{ pkgs, ... }:
let
  easy-dotnet-nvim-latest = pkgs.vimUtils.buildVimPlugin {
    name = "easy-dotnet-nvim";
    src = pkgs.fetchFromGitHub {
      owner = "GustavEikaas";
      repo = "easy-dotnet.nvim";
      rev = "7765221c078267bad975fdca307776ecc01c69cc";
      hash = "sha256-x/NXqklLsCZraLzj6gUCTMPx54VWmEgPYIr5XfntAcE=";
    };
    nvimSkipModule = [
      "easy-dotnet.picker._telescope"
      "easy-dotnet.neotest"
      "easy-dotnet.neotest.run-queue"
      "easy-dotnet.neotest.run-context"
      "easy-dotnet.neotest.results"
      "easy-dotnet.neotest.stream"
      "easy-dotnet.neotest.strategy"
    ];
  };
in
{
  extraPackages = with pkgs; [
    dotnetCorePackages.sdk_10_0-bin
    netcoredbg
    roslyn-ls
  ];

  plugins.easy-dotnet = {
    enable = true;
    package = easy-dotnet-nvim-latest;
    settings = {
      lsp = {
        enabled = true;
        preload_roslyn = true;
      };

      debugger = {
        bin_path = "${pkgs.netcoredbg}/bin/netcoredbg";
        auto_register_dap = false;
      };

      test_runner = {
        neotest_integration = true;
      };

      picker = "telescope";
    };
  };

  plugins.neotest.adapters.dotnet.enable = false;

  extraConfigLuaPre = ''
    local _dotnet_bin = vim.fn.exepath("dotnet")
    if _dotnet_bin ~= "" then
      local _real = vim.uv.fs_realpath(_dotnet_bin) or _dotnet_bin
      vim.env.DOTNET_ROOT = vim.fn.fnamemodify(_real, ":h")
    end
  '';

  extraConfigLua = ''
    do
      local dap = require("dap")
      dap.adapters["easy-dotnet"] = function(callback, config)
        if not config.port then
          vim.notify("easy-dotnet: debugger failed to start (no port)", vim.log.levels.ERROR)
          return
        end
        callback({ type = "server", host = "127.0.0.1", port = config.port })
      end
      dap.configurations["cs"] = dap.configurations["cs"] or {}
      local _has_easy_dotnet = false
      for _, c in ipairs(dap.configurations["cs"]) do
        if c.type == "easy-dotnet" then _has_easy_dotnet = true; break end
      end
      if not _has_easy_dotnet then
        table.insert(dap.configurations["cs"], {
          type    = "easy-dotnet",
          name    = "easy-dotnet",
          request = "attach",
          port = function()
            vim.schedule(function() vim.cmd("Dotnet debug profile") end)
            return dap.ABORT
          end,
        })
      end
    end

    vim.api.nvim_create_autocmd("VimEnter", {
      once = true,
      callback = function()
        vim.defer_fn(function()
          local ok, nio = pcall(require, "nio")
          if not ok then return end
          nio.run(function()
            local ok2, adapter = pcall(require, "easy-dotnet.neotest")
            if not ok2 then return end
            adapter.is_test_file("/tmp/_neotest_warmup_.cs")
          end)
        end, 3000)
      end,
    })
  '';
}
