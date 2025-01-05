{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-facter-modules.url = "github:numtide/nixos-facter-modules";
    home-manager = {
      url = "github:nix-community/home-manager/release-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
   compose2nix = { 
     url = "github:aksiksi/compose2nix";
     inputs.nixpkgs.follows = "nixpkgs";
    };
   
  };

  outputs = { nixpkgs, disko, nixos-facter-modules, ... }:

  let
    # Optionally you can define a disk creation script if needed
    diskoScript = ''
      # Ce script crée l'image disque ou configure la partition
      # Ajoute ici les étapes nécessaires pour la configuration disque
      echo "Running disko script"
    '';
  in

  {
    # Définir une configuration générique NixOS
    nixosConfigurations.generic = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        disko.nixosModules.disko
        ./configuration.nix
        ./hardware-configuration.nix
        ./disk-config.nix  # Intégration de ton fichier de configuration disque
      ];
    };

    # Configuration avec `nixos-facter` (si tu veux utiliser cette option)
    nixosConfigurations."generic-nixos-facter" = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        disko.nixosModules.disko
        ./configuration.nix
        nixos-facter-modules.nixosModules.facter
        ./disk-config.nix  # Intégration de ton fichier de configuration disque ici aussi
        # Ajoute une vérification du fichier de configuration générée par nixos-facter
        {
          config.facter.reportPath =
            if builtins.pathExists ./facter.json then
              ./facter.json
            else
              throw "Have you forgotten to run nixos-anywhere with `--generate-hardware-config nixos-facter ./facter.json`?";
        }
      ];
    };
  };
}
