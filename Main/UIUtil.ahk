;窗口&UI刷新
InitUI() {
    global MySoftData
    MyGui := Gui(, "RMTv1.0.4")
    MyGui.SetFont(, "Consolas")
    MySoftData.MyGui := MyGui

    AddUI()
    CustomTrayMenu()
    OnOpen()
}

OnOpen() {
    global MySoftData

    if (!MySoftData.IsExecuteShow && !MySoftData.IsLastSaved)
        return

    RefreshGui()
    IniWrite(false, IniFile, IniSection, "LastSaved")
}

RefreshGui() {
    global MySoftData
    if (MySoftData.IsSavedWinPos)
        MySoftData.MyGui.Show(Format("x{} y{} w{} h{}", MySoftData.WinPosX, MySoftData.WinPosY, 1090, 520))
    else
        MySoftData.MyGui.Show(Format("w{} h{} center", 1090, 520))

}

RefreshToolUI() {
    global ToolCheckInfo

    ToolCheckInfo.ToolMousePosCtrl.Value := ToolCheckInfo.PosStr
    ToolCheckInfo.ToolProcessNameCtrl.Value := ToolCheckInfo.ProcessName
    ToolCheckInfo.ToolProcessTileCtrl.Value := ToolCheckInfo.ProcessTile
    ToolCheckInfo.ToolProcessPidCtrl.Value := ToolCheckInfo.ProcessPid
    ToolCheckInfo.ToolProcessClassCtrl.Value := ToolCheckInfo.ProcessClass
    ToolCheckInfo.ToolProcessIdCtrl.Value := ToolCheckInfo.ProcessId
    ToolCheckInfo.ToolColorCtrl.Value := ToolCheckInfo.Color
}

;UI元素相关函数
AddUI() {
    global MySoftData
    MyGui := MySoftData.MyGui
    AddOperBtnUI()
    MySoftData.TabPosY := 10
    MySoftData.TabPosX := 130
    MySoftData.TabCtrl := MyGui.Add("Tab3", Format("x{} y{} w{} Choose{}", MySoftData.TabPosX, MySoftData.TabPosY, 940,
        MySoftData.TableIndex), MySoftData.TabNameArr)

    loop MySoftData.TabNameArr.Length {
        MySoftData.TabCtrl.UseTab(A_Index)
        func := GetUIAddFunc(A_Index)
        func(A_Index)
    }
    MySoftData.TabCtrl.UseTab()
    height := GetTabHeight()
    MySoftData.TabCtrl.Move(MySoftData.TabPosX, MySoftData.TabPosY, 940, height)

    SB := ScrollBar(MyGui, 100, 100)
    MySoftData.SB := SB
    SB.AddFixedControls(MySoftData.FixedCons)
}

AddOperBtnUI() {
    MyGui := MySoftData.MyGui
    con := MyGui.Add("GroupBox", Format("x{} y{} w{} h{} center", 10, 10, 110, 500), "全局操作")
    MySoftData.FixedCons.Push(con)
    MySoftData.GroupFixedCons.Push(con)

    posY := 35
    ; 暂停模块
    MySoftData.PauseToggleCtrl := MyGui.Add("CheckBox", Format("x{} y{} w{} h{}", 15, posY, 100, 20), "暂停")
    MySoftData.PauseToggleCtrl.Value := MySoftData.IsPause
    MySoftData.PauseToggleCtrl.OnEvent("Click", OnPauseHotkey)
    MySoftData.FixedCons.Push(MySoftData.PauseToggleCtrl)
    posY += 20
    con := MyGui.Add("Hotkey", Format("x{} y{} w{} h{}", 15, posY, 100, 20), MySoftData.PauseHotkey)
    con.Enabled := false
    MySoftData.FixedCons.Push(con)
    posY += 40

    ;终止模块
    con := MyGui.Add("Button", Format("x{} y{} w{} h{} center", 15, posY, 100, 30), "终止所有宏")
    con.OnEvent("Click", OnKillAllMacro)
    MySoftData.FixedCons.Push(con)
    posY += 31
    isHotKey := CheckIsHotKey(MySoftData.KillMacroHotkey)
    CtrlType := isHotKey ? "Hotkey" : "Text"
    con := MyGui.Add(CtrlType, Format("x{} y{} w{} h{}", 15, posY, 100, 20), MySoftData.KillMacroHotkey)
    con.Enabled := false
    MySoftData.FixedCons.Push(con)
    posY += 40

    ReloadBtnCtrl := MyGui.Add("Button", Format("x{} y{} w{} h{} center", 15, posY, 100, 30), "重载")
    ReloadBtnCtrl.OnEvent("Click", MenuReload)
    MySoftData.FixedCons.Push(ReloadBtnCtrl)
    posY += 40

    MySoftData.BtnAdd := MyGui.Add("Button", Format("x{} y{} w{} h{} center", 15, posY, 100, 30), "新增配置")
    MySoftData.BtnAdd.OnEvent("Click", OnAddSetting)
    posY += 40

    ; posY := 250
    ; con := MyGui.Add("Picture", Format("x{} y{} w{} h{} center", 15, posY, 100, 100), "Images\Soft\WeiXin.png")
    ; MySoftData.FixedCons.Push(con)

    ; posY := 350
    ; con := MyGui.Add("Text", Format("x{} y{} w{} center", 15, posY, 100), "游戏项目")
    ; MySoftData.FixedCons.Push(con)
    ; con := MyGui.Add("Text", Format("x{} y{} w{} center", 15, posY + 20, 100), "为爱发电")
    ; MySoftData.FixedCons.Push(con)
    ; con := MyGui.Add("Text", Format("x{} y{} w{} center", 15, posY + 40, 100), "诚邀美术、程序")
    ; MySoftData.FixedCons.Push(con)
    ; con := MyGui.Add("Link", Format("x{} y{} w{} center", 25, posY + 60, 100),
    ; '<a href="https://www.bilibili.com/video/BV1jPwTe3EtB">项目演示链接</a>')
    ; MySoftData.FixedCons.Push(con)
    ; con := MyGui.Add("Text", Format("x{} y{} w{} center", 15, posY + 80, 100), "QQ:2660681757")
    ; MySoftData.FixedCons.Push(con)

    posY := 470
    MySoftData.BtnSave := MyGui.Add("Button", Format("x{} y{} w{} h{} center", 15, posY, 100, 30), "应用并保存")
    MySoftData.BtnSave.OnEvent("Click", OnSaveSetting)

    MySoftData.FixedCons.Push(MySoftData.BtnAdd)
    MySoftData.FixedCons.Push(MySoftData.BtnSave)

    MyTriggerKeyGui.SureFocusCon := MySoftData.BtnSave
    MyTriggerStrGui.SureFocusCon := MySoftData.BtnSave
    MyMacroGui.SureFocusCon := MySoftData.BtnSave
    MyReplaceKeyGui.SureFocusCon := MySoftData.BtnSave
}

