{pkgs, ...}: {
  imports = [
    ../hardware/honor.nix
    ../profiles/common.nix
    ../profiles/desktop
    ../users/badenkov
  ];

  time.timeZone = "Asia/Tbilisi";

  networking.hostName = "honor";
  networking.firewall.allowedTCPPorts = [80 443 5201];

  ### TOD - Возможно стои перенести в hardware?
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  ###

  boot.kernelPackages = pkgs.linuxPackages_latest;

  fileSystems."/" = {
    device = "/dev/disk/by-label/nixos";
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-label/boot";
    fsType = "vfat";
  };

  swapDevices = [];

  services.blueman.enable = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "21.05"; # Did you read the comment?
}
