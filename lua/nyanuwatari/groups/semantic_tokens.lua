-- LSP semantic tokens (Neovim 0.9+). Links to treesitter @*-groups where the
-- mapping is unambiguous; overrides only for tokens that need distinct styling.

local M = {}

---@type fun(c: table, opts: table): table
function M.get(c, opts)
  -- stylua: ignore
  return {
    ["@lsp.type.boolean"]                       = "@boolean",
    ["@lsp.type.builtinType"]                   = "@type.builtin",
    ["@lsp.type.class"]                         = "@type",
    ["@lsp.type.comment"]                       = "@comment",
    ["@lsp.type.decorator"]                     = "@attribute",
    ["@lsp.type.deriveHelper"]                  = "@attribute",
    ["@lsp.type.enum"]                          = "@type",
    ["@lsp.type.enumMember"]                    = { fg = c.peach },
    ["@lsp.type.escapeSequence"]                = "@string.escape",
    ["@lsp.type.event"]                         = "Special",
    ["@lsp.type.formatSpecifier"]               = "@markup.list",
    ["@lsp.type.function"]                      = "@function",
    ["@lsp.type.generic"]                       = "@variable",
    ["@lsp.type.interface"]                     = "@type",
    ["@lsp.type.keyword"]                       = "@keyword",
    ["@lsp.type.lifetime"]                      = "@keyword.storage",
    ["@lsp.type.macro"]                         = "@function.macro",
    ["@lsp.type.method"]                        = "@function.method",
    ["@lsp.type.namespace"]                     = "@module",
    ["@lsp.type.namespace.python"]              = "@variable",
    ["@lsp.type.number"]                        = { fg = c.peach_dim },
    ["@lsp.type.operator"]                      = "@operator",
    ["@lsp.type.parameter"]                     = "@variable.parameter",
    ["@lsp.type.property"]                      = "@property",
    ["@lsp.type.regexp"]                        = "@string.regexp",
    ["@lsp.type.selfKeyword"]                   = "@variable.builtin",
    ["@lsp.type.selfTypeKeyword"]               = "@variable.builtin",
    ["@lsp.type.string"]                        = "@string",
    ["@lsp.type.struct"]                        = "@type",
    ["@lsp.type.type"]                          = "@type",
    ["@lsp.type.typeAlias"]                     = "@type.definition",
    ["@lsp.type.typeParameter"]                 = "@type.definition",
    ["@lsp.type.unresolvedReference"]           = { sp = c.error, undercurl = true },
    ["@lsp.type.variable"]                      = {}, -- defer to treesitter

    ["@lsp.mod.readonly"]                       = { fg = c.peach },
    ["@lsp.mod.deprecated"]                     = { fg = c.fg_mute, strikethrough = true },
    ["@lsp.mod.defaultLibrary"]                 = { italic = true },

    ["@lsp.typemod.class.defaultLibrary"]       = "@type.builtin",
    ["@lsp.typemod.enum.defaultLibrary"]        = "@type.builtin",
    ["@lsp.typemod.enumMember.defaultLibrary"]  = "@constant.builtin",
    ["@lsp.typemod.function.defaultLibrary"]    = { fg = c.pink, italic = true },
    ["@lsp.typemod.keyword.async"]              = "@keyword.coroutine",
    ["@lsp.typemod.keyword.injected"]           = "@keyword",
    ["@lsp.typemod.macro.defaultLibrary"]       = "@function.builtin",
    ["@lsp.typemod.method.defaultLibrary"]      = { fg = c.pink, italic = true },
    ["@lsp.typemod.operator.injected"]          = "@operator",
    ["@lsp.typemod.parameter.readonly"]         = { fg = c.fg, italic = true },
    ["@lsp.typemod.string.injected"]            = "@string",
    ["@lsp.typemod.struct.defaultLibrary"]      = "@type.builtin",
    ["@lsp.typemod.type.defaultLibrary"]        = { fg = c.lavender, italic = true },
    ["@lsp.typemod.typeAlias.defaultLibrary"]   = { fg = c.lavender, italic = true },
    ["@lsp.typemod.variable.callable"]          = "@function",
    ["@lsp.typemod.variable.defaultLibrary"]    = { fg = c.cyan },
    ["@lsp.typemod.variable.injected"]          = "@variable",
    ["@lsp.typemod.variable.readonly"]          = { fg = c.peach },
    ["@lsp.typemod.variable.static"]            = { fg = c.peach },
  }
end

return M
