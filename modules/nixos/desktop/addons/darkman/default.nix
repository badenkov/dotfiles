{ ... }: {
  config = {
    home.extraOptions = {
      services.darkman = {
        enable = true;

        settings = {
          # Tbilisi
          lat = 41.716667;
          lng = 44.783333;
          usegeoclue = true;
        };
      };
    };
  };
}
