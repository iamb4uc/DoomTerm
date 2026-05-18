# doomterm - DoomTerm terminal
# See LICENSE file for copyright and license details.
.POSIX:

include config.mk

SRC = doomterm.c x.c
OBJ = $(SRC:.c=.o)

all: options doomterm

options:
	@echo doomterm build options:
	@echo "CFLAGS  = $(STCFLAGS)"
	@echo "LDFLAGS = $(STLDFLAGS)"
	@echo "CC      = $(CC)"

config.h:
	cp config.def.h config.h

.c.o:
	$(CC) $(STCFLAGS) -c $<

doomterm.o: config.h doomterm.h win.h
x.o: arg.h config.h doomterm.h win.h

$(OBJ): config.h config.mk

doomterm: $(OBJ)
	$(CC) -o $@ $(OBJ) $(STLDFLAGS)

clean:
	rm -f doomterm $(OBJ) doomterm-$(VERSION).tar.gz

dist: clean
	mkdir -p doomterm-$(VERSION)
	cp -R FAQ LEGACY TODO LICENSE Makefile README config.mk\
		config.h doomterm.info doomterm.1 arg.h doomterm.h win.h $(SRC)\
		doomterm-$(VERSION)
	tar -cf - doomterm-$(VERSION) | gzip > doomterm-$(VERSION).tar.gz
	rm -rf doomterm-$(VERSION)

install: doomterm
	mkdir -p $(DESTDIR)$(PREFIX)/bin
	cp -f doomterm $(DESTDIR)$(PREFIX)/bin
	chmod 755 $(DESTDIR)$(PREFIX)/bin/doomterm
	mkdir -p $(DESTDIR)$(MANPREFIX)/man1
	sed "s/VERSION/$(VERSION)/g" < doomterm.1 > $(DESTDIR)$(MANPREFIX)/man1/doomterm.1
	chmod 644 $(DESTDIR)$(MANPREFIX)/man1/doomterm.1
	tic -sx doomterm.info
	@echo Please see the README file regarding the terminfo entry of doomterm.
	mkdir -p $(DESTDIR)$(APPPREFIX)
	cp -f doomterm.desktop $(DESTDIR)$(APPPREFIX)

uninstall:
	rm -f $(DESTDIR)$(PREFIX)/bin/doomterm
	rm -f $(DESTDIR)$(APPPREFIX)/doomterm.desktop
	rm -f $(DESTDIR)$(MANPREFIX)/man1/doomterm.1

.PHONY: all options clean dist install uninstall
