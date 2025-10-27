{
    # LSP
    plugins.lsp = {
        enable = true;
        keymaps.lspBuf = {
            "K" = "hover";
            "gr" = "references";
            # "gd" = "definition";
            "gi" = "implementation";
            # "gt" = "type_definition";
        };
    };

    plugins.lspsaga = {
        enable = true;
        settings.outline.closeAfterJump = true;
        settings.lightbulb.sign = false;
    };

    plugins.lsp-status.enable = true;
    plugins.lint.enable = true;
    # plugins.lsp-format.enable = true;
    plugins.lsp-lines.enable = true;
}
