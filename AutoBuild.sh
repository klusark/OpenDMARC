#!/bin/sh

perform()
{
	$*
	status=$?
	if [ $status != 0 ]
	then
		echo Fatal ERROR: "\"$*\" failed."
		exit 1
	fi
}

case $1 in
clean)
	echo "Cleaning"
	if [ -f Makefile ]
	then
		perform "make -s clean"
	fi
	rm -f config.log
	rm -f config.status
	rm -f *.gz
	exit 0
	;;
dist)
	# Put extras here.
	if [ -f Makefile ]
	then
		make dist
	fi
	exit 0
	;;
*)
	;;
esac

echo "Building opendmarc"

if [ ! -f config.h.in -a -f config.h.in~ ]; then
    perform "cp config.h.in~ config.h.in"
fi

AUTOMAKE=automake
AUTOHEADER=autoheader
AUTOCONF=autoconf

for name in $AUTOHEADER $AUTOMAKE $AUTOCONF
do
	echo $name
	perform $name
done

CONF="./configure --with-wall  -q"
echo ${CONF}
perform "$CONF"
perform "make -s"
exit 0
