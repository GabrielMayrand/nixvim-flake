{
  pkgs,
  ...
}:
{
  plugins.lsp.servers.roslyn_ls.enable = true;

  extraPackages = with pkgs; [
    netcoredbg
    roslyn-ls
  ];

  plugins.easy-dotnet = {
    enable = true;
    autoLoad = true;
  };

}
