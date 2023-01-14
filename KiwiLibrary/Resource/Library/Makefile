#
# Makefile
#

srcs	= Object.ts \
	  Array.ts \
	  File.ts \
	  Math.ts \
	  Debug.ts \
	  Graphics.ts \
	  Process.ts \
	  String.ts \
	  Curses.ts \
	  Turtle.ts \
	  Contacts.ts

intf_files	= types/Frame.d.ts \
		  types/intf-PointIF.d.ts \
		  types/intf-SizeIF.d.ts \
		  types/intf-RecordIF.d.ts \
		  types/intf-RectIF.d.ts \
		  types/intf-RangeIF.d.ts \
		  types/intf-TableDataIF.d.ts

dsts	= $(srcs:.ts=.js)
decls	= $(srcs:.ts=.d.ts)

dstdecl	= ./types/KiwiLibrary.d.ts

tsc	= npx tsc
tsc_opt	= -t ES2017 --lib "es2017" --declaration --declarationDir types \
	  --typeRoots types \
	  --alwaysStrict --strict --strictNullChecks --pretty


%.js: %.ts
	$(tsc) $(tsc_opt) $<

all:
	if [ -f ~/tools/bin/edecl ] ; then \
		make transpile ; \
	fi

transpile: exec_tool types/Enum.d.ts types/Intf.d.ts $(dsts) $(dstdecl) 

exec_tool: dummy
	(cd types && rm -f ./enum-*.d.ts ./intf-*.d.ts && ~/tools/bin/edecl)

types/Enum.d.ts: dummy
	cat types/enum-*.d.ts > $@

types/Intf.d.ts: $(intf_files)
	cat $(intf_files) > $@

$(dstdecl): types/Builtin.d.ts
	(cd types && cat Enum.d.ts Intf.d.ts Builtin.d.ts $(decls)) > $@

clean:
	rm -f $(dsts) $(dstdecl)
	rm -f types/enum-*.d.ts types/Enum.d.ts
	rm -f types/intf-*.d.ts types/Intf.d.ts

dummy:

