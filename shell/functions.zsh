# Create a new directory and enter it
function mkd() {
  mkdir -p "$@" && cd "$_";
}

# Move up an arbitrary number of directories
function up {
  if [[ "$#" < 1 ]] ; then
    cd ..
  else
    CDSTR=""
    for i in {1..$1} ; do
      CDSTR="../$CDSTR"
    done
    cd $CDSTR
  fi
}

# Open files with the preferred visual editor, terminal editor, or nano.
function editor.open() {
  local editor="${VISUAL:-${EDITOR:-nano}}"
  local -a editor_command

  editor_command=(${(z)editor})
  command "${editor_command[@]}" "$@"
}

# Open these dotfiles in the preferred editor without needing to change directories first.
function df.open() {
  editor.open "$HOME/.dotfiles"
}

# Update these dotfiles without needing to change directories first.
function df.update() {
  local dotfiles_root="$HOME/.dotfiles"

  git -C "$dotfiles_root" pull --rebase --autostash || return
  "$dotfiles_root/scripts/install-dotfiles.sh" || return
  if command -v brew >/dev/null 2>&1; then
    zsh "$dotfiles_root/scripts/brew.sh"
  fi
}

# Report how much of the managed dotfiles setup is configured.
function df.doctor() {
  local dotfiles_root="$HOME/.dotfiles"
  local fix=false
  local configured=0 total=0 i actual
  local -a destinations sources git_keys git_values

  case "${1:-}" in
    '') ;;
    --fix) fix=true ;;
    -h|--help)
      echo "Usage: df.doctor [--fix]"
      return 0
      ;;
    *)
      echo "Usage: df.doctor [--fix]" >&2
      return 2
      ;;
  esac

  (( $# <= 1 )) || {
    echo "Usage: df.doctor [--fix]" >&2
    return 2
  }

  if $fix; then
    "$dotfiles_root/scripts/install-dotfiles.sh" || return
    echo ''
  fi

  destinations=(
    "$HOME/.zshrc"
    "$HOME/.gitignore-global"
    "$HOME/.gitattributes-global"
    "$HOME/AGENTS.md"
    "$HOME/.config/starship.toml"
    "$HOME/.config/ghostty/config.ghostty"
    "$HOME/.config/zed/settings.json"
    "$HOME/.config/zed/keymap.json"
  )
  sources=(
    "$dotfiles_root/.zshrc"
    "$dotfiles_root/.gitignore-global"
    "$dotfiles_root/.gitattributes-global"
    "$dotfiles_root/llm/AGENTS.md"
    "$dotfiles_root/config/starship.toml"
    "$dotfiles_root/config/ghostty/config.ghostty"
    "$dotfiles_root/config/zed/settings.json"
    "$dotfiles_root/config/zed/keymap.json"
  )
  git_keys=(user.name user.email init.defaultBranch core.autocrlf core.excludesfile core.attributesfile)
  git_values=(present present main input "$HOME/.gitignore-global" "$HOME/.gitattributes-global")

  for (( i = 1; i <= ${#destinations}; i++ )); do
    (( ++total ))
    if [[ -L "${destinations[$i]}" && "$(readlink "${destinations[$i]}")" == "${sources[$i]}" ]]; then
      echo "✓ ${destinations[$i]#$HOME/}"
      (( ++configured ))
    else
      echo "✗ ${destinations[$i]#$HOME/}"
    fi
  done

  for (( i = 1; i <= ${#git_keys}; i++ )); do
    (( ++total ))
    actual="$(git config --global --get "${git_keys[$i]}" 2>/dev/null || true)"
    if { [[ "${git_values[$i]}" == present ]] && [[ -n "$actual" ]] } || [[ "$actual" == "${git_values[$i]}" ]]; then
      echo "✓ git ${git_keys[$i]}"
      (( ++configured ))
    else
      echo "✗ git ${git_keys[$i]}"
    fi
  done

  echo ''
  echo "$configured/$total configured ($(( configured * 100 / total ))%)."

  if (( configured < total )); then
    $fix || echo "Run df.doctor --fix to apply fixes."
    return 1
  fi
}

function git.fix() {
  local file
  local -a files

  while IFS= read -r -d $'\0' file; do
    files+=("$file")
  done < <(git diff --name-only -z --diff-filter=ACMRTUXB)

  if (( ${#files[@]} == 0 )); then
    echo "No changed files found."
    return 0
  fi

  editor.open "${files[@]}"
}

function git.amend_author() {
  local author="${1:-$(git config user.name) <$(git config user.email)>}"

  git commit --amend --author "$author" --no-edit
}

# Open every reviewable changed file from the current repo in the focused Zed workspace.
# Pass additional zsh globs to ignore them, e.g. git.review 'dist/**' '*.snap'.
function git.review() {
  local repo_root file pattern skip
  local -a files
  local -A seen

  repo_root="$(git rev-parse --show-toplevel 2>/dev/null)" || {
    echo "Not inside a Git repository."
    return 1
  }

  while IFS= read -r -d $'\0' file; do
    [[ -n "$file" ]] || continue

    # Dependency locks, build output, and generated artifacts are usually review noise.
    case "/$file/" in
      */dist/*|*/snap/*|*/snapshots/*|*/__snapshots__/*)
        continue
        ;;
    esac

    case "${file:t}" in
      *.lock|*.lockb|*.lock.hcl|package-lock.json|npm-shrinkwrap.json|pnpm-lock.yaml|Package.resolved|pubspec.lock|go.sum|*.min.js|*.min.css|*.map|*.tsbuildinfo|.DS_Store)
        continue
        ;;
    esac

    skip=false
    for pattern in "$@"; do
      if [[ "$file" == ${~pattern} ]]; then
        skip=true
        break
      fi
    done
    $skip && continue

    [[ -n "${seen[$file]:-}" ]] && continue
    seen[$file]=1
    files+=("$repo_root/$file")
  done < <(
    git -C "$repo_root" diff --name-only -z --diff-filter=ACMRTUXB
    git -C "$repo_root" diff --cached --name-only -z --diff-filter=ACMRTUXB
    git -C "$repo_root" ls-files --others --exclude-standard -z
  )

  if (( ${#files[@]} == 0 )); then
    echo "No reviewable changed files found."
    return 0
  fi

  if ! command -v zed >/dev/null 2>&1; then
    echo "Zed's CLI is not available on PATH."
    return 1
  fi

  command zed --add "${files[@]}"
}

# Determine size of a file or total size of a directory
function fs() {
  if du -b /dev/null > /dev/null 2>&1; then
    local arg=-sbh;
  else
    local arg=-sh;
  fi
  if [[ -n "$@" ]]; then
    du $arg -- "$@";
  else
    du $arg .[^.]* *;
  fi;
}

# Create a .tar.gz archive, using `zopfli`, `pigz` or `gzip` for compression
function targz() {
  local tmpFile="${@%/}.tar";
  tar -cvf "${tmpFile}" --exclude=".DS_Store" "${@}" || return 1;

  size=$(
    stat -f"%z" "${tmpFile}" 2> /dev/null; # OS X `stat`
    stat -c"%s" "${tmpFile}" 2> /dev/null # GNU `stat`
  );

  local cmd="";
  if (( size < 52428800 )) && hash zopfli 2> /dev/null; then
    # the .tar file is smaller than 50 MB and Zopfli is available; use it
    cmd="zopfli";
  else
    if hash pigz 2> /dev/null; then
      cmd="pigz";
    else
      cmd="gzip";
    fi;
  fi;

  echo "Compressing .tar using \`${cmd}\`…";
  "${cmd}" -v "${tmpFile}" || return 1;
  [ -f "${tmpFile}" ] && rm "${tmpFile}";
  echo "${tmpFile}.gz created successfully.";
}

# Show all the names (CNs and SANs) listed in the SSL certificate for a given domain
function getcertnames() {
  if [ -z "${1}" ]; then
    echo "ERROR: No domain specified.";
    return 1;
  fi;

  local domain="${1}";
  echo "Testing ${domain}…";
  echo ""; # newline

  local tmp=$(echo -e "GET / HTTP/1.0\nEOT" \
    | openssl s_client -connect "${domain}:443" -servername "${domain}" 2>&1);

  if [[ "${tmp}" = *"-----BEGIN CERTIFICATE-----"* ]]; then
    local certText=$(echo "${tmp}" \
      | openssl x509 -text -certopt "no_aux, no_header, no_issuer, no_pubkey, \
      no_serial, no_sigdump, no_signame, no_validity, no_version");
    echo "Common Name:";
    echo ""; # newline
    echo "${certText}" | grep "Subject:" | sed -e "s/^.*CN=//" | sed -e "s/\/emailAddress=.*//";
    echo ""; # newline
    echo "Subject Alternative Name(s):";
    echo ""; # newline
    echo "${certText}" | grep -A 1 "Subject Alternative Name:" \
      | sed -e "2s/DNS://g" -e "s/ //g" | tr "," "\n" | tail -n +2;
    return 0;
  else
    echo "ERROR: Certificate not found.";
    return 1;
  fi;
}
