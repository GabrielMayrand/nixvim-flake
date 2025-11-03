{
  # TREESITTER
  plugins.treesitter = {
    enable = true;
    settings = {
      auto_install = true;
      ensure_installed = [
        "c"
        "lua"
        "vim"
        "vimdoc"
        "query"
        "markdown"
        "markdown_inline"
        "javascript"
        "typescript"
        "vue"
        "nix"
        "c_sharp"
        "rust"
      ];
    };

  };
}
