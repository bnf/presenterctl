all: repeat-xi2

%: %.c
	gcc -ggdb -Wall $(shell pkg-config --libs --cflags x11) $< -o $@
