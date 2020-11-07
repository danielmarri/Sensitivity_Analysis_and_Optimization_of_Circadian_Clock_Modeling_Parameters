// stdafx.h : include file for standard system include files,
// or project specific include files that are used frequently, but
// are changed infrequently
//

#pragma once

#include "targetver.h"

#define WIN32_LEAN_AND_MEAN             // Exclude rarely-used stuff from Windows headers
// Windows Header Files:
#include <windows.h>

#include <AMIGO_model.h>

__declspec(dllexport) AMIGO_model* test_julia(
				int n_states,		int n_observables,	int n_pars,	
				int n_opt_pars,		int n_times,		int n_opt_ics,		
				int n_controls,		int n_controls_t,	int exp_num);
// TODO: reference additional headers your program requires here
