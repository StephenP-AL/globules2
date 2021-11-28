local BigBomb = require("BigBomb");

local BigBombBlastCircle = BigBomb:new(
    {
        tag = "bigBombBlastCircle",
        visibilityDuration = 5
    }
)

local function removeBombBlastImg(event)
    event.pp:destroy();
end

local filePath = "bomb-explosion.png";

function BigBombBlastCircle:spawn(grp)
    self.shape = display.newCircle(self.xPos, self.yPos, display.contentWidth / 3);
    self.shape.alpha = 0;
    
    self.blast = display.newImage(filePath);

    self.shape:setFillColor(1, 0.5, 0.6);
    physics.addBody(self.shape, "dynamic");

    self:initShape(grp);
end

function BigBombBlastCircle:initShape(grp)
    if not self.shape and self.blast then return end

    self.blastGroup = display.newGroup();

    self.shape.pp = self;
    self.shape.tag = self.tag;
    self.shape.x = self.xPos;
    self.shape.y = self.yPos;
    self.shape.anchorX = 0.5;
    self.shape.anchorY = 0.5;

    self.blast.x = self.xPos;
    self.blast.y = self.yPos;
    self.blast.xScale = 0.1;
    self.blast.yScale = 0.1;
    self.blast.anchorX = 0.5;
    self.blast.anchorY = 0.5;

    self.blastGroup = display.newGroup();
    self.blastGroup:insert(self.shape);
    self.blastGroup:insert(self.blast);

    if grp then 
        grp:insert(self.shape);
        grp:insert(self.blast);
    end
end

function BigBombBlastCircle:activate(grp)
    local activateTxt = display.newText(self.activationMsg, display.contentCenterX, display.contentCenterY, ComicSans, 24);
    grp:insert(activateTxt);

    if self and activateTxt then
        timer.performWithDelay(2000, function () activateTxt:removeSelf() activateTxt = nil end)
    end

    timer.performWithDelay(750, removeBombBlastImg);
end

function BigBombBlastCircle:destroy()
    self.shape:removeSelf();
    self.blast:removeSelf();
    self.shape = nil;
    self.blast = nil;
    self = nil;
end

return BigBombBlastCircle;
