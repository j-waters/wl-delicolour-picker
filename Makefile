.PHONY: install uninstall

all:
	@echo "Nothing to compile. Use 'make [DESTDIR=dir] install' to install wl-delicolour-picker."

install:
	@if [ "$$DESTDIR" = "" ]; then \
		if [ "$$(id -u)" -ne 0 ]; then \
			echo "Please execute this script as root."; \
			exit 1; \
		fi; \
	fi;

	@depends="grim slurp convert wl-copy delicolour"; \
	for dependency in $$(echo "$$depends" | xargs) ; do \
		echo "Checking for: $$dependency."; \
		if ! which "$$dependency" > /dev/null 2>&1 ; then \
			echo "  error: Required dependency '$$dependency' is missing."; \
			exit 1; \
		else \
			echo "  '$$dependency' found!"; \
		fi; \
	done;

	@echo

	@if [ -e "$$DESTDIR/usr/bin/wl-delicolour-picker" ]; then \
		echo "Please un-install the previous version first"; \
		exit 1; \
	fi; \

	@if [ ! -d "$$DESTDIR/usr/bin" ]; then \
		mkdir -p "$$DESTDIR/usr/bin"; \
	fi;

	@if [ ! -d "$$DESTDIR/usr/share/applications" ]; then \
		mkdir -p "$$DESTDIR/usr/share/applications"; \
	fi;

	@if [ ! -d "$$DESTDIR/usr/share/icons" ]; then \
		mkdir -p "$$DESTDIR/usr/share/icons"; \
	fi;

	@if [ ! -d "$$DESTDIR/usr/share/icons/hicolor/scalable/apps" ]; then \
		mkdir -p "$$DESTDIR/usr/share/icons/hicolor/scalable/apps"; \
	fi;

	@echo 'Copying wl-delicolour-picker'
	@echo

	cp wl-delicolour-picker.sh "$$DESTDIR/usr/bin/wl-delicolour-picker"
	cp wl-delicolour-picker.png "$$DESTDIR/usr/share/icons/"
	cp wl-delicolour-picker.svg "$$DESTDIR/usr/share/icons/hicolor/scalable/apps/"
	cp wl-delicolour-picker.desktop "$$DESTDIR/usr/share/applications/"

	@echo
	@echo 'Done!'

	@exit 0

uninstall:
	@if [ "$$(id -u)" != "0" ]; then \
		echo "Please execute uninstallation as root."; \
		exit 1; \
	fi;

	@echo 'Uninstalling wl-delicolour-picker'
	@echo

	rm "/usr/bin/wl-delicolour-picker"
	rm "/usr/share/icons/wl-delicolour-picker.png"
	rm "/usr/share/icons/hicolor/scalable/apps/wl-delicolour-picker.svg"
	rm "/usr/share/applications/wl-delicolour-picker.desktop"

	@echo
	@echo 'Done!'
