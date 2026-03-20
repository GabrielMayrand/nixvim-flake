{
  # COMPLETION
  plugins.friendly-snippets.enable = true;

  plugins.luasnip = {
    enable = true;
    settings = {
      enable_autosnippets = true;
      store_selection_keys = "<Tab>";
    };
  };

  extraConfigLua = ''
    local ls = require("luasnip")
    local s = ls.snippet
    local t = ls.text_node
    local i = ls.insert_node
    local f = ls.function_node

    -- Function to get filename without extension
    local function get_filename()
      return function(_, snip)
        local filename = vim.fn.expand("%:t:r")
        return filename
      end
    end

    -- Function to auto-generate namespace from directory path
    local function get_namespace()
      return function(_, snip)
        local filepath = vim.fn.expand("%:p:h")
        
        -- Try to find a .csproj file in parent directories to determine project root
        local current_dir = filepath
        local max_depth = 10
        local depth = 0
        local project_root = nil
        
        while depth < max_depth do
          local csproj_files = vim.fn.glob(current_dir .. "/*.csproj", false, true)
          if #csproj_files > 0 then
            project_root = current_dir
            break
          end
          local parent = vim.fn.fnamemodify(current_dir, ":h")
          if parent == current_dir then
            break
          end
          current_dir = parent
          depth = depth + 1
        end
        
        -- If project root found, generate namespace from relative path
        if project_root then
          local relative_path = filepath:sub(#project_root + 2) -- +2 to skip the trailing slash
          if relative_path and relative_path ~= "" then
            -- Replace path separators with dots and capitalize first letter of each part
            local namespace = relative_path:gsub("/", ".")
            return namespace
          end
        end
        
        -- Fallback: use the last directory name
        local last_dir = vim.fn.fnamemodify(filepath, ":t")
        return last_dir
      end
    end

    -- Load friendly snippets
    require("luasnip.loaders.from_vscode").lazy_load()

    -- Add C# NUnit test class snippet
    ls.add_snippets("cs", {
      s("nunitsetup", {
        t({"using NUnit.Framework;", "", "namespace "}),
        f(get_namespace(), {}),
        t({"", "{", "    [TestFixture]", "    public class "}),
        f(get_filename(), {}),
        t({"", "    {", "        [SetUp]", "        public void Setup()", "        {", "            "}),
        i(1, "// Setup code here"),
        t({"", "        }", "", "        [Test]", "        public void "}),
        i(2, "TestMethodName"),
        t({"()", "        {", "            "}),
        i(0, "// Test code here"),
        t({"", "        }", "    }", "}"}),
      }),
      -- NUnit test method with Arrange-Act-Assert pattern and Given_When_Then naming
      s("nunit", {
        t({"[Test]", "public void Given_"}),
        i(1, "Condition"),
        t("_When_"),
        i(2, "Action"),
        t("_Then_"),
        i(3, "ExpectedResult"),
        t({"()", "{", "    // ARRANGE", "    "}),
        i(4, ""),
        t({"", "", "    // ACT", "    "}),
        i(5, ""),
        t({"", "", "    // ASSERT", "    "}),
        i(0, ""),
        t({"", "}"}),
      }),
    })

    -- Add TypeScript/JavaScript Jest test snippets
    local jest_snippets = {
      -- Full describe block with beforeEach
      s("jestdescribe", {
        t({'describe("'}),
        i(1, "ComponentName"),
        t({' Tests", () => {', "    beforeEach(() => {", "        "}),
        i(2, "// Setup code here"),
        t({"", "    });", "", "    it(\""}),
        i(3, "When condition, Then expected result"),
        t({'\", () => {', "        "}),
        i(0, "// Test code here"),
        t({"", "    });", "});"}),
      }),
      
      -- Single it test with Given-When-Then naming
      s("jest", {
        t({'it("Given '}),
        i(1, "condition"),
        t(", When "),
        i(2, "action"),
        t(", Then "),
        i(3, "expected result"),
        t({'\", () => {', "    "}),
        i(0, ""),
        t({"", "});"}),
      }),

      -- Vue component test with wrapper setup
      s("jestvue", {
        t({'it("'}),
        i(1, "test description"),
        t({'\", () => {', "    const wrapper = getWrapper("}),
        i(2, ""),
        t({");", "", "    "}),
        i(3, ""),
        t({"", "", "    expect("}),
        i(0, "wrapper.find(\"selector\")"),
        t({").toBe(expected);", "});"}),
      }),

      -- Jest mock setup
      s("jestmock", {
        t("jest.spyOn("),
        i(1, "ServiceName"),
        t(', "'),
        i(2, "methodName"),
        t('").mockResolvedValue('),
        i(0, "mockValue"),
        t(");"),
      }),

      -- Async test with Given-When-Then
      s("jestasync", {
        t({'it("Given '}),
        i(1, "condition"),
        t(", When "),
        i(2, "action"),
        t(", Then "),
        i(3, "expected result"),
        t({'\", async () => {', "    "}),
        i(4, ""),
        t({"", "", "    await "}),
        i(5, "asyncAction()"),
        t({"", "", "    expect("}),
        i(0, "result"),
        t({").toBe(expected);", "});"}),
      }),

      -- beforeEach block
      s("jestbefore", {
        t({"beforeEach(() => {", "    "}),
        i(0, "// Setup code"),
        t({"", "});"}),
      }),
    }

    -- Add the same snippets to all relevant filetypes
    ls.add_snippets("typescript", jest_snippets)
    ls.add_snippets("javascript", jest_snippets)
    ls.add_snippets("typescriptreact", jest_snippets)
    ls.add_snippets("javascriptreact", jest_snippets)
  '';

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
      snippets.preset = "luasnip";
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
