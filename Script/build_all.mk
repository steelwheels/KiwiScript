#
# build_all.mk
#

all: stdlib engine jsrunner

stdlib : dummy
	(cd KiwiStdlib/OSX ; \
	 export PROJECT_NAME="KiwiStdlib" ; \
	 make -f ../../Script/install_osx.mk)

engine : dummy
	(cd KiwiEngine/OSX ; \
	 export PROJECT_NAME="KiwiEngine" ; \
	 make -f ../../Script/install_osx.mk)

jsrunner : dummy
	(cd JSRunner/OSX ; \
	 export PROJECT_NAME="JSRunner" ; \
	 make -f ../../Script/install_osx.mk)

dummy:

