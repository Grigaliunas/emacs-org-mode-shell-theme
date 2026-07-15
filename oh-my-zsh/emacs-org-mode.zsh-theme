# Emacs Org Mode — Oh My Zsh theme
# File: emacs-org-mode.zsh-theme
# Palette: Emacs Org Mode dark theme
# Install: copy to ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/themes/ and set ZSH_THEME="emacs-org-mode"

# Enable prompt substitutions and native prompt colors.
setopt prompt_subst

# truecolor / nearest-color support for %F{#RRGGBB} when available.
zmodload zsh/nearcolor 2>/dev/null || true
autoload -Uz colors && colors

autoload -Uz vcs_info
autoload -Uz add-zsh-hook

# Git status segment.
zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:*' use-simple true
zstyle ':vcs_info:git:*' check-for-changes true
zstyle ':vcs_info:git:*' unstagedstr '%F{#cc9393}*%f'
zstyle ':vcs_info:git:*' stagedstr '%F{#f0dfaf}+%f'
zstyle ':vcs_info:git:*' formats ' %F{#505050}[%f%F{#7f9f7f} %b%f%u%c%F{#505050}]%f'
zstyle ':vcs_info:git:*' actionformats ' %F{#505050}[%f%F{#7f9f7f} %b%f %F{#f0dfaf}| %a%f%u%c%F{#505050}]%f'

# Prompt state populated in precmd.
EMACS_ORG_MODE_STATUS='%F{#6fb86f}ok%f'
EMACS_ORG_MODE_JOBS=''

_emacs_org_mode_precmd() {
  local exit_code=$?
  vcs_info

  if [[ $exit_code -eq 0 ]]; then
    EMACS_ORG_MODE_STATUS='%F{#6fb86f}ok%f'
  else
    EMACS_ORG_MODE_STATUS="%F{#cc9393}${exit_code}%f"
  fi

  local job_count
  job_count=$(jobs -p 2>/dev/null | wc -l | tr -d ' ')
  if [[ -n "$job_count" && "$job_count" != "0" ]]; then
    EMACS_ORG_MODE_JOBS=" %F{#f0dfaf}jobs:${job_count}%f"
  else
    EMACS_ORG_MODE_JOBS=''
  fi
}

add-zsh-hook precmd _emacs_org_mode_precmd

# Left prompt: status user@host cwd git
# Prompt glyph: lambda, matching the editor/theme vibe.
PROMPT='${EMACS_ORG_MODE_STATUS} %F{#7cb8bb}%n%f%F{#505050}@%f%F{#8cd0d3}%m%f %F{#6fb86f}%~%f${vcs_info_msg_0_}${EMACS_ORG_MODE_JOBS}
%F{#f0dfaf}λ%f '

# Right prompt: time.
RPROMPT='%F{#505050}%D{%H:%M:%S}%f'

# Optional transient prompt for zsh users who enable prompt_cr/prompt_sp.
SPROMPT='%F{#f0dfaf}correct%f %F{#cc9393}%R%f %F{#505050}to%f %F{#6fb86f}%r%f %F{#505050}?%f [%F{#6fb86f}nyae%f] '
