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

; власна процедура виділення пам'яті
Mem_Alloc PROC Buf_Size:DWORD
	add Buf_Size,4	; виділяємо буфер на 4 байти більший
	invoke GlobalAlloc,GMEM_MOVEABLE or GMEM_ZEROINIT, Buf_Size   ; виділяємо область у динамічній пам'яті
	push eax 	; зберігаємо хендл області виділеного буфера у стек
	invoke GlobalLock,eax ;фіксуємо у реальній
	pop [eax]	;Витягнемо зі стеку значення  і запишемо у перші 4 байта виділеного масиву, 
				;це значення є хенд області виділеної області
				;наступні Buf_Size байт використовуємо як масив
	add eax,4	;зсуваємо вказівних початку масиву на 4 байти, оскільки перші 4 байти 
			;заняті значенням хендлу буфера
	ret	; виходимо з процедури
Mem_Alloc endp

; власна процедура знищення пам'яті.
Mem_Free PROC DATA:DWORD
	mov eax,DATA	;копіюємо значення параметра процедури у регістр eax, параметром є 
					;початкова (робоча) адреса буфера ( початок + 4 байти)
	sub eax,4	;пам'ятаємо, що перших 4 байти масиву  - це хендл буфера
	push [eax]	;беремо чотирьох байтне значення по адресі, що лежить у регістрі eax, заносимо його у стек
	invoke GlobalUnlock,eax	;розблоковуємо пам'ять (всю розміром Buf_Size+4)
	call GlobalFree	;оскільки параметр вже у стеці, викликаємо процедуру без параметрів, за дапомогою інструкції 
					;call (знищуємо хендел буфера)
	ret	;вихід з процедури
Mem_Free endp

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
	mov eax, uMsg
	.if eax==WM_NULL
		invoke SetTimer,hWin,10,50,0
	.elseif eax==WM_TIMER
		inc progress
		invoke SendDlgItemMessage, hWin, IDC_PGB1, PBM_SETPOS, progress, 0
		.if progress==100
			invoke KillTimer,hWin,10
			invoke ShowWindow,hOk,SW_SHOW
;			invoke SetClassLong,hWin,GCL_STYLE, styleTab
		.endif
	.else
		mov		eax,FALSE
		ret

	.endif
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
		invoke GetDlgItem,hWin,IDC_BTN1
		mov		hOk, eax
		invoke GetDlgItem,hWin,IDC_TAB1
		mov		hTab,eax
		
		mov		ts.imask,TCIF_TEXT
		mov		ts.lpReserved1,0
		mov		ts.lpReserved2,0
		mov		ts.iImage,-1
		mov		ts.lParam,0
		
		;Create the tabs
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
		
		; Load Image
		invoke GetDlgItem,hTabDlg,IDC_IMG1
		mov hImage1, eax
		
		invoke GetDlgItem,hTabDlg[16],IDC_IMG1
		mov hImage2, eax
		
		invoke LoadBitmap, hInstance, side_img
		invoke SendMessage, hImage1, STM_SETIMAGE,IMAGE_BITMAP,eax
		invoke SendMessage, hImage2, STM_SETIMAGE,IMAGE_BITMAP,eax
		
		; Read license file
		invoke GetDlgItem,hTabDlg[4],IDC_EDT1
		mov		hText, eax
		
		invoke Mem_Alloc, 4000h 
		mov pmem, eax
		
		invoke CreateFile, addr license_file, GENERIC_READ, FILE_SHARE_READ, 0, OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, 0
		.if eax==-1
			invoke Mem_Free, pmem
		.else
			mov hFile, eax	
			invoke ReadFile, hFile, pmem, 4000h, readed, 0
			invoke SendMessage, hText, WM_SETTEXT,0,pmem
		.endif

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
			
			.if SelTab==0
				invoke SetWindowText,hOk,addr szStart
			.elseif SelTab==1
				invoke SetWindowText,hOk,addr szNext
			.elseif SelTab==2
				invoke SetWindowText,hOk,addr szInstall
			.elseif SelTab==3; start progress
				invoke ShowWindow,hOk,SW_HIDE
				invoke SetWindowText,hOk,addr szNext
				invoke SendMessage,[hTabDlg+3*4],WM_NULL,0,0
			.elseif SelTab==4
				invoke SetWindowText,hOk,addr szFinish
				invoke ShowWindow,hOk,SW_SHOW
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
