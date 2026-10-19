# Dotfiles

Personal configuration managed by [chezmoi](https://www.chezmoi.io/).

The Fedora image initializes this repository automatically on first login with
BlueBuild's `chezmoi` module. To install it manually:

```bash
chezmoi init --apply git@github.com:richardrh/dotfiles.git
```

Chezmoi applies the shell, Git, Doom Emacs, Ghostty, Helix, and mise
configuration. The `run_once_after_03-install-nerd-font.sh.tmpl` script
ensures JetBrainsMono Nerd Font is available. The
`run_onchange_after_05-install-doom.sh.tmpl` script initializes Doom, and
`run_onchange_after_10-install-mise-tools.sh.tmpl` installs all mise-managed
tools, including Oh My Pi, Herdr, and Hugo, after the configuration files are applied.
On the Fedora image, the first-login `workstation-setup` terminal configures
SSH, interactively runs `gh auth login` and `glab auth login`, registers the
public key with both services, and runs `sudo tailscale up`. It creates
`~/.ssh/id_ed25519` only when requested; the SSH key's passphrase is entered
interactively and the private key stays on the machine. Run `workstation-setup`
again later to repeat any skipped step.

The shell defaults `DOCKER_HOST` to the rootless Podman socket and derives
`DOCKER_SOCK` from Unix endpoints so k3d can mount the host socket. An existing
`DOCKER_HOST` override is preserved.

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

### Sway browser headers

`dot_config/sway/config.d/99-browser-layout.conf` installs a user override
loaded by Fedora Sway Atomic's default configuration. New Chromium, Chrome,
Firefox, Brave, and Edge windows use horizontal split tiling with a 2-pixel
border instead of a Sway titlebar, matching both Wayland app IDs and XWayland
classes.

Apply the dotfiles and reload Sway to enable the rules:

```bash
chezmoi apply
swaymsg reload
```

For an already-open browser, focus it and press **Super+E** to return to split
tiling, or run `swaymsg 'layout splith; border pixel 2'` with that window focused.
Pixel borders alone do not hide a tabbed/stacked container's header.

Opening a matching browser changes its containing group's layout, including
any sibling windows. These are opening rules, not a ban on tabbed/stacked
layouts: choosing **Super+W** or **Super+S** afterward brings Sway's header back.
Browser tabs and the desktop status bar are unchanged.

### Sway touchpad settings

On Fedora Sway Atomic, use the graphical Sway Input Configurator instead of
layering a system package with `rpm-ostree`:

```bash
flatpak install flathub io.github.Sunderland93.sway-input-config
flatpak run io.github.Sunderland93.sway-input-config
```

It configures Sway's libinput settings for touchpad tapping, natural
scrolling, disable-while-typing, click method, pointer acceleration, and
related options. This is a user-level Flatpak and does not require an
`rpm-ostree` deployment or reboot. Reload Sway after saving if necessary:

```bash
swaymsg reload
```

The GUI is optional; hand-written Sway input settings belong in the user's
Sway configuration rather than in the immutable image.

Image-level changes (packages, system Sway defaults, Rofi theme) live in
[`fedora-build`](https://github.com/richardrh/fedora-wayblue), not here.
Publish that image and run `sudo rpm-ostree upgrade`, then reboot on Fedora.
The image README documents the rebase path and the Super+D launcher shortcut
for the Kinesis Advantage2.
