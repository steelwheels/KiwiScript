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

dsts	= $(srcs:.ts=.js)
decls	= $(srcs:.ts=.d.ts)

dstdecl	= ./types/KiwiLibrary.d.ts

tsc	= npx tsc
tsc_opt	= -t ES2017 --lib "es2017" --declaration --declarationDir types \
	  --typeRoots types \
	  --alwaysStrict --strict --strictNullChecks --pretty


%.js: %.ts
	$(tsc) $(tsc_opt) $<

all: types/Enum.d.ts $(dsts) $(dstdecl)

$(dstdecl): types/Enum.d.ts types/Builtin.d.ts
	(cd types && cat Enum.d.ts Builtin.d.ts $(decls)) > $@

types/Enum.d.ts: dummy
	(cd types && rm -f ./enum-*.d.ts && ~/tools/bin/edecl)
	cat types/enum-*.d.ts > $@

clean:
	rm -f $(dsts) $(dstdecl)
	rm -f types/enum-*.d.ts

dummy:

