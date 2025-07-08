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
------23323323232

local ScrollFrame = Instance.new("ScrollingFrame", Frame)
ScrollFrame.Size = UDim2.new(1, 0, 1, -30)
ScrollFrame.Position = UDim2.new(0, 0, 0, 30)
ScrollFrame.CanvasSize = UDim2.new(0, 0, 0, 1130) -----------------------------------------------------------------------------------------------каждая кнопка +20
ScrollFrame.ScrollBarThickness = 5
ScrollFrame.BackgroundTransparency = 1

local UIListLayout = Instance.new("UIListLayout", ScrollFrame)
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Padding = UDim.new(0, 5)

-- Заголовок
local UIListLayout = Instance.new("UIListLayout", ScrollFrame)
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Padding = UDim.new(0, 5)

-- Заголовок
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local isMenuMinimized = false
local fullSize = UDim2.new(0, 130, 0, 350)
local minimizedSize = UDim2.new(0, 130, 0, 30)

-- Настройка окна
Frame.AnchorPoint = Vector2.new(0, 0)
Frame.Position = UDim2.new(0, 150, 0, 20)
Frame.Active = true
Frame.Selectable = true

-- Заголовок
local Title = Instance.new("TextButton", Frame)
Title.Size = UDim2.new(0, 120, 0, 20)
Title.Position = UDim2.new(0, 5, 0, 5)
Title.Text = "Discord hacker2.02541\n Project codebugV3.7\n add:bind"
Title.TextSize = 7
Title.BackgroundTransparency = 1
Title.TextColor3 = Color3.new(1, 1, 1)
Title.TextStrokeTransparency = 0.5
Title.AutoButtonColor = false

-- Сворачивание
Title.MouseButton1Click:Connect(function()
    isMenuMinimized = not isMenuMinimized

    local targetSize = isMenuMinimized and minimizedSize or fullSize
    local tween = TweenService:Create(Frame, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        Size = targetSize
    })
    tween:Play()

    ScrollFrame.Visible = not isMenuMinimized
end)

-- Перетаскивание за заголовок (и мышь, и тач)
local dragging = false
local dragStart, startPos

local function update(input)
    local delta = input.Position - dragStart
    Frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X,
                               startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end

Title.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
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

UserInputService.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        update(input)
    end
end)

local function createTextField(placeholderText, callback)
    local textField = Instance.new("TextBox", ScrollFrame)
    textField.Size = UDim2.new(0, 120, 0, 20)
    textField.Text = ""
    textField.PlaceholderText = placeholderText
    textField.TextSize = 10
    textField.BackgroundColor3 = Color3.fromRGB(118, 41, 187)
    textField.TextColor3 = Color3.new(10, 37, 35)
    textField.ClearTextOnFocus = true
    textField.TextBoxColor3 = Color3.fromRGB(35, 35, 35)

    -- Добавление обводки синим цветом
    local textFieldStroke = Instance.new("UIStroke", textField)
    textFieldStroke.Color = Color3.fromRGB(10, 0, 120)
    textFieldStroke.Thickness = 2
    textFieldStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

    textField.Focused:Connect(function()
        callback(textField.Text)
    end)

    return textField
end
local UserInputService = game:GetService("UserInputService")
local keyBinds = {}
local waitingForBind = nil

local function createButton(text, callback, toggleHighlight, allowBinding)
    local btn = Instance.new("TextButton", ScrollFrame)
    btn.Size = UDim2.new(0, 120, 0, 18)
    btn.Text = text
    btn.TextSize = 10
    btn.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    btn.TextColor3 = Color3.new(10, 37, 35)
    btn.Selectable = false
    btn.AutoButtonColor = false

    local stroke = Instance.new("UIStroke", btn)
    stroke.Color = Color3.fromRGB(0, 0, 255)
    stroke.Thickness = 1
    stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 3)
    UICorner.Parent = btn

    local toggled = false
    local originalText = text

    local function runCallback()
        if toggleHighlight then
            toggled = not toggled
            btn.BackgroundColor3 = toggled and Color3.fromRGB(0, 80, 23) or Color3.fromRGB(0, 0, 0)
        end
        callback(btn)
    end

    btn.Activated:Connect(runCallback)

    -- Только если разрешён биндинг
    if allowBinding then
        btn.MouseButton2Click:Connect(function() -- ПКМ (MouseButton2)
            waitingForBind = {
                button = btn,
                callback = callback,
                originalText = originalText,
                highlight = toggleHighlight,
                toggled = toggled,
            }
            btn.Text = "[binding...]"
        end)
    end

    return btn
end