GetUIAddFunc(index) {
    UIAddFuncArr := [AddMacroHotkeyUI, AddMacroHotkeyUI, AddMacroHotkeyUI, AddMacroHotkeyUI,
        AddToolUI, AddSettingUI, AddRewardUI]
    return UIAddFuncArr[index]
}

;添加正常按键宏UI
AddMacroHotkeyUI(index) {
    global MySoftData
    tableItem := MySoftData.TableInfo[index]
    isSubMacro := CheckIsSubMacroTable(index)
    offsetPosx := isSubMacro ? -60 : 0
    tableItem.underPosY := MySoftData.TabPosY
    ; 配置规则说明
    UpdateUnderPosY(index, 30)

    MyGui := MySoftData.MyGui
    con := MyGui.Add("Text", Format("x{} y{} w100", MySoftData.TabPosX + 20, tableItem.underPosY), "宏触发按键")
    con.Visible := !isSubMacro

    MyGui.Add("Text", Format("x{} y{} w80", MySoftData.TabPosX + 120 + offsetPosx, tableItem.underPosY), "长按时间")
    MyGui.Add("Text", Format("x{} y{} w550", MySoftData.TabPosX + 205 + offsetPosx, tableItem.underPosY), "宏指令")
    MyGui.Add("Text", Format("x{} y{} w30", MySoftData.TabPosX + 540, tableItem.underPosY), "编辑")
    MyGui.Add("Text", Format("x{} y{} w30", MySoftData.TabPosX + 600, tableItem.underPosY), "游戏")
    MyGui.Add("Text", Format("x{} y{} w30", MySoftData.TabPosX + 640, tableItem.underPosY), "禁止")
    MyGui.Add("Text", Format("x{} y{} w80", MySoftData.TabPosX + 675, tableItem.underPosY), "循环次数")
    MyGui.Add("Text", Format("x{} y{} w100", MySoftData.TabPosX + 740, tableItem.underPosY), "指定进程名")

    UpdateUnderPosY(index, 20)
    LoadSavedSettingUI(index)
}

