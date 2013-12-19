--[[
All code, graphics, and idea by Daniël Haazen, except for the Desura, itch.io and LÖVE logo, and the Squarefont.

The main theme is by Elephly from Newgrounds.com.

If anything else is not made by me it should be commented in the file, or be obvious.

danielhaazen.com
sheepolution.com

____________________________________________________________

This work is licensed under a Creative Commons Attribution-NonCommercial-ShareAlike 3.0 Unported License.

You are free:

to Share — to copy, distribute and transmit the work
to Remix — to adapt the work

Under the following conditions:
Attribution — You must attribute the work in the manner specified by the author or licensor (but not in any way that suggests that they endorse you or your use of the work).
Noncommercial — You may not use this work for commercial purposes.
Share Alike — If you alter, transform, or build upon this work, you may distribute the resulting work only under the same or similar license to this one.

With the understanding that:
Waiver — Any of the above conditions can be waived if you get permission from the copyright holder.
Public Domain — Where the work or any of its elements is in the public domain under applicable law, that status is in no way affected by the license.
Other Rights — In no way are any of the following rights affected by the license:
	Your fair dealing or fair use rights, or other applicable copyright exceptions and limitations;
	The author's moral rights;
	Rights other persons may have either in the work itself or in how the work is used, such as publicity or privacy rights.
Notice — For any reuse or distribution, you must make clear to others the license terms of this work. The best way to do this is with a link to this web page.


http://creativecommons.org/licenses/by-nc-sa/3.0/
____________________________________________________________

I know, I know, it's a mess. This game is made in 1 week for the October Challenge of Ludum Dare. I was in a rush, and I'm cleaning it up, don't worry.


]]

function love.load()
	
	version = "1.0.06"
	math.randomseed(os.time()+love.mouse.getX()+love.mouse.getY())

	require "class"
	require "intro"
	require "game"
	require "player"
	require "field"
	require "ai"

	--images

	imgPlayers = {
		love.graphics.newImage("images/playerRed.png"),
		love.graphics.newImage("images/playerBlue.png"),
		love.graphics.newImage("images/playerYellow.png"),
		love.graphics.newImage("images/playerGreen.png")
	}

	imgSquares = {
		love.graphics.newImage("images/squareRed.png"),
		love.graphics.newImage("images/squareBlue.png"),
		love.graphics.newImage("images/squareYellow.png"),
		love.graphics.newImage("images/squareGreen.png")
	}

	imgPlayersCB = {
		love.graphics.newImage("images/playerRedCB.png"),
		love.graphics.newImage("images/playerBlueCB.png"),
		love.graphics.newImage("images/playerYellowCB.png"),
		love.graphics.newImage("images/playerGreenCB.png")
	}

	imgSquaresCB = {
		love.graphics.newImage("images/squareRedCB.png"),
		love.graphics.newImage("images/squareBlueCB.png"),
		love.graphics.newImage("images/squareYellowCB.png"),
		love.graphics.newImage("images/squareGreenCB.png")
	}

	imgSheeps = {
		love.graphics.newImage("images/sheepred.png"),
		love.graphics.newImage("images/sheepblue.png"),
		love.graphics.newImage("images/sheepyellow.png"),
		love.graphics.newImage("images/sheepgreen.png")
	}

	imgCells = {
		love.graphics.newImage("images/cellred.png"),
		love.graphics.newImage("images/cellblue.png"),
		love.graphics.newImage("images/cellyellow.png"),
		love.graphics.newImage("images/cellgreen.png")
	}


	imgCursor = love.graphics.newImage("images/cursor.png")

	imgSquare = love.graphics.newImage("images/square.png")
	
	imgSheepolution = love.graphics.newImage("images/sheepolution.png")
	imgLogo = love.graphics.newImage("images/logo.png")
	imgLove = love.graphics.newImage("images/love.png")
	imgDesura = love.graphics.newImage("images/desura.png")
	imgItch = love.graphics.newImage("images/itchio.png")

	imgGo = love.graphics.newImage("images/go.png")
	imgReplay = love.graphics.newImage("images/replay.png")
	imgPlay = love.graphics.newImage("images/play.png")
	imgMenu = love.graphics.newImage("images/menu.png")
	imgBack = love.graphics.newImage("images/back.png")
	imgSoundOn = love.graphics.newImage("images/soundon.png")
	imgSoundOff = love.graphics.newImage("images/soundoff.png")
	imgLeave = love.graphics.newImage("images/leave.png")
	imgStop = love.graphics.newImage("images/stop.png")
	imgStart = love.graphics.newImage("images/start.png")
	imgTutorial = love.graphics.newImage("images/tutorial.png")
	imgSingleplayer = love.graphics.newImage("images/1player.png")
	imgVSCPU = love.graphics.newImage("images/pvcpu.png")
	imgOnline = love.graphics.newImage("images/online.png")
	imgColorblind = love.graphics.newImage("images/colorblind.png")
	img2Players = love.graphics.newImage("images/pvp.png")
	img3Players = love.graphics.newImage("images/3players.png")
	img4Players = love.graphics.newImage("images/4players.png")
	img1CPU = love.graphics.newImage("images/1cpu.png")
	img2CPU = love.graphics.newImage("images/2cpu.png")
	img3CPU = love.graphics.newImage("images/3cpu.png")
	imgPlus1 = love.graphics.newImage("images/plus1cpu.png")
	imgPlus2 = love.graphics.newImage("images/plus2cpu.png")
	imgSmall = love.graphics.newImage("images/small.png")
	imgMedium = love.graphics.newImage("images/medium.png")
	imgBig = love.graphics.newImage("images/big.png")
	imgScreen = love.graphics.newImage("images/fullscreen.png")
	imgReplayLevel = love.graphics.newImage("images/replaylevel.png")
	imgNewLevel = love.graphics.newImage("images/newlevel.png")
	
	imgTime = {
		love.graphics.newImage("images/time1.png"),
		love.graphics.newImage("images/time2.png"),
		love.graphics.newImage("images/time3.png"),
		love.graphics.newImage("images/time4.png")
	}

	imgTutPages = {
		love.graphics.newImage("images/tutorialpage1.png"),
		love.graphics.newImage("images/tutorialpage2.png"),
		love.graphics.newImage("images/tutorialpage3.png"),
		love.graphics.newImage("images/tutorialpage4.png"),
		love.graphics.newImage("images/tutorialpage5.png")
	}

	--audio
	sndMain = love.audio.newSource("sounds/maintheme.mp3")
	sndMain:setLooping(true)
	sndMain:setVolume(0)
	love.audio.play(sndMain)

	--fonts
	fontStandard = love.graphics.setNewFont("images/squarefont.ttf",20)
	love.graphics.setFont(fontStandard)

	--data
	dataNames = {
	"Red",
	"Blue",
	"Yellow",
	"Green"
	}

	dataSquares = {
	{175,0,0},
	{30,60,150},
	{220,160,20},
	{0,150,0}
	}

	m_abs = math.abs
	m_random = math.random
	m_floor = math.floor
	m_ceil = math.ceil


	love.mouse.setVisible(false)

	highscores = {}

	if love.filesystem.exists("highscores.sav") then -- Checks if the file exists
      filehs = love.filesystem.read("highscores.sav") -- Reads the file to get the name
   else
      love.filesystem.newFile("highscores.sav") -- Create a new file
      filehs = "0,0,0,0,0"
      love.filesystem.write("highscores.sav", filehs) -- Write the empty name
   end
   	local index = 1
   	for value in string.gmatch(filehs,"%w+") do 
    	highscores[index] = value
    	index = index + 1
	end
	for i=1,5 do
		if (highscores[i]==nil) then
			highscores[i]=0
		end
	end


	vsAI = false
	numberOfPlayers = 4
	size = 0
	single = false
	description = "Welcome to HOX"
	result = ""
	white = false
	filled = 0
	timeleft = 0
	currentTutPage = 1
	OS = love._os
	soundOn = true
	colorblind = false
	fadecolor = 0
	gametime = 3
	lights = false
	sheep = false
	cells = false


	gamestate = "intro"
	intro_load()
	if (gamestate == "game") then
		game_load(true,0,4,false,false)
	end

end

function love.update(dt)
	dt = math.min(dt,0.0166667)
	xMouse = love.mouse.getX()
	yMouse = love.mouse.getY()
	if (gamestate == "intro") then
		intro_update(dt)
	end
	if (gamestate == "game") then
		game_update(dt)
	end
end

function love.draw()
	if (gamestate == "intro") then
		intro_draw()
	elseif (gamestate == "menu") then
		menu_draw()
	elseif (gamestate == "game") then
	game_draw()
	end
	love.graphics.setColor(255,255,255)
	love.graphics.setBlendMode("alpha")
	if (gamestate ~= "intro") then
		love.graphics.draw(imgCursor, xMouse, yMouse,0,1,1,7.5,7.5)
	end
end

function love.keypressed(key)
	if (gamestate == "intro") then
		if (key=="return") then
			gamestate = "game"
			game_load(true,0,4)
		end
	end
	if (key=="r") then
		game_load(true,0,4)
		gamestate = "game"
	end
	if (key==" ") then
		lights = not lights
	end
end

function love.mousereleased(x,y,button)
	if (gamestate == "intro") then
		gamestate = "game"
		game_load(true,0,4,false,false)
		return
	end
	if (gamestate == "menu") then
		menu_mousepressed(x,y,button)
	elseif (gamestate == "game") then
		game_mousereleased(x,y,button)
	end

end