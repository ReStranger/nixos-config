{ username, ... }:
{
  users.users.${username} = {
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIN9atm7t4QIPwVKUd6+JwIj0lKHzWR4/Is/qPRmU0skL restranger@disroot.org"
    ];
  };
}
