Scriptname mzinUtilityPlayerAlias extends ReferenceAlias

mzinTextureUtility Property TexUtil Auto
mzinOverlayUtility Property OlUtil Auto
mzinInit Property Init Auto
mzinUtility Property mzinUtil Auto

Actor Property PlayerRef Auto

MagicEffect Property mzinDirtinessTier2Effect Auto
MagicEffect Property mzinDirtinessTier3Effect Auto

Formlist Property mzinDirtyActorsList Auto

Event OnPlayerLoadGame() ; run whenever possible
	mzinUtil.LogTrace("PlayerLoadGame ============================")
	if !Init.DoHardCheck()
		mzinUtil.LogNotification("Crucial dependencies are missing. Check Auxiliary when initialized.", true)
	endIf
	int iSoftCheck = Init.DoSoftCheck()
	if mzinUtil.Menu.cachedSoftCheck != iSoftCheck
		Init.SetInternalVariables()
		mzinUtil.Menu.cachedSoftCheck = iSoftCheck
	endIf
	
	RegisterForModEvent("BiS_ForbidBathing", "OnBiS_ForbidBathing")
	RegisterForModEvent("BiS_PermitBathing", "OnBiS_PermitBathing")

	SendModEvent("mzin_Int_PlayerLoadsGame")
EndEvent

Event OnBiS_ForbidBathing(Form Sender, Form ForbiddenActor, String ForbiddenString)
	If StorageUtil.FormListFind(ForbiddenActor, "BiS_ForbiddenSenders", Sender) == -1
		StorageUtil.FormListAdd(none, "BiS_ForbiddenActors", ForbiddenActor, allowDuplicate = false)
		StorageUtil.FormListAdd(ForbiddenActor, "BiS_ForbiddenSenders", Sender, allowDuplicate = false)
		StorageUtil.StringListAdd(ForbiddenActor, "BiS_ForbiddenString", ForbiddenString, allowDuplicate = true)
		mzinUtil.LogTrace("Forbid bathing event received for " + ForbiddenActor + " from sender " + Sender)
	Else
		mzinUtil.LogTrace("Forbid bathing event received for " + ForbiddenActor + " but sender " + Sender + " has already forbidden bathing")
	EndIf
EndEvent

Event OnBiS_PermitBathing(Form Sender, Form ForbiddenActor)
	Int Index = StorageUtil.FormListFind(ForbiddenActor, "BiS_ForbiddenSenders", Sender)
	If Index != -1
		StorageUtil.StringListRemoveAt(ForbiddenActor, "BiS_ForbiddenString", Index)
		StorageUtil.FormListRemoveAt(ForbiddenActor, "BiS_ForbiddenSenders", Index)
		If StorageUtil.FormListCount(ForbiddenActor, "BiS_ForbiddenSenders") == 0
			StorageUtil.FormListRemove(none, "BiS_ForbiddenActors", ForbiddenActor, allInstances = true) ; Remove actor from forbidden list
			
			; Clean up
			StorageUtil.StringListClear(ForbiddenActor, "BiS_ForbiddenString")
			StorageUtil.FormListClear(ForbiddenActor, "BiS_ForbiddenSenders")
		EndIf
		mzinUtil.LogTrace(Sender + " permits bathing on " + ForbiddenActor)
	Else
		mzinUtil.LogTrace("PermitBathing event received for " + ForbiddenActor + " but sender " +  Sender + " was not found in the list")
	EndIf
EndEvent

Function CheckDirt(Actor akTarget)
	OlUtil.ClearDirtGameLoad(akTarget)
	If akTarget.HasMagicEffect(mzinDirtinessTier2Effect) || akTarget.HasMagicEffect(mzinDirtinessTier3Effect)
		mzinUtil.LogTrace("Adding dirt to: " + akTarget.GetBaseObject().GetName())
		OlUtil.ApplyDirt(akTarget, StorageUtil.GetFloatValue(akTarget, "Mzin_ActorDirtiness", 1.0))
	Else
		mzinUtil.LogTrace("Actor is clean: " + akTarget.GetBaseObject().GetName())
	EndIf
EndFunction