#NoEnv

Gui , Timer:Show , w165 h114 , Timer
Gui , Timer:+AlwaysOnTop +SysMenu -MinimizeBox -MaximizeBox
Gui , Timer:Color , 1F1F23

Gui , Timer:Font , s33 cLime , Digital Dismay
Gui , Timer:Add , Text , x0 y1 w169 h45 center vdispt , 00:00:00

Gui , Timer:Font , s12 cBlack , Trebuchet MS
Gui , Timer:Add , Button , gstart x0 y46 w80 h25 center , Re/Start
Gui , Timer:Add , Button , gresume x80 y46 w85 h25 center , P/Resume

Gui , Timer:Font , s11 cBlack , Trebuchet MS
Gui , Timer:Add , Edit , x0 y71 w55 h25 center ve3
Gui , Timer:Add , UpDown , x0 y71 w55 h25 -VScroll , 0
Gui , Timer:Add , Edit , x55 y71 w55 h25 center ve2
Gui , Timer:Add , UpDown , x55 y71 w55 h25 -VScroll , 0
Gui , Timer:Add , Edit , x110 y71 w55 h25 center ve1
Gui , Timer:Add , UpDown , x110 y71 w55 h25 -VScroll , 10

Gui , Timer:Font , s10 cFFFAFA , Trebuchet MS
Gui , Timer:Add , Text , vTStart x3 y96 w75 ,
Gui , Timer:Add , Text , vTEnds x109 y96 w75 ,
return

human2Unix(humanTime)
{
	humanTime -= 1970, s
	return humanTime
}

unix2Human(unixTimestamp)
{
	retDate = 19700101000000
	retDate += unixTimestamp, s
	return retDate
}


start:
	Pause , 0
	Gui , Submit , NoHide

	Gui , Timer:Color , 1F1F23
	Gui , Timer:Font , s33 cLime , Digital Dismay
	GuiControl , Timer:Font , dispt

	If e3 is not number
		e3:=0
	If e2 is not number
		e2:=0
	If e1 is not number
		e1:=0
	TimerExpire := e3*3600+e2*60+e1

	hur := Format("{:02}" , floor(TimerExpire/3600))
	min := Format("{:02}" , floor(mod(TimerExpire/60, 60)))
	sec := Format("{:02}" , floor(mod(TimerExpire, 60)))
	GuiControl , Timer:Text , dispt , %hur%:%min%:%sec%

	TimerFinish := human2Unix(A_Now)+TimerExpire

	FormatTime , TimeString , %A_Now% , HH:mm:ss
	GuiControl , Timer:Text , TStart , %TimeString%

	FormatTime , TimeString , % unix2Human(TimerFinish) , HH:mm:ss
	GuiControl , Timer:Text , TEnds , %TimeString%

	SetTimer , CDTimer , 100
return

resume:
	Pause , Toggle , 1
	IsPause := !IsPause
	If !IsPause
	{
		TimerFinish := human2Unix(A_Now)+TimeLeft

		FormatTime , TimeString , %A_Now% , HH:mm:ss
		GuiControl , Timer:Text , TStart , %TimeString%

		FormatTime , TimeString , % unix2Human(TimerFinish) , HH:mm:ss
		GuiControl , Timer:Text , TEnds , %TimeString%
	}
return

CDTimer:
	If !IsPause
	{
		TimeLeft := TimerFinish-human2Unix(A_Now)
	}

	hur := Format("{:02}" , floor(abs(TimeLeft/3600)))
	min := Format("{:02}" , floor(mod(abs(TimeLeft/60), 60)))
	sec := Format("{:02}" , floor(mod(abs(TimeLeft), 60)))

	GuiControl , Timer:Text , dispt , %hur%:%min%:%sec%
	Gui , Timer:Show , NoActivate , %hur%:%min%:%sec%

	if (TimeLeft < 0)
	{
		IsDone := !IsDone
		If IsDone
		{
			Gui , Timer:Font , s33 cBlack
			Gui , Timer:Color , FFFF00
		}
		else
		{
			Gui , Timer:Font , s33 cRed
			Gui , Timer:Color , 1F1F23
		}
		GuiControl , Timer:Font , dispt
	}
return

TimerGuiClose:
ExitApp