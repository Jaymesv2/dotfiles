require("avante_lib").load()
require("avante").setup({
  -- ---@alias Provider "claude" | "openai" | "azure" | "gemini" | "cohere" | "copilot" | string
  -- ---@type Provider
  -- provider = "openai", -- The provider used in Aider mode or in the planning phase of Cursor Planning Mode
  ---@alias Mode "agentic" | "legacy"
  ---@type Mode
  mode = "agentic", -- The default mode for interaction. "agentic" uses tools to automatically generate code, "legacy" uses the old planning method to generate code.
  -- WARNING: Since auto-suggestions are a high-frequency operation and therefore expensive,
  -- currently designating it as `copilot` provider is dangerous because: https://github.com/yetone/avante.nvim/issues/1048
  -- Of course, you can reduce the request frequency by increasing `suggestion.debounce`.
  --
  -- auto_suggestions_provider = "claude",
  -- providers = {
  --   claude = {
  --     endpoint = "https://api.anthropic.com",
  --     auth_type = "api" -- Set to "max" to sign in with Claude Pro/Max subscription
  --     model = "claude-3-5-sonnet-20241022",
  --     extra_request_body = {
  --       temperature = 0.75,
  --       max_tokens = 4096,
  --     },
  --   },
  -- },
  provider = "codex",
  acp_providers = {
    codex = {
      command = "codex-acp",
      args = {},
      env = {
        HOME = os.getenv("HOME"),
        PATH = os.getenv("PATH"),
      },
    },
  },
  auto_suggestions_provider = "openai",
  system_prompt = function()
    local hub = require("mcphub").get_hub_instance()
    return hub and hub:get_active_servers_prompt() or ""
  end,
  -- Using function prevents requiring mcphub before it's loaded
  custom_tools = function()
      return {
          require("mcphub.extensions.avante").mcp_tool(),
      }
  end,
})
