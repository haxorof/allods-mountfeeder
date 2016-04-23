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