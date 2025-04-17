
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer
local Drawing = Drawing or require(game:GetService("CoreGui"):FindFirstChildOfClass("ModuleScript"))

local Players = game:GetService("Players")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

local AimbotEnabled, AimWallhack, ESPEnabled, BringEnabled, NoClipEnabled, TurboModeEnabled, FallOverEnabled = false, false, false, false, false, false, false, false
local FOV, SpinSpeed, HitboxSize = 50, 0, 1.5
local ESPObjects, MenuVisible = {}, true
local AimbotTarget = "Head"

local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
local Frame = Instance.new("Frame", ScreenGui)
Frame.Size = UDim2.new(0, 130, 0, 330)
Frame.Position = UDim2.new(0, Camera.ViewportSize.X / 2 - 200, 0, Camera.ViewportSize.Y / 2 - 230)
Frame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
Frame.BorderSizePixel = 2
Frame.BorderColor3 = Color3.fromRGB(35, 35, 35)
Frame.Active = true  -- Позволяет взаимодействовать с объектом

-- Делаем меню перетаскиваемым
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

-- Добавляем ScrollFrame для прокрутки
local ScrollFrame = Instance.new("ScrollingFrame", Frame)
ScrollFrame.Size = UDim2.new(1, 0, 1, -30)
ScrollFrame.Position = UDim2.new(0, 0, 0, 30)
ScrollFrame.CanvasSize = UDim2.new(0, 0, 0, 570)
ScrollFrame.ScrollBarThickness = 5
ScrollFrame.BackgroundTransparency = 1

local UIListLayout = Instance.new("UIListLayout", ScrollFrame)
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Padding = UDim.new(0, 5)

-- Заголовок
local Title = Instance.new("TextLabel", Frame)
Title.Size = UDim2.new(0, 120, 0, 20)
Title.Position = UDim2.new(0, 5, 0, 5)
Title.Text = "Discord hacker2.02541\n codebugV2.8\n add: "
Title.TextSize = 7
Title.BackgroundTransparency = 1
Title.TextColor3 = Color3.new(1, 1, 1)
Title.TextStrokeTransparency = 0.5

-- Кнопка отображения меню (Теперь тоже перетаскиваемая)
local ToggleMenuBtn = Instance.new("TextButton", ScreenGui)
ToggleMenuBtn.Size = UDim2.new(0, 60, 0, 20)
ToggleMenuBtn.Position = UDim2.new(0, 10, 0, 10)
ToggleMenuBtn.Text = "Menu⚙️"
ToggleMenuBtn.TextSize = 10
ToggleMenuBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
ToggleMenuBtn.TextColor3 = Color3.new(1, 1, 1)

ToggleMenuBtn.MouseButton1Click:Connect(function()
    MenuVisible = not MenuVisible
    Frame.Visible = MenuVisible
end)

-- Перетаскивание кнопки меню
local draggingBtn, dragInputBtn, dragStartBtn, startPosBtn

local function updateInputBtn(input)
    local delta = input.Position - dragStartBtn
    ToggleMenuBtn.Position = UDim2.new(startPosBtn.X.Scale, startPosBtn.X.Offset + delta.X, startPosBtn.Y.Scale, startPosBtn.Y.Offset + delta.Y)
end

ToggleMenuBtn.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
        draggingBtn = true
        dragStartBtn = input.Position
        startPosBtn = ToggleMenuBtn.Position

        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                draggingBtn = false
            end
        end)
    end
end)

ToggleMenuBtn.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseMovement then
        dragInputBtn = input
    end
end)

