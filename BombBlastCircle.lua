local Bomb = require("Bomb");

local BombBlastCircle = Bomb:new(
    {
        tag = "bombBlastCircle",
        visibilityDuration = 5
    }
)

local function removeBombBlastImg(event)
    local params = event.source.params;
    local obj = params.Self;
    obj:destroy();
end

local filePath = "bomb-explosion.png";
function BombBlastCircle:spawn(grp)
    self.shape = display.newCircle(self.xPos, self.yPos, display.contentWidth / 3);
    self.shape.alpha = 0;
    
    self.blast = display.newImage(filePath);

    self.shape:setFillColor(1, 0.5, 0.6);
    physics.addBody(self.shape, "dynamic");

    self:initShape(grp);
end

function BombBlastCircle:initShape(grp)
    if not self.shape and self.blast then return end

    self.blastGroup = display.newGroup();
    self.blastGroup:insert(self.shape);
    self.blastGroup:insert(self.blast);
    self.blastGroup.x = self.xPos;
    self.blastGroup.y = self.yPos;
    self.blastGroup.anchorX = 0.5;
    self.blastGroup.anchorY = 0.5;
    
    self.shape.pp = self;
    self.shape.tag = self.tag;
    self.shape.x = self.xPos;
    self.shape.y = self.yPos;
    self.shape.anchorX = 0.5;
    self.shape.anchorY = 0.5;

    self.blast.x = self.xPos;
    self.blast.y = self.yPos;
    self.blast.xScale = 0.05;
    self.blast.yScale = 0.05;
    self.blast.anchorX = 0.5;
    self.blast.anchorY = 0.5;


    if grp then 
        grp:insert(self.shape);
        grp:insert(self.blast);
    end
end

function BombBlastCircle:activate(grp)

    local removalTimer = timer.performWithDelay(750, removeBombBlastImg);
    removalTimer.params = { Self = self };
end

function BombBlastCircle:destroy()
    if not self.shape or not self.blast then return end
    self.shape:removeSelf();
    self.blast:removeSelf();

    self.shape = nil;
    self.blast = nil;
    self = nil;
end

return BombBlastCircle;
