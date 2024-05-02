{ pkgs, ... }: {
  # environment.variables = {
  #   GTK_THEME = "Catppuccin-Mocha-Compact-Blue-dark";
  # };

  environment.systemPackages = let
    schema = pkgs.gsettings-desktop-schemas;
    datadir = "${schema}/share/gsettings-schemas/${schema.name}";
    set-gtk-light-script = pkgs.writeShellScriptBin "set-gtk-light" ''
      export XDG_DATA_DIRS=${datadir}:$XDG_DATA_DIRS
      gnome_schema=org.gnome.desktop.interface
      gsettings set $gnome_schema gtk-theme 'Catppuccin-Latte-Standard-Lavender-Light'
      gsettings set org.gnome.desktop.interface color-scheme 'prefer-light'
    '';
    set-gtk-dark-script = pkgs.writeShellScriptBin "set-gtk-dark" ''
      export XDG_DATA_DIRS=${datadir}:$XDG_DATA_DIRS
      gnome_schema=org.gnome.desktop.interface
      gsettings set $gnome_schema gtk-theme 'Catppuccin-Mocha-Standard-Lavender-Dark'
      gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'
    '';
  in [
    set-gtk-light-script
    set-gtk-dark-script
  ];

  home.extraOptions.gtk = {
    enable = true;

    theme = {
      name = "Catppuccin-Mocha-Standard-Lavender-Dark";
      package = pkgs.custom.catppuccin-gtk;
    };

    # cursorTheme = {
    #   name = "Catppuccin-${flavourUpper}-${accentUpper}-Cursors";
    #   package = pkgs.catppuccin-cursors;
    # };
    
    # iconTheme = {
    #   name = "Adwaita-Dark";
    #   package = pkgs.gnome3.adwaita-icon-theme; # default gnome cursors
    # };
  };

  home.extraOptions.services.darkman = {
    lightModeScripts.gtk = ''
      set-gtk-light
    '';
    darkModeScripts.gtk = ''
      set-gtk-dark
    '';
  };
}
