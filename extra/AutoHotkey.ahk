SetTitleMatchMode RegEx
CoordMode Mouse, Screen

; calculator on Win-C
#c::Run, C:\Windows\system32\calc.exe

; mouse buttons to switch messages in outlook reading pane
#IfWinActive ahk_exe OUTLOOK.EXE
    ^PgUp:: send ^{,}
    ^PgDn:: send ^{.}
#IfWinActive

; CapsLock sends Ctrl-B as tmux leader. Only in mintty windows
#IfWinActive ahk_class mintty
    CapsLock::Send {LControl Down}b
    CapsLock Up::Send {LControl Up}
#IfWinActive

; CapsLock is control otherwise
CapsLock::LControl

; Shift-CapsLock to toggle CapsLock
+CapsLock::
if GetKeyState("CapsLock", "T") = 1
    SetCapsLockState, Off
else
    SetCapsLockState, On
return

; Media Buttons
ScrollLock::Media_Play_Pause
AppsKey & PgUp::    send {Volume_Up}
AppsKey & PgDn::    send {Volume_Down}
AppsKey & Home::    send {Volume_Mute}
AppsKey & End::     send {Media_Next}
AppsKey & Del::     send {Media_Prev}
AppsKey & Down::    send {Media_Play_Pause}

; For thinkpads which don't have a Fn key on the right.
; I think these F-keys correspond to the usual functions
AppsKey & F10:: send {Volume_Mute}
AppsKey & F11:: send {Volume_Down}
AppsKey & F12:: send {Volume_Up}
AppsKey & l::   send {LWin Down}l{Lwin Up}

AppsKey::AppsKey

; vim-like key bindings for window movement (not used much)
#+h::#+Left
#+l::#+Right
#j::#Down
#k::#Up
