local Powerup = require("Powerup");

local Bomb = Powerup:new(
    {
        tag = "bomb",
        activationAudio = nil,
        activationMsg = [[Bomb armed. Double-tap anywhere to detonate.]],
        xPos = math.random(10, display.contentWidth-10),
        yPos = math.random(10, display.contentHeight-10),
        visibilityDuration = 5
    }
)

local filePath = "bomb.png";
function Bomb:spawn(grp)
    self.shape = display.newImage(filePath);
    self.shape.xScale = 0.1;
    self.shape.yScale = 0.1;
    self.outline = graphics.newOutline(2, filePath);
    physics.addBody(self.shape, "static", {outline = self.outline});

    self:initShape(grp);
end

function Bomb:arm(grp)
    self:destroy();
end

function Bomb:destroy()
    if not self.shape then return end

    self.shape:removeSelf();
    self.shape = nil;
end

return Bomb;
