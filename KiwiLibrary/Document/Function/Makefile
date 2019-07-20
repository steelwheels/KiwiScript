#
#
#

project_dir	= ../..
library_dir	= $(project_dir)/Resource/Library
script_dir	= ../../../Script

m4_cmd	= m4 --prefix-builtins \
	     --include=$(library_dir) \
	     $(script_dir)/m4_header.m4

%.md: %.md4
	$(m4_cmd) $< > $@

all: Graphics.md

clean:
	rm -f Graphics.md

Graphics.md: Graphics.md4 $(library_dir)/Graphics.js

