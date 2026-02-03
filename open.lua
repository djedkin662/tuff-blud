-- // Slap Abuse GUI - Rayfield Edition - kneehfitobreatheair only
-- // 2025/2026 vibe

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "kneehfitobreatheair's Panel",
   LoadingTitle = "Mass Murder Tools",
   LoadingSubtitle = "by kneehfitobreatheair",
   ConfigurationSaving = {
      Enabled = false,
      FolderName = nil,
      FileName = "KneeConfig"
   },
   Discord = {
      Enabled = false,
   },
   KeySystem = false,
})

local MainTab = Window:CreateTab("Main", 4483362458) -- random icon id

-- Very strict owner check
local AllowedName = "kneehfitobreatheair"
local lp = game.Players.LocalPlayer

if lp.Name ~= AllowedName then
   Rayfield:Notify({
      Title = "Access Denied",
      Content = "This script belongs to kneehfitobreatheair only.",
      Duration = 6.5,
      Image = 4483362458,
   })
   task.wait(3)
   game.Players.LocalPlayer:Kick("Not kneehfitobreatheair → access revoked")
   return
end

-- ──────────────────────────────────────────────
--  Remotes
-- ──────────────────────────────────────────────

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local events = ReplicatedStorage:WaitForChild("events", 8)

local slapRemote  = events and events:WaitForChild("SendSlap", 5)
local queueRemote = events and events:WaitForChild("SlapQueue", 5)

if not slapRemote or not queueRemote then
   Rayfield:Notify({
      Title = "Critical Error",
      Content = "Couldn't find SendSlap or SlapQueue remotes.\nGame updated / wrong place?",
      Duration = 8,
   })
   return
end

-- ──────────────────────────────────────────────
--  Variables & Loop Control
-- ──────────────────────────────────────────────

local MassMurderRunning = false
local SpamSpeed = 18   -- default (lower = faster)

local function getDelay()
   return math.clamp(1 / SpamSpeed, 0.0008, 1)   -- roughly maps 1–30 → delay
end

-- ──────────────────────────────────────────────
--  Mass Murder (Auto Slap + Auto Queue combined)
-- ──────────────────────────────────────────────

local MassMurderToggle = MainTab:CreateToggle({
   Name = "Mass Murder",
   CurrentValue = false,
   Flag = "MassMurderToggle",
   Callback = function(Value)
      MassMurderRunning = Value
      
      if Value then
         Rayfield:Notify({
            Title = "Mass Murder Activated",
            Content = "Slapping + queue spamming at full power...",
            Duration = 4,
         })
         
         task.spawn(function()
            while MassMurderRunning do
               pcall(function()
                  slapRemote:FireServer(999999)
                  queueRemote:FireServer()
               end)
               task.wait(getDelay())
            end
         end)
      else
         Rayfield:Notify({
            Title = "Mass Murder Paused",
            Content = "Stopped spamming.",
            Duration = 3,
         })
      end
   end,
})

-- ──────────────────────────────────────────────
--  Single Slap (also can be used to interrupt loops visually)
-- ──────────────────────────────────────────────

MainTab:CreateButton({
   Name = "Slap Once (can also force stop the crash)",
   Callback = function()
      pcall(function()
         slapRemote:FireServer(999999)
      end)
      Rayfield:Notify({
         Title = "Single Slap",
         Content = "Fired SendSlap once (999999 dmg)",
         Duration = 2.2,
      })
   end,
})

-- ──────────────────────────────────────────────
--  Crash Booth (aggressive queue spam)
-- ──────────────────────────────────────────────

MainTab:CreateButton({
   Name = "Crash Booth",
   Callback = function()
      if MassMurderRunning then
         MassMurderToggle:Set(false) -- auto turn off mass murder if running
      end
      
      Rayfield:Notify({
         Title = "Booth Crasher",
         Content = "Spamming SlapQueue × 80...",
         Duration = 3.5,
      })
      
      for i = 1, 80 do
         pcall(function()
            queueRemote:FireServer()
         end)
         task.wait(0.0009)
      end
      
      Rayfield:Notify({
         Title = "Done",
         Content = "Sent 80× SlapQueue (booth crash attempt)",
         Duration = 4,
      })
   end,
})

-- ──────────────────────────────────────────────
--  Speed Slider
-- ──────────────────────────────────────────────

local SpeedSlider = MainTab:CreateSlider({
   Name = "Spam Speed (higher = faster)",
   Range = {1, 30},
   Increment = 1,
   Suffix = "×",
   CurrentValue = 18,
   Flag = "SpamSpeed",
   Callback = function(Value)
      SpamSpeed = Value
      Rayfield:Notify({
         Title = "Speed Updated",
         Content = "New spam speed: " .. Value .. "×",
         Duration = 2.5,
      })
   end,
})

-- Final message
Rayfield:Notify({
   Title = "kneehfitobreatheair Panel Loaded",
   Content = "Mass Murder = slap + queue spam\nOnly you can use this.",
   Duration = 5.5,
   Image = 4483362458,
})

print("[kneehfitobreatheair] Panel loaded - owner verified")
