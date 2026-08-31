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

    -- Vue 3 Composition API & SFC snippets
    local vue_snippets = {
      -- Full Vue 3 SFC with script setup (TypeScript) and scoped SCSS
      s("vbase", {
        t({"<template>", "    <div class=\""}),
        i(1, "component-name"),
        t({"\"", ">", "        "}),
        i(0),
        t({"", "    </div>", "</template>", "", "<script lang=\"ts\" setup>", "    "}),
        i(2, "// imports and logic"),
        t({"", "</script>", "", "<style scoped lang=\"scss\">", "."}),
        f(function(args) return args[1][1] or "" end, {1}),
        t({" {", "    ", "}", ""}),
      }),

      -- Minimal Vue 3 SFC with script setup
      s("vbase-ts", {
        t({"<template>", "    <div>", "        "}),
        i(0),
        t({"", "    </div>", "</template>", "", "<script lang=\"ts\" setup>", "    "}),
        i(1),
        t({"", "</script>", ""}),
      }),

      -- defineProps (typed)
      s("vprops", {
        t("const props = defineProps<{"),
        t({"", "    "}),
        i(1, "propName: string"),
        t({"", "}>();"}),
      }),

      -- withDefaults defineProps
      s("vpropsdef", {
        t("const props = withDefaults("),
        t({"", "    defineProps<{"}),
        t({"", "        "}),
        i(1, "propName?: string;"),
        t({"", "    }>(),", "    {"}),
        t({"", "        "}),
        i(2, "propName: \"defaultValue\""),
        t({"", "    }", ");"}),
      }),

      -- defineEmits (typed Vue 3.3+)
      s("vemits", {
        t("const emit = defineEmits<{"),
        t({"", "    "}),
        i(1, "eventName: [payload: any];"),
        t({"", "}>();"}),
      }),

      -- defineModel (Vue 3.4+)
      s("vmodel", {
        t("const "),
        i(1, "modelValue"),
        t(" = defineModel<"),
        i(2, "string"),
        t(">("),
        i(3),
        t(");"),
      }),

      -- ref
      s("vref", {
        t("const "),
        i(1, "state"),
        t(" = ref<"),
        i(2, "boolean"),
        t(">("),
        i(3, "false"),
        t(");"),
      }),

      -- reactive
      s("vreactive", {
        t("const "),
        i(1, "state"),
        t(" = reactive<"),
        i(2, "object"),
        t(">({"),
        t({"", "    "}),
        i(0),
        t({"", "});"}),
      }),

      -- computed
      s("vcomputed", {
        t("const "),
        i(1, "computedValue"),
        t(" = computed(() => {"),
        t({"", "    return "}),
        i(0),
        t({"", "});"}),
      }),

      -- watch
      s("vwatch", {
        t("watch("),
        i(1, "source"),
        t({", (newVal, oldVal) => {", "    "}),
        i(0),
        t({"", "});"}),
      }),

      -- watchEffect
      s("vwatcheffect", {
        t({"watchEffect(() => {", "    "}),
        i(0),
        t({"", "});"}),
      }),

      -- onMounted
      s("vonmounted", {
        t({"onMounted(() => {", "    "}),
        i(0),
        t({"", "});"}),
      }),

      -- onUnmounted
      s("vonunmounted", {
        t({"onUnmounted(() => {", "    "}),
        i(0),
        t({"", "});"}),
      }),

      -- Vue template slot
      s("vslot", {
        t("<template #"),
        i(1, "slotName"),
        t("=\"{ "),
        i(2, "prop"),
        t({" }\">", "    "}),
        i(0),
        t({"", "</template>"}),
      }),

      -- Redux useDispatch + useSelector hook inside Vue SFC
      s("vrx", {
        t({"const dispatch = useDispatch();", "const "}),
        i(1, "items"),
        t(" = useSelector("),
        i(2, "Selectors.getItems"),
        t(");"),
      }),

      -- ValidationField template component
      s("vvalfield", {
        t("<ValidationField"),
        t({"", "    v-slot=\"{ validationEvaluator }\""}),
        t({"", "    :object-id=\""}),
        i(1, "item.id"),
        t("\""),
        t({"", "    :field-name=\""}),
        i(2, "fieldName"),
        t("\""),
        t({"", "    :rules=\""}),
        i(3, "rules"),
        t("\""),
        t({"", ">", "    "}),
        i(0),
        t({"", "</ValidationField>"}),
      }),
    }

    -- Redux Toolkit snippets
    local redux_snippets = {
      -- Full Redux Slice with Entity Adapter
      s("rtkslice", {
        t({"import { createEntityAdapter, createSlice } from \"@reduxjs/toolkit\";", ""}),
        t("export const "),
        i(1, "items"),
        t("Adapter = createEntityAdapter<"),
        i(2, "Item"),
        t({", string>({", "    selectId: ("}),
        i(3, "item"),
        t(") => "),
        f(function(args) return args[1][1] or "item" end, {3}),
        t({".id,", "});", "", "const slice = createSlice({", "    name: \""}),
        i(4, "FeatureName"),
        t({"\",", "    initialState: "}),
        f(function(args) return args[1][1] or "items" end, {1}),
        t({"Adapter.getInitialState(),", "    reducers: (create) => ({", "        setAll: create.reducer<"}),
        f(function(args) return args[1][1] or "Item" end, {2}),
        t({"[]>((state, action) => {", "            "}),
        f(function(args) return args[1][1] or "items" end, {1}),
        t({"Adapter.setAll(state, action.payload);", "        }),", "        addOne: create.reducer<"}),
        f(function(args) return args[1][1] or "Item" end, {2}),
        t({">((state, action) => {", "            "}),
        f(function(args) return args[1][1] or "items" end, {1}),
        t({"Adapter.addOne(state, action.payload);", "        }),", "        updateOne: create.reducer<{ id: string; changes: Partial<"}),
        f(function(args) return args[1][1] or "Item" end, {2}),
        t({"> }>((state, action) => {", "            "}),
        f(function(args) return args[1][1] or "items" end, {1}),
        t({"Adapter.updateOne(state, action.payload);", "        }),", "        removeOne: create.reducer<string>((state, action) => {", "            "}),
        f(function(args) return args[1][1] or "items" end, {1}),
        t({"Adapter.removeOne(state, action.payload);", "        }),", "    }),", "});", "", "export const "}),
        f(function(args) return args[1][1] or "FeatureName" end, {4}),
        t({"Actions = slice.actions;", "export default slice.reducer;"}),
      }),

      -- Async Thunk Action
      s("rtkthunk", {
        t({"import { createAsyncThunk } from \"@reduxjs/toolkit\";", ""}),
        t("export const "),
        i(1, "loadItemsAction"),
        t(" = createAsyncThunk("),
        t({"", "    \""}),
        i(2, "feature/loadItems"),
        t({"\",", "    async ("}),
        i(3, "_"),
        t({", { dispatch }) => {", "        const response = await "}),
        i(4, "Services.getAll()"),
        t({";", "        return response;", "    }", ");"}),
      }),

      -- Redux createSelector memoized selector
      s("rtkselect", {
        t("export const get"),
        i(1, "Items"),
        t(" = createSelector("),
        t({"", "    (state: RootState) => "}),
        i(2, "state.feature"),
        t({",", "    ("}),
        i(3, "feature"),
        t("): "),
        i(4, "Item[]"),
        t({" => {", "        return "}),
        i(0),
        t({";", "    }", ");"}),
      }),

      -- useDispatch Hook
      s("rtkdispatch", {
        t("const dispatch = useDispatch();"),
      }),

      -- useSelector Hook
      s("rtkselector", {
        t("const "),
        i(1, "items"),
        t(" = useSelector("),
        i(2, "Selectors.getItems"),
        t(");"),
      }),
    }

    -- Ajax API Service snippets
    local api_snippets = {
      s("apiservice", {
        t({"import Globalize from \"@App/LocalizedMessages/GlobalizeBootstrapper\";", "import AjaxAdapter from \"@App/Common/Ajax/AjaxAdapter\";", ""}),
        t("const localizedApiUrl = `/api/''${Globalize.locale().locale}/"),
        i(1, "endpoint"),
        t({"`;", "", "function get(): Promise<"}),
        i(2, "IModel"),
        t({"[]> {", "    return AjaxAdapter.GET({ url: localizedApiUrl });", "}", "", "function save(model: "}),
        f(function(args) return args[1][1] or "IModel" end, {2}),
        t({"): Promise<"}),
        f(function(args) return args[1][1] or "IModel" end, {2}),
        t({"> {", "    return AjaxAdapter.PUT({ url: localizedApiUrl, data: JSON.stringify(model) });", "}", "", "function deleteById(id: string): Promise<void> {", "    return AjaxAdapter.DELETE({ url: localizedApiUrl, objectId: id });", "}", "", "export default {", "    getAll: get,", "    save,", "    delete: deleteById,", "};"}),
      }),
    }

    -- Full Vue Test Suite Snippet
    local vue_test_snippets = {
      s("vtestsuite", {
        t({"import type { VueWrapper } from \"@vue/test-utils\";", "import { mount, shallowMount } from \"@vue/test-utils\";", "import { createInjectedReactiveStore } from \"@App/Common/Store/ReduxBindings\";", "import store from \"@App/Store\";", "import CommonActions from \"@App/Common/Store/CommonActions\";", ""}),
        t("import "),
        i(1, "ComponentView"),
        t(" from \"./"),
        f(function(args) return args[1][1] or "ComponentView" end, {1}),
        t({".vue\";", "", "describe(\""}),
        f(function(args) return args[1][1] or "ComponentView" end, {1}),
        t({" Tests\", () => {", "    let wrapper: VueWrapper;", "", "    beforeEach(() => {", "        store.dispatch(CommonActions.resetStore());", "        "}),
        i(2, "// additional setup"),
        t({"", "    });", "", "    afterEach(() => {", "        wrapper?.unmount();", "    });", "", "    function createWrapper(props = {}) {", "        wrapper = mount("}),
        f(function(args) return args[1][1] or "ComponentView" end, {1}),
        t({", {", "            props,", "            global: {", "                provide: createInjectedReactiveStore(store),", "            },", "        });", "    }", "", "    it(\"Given initial state, When mounted, Then component renders\", () => {", "        createWrapper();", "        expect(wrapper.exists()).toBe(true);", "    });", "});"}),
      }),

      s("vtestshallow", {
        t({"wrapper = shallowMount("}),
        i(1, "ComponentView"),
        t({", {", "    props: {"}),
        i(2),
        t({"", "    },", "    global: {", "        provide: createInjectedReactiveStore(store),", "        stubs: {"}),
        i(3),
        t({"", "        },", "    },", "});"}),
      }),

      s("vtestevent", {
        t("expect(wrapper.emitted(\""),
        i(1, "eventName"),
        t({"\")).toEqual([["}),
        i(2, "expectedPayload"),
        t("]]);"),
      }),
    }

    -- Composition API snippets for composables (.ts/.js)
    local composable_snippets = {
      vue_snippets[7],  -- vref
      vue_snippets[8],  -- vreactive
      vue_snippets[9],  -- vcomputed
      vue_snippets[10], -- vwatch
      vue_snippets[11], -- vwatcheffect
      vue_snippets[12], -- vonmounted
      vue_snippets[13], -- vonunmounted
    }

    -- Add the same snippets to all relevant filetypes
    ls.add_snippets("typescript", jest_snippets)
    ls.add_snippets("typescript", vue_test_snippets)
    ls.add_snippets("typescript", composable_snippets)
    ls.add_snippets("typescript", redux_snippets)
    ls.add_snippets("typescript", api_snippets)

    ls.add_snippets("javascript", jest_snippets)
    ls.add_snippets("javascript", vue_test_snippets)
    ls.add_snippets("javascript", composable_snippets)
    ls.add_snippets("javascript", redux_snippets)
    ls.add_snippets("javascript", api_snippets)

    ls.add_snippets("typescriptreact", jest_snippets)
    ls.add_snippets("javascriptreact", jest_snippets)

    ls.add_snippets("vue", vue_snippets)
    ls.add_snippets("vue", jest_snippets)
    ls.add_snippets("vue", redux_snippets)
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
