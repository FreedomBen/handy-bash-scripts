#include <stdio.h>

int main( int argc, char **argv )
{
    if( argc == 1 )
    {
        system( "iwconfig wlan0" );
        printf( "\nIf you want to set the Tx Power, rerun with 1 arg\n" );
    }
    else if( argc == 2 )
    {
        char str[150];
        snprintf( str, 149, "iwconfig wlan0 txpower %s", argv[1] );
        int userid = getuid();
        setuid( 0 );
        system( str );
        setuid( userid );
        system( "iwconfig wlan0" );
        printf( "\nSet Tx Power to: %s\n", argv[1] );
    }
    else
    {
        printf( "\nerror\n" );
    }
}
