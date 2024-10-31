{
  user,
  config,
  pkgs,
  homedir,
  ...
}:

{
  home.username = user;
  home.homeDirectory = homedir;

  home.stateVersion = "24.05";

  home.packages = with pkgs; [
    fastfetch
    neovim
    fd
    ripgrep
    bat
    oh-my-posh
    nodejs_22

    # language server - formatter
    nil
    nixfmt-rfc-style
    nginx-config-formatter
  ];

  home.file =
    let
      symlink = config.lib.file.mkOutOfStoreSymlink;
    in
    {
      ".config/nvim".source = symlink "${homedir}/.dotfiles/.config/nvim";
      ".config/oh-my-posh".source = symlink "${homedir}/.dotfiles/.config/oh-my-posh";
    };

  programs.git = {
    enable = true;
    userEmail = "dangdoan2206@gmail.com";
    userName = "D-Dev";
    extraConfig = {
      init.defaultBranch = "main";
    };
  };

  home.sessionVariables = {
    LANG = "en_US.UTF-8";
    LC_ALL = "en_US.UTF-8";
  };

  programs.home-manager.enable = true;
}
