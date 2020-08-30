function DistanceBetweenCoords(x1,y1,z1,x2,y2,z2)
	local deltax = x1 - x2
	local deltay = y1 - y2
	local deltaz = z1 - z2

	local dist = math.sqrt((deltax * deltax) + (deltay * deltay) + (deltaz * deltaz))
	--xout = math.abs(deltax)
	--yout = math.abs(deltay)
	--zout = math.abs(deltaz)
	--result = {distance = dist, x = xout, y = yout, z = zout}

	return dist
end

function DistanceBetweenCoords2D(x1,y1,x2,y2)
	local deltax = x1 - x2
	local deltay = y1 - y2

	dist = math.sqrt((deltax * deltax) + (deltay * deltay))
	--xout = math.abs(deltax)
	--yout = math.abs(deltay)
	--result = {distance = dist, x = xout, y = yout}

	return dist
end

function mysplit(inputstr, sep)
	if sep == nil then
		sep = "%s"
	end
	local t={} ; i=1
	for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
		t[i] = str
		i = i + 1
	end
	return t
end

function tobool(v)
	if v == "true" then
		return true
	else
		return false
	end
end

function calculateBonuses(humanity)
	local increase = 0
	for i=500,0,-100 do
		if humanity <= i then
			if i>500 then
				increase=increase-5
			else
				increase=increase+5
			end
			if i == 500 then increase = 0 end
		end
	end
	for i=500,1000,100 do
		if humanity >= i then
			if i>500 then
				increase=increase-5
			else
				increase=increase+5
			end
			if i == 500 then increase = 0 end
		end
	end
	return increase
end

function calculateAmmoBonuses(humanity)
	local increase = 0
	for i=500,0,-100 do
		if humanity <= i then
			if i>500 then
				increase=increase-3
			else
				increase=increase+3
			end
			if i == 500 then increase = 0 end
		end
	end
	for i=500,1000,100 do
		if humanity >= i then
			if i>500 then
				increase=increase-3
			else
				increase=increase+3
			end
			if i == 500 then increase = 0 end
		end
	end
	return increase
end

function reverseBonuses(humanity)
	local increase = 0
	for i=500,0,-100 do
		if humanity <= i then
			if i>500 then
				increase=increase+5
			else
				increase=increase-5
			end
			if i == 500 then increase = 0 end
		end
	end
	for i=500,1000,100 do
		if humanity >= i then
			if i>500 then
				increase=increase+5
			else
				increase=increase-5
			end
			if i == 500 then increase = 0 end
		end
    end
	return increase
end

function math.round(num, numDecimalPlaces)
	if numDecimalPlaces and numDecimalPlaces>0 then
		local mult = 10^numDecimalPlaces
		return math.floor(num * mult + 0.5) / mult
	end
	return math.floor(num + 0.5)
end

function deepcopy(orig)
    local orig_type = type(orig)
    local copy
    if orig_type == 'table' then
        copy = {}
        for orig_key, orig_value in next, orig, nil do
            copy[deepcopy(orig_key)] = deepcopy(orig_value)
        end
        setmetatable(copy, deepcopy(getmetatable(orig)))
    else -- number, string, boolean, etc
        copy = orig
    end
    return copy
end