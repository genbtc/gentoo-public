/*
 *  Main Stub
 *  Copyright (c) 2023 by genr8eofl <genBTC@gmx.com>
 *
 *
 *   This library is free software; you can redistribute it and/or modify
 *   it under the terms of the GNU Lesser General Public License as
 *   published by the Free Software Foundation; either version 2.1 of
 *   the License, or (at your option) any later version.
 *
 *   This program is distributed in the hope that it will be useful,
 *   but WITHOUT ANY WARRANTY; without even the implied warranty of
 *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *   GNU Lesser General Public License for more details.
 *
 *   You should have received a copy of the GNU Lesser General Public
 *   License along with this library; if not, write to the Free Software
 *   Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301  USA
 *
 */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <err.h>

static int verbose = 0;
static int debug = 0;
static int warning = 0;

static void usage(void) {
	fprintf(stderr, "usage: mainstub [-vdw] [file...]\n");
	exit(1);
}

static void read_filename(const char *file) {
	if (verbose)
		printf("file: %s passed ok via command line arguments\n", file);
}

int main(int argc, char **argv) {
	int c;

	while ((c = getopt(argc, argv, "vdw")) != -1) {
		switch (c) {
		case 'v':
			verbose = 1;
			break;
		case 'd':
			debug = 1;
			break;
		case 'w':
			warning = 1;
			break;
		case '?':
		default:
			usage();
			/* exit(1) */
		}
	}
	argc -= optind;
	argv += optind;

	if (argc < 1)
		read_filename(NULL);
	else
		while (*argv)
			read_filename(*argv++);

	return 0;
}
