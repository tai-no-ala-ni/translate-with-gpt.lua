local translateWithGpt = {}

-- get selected text from vim visual mode
translateWithGpt.getSelectedText = function()
	local vstart = vim.fn.getpos("'<")
	local vend = vim.fn.getpos("'>")
	local line_start = vstart[2]
	local line_end = vend[2]
	local char_start = vstart[3]
	local char_end = vend[3]
	local lines = vim.fn.getline(line_start, line_end)
	lines[1] = string.sub(lines[1], char_start)
	lines[#lines] = string.sub(lines[#lines], 1, char_end)
	local text = table.concat(lines, "\n")
	return text
end

local function exists(file)
	local ok, err, code = os.rename(file, file)
	if not ok then
		if code == 13 then
			return true
		end
	end
	return ok, err
end

local function starts_with(str, start)
	return str:sub(1, #start) == start
end

local function countLines(file)
	local count = 0
	for _ in io.lines(file) do
		count = count + 1
	end
	return count
end

translateWithGpt.checkApiKeyFile = function()
	--check if file exists
	local configDirectory = os.getenv("HOME") .. "/.config/translateWithGpt/"
	local apiKeyFile = "ApiKey"
	local checkDirectory = exists(configDirectory)
	if not checkDirectory then
		os.execute("mkdir -p " .. configDirectory)
	end
	local checkFile = exists(configDirectory .. apiKeyFile)
	if not checkFile then
		os.execute("touch " .. configDirectory .. apiKeyFile)
	end

	-- check if api key exists
	local apiKey = ""
	local apiKeyFromFile = io.open(configDirectory .. apiKeyFile, "rb")
	local apiKeyFromFileContent = apiKeyFromFile:read("*a")
	local apiKeyFromFileLines = countLines(configDirectory .. apiKeyFile)
	apiKeyFromFile:close()
	if starts_with(apiKeyFromFileContent, "sk-") and apiKeyFromFileLines == 1 then
		return apiKeyFromFileContent
	else
		vim.ui.input({ prompt = "Enter Your Chat GPT API Key: " }, function(input)
			apiKey = input
		end)
		local apiKeyFromFileWrite = io.open(configDirectory .. apiKeyFile, "w")
		apiKeyFromFileWrite:write(apiKey)
		apiKeyFromFileWrite:close()
	end
	return apiKey
end

local execute_cmd = function(cmd)
	local handle = io.popen(cmd)
	local result = handle:read("*a")
	handle:close()

	return result
end

translateWithGpt.sendSelectedText = function(text, apiKey)
	local payload = {
		model = "gpt-3.5-turbo",
		messages = { { role = "user", content = "以下の文章を日本語に翻訳してください\n" .. text } },
	}
	local url = "https://api.openai.com/v1/chat/completions"
	local body = '{"model":"gpt-3.5-turbo","messages":[{"content":"'
		.. "次の文章を日本語に翻訳してください: "
		.. text
		.. '","role":"user"}]}'

	local curl_command = "curl -s "
		.. url
		.. " -H 'Content-Type: application/json' "
		.. " -H 'Authorization: Bearer "
		.. apiKey
		.. "'"
		.. " -d '"
		.. body
		.. "'"
		.. " | jq .choices[0].message.content"
	--print("curl_command: " .. curl_command)

	local result = execute_cmd(curl_command)
	return result
end

return translateWithGpt