game:GetService("UserInputService").InputChanged:Connect(function(input)
    if input == dragInputBtn and draggingBtn then
        updateInputBtn(input)
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
    textFieldStroke.Color = Color3.fromRGB(150, 0, 0)
    textFieldStroke.Thickness = 2
    textFieldStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

    textField.Focused:Connect(function()
        callback(textField.Text)
    end)

    return textField
end

local function createButton(text, callback)
    local btn = Instance.new("TextButton", ScrollFrame)
    btn.Size = UDim2.new(0, 120, 0, 18)
    btn.Text = text
    btn.TextSize = 10
    btn.BackgroundColor3 = Color3.fromRGB(5, 10, 125)
    btn.TextColor3 = Color3.new(10, 37, 35)

    -- Добавление обводки синим цветом
    local buttonStroke = Instance.new("UIStroke", btn)
    buttonStroke.Color = Color3.fromRGB(0, 0, 35)
    buttonStroke.Thickness = 0.5
    buttonStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

    btn.MouseButton1Click:Connect(callback)
end

-- FOV Circle
local FOVCircle = Drawing.new("Circle")
FOVCircle.Thickness = 2
FOVCircle.Color = Color3.new(1, 0, 0)
FOVCircle.Transparency = 0.5
FOVCircle.Visible = true
FOVCircle.Filled = false

-- Aimbot Target Search
local function getClosestTarget()
    local target, minDist = nil, FOV
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild(AimbotTarget) then
            local humanoid = player.Character:FindFirstChild("Humanoid")
            if humanoid and humanoid.Health > 0 then  -- Проверяем, жив ли игрок
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

    -- Hitbox Resize
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local hrp = player.Character.HumanoidRootPart
            hrp.Size = Vector3.new(HitboxSize, HitboxSize, HitboxSize)
            hrp.Transparency = 0.2
            hrp.CanCollide = false
        end
    end
end)

-- Turbo Speed
local DefaultWalkSpeed = nil -- Сюда запоминаем стандартную скорость

RunService.RenderStepped:Connect(function()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        local humanoid = LocalPlayer.Character.Humanoid

        if TurboModeEnabled then
            -- Сохраняем стандартную скорость один раз
            if not DefaultWalkSpeed then
                DefaultWalkSpeed = humanoid.WalkSpeed
            end
            humanoid.WalkSpeed = 106
        else
            -- Возвращаем сохранённую скорость
            if DefaultWalkSpeed then
                humanoid.WalkSpeed = DefaultWalkSpeed
                DefaultWalkSpeed = nil -- сбрасываем для следующего включения
            end
        end
    end
end)

-- Anti Aim / Fall Over
RunService.Heartbeat:Connect(function()
    if FallOverEnabled and LocalPlayer.Character then
        local humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        local hrp = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if humanoid and hrp then
            hrp.CFrame = hrp.CFrame * CFrame.Angles(0, math.rad(180), 0)
        end
    end
end)

-- Получаем сервисы
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

local ESPEnabled = false
local ESPObjects = {}

-- Функция для создания ESP Box
local function createESPBox()
    local espBox = Drawing.new("Square")
    espBox.Visible = false
    espBox.Color = Color3.fromRGB(0, 0, 255)
    espBox.Thickness = 1
    espBox.Filled = false
    return espBox
end

-- Функция включения/выключения ESP
local function toggleESP()
    ESPEnabled = not ESPEnabled
    if not ESPEnabled then
        -- Удаление старого ESP, когда ESP выключен
        for player, v in pairs(ESPObjects) do
            if v.Box then v.Box:Remove() end
        end
        ESPObjects = {}  -- Очищаем хранилище объектов ESP
    end
end

-- Удаляем ESP при выходе игрока
Players.PlayerRemoving:Connect(function(player)
    if ESPObjects[player] then
        if ESPObjects[player].Box then ESPObjects[player].Box:Remove() end
        ESPObjects[player] = nil
    end
end)

