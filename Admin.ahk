#SingleInstance Force
Gui, Color, 212121
CheckUIA()
{
    if (!A_IsCompiled && !InStr(A_AhkPath, "_UIA")) {
        Run % "*uiAccess " A_ScriptFullPath
        ExitApp
    }
}
CheckUIA()

; Путь к папке в Program Files
folderPath := "C:\Program Files\AdminHelper"
iniFile := folderPath "\tag_settings.ini"

; Функция для проверки и создания папки, если её нет
EnsureFolderExists() {
    global folderPath
    if !FileExist(folderPath)
    {
        ; Пытаемся создать папку
        FileCreateDir, %folderPath%
        if ErrorLevel
        {
            MsgBox, 16, Ошибка, Не удалось создать папку: %folderPath%
            return false
        }
        else
        {
            MsgBox, 64, Успех, Папка успешно создана: %folderPath%
            return true
        }
    }
    return true
}

; Проверяем и создаем папку при запуске
if !EnsureFolderExists()
{
    ExitApp  ; Завершаем скрипт, если папку не удалось создать
}

; Загружаем локальную версию из файла
if FileExist("version_local.txt") {
    FileRead, currentVersion, version_local.txt
    currentVersion := Trim(currentVersion)
} else {
    currentVersion := "1.0.0"  ; Версия по умолчанию, если файла нет
}

; Ссылки на GitHub
githubVersionURL := "https://raw.githubusercontent.com/StichneAllen/AdminHelper/main/version.txt"
githubScriptURL := "https://raw.githubusercontent.com/StichneAllen/AdminHelper/main/Admin.ahk"

; Функция для проверки обновлений
CheckForUpdates() {
    global currentVersion, githubVersionURL, githubScriptURL

    ; Загружаем версию с GitHub
    whr := ComObjCreate("WinHttp.WinHttpRequest.5.1")
    whr.Open("GET", githubVersionURL, true)
    whr.Send()
    whr.WaitForResponse()
    serverVersion := whr.ResponseText

    ; Убираем лишние символы (например, переносы строк)
    serverVersion := Trim(serverVersion)

    ; Сравниваем версии
    if (serverVersion != currentVersion) {
        MsgBox, 4, Обновление, Доступна новая версия (%serverVersion%). Хотите обновить?
        IfMsgBox, No
            return

        ; Загружаем новый скрипт
        whr.Open("GET", githubScriptURL, true)
        whr.Send()
        whr.WaitForResponse()
        newScript := whr.ResponseText

        ; Сохраняем новый скрипт
        scriptPath := A_ScriptFullPath  ; Полный путь к текущему скрипту
        FileDelete, %scriptPath%  ; Удаляем старый скрипт
        FileAppend, %newScript%, %scriptPath%  ; Сохраняем новый скрипт

        ; Обновляем текущую версию
        currentVersion := serverVersion

        ; Сохраняем новую версию в файл
        FileDelete, version_local.txt
        FileAppend, %currentVersion%, version_local.txt

        MsgBox, 64, Успех, Скрипт успешно обновлен. Перезапустите скрипт.
        ExitApp  ; Завершаем текущий скрипт
    } else {
        MsgBox, 64, Информация, У вас актуальная версия скрипта.
    }
}

; Проверка обновлений при запуске
CheckForUpdates()

; ... (остальная часть вашего кода)


:*?:/дмкар::
SendMessage, 0x50,, 0x4190419,, A
Sleep 100
SendPlay banname  d 1.5 DM car by %SavedTag%
Sleep 100
SendPlay, {Home}{Right 8}
return
