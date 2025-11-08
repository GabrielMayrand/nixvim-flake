{
  plugins.mini.enable = true;
  plugins.mini-pairs.enable = true;
  plugins.mini-comment = {
    enable = true;
    settings = {
      mappings = {
        comment = "gc";
        # comment_line = "gcc";
        comment_visual = "gc";
        textobject = "gc";
      };
    };
  };
  plugins.mini-statusline = {
    enable = true;
    settings = {
      use_icons = true;
    };
  };
  plugins.mini-surround = {
    enable = true;
  };
}
