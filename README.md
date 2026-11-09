# ojuny-desktop

Ojuny Desktop packages MangoWM and Dux Modular Shell for NixOS. The `desktop.ojuny.*` options generate both configurations from one source, and the repository exports a NixOS module, a Home Manager module, and a nested session runner.

Status: untested. No release tag exists. Applies to commit `34462aa`. The modules and the nested runner are described from the code; no end-to-end install is recorded as of 2026-11-03.

## Requirements

- Nix with flakes enabled.
- NixOS with the module, or Home Manager on an existing system.
- A Wayland session. MangoWM is the compositor, so an X11 session does not work.
- Dux Modular Shell needs `quickshell` 0.3.0 or newer. The flake supplies it, and the wrapper checks the version at build time.
- Stylix is optional. Import the Stylix module before setting `desktop.ojuny.stylix.enable`.
- Disk and memory use are not measured.

## Install

Add the flake input and the NixOS module to the system flake:

```nix
{
  inputs.ojuny-desktop.url = "github:ojuny-project/ojuny-desktop";

  outputs = { nixpkgs, ojuny-desktop, ... }: {
    nixosConfigurations.myhost = nixpkgs.lib.nixosSystem {
      modules = [
        ojuny-desktop.nixosModules.default
        {
          desktop.ojuny.enable = true;
        }
      ];
    };
  };
}
```

Replace `myhost` with the configuration name, then rebuild:

```sh
sudo nixos-rebuild switch --flake .#myhost
```

The switch writes the generated session and starts the user services at activation. This path is untested; no run is recorded.

## Try it

Run the nested session without installing anything:

```sh
nix run github:ojuny-project/ojuny-desktop
```

The runner uses temporary `XDG_CONFIG_HOME`, `XDG_STATE_HOME`, `XDG_CACHE_HOME`, and `XDG_DATA_HOME` directories. It does not touch the installed Dux Modular Shell configuration, and the directories disappear when the session exits.

## Configure

The Home Manager module takes the same options. It installs the session, the file manager and its portal, wallpaper handling, the Ghostty wrapper, and a session entry for display managers. Mango binds, Dux Modular Shell bar and plugin options, dankMenu, and Stylix colors are configuration options. A complete home configuration:

```nix
{
  outputs = { nixpkgs, home-manager, ojuny-desktop, ... }: {
    homeConfigurations.user = home-manager.lib.homeManagerConfiguration {
      pkgs = nixpkgs.legacyPackages.x86_64-linux;
      modules = [
        ojuny-desktop.homeManagerModules.default
        {
          home.username = "user";
          home.homeDirectory = "/home/user";
          home.stateVersion = "26.05";
          desktop.ojuny.enable = true;
          desktop.ojuny.defaultApps = with pkgs; [ ghostty firefox ];
          desktop.ojuny.fileManager.package = "dux-files";
          desktop.ojuny.dankMenu.enable = true;
          desktop.ojuny.dankMenu.menu."learn.keybinds" = {
            icon = "keyboard";
            label = "Keybinds";
            action = "dms ipc call keybinds open binds";
          };
        }
      ];
    };
  };
}
```

Change `user`, `/home/user`, and `stateVersion` to match the account. Every option and its default is in [options.md](options.md). [DESIGN.md](DESIGN.md) explains how the files are generated and linked.

The default Super+H bind runs `ojuny-snap`, which floats or unfloats the focused window and snaps it to the pointer's screen zone. The zone width, inner gap and screen insets are `desktop.ojuny.mango.snap.*`; [options.md](options.md) lists them and [DESIGN.md](DESIGN.md) describes the nine-zone behavior. The generated config file is re-read on every press, so a rebuild applies new values without restarting the session.

## Limits

- Generated Dux Modular Shell files are symlinks into the store inside a writable `~/.config/dms`. The session file is a writable copy in `~/.local/state/dms`, replaced when the generated session changes, so wallpaper cycling survives. See [DESIGN.md](DESIGN.md).
- On NixOS, activation repoints the links. Restart Dux Modular Shell after a switch to reload the shell and MangoWM.
- The Home Manager session entry lives at `$profile/share/wayland-sessions/ojuny.desktop`. GDM and LightDM do not scan the user profile, so symlink it into `/usr/share/wayland-sessions` or configure the display manager.
- `desktop.ojuny.dms.*` was renamed to `desktop.ojuny.dux.*`. The old path still evaluates with a warning.
- Terminal binds use `ojuny-ghostty`, which loads the generated config before the user's Ghostty config. The `ghostty` binary is not replaced.
- Several plugins are enabled with `mkDefault` because the default bar, control center, and binds use them. Override `src` to pin one, or set `enable = false` to remove it. See [options.md](options.md).

## Documentation

- [options.md](options.md): what each option does and its default.
- [options.generated.md](options.generated.md): generated reference for every public option and its declared default.
- [DESIGN.md](DESIGN.md): how configs are generated, linked, and wrapped.
- [MangoWM](https://github.com/mangowm/mango): compositor configuration and commands.
- [Dux Modular Shell](https://github.com/duxlabs-dev/dux-shell): shell settings and plugin behavior.

## Contributing

Open issues at <https://github.com/ojuny-project/ojuny-desktop/issues>. A patch should include the command that failed, its output, the NixOS or Home Manager version, and the commit it applies to. A behavior change updates `options.md` and `DESIGN.md` in the same patch.

## License

GPL-3.0. Built on [MangoWM](https://github.com/mangowm/mango) and [Dux Modular Shell](https://github.com/duxlabs-dev/dux-shell), with optional [Stylix](https://github.com/nix-community/stylix) integration.

