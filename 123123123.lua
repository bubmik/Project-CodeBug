local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer
local Drawing = Drawing or require(game:GetService("CoreGui"):FindFirstChildOfClass("ModuleScript")) 

local AimbotEnabled, AimWallhack, ESPEnabled, BringEnabled, NoClipEnabled, TurboModeEnabledB, FallOverEnabled, HitboxSize = false, false, false, false, false, false, false, false, false
local FOV, SpinSpeed, HitboxSize = 50, 0, 1.5
local ESPObjects, MenuVisible = {}, true
local AimbotTarget = "Head"

local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
local Frame = Instance.new("Frame", ScreenGui)
Frame.Size = UDim2.new(0, 130, 0, 330)
Frame.Position = UDim2.new(0, Camera.ViewportSize.X / 2 - 200, 0, Camera.ViewportSize.Y / 2 - 230)
Frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0) -- сделать позже черный цвет
Frame.BorderSizePixel = 2
Frame.BorderColor3 = Color3.fromRGB(0, 0, 150)
Frame.Active = true  -- Позволяет взаимодействовать с объектом

-- Надпись сверху
local topLabel = Instance.new("TextLabel", ScreenGui)
topLabel.Size = UDim2.new(0, 400, 0, 40)
topLabel.Position = UDim2.new(0.5, -200, 0, 10) -- по центру
topLabel.BackgroundTransparency = 0.6
topLabel.Text = "project codebug-name smooth ware,created hacker2.02541\n add: bullet tp.  trigger bot. new anti aim.\n smooth ware v3.7 pc"
topLabel.Font = Enum.Font.GothamBlack
topLabel.TextSize = 20
topLabel.TextStrokeTransparency = 1
topLabel.TextColor3 = Color3.fromRGB(128, 0, 255)

local currentIndex = 1
task.spawn(function()
    while true do
        local nextIndex = (currentIndex % #colors) + 1
        local tween = TweenService:Create(topLabel, TweenInfo.new(1, Enum.EasingStyle.Linear), {
            TextColor3 = colors[nextIndex]
        })
        tween:Play()
        tween.Completed:Wait()
        currentIndex = nextIndex
    end
end)


local dragging, dragInput, dragStart, startPos

local function updateInput(input)
    local delta = input.Position - dragStart
    Frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end

Frame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = Frame.Position

        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then 
                dragging = false
            end
        end)
    end
end)

Frame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseMovement then
        dragInput = input
    end
end)

game:GetService("UserInputService").InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        updateInput(input)
    end
end)
