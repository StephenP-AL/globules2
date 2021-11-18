local Powerup = require("Powerup");

local Slasher = Powerup:new(
    {
        tag = "slasher",
        activationMsg = "Swipe to destroy!",
        activationAudio = nil,
        xPos = math.random(0, display.contentWidth),
        yPos = math.random(0, display.contentHeight),
        effectDuration = 2,
        visibilityDuration = 5
    }
)

local filePath = "slasher.png";

function Slasher:spawn()
    self.shape = display.newImage(filePath);
    self.shape.x = self.xPos;
    self.shape.y = self.yPos;
    self.outline = graphics.newOutline(2, filePath);
    self.shape.pp = self;
    self.shape.tag = self.tag;
    physics.addBody(self.shape, "dynamic", {outline = self.outline});
end

function Slasher:activate()

end

return Slasher;