--
-- Author: sheepkx@qq.com
-- Date: 2015-06-19 01:08:19
-- 求一个Cocos2d-Lua的兼职开发或者外包游戏的开发工作，有意者可直接联系我的邮箱，tks.
--
-- 1,4	2,4	3,4	4,4
-- 1,3	2,3	3,3	4,3
-- 1,2	2,2	3,2	4,2
-- 1,1	2,1	3,1	4,1
local scheduler = require("framework.scheduler")

local size
local cardArr = {}
local touchStart = {0, 0}
local bg
local gridbg
local scoreLabel
local score = 0
local idDo = false
local gameOver = false
local gameOverCount = 0
local gameOverLabel

local MainScene = class("MainScene", function()
    return display.newScene("MainScene")
end)

local CardSprite = import("..Objects.CardSprite")

function MainScene:ctor()
	math.randomseed(os.time())
	math.random()

    -- self.visibleSize = cc.Director:getInstance():getVisibleSize()
    -- self.origin = cc.Director:getInstance():getVisibleOrigin()

    bg = cc.LayerColor:create(cc.c4b(250,248,239,255))
    gridbg = cc.LayerColor:create(cc.c4b(187,173,160,255),display.width - 15,display.width- 15)
    gridbg:setPosition(8,155)
    self:addChild(bg)
    self:addChild(gridbg)

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

    scoreLabel = cc.ui.UILabel.new({
        UILabelType = 2, text = score, size = 64})
    :align(display.CENTER, display.right - 100, display.top - 50)
    :addTo(self)

    gameOverLabel = cc.ui.UILabel.new({
        UILabelType = 2, text = "GAME OVER!!!", size = 64})
    :align(display.CENTER, display.cx, display.cy)
    :addTo(self)

    gameOverLabel:setVisible(false)

  -- 这里打开就可以随机移动测试。
  --   local function onInterval(dt)
	 --    local i = self:getRandom(4)
		-- if i == 1 then
		-- 	self:doRight()
		-- elseif i == 2 then
		-- 	self:doLeft()
		-- elseif i == 3 then
		-- 	self:doUp()
		-- elseif  i == 4 then
		-- 	self:doDown()
		-- end
  --   end
  --   -- 每 0.5 秒执行一次 onInterval()
  --   local handle = scheduler.scheduleGlobal(onInterval, 0.1)
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


	-- Game Over判定！
	-- for a=1,4 do
	-- 	for b=1,4 do
	-- 		if cardArr[a][b]:getNumber() > 0 then
	-- 			gameOverCount = gameOverCount + 1
	-- 		else
	-- 			gameOverCount = 0
	-- 		end
	-- 	end
	-- end

	-- if gameOverCount > 16 then
	-- 	print("GameOver!")
	-- 	gameOver = true
	-- 	gameOverLabel:setVisible(true)
	-- end

	-- print("----------打印布局----------")
	-- print(cardArr[1][4]:getNumber(),cardArr[2][4]:getNumber(),cardArr[3][4]:getNumber(),cardArr[4][4]:getNumber())
	-- print(cardArr[1][3]:getNumber(),cardArr[2][3]:getNumber(),cardArr[3][3]:getNumber(),cardArr[4][3]:getNumber())
	-- print(cardArr[1][2]:getNumber(),cardArr[2][2]:getNumber(),cardArr[3][2]:getNumber(),cardArr[4][2]:getNumber())
	-- print(cardArr[1][1]:getNumber(),cardArr[2][1]:getNumber(),cardArr[3][1]:getNumber(),cardArr[4][1]:getNumber())
	-- print("---------结束打印布局---------")
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
		if (tx > 100) then
			self:doRight()
		elseif (tx < - 100) then
			self:doLeft()
		elseif (ty > 100) then
			self:doUp()
		elseif (ty < - 100) then
			self:doDown()
		end
	end
	return true
end

