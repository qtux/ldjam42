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

local suit = require "lib.suit"

local game = {}

function game:update(dt)
	suit.layout:reset(love.graphics.getWidth() / 2 - 100, love.graphics.getHeight() / 2 - 15 * 3)
	suit.layout:padding(10, 10)
	suit.Label("Running the game!", suit.layout:row(200, 30))
end

function game:draw()
	-- draw the SUIT GUI
	suit.draw()
end

return game