LoadSavedSettingUI(index) {
    tableItem := MySoftData.TableInfo[index]
    isMacro := CheckIsMacroTable(index)
    isNormal := CheckIsNormalTable(index)
    isSubMacro := CheckIsSubMacroTable(index)
    curIndex := 0
    MyGui := MySoftData.MyGui
    TabPosX := MySoftData.TabPosX
    subMacroWidth := isSubMacro ? 75 : 0
    isTriggerStr := CheckIsStringMacroTable(index)
    EditTriggerAction := isTriggerStr ? OnTableEditTriggerStr : OnTableEditTriggerKey
    EditMacroAction := isMacro ? OnTableEditMacro : OnTableEditReplaceKey
    loop tableItem.ModeArr.Length {
        heightValue := 60
        InfoHeight := 45

        newIndexCon := MyGui.Add("Text", Format("x{} y{} w{}", TabPosX + 10, tableItem.underPosY + 5, 30), A_Index ".")
        newTriggerTypeCon := MyGui.Add("DropDownList", Format("x{} y{} w{}", TabPosX + 40, tableItem.underPosY, 70), [
            "按下",
            "松开",
            "松止", "开关", "长按"])
        newTriggerTypeCon.Value := tableItem.TriggerTypeArr.Length >= A_Index ? tableItem.TriggerTypeArr[A_Index] : 1
        newTriggerTypeCon.Enabled := isNormal
        newTriggerTypeCon.OnEvent("Change", GetTableClosureAction(OnChangeTriggerType, tableItem, A_Index))
        newTriggerTypeCon.Visible := isSubMacro ? false : true

        newTkControl := MyGui.Add("Edit", Format("x{} y{} w{} h{} Center", TabPosX + 10, tableItem.underPosY + 25, 100,
            20), "")
        newTkControl.Visible := isSubMacro ? false : true
        newTkControl.Value := tableItem.TKArr.Length >= A_Index ? tableItem.TKArr[A_Index] : ""

        newHoldTimeControl := MyGui.Add("Edit", Format("x{} y{} w80 center", TabPosX + 115 - subMacroWidth, tableItem.underPosY
        ), "500"
        )
        newHoldTimeControl.value := tableItem.HoldTimeArr[A_Index]
        newHoldTimeControl.Enabled := isNormal && newTriggerTypeCon.Value == 5 ;长按才能配置

        newMacroTypeCon := MyGui.Add("DropDownList", Format("x{} y{} w{}", TabPosX + 115 - subMacroWidth, tableItem.underPosY +
            25, 80),
        [
            "指令串联", "指令并联"])
        newMacroTypeCon.Enabled := isMacro
        newMacroTypeCon.Value := tableItem.MacroTypeArr.Length >= A_Index ? tableItem.MacroTypeArr[A_Index] : 1

        newInfoControl := MyGui.Add("Edit", Format("x{} y{} w{} h{}", TabPosX + 200 - subMacroWidth, tableItem.underPosY,
            325 + subMacroWidth,
            InfoHeight), "")
        newInfoControl.Value := tableItem.MacroArr.Length >= A_Index ? tableItem.MacroArr[A_Index] : ""

        newKeyBtnControl := MyGui.Add("Button", Format("x{} y{} w60 h20", TabPosX + 530, tableItem.underPosY), "触发键")
        newKeyBtnControl.OnEvent("Click", GetTableClosureAction(EditTriggerAction, tableItem, A_Index))
        newKeyBtnControl.Enabled := !isSubMacro

        newModeControl := MyGui.Add("Checkbox", Format("x{} y{} w30", TabPosX + 610, tableItem.underPosY + 5), "")
        newModeControl.value := tableItem.ModeArr[A_Index]
        newForbidControl := MyGui.Add("Checkbox", Format("x{} y{} w30", TabPosX + 645, tableItem.underPosY + 5), "")
        newForbidControl.value := tableItem.ForbidArr[A_Index]

        newProcessNameControl := MyGui.Add("Edit", Format("x{} y{} w180", TabPosX + 740, tableItem.underPosY), "")
        newProcessNameControl.value := tableItem.ProcessNameArr.Length >= A_Index ? tableItem.ProcessNameArr[A_Index] :
            ""

        newMacroBtnControl := MyGui.Add("Button", Format("x{} y{} w60 h20", TabPosX + 530, tableItem.underPosY + 25),
        "宏指令")
        newDeleteBtnControl := MyGui.Add("Button", Format("x{} y{} w50 h20", TabPosX + 610, tableItem.underPosY + 25),
        "删除")
        newMacroBtnControl.OnEvent("Click", GetTableClosureAction(EditMacroAction, tableItem, A_Index))
        newDeleteBtnControl.OnEvent("Click", GetTableClosureAction(OnTableDelete, tableItem, A_Index))
        newRemarkTextControl := MyGui.Add("Text", Format("x{} y{} w60", TabPosX + 700, tableItem.underPosY + 30), "备注:"
        )
        newRemarkControl := MyGui.Add("Edit", Format("x{} y{} w180", TabPosX + 740, tableItem.underPosY + 25), ""
        )
        newRemarkControl.value := tableItem.RemarkArr.Length >= A_Index ? tableItem.RemarkArr[A_Index] : ""

        newLoopCountControl := MyGui.Add("Edit", Format("x{} y{} w60 center", TabPosX + 675, tableItem.underPosY), "")
        conValue := tableItem.LoopCountArr.Length >= A_Index ? tableItem.LoopCountArr[A_Index] : "1"
        conValue := conValue == "-1" ? "∞" : conValue
        newLoopCountControl.Value := conValue
        newLoopCountControl.Enabled := isMacro

        tableItem.MacroBtnConArr.Push(newMacroBtnControl)
        tableItem.RemarkConArr.Push(newRemarkControl)
        tableItem.RemarkTextConArr.Push(newRemarkTextControl)
        tableItem.LoopCountConArr.Push(newLoopCountControl)
        tableItem.TKConArr.Push(newTkControl)
        tableItem.InfoConArr.Push(newInfoControl)
        tableItem.KeyBtnConArr.Push(newKeyBtnControl)
        tableItem.DeleteBtnConArr.Push(newDeleteBtnControl)
        tableItem.ModeConArr.Push(newModeControl)
        tableItem.ForbidConArr.Push(newForbidControl)
        tableItem.HoldTimeConArr.Push(newHoldTimeControl)
        tableItem.ProcessNameConArr.Push(newProcessNameControl)
        tableItem.IndexConArr.Push(newIndexCon)
        tableItem.TriggerTypeConArr.Push(newTriggerTypeCon)
        tableItem.MacroTypeConArr.Push(newMacroTypeCon)
        UpdateUnderPosY(index, heightValue)
    }
}

