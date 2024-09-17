# NixOS configuration with Nvidia drivers fix

This configuration is an example configuration requiring no flakes.

**unfree drivers are enabled** (disable in global_packages.nix)


To make nvidia drivers run smoothly on NixOS we need:


1. to choose the drivers version carefully.
2. to use a kernel version that works with the drivers version we are using
3. patches OpenGL libraries issues in the nvidia settings

### Drivers

In this example configuration, the drivers version is the 555.58.02 (the latest 555 as of when this file was written)

They're obtained the following way:

```nix
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
  # The (semi) open driver from nvidia (is NOT nouveau)
  open = true;
  };
```

It is possible to use a different version of the nvidia drivers.

Please note: the 560 drivers does not work properly out of the box on NixOS as of now with any kernel.


To get the hashes above, you need to either get them from a reliable source(preferably different from the same download source), this can be from someone who have already built them (such as this repo). Or build the drivers yourself once and add the hashes of the built files to the configuration(not recommended as you might be validating a fake file on your first build).

### Kernel

The kernel is the 6.1, which is a LTS version. Lower versions of the kernel work, but higher versions might cause issues with the drivers. (currently 6.6 and 6.10 are not satisfying. *The latest 6.10 being 6.10.10 as of when this file was written and Nix OS being 24.05*) Found in ./boot_kernel.nix in this repo.

### Nvidia settings fix

If you have done all of above, your system should be somewhat running but you might have noticed some of your applications not working, flickering, crashing or acting unexpectedly. This is due to a (very lightly/un)documented bug introduced in the nvidia drivers when using the openGL library some times ago.

This bug happens with the *GLThreadedOptimizations* parameter set to true, you can disable it for any application using the openGL library to fix the issue.

This can be done either by running `nvidia-settings` and creating a profile and a rule for the GLThreadedOptimizations component; or creating the profile and rule inside of the configuration file using the home-manager as shown in this repo (same thing but using nix configuration files):


./home-manager/users/main.nix
```nix
#----Fix for openGL nvidia drivers bug (GLThreadedOptimizations)----#
    home.file = {
    ".nv/nvidia-application-profiles-rc".text = ''
{
    "rules": [
        {
            "pattern": {
                "feature": "dso",
                "matches": "libGL.so.1"
            },
            "profile": "openGL_fix"
        }
    ],
    "profiles": [
        {
            "name": "openGL_fix",
            "settings": [
                {
                    "key": "GLThreadedOptimizations",
                    "value": false
                }
            ]
        }
    ]
}
    '';
  };
  #----end of fix for openGL nvidia drivers bug----#
```


The openGL library dso(Dynamic Shared Object, used to identify the library in the rule) is ***libGL.so.1***

Alternatively, you can also make the rule global but the GLThreadedOptimizations component will be deactivated for every applications without exception.


this has to be done for every users of the system where you want the fix.
