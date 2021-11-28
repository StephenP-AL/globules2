local physics = require("physics");

local Powerup = {
    tag = "powerup",
    activationMsg = "",
    activationAudio = nil,
    spriteObj = nil,
    xPos = 0,
    yPos = 0,
    effectDuration = 0,
    visibilityDuration = 0
}

function Powerup:new (o)
    o = o or {};
    setmetatable(o, self);
    self.__index = self;
    return o;
end

function Powerup:spawn(grp)
    self.shape = display.newCircle(self.xPos, self.yPos, 15);
    self.shape:setFillColor(0,0,0);
    physics.addBody(self.shape, "dynamic");

    self:initShape(grp);

    return self.shape;
end

function Powerup:initShape(grp)
    if not self.shape then return end

    self.shape.pp = self;
    self.shape.tag = self.tag;
    self.shape.x = self.xPos;
    self.shape.y = self.yPos;
    self.shape.anchorX = 0.5;
    self.shape.anchorY = 0.5;

    if grp then grp:insert(self.shape) end
end

function Powerup:activate(grp)
    local activateTxt = display.newText(self.activationMsg, display.contentCenterX, display.contentCenterY, ComicSans, 24);
    grp:insert(activateTxt);

    timer.performWithDelay(2000, function () activateTxt:removeSelf() activateTxt = nil end)
end

function Powerup:destroy()
    if not self.shape then return end

    self.shape:removeSelf();
    self.shape = nil;
    self = nil;
end

return Powerup;