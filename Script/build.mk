#
# build_all.mk
#

all: KiwiEngine KSStdLib

KiwiEngine : dummy
	(cd KiwiEngine/OSX ; \
	 export PROJECT_NAME="KiwiEngine" ; \
	 make -f ../../Script/install_osx.mk)

KSStdLib : dummy
	(cd KSStdLib/OSX ; \
	 export PROJECT_NAME="KSStdLib" ; \
	 make -f ../../Script/install_osx.mk)

dummy:

