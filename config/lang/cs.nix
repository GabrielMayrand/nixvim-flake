{ pkgs, ... }:
{
  extraPackages = with pkgs; [
    dotnetCorePackages.sdk_10_0-bin
    netcoredbg
    roslyn-ls
  ];

  plugins.dap = {
    enable = true;

    adapters.executables.coreclr = {
      command = "${pkgs.netcoredbg}/bin/netcoredbg";
      args = [ "--interpreter=vscode" ];
    };

    configurations = {
      cs = [
        {
          type = "coreclr";
          name = "Launch (.NET)";
          request = "launch";
          program.__raw = ''
            function()
              return vim.fn.input('Path to dll: ', vim.fn.getcwd() .. '/bin/Debug/', 'file')
            end
          '';
          cwd = "\${workspaceFolder}";
          stopAtEntry = false;
          console = "integratedTerminal";
        }
        {
          type = "coreclr";
          name = "Attach (.NET) - pick dotnet process";
          request = "attach";

          processId.__raw = ''
            function()
              local utils = require("dap.utils")
              return utils.pick_process({
                filter = function(proc)
                  -- proc.name is typically the executable name (e.g. "dotnet")
                  -- proc.cmdline may contain full command line depending on OS/provider
                  if proc.name and proc.name:find("dotnet") then
                    return true
                  end
                  if proc.cmdline and proc.cmdline:find("dotnet") then
                    return true
                  end
                  return false
                end,
              })
            end
          '';
        }
      ];
    };
  };

  plugins.easy-dotnet = {
    enable = true;
    autoLoad = true;

    settings = {
      picker = "telescope";

      debugger = {
        auto_register_dap = true;
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
