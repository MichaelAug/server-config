# N150 Home Server

NixOS configuration for my home server, managed with flakes.

## Structure

All `.nix` files in `nixos/modules/` are automatically discovered and loaded by the flake. Each module should be self-contained around a particular system concern or service.

## Files and Directories Not Created by NixOS

The following must be created or supplied separately when setting up a new system:

| Path | Purpose |
|---|---|
| `/home/server/.ssh/authorized_keys` | SSH public keys used to authenticate the `server` user |
| `/var/lib/radicale/users` | File used by Radicale. Create using `htpasswd' |

The rest of the service configuration and required system directories are created and managed by NixOS.

## Tailscale Serve

Tailscale Serve terminates HTTPS and reverse-proxies each port to the service's local HTTP port. All endpoints are tailnet-only.

```text
https://n150.tail617a34.ts.net:443
    → http://127.0.0.1:2283 Immich

https://n150.tail617a34.ts.net:8444
    → http://127.0.0.1:8123 Home Assistant

https://n150.tail617a34.ts.net:8445
    → http://127.0.0.1:8384 Syncthing

https://n150.tail617a34.ts.net:8446
    → http://127.0.0.1:5232 Radicale / CalDAV

```

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
