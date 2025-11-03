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
  };
  plugins.dap-ui = {
    enable = true;
    # mappings = {
    #     toggle = "<leader> dt";
    # };
  };
  plugins.dap-virtual-text.enable = true;
}
