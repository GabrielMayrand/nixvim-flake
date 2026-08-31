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

      local function get_web_root()
        local cwd = vim.fn.getcwd()
        if vim.fn.isdirectory(cwd .. "/Onyx.Web") == 1 then
          return cwd .. "/Onyx.Web"
        end
        return cwd
      end

      local chrome_exe = find_chrome_executable()

      local js_debug_configs = {
        {
          type = "pwa-chrome",
          request = "attach",
          name = "Attach to Chrome (port 9222)",
          port = 9222,
          timeout = 30000,
          webRoot = get_web_root,
          sourceMaps = true,
          sourceMapPathOverrides = {
            ["webpack-vue:///*"] = "''${webRoot}/*",
            ["webpack-vue:///./*"] = "''${webRoot}/*",
            ["webpack:///*"] = "''${webRoot}/*",
            ["webpack:///./*"] = "''${webRoot}/*",
            ["webpack:///Scripts/*"] = "''${webRoot}/Scripts/*",
          },
          skipFiles = { "<node_modules>/**" },
        },
        {
          type = "pwa-chrome",
          request = "attach",
          name = "Attach to Chrome (Custom Port)",
          port = function()
            local p = vim.fn.input("Chrome Remote Debug Port: ", "9222")
            return tonumber(p) or 9222
          end,
          timeout = 30000,
          webRoot = get_web_root,
          sourceMaps = true,
          sourceMapPathOverrides = {
            ["webpack-vue:///*"] = "''${webRoot}/*",
            ["webpack-vue:///./*"] = "''${webRoot}/*",
            ["webpack:///*"] = "''${webRoot}/*",
            ["webpack:///./*"] = "''${webRoot}/*",
            ["webpack:///Scripts/*"] = "''${webRoot}/Scripts/*",
          },
          skipFiles = { "<node_modules>/**" },
        },
        {
          type = "pwa-chrome",
          request = "launch",
          name = "Launch Chrome (Onyx.Web https://localhost:44355)",
          url = "https://localhost:44355",
          runtimeExecutable = chrome_exe,
          userDataDir = true,
          timeout = 30000,
          webRoot = get_web_root,
          sourceMaps = true,
          sourceMapPathOverrides = {
            ["webpack-vue:///*"] = "''${webRoot}/*",
            ["webpack-vue:///./*"] = "''${webRoot}/*",
            ["webpack:///*"] = "''${webRoot}/*",
            ["webpack:///./*"] = "''${webRoot}/*",
            ["webpack:///Scripts/*"] = "''${webRoot}/Scripts/*",
          },
          runtimeArgs = { "--ignore-certificate-errors" },
          skipFiles = { "<node_modules>/**" },
        },
        {
          type = "pwa-chrome",
          request = "launch",
          name = "Launch Chrome (Webpack Dev Server http://localhost:8086)",
          url = "http://localhost:8086",
          runtimeExecutable = chrome_exe,
          userDataDir = true,
          timeout = 30000,
          webRoot = get_web_root,
          sourceMaps = true,
          sourceMapPathOverrides = {
            ["webpack-vue:///*"] = "''${webRoot}/*",
            ["webpack-vue:///./*"] = "''${webRoot}/*",
            ["webpack:///*"] = "''${webRoot}/*",
            ["webpack:///./*"] = "''${webRoot}/*",
            ["webpack:///Scripts/*"] = "''${webRoot}/Scripts/*",
          },
          skipFiles = { "<node_modules>/**" },
        },
        {
          type = "pwa-chrome",
          request = "launch",
          name = "Launch Chrome (Custom URL)",
          url = function()
            return vim.fn.input("URL: ", "https://localhost:44355")
          end,
          runtimeExecutable = chrome_exe,
          userDataDir = true,
          timeout = 30000,
          webRoot = get_web_root,
          sourceMaps = true,
          sourceMapPathOverrides = {
            ["webpack-vue:///*"] = "''${webRoot}/*",
            ["webpack-vue:///./*"] = "''${webRoot}/*",
            ["webpack:///*"] = "''${webRoot}/*",
            ["webpack:///./*"] = "''${webRoot}/*",
            ["webpack:///Scripts/*"] = "''${webRoot}/Scripts/*",
          },
          runtimeArgs = { "--ignore-certificate-errors" },
          skipFiles = { "<node_modules>/**" },
        },
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
