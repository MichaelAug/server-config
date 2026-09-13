{ username, ... }:

{
  # Configure SSH server
  services.openssh = {
    enable = true;

    authorizedKeysFiles = [
      "/home/${username}/.ssh/authorized_keys"
    ];

    settings = {
      PasswordAuthentication = false;
      PubkeyAuthentication = true;
      X11Forwarding = false;
      AllowAgentForwarding = false;
      PermitRootLogin = "no";
      KbdInteractiveAuthentication = false;
      ClientAliveInterval = 300;
      ClientAliveCountMax = 2;
      # Don't reveal unnecessary information
      VersionAddendum = null;
    };
  };

  # Configure SSH client
  programs.ssh.extraConfig = ''
    Host nix-desktop
      User restic
      IdentityFile /root/.ssh/n150
      IdentitiesOnly yes
  '';
}
