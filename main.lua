local brokerPlayedTime = LibStub:GetLibrary("LibDataBroker-1.1"):GetDataObjectByName("Time Played")

local timeManagerFrame = CreateFrame("Frame")
local clockButtonUpdateTooltipHooked = false

local function HookClockButton()

  -- Blizzard_TimeManager is load on demand. If another addon (e.g. a UI overhaul) has
  -- already pulled it in before we registered for ADDON_LOADED, that event never fires
  -- for us again, so we also have to check whether the button is simply already there.
  if clockButtonUpdateTooltipHooked or not TimeManagerClockButton then return end

  -- The Blizzard UI only updates the TimeManagerClockButton (and with it the tooltip) once per second.
  -- But we want the tooltip to be shown immediately!
  TimeManagerClockButton:HookScript("OnEnter", function()
    TimeManagerClockButton_UpdateTooltip()
  end)


  -- Add PlayedTime to clock button tooltip!
  hooksecurefunc("TimeManagerClockButton_UpdateTooltip", function ()

    if not GameTooltip:IsShown() then return end

    GameTooltip:AddLine(" ")
    GameTooltip:AddLine(" ")

    brokerPlayedTime.OnTooltipShow(GameTooltip)

    -- Adjust tooltip size.
    GameTooltip:Show()
  end)

  -- Add PlayedTime options to right click!
  TimeManagerClockButton:SetScript("OnClick", function (self, button)

    GameTooltip:Hide()

    if button == "RightButton" then
      brokerPlayedTime.OnClick(self, button)
      if TimeManagerFrame:IsVisible() then
        GameTooltip:Hide()
      end
    else
      TimeManagerClockButton_OnClick(self)
      if not TimeManagerFrame:IsVisible() then
        self:GetScript("OnEnter")(self)
      end
    end

  end)

  clockButtonUpdateTooltipHooked = true

end


timeManagerFrame:RegisterEvent("ADDON_LOADED")
timeManagerFrame:RegisterEvent("PLAYER_LOGIN")
timeManagerFrame:SetScript("OnEvent", function(self, event, name)

  if event == "ADDON_LOADED" and name ~= "Blizzard_TimeManager" then return end

  HookClockButton()

  if clockButtonUpdateTooltipHooked then
    self:UnregisterAllEvents()
    self:SetScript("OnEvent", nil)
  end

end)
