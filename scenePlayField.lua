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
	speedScale = 3.5 --Adjusts the relative speed between globules of different sizes

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

	local function createGlobule(type,size)
		local group = display.newGroup() -- All globule elements contained in a group, then we only have to manipulate the group
		table.insert(globules,group)
		group.size = size --Represents the current globule size 
		startX = math.random() * display.contentWidth
		startY = math.random() * display.contentHeight
		local glob = display.newCircle(0,0,group.size)
		group:insert(glob)
		sceneGroup:insert(group)
		group.x = startX
		group.y = startY
		physics.addBody(group, 'dynamic', {bounce=1,radius=group.size,density=0})
		print("number:",(math.random()-0.5) *20/group.size)
		angle = math.random() * 2 * math.pi -- random direction of movement
		group:applyForce((math.cos(angle))*speedConstant/group.size,(math.sin(angle))*speedConstant - math.log(group.size/10)/speedScale, group.x,group.y) -- Ensure consistent speed among globules of the same size
		group:applyTorque(math.random() * 1900/group.size)

		--color
		local cA = math.random()
		local cB = math.random()
		local cC = math.random()
		local cD = 0
		local cE = 0
		local cF = 0

		if cA > 0.4 and cA < 0.6
			then
				cD = math.abs(0.5 - cA)
			else
				cD = 1 - cA
			end
		if cB > 0.4 and cB < 0.6
			then
				cE = math.abs(0.5 - cB)
			else
				cE = 1 - cB
			end
		if cC > 0.4 and cB < 0.6
			then
				cF = math.abs(0.5 - cC)
			else
				cF = 1 - cC
		end


		glob:setFillColor(cA,cB,cC) 
		glob:setStrokeColor(cD,cE,cF)
		glob.strokeWidth = 2
	end

	createGlobule("normal",60) --TODO: remove this; for testing only
	createGlobule("normal",30)
	createGlobule("normal",15)

	local function update()
		for _, globule in ipairs (globules) do
			print("Update function placeholder")
		end
	end

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