-- Функция обновления ESP с динамическим масштабом
local function updateESP()
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            if not ESPObjects[player] then
                -- Создание ESP Box
                local espBox = createESPBox()

                ESPObjects[player] = {Box = espBox}
            end

            local hrp = player.Character.HumanoidRootPart
            local screenPos, onScreen = Camera:WorldToViewportPoint(hrp.Position)

            if onScreen and ESPEnabled then
                local distance = (Camera.CFrame.Position - hrp.Position).Magnitude
                -- Чем дальше — тем меньше размер ESP
                local sizeFactor = math.clamp(1 - (distance / 150), 0.2, 0.7)

                -- Обновление ESP Box
                local espBox = ESPObjects[player].Box
                espBox.Size = Vector2.new(50 * sizeFactor, 50 * sizeFactor)
                espBox.Position = Vector2.new(screenPos.X - (25 * sizeFactor), screenPos.Y - (25 * sizeFactor))
                espBox.Visible = true
            else
                -- Если не на экране - удалить ESP этого игрока
                if ESPObjects[player] then
                    ESPObjects[player].Box:Remove()
                    ESPObjects[player] = nil
                end
            end
        elseif ESPObjects[player] then
            -- Удаляем ESP если игрока нет или пропал
            ESPObjects[player].Box:Remove()
            ESPObjects[player] = nil
        end
    end
end

-- Обновление ESP в каждом кадре
RunService.RenderStepped:Connect(function()
    if ESPEnabled then
        updateESP()
    end
end)

-- Получаем сервисы
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

local ESPEnabled = false
local ESPObjects = {}

-- Функция для создания ESP Line
local function createESPLine()
    local espLine = Drawing.new("Line")
    espLine.Visible = false
    espLine.Color = Color3.fromRGB(0, 0, 255)
    espLine.Thickness = 1
    return espLine
end

-- Функция включения/выключения ESP
local function toggleESP2()
    ESPEnabled = not ESPEnabled
    if not ESPEnabled then
        -- Удаление старого ESP, когда ESP выключен
        for player, v in pairs(ESPObjects) do
            if v.Line then v.Line:Remove() end
        end
        ESPObjects = {}  -- Очищаем хранилище объектов ESP
    end
end

-- Удаляем ESP при выходе игрока
Players.PlayerRemoving:Connect(function(player)
    if ESPObjects[player] then
        if ESPObjects[player].Line then ESPObjects[player].Line:Remove() end
        ESPObjects[player] = nil
    end
end)

-- Функция обновления ESP с динамическим масштабом
local function updateESP()
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            if not ESPObjects[player] then
                -- Создание ESP Line
                local espLine = createESPLine()

                ESPObjects[player] = {Line = espLine}
            end

            local hrp = player.Character.HumanoidRootPart
            local screenPos, onScreen = Camera:WorldToViewportPoint(hrp.Position)

            if onScreen and ESPEnabled then
                -- Обновление ESP Line
                local espLine = ESPObjects[player].Line
                espLine.From = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
                espLine.To = Vector2.new(screenPos.X, screenPos.Y)
                espLine.Visible = true
            else
                -- Если не на экране - удалить ESP этого игрока
                if ESPObjects[player] then
                    ESPObjects[player].Line:Remove()
                    ESPObjects[player] = nil
                end
            end
        elseif ESPObjects[player] then
            -- Удаляем ESP если игрока нет или пропал
            ESPObjects[player].Line:Remove()
            ESPObjects[player] = nil
        end
    end
end

-- Обновление ESP в каждом кадре
RunService.RenderStepped:Connect(function()
    if ESPEnabled then
        updateESP()
    end
end)

-- Получаем сервисы
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

local ESPEnabled = false
local ESPObjects = {}

-- Функция включения/выключения ESP
local function toggleESP3()
    ESPEnabled = not ESPEnabled
    if not ESPEnabled then
        -- Удаление старого ESP, когда ESP выключен
        for player, v in pairs(ESPObjects) do
            if v.Name then v.Name:Remove() end
        end
        ESPObjects = {}  -- Очищаем хранилище объектов ESP
    end
end

-- Удаляем ESP при выходе игрока
Players.PlayerRemoving:Connect(function(player)
    if ESPObjects[player] then
        if ESPObjects[player].Name then ESPObjects[player].Name:Remove() end
        ESPObjects[player] = nil
    end
end)

