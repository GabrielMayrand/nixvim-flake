{ pkgs, ... }:
{

  extraPackages = with pkgs; [
    ripgrep
    zig
  ];
  # TELESCOPE
  plugins.telescope.enable = true;
  plugins.telescope.keymaps = {
    # Git
    "<leader>gt" = "git_status";
    "<leader>gs" = "git_stash";
    "<leader>gb" = "git_branches";
    "<leader>gc" = "git_commits";
    "<leader>gf" = "git_files";
    # Buffers
    "<C-f>" = "current_buffer_fuzzy_find";
    "<leader>fb" = "buffers";
    "<leader>fw" = "live_grep";
    # Files
    "<leader>ff" = "find_files";
    # Keymaps
    "<leader>fk" = "keymaps";
    # Commands
    "<leader>fch" = "command_history";
    "<leader>fco" = "commands";
    # Depends on plugin neoclip
    "<leader>fcc" = "neoclip"; # Clipboard history
    "<leader>fm" = "macroscope"; # Macro History
  };
}
