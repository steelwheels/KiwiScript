# install_xc.mk

PROJECT_NAME	?= KiwiTools
BUNDLE_PATH	= $(HOME)/tools/bundles
BIN_PATH	= $(HOME)/tools/bin

all: dummy
	echo "usage: make install_bundle or make install_tools"

install_bundle: dummy
	xcodebuild install \
	  -scheme $(PROJECT_NAME)Bundle \
	  -project $(PROJECT_NAME).xcodeproj \
	  -destination="macOSX" \
	  -configuration Release \
	  -sdk macosx \
	  BUILD_LIBRARY_FOR_DISTRIBUTION=YES \
	  INSTALL_PATH=$(BUNDLE_PATH) \
	  SKIP_INSTALL=NO \
	  DSTROOT=/ \
	  ONLY_ACTIVE_ARCH=NO

install_tools: install_edecl

install_edecl: dummy
	xcodebuild install \
	  -scheme edecl \
	  -project $(PROJECT_NAME).xcodeproj \
	  -destination="macOSX" \
	  -configuration Release \
	  -sdk macosx \
	  BUILD_LIBRARY_FOR_DISTRIBUTION=YES \
	  INSTALL_PATH=$(BIN_PATH) \
	  SKIP_INSTALL=NO \
	  DSTROOT=/ \
	  ONLY_ACTIVE_ARCH=NO

dummy:

