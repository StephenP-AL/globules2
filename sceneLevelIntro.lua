local composer = require( "composer" )
local scene = composer.newScene()
local physics = require("physics")
local widget = require("widget") 

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

	physics.setGravity(0,-1)
	physics.start()
	local boundTop = display.newRect(display.contentCenterX,-5,display.contentWidth,0)
	sceneGroup:insert(boundTop)
      	physics.addBody(boundTop,"static")

	local background = display.newRoundedRect(display.contentCenterX,display.contentCenterY,display.contentWidth,display.contentHeight,4)
	background:setFillColor(.2,0.2,0.5,.85)
	sceneGroup:insert(background)
	
	introText = event.params.introText

	for index, line in pairs(event.params.introText) do
		text = display.newText(line,display.contentCenterX,display.contentHeight + index * 50)
		transition.to(text,{y = index * 25, time = 4000})
		sceneGroup:insert(text)


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
