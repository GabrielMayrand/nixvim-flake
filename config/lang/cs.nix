{ pkgs, ... }:
{
  extraPackages = with pkgs; [
    dotnetCorePackages.sdk_10_0-bin
    netcoredbg
    roslyn-ls
  ];

  plugins.easy-dotnet = {
    enable = true;
    autoLoad = true;

    settings = {
      picker = "telescope";

      debugger = {
        auto_register_dap = false;
        bin_path = "${pkgs.netcoredbg}/bin/netcoredbg";
        console = "integratedTerminal";
      };

      test_runner = {
        auto_start_testrunner = true;
        viewmode = "float";
      };
    };
  };

  plugins.lsp.servers.roslyn_ls.enable = true;
}
