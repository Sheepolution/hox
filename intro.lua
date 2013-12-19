function intro_load()
	intro_color = 0
	intro_state = 1
	intro_time = 2
	show_love = false

end

function intro_update(dt)
	if (intro_state == 1) then
		intro_color = intro_color + 200 * dt
		if (intro_color>=250) then
		intro_state = 2
		end
	end

	if (intro_state == 2) then
		intro_time = intro_time - 1 * dt
		if (intro_time<0) then
			intro_state = 3
		end
	end

	if (intro_state == 3) then
		intro_color = intro_color - 200 * dt
		if (intro_color<=5) then
			if (show_love) then
				gamestate = "game"
				game_load(true,0,4,false,false)
			else
				intro_color = 0
				intro_state = 1
				show_love = true
				intro_time = 2
			end
		end
	end
end

function intro_draw()
	love.graphics.setColor(intro_color,intro_color,intro_color)
	if (show_love) then
		love.graphics.draw(imgLove, 0,0)
	else
		love.graphics.draw(imgSheepolution, 299,171)
	end

end