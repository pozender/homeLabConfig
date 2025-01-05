# Auto-generated using compose2nix v0.3.2-pre.
{ pkgs, lib, ... }:

{
  # Runtime
  virtualisation.docker = {
    enable = true;
    autoPrune.enable = true;
  };
  virtualisation.oci-containers.backend = "docker";

  # Containers
  virtualisation.oci-containers.containers."plex" = {
    image = "lscr.io/linuxserver/plex:latest";
    environment = {
      "PGID" = "1000";
      "PUID" = "1000";
      "TZ" = "Europe/Paris";
      "VERSION" = "docker";
    };
    volumes = [
      "/home/docker_containers/config/plex:/config:rw"
      "/home/shares/public/medias1/films:/films:rw"
      "/home/shares/public/medias1/series:/series:rw"
    ];
    log-driver = "journald";
    extraOptions = [
      "--network=host"
    ];
  };
  systemd.services."docker-plex" = {
    serviceConfig = {
      Restart = lib.mkOverride 90 "no";
    };
    partOf = [
      "docker-compose-homelab-root.target"
    ];
    wantedBy = [
      "docker-compose-homelab-root.target"
    ];
  };
  virtualisation.oci-containers.containers."prowlarr" = {
    image = "lscr.io/linuxserver/prowlarr:latest";
    environment = {
      "PGID" = "1000";
      "PUID" = "1000";
      "TZ" = "Etc/UTC";
    };
    volumes = [
      "/home/docker_containers/prowlarr/config:/config:rw"
    ];
    ports = [
      "9696:9696/tcp"
    ];
    log-driver = "journald";
    extraOptions = [
      "--add-host=host.docker.internal:host-gateway"
      "--network-alias=prowlarr"
      "--network=homelab_qbittorrent_net"
    ];
  };
  systemd.services."docker-prowlarr" = {
    serviceConfig = {
      Restart = lib.mkOverride 90 "always";
      RestartMaxDelaySec = lib.mkOverride 90 "1m";
      RestartSec = lib.mkOverride 90 "100ms";
      RestartSteps = lib.mkOverride 90 9;
    };
    after = [
      "docker-network-homelab_qbittorrent_net.service"
    ];
    requires = [
      "docker-network-homelab_qbittorrent_net.service"
    ];
    partOf = [
      "docker-compose-homelab-root.target"
    ];
    wantedBy = [
      "docker-compose-homelab-root.target"
    ];
  };
  virtualisation.oci-containers.containers."qbittorrent" = {
    image = "lscr.io/linuxserver/qbittorrent:latest";
    environment = {
      "PGID" = "992";
      "PUID" = "1000";
      "TORRENTING_PORT" = "6881";
      "TZ" = "Etc/UTC";
      "WEBUI_PORT" = "8080";
    };
    volumes = [
      "/home/docker_containers/config:/config:rw"
      "/home/shares/public/medias1:/downloads:rw"
      "/home/shares/public/medias1/films:/films:rw"
      "/home/shares/public/medias1/series:/series:rw"
    ];
    ports = [
      "8080:8080/tcp"
      "6881:6881/tcp"
      "6881:6881/udp"
    ];
    log-driver = "journald";
    extraOptions = [
      "--add-host=host.docker.internal:host-gateway"
      "--network-alias=qbittorrent"
      "--network=homelab_qbittorrent_net"
    ];
  };
  systemd.services."docker-qbittorrent" = {
    serviceConfig = {
      Restart = lib.mkOverride 90 "always";
      RestartMaxDelaySec = lib.mkOverride 90 "1m";
      RestartSec = lib.mkOverride 90 "100ms";
      RestartSteps = lib.mkOverride 90 9;
    };
    after = [
      "docker-network-homelab_qbittorrent_net.service"
    ];
    requires = [
      "docker-network-homelab_qbittorrent_net.service"
    ];
    partOf = [
      "docker-compose-homelab-root.target"
    ];
    wantedBy = [
      "docker-compose-homelab-root.target"
    ];
  };
  virtualisation.oci-containers.containers."radarr" = {
    image = "lscr.io/linuxserver/radarr:latest";
    environment = {
      "PGID" = "1000";
      "PUID" = "1000";
      "TZ" = "Etc/UTC";
    };
    volumes = [
      "/home/docker_containers/radarr/config:/config:rw"
      "/home/shares/public/medias1:/downloads:rw"
      "/home/shares/public/medias1/films:/movies:rw"
    ];
    ports = [
      "7878:7878/tcp"
    ];
    log-driver = "journald";
    extraOptions = [
      "--add-host=host.docker.internal:host-gateway"
      "--network-alias=radarr"
      "--network=homelab_qbittorrent_net"
    ];
  };
  systemd.services."docker-radarr" = {
    serviceConfig = {
      Restart = lib.mkOverride 90 "always";
      RestartMaxDelaySec = lib.mkOverride 90 "1m";
      RestartSec = lib.mkOverride 90 "100ms";
      RestartSteps = lib.mkOverride 90 9;
    };
    after = [
      "docker-network-homelab_qbittorrent_net.service"
    ];
    requires = [
      "docker-network-homelab_qbittorrent_net.service"
    ];
    partOf = [
      "docker-compose-homelab-root.target"
    ];
    wantedBy = [
      "docker-compose-homelab-root.target"
    ];
  };
  virtualisation.oci-containers.containers."rmtracker" = {
    image = "compose2nix/rmtracker";
    environment = {
      "HOST" = "qbittorrent";
      "PASSWD" = "passwd";
      "USER" = "admin";
    };
    dependsOn = [
      "qbittorrent"
    ];
    log-driver = "journald";
    extraOptions = [
      "--network-alias=rmtracker"
      "--network=homelab_qbittorrent_net"
    ];
  };
  systemd.services."docker-rmtracker" = {
    serviceConfig = {
      Restart = lib.mkOverride 90 "always";
      RestartMaxDelaySec = lib.mkOverride 90 "1m";
      RestartSec = lib.mkOverride 90 "100ms";
      RestartSteps = lib.mkOverride 90 9;
    };
    after = [
      "docker-network-homelab_qbittorrent_net.service"
    ];
    requires = [
      "docker-network-homelab_qbittorrent_net.service"
    ];
    partOf = [
      "docker-compose-homelab-root.target"
    ];
    wantedBy = [
      "docker-compose-homelab-root.target"
    ];
  };
  virtualisation.oci-containers.containers."sonarr" = {
    image = "lscr.io/linuxserver/sonarr:latest";
    environment = {
      "PGID" = "1000";
      "PUID" = "1000";
      "TZ" = "Etc/UTC";
    };
    volumes = [
      "/home/docker_containers/sonarr/config:/config:rw"
      "/home/shares/public/medias1:/downloads:rw"
      "/home/shares/public/medias1/series:/tv:rw"
    ];
    ports = [
      "8989:8989/tcp"
    ];
    log-driver = "journald";
    extraOptions = [
      "--add-host=host.docker.internal:host-gateway"
      "--network-alias=sonarr"
      "--network=homelab_qbittorrent_net"
    ];
  };
  systemd.services."docker-sonarr" = {
    serviceConfig = {
      Restart = lib.mkOverride 90 "always";
      RestartMaxDelaySec = lib.mkOverride 90 "1m";
      RestartSec = lib.mkOverride 90 "100ms";
      RestartSteps = lib.mkOverride 90 9;
    };
    after = [
      "docker-network-homelab_qbittorrent_net.service"
    ];
    requires = [
      "docker-network-homelab_qbittorrent_net.service"
    ];
    partOf = [
      "docker-compose-homelab-root.target"
    ];
    wantedBy = [
      "docker-compose-homelab-root.target"
    ];
  };

  # Networks
  systemd.services."docker-network-homelab_qbittorrent_net" = {
    path = [ pkgs.docker ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStop = "docker network rm -f homelab_qbittorrent_net";
    };
    script = ''
      docker network inspect homelab_qbittorrent_net || docker network create homelab_qbittorrent_net --driver=bridge
    '';
    partOf = [ "docker-compose-homelab-root.target" ];
    wantedBy = [ "docker-compose-homelab-root.target" ];
  };

  # Builds
  systemd.services."docker-build-rmtracker" = {
    path = [ pkgs.docker pkgs.git ];
    serviceConfig = {
      Type = "oneshot";
      TimeoutSec = 300;
    };
    script = ''
      cd /home/pozender/rmtracker
      docker build -t compose2nix/rmtracker .
    '';
  };

  # Root service
  # When started, this will automatically create all resources and start
  # the containers. When stopped, this will teardown all resources.
  systemd.targets."docker-compose-homelab-root" = {
    unitConfig = {
      Description = "Root target generated by compose2nix.";
    };
    wantedBy = [ "multi-user.target" ];
  };
}