-- Функция обновления ESP с динамическим масштабом
local function updateESP()
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            if not ESPObjects[player] then
                -- Создание Name ESP
                local espName = Drawing.new("Text")
                espName.Visible = false
                espName.Color = Color3.fromRGB(255, 50, 5)
                espName.Size = 10
                espName.Center = true
                espName.Outline = true

                ESPObjects[player] = {Name = espName}
            end

            local hrp = player.Character.HumanoidRootPart
            local screenPos, onScreen = Camera:WorldToViewportPoint(hrp.Position)

            if onScreen and ESPEnabled then
                local distance = (Camera.CFrame.Position - hrp.Position).Magnitude
                -- Чем дальше — тем меньше размер ESP
                local sizeFactor = math.clamp(1 - (distance / 150), 0.2, 0.7)

                -- Обновление Name ESP
                local espName = ESPObjects[player].Name
                espName.Text = player.Name
                espName.Position = Vector2.new(screenPos.X, screenPos.Y - (30 * sizeFactor))
                espName.Visible = true
            else
                -- Если не на экране - удалить ESP этого игрока
                if ESPObjects[player] then
                    ESPObjects[player].Name:Remove()
                    ESPObjects[player] = nil
                end
            end
        elseif ESPObjects[player] then
            -- Удаляем ESP если игрока нет или пропал
            ESPObjects[player].Name:Remove()
            ESPObjects[player] = nil
        end
    end
end

-- Обновление ESP в каждом кадре
RunService.RenderStepped:Connect(function()
    if ESPEnabled then
        updateESP()
    end
end)

-- Функция для включения/выключения Fly Jump
local FlyJumpEnabled = false
local JumpConnection

local function toggleFlyJump()
    FlyJumpEnabled = not FlyJumpEnabled
    if FlyJumpEnabled then
        JumpConnection = game:GetService("UserInputService").JumpRequest:Connect(function()
            local character = LocalPlayer.Character
            if character and character:FindFirstChildOfClass("Humanoid") then
                character:FindFirstChildOfClass("Humanoid"):ChangeState(Enum.HumanoidStateType.Jumping)
            end
        end)
    else
        if JumpConnection then
            JumpConnection:Disconnect()
            JumpConnection = nil
        end
    end
end

-- Получаем сервисы
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

local ESPEnabled = false
local ESPObjects = {}

-- Функция включения/выключения ESP здоровья
local function toggleESPHealth()
    ESPEnabled = not ESPEnabled
    if not ESPEnabled then
        -- Удаление старого ESP, когда ESP выключен
        for player, v in pairs(ESPObjects) do
            if v.Health then v.Health:Remove() end
        end
        ESPObjects = {}  -- Очищаем хранилище объектов ESP
    end
end

-- Удаляем ESP при выходе игрока
Players.PlayerRemoving:Connect(function(player)
    if ESPObjects[player] then
        if ESPObjects[player].Health then ESPObjects[player].Health:Remove() end
        ESPObjects[player] = nil
    end
end)

-- Функция обновления ESP с динамическим цветом здоровья
local function updateESP()
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") and player.Character:FindFirstChild("Humanoid") then
            if not ESPObjects[player] then
                -- Создание ESP для здоровья
                local espHealth = Drawing.new("Text")
                espHealth.Visible = false
                espHealth.Size = 10
                espHealth.Center = true
                espHealth.Outline = true
                ESPObjects[player] = {Health = espHealth}
            end

            local humanoid = player.Character.Humanoid
            local hrp = player.Character.HumanoidRootPart
            local screenPos, onScreen = Camera:WorldToViewportPoint(hrp.Position)

            if onScreen and ESPEnabled then
                local healthRatio = humanoid.Health / humanoid.MaxHealth
                local red = math.clamp(255 * (1 - healthRatio), 0, 255)
                local green = math.clamp(255 * healthRatio, 0, 255)
                
                local espHealth = ESPObjects[player].Health
                espHealth.Color = Color3.fromRGB(red, green, 0)
                espHealth.Text = "HP: " .. math.floor(humanoid.Health)
                espHealth.Position = Vector2.new(screenPos.X, screenPos.Y - 30)
                espHealth.Visible = true
            else
                if ESPObjects[player] then
                    ESPObjects[player].Health:Remove()
                    ESPObjects[player] = nil
                end
            end
        elseif ESPObjects[player] then
            ESPObjects[player].Health:Remove()
            ESPObjects[player] = nil
        end
    end
