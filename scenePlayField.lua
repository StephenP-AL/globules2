local composer = require( "composer" )
local scene = composer.newScene()
local DoubleDamage = require("DoubleDamage");
local Slasher = require("Slasher");
local Bomb = require("Bomb");
local BombBlastCircle = require("BombBlastCircle");
local BigBomb = require("BigBomb");
local BigBombBlast = require("BigBombBlast");
local csv = require("csv")

local popSound = audio.loadSound("bubblePop.wav")
local hitSound = audio.loadSound("hit_m12.wav")
local ddOffSound = audio.loadSound("double-damage-expire.wav");

function catcherror(err)
	print("ERROR:",err)
end
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
      	
	--Play statistics
	saturationLimit = 500
	saturation = 0
	score = event.params.score
	levelScore = 0;
	pause = true
	hasLevelStarted = false;
	damageOutput = 1;
	dd = nil;
	bomb = nil;
	bombBlastRadius = nil;
	bigBomb = nil;
	bigBombBlast = nil;
	powerupTimer = nil;
	parTimer = nil;
	activateTxt = nil;
	activateTxtTimer = nil;


     	level = event.params.level
	print("level: "..level)
      	local lvlGlob = system.pathForFile("level/"..level.."/glob.csv")
	local fileGlob = csv.open(lvlGlob,{header = true})
	local spawnList = {}
	spawnCount = 0
	for record in fileGlob:lines()
		do
			table.insert(spawnList,record.type)
			spawnCount = spawnCount + 1
		end
		print("Spawn Count:",spawnCount)
	local lvlParams = system.pathForFile("level/"..level.."/params.csv")
	local fileParams = csv.open(lvlParams,{header = true})
	initSpawnTimer = 800
	finalLevel = 0
	parTime = 120;
	
	for record in fileParams:lines()
		do
			initSpawnTimer = record.spawnTimer
			finalLevel = record.final
			parTime = record.parTime
		end

      	local lvlIntro= system.pathForFile("level/"..level.."/intro.csv")
	local fileIntro= csv.open(lvlIntro,{header = true})
	local introList = {}
	for record in fileIntro:lines()
		do
			table.insert(introList,record.type)
		end	

	local lvlPowerups = system.pathForFile("level/"..level.."/powerups.csv");
	local filePowerup = csv.open(lvlPowerups, {header=true});
	local powerupList = {};
	for record in filePowerup:lines() do
		table.insert(powerupList, record.type);
	end

      	local pysics = require("physics")
	physics.start()
	physics.setGravity(0,0)

	--globule constants
	speedConstant = 10 -- Bases speed for globules TODO: Adjust based upon current difficulty
	speedScale = 16.5 --Adjusts the relative speed between globules of different sizes
	testSize = 80 -- default size of globule TODO: find a better way to do this
	--
	-- TODO replace these text displays with widgets
	--local saturationText = display.newText("Saturation: 0",0,-25)
	local scoreImage = "scoreImage-removebg-preview.png"
	--saturationText.anchorX = 0
	--sceneGroup:insert(saturationText)
	scoreImageRect = display.newImageRect(scoreImage, 50, 50 )
	scoreImageRect.x = 45;
	scoreImageRect.y = -20;
	scoreImageRect.anchorX = 1;
	scoreImageRect.xScale = 0.80;
	scoreImageRect.yScale = 0.80;
	sceneGroup:insert(scoreImageRect)

	local scoreText = display.newText(score,scoreImageRect.x + 7,-20, native.systemFont, 20)
	scoreText.anchorX = 0
	sceneGroup:insert(scoreText)

	updatedParTimer = tonumber(parTime);
	local parTimerText = display.newText("Time Bonus: "..updatedParTimer, display.contentWidth - 120, -25);
	parTimerText.anchorX = 0;
	sceneGroup:insert(parTimerText);
	local levelText = display.newText("Level: "..level, display.contentWidth - 120, -5);
	levelText.anchorX = 0;
	sceneGroup:insert(levelText);


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

	local widget = require( "widget" )
	local optionsProg = {
		width = 64,
		height = 64,
		numFrames = 6,
		sheetContentWidth = 384,
		sheetContentHeight = 64
	}

	local progressSheet = graphics.newImageSheet( "widget-progress-view.png", optionsProg )
	 
	-- Create the widget
	local progressView = widget.newProgressView(
		{
			sheet = progressSheet,
			fillOuterMiddleFrame = 4,
			fillInnerLeftFrame = 4,
			fillInnerMiddleFrame = 4,
			fillWidth = 0,
			fillHeight = 32,
			left = 100,
			top = -40,
			width = 220,
			height = 100,
			isAnimated = true
		}
	)
	sceneGroup:insert(progressView)
	--Globules
	globules = {} --table to reference all globules

	local function ddRemoveNoClick(event)
		if not dd then return end

		damageOutput = 1;
		dd:destroy();
		dd = nil;
	end
	
	local function bombRemoveNoClick(event)
		if not bomb or not bomb.shape then return end
		
		bomb:destroy();
		bomb = nil;
	end

	local function bigBombRemoveNoClick(event)
		if not bigBomb then return end

		bigBomb:destroy();
		bigBomb = nil;
	end

	local function ddRemove(event)
		if not dd then return end
		audio.play(ddOffSound);
		damageOutput = 1;
		dd = nil;
	end

	local function ddActivate(event)
		if powerupTimer then
			timer.cancel(powerupTimer);
		end

		activateTxt = display.newText(dd.activationMsg, display.contentCenterX, display.contentCenterY, ComicSans, 24);
		sceneGroup:insert(activateTxt);
	
		if activateTxt then
			activateTxtTimer = timer.performWithDelay(1000, function () activateTxt:removeSelf() activateTxt = nil end);
		end

		damageOutput = dd:activate(sceneGroup);
		dd:destroy();

		timer.performWithDelay(5000, ddRemove);

		return true;
	end

	local function bombDetonate(event)
		if (event.numTaps == 2) then
			Runtime:removeEventListener("tap", bombDetonate);

			if activateTxt then
				timer.cancel(activateTxtTimer);
				activateTxtTimer = nil;
				activateTxt:removeSelf();
				activateTxt = nil;
			end
			bomb = nil;
			bombBlastRadius = BombBlastCircle:new({xPos=event.x, yPos=event.y});
			bombBlastRadius:spawn(sceneGroup);
			bombBlastRadius:activate(sceneGroup);
			return true;
		end
	end

	local function bombActivate(event)
		if powerupTimer then
			timer.cancel(powerupTimer);
		end

		bomb:arm(sceneGroup);
		activateTxt = display.newText(bomb.activationMsg, display.contentCenterX, display.contentCenterY, ComicSans, 12);
		sceneGroup:insert(activateTxt);
	
		if activateTxt then
			activateTxtTimer = timer.performWithDelay(1500, function () activateTxt:removeSelf() activateTxt = nil end);
		end
		
		Runtime:addEventListener("tap", bombDetonate);

		return true;
	end

	local function bigBombActivate(event)
		if powerupTimer then
			timer.cancel(powerupTimer);
		end

		local xVal = bigBomb.shape.xPos;
		local yVal = bigBomb.shape.yPos;

		bigBomb:destroy();

		bigBombBlast = BigBombBlast:new({xPos=xVal, yPos=yVal});
		bigBombBlast:spawn(sceneGroup);
		bigBombBlast:activate(sceneGroup);

		return true;
	end

	local function spawnDoubleDamage()
		dd = DoubleDamage:new();
		dd:spawn(sceneGroup);
		dd.shape:addEventListener("touch", ddActivate);

		powerupTimer = timer.performWithDelay(5000, ddRemoveNoClick);
	end

	local function spawnBomb()
		bomb = Bomb:new();
		bomb:spawn(sceneGroup);
		bomb.shape:addEventListener("touch", bombActivate);

		powerupTimer = timer.performWithDelay(5000, bombRemoveNoClick);
	end

	local function spawnBigBomb()
		bigBomb = BigBomb:new();
		bigBomb:spawn(sceneGroup);
		bigBomb.shape:addEventListener("touch", bigBombActivate);

		powerupTimer = timer.performWithDelay(3000, bigBombRemoveNoClick);
	end

	local function determinePowerupSpawn()
		if (powerupList[1] == "bomb") then
			spawnBomb();
		else
			spawnDoubleDamage();
		end
		table.remove(powerupList, 1);
	end

	local function activatePowerups()

		if (updatedParTimer == math.floor(parTime / 4) * 3) then
			determinePowerupSpawn();
			return;
		end
		if (updatedParTimer == math.floor(parTime / 2)) then
			determinePowerupSpawn();
			return;
		end

		if (updatedParTimer == 10) then
			determinePowerupSpawn();
			return;
		end

		if (updatedParTimer == 1) then
			determinePowerupSpawn();
			return;
		end

		if (saturation >= saturationLimit - 75) then
			--determinePowerupSpawn();
			for i,powerup in pairs(powerupList) do
				if (powerup == "bigBomb") then
					spawnBigBomb();
					table.remove(powerupList, i);
				end
			end

			return;
		end
	end

	local function removeAllPowerupsFromDisplay()
		if bomb and bomb.shape then
			bomb:destroy();
			bomb = nil;
		end
		if dd and dd.shape then
			dd:destroy();
			dd = nil;
		end
		if bigBomb and bigBomb.shape then
			bigBomb:destroy();
			bigBomb = nil;
		end
		if bombBlastRadius and bombBlastRadius.shape then
			bombBlastRadius:destroy();
			bombBlastRadius = nil;
		end
		if bigBombBlast and bigBombBlast.shape then
			bigBombBlast:destroy();
			bigBombBlast = nil;
		end
		if activateTxt then
			timer.cancel(activateTxtTimer);
			activateTxtTimer = nil;
			activateTxt:removeSelf();
			activateTxt = nil;
		end
	end

	local function countDownTimer()
		if (updatedParTimer > 0) then
			updatedParTimer = updatedParTimer - 1;
		end

		parTimerText.text = "Time Bonus: "..updatedParTimer;

		if (#powerupList > 0) then
			activatePowerups();
		end
	end

	local function globCollision(event)
		if (event.phase == "began") then
			if bombBlastRadius then
				if (event.other == bombBlastRadius.shape) then
					if (event.target.hp > 0) then
						event.target.hp = event.target.hp - damageOutput;
					--TODO: need a visual and audio indicator of hit
					addScore(1)
					elseif (event.target.size < 21) then
					event.target.delete = true
						event.target:removeSelf()
					levelScore = levelScore + 4
					score = score + 4;
					scoreText.text = score
				end
			end
			if bigBombBlast then
				if (event.other == bigBombBlast.shape) then
					event.target.delete = true
					event.target:removeSelf();
					levelScore = levelScore + 4
					score = score + 4;
				scoreText.text = score
				end
			end
		end
		end
	end

	function scene:resumeGame()
		--print(spawnCount.." resume")
		pause = false
		physics.start()


	end
	function addScore(points)
		levelScore = levelScore + points;
		score = score + points;
		scoreText.text = score
	end
	function tapGlobule(event)
		if (event.target.hp == 2 or (event.target.hp == 1 and damageOutput == 1)) then
			event.target.hp = event.target.hp - damageOutput;
		--TODO: need a visual and audio indicator of hit
			audio.play(hitSound)
			addScore(1)
			event.target.glob.strokeWidth = event.target.hp * 5 + 2

		elseif (event.target.size < 21) then
			event.target.delete = true
		        event.target:removeSelf()
			audio.play(popSound)
			levelScore = levelScore + 4
			score = score + 4;
			scoreText.text = score
		else

			audio.play(popSound)
			if (event.target.type == "multi") then
				local angle = math.random() * 2 * math.pi
				for i = 0,2,1 do
					local x = math.cos(angle + i * 4 / 3 * math.pi) 
					local y = math.sin(angle + i * 4 / 3 * math.pi) 
					createGlobule(
						event.target.type,
						event.target.size / 2,
						x * event.target.size / 2 + event.target.x,
						y * event.target.size / 2 + event.target.y,
						x,
						y,
						event.target.red,
						event.target.green,
						event.target.blue
						)
				end
			else 
				local angle = math.random() * 2 * math.pi
				local x = math.cos(angle)
				local y = math.sin(angle)
				createGlobule(
					event.target.type,
					event.target.size / 2, 
					x * event.target.size / 2 + event.target.x, 
					y * event.target.size / 2 + event.target.y, 
					x, 
					y, 
					event.target.red, 
					event.target.green, 
					event.target.blue)
				createGlobule(
					event.target.type,
					event.target.size / 2, 
					-x * event.target.size / 2 + event.target.x, 
					-y * event.target.size / 2 + event.target.y, 
					-x, 
					-y, 
					event.target.red, 
					event.target.green, 
					event.target.blue)
					end event.target.delete = true event.target:removeSelf() levelScore = levelScore + 1 score = score + 1; scoreText.text = score end end

	-- Globule animation
	function squishX(obj)
		transition.to(obj,{transition = easing.inOutSine, xScale = .9, yScale = 1.1, time = 3500, onComplete = squishY})
	end

	function squishY(obj)
		transition.to(obj,{transition = easing.inOutSine, yScale = .9, xScale = 1.1, time = 3500, onComplete = squishX})
	end
	
	-- background 
	local bgRect = display.newRect(display.contentCenterX,display.contentCenterY,display.contentWidth,display.contentHeight + 90)
	bgRect:setFillColor(.5,.5,.6,.8)
	sceneGroup:insert(bgRect)
	bgRect:toBack()

	local bgItt = math.random(3) + 2
	for i = bgItt,1,-1
	do
		local bgglob = display.newCircle(math.random() * display.contentWidth, math.random() * display.contentHeight, math.random() * 40 + 90)
		bgglob:setFillColor(math.random(),math.random(),math.random(),.5)
		sceneGroup:insert(bgglob)
		bgglob:toBack()
		bgglob.rotate=math.random() * math.pi
		squishX(bgglob)
	end

        function createGlobule(type,size,startX,startY,deltaX,deltaY,red,green,blue)
		local group = display.newGroup() -- All globule elements contained in a group, then we only have to manipulate the group
		table.insert(globules,group)
		group.delete = false
		group.size = size --Represents the current globule size 
		group.type = type
		group.hp = 0
		if (type == "armored") then
			group.hp = 2
		end
		group.x = startX
		group.y = startY

		group.red = red
		group.green = green
		group.blue = blue

		local glob = display.newCircle(0,0,group.size)
		group:addEventListener("tap",tapGlobule)
		group:insert(glob)
		group.glob = glob
		sceneGroup:insert(group)
		if (type == "paramecium") then
			physics.addBody(group, 'dynamic', {bounce=1,radius=group.size,density=.1})
		else
			physics.addBody(group, 'dynamic', {bounce=1,radius=group.size,density=0})
		end
		local speedLog = math.log(group.size) / speedScale
		group:applyForce(deltaX * speedConstant * speedLog, deltaY * speedConstant * speedLog ) -- Ensure consistent speed among globules of the same size
--		group:applyTorque(1- math.random() / 100 )
		squishX(group)

		--color
		local cD = 0
		local cE = 0
		local cF = 0

		if red > 0.4 and red < 0.6
			then
				cD = math.abs(0.5 - red)
			else
				cD = 1 - red
			end
		if green > 0.4 and green < 0.6
			then
				cE = math.abs(0.5 - green)
			else
				cE = 1 - green
			end
		if blue > 0.4 and blue < 0.6
			then
				cF = math.abs(0.5 - blue)
			else
				cF = 1 - blue
		end


		glob:setFillColor(red,green,blue) 
		glob:setStrokeColor(cD,cE,cF)		

		if (type == "multi") then
			for i=0, 3 ,1 do
				globlette1 = display.newCircle(
					math.cos(math.pi * i * 4 / 3) * group.size / 2, 
					math.sin(math.pi * i * 4 / 3) * group.size / 2,
					group.size / 2)
				globlette1:setFillColor(red,green,blue)
				globlette1:setStrokeColor(cD,cE,cF)
				globlette1.strokeWidth = 2
				group:insert(globlette1)
			end
		end 
		--Paramecium
		if (type == "paramecium") then
			for i=0, 2 * math.pi,math.pi/12
				do
					local x = math.cos(i)
					local y = math.sin(i)
					line = display.newLine(x * group.size,y * group.size,x * (group.size + 6),y* (group.size +6))
					line:setStrokeColor(cD,cE,cF)
					group:insert(line)
					group.jump = math.random() * 200
				end
			end



		if (type == "armored") then
			glob.strokeWidth = 10
		else
			glob.strokeWidth = 2
		end

		if(hasLevelStarted == false) then
			parTimer = timer.performWithDelay(1000, countDownTimer, tonumber(parTime));
			hasLevelStarted = true;
		end

		group:addEventListener("collision", globCollision);
	end

	local function spawnGlobule(type)
		local angle = math.random() * 2 * math.pi-- random direction of movement
		local deltaX = math.cos(angle)
		local deltaY = math.sin(angle)
		local startX = math.random() * display.contentCenterX
		local startY = math.random() * display.contentCenterY
		local red = math.random()
		local green = math.random()
		local blue = math.random()
		createGlobule(type, testSize,startX,startY,deltaX,deltaY,red,green,blue)
   	end

	local function calculateScoreBonus(currentTimeBonus, totalParTime)

		if (currentTimeBonus >= (totalParTime / 1.5)) then
			return 10;
		else if (currentTimeBonus >= (totalParTime / 2)) then
			return 5;
		else if (currentTimeBonus >= (totalParTime / 4)) then
			return 3;
		else if (currentTimeBonus > 0) then
			return 2;
		else
			return 1;
		end
		end
		end
	end
	end

	local options = {
		isModal = true,
		effect = "fade",
		time = 1800,
		params = {
			introText = introList
			}
	}
	composer.showOverlay("sceneLevelIntro",options)


	spawnGlobule(spawnList[1]) 
	spawnIterator = 2
	spawnTimer = initSpawnTimer
	--print("level spawn timer: "..initSpawnTimer)
	local function update()

		if (pause == true)then
			physics.pause()
			return
		end
		local sat = 0
		for index, globule in pairs (globules) do
			if (globule.delete) then
				table.remove(globules,index)
			else
				if (globule.size == 80)then
					sat = sat + globule.size
				else if (globule.size == 40) then
					sat = sat + 26
				else if (globule.size == 20) then
					sat = sat + 8
				end
				end
				end
			end
			-- Random movement of paramecium
			if (globule.type == "paramecium") then
				globule.jump = globule.jump - 1
				if (globule.jump <= 0 and globule ~= nil) then
					local function jump()
						globule:applyForce((0.5 - math.random()) * globule.size , (.5 - math.random()) * globule.size   )
					end
					if (pcall(jump)) then
						--print("paramecium jump success")
					else
						print("paramecium jump fail",globule)
					end
					globule.jump = math.random() * 200
				end
			end
		end
		saturation = sat
		if (saturation > saturationLimit) then
			pause = true
			timer.cancel(parTimer);
			removeAllPowerupsFromDisplay();

			composer.showOverlay("sceneKillScreen",{
						effect = "fade",
						time = 1000,
						params = {finalScore = score}
					}
)
		end

		--[[ Incompatible with level changes
		if (saturation == 0 and hasLevelStarted == true) then
			pause = true;
			score = calculateScoreBonus(score, updatedParTimer, parTime);
			composer.gotoScene("sceneWinScreen");
		end
		]]
		
		--saturationText.text = "Saturation: "..saturation
		
		local progressSaturation = saturation/500
		progressView:setProgress(progressSaturation)
		--print(progressSaturation)
		if (spawnIterator <= spawnCount)then
			spawnTimer = spawnTimer - 1
--			print("1. Iterator "..spawnIterator.." Count "..spawnCount)

			if (spawnTimer == 0) then
--				print("1.1. Iterator "..spawnIterator.." Count "..spawnCount)
				--print("Spawning. Level timer: "..initSpawnTimer.." current timer "..spawnTimer)
				spawnGlobule(spawnList[spawnIterator]) 
				--print("Spawn "..spawnIterator)
				spawnIterator = spawnIterator + 1
				spawnTimer = initSpawnTimer
			end
		elseif spawnIterator > spawnCount then
			if (#globules == 0 and saturation == 0) then
				
				timer.cancel(parTimer);
				removeAllPowerupsFromDisplay();

				local bonusMultiplier = calculateScoreBonus(updatedParTimer, parTime);
				score = score - levelScore;
				levelScore = levelScore * bonusMultiplier;
				score = score + levelScore;

				print("final: "..finalLevel)
				if (finalLevel == "0") then
					local nextlvl = level + 1
					local pscore = score
					pause = true
					spawnIterator = 1
					params = {
						level = nextlvl,
						score = pscore
					}
					--print("play field before next level score: "..score)
					composer.gotoScene("sceneLevelTransition",{params = params} )
				elseif (finalLevel == "1") then
					pause = true;
					print("final level marker",finalLevel)
					composer.gotoScene("sceneWinScreen",{
						effect = "fade",
						time = 1000,
						params = {finalScore = score}
					}
					)
				end
			end
		end
		end

	timer.performWithDelay(16,update,0)

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
