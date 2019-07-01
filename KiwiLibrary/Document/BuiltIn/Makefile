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

all: SpriteAction.md SpriteStatus.md SpriteCondition.md

clean:
	rm -f SpriteAction.md SpriteStatus.md SpriteCondition.md

SpriteAction.md: SpriteAction.md4 $(library_dir)/SpriteAction.js

SpriteStatus.md: SpriteStatus.md4 $(library_dir)/SpriteStatus.js

SpriteCondition.md: SpriteCondition.md4 $(library_dir)/SpriteCondition.js

