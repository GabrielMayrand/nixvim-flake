{ pkgs, ... }:
{
  extraPackages = with pkgs; [
    prettierd
    prettier
  ];

  plugins.lsp.servers = {
    ts_ls = {
      enable = true;
      settings = {
        typescript = {
          tsserver = {
            useSyntaxServer = false;
          };
          inlayHints = {
            includeInlayParameterNameHints = "all";
            includeInlayParameterNameHintsWhenArgumentMatchesName = true;
            includeInlayFunctionParameterTypeHints = true;
            includeInlayVariableTypeHints = true;
            includeInlayVariableTypeHintsWhenTypeMatchesName = true;
            includeInlayPropertyDeclarationTypeHints = true;
            includeInlayFunctionLikeReturnTypeHints = true;
            includeInlayEnumMemberValueHints = true;
          };
        };
      };
    };

    volar = {
      enable = true;
    };

    eslint = {
      enable = true;
      filetypes = [
        "vue"
        "ts"
        "js"
        "typescript"
        "javascript"
      ];
    };
  };

  extraConfigLua = ''
    do
      local dap = require("dap")
      local js_debug_cmd = "${pkgs.vscode-js-debug}/bin/js-debug"

      local function get_web_root()
        local cwd = vim.fn.getcwd()
        if vim.fn.isdirectory(cwd .. "/Onyx.Web") == 1 then
          return cwd .. "/Onyx.Web"
        end
        return cwd
      end

      local function enrich_vue_config(config, on_config)
        local enriched = vim.deepcopy(config)
        local web_root = get_web_root()
        local file = vim.fn.expand("%:p")
        local prefix = web_root .. "/"

        if vim.startswith(file, prefix) and file:sub(-4) == ".vue" then
          local relative = file:sub(#prefix + 1)
          local directory = vim.fn.fnamemodify(relative, ":h")
          local name = vim.fn.fnamemodify(relative, ":t")
          local generated = (directory == "." and "" or directory .. "/") .. "generated-" .. name
          enriched.sourceMapPathOverrides = vim.deepcopy(enriched.sourceMapPathOverrides or {})
          enriched.sourceMapPathOverrides["webpack-generated:///./" .. generated .. "?*"] =
            "''${webRoot}/" .. relative
        end

        on_config(enriched)
      end

      for _, adapter in ipairs({ "pwa-node", "pwa-chrome", "pwa-msedge", "node-terminal" }) do
        dap.adapters[adapter] = {
          type = "server",
          host = "127.0.0.1",
          port = "''${port}",
          executable = {
            command = js_debug_cmd,
            args = { "''${port}" },
          },
          options = {
            initialize_timeout_sec = 30,
          },
          enrich_config = enrich_vue_config,
        }
      end

      local function find_chrome_executable()
        local candidates = {
          "/mnt/c/Program Files/Google/Chrome/Application/chrome.exe",
          "/mnt/c/Program Files (x86)/Microsoft/Edge/Application/msedge.exe",
          "google-chrome",
          "google-chrome-stable",
          "chromium",
          "chromium-browser",
        }
        for _, path in ipairs(candidates) do
          if vim.fn.executable(path) == 1 or vim.fn.filereadable(path) == 1 then
            return path
          end
        end
        return nil
      end

      local chrome_exe = find_chrome_executable()

      local chrome_defaults = {
        type = "pwa-chrome",
        address = "127.0.0.1",
        timeout = 30000,
        webRoot = get_web_root,
        sourceMaps = true,
        sourceMapPathOverrides = {
          ["vite:///*"] = "''${webRoot}/*",
          ["webpack-vue:///*"] = "''${webRoot}/*",
          ["webpack-vue:///./*"] = "''${webRoot}/*",
          ["webpack:///*"] = "''${webRoot}/*",
          ["webpack:///./*"] = "''${webRoot}/*",
          ["webpack:///Scripts/*"] = "''${webRoot}/Scripts/*",
        },
        skipFiles = { "<node_modules>/**" },
      }

      local function chrome_config(fields)
        return vim.tbl_extend("force", vim.deepcopy(chrome_defaults), fields)
      end

      local js_debug_configs = {
        chrome_config({
          request = "attach",
          name = "Attach to Chrome (port 9222)",
          port = 9222,
        }),
        chrome_config({
          request = "attach",
          name = "Attach to Chrome (Custom Port)",
          port = function()
            local p = vim.fn.input("Chrome Remote Debug Port: ", "9222")
            return tonumber(p) or 9222
          end,
        }),
        chrome_config({
          request = "launch",
          name = "Launch Chrome (Onyx.Web https://localhost:44355)",
          url = "https://localhost:44355",
          runtimeExecutable = chrome_exe,
          userDataDir = true,
          runtimeArgs = { "--ignore-certificate-errors" },
        }),
        chrome_config({
          request = "launch",
          name = "Launch Chrome (Webpack Dev Server http://localhost:8086)",
          url = "http://localhost:8086",
          runtimeExecutable = chrome_exe,
          userDataDir = true,
        }),
        chrome_config({
          request = "launch",
          name = "Launch Chrome (Custom URL)",
          url = function()
            return vim.fn.input("URL: ", "https://localhost:44355")
          end,
          runtimeExecutable = chrome_exe,
          userDataDir = true,
          runtimeArgs = { "--ignore-certificate-errors" },
        }),
        {
          type = "pwa-node",
          request = "launch",
          name = "Launch Current File (Node)",
          program = "''${file}",
          cwd = "''${workspaceFolder}",
          skipFiles = { "<node_modules>/**" },
        },
        {
          type = "pwa-node",
          request = "attach",
          name = "Attach to Node Process",
          processId = require("dap.utils").pick_process,
          cwd = "''${workspaceFolder}",
          skipFiles = { "<node_modules>/**" },
        },
      }

      for _, lang in ipairs({ "typescript", "javascript", "typescriptreact", "javascriptreact", "vue" }) do
        dap.configurations[lang] = js_debug_configs
      end
    end
  '';

  plugins.neotest.adapters = {
    jest.enable = true;
    plenary.enable = true;
  };
}
