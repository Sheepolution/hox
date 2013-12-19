ai = class:new()
function ai:init(i,p)
	self.number = i
	self.parent = p

	self.squares = {}
	self.numbers = {}
	self.surrounded = {}

end

function ai:startThinking()
	--The AI is really simple. We check if the number of surrounding squares for each square, and the number on the square.
	--We sum that up, and the lowest value wins.
	self.squares = {}
	self.numbers = {}
	self.surrounded = {}

	for i=1,field.totalSquares do
		if (i~=self.parent.square) then
			if (field.takenSquares[i]~=0) then
				if (getSquareDistance(self.parent.square,i)<=3) then
					table.insert(self.surrounded,i)
				end
			end
			if (squareIsLegit(i)) then
				table.insert(self.squares,i)
				table.insert(self.numbers,field.numbers[i])
			end
			if (not self.surrounded[i]) then
				self.surrounded[i]=0
			end
		end
	end

	if (#self.squares==0) then
		self.parent.alive = false
		field.takenSquares[self.parent.square] = self.parent.number
		game_endturn()
	end

	if (self.parent.alive) then
		local bestSquare, bestValue, squareValue

		for i=1,#self.squares do
			squareValue = self:getSquareValue(self.surrounded[i],self.numbers[i])
			if (bestValue) then
				if (squareValue < bestValue) then
					bestSquare = self.squares[i]
					bestValue = squareValue
				end
			else
				bestValue = squareValue
				bestSquare = self.squares[i]
			end
		end
		self.parent.goToSquare=bestSquare
		table.insert(self.parent.replay,bestSquare)
	end
end


function ai:getSquareValue(s,n) -- surrounded,number
	if (n == "x") then
		n = 20
	end
	if (s) then
		return s*2+n
	else
		return n
	end
end