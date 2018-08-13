# Snakevasion (Ludum Dare 42 - Running out of space)
#
# Copyright (C) 2018  Matthias Gazzari
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <https://www.gnu.org/licenses/>.

.SUFFIXES:

BUILDIR       = build
LOVE_FILE     = snakevasion.love
WIN32_BINARY  = snakevasion_win32.exe
WIN32_ZIP     = snakevasion_win32.zip

default: $(LOVE_FILE) $(WIN32_ZIP)
.PHONY: default

$(LOVE_FILE):
	zip -9 -r $@ . --exclude $(BUILDIR) \*.git\* \*docs\* \*.rockspec Makefile \*.travis.yml

$(WIN32_ZIP):
	mkdir -p $(BUILDIR)
	wget https://bitbucket.org/rude/love/downloads/love-11.1-win32.zip -O $(BUILDIR)/windows.zip
	unzip -o -j $(BUILDIR)/windows.zip -d $(BUILDIR)
	cat $(BUILDIR)/love.exe $(LOVE_FILE) > $(BUILDIR)/snakevasion_win32.exe
	zip -9 -r $@ $(BUILDIR) --exclude \*love.exe \*changes.txt \*readme.txt \*windows.zip

clean:
	rm -rf $(BUILDIR)
	rm -f $(LOVE_FILE)
	rm -f $(WIN32_ZIP)
