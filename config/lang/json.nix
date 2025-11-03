{ pkgs, ... }:
{
  extraPackages = with pkgs; [
    nodePackages_latest.jsonlint
  ];
  plugins.lsp.servers.jsonls.enable = true;
}
