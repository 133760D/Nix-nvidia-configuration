#Config for Nvidia and others graphics drivers and utilities
#system info: rtx 3060 lhr_v1
{ config, ... }:
{
  #opengl
  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
  };
  
  #drivers nvidia
  hardware.nvidia = {
    package = config.boot.kernelPackages.nvidiaPackages.mkDriver {
      version = "555.58.02";
      sha256_64bit = "sha256-xctt4TPRlOJ6r5S54h5W6PT6/3Zy2R4ASNFPu8TSHKM=";
      sha256_aarch64 = "sha256-wb20isMrRg8PeQBU96lWJzBMkjfySAUaqt4EgZnhyF8=";
      openSha256 = "sha256-8hyRiGB+m2hL3c9MDA/Pon+Xl6E788MZ50WrrAGUVuY=";
      settingsSha256 = "sha256-ZpuVZybW6CFN/gz9rx+UJvQ715FZnAOYfHn5jt5Z2C8=";
      persistencedSha256 = "sha256-a1D7ZZmcKFWfPjjH1REqPM5j/YLWKnbkP9qfRyIyxAw=";
    };
  # Modesetting is required for various things
  modesetting.enable = true;
  # Power management is required to get nvidia GPUs to behave on suspend, due to firmware bugs.
  powerManagement.enable = true;
  # powerManagement.finegrained for multi-gpu setup
  powerManagement.finegrained = false;
  # nvidiaSettings is enabled by default
  # The open driver from nvidia (is NOT nouveau) nb: "semi"-open
  open = true;
  };
}
