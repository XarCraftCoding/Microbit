;;;
;;; File Table: Basic File Table Made With DB, String Consists Of '{fileName1-sector#, fileName2-sector#, ...fileNameN-sector#)'
;;;
db '{calculator-04, notepad-06}'

	;; Sector Padding Magic
	times 512-($-$$) db 0	; Pad Rest Of File To 0s Until 512th Byte / End Of Sector