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

suit = require "lib.suit"

function love.load()
end

function love.update(dt)
	suit.layout:reset(love.graphics.getWidth() / 2 - 100, love.graphics.getHeight() / 2 - 15 * 3)
	suit.layout:padding(10, 10)
	suit.Label("Running out of space!", suit.layout:row(200, 30))
	if suit.Button("Start the Game", suit.layout:row()).hit then
		print("Starting the game")
	end
	if suit.Button("Quit", suit.layout:row()).hit then
		love.event.quit(0)
	end
end

function love.draw()
	-- draw the SUIT GUI
	suit.draw()
end

function love.keypressed(key)
	-- process key input
	if key == "escape" then
		love.event.quit(0)
	end
end
