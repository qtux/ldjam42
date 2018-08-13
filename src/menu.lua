--[[
Ludum Dare 42: Running out of space.

Copyright (C) 2018  Matthias Gazzari

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
]]--

local gamestate = require "lib.hump.gamestate"
local suit = require "lib.suit"

local menu = {}
local game, bg, offset

function menu:init()
	game = require "src.game"
	bg = love.graphics.newImage("assets/title.png")
	offset = {}
	offset.x = (love.graphics.getWidth() - bg:getWidth()) / 2
	offset.y = (love.graphics.getHeight() - bg:getHeight()) / 2
end

function menu:update(dt)
	suit.layout:reset(love.graphics.getWidth() / 2 - 100, love.graphics.getHeight() / 2 - 65)
	suit.layout:padding(10, 10)
	suit.Label("Running out of space!", suit.layout:row(200, 30))
	if suit.Button("Start the Game", suit.layout:row()).hit then
		gamestate.switch(game)
	end
	if suit.Button("Quit", suit.layout:row()).hit then
		love.event.quit(0)
	end
end

function menu:draw()
	love.graphics.draw(bg, offset.x, offset.y)
	-- draw the SUIT GUI
	suit.draw()
end

return menu
