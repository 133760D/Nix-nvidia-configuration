#use users.users.<name> for default/main user; users.extraUsers.<name> otherwise
{ pkgs, ...}:
{
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.extraUsers.games = {
    isNormalUser = true;
    home = "/home/games";
    description = "Gaming account";
    extraGroups = [ "wheel" ];
  };
  
  home-manager.users.games = {
    home.stateVersion = "24.05";
    #user packages
    home.packages = with pkgs; [
      jdk
      prismlauncher #minecraft
    ];
    
    #----Fix for openGL nvidia drivers bug (GLThreadedOptimizations)
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
  #----End of fix for openGL nvidia drivers bug
  };
}
