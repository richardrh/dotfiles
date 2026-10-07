# Dotfiles

Personal configuration managed by [chezmoi](https://www.chezmoi.io/).

The Fedora image initializes this repository automatically on first login with
BlueBuild's `chezmoi` module. To install it manually:

```bash
chezmoi init --apply git@github.com:richardrh/dotfiles.git
```

Chezmoi applies the shell, Git, Doom Emacs, Ghostty, Helix, and mise
configuration. The `run_onchange_after_10-install-mise-tools.sh.tmpl` script
installs mise-managed tools, and `run_onchange_after_20-install-doom.sh.tmpl`
initializes Doom after the configuration files are applied.
Secrets and machine state do not belong in this repository.

Preview and apply later changes with:

```bash
chezmoi diff
chezmoi apply
```

To get changes from this repository onto the Fedora Sway Atomic machine,
commit and push them to `main`. On Fedora, fetch the new source without
applying it, preview the changes, and apply:

```bash
chezmoi update --apply=false
chezmoi diff
chezmoi apply
```

`chezmoi apply` alone does not fetch remote changes. For a one-step pull and
apply, run `chezmoi update`. The image's chezmoi user services also update
dotfiles automatically.

Image-level changes (packages, system Sway defaults, Rofi theme) live in
[`fedora-build`](https://github.com/richardrh/fedora-wayblue), not here.
Publish that image and run `sudo rpm-ostree upgrade`, then reboot on Fedora.
The image README documents the rebase path and the Super+D launcher shortcut
for the Kinesis Advantage2.
