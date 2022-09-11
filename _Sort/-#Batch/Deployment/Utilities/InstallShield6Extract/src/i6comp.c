///////////////////////////////////////////////////////////////////
// i6comp.c
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

#include <windows.h>
#include <stdio.h>
#include <string.h>
#include <direct.h>
#include <malloc.h>
#include "zdata.h"
#include "is6cab.h"
#include "i6comp.h"


#define CSFG_MAX      512
#define CRYPT_NONE		0
#define CRYPT_DECRYPT	1
#define CRYPT_ENCRYPT	2


// IShield functions
void ExtractFiles();
void ReplaceFiles();
void DeleteFiles();
void AddFiles();
void ListFiles();
void ListSetupTypes();
void ListComponents();
void ListFileGroups();
void ReadCabHeader(HANDLE hCab);
void InitCabFile(LPSTR cabfile, DWORD Access);
void SaveCabHeaders();
BOOL IsSingleVolume();
HANDLE ReadCabHeaderFile(LPSTR cabfile, DWORD Access);


// ZData functions
int CALLBACK ReadData(LPVOID pbuf, LPDWORD size, LPRWHANDLES pHnd);
int CALLBACK WriteData(LPVOID pbuf, LPDWORD size, LPRWHANDLES pHnd);
void InitCompressLib();

// Utils
void StartMsg();
void Usage();
void CleanExit(int code);
void DispatchCommand(int argc, char* argv[]);
void DeleteCab(LPSTR cabname);
void TransferData(HANDLE hFrom, HANDLE hTo, DWORD Length, DWORD Crypt);
void InitZData(RWHANDLES* pHnds);
void CreateDir(LPSTR dirname);
void CabBasedFileList(LPSTR CabParam, LPSTR DiskParam);
void DiskBasedFileList(LPSTR CabParam, LPSTR DiskParam);
void TranslateFileGroup();
void RecurseBuildDiskList(LPSTR BegDP, LPSTR CurDP, LPSTR Mask, LPSTR CabPath);
void Free(LPVOID ptr);
void RebuildDFT(LPDWORD NextFile, LPDWORD ofsNextDesc, LPDWORD ofsNextName);
void CopyFileGroup(DFTABLE OldT, DFTABLE NewT, DWORD cNewDirs, DWORD FGIndex, LPDWORD NextFile, LPDWORD ofsNextDesc, LPDWORD ofsNextName);
void ShiftDataDown(LPSTR FileName, DWORD DataOfs, DWORD Shift);
long strtolong(char* str);
long atolong(char* str);
long DirsArrayFind(LPDIRARRAY pDA, LPSTR DirName);
long DirsArrayAddDir(LPDIRARRAY* ppDA, LPSTR DirName);
BOOL TranslatePathToGroup(LPSTR* ppPath, LPSTR* ppFGName);
BOOL WildMatch(LPSTR str, LPSTR wildcard);
BOOL IsMask(LPSTR str);
BOOL DirExists(LPSTR DirName);
short GetVolumeByFile(DWORD Index);
LPSTR GetGroupNameByFile(DWORD Index);
DWORD GetGroupIndexByName(LPSTR GroupName);
LPVOID Alloc(DWORD NewSize);
LPVOID ReAlloc(LPVOID Ptr, DWORD NewSize);
HANDLE OpenForRead(LPSTR filename);
HANDLE OpenForWrite(LPSTR filename, DWORD Flags);
HANDLE OpenForAccess(LPSTR filename, DWORD Access);
LPFILEGROUPDESC GetGroupByFile(DWORD index);
LPDIRARRAY DirsArrayBuild();


// Errors
void CantReadFile(int code);
void CantWriteFile(int code);
void CantOpenFile(LPSTR filename);
void InvalidCab();
void NotIShield6();
void NoMemory();
void MultipleNotSupported();
void InvalidFileIndex();
void CantDecompress(LPSTR filename);
void CantCompressError(LPSTR filename);
void CantCompressStore(LPSTR filename);
void NotInAnyGroups(LPSTR filename);
void NotEnoughParams(LPSTR str);
void NoFilesMatched();
void ExceptInDecompress();
void NoMatchBytesOut();
void GeneralException();
void TooManyEntries(LPSTR str);
void BadFileGroup();

// Global Cab variables
HANDLE hCabFile = NULL;
HANDLE hCabHdr = NULL;
CABHEADER CabHdr;
CABHEADER _FirstVolHdr;
LPCABHEADER FirstVolHdr = &_FirstVolHdr;
LPCABDESC pCabDesc = NULL;
DFTABLE DFT = NULL;
SETUPTYPETABLE SetupTypes = NULL;
DWORD cSetupTypes = 0;
COMPONENTTABLE Components = NULL;
DWORD cComponents = 0;
FILEGROUPTABLE FileGroups = NULL;
DWORD cFileGroups = 0;
LPSTR pCabPattern = NULL;

// Globals
LPSTR exename = NULL;
LPVOID pZBuf = NULL;
LPCABFILELIST pFileList = NULL;
LPDISKFILELIST pDiskList = NULL;
DWORD FileCount = 0;
DWORD FileAttrVals[4] = {FILE_ATTRIBUTE_ARCHIVE, FILE_ATTRIBUTE_READONLY, FILE_ATTRIBUTE_HIDDEN, FILE_ATTRIBUTE_SYSTEM};
char FileAttrChars[] = "ARHS";

// Options
BOOL optRecurseSubdirs = FALSE;
BOOL optMatchWithDirs = FALSE;
BOOL optPrintAll = TRUE;
BOOL optFGasDir = FALSE;
DWORD optFileGroup = (DWORD)-1;
DWORD optVersion = 51145;




void main(int argc, char* argv[])
{
	exename = argv[0];

	if (argc < 3) {
		StartMsg();
		Usage();
	}

	__try {
		DispatchCommand(argc - 1, argv + 1);
	} __except(EXCEPTION_EXECUTE_HANDLER) {
		GeneralException();
	}
	CleanExit(0);
}

void StartMsg()
{
	if (optPrintAll) {
		fprintf(stdout,"ÄÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÄ\n");
		fprintf(stdout,"þInstallShield 5.x Cabinet Compression & Maintenance Utilþ\n");
		fprintf(stdout,"þVersion 2.00  -] fOSSiL - 2000 [-                       þ\n");
		fprintf(stdout,"þInstallShield 6.x Cabinet Compression & Maintenance Utilþ\n");
		fprintf(stdout,"þVersion 1.03b -] Morlac - 2000 [-                       þ\n");
		fprintf(stdout,"þGeneral exception bugfix by -] DarkSoul - 2002 [-       þ\n");
		fprintf(stdout,"ÄÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÄ\n");
	}
}

void Usage()
{
	if (optPrintAll) {
		LPSTR pName;
		pName = strrchr(exename, '\\');
		pName = pName ? pName + 1 : exename;

		fprintf(stdout, "\nUsage: %s <cmd> [-opts] <cab> [cab index|fmask|path] [disk fmask|path]\n", pName);
		fprintf(stdout, "Commands\n");
		fprintf(stdout, "\tl: list Files\n");
		fprintf(stdout, "\tt: list Setup Types\n");
		fprintf(stdout, "\tc: list Components\n");
		fprintf(stdout, "\tg: list File Groups\n");
		fprintf(stdout, "\te: extract files (specify <cab index|mask> when specifying <disk path>)\n");
		fprintf(stdout, "\tx: same as 'e' with subdirs\n");
		fprintf(stdout, "\tr: replace files in cab (same syntax as 'e')\n");
		fprintf(stdout, "\td: delete files from cab (specify <cab index|mask>)\n");
		fprintf(stdout, "\ta: add files to cab (<cab path> is optional; must specify -g OR -f)\n");
		fprintf(stdout, "Options\n");
		fprintf(stdout, "\tr: extract subdirs/recurse and store subdirs\n");
		fprintf(stdout, "\td: include directories in cab matches\n");
		fprintf(stdout, "\tg<name|index>: specifies File Group to work with\n");
		fprintf(stdout, "\to: suppress supplementary output (start msg, comments, etc.)\n");
		fprintf(stdout, "\tf: treat File Groups as directories (usefull for GUI, wrappers)\n");
		fprintf(stdout, "\t   for Add, Delete and Replace only 1 File Groups may be used at a time\n");
	}
	CleanExit(100);
}

void CleanExit(int code)
{
	if (hCabFile)
		CloseHandle(hCabFile);
	if (hCabHdr)
		CloseHandle(hCabHdr);

	Free(pCabDesc);
	Free(DFT);
	Free(pCabPattern);
	Free(pZBuf);
	Free(Components);
	Free(FileGroups);

	if (pFileList) {
		LPCABFILELIST pTemp;
		while (pFileList) {
			pTemp = pFileList->pNext;
			Free(pFileList);
			pFileList = pTemp;
		}
	}
	if (pDiskList) {
		LPDISKFILELIST pTemp;
		while (pDiskList) {
			pTemp = pDiskList->pNext;
			Free(pDiskList);
			pDiskList = pTemp;
		}
	}
	ZDataDeinit();
	exit(code);
}

