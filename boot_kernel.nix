#bootloader, kernel and others boot options
{ pkgs, ... }:
{
  #-----bootloader-----#
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/sdX_ERROR_CHANGE_THIS"; #DON'T FORGET TO CHANGE THIS
  boot.loader.grub.useOSProber = true;
  #-----end of bootloader-----#
  
  #-----kernel-----#
  #boot.kernelPackages = pkgs.linuxPackages_5_10; #EOL 2026 | 2031 CIP
  #boot.kernelPackages = pkgs.linuxPackages_5_18; #EOL 2026
  boot.kernelPackages = pkgs.linuxPackages_6_1; #EOL 2026 | 2033 CIP
  
  #**the followings have issues with nvidia drivers on Nix by default currently
  #boot.kernelPackages = pkgs.linuxPackages_6_6; #EOL 2026
  #boot.kernelPackages = pkgs.linuxPackages_6_10;
  
  #I don't recommend using this to avoid bad surprises when building.
  #You should update the kernel manually.
  #boot.kernelPackages = pkgs.linuxPackages_latest; 
  #-----end of kernel-----#
}

