require('nvim-treesitter.configs').setup {
    ensure_installed = { 'help',
        'javascript', 'typescript', 'html', 'css', 'scss', 'json', 'tsx', 'vue',
        'c', 'cpp', 'cmake', 'make',
        'elixir', 'erlang',
        'lua',
        'go', 'gomod', 'gowork', 'proto',
        'markdown', -- 'org',
        'rust',
        'sql',
        'yaml',
        'dockerfile', },
    sync_install = false,
    auto_install = true,

    highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
    }
}

