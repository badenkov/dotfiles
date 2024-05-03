{ pkgs, ... }: {
  config = {
    environment.systemPackages = with pkgs; [
      thunderbird # Email client

      #### CLI
      sysz # A fzf terminal UI for systemctl

      # Next is necessary for yazi
      libsixel # The SIXEL library for console graphics, and converter programs
      poppler # for pdf preview 
      ffmpegthumbnailer # for video preview
      unar # for archive preview

      lsix # Shows thumbnails in terminal using sixel graphics

      zathura # Document reader

      obsidian
      logseq
      anki

      mpv # Videoplayer
      ytfzf # A posix script to find and watch youtube videos from the terminal. (Without API)

      ###############################
      # Messengers

      #slack
      #zoom-us
      element-desktop

      ##############################
      # Virtualization
      virt-manager

      docker-compose

      ##############################
      # Development
      just

      ###################################
      unzip

      jc # CLI tool and python library that converts the output of popular command-line tools,
      # file-types, and common strings to JSON, YAML, or Dictionaries. This allows piping of output to tools
      # like jq and simplifying automation scripts.

      silver-searcher
      ripgrep
      fd
      lf

      fzf # A command-line fuzzy finder written in Go

      erdtree # File-tree visualizer and disk usage analyzer
      glow # Render markdown in CLI

      jq

      carapace
    ];
  };
}
