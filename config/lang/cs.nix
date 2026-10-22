{ pkgs, ... }:
let
  dotnet-sdk = pkgs.dotnetCorePackages.sdk_10_0-bin;
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
    local _data_dir = vim.fn.stdpath("data") .. "/easy-dotnet"
    pcall(vim.fn.mkdir, _data_dir, "p")
    -- Nix's dotnet executable is a wrapper; its parent is not the runtime root.
    vim.env.DOTNET_ROOT = "${dotnet-sdk}/share/dotnet"
    vim.env.DOTNET_ROOT_X64 = vim.env.DOTNET_ROOT
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
        local solution = require("easy-dotnet.current_solution")
        if not solution.try_get_selected_solution() then
          local candidates = vim.fs.find("Onyx.sln", {
            path = vim.fn.getcwd(),
            upward = true,
            type = "file",
          })
          if #candidates == 1 then pcall(solution.set_solution, candidates[1]) end
        end

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

    local function _visual_selection()
      local s = vim.fn.getpos("'<")
      local e = vim.fn.getpos("'>")
      if s[2] == 0 or e[2] == 0 then return nil end

      local lines = vim.fn.getline(s[2], e[2])
      if type(lines) ~= "table" or #lines == 0 then return nil end

      if #lines == 1 then
        return string.sub(lines[1], s[3], e[3])
      end
      lines[1] = string.sub(lines[1], s[3])
      lines[#lines] = string.sub(lines[#lines], 1, e[3])
      return table.concat(lines, "\n")
    end

    local function _onyx_solution_dir()
      local found = vim.fs.find("Onyx.sln", {
        path = vim.fn.getcwd(),
        upward = true,
        type = "file",
      })
      if #found > 0 then return vim.fs.dirname(found[1]) end
      return vim.fn.getcwd()
    end

    function _G.dotnet_test_filter(visual)
      local selection
      if visual then
        selection = _visual_selection()
      else
        selection = vim.fn.expand("<cword>")
      end
      selection = vim.trim(selection or "")
      if selection == "" then
        vim.notify("dotnet test: nothing selected", vim.log.levels.WARN)
        return
      end

      local filter = "FullyQualifiedName~" .. selection
      local cmd = string.format(
        "cd %s && dotnet test Onyx.sln --filter %s",
        vim.fn.shellescape(_onyx_solution_dir()),
        vim.fn.shellescape(filter)
      )

      vim.cmd("botright split")
      vim.cmd("terminal " .. cmd)
      vim.cmd("startinsert")
    end

    vim.api.nvim_create_user_command("DotnetTestFilter", function()
      _G.dotnet_test_filter(false)
    end, { desc = "Run dotnet test filtered by the word under the cursor" })
  '';
}
