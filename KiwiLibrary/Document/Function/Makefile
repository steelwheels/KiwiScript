#
#
#

project_dir	= ../..
library_dir	= $(project_dir)/Resource/Library
script_dir	= ../../../Script

m4_cmd	= m4 --prefix-builtins \
	     --include=$(library_dir) \
	     --include=./ \
	     $(script_dir)/m4_header.m4

%.md: %.md4
	$(m4_cmd) $< > $@

srcs	= Graphics.md4 \
	  Network.md4
dsts	= $(srcs:.md4=.md)

all: $(dsts)

clean:
	rm -f $(dsts)

Graphics.md: Graphics.md4 $(library_dir)/Graphics.js

