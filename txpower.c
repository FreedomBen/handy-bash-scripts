#include <stdio.h>
#include <stdlib.h>
#include <string.h>

size_t isOnlyInts( size_t length, char *str )
{
    /* must be ascii 48 to 57 inclusive */
    size_t i;
    for( i=0; i<length; ++i )
    {
        if( str[i] == '\x00' )
            continue;

        if( str[i] < '0' || str[i] > '9' )
            return 0;
    }
    return 1;
}

size_t main( size_t argc, char **argv )
{
    if( argc == 1 )
    {
        // system( "iwconfig wlan0" );
        system( "iwconfig wlp8s0" );
        printf( "\nIf you want to set the Tx Power, rerun with 1 arg\n" );
    }
    else if( argc == 2 )
    {
        /* make sure argv[1] contains only integers for security.  Crap on the floor if it doesn't */
        if( isOnlyInts( strlen( argv[1] ), argv[1] ) )
        {
            size_t strSize = strlen( argv[1] ) + 30;
            char str[strSize];
            size_t i;
            for( i=0; i<strSize; ++i )
                str[i] = '\x00';

            // snprintf( str, strSize - 1, "iwconfig wlan0 txpower %s", argv[1] );
            snprintf( str, strSize - 1, "iwconfig wlp8s0 txpower %s", argv[1] );

            size_t userid = getuid();
            setuid( geteuid() );
            system( str );
            setuid( userid );
            // system( "iwconfig wlan0" );
            system( "iwconfig wlp8s0" );
            printf( "\nSet Tx Power to: %s\n", argv[1] );
            exit( 0 );
        }
        else
        {
            printf( "\nArg was invalid.  Must include only integers\n" );
            exit( 1 );
        }
    }
    else
    {
        printf( "\nError: Too many args\n" );
        exit( 1 );
    }
}
