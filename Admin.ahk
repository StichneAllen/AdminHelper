#SingleInstance Force
; Запуск от имени админа
CheckUIA()
{
    if (!A_IsCompiled && !InStr(A_AhkPath, "_UIA")) {
        Run % "*uiAccess " A_ScriptFullPath
        ExitApp
    }
}
; Запуск Run with UI Access
CheckUIA()

if not A_IsAdmin
{
    Run *RunAs "%A_ScriptFullPath%" 
    ExitApp
}
;________________________________________________________________________________________________________________________________________________________________________________________

; Авто обновление
#SingleInstance Force
scriptPath := A_ScriptFullPath
scriptDir := A_ScriptDir
scriptName := A_ScriptName
currentVersion := "1.5.1"
githubVersionURL := "https://raw.githubusercontent.com/adminprovince/AdminHelper/refs/heads/main/version.txt"
githubScriptURL := "https://raw.githubusercontent.com/adminprovince/AdminHelper/refs/heads/main/Admin.ahk"
githubChangelogURL := "https://raw.githubusercontent.com/adminprovince/AdminHelper/refs/heads/main/changelog.txt"
CheckForUpdates() {
    global currentVersion, githubVersionURL, githubScriptURL, githubChangelogURL, scriptPath, scriptDir, scriptName
    whr := ComObjCreate("WinHttp.WinHttpRequest.5.1")
    whr.Open("GET", githubVersionURL, true)
    whr.Send()
    whr.WaitForResponse()
    status := whr.Status
    if (status != 200) {
        MsgBox, 16, Ошибка, Не удалось получить версию с сервера. Код статуса: %status%
        return
    }
    serverVersion := Trim(whr.ResponseText)
    serverVersion := RegExReplace(serverVersion, "[\r\n]+", "")
    serverVersion := RegExReplace(serverVersion, "\s+", "")
    currentVersion := Trim(currentVersion)
    currentVersion := RegExReplace(currentVersion, "[\r\n]+", "")
    currentVersion := RegExReplace(currentVersion, "\s+", "")
    if (serverVersion != currentVersion) {
        MsgBox, 4, Обновление, Доступна новая версия (%serverVersion%). Хотите обновить?
        IfMsgBox, No
            return
        whr.Open("GET", githubChangelogURL, true)
        whr.Send()
        whr.WaitForResponse()
        status := whr.Status
        if (status != 200) {
            MsgBox, 16, Ошибка, Не удалось получить информацию об изменениях. Код статуса: %status%
            return
        }
        changelog := whr.ResponseText
        whr.Open("GET", githubScriptURL, true)
        whr.Send()
        whr.WaitForResponse()
        status := whr.Status
        if (status != 200) {
            MsgBox, 16, Ошибка, Не удалось загрузить новый скрипт. Код статуса: %status%
            return
        }
        newScript := whr.ResponseText
        oldScriptPath := scriptDir "\" RegExReplace(scriptName, "\.ahk$", "") " (old).ahk"
        FileMove, %scriptPath%, %oldScriptPath%
        FileAppend, %newScript%, %scriptPath%
        currentVersion := serverVersion

        MsgBox, 64, Скрипт обновлен, Скрипт успешно обновлен до версии %serverVersion%.`n`nОбновления:`n%changelog%
        ExitApp
    }
}
CheckForUpdates()
;________________________________________________________________________________________________________________________________________________________________________________________
; Создание папки для тега
folderPath := "C:\Program Files\AdminHelper"
iniFile := folderPath "\tag_settings.ini"
EnsureFolderExists() {
    global folderPath
    if !FileExist(folderPath)
    {
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
if !EnsureFolderExists()
{
    ExitApp  ; Завершаем скрипт, если папку не удалось создать
}

;________________________________________________________________________________________________________________________________________________________________________________________

Gui, Color, 212121 
Gui 1:Font, s12 c000000 Bold, Arial
Gui 1:Add, Tab2, x9 y10 h40 w450 Buttons -Wrap c9FFC69, Основное|GPS|Другое
Gui 1:Font, s11 c000000 Bold, Arial
Gui 1:Add, GroupBox, x10 y40 w350 h205 c9FFC69, [ keys ]
Gui 1:Font, s8 cWhite Bold, Arial
Gui, Add, Text, x2 x20 y60 w300 h15 , ALT+Num1 - Приятной игры!
Gui, Add, Text, x2 x20 y75 w300 h15 , ALT+Num2 - Cлежка
Gui, Add, Text, x2 x20 y90 w300 h15 , ALT+Num3 - Нарушений нет (слежка)
Gui, Add, Text, x2 x20 y105 w300 h15 , ALT+Num4 - Игрок наказан
Gui, Add, Text, x2 x20 y120 w300 h15 , ALT+Num5 - Province.info
Gui, Add, Text, x2 x20 y135 w300 h15 , ALT+Num6 - Тех. поддержка
Gui, Add, Text, x2 x20 y150 w300 h15 , ALT+Num7 - Жб. на форум
Gui, Add, Text, x2 x20 y165 w300 h15 , CTRL+Num8 - Обж. на форум
Gui, Add, Text, x2 x20 y180 w300 h15 , ALT+Num8 - Соблюдать ПДД
Gui, Add, Text, x2 x20 y195 w338 h15 c9FFC69, ALT+Num9 - /rcarall 4+ (АДМ НОВОСТИ, ЧАТ НЕ ОТКРЫВАТЬ!)
Gui, Add, Text, x2 x20 y210 w300 h15 , ALT+Num0 - Проверка на бота
Gui, Add, Text, x2 x20 y225 w300 h15 , CTRL+Num0 - Проверка на бота пройдена

; ------------------------------- Админ команды БАНЫ (ОСНОВНОЕ)-------------------------------

Gui 1:Font, s11 cWhite Bold, Arial
Gui 1:Add, GroupBox, x370 y40 w420 h540 c9FFC69, [ banname (3 lvl) ]
Gui 1:Font, s11 cWhite Bold, Arial
Gui, Add, Text, x2 x380 y60 w400 h15 c9FFC69, Все блокировки по нику.
Gui, Add, Text, x2 x380 y75 w400 h20 c9FFC69, Данные команды вводить исключительно в F8 ! ! !
Gui 1:Font, s8 cWhite Bold, Arial
Gui, Add, Text, x2 x380 y95 w395 h15 , /бх - BH при погоне
Gui, Add, Text, x2 x380 y110 w395 h15 , /выходрп - Off от РП
Gui, Add, Text, x2 x380 y125 w395 h15 , /вх - WH
Gui, Add, Text, x2 x380 y140 w395 h15 , /дмигрок - DM игрока
Gui, Add, Text, x2 x380 y155 w395 h15 , /дмкар - DM car
Gui, Add, Text, x2 x380 y170 w395 h15 , /дмкил - DM kill
Gui, Add, Text, x2 x380 y185 w395 h15 , /дмкпз - DM через клетку КПЗ
Gui, Add, Text, x2 x380 y200 w395 h15 , /дб - DB
Gui, Add, Text, x2 x380 y215 w395 h15 , /пг - PG
Gui, Add, Text, x2 x380 y230 w395 h15 , /подрез - Созд. аварийных ситуаций
Gui, Add, Text, x2 x380 y245 w395 h15 , /погоняепт - Езда по газонам/тротуарам при погоне
Gui, Add, Text, x2 x380 y260 w395 h15 , /погоняепп - Езда по полю при погоне
Gui, Add, Text, x2 x380 y275 w395 h15 , /политпров - Полит. провокация
Gui, Add, Text, x2 x380 y290 w395 h15 , /погонявело - Погоня на велосипеде
Gui, Add, Text, x2 x380 y305 w395 h15 , /оскпроект - Оск. проекта
Gui, Add, Text, x2 x380 y320 w395 h15 , /оскрод - Оск. родных
Gui, Add, Text, x2 x380 y335 w395 h15 , /оскадм - Оск. администрации
Gui, Add, Text, x2 x380 y350 w395 h15 , /тк - TK
Gui, Add, Text, x2 x380 y365 w395 h15 , /таран - Таран авто
Gui, Add, Text, x2 x380 y380 w395 h15 , /упомрод - Упом. родных
Gui, Add, Text, x2 x380 y395 w395 h15 , /уходрп - Уход от рп
Gui, Add, Text, x2 x380 y410 w395 h15 , /шантаж - Шантаж и вымогательства
Gui, Add, Text, x2 x380 y425 w395 h15 , /нацизм - Проявление нацизма
Gui, Add, Text, x2 x380 y440 w395 h15 , /расизм - Проявление расизма
Gui, Add, Text, x2 x380 y455 w395 h15 , /ртлц - Рабочий транспорт в ЛЦ
Gui, Add, Text, x2 x380 y470 w395 h15 , /банбагоюз - Мелкий багоюз
Gui, Add, Text, x2 x380 y485 w395 h15 , /нонрп - NonRP
Gui, Add, Text, x2 x380 y500 w395 h15 , /вилка - Вилка в клаве
Gui, Add, Text, x2 x380 y515 w395 h15 , /рекламачит - Реклама сторонних рес.
Gui, Add, Text, x2 x380 y530 w395 h15 , /чит - Читы
Gui, Add, Text, x2 x380 y545 w395 h15 , /ботраб - Бот для работы
Gui, Font, S8 c747474, Regular, Arial,
Gui, Add, Text, x545 y582 w300 h30 , Создатели: Stich_Allen and German_McKenzy

; ------------------------------- Админ команды джайлы (ОСНОВНОЕ)-------------------------------

Gui 1:Font, s11 c000000 Bold, Arial
Gui 1:Add, GroupBox, x10 y250 w350 h330 c9FFC69, [ ajail | muted | kicked (2 lvl) ]
Gui 1:Font, s8 cWhite Bold, Arial
Gui, Add, Text, x20 y270 w330 h15 , /встречка - Встречка
Gui, Add, Text, x20 y285 w330 h15 , /красные - Красный х2
Gui, Add, Text, x20 y300 w330 h15 , /епп - Езда по полю
Gui, Add, Text, x20 y315 w330 h15 , /епт - Езда по тротуару/газону
Gui, Add, Text, x20 y330 w330 h15 , /епр - Езда по рельсам
Gui, Add, Text, x20 y345 w330 h15 , /музыка - Музыка в ГЧ
Gui, Add, Text, x20 y360 w330 h15 , /помеха - Афк помеха
Gui, Add, Text, x20 y375 w330 h15 , /оффтоп - Offtop in report
Gui, Add, Text, x20 y390 w330 h15 , /мг - MG
Gui, Add, Text, x20 y405 w330 h15 , /капс - Caps Lock
Gui, Add, Text, x20 y420 w330 h15 , /флуд - Flood
Gui, Add, Text, x20 y435 w330 h15 , /мат - Употребление нецензурных слов
Gui, Add, Text, x20 y450 w330 h15 , /оскигрок - Оск. игроков
Gui, Add, Text, x20 y465 w330 h15 , /неувоб - Неув. обращение в репорт
Gui, Add, Text, x20 y480 w330 h15 , /безсвета - Без света ОТ
Gui, Add, Text, x20 y495 w330 h15 , /пантограф - Торм. пантографом
Gui, Add, Text, x20 y510 w330 h15 , /кикафк - Кик игроков 3+ афк (в хх:х5 (говка))
Gui, Add, Text, x20 y525 w330 h15 , /фармзп - AFK 15+ (фракция)
Gui, Add, Text, x20 y540 w330 h15 ,
Gui, Add, Text, x20 y555 w330 h15 ,

; ------------------------------- РАБОТЫ (GPS)-------------------------------

Gui 1:Font, s11 cWhite Bold, Arial
Gui 1:Tab, 2
Gui 1:Add, GroupBox, x10 y40 w250 h250 c9FFC69, [ job ]
Gui 1:Font, s8 cWhite Bold, Arial
Gui, Add, Text, x20 y60 w230 h15, /атп - АТП
Gui, Add, Text, x20 y75 w230 h15, /сто - Автомастерская
Gui, Add, Text, x20 y90 w230 h15 , /аэропорт - Аэропорт
Gui, Add, Text, x20 y105 w230 h15 , /банк - Банк
Gui, Add, Text, x20 y120 w230 h15 , /дорожная служба - Дорожная служба
Gui, Add, Text, x20 y135 w230 h15 , /жбк - Завод ЖБК
Gui, Add, Text, x20 y150 w230 h15 , /лесопилка - Лесопилка(Жуковский)
Gui, Add, Text, x20 y165 w230 h15 , /трамвай - Трамвайное депо
Gui, Add, Text, x20 y180 w230 h15 , /дальнобой - Транспортная компания
Gui, Add, Text, x20 y195 w230 h15 , /стройка - Стройплощадка
Gui, Add, Text, x20 y210 w230 h15 , /такси - Таксопарк
Gui, Add, Text, x20 y225 w230 h15 , /шахта - Шахта
Gui, Add, Text, x20 y240 w230 h15 , /вту - ВТУ (Волчанск)
Gui, Add, Text, x20 y255 w230 h15 , /октябрь - Завод "Красный Октябрь"
Gui, Add, Text, x20 y270 w230 h15 , /табачка - Табачный завод

; ------------------------------- Часто используемые (GPS)-------------------------------

Gui 1:Font, s11 cWhite Bold, Arial
Gui 1:Tab, 2
Gui 1:Add, GroupBox, x270 y40 w250 h460 c9FFC69, [ other ]
Gui 1:Font, s8 cWhite Bold, Arial
Gui, Add, Text, x280 y60 w220 h15 , /больница - Больница
Gui, Add, Text, x280 y75 w220 h15 , /военкомат - Военкоман
Gui, Add, Text, x280 y90 w220 h15 , /полиция - Полицейский участок
Gui, Add, Text, x280 y105 w220 h15 , /вч - Воинская часть
Gui, Add, Text, x280 y120 w220 h15 , /ржд - Здание РЖД
Gui, Add, Text, x280 y135 w220 h15 , /отдых - Магазин "Все для отдыха"
Gui, Add, Text, x280 y150 w220 h15 , /автомагазин - Автомагазин
Gui, Add, Text, x280 y165 w220 h15 , /скупщик - Скупщик рыбы и грибов
Gui, Add, Text, x280 y180 w220 h15 , /автосалон - Автосалон
Gui, Add, Text, x280 y195 w220 h15 , /автостоянка - Автостоянка
Gui, Add, Text, x280 y210 w220 h15 , /маэс - МАЭС
Gui, Add, Text, x280 y225 w220 h15 , /стадион - Стадион Мирный
Gui, Add, Text, x280 y240 w220 h15 , /летная школа - Летная школа
Gui, Add, Text, x280 y255 w220 h15 , /водная школа - Водная школа
Gui, Add, Text, x280 y270 w220 h15 , /гостиница - Гостиница
Gui, Add, Text, x280 y285 w220 h15 , /хранилище - Хранилище
Gui, Add, Text, x280 y300 w220 h15 , /порт - Морской порт Невского
Gui, Add, Text, x280 y315 w220 h15 , /офис - Офисный центр
Gui, Add, Text, x280 y330 w220 h15 , /гтрек - Гоночный трек
Gui, Add, Text, x280 y345 w220 h15 , /ттрек - Тестовый трек
Gui, Add, Text, x280 y360 w220 h15 , /лента - ТЦ "Лента"
Gui, Add, Text, x280 y375 w220 h15 , /вивалэнд - ТРК "ВиваЛэнд"
Gui, Add, Text, x280 y390 w220 h15 , /цветы - Цветочная лавка Николая
Gui, Add, Text, x280 y405 w220 h15 , /аренда - Аренда авто/великов/лодок
Gui, Add, Text, x280 y420 w220 h15 , /бар - Бар Приволжск/Мирный
Gui, Add, Text, x280 y435 w220 h15 , /пк - Компьютерный клуб
Gui, Add, Text, x280 y450 w220 h15 , /спортзал - Спортивный зал
Gui, Add, Text, x280 y465 w220 h15 , /парашют - Прыжок с парашютом
Gui, Add, Text, x280 y480 w220 h15 , /тир - Тир
Gui, Font, S8 c747474, Regular, Arial,
Gui, Add, Text, x545 y582 w300 h30 , Создатели: Stich_Allen and German_McKenzy

; ------------------------------- Часто используемые (БИНДЫ)-------------------------------

Gui 1:Tab, 3
Gui 1:Font, s11 cWhite Bold, Arial
Gui 1:Add, GroupBox, x10 y40 w300 h280 c9FFC69, [ binds ]
Gui 1:Font, s8 cWhite Bold, Arial
Gui, Add, Text, x2 x20 y60 w250 h15 , /двери - Двери трамваев/автобусов
Gui, Add, Text, x2 x20 y75 w250 h15 , /скорость - Лимит скорости
Gui, Add, Text, x2 x20 y90 w250 h15 , /круиз - Круиз контроль
Gui, Add, Text, x2 x20 y105 w250 h15 , /войс - Голосовой чат
Gui, Add, Text, x2 x20 y120 w250 h15 , /чат - IC чат
Gui, Add, Text, x2 x20 y135 w250 h15 , /телефон - Достать/убрать телефон
Gui, Add, Text, x2 x20 y150 w250 h15 , /карпанель - Панель авто (F3)
Gui, Add, Text, x2 x20 y165 w250 h15 , /двигатель - зажигание двигателя
Gui, Add, Text, x2 x20 y180 w250 h15 , /скрин - Скриншот (F12)
Gui, Add, Text, x2 x20 y195 w250 h15 , /карта - Карта (F11)
Gui, Add, Text, x2 x20 y210 w250 h15 , /крюк - Крюк эвакуатора
Gui, Add, Text, x2 x20 y225 w250 h15 , /шасси - Шсси самолетов
Gui, Add, Text, x2 x20 y240 w250 h15 , /маячки - Маячки
Gui, Add, Text, x2 x20 y255 w250 h15 , /ремень - Ремень безопасности
Gui, Add, Text, x2 x20 y270 w250 h15 , /f21 - Панель игроков F2
Gui, Add, Text, x2 x20 y285 w280 h15 , [Писать в F8] /нум - Все клавиши NumPad

; ------------------------------- Другое (БИНДЫ/ДРУГОЕ)-------------------------------

Gui 1:Font, s11 cWhite Bold, Arial
Gui 1:Tab, 3
Gui 1:Add, GroupBox, x320 y40 w350 h280 c9FFC69, [ command ]
Gui 1:Font, s8 cWhite Bold, Arial
Gui, Add, Text, x330 y60 w320 h15 , /проверкаафк - Проверка на AFK
Gui, Add, Text, x330 y75 w320 h15 , /впс - Попросить игрока изучить ВПС
Gui, Add, Text, x330 y90 w320 h15 , /поезд - Расписание поездов
Gui, Add, Text, x330 y105 w320 h15 , /эвакуатор - Все команды работы эвакуатора
Gui, Add, Text, x330 y120 w320 h15 , /мп - Группа мероприятий сервера
Gui, Add, Text, x330 y135 w320 h15 , /права - стоимость ВУ B,D,C
Gui, Add, Text, x330 y150 w320 h15 , /номер - Где получить номера
Gui, Add, Text, x330 y165 w330 h15 , /дистанция - предупредить соблюдать дистанцию
Gui, Add, Text, x330 y180 w320 h15 , /свет - предупредить включить свет
Gui, Add, Text, x330 y195 w320 h15 , /собес - Расписание новостей
Gui, Add, Text, x330 y210 w320 h15 , /jai - /jailtime
Gui, Add, Text, x330 y225 w320 h15 , /а31 - F3 - Эвакуировать авто
Gui, Add, Text, x330 y240 w320 h15 , /донат - Сайт с донатом в игру
Gui, Add, Text, x330 y255 w320 h15 , /скидка - Промокод на скидку
Gui, Add, Text, x330 y270 w320 h15 , /баг - Писать про баг в ДС
Gui, Add, Text, x330 y285 w320 h15 , /берег - Ищите берег самостоятельно
;Gui, Add, Text, x330 y300 w320 h15 , -
;Gui, Add, Text, x330 y315 w320 h15 , -
;Gui, Add, Text, x330 y330 w320 h15 , -
;Gui, Add, Text, x330 y345 w320 h15 , -
Gui, Font, S8 c747474, Regular, Arial,
Gui, Add, Text, x545 y582 w300 h30 , Создатели: Stich_Allen and German_McKenzy

------------------------------------АДМИН ТЭГ------------------------------------
Gui 1:Tab, 1
Gui 1:Font, s12 cFD7B7C Bold Arial
Gui 1:Add, Button, x640 y10 w150 h30 gOpenTagMenu BackgroundColor=cWhite TextColor=cFD7B7C, Изменение тега
if FileExist(iniFile) {
    IniRead, SavedTag, %iniFile%, Settings, Tag  ; читаем тег из файла
    if (SavedTag = "ERROR" || SavedTag = "") {  ; если тег пустой или файл поврежден
        MsgBox, Ошибка: Тег не найден или файл поврежден. Пожалуйста, введите новый тег.
        SavedTag := ""  ; оставляет тег пустым
    }
} else {
    SavedTag := ""  ; Если файла нет, оставляем тег пустым
}
Gui 3:Font, s12
Gui 3:Add, Edit, vNewTagInput w200 BackgroundColor=White TextColor=Black, %SavedTag%  ; поле для ввода нового тега
Gui 3:Add, Button, gSaveTag, save
Gui 3:Add, Button, gCloseTagGUI, close
Gui 2:Font, s14 Bold Arial
Gui 2:Color, c202127
Gui 2:Add, Edit, vCurrentTag w200 x100 y50 Center, %SavedTag%
Gui 2:Font, s11 Bold Arial
Gui 2:Add, Text, x160 y30 w120 h15 cWhite, Новый тег:
Gui 2:Font, s14 c202127
Gui 2:Add, Button, x140 y120 w120 h40 gButtonReset, Reset
Gui 2:Add, Button, x10 y120 w120 h40 gButtonSave, Save
Gui 2:Add, Button, x270 y120 w120 h40 gButtonCancel, Close
Gui 2:Hide
SetTimer, CheckTag, 30000  ; 30000 мс = 30 секунд
Gui 1:Show, center h600 w800, AdminHelper
return

; Таймер для проверки наличия тега
CheckTag:
if !FileExist(iniFile) || (SavedTag = "") {  ; Если файла нет или тег пустой
    ; Закрываем предыдущее окно ошибки (если оно есть)
    WinClose, Ошибка ahk_class #32770  ; Закрываем окно с заголовком "Ошибка"
    ; Показываем новое сообщение об ошибке
    MsgBox, 16, Ошибка, Тег не задан! Пожалуйста, введите тег.
}
return
SaveTag:
Gui 3:Submit, NoHide  ; Сохраняем введенные данные без закрытия GUI
if (NewTagInput = "") {
    MsgBox, Ошибка: Тег не может быть пустым!
    return
}
if !EnsureFolderExists()
{
    return
}
IniWrite, %NewTagInput%, %iniFile%, Settings, Tag
if ErrorLevel {
    MsgBox, Ошибка при сохранении тега!
    return
}
MsgBox, Новый тег сохранен: %NewTagInput%
SavedTag := NewTagInput  ; Обновляем переменную SavedTag
GuiControl, 2:, CurrentTag, %NewTagInput%  ; Обновляем поле в GUI 2
return
CloseTagGUI:
Gui 3:Hide  ; Скрываем GUI 3
return
ButtonReset:
MsgBox, 4,, Вы уверены, что хотите сбросить тег?
IfMsgBox, No
    return
GuiControl, 2:, CurrentTag,  ; Очищаем поле ввода
if !EnsureFolderExists()
{
    return
}

IniDelete, %iniFile%, Settings, Tag  ; Удаляем тег из файла
SavedTag := ""  ; Очищаем переменную SavedTag
MsgBox, Тег сброшен.
return
ButtonSave:
Gui 2:Submit, NoHide
GuiControlGet, CurrentTag,, CurrentTag
if (CurrentTag = "") {
    MsgBox, Ошибка: Тег не может быть пустым!
    return
}
if !EnsureFolderExists()
{
    return
}

IniWrite, %CurrentTag%, %iniFile%, Settings, Tag  ; Сохраняем тег в файл
if ErrorLevel {
    MsgBox, Ошибка при сохранении тега!
    return
}
SavedTag := CurrentTag  ; Обновляем переменную SavedTag
MsgBox, Тег сохранен: %CurrentTag%
return
OpenTagMenu:
Gui 2:Show, w400 h170, Admin tag
return
ButtonCancel:
Gui 1:-Disabled
Gui 2:Cancel
return

; Горячая клавиша для открытия GUI 3 (управление тегом)
^!t::  ; Ctrl+Alt+T для открытия GUI 3
Gui 3:Show,, Настройка тега
return

; Закрыть скрипт на крестик
GuiClose:
ExitApp

------------------------------------АДМИН ТЭГ------------------------------------

CapsLock::Return

!numpad0::
SendMessage, 0x50,, 0x4190419,, A
Sleep 200
SendPlay, {space} [Проверка] Как меня зовут?
return

^numpad0::
    Random, rand, 1, 5
    if (rand = 1) {
        command := "Проверка на отсутствие бота для работы пройдена"
    } else if (rand = 2) {
        command := "Проверка на отсутствие софта пройтена"
    } else if (rand = 3) {
        command := "Проверка успешно пройдена"
    } else if (rand = 4) {
        command := "Проверка пройдена, удачи{!}"
    } else if (rand = 5) {
        command := "Проверка пройдена. Приятной игры{!}"
    }
    SendMessage, 0x50,, 0x4190419,, A
    Sleep 200
    SendPlay {space}%command%
return

!numpad1::
    Random, rand, 1, 15
    if (rand = 1) {
        command := "Приятной игры{!}"
    } else if (rand = 2) {
        command := "Удачи{!}"
    } else if (rand = 3) {
        command := "удачи"
    } else if (rand = 4) {
        command := "приятной игры"
    } else if (rand = 5) {
        command := "Приятной игры"
    } else if (rand = 6) {
        command := "Удачи"
    } else if (rand = 7) {
        command := "удачи{!}"
    } else if (rand = 8) {
        command := "удачи"
    } else if (rand = 9) {
        command := "Приятной игры{!}"
    } else if (rand = 10) {
        command := "удачи"
    } else if (rand = 11) {
        command := "Приятной игры{!}"
    } else if (rand = 12) {
        command := "приятной игры{!}"
    } else if (rand = 13) {
        command := "приятной игры"
    } else if (rand = 14) {
        command := "удачи"
    } else if (rand = 15) {
        command := "Удачи"
    }
    SendMessage, 0x50,, 0x4190419,, A
    Sleep 100
    SendPlay {space}%command%
return

!numpad2::
    Random, rand, 1, 6
    if (rand = 1) {
        command := "Слежу"
    } else if (rand = 2) {
        command := "слежу"
    } else if (rand = 3) {
        command := "Слежу"
    } else if (rand = 4) {
        command := "Cлежу"
    } else if (rand = 5) {
        command := "Слежу"
    } else if (rand = 6) {
        command := "слежу"
    }
    SendMessage, 0x50,, 0x4190419,, A
    Sleep 100
    SendPlay {space}%command%
return

!numpad3::
    Random, rand, 1, 14
    if (rand = 1) {
        command := "Нарушений не заметил"
    } else if (rand = 2) {
        command := "нарушений не заметил"
    } else if (rand = 3) {
        command := "Нарушений нет"
    } else if (rand = 4) {
        command := "нарушений нет"
    } else if (rand = 5) {
        command := "Не нарушает"
    } else if (rand = 6) {
        command := "не нарушает"
    } else if (rand = 7) {
        command := "Нарушения нет"
    } else if (rand = 8) {
        command := "нарушения нет"
    } else if (rand = 9) {
        command := "Игрок не нарушает"
    } else if (rand = 10) {
        command := "игрок не нарушает"
    } else if (rand = 11) {
        command := "Нарушений не заметил"
    } else if (rand = 12) {
        command := "нарушений не заметил"
    } else if (rand = 13) {
        command := "Нарушений не увидел"
    } else if (rand = 14) {
        command := "нарушений не увидел"
    }
    SendMessage, 0x50,, 0x4190419,, A
    Sleep 100
    SendPlay {space}%command%
return


!numpad4::
    Random, rand, 1, 12
    if (rand = 1) {
        command := "Наказал"
    } else if (rand = 2) {
        command := "Игрок наказан"
    } else if (rand = 3) {
        command := "наказан"
    } else if (rand = 4) {
        command := "наказал"
    } else if (rand = 5) {
        command := "игрок наказан"
    } else if (rand = 6) {
        command := "Наказан"
    } else if (rand = 7) {
        command := "игрок наказан"
    } else if (rand = 8) {
        command := "Наказал"
    } else if (rand = 9) {
        command := "Наказан"
    } else if (rand = 10) {
        command := "Наказан"
    } else if (rand = 11) {
        command := "Игрок наказан"
    } else if (rand = 12) {
        command := "Наказал"
    }
    SendMessage, 0x50,, 0x4190419,, A
    Sleep 100
    SendPlay {space}%command%
return

!numpad6::
    Random, rand, 1, 21
    if (rand = 1) {
        command := "Обратитесь в тех. поддержку"
    } else if (rand = 2) {
        command := "вам в тех. поддержку"
    } else if (rand = 3) {
        command := "напишите в тех. поддержку"
    } else if (rand = 4) {
        command := "Пишите в тех. поддержку"
    } else if (rand = 5) {
        command := "Напишите в тех. поддержку"
    } else if (rand = 6) {
        command := "пишите в тех.поддержку"
    } else if (rand = 7) {
        command := "вам в тех.поддержку"
    } else if (rand = 8) {
        command := "обратитесь в тех.поддержку"
    } else if (rand = 9) {
        command := "Напишите в тех. поддержку"
    } else if (rand = 10) {
        command := "Напишите в тех.поддержку"
    } else if (rand = 11) {
        command := "обратитесь в тех. поддержку"
    } else if (rand = 12) {
        command := "Вам в тех. поддержку"
    } else if (rand = 13) {
        command := "Пишите в тех.поддержку"
    } else if (rand = 14) {
        command := "напишите в тех.поддержку"
    } else if (rand = 15) {
        command := "напишите в тех. поддержку"
    } else if (rand = 16) {
        command := "напишите в тех. поддержку"
    } else if (rand = 17) {
        command := "Вам в тех.поддержку"
    } else if (rand = 18) {
        command := "напишите в тех.поддержку"
    } else if (rand = 19) {
        command := "Напишите в тех.поддержку"
    } else if (rand = 20) {
        command := "Обратитесь в тех.поддержку"
    } else if (rand = 21) {
        command := "пишите в тех. поддержку"
    }
    SendMessage, 0x50,, 0x4190419,, A
    Sleep 100
    SendPlay {space}%command%
return

!numpad5::
    Random, rand, 1, 28
    if (rand = 1) {
        command := "Изуче на province.info"
    } else if (rand = 2) {
        command := "изуче на province.info"
    } else if (rand = 3) {
        command := "изуче на провинс инфо"
    } else if (rand = 4) {
        command := "Изуче на провинс инфо"
    } else if (rand = 5) {
        command := "Найдите на province.info"
    } else if (rand = 6) {
        command := "найдите на province.info"
    } else if (rand = 7) {
        command := "Найдите на провинс инфо"
    } else if (rand = 8) {
        command := "найдите на провинс инфо"
    } else if (rand = 9) {
        command := "изучите самостоятельно"
    } else if (rand = 10) {
        command := "Изучите самостоятельно"
    } else if (rand = 11) {
        command := "Ищите на province.info"
    } else if (rand = 12) {
        command := "ищите на province.info"
    } else if (rand = 13) {
        command := "Ищите на провинс инфо"
    } else if (rand = 14) {
        command := "ищите на провинс инфо"
    } else if (rand = 15) {
        command := "вам на province.info"
    } else if (rand = 16) {
        command := "Вам на province.info"
    } else if (rand = 17) {
        command := "Изучите самостоятельно"
    } else if (rand = 18) {
        command := "изучите самостоятельно"
    } else if (rand = 19) {
        command := "изуче на Провинс инфо"
    } else if (rand = 20) {
        command := "Изуче на Провинс инфо"
    } else if (rand = 21) {
        command := "найдите на Провинс инфо"
    } else if (rand = 22) {
        command := "Найдите на Провинс инфо"
    } else if (rand = 23) {
        command := "ищите на Провинс инфо"
    } else if (rand = 24) {
        command := "Ищите на Провинс инфо"
    } else if (rand = 25) {
        command := "Изучите на Провинс инфо"
    } else if (rand = 26) {
        command := "изучите на Провинс инфо"
    } else if (rand = 27) {
        command := "Ищите на провинс инфо"
    } else if (rand = 28) {
        command := "ищите на провинс инфо"
    }
    SendMessage, 0x50,, 0x4190419,, A
    Sleep 100
    SendPlay {space}%command%
return

!numpad7::
    Random, rand, 1, 15
    if (rand = 1) {
        command := "Оставьте жалобу на форум"
    } else if (rand = 2) {
        command := "оставьте жалобу на форум"
    } else if (rand = 3) {
        command := "Пишите жалобу"
    } else if (rand = 4) {
        command := "пишите жалобу"
    } else if (rand = 5) {
        command := "Пишите жалобу на форум"
    } else if (rand = 6) {
        command := "пишите жалобу на форум"
    } else if (rand = 7) {
        command := "Напишите жалобу на форум"
    } else if (rand = 8) {
        command := "напишите жалобу на форум"
    } else if (rand = 9) {
        command := "Оставьте жалобу на форум"
    } else if (rand = 10) {
        command := "оставьте жалобу на форум"
    } else if (rand = 11) {
        command := "пишите жалобу на форум"
    } else if (rand = 12) {
        command := "Пишите жалобу"
    } else if (rand = 13) {
        command := "Напишите жалобу"
    } else if (rand = 14) {
        command := "напишите жалобу"
    } else if (rand = 15) {
        command := "пишите жалобу"
    }
    SendMessage, 0x50,, 0x4190419,, A
    Sleep 100
    SendPlay {space}%command%
return

^numpad7::
    Random, rand, 1, 15
    if (rand = 1) {
        command := "Обжалуйте наказание на форуме"
    } else if (rand = 2) {
        command := "обжалуйте наказание на форуме"
    } else if (rand = 3) {
        command := "Обжалуйте наказание"
    } else if (rand = 4) {
        command := "обжалуйте наказание"
    } else if (rand = 5) {
        command := "Пишите обжалование"
    } else if (rand = 6) {
        command := "пишите обжалование"
    } else if (rand = 7) {
        command := "Напишите обжалование"
    } else if (rand = 8) {
        command := "напишите обжалование"
    } else if (rand = 9) {
        command := "Пишите обжалование на форум"
    } else if (rand = 10) {
        command := "пишите обжалование на форум"
    } else if (rand = 11) {
        command := "напишите обжалование на форум"
    } else if (rand = 12) {
        command := "напишите обжалование на форум"
    } else if (rand = 13) {
        command := "напишите обжалование"
    } else if (rand = 14) {
        command := "Напишите обжалование"
    } else if (rand = 15) {
        command := "Пишите обжалование"
    }
    SendMessage, 0x50,, 0x4190419,, A
    Sleep 100
    SendPlay {space}%command%
return

!numpad8::
    Random, rand, 1, 5
    if (rand = 1) {
        command := "Соблюдайте ПДД"
    } else if (rand = 2) {
        command := "Не нарушайте ПДД"
    } else if (rand = 3) {
        command := "соблюдайте ПДД"
    } else if (rand = 4) {
        command := "не нарушайте пдд"
    } else if (rand = 5) {
        command := "соблюдайте ПДД"
    }
    SendMessage, 0x50,, 0x4190419,, A
    Sleep 100
    SendPlay {space}%command%
return

!numpad9::
SendPlay, {T}
SendMessage, 0x50,, 0x4190419,, A
Sleep 2000
SendPlay, /p Уважаемые игроки{!} {enter}
Sleep 500
SendPlay, {T}
Sleep 2000
SendPlay, /p Через 30 секунд будет респавн всех служебных и рабочих ТС. Просим занять свои авто. {enter}
Sleep 29000
SendPlay, {T}
SendMessage, 0x50,, 0x4190419,, A
Sleep 2000
SendPlay, /rcarall {enter}
Sleep 500
SendPlay, {T}
Sleep 2000
SendPlay, /p Респавн транспорта произошёл успешно. Приятной игры с администрацией второго сервера{!} {Enter}
return

:*?:/рекламамп1::
SendMessage, 0x50,, 0x4190419,, A
Sleep 2000
SendPlay /p Не знаешь, чем заняться на сервере и ищешь развлечения? {enter}
Sleep 300
SendPlay, {T}
Sleep 2000
SendPlay /p Ежедневные рубрики и мероприятия с призами публикуются в нашей группе vk.com/2province_mp {enter}
return

:*?:/гувд::
SendMessage, 0x50,, 0x4190419,,
Sleep 500
SendPlay /p Хотите стоять на страже закона и участвовать в операциях по задержанию опасных преступников? {enter}
Sleep 500
SendPlay, {T}
Sleep 2000
SendPlay /p Присоединяйтесь к одному из филиалов УВД Республики Провинция{!} {enter}
Sleep 500
SendPlay, {T}
Sleep 2000
SendPlay /p Ежедневные патрули, задержание преступников, обучение и специальные мероприятия ждут вас. {enter}
Sleep 500
SendPlay, {T}
Sleep 2000
SendPlay /p Оставить заявку на трудоустройство можно в любой из городов: https://vk.cc/ceSvIP {enter}
return

:*?:/хранилище::
    Random, rand, 1, 4
    if (rand = 1) {
        command := "/gps - Приволжск"
    } else if (rand = 2) {
        command := "/gps - Приволжск - Услуги - Склад"
    } else if (rand = 3) {
        command := "/gps - Приволжск - Услуги"
    } else if (rand = 4) {
        command := "/gps"
    }
    SendMessage, 0x50,, 0x4190419,, A
    Sleep 100
    SendPlay %command%
return

:*?:/банк::
    Random, rand, 1, 4
    if (rand = 1) {
        command := "/gps - Город"
    } else if (rand = 2) {
        command := "/gps - Город - Гос.учереждения"
    } else if (rand = 3) {
        command := "/gps - Город - Гос.учереждения - Банк"
    } else if (rand = 4) {
        command := "/gps"
    }
    SendMessage, 0x50,, 0x4190419,, A
    Sleep 100
    SendPlay %command%
return

:*?:/тту::
    Random, rand, 1, 5
    if (rand = 1) {
        command := "/gps - Город - Работа - ТТУ"
    } else if (rand = 2) {
        command := "/gps - Работа - ТТУ"
    } else if (rand = 3) {
        command := "/gps"
    } else if (rand = 4) {
        command := "/gps - Город - Работа"
    } else if (rand = 5) {
        command := "/gps - город - работа - тту"
    }
    SendMessage, 0x50,, 0x4190419,, A
    Sleep 100
    SendPlay %command%
return

:*?:/дальнобой::
    Random, rand, 1, 5
    if (rand = 1) {
        command := "/gps - Город - Работа - Транспортная компания"
    } else if (rand = 2) {
        command := "/gps - Работа - транспортная компания"
    } else if (rand = 3) {
        command := "/gps"
    } else if (rand = 4) {
        command := "/gps - Город - Работа"
    } else if (rand = 5) {
        command := "/gps - город - работа - Транспортная компания"
    }
    SendMessage, 0x50,, 0x4190419,, A
    Sleep 100
    SendPlay %command%
return

:*?:/тюнинг::
    Random, rand, 1, 5
    if (rand = 1) {
        command := "/gps - Город - Авто - Тюнинг-ателье"
    } else if (rand = 2) {
        command := "/gps - Авто - Тюнинг-ателье"
    } else if (rand = 3) {
        command := "/gps"
    } else if (rand = 4) {
        command := "/gps - Город - Авто"
    } else if (rand = 5) {
        command := "/gps - город - авто - тюнинг-ателье"
    }
    SendMessage, 0x50,, 0x4190419,, A
    Sleep 100
    SendPlay %command%
return

:*?:/автошкола::
    Random, rand, 1, 5
    if (rand = 1) {
        command := "/gps - Город - Гос.учреждения - Автошкола"
    } else if (rand = 2) {
        command := "/gps - гос.учреждения"
    } else if (rand = 3) {
        command := "/gps"
    } else if (rand = 4) {
        command := "/gps - город - гос.учреждения"
    } else if (rand = 5) {
        command := "/gps - город - гос.учреждения - автошкола"
    }
    SendMessage, 0x50,, 0x4190419,, A
    Sleep 100
    SendPlay %command%
return

:*?:/больница::
    Random, rand, 1, 5
    if (rand = 1) {
        command := "/gps - Город - Гос.учреждения - Больница"
    } else if (rand = 2) {
        command := "/gps - гос.учреждения"
    } else if (rand = 3) {
        command := "/gps"
    } else if (rand = 4) {
        command := "/gps - город - гос.учреждения"
    } else if (rand = 5) {
        command := "/gps - город - гос.учреждения - больница"
    }
    SendMessage, 0x50,, 0x4190419,, A
    Sleep 100
    SendPlay %command%
return

:*?:/военкомат::
    Random, rand, 1, 5
    if (rand = 1) {
        command := "/gps - Приволжск/Мирный - Гос.учреждения - Военкомат"
    } else if (rand = 2) {
        command := "/gps - город - гос.учреждения - военкомат"
    } else if (rand = 3) {
        command := "/gps - гос.учреждения - Военкомат"
    } else if (rand = 4) {
        command := "/gps - Город - гос.учреждения"
    } else if (rand = 5) {
        command := "/gps"
    }
    SendMessage, 0x50,, 0x4190419,, A
    Sleep 100
    SendPlay %command%
return

:*?:/вч::
    Random, rand, 1, 5
    if (rand = 1) {
        command := "/gps"
    } else if (rand = 2) {
        command := "/gps - Мирный - Гос.учреждения - Воинская часть"
    } else if (rand = 3) {
        command := "/gps - мирный - гос.учреждения - воинская часть"
    } else if (rand = 4) {
        command := "/gps - Мирный - Гос.учреждения"
    } else if (rand = 5) {
        command := "/gps"
    }
    SendMessage, 0x50,, 0x4190419,, A
    Sleep 100
    SendPlay %command%
return

:*?:/полиция::
    Random, rand, 1, 5
    if (rand = 1) {
        command := "/gps"
    } else if (rand = 2) {
        command := "/gps - город - гос.учреждения - полицейский участок"
    } else if (rand = 3) {
        command := "/gps - город - гос.учреждения"
    } else if (rand = 4) {
        command := "/gps - гос.учреждения"
    } else if (rand = 5) {
        command := "/gps"
    }
    SendMessage, 0x50,, 0x4190419,, A
    Sleep 100
    SendPlay %command%
return

:*?:/отдых::
    Random, rand, 1, 5
    if (rand = 1) {
        command := "/gps - Ближайшие места"
    } else if (rand = 2) {
        command := "/gps - ближайшие места - Магазин Все для отдыха"
    } else if (rand = 3) {
        command := "/gps - Город - ближайшие места - магазин все для отдыха"
    } else if (rand = 4) {
        command := "/gps"
    } else if (rand = 5) {
        command := "/gps - ближайшие места"
    }
    SendMessage, 0x50,, 0x4190419,, A
    Sleep 100
    SendPlay %command%
return

:*?:/автомагазин::
    Random, rand, 1, 5
    if (rand = 1) {
        command := "/gps- ближайшие места"
    } else if (rand = 2) {
        command := "/gps"
    } else if (rand = 3) {
        command := "/gps - ближайшие места - автомагазин"
    } else if (rand = 4) {
        command := "/gps - Ближайшие места - Автомагазин"
    } else if (rand = 5) {
        command := "/gps - Город - Ближайшие места - Автомагазин"
    }
    SendMessage, 0x50,, 0x4190419,, A
    Sleep 100
    SendPlay %command%
return

:*?:/скупщик::
    Random, rand, 1, 5
    if (rand = 1) {
        command := "/gps - Ближайшие места - Скупщик"
    } else if (rand = 2) {
        command := "/gps - ближайшие места - Скупщик рыбы и грибов"
    } else if (rand = 3) {
        command := "/gps - Город - Ближайшие места"
    } else if (rand = 4) {
        command := "/gps"
    } else if (rand = 5) {
        command := "/gps - Город - ближайшие места - Скупщик рыбы и грибов"
    }
    SendMessage, 0x50,, 0x4190419,, A
    Sleep 100
    SendPlay %command%
return

:*?:/автосалон::
    Random, rand, 1, 5
    if (rand = 1) {
        command := "/gps - Город - Авто - Автосалон"
    } else if (rand = 2) {
        command := "/gps"
    } else if (rand = 3) {
        command := "/gps - авто - автосалон"
    } else if (rand = 4) {
        command := "/gps - город - авто - автосалон"
    } else if (rand = 5) {
        command := "/gps - Авто - Автосалон"
    }
    SendMessage, 0x50,, 0x4190419,, A
    Sleep 100
    SendPlay %command%
return

:*?:/автостоянка::
    Random, rand, 1, 5
    if (rand = 1) {
        command := "/gps"
    } else if (rand = 2) {
        command := "/gps - город - авто - автостоянка"
    } else if (rand = 3) {
        command := "/gps - Город - Авто - Автостоянка"
    } else if (rand = 4) {
        command := "/gps - авто - автостоянка"
    } else if (rand = 5) {
        command := "/gps - Авто"
    }
    SendMessage, 0x50,, 0x4190419,, A
    Sleep 100
    SendPlay %command%
return

:*?:/маэс::
    Random, rand, 1, 5
    if (rand = 1) {
        command := "/gps"
    } else if (rand = 2) {
        command := "/gps - Мирный - Интересные места - АЭС"
    } else if (rand = 3) {
        command := "/gps - интересные места - АЭС"
    } else if (rand = 4) {
        command := "/gps - мирный - интересные места - АЭС"
    } else if (rand = 5) {
        command := "/gps - Мирный"
    }
    SendMessage, 0x50,, 0x4190419,, A
    Sleep 100
    SendPlay %command%
return

:*?:/звезда::
    Random, rand, 1, 4
    if (rand = 1) {
        command := "1 звезда - 10 минут в КПЗ/1 час на воле "
    } else if (rand = 2) {
        command := "1 звезда = 10 минут в КПЗ или 1 час игры"
    } else if (rand = 3) {
        command := "1 звезда = 10 минут в КПЗ. 1 звезда = 1 час прибывания на воле"
    } else if (rand = 4) {
        command := "1 звезда - 1 час на воле/10 минут в КПЗ"
    }
    SendMessage, 0x50,, 0x4190419,, A
    Sleep 100
    SendPlay %command%
return

:*?:/стадион::
    Random, rand, 1, 5
    if (rand = 1) {
        command := "/gps"
    } else if (rand = 2) {
        command := "/gps - Мирный - Интересные места - Арена Мирный"
    } else if (rand = 3) {
        command := "/gps - Мирный - Интересные места"
    } else if (rand = 4) {
        command := "/gps - мирный"
    } else if (rand = 5) {
        command := "/gps - мирный - интересные места"
    }
    SendMessage, 0x50,, 0x4190419,, A
    Sleep 100
    SendPlay %command%
return

:*?:/ржд::
    Random, rand, 1, 5
    if (rand = 1) {
        command := "/gps"
    } else if (rand = 2) {
        command := "/gps - мирный - РЖД"
    } else if (rand = 3) {
        command := "/gps - мирный - Гос.учреждения"
    } else if (rand = 4) {
        command := "/gps - Мирный - Гос.учреждения"
    } else if (rand = 5) {
        command := "/gps - мирный - гос.учреждения - здание РЖД"
    }
    SendMessage, 0x50,, 0x4190419,, A
    Sleep 100
    SendPlay %command%
return

:*?:/летная школа::
    Random, rand, 1, 5
    if (rand = 1) {
        command := "/gps"
    } else if (rand = 2) {
        command := "/gps - мирный - гос.учреждения - летная школа"
    } else if (rand = 3) {
        command := "/gps - мирный - летная школа"
    } else if (rand = 4) {
        command := "/gps - мирный - гос.учреждения"
    } else if (rand = 5) {
        command := "/gps - Мирный - Гос.учреждения - Летная школа"
    }
    SendMessage, 0x50,, 0x4190419,, A
    Sleep 100
    SendPlay %command%
return

:*?:/водная школа::
    Random, rand, 1, 5
    if (rand = 1) {
        command := "/gps"
    } else if (rand = 2) {
        command := "/gps - невский - гос.учреждения - Водная школа"
    } else if (rand = 3) {
        command := "/gps - невский - водная школа"
    } else if (rand = 4) {
        command := "/gps - Невский - гос.учреждения"
    } else if (rand = 5) {
        command := "/gps - Невский - Гос.учреждения - Водная школа"
    }
    SendMessage, 0x50,, 0x4190419,, A
    Sleep 100
    SendPlay %command%
return

:*?:/гостиница::
    Random, rand, 1, 5
    if (rand = 1) {
        command := "/gps"
    } else if (rand = 2) {
        command := "/gps - услуги - гостиница"
    } else if (rand = 3) {
        command := "/gps - город - услуги - гостиница"
    } else if (rand = 4) {
        command := "/gps - услуги - гостиница"
    } else if (rand = 5) {
        command := "/gps - Услуги - Гостиница"
    }
    SendMessage, 0x50,, 0x4190419,, A
    Sleep 100
    SendPlay %command%
return

:*?:/порт::
    Random, rand, 1, 5
    if (rand = 1) {
        command := "/gps"
    } else if (rand = 2) {
        command := "/gps - Невский - Интересные места"
    } else if (rand = 3) {
        command := "/gps - Невский"
    } else if (rand = 4) {
        command := "/gps - невский - интересные места"
    } else if (rand = 5) {
        command := "/gps - невский"
    }
    SendMessage, 0x50,, 0x4190419,, A
    Sleep 100
    SendPlay %command%
return

:*?:/войс::
    Random, rand, 1, 3
    if (rand = 1) {
        command := "bind клавиша doWn voiceptt 1 bind клавиша up voiceptt 0"
    } else if (rand = 2) {
        command := "bind клавиша voiceptt 1"
    } else if (rand = 3) {
        command := "bind клавиша voiceptt 1 bind клавиша voiceptt 0"
    }
    SendMessage, 0x50,, 0x4190419,, A
    Sleep 100
    SendPlay %command%
return

:*?:/эвакуатор::
    Random, rand, 1, 3
    if (rand = 1) {
        command := "/evacuate id /repair id"
    } else if (rand = 2) {
        command := "/repair id /evacuate id /mehlist"
    } else if (rand = 3) {
        command := "/evacuate id /repair id /mehlist Numpad 2,8"
    }
    SendMessage, 0x50,, 0x4190419,, A
    Sleep 100
    SendPlay %command%
return

:*?:/крюк::
    Random, rand, 1, 3
    if (rand = 1) {
        command := "bind num_8 special_control_up bind num_2 special_control_doWn "
    } else if (rand = 2) {
        command := "bind num_2 special_control_doWn bind num_8 special_control_up"
    } else if (rand = 3) {
        command := "bind num_8 special_control_up - поднять крюк bind num_2 special_control_doWn - опустить крюк"
    }
    SendMessage, 0x50,, 0x4190419,, A
    Sleep 100
    SendPlay %command%
return

:*?:/двери::
SendMessage, 0x50,, 0x4190419,, A
Sleep 100
SendPlay bind 2 open_doors
return

:*?:/скорость::
SendMessage, 0x50,, 0x4190419,, A
Sleep 100
SendPlay bind f5 speed_limit
return

:*?:/шасси::
SendMessage, 0x50,, 0x4190419,, A
Sleep 100
SendPlay bind 2 sub_mission
return

:*?:/маячки::
SendMessage, 0x50,, 0x4190419,, A
Sleep 100
SendPlay bind j speclight_onoff
return

:*?:/ремень::
SendMessage, 0x50,, 0x4190419,, A
Sleep 100
SendPlay bind b seatbelt
return

:*?:/впс::
    Random, rand, 1, 6
    if (rand = 1) {
        command := "Изучите правила сервера"
    } else if (rand = 2) {
        command := "Изучите правила сервера на форуме"
    } else if (rand = 3) {
        command := "Ознакомьтесь с правилами сервера"
    } else if (rand = 4) {
        command := "изучите правила сервера"
    } else if (rand = 5) {
        command := "изучите правила сервера на форуме"
    } else if (rand = 4) {
        command := "ознакомьтесь с правилами сервера"
    }
    SendMessage, 0x50,, 0x4190419,, A
    Sleep 100
    SendPlay %command%
return

:*?:/мп::
SendMessage, 0x50,, 0x4190419,, A
Sleep 100
SendPlay Группа по мероприятиям - https://vk.com/2province_mp
return

:*?:/круиз::
SendMessage, 0x50,, 0x4190419,, A
Sleep 100
SendPlay bind x cruise_control
return

; ------------------------------- АДМИН КОМАНДЫ (ОСНОВНОЕ)-------------------------------

:*?:/кикафк:: ; Писать в обычный чат. Перед этим занимаем админ волну!
Sleep 500
SendMessage, 0x50,, 0x4190419,, A
SendPlay /p Внимание{!} Через 10 секунд будет массовый кик игроков с афк более чем 3 минуты{!} {enter}
Sleep 500
SendPlay, {T}
Sleep 500
SendMessage, 0x50,, 0x4190419,, A
SendPlay /kickafk 3 {enter}
Sleep 2000
SendPlay, {T}
Sleep 500
SendMessage, 0x50,, 0x4190419,, A
SendPlay /p Массовый кик был завершен. Приятной игры{!} {enter}
return

:*?:/уходрп::
    SendMessage, 0x50,, 0x4190419,, A
    Sleep 100
    SendPlay, Кол-во дней: 
    Sleep 100
    Input, Days, V, {Enter}
    Days := Trim(Days)
    SendMessage, 0x50,, 0x4190419,, A
    Sleep 100
    SendPlay, banname  d %Days% Уход от РП by %SavedTag%
    SendPlay, {Home}{Right 8}
return

:*?:/выходрп::
SendMessage, 0x50,, 0x4190419,, A
Sleep 100
SendPlay, banname  d 7 Off от РП by %SavedTag%
Sleep 100
SendPlay, {Home}{Right 8}
return

:*?:/банбагоюз::
    SendMessage, 0x50,, 0x4190419,, A
    Sleep 100
    SendPlay, Кол-во дней: 
    Sleep 100
    Input, Days, V, {Enter}
    Days := Trim(Days)
    SendMessage, 0x50,, 0x4190419,, A
    Sleep 100
    SendPlay, banname  d %Days% Багоюз by %SavedTag%
    SendPlay, {Home}{Right 8}
return

:*?:/чит::
SendMessage, 0x50,, 0x4190419,, A
Sleep 100
SendPlay, banname  d 0 Читы by %SavedTag%
Sleep 100
SendPlay, {Home}{Right 8}
return

:*?:/ботраб::
SendMessage, 0x50,, 0x4190419,, A
Sleep 100
SendPlay banname  d 0 Бот для работы by %SavedTag%
Sleep 100
SendPlay, {Home}{Right 8}
return

:*?:/дмигрок::
    SendMessage, 0x50,, 0x4190419,, A
    Sleep 100
    SendPlay, Кол-во дней: 
    Sleep 100
    Input, Days, V, {Enter}
    Days := Trim(Days)
    SendMessage, 0x50,, 0x4190419,, A
    Sleep 100
    SendPlay, banname  d %Days% DM игрока by %SavedTag%
    SendPlay, {Home}{Right 8}
return

:*?:/дб::
    SendMessage, 0x50,, 0x4190419,, A
    Sleep 100
    SendPlay, Кол-во дней: 
    Sleep 100
    Input, Days, V, {Enter}
    Days := Trim(Days)
    SendMessage, 0x50,, 0x4190419,, A
    Sleep 100
    SendPlay, banname  d %Days% DB by %SavedTag%
    SendPlay, {Home}{Right 8}
return

:*?:/вх::
SendMessage, 0x50,, 0x4190419,, A
Sleep 100
SendPlay banname  h 3 WH by %SavedTag%
Sleep 100
SendPlay, {Home}{Right 8}
return

:*?:/бх::
    SendMessage, 0x50,, 0x4190419,, A
    Sleep 100
    SendPlay, Кол-во дней: 
    Sleep 100
    Input, Days, V, {Enter}
    Days := Trim(Days)
    SendMessage, 0x50,, 0x4190419,, A
    Sleep 100
    SendPlay, banname  d %Days% BH при погоне by %SavedTag%
    SendPlay, {Home}{Right 8}
return

:*?:/тк::
    SendMessage, 0x50,, 0x4190419,, A
    Sleep 100
    SendPlay, Кол-во дней: 
    Sleep 100
    Input, Days, V, {Enter}
    Days := Trim(Days)
    SendMessage, 0x50,, 0x4190419,, A
    Sleep 100
    SendPlay, banname  d %Days% TK by %SavedTag%
    SendPlay, {Home}{Right 8}
return

:*?:/пг::
    SendMessage, 0x50,, 0x4190419,, A
    Sleep 100
    SendPlay, Кол-во дней: 
    Sleep 100
    Input, Days, V, {Enter}
    Days := Trim(Days)
    SendMessage, 0x50,, 0x4190419,, A
    Sleep 100
    SendPlay, banname  d %Days% PG by %SavedTag%
    SendPlay, {Home}{Right 8}
return

:*?:/упомрод::
SendMessage, 0x50,, 0x4190419,, A
Sleep 100
SendPlay banname  d 15 Упом. родных в негативном контексте by %SavedTag%
Sleep 100
SendPlay, {Home}{Right 8}
return

:*?:/оскрод::
SendMessage, 0x50,, 0x4190419,, A
Sleep 100
SendPlay banname  d 30 Оск.родных by %SavedTag%
Sleep 100
SendPlay, {Home}{Right 8}
return

:*?:/оскадм::
    SendMessage, 0x50,, 0x4190419,, A
    Sleep 100
    SendPlay, Кол-во дней: 
    Sleep 100
    Input, Days, V, {Enter}
    Days := Trim(Days)
    SendMessage, 0x50,, 0x4190419,, A
    Sleep 100
    SendPlay, banname  d %Days% Оск. администрации by %SavedTag%
    SendPlay, {Home}{Right 8}
return

:*?:/политпров::
SendMessage, 0x50,, 0x4190419,, A
Sleep 100
SendPlay banname  d 30 Политическая провокация by %SavedTag%
Sleep 100
SendPlay, {Home}{Right 8}
return

:*?:/нацизм::
SendMessage, 0x50,, 0x4190419,, A
Sleep 100
SendPlay banname  d 30 Проявление нацизма/расизма by %SavedTag%
Sleep 100
SendPlay, {Home}{Right 8}
return

:*?:/расизм::
SendMessage, 0x50,, 0x4190419,, A
Sleep 100
SendPlay banname  d 30 Проявление расизма by %SavedTag%
Sleep 100
SendPlay, {Home}{Right 8}
return

:*?:/оскпроект::
SendMessage, 0x50,, 0x4190419,, A
Sleep 100
SendPlay banname  d 30 Оск. проекта by %SavedTag%
Sleep 100
SendPlay, {Home}{Right 8}
return

:*?:/рекламачит::
SendMessage, 0x50,, 0x4190419,, A
Sleep 100
SendPlay banname  d 0 Реклама сторонних ресурсов by %SavedTag%
Sleep 100
SendPlay, {Home}{Right 8}
return

:*?:/шантаж::
    SendMessage, 0x50,, 0x4190419,, A
    Sleep 100
    SendPlay, Кол-во дней: 
    Sleep 100
    Input, Days, V, {Enter}
    Days := Trim(Days)
    SendMessage, 0x50,, 0x4190419,, A
    Sleep 100
    SendPlay, banname  d %Days% Шантаж игрока by %SavedTag%
    SendPlay, {Home}{Right 8}
return

:*?:/Таран::
    SendMessage, 0x50,, 0x4190419,, A
    Sleep 100
    SendPlay, Кол-во дней: 
    Sleep 100
    Input, Days, V, {Enter}
    Days := Trim(Days)
    SendMessage, 0x50,, 0x4190419,, A
    Sleep 100
    SendPlay, banname  d %Days% Таран by %SavedTag%
    SendPlay, {Home}{Right 8}
return

:*?:/подрез::
    SendMessage, 0x50,, 0x4190419,, A
    Sleep 100
    SendPlay, Кол-во дней: 
    Sleep 100
    Input, Days, V, {Enter}
    Days := Trim(Days)
    SendMessage, 0x50,, 0x4190419,, A
    Sleep 100
    SendPlay, banname  d %Days% Созд. аварийных ситуаций by %SavedTag%
    SendPlay, {Home}{Right 8}
return

:*?:/погоняепт::
    SendMessage, 0x50,, 0x4190419,, A
    Sleep 100
    SendPlay, Кол-во дней: 
    Sleep 100
    Input, Days, V, {Enter}
    Days := Trim(Days)
    SendMessage, 0x50,, 0x4190419,, A
    Sleep 100
    SendPlay, banname  d %Days% Езда по газонам/тротуарам при погоне by %SavedTag%
    SendPlay, {Home}{Right 8}
return

:*?:/погоняепп::
    SendMessage, 0x50,, 0x4190419,, A
    Sleep 100
    SendPlay, Кол-во дней: 
    Sleep 100
    Input, Days, V, {Enter}
    Days := Trim(Days)
    SendMessage, 0x50,, 0x4190419,, A
    Sleep 100
    SendPlay, banname  d %Days% ЕПП при погоне by %SavedTag%
    SendPlay, {Home}{Right 8}
return

:*?:/ртлц::
SendMessage, 0x50,, 0x4190419,, A
Sleep 100
SendPlay banname  d 1 Рабочий транспорт в ЛЦ by %SavedTag%
Sleep 100
SendPlay, {Home}{Right 8}
return

:*?:/нонрп::
    SendMessage, 0x50,, 0x4190419,, A
    Sleep 100
    SendPlay, Nick_Name: 
    Sleep 100
    SendPlay, {Home}{Right 99}
    Input, Name, V, {Enter}
    ID := Trim(ID)

    SendMessage, 0x50,, 0x4190419,, A
    Sleep 100
    SendPlay, Кол-во дней: 
    Sleep 100
    SendPlay, {Home}{Right 99}
    Input, Days, V, {Enter}
    UserInput := Trim(UserInput)

    SendMessage, 0x50,, 0x4190419,, A
    Sleep 100
    SendPlay, banname %Name% d %Days% NonRP by %SavedTag%
return

:*?:/нонрп::
    SendMessage, 0x50,, 0x4190419,, A
    Sleep 100
    SendPlay, Кол-во дней: 
    Sleep 100
    Input, Days, V, {Enter}
    Days := Trim(Days)
    SendMessage, 0x50,, 0x4190419,, A
    Sleep 100
    SendPlay, banname  d %Days% NonRP by %SavedTag%
    SendPlay, {Home}{Right 8}
return

:*?:/вилка::
SendMessage, 0x50,, 0x4190419,, A
Sleep 100
SendPlay banname  d 1 Вилка в клаве by %SavedTag%
Sleep 100
SendPlay, {Home}{Right 8}
return

:*?:/дмкар::
    SendMessage, 0x50,, 0x4190419,, A
    Sleep 100
    SendPlay, Кол-во дней: 
    Sleep 100
    Input, Days, V, {Enter}
    Days := Trim(Days)
    SendMessage, 0x50,, 0x4190419,, A
    Sleep 100
    SendPlay, banname  d %Days% DM car by %SavedTag%
    SendPlay, {Home}{Right 8}
return

:*?:/дмкпз::
    SendMessage, 0x50,, 0x4190419,, A
    Sleep 100
    SendPlay, Кол-во дней: 
    Sleep 100
    Input, Days, V, {Enter}
    Days := Trim(Days)
    SendMessage, 0x50,, 0x4190419,, A
    Sleep 100
    SendPlay, banname  d %Days% DM через клетку КПЗ by %SavedTag%
    SendPlay, {Home}{Right 8}
return

:*?:/дмкил::
    SendMessage, 0x50,, 0x4190419,, A
    Sleep 100
    SendPlay, Кол-во дней: 
    Sleep 100
    Input, Days, V, {Enter}
    Days := Trim(Days)
    SendMessage, 0x50,, 0x4190419,, A
    Sleep 100
    SendPlay, banname  d %Days% DM kill by %SavedTag%
    SendPlay, {Home}{Right 8}
return

:*?:/погонявело::
    SendMessage, 0x50,, 0x4190419,, A
    Sleep 100
    SendPlay, Кол-во дней: 
    Sleep 100
    Input, Days, V, {Enter}
    Days := Trim(Days)
    SendMessage, 0x50,, 0x4190419,, A
    Sleep 100
    SendPlay, banname  d %Days% Использование велосипеда при погоне by %SavedTag%
    SendPlay, {Home}{Right 8}
return

:*?:/епп::
    SendMessage, 0x50,, 0x4190419,, A
    Sleep 100
    SendPlay, ID: 
    Sleep 100
    SendPlay, {Home}{Right 99}
    Input, ID, V, {Enter}
    ID := Trim(ID)

    SendMessage, 0x50,, 0x4190419,, A
    Sleep 100
    SendPlay, ajail %ID% 30 ЕПП by %SavedTag%
return

:*?:/епт::
    SendMessage, 0x50,, 0x4190419,, A
    Sleep 100
    SendPlay, ID: 
    Sleep 100
    SendPlay, {Home}{Right 99}
    Input, ID, V, {Enter}
    ID := Trim(ID)

    SendMessage, 0x50,, 0x4190419,, A
    Sleep 100
    SendPlay, ajail %ID% 30 Езда по газонам/тротуарам by %SavedTag%
return

:*?:/епр::
    SendMessage, 0x50,, 0x4190419,, A
    Sleep 100
    SendPlay, ID: 
    Sleep 100
    SendPlay, {Home}{Right 99}
    Input, ID, V, {Enter}
    ID := Trim(ID)

    SendMessage, 0x50,, 0x4190419,, A
    Sleep 100
    SendPlay, ajail %ID% 15 Движение по рельсам by %SavedTag%
return

:*?:/красные::
    SendMessage, 0x50,, 0x4190419,, A
    Sleep 100
    SendPlay, ID: 
    Sleep 100
    SendPlay, {Home}{Right 99}
    Input, ID, V, {Enter}
    ID := Trim(ID)

    SendMessage, 0x50,, 0x4190419,, A
    Sleep 100
    SendPlay, ajail %ID% 30 Проезд на красный светофор х2 by %SavedTag%
return

:*?:/встречка::
    SendMessage, 0x50,, 0x4190419,, A
    Sleep 100
    SendPlay, ID: 
    Sleep 100
    SendPlay, {Home}{Right 99}
    Input, ID, V, {Enter}
    ID := Trim(ID)

    SendMessage, 0x50,, 0x4190419,, A
    Sleep 100
    SendPlay, ajail %ID% 30 Движение по встречной полосе by %SavedTag%
return

:*?:/музыка::
    SendMessage, 0x50,, 0x4190419,, A
    Sleep 100
    SendPlay, ID: 
    Sleep 100
    SendPlay, {Home}{Right 99}
    Input, ID, V, {Enter}
    ID := Trim(ID)

    SendMessage, 0x50,, 0x4190419,, A
    Sleep 100
    SendPlay, Кол-во часов: 
    Sleep 100
    SendPlay, {Home}{Right 99}
    Input, Time, V, {Enter}
    Time := Trim(Time)

    SendMessage, 0x50,, 0x4190419,, A
    Sleep 100
    SendPlay, muted %ID% h %Time% Музыка в войс by %SavedTag%
return

:*?:/оффтоп::
    SendMessage, 0x50,, 0x4190419,, A
    Sleep 100
    SendPlay, ID: 
    Sleep 100
    SendPlay, {Home}{Right 99}
    Input, ID, V, {Enter}
    ID := Trim(ID)

    SendMessage, 0x50,, 0x4190419,, A
    Sleep 100
    SendPlay, Кол-во часов: 
    Sleep 100
    SendPlay, {Home}{Right 99}
    Input, Time, V, {Enter}
    Time := Trim(Time)

    SendMessage, 0x50,, 0x4190419,, A
    Sleep 100
    SendPlay, muted %ID% h %Time% Offtop in report by %SavedTag%
return

:*?:/мг::
    SendMessage, 0x50,, 0x4190419,, A
    Sleep 100
    SendPlay, ID: 
    Sleep 100
    SendPlay, {Home}{Right 99}
    Input, ID, V, {Enter}
    ID := Trim(ID)

    SendMessage, 0x50,, 0x4190419,, A
    Sleep 100
    SendPlay, Кол-во часов: 
    Sleep 100
    SendPlay, {Home}{Right 99}
    Input, Time, V, {Enter}
    Time := Trim(Time)

    SendMessage, 0x50,, 0x4190419,, A
    Sleep 100
    SendPlay, muted %ID% h %Time% MG by %SavedTag%
return

:*?:/капс::
    SendMessage, 0x50,, 0x4190419,, A
    Sleep 100
    SendPlay, ID: 
    Sleep 100
    SendPlay, {Home}{Right 99}
    Input, ID, V, {Enter}
    ID := Trim(ID)

    SendMessage, 0x50,, 0x4190419,, A
    Sleep 100
    SendPlay, Кол-во часов: 
    Sleep 100
    SendPlay, {Home}{Right 99}
    Input, Time, V, {Enter}
    Time := Trim(Time)

    SendMessage, 0x50,, 0x4190419,, A
    Sleep 100
    SendPlay, muted %ID% h %Time% Caps Lock by %SavedTag%
return

:*?:/флуд::
    SendMessage, 0x50,, 0x4190419,, A
    Sleep 100
    SendPlay, ID: 
    Sleep 100
    SendPlay, {Home}{Right 99}
    Input, ID, V, {Enter}
    ID := Trim(ID)

    SendMessage, 0x50,, 0x4190419,, A
    Sleep 100
    SendPlay, Кол-во часов: 
    Sleep 100
    SendPlay, {Home}{Right 99}
    Input, Time, V, {Enter}
    Time := Trim(Time)

    SendMessage, 0x50,, 0x4190419,, A
    Sleep 100
    SendPlay, muted %ID% h %Time% Flood by %SavedTag%
return

:*?:/мат::
    SendMessage, 0x50,, 0x4190419,, A
    Sleep 100
    SendPlay, ID: 
    Sleep 100
    SendPlay, {Home}{Right 99}
    Input, ID, V, {Enter}
    ID := Trim(ID)

    SendMessage, 0x50,, 0x4190419,, A
    Sleep 100
    SendPlay, Кол-во часов: 
    Sleep 100
    SendPlay, {Home}{Right 99}
    Input, Time, V, {Enter}
    Time := Trim(Time)

    SendMessage, 0x50,, 0x4190419,, A
    Sleep 100
    SendPlay, muted %ID% h %Time% Употребление нецензурных слов by %SavedTag%
return

:*?:/оскигрок::
    SendMessage, 0x50,, 0x4190419,, A
    Sleep 100
    SendPlay, ID: 
    Sleep 100
    SendPlay, {Home}{Right 99}
    Input, ID, V, {Enter}
    ID := Trim(ID)

    SendMessage, 0x50,, 0x4190419,, A
    Sleep 100
    SendPlay, Кол-во часов: 
    Sleep 100
    SendPlay, {Home}{Right 99}
    Input, Time, V, {Enter}
    Time := Trim(Time)

    SendMessage, 0x50,, 0x4190419,, A
    Sleep 100
    SendPlay, muted %ID% h %Time% Оск. игрока by %SavedTag%
return

:*?:/неувоб::
    SendMessage, 0x50,, 0x4190419,, A
    Sleep 100
    SendPlay, ID: 
    Sleep 100
    SendPlay, {Home}{Right 99}
    Input, ID, V, {Enter}
    ID := Trim(ID)

    SendMessage, 0x50,, 0x4190419,, A
    Sleep 100
    SendPlay, Кол-во часов: 
    Sleep 100
    SendPlay, {Home}{Right 99}
    Input, Time, V, {Enter}
    Time := Trim(Time)

    SendMessage, 0x50,, 0x4190419,, A
    Sleep 100
    SendPlay, muted %ID% h %Time% Неув. обращение в репорт by %SavedTag%
return

:*?:/помеха::
    SendMessage, 0x50,, 0x4190419,, A
    Sleep 100
    SendPlay, ID: 
    Sleep 100
    SendPlay, {Home}{Right 99}
    Input, ID, V, {Enter}
    ID := Trim(ID)

    SendMessage, 0x50,, 0x4190419,, A
    Sleep 100
    SendPlay, kicked %ID% AFK (помеха) by %SavedTag%
return

:*?:/безсвета::
    SendMessage, 0x50,, 0x4190419,, A
    Sleep 100
    SendPlay, ID: 
    Sleep 100
    SendPlay, {Home}{Right 99}
    Input, ID, V, {Enter}
    ID := Trim(ID)

    SendMessage, 0x50,, 0x4190419,, A
    Sleep 100
    SendPlay, kicked %ID% Движение с выкл. фарами/светом в салоне by %SavedTag%
return

:*?:/пантограф::
    SendMessage, 0x50,, 0x4190419,, A
    Sleep 100
    SendPlay, ID: 
    Sleep 100
    SendPlay, {Home}{Right 99}
    Input, ID, V, {Enter}
    ID := Trim(ID)

    SendMessage, 0x50,, 0x4190419,, A
    Sleep 100
    SendPlay, tramoff %ID% Торможение с помощью пантографа by %SavedTag%
return

:*?:/фармзп::
    SendMessage, 0x50,, 0x4190419,, A
    Sleep 100
    SendPlay, ID: 
    Sleep 100
    SendPlay, {Home}{Right 99}
    Input, ID, V, {Enter}
    ID := Trim(ID)

    SendMessage, 0x50,, 0x4190419,, A
    Sleep 100
    SendPlay, Фракция: 
    Sleep 100
    SendPlay, {Home}{Right 99}
    Input, UserInput, V, {Enter}
    UserInput := Trim(UserInput)

    SendMessage, 0x50,, 0x4190419,, A
    Sleep 100
    SendPlay, kicked %ID% Фарм ЗП (%UserInput%) by %SavedTag%
return

; ------------------------------- БИНД КЛАВИШ NUMPAD (ОСНОВНОЕ)-------------------------------

:*?:/скидка::
    Random, rand, 1, 5
    if (rand = 1) {
        command := "Промокод даст скидку на покупку квартиры или авто"
    } else if (rand = 2) {
        command := "Промокод дает скидку на покупку авто или квартиру"
    } else if (rand = 3) {
        command := "Промокод снижает стоимость при покупке авто или квартиры"
    } else if (rand = 4) {
        command := "Промокод даёт выгоду при покупке квартиры или авто"
    } else if (rand = 5) {
        command := "Промокод даст меньшую стоимость при покупке авто или квартиры"
    }
    SendMessage, 0x50,, 0x4190419,, A
    Sleep 100
    SendPlay %command%
return

:*?:/права::
    Random, rand, 1, 5
    if (rand = 1) {
        command := "изучите стоимость прав в автошколе"
    } else if (rand = 2) {
        command := "изучите стоимось в автошколе"
    } else if (rand = 3) {
        command := "Изучите стоимость прав в автошколе"
    } else if (rand = 4) {
        command := "Изучите стоимость в автошколе"
    } else if (rand = 5) {
        command := "Стоимость ВУ можно посмотреть в автошколе"
    }
    SendMessage, 0x50,, 0x4190419,, A
    Sleep 100
    SendPlay %command%
return

:*?:/проверкаафк::
    Random, rand, 1, 3
    if (rand = 1) {
        command := "Вы тут? Ответ в /report - Да"
    } else if (rand = 2) {
        command := "Вы тут?"
    } else if (rand = 3) {
        command := "Проверка. Вы тут?"
    }
    SendMessage, 0x50,, 0x4190419,, A
    Sleep 100
    SendPlay %command%
return

:*?:/дистанция::
    Random, rand, 1, 5
    if (rand = 1) {
        command := "Соблюдайте дистанцию"
    } else if (rand = 2) {
        command := "соблюдайте дистанцию{!}"
    } else if (rand = 3) {
        command := "Соблюдайте дистанцию"
    } else if (rand = 4) {
        command := "соблюдайте дистанцию"
    } else if (rand = 5) {
        command := "Соблюдайте дистанцию{!}"
    }
    SendMessage, 0x50,, 0x4190419,, A
    Sleep 100
    SendPlay %command%
return

:*?:/свет::
    Random, rand, 1, 8
    if (rand = 1) {
        command := "Включите свет в салоне и фары (клавиши K и L)"
    } else if (rand = 2) {
        command := "Включите свет в салоне и фары (клавиши L и K)"
    } else if (rand = 3) {
        command := "Включите свет в салоне и фары (L и K)"
    } else if (rand = 4) {
        command := "Включите свет в салоне и фары (K и L)"
    } else if (rand = 5) {
        command := "включите свет в салоне и фары (клавиши K и L)"
    } else if (rand = 6) {
        command := "включите свет в салоне и фары (клавиши L и K)"
    } else if (rand = 7) {
        command := "включите свет в салоне и фары (L и K)"
    } else if (rand = 8) {
        command := "включите свет в салоне и фары (K и L)"
    }
    SendMessage, 0x50,, 0x4190419,, A
    Sleep 100
    SendPlay %command%
return

:*?:/номер::
    Random, rand, 1, 8
    if (rand = 1) {
        command := "Номера можно получить в полицейском участке"
    } else if (rand = 2) {
        command := "Номера можно получить в автошколе"
    } else if (rand = 3) {
        command := "Номера можно получить в полицейском участке или в автошколе"
    } else if (rand = 4) {
        command := "номера можно получить в автошколе или полицейском участке"
    } else if (rand = 5) {
        command := "номера можно получить в полицейском участке"
    } else if (rand = 6) {
        command := "номера можно получить в автошколе"
    } else if (rand = 7) {
        command := "номера можно получить в полицейском участке или в автошколе"
    } else if (rand = 8) {
        command := "Номера можно получить в автошколе или полицейском участке"
    }
    SendMessage, 0x50,, 0x4190419,, A
    Sleep 100
    SendPlay %command%
return

:*?:/f21::
SendMessage, 0x50,, 0x4190419,, A
Sleep 100
SendPlay bind f2 down Toggle scoreboard 1 bind f2 up Toggle scoreboard 0
return

:*?:/собес::
SendMessage, 0x50,, 0x4190419,, A
Sleep 100
SendPlay Все собеседования можно посмотреть в телефоне
return

:*?:/нум::
SendMessage, 0x50,, 0x4190419,, A
Sleep 100
SendPlay Бинды NumPad: num_0;num_1;num_2 ... num_9; num_mul - умножение; num_div - деление; num_add - сложение; num_enter - клавиша Enter; num_dec - запятая
return

:*?:/jai::
SendMessage, 0x50,, 0x4190419,, A
Sleep 100
SendPlay /jailtime
return

:*?:/номер::
    Random, rand, 1, 8
    if (rand = 1) {
        command := "F3 - Эвакуировать авто"
    } else if (rand = 2) {
        command := "F3 - эвакуировать авто"
    } else if (rand = 3) {
        command := "F3 - Эвакуировать"
    } else if (rand = 4) {
        command := "F3 - эвакуировать"
    } else if (rand = 5) {
        command := "F3 - эвакуировать"
    } else if (rand = 6) {
        command := "F3 - эвакуировать авто"
    } else if (rand = 7) {
        command := "F3 - Эвакуировать"
    } else if (rand = 8) {
        command := "F3 - Эвакуировать авто"
    }
    SendMessage, 0x50,, 0x4190419,, A
    Sleep 100
    SendPlay %command%
return

:*?:/донат::
    Random, rand, 1, 10
    if (rand = 1) {
        command := "Задонатить можно через сайт проекта"
    } else if (rand = 2) {
        command := "Задонатить можно через офф сайт проекта"
    } else if (rand = 3) {
        command := "Задонатить можно через сайт"
    } else if (rand = 4) {
        command := "пополнение через сайт проекта"
    } else if (rand = 5) {
        command := "донатите через официальный сайт проекта"
    } else if (rand = 6) {
        command := "задонатить можно через сайт"
    } else if (rand = 7) {
        command := "Оплатить донат можно через сайт проекта"
    } else if (rand = 8) {
        command := "задонатить можно только через сайт проекта"
    } else if (rand = 9) {
        command := "оплатить донат можно через сайт проекта"
    } else if (rand = 10) {
        command := "Задонатить можно через сайт"
    }
    SendMessage, 0x50,, 0x4190419,, A
    Sleep 100
    SendPlay %command%
return

:*?:/баг::
    Random, rand, 1, 15
    if (rand = 1) {
        command := "Сообщите про баг в дискорд сервере проекта"
    } else if (rand = 2) {
        command := "сообщите про баг в дискорд сервере проекта"
    } else if (rand = 3) {
        command := "Если обнаружили баг, обратитесь в дискорд проекта"
    } else if (rand = 4) {
        command := "если обнаружили баг, обратитесь в дискорд проекта"
    } else if (rand = 5) {
        command := "При обнаружении бага обратитесь в дискорд сервер проекта"
    } else if (rand = 6) {
        command := "при обнаружении бага обратитесь в дискорд сервер проекта"
    } else if (rand = 7) {
        command := "Сообщить о баге можно в дискорд сервер проекта"
    } else if (rand = 8) {
        command := "сообщить о баге можно в дискорд сервер проекта"
    } else if (rand = 9) {
        command := "Сообщите про баг в дискорд-сервере проекта"
    } else if (rand = 10) {
        command := "если обнаружили баг, обратитесь в дискорд проекта"
    } else if (rand = 11) {
        command := "При обнаружении бага обратитесь в дискорд сервер проекта"
    } else if (rand = 12) {
        command := "сообщить о баге можно в дискорд сервер проекта"
    } else if (rand = 13) {
        command := "Если обнаружили баг, обратитесь в дискорд проекта"
    } else if (rand = 14) {
        command := "Сообщить о баге можно в дискорд сервер проекта"
    } else if (rand = 15) {
        command := "при обнаружении бага обратитесь в дискорд сервер проекта"
    }
    SendMessage, 0x50,, 0x4190419,, A
    Sleep 100
    SendPlay %command%
return

:*?:/берег::
SendMessage, 0x50,, 0x4190419,, A
Sleep 100
SendPlay Ищите берег самостоятельно
return

:*?:/поезд::
SendMessage, 0x50,, 0x4190419,, A
Sleep 100
SendPlay Расписание поездов можно посмотреть на форуме
return

:*?:/атп::
SendMessage, 0x50,, 0x4190419,, A
Sleep 100
SendPlay /gps - Город - Работа - АТП
return

:*?:/сто::
SendMessage, 0x50,, 0x4190419,, A
Sleep 100
SendPlay /gps - Город - Работа - Автомастерская
return

:*?:/аэропорт::
SendMessage, 0x50,, 0x4190419,, A
Sleep 100
SendPlay /gps - Приволжск - Работа - Аэропорт
return

:*?:/дорожная служба::
SendMessage, 0x50,, 0x4190419,, A
Sleep 100
SendPlay /gps - Город - Работа - Дорожная служба
return

:*?:/жбк::
    Random, rand, 1, 4
    if (rand = 1) {
        command := "/gps - Приволжск - Работа"
    } else if (rand = 2) {
        command := "/gps - приволжск - работа"
    } else if (rand = 3) {
        command := "/gps - приволжск - работа - завод ЖБК"
    } else if (rand = 4) {
        command := "/gps - Приволжск"
    }
    SendMessage, 0x50,, 0x4190419,, A
    Sleep 100
    SendPlay %command%
return

:*?:/лесопилка::
    Random, rand, 1, 4
    if (rand = 1) {
        command := "/gps - Приволжск - Работа"
    } else if (rand = 2) {
        command := "/gps - Приволжск - работа"
    } else if (rand = 3) {
        command := "/gps - Работа - Лесопилка"
    } else if (rand = 4) {
        command := "/gps - работа"
    }
    SendMessage, 0x50,, 0x4190419,, A
    Sleep 100
    SendPlay %command%
return

:*?:/пицца::
SendMessage, 0x50,, 0x4190419,, A
Sleep 100
SendPlay /gps - Приволжск - Работа - Пиццерия
return

:*?:/трамвай::
SendMessage, 0x50,, 0x4190419,, A
Sleep 100
SendPlay /gps - Город - Работа - Трамвайное депо
return

:*?:/стройка::
    Random, rand, 1, 4
    if (rand = 1) {
        command := "/gps - работа - стройплощадка"
    } else if (rand = 2) {
        command := "/gps - Работа - Стройплощадка"
    } else if (rand = 3) {
        command := "/gps - Работа"
    } else if (rand = 4) {
        command := "/gps - работа"
    }
    SendMessage, 0x50,, 0x4190419,, A
    Sleep 100
    SendPlay %command%
return

:*?:/такси::
SendMessage, 0x50,, 0x4190419,, A
Sleep 100
SendPlay /gps - Город - Работа - Таксопарк
return

:*?:/шахта::
    Random, rand, 1, 4
    if (rand = 1) {
        command := "/gps - мирный - работа"
    } else if (rand = 2) {
        command := "/gps - Мирный - Работа"
    } else if (rand = 3) {
        command := "/gps - Работа - Шахта"
    } else if (rand = 4) {
        command := "/gps"
    }
    SendMessage, 0x50,, 0x4190419,, A
    Sleep 100
    SendPlay %command%
return

:*?:/вту::
SendMessage, 0x50,, 0x4190419,, A
Sleep 100
SendPlay /gps - Невский - Работа - ВТУ
return

:*?:/октябрь::
SendMessage, 0x50,, 0x4190419,, A
Sleep 100
SendPlay /gps - Невский - Работа - Завод "Красный Октябрь"
return

:*?:/табачка::
SendMessage, 0x50,, 0x4190419,, A
Sleep 100
SendPlay /gps - Невский - Работа - Табачный завод
return

:*?:/офис::
    Random, rand, 1, 4
    if (rand = 1) {
        command := "/gps - Город - Интересные места"
    } else if (rand = 2) {
        command := "/gps - интересные места - офисный цент"
    } else if (rand = 3) {
        command := "/gps - Интересные места - Офисный цент"
    } else if (rand = 4) {
        command := "/gps"
    }
    SendMessage, 0x50,, 0x4190419,, A
    Sleep 100
    SendPlay %command%
return

:*?:/гтрек::
SendMessage, 0x50,, 0x4190419,, A
Sleep 100
SendPlay /gps - Приволжск - Авто - Гоночный трек
return

:*?:/ттрек::
SendMessage, 0x50,, 0x4190419,, A
Sleep 100
SendPlay /gps - Приволжск - Авто - Тестовый автотрек
return

:*?:/лента::
SendMessage, 0x50,, 0x4190419,, A
Sleep 100
SendPlay /gps - Приволжск - Интересные места
return

:*?:/вивалэнд::
SendMessage, 0x50,, 0x4190419,, A
Sleep 100
SendPlay /gps - Приволжск - Услуги
return

:*?:/цветы::
SendMessage, 0x50,, 0x4190419,, A
Sleep 100
SendPlay /gps - Приволжск - Услуги
return

:*?:/аренда::
SendMessage, 0x50,, 0x4190419,, A
Sleep 100
SendPlay /gps - Город - Услуги
return

:*?:/бар::
SendMessage, 0x50,, 0x4190419,, A
Sleep 100
SendPlay /gps - Приволжск/Мирный - Услуги
return

:*?:/пк::
SendMessage, 0x50,, 0x4190419,, A
Sleep 100
SendPlay /gps - Город - Ближайшие места
return

:*?:/спортзал::
SendMessage, 0x50,, 0x4190419,, A
Sleep 100
SendPlay /gps - Мирный - Услуги
return

:*?:/парашют::
SendMessage, 0x50,, 0x4190419,, A
Sleep 100
SendPlay /gps - Мирный/Невский - Услуги
return

:*?:/тир::
SendMessage, 0x50,, 0x4190419,, A
Sleep 100
SendPlay /gps - Невский - Услуги - Тир
return

:*?:/чат::
SendMessage, 0x50,, 0x4190419,, A
Sleep 100
SendPlay bind t chatbox chatboxsay
return

:*?:/телефон::
SendMessage, 0x50,, 0x4190419,, A
Sleep 100
SendPlay bind u phone
return

:*?:/карпанель::
SendMessage, 0x50,, 0x4190419,, A
Sleep 100
SendPlay bind f3 car_panel}
return

:*?:/двигатель::
SendMessage, 0x50,, 0x4190419,, A
Sleep 100
SendPlay bind z engine
return

:*?:/скрин::
SendMessage, 0x50,, 0x4190419,, A
Sleep 100
SendPlay bind f12 screenshot
return

:*?:/карта::
SendMessage, 0x50,, 0x4190419,, A
Sleep 100
SendPlay bind f11 radar
return
