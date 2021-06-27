local is_debugging
local player_guid

local function sd_combat_log(timestamp, combat_event, src_guid, src_name, src_flags, dst_guid, dst_name, dst_flags, spell_id, spell_name)
  if is_debugging and src_guid == player_guid then
      ChatFrame1:AddMessage(spell_id)
      ChatFrame1:AddMessage(spell_name)
      ChatFrame1:AddMessage(combat_event)
  end
end

local function sd_commands(sub_string)
  is_debugging = not is_debugging
  ChatFrame1:AddMessage("Debugging is now hopefully on.")
end

local function sd_on_load(self)
        self:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
        SlashCmdList["SPELLSDEBUGGER"] = sd_commands
        SLASH_SPELLSDEBUGGER1 = "/sd"
        is_debugging = false
        player_guid = UnitGUID("player")
end

local event_handler = {
    ["PLAYER_LOGIN"] = function(self) sd_on_load(self) end,
    ["COMBAT_LOG_EVENT_UNFILTERED"] = function(self,...) sd_combat_log(...) end,
}

local function sd_on_event(self,event,...)
	event_handler[event](self,...)
end

if not sd_frame then 
    CreateFrame("Frame","sd_frame",UIParent)
end
sd_frame:SetScript("OnEvent",sd_on_event)
sd_frame:RegisterEvent("PLAYER_LOGIN")