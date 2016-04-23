--------------------------------------------------------------------------------
-- GLOBALS
--------------------------------------------------------------------------------
Global("wtMainPanel", nil)

--------------------------------------------------------------------------------
-- REACTION HANDLERS
--------------------------------------------------------------------------------
function IsMountHungry(mountInfo)
	local isHungry = false
	if mountInfo.canBeFeeded and mountInfo.satiationMs == 0 then
		isHungry = true
	end
	return isHungry
end

function DisplayFoodShortageMessage()
	local stableInfo = mount.GetStableInfo()
	if stableInfo and stableInfo.foodCount < 3 then
		wtMainPanel:Show(true)
	end
end

function FeedMountIfHungry(mountInfo)
	if IsMountHungry(mountInfo) then
		mount.Feed(mountInfo.id)
		DisplayFoodShortageMessage()
	end
end

function DoFeedMount(mountId, caller)
	local mountInfo = mount.GetInfo(mountId)
	FeedMountIfHungry(mountInfo)
end

-- EVENT_STABLE_MOUNT_HUNGRY
function OnEventMountHungry(param)
	DoFeedMount(param.id, "OnEventMountHungry")
end

-- EVENT_ACTIVE_MOUNT_CHANGED
function OnEventMountChanged()
	local mountId = mount.GetActive()
	if mountId then
		DoFeedMount(mountId, "OnEventMountChanged")
	end
end

-- "close"
function OnReactionClose(params)
	wtMainPanel:Show(false)
end

--------------------------------------------------------------------------------
-- INITIALIZATION
--------------------------------------------------------------------------------
function InitEventHandlers()
	common.RegisterEventHandler(OnEventMountHungry, "EVENT_STABLE_MOUNT_HUNGRY")
	common.RegisterEventHandler(OnEventMountChanged, "EVENT_ACTIVE_MOUNT_CHANGED")
end

function Init()
	InitEventHandlers()
	common.RegisterReactionHandler(OnReactionClose, "close") 
	wtMainPanel = mainForm:GetChildChecked("MainPanel", false)
	LogInfo("Initialized [1.0, ", _VERSION, "]")
end
--------------------------------------------------------------------------------
Init()
--------------------------------------------------------------------------------
