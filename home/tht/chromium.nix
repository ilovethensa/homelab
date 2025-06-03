{pkgs, config, ...}: {
  programs.chromium =
    let
      package = pkgs.ungoogled-chromium;
      installExtensions = true; # TODO: Figure out how to load these links only once per extension
    in
    {
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
            extension:
            "https://clients2.google.com/service/update2/crx?response=redirect\\&acceptformat=crx2,crx3\\&prodversion=${package.version}\\&x=id%3D${extension.id}%26uc"
          ) config.programs.chromium.extensions
        );
      dictionaries = [
        pkgs.hunspellDictsChromium.de_DE
        pkgs.hunspellDictsChromium.en_GB
        pkgs.hunspellDictsChromium.fr_FR
      ];
      enable = true;
      extensions = [
        {
          # BetterTTV
          id = "ajopnjidmegmdimjlfnijceegpefgped";
        }
        {
          # Copy All Urls
          id = "djdmadneanknadilpjiknlnanaolmbfk";
        }
        {
          # Disable YouTube Number Keyboard Shortcuts
          id = "lajiknjoinemadijnpdnjjdmpmpigmge";
        }
        {
          # Get RSS Feed URL
          id = "kfghpdldaipanmkhfpdcjglncmilendn";
        }
        {
          # Insecure Links Highlighter
          id = "oejjgapcbhmlhkiijmadcofhmmfebmec";
        }
        {
          # I still don't care about cookies
          id = "edibdbjcniadpccecjdfdjjppcpchdlm";
        }
        {
          # Kagi Search
          id = "cdglnehniifkbagbbombnjghhcihifij";
        }
        {
          # KeePassXC-Browser
          id = "oboonakemofpalcgghocfoadofidjkkk";
        }
        {
          # Pinboard Plus
          id = "mphdppdgoagghpmmhodmfajjlloijnbd";
        }
        {
          # Privacy Badger
          id = "pkehgijcmpdhfbdbbnkijodmdjhbjlgp";
        }
        {
          # Read Aloud: A Text to Speech Voice Reader
          id = "hdhinadidafjejdhmfkjgnolgimiaplp";
        }
        {
          # Refined GitHub
          id = "hlepfoohegkhhmjieoechaddaejaokhf";
        }
        {
          # uBlock Origin Lite
          id = "ddkjiahejlhfcafbddmgiahcphecmpfh";
        }
        {
          # Wayback Machine
          id = "fpnmgdkabkmnadcjpehmlllkndpkmiak";
        }
      ];
    };

}
