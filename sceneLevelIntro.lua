local composer = require( "composer" )
local scene = composer.newScene()
local widget = require("widget") 
local csv = require("csv")

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

	local boundTop = display.newRect(display.contentCenterX,-5,display.contentWidth,0)
	sceneGroup:insert(boundTop)
      	physics.addBody(boundTop,"static")

	local function closeListener(event)
		if (event.phase == "ended")then
			composer.hideOverlay()
		end
	end
	local background = display.newRoundedRect(display.contentCenterX,display.contentCenterY,display.contentWidth,display.contentHeight,4)
	background:setFillColor(.2,0.2,0.5,.85)
	sceneGroup:insert(background)
	
	introText = event.params.introText

	for index, line in pairs(event.params.introText) do
		text = display.newText(line,display.contentCenterX,display.contentHeight + index * 100,native.systemFont, 25)
		transition.to(text,{y = index * 45, time = 10000 + index * 500})
		sceneGroup:insert(text)
	end
	local closeButton= widget.newButton(
   	{
      		x = display.contentCenterX,
		y = display.contentHeight + #event.params.introText * 110,
      		id = "closeButton",
      		label = "Close",
      		labelColor = { default={ 1, 0.8, 0 }, over={ 0.2, 1, 1} },
      		onEvent = closeListener,
      		fontSize = 30, 
      		width = 150,
      		height = 85,
      		defaultFile= "LevelButtonGlobulesImage_adobespark (1).png"
   	}
	)
	transition.to(closeButton,{y = (#event.params.introText + 1) * 45, time = 13000 + (#event.params.introText + 2) * 500})
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
 	local parent = event.parent
   if ( phase == "will" ) then
      -- Called when the scene is on screen (but is about to go off screen).
      -- Insert code here to "pause" the scene.
      -- Example: stop timers, stop animation, stop audio, etc.
      	
      	parent:resumeGame()

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
