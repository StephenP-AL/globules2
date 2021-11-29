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

function DoubleDamage:spawn(grp)
    self.shape = display.newImage(filePath);
    self.outline = graphics.newOutline(2, filePath);
    physics.addBody(self.shape, "dynamic", {outline = self.outline});

    self:initShape(grp);
end

function DoubleDamage:activate(grp)
    self.activateTxt = display.newText(self.activationMsg, display.contentCenterX, display.contentCenterY, ComicSans, 12);
    grp:insert(self.activateTxt);

    if self.activateTxt then
        self.timer = timer.performWithDelay(1000, function () if self.activateTxt then self.activateTxt:removeSelf() self.activateTxt = nil end end)
    end

    return 2;
end

function DoubleDamage:destroy()
    if not self.shape then return end

    self.shape:removeSelf();
    self.shape = nil;
end

return DoubleDamage;