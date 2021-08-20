#include "./src/Memory.au3"

Global Const $__g_au3LinkedList_doubly_tagList = "PTR head;PTR tail;"
Global Const $__g_au3LinkedList_doubly_tagNode = "PTR previous;PTR data;PTR next;"

Func _au3LinkedList_Doubly_Node_Create($pNode = 0)
    If IsDllStruct($pNode) Then Return $pNode
    Return DllStructCreate($__g_au3LinkedList_doubly_tagNode, $pNode)
EndFunc

Func _au3LinkedList_Doubly_List_Create($pList = 0)
    If IsDllStruct($pList) Then Return $pList
    Return DllStructCreate($__g_au3LinkedList_doubly_tagList, $pList)
EndFunc

Func _au3LinkedList_Doubly_List_Append($vDoublyLinkedList, $vItem)
    Local $tDoublyLinkedList = _au3LinkedList_Doubly_List_Create($vDoublyLinkedList)
    Local $hItem = IsDllStruct($vItem) ? _au3LinkedList_Memory_AllocDllStruct($vItem) : $vItem
    Local $hNode = _au3LinkedList_Memory_AllocDllStruct(DllStructCreate($__g_au3LinkedList_doubly_tagNode))
    Local $tNode = DllStructCreate($__g_au3LinkedList_doubly_tagNode, $hNode)
        $tNode.data = $hItem
    If $tDoublyLinkedList.head = 0 Then
        $tDoublyLinkedList.head = $hNode
        $tDoublyLinkedList.tail = $hNode
    Else
        $tNode.previous = $tDoublyLinkedList.tail
        $tTailNode = DllStructCreate($__g_au3LinkedList_doubly_tagNode, $tDoublyLinkedList.tail)
        $tTailNode.next = $hNode
        $tDoublyLinkedList.tail = $hNode
    EndIf
EndFunc

Func _au3LinkedList_Doubly_List_AppendAt($vDoublyLinkedList, $pos, $vItem)
    Local $fNode = _au3LinkedList_Doubly_Node_Create
    Local $tDoublyLinkedList = _au3LinkedList_Doubly_List_Create($vDoublyLinkedList)
    Local $current = $tDoublyLinkedList.head
    Local $counter = 1
    Local $hItem = IsDllStruct($vItem) ? _au3LinkedList_Memory_AllocDllStruct($vItem) : $vItem
    Local $hNode = _au3LinkedList_Memory_AllocDllStruct(DllStructCreate($__g_au3LinkedList_doubly_tagNode))
    Local $tNode = $fNode($hNode)
        $tNode.data = $hItem
    If $pos = 0 Then
        $tHeadNode = $fNode($tDoublyLinkedList.head)
        $tHeadNode.previous = $hNode
        $tNode.next = $tDoublyLinkedList.head
        $tDoublyLinkedList.head = $hNode
    Else
        While $current
            $current = $fNode($current).next

            If $counter = $pos Then
                $tNode.previous = $fNode($current).previous
                Local $tPreviousNode = $fNode($fNode($current).previous)
                $tPreviousNode.next = $hNode
                $tNode.next = $current
                Local $tCurrentNode = $fNode($current)
                $tCurrentNode.previous = $hNode
            EndIf
            $counter+=1
        WEnd
    EndIf
EndFunc

Func _au3LinkedList_Doubly_List_Remove($vDoublyLinkedList, $hItem, $bFree = True)
    Local $fNode = _au3LinkedList_Doubly_Node_Create
    Local $tDoublyLinkedList = _au3LinkedList_Doubly_List_Create($vDoublyLinkedList)
    Local $current = $tDoublyLinkedList.head
    Local $next

    While $current
        If $fNode($current).data = $hItem Then
            If $current = $tDoublyLinkedList.head And $current = $tDoublyLinkedList.tail Then
                $tDoublyLinkedList.head = 0
                $tDoublyLinkedList.tail = 0
            ElseIf $current = $tDoublyLinkedList.head Then
                $tDoublyLinkedList.head = $fNode($tDoublyLinkedList.head).next
                Local $tHeadNode = $fNode($tDoublyLinkedList.head)
                $tHeadNode.previous = 0
            ElseIf $current = $tDoublyLinkedList.tail Then
                $tDoublyLinkedList.tail = $fNode($tDoublyLinkedList.tail).previous
                Local $tTailNode = $fNode($tDoublyLinkedList.tail)
                $tTailNode.next = 0
            Else
                Local $tPreviousNode = $fNode($fNode($current).previous)
                Local $tNextNode = $fNode($fNode($current).next)
                $tPreviousNode.next = $fNode($current).next
                $tNextNode.previous = $fNode($current).previous
            EndIf
            If $bFree Then
                $next = $fNode($current).next
                _au3LinkedList_Memory_FreeDllStruct($current)
                $current = $next
                ContinueLoop
            EndIf
        EndIf
        $current = $fNode($current).next
    WEnd
EndFunc

