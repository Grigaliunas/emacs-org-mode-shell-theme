#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'EOF'
Emacs Org Mode shell prompt installer

Usage:
  ./install.sh --zsh [--apply]
  ./install.sh --bash [--apply]
  ./install.sh --both [--apply]

Flags:
  --zsh    Copy the Oh My Zsh theme into the custom themes directory.
  --bash   Copy the Bash prompt into ~/.config/emacs-org-mode/.
  --both   Install both files.
  --apply  Also modify ~/.zshrc and/or ~/.bashrc with backups.

Without --apply, this script only copies files and prints the line to add manually.
EOF
}

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
INSTALL_ZSH=0
INSTALL_BASH=0
APPLY=0

if [[ $# -eq 0 ]]; then
  usage
  exit 0
fi

while [[ $# -gt 0 ]]; do
  case "$1" in
    --zsh) INSTALL_ZSH=1 ;;
    --bash) INSTALL_BASH=1 ;;
    --both) INSTALL_ZSH=1; INSTALL_BASH=1 ;;
    --apply) APPLY=1 ;;
    -h|--help) usage; exit 0 ;;
    *) echo "Unknown option: $1" >&2; usage; exit 1 ;;
  esac
  shift
done

if [[ "$INSTALL_ZSH" == "1" ]]; then
  ZSH_THEME_DIR="${ZSH_CUSTOM:-${ZSH:-$HOME/.oh-my-zsh}/custom}/themes"
  mkdir -p "$ZSH_THEME_DIR"
  cp "$SCRIPT_DIR/oh-my-zsh/emacs-org-mode.zsh-theme" "$ZSH_THEME_DIR/emacs-org-mode.zsh-theme"
  echo "Installed Oh My Zsh theme: $ZSH_THEME_DIR/emacs-org-mode.zsh-theme"

  if [[ "$APPLY" == "1" ]]; then
    ZSHRC="$HOME/.zshrc"
    touch "$ZSHRC"
    cp "$ZSHRC" "$ZSHRC.bak.$(date +%Y%m%d%H%M%S)"
    if grep -q '^ZSH_THEME=' "$ZSHRC"; then
      sed -i.tmp 's/^ZSH_THEME=.*/ZSH_THEME="emacs-org-mode"/' "$ZSHRC" && rm -f "$ZSHRC.tmp"
    else
      printf '\nZSH_THEME="emacs-org-mode"\n' >> "$ZSHRC"
    fi
    echo "Updated $ZSHRC. Restart zsh or run: exec zsh"
  else
    echo 'Manual step: set ZSH_THEME="emacs-org-mode" in ~/.zshrc and restart zsh.'
  fi
fi

if [[ "$INSTALL_BASH" == "1" ]]; then
  BASH_DIR="$HOME/.config/emacs-org-mode"
  mkdir -p "$BASH_DIR"
  cp "$SCRIPT_DIR/bash/emacs-org-mode.bash" "$BASH_DIR/emacs-org-mode.bash"
  cp "$SCRIPT_DIR/extras/emacs-org-mode.dircolors" "$BASH_DIR/emacs-org-mode.dircolors"
  echo "Installed Bash prompt: $BASH_DIR/emacs-org-mode.bash"

  SOURCE_LINE='source "$HOME/.config/emacs-org-mode/emacs-org-mode.bash"'
  if [[ "$APPLY" == "1" ]]; then
    BASHRC="$HOME/.bashrc"
    touch "$BASHRC"
    cp "$BASHRC" "$BASHRC.bak.$(date +%Y%m%d%H%M%S)"
    if ! grep -Fq 'emacs-org-mode.bash' "$BASHRC"; then
      printf '\n# Emacs Org Mode Bash prompt\n%s\n' "$SOURCE_LINE" >> "$BASHRC"
    fi
    echo "Updated $BASHRC. Reload with: source ~/.bashrc"
  else
    echo "Manual step: add this line to ~/.bashrc:"
    echo "  $SOURCE_LINE"
  fi
fi
