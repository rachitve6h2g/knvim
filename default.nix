{
  pkgs,
  mnw,
  ...
}:
mnw.lib.wrap pkgs {
  appName = "nvim";
  desktopEntry = false;

  aliases = [
    "vim"
    "vi"
  ];

  # luaFiles = [
  #   ./init.lua
  # ];

  providers = {
    nodeJs.enable = true;
    perl = {
      enable = true;
      extraPackages =
        p: with p; [
          NeovimExt # Defaults must
          Appcpanminus # be present

          DirManifest
        ];
    };
  };

  extraLuaPackages =
    ps: with ps; [
      jsregexp
      lua-utils-nvim
      magick
      pathlib-nvim
    ];

  neovim = pkgs.neovim-unwrapped;
  plugins = {
    startAttrs = {
      "blink.cmp" = null;
    };
    start = import ./packages/startPlugins.nix { inherit pkgs; };
    # start = import ./packages/treesitter.nix { inherit pkgs; };
    # optAttrs = import ./packages/optPlugins.nix { inherit pkgs; };
    opt = import ./packages/optPlugins.nix { inherit pkgs; };

    dev.myconfig = {
      pure = ./nvim;
      impure = "/home/krish/Documents/projects/neovim/nvim";
    };
  };

  extraBinPath = import ./packages/binaries.nix { inherit pkgs; };
}