OnAddSetting(*) {
    global MySoftData
    TableIndex := MySoftData.TabCtrl.Value
    if (!CheckIfAddSetTable(TableIndex)) {
        MsgBox("该页签不可添加配置啊喂")
        return
    }

    MySoftData.SB.ResetVerticalValue()
    MyGui := MySoftData.MyGui
    tableItem := MySoftData.TableInfo[TableIndex]
    TabPosX := MySoftData.TabPosX
    isMacro := CheckIsMacroTable(TableIndex)
    isNormal := CheckIsNormalTable(TableIndex)
    isSubMacro := CheckIsSubMacroTable(TableIndex)
    subMacroWidth := isSubMacro ? 75 : 0
    isTriggerStr := CheckIsStringMacroTable(TableIndex)
    EditTriggerAction := isTriggerStr ? OnTableEditTriggerStr : OnTableEditTriggerKey
    EditMacroAction := isMacro ? OnTableEditMacro : OnTableEditReplaceKey
    tableItem.TKArr.Push("")
    tableItem.MacroArr.Push("")
    tableItem.ModeArr.Push(0)
    tableItem.ForbidArr.Push(0)
    tableItem.ProcessNameArr.Push("")
    tableItem.RemarkArr.Push("")
    tableItem.LoopCountArr.Push("1")
    tableItem.HoldTimeArr.Push(0)

    heightValue := 60
    TKPosY := tableItem.underPosY + 10
    InfoHeight := 45
    index := tableItem.ModeArr.Length

    MySoftData.TabCtrl.UseTab(TableIndex)

    newIndexCon := MyGui.Add("Text", Format("x{} y{} w{}", TabPosX + 10, tableItem.underPosY + 5, 30), index ".")
    newTriggerTypeCon := MyGui.Add("DropDownList", Format("x{} y{} w{}", TabPosX + 40, tableItem.underPosY, 70), ["按下",
        "松开",
        "松止", "开关", "长按"])
    newTriggerTypeCon.Value := 1
    newTriggerTypeCon.Enabled := isNormal
    newTriggerTypeCon.Visible := isSubMacro ? false : true
    newTriggerTypeCon.OnEvent("Change", GetTableClosureAction(OnChangeTriggerType, tableItem, index))

    newTkControl := MyGui.Add("Edit", Format("x{} y{} w{} h{} Center", TabPosX + 10, tableItem.underPosY + 25, 100, 20),
    "")
    newTkControl.Visible := isSubMacro ? false : true

    newHoldTimeControl := MyGui.Add("Edit", Format("x{} y{} w80 center", TabPosX + 115 - subMacroWidth, tableItem.underPosY
    ), "500")
    newHoldTimeControl.Enabled := false

    newMacroTypeCon := MyGui.Add("DropDownList", Format("x{} y{} w{}", TabPosX + 115 - subMacroWidth, tableItem.underPosY +
        25, 80),
    [
        "指令串联", "指令并联"])
    newMacroTypeCon.Enabled := isMacro
    newMacroTypeCon.Value := 1

    newInfoControl := MyGui.Add("Edit", Format("x{} y{} w{} h{}", TabPosX + 200 - subMacroWidth, tableItem.underPosY,
        325 + subMacroWidth, InfoHeight),
    "")

    newKeyBtnControl := MyGui.Add("Button", Format("x{} y{} w60 h20", TabPosX + 530, tableItem.underPosY), "触发键")
    newKeyBtnControl.OnEvent("Click", GetTableClosureAction(EditTriggerAction, tableItem, index))
    newKeyBtnControl.Enabled := !isSubMacro

    newModeControl := MyGui.Add("Checkbox", Format("x{} y{} w30", TabPosX + 610, tableItem.underPosY + 5), "")
    newModeControl.value := 0
    newForbidControl := MyGui.Add("Checkbox", Format("x{} y{} w30", TabPosX + 645, tableItem.underPosY + 5), "")
    newForbidControl.value := 0
    newProcessNameControl := MyGui.Add("Edit", Format("x{} y{} w180", TabPosX + 740, tableItem.underPosY), "")
    newProcessNameControl.value := ""

    newMacroBtnControl := MyGui.Add("Button", Format("x{} y{} w60 h20", TabPosX + 530, tableItem.underPosY + 25),
    "宏指令")
    newDeleteBtnControl := MyGui.Add("Button", Format("x{} y{} w50 h20", TabPosX + 610, tableItem.underPosY + 25),
    "删除")
    newMacroBtnControl.OnEvent("Click", GetTableClosureAction(EditMacroAction, tableItem, index))
    newDeleteBtnControl.OnEvent("Click", GetTableClosureAction(OnTableDelete, tableItem, index))

    newRemarkTextControl := MyGui.Add("Text", Format("x{} y{} w60", TabPosX + 700, tableItem.underPosY + 30), "备注:"
    )
    newRemarkControl := MyGui.Add("Edit", Format("x{} y{} w180", TabPosX + 740, tableItem.underPosY + 25), "")

    newLoopCountControl := MyGui.Add("Edit", Format("x{} y{} w60 center", TabPosX + 675, tableItem.underPosY), "1")
    newLoopCountControl.Enabled := isMacro

    tableItem.LoopCountConArr.Push(newLoopCountControl)
    tableItem.MacroBtnConArr.Push(newMacroBtnControl)
    tableItem.RemarkConArr.Push(newRemarkControl)
    tableItem.RemarkTextConArr.Push(newRemarkTextControl)
    tableItem.KeyBtnConArr.Push(newKeyBtnControl)
    tableItem.DeleteBtnConArr.Push(newDeleteBtnControl)
    tableItem.TKConArr.Push(newTkControl)
    tableItem.InfoConArr.Push(newInfoControl)
    tableItem.ModeConArr.Push(newModeControl)
    tableItem.ForbidConArr.Push(newForbidControl)
    tableItem.HoldTimeConArr.Push(newHoldTimeControl)
    tableItem.ProcessNameConArr.Push(newProcessNameControl)
    tableItem.IndexConArr.Push(newIndexCon)
    tableItem.TriggerTypeConArr.Push(newTriggerTypeCon)
    tableItem.MacroTypeConArr.Push(newMacroTypeCon)

    UpdateUnderPosY(TableIndex, heightValue)

    MySoftData.TabCtrl.UseTab()
    height := GetTabHeight()
    MySoftData.TabCtrl.Move(MySoftData.TabPosX, MySoftData.TabPosY, 940, height)
    MySoftData.SB.UpdateScrollBars()

    SaveWinPos()
    RefreshGui()
}

AddSettingUI(index) {
    MyGui := MySoftData.MyGui
    posY := MySoftData.TabPosY
    posX := MySoftData.TabPosX
    ; 配置规则说明
    posY += 35
    MyGui.Add("Text", Format("x{} y{}", posX + 20, posY), "获取快捷方式：(暂停只能用快捷键触发，其他可以用快捷键或字串触发)")
    posY += 25
    MySoftData.EditHotKeyCtrl := MyGui.Add("Edit", Format("x{} y{} center w120", posX + 20, posY - 5), "")
    con := MyGui.Add("Button", Format("x{} y{} center w80", posX + 140, posY - 5), "编辑快捷键")
    con.OnEvent("Click", OnEditHotkey)

    MySoftData.EditHotStrCtrl := MyGui.Add("Edit", Format("x{} y{} center w120", posX + 320, posY - 5), "")
    con := MyGui.Add("Button", Format("x{} y{} center w80", posX + 440, posY - 5), "编辑字串")
    con.OnEvent("Click", OnEditHotStr)

    posY += 40
    con := MyGui.Add("Text", Format("x{} y{} w130", posX + 20, posY), "脚本暂停快捷键:")
    MySoftData.PauseHotkeyCtrl := MyGui.Add("Edit", Format("x{} y{} w100 center", posX + 140, posY - 4), MySoftData.PauseHotkey
    )

    con := MyGui.Add("Text", Format("x{} y{} w130", posX + 290, posY), "终止宏快捷方式:")
    MySoftData.KillMacroHotkeyCtrl := MyGui.Add("Edit", Format("x{} y{} w100 center", posX + 410, posY - 4), MySoftData
    .KillMacroHotkey)

    MyGui.Add("Text", Format("x{} y{}", posX + 550, posY), "鼠标信息快捷方式:")
    ToolCheckInfo.ToolCheckHotKeyCtrl := MyGui.Add("Edit", Format("x{} y{} w100 center", posX + 665, posY - 4),
    ToolCheckInfo.ToolCheckHotkey
    )

    posY += 30
    con := MyGui.Add("Text", Format("x{} y{} w130", posX + 20, posY), "指令录制快捷方式:")
    ToolCheckInfo.ToolRecordMacroHotKeyCtrl := MyGui.Add("Edit", Format("x{} y{} w100 center", posX + 140, posY - 4),
    ToolCheckInfo.ToolRecordMacroHotKey
    )

    con := MyGui.Add("Text", Format("x{} y{} w130", posX + 290, posY), "文本提取快捷方式:")
    ToolCheckInfo.ToolTextFilterHotKeyCtrl := MyGui.Add("Edit", Format("x{} y{} w100 center", posX + 410, posY - 4),
    ToolCheckInfo.ToolTextFilterHotKey
    )

    posY += 40
    MyGui.Add("Text", Format("x{} y{} w130", posX + 20, posY), "按住时间浮动:(%)")
    MySoftData.HoldFloatCtrl := MyGui.Add("Edit", Format("x{} y{} w100 center", posX + 140, posY - 4), MySoftData.HoldFloat
    )

    MyGui.Add("Text", Format("x{} y{} w130", posX + 290, posY), "每次间隔时间浮动:")
    MySoftData.PreIntervalFloatCtrl := MyGui.Add("Edit", Format("x{} y{} w100 center", posX + 410, posY - 4),
    MySoftData.PreIntervalFloat)

    MyGui.Add("Text", Format("x{} y{} w130", posX + 550, posY), "间隔指令时间浮动:")
    MySoftData.IntervalFloatCtrl := MyGui.Add("Edit", Format("x{} y{} w100 center", posX + 665, posY - 4), MySoftData.IntervalFloat
    )

    posY += 40
    MyGui.Add("Text", Format("x{} y{} w130", posX + 20, posY), "坐标X浮动:(px)")
    MySoftData.CoordXFloatCon := MyGui.Add("Edit", Format("x{} y{} w100 center", posX + 140, posY - 4), MySoftData.CoordXFloat
    )

    MyGui.Add("Text", Format("x{} y{} w130", posX + 290, posY), "坐标Y浮动:")
    MySoftData.CoordYFloatCon := MyGui.Add("Edit", Format("x{} y{} w100 center", posX + 410, posY - 4),
    MySoftData.CoordYFloat)

    posY += 40
    MyGui.Add("Text", Format("x{} y{} w130", posX + 20, posY), "搜索模糊(0~255):")
    MySoftData.ImageSearchBlurCtrl := MyGui.Add("Edit", Format("x{} y{} w100 center", posX + 140, posY - 4), MySoftData
    .ImageSearchBlur
    )

    MySoftData.ShowWinCtrl := MyGui.Add("CheckBox", Format("x{} y{}", posX + 290, posY), "运行后显示窗口")
    MySoftData.ShowWinCtrl.Value := MySoftData.IsExecuteShow
    MySoftData.ShowWinCtrl.OnEvent("Click", OnShowWinChanged)

    MySoftData.BootStartCtrl := MyGui.Add("CheckBox", Format("x{} y{}", posX + 550, posY), "开机自启")
    MySoftData.BootStartCtrl.Value := MySoftData.IsBootStart
    MySoftData.BootStartCtrl.OnEvent("Click", OnBootStartChanged)

    posY += 30
    MyGui.Add("Text", Format("x{} y{}", posX + 20, posY), "禁止：勾选后对应配置不生效")
    posY += 20
    MyGui.Add("Text", Format("x{} y{}", posX + 20, posY), "游戏：勾选为游戏模式。若游戏内仍然无效请以管理员身份运行软件，如果非游戏模式功能正常，请忽略此项")
    posY += 20
    MyGui.Add("Text", Format("x{} y{}", posX + 20, posY), "指定进程名：填写后，仅在该进程获得焦点时生效，否则对所有进程生效（可通过工具模块获取进程名）")
    posY += 20
    MyGui.Add("Text", Format("x{} y{}", posX + 20, posY), "循环次数：-1为无限循环(通过终止所有宏按键取消循环),大于0的整数为循环次数")
    posY += 20
    MyGui.Add("Text", Format("x{} y{}", posX + 20, posY), "快捷键：通过%设置%下的编辑快捷键获取配置")
    posY += 20
    MyGui.Add("Text", Format("x{} y{}", posX + 20, posY), "快捷方式：通过%设置%下的 编辑快捷 或者 编辑字串 获取配置")
    posY += 30
    MyGui.Add("Text", Format("x{} y{}", posX + 20, posY), "其他说明：")
    posY += 20
    MyGui.Add("Text", Format("x{} y{}", posX + 20, posY), "按键宏的触发键与字串宏的触发键可以混用。")
    posY += 20
    MyGui.Add("Text", Format("x{} y{}", posX + 20, posY), "所有操作只有点击%应用并保存%按钮后才会生效。")

    posY += 20
    MyGui.Add("Text", Format("x{} y{}", posX + 20, posY), "软件使用交流QQ群:837661891")

    posY += 20

    tableItem := MySoftData.TableInfo[index]
    tableItem.UnderPosY := posY
}

