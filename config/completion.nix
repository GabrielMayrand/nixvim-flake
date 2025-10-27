{
    # COMPLETION
    plugins.friendly-snippets.enable = true;
    plugins.blink-cmp = {
        enable = true;
        settings = {
            appearance = {
                use_nvim_cmp_as_default = true;
                nerd_font_variant = "mono";
            };
            keymap = {
                preset = "default";
            };
            sources.default = [
                "lsp"
                "path"
                "snippets"
                "buffer"
            ];
            signature.enabled = true;
        };
    };
}
