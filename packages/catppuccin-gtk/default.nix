{ lib
, stdenvNoCC
, fetchFromGitHub
, gtk3
, colloid-gtk-theme
, gnome-themes-extra
, gtk-engine-murrine
, python3
, sassc
, nix-update-script
}:
let
  pname = "catppuccin-gtk";
in

stdenvNoCC.mkDerivation rec {
  inherit pname;
  version = "0.7.3";

  src = fetchFromGitHub {
    owner = "catppuccin";
    repo = "gtk";
    rev = "v${version}";
    hash = "sha256-pGL8vaE63ss2ZT2FoNDfDkeuCxjcbl02RmwwfHC/Vxg=";
  };

  nativeBuildInputs = [ gtk3 sassc ];

  patches = [
    ./colloid-src-git-reset.patch
  ];

  buildInputs = [
    gnome-themes-extra
    (python3.withPackages (ps: [ ps.catppuccin ]))
  ];

  propagatedUserEnvPkgs = [ gtk-engine-murrine ];

  postUnpack = ''
    rm -rf source/colloid
    cp -r ${colloid-gtk-theme.src} source/colloid
    chmod -R +w source/colloid
  '';

  postPatch = ''
    patchShebangs --build colloid/install.sh colloid/build.sh
  '';

  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall

    cp -r colloid colloid-base
    mkdir -p $out/share/themes
    export HOME=$(mktemp -d)

    python3 install.py latte --accent lavender --dest $out/share/themes
    python3 install.py mocha --accent lavender --dest $out/share/themes

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    description = "Soothing pastel theme for GTK";
    homepage = "https://github.com/catppuccin/gtk";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ fufexan dixslyf ];
  };
}
