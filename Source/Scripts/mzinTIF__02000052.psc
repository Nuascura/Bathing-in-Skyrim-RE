;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 1
Scriptname mzinTIF__02000052 Extends TopicInfo Hidden

;BEGIN FRAGMENT Fragment_0
Function Fragment_0(ObjectReference akSpeakerRef)
Actor akSpeaker = akSpeakerRef as Actor
;BEGIN CODE
mzinFollowerCanBathe_dia.SetValue(BatheQuest.IsInWater(akSpeaker) as int)
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment

mzinBatheQuest Property BatheQuest Auto
GlobalVariable Property mzinFollowerCanBathe_dia  Auto  
