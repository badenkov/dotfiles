_: {
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Disable wpa_supplicant
  networking.wireless.enable = false;
  # Enable NetworkManager
  networking.networkmanager.enable = true;

  user.name = "badenkov";
  user.fullName = "Alexey Badenkov";
  user.email = "alexey.badenkov@gmail.com";

  desktop.enable = true;
  desktop.sway.enable = true;

  system.stateVersion = "23.05";
}
