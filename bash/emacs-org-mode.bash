# Emacs Org Mode — Bash prompt theme
# File: emacs-org-mode.bash
# Source from ~/.bashrc:
#   source ~/.config/emacs-org-mode/emacs-org-mode.bash

# Avoid double-loading.
if [[ -n "${__EMACS_ORG_MODE_BASH_LOADED:-}" ]]; then
  return 0 2>/dev/null || exit 0
fi
__EMACS_ORG_MODE_BASH_LOADED=1

# Hex -> truecolor ANSI escape wrapped for Bash prompt length accounting.
__eom_fg() {
  local hex="${1#\#}"
  printf '\[\e[38;2;%d;%d;%dm\]' "0x${hex:0:2}" "0x${hex:2:2}" "0x${hex:4:2}"
}

__eom_bg() {
  local hex="${1#\#}"
  printf '\[\e[48;2;%d;%d;%dm\]' "0x${hex:0:2}" "0x${hex:2:2}" "0x${hex:4:2}"
}

__eom_reset='\[\e[0m\]'
__eom_bold='\[\e[1m\]'
__eom_dim='\[\e[2m\]'

__eom_git_segment() {
  command -v git >/dev/null 2>&1 || return 0
  git rev-parse --is-inside-work-tree >/dev/null 2>&1 || return 0

  local branch dirty staged
  branch=$(git symbolic-ref --quiet --short HEAD 2>/dev/null || git rev-parse --short HEAD 2>/dev/null) || return 0
  git diff --quiet --ignore-submodules -- 2>/dev/null || dirty='*'
  git diff --cached --quiet --ignore-submodules -- 2>/dev/null || staged='+'

  local dim comment red yellow reset
  dim="$(__eom_fg '#505050')"
  comment="$(__eom_fg '#7f9f7f')"
  red="$(__eom_fg '#cc9393')"
  yellow="$(__eom_fg '#f0dfaf')"
  reset="$__eom_reset"

  printf ' %s[%s%s %s%s' "$dim" "$reset" "$comment" "$branch" "$reset"
  [[ -n "$dirty" ]] && printf '%s*%s' "$red" "$reset"
  [[ -n "$staged" ]] && printf '%s+%s' "$yellow" "$reset"
  printf '%s]%s' "$dim" "$reset"
}

__eom_jobs_segment() {
  local count
  count=$(jobs -p 2>/dev/null | wc -l | tr -d ' ')
  [[ -n "$count" && "$count" != "0" ]] || return 0
  printf ' %sjobs:%s%s' "$(__eom_fg '#f0dfaf')" "$count" "$__eom_reset"
}

__eom_set_ps1() {
  local exit_code="$1"

  local bg0 fg dim cyan bright_cyan green yellow red reset
  bg0="$(__eom_fg '#1c1c1c')"
  fg="$(__eom_fg '#d0d0d0')"
  dim="$(__eom_fg '#505050')"
  cyan="$(__eom_fg '#7cb8bb')"
  bright_cyan="$(__eom_fg '#8cd0d3')"
  green="$(__eom_fg '#6fb86f')"
  yellow="$(__eom_fg '#f0dfaf')"
  red="$(__eom_fg '#cc9393')"
  reset="$__eom_reset"

  local status
  if [[ "$exit_code" == "0" ]]; then
    status="${green}ok${reset}"
  else
    status="${red}${exit_code}${reset}"
  fi

  local git jobs
  git="$(__eom_git_segment)"
  jobs="$(__eom_jobs_segment)"

  PS1="${status} ${cyan}\u${dim}@${bright_cyan}\h${reset} ${green}\w${reset}${git}${jobs}\n${yellow}λ${reset} "
}

# Preserve an existing PROMPT_COMMAND if one was set before this theme.
if [[ -n "${PROMPT_COMMAND:-}" && "${PROMPT_COMMAND}" != *__eom_prompt_command* ]]; then
  __EOM_OLD_PROMPT_COMMAND="$PROMPT_COMMAND"
else
  __EOM_OLD_PROMPT_COMMAND=""
fi

__eom_prompt_command() {
  local exit_code=$?
  if [[ -n "${__EOM_OLD_PROMPT_COMMAND:-}" ]]; then
    eval "$__EOM_OLD_PROMPT_COMMAND"
  fi
  __eom_set_ps1 "$exit_code"
}

PROMPT_COMMAND=__eom_prompt_command

# Reasonable defaults for ls colors on macOS/BSD and GNU coreutils.
export CLICOLOR=1
export LSCOLORS="ExGxBxDxCxEgEdxbxgxcxd"
if command -v dircolors >/dev/null 2>&1 && [[ -f "$HOME/.config/emacs-org-mode/emacs-org-mode.dircolors" ]]; then
  eval "$(dircolors -b "$HOME/.config/emacs-org-mode/emacs-org-mode.dircolors")"
fi
