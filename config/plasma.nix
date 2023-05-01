{ pkgs, ... }:

let
  flake-compat = builtins.fetchTarball "https://github.com/edolstra/flake-compat/archive/master.tar.gz";
  plasma-manager = (import flake-compat { src = builtins.fetchTarball "https://github.com/pjones/plasma-manager/archive/master.tar.gz"; }).defaultNix;
in {
  imports = [ plasma-manager.homeManagerModules.plasma-manager ];

  home.packages = [
    plasma-manager.packages."x86_64-linux".rc2nix
  ];

  programs.plasma = {
    # Just checking if it works
    files = {
      kdeglobals = {
        General.BrowserApplication = "brave.desktop";
      };
    };
  };

  # Touchpad gestures
  xdg.configFile."touchegg/touchegg.conf".text = ''
    <touchégg>
      <settings>
        <property name="animation_delay">0</property>
        <property name="action_execute_threshold">0</property>
      </settings>
      <application name="All">
        <gesture type="SWIPE" fingers="3" direction="LEFT">
          <action type="CHANGE_DESKTOP">
            <direction>right</direction>
            <animate>true</animate>
            <animationPosition>right</animationPosition>
            <color>3E9FED</color>
            <borderColor>3E9FED</borderColor>
          </action>
        </gesture>
        <gesture type="SWIPE" fingers="3" direction="RIGHT">
          <action type="CHANGE_DESKTOP">
            <direction>left</direction>
            <animate>true</animate>
            <animationPosition>right</animationPosition>
            <color>3E9FED</color>
            <borderColor>3E9FED</borderColor>
          </action>
        </gesture>
        <gesture type="SWIPE" fingers="3" direction="DOWN">
          <action type="CHANGE_DESKTOP">
            <direction>up</direction>
            <animate>true</animate>
            <animationPosition>right</animationPosition>
            <color>3E9FED</color>
            <borderColor>3E9FED</borderColor>
          </action>
        </gesture>
        <gesture type="SWIPE" fingers="3" direction="UP">
          <action type="CHANGE_DESKTOP">
            <direction>down</direction>
            <animate>true</animate>
            <animationPosition>right</animationPosition>
            <color>3E9FED</color>
            <borderColor>3E9FED</borderColor>
          </action>
        </gesture>
        <gesture type="SWIPE" fingers="4" direction="UP">
          <action type="SEND_KEYS">
            <repeat>false</repeat>
            <modifiers>Super_L</modifiers>
            <keys>D</keys>
            <on>begin</on>
          </action>
        </gesture>
        <gesture type="SWIPE" fingers="4" direction="DOWN">
          <action type="SEND_KEYS">
            <repeat>false</repeat>
            <modifiers>Super_L</modifiers>
            <keys>D</keys>
            <on>begin</on>
          </action>
        </gesture>
      </application>
    </touchégg>
  '';
}
