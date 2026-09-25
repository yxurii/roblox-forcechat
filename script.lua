--[================================================================================]--
-- READ ME READ ME READ ME READ ME READ ME READ ME READ ME READ ME
--  REQUIRES A VULNERABILITY TO WORK OR IT WONT BE SERVER SIDED.
--  An Exposed Server-Sided Backdoor (Require Script):
--  An Unsecured RemoteEvent (Lack of Sanity Checks):
-- you need one of theres vulnerabilitys. check a games vulnerabilitys with this.
--  
--[================================================================================]--

local Players = game:GetService("Players")
local ChatService = game:GetService("Chat")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local guiParent = (RunService:IsStudio() and playerGui) or (pcall(function() return CoreGui:GetChildren() end) and CoreGui or playerGui)

if guiParent:FindFirstChild("AdvancedFakeChatGui") then
	guiParent.AdvancedFakeChatGui:Destroy()
end

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "AdvancedFakeChatGui"
screenGui.ResetOnSpawn = false
screenGui.DisplayOrder = 999
screenGui.Parent = guiParent

local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 320, 0, 260)
mainFrame.Position = UDim2.new(0.5, -160, 0.5, -130)
mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = screenGui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 10)
corner.Parent = mainFrame

local stroke = Instance.new("UIStroke")
stroke.Color = Color3.fromRGB(45, 45, 60)
stroke.Thickness = 2
stroke.Parent = mainFrame

-- Title Bar
local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, 0, 0, 40)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "  ⚡ Force Chat Studio v3.5"
titleLabel.TextColor3 = Color3.fromRGB(240, 240, 255)
titleLabel.TextSize = 15
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.Parent = mainFrame

-- 3. Input Fields Setup Helper
local function createTextBox(placeholder, posY)
	local box = Instance.new("TextBox")
	box.Size = UDim2.new(0, 280, 0, 40)
	box.Position = UDim2.new(0, 20, 0, posY)
	box.BackgroundColor3 = Color3.fromRGB(30, 30, 38)
	box.TextColor3 = Color3.fromRGB(255, 255, 255)
	box.PlaceholderText = placeholder
	box.PlaceholderColor3 = Color3.fromRGB(110, 110, 130)
	box.Text = ""
	box.TextSize = 14
	box.Font = Enum.Font.GothamMedium
	box.ClearTextOnFocus = false
	box.Parent = mainFrame

	local boxCorner = Instance.new("UICorner")
	boxCorner.CornerRadius = UDim.new(0, 6)
	boxCorner.Parent = box

	local boxStroke = Instance.new("UIStroke")
	boxStroke.Color = Color3.fromRGB(50, 50, 65)
	boxStroke.Thickness = 1
	boxStroke.Parent = box
	
	return box
end

local playerInput = createTextBox("Target Player (Name or Display Name)...", 50)
local messageInput = createTextBox("Enter chat message text...", 100)

local statusLabel = Instance.new("TextLabel")
statusLabel.Size = UDim2.new(0, 280, 0, 20)
statusLabel.Position = UDim2.new(0, 20, 0, 145)
statusLabel.BackgroundTransparency = 1
statusLabel.Text = "Status: Ready"
statusLabel.TextColor3 = Color3.fromRGB(130, 130, 160)
statusLabel.TextSize = 12
statusLabel.Font = Enum.Font.Gotham
statusLabel.TextXAlignment = Enum.TextXAlignment.Left
statusLabel.Parent = mainFrame

local sendButton = Instance.new("TextButton")
sendButton.Size = UDim2.new(0, 280, 0, 45)
sendButton.Position = UDim2.new(0, 20, 0, 185)
sendButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
sendButton.Text = "TRIGGER CHAT BUBBLE"
sendButton.TextColor3 = Color3.fromRGB(255, 255, 255)
sendButton.TextSize = 14
sendButton.Font = Enum.Font.GothamBold
sendButton.Parent = mainFrame

local btnCorner = Instance.new("UICorner")
btnCorner.CornerRadius = UDim.new(0, 6)
btnCorner.Parent = sendButton

local gradient = Instance.new("UIGradient")
gradient.Color = ColorSequence.new({
	ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 120, 255)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 200, 120))
})
gradient.Rotation = 45
gradient.Parent = sendButton

-- 6. Advanced Target Matcher Logic (Fuzzy + Partial Matching)
local function advancedFindPlayer(searchQuery)
	if not searchQuery or searchQuery == "" then return nil end
	searchQuery = string.lower(searchQuery)
	
	-- Exact match check first
	for _, p in ipairs(Players:GetPlayers()) do
		if string.lower(p.Name) == searchQuery or string.lower(p.DisplayName) == searchQuery then
			return p
		end
	end
	
	-- Partial match check fallback
	for _, p in ipairs(Players:GetPlayers()) do
		if string.sub(string.lower(p.Name), 1, #searchQuery) == searchQuery or 
		   string.sub(string.lower(p.DisplayName), 1, #searchQuery) == searchQuery then
			return p
		end
	end
	
	return nil
end

local function updateStatus(text, color)
	statusLabel.Text = text
	statusLabel.TextColor3 = color or Color3.fromRGB(130, 130, 160)
	
	-- Quick subtle pulse animation on status change
	local tweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
	TweenService:Create(statusLabel, tweenInfo, {TextSize = 13}):Play()
	task.delay(0.2, function()
		TweenService:Create(statusLabel, tweenInfo, {TextSize = 12}):Play()
	end)
end

local isCooldown = false

sendButton.MouseButton1Click:Connect(function()
	if isCooldown then return end
	
	local targetQuery = playerInput.Text
	local messageText = messageInput.Text

	if targetQuery == "" or messageText == "" then
		updateStatus("Error: Fields cannot be empty!", Color3.fromRGB(255, 80, 80))
		return
	end

	local targetPlayer = advancedFindPlayer(targetQuery)
	if not targetPlayer then
		updateStatus("Error: Player not found!", Color3.fromRGB(255, 80, 80))
		return
	end

	local character = targetPlayer.Character
	if not character then
		updateStatus("Error: Target character missing!", Color3.fromRGB(255, 80, 80))
		return
	end
	
	local head = character:FindFirstChild("Head")
	if not head then
		updateStatus("Error: Target Head part not found!", Color3.fromRGB(255, 80, 80))
		return
	end


	isCooldown = true
	local pressTween = TweenService:Create(sendButton, TweenInfo.new(0.1), {Size = UDim2.new(0, 270, 0, 42), Position = UDim2.new(0, 25, 0, 187)})
	pressTween:Play()
	pressTween.Completed:Wait()
	
	local releaseTween = TweenService:Create(sendButton, TweenInfo.new(0.1), {Size = UDim2.new(0, 280, 0, 45), Position = UDim2.new(0, 20, 0, 185)})
	releaseTween:Play()

	local success, err = pcall(function()
		ChatService:Chat(head, messageText, Enum.ChatColor.White)
	end)

	if success then
		updateStatus("Success: Chat sent for " .. targetPlayer.Name, Color3.fromRGB(80, 255, 120))
		messageInput.Text = ""
	else
		updateStatus("Execution Failed!", Color3.fromRGB(255, 80, 80))
	end

	-- Cooldown reset timer
	task.delay(0.8, function()
		isCooldown = false
	end)
end)
