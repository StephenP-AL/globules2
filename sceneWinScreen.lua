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

   local globeOpt = 
   {
       frames = {
           { x = 0, y = 0, width = 400, height = 400 }, -- frame 1
           { x = 400, y = 0, width = 400, height = 400 }, -- frame 2
           { x = 800, y = 0, width = 400, height = 400 }, -- frame 3
           { x = 1200, y = 0, width = 400, height = 400 }, -- frame 4
           { x = 1600, y = 0, width = 400, height = 400 }, -- frame 5
           { x = 2000, y = 0, width = 400, height = 400 }, -- frame 6
           { x = 2400, y = 0, width = 400, height = 400 }, -- frame 7
           { x = 2800, y = 0, width = 400, height = 400 }, -- frame 8
           { x = 3200, y = 0, width = 400, height = 400 }, -- frame 9
           { x = 3600, y = 0, width = 400, height = 400 }, -- frame 10
           { x = 4000, y = 0, width = 400, height = 400 }, -- frame 11
           { x = 4400, y = 0, width = 400, height = 400 }, -- frame 12
           { x = 4800, y = 0, width = 400, height = 400 }, -- frame 13
           { x = 5200, y = 0, width = 400, height = 400 }, -- frame 14
           { x = 5600, y = 0, width = 400, height = 400 }, -- frame 15
           { x = 6000, y = 0, width = 400, height = 400 }, -- frame 16
           { x = 6400, y = 0, width = 400, height = 400 }, -- frame 17
           { x = 6800, y = 0, width = 400, height = 400 }, -- frame 18
           { x = 7200, y = 0, width = 400, height = 400 }, -- frame 19
           { x = 7600, y = 0, width = 400, height = 400 }, -- frame 20
           { x = 8000, y = 0, width = 400, height = 400 }, -- frame 21
           { x = 8400, y = 0, width = 400, height = 400 }, -- frame 22
           { x = 8800, y = 0, width = 400, height = 400 }, -- frame 23
           { x = 9200, y = 0, width = 400, height = 400 }, -- frame 24
           { x = 9600, y = 0, width = 400, height = 400 }, -- frame 25
           { x = 10000, y = 0, width = 400, height = 400 }, -- frame 26
           { x = 10400, y = 0, width = 400, height = 400 }, -- frame 27
           { x = 10800, y = 0, width = 400, height = 400 }, -- frame 28
           { x = 11200, y = 0, width = 400, height = 400 }, -- frame 29
           { x = 11600, y = 0, width = 400, height = 400 }, -- frame 30
           { x = 12000, y = 0, width = 400, height = 400 }, -- frame 31
           { x = 12400, y = 0, width = 400, height = 400 }, -- frame 32
           { x = 12800, y = 0, width = 400, height = 400 }, -- frame 33
           { x = 13200, y = 0, width = 400, height = 400 }, -- frame 34
           { x = 13600, y = 0, width = 400, height = 400 }, -- frame 35
           { x = 14000, y = 0, width = 400, height = 400 } -- frame 36
       }
   }

   local globeSheet = graphics.newImageSheet("globe-spritesheet.png", globeOpt);

   local globeSeqData = {
       { name = "globeSpin", start = 1, count = 36, time = 7500 }
   }

   local globeAnim = display.newSprite(globeSheet, globeSeqData);
   sceneGroup:insert(globeAnim);

   globeAnim.anchorX = 0.5;
   globeAnim.anchorY = 0.5;
   globeAnim.x = display.contentCenterX;
   globeAnim.y = display.contentCenterY;
   globeAnim:setSequence("globeSpin");
   globeAnim:play();
-- animation
 	function squishX(obj)
		transition.to(obj,{transition = easing.inOutSine, xScale = .95, yScale = 1.05, time = 3500, onComplete = squishY, rotation = 10})
	end

	function squishY(obj)
		transition.to(obj,{transition = easing.inOutSine, yScale = .95, xScale = 1.05, time = 3500, onComplete = squishX, rotation = 10})
	end
	function restore(obj)
		transition.to(obj,{transition = easing.inOutSine,xScale = 1, yScale = 1, time = 20000,onComplete = squishX})
	end
	function closeListener(event)
		if (event.phase == "ended")then
			composer.gotoScene("scenemenu")
		end
	end

   local solute = display.newCircle(display.contentCenterX,display.contentCenterY,display.contentWidth / 2)
   sceneGroup:insert(solute)
   transition.to(solute,{transition = easing.inOutSine, xScale = .01, yScale = .01, time = 1,onComplete = restore})
   solute:setFillColor(.4,.4,.4,.4)

   local message= {
	   "Globule is become solute.",
	   "Solute is much big.",
	   "Solute is become all.",
	   "You is helper; you is solute"
   }
	for index, line in pairs(message) do
		text = display.newText(line,display.contentCenterX,display.contentHeight + index * 100,native.systemFont, 25)
		transition.to(text,{y = index * 45, time = 10000 + index * 500})
		sceneGroup:insert(text)
	end
	local closeButton= widget.newButton(
   	{
      		x = display.contentCenterX,
		y = display.contentHeight + #message * 110,
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
	transition.to(closeButton,{y = (#message + 1) * 45, time = 13000 + (#message + 2) * 500})
	sceneGroup:insert(closeButton)



   -- Initialize the scene here.
   -- Example: add display objects to "sceneGroup", add touch listeners, etc.
end
 
-- "scene:show()"
function scene:show( event )
 
   local sceneGroup = self.view
   local phase = event.phase
 
   if ( phase == "will" ) then
	   composer.removeScene("scenePlayField")
      -- Called when the scene is still off screen (but is about to come on screen).
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
