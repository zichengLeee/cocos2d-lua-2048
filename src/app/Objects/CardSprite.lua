--
-- Author: sheepkx@qq.com
-- Date: 2015-06-19 01:08:19
-- 求一个Cocos2d-Lua的兼职开发或者外包游戏的开发工作，有意者可直接联系我的邮箱，tks.
--
--卡片
local CardSprite = class("CardSprite",function()
	return display.newNode()
end)
-- number如果不加self的话会导致自动取数组里的最大值。下面的numLabel必须带self.
-- 两种选择，要么在ctor里写self.number，要么在上面写CardSprite.number。
CardSprite.number = 0
CardSprite.numLabel = nil

function CardSprite:ctor()
	-- self.number = 0
end


function CardSprite:createCardSprite(num,w,h,cX,cY)
	local cardBox = CardSprite.new()
	self.number = num
	
	local bg = cc.LayerColor:create(cc.c4b(200,190,180,255),w - 15,h - 15)
	bg:setPosition(cX,cY)


	if num > 0 then
		-- numLabel = LabelUtils:createLabel(num,18)
		-- numLabel:setTextColor(cc.c4b(200, 190, 180 ,255))
		self.numLabel = cc.ui.UILabel.new({
	        text = num,
	        size = 100,
    	})
    	self.numLabel:setPosition(bg:getContentSize().width / 2 - 15, bg:getContentSize().height / 2)

	else
		-- numLabel = LabelUtils:createLabel("",18)
		-- numLabel:setTextColor(cc.c4b(200, 190, 180 ,255))
		self.numLabel = cc.ui.UILabel.new({
	        text = "",
	        size = 80,
    	})
    	self.numLabel:setPosition(bg:getContentSize().width / 2 - 15, bg:getContentSize().height / 2)

	end

	bg:addChild(self.numLabel)
	cardBox:addChild(bg)

	return cardBox
end

function CardSprite:setNumber(num)
	self.number = num
	if num > 0 then
		self.numLabel:setString(num)
	else
		self.numLabel:setString("")
	end
end

function CardSprite:getNumber()
	return self.number
end

return CardSprite