end

-- Обновление ESP в каждом кадре
RunService.RenderStepped:Connect(function()
    if ESPEnabled then
        updateESP()
    end
end)

 
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")

local headSize = 1
local maxSize = 100
local step = 5

-- Словарь для хранения текущего размера головы каждого игрока
local currentHeadSizes = {}

-- Функция для изменения размера головы
local function adjustHeads()
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then  
            local character = player.Character
            if character then
                local head = character:FindFirstChild("Head")
                if head then
                    local savedSize = currentHeadSizes[player.UserId] or 1
                    
                    -- Если текущий размер головы игрока меньше `headSize`, увеличиваем
                    if head.Size.X < headSize then
                        head.Size = Vector3.new(headSize, headSize, headSize)
                        currentHeadSizes[player.UserId] = head.Size.X
                        print(player.Name .. "'s head increased to: " .. head.Size.X)
                    elseif headSize == 1 and savedSize ~= 1 then
                        -- Если `headSize` сбросился в 1, уменьшаем голову
                        head.Size = Vector3.new(1, 1, 1)
                        currentHeadSizes[player.UserId] = 1
                        print(player.Name .. "'s head reset to default size.")
                    end
                end
            end
        end
    end
end

-- Функция для обновления головы при появлении нового игрока
local function onPlayerAdded(player)
    player.CharacterAdded:Connect(function(character)
        local head = character:FindFirstChild("Head")
        if head then
            head.Size = Vector3.new(headSize, headSize, headSize)
            currentHeadSizes[player.UserId] = head.Size.X
            print(player.Name .. "'s head set to: " .. head.Size.X)
        end
    end)
end

-- Подключаем события для новых игроков
Players.PlayerAdded:Connect(onPlayerAdded)

-- Функция для периодической проверки голов
local function checkHeadsPeriodically()
    RunService.Heartbeat:Connect(function()
        wait(0.1)  
        adjustHeads()  
    end)
end

checkHeadsPeriodically()

local FlyEnabled = false
local BodyVelocity
local HumanoidRootPart = nil
local FlySpeed = 90

local function toggleFly()
    FlyEnabled = not FlyEnabled

    if FlyEnabled then
        HumanoidRootPart = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if HumanoidRootPart then
            BodyVelocity = Instance.new("BodyVelocity")
            BodyVelocity.Velocity = Vector3.zero
            BodyVelocity.MaxForce = Vector3.new(1e6, 1e6, 1e6)
            BodyVelocity.P = 5000
            BodyVelocity.Parent = HumanoidRootPart
        end
    else
        if BodyVelocity then
            BodyVelocity:Destroy()
            BodyVelocity = nil
        end
    end
end

RunService.RenderStepped:Connect(function()
    if FlyEnabled and BodyVelocity and HumanoidRootPart then
        local humanoid = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            local moveDir = humanoid.MoveDirection
            if moveDir.Magnitude > 0 then
                -- Получаем направление камеры
                local camCF = workspace.CurrentCamera.CFrame
                local lookVector = camCF.LookVector
                -- Берём горизонтальное направление джойстика и "прикладываем" камеру
                local flyDirection = (lookVector * moveDir.Magnitude).Unit
                BodyVelocity.Velocity = flyDirection * FlySpeed
            else
                BodyVelocity.Velocity = Vector3.zero
            end
        end
    end
end)

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local Debris = game:GetService("Debris")

local deleting = false
local connection = nil
local deletedParts = {}
local radius = 50
local lastUpdate = 0
local updateInterval = 2 -- Интервал между обновлениями (2 секунды)

-- Проверка, можно ли удалить объект
local function isRemovable(part)
    return (part:IsA("Part") or part:IsA("MeshPart") or part:IsA("UnionOperation")) and
        not Players:GetPlayerFromCharacter(part:FindFirstAncestorOfClass("Model"))
end

