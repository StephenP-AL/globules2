local composer = require( "composer" )
local scene = composer.newScene()
local levelbuttonImage = "LevelButtonGlobulesImage_adobespark (1).png"

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


	   local loadlvl = 1 --Variable for selecting the level
local background = display.newImageRect("globulesBackgroundImage.jpg", display.contentWidth*2.2 , display.contentHeight*2.2 )
sceneGroup:insert(background);

local function ch1 (event)
	if (event.phase =="ended")
		then
			local params = {
            			levelParTimer = 120,
				level =1, 
				score = 0
			}
			composer.gotoScene("sceneLevelTransition",{params = params} )
		end
	end

	local function ch2 (event)
	if (event.phase =="ended")
		then
			local params = {
            			levelParTimer = 120,
				level =4 ,
				score = 0
			}
			composer.gotoScene("sceneLevelTransition",{params = params} )
		end
	end
local function ch3 (event)
	if (event.phase =="ended")
		then
			local params = {
            			levelParTimer = 120,
				level =7,
				score = 0
			}
			composer.gotoScene("sceneLevelTransition",{params = params} )
		end
	end
local function ch4 (event)
	if (event.phase =="ended")
		then
			local params = {
            			levelParTimer = 120,
				level =10,
				score = 0
			}
			composer.gotoScene("sceneLevelTransition",{params = params} )
		end
	end
local function win(event)
	if (event.phase == "ended")
		then
--			composer.gotoScene("sceneWinScreen")
			composer.gotoScene("sceneWinScreen",{
						effect = "fade",
						time = 1000,
						params = {finalScore = 1000000}
					}
					)

		end
	end
local chButton1 = widget.newButton(
   {
      x = display.contentCenterX,
      y = display.contentCenterY-250,
      id = "ch1",
      label = "Chapter 1",
      labelColor = { default={ 1, 0.8, 0 }, over={ 0.2, 1, 1} },
      onEvent = ch1,
      fontSize = 30, 
      width = 150,
      height = 85,
      defaultFile= levelbuttonImage
   }
);
local chButton2 = widget.newButton(
   {
      x = display.contentCenterX,
      y = display.contentCenterY-150,
      id = "ch2",
      label = "Chapter 2",
      labelColor = { default={ 1, 0.8, 0 }, over={ 0.2, 1, 1} },
      onEvent = ch2,
      fontSize = 30, 
      width = 150,
      height = 85,
      defaultFile= levelbuttonImage
   }
);
local chButton3 = widget.newButton(
   {
      x = display.contentCenterX,
      y = display.contentCenterY-50,
      id = "ch3",
      label = "Chapter 3",
      labelColor = { default={ 1, 0.8, 0 }, over={ 0.2, 1, 1} },
      onEvent = ch3,
      fontSize = 30, 
      width = 150,
      height = 85,
      defaultFile= levelbuttonImage
   }
);
local chButton4 = widget.newButton(
   {
      x = display.contentCenterX,
      y = display.contentCenterY+50,
      id = "ch4",
      label = "Chapter 4",
      labelColor = { default={ 1, 0.8, 0 }, over={ 0.2, 1, 1} },
      onEvent = ch4,
      fontSize = 30, 
      width = 150,
      height = 85,
      defaultFile= levelbuttonImage
   }
);
local winButton = widget.newButton(
   {
      x = display.contentCenterX,
      y = display.contentCenterY+150,
      id = "win",
      label = "Ending",
      labelColor = { default={ 1, 0.8, 0 }, over={ 0.2, 1, 1} },
      onEvent = win,
      fontSize = 30, 
      width = 150,
      height = 85,
      defaultFile= levelbuttonImage
   }
);
sceneGroup:insert(chButton1)
sceneGroup:insert(chButton2)
sceneGroup:insert(chButton3)
sceneGroup:insert(chButton4)
sceneGroup:insert(winButton)

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
