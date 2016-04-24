--------------------------------------------------------------------------------
-- GLOBALS
--------------------------------------------------------------------------------

-- CONSTANTS
Global("TXT_NOTIFICATION_MSG", "Msg")

-- Other
Global("locale", nil)

--------------------------------------------------------------------------------
-- Helper functions
--------------------------------------------------------------------------------
function GetTableSize( t )
	if not t then
		return 0
	end
	local count = 0
	for k, v in pairs( t ) do
		count = count + 1
	end
	return count
end

function InitLocalization()
	locale = common.GetLocalization()
end

function GetTextLocalized(strTextName)
	if locale == nil then
	    -- Default to English
		return common.GetAddonRelatedTextGroup("eng_eu"):GetText(strTextName)
	else
		return common.GetAddonRelatedTextGroup(locale):GetText(strTextName)
	end
end

--------------------------------------------------------------------------------
-- Logging helpers
--------------------------------------------------------------------------------
function GetStringListByArguments( ... )
	local argList = {...}
	local newArgList = {}
	
	for i = 1, #argList do
		local arg = argList[ i ]
		if common.IsWString( arg ) then
			newArgList[ i ] = arg
		else
			newArgList[ i ] = tostring( arg )
		end
	end

	return newArgList
end
--------------------------------------------------------------------------------
function LogInfo( ... )
	common.LogInfo( common.GetAddonName(), unpack( GetStringListByArguments( ... ) ) )
end
--------------------------------------------------------------------------------
function LogInfoCommon( ... )
	common.LogInfo( "common", unpack( GetStringListByArguments( ... ) ) )
end
--------------------------------------------------------------------------------
function LogWarning( ... )
	common.LogWarning( "common", unpack( GetStringListByArguments( ... ) ) )
end
--------------------------------------------------------------------------------
function LogError( ... )
	common.LogError( "common", unpack( GetStringListByArguments( ... ) ) )
end
--------------------------------------------------------------------------------