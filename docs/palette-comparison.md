# Palette comparison: how popular themes handle warm/cool balance

Research notes from when we were diagnosing the "Mexico filter" sensation in
the original palette. The methodology: pull the raw hex values from each
upstream repo, convert to HSL, and compare hue/saturation distribution of
neutrals (bg through fg) and accents.

Themes analyzed: Catppuccin Mocha, Tokyo Night Storm, Gruvbox dark, Solarized
dark (Schoonover canonical), Rose Pine main.

## The hue map

```
            COOL                     WARM
           180°    210°    240°    270°    300°    330°    0°/360°    30°    60°
            │       │       │       │       │       │       │         │       │
Solarized:  ████████              (180-196°)
TokyoNight:                ████  (227-230°)
Catppuccin:                ████  (226-240°)
Rose Pine:                  ████ (244-251°)
Gruvbox:                                                              ███████  (20-43°)
```

Three clusters. **Solarized goes deep cool (teal).** **Catppuccin / Tokyo Night
/ Rose Pine cluster around 225–250° (cool blue-violet).** **Gruvbox sits
warm (20–43°).** Nobody lives between.

## The saturation map (this is the real story)

| Theme | Neutral S range | fg-equivalent S | What this means |
|---|---|---|---|
| **Gruvbox dark** | 0–59% (light1=59!) | **59** | Warm and **committed** — fg is openly cream-yellow |
| **Catppuccin Mocha** | 11–64% | **64** | Cool and committed — fg is openly pale-blue |
| **Tokyo Night Storm** | 23–73% | **73** | Most cool-committed of any theme — fg is *very* pale blue |
| **Rose Pine main** | 12–50% | **50** | Cool violet, openly so |
| **Solarized dark** | 7–14% | **8** | Mid-saturation cool — Schoonover's "selective contrast" math |
| **nyanuwatari (original)** | **2–5%** | **5** | Warm direction, but **almost-zero saturation** |

**The finding**: every popular theme either commits to a hue with real
saturation (8% minimum) OR doesn't tilt at all. The original palette sat in a
muddy middle — warm direction, but desaturated to a whisper.

That's why it read as "Mexico filter." Low-saturation warm = stain / tint /
sepia. High-saturation warm = intentional aesthetic (Gruvbox). High-saturation
cool = also fine (TN/Cat). **The muddy middle is the problem**, not the warmth
itself.

## What each theme actually feels like, decoded

- **Gruvbox** feels warm because it *commits*: light1 fg is HSL(43, 59, 81) —
  that's basically a saturated pale cream. People know they're using a warm
  theme.
- **Tokyo Night** feels modern/cool because fg = HSL(229, 73, 86) — that's
  overtly pale blue. No mistaking it.
- **Catppuccin Mocha** balances by committing to violet-blue neutrals (S=11–64)
  and then putting warm pink/peach/yellow accents on top. The high contrast
  between cool surface and warm accents is what makes Catppuccin "pop."
- **Solarized** is unique: cool *neutrals* but with such surgical saturation
  control that it doesn't read as "blue theme." Schoonover used CIELAB rather
  than HSL.
- **Rose Pine** commits to violet at low-but-real saturation (12–25 in mid-
  range neutrals). "Calm" because it never spikes saturation in the neutrals.

## Three principled exits from the muddy middle

### Exit A — Commit to warmth (Gruvbox direction)

- Push neutral S from 2–5% → 8–14% **while staying warm** (H≈25–30°)
- fg: HSL(28, 12, 88) → roughly `#e6e0d6` (warm cream, but openly so)
- bg_0: HSL(28, 8, 8) → `#161413`
- Effect: stops looking like a filter, starts looking like a warm theme.
- Trade-off: makes the theme objectively more warm, but reads as *less* filter
  because the eye understands it's intentional.

### Exit B — Cool-tilt (Catppuccin / Tokyo Night direction)

- Rotate neutrals to H=220–230° while bumping S to 6–10%
- fg: HSL(225, 8, 90) → roughly `#dfe2e8` (clearly cool, slightly brighter)
- bg_0: HSL(225, 8, 8) → `#13141a`
- Effect: warm accents (pink, peach, yellow) sit on a cool canvas → they
  *read* warmer by contrast, the canvas reads as restful.
- Trade-off: surrenders the "charcoal/soot warm grey" identity in the bg.

### Exit C — True neutral (rare)

- H irrelevant, S=0 throughout neutrals
- fg: pure grey at L=88 → `#e0e0e0`
- Most defensible mathematically; least character.

## Raw HSL data for reference

### nyanuwatari (original, pre-fix)

```
bg_deep   #100f0f   H=0   S=3  L=6
bg_0      #151414   H=0   S=2  L=8
bg_1      #1d1c1b   H=30  S=4  L=11
bg_2      #282625   H=20  S=4  L=15
bg_3      #353331   H=30  S=4  L=20
bg_4      #454240   H=24  S=4  L=26
fg_faint  #85807a   H=33  S=4  L=50
fg_mute   #b1ada9   H=30  S=5  L=68
fg        #e2e0df   H=20  S=5  L=88
-- accents (unchanged) --
cyan      #a6dde7   H=189 S=58 L=78
lavender  #cca6e7   H=275 S=58 L=78
pink      #eaa4c9   H=328 S=62 L=78
peach     #e7bca6   H=20  S=58 L=78
yellow    #e7dda6   H=51  S=58 L=78
```

