# Battle plan — nyanuwatari.nvim refactor

## Context

The current colorscheme works but is built on a stack that's holding back quality:

- **`lush.nvim`** as a runtime DSL dependency — adds a hard plugin dep and an opaque transform between the spec and `nvim_set_hl`.
- **`shipwright.nvim`** for extras generation — extra build dep, half the extras use built-in contribs and half are custom runners, output style is inconsistent.
- Highlight coverage is wide but uneven — visible issues across treesitter groups, no LSP semantic-token discipline, no plugin-specific groups beyond file icons.

The user has lived with the palette for several days and is happy with it; the technical implementation is what needs to be torn down and rebuilt. The reference is **folke/tokyonight.nvim**: a hex-internal, module-per-concern, no-DSL Lua architecture proven across hundreds of thousands of users. `nordic.nvim` is the secondary reference for the *semantic-alias* pattern that lets us enforce "green never appears in code syntax" from a single chokepoint.

**Outcome we want:**

1. No runtime dependencies. `:colorscheme nyanuwatari` works with the plugin alone.
2. Single dark variant — no light mode, no style permutations.
3. Palette authored in HSL (`{h, s, l}`), resolved to hex once at load time. Simple converter, no HSLuv.
4. Full ANSI 16-color support (black/red/green/yellow/blue/magenta/cyan/white + bright). Green exists in the palette but is **only** reachable through `ui.*` semantic aliases (diff/git/success/hints) — *never* from any syntax/treesitter/LSP group.
5. Three extras only: ghostty, tmux, fish. Lua generators, invoked by `just extras`.
6. Plugin groups: gitsigns, telescope, cmp/blink.cmp, lazy, mini, snacks, flash, nvim-tree, lualine, indent-blankline, treesitter-context.

The spirit of the theme (charcoal background, yellow / cyan / pink core, soft accents) is preserved 1:1. The palette gains one new color: a true blue for ANSI slot 4/12.

---

## Target file tree

```
colors/nyanuwatari.lua          # 3-line entry: require("nyanuwatari").load()
lua/nyanuwatari/
  init.lua                      # M.setup(opts), M.load() — config merge + theme dispatch
  config.lua                    # defaults: styles, plugins, transparent, terminal_colors, cache, on_colors, on_highlights
  theme.lua                     # core: builds colors+groups, loops nvim_set_hl, sets terminal_color_*
  util.lua                      # blend / darken / lighten / template / cache.read/write / read / write / resolve
  hsl.lua                       # hsl_to_hex({h,s,l}) / hex_to_hsl(hex) — ~30 lines
  palette.lua                   # raw HSL palette — single source of truth
  colors.lua                    # palette resolution: HSL→hex, derived semantic aliases (ui, diff, git, terminal), on_colors callback
  groups/
    init.lua                    # aggregator: enabled-modules merge, cache check, util.resolve, plugin auto-detect via lazy
    base.lua                    # editor UI, diagnostics, native Syntax/* groups, diff/git UI
    treesitter.lua              # @* groups
    semantic_tokens.lua         # @lsp.type.* / @lsp.mod.* / @lsp.typemod.*
    kinds.lua                   # LSP kind helper (reused by cmp/blink/telescope)
    plugins/
      gitsigns.lua
      telescope.lua
      cmp.lua
      blink.lua
      lazy.lua
      mini.lua
      snacks.lua
      flash.lua
      nvim_tree.lua
      lualine.lua
      indent_blankline.lua
      treesitter_context.lua
  extras/
    init.lua                    # M.setup() — orchestrates generators, writes files
    util.lua                    # template engine (reused from main util) + write helper
    ghostty.lua                 # M.generate(colors) → string
    tmux.lua
    fish.lua
extras/                         # output dir (committed)
  ghostty/nyanuwatari
  tmux/nyanuwatari.tmux
  fish/nyanuwatari.fish
justfile                        # extras / check / fmt / check-fmt — no .deps, no clone steps
README.md                       # updated install + extras sections
```

**Deleted entirely:**

- `lua/nyanuwatari/specs/` (the lush spec)
- `lua/nyanuwatari/shipwright/` (all runners + build)
- `lua/nyanuwatari/term.lua` (folded into `theme.lua`)
- `extras/alacritty/`, `extras/kitty/`, `extras/wezterm/`
- `.deps/` (if present locally — never tracked)
- All `lush`/`shipwright` references in README

