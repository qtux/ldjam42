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
local board, snakes, cell_size

function game:enter()
	cell_size = vector(32, 32)
	-- define board
	board = {offset=cell_size, size=vector(16, 16), cells={}, intervall=0.15, min_intervall=0.03}
	for x = 0, board.size.x - 1 do
		board.cells[x] = {}
		for y = 0, board.size.y - 1 do
			board.cells[x][y] = " "
		end
	end
	-- define snake and add it to the board
	snakes = {}
	for i = 1, 2 do
		table.insert(snakes, {
			segments={vector(5, i * 5), vector(4, i * 5), vector(3, i * 5), vector(2, i * 5), vector(1, i * 5)},
			dir=vector(1, 0),
			cooldown=false,
			lost=false
		})
	end
	for i, snake in ipairs(snakes) do
		for _, vec in ipairs(snake.segments) do
			board.cells[vec.x][vec.y] = i
		end
	end
	timer.after(board.intervall, update_game)
	timer.tween(60, board, {intervall=board.min_intervall}, "linear")
end

function update_game()
	-- update snakes
	for i, snake in ipairs(snakes) do
		-- determine new snake head
		local head = snake.segments[1] + snake.dir
		head.x = head.x % board.size.x
		head.y = head.y % board.size.y

		-- keep tail if head is on food
		local tail = snake.segments[#snake.segments]
		if board.cells[head.x][head.y] == "u" then
			table.insert(snake.segments, tail)
		else
			board.cells[tail.x][tail.y] = " "
		end

		-- update internal snake representation and reset snake cooldown
		for j = #snake.segments, 2, -1 do
			snake.segments[j] = snake.segments[j - 1]
		end
		snake.segments[1] = head
		snake.cooldown = false
	end
	-- update board cells with new snake heads
	for i, snake in ipairs(snakes) do
		board.cells[snake.segments[1].x][snake.segments[1].y] = i
	end

	-- check for snake head in own snake body
	for i, snake in ipairs(snakes) do
		for j = 2, #snake.segments do
			if snake.segments[1] == snake.segments[j] then
				snake.loss = true
				print("snake", i, "crashed into itself")
			end
		end
	end

	-- check for overlapping snakes
	for i = 1, #snakes do
		for j = i + 1, #snakes do
			for _, segment in ipairs(snakes[i].segments) do
				for _, other_segment in ipairs(snakes[j].segments) do
					if segment == other_segment then
						if segment == snakes[i].segments[1] then
							snakes[i].loss = true
							print("snake", i, "crashed into another snake")
						end
						if other_segment == snakes[j].segments[1] then
							snakes[j].loss = true
							print("snake", j, "crashed into another snake")
						end
					end
				end
			end
		end
	end

	-- stop game if at least one of the snakes lost the game
	for i, snake in ipairs(snakes) do
		if snake.loss then
			timer.clear()
			return
		end
	end

	-- place random food
	if math.random() > 0.98 then
		local x, y
		repeat
			x, y = math.random(0, board.size.x - 1), math.random(0, board.size.y - 1)
			-- check for collision with snake
			local collides = false
			for _, snake in ipairs(snakes) do
				for _, vec in ipairs(snake.segments) do
					collides = collides or (vec.x == x and vec.y == y)
				end
			end
		until not collides
		board.cells[x][y] = "u"
	end

	timer.after(board.intervall, update_game)
end

function game:update(dt)
	suit.layout:reset(love.graphics.getWidth() / 2 - 100, love.graphics.getHeight() / 2 - 15 * 3)
	suit.layout:padding(10, 10)
	timer.update(dt)
end

function game:keypressed(key)
	if key == "a" and not snakes[1].cooldown then
		snakes[1].dir = vector(snakes[1].dir.y, -snakes[1].dir.x)
		snakes[1].cooldown = true
	elseif key == "d" and not snakes[1].cooldown then
		snakes[1].dir = vector(-snakes[1].dir.y, snakes[1].dir.x)
		snakes[1].cooldown = true
	end
	if key == "left" and not snakes[2].cooldown then
		snakes[2].dir = vector(snakes[2].dir.y, -snakes[2].dir.x)
		snakes[2].cooldown = true
	elseif key == "right" and not snakes[2].cooldown then
		snakes[2].dir = vector(-snakes[2].dir.y, snakes[2].dir.x)
		snakes[2].cooldown = true
	end
end

function game:draw()
	-- draw the board
	for x = 0, #board.cells do
		for y = 0, #board.cells[x] do
			point = board.offset + vector(x, y):permul(cell_size)
			if board.cells[x][y] == " " then
				love.graphics.setColor(0.1, 0.1, 0.3)
				love.graphics.rectangle("fill", point.x, point.y, cell_size.x, cell_size.y)
				love.graphics.setColor(0.5, 0.5, 0.5)
				love.graphics.rectangle("line", point.x, point.y, cell_size.x, cell_size.y)
			elseif board.cells[x][y] == "u" then
				love.graphics.setColor(0, 1, 0)
				love.graphics.rectangle("fill", point.x, point.y, cell_size.x, cell_size.y)
			elseif board.cells[x][y] == 1 then
				love.graphics.setColor(1, 0, 0)
				love.graphics.rectangle("fill", point.x, point.y, cell_size.x, cell_size.y)
			elseif board.cells[x][y] == 2 then
				love.graphics.setColor(0, 0, 1)
				love.graphics.rectangle("fill", point.x, point.y, cell_size.x, cell_size.y)
			end
		end
	end
	-- draw the SUIT GUI
	suit.draw()
end

return game
