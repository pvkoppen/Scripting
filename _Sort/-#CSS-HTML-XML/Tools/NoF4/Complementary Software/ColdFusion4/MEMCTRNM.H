//
//  memctrnm.h
//
//  Offset definition file for exensible counter objects and counters
//
//  These "relative" offsets must start at 0 and be multiples of 2 (i.e.
//  even numbers). In the Open Procedure, they will be added to the 
//  "First Counter" and "First Help" values for the device they belong to, 
//  in order to determine the  absolute location of the counter and 
//  object names and corresponding help text in the registry.
//
//  This file is used by datamem.cpp as well as the 
//  counter name and help text definition file (.INI) file that is used
//  by LODCTR to load the names into the registry.
//


#define CFAS_OBJECT			0
#define CFAS_DBTRANSSEC		2
#define CFAS_PAGEHITSSEC		4
#define CFAS_REQQUEUED		6
#define CFAS_REQRUNNING		8
#define CFAS_REQTIMEDOUT		10
#define CFAS_BYTESIN			12
#define CFAS_BYTESOUT		14
#define CFAS_AVGQUEUETIME	16
#define CFAS_AVGREQTIME		18
#define CFAS_AVGDBTIME		20
#define CFAS_CACHEPOPSSEC	22

