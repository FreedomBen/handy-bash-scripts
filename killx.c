#include <stdio.h>
#include <stdlib.h>

size_t main( size_t argc, char **argv )
{
    size_t userid = getuid();
    setuid( geteuid() );
    system( "killall Xorg" );
    // system( "kill -9 $(ps -A | grep X | awk '{print $1}')" );
    setuid( userid );
}
