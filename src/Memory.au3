#include <Memory.au3>

Func _au3LinkedList_Memory_AllocDllStruct($tSource)
    Local $hBytes = _MemGlobalAlloc(DllStructGetSize($tSource), $GPTR)
    _MemMoveMemory(DllStructGetPtr($tSource), $hBytes, DllStructGetSize($tSource))
    Return $hBytes
EndFunc

Func _au3LinkedList_Memory_GlobalHandle($pMem)
   Local $aRet = DllCall("kernel32.dll", "ptr", "GlobalHandle", "ptr", $pMem)
   If @error<>0 Then Return SetError(@error, @extended, 0)
   If $aRet[0]=0 Then Return SetError(-1, @extended, 0)
   Return $aRet[0]
EndFunc

Func _au3LinkedList_Memory_FreeDllStruct($hSource)
    Return _MemGlobalFree(_au3LinkedList_Memory_GlobalHandle($hSource))
EndFunc
