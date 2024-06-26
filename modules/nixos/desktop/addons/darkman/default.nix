{ pkgs, lib, ... }: {
  config = {
    home.extraOptions = {
      services.darkman = {
        enable = true;
        #package = pkgs.custom.darkman;
        package = pkgs.symlinkJoin {
          name = "darkman-wrapped";
          paths = [ pkgs.darkman ];
          nativeBuildInputs = [ pkgs.makeBinaryWrapper ];
          postBuild = ''
            wrapProgram "$out/bin/darkman" \
              --set PATH ${lib.makeBinPath [ pkgs.bash ]}
          '';
          meta.mainProgram = "darkman";
        };

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
