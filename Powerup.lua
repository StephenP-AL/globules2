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

function Powerup:spawn()
    self.shape = display.newCircle(self.xPos, self.yPos, 15);
    self.shape.pp = self;
    self.shape.tag = self.tag;
    self.shape:setFillColor(0,0,0);
    physics.addBody(self.shape, "dynamic");
end

function Powerup:activate()

end

function Powerup:destroy()

end

return Powerup;