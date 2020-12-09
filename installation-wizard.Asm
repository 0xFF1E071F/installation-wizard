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


Tab1Proc proc hWin:HWND,uMsg:UINT,wParam:WPARAM,lParam:LPARAM
	mov		eax,TRUE
	ret
Tab1Proc endp

Tab2Proc proc hWin:HWND,uMsg:UINT,wParam:WPARAM,lParam:LPARAM
	mov		eax,TRUE
	ret
Tab2Proc endp

Tab3Proc proc hWin:HWND,uMsg:UINT,wParam:WPARAM,lParam:LPARAM
	mov		eax,TRUE
	ret
Tab3Proc endp

Tab4Proc proc hWin:HWND,uMsg:UINT,wParam:WPARAM,lParam:LPARAM
	
	mov		eax,TRUE
	ret

Tab4Proc endp

Tab5Proc proc hWin:HWND,uMsg:UINT,wParam:WPARAM,lParam:LPARAM
	mov		eax,TRUE
	ret
Tab5Proc endp

DlgProc proc hWin:HWND,uMsg:UINT,wParam:WPARAM,lParam:LPARAM
	LOCAL	ts:TC_ITEM
	LOCAL	changeSel:NMHDR
	
	mov		eax,uMsg
	.if eax==WM_INITDIALOG
		;Create the tabs
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
		
		;Create the tab dialogs
		invoke CreateDialogParam,hInstance,IDD_DLG1,hTab,addr Tab1Proc,0
		mov hTabDlg,eax
		invoke CreateDialogParam,hInstance,IDD_DLG2,hTab,addr Tab2Proc,0
		mov hTabDlg[4],eax
		invoke CreateDialogParam,hInstance,IDD_DLG3,hTab,addr Tab3Proc,0
		mov hTabDlg[8],eax
		invoke CreateDialogParam,hInstance,IDD_DLG4,hTab,addr Tab4Proc,0
		mov hTabDlg[12],eax
		invoke CreateDialogParam,hInstance,IDD_DLG5,hTab,addr Tab5Proc,0
		mov hTabDlg[16],eax
		
	.elseif eax==WM_COMMAND
		.if wParam == IDC_BTN1
			
			mov eax, sizeof hTabDlg
			mov ecx, 5
			div ecx

			; Close if it is the last element
			.if SelTab == eax
				invoke SendMessage,hWin,WM_CLOSE,0,0
			.endif
			
			; Hide current tab
			mov eax, SelTab
			push eax
			invoke ShowWindow,[hTabDlg+eax*4],SW_HIDE
			
			; Get next tab
			pop eax
			inc eax
			mov SelTab, eax
			
			invoke ShowWindow,[hTabDlg+eax*4],SW_SHOWDEFAULT
			invoke SendMessage,hTab,TCM_SETCURSEL,SelTab,0
			
			invoke GetDlgItem,hWin,IDC_BTN1
			.if SelTab==0
				invoke SetWindowText,eax,addr szStart
			.elseif SelTab==1
				invoke SetWindowText,eax,addr szNext
			.elseif SelTab==2
				invoke SetWindowText,eax,addr szInstall
			.elseif SelTab==3; start progress
				invoke ShowWindow,eax,SW_HIDE
				invoke SendMessage,[hTabDlg+3*4],WM_NULL,0,0
			.endif
		.elseif wParam == IDC_BTN2
			invoke MessageBox,0,addr szExitText,addr szExitCaption,MB_OKCANCEL + MB_ICONQUESTION
			.if eax==IDOK
				invoke SendMessage,hWin,WM_CLOSE,0,0
			.endif
		.endif
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
