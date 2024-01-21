{ system, inputs, pkgs }: let
  ruby = pkgs.ruby_3_3;
  bundler = pkgs.bundler.override { inherit ruby; };
in pkgs.mkShell {
  buildInputs = [
    ruby
    bundler

    pkgs.nodejs
    pkgs.yarn
  ];

  shellHook = ''
    mkdir -p ~/mygems

    GEM_HOME=$(gem environment home)
    export PATH=$GEM_HOME/bin:$PATH

    alias bi="bundle install"
    alias be="bundle exec"
  '';
}
