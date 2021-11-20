local composer = require( "composer" )
local scene = composer.newScene()
local background = display.newImageRect("settingBackground.jpg", 1000, 1000 )
local musicImage = "musicImage..png"
local musicOffImage= "musicoffImage2.png"
local backButtonImage = "backbuttonimage.png";
local widget = require("widget")
local levelbuttonImage = "LevelButtonGlobulesImage_adobespark (1).png"
---------------------------------------------------------------------------------
-- All code outside of the listener functions will only be executed ONCE
-- unless "composer.removeScene()" is called.
---------------------------------------------------------------------------------
 
-- local forward references should go here
 
---------------------------------------------------------------------------------
 
-- "scene:create()"
function scene:create( event )
   
   local sceneGroup = self.view
   
  
end
 
-- "scene:show()"
function scene:show( event )
 
   local sceneGroup = self.view
   local phase = event.phase
   local function backListener(event)
     
            composer.gotoScene("scenemenu" )
  
      end

      function map (value, istart, istop, ostart, ostop) 
         return ostart + (ostop - ostart) * ((value - istart) / (istop - istart));
       end
      local function sliderListener( event )
         print( "Slider Volume at " .. event.value .. "%" )
         local value=map(event.value,0,100,0,1)
         composer.setVariable("setVolume",value)
      end
      local function onSwitchPress( event )
         composer.setVariable("setVolume",0)
      end
      
     
     local widget = require("widget")
     local function onMusicPress (event)
       
      end
      local settingTop= display.newRoundedRect(display.contentCenterX,10,150,50,20)
      settingTop:setFillColor(0.2, 1, 1)
      local settingText=display.newText("Setting",display.contentCenterX,10,native.systemFont, 30)
      settingText:setFillColor(1,0.5,0.5)
      settingTop.strokeWidth = 4;
      settingTop:setStrokeColor(1,0.5,0.4);

      local musicBox= display.newRoundedRect(display.contentCenterX-90,160,90,30,20)
      musicBox:setFillColor( 1, 0.8, 0.1 )
      local musicText=display.newText("Volume",display.contentCenterX-90,160,native.systemFont, 20)
      musicText:setFillColor(1,0.5,0.5)
  
      local musicBox1= display.newRoundedRect(display.contentCenterX-90,210,120,30,20)
      musicBox1:setFillColor( 1, 0.8, 0.1 )
      local musicText1=display.newText("Music Off",display.contentCenterX-90,210,native.systemFont, 20)
      musicText1:setFillColor(1,0.5,0.5)

      local slider1= widget.newSlider(
          {
             x = display.contentCenterX+75,
             y = 160,
             width = 130,
             value=0,
             listener = sliderListener
          })

          local onOffSwitch = widget.newSwitch(
            {
                left = 250,
                top = 200,
                style = "onOff",
                id = "onOffSwitch",
                onPress = onSwitchPress
            }
        )
         
        
        local backButton = widget.newButton(
         {
            x = display.contentCenterX,
            y = 470,
            id = "startButton",
            label = "Close",
            labelColor = { default={ 1, 0.8, 0 }, over={ 0.2, 1, 1} },
            onEvent = backListener,
            fontSize = 30, 
            width = 150,
            height = 85,
            defaultFile= levelbuttonImage
         }
      );
      
      sceneGroup:insert(background)
      sceneGroup:insert(backButton)
      sceneGroup:insert(settingTop)
      sceneGroup:insert(settingText)
      sceneGroup:insert(musicBox)
      sceneGroup:insert(musicText)
      sceneGroup:insert(slider1)
      sceneGroup:insert(onOffSwitch)
      sceneGroup:insert(musicBox1)
      sceneGroup:insert(musicText1)

      
   if ( phase == "will" ) then
      

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
