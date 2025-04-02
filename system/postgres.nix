{ config, ... }: {
  # select (Birthday, Address) FROM employee WHERE fname = 'john' and minit = 'b' and lname = 'smith';

  services.postgresql = {
    enable = true;
    ensureUsers = [
      {
        name = "pgadmin";
        ensureDBOwnership = true;
        ensureClauses = {
          login = true;
          createrole = true;
          superuser = true;
        };
      }
      {
        name = "trent";
        ensureDBOwnership = true;
        ensureClauses = {
          login = true;
          createrole = true;
          superuser = true;
        };
      }
    ];
    ensureDatabases = ["pgadmin" "trent"];
    enableJIT = true;

  };

  sops.secrets.pgadmin_password = {
    sopsFile = ../secrets/pg_admin.sops.txt;
    format = "binary";
  };
  services.pgadmin = {
    enable = true;
    initialEmail = "ghastfilms613@gmail.com";
    initialPasswordFile = config.sops.secrets.pgadmin_password.path;
  };
}
