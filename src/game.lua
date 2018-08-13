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
local vector = require "lib.hump.vector"
local timer = require "lib.hump.timer"

local game = {}
local board, snake, cell_size

function game:enter()
	cell_size = vector(32, 32)
	-- define board
	board = {width=16, height=16, cells={}}
	for x = 0, board.width - 1 do
		board.cells[x] = {}
		for y = 0, board.height - 1 do
			board.cells[x][y] = " "
		end
	end
	-- define snake and add it to the board
	snake = {
		segments={vector(5, 0), vector(4, 0), vector(3, 0), vector(2, 0), vector(1, 0)},
		dir=vector(1, 0),
		cooldown=false
	}
	for _, vec in ipairs(snake.segments) do
		board.cells[vec.x][vec.y] = "s"
	end
	timer.every(0.1, update_game)
end

function update_game()
	-- determine new snake head
	local head = snake.segments[1] + snake.dir
	head.x = head.x % board.width
	head.y = head.y % board.height
	local tail = snake.segments[#snake.segments]

	-- test if head touches body
	for _, vec in ipairs(snake.segments) do
		if head == vec then
			print("GAMEOVER")
		end
	end

	-- update tail and head (keep tail if head is on food)
	if board.cells[head.x][head.y] == "u" then
		table.insert(snake.segments, tail)
	else
		board.cells[tail.x][tail.y] = " "
	end
	-- update head in any case
	board.cells[head.x][head.y] = "s"
	-- update internal snake representation and reset snake cooldown
	for i = #snake.segments, 2, -1 do
		snake.segments[i] = snake.segments[i - 1]
	end
	snake.segments[1] = head
	snake.cooldown = false

	-- place random food
	if math.random() > 0.98 then
		local x, y
		repeat
			x, y = math.random(0, board.width - 1), math.random(0, board.height - 1)
			-- check for collision with snake
			local collides = false
			for _, vec in ipairs(snake.segments) do
				collides = collides or (vec.x == x and vec.y == y)
			end
		until not collides
		board.cells[x][y] = "u"
	end
end

function game:update(dt)
	suit.layout:reset(love.graphics.getWidth() / 2 - 100, love.graphics.getHeight() / 2 - 15 * 3)
	suit.layout:padding(10, 10)
	timer.update(dt)
end

function game:keypressed(key)
	if love.keyboard.isDown("a") and not snake.cooldown then
		snake.dir = vector(snake.dir.y, -snake.dir.x)
		snake.cooldown = true
	elseif love.keyboard.isDown("d") and not snake.cooldown then
		snake.dir = vector(-snake.dir.y, snake.dir.x)
		snake.cooldown = true
	end
end

function game:draw()
	offset = cell_size
	-- draw the board
	for x = 0, #board.cells do
		for y = 0, #board.cells[x] do
			point = offset + vector(x, y):permul(cell_size)
			if board.cells[x][y] == " " then
				love.graphics.setColor(0.1, 0.1, 0.3)
				love.graphics.rectangle("fill", point.x, point.y, cell_size.x, cell_size.y)
				love.graphics.setColor(0.5, 0.5, 0.5)
				love.graphics.rectangle("line", point.x, point.y, cell_size.x, cell_size.y)
			elseif board.cells[x][y] == "s" then
				love.graphics.setColor(1, 0, 0)
				love.graphics.rectangle("fill", point.x, point.y, cell_size.x, cell_size.y)
			elseif board.cells[x][y] == "u" then
				love.graphics.setColor(0, 1, 0)
				love.graphics.rectangle("fill", point.x, point.y, cell_size.x, cell_size.y)
			end
		end
	end
	-- draw the SUIT GUI
	suit.draw()
end

return game
