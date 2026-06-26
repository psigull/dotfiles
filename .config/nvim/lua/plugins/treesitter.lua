return {
    source = 'arborist-ts/arborist.nvim',
    config = function()
        require('arborist').setup({
            ensure_installed = df.tslangs
        })
    end
}
