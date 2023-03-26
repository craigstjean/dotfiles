require('cloak').setup({
    enabled = true,
    cloak_character = '*',
    highlight_group = 'Comment',
    paterns = {
        {
            file_pattern = {
                '.env*',
                'wrangler.toml',
                '.dev.vars',
                '.properties',
            },
            cloak_pattern = '=.+'
        },
    },
})

