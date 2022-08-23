{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.virtualisation.googleComputeImage;
  defaultConfigFile = pkgs.writeText "configuration.nix" ''
    { ... }:
    {
      imports = [
        <nixpkgs/nixos/modules/virtualisation/google-compute-image.nix>
      ];
    }
  '';
in {
  imports = [./google-compute-config.nix];

  options = {
    virtualisation.googleComputeImage.diskSize = mkOption {
      type = with types; either (enum ["auto"]) int;
      default = "auto";
      example = 1536;
      description = lib.mdDoc ''
        Size of disk image. Unit is MB.
      '';
    };

    virtualisation.googleComputeImage.configFile = mkOption {
      type = with types; nullOr str;
      default = null;
      description = lib.mdDoc ''
        A path to a configuration file which will be placed at `/etc/nixos/configuration.nix`
        and be used when switching to a new configuration.
        If set to `null`, a default configuration is used, where the only import is
        `<nixpkgs/nixos/modules/virtualisation/google-compute-image.nix>`.
      '';
    };

    virtualisation.googleComputeImage.compressionLevel = mkOption {
      type = types.int;
      default = 6;
      description = lib.mdDoc ''
        GZIP compression level of the resulting disk image (1-9).
      '';
    };

    virtualisation.googleComputeImage.partitionTableType = mkOption {
      type = types.enum ["legacy" "legacy+gpt" "efi" "hybrid" "none"];
      default = "legacy";
      description = lib.mdDoc ''
        # Type of partition table to use; either "legacy", "efi", or "none".
        # For "efi" images, the GPT partition table is used and a mandatory ESP
        #   partition of reasonable size is created in addition to the root partition.
        # For "legacy", the msdos partition table is used and a single large root
        #   partition is created.
        # For "legacy+gpt", the GPT partition table is used, a 1MiB no-fs partition for
        #   use by the bootloader is created, and a single large root partition is
        #   created.
        # For "hybrid", the GPT partition table is used and a mandatory ESP
        #   partition of reasonable size is created in addition to the root partition.
        #   Also a legacy MBR will be present.
        # For "none", no partition table is created. Enabling `installBootLoader`
        #   most likely fails as GRUB will probably refuse to install.
      '';
    };
  };

  #### implementation
  config = {
    system.build.googleComputeImage = import ../../lib/make-disk-image.nix {
      name = "google-compute-image";
      postVM = ''
        PATH=$PATH:${with pkgs; lib.makeBinPath [gnutar gzip]}
        pushd $out
        mv $diskImage disk.raw
        tar -Sc disk.raw | gzip -${toString cfg.compressionLevel} > \
          nixos-image-${config.system.nixos.label}-${pkgs.stdenv.hostPlatform.system}.raw.tar.gz
        rm $out/disk.raw
        popd
      '';
      configFile =
        if cfg.configFile == null
        then defaultConfigFile
        else cfg.configFile;
      inherit (cfg) diskSize partitionTableType;
      inherit config lib pkgs;
    };
  };
}
