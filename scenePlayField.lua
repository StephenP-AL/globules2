local composer = require( "composer" )
local scene = composer.newScene()
 
---------------------------------------------------------------------------------
-- All code outside of the listener functions will only be executed ONCE
-- unless "composer.removeScene()" is called.
---------------------------------------------------------------------------------
 
-- local forward references should go here
 
---------------------------------------------------------------------------------
 
-- "scene:create()"
function scene:create( event )
 
   local sceneGroup = self.view
   -- Initialize the scene here.
   -- Example: add display objects to "sceneGroup", add touch listeners, etc.
end
 
-- "scene:show()"
function scene:show( event )
 
   local sceneGroup = self.view
   local phase = event.phase
 
   if ( phase == "will" ) then
      -- Called when the scene is still off screen (but is about to come on screen).
     	 
      	local pysics = require("physics")
	physics.start()
	physics.setGravity(0,0)

	--globule constants
	speedConstant = 10 -- Bases speed for globules TODO: Adjust based upon current difficulty
	speedScale = 16.5 --Adjusts the relative speed between globules of different sizes
	testSize = 80 -- default size of globule TODO: find a better way to do this

	--Play statistics
	saturationLimit = 400
	saturation = 0
	score = 0
	pause = true

	--
	-- TODO replace these text displays with widgets
	local saturationText = display.newText("Saturation: 0",0,0)
	saturationText.anchorX = 0
	local scoreText = display.newText("Score: 0",0,20)
	scoreText.anchorX = 0

	--Field boundries
	local boundTop = display.newRect(0,0,display.contentWidth,0)
	boundTop.anchorX = 0; boundTop.anchorY = 0
	local boundBottom = display.newRect(0, display.contentHeight, display.contentWidth, 0)
	boundBottom.anchorX = 0; boundBottom.anchorY = 0
	local boundLeft = display.newRect(0, 0,0 , display.contentHeight)
	boundLeft.anchorX = 0; boundLeft.anchorY = 0
	local boundRight = display.newRect(display.contentWidth, 0, 0, display.contentHeight)
	boundRight.anchorX = 0; boundRight.anchorY = 0
	pysics.addBody(boundTop, 'static')
	pysics.addBody(boundBottom, 'static')
	pysics.addBody(boundLeft, 'static')
	pysics.addBody(boundRight, 'static')


	--Globules
	local globules = {} --table to reference all globules

	function scene:resumeGame()
		pause = false
		physics.start()
	end
	function addScore(points)
		score = score + points
		scoreText.text = "Score: "..score
	end
	function tapGlobule(event)
        	if (event.target.hp > 0) then
		        event.target.hp = event.target.hp - 1
			--TODO: need a visual and audio indicator of hit
			addScore(1)
		elseif (event.target.size < 21) then
			event.target.delete = true
		        event.target:removeSelf()
			score = score + 4
			scoreText.text = "Score: "..score
		else
			if (event.target.type == "multi") then
				local angle = math.random() * 2 * math.pi
				for i = 0,2,1 do
					local x = math.cos(angle + i * 4 / 3 * math.pi) 
					local y = math.sin(angle + i * 4 / 3 * math.pi) 
					createGlobule(
						event.target.type,
						event.target.size / 2,
						x * event.target.size / 2 + event.target.x,
						y * event.target.size / 2 + event.target.y,
						x,
						y,
						event.target.red,
						event.target.green,
						event.target.blue
						)
				end
			else 
				local angle = math.random() * 2 * math.pi
				local x = math.cos(angle)
				local y = math.sin(angle)
				createGlobule(
					event.target.type,
					event.target.size / 2, 
					x * event.target.size / 2 + event.target.x, 
					y * event.target.size / 2 + event.target.y, 
					x, 
					y, 
					event.target.red, 
					event.target.green, 
					event.target.blue)
				createGlobule(
					event.target.type,
					event.target.size / 2, 
					-x * event.target.size / 2 + event.target.x, 
					-y * event.target.size / 2 + event.target.y, 
					-x, 
					-y, 
					event.target.red, 
					event.target.green, 
					event.target.blue)
					
				end
			event.target.delete = true
			event.target:removeSelf()
			score = score + 1
			scoreText.text = "Score: "..score

		end

	end

	-- Globule animation
	function squishX(obj)
		transition.to(obj,{transition = easing.inOutSine, xScale = .9, yScale = 1.1, time = 3500, onComplete = squishY})
	end

	function squishY(obj)
		transition.to(obj,{transition = easing.inOutSine, yScale = .9, xScale = 1.1, time = 3500, onComplete = squishX})
	end
	
        function createGlobule(type,size,startX,startY,deltaX,deltaY,red,green,blue)
		local group = display.newGroup() -- All globule elements contained in a group, then we only have to manipulate the group
		table.insert(globules,group)
		group.delete = false
		group.size = size --Represents the current globule size 
		group.type = type
		group.hp = 0
		if (type == "armored") then
			group.hp = 2
		end
		group.x = startX
		group.y = startY

		group.red = red
		group.green = green
		group.blue = blue

		local glob = display.newCircle(0,0,group.size)
		group:addEventListener("tap",tapGlobule)
		group:insert(glob)
		sceneGroup:insert(group)
		if (type == "paramecium") then
			physics.addBody(group, 'dynamic', {bounce=1,radius=group.size,density=.1})
		else
			physics.addBody(group, 'dynamic', {bounce=1,radius=group.size,density=0})
		end
		local speedLog = math.log(group.size) / speedScale
		group:applyForce(deltaX * speedConstant * speedLog, deltaY * speedConstant * speedLog ) -- Ensure consistent speed among globules of the same size
