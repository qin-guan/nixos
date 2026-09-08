{ pkgs, ... }:
{
  i18n.inputMethod = {
    enable = true;
    type = "fcitx5";
    fcitx5.waylandFrontend = true;
    fcitx5.addons = with pkgs; [
      qt6Packages.fcitx5-chinese-addons
      qt6Packages.fcitx5-configtool
    ];
  };

  i18n.inputMethod.fcitx5.settings = {
    inputMethod = {
      GroupOrder."0" = "Default";
      "Groups/0" = {
        Name = "Default";
        "Default Layout" = "us";
        DefaultIM = "pinyin";
      };
      "Groups/0/Items/0".Name = "keyboard-us";
      "Groups/0/Items/1".Name = "pinyin";
    };

    globalOptions = {
      "Hotkey/TriggerKeys"."0" = "Control+space";
      Behavior.ActiveByDefault = "False";
    };

    addons.pinyin.globalSection = {
      EmojiEnabled = "True";
      CloudPinyinEnabled = "False";   # sends keystrokes to a remote service
      PageSize = "7";
    };
  };
}
