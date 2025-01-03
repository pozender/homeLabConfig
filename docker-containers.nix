{ config, pkgs, ... }:

{
  virtualisation.oci-containers = {
    backend = "docker";
    containers = {
      portainer = {
        image = "portainer/portainer-ce";
        volumes = [
          "/var/run/docker.sock:/var/run/docker.sock"
          "portainer_data:/data"
        ];
        ports = [
          "9443:9443"
          "8000:8000"
        ];
        autoStart = true;
      };
      qbitorrent = {
        image = "lscr.io/linuxserver/qbittorrent:latest";
        volumes = [
          "/home/docker_containers/config/qbittorrent:/config"
          "/home/shares/public/medias1:/downloads"
          "/home/shares/public/medias1/films:/films"
          "/home/shares/public/medias1/series:/series"
        ];
        environment = {
          PUID = "1000";
          PGID = "9920";
          TZ = "Etc/UTC";
          WEBUI_PORT = "8080";
          TORRENTING_PORT = "6881";
        };
        ports = [
          "8080:8080"
          "6881:6881"
          "6881:6881/udp"
        ];
        autoStart = true;
      };
    plex = {
     image = "lscr.io/linuxserver/plex:latest";
     volumes = [
     "/home/docker_containers/config/plex:/config"
     "/home/shares/public/medias1/films:/films"
     "/home/shares/public/medias1/series:/series"
     ];
     environment = {
       PUID = "1000";
       PGID = "9920";
       TZ = "Etc/UTC";
       VERSION = "docker";
     };
     extraOptions = ["--network=host"];
     autoStart = true;
     };

   autoremovetracker = {
      image = "./autoremovetracker.tar";
      environmentFiles = [./rmtracker.env];
      dependsOn = ["qbitorrent"];
      autoStart = true;
      };
    };
  };
}