---

## Architectural decisions

### 1. Color representation

- **Authoring:** HSL tables in `palette.lua`, e.g. `pink = { 328, 70, 78 }`.
- **Internal:** hex strings everywhere downstream (groups, derived colors, extras). Resolution happens once at the top of `colors.lua`.
- **Operations:** `util.blend(fg, alpha, bg)` does linear RGB interpolation (port from `tokyonight/util.lua:10-50`). `darken = blend(c, alpha, palette.bg)`, `lighten = blend(c, alpha, palette.fg)`.
- **HSL converter:** `lua/nyanuwatari/hsl.lua` — pure functions, no dependencies. Standard HSL→RGB algorithm (~30 lines). Optional helper `hsl_adjust(hex, {h=?, s=?, l=?})` if we want to tweak resolved colors.
- **No HSLuv.** User explicitly chose plain HSL. Drop tokyonight's `hsluv.lua` and `util.invert`/`util.brighten` — replace `brighten` with a simple HSL lightness bump.

### 2. Semantic-alias chokepoint (the "no green in code" enforcement)

In `colors.lua` after the HSL→hex resolution:

```lua
-- Raw palette (hex strings)
local p = palette.resolve()  -- { bg = "#171616", pink = "#eaa4c9", green = "#98cdaa", ... }

-- Semantic aliases — THIS is where code groups may reach for color
local c = {
  -- direct palette pass-through for non-green hues
  bg = p.bg_0, bg_1 = p.bg_1, ... fg = p.fg, fg_mute = p.fg_mute, ...
  pink = p.pink, cyan = p.cyan, yellow = p.yellow, peach = p.peach,
  lavender = p.lavender, red = p.red, blue = p.blue,

  -- UI-only semantic aliases (green leaks ONLY through these)
  ui = {
    diff_add    = p.green,
    diff_change = p.blue,
    diff_delete = p.red,
    diff_text   = util.blend(p.blue, 0.3, p.bg_0),  -- subtle bg for changed text
    success     = p.green,
    warning     = p.yellow,
    error       = p.red,
    info        = p.blue,
    hint        = p.cyan,    -- explicitly NOT green
  },

  git = { add = p.green, change = p.blue, delete = p.red },

  terminal = {  -- ANSI 16-color mapping, drives vim.g.terminal_color_*
    black = p.bg_2, black_bright = p.bg_4,
    red = p.red, red_bright = util.lighten(p.red, 0.15),
    green = p.green, green_bright = util.lighten(p.green, 0.15),
    yellow = p.yellow, yellow_bright = util.lighten(p.yellow, 0.15),
    blue = p.blue, blue_bright = util.lighten(p.blue, 0.15),
    magenta = p.pink, magenta_bright = util.lighten(p.pink, 0.15),
    cyan = p.cyan, cyan_bright = util.lighten(p.cyan, 0.15),
    white = p.fg_mute, white_bright = p.fg,
  },
}
```

**Convention enforced by code review and grep, not by types:**

