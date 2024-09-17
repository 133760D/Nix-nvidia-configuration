{
  # Enable sound with pipewire.
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;
  };
  
  # the following are "services" but fit more here
  # Enable CUPS to print documents.
  services.printing.enable = false;
  # Enable touchpad support (enabled default in most desktopManager). (move to DE?)
  # services.xserver.libinput.enable = true;
}