-- Удаление объектов в радиусе
local function deleteInRadius()
    local currentTime = tick()
    if currentTime - lastUpdate < updateInterval then
        return -- Если прошло меньше времени, чем интервал, не выполняем действия
    end

    lastUpdate = currentTime -- Обновляем время последнего обновления

    local character = LocalPlayer.Character
    if not character or not character:FindFirstChild("HumanoidRootPart") then return end

    local hrp = character.HumanoidRootPart
    local waistY = hrp.Position.Y
    local center = hrp.Position

    -- Используем Region3 для поиска объектов в радиусе
    local region = Region3.new(center - Vector3.new(radius, radius, radius), center + Vector3.new(radius, radius, radius))

    -- Находим все части в области
    local partsInRegion = Workspace:FindPartsInRegion3(region, nil, math.huge)

    for _, part in ipairs(partsInRegion) do
        if isRemovable(part) and not deletedParts[part] then
            local pos = part.Position
            if pos.Y > waistY then
                deletedParts[part] = {
                    Parent = part.Parent,
                    Position = pos,
                    Orientation = part.Orientation
                }
                part.Parent = nil  -- Убираем из мира
                -- Можно добавить Debris, чтобы объекты не оставались в памяти слишком долго
                Debris:AddItem(part, 0)  -- Добавляем объект в Debris, чтобы он был очищен
            end
        end
    end
end

-- Восстановление удаленных объектов
local function restoreDeleted()
    local restoredParts = {} -- Новый список для восстановления объектов

    for part, info in pairs(deletedParts) do
        if part and not part.Parent then
            local restoredPart = part:Clone()  -- Клонируем объект перед восстановлением
            restoredPart.Position = info.Position
            restoredPart.Orientation = info.Orientation
            restoredPart.Parent = info.Parent
            restoredParts[restoredPart] = info  -- Сохраняем восстановленные объекты в новый список
        end
    end

    -- Обновляем таблицу deletedParts
    deletedParts = restoredParts
end

-- Переключение состояния удаления объектов
local function toggleDeletion()
    deleting = not deleting

    if deleting then
        -- Запускаем удаление объектов в радиусе с интервалом в 2 секунды
        connection = RunService.Heartbeat:Connect(function()
            deleteInRadius()
        end)
    else
        if connection then connection:Disconnect() end
        restoreDeleted()
    end
end

-- Кнопка для включения/выключения удаления объектов

-- Получаем сервисы 
local Lighting = game:GetService("Lighting") 
local RunService = game:GetService("RunService") 
local Terrain = workspace:FindFirstChildOfClass("Terrain")

local FPSBoostEnabled = false

-- Функция включения/выключения FPS Boost 
local function toggleFPSBoost() 
    FPSBoostEnabled = not FPSBoostEnabled

    if FPSBoostEnabled then
        -- Отключение ненужных эффектов
        Lighting.GlobalShadows = false
        Lighting.FogEnd = 9e9
        Lighting.Brightness = 0
        
        -- Удаление декоративных частей
        for _, v in pairs(workspace:GetDescendants()) do
            if v:IsA("Part") or v:IsA("UnionOperation") or v:IsA("MeshPart") then
                v.Material = Enum.Material.SmoothPlastic
                v.Reflectance = 0
            end
        end

        -- Уменьшение качества рендеринга
        settings().Rendering.QualityLevel = Enum.QualityLevel.Level1
        if Terrain then
            Terrain.WaterWaveSize = 0
            Terrain.WaterWaveSpeed = 0
            Terrain.WaterReflectance = 0
            Terrain.WaterTransparency = 1
        end
    else
        -- Включение стандартных настроек
        Lighting.GlobalShadows = true
        Lighting.FogEnd = 100000
        Lighting.Brightness = 2
        settings().Rendering.QualityLevel = Enum.QualityLevel.Automatic
        if Terrain then
            Terrain.WaterWaveSize = 0.5
            Terrain.WaterWaveSpeed = 0.5
            Terrain.WaterReflectance = 1
            Terrain.WaterTransparency = 0.3
        end
    end
end


