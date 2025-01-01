{ config, pkgs, ... }:

{
  # Enable Docker service
  virtualisation.docker.enable = true;

  # Enable and configure Docker container for Portainer
  systemd.services.portainer = {
    description = "Portainer - Docker UI";
    after = [ "docker.service" ];
    # Ensure Portainer is pulled and started as a Docker container
    serviceConfig = {
      ExecStart = "${pkgs.docker}/bin/docker run --name portainer -d \
                     -p 9000:9000 \
                     -v /var/run/docker.sock:/var/run/docker.sock \
                     -v portainer_data:/data \
                     portainer/portainer-ce";
      Restart = "always";
    };
    wantedBy = [ "multi-user.target" ];
  };

  # Enable Portainer data volume (for persistence)
  virtualisation.docker.extraVolumes = [
    {
      name = "portainer_data";
      driver = "local";
    }
  ];

  # Make sure Docker is started on boot
  services.docker.enable = true;
  systemd.services.docker.restartIfChanged = true;
}
