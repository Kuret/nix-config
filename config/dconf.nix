{ lib, ... }:

with lib.hm.gvariant;

{
  dconf.settings = {
    "ca/desrt/dconf-editor" = {
      saved-pathbar-path = "/org/";
      saved-view = "/org/";
      show-warning = false;
      window-height = 979;
      window-is-maximized = false;
      window-width = 881;
    };

    "org/gnome/desktop/calendar" = {
      show-weekdate = true;
    };

    "org/gnome/desktop/input-sources" = {
      sources = [ (mkTuple [ "xkb" "us" ]) ];
      xkb-options = [ "terminate:ctrl_alt_bksp" "caps:escape" ];
    };

    "org/gnome/desktop/interface" = {
      clock-format = "24h";
      clock-show-date = true;
      clock-show-weekday = true;
      cursor-size = 32;
      cursor-theme = "phinger-cursors";
      document-font-name = "Noto Sans 11";
      enable-hot-corners = false;
      font-name = "Noto Sans 10";
      font-rgba-order = "rgb";
      icon-theme = "Adwaita";
      monospace-font-name = "LigaConsolas Nerd Font 11";
      show-battery-percentage = true;
      text-scaling-factor = 1;
    };

    "org/gnome/desktop/media-handling" = {
      automount-open = false;
      autorun-never = true;
    };

    "org/gnome/desktop/peripherals/mouse" = {
      accel-profile = "flat";
    };

    "org/gnome/desktop/peripherals/touchpad" = {
      disable-while-typing = true;
      natural-scroll = true;
      two-finger-scrolling-enabled = true;
    };

    "org/gnome/desktop/session" = {
      idle-delay = mkUint32 900;
    };

    "org/gnome/desktop/wm/preferences" = {
      button-layout = "close:icon";
      titlebar-font = "Noto Sans Bold 11";
    };

    "org/gnome/epiphany" = {
      ask-for-default = false;
    };

    "org/gnome/mutter" = {
      edge-tiling = true;
      experimental-features = [ "scale-monitor-framebuffer" ];
      workspaces-only-on-primary = true;
    };

    "org/gnome/nautilus/icon-view" = {
      captions = [ "size" "none" "none" ];
    };

    "org/gnome/nautilus/list-view" = {
      default-zoom-level = "medium";
      use-tree-view = true;
    };

    "org/gnome/nautilus/preferences" = {
      default-folder-viewer = "list-view";
      show-create-link = false;
      show-delete-permanently = true;
      show-hidden-files = true;
    };

    "org/gnome/settings-daemon/plugins/power" = {
      idle-dim = false;
    };

    "org/gnome/shell" = {
      disable-extension-version-validation = true;
      enabled-extensions = [ "mediacontrols@cliffniff.github.com" ];
      welcome-dialog-last-shown-version = "44.1";
    };

    "org/gnome/shell/extensions/mediacontrols" = {
      extension-position = "right";
      hide-media-notification = true;
      max-widget-width = 500;
      mouse-actions = [ "next" "toggle_play" "toggle_menu" "none" "none" "none" "none" "none" ];
      show-control-icons = false;
      show-player-icon = false;
      show-seperators = false;
      show-sources-menu = false;
      show-text = true;
      track-label = [ "track" "|" "artist" ];
    };

    "org/gnome/tweaks" = {
      show-extensions-notice = false;
    };

    "org/gtk/gtk4/settings/file-chooser" = {
      show-hidden = true;
      show-size-column = true;
      show-type-column = true;
      sort-directories-first = true;
      type-format = "category";
      view-type = "list";
    };

    "system/locale" = {
      region = "nl_NL.UTF-8";
    };
  };
}
