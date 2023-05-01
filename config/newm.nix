{pkgs, ...}: let
in {
  xdg.configFile."wallpaper.jpg".source = ./wallpaper.jpg;

  xdg.configFile."newm/config.py".text = ''
    import os
    import logging

    logger = logging.getLogger(__name__)

    from pywm import (
        PYWM_TRANSFORM_90,
        PYWM_TRANSFORM_180,
        PYWM_TRANSFORM_270,
        PYWM_TRANSFORM_FLIPPED,
        PYWM_TRANSFORM_FLIPPED_90,
        PYWM_TRANSFORM_FLIPPED_180,
        PYWM_TRANSFORM_FLIPPED_270,
    )

    from newm.helper import BacklightManager, WobRunner, PaCtl

    def on_startup():
        os.system("systemctl --user import-environment DISPLAY WAYLAND_DISPLAY XDG_CURRENT_DESKTOP=wlroots QT_QPA_PLATFORM=wayland-egl")
        os.system("hash dbus-update-activation-environment 2>/dev/null && \
            dbus-update-activation-environment --systemd DISPLAY \
            WAYLAND_DISPLAY XDG_CURRENT_DESKTOP=wlroots QT_QPA_PLATFORM=wayland-egl")
        os.system("systemctl --user restart xdg-desktop-portal-wlr.service")
        os.system("waybar &")

    def on_reconfigure():
        os.system("pkill waybar; waybar &")
        os.system("notify-send newm \"Reloaded config\" &")

    corner_radius = 0

    pywm = {
        'xcursor_theme': 'Adwaita',
        'xcursor_size': 24,

        'encourage_csd': False,
        'enable_xwayland': True,

        'natural_scroll': True,

        'texture_shaders': 'basic',
        'renderer_mode': 'pywm'
    }

    def rules(view):
        if view.role == "rofi":
            return { 'float': True, 'float_pos': (0.5, 0.5) }
        if view.app_id == "pavucontrol":
            return { 'float': True, 'float_size': (340, 600), 'float_pos': (0.15, 0.4) }
        if view.app_id == "Alacritty":
            return { 'blur': { 'radius': 5, 'passes': 3}}
        return None

    view = {
        'corner_radius': 4,
        'padding': 12,
        'fullscreen_padding': 0,
        'send_fullscreen': False,
        'accept_fullscreen': False,

        'rules': rules,
        'floating_min_size': False,

        'debug_scaling': True,
        'border_ws_switch': 100,
    }

    swipe_zoom = {
        'grid_m': 1,
        'grid_ovr': 0.02,
    }

    mod = "L"

    background = {
        'path': os.environ['HOME'] + '/.config/wallpaper.jpg',
        'time_scale': 0.125,
        'anim': True,
    }

    anim_time = .25
    blend_time = .5

    wob_runner = WobRunner("wob -a bottom -M 100")
    backlight_manager = BacklightManager(anim_time=1., bar_display=wob_runner)
    def synchronous_update() -> None:
        backlight_manager.update()
        return

    pactl = PaCtl(0, wob_runner)

    def adjust_current_volume(delta):
        current_sink = execute("pactl list short sinks | grep RUNNING | awk '{print $1}'")
        current_sink = current_sink.strip()
        if current_sink.isdigit():
            current_pactl = PaCtl(int(current_sink))
            current_pactl.volume_adj(delta)
        else:
            pactl.volume_adj(delta)

    key_bindings = lambda layout: [
        (mod+"-h", lambda: layout.move(-1, 0)),
        (mod+"-j", lambda: layout.move(0, 1)),
        (mod+"-k", lambda: layout.move(0, -1)),
        (mod+"-l", lambda: layout.move(1, 0)),
        (mod+"-t", lambda: layout.move_in_stack(1)),

        (mod+"-H", lambda: layout.move_focused_view(-1, 0)),
        (mod+"-J", lambda: layout.move_focused_view(0, 1)),
        (mod+"-K", lambda: layout.move_focused_view(0, -1)),
        (mod+"-L", lambda: layout.move_focused_view(1, 0)),

        (mod+"-C-h", lambda: layout.resize_focused_view(-1, 0)),
        (mod+"-C-j", lambda: layout.resize_focused_view(0, 1)),
        (mod+"-C-k", lambda: layout.resize_focused_view(0, -1)),
        (mod+"-C-l", lambda: layout.resize_focused_view(1, 0)),

        (mod+"-A-k", lambda: layout.basic_scale(1)),
        (mod+"-A-j", lambda: layout.basic_scale(-1)),

        (mod+"-v", lambda: layout.toggle_focused_view_floating()),
        (mod+"-w", lambda: layout.change_focused_view_workspace()),
        (mod+"-W", lambda: layout.move_workspace()),
        (mod+"-S", lambda: os.system("grim -g \"$(slurp)\" &")),

        (mod+"-Return", lambda: os.system("alacritty &")),
        (mod+"-c", lambda: os.system("brave --enable-features=UseOzonePlatform --ozone-platform=wayland &")),
        (mod+"-q", lambda: layout.close_view()),
        (mod+"-Q", lambda: os.system("rofi -show power-menu -modi power-menu:rofi-power-menu &")),

        (mod+"-p", lambda: layout.ensure_locked(dim=True)),
        (mod+"-P", lambda: layout.terminate()),
        (mod+"-C", lambda: layout.update_config()),

        (mod+"-r", lambda: os.system("rofi -show run &")),
        (mod+"-SPC", lambda: os.system("rofi -show drun &")),
        (mod+"-f", lambda: layout.toggle_fullscreen()),

        (mod+"-", lambda: layout.toggle_overview(only_active_workspace=False)),

        ("XF86MonBrightnessUp", lambda: backlight_manager.set(backlight_manager.get() + 0.1)),
        ("XF86MonBrightnessDown", lambda: backlight_manager.set(backlight_manager.get() - 0.1)),
        ("XF86AudioRaiseVolume", lambda: pactl.volume_adj(5)),
        ("XF86AudioLowerVolume", lambda: pactl.volume_adj(-5)),
        ("XF86AudioMute", lambda: pactl.mute()),

        ("XF86LaunchA", lambda: None),
        ("XF86LaunchB", lambda: None),
        ("XF86AudioPrev", lambda: None),
        ("XF86AudioPlay", lambda: None),
        ("XF86AudioNext", lambda: None),
    ]

    gestures = {
        'lp_freq': 120.,
        'lp_inertia': 0.4,

        'c': {'enabled': False, 'scale_px': 800.},
        'pyevdev': {'enabled': True},
    }

    swipe = {
        'gesture_factor': 3
    }

    panels = {
        'lock': {
            'cmd': 'alacritty -e newm-panel-basic lock',
            'w': 1.0,
            'h': 1.0,
            'corner_radius': 0,
        },
    }

    grid = {
        'throw_ps': [2, 10]
    }

    energy = {
        'idle_callback': lambda event: "idle",
        'idle_times': [600, 840, 900],
        'suspend_command': "systemctl suspend",
    }

    focus = {
        'enabled': True,
        'width': 2,
        'distance': 2,
        'color': '#555555',
    }
  '';

  programs.waybar.enable = true;
  programs.waybar.settings = {
    mainBar = {
      layer = "top";
      position = "bottom";
      exclusive = false;
      height = 18;
      modules-right = [ "idle_inhibitor" "pulseaudio" "network" "battery" "clock#date" "clock#time" ];
      battery = {
        format = "  {icon}  {capacity}%";
        format-discharging = "{icon}  {capacity}%";
        format-icons = [ "" "" "" "" "" ];
        tooltip = true;
      };
      "clock#time" = {
        interval = 1;
        format = "{:%H:%M}";
        tooltip = false;
      };
      "clock#date" = {
        interval = 10;
        format = "{:%e %b %Y}";
        tooltip = false;
      };
      network = {
        interval = 5;
        format-wifi = "  {essid}";
        format-disconnected = "⚠  Disconnected";
        tooltip-format = "{ifname}: {ipaddr}";
      };
      pulseaudio = {
        format = "{icon}  {volume}%";
        format-bluetooth = "{icon}  {volume}% ";
        format-muted = "";
        format-icons = {
          headphones = "";
          default = [ "" "" ];
        };
        on-click = "pavucontrol";
      };
      idle_inhibitor = {
        format = "{icon}";
        format-icons = {
          activated = " ";
          deactivated = " ";
        };
      };
    };
  };

  programs.waybar.style = ''
    * {
      border: none;
      border-radius: 0;
      min-height: 0;
      margin: 0;
      padding: 0;
    }

    #waybar {
      background: transparent;
      color: #ebdbb2;
      font-family: "LigaConsolas Nerd Font";
      font-size: 18px;
    }

    #battery, #clock, #network, #pulseaudio, #idle_inhibitor, #tray {
      background: #1d2021;
      padding-left: 10px;
      padding-right: 10px;
    }

    #battery.warning {color: orange;}
    #battery.critical {color: red;}
    #clock {font-weight: bold;}
    #network.disconnected {color: orange;}
  '';

  xdg.configFile."mako/config".text = ''
    background-color=#282828
    border-color=#ebdbb2
    border-radius=5
    border-size=1
    default-timeout=5000
    font=LigaConsolas Nerd Font 14
    layer=overlay
    margin=5,5
    padding=10
    text-color=#ebdbb2
  '';

  xdg.configFile."rofi/config.rasi".text = ''
    @theme "/dev/null"
    configuration {
      modi: "run,drun";
      display-run: " ";
      display-drun:   " ";
      font: "LigaConsolas Nerd Font 18";
      matching: "fuzzy";
    }
    * { width: 20%; height: 15%; background-color: #1d2021; text-color: #ebdbb2; }
    window { padding: 20px; }
    element { text-color: #ebdbb2; }
    element selected { text-color: #1d2021; background-color: #ebdbb2; }
    element-text, element-icon { background-color: inherit; text-color: inherit; }
  '';

  xdg.configFile."networkmanager-dmenu/config.ini".text = ''
    [dmenu]
    dmenu_command = rofi
  '';

  programs.fish.loginShellInit = ''
    if test (tty) = /dev/tty1
      start-newm
    end
  '';
}
