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

      push.default = "simple";
      init.defaultBranch = "main";
    };
  };
}
