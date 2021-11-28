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
    physics.addBody(self.shape, "dynamic", {outline = self.outline});

    self:initShape(grp);
end

function Bomb:arm(grp)
    self.activateTxt = display.newText(self.activationMsg, display.contentCenterX, display.contentCenterY, ComicSans, 12);
    grp:insert(self.activateTxt);

    if self.activateTxt then
        self.timer = timer.performWithDelay(2000, function () if self.activateTxt then self.activateTxt:removeSelf() self.activateTxt = nil end end)
    end

    self:destroy();
end

function Bomb:destroy()
    if not self.shape then return end

    self.shape:removeSelf();
    self.shape = nil;
end

return Bomb;
