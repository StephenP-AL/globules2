local Powerup = require("Powerup");

local DoubleDamage = Powerup:new(
    {
        tag = "doubleDamage",
        activationMsg = "Double Damage!",
        activationAudio = nil,
        xPos = math.random(0, display.contentWidth),
        yPos = math.random(0, display.contentHeight),
        effectDuration = 5,
        visibilityDuration = 5
    }
)


local filePath = "double-damage.png";

function DoubleDamage:spawn()
    self.shape = display.newImage(filePath);
    self.shape.x = self.xPos;
    self.shape.y = self.yPos;
    self.outline = graphics.newOutline(2, filePath);
    self.shape.pp = self;
    self.shape.tag = self.tag;
    physics.addBody(self.shape, "dynamic", {outline = self.outline});
end

function DoubleDamage:activate()
    return 2;
end


return DoubleDamage;