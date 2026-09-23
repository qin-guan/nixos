{ ... }:

{
  programs.git = {
    enable = true;
    signing.format = null;

    settings = {
      user = {
        name = "Qin Guan";
        email = "helloqinguan@gmail.com";
      };

      pull.rebase = true;
      push.default = "simple";
      init.defaultBranch = "main";
    };
  };
}