### Catppuccin Mocha

```
crust     #11111b   H=240 S=23 L=9
mantle    #181825   H=240 S=21 L=12
base      #1e1e2e   H=240 S=21 L=15
surface0  #313244   H=237 S=16 L=23
surface1  #45475a   H=234 S=13 L=31
surface2  #585b70   H=232 S=12 L=39
overlay0  #6c7086   H=231 S=11 L=47
overlay1  #7f849c   H=230 S=13 L=55
overlay2  #9399b2   H=228 S=17 L=64
subtext0  #a6adc8   H=228 S=24 L=72
subtext1  #bac2de   H=227 S=35 L=80
text      #cdd6f4   H=226 S=64 L=88
-- accents --
blue      #89b4fa   H=217 S=92 L=76
mauve     #cba6f7   H=267 S=84 L=81
pink      #f5c2e7   H=316 S=72 L=86
red       #f38ba8   H=343 S=81 L=75
peach     #fab387   H=23  S=92 L=75
yellow    #f9e2af   H=41  S=86 L=83
```

### Tokyo Night Storm

```
bg_dark1     #1b1e2d   H=230 S=25 L=14
bg_dark      #1f2335   H=229 S=26 L=16
bg           #24283b   H=230 S=24 L=19
bg_highlight #292e42   H=228 S=23 L=21
fg_gutter    #3b4261   H=229 S=24 L=31
comment      #565f89   H=229 S=23 L=44
fg_dark      #a9b1d6   H=229 S=35 L=75
fg           #c0caf5   H=229 S=73 L=86
-- accents --
blue         #7aa2f7   H=221 S=89 L=72
magenta      #bb9af7   H=261 S=85 L=79
red          #f7768e   H=349 S=89 L=72
orange       #ff9e64   H=22  S=100 L=70
yellow       #e0af68   H=36  S=66 L=64
```

### Gruvbox dark

```
dark0_hard   #1d2021   H=195 S=6   L=12
dark0        #282828   H=0   S=0   L=16
dark0_soft   #32302f   H=20  S=3   L=19
dark1        #3c3836   H=20  S=5   L=22
dark2        #504945   H=22  S=7   L=29
dark3        #665c54   H=27  S=10  L=36
dark4        #7c6f64   H=28  S=11  L=44
light4       #a89984   H=35  S=17  L=59
light3       #bdae93   H=39  S=24  L=66
light2       #d5c4a1   H=40  S=38  L=73
light1       #ebdbb2   H=43  S=59  L=81
-- accents --
br_red       #fb4934   H=6   S=96  L=59
br_orange    #fe8019   H=27  S=99  L=55
br_yellow    #fabd2f   H=42  S=95  L=58
br_blue      #83a598   H=157 S=16  L=58
br_purple    #d3869b   H=344 S=47  L=68
br_aqua      #8ec07c   H=104 S=35  L=62
```

### Solarized dark

```
base03       #002b36   H=192 S=100 L=11
base02       #073642   H=192 S=81  L=14
base01       #586e75   H=194 S=14  L=40
base00       #657b83   H=196 S=13  L=45
base0        #839496   H=186 S=8   L=55
base1        #93a1a1   H=180 S=7   L=60
-- accents --
yellow       #b58900   H=45  S=100 L=35
orange       #cb4b16   H=18  S=80  L=44
red          #dc322f   H=1   S=71  L=52
magenta      #d33682   H=331 S=64  L=52
violet       #6c71c4   H=237 S=43  L=60
blue         #268bd2   H=205 S=69  L=49
cyan         #2aa198   H=175 S=59  L=40
green        #859900   H=68  S=100 L=30
```

### Rose Pine main

```
_nc            #16141f   H=251 S=22 L=10
base           #191724   H=249 S=22 L=12
surface        #1f1d2e   H=247 S=23 L=15
overlay        #26233a   H=248 S=25 L=18
highlight_low  #21202e   H=244 S=18 L=15
highlight_med  #403d52   H=249 S=15 L=28
highlight_high #524f67   H=248 S=13 L=36
muted          #6e6a86   H=249 S=12 L=47
subtle         #908caa   H=248 S=15 L=61
text           #e0def4   H=245 S=50 L=91
-- accents --
love           #eb6f92   H=343 S=76 L=68
gold           #f6c177   H=35  S=88 L=72
rose           #ebbcba   H=2   S=55 L=83
pine           #31748f   H=197 S=49 L=38
foam           #9ccfd8   H=189 S=43 L=73
iris           #c4a7e7   H=267 S=57 L=78
```

## Sources

- Catppuccin: `github.com/catppuccin/nvim` — `lua/catppuccin/palettes/mocha.lua`
- Tokyo Night: `github.com/folke/tokyonight.nvim` — `lua/tokyonight/colors/storm.lua` + `night.lua`
- Gruvbox: `github.com/ellisonleao/gruvbox.nvim` — `lua/gruvbox.lua`
- Solarized: canonical values from Ethan Schoonover's `ethanschoonover.com/solarized` (the `maxmx03/solarized.nvim` repo did not resolve at fetch time; canonical values are stable since 2011)
- Rose Pine: `github.com/rose-pine/neovim` — `lua/rose-pine/palette.lua`
