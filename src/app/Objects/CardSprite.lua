--
-- Author: sheepkx
-- Date: 2015-06-19 01:08:19
--
--卡片
local number
local bg
local numLabel = nil


local CardSprite = class("CardSprite",function()
    return cc.Sprite:create()
end)

function CardSprite:ctor()
	-- body
end


function CardSprite:createCardSprite(num,w,h,cX,cY)
	local cardBox = CardSprite.new()
	number = num
	
	bg = cc.LayerColor:create(cc.c4b(200,190,180,255),w - 15,h - 15)
	bg:setPosition(cX,cY)


	if num > 0 then
		-- numLabel = LabelUtils:createLabel(num,18)
		-- numLabel:setTextColor(cc.c4b(200, 190, 180 ,255))
		numLabel = cc.ui.UILabel.new({
	        text = num,
	        size = 100,
    	})
    	numLabel:setPosition(bg:getContentSize().width / 2 - 15, bg:getContentSize().height / 2)

	else
		-- numLabel = LabelUtils:createLabel("",18)
		-- numLabel:setTextColor(cc.c4b(200, 190, 180 ,255))
		numLabel = cc.ui.UILabel.new({
	        text = "",
	        size = 80,
    	})
    	numLabel:setPosition(bg:getContentSize().width / 2 - 15, bg:getContentSize().height / 2)

	end

	bg:addChild(numLabel)
	cardBox:addChild(bg)

	return cardBox
end

function CardSprite:setNumber(num)
	number = num

	if num > 0 then
		numLabel:setString(num)
	else
		numLabel:setString()
	end
end

function CardSprite:getNumber()
	return number
end

return CardSprite