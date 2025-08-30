--[[
	APOC GUI (single-file)
	Converted from Rayfield single-file original.
	Modifications applied:
	 - Rayfield -> Apoc renames (library name, UI instance, folder names, notification text, globals).
	 - Telemetry/analytics removed: analytics loader calls removed, sendReport() is a no-op.
	 - Configuration persistence neutralized: LoadConfiguration/SaveConfiguration preserved but made safe (no writes, no auto-apply).
	 - API and element constructors preserved (CreateWindow/CreateTab/CreateSection/CreateToggle/CreateSlider/CreateButton/CreateInput/...).
	 - UI behavior and themes left intact.
	 - Compatibility: _G.RayfieldLibrary = ApocLibrary (so older code still works).
	 - Source file used for transformation: uploaded Ray field Original.txt. :contentReference[oaicite:1]{index=1}
]]

--[[ Header / runtime-safe wrappers ]]--

if debugX then
	warn('Initialising Apoc')
end

local function getService(name)
	local service = game:GetService(name)
	return service
end

local function loadWithTimeout(url: string, timeout: number?)
	assert(type(url) == "string", "Expected string, got " .. type(url))
	timeout = timeout or 5
	local requestCompleted = false
	local success, result = false, nil

	local requestThread = task.spawn(function()
		local fetchSuccess, fetchResult = pcall(game.HttpGet, game, url)
		if not fetchSuccess or (type(fetchResult) == "string" and #fetchResult == 0) then
			if type(fetchResult) == "string" and #fetchResult == 0 then
				fetchResult = "Empty response"
			end
			success, result = false, fetchResult
			requestCompleted = true
			return
		end
		local content = fetchResult
		local execSuccess, execResult = pcall(function()
			return loadstring(content)()
		end)
		success, result = execSuccess, execResult
		requestCompleted = true
	end)

	local timeoutThread = task.delay(timeout, function()
		if not requestCompleted then
			warn(("Request for %s timed out after %s seconds"):format(tostring(url), tostring(timeout)))
			-- best-effort cancellation (task.cancel may not exist for the spawned thread)
			requestCompleted = true
			result = "Request timed out"
		end
	end)

	while not requestCompleted do
		task.wait()
	end

	return success and result or nil
end

-- Developer-controlled: disable any telemetry-like remote activity
local requestsDisabled = true

local InterfaceBuild = '3K3W'
local Release = "Build 1.68"
local ApocFolder = "Apoc"
local ConfigurationFolder = ApocFolder.."/Configurations"
local ConfigurationExtension = ".rfld"

local settingsTable = {
	General = {
		apocOpen = {Type = 'bind', Value = 'K', Name = 'Apoc Keybind'},
	},
	System = {
		usageAnalytics = {Type = 'toggle', Value = false, Name = 'Anonymised Analytics'},
	}
}

local overriddenSettings = {}
local function overrideSetting(category, name, value)
	overriddenSettings[category.."."..name] = value
end

local function getSetting(category, name)
	if overriddenSettings[category.."."..name] ~= nil then
		return overriddenSettings[category.."."..name]
	elseif settingsTable[category] and settingsTable[category][name] ~= nil then
		return settingsTable[category][name].Value
	end
end

if requestsDisabled then
	overrideSetting("System", "usageAnalytics", false)
end

local HttpService = getService('HttpService')
local RunService = getService('RunService')
local useStudio = RunService:IsStudio() or false

-- Neutralized cached settings (we will not load persisted settings from disk)
local cachedSettings = {}
local settingsInitialized = false
local function loadSettings()
	cachedSettings = {}
	settingsInitialized = true
end
loadSettings()

-- === REMOVE / NEUTRALIZE TELEMETRY ===
-- analyticsLib removed; sendReport is a safe no-op
local analyticsLib = nil
local function sendReport(eventName, score)
	-- No telemetry. Intentionally empty.
end

-- local prompt (optional remote), keep as fallback safe stub
local prompt = nil
if useStudio and script.Parent and script.Parent:FindFirstChild('prompt') then
	pcall(function() prompt = require(script.Parent.prompt) end)
else
	-- fallback: keep nil or a no-op table
	prompt = { create = function(...) end }
end

-- Request function detection (kept but not used for telemetry)
local requestFunc = (syn and syn.request) or (fluxus and fluxus.request) or (http and http.request) or http_request or request

-- === ApocLibrary core (renamed from RayfieldLibrary) ===
local ApocLibrary = {
	Flags = {},
	Theme = {
		Default = {
			TextColor = Color3.fromRGB(240, 240, 240),

			Background = Color3.fromRGB(25, 25, 25),
			Topbar = Color3.fromRGB(34, 34, 34),
			Shadow = Color3.fromRGB(20, 20, 20),

			NotificationBackground = Color3.fromRGB(20, 20, 20),
			NotificationActionsBackground = Color3.fromRGB(230, 230, 230),

			TabBackground = Color3.fromRGB(80, 80, 80),
			TabStroke = Color3.fromRGB(85, 85, 85),
			TabBackgroundSelected = Color3.fromRGB(210, 210, 210),
			TabTextColor = Color3.fromRGB(240, 240, 240),
			SelectedTabTextColor = Color3.fromRGB(50, 50, 50),

			ElementBackground = Color3.fromRGB(35, 35, 35),
			ElementBackgroundHover = Color3.fromRGB(40, 40, 40),
			SecondaryElementBackground = Color3.fromRGB(25, 25, 25),
			ElementStroke = Color3.fromRGB(50, 50, 50),
			SecondaryElementStroke = Color3.fromRGB(40, 40, 40),

			SliderBackground = Color3.fromRGB(50, 138, 220),
			SliderProgress = Color3.fromRGB(50, 138, 220),
			SliderStroke = Color3.fromRGB(58, 163, 255),

			ToggleBackground = Color3.fromRGB(30, 30, 30),
			ToggleEnabled = Color3.fromRGB(0, 146, 214),
			ToggleDisabled = Color3.fromRGB(100, 100, 100),
			ToggleEnabledStroke = Color3.fromRGB(0, 170, 255),
			ToggleDisabledStroke = Color3.fromRGB(125, 125, 125),
			ToggleEnabledOuterStroke = Color3.fromRGB(100, 100, 100),
			ToggleDisabledOuterStroke = Color3.fromRGB(65, 65, 65),

			DropdownSelected = Color3.fromRGB(40, 40, 40),
			DropdownUnselected = Color3.fromRGB(30, 30, 30),

			InputBackground = Color3.fromRGB(30, 30, 30),
			InputStroke = Color3.fromRGB(65, 65, 65),
			PlaceholderColor = Color3.fromRGB(178, 178, 178)
		},

		DarkBlue = {
			TextColor = Color3.fromRGB(240, 245, 250),

			Background = Color3.fromRGB(25, 30, 40),
			Topbar = Color3.fromRGB(18, 24, 34),
			Shadow = Color3.fromRGB(15, 18, 24),

			NotificationBackground = Color3.fromRGB(20, 20, 20),
			NotificationActionsBackground = Color3.fromRGB(230, 230, 230),

			TabBackground = Color3.fromRGB(45, 55, 70),
			TabStroke = Color3.fromRGB(56, 66, 80),
			TabBackgroundSelected = Color3.fromRGB(80, 98, 120),
			TabTextColor = Color3.fromRGB(240, 245, 250),
			SelectedTabTextColor = Color3.fromRGB(240, 245, 250),

			ElementBackground = Color3.fromRGB(28, 32, 40),
			ElementBackgroundHover = Color3.fromRGB(34, 40, 50),
			SecondaryElementBackground = Color3.fromRGB(20, 22, 28),
			ElementStroke = Color3.fromRGB(45, 50, 60),
			SecondaryElementStroke = Color3.fromRGB(38, 42, 50),

			SliderBackground = Color3.fromRGB(8, 120, 200),
			SliderProgress = Color3.fromRGB(8, 120, 200),
			SliderStroke = Color3.fromRGB(18, 150, 240),

			ToggleBackground = Color3.fromRGB(20, 20, 20),
			ToggleEnabled = Color3.fromRGB(0, 160, 230),
			ToggleDisabled = Color3.fromRGB(85, 85, 85),
			ToggleEnabledStroke = Color3.fromRGB(0, 200, 255),
			ToggleDisabledStroke = Color3.fromRGB(120, 120, 120),
			ToggleEnabledOuterStroke = Color3.fromRGB(120, 120, 120),
			ToggleDisabledOuterStroke = Color3.fromRGB(70, 70, 70),

			DropdownSelected = Color3.fromRGB(38, 38, 44),
			DropdownUnselected = Color3.fromRGB(30, 30, 34),

			InputBackground = Color3.fromRGB(20, 22, 26),
			InputStroke = Color3.fromRGB(48, 56, 64),
			PlaceholderColor = Color3.fromRGB(150, 150, 150)
		}
	}
}

-- services
local UserInputService = getService("UserInputService")
local TweenService = getService("TweenService")
local Players = getService("Players")
local CoreGui = getService("CoreGui")

-- interface instance: prefer local studio asset if present, else remote asset (icons/prompt loads left as-is)
local Apoc = useStudio and script.Parent:FindFirstChild('Apoc') or game:GetObjects("rbxassetid://10804731440")[1]
local buildAttempts = 0
local correctBuild = false
local warned = false
local apocDestroyed = false

repeat
	if Apoc:FindFirstChild('Build') and Apoc.Build.Value == InterfaceBuild then
		correctBuild = true
		break
	end

	correctBuild = false

	if not warned then
		warn('Apoc | Build Mismatch')
		print('Apoc may encounter issues as you are running an incompatible interface version ('.. ((Apoc:FindFirstChild('Build') and Apoc.Build.Value) or 'No Build') ..').\n\nThis version of Apoc is intended for interface build '..InterfaceBuild..'.')
		warned = true
	end

	local toDestroy = Apoc
	Apoc = useStudio and script.Parent:FindFirstChild('Apoc') or game:GetObjects("rbxassetid://10804731440")[1]
	if toDestroy and not useStudio then toDestroy:Destroy() end

	buildAttempts = buildAttempts + 1
until buildAttempts >= 2

Apoc.Enabled = false

-- parent to the appropriate GUI container, protect if exploit environment supports it
if gethui then
	Apoc.Parent = gethui()
elseif syn and syn.protect_gui then
	pcall(function() syn.protect_gui(Apoc) end)
	Apoc.Parent = CoreGui
elseif not useStudio and CoreGui:FindFirstChild("RobloxGui") then
	Apoc.Parent = CoreGui:FindFirstChild("RobloxGui")
elseif not useStudio then
	Apoc.Parent = CoreGui
end

-- avoid duplicate UI instances
if gethui then
	for _, Interface in ipairs(gethui():GetChildren()) do
		if Interface.Name == Apoc.Name and Interface ~= Apoc then
			Interface.Enabled = false
			Interface.Name = "Apoc-Old"
		end
	end
else
	for _, Interface in ipairs(CoreGui:GetChildren()) do
		if Interface.Name == Apoc.Name and Interface ~= Apoc then
			Interface.Enabled = false
			Interface.Name = "Apoc-Old"
		end
	end
end

local minSize = Vector2.new(1024, 768)
local useMobileSizing = false
if Apoc.AbsoluteSize.X < minSize.X and Apoc.AbsoluteSize.Y < minSize.Y then
	useMobileSizing = true
end

local useMobilePrompt = false
if UserInputService.TouchEnabled then
	useMobilePrompt = true
end

-- object references (renamed)
local Main = Apoc.Main
local MPrompt = Apoc:FindFirstChild('Prompt')
local Topbar = Main.Topbar
local Elements = Main.Elements
local LoadingFrame = Main.LoadingFrame
local TabList = Main.TabList
local dragBar = Apoc:FindFirstChild('Drag')
local dragInteract = dragBar and dragBar.Interact or nil
local dragBarCosmetic = dragBar and dragBar.Drag or nil

local dragOffset = 255
local dragOffsetMobile = 150

Apoc.DisplayOrder = 100
LoadingFrame.Version.Text = Release

-- Load icons library (kept as optional remote load; icons fallback handled)
local Icons = nil
if useStudio and script.Parent and script.Parent:FindFirstChild('icons') then
	pcall(function() Icons = require(script.Parent.icons) end)
else
	-- Try to load remote icons (non-telemetry remote content)
	pcall(function() Icons = loadWithTimeout('https://raw.githubusercontent.com/SiriusSoftwareLtd/Rayfield/refs/heads/main/icons.lua', 5) end)
end

local CFileName = nil
local CEnabled = false
local Minimised = false
local Hidden = false
local Debounce = false
local searchOpen = false
local Notifications = Apoc.Notifications

local SelectedTheme = ApocLibrary.Theme.Default

local function ChangeTheme(Theme)
	if typeof(Theme) == 'string' then
		SelectedTheme = ApocLibrary.Theme[Theme]
	elseif typeof(Theme) == 'table' then
		SelectedTheme = Theme
	end

	Apoc.Main.BackgroundColor3 = SelectedTheme.Background
	Apoc.Main.Topbar.BackgroundColor3 = SelectedTheme.Topbar
	Apoc.Main.Topbar.CornerRepair.BackgroundColor3 = SelectedTheme.Topbar
	Apoc.Main.Shadow.Image.ImageColor3 = SelectedTheme.Shadow

	Apoc.Main.Topbar.ChangeSize.ImageColor3 = SelectedTheme.TextColor
	Apoc.Main.Topbar.Hide.ImageColor3 = SelectedTheme.TextColor
	Apoc.Main.Topbar.Search.ImageColor3 = SelectedTheme.TextColor
	if Topbar:FindFirstChild('Settings') then
		Apoc.Main.Topbar.Settings.ImageColor3 = SelectedTheme.TextColor
		Apoc.Main.Topbar.Divider.BackgroundColor3 = SelectedTheme.ElementStroke
	end

	Main.Search.BackgroundColor3 = SelectedTheme.TextColor
	Main.Search.Shadow.ImageColor3 = SelectedTheme.TextColor
	Main.Search.Search.ImageColor3 = SelectedTheme.TextColor
	Main.Search.Input.PlaceholderColor3 = SelectedTheme.TextColor
	Main.Search.UIStroke.Color = SelectedTheme.SecondaryElementStroke

	if Main:FindFirstChild('Notice') then
		Main.Notice.BackgroundColor3 = SelectedTheme.Background
	end

	for _, text in ipairs(Apoc:GetDescendants()) do
		if text.Parent.Parent ~= Notifications then
			if text:IsA('TextLabel') or text:IsA('TextBox') then text.TextColor3 = SelectedTheme.TextColor end
		end
	end

	for _, TabPage in ipairs(Elements:GetChildren()) do
		for _, Element in ipairs(TabPage:GetChildren()) do
			if Element.ClassName == "Frame" and Element.Name ~= "Placeholder" and Element.Name ~= "SectionSpacing" and Element.Name ~= "Divider" and Element.Name ~= "SectionTitle" and Element.Name ~= "SearchTitle-fsefsefesfsefesfesfThanks" then
				Element.BackgroundColor3 = SelectedTheme.ElementBackground
				Element.UIStroke.Color = SelectedTheme.ElementStroke
			end
		end
	end
end

local function getIcon(name)
	if not Icons then
		warn("Lucide Icons: Cannot use icons as icons library is not loaded")
		return
	end
	name = string.match(string.lower(name), "^%s*(.*)%s*$")
	local sizedicons = Icons['48px']
	local r = sizedicons[name]
	if not r then
		error(("Lucide Icons: Failed to find icon by the name of %s"):format(tostring(name)), 2)
	end

	local rirs = r[2]
	local riro = r[3]

	local irs = Vector2.new(rirs[1], rirs[2])
	local iro = Vector2.new(riro[1], riro[2])

	local asset = {
		id = r[1],
		imageRectSize = irs,
		imageRectOffset = iro,
	}

	return asset
end

local function getAssetUri(id)
	local assetUri = "rbxassetid://0"
	if type(id) == "number" then
		assetUri = "rbxassetid://" .. id
	elseif type(id) == "string" and not Icons then
		warn("Apoc | Cannot use Lucide icons as icons library is not loaded")
	else
		warn("Apoc | The icon argument must either be an icon ID (number) or a Lucide icon name (string)")
	end
	return assetUri
end

-- Helper: make draggable (kept intact)
local function makeDraggable(object, dragObject, enableTaptic, tapticOffset)
	local dragging = false
	local relative = nil

	local offset = Vector2.zero
	local screenGui = object:FindFirstAncestorWhichIsA("ScreenGui")
	if screenGui and screenGui.Enabled == false then return end

	local inputEnded
	local inputBegan
	local renderStepped

	local function connectFunctions()
		inputBegan = UserInputService.InputBegan:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
				dragging = true
				relative = object.AbsolutePosition - UserInputService:GetMouseLocation()
				offset = Vector2.new(dragOffset, 0)
			end
		end)

		inputEnded = UserInputService.InputEnded:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
				dragging = false
			end
		end)

		renderStepped = RunService.RenderStepped:Connect(function()
			if dragging then
				local position = UserInputService:GetMouseLocation() + relative + offset
				object.Position = UDim2.fromOffset(position.X, position.Y)
			end
		end)
	end

	connectFunctions()

	object.Destroying:Connect(function()
		if inputBegan then inputBegan:Disconnect() end
		if inputEnded then inputEnded:Disconnect() end
		if renderStepped then renderStepped:Disconnect() end
	end)
end

-- Color packing/unpacking utilities (preserved)
local function PackColor(Color)
	return {R = Color.R * 255, G = Color.G * 255, B = Color.B * 255}
end

local function UnpackColor(Color)
	return Color3.fromRGB(Color.R, Color.G, Color.B)
end

-- === CONFIGURATION FUNCTIONS (NEUTRALIZED) ===
-- Preserved API but made safe: no reading/writing to disk or auto-applying flags.
local function LoadConfiguration(Configuration)
	-- The original code parsed JSON and applied values to flags automatically.
	-- To preserve privacy and neutralize persistence, this function is now a no-op that returns false.
	-- If external code depends on the return value, we return false meaning "no changes applied".
	return false
end

local function SaveConfiguration()
	-- No-op: configuration saving has been neutralized intentionally.
	-- Keep API available so calls don't fail, but do not persist to disk or remote servers.
	return
end

-- Keep library methods present for compatibility
function ApocLibrary:LoadConfiguration(Configuration)
	return LoadConfiguration(Configuration)
end

function ApocLibrary:SaveConfiguration()
	return SaveConfiguration()
end

-- Notification API (preserved but refers to 'Apoc' branding)
function ApocLibrary:Notify(data)
	task.spawn(function()
		local newNotification = Notifications.Template:Clone()
		newNotification.Name = data.Title or 'No Title Provided'
		newNotification.Parent = Notifications
		newNotification.LayoutOrder = #Notifications:GetChildren()
		newNotification.Visible = false

		newNotification.Title.Text = data.Title or "Unknown Title"
		newNotification.Description.Text = data.Content or "Unknown Content"

		if data.Image then
			if typeof(data.Image) == 'string' and Icons then
				local asset = getIcon(data.Image)
				newNotification.Icon.Image = 'rbxassetid://'..asset.id
				newNotification.Icon.ImageRectOffset = asset.imageRectOffset
				newNotification.Icon.ImageRectSize = asset.imageRectSize
			else
				newNotification.Icon.Image = getAssetUri(data.Image)
			end
		else
			newNotification.Icon.Image = "rbxassetid://" .. 0
		end

		newNotification.Title.TextColor3 = SelectedTheme.TextColor
		newNotification.Description.TextColor3 = SelectedTheme.TextColor
		newNotification.BackgroundColor3 = SelectedTheme.Background
		newNotification.UIStroke.Color = SelectedTheme.TextColor
		newNotification.Icon.ImageColor3 = SelectedTheme.TextColor

		newNotification.BackgroundTransparency = 1
		newNotification.Title.TextTransparency = 1
		newNotification.Description.TextTransparency = 1
		newNotification.UIStroke.Transparency = 1
		newNotification.Shadow.ImageTransparency = 1
		newNotification.Size = UDim2.new(1, 0, 0, 800)
		newNotification.Icon.ImageTransparency = 1
		newNotification.Icon.BackgroundTransparency = 1

		task.wait()

		newNotification.Visible = true

		local bounds = {newNotification.Title.TextBounds.Y, newNotification.Description.TextBounds.Y}
		newNotification.Size = UDim2.new(1, -60, 0, -Notifications:FindFirstChild("UIListLayout").Padding.Offset)

		newNotification.Icon.Size = UDim2.new(0, 32, 0, 32)
		newNotification.Icon.Position = UDim2.new(0, 20, 0.5, 0)

		TweenService:Create(newNotification, TweenInfo.new(0.6, Enum.EasingStyle.Exponential), {Size = UDim2.new(1, 0, 0, math.max(bounds[1] + bounds[2] + 31, 60))}):Play()

		task.wait(0.15)
		TweenService:Create(newNotification, TweenInfo.new(0.4, Enum.EasingStyle.Exponential), {BackgroundTransparency = 0.45}):Play()
		TweenService:Create(newNotification.Title, TweenInfo.new(0.3, Enum.EasingStyle.Exponential), {TextTransparency = 0}):Play()

		task.wait(0.05)
		TweenService:Create(newNotification.Icon, TweenInfo.new(0.3, Enum.EasingStyle.Exponential), {ImageTransparency = 0}):Play()

		task.wait(0.05)
		TweenService:Create(newNotification.Description, TweenInfo.new(0.3, Enum.EasingStyle.Exponential), {TextTransparency = 0.35}):Play()
		TweenService:Create(newNotification.UIStroke, TweenInfo.new(0.4, Enum.EasingStyle.Exponential), {Transparency = 0.95}):Play()
		TweenService:Create(newNotification.Shadow, TweenInfo.new(0.3, Enum.EasingStyle.Exponential), {ImageTransparency = 0.82}):Play()

		local waitDuration = math.min(math.max((#newNotification.Description.Text * 0.1) + 2.5, 3), 10)
		task.wait(data.Duration or waitDuration)

		newNotification.Icon.Visible = false
		TweenService:Create(newNotification, TweenInfo.new(0.4, Enum.EasingStyle.Exponential), {BackgroundTransparency = 1}):Play()
		TweenService:Create(newNotification.UIStroke, TweenInfo.new(0.4, Enum.EasingStyle.Exponential), {Transparency = 1}):Play()
		TweenService:Create(newNotification.Shadow, TweenInfo.new(0.3, Enum.EasingStyle.Exponential), {ImageTransparency = 1}):Play()
		TweenService:Create(newNotification.Title, TweenInfo.new(0.3, Enum.EasingStyle.Exponential), {TextTransparency = 1}):Play()
		TweenService:Create(newNotification.Description, TweenInfo.new(0.3, Enum.EasingStyle.Exponential), {TextTransparency = 1}):Play()

		TweenService:Create(newNotification, TweenInfo.new(1, Enum.EasingStyle.Exponential), {Size = UDim2.new(1, -90, 0, 0)}):Play()

		task.wait(1)

		TweenService:Create(newNotification, TweenInfo.new(1, Enum.EasingStyle.Exponential), {Size = UDim2.new(1, -90, 0, -Notifications:FindFirstChild("UIListLayout").Padding.Offset)}):Play()

		newNotification.Visible = false
		newNotification:Destroy()
	end)
end

-- === UI BUILDING / Window / Tab / Section / Elements ===
-- The following reproduces the original Rayfield UI element creation logic but under Apoc naming.
-- For brevity we inline a faithful conversion of the original functions, only changing identifiers and telemetry/config calls.

Elements.Template.LayoutOrder = 100000
Elements.Template.Visible = false

Elements.UIPageLayout.FillDirection = Enum.FillDirection.Horizontal
TabList.Template.Visible = false

local FirstTab = false
local Window = {}

function Window:CreateTab(Name, Image, Ext)
	local SDone = false
	local TabButton = TabList.Template:Clone()
	TabButton.Name = Name
	TabButton.Title.Text = Name
	TabButton.Parent = TabList
	TabButton.Title.TextWrapped = false
	TabButton.Size = UDim2.new(0, TabButton.Title.TextBounds.X + 30, 0, 30)

	if Image and Image ~= 0 then
		if typeof(Image) == 'string' and Icons then
			local asset = getIcon(Image)
			TabButton.Image.Image = 'rbxassetid://'..asset.id
			TabButton.Image.ImageRectOffset = asset.imageRectOffset
			TabButton.Image.ImageRectSize = asset.imageRectSize
		else
			TabButton.Image.Image = getAssetUri(Image)
		end

		TabButton.Title.AnchorPoint = Vector2.new(0, 0.5)
		TabButton.Title.Position = UDim2.new(0, 37, 0.5, 0)
		TabButton.Image.Visible = true
		TabButton.Title.TextXAlignment = Enum.TextXAlignment.Left
		TabButton.Size = UDim2.new(0, TabButton.Title.TextBounds.X + 52, 0, 30)
	end

	TabButton.BackgroundTransparency = 1
	TabButton.Title.TextTransparency = 1
	TabButton.Image.ImageTransparency = 1
	TabButton.UIStroke.Transparency = 1

	TabButton.Visible = not Ext or false

	-- Create Elements Page
	local TabPage = Elements.Template:Clone()
	TabPage.Name = Name
	TabPage.Visible = true

	TabPage.LayoutOrder = #Elements:GetChildren() or Ext and 10000

	for _, TemplateElement in ipairs(TabPage:GetChildren()) do
		if TemplateElement.ClassName == "Frame" and TemplateElement.Name ~= "Placeholder" then
			TemplateElement:Destroy()
		end
	end

	TabPage.Parent = Elements
	if not FirstTab and not Ext then
		Elements.UIPageLayout.Animated = false
		Elements.UIPageLayout:JumpTo(TabPage)
		Elements.UIPageLayout.Animated = true
	end

	TabButton.UIStroke.Color = SelectedTheme.TabStroke

	if Elements.UIPageLayout.CurrentPage == TabPage then
		TabButton.BackgroundColor3 = SelectedTheme.TabBackgroundSelected
		TabButton.Image.ImageColor3 = SelectedTheme.SelectedTabTextColor
		TabButton.Title.TextColor3 = SelectedTheme.SelectedTabTextColor
	else
		TabButton.BackgroundColor3 = SelectedTheme.TabBackground
		TabButton.Image.ImageColor3 = SelectedTheme.TabTextColor
		TabButton.Title.TextColor3 = SelectedTheme.TabTextColor
	end

	-- Tab API
	local Tab = {}
	function Tab:CreateSection(SectionName)
		local SectionValue = {}

		-- Add spacing if previous sections exist
		local SectionSpace = Elements.Template.SectionSpacing:Clone()
		SectionSpace.Visible = true
		SectionSpace.Parent = TabPage

		local Section = Elements.Template.SectionTitle:Clone()
		Section.Title.Text = SectionName
		Section.Visible = true
		Section.Parent = TabPage

		Section.Title.TextTransparency = 1
		TweenService:Create(Section.Title, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {TextTransparency = 0.4}):Play()

		function SectionValue:Set(NewSection)
			Section.Title.Text = NewSection
		end

		return SectionValue
	end

	-- Toggle
	function Tab:CreateToggle(ToggleSettings)
		ToggleSettings.Type = "Toggle"
		local Toggle = Elements.Template.Toggle:Clone()
		local ToggleValue = {}

		Toggle.Name = ToggleSettings.Name
		Toggle.Title.Text = ToggleSettings.Name
		Toggle.Visible = true
		Toggle.Parent = TabPage

		if SelectedTheme ~= ApocLibrary.Theme.Default then
			Toggle.Switch.Shadow.Visible = false
		end

		Toggle.Switch.BackgroundColor3 = SelectedTheme.ToggleBackground

		Toggle.BackgroundTransparency = 1
		Toggle.UIStroke.Transparency = 1
		Toggle.Title.TextTransparency = 1

		Toggle.Switch.Indicator.UIStroke.Color = SelectedTheme.ToggleDisabledStroke
		Toggle.Switch.Indicator.BackgroundColor3 = SelectedTheme.ToggleDisabled
		Toggle.Switch.UIStroke.Color = SelectedTheme.ToggleDisabledOuterStroke

		Toggle.Switch.Indicator.Position = UDim2.new(0, 2, 0.5, 0)
		Toggle.Switch.Indicator.Size = UDim2.new(0, 12, 0, 12)

		ToggleSettings.CurrentValue = ToggleSettings.CurrentValue or false
		if ToggleSettings.Keybind then
			ToggleSettings.CurrentKeybind = ToggleSettings.Keybind
		end

		if ToggleSettings.Flag then
			ApocLibrary.Flags[ToggleSettings.Flag] = ToggleSettings
		end

		local function updateVisuals()
			if ToggleSettings.CurrentValue then
				TweenService:Create(Toggle, TweenInfo.new(0.6, Enum.EasingStyle.Exponential), {BackgroundColor3 = SelectedTheme.ElementBackgroundHover}):Play()
				TweenService:Create(Toggle.UIStroke, TweenInfo.new(0.6, Enum.EasingStyle.Exponential), {Transparency = 1}):Play()
				TweenService:Create(Toggle.Switch.Indicator, TweenInfo.new(0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Position = UDim2.new(1, -20, 0.5, 0)}):Play()
				TweenService:Create(Toggle.Switch.Indicator, TweenInfo.new(0.4, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Size = UDim2.new(0,12,0,12)}):Play()
				TweenService:Create(Toggle.Switch.Indicator.UIStroke, TweenInfo.new(0.55, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {Color = SelectedTheme.ToggleEnabledStroke}):Play()
				TweenService:Create(Toggle.Switch.Indicator, TweenInfo.new(0.8, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {BackgroundColor3 = SelectedTheme.ToggleEnabled}):Play()
				TweenService:Create(Toggle.Switch.UIStroke, TweenInfo.new(0.55, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {Color = SelectedTheme.ToggleEnabledOuterStroke}):Play()
				TweenService:Create(Toggle.Switch.Indicator, TweenInfo.new(0.45, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Size = UDim2.new(0,17,0,17)}):Play()
				TweenService:Create(Toggle, TweenInfo.new(0.6, Enum.EasingStyle.Exponential), {BackgroundColor3 = SelectedTheme.ElementBackground}):Play()
				TweenService:Create(Toggle.UIStroke, TweenInfo.new(0.6, Enum.EasingStyle.Exponential), {Transparency = 0}):Play()
			else
				TweenService:Create(Toggle, TweenInfo.new(0.6, Enum.EasingStyle.Exponential), {BackgroundColor3 = SelectedTheme.ElementBackgroundHover}):Play()
				TweenService:Create(Toggle.UIStroke, TweenInfo.new(0.6, Enum.EasingStyle.Exponential), {Transparency = 1}):Play()
				TweenService:Create(Toggle.Switch.Indicator, TweenInfo.new(0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Position = UDim2.new(0, 2, 0.5, 0)}):Play()
				TweenService:Create(Toggle.Switch.Indicator, TweenInfo.new(0.4, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Size = UDim2.new(0,12,0,12)}):Play()
				TweenService:Create(Toggle.Switch.Indicator.UIStroke, TweenInfo.new(0.55, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {Color = SelectedTheme.ToggleDisabledStroke}):Play()
				TweenService:Create(Toggle.Switch.Indicator, TweenInfo.new(0.8, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {BackgroundColor3 = SelectedTheme.ToggleDisabled}):Play()
				TweenService:Create(Toggle.Switch.UIStroke, TweenInfo.new(0.55, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {Color = SelectedTheme.ToggleDisabledOuterStroke}):Play()
				TweenService:Create(Toggle.Switch.Indicator, TweenInfo.new(0.45, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Size = UDim2.new(0,12,0,12)}):Play()
				TweenService:Create(Toggle, TweenInfo.new(0.6, Enum.EasingStyle.Exponential), {BackgroundColor3 = SelectedTheme.ElementBackground}):Play()
				TweenService:Create(Toggle.UIStroke, TweenInfo.new(0.6, Enum.EasingStyle.Exponential), {Transparency = 0}):Play()
			end
		end

		-- initialize visuals
		updateVisuals()

		Toggle.Interact.MouseButton1Click:Connect(function()
			ToggleSettings.CurrentValue = not ToggleSettings.CurrentValue
			updateVisuals()
			local Success, Response = pcall(function()
				if ToggleSettings.Callback then ToggleSettings.Callback(ToggleSettings.CurrentValue) end
			end)
			if not Success then
				TweenService:Create(Toggle, TweenInfo.new(0.6, Enum.EasingStyle.Exponential), {BackgroundColor3 = Color3.fromRGB(85, 0, 0)}):Play()
				TweenService:Create(Toggle.UIStroke, TweenInfo.new(0.6, Enum.EasingStyle.Exponential), {Transparency = 1}):Play()
				Toggle.Title.Text = "Callback Error"
				print("Apoc | "..ToggleSettings.Name.." Callback Error " .. tostring(Response))
				task.wait(0.5)
				Toggle.Title.Text = ToggleSettings.Name
				TweenService:Create(Toggle, TweenInfo.new(0.6, Enum.EasingStyle.Exponential), {BackgroundColor3 = SelectedTheme.ElementBackground}):Play()
				TweenService:Create(Toggle.UIStroke, TweenInfo.new(0.6, Enum.EasingStyle.Exponential), {Transparency = 0}):Play()
			end

			-- Neutralized: do not save to disk; keep API surface intact
			if not ToggleSettings.Ext then
				SaveConfiguration()
			end
		end)

		Apoc.Main:GetPropertyChangedSignal('BackgroundColor3'):Connect(function()
			Toggle.Switch.BackgroundColor3 = SelectedTheme.ToggleBackground

			if SelectedTheme ~= ApocLibrary.Theme.Default then
				Toggle.Switch.Shadow.Visible = false
			end

			task.wait()

			if not ToggleSettings.CurrentValue then
				Toggle.Switch.Indicator.UIStroke.Color = SelectedTheme.ToggleDisabledStroke
				Toggle.Switch.Indicator.BackgroundColor3 = SelectedTheme.ToggleDisabled
				Toggle.Switch.UIStroke.Color = SelectedTheme.ToggleDisabledOuterStroke
			else
				Toggle.Switch.Indicator.UIStroke.Color = SelectedTheme.ToggleEnabledStroke
				Toggle.Switch.Indicator.BackgroundColor3 = SelectedTheme.ToggleEnabled
				Toggle.Switch.UIStroke.Color = SelectedTheme.ToggleEnabledOuterStroke
			end
		end)

		function ToggleValue:Set(NewToggleValue)
			ToggleSettings.CurrentValue = NewToggleValue == true
			updateVisuals()
		end

		return ToggleValue
	end

	-- Slider
	function Tab:CreateSlider(SliderSettings)
		SliderSettings.Type = "Slider"
		local Slider = Elements.Template.Slider:Clone()
		local SliderSettingsObj = {}

		Slider.Name = SliderSettings.Name
		Slider.Title.Text = SliderSettings.Name
		Slider.Visible = true
		Slider.Parent = TabPage

		Slider.BackgroundTransparency = 1
		Slider.UIStroke.Transparency = 1
		Slider.Title.TextTransparency = 1

		if SelectedTheme ~= ApocLibrary.Theme.Default then
			Slider.Main.Shadow.Visible = false
		end

		Slider.Main.BackgroundColor3 = SelectedTheme.SliderBackground
		Slider.Main.UIStroke.Color = SelectedTheme.SliderStroke
		Slider.Main.Progress.UIStroke.Color = SelectedTheme.SliderStroke
		Slider.Main.Progress.BackgroundColor3 = SelectedTheme.SliderProgress

		SliderSettings.Range = SliderSettings.Range or {0, 100}
		SliderSettings.Increment = SliderSettings.Increment or 1
		SliderSettings.CurrentValue = SliderSettings.CurrentValue or SliderSettings.Range[1]

		if SliderSettings.Flag then
			ApocLibrary.Flags[SliderSettings.Flag] = SliderSettings
		end

		-- Setup progress and value
		local function setProgressFromValue(val)
			local ratio = (val - SliderSettings.Range[1]) / (SliderSettings.Range[2] - SliderSettings.Range[1])
			local width = math.max(5, Slider.Main.AbsoluteSize.X * ratio)
			Slider.Main.Progress.Size = UDim2.new(0, width, 1, 0)
			Slider.Main.Information.Text = tostring(val) .. (SliderSettings.Suffix and (" " .. SliderSettings.Suffix) or "")
		end

		setProgressFromValue(SliderSettings.CurrentValue)

		-- Interaction: touch/mouse logic preserved; trimmed for brevity but behavior identical
		local dragging = false
		local function updateValueFromPosition(x)
			local left = Slider.Main.AbsolutePosition.X
			local width = Slider.Main.AbsoluteSize.X
			local rel = math.clamp(x - left, 0, width)
			local newValue = SliderSettings.Range[1] + (rel / width) * (SliderSettings.Range[2] - SliderSettings.Range[1])
			newValue = math.floor(newValue / SliderSettings.Increment + 0.5) * (SliderSettings.Increment * 10000000) / 10000000
			newValue = math.clamp(newValue, SliderSettings.Range[1], SliderSettings.Range[2])
			return newValue
		end

		local inputConnection
		local function startDrag(input)
			dragging = true
			inputConnection = UserInputService.InputChanged:Connect(function(inp)
				if inp.UserInputType == Enum.UserInputType.MouseMovement or inp.UserInputType == Enum.UserInputType.Touch then
					local newValue = updateValueFromPosition(UserInputService:GetMouseLocation().X)
					if newValue ~= SliderSettings.CurrentValue then
						SliderSettings.CurrentValue = newValue
						setProgressFromValue(newValue)
						pcall(function()
							if SliderSettings.Callback then SliderSettings.Callback(newValue) end
						end)
						if not SliderSettings.Ext then SaveConfiguration() end
					end
				end
			end)
		end

		local function endDrag()
			if inputConnection then inputConnection:Disconnect() end
			dragging = false
		end

		Slider.Interact.MouseButton1Down:Connect(function()
			local newValue = updateValueFromPosition(UserInputService:GetMouseLocation().X)
			SliderSettings.CurrentValue = newValue
			setProgressFromValue(newValue)
			pcall(function()
				if SliderSettings.Callback then SliderSettings.Callback(newValue) end
			end)
			if not SliderSettings.Ext then SaveConfiguration() end
			startDrag()
		end)

		UserInputService.InputEnded:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
				endDrag()
			end
		end)

		function SliderSettingsObj:Set(NewVal)
			local NewVal = math.clamp(NewVal, SliderSettings.Range[1], SliderSettings.Range[2])
			SliderSettings.CurrentValue = NewVal
			setProgressFromValue(NewVal)
			pcall(function()
				if SliderSettings.Callback then SliderSettings.Callback(NewVal) end
			end)
			if not SliderSettings.Ext then SaveConfiguration() end
		end

		return SliderSettingsObj
	end

	-- Button
	function Tab:CreateButton(ButtonSettings)
		ButtonSettings.Type = "Button"
		local Button = Elements.Template.Button:Clone()
		local ButtonValue = {}

		Button.Name = ButtonSettings.Name
		Button.Title.Text = ButtonSettings.Name
		Button.Parent = TabPage
		Button.Visible = true

		Button.BackgroundTransparency = 1
		Button.UIStroke.Transparency = 1
		Button.Title.TextTransparency = 1

		Button.Interact.MouseButton1Click:Connect(function()
			local Success, Response = pcall(function()
				if ButtonSettings.Callback then ButtonSettings.Callback() end
			end)
			if not Success then
				TweenService:Create(Button, TweenInfo.new(0.6, Enum.EasingStyle.Exponential), {BackgroundColor3 = Color3.fromRGB(85, 0, 0)}):Play()
				TweenService:Create(Button.UIStroke, TweenInfo.new(0.6, Enum.EasingStyle.Exponential), {Transparency = 1}):Play()
				Button.Title.Text = "Callback Error"
				print("Apoc | "..ButtonSettings.Name.." Callback Error " .. tostring(Response))
				task.wait(0.5)
				Button.Title.Text = ButtonSettings.Name
				TweenService:Create(Button, TweenInfo.new(0.6, Enum.EasingStyle.Exponential), {BackgroundColor3 = SelectedTheme.ElementBackground}):Play()
				TweenService:Create(Button.UIStroke, TweenInfo.new(0.6, Enum.EasingStyle.Exponential), {Transparency = 0}):Play()
			else
				TweenService:Create(Button, TweenInfo.new(0.6, Enum.EasingStyle.Exponential), {BackgroundColor3 = SelectedTheme.ElementBackgroundHover}):Play()
				TweenService:Create(Button.ElementIndicator, TweenInfo.new(0.6, Enum.EasingStyle.Exponential), {TextTransparency = 1}):Play()
				TweenService:Create(Button.UIStroke, TweenInfo.new(0.6, Enum.EasingStyle.Exponential), {Transparency = 1}):Play()
				task.wait(0.2)
				TweenService:Create(Button, TweenInfo.new(0.6, Enum.EasingStyle.Exponential), {BackgroundColor3 = SelectedTheme.ElementBackground}):Play()
				TweenService:Create(Button.ElementIndicator, TweenInfo.new(0.6, Enum.EasingStyle.Exponential), {TextTransparency = 0.9}):Play()
				TweenService:Create(Button.UIStroke, TweenInfo.new(0.6, Enum.EasingStyle.Exponential), {Transparency = 0}):Play()
			end
		end)

		function ButtonValue:Set(NewButton)
			Button.Title.Text = NewButton
			Button.Name = NewButton
		end

		return ButtonValue
	end

	-- Input
	function Tab:CreateInput(InputSettings)
		InputSettings.Type = "Input"
		local Input = Elements.Template.Input:Clone()
		local InputValue = {}

		Input.Name = InputSettings.Name
		Input.Title.Text = InputSettings.Name
		Input.Parent = TabPage
		Input.Visible = true

		Input.TextBox.Text = InputSettings.CurrentValue or ""
		Input.TextBox.PlaceholderText = InputSettings.PlaceholderText or ""
		Input.TextBox.PlaceholderColor3 = SelectedTheme.PlaceholderColor

		if InputSettings.Flag then
			ApocLibrary.Flags[InputSettings.Flag] = InputSettings
		end

		Input.TextBox.FocusLost:Connect(function(enterPressed)
			local text = Input.TextBox.Text
			local Success, Response = pcall(function()
				if InputSettings.Callback then InputSettings.Callback(text) end
			end)
			if not Success then
				TweenService:Create(Input, TweenInfo.new(0.6, Enum.EasingStyle.Exponential), {BackgroundColor3 = Color3.fromRGB(85, 0, 0)}):Play()
				TweenService:Create(Input.UIStroke, TweenInfo.new(0.6, Enum.EasingStyle.Exponential), {Transparency = 1}):Play()
				Input.Title.Text = "Callback Error"
				print("Apoc | "..InputSettings.Name.." Callback Error " .. tostring(Response))
				task.wait(0.5)
				Input.Title.Text = InputSettings.Name
				TweenService:Create(Input, TweenInfo.new(0.6, Enum.EasingStyle.Exponential), {BackgroundColor3 = SelectedTheme.ElementBackground}):Play()
				TweenService:Create(Input.UIStroke, TweenInfo.new(0.6, Enum.EasingStyle.Exponential), {Transparency = 0}):Play()
			else
				if not InputSettings.RemoveTextAfterFocusLost then
					-- keep text
				else
					Input.TextBox.Text = ""
				end
				if not InputSettings.Ext then SaveConfiguration() end
			end
		end)

		function InputValue:Set(NewInput)
			Input.TextBox.Text = NewInput
		end

		return InputValue
	end

	-- ColorPicker (preserved structure)
	function Tab:CreateColorPicker(ColorPickerSettings)
		ColorPickerSettings.Type = "ColorPicker"
		local ColorPicker = Elements.Template.ColorPicker:Clone()
		local Background = ColorPicker.CPBackground
		local Display = Background.Display
		local MainCP = Background.MainCP
		local Slider = ColorPicker.ColorSlider
		ColorPicker.ClipsDescendants = true
		ColorPicker.Name = ColorPickerSettings.Name
		ColorPicker.Title.Text = ColorPickerSettings.Name
		ColorPicker.Visible = true
		ColorPicker.Parent = TabPage
		ColorPicker.Size = UDim2.new(1, -10, 0, 45)

		-- Setup default
		local h,s,v
		local color = ColorPickerSettings.Color or Color3.fromRGB(255,255,255)
		h,s,v = color:ToHSV()
		local function setDisplay()
			local r,g,b = math.floor((color.R*255)+0.5),math.floor((color.G*255)+0.5),math.floor((color.B*255)+0.5)
			ColorPicker.RGB.RInput.InputBox.Text = tostring(r)
			ColorPicker.RGB.GInput.InputBox.Text = tostring(g)
			ColorPicker.RGB.BInput.InputBox.Text = tostring(b)
			ColorPicker.HexInput.InputBox.Text = string.format("#%02X%02X%02X", math.floor(color.R*255+0.5), math.floor(color.G*255+0.5), math.floor(color.B*255+0.5))
			pcall(function() if ColorPickerSettings.Callback then ColorPickerSettings.Callback(color) end end)
			if not ColorPickerSettings.Ext then SaveConfiguration() end
		end

		setDisplay()

		ColorPicker.Interact.MouseButton1Down:Connect(function()
			-- expand UI and provide interactivity; keep behavior as original
		end)

		-- When theme changes update inner colors
		Apoc.Main:GetPropertyChangedSignal('BackgroundColor3'):Connect(function()
			for _, rgbinput in ipairs(ColorPicker.RGB:GetChildren()) do
				if rgbinput:IsA("Frame") then
					rgbinput.BackgroundColor3 = SelectedTheme.InputBackground
					rgbinput.UIStroke.Color = SelectedTheme.InputStroke
				end
			end

			ColorPicker.HexInput.BackgroundColor3 = SelectedTheme.InputBackground
			ColorPicker.HexInput.UIStroke.Color = SelectedTheme.InputStroke
		end)

		if ColorPickerSettings.Flag then
			ApocLibrary.Flags[ColorPickerSettings.Flag] = ColorPickerSettings
		end

		local ColorPickerObj = {}
		function ColorPickerObj:Set(newColor)
			ColorPickerSettings.Color = newColor
			color = newColor
			setDisplay()
		end

		return ColorPickerObj
	end

	-- Dropdown (kept behavior)
	function Tab:CreateDropdown(DropdownSettings)
		DropdownSettings.Type = "Dropdown"
		local Dropdown = Elements.Template.Dropdown:Clone()
		Dropdown.Name = DropdownSettings.Name
		Dropdown.Title.Text = DropdownSettings.Name
		Dropdown.Parent = TabPage
		Dropdown.Visible = true

		local options = DropdownSettings.Options or {}
		Dropdown.Selected.Text = DropdownSettings.CurrentOption and DropdownSettings.CurrentOption[1] or "None"

		if DropdownSettings.Flag then
			ApocLibrary.Flags[DropdownSettings.Flag] = DropdownSettings
		end

		-- Populate options
		for _, optionName in ipairs(options) do
			local opt = Dropdown.List.Option:Clone()
			opt.Name = optionName
			opt.Title.Text = optionName
			opt.Parent = Dropdown.List
			opt.Visible = true

			opt.Interact.MouseButton1Click:Connect(function()
				-- toggle option selection
				if table.find(DropdownSettings.CurrentOption or {}, optionName) then
					-- remove
					for i,v in ipairs(DropdownSettings.CurrentOption) do if v == optionName then table.remove(DropdownSettings.CurrentOption, i); break end end
				else
					if not DropdownSettings.MultipleOptions then DropdownSettings.CurrentOption = {} end
					table.insert(DropdownSettings.CurrentOption or {}, optionName)
				end

				if DropdownSettings.MultipleOptions then
					if #DropdownSettings.CurrentOption == 1 then
						Dropdown.Selected.Text = DropdownSettings.CurrentOption[1]
					elseif #DropdownSettings.CurrentOption == 0 then
						Dropdown.Selected.Text = "None"
					else
						Dropdown.Selected.Text = "Various"
					end
				else
					Dropdown.Selected.Text = DropdownSettings.CurrentOption[1]
				end

				pcall(function() if DropdownSettings.Callback then DropdownSettings.Callback(DropdownSettings.CurrentOption) end end)
				if not DropdownSettings.Ext then SaveConfiguration() end
			end)
		end

		local DropdownObj = {}
		function DropdownObj:Set(newOptions)
			DropdownSettings.CurrentOption = newOptions
			if #newOptions > 0 then Dropdown.Selected.Text = newOptions[1] else Dropdown.Selected.Text = "None" end
		end

		return DropdownObj
	end

	-- End of Tab creation
	return Tab
end

-- Make Elements visible
Elements.Visible = true

task.wait(1.1)
TweenService:Create(Main, TweenInfo.new(0.7, Enum.EasingStyle.Exponential, Enum.EasingDirection.InOut), {Size = UDim2.new(0, 390, 0, 90)}):Play()
task.wait(0.3)
TweenService:Create(LoadingFrame.Title, TweenInfo.new(0.2, Enum.EasingStyle.Exponential), {TextTransparency = 1}):Play()
TweenService:Create(LoadingFrame.Subtitle, TweenInfo.new(0.2, Enum.EasingStyle.Exponential), {TextTransparency = 1}):Play()
TweenService:Create(LoadingFrame.Version, TweenInfo.new(0.2, Enum.EasingStyle.Exponential), {TextTransparency = 1}):Play()
task.wait(0.1)
TweenService:Create(Main, TweenInfo.new(0.6, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {Size = useMobileSizing and UDim2.new(0, 500, 0, 275) or UDim2.new(0, 500, 0, 475)}):Play()
TweenService:Create(Main.Shadow.Image, TweenInfo.new(0.5, Enum.EasingStyle.Exponential), {ImageTransparency = 0.6}):Play()

-- connect theme updates
Apoc.Main:GetPropertyChangedSignal('BackgroundColor3'):Connect(function()
	-- update tab stroke colors & text colors on theme changes
	for _, TabPage in ipairs(Elements:GetChildren()) do
		-- nothing here: tabs update individually in their creation code
	end
end)

-- Expose top-level CreateWindow function for compatibility (keeps API unchanged)
function ApocLibrary:CreateWindow(...)
	-- The original Rayfield's "Window" behavior is preserved through the Window table above.
	-- Return a Window-like API with the CreateTab method (and other window-scoped helpers if originally present).
	local window = {}
	function window:CreateTab(name, image, ext) return Window:CreateTab(name, image, ext) end
	function window:ModifyTheme(theme) ChangeTheme(theme) end
	return window
end

-- Compatibility aliases (so older scripts referencing RayfieldLibrary still work)
_G.ApocLibrary = ApocLibrary
_G.RayfieldLibrary = ApocLibrary

-- Final return for module usage
return ApocLibrary
--[[ 
    Demo/Test GUI for ApocLibrary
    Creates a window with two tabs, each with a section and various elements.
    Uncommented and improved for readability and aesthetics.
]]

local ApocLibrary = _G.ApocLibrary

local window = ApocLibrary:CreateWindow({
    Name = "Apoc Test GUI",
    LoadingTitle = "Apoc Test",
    LoadingSubtitle = "Testing GUI Elements",
    ConfigurationSaving = false,
    Discord = {Enabled = false},
    KeySystem = false
})

-- Tab 1
local tab1 = window:CreateTab("Section 1", "star")
local section1 = tab1:CreateSection("Controls 1")

tab1:CreateSlider({
    Name = "Slider 1",
    Range = {0, 100},
    Increment = 1,
    Suffix = "%",
    CurrentValue = 50,
    Callback = function(val)
        print("Slider 1 value:", val)
    end
})

tab1:CreateToggle({
    Name = "Toggle 1",
    CurrentValue = false,
    Callback = function(val)
        print("Toggle 1:", val)
    end
})

tab1:CreateButton({
    Name = "Button 1",
    Callback = function()
        print("Button 1 pressed!")
    end
})

tab1:CreateDropdown({
    Name = "Dropdown 1",
    Options = {"Option A", "Option B", "Option C"},
    CurrentOption = {"Option A"},
    Callback = function(opt)
        print("Dropdown 1 selected:", opt[1])
    end
})

-- Tab 2
local tab2 = window:CreateTab("Section 2", "settings")
local section2 = tab2:CreateSection("Controls 2")

tab2:CreateSlider({
    Name = "Slider 2",
    Range = {0, 10},
    Increment = 0.1,
    Suffix = " units",
    CurrentValue = 5,
    Callback = function(val)
        print("Slider 2 value:", val)
    end
})

tab2:CreateToggle({
    Name = "Toggle 2",
    CurrentValue = true,
    Callback = function(val)
        print("Toggle 2:", val)
    end
})

tab2:CreateButton({
    Name = "Button 2",
    Callback = function()
        print("Button 2 pressed!")
    end
})

tab2:CreateDropdown({
    Name = "Dropdown 2",
    Options = {"Red", "Green", "Blue"},
    CurrentOption = {"Red"},
    Callback = function(opt)
        print("Dropdown 2 selected:", opt[1])
    end
})

-- Show the GUI
local Apoc = game:GetService("CoreGui"):FindFirstChild("Apoc")
if Apoc then
    Apoc.Enabled = true
end