-- Обработка ввода
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end

    if waitingForBind then
        local btn = waitingForBind.button
        local callback = waitingForBind.callback
        local originalText = waitingForBind.originalText

        if input.KeyCode == Enum.KeyCode.Delete then
            keyBinds[btn] = nil
            btn.Text = originalText
            -- Сброс цвета
            if waitingForBind.highlight then
                btn.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
            end
        else
            keyBinds[btn] = {
                key = input.KeyCode,
                callback = callback,
                toggled = waitingForBind.toggled or false,
                highlight = waitingForBind.highlight,
                originalText = originalText,
            }
            btn.Text = originalText .. " [" .. input.KeyCode.Name .. "]"
        end
        waitingForBind = nil
    else
        for btn, data in pairs(keyBinds) do
            if data.key == input.KeyCode then
                if data.highlight then
                    data.toggled = not data.toggled
                    btn.BackgroundColor3 = data.toggled and Color3.fromRGB(0, 80, 23) or Color3.fromRGB(0, 0, 0)
                end
                data.callback(btn)
            end
        end
    end
end)

local UserInputService = game:GetService("UserInputService")
local MenuVisible = true -- чтобы можно было управлять видимостью

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed and input.KeyCode == Enum.KeyCode.RightControl then
        MenuVisible = not MenuVisible
        Frame.Visible = MenuVisible
        topLabel.Visible = MenuVisible
    end
end)

-- Переменные
local AimbotTarget = "Head"
-- Круг обзора
local FOVCircle = Drawing.new("Circle")
FOVCircle.Thickness = 1.5
FOVCircle.Color = Color3.new(5, 0, 0)
FOVCircle.Transparency = 0.5
FOVCircle.Visible = true
FOVCircle.Filled = false

-- Глобальная переменная для TeamCheck
local AimbotTeamCheck = false

-- Поиск цели
local function getClosestTarget()
    local target, minDist = nil, FOV
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild(AimbotTarget) then
            if AimbotTeamCheck and player.Team == LocalPlayer.Team then continue end

            local humanoid = player.Character:FindFirstChild("Humanoid")
            if humanoid and humanoid.Health > 0 then
                local part = player.Character[AimbotTarget]
                local screenPos, onScreen = Camera:WorldToViewportPoint(part.Position)
                if onScreen then
                    local dist = (Vector2.new(screenPos.X, screenPos.Y) - Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)).Magnitude
                    if dist < minDist then
                        if AimWallhack then
                            target, minDist = part, dist
                        else
                            local rayParams = RaycastParams.new()
                            rayParams.FilterDescendantsInstances = {LocalPlayer.Character}
                            rayParams.FilterType = Enum.RaycastFilterType.Blacklist
                            local ray = workspace:Raycast(Camera.CFrame.Position, (part.Position - Camera.CFrame.Position).Unit * 500, rayParams)
                            if ray and ray.Instance and ray.Instance:IsDescendantOf(player.Character) then
                                target, minDist = part, dist
                            end
                        end
                    end
                end
            end
        end
    end
    return target
end

-- Плавная наводка (если используешь в RenderStepped)
RunService.RenderStepped:Connect(function(dt)
    if AimbotEnabled then
        local target = getClosestTarget()
        if target then
            local camPos = Camera.CFrame.Position
            local targetDir = (target.Position - camPos).Unit
            local desiredCFrame = CFrame.new(camPos, camPos + targetDir)
            Camera.CFrame = Camera.CFrame:Lerp(desiredCFrame, math.clamp(dt * (1 / AimSmoothness), 0, 1))
        end
    end
end)

-- Bring Players Function
local function bringPlayers()
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            player.Character.HumanoidRootPart.CFrame = LocalPlayer.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, -10)
        end
    end
end

-- Main Render Loop
RunService.RenderStepped:Connect(function()
    -- FOV Circle
    FOVCircle.Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
    FOVCircle.Radius = FOV
    FOVCircle.Visible = AimbotEnabled

    -- Aimbot
    if AimbotEnabled then
        local target = getClosestTarget()
        if target then
            Camera.CFrame = CFrame.lookAt(Camera.CFrame.Position, target.Position)
        end
    end

    -- Bring All
    if BringEnabled then bringPlayers() end

    -- NoClip
    if NoClipEnabled and LocalPlayer.Character then
        for _, part in ipairs(LocalPlayer.Character:GetChildren()) do
            if part:IsA("BasePart") then part.CanCollide = false end
        end
    end

    -- SpinBot
    if SpinSpeed > 0 and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local hrp = LocalPlayer.Character.HumanoidRootPart
        hrp.CFrame = hrp.CFrame * CFrame.Angles(0, math.rad(SpinSpeed), 0)
    end

if HitboxSize > 1.5 then
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local hrp = player.Character.HumanoidRootPart
            hrp.Size = Vector3.new(HitboxSize, HitboxSize, HitboxSize)
            hrp.Transparency = 0.4
            hrp.CanCollide = false
        end
    end
elseif HitboxSize == 0 then
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local hrp = player.Character.HumanoidRootPart
            hrp.Size = Vector3.new(2, 2, 1) -- стандартный размер
            hrp.Transparency = 0
            hrp.CanCollide = true
        end
    end
end
end)
