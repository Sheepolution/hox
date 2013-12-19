player = class:new()
function player:init(i,c)
	if (c) then
		self.AI = ai:new(i,self)
	end
	self.alive = true
	self.number = i
	self.img = imgPlayers[i]
	self.imgCB = imgPlayersCB[i]
	self.xPos, self.yPos, self.w, self.h = x, y, self.img:getWidth()/2, self.img:getHeight()/2
	self.square = 0
	self.opponent = 0
	self.goToSquare = 0
	self.xDistance = 0
	self.yDistance = 0
	self.replay = {}
	self.noteSize = 64
	self.noteColor = 0
end

function player:update(dt)
	

	if (WINNER == 0 and not PAUSE and not (REPLAY and love.mouse.isDown("l"))) then

		if (playerOnTurn == self.number and self.goToSquare == 0) then
			if (self.goToSquare == 0) then
				self.noteSize = self.noteSize + 100 * dt
				self.noteColor = self.noteColor - 300 * dt
				if (self.noteColor<5) then
					self.noteColor = 0
				end
				if (self.noteSize > 300) then
					self.noteSize = 64
					self.noteColor = 255
				end
			end
		else
			self.noteSize = 64
			self.noteColor = 0
		end


		if (self.goToSquare~=0) then
			local xSqr,ySqr = getSquareX(self.goToSquare),getSquareY(self.goToSquare)
			if (math.abs(xSqr-self.xPos)>8) then
				if (self.xPos<xSqr) then
					self.xPos=self.xPos+field.squareSize*8*dt
				elseif (self.xPos>xSqr) then
					self.xPos=self.xPos-field.squareSize*8*dt
				end
			elseif (math.abs(ySqr-self.yPos)>8) then
				if (self.yPos<ySqr) then
					self.yPos=self.yPos+field.squareSize*8*dt
				elseif (self.yPos>ySqr) then
					self.yPos=self.yPos-field.squareSize*8*dt
				end
			else
				self:toSquare(self.goToSquare)
				self.goToSquare = 0
			end
		end
	end
end

function player:draw()
	love.graphics.setColor(255,255,255)
	love.graphics.setBlendMode("alpha")
	if (colorblind) then
		love.graphics.draw(self.imgCB,self.xPos,self.yPos)
	else
		love.graphics.draw(self.img,self.xPos,self.yPos)
	end
	love.graphics.setColor(self.noteColor,self.noteColor,self.noteColor)
	love.graphics.setBlendMode("additive")
	if (WINNER == 0 and not PAUSE and not (REPLAY and love.mouse.isDown("l"))) then
		if (playerOnTurn == self.number and self.goToSquare==0) then
			love.graphics.setLine(2, "smooth")
			love.graphics.rectangle("line", self.xPos-self.noteSize/2+32, self.yPos-self.noteSize/2+32, self.noteSize, self.noteSize)
		end
	end

end

function player:mousereleased(x,y,button)
	if (not self.AI and not REPLAY and self.goToSquare == 0) then
		for i=1,field.totalSquares do
			if (i~=self.square) then
				if (onClick(x,y,getSquareX(i),getSquareY(i),field.squareSize,field.squareSize)) then
					if (squareIsLegit(i)) then
						self.goToSquare = i
						time_reset(SINGLE)
						table.insert(self.replay,i)
						break
					end
				end
			end
		end
	end
end

function player:toSquare(i)
	field.takenSquares[self.square]=self.number
	self.square = i
	self:setPosition()

	game_endturn()

	return self.collected
end


function player:setPosition()
	
	self.xPos = getSquareX(self.square)
	self.yPos = getSquareY(self.square)

end