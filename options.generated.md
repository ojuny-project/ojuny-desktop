<!-- Generated file. Do not edit by hand. -->
# Ojuny Desktop options reference (generated)

Generated from the option declarations in `lib/ojuny-options.nix` through
`lib.evalModules`. Internal options are omitted. Regenerate with
`python3 scripts/gen-options.py`; CI fails when this file is stale.

101 public options under `desktop.ojuny`.

## top level

- `desktop.ojuny.defaultApps` (`list of package`, default `[ ]`): Packages added to the desktop session PATH (terminal, browser, file manager, etc.) so default keybinds can launch them.
- `desktop.ojuny.enable` (`boolean`, default `false`): Whether to enable Ojuny Desktop (mangoWM + Dux Modular Shell).

## dankMenu

- `desktop.ojuny.dankMenu.enable` (`boolean`, default `false`): Whether to enable a Nix-managed dankMenu menu (the plugin itself is enabled by default).
- `desktop.ojuny.dankMenu.extraEntries` (`attribute set of (submodule)`, default `{ }`): Menu entries added by patches and non-GUI modules, keyed by dotted id and using the same row shape as `menu`. Entries are merged over `menu` with `lib.recursiveUpdate` when the menu JSON is generated, so a patch can add a section or a child of an existing section without editing the GUI-owned `menu` attrset. The settings editor only reads and writes `menu`, so a GUI save never removes an extra entry.
- `desktop.ojuny.dankMenu.extraEntries.<name>.action` (`null or string`, default `null`): Shell command run on select.
- `desktop.ojuny.dankMenu.extraEntries.<name>.aliases` (`list of string`, default `[ ]`): Search aliases.
- `desktop.ojuny.dankMenu.extraEntries.<name>.checked` (`null or string`, default `null`): Shell condition for the checked state.
- `desktop.ojuny.dankMenu.extraEntries.<name>.disabled` (`null or string`, default `null`): Shell condition that greys the row out.
- `desktop.ojuny.dankMenu.extraEntries.<name>.icon` (`string`, default `no default`): Material icon name.
- `desktop.ojuny.dankMenu.extraEntries.<name>.iconFont` (`null or string`, default `null`)
- `desktop.ojuny.dankMenu.extraEntries.<name>.label` (`string`, default `no default`): Row text.
- `desktop.ojuny.dankMenu.extraEntries.<name>.provider` (`null or string`, default `null`): Provider-backed submenu id (e.g. "apps").
- `desktop.ojuny.dankMenu.extraEntries.<name>.target` (`null or string`, default `null`): Link target opened when selected.
- `desktop.ojuny.dankMenu.extraEntries.<name>.title` (`null or string`, default `null`)
- `desktop.ojuny.dankMenu.extraEntries.<name>.when` (`null or string`, default `null`): Shell condition controlling visibility.
- `desktop.ojuny.dankMenu.menu` (`attribute set of (submodule)`, default `{ }`): dankMenu tree keyed by dotted id (e.g. "learn.keybinds"). A non-empty tree overrides the plugin's bundled menu through the menuPath setting. This is the tree the settings editor reads and writes; patches and modules add entries with `extraEntries` instead.
- `desktop.ojuny.dankMenu.menu.<name>.action` (`null or string`, default `null`): Shell command run on select.
- `desktop.ojuny.dankMenu.menu.<name>.aliases` (`list of string`, default `[ ]`): Search aliases.
- `desktop.ojuny.dankMenu.menu.<name>.checked` (`null or string`, default `null`): Shell condition for the checked state.
- `desktop.ojuny.dankMenu.menu.<name>.disabled` (`null or string`, default `null`): Shell condition that greys the row out.
- `desktop.ojuny.dankMenu.menu.<name>.icon` (`string`, default `no default`): Material icon name.
- `desktop.ojuny.dankMenu.menu.<name>.iconFont` (`null or string`, default `null`)
- `desktop.ojuny.dankMenu.menu.<name>.label` (`string`, default `no default`): Row text.
- `desktop.ojuny.dankMenu.menu.<name>.provider` (`null or string`, default `null`): Provider-backed submenu id (e.g. "apps").
- `desktop.ojuny.dankMenu.menu.<name>.target` (`null or string`, default `null`): Link target opened when selected.
- `desktop.ojuny.dankMenu.menu.<name>.title` (`null or string`, default `null`)
- `desktop.ojuny.dankMenu.menu.<name>.when` (`null or string`, default `null`): Shell condition controlling visibility.
- `desktop.ojuny.dankMenu.settings` (`TOML value`, default `{ }`): Additional dankMenu plugin settings merged into plugin_settings.json.

## dux

