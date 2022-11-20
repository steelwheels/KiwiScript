# install_all.mk

build_mk	= ../../Script/build.mk
install_tool_mk	= ../../Script/install_tool.mk

all: res0 engine tools lib shell

res0: dummy
	(cd KiwiLibrary/Resource/Library/ && make)

engine: dummy
	(cd KiwiEngine/Project  && make -f $(build_mk))

tools: dummy
	(cd KiwiTools/Project   && make -f $(install_tool_mk) install_tools)

lib: dummy
	(cd KiwiLibrary/Project && make -f $(build_mk))

shell: KiwiShell/Resource/Library/types/KiwiLibrary.d.ts
	(cd KiwiShell/Project   && make -f $(build_mk))

KiwiShell/Resource/Library/types/KiwiLibrary.d.ts: \
	    KiwiLibrary/Resource/Library/types/KiwiLibrary.d.ts
	cp $< $@

dummy:

