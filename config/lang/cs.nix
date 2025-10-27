{ pkgs, ... } :
{
    plugins.lsp.servers.roslyn_ls.enable = true;
    extraPlugins = [ 
        { 
            plugin = (pkgs.vimUtils.buildVimPlugin {
                name = "dap-cs";
                src = pkgs.fetchFromGitHub {
                    owner = "NicholasMata";
                    repo = "nvim-dap-cs";
                    rev = "main";
                    hash = "sha256-htcBYnT/ScFxe/TKtXJMmDjEz2I3ZEDgud7jEsOqsNE=";
                };
            });
            config = '' lua require("dap-cs").setup() '';

        }            
    ];
    plugins.neotest.adapters = {
        dotnet.enable = true;
    };
}
