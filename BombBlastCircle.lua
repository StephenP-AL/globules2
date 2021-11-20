local Bomb = require("Bomb");

local BombBlastCircle = Bomb:new(
    {
        tag = "bombBlastCircle",
        activationMsg = "Kaboom!",
        visibilityDuration = 5
    }
)

function BombBlastCircle:spawn()
    self.shape = display.newCircle(self.xPos, self.yPos, display.contentWidth / 3);
    self.shape:setFillColor(1, 0.5, 0.6);
    self.shape.x = self.xPos;
    self.shape.y = self.yPos;
    self.shape.anchorX = 0.5;
    self.shape.anchorY = 0.5;
    self.shape.pp = self;
    self.shape.tag = self.tag;
    physics.addBody(self.shape, "dynamic");
end

function BombBlastCircle:activate()
    
end

return BombBlastCircle;
