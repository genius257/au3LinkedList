#include "./src/Memory.au3"

Global Const $__g_au3LinkedList_singly_tagList = "PTR head;PTR tail;"
Global Const $__g_au3LinkedList_singly_tagNode = "PTR data;PTR next;"

Func _au3LinkedList_Singly_Node_Create($pNode = 0)
    If IsDllStruct($pNode) Then Return $pNode
    Return DllStructCreate($__g_au3LinkedList_singly_tagNode, $pNode)
EndFunc

Func _au3LinkedList_Singly_List_Create($pList = 0)
    If IsDllStruct($pList) Then Return $pList
    Return DllStructCreate($__g_au3LinkedList_singly_tagList, $pList)
EndFunc

Func _au3LinkedList_Singly_List_Append($vSinglyLinkedList, $vItem)
    Local $tSinglyLinkedList = _au3LinkedList_Singly_List_Create($vSinglyLinkedList)
    Local $hItem = IsDllStruct($vItem) ? _au3LinkedList_Memory_AllocDllStruct($vItem) : $vItem
    Local $hNode = _au3LinkedList_Memory_AllocDllStruct(DllStructCreate($__g_au3LinkedList_singly_tagNode))
    Local $tNode = DllStructCreate($__g_au3LinkedList_singly_tagNode, $hNode)
        $tNode.data = $hItem
    If $tSinglyLinkedList.head = 0 Then
        $tSinglyLinkedList.head = $hNode
        $tSinglyLinkedList.tail = $hNode
    Else
        $tTailNode = DllStructCreate($__g_au3LinkedList_singly_tagNode, $tSinglyLinkedList.tail)
        $tTailNode.next = $hNode
        $tSinglyLinkedList.tail = $hNode
    EndIf
EndFunc

Func _au3LinkedList_Singly_List_AppendAt($vSinglyLinkedList, $pos, $vItem)
    Local $fNode = _au3LinkedList_Singly_Node_Create
    Local $tSinglyLinkedList = _au3LinkedList_Singly_List_Create($vSinglyLinkedList)
    Local $current = $tSinglyLinkedList.head
    Local $previous
    Local $counter = 1
    Local $hItem = IsDllStruct($vItem) ? _au3LinkedList_Memory_AllocDllStruct($vItem) : $vItem
    Local $hNode = _au3LinkedList_Memory_AllocDllStruct(DllStructCreate($__g_au3LinkedList_singly_tagNode))
    Local $tNode = $fNode($hNode)
        $tNode.data = $hItem
    If $pos = 0 Then
        $tHeadNode = $fNode($tSinglyLinkedList.head)
        $tNode.next = $tSinglyLinkedList.head
        $tSinglyLinkedList.head = $hNode
    Else
        While $current
            $previous = $current
            $current = $fNode($current).next

            If $counter = $pos Then
                $previous = $fNode($previous)
                $previous.next = $hNode
                $tNode.next = $current
                Local $tCurrentNode = $fNode($current)
            EndIf
            $counter+=1
        WEnd
    EndIf
EndFunc

Func _au3LinkedList_Singly_List_Remove($vSinglyLinkedList, $hItem, $bFree = True)
    Local $fNode = _au3LinkedList_Singly_Node_Create
    Local $tSinglyLinkedList = _au3LinkedList_Singly_List_Create($vSinglyLinkedList)
    Local $current = $tSinglyLinkedList.head
    Local $previous
    Local $next

    While $current
        If $fNode($current).data = $hItem Then
            If $current = $tSinglyLinkedList.head And $current = $tSinglyLinkedList.tail Then
                $tSinglyLinkedList.head = 0
                $tSinglyLinkedList.tail = 0
            ElseIf $current = $tSinglyLinkedList.head Then
                $tSinglyLinkedList.head = $fNode($tSinglyLinkedList.head).next
                Local $tHeadNode = $fNode($tSinglyLinkedList.head)
                $tHeadNode.previous = 0
            ElseIf $current = $tSinglyLinkedList.tail Then
                $tSinglyLinkedList.tail = $previous
                Local $tTailNode = $fNode($tSinglyLinkedList.tail)
                $tTailNode.next = 0
            Else
                Local $tPreviousNode = $fNode($previous)
                Local $tNextNode = $fNode($fNode($current).next)
                $tPreviousNode.next = $fNode($current).next
            EndIf
            If $bFree Then
                $next = $fNode($current).next
                _au3LinkedList_Memory_FreeDllStruct($current)
                $current = $next
                ContinueLoop
            EndIf
        EndIf
        $previous = $current
        $current = $fNode($current).next
    WEnd
