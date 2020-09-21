# install_all.mk

build_mk = ../../Script/build.mk

all:
	(cd KiwiEngine/Project  && make -f $(build_mk))
	(cd KiwiLibrary/Project && make -f $(build_mk))
	(cd KiwiShell/Project   && make -f $(build_mk))
	
