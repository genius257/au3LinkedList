#include "..\Doubly.au3"

$tDoublyLinkedList = DllStructCreate($__g_au3LinkedList_doubly_tagList)
_test_log($tDoublyLinkedList)
_au3LinkedList_Doubly_List_Append($tDoublyLinkedList, 0xF)
_au3LinkedList_Doubly_List_Append($tDoublyLinkedList, 0xFF)
_au3LinkedList_Doubly_List_Append($tDoublyLinkedList, 0xFFF)
_test_log($tDoublyLinkedList)
_au3LinkedList_Doubly_List_AppendAt($tDoublyLinkedList, 1, 0xABC)
_test_log($tDoublyLinkedList)
_au3LinkedList_Doubly_List_Remove($tDoublyLinkedList, 0xCBA)
_test_log($tDoublyLinkedList)
_au3LinkedList_Doubly_List_Remove($tDoublyLinkedList, 0xABC)
_test_log($tDoublyLinkedList)
_au3LinkedList_Doubly_List_RemoveAt($tDoublyLinkedList, 1)
_test_log($tDoublyLinkedList)
_au3LinkedList_Doubly_List_Reverse($tDoublyLinkedList)
_test_log($tDoublyLinkedList)
_au3LinkedList_Doubly_List_Swap($tDoublyLinkedList, 0, 1)
_test_log($tDoublyLinkedList)
ConsoleWrite(_au3LinkedList_Doubly_List_Length($tDoublyLinkedList)&@CRLF)
ConsoleWrite("-------------------------------Traverse test----------------------------------------"&@CRLF)
_au3LinkedList_Doubly_List_Traverse($tDoublyLinkedList, cb)
ConsoleWrite("-------------------------------TraverseReverse test---------------------------------"&@CRLF)
_au3LinkedList_Doubly_List_TraverseReverse($tDoublyLinkedList, cb)
ConsoleWrite("------------------------------------------------------------------------------------"&@CRLF)
ConsoleWrite(_au3LinkedList_Doubly_List_Search($tDoublyLinkedList, 0xFF)&@CRLF)
ConsoleWrite(_au3LinkedList_Doubly_List_Search($tDoublyLinkedList, 0xFFF)&@CRLF)

Func _test_log($tDoublyLinkedList)
    Local $hCurrent = $tDoublyLinkedList.head
    Local $iIndex = 0
    ConsoleWrite(StringFormat("doublyLinkedList: %s", DllStructGetPtr($tDoublyLinkedList))&@CRLF)
    while ($hCurrent)
        $tCurrent = _au3LinkedList_Doubly_Node_Create($hCurrent)

        ConsoleWrite(StringFormat("    [%s]: %s", $iIndex, $tCurrent.data)&@crlf)

        $hCurrent = $tCurrent.next
        $iIndex += 1
    WEnd
EndFunc

Func cb($tNode)
    ConsoleWrite("cb: "&$tNode.data&@CRLF)
EndFunc
