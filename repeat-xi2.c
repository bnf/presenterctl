#include <stdlib.h>
#include <X11/X.h>
#include <X11/XKBlib.h>

int
main(int argc, char *argv[])
{
	Display *dpy;
	XkbDescPtr xkb;
	unsigned int id, delay, interval;

	if (argc < 4)
		exit(1);

	id = atoi(argv[1]);
	delay = atoi(argv[2]);
	interval = atoi(argv[3]);

	dpy = XOpenDisplay(NULL);
	if (!dpy)
		exit(2);

	xkb = XkbGetKeyboard(dpy, XkbControlsMask, id);
	if (!xkb)
		exit(3);

	/* With X.Org-Server 1.13.1 on Gentoo ctrls is unexpectedly NULL. */
	if (!xkb->ctrls)
		XkbGetControls(dpy, XkbRepeatKeysMask, xkb);

	xkb->ctrls->repeat_delay = delay;
	xkb->ctrls->repeat_interval = 1000 / interval;

	XkbSetControls(dpy, XkbRepeatKeysMask, xkb);
	XkbFreeKeyboard(xkb, 0, True);

	XCloseDisplay(dpy);

	return 0;
}
