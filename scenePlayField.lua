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
	speedConstant = 10 -- Bases speed for globules TODO: Adjust based upon current difficulty
	speedScale = 16.5 --Adjusts the relative speed between globules of different sizes
	testSize = 80 --TODO: remove this

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

	function tapGlobule(event)
        	if (event.target.hp > 0) then
			print("armored")
		        event.target.hp = event.target.hp - 1
		elseif (event.target.size < 21) then
		        print("size")
		        event.target:removeSelf()
		else
			print("split")
			local angle = math.random() * 2 * math.pi
			local x = math.cos(angle)
			local y = math.sin(angle)
			createGlobule(event.target.type,event.target.size / 2, x * event.target.size / 2 + event.target.x, y * event.target.size / 2 + event.target.y, x, y, event.target.red, event.target.green, event.target.blue)
			createGlobule(event.target.type,event.target.size / 2, -x * event.target.size / 2 + event.target.x, -y * event.target.size / 2 + event.target.y, -x, -y, event.target.red, event.target.green, event.target.blue)
--			createGlobule(event.target.type,math.random() * display.contentCenterX, math.random() * display.contentCenterY, -x, -y, event.target.red, event.target.green, event.target.blue)
			event.target:removeSelf()
		end

		print("globule tapped")
	end

	function squishX(obj)
		transition.to(obj,{transition = easing.inOutSine, xScale = .9, yScale = 1.1, time = 1500, onComplete = squishY})
	end

	function squishY(obj)
		transition.to(obj,{transition = easing.inOutSine, yScale = .9, xScale = 1.1, time = 1500, onComplete = squishX})
	end
	
        function createGlobule(type,size,startX,startY,deltaX,deltaY,red,green,blue)
		local group = display.newGroup() -- All globule elements contained in a group, then we only have to manipulate the group
		table.insert(globules,group)
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

		physics.addBody(group, 'dynamic', {bounce=1,radius=group.size,density=0})
		local speedLog = math.log(group.size) / speedScale
		print (speedLog)
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
		if (type == "armored") then
			glob.strokeWidth = 6
		else
			glob.strokeWidth = 2
		end
	end

	local function spawnGlobule()
		local angle = math.random() * 2 * math.pi-- random direction of movement
		local deltaX = math.cos(angle)
		local deltaY = math.sin(angle)
		local startX = math.random() * display.contentCenterX
		local startY = math.random() * display.contentCenterY
		local red = math.random()
		local green = math.random()
		local blue = math.random()
		createGlobule("normal", testSize,startX,startY,deltaX,deltaY,red,green,blue)
                print("spawn")
   	end

	spawnGlobule()

	spawnTimer = 300
	local function update()
		for _, globule in ipairs (globules) do
--			print("Update function placeholder")

		end
		spawnTimer = spawnTimer - 1
		if (spawnTimer == 0) then
			spawnGlobule()
			spawnTimer = 300
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