void DispatchCommand(int argc, char* argv[])
{
	int arg = 0;
	char cmd;
	char* cabname;

	cmd = (char)toupper(argv[arg][0]);
	arg++;
	while (arg < argc && argv[arg][0] == '-') {
		switch (toupper(argv[arg][1])) {
			case 'R':
				optRecurseSubdirs = TRUE;
				break;
			case 'D':
				optMatchWithDirs = TRUE;
				break;
			case 'G':
				optFileGroup = atolong(argv[arg] + 2);
				if (optFileGroup == (DWORD)-1)
					optFileGroup = (DWORD)(argv[arg] + 2);
				break;
			case 'O':
				optPrintAll = FALSE;
				break;
			case 'F':
				optFGasDir = TRUE;
				break;
			default:
				StartMsg();
				fprintf(stdout, "\nUnknown option specified\n");
				Usage();
		}
		arg++;
	}
	if (arg >= argc) {
		StartMsg();
		fprintf(stdout, "\nNo cab file specified\n");
		Usage();
	}
	
	StartMsg();

	cabname = argv[arg];
	arg++;

	switch (cmd) {
		case 'L':
			InitCabFile(cabname, GENERIC_READ);
			TranslateFileGroup();
			CabBasedFileList(arg < argc ? argv[arg] : NULL, NULL);
			arg += 1;
			ListFiles();
			break;
		case 'T':
			InitCabFile(cabname, GENERIC_READ);
			ListSetupTypes();
			break;
		case 'C':
			InitCabFile(cabname, GENERIC_READ);
			ListComponents();
			break;
		case 'G':
			InitCabFile(cabname, GENERIC_READ);
			TranslateFileGroup();
			ListFileGroups();
			break;
		case 'X':
			//not working propably. Some FG name contain illegal chars
			optRecurseSubdirs = TRUE;
		case 'E':
			InitCabFile(cabname, GENERIC_READ);
			TranslateFileGroup();
			CabBasedFileList(arg < argc ? argv[arg] : NULL, arg + 1 < argc ? argv[arg + 1] : NULL);
			arg += 2;
			ExtractFiles();
			break;
		case 'R':
			InitCabFile(cabname, GENERIC_READ | GENERIC_WRITE);
			TranslateFileGroup();
			CabBasedFileList(arg < argc ? argv[arg] : NULL, arg + 1 < argc ? argv[arg + 1] : NULL);
			arg += 2;
			ReplaceFiles();
			break;
		case 'D':
			InitCabFile(cabname, GENERIC_READ | GENERIC_WRITE);
			TranslateFileGroup();
			if (arg < argc)
				CabBasedFileList(argv[arg], NULL);
			else
				NotEnoughParams("'d': ");
			arg += 1;
			DeleteFiles();
			break;
		case 'A':
			/* Does not handle multi-volume cabinets */
			InitCabFile(cabname, GENERIC_READ | GENERIC_WRITE);
			TranslateFileGroup();
			switch (argc - arg) {
				case 1:
					DiskBasedFileList(NULL, argv[arg]);
					arg += 1;
					break;
				case 2:
					DiskBasedFileList(argv[arg], argv[arg + 1]);
					arg += 2;
					break;
				default:
					NotEnoughParams("'a': ");
			}
			AddFiles();
			break;
		default:
			fprintf(stdout, "Unknown command specified\n");
			Usage();
	}
}

void DeleteCab(LPSTR cabname)
{
	if (!DeleteFile(cabname))
		fprintf(stdout, "Could not delete %s, error code %d\n", cabname, GetLastError());
}

void TransferData(HANDLE hFrom, HANDLE hTo, DWORD Length, DWORD Crypt)
{
	DWORD dwTran;
	LPBYTE pBuf;
	DWORD ToTran;
	DWORD Total = 0;

	if (Length > 262144)
		ToTran = 262144;
	else
		ToTran = Length;

	pBuf = Alloc(ToTran);

	while (Length) {
		if (ToTran > Length)
			ToTran = Length;
		if (!ReadFile(hFrom, pBuf, ToTran, &dwTran, NULL) || dwTran != ToTran)
			CantReadFile(GetLastError());
	
		if (Crypt == CRYPT_ENCRYPT) {
			DWORD i;
			BYTE ts;
			for (i=0; i < dwTran; i++) {
				ts = (BYTE)((Total + i) % 0x47) + pBuf[i];
				__asm { rol byte ptr ts, 2 };
				pBuf[i] = ts ^ 0xd5;
			}
			Total += dwTran;
		} else if (Crypt == CRYPT_DECRYPT) {
			DWORD i;
			BYTE ts;
			for (i=0; i < dwTran; i++) {
				ts = pBuf[i] ^ 0xd5;
				__asm { ror byte ptr ts, 2 };
				pBuf[i] = ts - (BYTE)((Total + i) % 0x47);
			}
			Total += dwTran;
		}

		if (!WriteFile(hTo, pBuf, ToTran, &dwTran, NULL) || dwTran != ToTran)
			CantWriteFile(GetLastError());
		Length -= dwTran;
	}
	Free(pBuf);
}

void InitZData(RWHANDLES* pHnds)
{
	InitCompressLib();
	pZBuf = Alloc(STD_DECOMP_BUFFER);
	ZDataSetInfo(INFO_BUFFER_PTR, (DWORD)pZBuf);
	ZDataSetInfo(INFO_BUFFER_SIZE, STD_DECOMP_BUFFER);
	ZDataSetInfo(INFO_READ_CALLBACK, (DWORD)ReadData);
	ZDataSetInfo(INFO_WRITE_CALLBACK, (DWORD)WriteData);
	ZDataSetInfo(INFO_CALLBACK_PARAM, (DWORD)pHnds);
}

void ExtractFiles()
{
	LPFILEDESC pFile;
	RWHANDLES rwHnd;
	unsigned int i;
	LPSTR pSlash,pName;
	LPCABFILELIST pCurrent = pFileList;
	FILETIME filetime;
	DWORD Res;
	short Vol = -1;
	char CabName[MAX_PATH];

	memset(&rwHnd, 0, sizeof(rwHnd));
	InitZData(&rwHnd);

	while(pCurrent) {
		i = pCurrent->CabIndex;
		pFile = GetFileDesc(DFT, pCabDesc->cDirs, i);
		pName = pCurrent->FileName;

		if (Vol != pFile->VolIndex) {
		  Vol = pFile->VolIndex;
		  if(rwHnd.hRead)
 				CloseHandle(rwHnd.hRead);
  		sprintf(CabName,pCabPattern, Vol);
	  	rwHnd.hRead = OpenForRead(CabName);
		}

		if(pFile->cbCompressed == pFile->cbExpanded || !pFile->ofsData) {
			fprintf(stdout,"\n\n%s is not stored in %s\n",pName,CabName);
			fprintf(stdout,"Check in the installation medium.\n\n");
			pCurrent = pCurrent->pNext;
			continue;
		}
		
		SetFilePointer(rwHnd.hRead, pFile->ofsData, 0, 0);
		
		pSlash = strrchr(pName, '\\');
		if(pSlash) {
			*pSlash = '\0';
			if (!DirExists(pName))
				CreateDir(pName);
			*pSlash = '\\';
		}

		rwHnd.hWrite = OpenForWrite(pName, CREATE_ALWAYS);
	
		if(pFile->DescStatus & DESC_COMPRESSED) {
			rwHnd.BytesIn = pFile->cbCompressed;
			rwHnd.BytesOut = 0;

			__try {
				if (ZDataStart(0))
					CantDecompress(pName);
				if (Res=ZDataDecompress(0))
					CantDecompress(pName);
				else {
					if (optPrintAll || rwHnd.BytesOut != pFile->cbExpanded)
						fprintf(stdout, "%s", pName);
					if (rwHnd.BytesOut != pFile->cbExpanded)
						NoMatchBytesOut();
					if (optPrintAll || rwHnd.BytesOut != pFile->cbExpanded)
						fprintf(stdout, "\n");
				}
				ZDataEnd();
			} __except(EXCEPTION_EXECUTE_HANDLER) {
				ExceptInDecompress();
			}
		} else {
			TransferData(rwHnd.hRead,
						rwHnd.hWrite,
						pFile->cbExpanded,
						pFile->DescStatus & DESC_ENCRYPTED ? CRYPT_DECRYPT : CRYPT_NONE);
			if (optPrintAll)
				fprintf(stdout, "%s\n", pName);
		}
		DosDateTimeToFileTime(pFile->FatDate, (WORD)pFile->FatTime, &filetime);
		SetFileTime(rwHnd.hWrite, NULL, NULL, &filetime);
		CloseHandle(rwHnd.hWrite);
		SetFileAttributes(pName, pFile->Attrs);

		pCurrent = pCurrent->pNext;
	}
	CloseHandle(rwHnd.hRead);
}

short GetVolumeByFile(DWORD Index)
{
	LPFILEDESC pFile;

	pFile = GetFileDesc(DFT, pCabDesc->cDirs , Index);

	return (short)(pFile ? pFile->VolIndex : -1);
}

LPFILEGROUPDESC GetGroupByFile(DWORD index)
{
	LPFILEGROUPDESC pFG = NULL;
	DWORD i = 0;

	while (	i < cFileGroups &&
		(index < (pFG=GetFileGroupDesc(pCabDesc, FileGroups, i))->FirstFile ||
		index > pFG->LastFile) )
			i++;
	return i < cFileGroups ? pFG : NULL;
}

void CreateDir(LPSTR dirname)
{
	DWORD dwErr;

	if (!CreateDirectory(dirname, NULL)) {
		dwErr = GetLastError();
		if (dwErr == ERROR_PATH_NOT_FOUND) {
			LPSTR pSlash;
			pSlash = strrchr(dirname, '\\');
			if (pSlash) {
				*pSlash = '\0';
				CreateDir(dirname);
				*pSlash = '\\';
				CreateDir(dirname);
				return;
			}
		}
		if (dwErr == ERROR_ALREADY_EXISTS)
			return;

		fprintf(stdout, "Can not create directory %s\n", dirname);
		CleanExit(9);
	}
}

int CALLBACK ReadData(LPVOID pbuf, LPDWORD size, LPRWHANDLES pHnd)
{
	DWORD dwRead;

	if (!pHnd->BytesIn) {
		*size = 0;
		return 0;
	}
	if (pHnd->BytesIn < *size)
		*size = pHnd->BytesIn;

	if (ReadFile(pHnd->hRead, pbuf, *size, &dwRead, NULL)) {
		pHnd->BytesIn -= dwRead;
		*size = dwRead;
		return 0;
	} else
		return GetLastError();
}

