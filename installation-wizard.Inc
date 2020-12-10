
include windows.inc
include kernel32.inc
include user32.inc
include Comctl32.inc
include shell32.inc

includelib kernel32.lib
includelib user32.lib
includelib Comctl32.lib
includelib shell32.lib

DlgProc			PROTO	:HWND,:UINT,:WPARAM,:LPARAM

.const

;installation-wizard.dlg
IDD_DIALOG1						equ 101
IDC_BTN2						equ 1002
IDC_BTN1						equ 1001
IDC_TAB1						equ 1004

;installation-wizard.Rc

;Res\installation-wizardRes.rc
MANIFEST						equ 24

;tabDlg1.dlg
IDD_DLG1						equ 2000
IDC_STC1						equ 2003
IDC_STC2						equ 2004
IDC_STC3						equ 2001
IDC_IMG1						equ 2002

;tabDlg2.dlg
IDD_DLG2						equ 3001
IDC_HDR1						equ 3003
IDC_STC4						equ 3002
IDC_EDT1						equ 3004

;tabDlg3.dlg
IDD_DLG3						equ 4002
IDC_HDR2						equ 4001
IDC_STC5						equ 4003
IDC_BTN3						equ 4004
IDC_EDT2						equ 4005

;tabDlg4.dlg
IDD_DLG4						equ 5003
IDC_HDR3						equ 5001
IDC_STC6						equ 5002
IDC_PGB1						equ 5004
IDC_STC7						equ 5005
IDC_STC8						equ 5006

;tabDlg5.dlg
IDD_DLG5						equ 6004
IDC_IMG2						equ 6001
IDC_STC9						equ 6002
IDC_STC10						equ 6003


;#########################################################################
.data
side_img		db 123
TabTitle1       db "Intro",0
TabTitle2       db "License",0
TabTitle3       db "Path",0
TabTitle4		db "Setup",0
TabTitle5		db "Done",0
SelTab			dd 0
progress		db 0

szInstall		db "Install",0
szNext			db "Next",0
szStart			db "Start",0
szFinish		db "Finish",0
license_file	db "LICENSE",0

szExitText		db "Do you really want to stop setup?",0
szExitCaption	db "Exit Setup",0

bitmapName		db "side_img",0
szLicense		db 0
readed			dd 0
pmem 			dd 0

.data?

hInstance		dd ?
hTab			dd ?
hFile			dd ?
hOk				dd ?
hTabDlg			dd 5 dup(?)
hText			dd ?

bmp				dd ?

;#########################################################################
