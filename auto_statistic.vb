'给那个傻乎乎的考勤机写个傻乎乎的宏，解放一小撮儿不明真相的群众
'懒，人类之精华—---R0rs12ach
Private Sub Worksheet_BeforeDoubleClick(ByVal Target As Range, Cancel As Boolean)
Dim id As Integer
Dim time As String
Dim result As String
Dim weekday As String
Dim i As Integer
Dim startHour As Integer
Dim startTime As Integer
Dim endTime As Integer
Dim gap As Long
Dim morninglate As Long
Dim eveninglate As Long

Set sheet = Sheets("sheet1")

For i = 1 To sheet.UsedRange.Rows.Count
    result = sheet.Cells(i, 5).Value
    weekday = DatePart("w", sheet.Cells(i, 4).Value)

    If weekday = 7 Or weekday = 1 Then
        sheet.Cells(i, 6).Value = "周末"
        
        If Len(result) = 5 Then
            sheet.Cells(i, 7).Value = "周末打卡异常, 请联系当事人"
        ElseIf Len(result) > 5 Then
            
            startTime = Left(result, 2) * 60 + Right(Left(result, 5), 2)
            endTime = Left(Right(result, 5), 2) * 60 + Right(result, 2)
            gap = (endTime - startTime) / 60

            If gap >= 8 Then
                sheet.Cells(i, 7).Value = "加班一天"
            ElseIf gap >= 4 And gap < 8 Then
                sheet.Cells(i, 7).Value = "加班半天"
            Else
                sheet.Cells(i, 7).Value = "不足半天"
            End If

        End If

    Else
        sheet.Cells(i, 6).Value = "工作日"

        If Len(result) = 0 Then
            sheet.Cells(i, 7).Value = "缺勤一天"
        ElseIf Len(result) = 5 Then
            sheet.Cells(i, 7).Value = "工作日打卡异常，请联系当事人"
        Else
            
            startTime = Left(result, 2) * 60 + Right(Left(result, 5), 2)
            endTime = Left(Right(result, 5), 2) * 60 + Right(result, 2)
            gap = (endTime - startTime) / 60

            morninglate = startTime - 570
            eveninglate = endTime - 1200

            If morninglate >= 0 Then

                If gap >= 8 Then
                    sheet.Cells(i, 7).Value = "迟到但工作超过8小时"
                Else
                    sheet.Cells(i, 7).Value = "迟到且工作不足8小时"
                End If
            Else

                If eveninglate >= 0 Then
                    sheet.Cells(i, 7).Value = "加班"
                End If
            End If
            
        End If
    End If

    Next
    
End Sub
