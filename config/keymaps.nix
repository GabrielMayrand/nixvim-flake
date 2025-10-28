{
    keymaps = [
        # BUFFERS CONTROLS
        {
            action = "<cmd>bnext<CR>";
            key = "<leader>bn";
        }
        {
            action = "<cmd>bprevious<CR>";
            key = "<leader>bp";
        }
        # Bufdelete
        {
            action = "<cmd>Bdelete<CR>";
            key = "<leader>bd";
        }
        {
            action = "<cmd>Bwipeout<CR>";
            key = "<leader>bw";
        }
        # NEOTREE
        {
            action = "<cmd>Neotree buffers toggle float<CR>";
            key = "<leader>eb";
        }
        {
            action = "<cmd>Neotree filesystem toggle float<CR>";
            key = "<leader>ef";
        }
        {
            action = "<cmd>Neotree git_status toggle float<CR>";
            key = "<leader>eg";
        }
        # UNDOTREE
        {
            action = "<cmd>UndotreeToggle<CR>";
            key = "<leader>eu";
        }
        # SESSIONS
        {
            action = "<cmd>SessionSave<CR>";
            key = "<leader>ss";
        }
        {
            action = "<cmd>SessionSearch<CR>";
            key = "<leader>sf";
        }
        {
            action = "<cmd>SessionToggleAutoSave<CR>";
            key = "<leader>sA";
        }
        {
            action = "<cmd>SessionRestore<CR>";
            key = "<leader>sr";
        }
        # LAZYGIT
        {
            action = "<cmd>LazyGit<CR>";
            key = "<leader>gg";
        }
        # NEOTEST
        {
            key = "<leader>tt";
            action = "<cmd>lua require('neotest').run.run()<cr>";
            mode = "n";
            options.desc = "Run nearest test";
        }
        {
            key = "<leader>tf";
            action = "<cmd>lua require('neotest').run.run(vim.fn.expand('%'))<cr>";
            mode = "n";
            options.desc = "Run test file";
        }
        {
            key = "<leader>td";
            action = "<cmd>lua require('neotest').run.run({strategy = 'dap'})<cr>";
            mode = "n";
            options.desc = "Debug nearest test";
        }
        {
            key = "<leader>to";
            action = "<cmd>Neotest output-panel<cr>";
            mode = "n";
            options.desc = "Neotest output";
        }
        {
            key = "<leader>tS";
            action = "<cmd>Neotest summary<cr>";
            mode = "n";
            options.desc = "Neotest summary";
        }
        {
            key = "<leader>ts";
            action = "<cmd>Neotest stop<cr>";
            mode = "n";
            options.desc = "Neotest stop";
        }
        # DAP
        {
            key = "<leader>db";
            action = "<cmd>DapToggleBreakpoint<cr>";
            mode = "n";
            options.desc = "Toggle Breakpoint";
        }
        {
            key = "<leader>dc";
            action = "<cmd>DapContinue<cr>";
            mode = "n";
            options.desc = "Debug Continue";
        }
        {
            key = "<F1>";
            action = "lua require('dapui').continue()";
            mode = "n";
            options.desc = "Debug Continue";
        }
        {
            key = "<leader>di";
            action = "<cmd>DapStepInto<cr>";
            mode = "n";
            options.desc = "Debug Step Into";
        }
        {
            key = "<leader>do";
            action = "<cmd>DapStepOut<cr>";
            mode = "n";
            options.desc = "Debug Step Out";
        }
        {
            key = "<leader>dO";
            action = "<cmd>DapStepOver<cr>";
            mode = "n";
            options.desc = "Debug Step Over";
        }
        { 
            mode = "n";
            key = "<leader>du";
            action = "<cmd>lua require('dapui').toggle()<cr>";
            options = {
                silent = true;
                desc = "DAP UI";
            };
        }                
        {
            mode = "n";
            key = "<leader>ds";
            action = "<cmd>lua require('dap').session()<cr>";
            options = {
                silent = true;
                desc = "Debugger Session";
            };
        }                
        {
            mode = "n";
            key = "<leader>dr";
            action = "<cmd>lua require('dap').run_to_cursor()<cr>";
            options = {
                silent = true;
                desc = "Debug at cursor";
            };
        }                
        # UI
        {
            key = "<leader>us";
            action = "<cmd> set laststatus=0 <CR>";
            mode = "n";
            options.desc = "Disable status line nvim";
        }
        {
            key = "<leader>uw";
            action = "<cmd> set wrap <CR>";
            mode = "n";
            options.desc = "Enable wrap";
        }
        {
            key = "<leader>uW";
            action = "<cmd> set nowrap! <CR>";
            mode = "n";
            options.desc = "Disable wrap";
        }
        {
            key = "<leader>gl";
            action = "<cmd> GitBlameToggle <CR>";
            mode = "n";
        }
        {
            key = "<c-k>";
            action = "<cmd>wincmd k<CR>";
            mode = "n";
        }
        {
            key = "<c-j>";
            action = "<cmd>wincmd j<CR>";
            mode = "n";
        }
        {
            key = "<c-h>";
            action = "<cmd>wincmd h<CR>";
            mode = "n";
        }
        {
            key = "<c-l>";
            action = "<cmd>wincmd l<CR>";
            mode = "n";
        }
        {
            key = "<c-q>";
            action = "<cmd>wincmd q<CR>";
            mode = "n";
        }
        {
            key = "<M-h>";
            action = "<cmd>wincmd < <CR>";
            mode = "n";
        }
        {
            key = "<M-l>";
            action = "<cmd>wincmd > <CR>";
            mode = "n";
        }
        {
            key = "<M-j>";
            action = "<cmd>wincmd - <CR>";
            mode = "n";
        }
        {
            key = "<M-k>";
            action = "<cmd>wincmd + <CR>";
            mode = "n";
        }
        # LSP
        {
            key = "<leader>lr";
            action = "<cmd>Telescope lsp_references<CR>";
            mode = "n";
            options.desc = "LSP References";
        }
        {
            key = "<leader>lf";
            action = "<cmd>Lspsaga finder<CR>";
            mode = "n";
            options.desc = "LSP Finder";
        }
        {
            key = "<leader>lp";
            action = "<cmd>Lspsaga peek_definition<CR>";
            mode = "n";
            options.desc = "LSP Peek Definition";
        }
        {
            key = "<leader>lP";
            action = "<cmd>Lspsaga peek_type_definition<CR>";
            mode = "n";
            options.desc = "LSP Peek Type Definition";
        }
        {
            key = "gr";
            action = "<cmd>Telescope lsp_references<CR>";
            mode = "n";
            options.desc = "LSP References";
        }
        {
            key = "<leader>la";
            action = "<cmd>Lspsaga code_action<CR>";
            mode = "n";
            options.desc = "LSP Actions";
        }
        {
            key = "ga";
            action = "<cmd>Lspsaga code_action<CR>";
            mode = "n";
            options.desc = "LSP Actions";
        }
        {
            key = "<leader>lk";
            action = "<cmd>Lspsaga hover_doc<CR>";
            mode = "n";
            options.desc = "LSP Hover Info";
        }
        {
            key = "<leader>r";
            action = "<cmd>Lspsaga rename<CR>";
            mode = "n";
            options.desc = "LSP Rename";
        }
        {
            key = "<leader>ld";
            action = "<cmd>Telescope lsp_definitions<CR>";
            mode = "n";
            options.desc = "LSP Definition";
        }
        {
            key = "gd";
            action = "<cmd>Telescope lsp_definitions<CR>";
            mode = "n";
            options.desc = "LSP Definition";
        }
        {
            key = "<leader>lD";
            action = "<cmd>Telescope lsp_type_definitions<CR>";
            mode = "n";
            options.desc = "LSP Type Definition";
        }
        {
            key = "gD";
            action = "<cmd>Telescope lsp_type_definitions<CR>";
            mode = "n";
            options.desc = "LSP Type Definition";
        }
        {
            key = "<leader>lo";
            action = "<cmd>Lspsaga outline<CR>";
            mode = "n";
            options.desc = "LSP Outline";
        }
        {
            key = "<leader>eo";
            action = "<cmd>Lspsaga outline<CR>";
            mode = "n";
            options.desc = "LSP Outline";
        }
        {
            key = "<leader>lss";
            action = "<cmd>Lspsaga show_line_diagnostics<CR>";
            mode = "n";
            options.desc = "LSP Inline Diagnostics";
        }
        {
            key = "<leader>lsn";
            action = "<cmd>Lspsaga diagnostic_jump_next<CR>";
            mode = "n";
            options.desc = "LSP Diagnostic Next";
        }
        {
            key = "<leader>lsp";
            action = "<cmd>Lspsaga diagnostic_jump_prev<CR>";
            mode = "n";
            options.desc = "LSP Diagnostic Next";
        }
        {
            key = "<leader>lsw";
            action = "<cmd>Lspsaga show_workspace_diagnostics<CR>";
            mode = "n";
            options.desc = "LSP Workspace Diagnostics";
        }
        {
            key = "<leader>lsb";
            action = "<cmd>Lspsaga show_buf_diagnostics<CR>";
            mode = "n";
            options.desc = "LSP Buffers Diagnostics";
        }
        {
            key = "<leader>lsc";
            action = "<cmd>Lspsaga show_cursor_diagnostics<CR>";
            mode = "n";
            options.desc = "LSP Cursor Diagnostics";
        }
    ];

}