AddRewardUI(index) {
    MyGui := MySoftData.MyGui
    posY := MySoftData.TabPosY
    posX := MySoftData.TabPosX

    posY += 40
    posX += 15
    con := MyGui.Add("Text", Format("x{} y{} w{} h{}", posX, posY, 800, 60), "RMT(若梦兔)完全免费的开源软件，如果你觉得它提升了你的效率，欢迎请我喝杯咖啡~ `n你的打赏会让我更有动力持续更新和维护这个项目！")
    con.SetFont((Format("S{} W{} Q{}", 12, 600, 5)))

    posY += 60
    posX := MySoftData.TabPosX + 100
    con := MyGui.Add("Picture", Format("x{} y{} w{} h{} center", posX, posY, 220, 220), "Images\Soft\WeiXin.png")
    con := MyGui.Add("Text", Format("x{} y{} w{} h{} center", posX, posY + 230, 220, 50), "微信打赏")
    con.SetFont((Format("S{} W{} Q{}", 12, 600, 5)))

    posX += 450
    con := MyGui.Add("Picture", Format("x{} y{} w{} h{} center", posX, posY, 220, 220), "Images\Soft\ZhiFuBao.png")
    con := MyGui.Add("Text", Format("x{} y{} w{} h{} center", posX, posY + 230, 220, 50), "支付宝打赏")
    con.SetFont((Format("S{} W{} Q{}", 12, 600, 5)))

    posY += 300
    posX := MySoftData.TabPosX + 15
    con := MyGui.Add("Text", Format("x{} y{} w{} h{}", posX, posY, 860, 80), "即使只是5元、10元，也是对我莫大的鼓励！当然，如果你暂时不方便，分享给朋友也是很棒的支持~`n开发不易，感谢你的每一份温暖！")
    con.SetFont((Format("S{} W{} Q{}", 12, 600, 5)))

    posY += 35
    MySoftData.TableInfo[index].underPosY := posY
}

