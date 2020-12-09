.386
.model flat, stdcall  ;32 bit memory model
option casemap :none  ;case sensitive

include installation-wizard.inc

.code

start:

	invoke GetModuleHandle,NULL
	mov		hInstance,eax

    invoke InitCommonControls
	invoke DialogBoxParam,hInstance,IDD_DIALOG1,NULL,addr DlgProc,NULL
	invoke ExitProcess,0

;########################################################################

DlgProc proc hWin:HWND,uMsg:UINT,wParam:WPARAM,lParam:LPARAM
	LOCAL	ts:TC_ITEM
	LOCAL	changeSel:NMHDR
	LOCAL	bi:BROWSEINFO
	
	mov		eax,uMsg
	.if eax==WM_INITDIALOG
		
		invoke GetDlgItem,hWin,IDC_TAB1
		mov		hTab,eax
		mov		ts.imask,TCIF_TEXT
		mov		ts.lpReserved1,0
		mov		ts.lpReserved2,0
		mov		ts.iImage,-1
		mov		ts.lParam,0
		
		mov		ts.pszText,offset TabTitle1
		mov		ts.cchTextMax,sizeof TabTitle1
		invoke SendMessage,hTab,TCM_INSERTITEM,0,addr ts
		
		mov		ts.pszText,offset TabTitle2
		mov		ts.cchTextMax,sizeof TabTitle2
		invoke SendMessage,hTab,TCM_INSERTITEM,1,addr ts
		
		mov		ts.pszText,offset TabTitle3
		mov		ts.cchTextMax,sizeof TabTitle3
		invoke SendMessage,hTab,TCM_INSERTITEM,2,addr ts
		
		mov		ts.pszText,offset TabTitle4
		mov		ts.cchTextMax,sizeof TabTitle4
		invoke SendMessage,hTab,TCM_INSERTITEM,3,addr ts
	
		mov		ts.pszText,offset TabTitle5
		mov		ts.cchTextMax,sizeof TabTitle5
		invoke SendMessage,hTab,TCM_INSERTITEM,4,addr ts
		
		
	.elseif eax==WM_COMMAND

	.elseif eax==WM_CLOSE
		invoke EndDialog,hWin,0
	.else
		mov		eax,FALSE
		ret
	.endif
	mov		eax,TRUE
	ret

DlgProc endp

end start
