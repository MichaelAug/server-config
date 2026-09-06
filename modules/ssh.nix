{ username, ... }:

{
  services.openssh = {
    enable = true;

    authorizedKeysFiles = [
      "/home/${username}/.ssh/authorized_keys"
    ];

    settings = {
      PasswordAuthentication = false;
      PermitRootLogin = "no";
      KbdInteractiveAuthentication = false;
      ClientAliveCountMax = 1;

      # Don't reveal unnecessary information
      VersionAddendum = null;
    };
  };
}
