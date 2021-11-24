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

function BigBomb:spawn()
    self.shape = display.newImage(filePath);
    self.shape.xScale = 0.3;
    self.shape.yScale = 0.3;
    self.shape.x = self.xPos;
    self.shape.y = self.yPos;
    self.outline = graphics.newOutline(2, filePath);
    self.shape.pp = self;
    self.shape.tag = self.tag;
    physics.addBody(self.shape, "dynamic", {outline = self.outline});
end

function BigBomb:activate()

end

return BigBomb;
