{ ... }: {
  plugins.neotest = {
    enable = true;
    # Use easy-dotnet's built-in neotest adapter instead of the standalone
    # neotest-dotnet package. It reuses the easy-dotnet-server test runner
    # state so no extra discovery step is needed.
    settings = {
      adapters = [
        { __raw = ''require("easy-dotnet.neotest")''; }
      ];

      # Disable background tree scanning on buffer open.
      # The .NET testrunner/initialize RPC call (which indexes the full solution)
      # is expensive for large solutions like Onyx. With auto-discovery off, the
      # cost is deferred until the user explicitly runs or navigates to a test.
      discovery = {
        enabled = false;

        filter_dir = {
          __raw = ''
            function(name, rel_path, _root)
              local ignored = {
                bin = true,
                obj = true,
                node_modules = true,
                [".git"] = true,
                [".vs"] = true,
                [".idea"] = true,
                [".nuget"] = true,
                [".vscode"] = true,
                DockerFiles = true,
                Setup = true,
                NUnitAddins = true,
                result = true,
              }
              if ignored[name] then return false end

              -- Allow frontend test container directory
              if name == "Onyx.Web" then return true end

              -- If already within a test directory, explore all child directories
              local rel = rel_path or ""
              if rel:lower():find("test") then return true end

              -- Top-level directories must contain 'test'
              if name:lower():find("test") then return true end

              -- Reject non-test source folders
              return false
            end
          '';
        };
      };
    };
  };
}
