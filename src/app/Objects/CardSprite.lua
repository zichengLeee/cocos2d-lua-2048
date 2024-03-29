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
CardSprite.bg = nil
CardSprite.cX = 0
CardSprite.cY = 0

function CardSprite:ctor(num,w,h,cX,cY)
	-- 之前使用的是函数createCardSprite，但是会导致问题，第一次获取数字变成了创建精灵，结果导致各种问题。
	self.number = num
	self.cX = cX
	self.cY = cY
	
	self.bg = cc.LayerColor:create(cc.c4b(204,192,180,255),w - 15,h - 15)
	self.bg:setPosition(cX,cY)


	if num > 0 then
		-- numLabel = LabelUtils:createLabel(num,18)
		-- numLabel:setTextColor(cc.c4b(200, 190, 180 ,255))
		self.numLabel = cc.ui.UILabel.new({
	        text = num,
	        size = 80,
    	})
    	self.numLabel:setPosition(self.bg:getContentSize().width / 2 - 20, self.bg:getContentSize().height / 2)
	else
		-- numLabel = LabelUtils:createLabel("",18)
		-- numLabel:setTextColor(cc.c4b(200, 190, 180 ,255))
		self.numLabel = cc.ui.UILabel.new({
	        text = "",
	        size = 80,
    	})
    	self.numLabel:setPosition(self.bg:getContentSize().width / 2 - 20, self.bg:getContentSize().height / 2)
	end

	self.bg:addChild(self.numLabel)
	self:addChild(self.bg)
end


-- function CardSprite:createCardSprite(num,w,h,cX,cY)
-- 	local cardBox = CardSprite.new()


-- 	return cardBox
-- end

function CardSprite:setNumber(num)
	self.number = num

	if num >=0 then
		-- self.numLabel:setSystemFontSize(80)
		self.numLabel:setPosition(self.bg:getContentSize().width / 2 - 20, self.bg:getContentSize().height / 2)
	end

	if num >=16 then
		-- self.numLabel:setSystemFontSize(60)
		self.numLabel:setPosition(self.bg:getContentSize().width / 2 -45, self.bg:getContentSize().height / 2)
	end

	if num >=128 then
		-- self.numLabel:setSystemFontSize(40)
		self.numLabel:setPosition(self.bg:getContentSize().width / 2 -60, self.bg:getContentSize().height / 2)
	end

	if num >=1024 then
		-- self.numLabel:setSystemFontSize(20)
		self.numLabel:setPosition(self.bg:getContentSize().width / 2 -80, self.bg:getContentSize().height / 2)
	end

	if num == 0 then
		self.bg:setColor(cc.c3b(204, 192, 180))
	end
	if num == 2 then
		self.bg:setColor(cc.c3b(238, 228, 218))
		self.numLabel:setColor(cc.c4b(119,110,101))
	end
	if num == 4 then
		self.bg:setColor(cc.c3b(240, 220, 200))
		self.numLabel:setColor(cc.c4b(119,110,101))
	end
	if num == 8 then
		self.bg:setColor(cc.c3b(242, 177, 121))
		self.numLabel:setColor(cc.c4b(255,255,255))
	end
	if num == 16 then
		self.bg:setColor(cc.c3b(236, 141, 84))
		self.numLabel:setColor(cc.c4b(255,255,255))
	end
	if num == 32 then
		self.bg:setColor(cc.c3b(246, 124, 95))
		self.numLabel:setColor(cc.c4b(255,255,255))
	end
	if num == 64 then
		self.bg:setColor(cc.c3b(234, 89, 55))
		self.numLabel:setColor(cc.c4b(255,255,255))
	end
	if num == 128 then
		self.bg:setColor(cc.c3b(240, 90, 60))
		self.numLabel:setColor(cc.c4b(255,255,255))
	end
	if num == 256 then
		self.bg:setColor(cc.c3b(240, 200, 70))
		self.numLabel:setColor(cc.c4b(255,255,255))
	end
	if num == 512 then
		self.bg:setColor(cc.c3b(240, 200, 70))
		self.numLabel:setColor(cc.c4b(255,255,255))
	end
	if num == 1024 then
		self.bg:setColor(cc.c3b(0, 130, 0))
		self.numLabel:setColor(cc.c4b(255,255,255))
	end
	if num == 2048 then
		self.bg:setColor(cc.c3b(0, 130, 0))
		self.numLabel:setColor(cc.c4b(255,255,255))
	end


	if num > 0 then
		self.numLabel:setString(num)
	else
		self.numLabel:setString("")
	end
end

function CardSprite:getNumber()
	return self.number
end

function CardSprite:play()
	-- 机智，等数字出来，直接缩小，然后在播放放大动画。
	
	self.numLabel:runAction(cc.Sequence:create(cc.ScaleTo:create(0, 0.1, 0.1), cc.ScaleTo:create(0.5, 1, 1)))
end

return CardSprite