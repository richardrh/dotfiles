# Dotfiles

Personal configuration managed by [chezmoi](https://www.chezmoi.io/).

The Fedora image initializes this repository automatically on first login with
BlueBuild's `chezmoi` module. To install it manually:

```bash
chezmoi init --apply git@github.com:richardrh/dotfiles.git
```

Chezmoi applies the shell, Git, Doom Emacs, Ghostty, Helix, and mise
configuration. It then installs mise-managed tools and bootstraps Doom Emacs.
Secrets and machine state do not belong in this repository.

Preview and apply later changes with:

```bash
chezmoi diff
chezmoi apply
```
