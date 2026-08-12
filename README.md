# Leon's Linux Rice

I use [gentoo](https://www.gentoo.org/) + [Hyprland](https://hypr.land/) (installed from hyproverlay) with kitty as the terminal, waybar as the bar, and wmenu standing in for dmenu. The dotfiles are managed with [yadm](https://yadm.io/), so the same repo covers the desktop, the laptop, WSL and headless servers. This repo is still heavily inspired by Luke Smith's [voidrice](https://github.com/LukeSmithxyz/voidrice) and keeps many of his scripts, now ported to Wayland tools.

The old dwm/st forks are retired and their repos archived. Everything they did (master layout, gaps, scratchpads, the statusbar signal numbers) is reproduced in the Hyprland config and the `hypr-layout` / `hypr-gaps` / `barsig` helper scripts.

See [deployLinux](https://github.com/0n3W4y7ick3t/deployLinux) for the system layer: gentoo install, kernel config and the packages these dotfiles expect.

## Deploying on a new machine

```sh
yadm clone <this repo>
yadm config local.class desktop   # or x13 / wsl / server
yadm alt                     # materialize the ##class.* alternates
yadm bootstrap               # zsh plugins, shortcut files, XDG dirs
```

The class picks which `NAME##class.X` alternate files become active, for example `.config/hypr/machine.conf##class.desktop` or `.wezterm.lua##class.wsl`. Servers can additionally apply `.config/yadm/sparse-checkout.server` to keep GUI trees out of the checkout entirely; instructions are at the top of that file.

Commits happen only in the development clone at `~/akira/rice`, never through yadm on a deployed machine. yadm is a consumer: pull, `yadm alt`, done.

## Machine notes

- **desktop**: two 4K displays are told apart by EDID description. On first boot run `hyprctl monitors` and replace the `CHANGE_ME_27INCH` placeholder in `.config/hypr/machine.conf##class.desktop` with the 27" panel's description string.
- **x13**: kanshi manages docking profiles; fill in the external output in `.config/kanshi/config` when you first dock.
- **wsl**: only the shell environment plus `.wezterm.lua` matter; no compositor is started.
- **server**: bootstrap skips all GUI setup, and the sparse-checkout profile above trims the tree.

Machine-local shell tweaks go in `~/.zshrc.local`, which `.zshrc` sources if present and which stays untracked. The work git identity in `~/.gitconfig-companyA` is intentionally untracked too; `.gitconfig` includes it conditionally.

## Keybindings

[KEYBINDINGS.md](KEYBINDINGS.md) is generated from the Hyprland config by `.scripts/hypr-keybindings-doc`; don't edit it by hand. Run the script to regenerate it, or add `--pdf` for a printable `KEYBINDINGS.pdf` (needs [typst](https://typst.app/), stays untracked). Saving `hyprland.conf` or a `machine.conf` in neovim regenerates both automatically, and CI fails a push that changes the hypr config without refreshing the doc.

## Hyprland config layout

`.config/hypr/hyprland.conf` holds everything shared: the master layout, Tokyo Night colors, and all keybinds carried over one-to-one from dwm. It sources `~/.config/hypr/machine.conf`, which is a per-class alternate carrying monitors, env vars and input quirks. The config is plain hyprlang; when Hyprland finishes the move to Lua configs this will be converted with hyprconf2lua.

The Tokyo Night palette that used to live in xresources is now written directly into the kitty, waybar and hyprlock configs. pywal templates under `.config/wal/` are kept in case I return to generated colorschemes.
