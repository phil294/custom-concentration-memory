#noenv
setworkingdir %a_scriptdir%
;;;;;;;;;;;;
pic_width := 100
pic_height := 100
;;;;;;;;;;;;

	if(!fileExist("data")) {
		msgbox data folder missing. exiting
		exitapp
	}

	i:=0
	pics := []
	loop, files, data\*
	{
		i++
		file := "data\" a_loopfilename
		pics.Push(file)
	}
	if(mod(i,2)!=0) {
		msgbox, odd number of files in data folder. exiting
		exitapp
	}
	row_length := floor(sqrt(i))

	ids=
	while(i>0)
		ids .= "," i--
	ids := subStr(ids, 2)
	sort, ids, random D,

	row:=0
	col:=0
	hwnd_to_index := []
	loop, parse, ids, `,
	{
		col++
		if(col > row_length) {
			col:=1
			row++
		}
		x := pic_width * (col-1)
		y := pic_height * row
		gui, add, picture, x%x% y%y% w%pic_width% h%pic_height% vreal%a_loopfield%, % pics[a_loopField]
		gui, add, text, x%x% y%y% w%pic_width% h%pic_height% gpic_click hwndthehwnd vcloak%a_loopfield% center 0x200, ?
		hwnd_to_index[thehwnd] := a_loopfield
	}
	tries := 0
	gui, font, s20 cgreen
	gui, add, text, vtries w100
	gui, show

return

open=
pic_click(hwnd,event,info,error:="") {
	global
	id := hwnd_to_index[hwnd]
	guicontrol, hide, cloak%id%
	if(!open) {
		open = %id%
	} else {
		; check if abs(diff) == 1 and lower one odd
		diff := id - open
		if((diff==1 && mod(open,2)==1) || diff==-1 && mod(id,2)==1) {
			; match
		} else {
			sleep 400
			guicontrol, show, cloak%id%
			guicontrol, show, cloak%open%
		}
		open=
		guicontrol,, tries, % ++tries
	}
}

guiclose:
	exitapp
return