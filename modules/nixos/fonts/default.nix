{ pkgs, ... }: {
  config = {
    fonts = {
      enableDefaultPackages = true;
      packages = with pkgs; [
        ubuntu_font_family
        jetbrains-mono
        #fira-code
        #fira-code-symbols
        #iosevka
        martian-mono
        # for neovim
        #nerdfonts

        #(nerdfonts.override {fonts = ["FiraCode" "JetBrainsMono"];})
        (nerdfonts.override { fonts = [ "JetBrainsMono" ];})
      ];
    };
  };
}
