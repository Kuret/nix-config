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
  boot.kernelParams = [ "mem_sleep_default=deep" ];
  boot.kernelPackages = pkgs.linuxPackages_xanmod_latest;

  # Graphics
  boot.initrd.kernelModules = [ "amdgpu" ];
  services.xserver.videoDrivers = [ "amdgpu" ];

  # GPU
  hardware.opengl.driSupport = true;
  hardware.opengl.driSupport32Bit = true;
  hardware.opengl.extraPackages = with pkgs; [
    rocm-opencl-icd
    rocm-opencl-runtime

    amdvlk
  ];

  # Networking
  networking.hostName = "gpd";
  networking.networkmanager.enable = true;

  # Bluetooth
  hardware.bluetooth.enable = true;

  # Thunderbolt
  services.hardware.bolt.enable = true;

  # Sleep
  systemd.targets.hibernate.enable = false;
  systemd.targets.hybrid-sleep.enable = false;

  # Disable wakeup events from usb
  systemd.services.wakeup-gpd = {
    description = "Fix GPD Win Max 2 wakeups";
    # wantedBy = [ "multi-user.target" "post-resume.target" ];
    # after = [ "multi-user.target" "post-resume.target" ];
    wantedBy = [ "multi-user.target" ];
    after = [ "multi-user.target" ];
    script = ''
      if ${pkgs.gnugrep}/bin/grep -q '\bXHC1\b.*\benabled\b' /proc/acpi/wakeup; then
        echo XHC1 > /proc/acpi/wakeup
      fi
    '';
    serviceConfig.Type = "oneshot";
  };

  # Enable HIP for GPU Acceleration
  systemd.tmpfiles.rules = [
    "L+    /opt/rocm/hip   -    -    -     -    ${pkgs.hip}"
  ];
}
