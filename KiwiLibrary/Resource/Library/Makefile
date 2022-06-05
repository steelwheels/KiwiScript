#
# Makefile
#

srcs	= Object.ts \
	  Array.ts \
	  Table.ts \
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
decls	= $(srcs:.ts=.d.ts) \
		  Enum.d.ts

dstdecl	= ./types/KiwiLibrary.d.ts

tsc	= npx tsc
tsc_opt	= -t ES2017 --lib "es2017" --declaration --declarationDir types \
	  --typeRoots types \
	  --alwaysStrict --strict --strictNullChecks --pretty


%.js: %.ts
	$(tsc) $(tsc_opt) $<

all: $(dsts) $(dstdecl)

$(dstdecl): types/Enum.d.ts
	(cd types && cat Builtin.d.ts $(decls)) > $@

types/Enum.d.ts: dummy
	if [ -x ~/tools/bin/jsdecl ] ; then \
		~/tools/bin/jsdecl -b > $@ ; \
	fi

clean:
	rm -f $(dsts)

dummy:

