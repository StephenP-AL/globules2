local composer = require( "composer" )
local scene = composer.newScene()
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
   local message = {
	   "Globule is much many.",
	   "Fast not enuff.",
	   "Plees again.",
	   "Final Score: "..event.params.finalScore
   }

 
   if ( phase == "will" ) then
      -- Called when the scene is still off screen (but is about to come on screen).
      	local background = display.newRoundedRect(display.contentCenterX,display.contentCenterY,display.contentWidth,display.contentHeight+100,4)
	sceneGroup:insert(background)
	background:setFillColor(.4,.1,.4,.85)
	local function closeListener(event)
		if (event.phase == "ended")then
	--		composer.hideOverlay()
			composer.gotoScene("scenemenu")
		end
	end
      	for index, line in pairs(message) do
		text = display.newText(line, display.contentCenterX, display.contentHeight + index * 100, native.systemFont,25)
		sceneGroup:insert(text)
		transition.to(text,{y = index * 45, time = 10000 + index * 500})
	end
	local closeButton= widget.newButton(
             {
             x = display.contentCenterX,
             y = display.contentHeight + #message * 110,
             id = "closeButton",
                      label = "OK",
                      labelColor = { default={ 1, 0.8, 0 }, over={ 0.2, 1, 1} },
                      onEvent = closeListener,
                      fontSize = 30,
                      width = 150,
                      height = 85,
                      defaultFile= "LevelButtonGlobulesImage_adobespark (1).png"
              })
	       transition.to(closeButton,{y = (#message + 1) * 45, time = 13000 + (#message + 2) * 500})
	       sceneGroup:insert(closeButton)
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
