function game_load(menu,size,nOP,ai,single,multiplayer)
	love.graphics.setFont(fontStandard)
	love.graphics.setBackgroundColor(0,0,0)

	READY = true
	WINNER = 0
	SINGLE = single
	multi = 0
	TUTORIAL = false
	colorAll = 0
	END = false
	AI = ai
	MULTI = multiplayer
	vsAI = false
	REPLAY = false
	replayTimer = 1
	MENU = menu
	GAME = not menu
	menustate = "singlemulti"
	result = ""

	goSize = 0
	goColor = 255

	field_load(size)
	players = {}
	for i=1,nOP do
		if (i~=1 and AI or MENU) then
			if ((multiplayer==2 and (i==3 or i==4)) or (multiplayer==1 and i==4) or multiplayer==0 or not multiplayer) then
				players[i] = player:new(i,true)
			else
				players[i] = player:new(i,false)
			end
		else
			players[i] = player:new(i,false)
		end
	end

	playerOnTurn = 1

	for i=1,#players do
		if (i==1) then
			players[i].square = field.horSquares/2+0.5
			players[i].opponent = #players
		end
		if (i==2) then
			if (#players == 2) then
				players[i].square = field.totalSquares-field.horSquares/2+0.5
				players[i].opponent = 1
			else
				players[i].square = field.totalSquares/2+field.horSquares/2
				players[i].opponent = 1
			end
		end
		if (i==3) then
			players[i].square = field.totalSquares-field.horSquares/2+0.5
			players[i].opponent = 2
		end
		if (i==4) then
			players[i].square = field.totalSquares/2-field.horSquares/2+1
			players[i].opponent = 3
		end
		players[i]:setPosition()
	end

	if (MENU) then
		players[playerOnTurn].AI:startThinking()
		player_reset()
		for i=1,field.totalSquares do
			field.takenSquares[i]=3
		end
		PAUSE = true
	else
		PAUSE = false
	end
end



function game_update(dt)
	if (fadecolor<255) then
		fadecolor = fadecolor + 100 * dt
		if (fadecolor>250) then
			fadecolor = 255
		end
	end


	if (goSize<1) then
		goSize = goSize + 6 * dt
		if (goSize > 1) then
			goSize = 1
		end
	end
	if (goColor>0 and goSize == 1) then
		goColor = goColor - 400 * dt
		if (goColor<0) then
			goColor = 0
		end
	end

	if (sndMain:getVolume()<1 and not cells) then
		sndMain:setVolume(sndMain:getVolume()+0.4*dt)
	elseif (sndMain:getVolume()~=1 and not cells) then
		sndMain:setVolume(1)
	end



	if (WINNER==0) then
		if (GAME and not REPLAY) then
			timeleft = timeleft - dt
			if (timeleft < 0 and gametime ~= 4) then
				players[playerOnTurn].replay[replayTimer] = players[playerOnTurn].square
				players[playerOnTurn].alive = false
				field.takenSquares[players[playerOnTurn].square] = players[playerOnTurn].number
				game_endturn()
			end
		end

		for i=1,#players do
			players[i]:update(dt)
		end
		
	end

	if (WINNER~=0) then
		if (colorAll<field.totalSquares) then
			colorAll = colorAll + 59 * dt
			field.takenSquares[m_floor(colorAll)] = WINNER
		else
			for i=1,field.totalSquares do
				field.takenSquares[i] = WINNER
			end
			END = true
			if (MENU) then
				game_reset(0)
			end
		end
	end
	filled = 0
	for i=1,field.totalSquares do
		if (field.takenSquares[i]~=0) then
			filled = filled + 1
		end
	end
	if (SINGLE and WINNER==0) then
		result =  "Highscore - " .. tostring(highscores[field.size]) .. "         Current score - ".. tostring(m_floor((filled+1)*75+timeleft*7)) ..  "              " .. tostring(filled+1) .. " / " .. tostring(field.totalSquares) .. " squares          " ..  tostring(m_floor((filled+1)/field.totalSquares*100)) .. "% / Goal - 75%"
	end

	if (MENU and vsAI) then
		local win,loss = tonumber(highscores[4]),tonumber(highscores[5])
		local percent
		if (win>0 and loss>0) then
			percent = m_floor(win / (win + loss) * 100)
		else
			percent = 0
		end
		result =  "Win / loss ratio against CPU - " .. win .. " / " .. loss .. ".       " ..  percent .. "% wins."
	elseif (MENU) then
		result = ""
	end

	setDescription(xMouse,yMouse,menustate)

end

function game_draw()

	love.graphics.setFont(fontStandard)
	love.graphics.setBlendMode("alpha")
	if (not TUTORIAL) then
		field_draw()
		if (PAUSE) then
			love.graphics.setColor(20,20,20)
		else
			love.graphics.setColor(255,255,255)
		end

		love.graphics.setBlendMode("alpha")
		for i=1,#players do
			players[i]:draw()
		end

	end
	love.graphics.setColor(255,255,255)

	love.graphics.printf(description, 0, 740,1024,"center")
	love.graphics.printf(result, 0, field.verSquares*64+5,1024,"center")


	love.graphics.setBlendMode("alpha")
	if (soundOn) then 
		love.graphics.draw(imgSoundOn,96,640)
	else
		love.graphics.draw(imgSoundOff,96,640)
	end


	if (GAME and timeleft~=0 and gametime~=4) then
		love.graphics.print("Time left", 32, 10)
		love.graphics.printf(math.ceil(timeleft), 0, 35, 150, "center")
	end

	if (GAME and goColor~=0) then
		love.graphics.setBlendMode("additive")
		love.graphics.setColor(goColor,goColor,goColor)
		love.graphics.draw(imgGo, 512, 352, 0, goSize, goSize,162,97)
	end

	if (MENU and not TUTORIAL) then
		love.graphics.setBlendMode("alpha")
		love.graphics.setColor(255,255,255)
		
		love.graphics.draw(imgLogo, 224, 64)
		if (menustate ~= "singlemulti") then
			love.graphics.draw(imgBack, 32, 640)
		end
		if (PAUSE) then
			love.graphics.draw(imgStart, 32, 0)
		else
			love.graphics.draw(imgStop, 32, 0)
		end
		love.graphics.draw(imgColorblind, 928, 640)
		love.graphics.draw(imgScreen, 864,640)
		love.graphics.draw(imgLeave, 928, 0)
		if (menustate == "singlemulti") then
			love.graphics.draw(imgSingleplayer, 352, 448)
			love.graphics.draw(imgTutorial,480, 448)
			love.graphics.draw(img3Players, 608, 448)
		end
		if (menustate == "multiplayer") then
			love.graphics.draw(img2Players, 352, 448)
			love.graphics.draw(imgOnline, 480, 448)
			love.graphics.draw(imgVSCPU, 608, 448)
			love.graphics.draw(imgTime[gametime], 800, 640)
		end
		if (menustate == "vsplayer") then
			love.graphics.draw(img2Players, 352, 448)
			love.graphics.draw(imgPlus2, 352, 512)
			love.graphics.draw(img3Players, 480, 448)
			love.graphics.draw(imgPlus1, 480, 512)
			love.graphics.draw(img4Players, 608, 448)
			love.graphics.draw(imgTime[gametime], 800, 640)
		end
		if (menustate == "vscpu") then
			love.graphics.draw(img1CPU, 352, 448)
			love.graphics.draw(img2CPU, 480, 448)
			love.graphics.draw(img3CPU, 608, 448)
			love.graphics.draw(imgTime[gametime], 800, 640)

		end
		if (menustate == "size") then
			love.graphics.draw(imgSmall, 352, 448)
			love.graphics.draw(imgMedium, 480, 448)
			love.graphics.draw(imgBig, 608, 448)
			if (not single) then
				love.graphics.draw(imgTime[gametime], 800, 640)
			end

		end
	end

	if (TUTORIAL) then
		if (currentTutPage~=6) then
			love.graphics.draw(imgTutPages[currentTutPage], 224, 0)
			love.graphics.draw(imgSquares[2], 928, 256)
			love.graphics.draw(imgPlay, 928, 256)
		else
			love.graphics.draw(imgDesura, 120, 220)
			love.graphics.draw(imgItch, 200, 400)
			love.graphics.printf("HOX \n \n All art and code is made by Daniël Haazen.\n Made in lua with the LÖVE engine. \n Music by Elephly from Newgrounds.com \n Font is Squarefont by Agustín Bou.  \n \n You can buy this game for $1.99 on desura.com and itch.io.\n Click on the following images to go to the game's page.", 10, 10, 1024, "center")
			love.graphics.printf("Thank you so much for buying my game. \n If you have questions or feedback you are free to contact me. \n \n sheepolution.com \n danielhaazen.com \n \n",10, 630, 1024, "center")
		end
		if (currentTutPage~=1) then
			love.graphics.draw(imgSquares[1], 32, 256)
			love.graphics.draw(imgPlay, 96, 256,0,-1,1)
		end
		love.graphics.setColor(255,255,255)
		love.graphics.draw(imgBack, 32, 640)
	end

	if (END) then
		if (GAME) then
			love.graphics.setColor(255,255,255)
			love.graphics.setBlendMode("alpha")
			if (not SINGLE) then
				love.graphics.draw(imgReplay, getSquareX(field.totalSquares/2-3+0.5), getSquareY(field.totalSquares/2-3+0.5))
			else
				love.graphics.draw(imgReplayLevel, getSquareX(field.totalSquares/2-3+0.5), getSquareY(field.totalSquares/2-3+0.5))
			end
			if (not SINGLE) then
				love.graphics.draw(imgPlay, getSquareX(field.totalSquares/2+0.5), getSquareY(field.totalSquares/2+0.5))
			else
				love.graphics.draw(imgNewLevel, getSquareX(field.totalSquares/2+0.5), getSquareY(field.totalSquares/2+0.5))
			end
			love.graphics.draw(imgMenu, getSquareX(field.totalSquares/2+3+0.5), getSquareY(field.totalSquares/2+3+0.5))
		end
	end

	love.graphics.setBlendMode("additive")
	love.graphics.setColor(70,70,70)
	for i=1,field.totalSquares do
		if (onClick(xMouse,yMouse,getSquareX(i),getSquareY(i),64,64)) then
			love.graphics.rectangle("fill", getSquareX(i), getSquareY(i), 64,64)
			break
		end
	end
	if (not MENU) then

		love.graphics.setColor(255,255,255)
		love.graphics.setBlendMode("alpha")
		love.graphics.draw(imgBack, 32, 640)


		love.graphics.setBlendMode("additive")
		love.graphics.setColor(70,70,70)
		if (onClick(xMouse,yMouse,96,640,64,64)) then
			love.graphics.rectangle("fill", 96, 640,64,64)
		end
		if (onClick(xMouse,yMouse,32,640,64,64)) then
			love.graphics.rectangle("fill", 32, 640, 64,64)
		end
	end
	love.graphics.setColor(fadecolor,fadecolor,fadecolor)
	love.graphics.setBlendMode("multiplicative")
	love.graphics.rectangle("fill", 0, 0, 1024, 768)
end

function game_mousereleased(x,y,button)

	if (WINNER~=0 and not END and not MENU) then
		for i=1,field.totalSquares do
			field.takenSquares[i] = WINNER
			END = true
		end
	end
	
	if (button=="l") then
		if (gamestate == "game") then

			if (onClick(x,y,96,640,64,64)) then
				soundOn = not soundOn
				if (soundOn) then
					
					love.audio.play(sndMain)
				else
					love.audio.pause(sndMain)
				end
			end


			if (not MENU) then
				if (onClick(x,y,32,640,64,64)) then
					game_load(true,0,4,false,false)
				end
			end
			

			if (MENU and not TUTORIAL) then
				if (onClick(x,y,32,0,64,64)) then
					if (PAUSE) then
						PAUSE = false
						game_reset(0)
						return
					else
						PAUSE = true
						player_reset()
						for i=1,field.totalSquares do
							field.takenSquares[i]=3
						end
						return
					end
				end
				if (onClick(x,y,480,128,64,64)) then
					lights = not lights
				end
				if (onClick(x,y,672,128,64,64)) then
					sheep = not sheep
					cells = false
				end
				if (onClick(x,y,288,128,64,64)) then
					cells = not cells
					if (cells) then
						sheep = false
					end
					return
				end
				if (onClick(x,y,928,640,64,64)) then
					colorblind = not colorblind
				end
				if (onClick(x,y,864,640,64,64)) then
					love.graphics.toggleFullscreen()
				end
				if (onClick(x,y,928,0,64,64)) then
					love.event.quit()
				end
				if (onClick(x,y,32,640,64,64)) then
					if (menustate == "multiplayer") then
						menustate = "singlemulti"
						return
					end
					if (menustate == "vscpu") then
						menustate = "multiplayer"
						vsAI = false
						return
					end
					if (menustate == "vsplayer") then
						menustate = "multiplayer"
						vsAI = false
						return
					end
					if (menustate == "size") then
						if (single) then
							menustate = "singlemulti"
							single = false
						elseif (vsAI and multi==0) then
							menustate = "vscpu"
						else
							menustate = "vsplayer"
							multi = 0
							vsAI = false
						end
					end
				end

			love.graphics.draw(imgTime[gametime], 800, 640)
				if (onClick(x,y,800,640,64,64)) then
					if (menustate ~= "singlemulti") then
						gametime = gametime + 1
						if (gametime>#imgTime) then
							gametime = 1
						end
						return
					end
				end
				if (onClick(x,y,352,448,64,64)) then
					if (menustate == "singlemulti") then
						menustate = "size"
						single = true
						numberOfPlayers = 1
						return
					end
					if (menustate == "multiplayer") then
						menustate = "vsplayer"
						return
					end
					if (menustate == "vsplayer") then
						numberOfPlayers = 2
						menustate = "size"
						return
					end
					if (menustate == "vscpu") then
						numberOfPlayers = 2
						menustate = "size"
						return
					end
					if (menustate == "size") then

						time_reset(single,1)
						game_load(false,1,numberOfPlayers,vsAI,single,multi)
					end
				end
				if (onClick(x,y,480,448,64,64)) then
					if (menustate == "singlemulti") then
						TUTORIAL = true
						return
					end
					if (menustate == "vscpu") then
						numberOfPlayers = 3
						menustate = "size"
						return
					end
					if (menustate == "vsplayer") then
						numberOfPlayers = 3
						menustate = "size"
						return
					end
					if (menustate == "size") then
						time_reset(single,2)
						game_load(false,2,numberOfPlayers,vsAI,single,multi)
					end
				end
				if (onClick(x,y,608,448,64,64)) then
					if (menustate == "singlemulti") then
						menustate = "multiplayer"
						single = false
						return
					end
					if (menustate == "multiplayer") then
						menustate = "vscpu"
						vsAI = true
						return
					end
					if (menustate == "vscpu") then
						numberOfPlayers = 4
						menustate = "size"
						return
					end
					if (menustate == "vsplayer") then
						numberOfPlayers = 4
						menustate = "size"
						return
					end
					if (menustate == "size") then
						time_reset(single,3)
						game_load(false,3,numberOfPlayers,vsAI,single,multi)
					end
				end

				if (onClick(x,y,480,512,64,64)) then
					if (menustate == "vsplayer") then
						multi = 1
						numberOfPlayers = 4
						vsAI = true
						menustate = "size"
					end
				end
				if (onClick(x,y,352,512,64,64)) then
					if (menustate == "vsplayer") then
						multi = 2
						numberOfPlayers = 4
						vsAI = true
						menustate = "size"
					end
				end

			elseif (TUTORIAL) then
				if (onClick(xMouse,yMouse,120,220,600,238)) then
					if (currentTutPage==6) then
						if (OS=="Windows") then
							os.execute("start http://desura.com/games/hox")
						elseif (OS=="Linux") then
							os.execute("xdg-open \"http://desura.com/games/hox/\"")
						elseif (OS=="OS X") then
							os.execute("open http://desura.com/games/hox/")
						end
					end
				end
				if (onClick(xMouse,yMouse,200,400,800,200)) then
					if (currentTutPage==6) then
						if (OS=="Windows") then
							os.execute("start http://sheepolution.itch.io/hox")
						elseif (OS=="Linux") then
							os.execute("xdg-open \"http://sheepolution.itch.io/hox/\"")
						elseif (OS=="OS X") then
							os.execute("open http://sheepolution.itch.io/hox/")
						end
					end
				end

				if (onClick(xMouse,yMouse,928,256,field.squareSize,field.squareSize)) then
					if (currentTutPage~=6) then
						currentTutPage = currentTutPage + 1
						return
					end
				end

				if (onClick(xMouse,yMouse,32,256,field.squareSize,field.squareSize)) then
					if (currentTutPage~=1) then
						currentTutPage = currentTutPage - 1
						return
					end
				end

				if (onClick(xMouse,yMouse,32,640,field.squareSize,field.squareSize)) then
					game_load(true,0,4)
					currentTutPage = 1
					return
				end
			elseif (not END) then
				players[playerOnTurn]:mousereleased(x,y,button)
			else
				if (onClick(xMouse,yMouse,getSquareX(field.totalSquares/2-3+0.5),getSquareY(field.totalSquares/2-3+0.5),field.squareSize,field.squareSize)) then
					if (not SINGLE) then
						REPLAY = true
						game_reset(field.size)
						time_reset()
					else
						game_reset(field.size,SINGLE)
						time_reset(SINGLE,field.size)
					end
				end
				if (onClick(xMouse,yMouse,getSquareX(field.totalSquares/2+0.5),getSquareY(field.totalSquares/2+0.5),field.squareSize,field.squareSize)) then
					game_load(false,field.size,numberOfPlayers,AI,SINGLE,MULTI)
					time_reset(SINGLE,field.size)

				end
				if (onClick(xMouse,yMouse,getSquareX(field.totalSquares/2+3+0.5),getSquareY(field.totalSquares/2+3+0.5),field.squareSize,field.squareSize)) then
					game_load(true,0,4,false)
				end
			end
		end
	end
	description = ""
end

function game_endturn()

	

	local dead,win = 0,playerOnTurn
	repeat
	dead = dead + 1
	playerOnTurn = playerOnTurn + 1
	if (playerOnTurn > #players) then
		playerOnTurn = 1
		replayTimer = replayTimer + 1
	end
	until players[playerOnTurn].alive or dead > 5

	if (dead>5) then
		game_win(win)
		return
	end

	

	if (not SINGLE) then

		local alive = 0
		for i=1,#players do
			if (players[i].alive) then
				alive = alive + 1
			end
		end

		if (alive==1) then
			game_win(playerOnTurn)
		end

		if (not players[players[playerOnTurn].opponent].alive) then
			local opp,dead = players[playerOnTurn].opponent,0
			repeat
			dead = dead + 1
				opp = opp - 1
				if (opp<1) then
					opp = #players
				end
				if (players[opp].alive) then
					players[playerOnTurn].opponent=opp
				end
			until players[players[playerOnTurn].opponent].alive
		end

		time_reset(false)
	end

	if (players[playerOnTurn].AI and not REPLAY) then
		players[playerOnTurn].AI:startThinking()
	else
		local legitsqrs = 0
		for i=1,field.totalSquares do
			if (i~=players[playerOnTurn].square) then
				if (squareIsLegit(i)) then
					legitsqrs = legitsqrs + 1
				end
			end
		end
		if (legitsqrs==0) then
			players[playerOnTurn].alive = false
			field.takenSquares[players[playerOnTurn].square] = players[playerOnTurn].number
			game_endturn()
			return
		end
	end
	if (REPLAY) then
		if (players[playerOnTurn].replay[replayTimer]) then
			players[playerOnTurn].goToSquare = players[playerOnTurn].replay[replayTimer]
		else
			players[playerOnTurn].alive = false
			game_endturn()
			return
		end
 	end
end

function game_win(winner)
	print(winner)
	WINNER = winner
	if (not SINGLE and not MENU and not TUTORIAL) then
		result = "GAME OVER!    Player " .. WINNER .. " WINS!!   ( " .. dataNames[WINNER] .. " )"
		if (AI and MULTI == 0 and not players[WINNER].AI) then
			highscores[4] = tonumber(highscores[4])+1
			love.filesystem.write("highscores.sav", highscores[1]..","..highscores[2]..","..highscores[3]..","..highscores[4]..","..highscores[5])
		elseif (AI and MULTI and players[WINNER].AI) then
			highscores[5] = tonumber(highscores[5])+1
			love.filesystem.write("highscores.sav", highscores[1]..","..highscores[2]..","..highscores[3]..","..highscores[4]..","..highscores[5])
		end
	elseif (SINGLE) then
		filled = 0
		for i=1,field.totalSquares do
			if (field.takenSquares[i]~=0) then
				filled = filled + 1
			end
		end
		if (m_floor((filled)/field.totalSquares*100)>=75) then
			if (tonumber(highscores[field.size])<(filled)*75+timeleft*7) then
				highscores[field.size]=m_floor((filled)*75+timeleft*7)
				love.filesystem.write("highscores.sav", highscores[1]..","..highscores[2]..","..highscores[3]..","..highscores[4]..","..highscores[5])
			end
			result =  "LEVEL COMPLETE!   " .. tostring(filled) .. " / " .. tostring(field.totalSquares) .. " squares          " ..  tostring(m_floor((filled)/field.totalSquares*100)) .. "% / Goal - 75%       Final score - " .. tostring(m_floor((filled)*75+timeleft*7)) .. "          Highscore - " .. tostring(highscores[field.size])
		else
			result =  "LEVEL FAILED!   " .. tostring(filled) .. " / " .. tostring(field.totalSquares) .. " squares          " ..  tostring(m_floor((filled)/field.totalSquares*100)) .. "% / Goal - 75%"
		end
	return
	end

end

function game_reset(size,rplay)
	WINNER = 0
	colorAll = 0
	END = false
	replayTimer = 1
	playerOnTurn = 1
	if (not REPLAY and not rplay) then
		field_load(size)
	else
		for i=1,field.totalSquares do
			field.takenSquares[i] = 0
		end
	end

	player_reset()
	if (not rplay) then
		if (MENU) then
			players[playerOnTurn].AI:startThinking()
		elseif (GAME) then
			players[playerOnTurn].goToSquare = players[playerOnTurn].replay[replayTimer]
		end
	end
end

function time_reset(single,size)
	if (not single) then
		if (gametime ~= 4) then
			timeleft = 10 * gametime
		end
	else
		if (size == 1) then
			timeleft = 100
		elseif (size == 2) then
			timeleft = 175
		elseif (size == 3) then
			timeleft = 250
		end
	end
end

function player_reset()
	for i=1,#players do
		players[i].alive = true
		if (i==1) then
			players[i].square = field.horSquares/2+0.5
			players[i].opponent = #players
		end
		if (i==2) then
			if (#players == 2) then
				players[i].square = field.totalSquares-field.horSquares/2+0.5
				players[i].opponent = 1
			else
				players[i].square = field.totalSquares/2+field.horSquares/2
				players[i].opponent = 1
			end
		end
		if (i==3) then
			players[i].square = field.totalSquares-field.horSquares/2+0.5
			players[i].opponent = 2
		end
		if (i==4) then
			players[i].square = field.totalSquares/2-field.horSquares/2+1
			players[i].opponent = 3
		end
		players[i]:setPosition()
	end
end

function onClick(mx,my,x,y,w,h,c)
	return (mx > x and mx < x+w and my > y and my < y+h)
end

function isEven(i)
	return i%2==0
end


function setDescription(x,y,ms)
	if (onClick(x,y,96,640,64,64)) then
		description = "Toggle sound"
	end
	if (MENU and not TUTORIAL) then
		if (onClick(x,y,32,0,64,64)) then
			if (PAUSE) then
				description = "Play background animation"
			else
				description = "Stop background animation"
			end
		end
		if (onClick(x,y,928,640,64,64)) then
			description = "Toggle colorblind mode"
		end
		if (onClick(x,y,864,640,64,64)) then
			description = "Toggle Fullscreen"
		end
		if (onClick(x,y,928,0,64,64)) then
			description = "Quit the game"
		end
		if (onClick(x,y,800,640,64,64)) then
			if (ms~="singlemulti" and not single) then
				description = "Set the gametime - 10 - 20 - 30 or none"
			end
		end

		if (onClick(x,y,352,448,64,64)) then
			if (ms == "singlemulti") then
				description = "Singleplayer - try to fill as many squares on your own!"
			end
			if (ms == "multiplayer") then
				description = "Player vs Player - Play against your friends!"
			end
			if (ms == "vsplayer") then
				description = "2 Players"
			end
			if (ms == "vscpu") then
				description = "1 CPU"
			end
			if (ms == "size") then
				description = "Level size - Small"
			end
		end
		if (onClick(x,y,480,448,64,64)) then
			if (ms == "singlemulti") then
				description = "Tutorial - Learn to play the game!"
			end
			if (ms == "multiplayer") then 
				description = "Online Multiplayer - This option is not yet available. Check the Desura page for more information."
			end
			if (ms == "vsplayer") then
				description = "3 Players"
			end
			if (ms == "vscpu") then
				description = "2 CPU"
			end
			if (ms == "size") then
				description = "Level Size - Normal"
			end
		end
		if (onClick(x,y,608,448,64,64)) then
			if (ms == "singlemulti") then
				description = "Multiplayer - Play against opponents and try to be the last remaining!"
			end
			if (ms == "multiplayer") then
				description = "Player vs CPU - Play against the computer!"

			end
			if (ms == "vsplayer") then
				description = "4 Players"
			end
			if (ms == "vscpu") then
				description = "3 CPU"
			end
			if (ms == "size") then
				description = "Level Size: Big"
			end
		end
		if (onClick(x,y,480,512,64,64)) then
			if (ms == "vsplayer") then
				description = "3 players, and 1 CPU"
			end
		end
		if (onClick(x,y,352,512,64,64)) then
			if (ms == "vsplayer") then
				description = "2 players, and 2 CPU"
			end
		end
	end
	if (END) then
		if (onClick(xMouse,yMouse,getSquareX(field.totalSquares/2-3+0.5),getSquareY(field.totalSquares/2-3+0.5),field.squareSize,field.squareSize)) then
			if (not SINGLE) then
				description = "Rewatch the game you just played!"
			else
				description = "Replay the level you just played!"
			end
		end
		if (onClick(xMouse,yMouse,getSquareX(field.totalSquares/2+0.5),getSquareY(field.totalSquares/2+0.5),field.squareSize,field.squareSize)) then
			description = "Play again!"
		end
		if (onClick(xMouse,yMouse,getSquareX(field.totalSquares/2+3+0.5),getSquareY(field.totalSquares/2+3+0.5),field.squareSize,field.squareSize)) then
			description = "Go to the menu."
		end
	end
	if (REPLAY) then
		description = "Hold to pause the replay!"
	end

	if (not (MENU and ms == "singlemulti" and not TUTORIAL)) then
		if (onClick(x,y,32,640,64,64)) then
			description = "Back"
		end
	end
end