{ pkgs, ... }:
{
  # DAP
  plugins.dap = {
    enable = true;

    signs = {
      dapBreakpoint = {
        text = "●";
        texthl = "DapBreakpoint";
      };
      dapBreakpointCondition = {
        text = "●";
        texthl = "DapBreakpointCondition";
      };
      dapLogPoint = {
        text = "◆";
        texthl = "DapLogPoint";
      };
    };

    adapters.executables.coreclr = {
      command = "${pkgs.netcoredbg}/bin/netcoredbg";
      args = [ "--interpreter=vscode" ];
    };

    configurations = {
      cs = [
        {
          type = "coreclr";
          name = "launch - netcoredbg";
          request = "launch";
          program.__raw = ''
            function()
              return vim.fn.input('Path to dll: ', vim.fn.getcwd() .. '/bin/Debug/', 'file')
            end
          '';
          cwd = "\${workspaceFolder}";
        }
      ];
    };
  };
  plugins.dap-ui = {
    enable = true;
    # mappings = {
    #     toggle = "<leader> dt";
    # };
  };
  plugins.dap-virtual-text.enable = true;
}
