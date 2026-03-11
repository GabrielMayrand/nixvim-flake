{pkgs, ...}: {
  plugins.neotest = {
    enable = true;
    adapters.dotnet = {
      enable = true;
      settings = {
        dap = {
          adapter_name = "coreclr";
          args = { justMyCode = false; };
        };
        discovery_root = "solution";
      };
    };
  };
}
