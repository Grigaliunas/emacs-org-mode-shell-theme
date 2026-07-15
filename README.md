# Emacs Org Mode Shell Theme — Oh My Zsh + Bash

This package contains an **Emacs Org Mode** shell prompt theme using the same palette as the rest of the theme pack.

It includes two variants:

- **Oh My Zsh theme**: `oh-my-zsh/emacs-org-mode.zsh-theme`
- **Bash prompt theme**: `bash/emacs-org-mode.bash`

Oh My Zsh is for **zsh**, not Bash. The Bash prompt is included separately for users who want the same look in `.bashrc`.

## Palette

| Role | Hex |
|---|---|
| Background 0 | `#1c1c1c` |
| Background 1 | `#282828` |
| Background 2 | `#2a2a2a` |
| Background 3 | `#2f2f2f` |
| Status / current line | `#343434` |
| Header | `#383838` |
| Dim | `#505050` |
| Border | `#696969` |
| Foreground | `#d0d0d0` |
| Muted foreground | `#c0c0c0` |
| Bright foreground | `#dcdccc` |
| Cyan | `#7cb8bb` |
| Bright cyan | `#8cd0d3` |
| Link teal | `#93e0e3` |
| Green | `#6fb86f` |
| Comment green | `#7f9f7f` |
| Yellow | `#f0dfaf` |
| Red/string | `#cc9393` |

## Oh My Zsh install

### Automatic copy only

```bash
./install.sh --zsh
```

Then edit `~/.zshrc`:

```zsh
ZSH_THEME="emacs-org-mode"
```

Restart zsh:

```bash
exec zsh
```

### Automatic copy + update `.zshrc`

```bash
./install.sh --zsh --apply
exec zsh
```

The installer creates a timestamped backup of `~/.zshrc` before editing it.

### Manual install

```bash
mkdir -p "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes"
cp oh-my-zsh/emacs-org-mode.zsh-theme "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/"
```

Set this in `~/.zshrc`:

```zsh
ZSH_THEME="emacs-org-mode"
```

## Bash install

### Automatic copy only

```bash
./install.sh --bash
```

Then add this to `~/.bashrc`:

```bash
source "$HOME/.config/emacs-org-mode/emacs-org-mode.bash"
```

Reload Bash:

```bash
source ~/.bashrc
```

### Automatic copy + update `.bashrc`

```bash
./install.sh --bash --apply
source ~/.bashrc
```

The installer creates a timestamped backup of `~/.bashrc` before editing it.

## Prompt layout

The prompt shows:

```text
status user@host current-directory [git-branch*+]
λ
```

Status values:

- `ok` in green for exit code `0`
- numeric exit code in red for non-zero commands

Git markers:

- `*` = unstaged changes
- `+` = staged changes

## Truecolor note

The prompts use 24-bit ANSI colors / zsh `%F{#RRGGBB}` color notation. For best results, use a terminal profile that supports truecolor, such as iTerm2, Ghostty, Kitty, Alacritty, WezTerm, or modern GNOME Terminal.

## Files

```text
emacs-org-mode-shell-theme/
  oh-my-zsh/
    emacs-org-mode.zsh-theme
  bash/
    emacs-org-mode.bash
  extras/
    emacs-org-mode.dircolors
  install.sh
  palette.json
  README.md
  LICENSE
```

## License

[MIT](LICENSE)
