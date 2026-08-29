# AGENTS.md

## What this repo is

A standalone Nix flake producing a fully-configured Neovim via [nixvim](https://github.com/nix-community/nixvim). Targets Vue/TS, Rust, Nix, and C#/.NET.
[Documentation](https://nix-community.github.io/nixvim/)

## Key commands

| Command | Purpose |
|---|---|
| `nix run .` | Launch the configured Neovim (primary test workflow) |
| `nix build .` | Build the package; creates `./result` symlink |
| `nix flake check .` | Validate config without launching the editor |
| `nix flake update` | Update `flake.lock` to latest inputs |

There is no CI, no Makefile, no test suite beyond `nix flake check`.

## Repo structure

```
flake.nix          # Inputs, outputs, perSystem wiring via flake-parts
flake.lock
config/
  default.nix      # Root module — imports all config/*.nix
  lang/
    default.nix    # Imports all lang/*.nix
    cs.nix         # C#/.NET: roslyn_ls, netcoredbg, dotnet SDK 10, easy-dotnet
    nix.nix        # Nix: nixd LSP, nixfmt
    rust.nix       # Rust: rustaceanvim, crates.nvim, rustfmt, nextest
    vue.nix        # Vue/TS/JS: ts_ls, eslint, prettierd, pwa-node DAP, Jest
  lsp.nix          # Core LSP config, lspsaga, lint
  keymaps.nix      # All global keybindings
  completion.nix   # blink-cmp + LuaSnip (custom C# and JS/TS snippet generators)
  dap.nix          # DAP + UI + virtual text
  ...              # Other feature modules (one concern per file)
```

## When adding a new file

Add a new `config/foo.nix` → also add it to `config/default.nix` imports.  
Add a new language file under `config/lang/` → add it to `config/lang/default.nix`.

## Nixvim patterns to know

- Enable plugins: `plugins.<name>.enable = true;`
- Enable LSP servers: `plugins.lsp.servers.<name>.enable = true;`
- Inject system binaries into Neovim's PATH: `extraPackages = with pkgs; [ ... ];`
- Raw Lua after setup: `extraConfigLua = ''...'';`
- Raw Lua before setup: `extraConfigLuaPre = ''...'';`
- Embed raw Lua inside Nix attribute sets: `__raw = ''...'';`

## Flake inputs

- `nixpkgs` → `nixpkgs-unstable`
- `nixvim` → nix-community/nixvim
- `flake-parts` → hercules-ci/flake-parts (provides `perSystem`)

Supported systems: `x86_64-linux`, `aarch64-linux`, `x86_64-darwin`, `aarch64-darwin`.

## Editor conventions (useful when editing keymaps or features)

- Leader key: `<Space>`
- Clipboard: system via `xclip`, `unnamedplus` register
- Format-on-save via conform-nvim; toggle with `:FormatToggle`
- Formatters: `rustfmt`, `nixfmt`, `prettierd`/`prettier`
