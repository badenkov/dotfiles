{ pkgs, ... }: {
  config = {
    environment.systemPackages = with pkgs; [
      telegram-desktop
      #kotatogram-desktop # Telegram client (TDesktop fork)
    ];
  };
}
