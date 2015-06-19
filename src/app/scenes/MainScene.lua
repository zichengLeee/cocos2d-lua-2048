local CardSprite = require("app.Objects.CardSprite")
local size
local cardArr = {}

local MainScene = class("MainScene", function()
    return display.newScene("MainScene")
end)

function MainScene:ctor()
	math.randomseed(os.time())
	math.random()
    -- cc.ui.UILabel.new({
    --         UILabelType = 2, text = "Hello, World", size = 64})
    --     :align(display.CENTER, display.cx, display.cy)
    --     :addTo(self)

    self.visibleSize = cc.Director:getInstance():getVisibleSize()
    self.origin = cc.Director:getInstance():getVisibleOrigin()

    size = cc.Director:getInstance():getVisibleSize()
    self:createCardSrpite(size)

    self:autoCreateCardNumber()
    -- self:autoCreateCardNumber()
end

function MainScene:createCardSrpite(s)
	local SquareLong = (s.width - 28) / 4

	for i=0,3 do
		for j=0,3 do
			local cardSprite = CardSprite:createCardSprite(0,SquareLong,SquareLong,SquareLong * i +20, SquareLong*j + 10 + s.height / 6)
			self:addChild(cardSprite)

			if not cardArr[i] then
        		cardArr[i] = {}
    		end

			cardArr[i][j] = cardSprite
		end
	end
end

function MainScene:autoCreateCardNumber()
	local i = self:getRandom(3)
	local j = self:getRandom(3)
	print(i,j)
	local card = cardArr[i][j]

	if (card:getNumber() > 0) then
		self:autoCreateCardNumber()
	else
		card:setNumber(self:getRandom(9) < 1 and 4 or 2)
	end
end


function MainScene:getRandom(maxSize)
	print("执行了MainScene:getRandom")
    --随机1次并不能得到真正的随机数，因为第一次得到的随机数字都是一样的。所以我先随机了5次。
    --多次调用随机5次会导致Stack Overflow，我发现在ctor里先随机一次就OK了。
    local rnum = math.random(0,maxSize)
    -- for i=1,5 do
    -- 	rnum = math.random(0,maxSize)
    -- end
    return rnum
end

function MainScene:onEnter()
end

function MainScene:onExit()
end

return MainScene
