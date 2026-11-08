{
  description = "NixOS 26.05 - Niri + Noctalia";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";

    # Official recommended way for binary cache
    noctalia = {
      url = "github:noctalia-dev/noctalia/cachix";
      # Do NOT set inputs.nixpkgs.follows — it disables the binary cache
    };

    noctalia-greeter = {
      url = "github:noctalia-dev/noctalia-greeter";
      inputs.nixpkgs.follows = "nixpkgs";  # greeter is fine with follows
    };
  };

  outputs = { self, nixpkgs, ... }@inputs: {
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = { inherit inputs; };
      modules = [ ./configuration.nix ];
    };
  };
}