int CALLBACK WriteData(LPVOID pbuf, LPDWORD size, LPRWHANDLES pHnd)
{
	DWORD dwWritten;

	if (WriteFile(pHnd->hWrite, pbuf, *size, &dwWritten, NULL)) {
		*size = dwWritten;
		pHnd->BytesOut += dwWritten;
		return 0;
	} else
		return GetLastError();
}

void ReplaceFiles()
{
	LPFILEDESC pFile;
	LPSTR pName;
	LPFILEGROUPDESC pFG;
	RWHANDLES rwHnd;
	DWORD i;
	LPCABFILELIST pCurrent = pFileList;
	DWORD ofsNew;
	DWORD sizeNew;
	ZCOMPRESSBUF ZParam;
	BOOL Store;
	short Vol = -1;
	char CabName[MAX_PATH];

	memset(&rwHnd, 0, sizeof(rwHnd));
	InitZData(&rwHnd);

	while (pCurrent) {
		i = pCurrent->CabIndex;
		pName = pCurrent->FileName;
		pFile = GetFileDesc(DFT, pCabDesc->cDirs, i);
		pFG = GetGroupByFile(i);
		
		if(Vol != pFile->VolIndex) {
			Vol = pFile->VolIndex;
			if(rwHnd.hWrite)
				CloseHandle(rwHnd.hWrite);
			sprintf(CabName, pCabPattern, Vol);
			rwHnd.hWrite = OpenForWrite(CabName, OPEN_EXISTING);
		}

		if(pFile->cbCompressed == pFile->cbExpanded || !pFile->ofsData) {
			fprintf(stdout,"\n\n%s is not stored in %s\n", pName, CabName);
			fprintf(stdout,"Check in the installation medium.\n\n");
			fprintf(stdout,"Can't replace file.\n");

			pCurrent = pCurrent->pNext;
			continue;
		}
	
		rwHnd.hRead = OpenForRead(pName);
		
		{// Clean out the old file from cab
			HANDLE hCabRead;
			DWORD MoveSize;
			DWORD MoveShift;
			DWORD i2;
			DWORD FileSize;
			DWORD Top, Bottom;
			DWORD ofsTop;
			DWORD ofsBottom;
			LPFILEDESC pF;

			hCabRead = OpenForRead(CabName);
			FileSize = ofsTop = GetFileSize(hCabRead, NULL);
			ofsBottom = pFile->ofsData + pFile->cbCompressed;

			// Find file right after the one removing and the last file
			for (i2=0; i2 < pCabDesc->cFiles; i2++) {
				pF = GetFileDesc(DFT, pCabDesc->cDirs , i2);
				if (pF->DescStatus & DESC_INVALID)
					continue;
				if (pF->ofsData > pFile->ofsData && pF->ofsData < ofsTop) {
					Top = i2;
					ofsTop = pF->ofsData;
				}
				if (pF->ofsData > pFile->ofsData && pF->ofsData + pF->cbCompressed > ofsBottom) {
					Bottom = i2;
					ofsBottom = pF->ofsData + pF->cbCompressed;
				}
			}
			MoveSize = FileSize - ofsTop;
			MoveShift = ofsTop - pFile->ofsData;
			
			SetFilePointer(rwHnd.hWrite, pFile->ofsData, NULL, FILE_BEGIN);
			// Shift data up if necessary
			if (MoveSize) {
				SetFilePointer(hCabRead, ofsTop, NULL, FILE_BEGIN);
				TransferData(hCabRead, rwHnd.hWrite, MoveSize, CRYPT_NONE);
			}
			CloseHandle(hCabRead);

			ofsNew = SetFilePointer(rwHnd.hWrite, 0, NULL, FILE_CURRENT);
			
					
			// Update file descriptors to reflect the change in file position
			for (i2=0; i2 < pCabDesc->cFiles && i2 < FirstVolHdr->LastFile; i2++) {
				pF = GetFileDesc(DFT, pCabDesc->cDirs , i2);
				if (pF->DescStatus & DESC_INVALID)
					continue;
				if (pF->ofsData > pFile->ofsData)
					pF->ofsData -= MoveShift;
			}
		}

		sizeNew = GetFileSize(rwHnd.hRead, NULL);

		if (pFile->DescStatus & DESC_COMPRESSED)
			Store = FALSE;
		else
			Store = TRUE;

		if (!Store) {
			rwHnd.BytesIn = sizeNew;
			rwHnd.BytesOut = 0;

			if (ZDataStart(0))
				CantCompressError(pName);
			if (ZDataCompress(sizeof(ZParam), &ZParam) || sizeNew * 0.95 < rwHnd.BytesOut) {
				CantCompressStore(pName);
				pFile->DescStatus &= ~DESC_COMPRESSED;
				Store = TRUE;
				SetFilePointer(rwHnd.hWrite, ofsNew, NULL, FILE_BEGIN);
				SetFilePointer(rwHnd.hRead, 0, NULL, FILE_BEGIN);
			}
			ZDataEnd();
		}
		if (Store) {
			rwHnd.BytesOut = sizeNew;
			TransferData(rwHnd.hRead,
						rwHnd.hWrite,
						sizeNew,
						pFile->DescStatus & DESC_ENCRYPTED ? CRYPT_ENCRYPT : CRYPT_NONE);
		}
		CloseHandle(rwHnd.hRead);
		if(optPrintAll)
			fprintf(stdout, "\nFile replaced :  %s\n", pName);
		SetEndOfFile(rwHnd.hWrite);

		if (pFG) {
			pFG->cbExpanded += sizeNew - pFile->cbExpanded;
			pFG->cbCompressed += rwHnd.BytesOut - pFile->cbCompressed;
		}
		pFile->cbExpanded = sizeNew;
		pFile->cbCompressed = rwHnd.BytesOut;
		pFile->ofsData = ofsNew;

		pCurrent = pCurrent->pNext;
	}
	CloseHandle(rwHnd.hWrite);
	
	SaveCabHeaders();
}

void AddFiles()
{
	DWORD NextFile;
	DWORD ofsNextDesc;
	DWORD ofsNextName;
	RWHANDLES rwHnd;
	DWORD DataOfs;
	ZCOMPRESSBUF ZParam;
	LPDISKFILELIST pCurrent;
	LPFILEDESC pFile;
	LPFILEGROUPDESC pFG;
	char DName[MAX_PATH];
	DWORD Attrs;
	FILETIME filetime;
	DWORD Res;

	// add new files
	if (!IsSingleVolume())
		MultipleNotSupported();
	if (optFileGroup == -1) {
		fprintf(stdout, "'a': Must specify File Group to add to with -g OR use -f\n");
		CleanExit(25);
	}

	RebuildDFT(&NextFile, &ofsNextDesc, &ofsNextName);

	InitZData(&rwHnd);

	rwHnd.hWrite = OpenForWrite(pCabPattern, OPEN_EXISTING);
	DataOfs = SetFilePointer(rwHnd.hWrite, 0, NULL, FILE_END);
	
	pFG = GetFileGroupDesc(pCabDesc, FileGroups, optFileGroup);
	pCurrent = pDiskList;
	while (pCurrent) {
		strcpy(DName, pCurrent->DiskDir);
		strcat(DName, pCurrent->FileName);
		rwHnd.hRead = OpenForRead(DName);

		DFT[pCabDesc->cDirs + NextFile] = ofsNextDesc;
		ofsNextDesc += sizeof(FILEDESC);
		pFile = GetFileDesc(DFT, pCabDesc->cDirs , NextFile);

		pFile->DescStatus = DESC_COMPRESSED;
		pFile->ofsName = ofsNextName;
		strcpy(GetString(DFT, ofsNextName), pCurrent->FileName);
		ofsNextName += strlen(pCurrent->FileName) + 1;

		pFile->ofsData = DataOfs;
		pFile->DirIndex = (WORD)pCurrent->CabDirInd;
		rwHnd.BytesIn = GetFileSize(rwHnd.hRead, NULL);
		pFile->cbExpanded = rwHnd.BytesIn;
		rwHnd.BytesOut = 0;

		if (ZDataStart(0))
			CantCompressError(DName);

		Res=ZDataCompress(sizeof(ZParam), &ZParam);
		if ( Res || pFile->cbExpanded * 0.95 < rwHnd.BytesOut) {
			CantCompressStore(DName);
			pFile->DescStatus &= ~DESC_COMPRESSED;
			SetFilePointer(rwHnd.hWrite, DataOfs, NULL, FILE_BEGIN);
			SetFilePointer(rwHnd.hRead, 0, NULL, FILE_BEGIN);
			rwHnd.BytesOut = pFile->cbExpanded;
			TransferData(rwHnd.hRead, rwHnd.hWrite, rwHnd.BytesOut, CRYPT_NONE);
		}
		ZDataEnd();
		if (optPrintAll)
			fprintf(stdout,	"%s\n", DName);
		
		GetFileTime(rwHnd.hRead, NULL, NULL, &filetime);
		CloseHandle(rwHnd.hRead);
		pFile->FatDate = pFile->FatTime = 0;
		FileTimeToDosDateTime(&filetime, (LPWORD)&pFile->FatDate, (LPWORD)&pFile->FatTime);

		pFile->cbCompressed = rwHnd.BytesOut;
		Attrs = GetFileAttributes(DName);
		if (Attrs == -1) {
			Attrs = 0;
			fprintf(stdout, "Could not get file attributes of %s\n", DName);
		}
		pFile->Attrs = Attrs;
		DataOfs = SetFilePointer(rwHnd.hWrite, 0, NULL, FILE_CURRENT);
		
		// update headers
		FirstVolHdr->LastFile = NextFile;
		pCabDesc->cFiles = NextFile + 1;
		pFG->LastFile = NextFile;
		pFG->cbExpanded += pFile->cbExpanded;
		pFG->cbCompressed += pFile->cbCompressed;
		NextFile++;
		
		SaveCabHeaders();

		pCurrent = pCurrent->pNext;
	}
	CloseHandle(rwHnd.hWrite);
}

