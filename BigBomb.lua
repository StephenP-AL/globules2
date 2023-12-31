local Bomb = require("Bomb");

local BigBomb = Bomb:new(
    {
        tag = "bigBomb",
        activationAudio = nil,
        xPos = math.random(30, display.contentWidth-30),
        yPos = math.random(30, display.contentHeight-30),
        visibilityDuration = 5
    }
)

local filePath = "bomb.png";

function BigBomb:spawn(grp)
    self.shape = display.newImage(filePath);
    self.shape.xScale = 0.5;
    self.shape.yScale = 0.5;
    self.outline = graphics.newOutline(2, filePath);
    physics.addBody(self.shape, "static", {outline = self.outline});

    self:initShape(grp);
end

return BigBomb;
