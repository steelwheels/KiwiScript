#
# Makefile
#

srcs	= Object.ts \
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
decls	= $(srcs:.ts=.d.ts)

dstdecl	= ./types/KiwiLibrary.d.ts

tsc	= npx tsc
tsc_opt	= -t ES2017 --lib "es2017" --declaration --declarationDir types \
	  --typeRoots types \
	  --alwaysStrict --strict --strictNullChecks --pretty


%.js: %.ts
	$(tsc) $(tsc_opt) $<

all: $(dsts) $(dstdecl)

$(dstdecl): dummy
	(cd types && cat Builtin.d.ts $(decls)) > $@

clean:
	rm -f $(dsts)

dummy:

