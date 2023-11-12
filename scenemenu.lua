local composer = require( "composer" )
local scene = composer.newScene()
local widget = require("widget")
local background = display.newImage("globulesBackgroundImage.jpg", display.contentWidth/1.3, display.contentHeight /2 )
local levelbuttonImage = "LevelButtonGlobulesImage_adobespark (1).png"
local settingsCogWheelImage = "cogWheelImage2.png"
if (composer.getVariable("setVolume") == nil)then
	composer.setVariable("setVolume",100)
end
if (composer.getVariable("mute") == nil) then
	composer.setVariable("mute", false)
end
local music= audio.loadStream("backgroundMusic.mp3",{loops = -1})
local playMusic=audio.play(music,{chanel=1,loops=-1})

composer.removeScene("sceneWinScreen")
math.randomseed(os.time());


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


local function startListener(event)
	if (event.phase =="ended")
		then
			local params = {
            			levelParTimer = 120,
				level = 1,
				score = 0,

			}
			composer.gotoScene("sceneLevelTransition",{params = params} )
		end
	end
local function chListener(event)
	if (event.phase == "ended")
		then
			composer.gotoScene("sceneChapters")
		end
	end
local function settingsListener(event)
   if (event.phase =="ended")
      then
         local params = {
            spawnTimer = 8800
         }
         composer.gotoScene("sceneSettings",{params = params} )
      end
   end

local startButton = widget.newButton(
   {
      x = display.contentCenterX,
      y = display.contentCenterY-150,
      id = "startButton",
      label = "Start",
      labelColor = { default={ 1, 0.8, 0 }, over={ 0.2, 1, 1} },
      onEvent = startListener,
      fontSize = 30, 
      width = 150,
      height = 85,
      defaultFile= levelbuttonImage
   }
);
 
--[[   local levelButton = widget.newButton(
   {
      x = display.contentCenterX,
      y = display.contentCenterY,
      id = "level",
      label = "Chapters",
      labelColor = { default={ 0.2, 0.2, 1 }, over={ 0.2, 1, 1} },
      onEvent = chListener,
      fontSize = 30, 
      width = 150,
      height = 85,
      defaultFile= levelbuttonImage
   }
);
]]


 local settingsCogWheel = widget.newButton(
   {
      
      x = display.contentCenterX,
      y = display.contentCenterY+75+75,
      id = "Setting",
      label = "Settings",
      labelColor = { default={ 0.2, 1, 0 }, over={ 0.2, 1, 1} },
      onEvent = settingsListener,
      fontSize = 30, 
      width = 170,
      height = 85,
      defaultFile = levelbuttonImage,
   }
);

if (composer.getVariable("mute") == false) then
	audio.setVolume(composer.getVariable("setVolume"),{channel=1})
end

-- sceneGroup:insert(playMusic);
sceneGroup:insert(background);
--sceneGroup:insert(introButton);
sceneGroup:insert(startButton);
--sceneGroup:insert(levelButton);
sceneGroup:insert(settingsCogWheel);
--sceneGroup:insert(testWinScreen);

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
