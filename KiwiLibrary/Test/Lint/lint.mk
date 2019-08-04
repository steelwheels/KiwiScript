#
#
#

LIB_DIR		= ../../Resource/Library/

SRCS		= $(LIB_DIR)/Debug.js \
		  $(LIB_DIR)/Math.js \
		  $(LIB_DIR)/Graphics.js \
		  $(LIB_DIR)/Operation.js

lint: $(SRCS)
	eslint --config eslintrc.json $(SRCS)

