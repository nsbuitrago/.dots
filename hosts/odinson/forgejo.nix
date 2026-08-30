{ pkgs, ... }:
{
  services.forgejo = {
    enable = true;

    # SQLite is appropriate for this single-user Forgejo instance. Keep all
    # state on the local disk so its database, WAL files, and repositories are
    # backed up together by Restic.
    database.type = "sqlite3";

    settings = {
      server = {
        DOMAIN = "code.nsbuitrago.xyz";
        ROOT_URL = "https://code.nsbuitrago.xyz/";

        # Cloudflared is the only HTTP client; do not expose Forgejo directly.
        HTTP_ADDR = "127.0.0.1";
        HTTP_PORT = 3000;

        # Git-over-SSH is deliberately tailnet-only. The firewall trusts
        # tailscale0 and blocks this port on every other interface.
        START_SSH_SERVER = true;
        BUILTIN_SSH_SERVER_USER = "git";
        SSH_USER = "git";
        SSH_DOMAIN = "odinson";
        SSH_PORT = 2222;
        SSH_LISTEN_HOST = "0.0.0.0";
        SSH_LISTEN_PORT = 2222;
      };

      session.COOKIE_SECURE = true;

      service = {
        DISABLE_REGISTRATION = true;
        ENABLE_NOTIFY_MAIL = false;
      };

      # Keep optional network-facing or code-execution features off until
      # explicitly needed.
      federation.ENABLED = false;
      actions.ENABLED = false;
    };
  };

  # A remotely managed Cloudflare Tunnel receives its public-hostname routing
  # from the Cloudflare dashboard. The token is supplied out-of-band in the
  # root-owned file below, never from the Nix store or this repository.
  systemd.tmpfiles.rules = [
    "d /etc/cloudflared 0700 root root - -"
  ];

  systemd.services.cloudflared-forgejo = {
    description = "Cloudflare Tunnel for Forgejo";
    after = [ "network-online.target" ];
    wants = [ "network-online.target" ];
    wantedBy = [ "multi-user.target" ];
    unitConfig.ConditionPathExists = "/etc/cloudflared/forgejo-tunnel.token";

    serviceConfig = {
      DynamicUser = true;
      LoadCredential = [ "tunnel-token:/etc/cloudflared/forgejo-tunnel.token" ];
      ExecStart = "${pkgs.cloudflared}/bin/cloudflared --no-autoupdate tunnel run --token-file=%d/tunnel-token";
      Restart = "on-failure";
      RestartSec = "5s";

      NoNewPrivileges = true;
      PrivateTmp = true;
      ProtectSystem = "strict";
      ProtectHome = true;
      ProtectKernelTunables = true;
      ProtectKernelModules = true;
      ProtectControlGroups = true;
      RestrictAddressFamilies = [ "AF_UNIX" "AF_INET" "AF_INET6" ];
    };
  };
}
