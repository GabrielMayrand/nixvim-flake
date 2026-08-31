{
  # CLIPBOARD : Sync with system clipboard (supports local X11/Wayland and remote SSH via OSC 52)
  clipboard.register = "unnamedplus";
  clipboard.providers.wl-copy.enable = true;
  clipboard.providers.xclip.enable = true;

  extraConfigLua = ''
    -- Enable OSC 52 clipboard over SSH, inside Tmux, or when no graphical display server is detected
    local is_ssh = vim.env.SSH_CONNECTION ~= nil or vim.env.SSH_CLIENT ~= nil or vim.env.SSH_TTY ~= nil
    local is_tmux = vim.env.TMUX ~= nil
    local has_display = vim.env.DISPLAY ~= nil or vim.env.WAYLAND_DISPLAY ~= nil

    if is_ssh or is_tmux or not has_display then
      vim.g.clipboard = {
        name = "OSC 52",
        copy = {
          ["+"] = require("vim.ui.clipboard.osc52").copy("+"),
          ["*"] = require("vim.ui.clipboard.osc52").copy("*"),
        },
        paste = {
          ["+"] = function()
            return {
              vim.fn.split(vim.fn.getreg(""), "\n"),
              vim.fn.getregtype(""),
            }
          end,
          ["*"] = function()
            return {
              vim.fn.split(vim.fn.getreg(""), "\n"),
              vim.fn.getregtype(""),
            }
          end,
        },
      }
    end
  '';
}
