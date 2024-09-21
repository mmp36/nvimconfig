return {
  "mfussenegger/nvim-lint",
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    local lint = require("lint")

    lint.linters_by_ft = {
      javascript = { "eslint_d" },
      typescript = { "eslint_d" },
      javascriptreact = { "eslint_d" },
      typescriptreact = { "eslint_d" },
      svelte = { "eslint_d" },
      python = { "pylint" },
      php = { "pint" },  -- Use Laravel Pint for PHP files
    }

    -- Define the Pint linter for PHP
    lint.linters.pint = {
      cmd = "./vendor/bin/pint",  -- Correct path to Pint
      args = { "." },  -- Run Pint on the current directory
      stdin = false,
    }

    -- Create an autogroup for linting events
    local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })

    -- Trigger linting on specific events
    vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
      group = lint_augroup,
      callback = function()
        lint.try_lint()
      end,
    })

    -- Key mapping to manually trigger linting
    vim.keymap.set("n", "<leader>l", function()
      lint.try_lint()
    end, { desc = "Trigger linting for current file" })
  end,
}