function MainScene:doRight()
	print("doRight")
	local card
	local cardLast

	for y=1,4 do
		for x=4,1,-1 do
			card = cardArr[x][y]
			if card:getNumber() ~=0 then
				local x1 = x - 1
				while x1 >= 1 do
					cardLast = cardArr[x1][y]
					if cardLast:getNumber() ~=0 then
						if card:getNumber() == cardLast:getNumber() then
							score = score + cardLast:getNumber() * 2
							scoreLabel:setString(score)
							card:setNumber(cardLast:getNumber() * 2)
							cardLast:setNumber(0)
							isDo = true
						end
						x1 = 0
						break
					end
					x1 = x1 - 1
				end
			end
		end
	end

	for y=1,4 do
		for x=4,1,-1 do
			card = cardArr[x][y]
			if card:getNumber() ==0 then
				local x1 = x - 1
				while x1 >= 1 do
					cardLast = cardArr[x1][y]
					if cardLast:getNumber() ~=0 then
						card:setNumber(cardLast:getNumber())
						cardLast:setNumber(0)
						x1 = 0
						isDo = true
					end
					x1 = x1 - 1
				end
			end
		end
	end

	-- for y=4,1,-1 do
	-- 	for x=4,1,-1 do
	-- 		-- print("现在的位置",x,y,cardArr[x][y]:getNumber())
	-- 		local x1 = x - 1
	-- 		while (x1 >= 1) do
	-- 			print(x,y,x1,y)
	-- 			card = cardArr[x][y]
	-- 			cardLast = cardArr[x1][y]
	-- 			if (cardLast:getNumber() > 0) then
	-- 				print("cardLast大于0")
	-- 				if (card:getNumber() <= 0) then
	-- 					print(x1,y,cardArr[x1][y]:getNumber(),"--->",x,y,cardArr[x][y]:getNumber())

	-- 					card:setNumber(cardLast:getNumber())
	-- 					cardLast:setNumber(0)
	-- 					-- 发现一个问题，这里如果不检测的话，会出现x等于0的现象，然后导致数组溢出。
	-- 					-- 这里和c++版有一处不同，这里设置x的值不会改变任何结果，不会影响上面的循环。
	-- 					-- if (x < 4) then
	-- 					-- 	x = x + 1
	-- 					-- end
	-- 				elseif (card:getNumber() == cardLast:getNumber()) then
	-- 					card:setNumber(card:getNumber() * 2)
	-- 					cardLast:setNumber(0)
	-- 					print(x1,y,cardArr[x1][y]:getNumber(),"--->",x,y,cardArr[x][y]:getNumber())
	-- 				end
	-- 				x1 = 0
	-- 				break
	-- 			end
	-- 			x1 = x1 - 1
	-- 			-- break
	-- 		end
	-- 	end
	-- end
	if isDo then
		self:autoCreateCardNumber()
		isDo = false
	end
end

function MainScene:doLeft()
	print("doLeft")
	local card
	local cardLast

	-- for y = 1,4 do
 --        for x = 1,4 do
 --            for x1 = x + 1,4 do
 --                if (cardArr[x1][y]:getNumber() > 0) then
 --                    if (cardArr[x][y]:getNumber() <= 0) then
 --                        cardArr[x][y]:setNumber(cardArr[x1][y]:getNumber())
 --                        cardArr[x1][y]:setNumber(0);
 --                        x = x-1
 --                    elseif(cardArr[x][y]:getNumber() == cardArr[x1][y]:getNumber()) then
 --                        cardArr[x][y]:setNumber(cardArr[x][y]:getNumber() * 2)
 --                        cardArr[x1][y]:setNumber(0);
 --                        -- totalScore = totalScore+cardArr[x][y]:getNumber()
 --                    end
 --                    break
 --                end
 --            end
 --        end
 --    end

    for y=1,4 do
		for x=1,4 do
			card = cardArr[x][y]
			if card:getNumber() ~=0 then
				local x1 = x + 1
				while x1 < 5 do
					cardLast = cardArr[x1][y]
					if cardLast:getNumber() ~=0 then
						if card:getNumber() == cardLast:getNumber() then
							score = score + cardLast:getNumber() * 2
							scoreLabel:setString(score)
							card:setNumber(cardLast:getNumber() * 2)
							cardLast:setNumber(0)
							isDo = true
						end
						x1 = 5
						break
					end
					x1 = x1 + 1
				end
			end
		end
	end

	for y=1,4 do
		for x=1,4 do
			card = cardArr[x][y]
			if card:getNumber() ==0 then
				local x1 = x + 1
				while x1 < 5 do
					cardLast = cardArr[x1][y]
					if cardLast:getNumber() ~=0 then
						card:setNumber(cardLast:getNumber())
						cardLast:setNumber(0)
						x1 = 5
						isDo = true
					end
					x1 = x1 + 1
				end
			end
		end
	end

	-- for y=1,4 do
	-- 	for x=1,4 do
	-- 		-- print("现在的位置",x,y,cardArr[x][y]:getNumber())
	-- 		for x1=x + 1,4 do
	-- 			print(x,y)
	-- 			card = cardArr[x][y]
	-- 			cardLast = cardArr[x1][y]
	-- 			if (cardLast:getNumber() > 0) then
	-- 				if (card:getNumber() <= 0) then
	-- 					card:setNumber(cardLast:getNumber())
	-- 					cardLast:setNumber(0)
	-- 					print("左边的位置a",x1,y,cardArr[x1][y]:getNumber())
	-- 					print("右边的位置a",x,y,cardArr[x][y]:getNumber())
	-- 					-- 发现一个问题，这里如果不检测的话，会出现x等于0的现象，然后导致数组溢出。
	-- 					if (x > 1) then
	-- 						x = x - 1
	-- 					end
	-- 				elseif (card:getNumber() == cardLast:getNumber()) then
	-- 					card:setNumber(card:getNumber() * 2)
	-- 					cardLast:setNumber(0)
	-- 					print("左边的位置",x1,y,cardArr[x1][y]:getNumber())
	-- 					print("右边的位置",x,y,cardArr[x][y]:getNumber())
	-- 				end
	-- 				break
	-- 			end
	-- 		end
	-- 	end
	-- end
	if isDo then
		self:autoCreateCardNumber()
		isDo = false
	end
