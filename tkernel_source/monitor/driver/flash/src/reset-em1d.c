/*
 *----------------------------------------------------------------------
 *    T-Kernel 2.0 Software Package
 *
 *    Copyright 2011 by Ken Sakamura.
 *    This software is distributed under the latest version of T-License 2.x.
 *----------------------------------------------------------------------
 *
 *    Released by T-Engine Forum(http://www.t-engine.org/) at 2011/05/17.
 *    Modified by TRON Forum(http://www.tron.org/) at 2015/06/01.
 *
 *----------------------------------------------------------------------
 */

/*
 *	reset.c
 *
 *       Reset and reboot after Flash ROM write
 */

#include "flash.h"
#include <tk/sysdef.h>

IMPORT void _start( void );	/* start address after reset */

/*
 * reset and reboot
 */
EXPORT void flashwr_reset( void )
{
#define	PAGETBL_BASE	(_UW *)0x30000000

	void (* volatile reset_p)( void ) = 0;

        /* Remap the NOR FlashROM area to its original space, and jump */
	*PAGETBL_BASE = 0x9402;	// Strongly-order, Kernel/RO
	DSB();
	// I/D TLB invalidate
	// invalidate BTC
	DSB();
	ISB();
	(*reset_p)();		/* call reset entry (does not return) */
}
