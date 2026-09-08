{ ... }:

{
  programs.plasma = {
    enable = true;

    kwin = {
      # No animation when switching between virtual desktops.
      effects.desktopSwitching.animation = "off";
    };

    shortcuts.kwin = {
      # Move active window to left/right tile of the custom tile layout (Meta+T editor).
      # These are unset by default in KWin, so we bind them to Win+Left/Right.
      "Window Custom Quick Tile Left" = "Meta+Left";
      "Window Custom Quick Tile Right" = "Meta+Right";

      # Clear the default quick-tile bindings to avoid conflicting with the
      # custom-tile bindings above (empty list => "none" in kglobalshortcutsrc).
      "Window Quick Tile Left" = [ ];
      "Window Quick Tile Right" = [ ];
    };
  };
}
