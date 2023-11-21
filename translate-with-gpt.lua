package.loaded["translate-with-gpt/module"] = nil
local translateWithGpt = require("translate-with-gpt/module")

local text = translateWithGpt.getSelectedText()

--print(string.format("text: %s", vim.inspect(text)))

local apiKey = translateWithGpt.checkApiKeyFile()

local result = translateWithGpt.sendSelectedText(text, apiKey)

print(result)
