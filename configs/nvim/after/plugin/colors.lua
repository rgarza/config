-- Default options
require("nightfox").setup({
	options = {
		-- Compiled file's destination location
		compile_path = vim.fn.stdpath("cache") .. "/nightfox",
		compile_file_suffix = "_compiled", -- Compiled file suffix
		transparent = false,         -- Disable setting background
		terminal_colors = true,      -- Set terminal colors (vim.g.terminal_color_*) used in `:terminal`
		dim_inactive = false,        -- Non focused panes set to alternative background
		module_default = true,       -- Default enable value for modules
		colorblind = {
			enable = false,          -- Enable colorblind support
			simulate_only = false,   -- Only show simulated colorblind colors and not diff shifted
			severity = {
				protan = 0,          -- Severity [0,1] for protan (red)
				deutan = 0,          -- Severity [0,1] for deutan (green)
				tritan = 0,          -- Severity [0,1] for tritan (blue)
			},
		},
		styles = {      -- Style to be applied to different syntax groups
			comments = "italic", -- Value is any valid attr-list value `:help attr-list`
			conditionals = "italic",
			constants = "bold",
			functions = "NONE",
			keywords = "italic",
			numbers = "NONE",
			operators = "NONE",
			strings = "NONE",
			types = "NONE",
			variables = "NONE",
		},
		inverse = { -- Inverse highlight for different types
			match_paren = false,
			visual = false,
			search = false,
		},
		modules = { -- List of various plugins and additional options
			-- ...
		},
	},
	palettes = {
		nightfox = {
			bg0 = "#12121f",
			bg1 = "#12121f",
			bg2 = "#222237",
			bg3 = "#24243c",
			bg4 = "#63658b",
			fg0 = "#d4d7ff",
			fg1 = "#d4d7ff",
			fg2 = "#d4d7ff",
			fg3 = "#4f5071",
			sel0 = "#3f548d",
			sel1 = "#3f548d",
			comment = "#63658b",
			black = "#222236",
			red = "#d95177",
			green = "#7bdba6",
			yellow = "#65dedc", -- cyan
			blue = "#6d98e8",
			magenta = "#837dd7", -- purple
			cyan = "#fcf295", -- yellow
			white = "#d4d7ff",
			orange = "#e3b56f",
			pink = "#ff007d",
		},
	},
	specs = {},
	groups = {

    },
})

-- setup must be called before loading
vim.cmd("colorscheme nightfox")
