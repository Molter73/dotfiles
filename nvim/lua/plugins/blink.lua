return {
    'saghen/blink.cmp',
    -- optional: provides snippets for the snippet source
    dependencies = { 'rafamadriz/friendly-snippets' },
    version = '1.*',
    event = 'InsertEnter',
    build = 'cargo build --release',
    opts = {
        keymap = {
            preset = 'enter',
        },
        completion = {
            documentation = {
                auto_show = true,
            },
        },
        fuzzy = {
            implementation = 'rust',
            prebuilt_binaries = {
                download = false,
            },
        },
    },
}
