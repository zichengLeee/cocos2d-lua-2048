--
-- Author: sheepkx@qq.com
-- Date: 2015-06-19 01:08:19
-- 求一个Cocos2d-Lua的兼职开发或者外包游戏的开发工作，有意者可直接联系我的邮箱，tks.
--
-- 1,4	2,4	3,4	4,4
-- 1,3	2,3	3,3	4,3
-- 1,2	2,2	3,2	4,2
-- 1,1	2,1	3,1	4,1

local size
local cardArr = {}
local touchStart = {0, 0}

local MainScene = class("MainScene", function()
    return display.newScene("MainScene")
end)

local CardSprite = import("..Objects.CardSprite")

function MainScene:ctor()
	math.randomseed(os.time())
	math.random()

    -- cc.ui.UILabel.new({
    --         UILabelType = 2, text = "Hello, World", size = 64})
    --     :align(display.CENTER, display.cx, display.cy)
    --     :addTo(self)

    -- self.visibleSize = cc.Director:getInstance():getVisibleSize()
    -- self.origin = cc.Director:getInstance():getVisibleOrigin()

    -- 创建一个图片显示对象
	local sprite = display.newSprite("Item_pause.png", display.cx,display.top - 50, params):addTo(self)

	-- 启用触摸
	sprite:setTouchMode(cc.TOUCH_MODE_ONE_BY_ONE)
	sprite:setTouchEnabled(true)
	-- 设置处理函数
	sprite:addNodeEventListener(cc.NODE_TOUCH_EVENT,function(event)
		if event.name ~= "moved" then
            print(event.name)
        end

	    if event.name == "began" then
	    	print(event.x, event.y, event.prevX, event.prevY)
	    	return true
	    end
	end)

    self.size = cc.Director:getInstance():getVisibleSize()
    self:createCardSrpite(self.size)

    self:autoCreateCardNumber()
    self:autoCreateCardNumber()
end

function MainScene:createCardSrpite(s)
	local SquareLong = (s.width - 28) / 4

	for i=1,4 do
		cardArr[i] = {}
		for j=1,4 do
			local cardSprite = CardSprite.new(0,SquareLong,SquareLong,SquareLong * (i-1) +20, SquareLong*(j-1) + 10 + s.height / 6)
			self:addChild(cardSprite)

			cardArr[i][j] = cardSprite
		end
	end
end

function MainScene:autoCreateCardNumber()
	local i = self:getRandom(4)
	local j = self:getRandom(4)
	-- print(i,j)
	local card = cardArr[i][j]

	if (card:getNumber() > 0) then
		self:autoCreateCardNumber()
	else
		card:setNumber(self:getRandom(9) < 1 and 4 or 2)
		card:play()
	end
	print(cardArr[1][4]:getNumber(),cardArr[2][4]:getNumber(),cardArr[3][4]:getNumber(),cardArr[4][4]:getNumber())
	print(cardArr[1][3]:getNumber(),cardArr[2][3]:getNumber(),cardArr[3][3]:getNumber(),cardArr[4][3]:getNumber())
	print(cardArr[1][4]:getNumber(),cardArr[2][2]:getNumber(),cardArr[3][2]:getNumber(),cardArr[4][2]:getNumber())
	print(cardArr[1][1]:getNumber(),cardArr[2][1]:getNumber(),cardArr[3][1]:getNumber(),cardArr[4][1]:getNumber())
end


function MainScene:getRandom(maxSize)
	-- print("执行了MainScene:getRandom")
    --随机1次并不能得到真正的随机数，因为第一次得到的随机数字都是一样的。所以我先随机了5次。
    --多次调用随机5次会导致Stack Overflow，我发现在ctor里先随机一次就OK了。
    local rnum = math.random(1,maxSize)
    -- for i=1,5 do
    -- 	rnum = math.random(0,maxSize)
    -- end
    return rnum
end

function MainScene:onTouch(event, x, y)
	if event == 'began' then
		touchStart = {x, y}
	elseif event == 'ended' then
		local tx, ty = x - touchStart[1], y - touchStart[2]
		if (tx > 50) then
			self:doRight()
		elseif (tx < - 50) then
			self:doLeft()
		elseif (ty > 50) then
			self:doUp()
		elseif (ty < - 50) then
			self:doDown()
		end
	end
	return true
