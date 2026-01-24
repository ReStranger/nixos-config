{ username, ... }:
{
  users.users.${username} = {
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJHBGf+Jgje0qQSXDOhnFXaNEMa1H9Xs66KZhYoOvu7L restranger@disroot.org"
    ];
  };
}
