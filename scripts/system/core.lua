printTable = function(root)
	if type(root) ~= "table" then
		return
	end
	local cache = {  [root] = "." }
	local function _dump(t,space,name)
		local temp = {}
		for k,v in pairs(t) do
			local key = tostring(k)
			if cache[v] then
				table.insert(temp,"+" .. key .. " {" .. cache[v].."}")
			elseif type(v) == "table" then
				local new_key = name .. "." .. key
				cache[v] = new_key
				table.insert(temp,"+" .. key .. _dump(v,space .. (next(t,k) and "|" or " " ).. string.rep(" ",#key),new_key))
			else
				table.insert(temp,"+" .. key .. " [" .. tostring(v).."]")
			end
		end
		return table.concat(temp,"\n"..space)
	end
	print(_dump(root, "",""))
end
-- L_onTick L_onRPC L_onMysql
--local json = require "cjson"

client_rpc_map = {}
nc_rpc_map = {}
cbFunc = {}


function L_onError(message)
	print("[Error]+++++++++++++++++++++++++++++++++++++++")
	print(debug.traceback())
	print("[Error]---------------------------------------\n")

end

function L_onTick( ... )
end

function L_onRPC( type,args )
	local funName = table.remove(args,1)
	local func
	if type == 1 then
		func = client_rpc_map[funName]
	else
		func = nc_rpc_map[funName]
	end	
	assert(func ~= nil, funName .. " not register")	
	func(unpack(args))
end

function L_onConnected( sockId)
	print("L_onConnected",sockId)
end
function L_onClose( sockId )
	print("L_onClose",sockId)
end
function L_onConnectedNC( sockId)
	print("L_onConnectedNC",sockId)
end
function L_onCloseNC( sockId)
	print("L_onCloseNC",sockId)
end

function L_onMysql( ret )
	print("L_onMysql", tostring(ret))
	local func = table.remove(cbFunc, 1)
	func(ret)
end
function L_onCloseMysql( sockId)
	print("L_onCloseMysql",sockId)
end

function L_encode( t )
	return cjson.L_encode(t)
end
function L_decode( str )
	return cjson.decode(str)
end



