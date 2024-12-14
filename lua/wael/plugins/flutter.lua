return {
  {
    'neoclide/coc.nvim',
    branch = 'release',
    config = function()

      vim.keymap.set('n', '<leader>wa', '<Plug>(coc-codelens-action)', { noremap = true, silent = true, desc = "Code Lens Action" })
      vim.keymap.set('n', '<leader>wz', '<Plug>(coc-codeaction)', { noremap = true, silent = true, desc = "Code Action" })
      vim.keymap.set('v', '<leader>wq', '<Plug>(coc-codeaction-selected)', { noremap = true, silent = true, desc = "Code Action on Selection" })

      -- Optionally, configure other coc.nvim settings here
    end
  },
}