void RebuildDFT(LPDWORD NextFile, LPDWORD ofsNextDesc, LPDWORD ofsNextName)
{
	LPDIRARRAY pDA;
	LPDISKFILELIST pCurrent;
	DWORD i;
	DWORD NewSize;
	DWORD OldDataOfs, NewDataOfs;
	LPFILEDESC pFile;
	DFTABLE NewDFT;
	DWORD cFilesNew;
	
	// take apart Dirs
	pDA = DirsArrayBuild();
	// insert new dirs in the list
	pCurrent = pDiskList;
	while (pCurrent) {
		pCurrent->CabDirInd = DirsArrayAddDir(&pDA, pCurrent->CabDir);
		pCurrent = pCurrent->pNext;
	}
	// calc new size of the DFT
	cFilesNew = pCabDesc->cFiles + FileCount; 
	NewSize = (cFilesNew + pDA->Count) * sizeof(DWORD); // DF ofs table
	// position of first File Desc.
	*ofsNextDesc = NewSize;
	NewSize += cFilesNew * sizeof(FILEDESC);
	// position of first Name (Dir/File)
	*ofsNextName = NewSize;
	
	for (i=0; i < pCabDesc->cFiles; i++) {
		pFile = GetFileDesc(DFT, pCabDesc->cDirs , i);
		if (pFile->DescStatus & DESC_INVALID)
			continue;
		NewSize += strlen(GetString(DFT, pFile->ofsName)) + 1;
	}
	pCurrent = pDiskList;
	while (pCurrent) {
		NewSize += strlen(pCurrent->FileName) + 1;
		pCurrent = pCurrent->pNext;
	}
	for (i=0; i < pDA->Count; i++)
		NewSize += strlen(pDA->Dirs[i]) + 1;
	// new position of compressed data in cab
	NewDataOfs = CabHdr.ofsCabDesc + pCabDesc->ofsDFT + NewSize;

	// allocate and build new DFT, while moving the optFileGroup to the bottom
	NewDFT = Alloc(NewSize);
	
	// copy dirs
	for (i=0; i < pDA->Count; i++) {
		NewDFT[i] = *ofsNextName;
		strcpy(GetString(NewDFT, *ofsNextName), pDA->Dirs[i]);
		*ofsNextName += strlen(pDA->Dirs[i]) + 1;
	}

	// copy files, update filegroups
	*NextFile = 0;
	for (i=0; i < cFileGroups; i++) {
		if (i == optFileGroup)
			continue;
		CopyFileGroup(DFT, NewDFT, pDA->Count, i, NextFile, ofsNextDesc, ofsNextName);
	}
	CopyFileGroup(DFT, NewDFT, pDA->Count, optFileGroup, NextFile, ofsNextDesc, ofsNextName);

	// update all headers
	Free(DFT);
	DFT = NewDFT;
	pCabDesc->cDirs = (unsigned short)pDA->Count;
	Free(pDA);
	pCabDesc->cbDFT = NewSize;
	pCabDesc->cbDFT2 = NewSize;
	
	OldDataOfs = CabHdr.ofsCompData;
	if (NewDataOfs > OldDataOfs) {
		// newer versions have relevant headers separately
	/*	if (ver < ver55) {
			DWORD Shift = NewDataOfs - OldDataOfs;
			// update file descriptors
			for (i=0; i < pCabDesc->cFiles; i++) {
				pFile = GetFileDesc(NewDFT, pCabDesc->cDirs , i);
				pFile->ofsData += Shift;
			}
			// shift Z data down
			ShiftDataDown(pCabPattern, OldDataOfs, Shift);
		}*/
		// update headers
		CabHdr.ofsCompData = NewDataOfs;
	}
	SaveCabHeaders();
}

void ShiftDataDown(LPSTR FileName, DWORD DataOfs, DWORD Shift)
{
	HANDLE hRead, hWrite;
	DWORD MoveSize;
	DWORD dwTran;
	LPBYTE pBuf;
	DWORD ToTran;

	hRead = OpenForRead(FileName);
	hWrite = OpenForWrite(FileName, OPEN_EXISTING);

	MoveSize = GetFileSize(hRead, NULL) - DataOfs;
	DataOfs += MoveSize;

	if (MoveSize > 262144)
		ToTran = 262144;
	else
		ToTran = MoveSize;

	pBuf = Alloc(ToTran);

	while (MoveSize) {
		if (ToTran > MoveSize)
			ToTran = MoveSize;
		DataOfs -= ToTran;

		SetFilePointer(hRead, DataOfs, NULL, FILE_BEGIN);
		if (!ReadFile(hRead, pBuf, ToTran, &dwTran, NULL) || dwTran != ToTran)
			CantReadFile(GetLastError());
		
		SetFilePointer(hWrite, DataOfs + Shift, NULL, FILE_BEGIN);
		if (!WriteFile(hWrite, pBuf, ToTran, &dwTran, NULL) || dwTran != ToTran)
			CantWriteFile(GetLastError());
		MoveSize -= dwTran;
	}
	Free(pBuf);

	CloseHandle(hRead);
	CloseHandle(hWrite);
}

void CopyFileGroup(DFTABLE OldT, DFTABLE NewT, DWORD cNewDirs, DWORD FGIndex, LPDWORD NextFile, LPDWORD ofsNextDesc, LPDWORD ofsNextName)
{
	LPFILEGROUPDESC pFG;
	LPFILEDESC pFile, pNewFile;
	DWORD i, Start, End;

	pFG = GetFileGroupDesc(pCabDesc, FileGroups, FGIndex);
	Start = pFG->FirstFile;
	End = pFG->LastFile + 1;
	
	pFG->FirstFile = *NextFile;
	for (i = Start; i < End; i++) {
		pFile = GetFileDesc(OldT, pCabDesc->cDirs , i);
		NewT[cNewDirs + *NextFile] = *ofsNextDesc;
		*ofsNextDesc += sizeof(FILEDESC);
		pNewFile = GetFileDesc(NewT, cNewDirs , *NextFile);
		*pNewFile = *pFile;
		if ( !(pNewFile->DescStatus & DESC_INVALID) ) {
			LPSTR pNewName = GetString(NewT, *ofsNextName);
			strcpy(pNewName, GetString(OldT, pFile->ofsName));
			pNewFile->ofsName = *ofsNextName;
			*ofsNextName += strlen(pNewName) + 1;
		}
		(*NextFile)++;
	}
	pFG->LastFile = *NextFile - 1;
}

LPDIRARRAY DirsArrayBuild()
{
	LPDIRARRAY pDs;
	DWORD i;

	pDs = Alloc(sizeof(DIRARRAY) + pCabDesc->cDirs * sizeof(LPSTR));
	for (i=0; i < pCabDesc->cDirs; i++)
		pDs->Dirs[i] = GetString(DFT, DFT[i]);
	pDs->Count = pCabDesc->cDirs;

	return pDs;
}

long DirsArrayFind(LPDIRARRAY pDA, LPSTR DirName)
{
	DWORD i;

	i = 0;
	while (i < pDA->Count && _stricmp(pDA->Dirs[i], DirName) != 0)
		i++;
	if (i < pDA->Count)
		return i;
	else
		return -1;
}

long DirsArrayAddDir(LPDIRARRAY* ppDA, LPSTR DirName)
{
	LPDIRARRAY pDs = *ppDA;
	DWORD NewSize;
	DWORD Ind;

	Ind = DirsArrayFind(pDs, DirName);
	if (Ind != -1)
		return Ind;
	NewSize = sizeof(DIRARRAY) + (pDs->Count + 1) * sizeof(LPSTR);
	if (NewSize > _msize(pDs))
		pDs = ReAlloc(pDs, NewSize + 3 * sizeof(LPSTR));
	Ind = pDs->Count;
	pDs->Dirs[Ind] = DirName;
	pDs->Count++;
	*ppDA = pDs;

	return Ind;
}

