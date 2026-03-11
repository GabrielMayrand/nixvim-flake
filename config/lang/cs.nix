{
  pkgs,
  ...
}:
{
  extraPackages = with pkgs; [
    dotnetCorePackages.sdk_10_0-bin
  ];
  plugins.lsp.servers.roslyn_ls.enable = true;
}