end

function MainScene:doUp()
	print("doUp")
	local card
	local cardLast

	-- for x = 1,4 do
 --        for y = 4,1,-1 do
 --            for y1 = y - 1,1,-1 do
 --                if (cardArr[x][y1]:getNumber() > 0) then
 --                    if (cardArr[x][y]:getNumber() <= 0) then
 --                        cardArr[x][y]:setNumber(cardArr[x][y1]:getNumber())
 --                        cardArr[x][y1]:setNumber(0);
 --                        y = y + 1
 --                    elseif(cardArr[x][y]:getNumber() == cardArr[x][y1]:getNumber()) then
 --                        cardArr[x][y]:setNumber(cardArr[x][y]:getNumber() * 2)
 --                        cardArr[x][y1]:setNumber(0);
 --                        -- totalScore = totalScore+cardArr[x][y]:getNumber()
 --                    end
 --                    break
 --                end
 --            end
 --        end
 --    end

	for x = 1,4 do
        for y = 4,1,-1 do
			card = cardArr[x][y]
			if card:getNumber() ~=0 then
				local y1 = y - 1
				while y1 > 0 do
					cardLast = cardArr[x][y1]
					if cardLast:getNumber() ~=0 then
						if card:getNumber() == cardLast:getNumber() then
							score = score + cardLast:getNumber() * 2
							scoreLabel:setString(score)
							card:setNumber(cardLast:getNumber() * 2)
							cardLast:setNumber(0)
							isDo = true
						end
						y1 = 0
						break
					end
					y1 = y1 - 1
				end
			end
		end
	end

	for x = 1,4 do
        for y = 4,1,-1 do
			card = cardArr[x][y]
			if card:getNumber() ==0 then
				local y1 = y - 1
				while y1 > 0 do
					cardLast = cardArr[x][y1]
					if cardLast:getNumber() ~=0 then
						card:setNumber(cardLast:getNumber())
						cardLast:setNumber(0)
						y1 = 0
						isDo = true
					end
					y1 = y1 - 1
				end
			end
		end
	end
	if isDo then
		self:autoCreateCardNumber()
		isDo = false
	end
end

function MainScene:doDown()
	print("doDown")
	local card
	local cardLast

	-- for x = 1,4 do
 --        for y = 1,4 do
 --            for y1 = y + 1,4 do
 --                if (cardArr[x][y1]:getNumber() > 0) then
 --                    if (cardArr[x][y]:getNumber() <= 0) then
 --                        cardArr[x][y]:setNumber(cardArr[x][y1]:getNumber())
 --                        cardArr[x][y1]:setNumber(0);
 --                        y = y-1
 --                    elseif(cardArr[x][y]:getNumber() == cardArr[x][y1]:getNumber()) then
 --                        cardArr[x][y]:setNumber(cardArr[x][y]:getNumber() * 2)
 --                        cardArr[x][y1]:setNumber(0);
 --                        -- totalScore = totalScore+cardArr[x][y]:getNumber()
 --                    end
 --                    break
 --                end
 --            end
 --        end
 --    end

	for x = 1,4 do
        for y = 1,4 do
			card = cardArr[x][y]
			if card:getNumber() ~=0 then
				local y1 = y + 1
				while y1 < 5 do
					cardLast = cardArr[x][y1]
					if cardLast:getNumber() ~=0 then
						if card:getNumber() == cardLast:getNumber() then
							score = score + cardLast:getNumber() * 2
							scoreLabel:setString(score)
							card:setNumber(cardLast:getNumber() * 2)
							cardLast:setNumber(0)
							isDo = true
						end
						y1 = 5
						break
					end
					y1 = y1 + 1
				end
			end
		end
	end

	for x = 1,4 do
        for y = 1,4 do
			card = cardArr[x][y]
			if card:getNumber() ==0 then
				local y1 = y + 1
				while y1 < 5 do
					cardLast = cardArr[x][y1]
					if cardLast:getNumber() ~=0 then
						card:setNumber(cardLast:getNumber())
						cardLast:setNumber(0)
						y1 = 5
						isDo = true
					end
					y1 = y1 + 1
				end
			end
		end
	end

	if isDo then
		self:autoCreateCardNumber()
		isDo = false
	end
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
