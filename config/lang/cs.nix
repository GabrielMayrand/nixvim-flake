{
  pkgs,
  ...
}:
{
  plugins.lsp.servers.roslyn_ls.enable = true;
  extraPackages = with pkgs; [
    netcoredbg
  ];

  extraConfigLua = ''
        local dap = require("dap")

    local dap = require("dap")
    local dap_utils = require("dap.utils")

    dap.adapters.coreclr = {
      type = "executable",
      command = "netcoredbg",
      args = { "--interpreter=vscode" },
    }

    dap.configurations.cs = {
      {
        type = "coreclr",
        name = "Attach to running .NET (smart)",
        request = "attach",
        processId = function()
          return dap_utils.pick_process({
            filter = function(proc)
              return proc.name:match("dotnet")
            end,
          })
        end,
      },
    }
  '';

}
