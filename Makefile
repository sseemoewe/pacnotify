SHELL = /bin/bash
INSTALL = /usr/bin/install -c
DESTDIR =
icons = /usr/share/pixmaps
config = /usr/share/pacnotify
bindir = /usr/bin

all:

install: all
	$(INSTALL) -d $(DESTDIR)$(config)
	$(INSTALL) -d $(DESTDIR)$(icons)
	$(INSTALL) -d $(DESTDIR)$(bindir)
	$(INSTALL) -m744 pacnotify.conf $(DESTDIR)$(config)
	$(INSTALL) -m644 LICENSE $(DESTDIR)$(config)
	$(INSTALL) -m644 README $(DESTDIR)$(config)
	$(INSTALL) -m644 pacnotify32.png $(DESTDIR)$(icons)
	$(INSTALL) -m755 pacnotify $(DESTDIR)$(bindir)
