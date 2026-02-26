require("mcphub").setup({
    cmd = "mcp-hub",
    extensions = {
        avante = {
            make_slash_commands = true, -- make /slash commands from MCP server prompts
        }
    }
    -- cmdArgs = {"/path/to/mcp-hub/src/utils/cli.js"},
})