end

function MainScene:doRight()
	print("doRight")
	local card
	local cardLast

	for x=4,1,-1 do
		for y=1,4 do
			-- print("现在的位置",x,y,cardArr[x][y]:getNumber())
			for x1=x - 1,1,-1 do
				card = cardArr[x][y]
				cardLast = cardArr[x1][y]
				if (cardLast:getNumber() > 0) then
					if (card:getNumber() <= 0) then
						card:setNumber(cardLast:getNumber())
						cardLast:setNumber(0)
						-- 发现一个问题，这里如果不检测的话，会出现x等于0的现象，然后导致数组溢出。
						if (x < 4) then
							x = x + 1
						end
					elseif (card:getNumber() == cardLast:getNumber()) then
						card:setNumber(card:getNumber() * 2)
						cardLast:setNumber(0)
					end
					break
				end
			end
		end
	end
	self:autoCreateCardNumber()
end

function MainScene:doLeft()
	print("doLeft")
	local card
	local cardLast

	for x=1,4 do
		for y=1,4 do
			-- print("现在的位置",x,y,cardArr[x][y]:getNumber())
			for x1=x + 1,4 do
				card = cardArr[x][y]
				cardLast = cardArr[x1][y]
				if (cardLast:getNumber() > 0) then
					if (card:getNumber() <= 0) then
						card:setNumber(cardLast:getNumber())
						cardLast:setNumber(0)
						-- 发现一个问题，这里如果不检测的话，会出现x等于0的现象，然后导致数组溢出。
						if (x > 1) then
							x = x - 1
						end
					elseif (card:getNumber() == cardLast:getNumber()) then
						card:setNumber(card:getNumber() * 2)
						cardLast:setNumber(0)
					end
					break
				end
			end
		end
	end
	self:autoCreateCardNumber()
end

function MainScene:doUp()
	print("doUp")
	local card
	local cardLast

	for y=4,1,-1 do
		for x=1,4 do
			-- print("现在的位置",x,y,cardArr[x][y]:getNumber())
			for y1=y - 1,1,-1 do
				card = cardArr[x][y]
				cardLast = cardArr[x][y1]
				if (cardLast:getNumber() > 0) then
					if (card:getNumber() <= 0) then
						card:setNumber(cardLast:getNumber())
						cardLast:setNumber(0)
						-- 发现一个问题，这里如果不检测的话，会出现x等于0的现象，然后导致数组溢出。
						if (y < 4) then
							y = y + 1
						end
					elseif (card:getNumber() == cardLast:getNumber()) then
						card:setNumber(card:getNumber() * 2)
						cardLast:setNumber(0)
					end
					break
				end
			end
		end
	end
	self:autoCreateCardNumber()
end

function MainScene:doDown()
	print("doDown")
	local card
	local cardLast

	for y=1,4 do
		for x=1,4 do
			-- print("现在的位置",x,y,cardArr[x][y]:getNumber())
			for y1=y + 1,4 do
				card = cardArr[x][y]
				cardLast = cardArr[x][y1]
				if (cardLast:getNumber() > 0) then
					if (card:getNumber() <= 0) then
						card:setNumber(cardLast:getNumber())
						cardLast:setNumber(0)
						-- 发现一个问题，这里如果不检测的话，会出现x等于0的现象，然后导致数组溢出。
						if (y > 1) then
							y = y - 1
						end
					elseif (card:getNumber() == cardLast:getNumber()) then
						card:setNumber(card:getNumber() * 2)
						cardLast:setNumber(0)
					end
					break
				end
			end
		end
	end
	self:autoCreateCardNumber()
end

function MainScene:onEnter()
	local layer = display.newNode()
	layer:setContentSize(display.width, display.height)

	layer:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
		return self:onTouch(event.name, event.x, event.y)
	end)
	layer:setTouchEnabled(true)
	layer:setTouchSwallowEnabled(false)
	self:addChild(layer)
end

function MainScene:onExit()
end

return MainScene
