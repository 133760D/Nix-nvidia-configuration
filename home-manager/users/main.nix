#use users.users.<name> for default/main user; users.extraUsers.<name> otherwise
{ pkgs, ...}:
{
  #----user creation----#
  # Don't forget to set a password with ‘passwd’.
  users.users.main = {
    isNormalUser = true;
    description = "main";
    extraGroups = [ "networkmanager" "wheel" ];
  };
  #----end of user creation----#
  
  #**home manager**#
  home-manager.users.main = {
    home.stateVersion = "24.05";
    #user packages
    home.packages = with pkgs; [
      #conda
    ];
    
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
  };
}
