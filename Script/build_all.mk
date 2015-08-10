#
# build_all.mk
#

all: KiwiEngine KiwiLibraries

KiwiLibraries : KLConsole

KiwiEngine : dummy
	(cd KiwiEngine/OSX ; \
	 export PROJECT_NAME="KiwiEngine" ; \
	 make -f ../../Script/install_osx.mk)

KLConsole : dummy
	(cd KiwiLibraries/KLConsole/OSX ; \
	 export PROJECT_NAME="KLConsole" ; \
	 make -f ../../../Script/install_osx.mk)

dummy:

