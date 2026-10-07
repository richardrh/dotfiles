# Dotfiles

Personal configuration managed by [chezmoi](https://www.chezmoi.io/).

The Fedora image initializes this repository automatically on first login with
BlueBuild's `chezmoi` module. To install it manually:

```bash
chezmoi init --apply git@github.com:richardrh/dotfiles.git
```

Chezmoi applies the shell, Git, Doom Emacs, Ghostty, Helix, and mise
configuration. The `run_onchange_after_05-install-doom.sh.tmpl` script
initializes Doom, and `run_onchange_after_10-install-mise-tools.sh.tmpl`
installs mise-managed tools after the configuration files are applied.
The first apply also creates `~/.ssh/id_ed25519` if it does not exist and
configures GitHub/GitLab SSH host defaults. If `gh` or `glab` is already
authenticated, the public key is registered with that service; otherwise,
authenticate with `gh auth login` or `glab auth login` and add
`~/.ssh/id_ed25519.pub`. The private key stays on the machine.

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