void DeleteFiles()
{
	LPFILEDESC pFile;
	LPFILEGROUPDESC pFG;
	HANDLE hCabWrite=NULL;
	LPSTR pName;
	DWORD i;
	LPCABFILELIST pCurrent = pFileList;
	short Vol = -1;
	char CabName[MAX_PATH];

	while (pCurrent) {
		i = pCurrent->CabIndex;
		pFile = GetFileDesc(DFT, pCabDesc->cDirs , i);
		pName = GetString(DFT, pFile->ofsName);
		pFG = GetGroupByFile(i);

		if(Vol != pFile->VolIndex) {
			Vol = pFile->VolIndex;
			if(hCabWrite)
				CloseHandle(hCabWrite);
			sprintf(CabName, pCabPattern, Vol);
			hCabWrite = OpenForWrite(CabName, OPEN_EXISTING);
		}

		if(pFile->cbCompressed == pFile->cbExpanded || !pFile->ofsData) {
			fprintf(stdout,"\n\n%s is not stored in %s\n", pName,pCabPattern);
			fprintf(stdout,"Check in the installation medium.\n");
			fprintf(stdout,"Can't Delete file.\n\n");

			pCurrent = pCurrent->pNext;
			continue;
		}
	
		{// Clean out the old file from cab
			HANDLE hCabRead;
			DWORD MoveSize;
			DWORD MoveShift;
			DWORD i2;
			DWORD FileSize;
			DWORD Top, Bottom;
			DWORD ofsTop;
			DWORD ofsBottom;
			LPFILEDESC pF;

			hCabRead = OpenForRead(CabName);
			FileSize = ofsTop = GetFileSize(hCabRead, NULL);
			ofsBottom = pFile->ofsData + pFile->cbCompressed;

			// Find file right after the one removing and the last file
			for (i2=0; i2 < pCabDesc->cFiles; i2++) {
				pF = GetFileDesc(DFT, pCabDesc->cDirs , i2);
				if (pF->DescStatus & DESC_INVALID)
					continue;
				if (pF->ofsData > pFile->ofsData && pF->ofsData < ofsTop) {
					Top = i2;
					ofsTop = pF->ofsData;
				}
				if (pF->ofsData > pFile->ofsData && pF->ofsData + pF->cbCompressed > ofsBottom) {
					Bottom = i2;
					ofsBottom = pF->ofsData + pF->cbCompressed;
				}
			}
			MoveSize = FileSize - ofsTop;
			MoveShift = ofsTop - pFile->ofsData;
		
			SetFilePointer(hCabWrite, pFile->ofsData, NULL, FILE_BEGIN);
			// Shift data up if necessary
			if (MoveSize) {
				SetFilePointer(hCabRead, ofsTop, NULL, FILE_BEGIN);
				TransferData(hCabRead, hCabWrite, MoveSize, CRYPT_NONE);
			}
			CloseHandle(hCabRead);
			SetEndOfFile(hCabWrite);

			// Update file descriptors to reflect the change in file position
			for (i2=0; i2 < pCabDesc->cFiles && i2 < FirstVolHdr->LastFile; i2++) {
				pF = GetFileDesc(DFT, pCabDesc->cDirs , i2);
				if (pF->DescStatus & DESC_INVALID)
					continue;
				if (pF->ofsData > pFile->ofsData)
					pF->ofsData -= MoveShift;
			}
		}
		
		if (optPrintAll) {
			LPSTR pDir = GetString(DFT, DFT[pFile->DirIndex]);
			fprintf(stdout,"\nFile deleted :  ");
			if (*pDir != '\0')
				fprintf(stdout, "%s\\", pDir);
			fprintf(stdout, "%s\n", pName);
		}
			
		if (pFG) {
			pFG->cbExpanded -= pFile->cbExpanded;
			pFG->cbCompressed -= pFile->cbCompressed;
		}
		*pName = '\0';
		pFile->DescStatus = DESC_INVALID;
		
		pCurrent = pCurrent->pNext;
	}
	CloseHandle(hCabWrite);
	
	SaveCabHeaders();
}


void ListFiles()
{
	DWORD i;
	LPFILEDESC pFile;
	int files=0, osize=0, csize=0, ia;
	FILETIME filetime;
	SYSTEMTIME systime;
	LPSTR pDir, pName;
	char attrs[5];
	LPCABFILELIST pCurrent = pFileList;

	if (optPrintAll) {
		fprintf(stdout, "\n");
		fprintf(stdout, "Date       Time   OrigSize Attr  CompSize Ind,Vol FileName\n");
		fprintf(stdout, "========== ===== ========= ==== ========= ======= =================\n");
	}

	if (optFGasDir) {
		for (i = 0; i < cFileGroups; i++) {
			LPFILEGROUPDESC pFG = GetFileGroupDesc(pCabDesc, FileGroups, i);
			fprintf(stdout, "01-01-2000 12:00 %9d ____ %9d %4d,%2d %s\\\n",
				pFG->cbExpanded, pFG->cbCompressed, -1,-1, GetString(pCabDesc, pFG->ofsName));
		}
	}

	while (pCurrent) {
		i = pCurrent->CabIndex;
		pFile = GetFileDesc(DFT, pCabDesc->cDirs , i);

		DosDateTimeToFileTime(pFile->FatDate, pFile->FatTime, &filetime);
		FileTimeToSystemTime(&filetime, &systime);
		fprintf(stdout, "%02d-%02d-%04d %02d:%02d", systime.wMonth, systime.wDay, systime.wYear, systime.wHour, systime.wMinute);
	
		strcpy(attrs, FileAttrChars);
		for (ia=0; ia < 4; ia++)
			if (!(pFile->Attrs & FileAttrVals[ia]))
				attrs[ia] = '_';
		fprintf(stdout, " %9d %s %9d %4d,%2d ", pFile->cbExpanded, attrs, pFile->cbCompressed, i,pFile->VolIndex);
	
		pDir = GetString(DFT, DFT[pFile->DirIndex]);
		if (optFGasDir)
			fprintf(stdout, "%s\\", GetGroupNameByFile(i));
		if (*pDir != '\0')
			fprintf(stdout, "%s\\", pDir);
		pName = GetString(DFT, pFile->ofsName);
		fprintf(stdout, "%s\n", pName);

		files++;
		osize += pFile->cbExpanded;
		csize += pFile->cbCompressed;

		pCurrent = pCurrent->pNext;
	}

	if (optPrintAll) {
		fprintf(stdout, "                 ---------      --------- -------------------\n");
		fprintf(stdout, "                 %9d      %9d %4d file(s) total\n", osize, csize, files);
	}
}

LPSTR GetGroupNameByFile(DWORD Index)
{
	LPFILEGROUPDESC pFG = GetGroupByFile(Index);
	return GetString(pCabDesc, pFG->ofsName);
}

void ListSetupTypes()
{
	DWORD i;
	LPSETUPTYPEDESC pST;

	if (optPrintAll)
		fprintf(stdout, "\nSetup Types\n===============\n");

	for (i=0; i < cSetupTypes; i++) {
		pST = GetSetupTypeDesc(pCabDesc, SetupTypes, i);
		if (optPrintAll) fprintf(stdout, "Name         : ");
		fprintf(stdout, "%s\n", GetString(pCabDesc, pST->ofsName));
		if (optPrintAll) fprintf(stdout, "Display Name : ");
		fprintf(stdout, "%s\n", GetString(pCabDesc, pST->ofsDispName));
		if (optPrintAll) fprintf(stdout, "Description  : ");
		fprintf(stdout, "%s\n", GetString(pCabDesc, pST->ofsDescription));
		if (optPrintAll) fprintf(stdout, "\n");
	}
}


void ListComponents()
{
	DWORD i, fgi;
	LPCOMPONENTDESC pComp;
				
	if (optPrintAll)
		fprintf(stdout, "\nComponents\n===============\n");

	for (i=0; i < cComponents; i++) {
		pComp = GetCompDesc(pCabDesc, Components, i);
		if (optPrintAll) fprintf(stdout, "Index         : ");
		fprintf(stdout, "%d\n", pComp->CompIndex);
		if (optPrintAll) fprintf(stdout, "Name          : ");
		fprintf(stdout, "%s\n", GetString(pCabDesc, pComp->ofsName));
		if (optPrintAll) fprintf(stdout, "Display Name  : ");
		fprintf(stdout, "%s\n", GetString(pCabDesc, pComp->ofsDispName));
		if (optPrintAll) fprintf(stdout, "Description   : ");
		fprintf(stdout, "%s\n", GetString(pCabDesc, pComp->ofsDescription));
		if (optPrintAll) fprintf(stdout, "Comp Identity : ");
		fprintf(stdout, "%s\n", GetString(pCabDesc, pComp->ofsIdentifier));
		//if (optPrintAll) fprintf(stdout, "Password    : ");
		//fprintf(stdout, "%s\n", GetString(pCabDesc, pComp->ofsPassword));
		
		if (optPrintAll && GetString(pCabDesc, pComp->ofsCLSID)[0] != '\0') { 
			fprintf(stdout, "Registry CLSID: ");
			fprintf(stdout, "%s\n", GetString(pCabDesc, pComp->ofsCLSID));
		}
		if (optPrintAll) fprintf(stdout, "File Groups   : ");
		for (fgi=0; fgi < pComp->cFileGroups; fgi++) {
			fprintf(stdout, "%s", GetString(pCabDesc, ((LPDWORD)((LPBYTE)pCabDesc + pComp->ofsFileGroups))[fgi]));
			if (fgi + 1 != pComp->cFileGroups)
				fprintf(stdout, ", ");
		}
		fprintf(stdout, "\n");		
		if (optPrintAll) fprintf(stdout, "Depends       : ");
		for (fgi=0; fgi < pComp->cDepends; fgi++) {
			fprintf(stdout, "%s", GetString(pCabDesc, ((LPDWORD)((LPBYTE)pCabDesc + pComp->ofsDepends))[fgi]));
			if (fgi + 1 != pComp->cDepends)
				fprintf(stdout, ", ");
		}
		fprintf(stdout, "\n");		
		if (optPrintAll) fprintf(stdout, "SubComps      : ");
		for (fgi=0; fgi < pComp->cSubComps; fgi++) {
			fprintf(stdout, "%s", GetString(pCabDesc, ((LPDWORD)((LPBYTE)pCabDesc + pComp->ofsSubComps))[fgi]));
			if (fgi + 1 != pComp->cSubComps)
				fprintf(stdout, ", ");
		}
		fprintf(stdout, "\n");		
		if (optPrintAll) fprintf(stdout, "X3            : ");
		for (fgi=0; fgi < pComp->cX3; fgi++) {
			fprintf(stdout, "%s", GetString(pCabDesc, ((LPDWORD)((LPBYTE)pCabDesc + pComp->ofsX3))[fgi]));
			if (fgi + 1 != pComp->cX3)
				fprintf(stdout, ", ");
		}
		fprintf(stdout, "\n\n");
	} 
}


