{ ... }:
{
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

    # coreclr adapter and C# launch config are registered by easy-dotnet
    # via extraConfigLua in cs.nix (after nixvim's dap module overwrites adapters).
  };
  plugins.dap-ui = {
    enable = true;
    # mappings = {
    #     toggle = "<leader> dt";
    # };
  };
  plugins.dap-virtual-text.enable = true;
}
