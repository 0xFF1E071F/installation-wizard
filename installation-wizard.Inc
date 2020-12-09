
include windows.inc
include kernel32.inc
include user32.inc
include Comctl32.inc
include shell32.inc

includelib kernel32.lib
includelib user32.lib
includelib Comctl32.lib
includelib shell32.lib

;include masm32.inc
;include debug.inc
;includelib masm32.lib
;includelib debug.lib
;
DlgProc			PROTO	:HWND,:UINT,:WPARAM,:LPARAM

.const
;installation-wizard.dlg
IDD_DIALOG1						equ 101
IDC_SHP1						equ 1003
IDC_BTN2						equ 1002
IDC_BTN1						equ 1001
IDC_TAB1						equ 1004

;installation-wizard.Rc

;tabDlg1.dlg
IDD_DLG1						equ 1000

;tabDlg2.dlg
IDD_DLG2						equ 1001

;tabDlg3.dlg
IDD_DLG3						equ 1002

;tabDlg4.dlg
IDD_DLG4						equ 1003

;tabDlg5.dlg
IDD_DLG5						equ 1004


;#########################################################################
.data

TabTitle1       db "Intro",0
TabTitle2       db "Licence",0
TabTitle3       db "Path",0
TabTitle4		db "Setup",0
TabTitle5		db "Done",0
SelTab			dd 0
CurrentProgress	db 0

btn_install		db "Install",0
btn_next		db "Next",0
btn_start		db "Start",0
browse_ph		db "N",0

folder_path		db MAX_PATH dup(0)
current_dir		db MAX_PATH dup(0)


.data?

hInstance		dd ?
hTab			dd ?
hTabDlg			dd 4 dup(?)

;#########################################################################