void ListFileGroups()
{
	LPFILEGROUPDESC pFG;
	DWORD Start, End, i, CompSize=0, OrigSize=0;

	if (optPrintAll) {
		fprintf(stdout, "\n");
		fprintf(stdout, "VB - Cab volume number where the group begins (1-based)\n");
		fprintf(stdout, "VE - Cab volume number where the group ends\n");
		fprintf(stdout, "FF - Index of the first file in the group (0-based)\n");
		fprintf(stdout, "LF - Index of the last file in the group\n");
		fprintf(stdout, "\n");
		fprintf(stdout, " OrigSize  CompSize VB VE  FF   LF  Ind Name\n");
		fprintf(stdout, "========= ========= == == ==== ==== === =====================\n");
	}

	if (optFileGroup == -1)
		Start = 0, End = cFileGroups;
	else
		Start = optFileGroup, End = optFileGroup + 1;
	for (i = Start; i < End; i++) {
		pFG = GetFileGroupDesc(pCabDesc, FileGroups, i);
		fprintf(stdout, "%9d %9d %2d %2d %4d %4d %3d %s\n",
			pFG->cbExpanded, pFG->cbCompressed,
			GetVolumeByFile(pFG->FirstFile), GetVolumeByFile(pFG->LastFile),
			pFG->FirstFile, pFG->LastFile, i, GetString(pCabDesc, pFG->ofsName));
		OrigSize += pFG->cbExpanded;
		CompSize += pFG->cbCompressed;
/*		fprintf(stdout,"ofsVar4     : 0x%08x  %d\n",pFG->ofsVar4,pFG->ofsVar4);
		fprintf(stdout,"Attr1       : 0x%04x  %d\n",pFG->Attr1,pFG->Attr1);
		fprintf(stdout,"Attr2       : 0x%04x  %d\n",pFG->Attr2,pFG->Attr2);
		fprintf(stdout,"Compressed  : 0x%08x  %d  %s\n",pFG->Compressed,pFG->Compressed,GetString(pCabDesc, pFG->Compressed));
		fprintf(stdout,"ofsVar1     : 0x%08x  %d\n",pFG->ofsVar1,pFG->ofsVar1);
		fprintf(stdout,"ofsVar2     : 0x%08x  %d\n",pFG->ofsVar2,pFG->ofsVar2);
		fprintf(stdout,"ofsVar3     : 0x%08x  %d  %s\n",pFG->ofsVar3,pFG->ofsVar3,GetString(pCabDesc, pFG->ofsVar3));
		fprintf(stdout,"ofsHTTPLoc  : 0x%08x  %d  %s\n",pFG->ofsHTTPLocation,pFG->ofsHTTPLocation,GetString(pCabDesc, pFG->ofsHTTPLocation));
		fprintf(stdout,"ofsFTPLoc   : 0x%08x  %d  %s\n",pFG->ofsFTPLocation,pFG->ofsFTPLocation,GetString(pCabDesc, pFG->ofsFTPLocation));
		fprintf(stdout,"ofsMisc		: 0x%08x  %d  %s\n",pFG->ofsMisc,pFG->ofsMisc,GetString(pCabDesc, pFG->ofsMisc));
		fprintf(stdout, "========================================================\n");*/	
	}
	i -= Start;
	if (optPrintAll) {
		fprintf(stdout, "--------- ---------                  -------------------\n");
		fprintf(stdout, "%9d %9d                %4d Groups(s) total\n", OrigSize, CompSize, i);
	}
}


void CantReadFile(int code)
{
	fprintf(stdout, "\nCan not read from file, error code %d\n", code);
	CleanExit(3);
}

void CantWriteFile(int code)
{
	fprintf(stdout, "\nCan not write to file, error code %d\n", code);
	CleanExit(12);
}

void CantOpenFile(LPSTR filename)
{
	fprintf(stdout, "\nCould not open %s\n", filename);
	CleanExit(2);
}

void NotIShield6()
{
	fprintf(stdout, "\nThis does not look like IShield 6 cab =)\nAre u sure u know what u are doing ?\n");
	CleanExit(4);
}

void InvalidCab()
{
	fprintf(stdout, "\nInvalid or unsupported cab file\n");
	CleanExit(9);
}

void NoMemory()
{
	fprintf(stdout, "\nCan not grab enough memory, giving up =)\nGo get a better 'puter !");
	CleanExit(6);
}

void MultipleNotSupported()
{
	fprintf(stdout, "\nThis operation is not supported on a multi-volume cab\nConvert to a single volume first\n");
	CleanExit(10);
}

void CantDecompress(LPSTR filename)
{
	fprintf(stdout, "SJiT! Can not decompress %s. ZData returned an error\n", filename);
}

void CantCompressError(LPSTR filename)
{
	fprintf(stdout, "SJiT! Can not compress %s. ZData returned an error\n", filename);
	CleanExit(13);
}

void CantCompressStore(LPSTR filename)
{
	fprintf(stdout, "SJiT! Can not compress %s. Storing...\n", filename);
}

void NotInAnyGroups(LPSTR filename)
{
	fprintf(stdout, "\n%s is not in any FileGroups\n", filename);
}

void InvalidFileIndex()
{
	fprintf(stdout, "\nInvalid file index specified\n");
	CleanExit(12);
}

void BadFileGroup()
{
	fprintf(stdout, "Invalid FileGroup specified\n");
	CleanExit(22);
}

void NotEnoughParams(LPSTR str)
{
	fprintf(stdout, "%sNot enough parameters\n", str);
	CleanExit(24);
}

void NoFilesMatched()
{
	fprintf(stdout, "\nNo files matched the criteria, duh !\n");
	CleanExit(0);
}

void ExceptInDecompress()
{
	fprintf(stdout, "\nException in decompression routine\nDid you forget to specify -v<n> ?\n(or if u did, try a different one =)\n");
	CleanExit(26);
}

void GeneralException()
{
	fprintf(stdout, "\nAn exception occured\nThis might be a new version of InstallShield unsupported at this moment\n");
	CleanExit(27);
}

void TooManyEntries(LPSTR str)
{
	fprintf(stdout, "\nToo many %s, recompile with a larger buffer\n", str);
	CleanExit(28);
}

void NoMatchBytesOut()
{
	fprintf(stdout, " WARNING: file size does not match File Descriptor in cab");
}

HANDLE OpenForRead(LPSTR filename)
{
	HANDLE hnd;

	hnd = CreateFile(filename,
					 GENERIC_READ,
					 FILE_SHARE_READ | FILE_SHARE_WRITE,
					 NULL,
					 OPEN_EXISTING,
					 FILE_FLAG_RANDOM_ACCESS,
					 NULL);
	
	if (hnd == INVALID_HANDLE_VALUE)
		CantOpenFile(filename);

	return hnd;
}

HANDLE OpenForWrite(LPSTR filename, DWORD Flags)
{
	HANDLE hnd;

	hnd = CreateFile(filename,
					 GENERIC_WRITE,
					 FILE_SHARE_READ | FILE_SHARE_WRITE,
					 NULL,
					 Flags,
					 FILE_FLAG_RANDOM_ACCESS,
					 NULL);
	
	if (hnd == INVALID_HANDLE_VALUE)
		CantOpenFile(filename);

	return hnd;
}

HANDLE OpenForAccess(LPSTR filename, DWORD Access)
{
	HANDLE hnd;

	hnd = CreateFile(filename,
					 Access,
					 FILE_SHARE_READ | FILE_SHARE_WRITE,
					 NULL,
					 OPEN_EXISTING,
					 FILE_FLAG_RANDOM_ACCESS,
					 NULL);
	
	if (hnd == INVALID_HANDLE_VALUE)
		CantOpenFile(filename);

	return hnd;
}

void ReadCabHeader(HANDLE hCab)
{
	DWORD dwRead;

	if (!ReadFile(hCab, &CabHdr, sizeof(CabHdr), &dwRead, NULL) ||
		dwRead != sizeof(CabHdr))
		CantReadFile(GetLastError());
	if (CabHdr.Signature != CAB_SIG)
		NotIShield6();
	if (!(CabHdr.Version & 0x01006000))
		NotIShield6();
}

HANDLE ReadCabHeaderFile(LPSTR cabfile, DWORD Access)
{
	LPSTR pdot;
	CHAR CabHeader[512];
	HANDLE hFile;

	strcpy(CabHeader, cabfile);
	pdot = strrchr(CabHeader, '.');
	if (pdot == 0)
		pdot = CabHeader + strlen(CabHeader);
	strcpy(pdot, ".hdr");

	hFile = OpenForAccess(CabHeader, Access);
	ReadCabHeader(hFile);

	return hFile;
}

