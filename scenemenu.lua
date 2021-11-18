local composer = require( "composer" )
local scene = composer.newScene()
local widget = require("widget")
local background = display.newImageRect("globulesBackgroundImage.jpg", display.contentWidth*2.2 , display.contentHeight*2.2 )
local levelbuttonImage = "LevelButtonGlobulesImage_adobespark (1).png"
local settingsCogWheelImage = "cogWheelImage2.png"
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
				spawnTimer = 80,
            levelParTimer = 120,
				spawnList = {
					"normal",
					"armored",
					"multi",
					"paramecium",
					"normal",
					"normal",
					"armored"
				},
				introText = {
					"Globule come from far away.",
					"He want be solute,",
					"but he much big.",
					"Tap globule to make smol.",
					"Tap smol to make solute."

				},

			}
			composer.gotoScene("scenePlayField",{params = params} )
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

local function winScreenListener(event)
   if (event.phase == "ended") then
      composer.gotoScene("sceneWinScreen");
   end
end

local startButton = widget.newButton(
	{
		x=display.contentCenterX,
		y=100,
		label="Start",
		width=180,
		height=30,
		shape="roundedRect",
		onEvent=startListener
	}
	)
local levelOneButton = widget.newButton(
   {
      x = display.contentCenterX,
      y = display.contentCenterY-150,
      id = "levelOneButton",
      label = "Level 1",
      labelColor = { default={ 1, 0.8, 0 }, over={ 0.2, 1, 1} },
      onEvent = startListener,
      fontSize = 30, 
      width = 150,
      height = 85,
      defaultFile= levelbuttonImage
   }
);
   
     local levelTwoButton = widget.newButton(
   {
      x = display.contentCenterX,
      y = display.contentCenterY-75,
      id = "levelTwoButton",
      label = "Level 2",
      labelColor = { default={ 0.2, 1, 0 }, over={ 0.2, 1, 1} },
      onEvent = startListener,
      fontSize = 30, 
      width = 150,
      height = 85,
      defaultFile= levelbuttonImage
   }
);
  
       local levelThreeButton = widget.newButton(
   {
      x = display.contentCenterX,
      y = display.contentCenterY,
      id = "levelThreeButton",
      label = "Level 3",
      labelColor = { default={ 0.2, 0.2, 1 }, over={ 0.2, 1, 1} },
      onEvent = startListener,
      fontSize = 30, 
      width = 150,
      height = 85,
      defaultFile= levelbuttonImage
   }
);

local testWinScreen = widget.newButton(
   {
      x = display.contentCenterX,
      y = display.contentCenterY + 50,
      id = "testWinScreenBtn",
      label = "Test Win Screen",
      onEvent = winScreenListener,
      defaultFile = levelbuttonImage,
      width = 150,
      height = 85
   }
);

 local settingsCogWheel = widget.newButton(
   {
      x = display.contentWidth-50,
      y = display.contentHeight,
      id = "settingsCogWheel",
      label = "",
      labelColor = { default={ 0.2, 0.2, 1 }, over={ 0.2, 1, 1} },
      onEvent = settingsListener,
      fontSize = 30, 
      width = 90,
      height = 90,
      defaultFile= settingsCogWheelImage
   }
);


sceneGroup:insert(background);
  sceneGroup:insert(levelTwoButton);
   sceneGroup:insert(levelOneButton);
sceneGroup:insert(levelThreeButton);
sceneGroup:insert(settingsCogWheel)
sceneGroup:insert(startButton)
sceneGroup:insert(testWinScreen);
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
