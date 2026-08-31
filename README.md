# N150 Home Server

NixOS configuration for my home server, managed with flakes.

## Structure

```text
.
├── flake.nix
└── modules/
    ├── hardware-configuration.nix
    ├── ...
```

All `.nix` files in `nixos/modules/` are automatically discovered and loaded by the flake. Each module should be self-contained around a particular system concern or service.

## Rebuild

From the config directory:

```bash
sudo nixos-rebuild switch --flake .#server
```

Or using `nh`:

```bash
nh os switch .
```

## Development

run `nix develop` to get dev tools such as `nixd`, `nil`, `nixfmt`, `statix`, and `deadnix`.
