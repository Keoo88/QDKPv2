
--          Quick DKP V2 - Community patch
--
--            QuickBid module
--
--  Fast way to start a bid without opening the Bid Manager manually:
--    ALT+Right-click an item in your bags -> bid starts instantly
--
--  The Bid Manager window is NOT opened: the bid just starts and is announced.
--  Open it any time via right-click on the minimap button. Requires officer
--  rights; management mode is enforced by QDKP2_BidM_StartBid itself.
--
--  Set QDKP2_QuickBid_Enabled = false in DefaultOptions.lua to disable.


local function QDKP2_QuickBid_Start(itemLink)
  if not itemLink or itemLink == "" then return; end
  if QDKP2_QuickBid_Enabled == false then return; end
  if not QDKP2_OfficerMode() then return; end          --silently ignore for regular raiders
  if QDKP2_BidM_isBidding() then
    QDKP2_Msg("A bid is already running for "..tostring(QDKP2_BidM.ITEM or '-')..". Close or cancel it first.","WARNING")
    return
  end
  QDKP2_Debug(2,"QuickBid","Starting quick bid for "..itemLink)
  QDKP2_BidM_StartBid(itemLink)
  if not QDKP2_BidM_isBidding() then return; end       --StartBid refused (eg. no management mode)
  QDKP2_Events:Fire("DATA_UPDATED","roster")
end

-- ALT+Right-click on an item in the bags.
-- With a modifier key held, the client runs OnModifiedClick INSTEAD of the
-- default right-click action, so the item is not used/equipped by mistake.
hooksecurefunc("ContainerFrameItemButton_OnModifiedClick", function(self, button)
  if button == "RightButton" and IsAltKeyDown() then
    local bag = self:GetParent():GetID()
    local slot = self:GetID()
    local itemLink = GetContainerItemLink(bag, slot)
    QDKP2_QuickBid_Start(itemLink)
  end
end)
