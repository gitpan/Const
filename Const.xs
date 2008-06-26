/*
 * $Id
 */

#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

#include <stdio.h>

static void
lock_recursively(SV *sv, int ix){
    if (SvROK(sv) && !sv_isobject(sv)){
	SV *rv = SvRV(sv);
	if (SvTYPE(rv) == SVt_PVAV){
	    I32 l = av_len((AV *)rv);
	    SV **ae;
	    while(--l >= 0){
		ae = av_fetch((AV *)rv, l, 0);
		if (!ae) continue;
		if (SvROK(*ae)) lock_recursively(*ae, ix);
		ix ? SvREADONLY_off(*ae) : SvREADONLY_on(*ae);
	    }
	}
	else if (SvTYPE(rv) == SVt_PVHV){
	    HE *he;
	    hv_iterinit((HV *)rv);
	    while (he = hv_iternext((HV *)rv)){
		SV *val = HeVAL(he);
		if (SvROK(val)) lock_recursively(val, ix);
		ix ? SvREADONLY_off(val) : SvREADONLY_on(val);
	    }
	}
	ix ? SvREADONLY_off(rv) : SvREADONLY_on(rv);
    }
    ix ? SvREADONLY_off(sv) : SvREADONLY_on(sv);
}

MODULE = Const		PACKAGE = Const		

void
dlock(sv)
    SV *    sv;
PROTOTYPE: $
ALIAS:
    dlock   = 0
    dunlock = 1
CODE:
  lock_recursively(sv, ix);

