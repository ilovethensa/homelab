{
  pkgs,
  config,
  lib,
  ...
}: {
  programs.chromium = let
    package = pkgs.ungoogled-chromium;
    installExtensions = false; # TODO: Figure out how to load these links only once per extension
  in {
    inherit package;
    commandLineArgs =
      [
        "--extension-mime-request-handling=always-prompt-for-install" # Required for chromium-web-store <https://github.com/NeverDecaf/chromium-web-store/blob/26ecd834de4bcda8eb167617fa9f48ecef673975/README.md#read-this-first>
      ]
      ++ lib.optionals installExtensions (
        [
          "https://github.com/NeverDecaf/chromium-web-store/releases/latest/download/Chromium.Web.Store.crx"
        ]
        ++ map (
          extension: "https://clients2.google.com/service/update2/crx?response=redirect\\&acceptformat=crx2,crx3\\&prodversion=${package.version}\\&x=id%3D${extension.id}%26uc"
        )
        config.programs.chromium.extensions
      );
    dictionaries = [
      pkgs.hunspellDictsChromium.de_DE
      pkgs.hunspellDictsChromium.en_GB
      pkgs.hunspellDictsChromium.fr_FR
    ];
    enable = true;
    extensions = [
      {
        # Bitwarden
        id = "nngceckbapebfimnlniiiahkandclblb";
      }
      {
        # I still don't care about cookies
        id = "edibdbjcniadpccecjdfdjjppcpchdlm";
      }
      {
        # uBlock Origin Lite
        id = "ddkjiahejlhfcafbddmgiahcphecmpfh";
      }
      {
        # Onetab
        id = "chphlpgkkbolifaimnlloiipkdnihall";
      }
      {
        # Dark reader
        id = "eimadpbcbfnmbkopoojfekhnkhdbieeh";
      }
    ];
  };
}
