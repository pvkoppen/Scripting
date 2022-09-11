///////////////////////////////////////////////////////////////////
// is6cab.h
//  
// InstallShield cabinet definitions
//
// InstallShield 5.xx Compression and Maintenance util
// fOSSiL - 1999
//
// InstallShield 6.xx Compression and Maintenance util
// Morlac - 2000
//
// *Any use is authorized, granted the proper credit is given*
//
// No support will be provided for this code
//

#ifndef ISHIELD6_INC
#define ISHIELD6_INC

#pragma pack(1)
typedef struct tagCABHEADER {
	DWORD Signature;
	DWORD Version;
	BYTE NextVol;
	BYTE junk2;				// 9
	WORD junk3;				// a
	DWORD ofsCabDesc;
	DWORD cbCabDesc;
	DWORD ofsCompData;
	DWORD junk1;			// 18
	DWORD FirstFile;
	DWORD LastFile;
	DWORD ofsFirstData;
	DWORD cbFirstExpanded;
	DWORD cbFirstHere;
	DWORD ofsLastData;
	DWORD cbLastExpanded;
	DWORD cbLastHere;
} CABHEADER, *LPCABHEADER;	// size=3c,section is 1ED bytes in file

#define CAB_SIG		0x28635349

#define CFG_MAX		0x47

typedef struct tagCABDESC {
	DWORD ofsStrings;
	DWORD junk4;			//4
	DWORD ofsCompList;
	DWORD ofsDFT;
	DWORD junk10;			//10
	DWORD cbDFT;
	DWORD cbDFT2;
	WORD  cDirs;
	DWORD junk1e;			//1e
	WORD  junk22;			//22
	DWORD junk24;			//24
	DWORD cFiles;
	DWORD junk2c;			//2c
	WORD cCompTabInfo;
	DWORD ofsCompTab;
	DWORD junk36, junk3a;	//36,3a
	DWORD ofsFileGroup[CFG_MAX];
	DWORD ofsComponent[CFG_MAX];
	DWORD ofsSTypes;
	DWORD ofsSTab;
	DWORD junk27e,junk282;  //27e,282
} CABDESC, *LPCABDESC;		// section is 286 bytes in file

typedef DWORD* DFTABLE;

typedef struct tagFILEDESC {
	WORD  DescStatus;
	DWORD cbExpanded;
	DWORD junk6;			//6 ?
	DWORD cbCompressed;
	DWORD junke;			//e ? 
	DWORD ofsData;
	DWORD junk16,junk1a,junk1e,junk22,junk26,junk2a,junk2e,junk32,junk36;//16,1a,1e,22,26,2a,2e,32,36
	DWORD ofsName;
	WORD  DirIndex;
	DWORD Attrs;
	WORD  FatDate,FatTime;
	WORD  junk48;			//48 ?
	DWORD junk4a,junk4e;	//4a,4e
	WORD  junk52;			//52
	BYTE  junk54;			//54
	WORD  VolIndex;
} FILEDESC, *LPFILEDESC;


#define DESC_NEXT_VOLUME	1L
#define DESC_ENCRYPTED		2L
#define DESC_COMPRESSED		4L
#define DESC_INVALID		8L

typedef struct tagCOMPFILEENTRY {
	DWORD ofsName;
	DWORD ofsDesc;
	DWORD ofsNext;
} COMPONENTENTRY, *LPCOMPONENTENTRY, FILEGROUPENTRY, *LPFILEGROUPENTRY;

typedef DWORD* COMPONENTTABLE;
typedef DWORD* FILEGROUPTABLE;

typedef struct tagCOMPONENTDESC {
	DWORD	ofsIdentifier;		// 0
	DWORD	ofsDescription;		// 4	
	DWORD	ofsDispName;		// 8
	WORD	junk13;				// c
	DWORD	ofsjunk14;			// e
	DWORD	ofsjunk15;			// 12
	WORD	CompIndex;			// 16
	DWORD	ofsName;			// 18
	DWORD	ofsjunk18;			// 1c
	DWORD	ofsjunk19;			// 20
	DWORD	ofsjunk20;			// 24
	DWORD	junk1[8];			// 28,2c,30,34,38,3c,40,44
	DWORD	ofsCLSID;			// 48
	DWORD	junk2[7];			// 4c,50,54,58,5c,60,64,68
	BYTE	junkie;				// 68
	WORD	cDepends;			// 69
	DWORD	ofsDepends;			// 6b
	WORD	cFileGroups;		// 6f
	DWORD	ofsFileGroups;		// 71
	WORD	cX3;				// 75
	DWORD	ofsX3;				// 77
	WORD	cSubComps;			// 7b yes
	DWORD	ofsSubComps;		// 7d yes
	DWORD	ofsNextComponent;	// 81
	DWORD	ofsjunk27;			// 85
	DWORD	ofsjunk28;			// 89
	DWORD	ofsjunk29;			// 8d
	DWORD	ofsjunk30;			// 91
} COMPONENTDESC, *LPCOMPONENTDESC;//correct.


typedef struct tagFILEGROUPDESC {
	DWORD ofsName;
	DWORD cbExpanded;
	DWORD junk1;				//8		//Appears to be correct
	DWORD cbCompressed;
	WORD  junk2;				//10	//unknown
	WORD  Attr1, Attr2;			//12,14 //unknown
	DWORD FirstFile;
	DWORD LastFile;
	DWORD ofsUnkown;			//1e	|
	DWORD ofsVar4;				//22	|
	DWORD ofsVar1;				//26	|
	DWORD ofsHTTPLocation;		//2a	|
	DWORD ofsFTPLocation;		//2e	|------> These are offsets for sure
	DWORD ofsMisc;				//32	|
	DWORD ofsVar2;				//36	|
	DWORD ofsTargetDir;			//3a	|
	DWORD junk21, junk22, junk23, junk24, junk25;
} FILEGROUPDESC, *LPFILEGROUPDESC;

typedef struct tagSETUPTYPEHEADER {
	DWORD cSTypes;
	DWORD ofsSTypeTab;
} SETUPTYPEHEADER, *LPSETUPTYPEHEADER;

typedef DWORD* SETUPTYPETABLE;

typedef struct tagSETUPTYPEDESC {
	DWORD ofsName;
	DWORD ofsDescription;
	DWORD ofsDispName;
	DWORD cSTab;
	DWORD ofsSTab;
} SETUPTYPEDESC, *LPSETUPTYPEDESC;

#pragma pack()

#define GetString(ptr, ofs) ( (LPSTR) (((LPBYTE)ptr) + ((DWORD)ofs)) )

#define GetCompEntry(ptr, ofs) ( (LPCOMPONENTENTRY) (((LPBYTE)ptr) + ofs) )

#define GetFileGroupEntry(ptr, ofs) ( (LPFILEGROUPENTRY) (((LPBYTE)ptr) + ofs) )

#define GetSetupTypeDesc(ptr, stt, i) ( (LPSETUPTYPEDESC) (((LPBYTE)ptr) + ((SETUPTYPETABLE)stt)[i]) )

#define GetCompDesc(ptr, ct, i) ( (LPCOMPONENTDESC) (((LPBYTE)ptr) + ((COMPONENTTABLE)ct)[i]) )

#define GetFileGroupDesc(ptr, fgt, i) ( (LPFILEGROUPDESC) (((LPBYTE)ptr) + ((FILEGROUPTABLE)fgt)[i]) )

#define GetFileDesc(dft, i, j) ( (LPFILEDESC) (((LPBYTE)dft) + (i*4) + (j*sizeof(FILEDESC)) ))


#endif // ISHIELD6_INC
