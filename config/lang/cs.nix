{
  pkgs,
  ...
}:
{
  plugins.lsp.servers.roslyn_ls.enable = true;
  
  # Enable easy-dotnet plugin for better .NET workflow
  plugins.easy-dotnet = {
    enable = true;
    settings = {
      # Auto bootstrap namespace when creating new files
      auto_bootstrap_namespace = true;
      
      # Test runner configuration
      test_runner = {
        enable_buffer_test_execution = true;
        viewmode = "float";
      };
    };
  };
  
  extraPackages = with pkgs; [
    netcoredbg
  ];

  extraConfigLua = ''
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
        name = "Launch .NET",
        request = "launch",
        program = function()
          -- This will use easy-dotnet's project picker if available
          return vim.fn.input("Path to dll: ", vim.fn.getcwd() .. "/bin/Debug/", "file")
        end,
      },
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
