{ config, pkgs, lib, ...}: let wireguard_ports = [1443 1337 51820 57422 57797 55570]; in {
  networking.firewall = {
   # if packets are still dropped, they will show up in dmesg
   logReversePathDrops = true;
   # wireguard trips rpfilter up
   extraCommands = 
    builtins.concatStringsSep "\n" (builtins.map (port: ''
     ip46tables -t mangle -I nixos-fw-rpfilter -p udp -m udp --sport ${builtins.toString port} -j RETURN
     ip46tables -t mangle -I nixos-fw-rpfilter -p udp -m udp --dport ${builtins.toString port} -j RETURN
    '') wireguard_ports);
   extraStopCommands = 
    builtins.concatStringsSep "\n" (builtins.map (port: ''
     ip46tables -t mangle -D nixos-fw-rpfilter -p udp -m udp --sport ${builtins.toString port} -j RETURN || true
     ip46tables -t mangle -D nixos-fw-rpfilter -p udp -m udp --dport ${builtins.toString port} -j RETURN || true
    '') wireguard_ports);

  };

  # ------ DNS -----

  #networking.nameservers = [ "1.1.1.1#one.one.one.one" "1.0.0.1#one.one.one.one" ];

  # services.resolved = {
  #   enable = true;
  #   dnssec = "true";
  #   domains = [ "~." ];
  #   fallbackDns = [ "1.1.1.1#one.one.one.one" "1.0.0.1#one.one.one.one" ];
  #   dnsovertls = "true";
  # };
  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";
  # Enable networking

  networking.networkmanager = {
    enable = true;
    wifi.macAddress = "stable-ssid";
  };
  
  # services.tailscale.enable = true;
}
