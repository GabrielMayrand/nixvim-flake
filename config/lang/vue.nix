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
    plenary.enable = true;
  };
}