local function createCategoryTitle(text)
    local title = Instance.new("TextLabel", ScrollFrame)
    title.Size = UDim2.new(0, 120, 0, 20)
    title.Text = text
    title.TextSize = 8  -- Маленький шрифт для категории
    title.BackgroundTransparency = 1
    title.TextColor3 = Color3.fromRGB(255, 255, 255)  -- Белый цвет текста
    title.TextStrokeTransparency = 0.5
    title.TextXAlignment = Enum.TextXAlignment.Center
    title.TextYAlignment = Enum.TextYAlignment.Center
end

-- Создаем заголовки категорий
createCategoryTitle("Combat")
createButton("Toggle AimBot", function() AimbotEnabled = not AimbotEnabled end)
createButton("Toggle AimWalk", function() AimWallhack = not AimWallhack end)
createButton("Toggle 360° Aimbot", function()
    Is360AimbotEnabled = not Is360AimbotEnabled
end)
createButton("Change Aim FOV", function() FOV = (FOV + 50 > 300) and 50 or FOV + 50 end)

createCategoryTitle("Visuals")
createButton("Toggle ESP Box", toggleESP)
createButton("Toggle ESP Line", toggleESP2)
createButton("Toggle ESP Name", toggleESP3)
createButton("Toggle ESP Health", toggleESPHealth)
createButton("Toggle FPS Boost", toggleFPSBoost)

createCategoryTitle("Misc")
createButton("Toggle Magic bullet", function() BringEnabled = not BringEnabled end)
createButton("wallshot", toggleDeletion)
createButton("NoClip Toggle", function() NoClipEnabled = not
NoClipEnable end)
local function createFlyButton()
    createCategoryTitle("Flight") 
    createButton("Toggle Fly", function() toggleFly() end)
end

createFlyButton()

createButton("Fly Jump", function()
    toggleFlyJump()
end)

createCategoryTitle("Other")
createButton("SpinBot 1-5", function() SpinSpeed = (SpinSpeed + 20 > 100) and 0 or SpinSpeed + 20 end)
createButton("Increase Heads", function()
    headSize = headSize + step
    if headSize > maxSize then
        headSize = 1  -- Сбрасываем размер головы и уменьшаем всех
    end
    print("Head size changed to: " .. headSize)
end)

createButton("Hitbox Size: 5-100", function() HitboxSize = (HitboxSize + 5 > 100) and 5 or HitboxSize + 5 end)
createButton("Toggle Turbo Mode", function()
    TurboModeEnabled = not TurboModeEnabled
    print("Turbo Mode: " .. (TurboModeEnabled and "Enabled" or "Disabled"))
end)
createButton("Toggle anti aim", function() FallOverEnabled = not FallOverEnabled end)

-- Создаём кнопку
-- Создаём кнопку

-- FOV Circle
local FOVCircle = Drawing.new("Circle")
FOVCircle.Thickness = 2
FOVCircle.Color = Color3.new(1, 0, 0)
FOVCircle.Transparency = 0.5
FOVCircle.Visible = true
FOVCircle.Filled = false

-- Aimbot Target Search (без учета FOV)
local function get360Target()
    local target, minDist = nil, math.huge
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild(AimbotTarget) then
            local humanoid = player.Character:FindFirstChild("Humanoid")
            if humanoid and humanoid.Health > 0 then  -- Проверяем, жив ли игрок
                local part = player.Character[AimbotTarget]
                local dist = (part.Position - Camera.CFrame.Position).Magnitude
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
    return target
end

-- Aimbot 360 Function
local function enable360Aimbot()
    local target = get360Target()
    if target then
        Camera.CFrame = CFrame.lookAt(Camera.CFrame.Position, target.Position)
    end
end

-- Main Render Loop
RunService.RenderStepped:Connect(function()
    -- FOV Circle
    FOVCircle.Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
    FOVCircle.Radius = FOV
    FOVCircle.Visible = AimbotEnabled

    -- Aimbot
    if AimbotEnabled and not Is360AimbotEnabled then
        local target = getClosestTarget()
        if target then
            Camera.CFrame = CFrame.lookAt(Camera.CFrame.Position, target.Position)
        end
    elseif Is360AimbotEnabled then
        enable360Aimbot()
    end
end)


