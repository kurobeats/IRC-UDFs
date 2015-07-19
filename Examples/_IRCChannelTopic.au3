#include ".\..\IRC.au3"

; Allow some TCP lag
Opt("TCPTimeout", 200)

; Start Example
Example()

Func Example()

	; Start Up Networking
	TCPStartup()

	; Track Own Name
	Local $sName = "Au3bot" & Random(1000, 9999, 1)

	; Connect to IRC. Send Password, if any. Declare User Identity.
	Local $Sock = _IRCConnect("irc.freenode.net", 6667, $sName, 0, "Au3Bot", "")

	; If Error Connecting
	If @error Then

		; Display Message on Error
		ConsoleWrite("Server Connection Error: " & @error & " Extended: " & @extended & @CRLF)

		; Shutdown Networking
		TCPShutdown()

		; Exit with Error
		Exit 1

	EndIf

	; Prepare to Receive Data
	Local $sRecv = ""

	; Start Loop
	While 1

		; Receive Data
		$sRecv = _IRCGetMsg($Sock)

		; If Error Getting Data
		If @error Then

			; Display Message on Error
			ConsoleWrite("Recv Error: " & @error & " Extended: " & @extended & @CRLF)

			; Shutdown Networking
			TCPShutdown()

			; Exit with Error
			Exit 1

		; Otherwise, If No Data
		ElseIf Not $sRecv Then

			; Continue Checking
			ContinueLoop

		EndIf

		; Write Received Data to Console
		ConsoleWrite($sRecv)

		; Split Data into Commands and Parameters for Processing
		Local $sTemp = StringSplit($sRecv, " ")

		; If Not Usable, then Skip this Data
		If $sTemp[0] <= 2 Then ContinueLoop

		; Decide What To Do Based on Received Data
		Switch $sTemp[2]

			; On Server Welcome
			Case "001"

				; Join a #ircudftest
				_IRCChannelJoin($Sock, "#ircudftest")

			; On Channel Join
			Case "366"

				; Set Channel Topic
				_IRCChannelTopic($Sock, "#ircudftest", $sName & " topic set test")

				; Disconnect
				_IRCDisconnect($Sock)

				; Shutdown Networking
				TCPShutdown()

				; Exit
				Exit

		EndSwitch
	WEnd
EndFunc