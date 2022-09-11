///////////////////////////////////////////////////////////////////
// i6comp.h
//  
// InstallShield 5.xx Compression and Maintenance util
// fOSSiL - 1999
//
// InstallShield 6.xx Compression and Maintenance util
// Morlac - 2000
//
// General exception bugfix by DarkSoul Jan-11-2002
//
// *Any use is authorized, granted the proper credit is given*
//
// No support will be provided for this code
//

#ifndef _I6COMP_H
#define _I6COMP_H

// Following line added by DarkSoul Jan-10-2002 to safe memory
#pragma pack(2)

typedef struct tagRWHANDLES {
	HANDLE hRead;
	HANDLE hWrite;
	DWORD  BytesIn;
	DWORD  BytesOut;
} RWHANDLES, *LPRWHANDLES;

typedef struct tagCABFILELIST {
	unsigned char   *FileName;
	WORD   VolIndex;
	DWORD  CabIndex;
	struct tagCABFILELIST* pNext;
} CABFILELIST, *LPCABFILELIST;

typedef struct tagDISKFILELIST {
	unsigned char   *FileName;
	DWORD  CabDirInd;
	LPSTR  DiskDir;
	LPSTR  CabDir;
	struct tagDISKFILELIST* pNext;
} DISKFILELIST, *LPDISKFILELIST;

typedef struct tagDIRARRAY {
	DWORD Count;
	LPSTR Dirs[];
} DIRARRAY, *LPDIRARRAY;

// Following line added by DarkSoul Jan-10-2002
#pragma pack()

#endif // _I6COMP_H
