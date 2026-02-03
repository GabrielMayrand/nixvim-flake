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
    local dap_utils = require("dap.utils")

    dap.adapters.coreclr = {
      type = "executable",
      command = "netcoredbg",
      args = { "--interpreter=vscode" },
      -- Uncomment the line below to enable verbose logging for debugging
      -- args = { "--interpreter=vscode", "--log=/tmp/netcoredbg.log" },
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
        -- Ensure breakpoints are set after attaching
        justMyCode = false,
        -- Add source file path mappings if needed
        sourceFileMap = {
          ["/"] = vim.fn.getcwd(),
        },
      },
    }

    -- Auto-open dapui when debugging starts
    local dapui = require("dapui")
    dap.listeners.after.event_initialized["dapui_config"] = function()
      dapui.open()
    end

    -- Log when breakpoints are set
    dap.listeners.after.event_breakpoint["log_breakpoint"] = function(session, body)
      if body.reason == "changed" and body.breakpoint then
        local bp = body.breakpoint
        if bp.verified then
          vim.notify("Breakpoint verified at line " .. (bp.line or "?"), vim.log.levels.INFO)
        else
          vim.notify("Breakpoint NOT verified: " .. (bp.message or "unknown reason"), vim.log.levels.WARN)
        end
      end
    end
  '';

}
