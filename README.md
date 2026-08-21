# Leon's Linux Rice

I use [gentoo](https://www.gentoo.org/) + [Hyprland](https://hypr.land/) (installed from hyproverlay) with kitty as the terminal, waybar as the bar, and wmenu in place of dmenu. The dotfiles are managed with [yadm](https://yadm.io/), so the same repo covers the desktop, the laptop, WSL and headless servers. This repo is still heavily inspired by Luke Smith's [voidrice](https://github.com/LukeSmithxyz/voidrice) and keeps many of his scripts, now ported to Wayland tools.

The old dwm/st forks are retired and their repos archived. Everything they did (master layout, gaps, scratchpads, the statusbar signal numbers) is reproduced in the Hyprland config and the `hypr-layout` / `hypr-gaps` / `barsig` helper scripts.

See [deployLinux](https://github.com/0n3W4y7ick3t/deployLinux) for the system layer: gentoo install, kernel config and the packages these dotfiles expect. Operational notes for both repos live in the [wiki](https://github.com/0n3W4y7ick3t/rice/wiki).

## Deploying on a new machine

```sh
yadm clone <this repo>
yadm config local.class desktop   # or x13 / wsl / server
yadm alt                     # materialize the ##class.* alternates
yadm bootstrap               # zsh plugins, shortcut files, XDG dirs
```

The class picks which `NAME##class.X` alternate files become active, for example `.config/hypr/machine.lua##class.desktop`. Servers can additionally apply `.config/yadm/sparse-checkout.server` to keep GUI trees out of the checkout entirely; instructions are at the top of that file.

yadm on a deployed machine is also where commits happen: edit the real file in `$HOME`, then `yadm add` / `commit` / `push`. A plain clone elsewhere is a reference copy only. The other machines are consumers: pull, `yadm alt`, done.

## Machine notes

- **desktop**: two 4K displays are told apart by EDID description in `.config/hypr/machine.lua##class.desktop`; connector names are identical, so never match on those.
- **x13**: single internal panel; Hyprland's own monitor rules handle hotplug. When an external display arrives, add a rule matching its EDID description (`hyprctl monitors`) rather than the connector.
- **wsl**: only the shell environment matters; no compositor is started.
- **server**: bootstrap skips all GUI setup, and the sparse-checkout profile above trims the tree.

Machine-local shell tweaks go in `~/.zshrc.local`, which `.zshrc` sources if present and which stays untracked. Work git identity is untracked too; `.gitconfig` includes `~/.gitconfig-local` conditionally.

## Keybindings

[KEYBINDINGS.md](.local/share/KEYBINDINGS.md) is generated from the Hyprland config by `.scripts/hypr-keybindings-doc`; don't edit it by hand. Run the script to regenerate it, or add `--pdf` for a printable `.local/share/KEYBINDINGS.pdf` (needs [typst](https://typst.app/), stays untracked; `$mod+F1` opens it). Saving `hyprland.lua` or a `machine.lua` in neovim regenerates both automatically, and CI fails a push that changes the hypr config without refreshing the doc.

## Hyprland config layout

`.config/hypr/hyprland.lua` holds everything shared: the master layout, Tokyo Night colors, and all keybinds carried over one-to-one from dwm. It requires `machine.lua`, a per-class alternate carrying monitors, env vars and input quirks. The config has been Lua since 2026-08-21, migrated ahead of Hyprland 0.57 dropping hyprlang; the old `hyprland.conf` + `machine.conf##*` stay tracked as the 0.56 rollback until 0.57 is verified on every machine.

The Tokyo Night palette that used to live in xresources is now written directly into the kitty, waybar and hyprlock configs. pywal templates under `.config/wal/` are kept in case I return to generated colorschemes.