Func _au3LinkedList_Doubly_List_RemoveAt($vDoublyLinkedList, $pos, $bFree = True)
    Local $fNode = _au3LinkedList_Doubly_Node_Create
    Local $tDoublyLinkedList = _au3LinkedList_Doubly_List_Create($vDoublyLinkedList)
    Local $current = $tDoublyLinkedList.head
    Local $counter = 1
    If $pos = 0 Then
        $tDoublyLinkedList.head = $fNode($tDoublyLinkedList.head).next
        $tHeadNode = $fNode($tDoublyLinkedList.head)
        $tHeadNode.previous = 0

        If $bFree Then
            $next = $fNode($current).next
            _au3LinkedList_Memory_FreeDllStruct($current)
            $current = $next
        EndIf
    Else
        While $current
            $current = $fNode($current).next
            If $current = $tDoublyLinkedList.tail Then
                $tDoublyLinkedList.tail = $fNode($tDoublyLinkedList.tail).previous
                Local $tTailNode = $fNode($tDoublyLinkedList.tail)
                $tTailNode.next = 0
            ElseIf $counter = $pos Then
                Local $tPreviousNode = $fNode($fNode($current).previous)
                $tPreviousNode.next = $fNode($current).next
                Local $tNextNode = $fNode($fNode($current).next)
                $tNextNode.previous = $fNode($current).previous
                If $bFree Then
                    _au3LinkedList_Memory_FreeDllStruct($current)
                EndIf
                ExitLoop
            EndIf
            $counter+=1
        WEnd
    EndIf
EndFunc

Func _au3LinkedList_Doubly_List_Reverse($vDoublyLinkedList)
    Local $fNode = _au3LinkedList_Doubly_Node_Create
    Local $tDoublyLinkedList = _au3LinkedList_Doubly_List_Create($vDoublyLinkedList)
    Local $current = $tDoublyLinkedList.head
    local $prev = 0
    While $current
        Local $next = $fNode($current).next
        Local $tCurrent = $fNode($current)
        $tCurrent.next = $prev
        $tCurrent.previous = $next
        $prev = $current
        $current = $next
    WEnd
    $tDoublyLinkedList.tail = $tDoublyLinkedList.head
    $tDoublyLinkedList.head = $prev
EndFunc

Func _au3LinkedList_Doubly_List_Swap($vDoublyLinkedList, $nodeOne, $nodeTwo)
    Local $fNode = _au3LinkedList_Doubly_Node_Create
    Local $tDoublyLinkedList = _au3LinkedList_Doubly_List_Create($vDoublyLinkedList)
    Local $current = $tDoublyLinkedList.head
    Local $counter = 0
    Local $firstNode
    While $current
        If $counter = $nodeOne Then
            $firstNode = $current
        ElseIf $counter = $nodeTwo Then
            Local $tCurrent = $fNode($current)
            Local $tFirstNode = $fNode($firstNode)
            Local $temp = $tCurrent.data
            $tCurrent.data = $tFirstNode.data
            $tFirstNode.data = $temp
        EndIf
        $current = $fNode($current).next
        $counter+=1
    WEnd
    return True
EndFunc

Func _au3LinkedList_Doubly_List_IsEmpty($vDoublyLinkedList)
    Return _au3LinkedList_Doubly_List_Length($vDoublyLinkedList) < 1
EndFunc

Func _au3LinkedList_Doubly_List_Length($vDoublyLinkedList)
    Local $fNode = _au3LinkedList_Doubly_Node_Create
    Local $tDoublyLinkedList = _au3LinkedList_Doubly_List_Create($vDoublyLinkedList)
    Local $current = $tDoublyLinkedList.head
    Local $counter = 0
    While $current
        $counter+=1
        $current = $fNode($current).next
    WEnd
    Return $counter
EndFunc

Func _au3LinkedList_Doubly_List_Traverse($vDoublyLinkedList, $fn)
    Local $fNode = _au3LinkedList_Doubly_Node_Create
    Local $tDoublyLinkedList = _au3LinkedList_Doubly_List_Create($vDoublyLinkedList)
    Local $current = $tDoublyLinkedList.head
    While $current
        $tCurrent = $fNode($current)
        $fn($tCurrent)
        $current = $tCurrent.next
    WEnd
    Return True
EndFunc

Func _au3LinkedList_Doubly_List_TraverseReverse($vDoublyLinkedList, $fn)
    Local $fNode = _au3LinkedList_Doubly_Node_Create
    Local $tDoublyLinkedList = _au3LinkedList_Doubly_List_Create($vDoublyLinkedList)
    Local $current = $tDoublyLinkedList.tail
    While $current
        $tCurrent = $fNode($current)
        $fn($tCurrent)
        $current = $tCurrent.previous
    WEnd
    Return True
EndFunc

Func _au3LinkedList_Doubly_List_Search($vDoublyLinkedList, $hData)
    Local $fNode = _au3LinkedList_Doubly_Node_Create
    Local $tDoublyLinkedList = _au3LinkedList_Doubly_List_Create($vDoublyLinkedList)
    Local $current = $tDoublyLinkedList.head
    Local $counter = 0
    While $current
        Local $tCurrent = $fNode($current)
        If $tCurrent.data = $hData Then Return $counter
        $current = $tCurrent.next
        $counter+=1
    WEnd
    Return False
EndFunc
