{
  programs.alacritty.enable = true;
  programs.alacritty.settings = {
    env.TERM = "xterm-256color";
    tabspaces = 2;
    dynamic_title = true;
    cursor_style = "Block";
    unfocused_hollow_cursor = true;
    live_config_reload = true;
    selection.semantic_escape_chars = ",│`|:\"' ()[]{}<>";
    window = {
      padding.x = 10;
      padding.y = 10;
      decorations = "Full";
      opacity = 1;
    };
    font = {
      normal.family = "LigaConsolas Nerd Font";
      bold.family = "LigaConsolas Nerd Font";
      italic.family = "LigaConsolas Nerd Font";
      size = 10;
    };
    colors = {
      # Zenbones#seoulbones
      primary = {
        background = "#DADADA";
        foreground = "#555555";
      };
      cursor = {
        cursor = "#555555";
        text =   "#DADADA";
      };
      normal = {
        black =   "#DADADA";
        red =     "#DC5284";
        green =   "#628562";
        yellow =  "#C48562";
        blue =    "#0084A3";
        magenta = "#896788";
        cyan =    "#008586";
        white =   "#555555";
      };
      bright = {
        black =   "#BFBABB";
        red =     "#BE3C6D";
        green =   "#487249";
        yellow =  "#A76B48";
        blue =    "#006F89";
        magenta = "#7F4C7E";
        cyan =    "#006F70";
        white =   "#777777";
      };

      # GruvBox Dark
      # primary = {
      #   background = "0x1d2021";
      #   foreground = "0xebdbb2";
      # };
      # normal = {
      #   black =   "0x665c54";
      #   red =     "0xcc241d";
      #   green =   "0x98971a";
      #   yellow =  "0xd79921";
      #   blue =    "0x458588";
      #   magenta = "0xb16286";
      #   cyan =    "0x689d6a";
      #   white =   "0xa89984";
      # };
      # bright = {
      #   black =   "0x928374";
      #   red =     "0xfb4934";
      #   green =   "0xb8bb26";
      #   yellow =  "0xfabd2f";
      #   blue =    "0x83a598";
      #   magenta = "0xd3869b";
      #   cyan =    "0x8ec07c";
      #   white =   "0xebdbb2";
      # };
    };
    mouse_bindings = [
      {
        mouse = "Middle";
	      action = "PasteSelection";
      }
    ];
    mouse = {
      double_click.treshold = 300;
      truple_click.treshold = 300;
      faux_scrolling_lines = 1;
    };
  };
}
