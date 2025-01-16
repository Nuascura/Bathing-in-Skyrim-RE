Scriptname mzinTextureUtility extends Quest  

String[] Property TexNames Auto Hidden
String[] Property TexPathsF Auto Hidden
String[] Property TexPathsM Auto Hidden
Int[] Property DirtSetCount Auto Hidden

mzinBatheMCMMenu Property Menu Auto
mzinUtility Property mzinUtil Auto

Event OnInit()
	TexNames = new String[4]
	TexNames[0] = "DirtFXBody.dds"
	TexNames[1] = "DirtFXHands.dds"
	TexNames[2] = "DirtFXFeet.dds"
	TexNames[3] = "DirtFXFace.dds"

	TexPathsF = new String[5]
	TexPathsF[0] = "\\mzin\\Bathe\\Set1\\F\\"
	TexPathsF[1] = "\\mzin\\Bathe\\Set2\\F\\"
	TexPathsF[2] = "\\mzin\\Bathe\\Set3\\F\\"
	TexPathsF[3] = "\\mzin\\Bathe\\Set4\\F\\"
	TexPathsF[4] = "\\mzin\\Bathe\\Set5\\F\\"

	TexPathsM = new String[5]
	TexPathsM[0] = "\\mzin\\Bathe\\Set1\\M\\"
	TexPathsM[1] = "\\mzin\\Bathe\\Set2\\M\\"
	TexPathsM[2] = "\\mzin\\Bathe\\Set3\\M\\"
	TexPathsM[3] = "\\mzin\\Bathe\\Set4\\M\\"
	TexPathsM[4] = "\\mzin\\Bathe\\Set5\\M\\"

	DirtSetCount = new Int[2]
	DirtSetCount[0] = 0
	DirtSetCount[1] = 0
EndEvent

Function UtilInit()
	OnInit()
	DirtSetCount[0] = InitTexSets(0) ; male
	DirtSetCount[1] = InitTexSets(1) ; female
EndFunction

Int Function InitTexSets(int aiSex)
	; this is a relatively heavy function. Should not be run with OnInit()

	Int SetCount
	Int TexCount
	String SetPrefix
	String SetGender = GetStringFromSex(aiSex)
	String[] TexPaths
	if aiSex
		TexPaths = TexPathsF
	else
		TexPaths = TexPathsM
	endIf
	
	Int i = 0
	While i <= 4
		TexCount = 0
		SetPrefix = "data/Textures/mzin/Bathe/Set" + (i+1) + "/" + SetGender + "/"
		int j = 0
		While j < TexNames.Length
			Menu.UpdateProgressRedetectDirtSets((TexPaths[i] + TexNames[j]))
			mzinUtil.LogTrace("Checking: " + SetPrefix + TexNames[j])
			If MiscUtil.FileExists(SetPrefix + TexNames[j])
				mzinUtil.LogTrace("Dirt Set " + (i + 1) + ": Found " + TexNames[j])
				TexCount += 1
			Else
				mzinUtil.LogTrace("Warning: Dirt Set " + (i + 1) + ": DOES NOT EXIST: " + TexNames[j])
			EndIf
			j += 1
		EndWhile
		If TexCount == TexNames.Length ; Complete texture set
			mzinUtil.LogTrace("Complete set found!! Set " + i + "(" + SetGender + ")")
			SetCount += 1
		ElseIf TexCount == 0
			mzinUtil.LogTrace("Empty set detected. Ending search")
			Return SetCount
		Else
			mzinUtil.LogMessageBox("Error: InitTexSets(): Incomplete texture set detected for set " + i + "(" + SetGender + "). There should be " + TexNames.Length + " texture files per set but Mzin detected only " + TexCount + " files. One or more files are either missing or named incorrectly. You need to fix this first! Check your papyrus log. Search 'mzin'")
			Return -1
		EndIf
		i += 1
	EndWhile
	Return SetCount
EndFunction

String Function PickRandomDirtSet(int aiSex)
	Return "\\mzin\\Bathe\\Set" + Utility.RandomInt(1, DirtSetCount[aiSex]) + "\\" + GetStringFromSex(aiSex) + "\\"
EndFunction

String Function GetStringFromSex(int aiSex)
	if aiSex as bool
		return "F"
	else
		return "M"
	endIf
EndFunction