- `desktop.ojuny.dux.barConfigs` (`attribute set of (TOML value)`, default `{ default = { _order = 10; attachToScreenEdge = false; autoHide = false; autoHideDelay = 250; borderColor = "primary"; borderEnabled = false; borderOpacity = 1; borde…`): Bar configurations keyed by id. Each entry may set `_order` (int, default 1000) to control the generated array order.
- `desktop.ojuny.dux.barPreset` (`one of "caelestia", "default", "goth", "none", "sidebar-left", "sidebar-right", "simple-bar", "simple-island", "status", "taskbar", "custom"`, default `"default"`): Active bar preset. `custom` uses `barConfigs.custom`, so a downstream repo can override it.
- `desktop.ojuny.dux.clipboardSettings` (`TOML value`, default `{ autoClearDays = 1; clearAtStartup = true; disableHistory = false; disablePersist = false; disabled = false; maxEntrySize = 5242880; maxHistory = 25; }`): Dux Modular Shell clipboard settings (clsettings.json).
- `desktop.ojuny.dux.controlCenterWidgets` (`attribute set of (TOML value)`, default `{ battery = { _order = 20; col = 4; enabled = true; h = 1; row = 0; w = 1; }; bluetooth = { _order = 100; col = 3; enabled = true; h = 1; row = 2; …`): Control-center widgets keyed by id. Each entry may set `_order` (int, default 1000).
- `desktop.ojuny.dux.dashCards` (`attribute set of (TOML value)`, default `{ calendar = { _order = 40; col = 0; h = 3; row = 1; w = 3; }; clock = { _order = 10; col = 2; h = 1; row = 0; w = 1; }; media = { _order = 50; …`): Dashboard cards keyed by id. Each entry may set `_order` (int, default 1000).
- `desktop.ojuny.dux.dashOptions` (`TOML value`, default `{ calendar = { weekends = true; }; media = { playerStyle = "material"; }; weather = { widgets = { conditions = { _order = 10; city = false; col = 0;…`): Dashboard options. `weather.widgets` is an id-keyed attrset (with optional `_order`).
- `desktop.ojuny.dux.dashTabs` (`attribute set of (TOML value)`, default `{ media = { _order = 20; enabled = true; }; notifications = { _order = 60; enabled = true; }; overview = { _order = 10; enabled = false; }; wallpaper = { _ord…`): Dashboard tabs keyed by id. Each entry may set `_order` (int, default 1000).
- `desktop.ojuny.dux.dockConfigs` (`attribute set of (TOML value)`, default `{ dock = { _order = 10; autoHide = false; borderColor = "secondary"; borderEnabled = true; borderOpacity = 1; borderThickness = 1; bottomGap = 0; editOnRightClick = f…`): Dock configurations keyed by id. Each entry may set `_order` (int, default 1000). Nested `widgets` is itself an id-keyed attrset (with optional `_order`).
- `desktop.ojuny.dux.managePluginSettings` (`boolean`, default `true`): Whether to generate plugin_settings.json from dux.plugins.
- `desktop.ojuny.dux.plugins` (`attribute set of (submodule)`, default `{ }`): Dux Modular Shell plugins, keyed by plugin name.
- `desktop.ojuny.dux.plugins.<name>.config` (`TOML value`, default `{ }`): Extra configuration written to plugins/<dir>/config.json inside the plugin directory. Empty means no config.json is written.
- `desktop.ojuny.dux.plugins.<name>.dir` (`string`, default `""`): Directory name under plugins/ for this plugin's source. Empty means use the attribute key (the Dux Modular Shell plugin id). Set only when the plugin expects a different directory name.
- `desktop.ojuny.dux.plugins.<name>.enable` (`boolean`, default `false`): Whether to install and enable this plugin.
- `desktop.ojuny.dux.plugins.<name>.settings` (`TOML value`, default `{ }`): Plugin settings written to plugin_settings.json.
- `desktop.ojuny.dux.plugins.<name>.src` (`package or absolute path`, default `no default`): Source directory or package of the plugin.
- `desktop.ojuny.dux.session` (`TOML value`, default `{ }`): Dux Modular Shell session (session.json seeded into the XDG state directory at login). `wallpaperPathLight` and `wallpaperPathDark` set the shell wallpaper.
- `desktop.ojuny.dux.settings` (`TOML value`, default `{ animationDuration = 350; barElevationEnabled = false; builtInPluginSettings = { dms_clipboard_search = { trigger = "cb"; }; dms_power = { trigger = "pw"; }; dms…`): Dux Modular Shell settings (settings.json). Use the convenience options below for the collection keys (barConfigs, dockConfigs, controlCenterWidgets, dashCards, dashTabs, dashOptions); they override the same keys here.

## fileManager

