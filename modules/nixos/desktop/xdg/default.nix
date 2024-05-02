{ ... }: {
  home.extraOptions = {
    xdg.enable = true;
    xdg.mimeApps.defaultApplications = {
      "text/html" = "brave-browser-beta.desktop";
      "x-scheme-handler/http" = "brave-browser-beta.desktop";
      "x-scheme-handler/https" = "brave-browser-beta.desktop";
      "x-scheme-handler/about" = "brave-browser-beta.desktop";
      "x-scheme-handler/unknown" = "brave-browser-beta.desktop";
   };
  };
}
