
--set background
display.setDefault("background",25/255, 25/255, 112/255)
--stars
thisThing = {}
numOfStars = 50
for i = 1, numOfStars do
	thisThing[i] = display.newCircle(0,0,2)
	thisThing[i]:setFillColor(255,255,255)
	thisThing[i].x=math.random(0,display.contentWidth)
	thisThing[i].y=math.random(0,display.contentHeight)
end
for j = 1, numOfStars do
		transition.blink(thisThing[j],{time=math.random(500,10000)})
	end
--moon
local moon = display.newImage("moon.png") 
moon.x = 0
moon.y = 100
transition.to(moon, {time = 37500, x = 280, y = -8} )

-- function to draw building and window
local function installWindows( bX, bY, bW, bRC, bH, bFC, getTime )

	local bldgX = bX -- LEFT HAND HORIZONTAL POSITION
	local bldgY = bY -- THE FLOOR, THE BASE

	local bldgLayers = display.newGroup() 

	local bldgWidth = bW
	local bldgHeight = bH
	local bldgFloorCount = bFC
	local bldgRoomCount = bRC

	local windowWidthToRoomWidthRatio = 1 / 3
	local windowHeightToFloorHeightRatio = 1 / 3 

	local bldgRoomWidth = math.round( bldgWidth / bldgRoomCount )
	local bldgFloorHeight = math.round( bldgHeight / bldgFloorCount )
	local bldgWindowWidth = math.round( bldgRoomWidth * windowWidthToRoomWidthRatio )
	local bldgWindowHeight = math.round( bldgFloorHeight * windowHeightToFloorHeightRatio )

	local roomCenterX = bldgRoomWidth * 0.50
	local roomCenterY = bldgFloorHeight * 0.50

	local remainderX = bldgWidth - ( bldgRoomWidth * bldgRoomCount )
	local remainderY = bldgHeight - ( bldgFloorHeight * bldgFloorCount )
	remainderX = remainderX * 0.5
	remainderY = remainderY * 0.5

	local windowCenterX = bldgWindowWidth * 0.5
	local windowCenterY = bldgWindowHeight * 0.5 
	local windowAnchorX = remainderX - roomCenterX
	local windowAnchorY = remainderY - roomCenterY

	local windowLightsOff = { 0, 0, 0 }
	local windowLightsOn = { 1, .8, .2 }
	local buildingColor = { .3, .3, .3 } 

	local bldgAdjustX = bldgX + ( bldgWidth * 0.5 ) 

	local windowAdjustX = bldgX + windowAnchorX

	local bldgAdjustY = bldgY - ( bldgHeight * 0.5 )

	local windowAdjustY = bldgY + windowAnchorY - bldgHeight

	local bldgShell = display.newRect( bldgAdjustX, bldgAdjustY, bldgWidth, bldgHeight )
	bldgShell.fill = buildingColor

	bldgLayers:insert(bldgShell) 

		for column = 1, bldgRoomCount do
			for row = 1, bldgFloorCount do
				local xPos = windowAdjustX + (column * bldgRoomWidth) 
				local yPos = windowAdjustY + (row * bldgFloorHeight) 
				local window = display.newRect (xPos, yPos, bldgWindowWidth, bldgWindowHeight)
				window.fill = windowLightsOff
				bldgLayers:insert(window)
			end
		end

	local timeRow = math.ceil( getTime/bRC )-1
	local timeCol = getTime%bRC
		for row = 1, timeRow do
			for column = 1, bldgRoomCount do
				local xPos = windowAdjustX + (column * bldgRoomWidth) 
				local yPos = windowAdjustY + (row * bldgFloorHeight) 
				local light1 = display.newRect (xPos, yPos, bldgWindowWidth, bldgWindowHeight)
				light1.fill = windowLightsOn
				bldgLayers:insert(light1)
			end
		end
		for row = timeRow +1, timeRow + 1 do
			for column = 1, timeCol do
				local xPos = windowAdjustX + (column * bldgRoomWidth) 
				local yPos = windowAdjustY + (row * bldgFloorHeight) 
				local light2 = display.newRect (xPos, yPos, bldgWindowWidth, bldgWindowHeight)
				light2.fill = windowLightsOn
				bldgLayers:insert(light2)
			end
		end


return bldgLayers
end

local groundLevel = display.contentHeight * 0.98 -- ground level!

--call function
local buildingOne = installWindows( 20, groundLevel, 100, 4, 280, 6 ,os.date("%H"))
local buildingTwo = installWindows( 200, groundLevel, 100, 6, 380, 10 , os.date("%M"))

--shake to transition
local function onShake( event )
	if event.isShake then
		transition.to(buildingOne, {time = 7500, x = 180} )
		transition.to(buildingTwo, {time = 7500, x = -150} )
	end
end

Runtime:addEventListener("accelerometer",onShake,0)

