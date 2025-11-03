{ pkgs, ... }:
{
  extraPackages = with pkgs; [ nixfmt ];
  # NIX
  plugins.lsp.servers.nixd.enable = true;
}
