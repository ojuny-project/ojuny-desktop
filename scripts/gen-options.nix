let
  self = builtins.getFlake (toString ./..);
  lib = self.inputs.nixpkgs.lib;

  evaluated = lib.evalModules {
    specialArgs = { inherit lib; };
    modules = [ ../lib/ojuny-options.nix ];
  };

  describeType = opt:
    let
      description = opt.type.description or null;
    in
    if description != null then description else opt.type.name or "unknown";

  defaultText = opt:
    if opt ? default then
      let
        text = lib.generators.toPretty { } opt.default;
      in
      if lib.stringLength text > 200 then lib.substring 0 200 text + "…" else text
    else if opt ? defaultText then
      opt.defaultText
    else
      "no default";

  record = path: opt: {
    path = lib.concatStringsSep "." path;
    type = describeType opt;
    description = let d = opt.description or ""; in if d == null then "" else d;
    default = defaultText opt;
  };

  # Descend through container types (attrsOf/listOf) to the submodule that
  # declares child options, accumulating one "<name>" per container level.
  childrenOf = type: placeholders:
    if type ? nestedTypes && type.nestedTypes ? elemType then
      childrenOf type.nestedTypes.elemType (placeholders ++ [ "<name>" ])
    else if type ? getSubOptions then
      { inherit placeholders; options = type.getSubOptions [ ]; }
    else
      null;

  # The evaluated option tree mixes plain attrset groups (options.desktop.ojuny)
  # with option records, so walk both.
  project = prefix: entries:
    lib.concatLists (lib.mapAttrsToList
      (name: entry:
        if name == "_module" then
          [ ]
        else if entry ? _type && entry._type == "option" then
          let
            path = prefix ++ [ name ];
            children = childrenOf entry.type [ ];
            internal = entry.internal or false;
          in
          lib.optional (!internal) (record path entry)
          ++ lib.optionals (!internal && children != null)
            (project (path ++ children.placeholders) children.options)
        else if builtins.isAttrs entry then
          project (prefix ++ [ name ]) entry
        else
          [ ])
      entries);
in
project [ ] evaluated.options
