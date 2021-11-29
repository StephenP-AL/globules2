local Powerup = require("Powerup");
local activationSound = audio.loadSound("double-damage-get.wav");

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

function DoubleDamage:spawn(grp)
    self.shape = display.newImage(filePath);
    self.outline = graphics.newOutline(2, filePath);
    physics.addBody(self.shape, "dynamic", {outline = self.outline});

    self:initShape(grp);
end

function DoubleDamage:activate(grp)
    audio.play(activationSound);
    return 2;
end

function DoubleDamage:destroy()
    if not self.shape then return end

    self.shape:removeSelf();
    self.shape = nil;
end

return DoubleDamage;