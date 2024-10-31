{ ... }:
{
  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;
    enableCompletion = true;
    syntaxHighlighting.enable = true;
    history = {
      size = 1000;
      save = 1000;
      append = true;
      share = true;
      ignoreAllDups = true;
      ignoreDups = true;
      ignoreSpace = true;
    };
    shellAliases = {
      l = "eza -lh --icons=auto --sort=name --group-directories-first"; # long list
      ls = "eza --icons=auto --sort=name --group-directories-first"; # short list
      ll = "eza -lha --icons=auto --sort=name --group-directories-first"; # long list all
      la = "eza -a --icons=auto --sort=name --group-directories-first"; # short list all
      ld = "eza -lhD --icons=auto"; # long list dirs
      lt = "eza --icons=auto --tree"; # list folder as tree
      ".." = "cd ..";
      "..." = "cd ../..";
      ".3" = "cd ../../..";
      ".4" = "cd ../../../..";
      ".5" = "cd ../../../../..";
      n = "nvim";
      t = "tmux";
      refreshenv = "source ~/.zshrc";
      resetnvim = "rm -rf ~/.local/state/nvim ~/.cache/nvim";
      mkdir = "mkdir -p";
    };
    initExtra = ''
      ZINIT_HOME="''${XDG_DATA_HOME:-''${HOME}/.local/share}/zinit/zinit.git"
      if [ ! -d "''$ZINIT_HOME" ]; then
         mkdir -p "''$(dirname $ZINIT_HOME)"
         git clone https://github.com/zdharma-continuum/zinit.git "''$ZINIT_HOME"
      fi
      source "''${ZINIT_HOME}/zinit.zsh"

      eval "''$(oh-my-posh init zsh --config ''$HOME/.config/oh-my-posh/d-dev.toml)"

      zinit light Aloxaf/fzf-tab

      bindkey '^p' history-search-backward
      bindkey '^n' history-search-forward
      bindkey '^[w' kill-region

      zinit snippet OMZP::git
      zinit snippet OMZP::sudo

      zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
      zstyle ':completion:*' list-colors "''${(s.:.)LS_COLORS}"
      zstyle ':completion:*' menu no
      zstyle ':fzf-tab:*' use-fzf-default-opts yes
      zstyle ':fzf-tab:*' fzf-min-height 15
      zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza -1a --color=always --icons=auto $realpath'
      zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'eza -1a --color=always --icons=auto $realpath'
      zstyle ':fzf-tab:complete:systemctl-*:*' fzf-preview 'SYSTEMD_COLORS=1 systemctl status $word'
      zstyle ':fzf-tab:complete:*' fzf-bindings 'ctrl-/:toggle-preview,ctrl-e:preview-down,ctrl-y:preview-up'

      prv() {
        unset HISTFILE
        echo "\n\tRunning in private environment, no commands are saved!"
      }
    '';
  };

  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
    options = [ "--cmd cd" ];
  };

  programs.eza = {
    enable = true;
    enableZshIntegration = true;
    icons = "auto";
    extraOptions = [
      "--sort=name"
      "--group-directories-first"
    ];
  };

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
    defaultCommand = "rg --files --hidden --follow --glob '!.git'";
    defaultOptions = [
      "--height 40%"
      "--layout=reverse"
      "--info=inline"
      "--border"
      "--color=bg+:#363a4f,spinner:#f4dbd6,hl:#ed8796"
      "--color=fg:#cad3f5,header:#ed8796,info:#c6a0f6,pointer:#f4dbd6"
      "--color=marker:#b7bdf8,fg+:#cad3f5,prompt:#c6a0f6,hl+:#ed8796"
      "--color=selected-bg:#494d64"
    ];
    fileWidgetCommand = "rg --files --hidden --follow --glob '!.git'";
    fileWidgetOptions = [
      "--preview '(bat -n --color=always --style=numbers {}) 2> /dev/null | head -200'"
      "--bind 'ctrl-/:toggle-preview,ctrl-e:preview-down,ctrl-y:preview-up'"
    ];
    changeDirWidgetOptions = [
      "--select-1"
      "--exit-0"
      "--walker-skip .git,node_modules,target"
      "--preview '(eza -T --icons --sort=name {}) 2> /dev/null | head -50'"
      "--bind 'ctrl-/:toggle-preview,ctrl-e:preview-down,ctrl-y:preview-up'"
    ];
  };
}
