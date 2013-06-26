SHELL = /bin/bash
INSTALL = /usr/bin/install -c
DESTDIR =
confdir = /etc
icons = /usr/share/pixmaps
config = /usr/share/pacnotify
bin = /usr/bin

all:

install: all
	$(INSTALL) -d $(DESTDIR)$(config)
	$(INSTALL) -d $(DESTDIR)$(icons)
	$(INSTALL) -m755 pacnotify.conf $(DESTDIR)$(confdir)
	$(INSTALL) -m644 LICENSE $(DESTDIR)$(config)
	$(INSTALL) -m644 README $(DESTDIR)$(config)
	$(INSTALL) -m644 pacnotify32.png $(DESTDIR)$(icons)
	$(INSTALL) -m644 pacnotify $(DESTDIR)$(bin)
