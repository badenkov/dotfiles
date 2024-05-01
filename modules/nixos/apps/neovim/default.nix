{ pkgs, ... }: {
  config = {
    environment.variables = {
      EDITOR = "nvim";
    };

    environment.systemPackages = with pkgs; [
      custom.myvim
    ];
  };
}
