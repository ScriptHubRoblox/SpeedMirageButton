-- Speed Mirage Teleport (R6 & R15)
-- LocalScript, StarterGui
-- Teleports left/right to create multiple "versions" effect

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer
local workspace = workspace

-- Tunables
local SLIDE_DISTANCE = 10.       -- how far left/right per teleport
local SLIDE_SPEED = 0                -- seconds per teleport
local MIRAGE_COUNT = 4          -- number of rapid positions
local RANDOM_JITTER = 0.5      -- small Z/Y jitter for natural look

local toggled = false
local direction = 1
local lastSlide = 0

-- GUI
local gui = Instance.new("ScreenGui")
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

local btn = Instance.new("TextButton")
btn.Size = UDim2.new(0,140,0,44)
btn.Position = UDim2.new(0,20,0,160)
btn.BackgroundColor3 = Color3.fromRGB(30,30,30)
btn.TextColor3 = Color3.fromRGB(255,255,255)
btn.Font = Enum.Font.GothamBold
btn.TextScaled = true
btn.Text = "Speed Mirage: OFF"
btn.Parent = gui
btn.Draggable = true

btn.MouseButton1Click:Connect(function()
	toggled = not toggled
	btn.Text = toggled and "Speed Mirage: ON" or "Speed Mirage: OFF"
	btn.BackgroundColor3 = toggled and Color3.fromRGB(23,120,65) or Color3.fromRGB(30,30,30)
end)

-- Helpers
local function myChar() return player.Character end
local function getHRP()
	local ch = myChar()
	if ch then
		local hrp = ch:FindFirstChild("HumanoidRootPart")
		if hrp then return hrp end
	end
	return nil
end

-- Main Loop
RunService.Heartbeat:Connect(function(dt)
	if not toggled then return end

	local hrp = getHRP()
	if not hrp then return end

	lastSlide = lastSlide + dt
	if lastSlide >= SLIDE_SPEED then
		lastSlide = 0

		for i = 1, MIRAGE_COUNT do
			local multiplier = (i / MIRAGE_COUNT)
			local offsetDir = direction * SLIDE_DISTANCE * multiplier
			local jitterX = offsetDir
			local jitterZ = math.random() * RANDOM_JITTER - RANDOM_JITTER/2
			local jitterY = math.random() * RANDOM_JITTER/2
			local targetCFrame = hrp.CFrame + Vector3.new(jitterX, jitterY, jitterZ)
			-- teleport your HRP
			hrp.CFrame = targetCFrame
		end

		-- flip direction
		direction = -direction
	end
end)

