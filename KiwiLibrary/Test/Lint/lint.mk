#
#
#

LIB_DIR		= ../../Resource/Library/

SRCS		= $(LIB_DIR)/Debug.js \
		  $(LIB_DIR)/Math.js \
		  $(LIB_DIR)/Graphics.js \
		  $(LIB_DIR)/Operation.js \
		  $(LIB_DIR)/SpriteAction.js \
		  $(LIB_DIR)/SpriteStatus.js \
		  $(LIB_DIR)/SpriteCondition.js \
		  $(LIB_DIR)/SpriteOperation.js

lint: $(SRCS)
	eslint --config eslintrc.json $(SRCS)

