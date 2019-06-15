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

all: Operation.md

clean:
	rm -f Operation.md

Operation.md: Operation.md4 $(library_dir)/Operation.js
