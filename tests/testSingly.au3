#include "..\Singly.au3"

$tSinglyLinkedList = DllStructCreate($__g_au3LinkedList_singly_tagList)
_test_log($tSinglyLinkedList)
_au3LinkedList_Singly_List_Append($tSinglyLinkedList, 0xF)
_au3LinkedList_Singly_List_Append($tSinglyLinkedList, 0xFF)
_au3LinkedList_Singly_List_Append($tSinglyLinkedList, 0xFFF)
_test_log($tSinglyLinkedList)
_au3LinkedList_Singly_List_AppendAt($tSinglyLinkedList, 1, 0xABC)
_test_log($tSinglyLinkedList)
_au3LinkedList_Singly_List_Remove($tSinglyLinkedList, 0xCBA)
_test_log($tSinglyLinkedList)
_au3LinkedList_Singly_List_Remove($tSinglyLinkedList, 0xABC)
_test_log($tSinglyLinkedList)
_au3LinkedList_Singly_List_RemoveAt($tSinglyLinkedList, 1)
_test_log($tSinglyLinkedList)
_au3LinkedList_Singly_List_Reverse($tSinglyLinkedList)
_test_log($tSinglyLinkedList)
_au3LinkedList_Singly_List_Swap($tSinglyLinkedList, 0, 1)
_test_log($tSinglyLinkedList)
ConsoleWrite(_au3LinkedList_Singly_List_Length($tSinglyLinkedList)&@CRLF)
ConsoleWrite("-------------------------------Traverse test----------------------------------------"&@CRLF)
_au3LinkedList_Singly_List_Traverse($tSinglyLinkedList, cb)
ConsoleWrite("------------------------------------------------------------------------------------"&@CRLF)
ConsoleWrite(_au3LinkedList_Singly_List_Search($tSinglyLinkedList, 0xFF)&@CRLF)
ConsoleWrite(_au3LinkedList_Singly_List_Search($tSinglyLinkedList, 0xFFF)&@CRLF)

Func _test_log($tSinglyLinkedList)
    Local $hCurrent = $tSinglyLinkedList.head
    Local $iIndex = 0
    ConsoleWrite(StringFormat("singlyLinkedList: %s", DllStructGetPtr($tSinglyLinkedList))&@CRLF)
    while ($hCurrent)
        $tCurrent = _au3LinkedList_Singly_Node_Create($hCurrent)

        ConsoleWrite(StringFormat("    [%s]: %s", $iIndex, $tCurrent.data)&@crlf)

        $hCurrent = $tCurrent.next
        $iIndex += 1
    WEnd
EndFunc

Func cb($tNode)
    ConsoleWrite("cb: "&$tNode.data&@CRLF)
EndFunc
