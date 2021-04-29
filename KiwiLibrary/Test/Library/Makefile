#
# Makefile
#

config_opt	= -c eslintrc.json
lib_dir		= ../../Resource/Library

srcs		= $(lib_dir)/Data.js \
		  $(lib_dir)/Debug.js \
		  $(lib_dir)/File.js \
		  $(lib_dir)/Graphics.js \
		  $(lib_dir)/Curses.js \
		  $(lib_dir)/Math.js \
		  $(lib_dir)/Process.js \
		  $(lib_dir)/String.js \
		  $(lib_dir)/Turtle.js

all: test.js
	eslint $(config_opt) test.js

clean:
	rm -f test.js

test.js: $(srcs)
	cat $^ > $@