- `desktop.ojuny.fileManager.customCommand` (`string`, default `"dfiles open"`): Command run by the file-manager keybind when `package = "custom"`.
- `desktop.ojuny.fileManager.customPackage` (`null or package`, default `null`): Package installed when `package = "custom"`.
- `desktop.ojuny.fileManager.enable` (`boolean`, default `true`): Whether to install and wire the selected file manager.
- `desktop.ojuny.fileManager.package` (`one of "dux-files", "nautilus", "custom"`, default `"dux-files"`): File manager to install. `custom` installs `customPackage` and uses `customCommand` without MIME or portal wiring.
- `desktop.ojuny.fileManager.portal` (`boolean`, default `true`): Register the Dux Files FileChooser portal backend when the selected package is dux-files.

## mango

- `desktop.ojuny.mango.axisbind` (`attribute set of attribute set of (submodule)`, default `{ default = { viewNext = { args = [ ]; description = "Scroll views right"; dispatcher = "viewtoright_have_client"; group = "Mouse"; keys = [ "DOWN" ];…`): Scroll-axis bindings, grouped by mode then by name.
- `desktop.ojuny.mango.axisbind.<name>.<name>.args` (`(list of string) or string`, default `[ ]`)
- `desktop.ojuny.mango.axisbind.<name>.<name>.description` (`string`, default `""`)
- `desktop.ojuny.mango.axisbind.<name>.<name>.dispatcher` (`string`, default `"spawn"`)
- `desktop.ojuny.mango.axisbind.<name>.<name>.group` (`string`, default `"Other"`): Cheatsheet group (the top-level filter category).
- `desktop.ojuny.mango.axisbind.<name>.<name>.keys` (`list of string`, default `[ ]`)
- `desktop.ojuny.mango.axisbind.<name>.<name>.modifier` (`list of string`, default `[ "SUPER" ]`)
- `desktop.ojuny.mango.axisbind.<name>.<name>.subcat` (`string`, default `""`): Cheatsheet category used to sort within the group. Empty omits it.
- `desktop.ojuny.mango.binds` (`attribute set of attribute set of (submodule)`, default `{ common = { browser = { args = "firefox --new-window"; description = "Open browser"; dispatcher = "spawn"; group = "Applications"; keys = [ "B" ]; …`): Keybindings, grouped by key mode then by name.
- `desktop.ojuny.mango.binds.<name>.<name>.args` (`(list of string) or string`, default `[ ]`)
- `desktop.ojuny.mango.binds.<name>.<name>.description` (`string`, default `""`)
- `desktop.ojuny.mango.binds.<name>.<name>.dispatcher` (`string`, default `"spawn"`)
- `desktop.ojuny.mango.binds.<name>.<name>.group` (`string`, default `"Other"`): Cheatsheet group (the top-level filter category).
- `desktop.ojuny.mango.binds.<name>.<name>.keys` (`list of string`, default `[ ]`)
- `desktop.ojuny.mango.binds.<name>.<name>.modifier` (`list of string`, default `[ "SUPER" ]`)
- `desktop.ojuny.mango.binds.<name>.<name>.subcat` (`string`, default `""`): Cheatsheet category used to sort within the group. Empty omits it.
- `desktop.ojuny.mango.env` (`TOML value`, default `{ MOZ_ENABLE_WAYLAND = "1"; NIXOS_OZONE_WL = "1"; OZONE_PLATFORM = "wayland"; QT_QPA_PLATFORM = "wayland;xcb"; WLR_RENDERER_ALLOW_SOFTWARE = "1"; XDG_CURRENT_DESKTOP = "wlroots"; XDG_SES…`): Mango [env] variables.
- `desktop.ojuny.mango.exec` (`list of string`, default `[ ]`): Commands run on every config reload.
- `desktop.ojuny.mango.execOnce` (`list of string`, default `[ "dms run" "wl-clip-persist --clipboard both" "wl-paste --type text --watch cliphist store" "wl-paste --type image --watch cliphist store" "ojuny-ghostty" "ydotoold" ]`): Commands run once at startup.
- `desktop.ojuny.mango.gesturebind` (`attribute set of attribute set of (submodule)`, default `{ }`): Trackpad gesture bindings, grouped by mode then by name.
- `desktop.ojuny.mango.gesturebind.<name>.<name>.args` (`(list of string) or string`, default `[ ]`)
- `desktop.ojuny.mango.gesturebind.<name>.<name>.description` (`string`, default `""`)
- `desktop.ojuny.mango.gesturebind.<name>.<name>.dispatcher` (`string`, default `"spawn"`)
- `desktop.ojuny.mango.gesturebind.<name>.<name>.group` (`string`, default `"Other"`): Cheatsheet group (the top-level filter category).
- `desktop.ojuny.mango.gesturebind.<name>.<name>.keys` (`list of string`, default `[ ]`)
- `desktop.ojuny.mango.gesturebind.<name>.<name>.modifier` (`list of string`, default `[ "SUPER" ]`)
- `desktop.ojuny.mango.gesturebind.<name>.<name>.subcat` (`string`, default `""`): Cheatsheet category used to sort within the group. Empty omits it.
- `desktop.ojuny.mango.global` (`TOML value`, default `{ allow_lock_transparent = 1; allow_shortcuts_inhibit = 1; animation_duration_close = 300; animation_duration_focus = 200; animation_duration_move = 500; animation_duration_open = 400; a…`): Mango [global] settings (nested attrs are flattened with underscores).
- `desktop.ojuny.mango.mousebind` (`attribute set of attribute set of (submodule)`, default `{ default = { maximize = { args = "0"; description = "Maximize window"; dispatcher = "togglemaximizescreen"; group = "Mouse"; keys = [ "btn_middle" ];…`): Mouse button bindings, grouped by mode then by name.
- `desktop.ojuny.mango.mousebind.<name>.<name>.args` (`(list of string) or string`, default `[ ]`)
- `desktop.ojuny.mango.mousebind.<name>.<name>.description` (`string`, default `""`)
- `desktop.ojuny.mango.mousebind.<name>.<name>.dispatcher` (`string`, default `"spawn"`)
- `desktop.ojuny.mango.mousebind.<name>.<name>.group` (`string`, default `"Other"`): Cheatsheet group (the top-level filter category).
- `desktop.ojuny.mango.mousebind.<name>.<name>.keys` (`list of string`, default `[ ]`)
- `desktop.ojuny.mango.mousebind.<name>.<name>.modifier` (`list of string`, default `[ "SUPER" ]`)
- `desktop.ojuny.mango.mousebind.<name>.<name>.subcat` (`string`, default `""`): Cheatsheet category used to sort within the group. Empty omits it.
- `desktop.ojuny.mango.rules` (`TOML value`, default `{ device_rule = [ ]; layer_rule = [ ]; monitor_rule = [ ]; tag_rule = [ { id = 0; layout_name = "dwindle"; } ]; window_rule = [ { app_id = "foot"; focus…`): Mango window/tag/layer/monitor/device rules.
- `desktop.ojuny.mango.snap` (`submodule`, default `{ bottomInset = 5; leftInset = 3; range = 150; rightInset = 3; topInset = 45; }`): Zones and insets used by the ojuny-snap command and the Super+H bind.
- `desktop.ojuny.mango.snap.bottomInset` (`unsigned integer, meaning >=0`, default `5`): Space in pixels between the bottom screen edge and a snapped window.
- `desktop.ojuny.mango.snap.leftInset` (`unsigned integer, meaning >=0`, default `3`): Space in pixels between the left screen edge and a snapped window.
- `desktop.ojuny.mango.snap.range` (`positive integer, meaning >0`, default `150`): Width in pixels of each edge and corner snap zone.
- `desktop.ojuny.mango.snap.rightInset` (`unsigned integer, meaning >=0`, default `3`): Space in pixels between the right screen edge and a snapped window.
- `desktop.ojuny.mango.snap.topInset` (`unsigned integer, meaning >=0`, default `45`): Space in pixels between the top screen edge and a snapped window, usually the bar height.
- `desktop.ojuny.mango.source` (`list of string`, default `[ ]`): Additional config files to source.
- `desktop.ojuny.mango.switchbind` (`attribute set of (TOML value)`, default `{ }`): Switch bindings keyed by key mode, then by fold or unfold, with a dispatcher string such as "spawn,command".
- `desktop.ojuny.mango.var` (`TOML value`, default `{ }`): Mango [var] variables.

## stylix

- `desktop.ojuny.stylix.enable` (`boolean`, default `false`): Whether to enable theming mangoWM from the imported stylix palette (requires stylix to be imported separately).

## wallpaper

- `desktop.ojuny.wallpaper.cycleIncludeBuiltins` (`boolean`, default `true`): Include the generated bundled presets when Dux Modular Shell cycles through wallpapers.
- `desktop.ojuny.wallpaper.image` (`null or absolute path`, default `null`): Custom wallpaper image. When set, it overrides the selected preset and is used as-is.
- `desktop.ojuny.wallpaper.preset` (`one of "abstract", "city", "everforest", "floyd", "logo", "retro", "stripes", "waves"`, default `"everforest"`): Bundled wallpaper preset. Every preset is generated with the active stylix palette.
- `desktop.ojuny.wallpaper.userDirectory` (`null or absolute path`, default `null`): Directory of user wallpaper images to include in the generated wallpaper directory.
