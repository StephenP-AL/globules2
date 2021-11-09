local composer = require( "composer" )
local scene = composer.newScene()
local background2 = display.newImageRect("backgroundSettings2.jpg", display.contentWidth*2.2 , display.contentHeight*2.2 )
local musicImage = "musicImage..png"
local musicOffImage= "musicoffImage2.png"
local backButtonImage = "backbuttonimage.png";
---------------------------------------------------------------------------------
-- All code outside of the listener functions will only be executed ONCE
-- unless "composer.removeScene()" is called.
---------------------------------------------------------------------------------
 
-- local forward references should go here
 
---------------------------------------------------------------------------------
 
-- "scene:create()"
function scene:create( event )

   local sceneGroup = self.view
   local function sliderListener( event )
      print( "Slider Volume at " .. event.value .. "%" )
  end
   
  local options = {
      frames = {
          { x=0, y=0, width=36, height=48 },
          { x=40, y=0, width=36, height =48 },
          { x=80, y=0, width=36, height=48 },
          { x=124, y=0, width=36, height = 48 },
          { x=168, y=0, width=64, height= 48 }
      },
      sheetContentWidth = 232,
      sheetContentHeight = 48
  }
  local widget = require("widget")
  local function onMusicPress (event)
    
   end

  
end
 
-- "scene:show()"
function scene:show( event )
 
   local sceneGroup = self.view
   local phase = event.phase
 
   if ( phase == "will" ) then
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