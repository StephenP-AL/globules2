local Bomb = require("Bomb");

local BombBlastCircle = Bomb:new(
    {
        tag = "bombBlastCircle",
        activationMsg = "Kaboom!",
        visibilityDuration = 5
    }
)

local filePath = "bomb-explosion.png";

function BombBlastCircle:spawn()
    self.blastGroup = display.newGroup();
    self.shape = display.newCircle(self.xPos, self.yPos, display.contentWidth / 3);
    self.shape.alpha = 0;
    
    self.blast = display.newImage(filePath);
    self.blast.xScale = 0.05;
    self.blast.yScale = 0.05;
    self.blast.x = self.xPos;
    self.blast.y = self.yPos;
    self.blastGroup:insert(self.shape);
    self.blastGroup:insert(self.blast);
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
