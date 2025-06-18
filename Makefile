HOME=$(shell echo $$HOME)

xmonad:
	stack build

install:
	stack install
	ln -s $(HOME)/Code/xmonad-exe/build $(HOME)/.config/xmonad/build