EndFunc

Func _au3LinkedList_Singly_List_RemoveAt($vSinglyLinkedList, $pos, $bFree = True)
    Local $fNode = _au3LinkedList_Singly_Node_Create
    Local $tSinglyLinkedList = _au3LinkedList_Singly_List_Create($vSinglyLinkedList)
    Local $current = $tSinglyLinkedList.head
    Local $previous
    Local $counter = 1
    If $pos = 0 Then
        $tSinglyLinkedList.head = $fNode($tSinglyLinkedList.head).next
        $tHeadNode = $fNode($tSinglyLinkedList.head)

        If $bFree Then
            $next = $fNode($current).next
            _au3LinkedList_Memory_FreeDllStruct($current)
            $current = $next
        EndIf
    Else
        While $current
            $previous = $current
            $current = $fNode($current).next
            If $current = $tSinglyLinkedList.tail Then
                $tDoublyLinkedList.tail = $previous
                Local $tTailNode = $fNode($tSinglyLinkedList.tail)
                $tTailNode.next = 0
                If $bFree Then
                    _au3LinkedList_Memory_FreeDllStruct($current)
                EndIf
                ExitLoop
            ElseIf $counter = $pos Then
                Local $tNextNode = $fNode($fNode($current).next)
                Local $tPreviousNode = $fNode($previous)
                $tPreviousNode.next = $fNode($current).next
                If $bFree Then
                    _au3LinkedList_Memory_FreeDllStruct($current)
                EndIf
                ExitLoop
            EndIf
            $counter+=1
        WEnd
    EndIf
EndFunc

Func _au3LinkedList_Singly_List_Reverse($vSinglyLinkedList)
    Local $fNode = _au3LinkedList_Singly_Node_Create
    Local $tSinglyLinkedList = _au3LinkedList_Singly_List_Create($vSinglyLinkedList)
    Local $current = $tSinglyLinkedList.head
    local $prev = 0
    While $current
        Local $next = $fNode($current).next
        Local $tCurrent = $fNode($current)
        $tCurrent.next = $prev
        $prev = $current
        $current = $next
    WEnd
    Local $tail = $tSinglyLinkedList.tail
    $tSinglyLinkedList.tail = $tSinglyLinkedList.head
    $tSinglyLinkedList.head = $tail
EndFunc

Func _au3LinkedList_Singly_List_Swap($vSinglyLinkedList, $nodeOne, $nodeTwo)
    Local $fNode = _au3LinkedList_Singly_Node_Create
    Local $tSinglyLinkedList = _au3LinkedList_Singly_List_Create($vSinglyLinkedList)
    Local $current = $tSinglyLinkedList.head
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

Func _au3LinkedList_Singly_List_IsEmpty($vSinglyLinkedList)
    Return _au3LinkedList_Singly_List_Length($vSinglyLinkedList) < 1
EndFunc

Func _au3LinkedList_Singly_List_Length($vSinglyLinkedList)
    Local $fNode = _au3LinkedList_Singly_Node_Create
    Local $tSinglyLinkedList = _au3LinkedList_Singly_List_Create($vSinglyLinkedList)
    Local $current = $tSinglyLinkedList.head
    Local $counter = 0
    While $current
        $counter+=1
        $current = $fNode($current).next
    WEnd
    Return $counter
EndFunc

Func _au3LinkedList_Singly_List_Traverse($vSinglyLinkedList, $fn)
    Local $fNode = _au3LinkedList_Singly_Node_Create
    Local $tSinglyLinkedList = _au3LinkedList_Singly_List_Create($vSinglyLinkedList)
    Local $current = $tSinglyLinkedList.head
    While $current
        $tCurrent = $fNode($current)
        $fn($tCurrent)
        $current = $tCurrent.next
    WEnd
    Return True
EndFunc

Func _au3LinkedList_Singly_List_Search($vSinglyLinkedList, $hData)
    Local $fNode = _au3LinkedList_Singly_Node_Create
    Local $tSinglyLinkedList = _au3LinkedList_Singly_List_Create($vSinglyLinkedList)
    Local $current = $tSinglyLinkedList.head
    Local $counter = 0
    While $current
        Local $tCurrent = $fNode($current)
        If $tCurrent.data = $hData Then Return $counter
        $current = $tCurrent.next
        $counter+=1
    WEnd
    Return False
EndFunc
