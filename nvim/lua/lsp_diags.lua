local M = {}

function M.diags_off()
    vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
      vim.lsp.diagnostic.on_publish_diagnostics, {
        signs = false,
        underline = false,
        update_in_insert = false,
        virtual_text = false
      }
    )
end

function M.diags_on()
    vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
      vim.lsp.diagnostic.on_publish_diagnostics, {
        signs = true,
        underline = true,
        update_in_insert = true,
        virtual_text = true
      }
    )
    vim.lsp.diagnostic.get(0,0)
end

return M
