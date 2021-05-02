# install_all.mk

build_mk = ../../Script/build.mk

all:
	(cd KiwiLibrary/Resource/Library/ && make)
	(cd KiwiEngine/Project  && make -f $(build_mk))
	(cd KiwiLibrary/Project && make -f $(build_mk))
	cp KiwiLibrary/Resource/Library/types/KiwiLibrary.d.ts \
	   KiwiShell/Resource/Library/types/
	(cd KiwiShell/Project   && make -f $(build_mk))

