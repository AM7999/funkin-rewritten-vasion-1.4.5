--[[----------------------------------------------------------------------------
This file is part of Friday Night Funkin' Rewritten

Copyright (C) 2021  HTV04

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <https://www.gnu.org/licenses/>.
------------------------------------------------------------------------------]]

local song, difficulty

local video

return {
	enter = function(self, from, songNum, songAppend)
		weeks:enter()

		song = songNum
		difficulty = songAppend

		healthBarColorEnemy = {175,102,206}

		video = love.graphics.newVideo("videos/pokemoan/pokemoan.ogv") 

		enemy = love.filesystem.load("sprites/week1/daddy-dearest.lua")()

		girlfriend.x, girlfriend.y = 30, -90
		enemy.x, enemy.y = -380, -110
		boyfriend.x, boyfriend.y = 260, 100

		enemyIcon:animate("daddy dearest", false)

		self:load()
	end,

	load = function(self)
		weeks:load()

		inst = love.audio.newSource("music/pokemoan/pokemoan-inst.ogg", "stream")
		voices = love.audio.newSource("music/pokemoan/pokemoan-voices.ogg", "stream")
		
		self:initUI()

		weeks:setupCountdown()
	end,

	initUI = function(self)
		weeks:initUI()

		weeks:generateNotes(love.filesystem.load("charts/pokemoan/pokemoan" .. difficulty .. ".lua")())
	end,

	update = function(self, dt)
		weeks:update(dt)

		if not  video:isPlaying() and not countingDown then
			video:play()
		end

		if health >= 80 then
			if enemyIcon:getAnimName() == "daddy dearest" then
				enemyIcon:animate("daddy dearest losing", false)
			end
		else
			if enemyIcon:getAnimName() == "daddy dearest losing" then
				enemyIcon:animate("daddy dearest", false)
			end
		end


		
	 	if not (countingDown or graphics.isFading()) and not inst:isPlaying() then
			storyMode = false

			graphics.fadeOut(
					0.5,
					function()
						Gamestate.switch(menu)

						status.setLoading(false)
					end
				)
		end

		weeks:updateUI(dt)
	end,

	draw = function(self)
		love.graphics.push()
			love.graphics.translate(graphics.getWidth() / 2, graphics.getHeight() / 2)
			love.graphics.scale(cam.sizeX, cam.sizeY)

			love.graphics.push()
				love.graphics.translate(cam.x * 0.9, cam.y * 0.9)


			love.graphics.pop()
			love.graphics.push()
				love.graphics.translate(cam.x, cam.y)

			love.graphics.pop()
			love.graphics.push()
				love.graphics.translate(cam.x * 1.1, cam.y * 1.1)

			love.graphics.pop()
			weeks:drawRating(0.9)
		love.graphics.pop()


		love.graphics.draw(video, 0, 0)
				weeks:drawUI()
	end,

	leave = function(self)
        video = nil
		boyfriend = nil
		girlfriend = nil
		enemy = nil
		weeks:leave()
	end
}