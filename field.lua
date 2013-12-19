function field_load(s)

	field = {}
	field.size = s
	if (s==0) then
	field.horSquares, field.verSquares = 15,11
	else
		field.horSquares, field.verSquares = 5+s*2,5+s*2
	end
	field.totalSquares = field.horSquares*field.verSquares
	field.squareSize = 64
	if (field.horSquares == 15) then
		field.x,field.y = 32,0
	else
		field.x,field.y = 512-field.horSquares*field.squareSize/2,0
	end
	field.takenSquares = {}

	field.numbers = {}
	for i=1,field.totalSquares do
		table.insert(field.numbers,m_random(3))
		table.insert(field.takenSquares,0)
	end
	field.numbers[field.totalSquares/2+0.5] = "x"

end

function field_draw()
	if (lights) then
		love.graphics.setColor(0,0,0)
	else
		love.graphics.setColor(255,255,255)
	end

	for i=1,field.totalSquares do
		love.graphics.draw(imgSquare, getSquareX(i), getSquareY(i))
	end
	love.graphics.setColor(255,255,255)
	for i=1,field.totalSquares do
		love.graphics.printf(field.numbers[i], getSquareX(i)+field.squareSize/2-50, getSquareY(i)+field.squareSize/2-10,100,"center")
	end

	for i=1,field.totalSquares do
		if (field.takenSquares[i]~=0) then
			if (PAUSE) then
				love.graphics.setColor(20,20,20)
			end
			if (cells) then
				love.graphics.draw(imgCells[field.takenSquares[i]], getSquareX(i), getSquareY(i))
			elseif (sheep) then
				love.graphics.draw(imgSheeps[field.takenSquares[i]], getSquareX(i), getSquareY(i))
			elseif (colorblind) then
				love.graphics.draw(imgSquaresCB[field.takenSquares[i]], getSquareX(i), getSquareY(i))
			else
				if (lights) then
					love.graphics.setColor(dataSquares[field.takenSquares[i]][1],dataSquares[field.takenSquares[i]][2],dataSquares[field.takenSquares[i]][3])
					if (PAUSE) then
						love.graphics.setColor(20,20,20)
					end
					love.graphics.rectangle("fill", getSquareX(i),getSquareY(i), field.squareSize, field.squareSize)
				else
					love.graphics.draw(imgSquares[field.takenSquares[i]], getSquareX(i), getSquareY(i))
				end
			end
		end
	end
	
	
	if (lights) then
		love.graphics.setColor(255,255,255)
		for i=0,field.horSquares do
			love.graphics.line(field.x+i*field.squareSize,field.y,field.x+i*field.squareSize,field.y+field.verSquares*field.squareSize)
		end
		for i=0,field.verSquares do
			love.graphics.line(field.x,field.y+i*field.squareSize,field.x+field.horSquares*field.squareSize,field.y+i*field.squareSize)
		end
	end
	if (not MENU and not REPLAY) then
		love.graphics.setBlendMode("additive")
		for i=1,field.totalSquares do
			if (i~=players[playerOnTurn].square) then
				if (not squareIsLegit(i)) then
					if (field.numbers[players[players[playerOnTurn].opponent].square]~="x") then
						if (getSquareDistance(i,players[playerOnTurn].square)<=field.numbers[players[players[playerOnTurn].opponent].square]) then
							if (field.takenSquares[i]==0) then
								love.graphics.setColor(50,0,20)
								love.graphics.rectangle("fill", getSquareX(i),getSquareY(i), field.squareSize, field.squareSize)
							end
						end
					end
				else
					love.graphics.setColor(70,120,200)
					love.graphics.rectangle("fill", getSquareX(i),getSquareY(i), field.squareSize, field.squareSize)
				end
			end
		end
	end
end

function getSquareX(i)
	i=i-1
	return field.x+(i%field.horSquares)*field.squareSize
end

function getSquareY(i)
	i=i-1
	return field.y+m_floor(i/field.horSquares)*field.squareSize
end

function getSquareDistance(a,b)
	return (m_abs(getSquareX(a)-getSquareX(b))/field.squareSize+m_abs(getSquareY(a)-getSquareY(b))/field.squareSize)
end

function squareIsLegit(i)
	if (field.numbers[players[players[playerOnTurn].opponent].square]=="x") then
		if (field.takenSquares[i]==0) then
			local a = true
			for j=1,#players do
				if (players[j].square==i) then
					a = false
				end
			end
			if (a) then
				return true
			end
		end
	end

	if (getSquareDistance(i,players[playerOnTurn].square)==field.numbers[players[players[playerOnTurn].opponent].square]) then
		if (field.takenSquares[i]==0) then
			local a = true
			for j=1,#players do
				if (players[j].square==i) then
					a = false
				end
			end
			if (a) then
				return true
			end
		end
	end
	return false
end