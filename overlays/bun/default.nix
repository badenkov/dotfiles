_: (final: prev: {
  bun = prev.bun.overrideAttrs (finalAttrs: prevAttrs: let
    version = "1.0.25";
  in {
    inherit version;

    src = prev.fetchurl {
      url = "https://github.com/oven-sh/bun/releases/download/bun-v${version}/bun-linux-x64.zip";
      hash = "sha256-vg8YtbhW122EU/oBuMoh5kPVqA6YRbRxrDZWnoJmdYQ=";
    };
  });
})
