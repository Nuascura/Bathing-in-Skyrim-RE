;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 1
Scriptname mzinTIF__02000065 Extends TopicInfo Hidden

;BEGIN FRAGMENT Fragment_0
Function Fragment_0(ObjectReference akSpeakerRef)
Actor akSpeaker = akSpeakerRef as Actor
;BEGIN CODE
if UI.IsMenuOpen("Dialogue Menu")
    UI.InvokeString("Dialogue Menu", "_global.skse.CloseMenu", "Dialogue Menu")
endIf
BatheQuest.TryWashActor(BatheQuest.PlayerRef, None)
if BatheQuest.Menu.AutomateFollowerBathing.GetValue() < 1 || PO3_SKSEfunctions.GetPlayerFollowers().Find(akSpeaker) == -1
    BatheQuest.TryWashActor(akSpeaker, None)
endIf
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment

mzinBatheQuest Property BatheQuest Auto