- Group files (`groups/base.lua`, `groups/treesitter.lua`, `groups/semantic_tokens.lua`, plus every `groups/plugins/*.lua` that touches code-shaped groups) **may not reference `c.green`**. Period.
- `c.green` is only legal in: `groups/base.lua` UI sections (DiffAdd, GitSignsAdd, DiagnosticOk), `groups/plugins/gitsigns.lua`, `groups/plugins/lazy.lua` (progress complete), terminal mapping.
- Verification step: `grep -n "c\.green\|colors\.green" lua/nyanuwatari/groups/treesitter.lua lua/nyanuwatari/groups/semantic_tokens.lua` must return zero hits.
- Things currently green-tinted that **switch away from green**:
  - `SpecialChar`, `@string.escape`, `@character.special` → `c.peach` (warm emphasis)
  - `@markup.list.checked` → `c.cyan` (UI-state marker, distinct from code)
  - `@diff.plus` stays green (it's a diff marker, not code)
  - `DiffAdd`, `Added`, `GitSignsAdd` stay green (UI)
  - `DiagnosticOk` / success states → green
  - `DiagnosticHint` → cyan (not green)

### 3. Palette additions (preserving the core)

User-declared **core, untouched**: `bg`, `yellow`, `cyan`, `pink`. Everything else may evolve.

| Add | Why | Slot |
|---|---|---|
| `blue` (~210°, S 60, L 76) | ANSI slot 4/12, diff-change, info | New |
| Keep `green`, `red`, `peach`, `lavender`, `peach_dim`, brights | Already present | — |

All other current colors carry over as-is. The recent uncommitted lightness-tier work in `palette.lua` and the `peach_dim` addition in `specs/dark.lua` are folded into the new `palette.lua`.

### 4. Caching

Implement tokyonight-style JSON cache (port from `tokyonight/util.lua:142-168` and `tokyonight/groups/init.lua:138-163`). Single key (`nyanuwatari`), file at `vim.fn.stdpath("cache") .. "/nyanuwatari.json"`. Invalidate on input change: `{ colors, plugins, version, opts.styles, opts.transparent }`. Default on, disable via `setup({ cache = false })`. Cost is ~80 lines; payoff is ~5–10ms shaved off colorscheme load.

### 5. Style options (italic / bold)

Mirror tokyonight `config.lua:13-23` minimally:

```lua
styles = {
  comments  = { italic = true },
  keywords  = { italic = false },
  functions = {},
  variables = {},
}
```

Resolved via `util.resolve()` (port from `tokyonight/util.lua:96-106`) which flattens `{ style = {...} }` into inline `nvim_set_hl` keys.

### 6. Extras generator

Port tokyonight's `extra/init.lua:58-97` pattern, drastically simplified (no style loop, three extras only):

```lua
-- lua/nyanuwatari/extras/init.lua
function M.setup()
  local theme = require("nyanuwatari.theme")
  local colors = theme.setup({ plugins = { all = true } }).colors
  for _, name in ipairs({ "ghostty", "tmux", "fish" }) do
    local gen = require("nyanuwatari.extras." .. name)
    local out_path = ({
      ghostty = "extras/ghostty/nyanuwatari",
      tmux    = "extras/tmux/nyanuwatari.tmux",
      fish    = "extras/fish/nyanuwatari.fish",
    })[name]
    util.write(out_path, gen.generate(colors))
  end
end
```

Each generator uses `util.template` (port from `tokyonight/util.lua:114-120`) with `${var}` and nested `${terminal.blue}` substitution. Take the tokyonight ghostty/tmux/fish templates as the starting point and adapt key names to ours.

### 7. Entry flow

```
:colorscheme nyanuwatari
  └─ colors/nyanuwatari.lua
       └─ require("nyanuwatari").load()
            └─ require("nyanuwatari.theme").setup(opts)
                 ├─ colors = require("nyanuwatari.colors").setup(opts)
                 ├─ groups, names = require("nyanuwatari.groups").setup(colors, opts)
                 ├─ clear vim.g.colors_name + reset syntax
                 ├─ set vim.o.termguicolors, vim.g.colors_name = "nyanuwatari"
                 ├─ for group, hl in pairs(groups) do vim.api.nvim_set_hl(0, group, hl) end
                 └─ if opts.terminal_colors then set vim.g.terminal_color_0..15 end
```

This is a direct adaptation of `tokyonight/theme.lua:4-58`.

---

## Phased work

### Phase A — Demolition

1. Delete `lua/nyanuwatari/specs/`.
2. Delete `lua/nyanuwatari/shipwright/`.
3. Delete `lua/nyanuwatari/term.lua`.
4. Delete `extras/alacritty/`, `extras/kitty/`, `extras/wezterm/`.
5. Clear `lua/nyanuwatari/init.lua`, `lua/nyanuwatari/palette.lua`, `colors/nyanuwatari.lua` — keep file handles, empty contents.
6. Update `justfile`: remove `deps`, `deps-update`, `deps-clean`; rewrite `extras` recipe; keep `check`, `fmt`, `check-fmt`.

### Phase B — Foundation

7. Write `lua/nyanuwatari/hsl.lua` — `hsl_to_hex({h,s,l})`, `hex_to_hsl(hex)`, `hsl_adjust(hex, delta)`.
8. Write `lua/nyanuwatari/util.lua` — port `rgb`, `blend`, `darken`, `lighten`, `template`, `read`, `write`, `cache.read/write/file/clear`, `resolve` from `tokyonight/util.lua`. Replace `brighten`/`invert` with an HSL-based `brighten`.
9. Write `lua/nyanuwatari/config.lua` — defaults: `{ style = "dark", transparent = false, terminal_colors = true, styles = {...}, plugins = { all = false, auto = true, [plugin_name] = nil }, cache = true, on_colors = nil, on_highlights = nil }`.
10. Write `lua/nyanuwatari/palette.lua` — HSL table for every color. Includes existing core (bg tiers, fg tiers, pink, cyan, yellow, peach, lavender, red, green, peach_dim, brights) **plus** new `blue`.
11. Write `lua/nyanuwatari/colors.lua` — `M.setup(opts)`:
    - Call `palette.resolve()` (HSL→hex)
    - Build `c` with palette pass-through + `c.ui`, `c.git`, `c.terminal`, `c.diff` semantic aliases
    - Build derived bg variants (`bg_sidebar`, `bg_float`, `bg_visual`, `bg_statusline`, `border`) blended where needed
    - Apply `opts.on_colors(c)` callback
    - Return `c`
12. Write `lua/nyanuwatari/theme.lua` — `M.setup(opts)` that orchestrates colors→groups→`nvim_set_hl` loop + terminal slot setup. Direct port of `tokyonight/theme.lua` minus variant logic.
13. Write `lua/nyanuwatari/init.lua` — `M.setup(opts)` (merges into config), `M.load()` (calls theme.setup).
14. Write `colors/nyanuwatari.lua` — 1 line: `require("nyanuwatari").load()`.

### Phase C — Highlight groups

15. Write `lua/nyanuwatari/groups/init.lua` — aggregator. Always-on modules: `base`, `treesitter`, `semantic_tokens`, `kinds`. Plugin registry mapping `lazy.nvim` plugin names → group module name. Auto-detect through `package.loaded.lazy`. Merge + cache path identical to `tokyonight/groups/init.lua:94-167`.
16. Write `lua/nyanuwatari/groups/base.lua` — port the editor-UI, diagnostic, native Syntax, diff/git sections of the current `specs/dark.lua`, mapped to the new `c` table. **Audit every reference to green and re-route per the policy above.**
17. Write `lua/nyanuwatari/groups/treesitter.lua` — port the `@*` section of `specs/dark.lua`. Apply same green-audit. Strings stay `c.yellow`, special chars become `c.peach`.
18. Write `lua/nyanuwatari/groups/semantic_tokens.lua` — port the `@lsp.type.*` / `@lsp.mod.*` section. Use blends for de-emphasized tokens (port `Util.blend_fg(c.blue1, 0.7)` style from `tokyonight/groups/semantic_tokens.lua`).
19. Write `lua/nyanuwatari/groups/kinds.lua` — port the shared LSP kind table from `tokyonight/groups/kinds.lua` (used by cmp / blink / telescope).
20. Write `lua/nyanuwatari/groups/plugins/gitsigns.lua` — Add/Change/Delete sign + number variants + wordref. (Already exists in `specs/dark.lua` — port directly.)
21. Write `lua/nyanuwatari/groups/plugins/telescope.lua` — borders, selection, prompt, matching. Take `tokyonight/groups/telescope.lua` as the template, swap colors.
22. Write `lua/nyanuwatari/groups/plugins/cmp.lua` — completion menu, kinds, doc border. Template: `tokyonight/groups/cmp.lua`.
23. Write `lua/nyanuwatari/groups/plugins/blink.lua` — same idea for blink.cmp. Template: `tokyonight/groups/blink.lua`.
24. Write `lua/nyanuwatari/groups/plugins/{lazy,mini,snacks,flash,nvim_tree,lualine,indent_blankline,treesitter_context}.lua` — each one ports the corresponding `tokyonight/groups/*.lua` file with our `c` table.

### Phase D — Extras

25. Write `lua/nyanuwatari/extras/init.lua` — orchestration (see §6 above).
26. Write `lua/nyanuwatari/extras/ghostty.lua` — adapt `tokyonight/extra/ghostty.lua` template.
27. Write `lua/nyanuwatari/extras/tmux.lua` — adapt `tokyonight/extra/tmux.lua` template.
28. Write `lua/nyanuwatari/extras/fish.lua` — adapt `tokyonight/extra/fish.lua` template (note the `#`-stripping step for fish hex syntax).
29. Run `just extras` and review the three generated files by eye and side-by-side against the current `extras/{ghostty,tmux,fish}/...` versions to confirm visual continuity.

### Phase E — Build system + docs

30. Final `justfile`:

    ```
    extras:
      nvim --headless --noplugin -u NONE \
        --cmd 'set rtp+=.' \
        -l -c 'lua require("nyanuwatari.extras").setup()' +q

    check:
      nvim --headless --noplugin -u NONE \
        --cmd 'set rtp+=.' \
        -c 'colorscheme nyanuwatari' +q

    fmt:
      stylua lua/ colors/

    check-fmt:
      stylua --check lua/ colors/
    ```

31. README:
    - Drop `lush.nvim` dependency line.
    - Remove `shipwright` references.
    - Trim extras section to ghostty/tmux/fish.
    - Add a `Configuration` section sketching `require("nyanuwatari").setup({ ... })` (styles, plugins, transparent, terminal_colors, on_colors, on_highlights, cache).
    - Keep the "Story" / palette philosophy sections — those are the soul.

### Phase F — Verification

32. `just check-fmt` — clean.
33. `just check` — colorscheme loads without error in headless nvim.
34. Manual smoke test in a real nvim session against representative files: a Lua file (treesitter), a TypeScript file (LSP semantic tokens), markdown (headings + checkboxes), a diff (DiffAdd/Change/Delete), a git status (gitsigns column). Confirm zero green in code, green present in diff/git/success only.
35. `grep -rn "c\.green\|colors\.green" lua/nyanuwatari/groups/treesitter.lua lua/nyanuwatari/groups/semantic_tokens.lua` — must return zero. Repeat for every plugin group file. Allowlist: `groups/base.lua` (UI sections only), `groups/plugins/gitsigns.lua`, `groups/plugins/lazy.lua`, `colors.lua` (terminal/ui aliases).
36. `:terminal` inside the new colorscheme — run `ls --color`, `git diff`, and a 16-color test script (`for i in {0..15}; do printf "\e[48;5;${i}m  \e[0m"; done`). Confirm green/blue slots are recognizable and don't collide with cyan.
37. `:checkhealth` against a real config with telescope, gitsigns, cmp/blink, lualine loaded; auto-detect should pick them up via `package.loaded.lazy`.
38. `just extras` and diff the three generated files against the previous shipwright output to confirm no regression in terminal appearance.

---

## Critical reference files

While executing, keep these open from `/tmp/tokyonight-ref/`:

- `lua/tokyonight/theme.lua` — entry-flow template
- `lua/tokyonight/util.lua` — port verbatim (minus HSLuv-dependent functions)
- `lua/tokyonight/groups/init.lua` — aggregator + cache template
- `lua/tokyonight/groups/base.lua` — UI/native groups template
- `lua/tokyonight/groups/treesitter.lua` — `@*` template
- `lua/tokyonight/groups/semantic_tokens.lua` — `@lsp.*` template
- `lua/tokyonight/extra/{ghostty,tmux,fish}.lua` — generator templates

And from `/tmp/nordic-ref/`:

- `lua/nordic/colors/init.lua` — semantic-alias layer reference
- `lua/nordic/groups/integrations/` — per-plugin file layout idea

And from this repo (for color values + group coverage parity):

- `lua/nyanuwatari/palette.lua` (current working tree)
- `lua/nyanuwatari/specs/dark.lua` (current working tree) — source of group coverage; **read it to ensure no group is dropped** during port
- `docs/palette-comparison.md` — design rationale, keep accessible
- `README.md` — preserve story/philosophy sections

---

## Out of scope (explicitly)

- Light variant
- Multiple style variants (storm/night/moon/etc.)
- HSLuv perceptual color space
- alacritty / kitty / wezterm extras
- Auto-publishing extras anywhere
- `:Telescope colorscheme` style preview tooling
- Migration guide for existing users (single-user project, none needed)