--		group:applyTorque(1- math.random() / 100 )
		squishX(group)

		--color
		local cD = 0
		local cE = 0
		local cF = 0

		if red > 0.4 and red < 0.6
			then
				cD = math.abs(0.5 - red)
			else
				cD = 1 - red
			end
		if green > 0.4 and green < 0.6
			then
				cE = math.abs(0.5 - green)
			else
				cE = 1 - green
			end
		if blue > 0.4 and blue < 0.6
			then
				cF = math.abs(0.5 - blue)
			else
				cF = 1 - blue
		end


		glob:setFillColor(red,green,blue) 
		glob:setStrokeColor(cD,cE,cF)		

		if (type == "multi") then
			for i=0, 3 ,1 do
				globlette1 = display.newCircle(
					math.cos(math.pi * i * 4 / 3) * group.size / 2, 
					math.sin(math.pi * i * 4 / 3) * group.size / 2,
					group.size / 2)
				globlette1:setFillColor(red,green,blue)
				globlette1:setStrokeColor(cD,cE,cF)
				globlette1.strokeWidth = 2
				group:insert(globlette1)
			end
		end 
		--Paramecium
		if (type == "paramecium") then
			for i=0, 2 * math.pi,math.pi/12
				do
					local x = math.cos(i)
					local y = math.sin(i)
					line = display.newLine(x * group.size,y * group.size,x * (group.size + 6),y* (group.size +6))
					line:setStrokeColor(cD,cE,cF)
					group:insert(line)
					group.jump = math.random() * 200
				end
			end



		if (type == "armored") then
			glob.strokeWidth = 10
		else
			glob.strokeWidth = 2
		end
	end

	local function spawnGlobule(type)
		local angle = math.random() * 2 * math.pi-- random direction of movement
		local deltaX = math.cos(angle)
		local deltaY = math.sin(angle)
		local startX = math.random() * display.contentCenterX
		local startY = math.random() * display.contentCenterY
		local red = math.random()
		local green = math.random()
		local blue = math.random()
		createGlobule(type, testSize,startX,startY,deltaX,deltaY,red,green,blue)
   	end

	local options = {
		isModal = true,
		params = {introText = event.params.introText}
	}
	composer.showOverlay("sceneLevelIntro",options)

	local initSpawnTimer = event.params.spawnTimer
	local spawnIterator = 1
	local spawnTimer = initSpawnTimer
	local function update()
		if (pause == true)then
			return
		end
		print(#globules)
		local sat = 0
		for index, globule in pairs (globules) do
			if (globule.delete) then
				table.remove(globules,index)
			else
				if (globule.size == 80)then
					sat = sat + globule.size
				else if (globule.size == 40) then
					sat = sat + 26
				else if (globule.size == 20) then
					sat = sat + 8
				end
				end
				end
			end
			-- Random movement of paramecium
			if (globule.type == "paramecium") then
				globule.jump = globule.jump - 1
				if (globule.jump <= 0) then
					globule:applyForce((0.5 - math.random()) * globule.size , (.5 - math.random()) * globule.size   ) 
					globule.jump = math.random() * 200
				end
			end

		end
		saturation = sat
		saturationText.text = "Saturation: "..saturation
		if (spawnIterator <= #event.params.spawnList)then
			spawnTimer = spawnTimer - 1
			if (spawnTimer == 0) then
				spawnGlobule(event.params.spawnList[spawnIterator]) --TODO:Replace this with a set spawn table passed as param
				spawnIterator = spawnIterator + 1
				spawnTimer = initSpawnTimer
			end
		end
		end

	timer.performWithDelay(16,update,0)

  elseif ( phase == "did" ) then
      -- Called when the scene is now on screen.
      -- Insert code here to make the scene come alive.
      -- Example: start timers, begin animation, play audio, etc.
   end
end
 
-- "scene:hide()"
function scene:hide( event )
 
   local sceneGroup = self.view
   local phase = event.phase
 
   if ( phase == "will" ) then
      -- Called when the scene is on screen (but is about to go off screen).
      -- Insert code here to "pause" the scene.
      -- Example: stop timers, stop animation, stop audio, etc.
   elseif ( phase == "did" ) then

      -- Called immediately after scene goes off screen.
   end
end
 
-- "scene:destroy()"
function scene:destroy( event )
 
   local sceneGroup = self.view
 
   -- Called prior to the removal of scene's view ("sceneGroup").
   -- Insert code here to clean up the scene.
   -- Example: remove display objects, save state, etc.
end
 
---------------------------------------------------------------------------------
 
-- Listener setup
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )
 
---------------------------------------------------------------------------------
 
return scene
