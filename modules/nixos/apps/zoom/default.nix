{ pkgs, ... }: {
  config = {
    environment.systemPackages = with pkgs; [
      zoom-us
    ];
  };
}
