{ config, pkgs, ... }:

{
  ## Jellyfin Service ###
  services.jellyfin = {
    user = "jellyfin";
    enable = true;
    mediaDirs = [ "/home/shares/public/medias1" ]; # Exemple de configuration
  };
  ### Jellyfin ###

  ### Plex Service ###
  services.plex = {
    user = "plex";
    enable = true;
    mediaDirs = [ "/home/shares/public/medias1" ]; # Exemple de configuration
  };
  ### Plex ###

  ### Group Media ###
  users.groups.media.members = ["pozender" "plex" "jellyfin"];
}

