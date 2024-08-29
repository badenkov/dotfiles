{ pkgs, ... }: {
  config = {
    environment.systemPackages = with pkgs; [
      #### CLI
      zathura # Document reader

      obsidian
      #logseq
      anki

      mpv # Videoplayer
      #ytfzf # A posix script to find and watch youtube videos from the terminal. (Without API)

      ###############################
      # Messengers

      #slack
      #zoom-us
      #element-desktop
      kdenlive
    ];
  };
}
