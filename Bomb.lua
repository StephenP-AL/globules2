local Powerup = require("Powerup");

local Bomb = Powerup:new(
    {
        tag = "bomb",
        activationAudio = nil,
        xPos = math.random(0, display.contentWidth),
        yPos = math.random(0, display.contentHeight),
        visibilityDuration = 5
    }
)

local filePath = "bomb.png";

function Bomb:spawn()
    self.shape = display.newImage(filePath);
    self.shape.xScale = 0.5;
    self.shape.yScale = 0.5;
    self.shape.x = self.xPos;
    self.shape.y = self.yPos;
    self.outline = graphics.newOutline(2, filePath);
    self.shape.pp = self;
    self.shape.tag = self.tag;
    physics.addBody(self.shape, "dynamic", {outline = self.outline});
end

function Bomb:activate()

end

return Bomb;