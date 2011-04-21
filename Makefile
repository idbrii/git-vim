UNAME := $(shell uname)

ifeq ($(UNAME), Darwin)
	INSTALL=ginstall # For MacOS X with gnu ports
else
	INSTALL=install
endif
INSTALL_FILE=${INSTALL} -m 0644 -v -D

FILES_FOR_INSTALL= $(wildcard plugin/git*.vim) \
		   $(wildcard syntax/git*.vim) \
		   $(wildcard doc/git*.txt)
DEST=${HOME}/.vim

.PHONY: default
default: help

.PHONY: help
help:
	@echo "git-vim"
	@echo
	@echo "To install run:"
	@echo "    make install"
	@echo
	@echo "To uninstall run:"
	@echo "    make uninstall"
	@echo
	@echo "It will install the following files in ${DEST}:"
	@for f in ${FILES_FOR_INSTALL} ; do \
		if ! test -f "${DEST}/$$f" ; then \
			echo -n "   " ; \
		elif ! diff -q "$$f" "${DEST}/$$f" > /dev/null ; then \
			echo -n " * " ; \
		else \
			echo -n " = " ; \
		fi ; \
		echo "$$f" ; \
	done

.PHONY: install
install:
	@for f in ${FILES_FOR_INSTALL} ; do \
		${INSTALL_FILE} "$$f" "${DEST}/$$f" ; \
	done
	@echo
	@echo "git-vim installed in ${DEST}"

.PHONY: uninstall
uninstall:
	@for f in ${FILES_FOR_INSTALL} ; do \
		rm -v -f "${DEST}/$$f" ; \
	done
	@echo
	@echo "git-vim removed from ${DEST}"

.PHONY: test
test:
	@runVimTests tests

