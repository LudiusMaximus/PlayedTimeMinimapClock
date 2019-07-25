local brokerPlayedTime = LibStub:GetLibrary("LibDataBroker-1.1"):GetDataObjectByName("Time Played")

local timeManagerFrame = CreateFrame("Frame")
local clockButtonUpdateTooltipHooked = false
timeManagerFrame:RegisterEvent("ADDON_LOADED")
timeManagerFrame:SetScript("OnEvent", function(self, event, ...)

  local name = ...
  if not clockButtonUpdateTooltipHooked and name == "Blizzard_TimeManager" then
  
    -- Add PlayedTime to clock button tooltip!
    hooksecurefunc("TimeManagerClockButton_UpdateTooltip", function ()

      GameTooltip:AddLine(" ")
      GameTooltip:AddLine(" ")

      brokerPlayedTime.OnTooltipShow(GameTooltip)
     
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

end)
