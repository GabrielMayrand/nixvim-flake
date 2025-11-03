{ pkgs, ... }:
{
  extraPackages = with pkgs; [
    typescript-language-server
    prettierd
    prettier
  ];

  extraConfigLua = ''
    local cwd = vim.fn.getcwd()
    local capabilities = require('blink.cmp').get_lsp_capabilities()
    vim.lsp.config("ts_ls", {
        capabilities = capabilities,
        init_options = {
          plugins = {
            {
              name = "@vue/typescript-plugin",
              location = cwd .. "/node_modules/@vue/language-server",
              languages = { "vue" }
            }
          }
        },
        settings = {
          typescript = {
            tsserver = {
              useSyntaxServer = false
            },
            inlayHints = {
              includeInlayParameterNameHints = 'all',
              includeInlayParameterNameHintsWhenArgumentMatchesName = true,
              includeInlayFunctionParameterTypeHints = true,
              includeInlayVariableTypeHints = true,
              includeInlayVariableTypeHintsWhenTypeMatchesName = true,
              includeInlayPropertyDeclarationTypeHints = true,
              includeInlayFunctionLikeReturnTypeHints = true,
              includeInlayEnumMemberValueHints = true
            }
          }
        },
        filetypes = { "typescript", "javascript", "javascriptreact", "typescriptreact", "vue" }
    })
    vim.lsp.enable({"ts_ls"})
  '';

  plugins.lsp.servers.eslint.enable = true;

  plugins.dap.adapters.servers = {
    "pwa-node" = {
      host = "localhost";
      port = 8123;
      executable = {
        command = "${pkgs.vscode-js-debug}/bin/js-debug";
      };
    };
  };
  plugins.dap.configurations = {
    typescript = [
      {
        type = "pwa-node";
        request = "launch";
        name = "launch - typescript";
      }
    ];
  };

  plugins.neotest.adapters = {
    jest.enable = true;
  };

  plugins.neotest.adapters = {
    plenary.enable = true;
  };
}