AddToolUI(index) {
    global ToolCheckInfo

    MyGui := MySoftData.MyGui
    posY := MySoftData.TabPosY
    posX := MySoftData.TabPosX
    ; 配置规则说明
    posY += 35
    MyGui.Add("Text", Format("x{} y{}", posX + 20, posY), "鼠标信息：")

    ToolCheckInfo.ToolCheckCtrl := MyGui.Add("CheckBox", Format("x{} y{}", posX + 130, posY, 60), "开关")
    ToolCheckInfo.ToolCheckCtrl.Value := ToolCheckInfo.IsToolCheck
    ToolCheckInfo.ToolCheckCtrl.OnEvent("Click", OnToolCheckHotkey)

    isHotKey := CheckIsHotKey(ToolCheckInfo.ToolCheckHotkey)
    CtrlType := isHotKey ? "Hotkey" : "Text"
    con := MyGui.Add(CtrlType, Format("x{} y{} w{} h{}", posX + 210, posY - 5, 100, 20), ToolCheckInfo.ToolCheckHotkey)
    con.Enabled := false

    posY += 30
    MyGui.Add("Text", Format("x{} y{}", posX + 20, posY), "鼠标位置坐标：")
    ToolCheckInfo.ToolMousePosCtrl := MyGui.Add("Edit", Format("x{} y{} w250", posX + 120, posY - 5), ToolCheckInfo.PosStr
    )

    MyGui.Add("Text", Format("x{} y{}", posX + 390, posY), "进程名：")
    ToolCheckInfo.ToolProcessNameCtrl := MyGui.Add("Edit", Format("x{} y{} w250", posX + 450, posY - 5), ToolCheckInfo.ProcessName
    )

    posY += 30
    MyGui.Add("Text", Format("x{} y{}", posX + 20, posY), "进程标题：")
    ToolCheckInfo.ToolProcessTileCtrl := MyGui.Add("Edit", Format("x{} y{} w250", posX + 120, posY - 5), ToolCheckInfo.ProcessTile
    )

    MyGui.Add("Text", Format("x{} y{}", posX + 390, posY), "进程PID:")
    ToolCheckInfo.ToolProcessPidCtrl := MyGui.Add("Edit", Format("x{} y{} w250", posX + 450, posY - 5), ToolCheckInfo.ProcessPid
    )

    posY += 30
    MyGui.Add("Text", Format("x{} y{}", posX + 20, posY), "进程窗口类：")
    ToolCheckInfo.ToolProcessClassCtrl := MyGui.Add("Edit", Format("x{} y{} w250", posX + 120, posY - 5), ToolCheckInfo
    .ProcessClass
    )

    MyGui.Add("Text", Format("x{} y{}", posX + 390, posY), "句柄Id:")
    ToolCheckInfo.ToolProcessIdCtrl := MyGui.Add("Edit", Format("x{} y{} w250", posX + 450, posY - 5), ToolCheckInfo.ProcessId
    )

    posY += 30
    MyGui.Add("Text", Format("x{} y{}", posX + 20, posY), "鼠标位置颜色值：")
    ToolCheckInfo.ToolColorCtrl := MyGui.Add("Edit", Format("x{} y{} w250", posX + 120, posY - 5), ToolCheckInfo.Color
    )

    posY += 40
    MyGui.Add("Text", Format("x{} y{}", posX + 20, posY), "指令并联录制：")

    ToolCheckInfo.ToolCheckRecordMacroCtrl := MyGui.Add("CheckBox", Format("x{} y{}", posX + 130, posY, 60), "开关")
    ToolCheckInfo.ToolCheckRecordMacroCtrl.Value := ToolCheckInfo.IsToolRecord
    ToolCheckInfo.ToolCheckRecordMacroCtrl.OnEvent("Click", OnToolRecordMacro)

    isHotKey := CheckIsHotKey(ToolCheckInfo.ToolRecordMacroHotKey)
    CtrlType := isHotKey ? "Hotkey" : "Text"
    con := MyGui.Add(CtrlType, Format("x{} y{} w{} h{}", posX + 210, posY - 5, 100, 20), ToolCheckInfo.ToolRecordMacroHotKey
    )
    con.Enabled := false

    posY += 25
    MyGui.Add("Text", Format("x{} y{}", posX + 20, posY), "指令录制相关选项：")
    ToolCheckInfo.RecordKeyboardCtrl := MyGui.Add("CheckBox", Format("x{} y{}", posX + 140, posY, 60), "录制键盘")
    ToolCheckInfo.RecordKeyboardCtrl.Value := ToolCheckInfo.RecordKeyboardValue
    ToolCheckInfo.RecordKeyboardCtrl.OnEvent("Click", OnChangeRecordOption)

    ToolCheckInfo.RecordMouseCtrl := MyGui.Add("CheckBox", Format("x{} y{}", posX + 240, posY, 60), "录制鼠标")
    ToolCheckInfo.RecordMouseCtrl.Value := ToolCheckInfo.RecordMouseValue
    ToolCheckInfo.RecordMouseCtrl.OnEvent("Click", OnChangeRecordOption)

    ToolCheckInfo.RecordMouseRelativeCtrl := MyGui.Add("CheckBox", Format("x{} y{}", posX + 340, posY, 60), "鼠标相对位移")
    ToolCheckInfo.RecordMouseRelativeCtrl.Value := ToolCheckInfo.RecordMouseRelativeValue
    ToolCheckInfo.RecordMouseRelativeCtrl.OnEvent("Click", OnChangeRecordOption)

    posY += 40
    MyGui.Add("Text", Format("x{} y{}", posX + 20, posY), "图片文本提取：")

    con := MyGui.Add("Button", Format("x{} y{} w{} h{}", posX + 120, posY - 5, 80, 25), "选择图片")
    con.OnEvent("Click", OnToolTextFilterSelectImage)

    con := MyGui.Add("Button", Format("x{} y{} w{} h{}", posX + 220, posY - 5, 60, 25), "截图")
    con.OnEvent("Click", OnToolTextFilterScreenShot)

    isHotKey := CheckIsHotKey(ToolCheckInfo.ToolTextFilterHotKey)
    CtrlType := isHotKey ? "Hotkey" : "Text"
    con := MyGui.Add(CtrlType, Format("x{} y{} w{} h{}", posX + 280, posY - 5, 100, 20), ToolCheckInfo.ToolTextFilterHotKey
    )
    con.Enabled := false

    posY += 40
    MyGui.Add("Text", Format("x{} y{}", posX + 20, posY), "录制的指令或提取的文本内容：")

    con := MyGui.Add("Button", Format("x{} y{} w{} h{}", posX + 220, posY - 5, 80, 25), "清空内容")
    con.OnEvent("Click", OnClearToolText)

    posY += 25
    ToolCheckInfo.ToolTextCtrl := MyGui.Add("Edit", Format("x{} y{} w{} h{}", posX + 20, posY, 800, 100), "")

    posY += 20
    MySoftData.TableInfo[index].underPosY := posY
}

SetToolCheckInfo() {
    global ToolCheckInfo
    CoordMode("Mouse", "Screen")
    MouseGetPos &mouseX, &mouseY, &winId
    ToolCheckInfo.PosStr := mouseX . "," . mouseY
    ToolCheckInfo.ProcessName := WinGetProcessName(winId)
    ToolCheckInfo.ProcessTile := WinGetTitle(winId)
    ToolCheckInfo.ProcessPid := WinGetPID(winId)
    ToolCheckInfo.ProcessClass := WinGetClass(winId)
    ToolCheckInfo.ProcessId := winId
    ToolCheckInfo.Color := StrReplace(PixelGetColor(mouseX, mouseY, "Slow"), "0x", "")
    RefreshToolUI()
}

; 系统托盘优化
CustomTrayMenu() {
    A_TrayMenu.Insert("&Suspend Hotkeys", "重置位置并显示窗口", ResetWinPosAndRefreshGui)
    A_TrayMenu.Insert("&Suspend Hotkeys", "显示窗口", (*) => RefreshGui())
    A_TrayMenu.Delete("&Pause Script")
    A_TrayMenu.ClickCount := 1
    A_TrayMenu.Default := "显示窗口"
    TraySetIcon(, , true)
}
