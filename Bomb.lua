local Powerup = require("Powerup");

local Bomb = Powerup:new(
    {
        tag = "bomb",
        activationAudio = nil,
        xPos = math.random(10, display.contentWidth-10),
        yPos = math.random(10, display.contentHeight-10),
        visibilityDuration = 5
    }
)

local filePath = "bomb.png";

function Bomb:spawn()
    self.shape = display.newImage(filePath);
    self.shape.xScale = 0.1;
    self.shape.yScale = 0.1;
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