void InitCabFile(LPSTR cabfile, DWORD Access)
{
	DWORD dwRead;
	
	hCabFile = OpenForAccess(cabfile, Access);
	
	// Read Cab header
	ReadCabHeader(hCabFile);

	if (CabHdr.cbCabDesc == 0) {
		// cab descriptor is in .hdr file
		// copy first vol hdr to its place
		_FirstVolHdr = CabHdr;
		hCabHdr = ReadCabHeaderFile(cabfile, Access);
	} else {
		// all in one file - older version
		hCabHdr = OpenForAccess(cabfile, Access);
		FirstVolHdr = &CabHdr;
	}
		
	pCabDesc = Alloc(CabHdr.cbCabDesc);

	// Read Cab Descriptor and all descriptor data
	SetFilePointer(hCabHdr, CabHdr.ofsCabDesc, NULL, FILE_BEGIN);
	if (!ReadFile(hCabHdr, pCabDesc, CabHdr.cbCabDesc, &dwRead, NULL) ||
		dwRead != CabHdr.cbCabDesc)
		CantReadFile(GetLastError());
	
	{// Calculate Setup Types table location
		LPSETUPTYPEHEADER pSTH;
	
		pSTH = (LPSETUPTYPEHEADER) ((LPBYTE)pCabDesc + pCabDesc->ofsSTypes);
		cSetupTypes = pSTH->cSTypes;
		SetupTypes = (SETUPTYPETABLE) ((LPBYTE)pCabDesc + pSTH->ofsSTypeTab);
	}

	{// Calculate Components & File Groups tables location
		DWORD ofsEntry;
		long i;

		cComponents = 0;
		Components = (COMPONENTTABLE) Alloc(CSFG_MAX * sizeof(Components[0]));

		for (i = 0; i < CFG_MAX; i++) {
			ofsEntry = pCabDesc->ofsComponent[i];
			while (ofsEntry != 0) {
				Components[cComponents++] = GetCompEntry(pCabDesc, ofsEntry)->ofsDesc;
				ofsEntry = GetCompEntry(pCabDesc, ofsEntry)->ofsNext;
				if (cComponents >= CSFG_MAX)
					TooManyEntries("Components");
			}
		}

 		cFileGroups = 0;
		FileGroups = (FILEGROUPTABLE) Alloc(CSFG_MAX * sizeof(FileGroups[0]));

		for (i = 0; i < CFG_MAX; i++) {
			ofsEntry = pCabDesc->ofsFileGroup[i];
			while (ofsEntry != 0) {
				FileGroups[cFileGroups++] = GetFileGroupEntry(pCabDesc, ofsEntry)->ofsDesc;
				ofsEntry = GetFileGroupEntry(pCabDesc, ofsEntry)->ofsNext;
				if (cFileGroups >= CSFG_MAX)
					TooManyEntries("File Groups");
			}
		}
	}

	// Read Dirs & Files table
	DFT = Alloc(pCabDesc->cbDFT);
	SetFilePointer(hCabHdr, CabHdr.ofsCabDesc + pCabDesc->ofsDFT, NULL, FILE_BEGIN);
	if (!ReadFile(hCabHdr, DFT, pCabDesc->cbDFT, &dwRead, NULL) ||
		dwRead != pCabDesc->cbDFT)
		CantReadFile(GetLastError());

	// generate Cab filename pattern
	if (IsSingleVolume()) {
		pCabPattern = Alloc(strlen(cabfile) + 1);
		strcpy(pCabPattern, cabfile);
	} else {
		LPSTR pdot;
		int pos;
		pCabPattern = Alloc(strlen(cabfile) + 2);
		strcpy(pCabPattern, cabfile);
		pdot = strrchr(cabfile, '.');
		pos = pdot ? pdot - cabfile : strlen(cabfile);
		pCabPattern[pos - 1] = '\0';
		strcat(pCabPattern, "%d");
		if (pdot)
			strcat(pCabPattern, pdot);
	}
}

void SaveCabHeaders()
{
	DWORD dwWritten;

	SetFilePointer(hCabHdr, 0, NULL, FILE_BEGIN);
	if (!WriteFile(hCabHdr, &CabHdr, sizeof(CabHdr), &dwWritten, NULL) ||
		dwWritten != sizeof(CabHdr))
			CantWriteFile(GetLastError());
	
	SetFilePointer(hCabHdr, CabHdr.ofsCabDesc, NULL, FILE_BEGIN);
	if (!WriteFile(hCabHdr, pCabDesc, CabHdr.cbCabDesc, &dwWritten, NULL) ||
		dwWritten != CabHdr.cbCabDesc)
			CantWriteFile(GetLastError());

	SetFilePointer(hCabHdr, CabHdr.ofsCabDesc + pCabDesc->ofsDFT, NULL, FILE_BEGIN);
	if (!WriteFile(hCabHdr, DFT, pCabDesc->cbDFT, &dwWritten, NULL) ||
		dwWritten != pCabDesc->cbDFT)
		CantWriteFile(GetLastError());

	SetFilePointer(hCabFile, 0, NULL, FILE_BEGIN);
	if (!WriteFile(hCabFile, FirstVolHdr, sizeof(CABHEADER), &dwWritten, NULL) ||
		dwWritten != sizeof(CABHEADER))
			CantWriteFile(GetLastError());
}

BOOL IsSingleVolume()
{
	DWORD i; short Vol = -1;
	LPFILEDESC pFile;

	for(i=0; i < pCabDesc->cFiles; i++) {
		pFile = GetFileDesc(DFT, pCabDesc->cDirs , i);
		if(Vol < 0)
			Vol = pFile->VolIndex;
		if(Vol != pFile->VolIndex)
			return FALSE;
	}	
	return TRUE;
}

void InitCompressLib()
{
	if (ZDataInit(optVersion)) {
		fprintf(stdout, "Could not load/init the much needed ZData dll\n");
		CleanExit(1);
	}
}

BOOL TranslatePathToGroup(LPSTR* ppPath, LPSTR* ppFGName)
{
	LPSTR pSlash;
	DWORD i;

	*ppFGName = NULL;

	if (*ppPath == NULL || !optFGasDir)
		return FALSE;

	if (**ppPath == '\\')
		*ppPath++;

	// attemp to parse out FG Name
	pSlash = strchr(*ppPath, '\\');
	// slash found: either a dir or FG name
	if (pSlash)
		*pSlash = 0;

	i = GetGroupIndexByName(*ppPath);
	if (i != -1) {		// it's an FG name
		optFileGroup = i;
		*ppFGName = *ppPath;
		if (pSlash) {	// there is more of path/mask in a param
			*ppPath = pSlash + 1;
		} else			// it was FG only
			*ppPath = NULL;
		return TRUE;
	}
	
	// it wasn't an FG name
	if (pSlash)	// restore the path
		*pSlash = '\\';
	
	return FALSE;
}

// both params may be NULL
void CabBasedFileList(LPSTR CabParam, LPSTR DiskParam)
{
  unsigned int TempSize = 0;
	long CabInd;
	char dparam[MAX_PATH], buf[MAX_PATH];
	LPFILEDESC pFile;
	LPSTR pDir, pName, pFGName = NULL;
	LPCABFILELIST pCurrent = NULL;
	DWORD NewSize, i, Start, End;
	BOOL CabByName = FALSE, CabIsMask = FALSE, DiskIsDir = FALSE;

	// check if file-index 
	CabInd = strtolong(CabParam);
	
	if (CabInd == -1) {	// not an index
		TranslatePathToGroup(&CabParam, &pFGName);
		CabByName = TRUE;
		CabIsMask = IsMask(CabParam);

	} else if (CabInd < 0 || CabInd > (long)pCabDesc->cFiles - 1)
		InvalidFileIndex();
	
	if (CabIsMask || (!DiskParam) || DiskParam[strlen(DiskParam) - 1] == '\\')
		DiskIsDir = TRUE;
	
	if (DiskParam) {
		strcpy(dparam, DiskParam);
		if (DiskIsDir && DiskParam[strlen(DiskParam) - 1] != '\\')
			strcat(dparam, "\\");
	} else
		dparam[0] = '\0';
	if (!CabByName) {
		if (optFileGroup != -1)
			fprintf(stdout, "WARNING: FileGroup specified when referencing file by index, option ignored\n");
		pFile = GetFileDesc(DFT, pCabDesc->cDirs , CabInd);
		if (pFile->DescStatus & DESC_INVALID)
			InvalidFileIndex();
		buf[0] = '\0';
		if (DiskIsDir) {
			strcat(buf, dparam);
			pDir = GetString(DFT, DFT[pFile->DirIndex]);
			if (optRecurseSubdirs) {
				if (optFGasDir) {
					pFGName = GetGroupNameByFile(CabInd);
				}
				if (pFGName != NULL)
					strcat(strcat(buf, pFGName), "\\");
				if (*pDir != '\0')
					strcat(strcat(buf, pDir), "\\");
			} else {
				if (optFGasDir) {
					pFGName = GetGroupNameByFile(CabInd);
				}
				if (pFGName != NULL)
					strcat(strcat(buf, pFGName), "\\");
			}
			strcat(buf, GetString(DFT, pFile->ofsName));
		} else
			strcat(buf, dparam);

		pFileList = Alloc(sizeof(CABFILELIST) + strlen(buf) + 1);
		pFileList->CabIndex = CabInd;
		pFileList->VolIndex = pFile->VolIndex;
		pFileList->pNext = NULL;
		
		// following 2 lines added by DarkSoul to avoid general exceptions
		pFileList->FileName  = (unsigned char *) (pFileList);
		pFileList->FileName += sizeof(CABFILELIST);
		strcpy(pFileList->FileName, buf);
		FileCount = 1;

		return;
	}

	if (optFileGroup == -1) {
		Start = 0;
		End = pCabDesc->cFiles;
	} else {
		LPFILEGROUPDESC pFG = GetFileGroupDesc(pCabDesc, FileGroups, optFileGroup);
		Start = pFG->FirstFile;
		End = pFG->LastFile + 1;
	}
	for (i = Start; i < End; i++) {
		pFile = GetFileDesc(DFT, pCabDesc->cDirs , i);
		if (pFile->DescStatus & DESC_INVALID)
			continue;
		
		buf[0] = '\0';
		pDir = GetString(DFT, DFT[pFile->DirIndex]);
		pName = GetString(DFT, pFile->ofsName);
		
		if (optMatchWithDirs && *pDir != '\0') {
			strcat(buf, pDir);
			strcat(buf, "\\");
		}
		strcat(buf, pName);

		if (!WildMatch(buf, CabParam))
			continue;

		buf[0] = '\0';
		if (DiskIsDir) {
			strcat(buf, dparam);
			if (optRecurseSubdirs) {
				if (optFGasDir) {
					pFGName = GetGroupNameByFile(i);
				}
				if (pFGName != NULL)
					strcat(strcat(buf, pFGName), "\\");
				if (*pDir != '\0')
					strcat(strcat(buf, pDir), "\\");
			} else {
				if (optFGasDir) {
					pFGName = GetGroupNameByFile(i);
				}
				if (pFGName != NULL)
					strcat(strcat(buf, pFGName), "\\");
			}

			strcat(buf, pName);
		} else
			strcat(buf, dparam);
		
		NewSize = sizeof(CABFILELIST) + strlen(buf) + 1;
		if (pFileList) {
			pCurrent->pNext = Alloc(NewSize);
			pCurrent = pCurrent->pNext;
		} else {
			pFileList = Alloc(NewSize);
			pCurrent = pFileList;
		}
		pCurrent->CabIndex = i;
		pCurrent->VolIndex = pFile->VolIndex;
		pCurrent->pNext = NULL;
		TempSize = sizeof(CABFILELIST);

		// following 2 lines added by DarkSoul to avoid general exceptions
		pCurrent->FileName  = (unsigned char *) pCurrent;
		pCurrent->FileName += sizeof(CABFILELIST);
		strcpy(pCurrent->FileName, buf);

		FileCount++;
	}
	if (!FileCount)
		NoFilesMatched();
}

