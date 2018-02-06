SetTitleMatchMode RegEx
CoordMode Mouse, Screen

#+h::#+Left
#+l::#+Right
#j::#Down
#k::#Up
#z::#i

#c::Run, C:\Windows\system32\calc.exe

^F14::^!Tab

#IfWinActive ahk_exe OUTLOOK.EXE
	^PgUp:: send ^{,}
	^PgDn:: send ^{.}
#IfWinActive

Pause::
AppsKey & Up::
IfWinExist, Pandora
{
	ControlSend ahk_parent, {Space}, Pandora
} 
return

;ScrollLock::#5
^CtrlBreak::
;ScrollLock::
IfWinActive, Pandora
{
	WinMinimize, Pandora
}
else IfWinExist, Pandora
{
	WinActivate, Pandora
}
return

^#Right::
IfWinExist, Pandora
{
	ControlSend ahk_parent, {Right}, Pandora
}
return

#IfWinActive Pandora
	Right::return
	^Right::Right
#IfWinActive

#IfWinActive (VNC Viewer)
	RControl::WinActivate ahk_class Shell_TrayWnd
#IfWinActive

;;; BEGIN MAGICAL CAPS-LOCK HANDLING ;;;

#IfWinActive (Oracle VM VirtualBox|PuTTY)
	CapsLock::Send {LControl Down}b
	CapsLock Up::Send {LControl Up}
#IfWinActive

#IfWinActive ahk_class mintty
	CapsLock::Send {LControl Down}b
	CapsLock Up::Send {LControl Up}
#IfWinActive

#IfWinNotActive (Oracle VM VirtualBox|PuTTY)
	CapsLock::LControl
#IfWinNotActive

;CapsLock::LControl

;CapsLock::		send {LControl Down}
;CapsLock Up::	send {LControl Up}
;CapsLock::F12

+CapsLock::
if GetKeyState("CapsLock", "T") = 1
	SetCapsLockState, Off
else
	SetCapsLockState, On
return

;;; END MAGICAL CAPS-LOCK HANDLING ;;;

AppsKey & PgUp::	send {Volume_Up}
AppsKey & PgDn::	send {Volume_Down}
AppsKey & Home::	send {Volume_Mute}
AppsKey & End::		send {Media_Next}
AppsKey & Del::		send {Media_Prev}
AppsKey & Down::	send {Media_Play_Pause}

AppsKey & F10::	send {Volume_Mute}
AppsKey & F11::	send {Volume_Down}
AppsKey & F12::	send {Volume_Up}
AppsKey & l::	send {LWin Down}l{Lwin Up}

AppsKey::AppsKey
