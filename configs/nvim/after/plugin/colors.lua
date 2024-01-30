require('tokyonight').setup({
  disable_background = true
})

function ColorMyPencils(color)
  color = color or "tokyonight"
  vim.cmd.colorscheme(color)
end

ColorMyPencils()