// DiskParam may not be NULL
void DiskBasedFileList(LPSTR CabParam, LPSTR DiskParam)
{
	char cpath[MAX_PATH] = "";
	char begdp[MAX_PATH] = "";
	char curdp[MAX_PATH] = "";
	char mask[MAX_PATH];
	char tmpdp[MAX_PATH] = "";
	char nulldp[] = "";
	long tmp;
	LPSTR pFGName = NULL;


	if (CabParam) {	// we were passed a Cab Path
		// parse out the path
		TranslatePathToGroup(&CabParam, &pFGName);

		if (CabParam) {
			strcpy(cpath, CabParam);
			tmp = strlen(cpath);
			if (cpath[tmp - 1] == '\\')
				cpath[tmp - 1] = '\0';
		}
	}

	if (pFGName == NULL) {	// there was no Group in CabParam
		if (TranslatePathToGroup(&DiskParam, &pFGName)) {
			// path resolved to FileGroup name
			strcat(strcpy(begdp, pFGName), "\\");
			if (DiskParam == NULL)
				DiskParam = nulldp;
		}
	}

	tmp = strlen(DiskParam);
	if (IsMask(DiskParam)) {
		// we were passed a mask parse out starting dir and file mask
		LPSTR pSlash;
		pSlash = strrchr(DiskParam, '\\');
		if (pSlash) {
			tmp = pSlash - DiskParam + 1;
			strncpy(tmpdp, DiskParam, tmp);
			tmpdp[tmp] = '\0';
			pSlash++;
		} else {
			pSlash = DiskParam;
		}
		strcpy(mask, pSlash);

	} else if (tmp == 0 || DiskParam[tmp - 1] == '\\' || DirExists(DiskParam)) {
		// we were passed a dir - parse it
		// or it was a Group name
		LPSTR pSlash;
		strcpy(tmpdp, DiskParam);
		if (DiskParam[tmp - 1] == '\\')
			tmpdp[tmp - 1] = '\0';
		pSlash = strrchr(tmpdp, '\\');
		if (!pSlash)
			pSlash = tmpdp - 1;
		pSlash++;
		strcpy(curdp, pSlash);
		*pSlash = '\0';
		strcpy(mask, "*");
	
	} else { // we were passed a file
		LPSTR pSlash;
		strcpy(tmpdp, DiskParam);
		pSlash = strrchr(tmpdp, '\\');
		if (!pSlash)
			pSlash = tmpdp - 1;
		pSlash++;
		strcpy(mask, pSlash);
		*pSlash = '\0';
	}
	
	if (*tmpdp != 0)
		strcat(strcat(begdp, tmpdp), "\\");

	RecurseBuildDiskList(begdp, curdp, mask, cpath);
	if (!FileCount)
		NoFilesMatched();
}

void RecurseBuildDiskList(LPSTR BegDP, LPSTR CurDP, LPSTR Mask, LPSTR CabPath)
{
	HANDLE hFind;
	WIN32_FIND_DATA fd;
	char buf[MAX_PATH];
	BOOL Found;
	LPSTR pSubDir;
	static LPDISKFILELIST pCurrent;

	strcpy(buf, BegDP);
	strcat(buf, CurDP);
	if (*CurDP != '\0')
		strcat(buf, "\\");
	strcat(buf, "*");

	hFind = FindFirstFile(buf, &fd);
	if (hFind == INVALID_HANDLE_VALUE)
		return;
	
	// setup CurDirPath for subsequent recursive calls
	strcpy(buf, CurDP);
	pSubDir = strchr(buf, '\0');
	if (pSubDir != buf)
		*(pSubDir++) = '\\';

	Found = TRUE;
	while (Found) {
		if (fd.dwFileAttributes & FILE_ATTRIBUTE_DIRECTORY) {
			if (optRecurseSubdirs &&
					strcmp(fd.cFileName, ".") != 0 &&
					strcmp(fd.cFileName, "..") != 0) {
				strcpy(pSubDir, fd.cFileName);
				RecurseBuildDiskList(BegDP, buf, Mask, CabPath);
			}
		} else if (WildMatch(fd.cFileName, Mask) && 
					!(CurDP[0] == '\0' && _stricmp(pCabPattern, fd.cFileName) == 0) ) { // matched the wildcard
			DWORD Size;
			DWORD ofsDisk, ofsCab;
			Size = sizeof(DISKFILELIST) + strlen(fd.cFileName) + 1; // size of struct + size of FileName
			ofsDisk = Size;
			Size += strlen(BegDP) + strlen(CurDP) + 2; // size of disk path
			ofsCab = Size;
			Size += strlen(CabPath) + 2;
			if (optRecurseSubdirs)
				Size += strlen(CurDP);
			
			if (pDiskList) {
				pCurrent->pNext = Alloc(Size);
				pCurrent = pCurrent->pNext;
			} else {
				pDiskList = Alloc(Size);
				pCurrent = pDiskList;
			}

			// following 2 lines added by DarkSoul to avoid general exceptions
			pCurrent->FileName  = (unsigned char *) (pCurrent);
			pCurrent->FileName += sizeof(DISKFILELIST);
			strcpy(pCurrent->FileName, fd.cFileName);
			
			pCurrent->DiskDir = (LPSTR)pCurrent + ofsDisk;
			strcpy(pCurrent->DiskDir, BegDP);
			strcat(pCurrent->DiskDir, CurDP);
			if (CurDP[0] != '\0')
				strcat(pCurrent->DiskDir, "\\");
			
			pCurrent->CabDir = (LPSTR)pCurrent + ofsCab;
			strcpy(pCurrent->CabDir, CabPath);
			if (optRecurseSubdirs && CurDP[0] != '\0') {
				if (CabPath[0] != '\0')
					strcat(pCurrent->CabDir, "\\");
				strcat(pCurrent->CabDir, CurDP);
			}
			
			pCurrent->pNext = NULL;
			FileCount++;
			//fprintf(stdout, "%s, %s, %s\n", pCurrent->FileName, pCurrent->DiskDir, pCurrent->CabDir);
		}
		Found = FindNextFile(hFind, &fd);
	}

}

BOOL DirExists(LPSTR DirName)
{
	WIN32_FIND_DATA fd;
	HANDLE fh;

	fh = FindFirstFile(DirName, &fd);
	if (fh == INVALID_HANDLE_VALUE)
		return FALSE;
	FindClose(fh);
	if (fd.dwFileAttributes & FILE_ATTRIBUTE_DIRECTORY)
		return TRUE;
	else
		return FALSE;
}

void TranslateFileGroup()
{
	if (optFileGroup == -1)
		return;
	if (optFileGroup > 0x1000)
		optFileGroup = GetGroupIndexByName((LPSTR)optFileGroup);
	if (optFileGroup < 0 || optFileGroup > cFileGroups - 1) {
		fprintf(stdout, "Invalid FileGroup specified\n");
		CleanExit(22);
	}
}

DWORD GetGroupIndexByName(LPSTR GroupName)
{
	LPFILEGROUPDESC pFG;
	DWORD i = 0;

	while (	i < cFileGroups &&
		(_stricmp(GroupName, GetString(pCabDesc, (pFG=GetFileGroupDesc(pCabDesc, FileGroups, i))->ofsName)) != 0) )
			i++;
	return i < cFileGroups ? i : -1;
}

BOOL IsMask(LPSTR str)
{
	return (!str) || strchr(str, '*') || strchr(str, '?');
}

BOOL WildMatch(LPSTR str, LPSTR wildcard)
{
	LPSTR tstr;

	if (!wildcard)
		return TRUE;
	if (!str)
		return FALSE;

	while (*wildcard != '\0' && (toupper(*str) == toupper(*wildcard) || *wildcard == '*' || *wildcard == '?')) {
		if (*wildcard == '?') {
			wildcard++;
			if (*str == '\0')
				return FALSE;
			str++;
		} else if (*wildcard == '*') {
			wildcard++;
			if (*wildcard == '\0')
				return TRUE;
			tstr = str;
			while (*tstr != '\0' && !WildMatch(tstr, wildcard))
				tstr++;
			if (*tstr != '\0')
				str = tstr;
		} else {
			*wildcard++;
			*str++;
		}
	}
	return toupper(*str) == toupper(*wildcard);
}

// accepts part of the string
// returns -1 if no conversion possible
long strtolong(char* str)
{
	char* pend;
	long retval;

	if (!str)
		return -1;

	retval = strtol(str, &pend, 10);
	if (!(*pend == '\0' || *pend == ',' || *pend == '-'))
		retval = -1;

	return retval;
}

// must convert the entire the string
// returns -1 if no conversion possible
long atolong(char* str)
{
	char* pend;
	long retval;

	if (!str)
		return -1;

	retval = strtol(str, &pend, 10);
	if (*pend != '\0')
		retval = -1;

	return retval;
}

void Free(LPVOID ptr)
{
	if (ptr != NULL)
		free(ptr);
}

LPVOID Alloc(DWORD NewSize)
{
	LPVOID tempPtr = malloc(NewSize);
	if (!tempPtr)
		NoMemory();

	return tempPtr;
}

LPVOID ReAlloc(LPVOID Ptr, DWORD NewSize)
{
	LPVOID tempPtr = realloc(Ptr, NewSize);
	if (!tempPtr)
		NoMemory();
	
	return tempPtr;
}
