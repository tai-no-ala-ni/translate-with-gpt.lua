package.loaded["translate-with-gpt/module"] = nil

local M = {}

function M.translate()
	local translateWithGpt = require("translate-with-gpt/module")

	local text = translateWithGpt.getSelectedText()

	local apiKey = translateWithGpt.checkApiKeyFile()

	local result = translateWithGpt.sendSelectedText(text, apiKey)

	print(result)
end

return M
