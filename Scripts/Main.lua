--------------------------------------------------------------------------------
-- GLOBALS
--------------------------------------------------------------------------------

-- CONSTANTS
Global("MESSAGE_FADE_IN_TIME", 350)
Global("MESSAGE_FADE_SOLID_TIME", 4000)
Global("MESSAGE_FADE_OUT_TIME", 1000)

Global("WIDGET_FADE_TRANSPARENT", 1)
Global("WIDGET_FADE_IN", 2)
Global("WIDGET_FADE_SOLID", 3)
Global("WIDGET_FADE_OUT", 4)

-- WIDGETS
Global("wtNotificationMsg", nil)

-- OTHER
Global("fadeStatus", WIDGET_FADE_TRANSPARENT)

--------------------------------------------------------------------------------
-- REACTION HANDLERS
--------------------------------------------------------------------------------
function DisplayNotificationMessage()
	local stableInfo = mount.GetStableInfo()
	if stableInfo and stableInfo.foodCount < 3 then
		local vt=common.CreateValuedText()
		vt:SetFormat(userMods.ToWString([[<html><header color="0xFFF8ED69" alignx="center" fontsize="28" shadow="1"><r name="message"/></header></html>]]))
		vt:SetVal("message", GetTextLocalized(TXT_NOTIFICATION_MSG))
		wtNotificationMsg:SetValuedText(vt)
		wtNotificationMsg:Show(true)
		wtNotificationMsg:PlayFadeEffect(0.0, 1.0, MESSAGE_FADE_IN_TIME, EA_MONOTONOUS_INCREASE)
		fadeStatus = WIDGET_FADE_IN
	end
end

function IsMountHungry(mountInfo)
	local isHungry = false
	if mountInfo.canBeFeeded and mountInfo.satiationMs == 0 then
		isHungry = true
	end
	return isHungry
end

function DoFeedMount(mountId, caller)
	local mountInfo = mount.GetInfo(mountId)
	if IsMountHungry(mountInfo) then
		mount.Feed(mountInfo.id)
		DisplayNotificationMessage()
	end
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

-- EVENT_EFFECT_FINISHED
function OnEventEffectFinished(params)
	if params.wtOwner:IsEqual(wtNotificationMsg) then
		if fadeStatus == WIDGET_FADE_IN then
			wtNotificationMsg:PlayFadeEffect(1.0, 1.0, MESSAGE_FADE_SOLID_TIME, EA_MONOTONOUS_INCREASE)
			fadeStatus = WIDGET_FADE_SOLID		
		elseif fadeStatus == WIDGET_FADE_SOLID then
			wtNotificationMsg:PlayFadeEffect(1.0, 0.0, MESSAGE_FADE_OUT_TIME, EA_MONOTONOUS_INCREASE)
			fadeStatus = WIDGET_FADE_OUT		
		elseif fadeStatus == WIDGET_FADE_OUT then
			fadeStatus = WIDGET_FADE_TRANSPARENT
			wtNotificationMsg:Show(false)
		end
	end
end

--------------------------------------------------------------------------------
-- INITIALIZATION
--------------------------------------------------------------------------------
function InitEventHandlers()
	common.RegisterEventHandler(OnEventMountHungry, "EVENT_STABLE_MOUNT_HUNGRY")
	common.RegisterEventHandler(OnEventMountChanged, "EVENT_ACTIVE_MOUNT_CHANGED")
	common.RegisterEventHandler(OnEventEffectFinished, "EVENT_EFFECT_FINISHED")
end

function InitWidgets()
	wtNotificationMsg = mainForm:GetChildChecked("NotificationMsg", false)
	wtNotificationMsg:Show(false)
end

function Init()
	InitLocalization()
	InitEventHandlers()
	InitWidgets()
end
--------------------------------------------------------------------------------
Init()
--------------------------------------------------------------------------------
