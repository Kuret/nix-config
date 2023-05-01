{ pkgs, lib, ... }:

{
  imports = [
    /etc/nixos/hardware-configuration.nix
    ../../linux.nix
  ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot/efi";

  # Linux kernel
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # GPU
  hardware.opengl.driSupport = true;
  hardware.opengl.driSupport32Bit = true;
  hardware.opengl.extraPackages = with pkgs; [
    amdvlk
  ];

  # Networking
  networking.hostName = "gpd";
  networking.networkmanager.enable = true;

  # Bluetooth
  hardware.bluetooth.enable = true;
  #services.blueman.enable = true;

  # Thunderbolt
  services.hardware.bolt.enable = true;

  # Disable wakeup events from usb
  systemd.services.wakeup-gpd = {
    description = "Fix GPD Win Max 2 wakeups";
    wantedBy = [ "multi-user.target" "post-resume.target" ];
    after = [ "multi-user.target" "post-resume.target" ];
    script = ''
      if ${pkgs.gnugrep}/bin/grep -q '\bXHC1\b.*\benabled\b' /proc/acpi/wakeup; then
        echo XHC1 > /proc/acpi/wakeup
      fi
    '';
    serviceConfig.Type = "oneshot";
  };

  # Battery
  services.tlp = {
    enable = false;
    settings = {
      CPU_BOOST_ON_BAT = 0;
      CPU_SCALING_GOVERNOR_ON_BATTERY = "powersave";
      START_CHARGE_THRESH_BAT0 = 80;
      STOP_CHARGE_THRESH_BAT0 = 85;
      RUNTIME_PM_ON_BAT = "auto";
    };
  };
}
