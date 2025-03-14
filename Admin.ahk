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
currentVersion := "1.3.5"
githubVersionURL := "https://raw.githubusercontent.com/StichneAllen/AdminHelper/refs/heads/main/version.txt"
githubScriptURL := "https://raw.githubusercontent.com/StichneAllen/AdminHelper/refs/heads/main/Admin.ahk"
githubChangelogURL := "https://raw.githubusercontent.com/StichneAllen/AdminHelper/refs/heads/main/changelog.txt"
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
Gui 1:Add, Tab2, x9 y10 h40 w450 Buttons -Wrap c9FFC69, Основное|GPS|Телепорты [3+]|Другое
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
Gui, Add, Text, x2 x20 y210 w300 h15 , ALT+Num0 - Проверка на бота пройдена
Gui, Add, Text, x2 x20 y225 w300 h15 , CTRL+Num0 - Проверка на бота

; ------------------------------- Админ команды БАНЫ (ОСНОВНОЕ)-------------------------------

Gui 1:Font, s11 cWhite Bold, Arial
Gui 1:Add, GroupBox, x370 y40 w420 h540 c9FFC69, [ banname (3 lvl) ]
Gui 1:Font, s11 cWhite Bold, Arial
Gui, Add, Text, x2 x380 y60 w400 h15 c9FFC69, Все блокировки по нику.
Gui, Add, Text, x2 x380 y75 w400 h20 c9FFC69, Данные команды исключительно в F8 ! ! !
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

Gui 1:Tab, 4
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
Gui, Add, Text, x2 x20 y270 w250 h15 , /стрелки - Стрелочки (клавиши)
Gui, Add, Text, x2 x20 y285 w250 h15 , /f21 - Панель игроков F2
Gui, Add, Text, x2 x20 y300 w280 h15 , [Писать в F8] /нум - Все клавиши NumPad

; ------------------------------- Другое (БИНДЫ/ДРУГОЕ)-------------------------------

Gui 1:Font, s11 cWhite Bold, Arial
Gui 1:Tab, 4
Gui 1:Add, GroupBox, x320 y40 w350 h325 c9FFC69, [ command ]
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
Gui, Add, Text, x330 y300 w320 h15 , -
Gui, Add, Text, x330 y315 w320 h15 , -
Gui, Add, Text, x330 y330 w320 h15 , -
Gui, Add, Text, x330 y345 w320 h15 , -
Gui, Font, S8 c747474, Regular, Arial,
Gui, Add, Text, x545 y582 w300 h30 , Создатели: Stich_Allen and German_McKenzy

; ------------------------------- Телепорты (БИНДЫ/ДРУГОЕ)-------------------------------
Gui 1:Font, s11 cWhite Bold, Arial
Gui 1:Tab, 3
Gui 1:Add, GroupBox, x410 y40 w380 h450 c9FFC69, [ tp (3 lvl) (ОКОННЫЙ РЕЖИМ!!!)]
Gui 1:Font, s8 cWhite Bold, Arial
Gui, Add, Text, x2 x420 y60 w250 h15 c9FFC69, /тпофис<п/м/н>1
Gui, Add, Text, x2 x513 y60 w250 h15 , - Телепорт в офис Привы
Gui, Add, Text, x2 x420 y75 w250 h15 c9FFC69, /тпбу1
Gui, Add, Text, x2 x457 y75 w250 h15 , - Телепорт на БУ
Gui, Add, Text, x2 x420 y90 w250 h15 c9FFC69, /тпбанк<п/м/н>1
Gui, Add, Text, x2 x510 y90 w250 h15, - Телепорт в банк Прива/Мирка/Нева
Gui, Add, Text, x2 x420 y105 w250 h15 c9FFC69, /тпбольница<п/м/н>1
Gui, Add, Text, x2 x538 y105 w240 h15 , - Телепорт в больницу Прива/Мирка/Нева
Gui, Add, Text, x2 x420 y120 w250 h15 c9FFC69, /тпгувд<п/м/н>1
Gui, Add, Text, x2 x508 y120 w240 h15 , - Телепорт в ГУВД П/М/Н
Gui, Add, Text, x2 x420 y135 w250 h15 ,
Gui, Add, Text, x2 x420 y150 w250 h15 ,
Gui, Add, Text, x2 x420 y165 w250 h15 ,
Gui, Add, Text, x2 x420 y180 w250 h15 ,
Gui, Add, Text, x2 x420 y195 w250 h15 ,
Gui, Add, Text, x2 x420 y210 w250 h15 ,
Gui, Add, Text, x2 x420 y225 w250 h15 ,
Gui, Add, Text, x2 x420 y240 w250 h15 ,
Gui, Add, Text, x2 x420 y255 w250 h15 ,
Gui, Add, Text, x2 x420 y270 w250 h15 ,
Gui, Add, Text, x2 x420 y285 w250 h15 ,
Gui, Add, Text, x2 x420 y300 w280 h15 ,

Gui 1:Font, s11 cWhite Bold, Arial
Gui 1:Tab, 3
Gui 1:Add, GroupBox, x10 y40 w390 h450 c9FFC69, [ tp (3 lvl) (ОКНО БЕЗ РАМКИ/СТАНДАРТ!!!)]
Gui 1:Font, s8 cWhite Bold, Arial
Gui, Add, Text, x2 x20 y60 w250 h15 c9FFC69, /тпофис<п/м/н>
Gui, Add, Text, x2 x108 y60 w250 h15 , - Телепорт в офис Привы
Gui, Add, Text, x2 x20 y75 w250 h15 c9FFC69, /тпбу
Gui, Add, Text, x2 x52 y75 w250 h15 , - Телепорт на БУ
Gui, Add, Text, x2 x20 y90 w250 h15 c9FFC69, /тпбанк<п/м/н>
Gui, Add, Text, x2 x105 y90 w250 h15, - Телепорт в банк Прива/Мирка/Нева
Gui, Add, Text, x2 x20 y105 w250 h15 c9FFC69, /тпбольница<п/м/н>
Gui, Add, Text, x2 x133 y105 w240 h15 , - Телепорт в больницу Прива/Мирка/Нева
Gui, Add, Text, x2 x20 y120 w250 h15 c9FFC69, /тпгувд<п/м/н>
Gui, Add, Text, x2 x103 y120 w240 h15 , - Телепорт в ГУВД П/М/Н
Gui, Add, Text, x2 x20 y135 w250 h15 ,
Gui, Add, Text, x2 x20 y150 w250 h15 ,
Gui, Add, Text, x2 x20 y165 w250 h15 ,
Gui, Add, Text, x2 x20 y180 w250 h15 ,
Gui, Add, Text, x2 x20 y195 w250 h15 ,
Gui, Add, Text, x2 x20 y210 w250 h15 ,
Gui, Add, Text, x2 x20 y225 w250 h15 ,
Gui, Add, Text, x2 x20 y240 w250 h15 ,
Gui, Add, Text, x2 x20 y255 w250 h15 ,
Gui, Add, Text, x2 x20 y270 w250 h15 ,
Gui, Add, Text, x2 x20 y285 w250 h15 ,
Gui, Add, Text, x2 x20 y300 w280 h15 ,

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
;GuiClose:
;ExitApp

------------------------------------АДМИН ТЭГ------------------------------------

numpad0::
SendMessage, 0x50,, 0x4190419,, A
SendPlay, {space}[Проверка на бота] Как меня зовут? {enter}
return

!numpad0::
SendMessage, 0x50,, 0x4190419,, A
SendPlay, {space}[Проверка на бота] Какой у вас уровень? {enter}
return

^numpad0::
SendMessage, 0x50,, 0x4190419,, A
SendPlay, {space}Проверка на отсутствие софта пройдена. Приятной игры{!} {enter}
return

!numpad1::
SendMessage, 0x50,, 0x4190419,, A
SendPlay, {space}Приятной игры{!} {enter}
return

!numpad2::
SendMessage, 0x50,, 0x4190419,, A
SendPlay {space}Слежу. {enter}
return

!numpad3::
SendMessage, 0x50,, 0x4190419,, A
SendPlay, {space}На момент слежки нарушений не заметил. {enter}
return

!numpad4::
SendMessage, 0x50,, 0x4190419,, A
SendPlay, {space}Игрок наказан. Рады помочь{!} {enter}
return

!numpad6::
SendMessage, 0x50,, 0x4190419,, A
SendPlay, {space}Обратитесь в тех. поддержку - vk.com/provincehelp {enter}
return

!numpad5::
SendMessage, 0x50,, 0x4190419,, A
SendPlay, {space}Изучите данную информацию тут - https://info.gtaprovince.ru {enter}
return

!numpad7::
SendMessage, 0x50,, 0x4190419,, A
SendPlay {space}Оставьте жалобу на форум - https://vk.cc/cyNCUI {enter}
return

^numpad7::
SendMessage, 0x50,, 0x4190419,, A
SendPlay {space}Не согласны с выданным наказанием? Обжалуйте его на форуме - https://vk.cc/cyNCSD {enter}
return

!numpad8::
SendMessage, 0x50,, 0x4190419,, A
SendPlay {space}Уважаемый игрок{!} Соблюдайте ПДД. {enter}
return

!numpad9::
SendMessage, 0x50,, 0x4190419,, A
SendPlay, {T}
Sleep 500
SendPlay, /a ВНИМАНИЕ{!} Занимаю админ новости{!} {enter}
Sleep 5000
SendMessage, 0x50,, 0x4190419,, A
SendPlay, {T}
Sleep 500
SendPlay, /p Уважаемые игроки{!} {enter}
Sleep 29000
SendMessage, 0x50,, 0x4190419,, A
SendPlay, {T}
Sleep 500
SendPlay, /p Через 30 секунд будет респавн всех служебных и рабочих ТС. Просим занять свои авто. {enter}
SendMessage, 0x50,, 0x4190419,, A
SendPlay, {T}
Sleep 500
SendPlay, /rcarall {enter}
Sleep 500
SendMessage, 0x50,, 0x4190419,, A
SendPlay, {T}
Sleep 500
SendMessage, 0x50,, 0x4190419,, A
SendPlay, /p Респавн транспорта произошёл успешно. Приятной игры с администрацией второго сервера{!} {Enter}
return

:*?:/рекламамп1::
SendMessage, 0x50,, 0x4190419,, A
Sleep 500
SendPlay /a ВНИМАНИЕ{!} Занимаю админ новости{!} {enter}
Sleep 5000
SendPlay, {T}
SendMessage, 0x50,, 0x4190419,, A
Sleep 500
SendPlay /p Не знаешь, чем заняться на сервере и ищешь развлечения? {enter}
Sleep 500
SendMessage, 0x50,, 0x4190419,, A
SendPlay, {T}
Sleep 500
SendPlay /p Ежедневные рубрики и мероприятия с призами публикуются в нашей группе vk.com/2province_mp {enter}
return

:*?:/гувд::
SendMessage, 0x50,, 0x4190419,,
Sleep 300
SendPlay /p Хотите стоять на страже закона и участвовать в операциях по задержанию опасных преступников? {enter}
Sleep 100
SendMessage, 0x50,, 0x4190419,, A
SendPlay, {T}
Sleep 300
SendPlay /p Присоединяйтесь к одному из филиалов УВД Республики Провинция{!} {enter}
Sleep 100
SendMessage, 0x50,, 0x4190419,, A
SendPlay, {T}
Sleep 300
SendPlay /p Ежедневные патрули, задержание преступников, обучение и специальные мероприятия ждут вас. {enter}
Sleep 100
SendMessage, 0x50,, 0x4190419,, A
SendPlay, {T}
Sleep 300
SendPlay /p Оставить заявку на трудоустройство можно в любой из городов: https://vk.cc/ceSvIP {enter}
return

:*?:/хранилище::
SendMessage, 0x50,, 0x4190419,, A
Sleep 100
SendPlay /gps - Приволжск - Услуги - Склад временного хранения. {enter}
return

:*?:/банк::
SendMessage, 0x50,, 0x4190419,, A
Sleep 100
SendPlay /gps - Город - Гос.учереждения - Банк. {enter}
return

:*?:/тту::
SendMessage, 0x50,, 0x4190419,, A
Sleep 100
SendPlay /gps - Город - Работа - ТТУ. {enter}
return

:*?:/дальнобой::
SendMessage, 0x50,, 0x4190419,, A
Sleep 100
SendPlay /gps - Город - Работы - Транспортная компания. {enter}
return

:*?:/тюнинг::
SendMessage, 0x50,, 0x4190419,, A
Sleep 100
SendPlay /gps - Город - Авто - Тюнинг-ателье. {enter}
return

:*?:/автошкола::
SendMessage, 0x50,, 0x4190419,, A
Sleep 100
SendPlay /gps - Город - Гос.учреждения - Автошкола. {enter}
return

:*?:/больница::
SendMessage, 0x50,, 0x4190419,, A
Sleep 100
SendPlay /gps - Город - Гос.учреждения - Больница. {enter}
return

:*?:/военкомат::
SendMessage, 0x50,, 0x4190419,, A
Sleep 100
SendPlay /gps - Приволжск/Мирный - Гос.учреждения - Военкомат. {enter}
return

:*?:/вч::
SendMessage, 0x50,, 0x4190419,, A
Sleep 100
SendPlay /gps - Мирный - Гос.учреждения - Воинская часть. {enter}
return

:*?:/полиция::
SendMessage, 0x50,, 0x4190419,, A
Sleep 100
SendPlay /gps - Город - Гос.учреждения - Полицейский участок. {enter}
return

:*?:/отдых::
SendMessage, 0x50,, 0x4190419,, A
Sleep 100
SendPlay /gps - Город - ближайшие места - Магазин "Все для отдыха". {enter}
return

:*?:/автомагазин::
SendMessage, 0x50,, 0x4190419,, A
Sleep 100
SendPlay /gps - Город - ближайшие места - Автомагазин. {enter}
return

:*?:/скупщик::
SendMessage, 0x50,, 0x4190419,, A
Sleep 100
SendPlay /gps - Город - ближайшие места - Скупщик рыбы и грибов. {enter}
return

:*?:/автосалон::
SendMessage, 0x50,, 0x4190419,, A
Sleep 100
SendPlay /gps - Город - Авто - Автосалон. {enter}
return

:*?:/автостоянка::
SendMessage, 0x50,, 0x4190419,, A
Sleep 100
SendPlay /gps - Город - Авто - Автостоянка. {enter}
return

:*?:/маэс::
SendMessage, 0x50,, 0x4190419,, A
Sleep 100
SendPlay /gps - Мирный - Интересные места - АЭС "МирнАтом". {enter}
return

:*?:/звезда::
SendMessage, 0x50,, 0x4190419,, A
Sleep 100
SendPlay 1 звезда = 10 минут в КПЗ. 1 звезда = 1 час прибывания на воле. {enter}
return

:*?:/стадион::
SendMessage, 0x50,, 0x4190419,, A
Sleep 100
SendPlay /gps - Мирный - Интересные места - Стадион "Арена Мирный". {enter}
return

:*?:/ржд::
SendMessage, 0x50,, 0x4190419,, A
Sleep 100
SendPlay /gps - Мирный - Гос.учреждения - Здание РЖД. {enter}
return

:*?:/летная школа::
SendMessage, 0x50,, 0x4190419,, A
Sleep 100
SendPlay /gps - Мирный - Гос.учреждения - Летная школа. {enter}
return

:*?:/водная школа::
SendMessage, 0x50,, 0x4190419,, A
Sleep 100
SendPlay /gps - Невский - Гос.учреждения - Водная школа. {enter}
return

:*?:/гостиница::
SendMessage, 0x50,, 0x4190419,, A
Sleep 100
SendPlay /gps - Город - Услуги - Гостиница. {enter}
return

:*?:/порт::
SendMessage, 0x50,, 0x4190419,, A
Sleep 100
SendPlay /gps - Невский - Интересные места - Морской порт Невского. {enter}
return

:*?:/войс::
SendMessage, 0x50,, 0x4190419,, A
Sleep 100
SendPlay Вкл(зажать): bind клавиша doWn voiceptt 1 | Выкл(отжать): bind клавиша up voiceptt 0 {enter}
return

:*?:/эвакуатор::
SendMessage, 0x50,, 0x4190419,, A
Sleep 100
SendPlay Управлять эвакуатором - /evacuate id | /repair id | /mehlist | Numpad 2,8 | Ins Del. {enter}
return

:*?:/крюк::
SendMessage, 0x50,, 0x4190419,, A
Sleep 100
SendPlay bind num_8 special_control_up - поднять крюк | bind num_2 special_control_doWn - опустить крюк. {enter}
return

:*?:/двери::
SendMessage, 0x50,, 0x4190419,, A
Sleep 100
SendPlay bind 2 open_doors - открытие дверей в общественном транспорте {enter}
return

:*?:/скорость::
SendMessage, 0x50,, 0x4190419,, A
Sleep 100
SendPlay bind f5 speed_limit 5-320 - включить/выключить лимит скорости на авто.{enter}
return

:*?:/шасси::
SendMessage, 0x50,, 0x4190419,, A
Sleep 100
SendPlay bind 2 sub_mission - управление шасси самолета (на учебном не работает) {enter}
return

:*?:/маячки::
SendMessage, 0x50,, 0x4190419,, A
Sleep 100
SendPlay bind j speclight_onoff - Маячки {enter}
return

:*?:/ремень::
SendMessage, 0x50,, 0x4190419,, A
Sleep 100
SendPlay bind b seatbelt - ремень безопасности {enter}
return

:*?:/стрелки::
SendMessage, 0x50,, 0x4190419,, A
Sleep 100
SendPlay, Стрелочки: arroW_l - влево | arroW_r - вправо | arroW_d - вниз | arroW_u - вверх {enter}
return

:*?:/впс::
SendMessage, 0x50,, 0x4190419,, A
Sleep 100
SendPlay  Изучите правила сервера. Ссылка на раздел: https://vk.cc/cyUfaM {enter}
return

:*?:/мп::
SendMessage, 0x50,, 0x4190419,, A
Sleep 100
SendPlay Группа по мероприятиям в VK - https://vk.com/2province_mp {enter}
return

:*?:/круиз::
SendMessage, 0x50,, 0x4190419,, A
Sleep 100
SendPlay bind x cruise_control - включить/выключить круиз контроль. {enter}
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
SendMessage, 0x50,, 0x4190419,, A
Sleep 100
SendPlay Промокод даст скидку 20проц. на покупку квартиры или 25проц. на покупку авто до 700.000 рублей. {enter}
return

:*?:/права::
SendMessage, 0x50,, 0x4190419,, A
Sleep 100
SendPlay Легковые автомобили "B" - 5.000. Автобусы "D" - 7.000. Грузовые автомобили "C" - 8.000. {enter}
return

:*?:/проверкаафк::
SendMessage, 0x50,, 0x4190419,, A
Sleep 100
SendPlay [Проверка на AFK] Здравствуйте{!} Вы тут? Ответ в /report - Да. {enter}
return

:*?:/дистанция::
SendMessage, 0x50,, 0x4190419,, A
Sleep 100
SendPlay Уважаемый игрок{!} Соблюдайте дистанцию в 2-3 вагона, иначе последует наказание. {enter}
return

:*?:/свет::
SendMessage, 0x50,, 0x4190419,, A
Sleep 100
SendPlay Уважаемый игрок{!} Включите свет в салоне и фары (клавиши K и L). {enter}
return

:*?:/номер::
SendMessage, 0x50,, 0x4190419,, A
Sleep 100
SendPlay Номера можно получить в полицейском участке Мирного/Приволжска или в автошколе Невского. {enter}
return

:*?:/f21::
SendMessage, 0x50,, 0x4190419,, A
Sleep 100
SendPlay bind f2 down Toggle scoreboard 1 | bind f2 up Toggle scoreboard 0 {enter}
return

:*?:/собес::
SendMessage, 0x50,, 0x4190419,, A
Sleep 100
SendPlay Все собеседования можно посмотреть тут - https://gtajournal.online/gov?s=2 {enter}
return

:*?:/нум::
SendMessage, 0x50,, 0x4190419,, A
Sleep 100
SendPlay Бинды NumPad: num_0;num_1;num_2 ... num_9; num_mul - умножение; num_div - деление; num_add - сложение; num_enter - клавиша Enter; num_dec - запятая. {enter}
return

:*?:/jai::
SendMessage, 0x50,, 0x4190419,, A
Sleep 100
SendPlay /jailtime {enter}
return

:*?:/а31::
SendMessage, 0x50,, 0x4190419,, A
Sleep 100
SendPlay F3 - Эвакуировать авто. {enter}
return

:*?:/донат::
SendMessage, 0x50,, 0x4190419,, A
Sleep 100
SendPlay Задонатить в игру можно через оф. сайт проекта - https://gtaprovince.ru/donate {enter}
return

:*?:/баг::
SendMessage, 0x50,, 0x4190419,, A
Sleep 100
SendPlay При обнаружении бага обратитесь сюда - https://discord.gg/CZdhXZfM3J {enter}
return

:*?:/берег::
SendMessage, 0x50,, 0x4190419,, A
Sleep 100
SendPlay Администрация не телепортирует. Ищите берег самостоятельно {enter}
return

:*?:/поезд::
SendMessage, 0x50,, 0x4190419,, A
Sleep 100
SendPlay Расписание поездов можно посмотреть тут - https://vk.cc/cHe1kK {enter}
return

:*?:/атп::
SendMessage, 0x50,, 0x4190419,, A
Sleep 100
SendPlay /gps - Город - Работа - АТП {enter}
return

:*?:/сто::
SendMessage, 0x50,, 0x4190419,, A
Sleep 100
SendPlay /gps - Город - Работа - Автомастерская {enter}
return

:*?:/аэропорт::
SendMessage, 0x50,, 0x4190419,, A
Sleep 100
SendPlay /gps - Приволжск - Работа - Аэропорт {enter}
return

:*?:/дорожная служба::
SendMessage, 0x50,, 0x4190419,, A
Sleep 100
SendPlay /gps - Город - Работа - Дорожная служба {enter}
return

:*?:/жбк::
SendMessage, 0x50,, 0x4190419,, A
Sleep 100
SendPlay /gps - Приволжск - Работа - Завод ЖБК {enter}
return

:*?:/лесопилка::
SendMessage, 0x50,, 0x4190419,, A
Sleep 100
SendPlay /gps - Приволжск - Работа - Лесопилка (Жуковский) {enter}
return

:*?:/пицца::
SendMessage, 0x50,, 0x4190419,, A
Sleep 100
SendPlay /gps - Приволжск - Работа - Пиццерия {enter}
return

:*?:/трамвай::
SendMessage, 0x50,, 0x4190419,, A
Sleep 100
SendPlay /gps - Город - Работа - Трамвайное депо {enter}
return

:*?:/стройка::
SendMessage, 0x50,, 0x4190419,, A
Sleep 100
SendPlay /gps - Приволжск/Мирный - Работа - Стройплощадка {enter}
return

:*?:/такси::
SendMessage, 0x50,, 0x4190419,, A
Sleep 100
SendPlay /gps - Город - Работа - Таксопарк {enter}
return

:*?:/шахта::
SendMessage, 0x50,, 0x4190419,, A
Sleep 100
SendPlay /gps - Мирный - Работа - Шахта {enter}
return

:*?:/вту::
SendMessage, 0x50,, 0x4190419,, A
Sleep 100
SendPlay /gps - Невский - Работа - ВТУ (Вончанск) {enter}
return

:*?:/октябрь::
SendMessage, 0x50,, 0x4190419,, A
Sleep 100
SendPlay /gps - Невский - Работа - Завод "Красный Октябрь" {enter}
return

:*?:/табачка::
SendMessage, 0x50,, 0x4190419,, A
Sleep 100
SendPlay /gps - Невский - Работа - Табачный завод {enter}
return

:*?:/офис::
SendMessage, 0x50,, 0x4190419,, A
Sleep 100
SendPlay /gps - Город - Интересные места - Офисный центр {enter}
return

:*?:/гтрек::
SendMessage, 0x50,, 0x4190419,, A
Sleep 100
SendPlay /gps - Приволжск - Авто - Гоночный трек {enter}
return

:*?:/ттрек::
SendMessage, 0x50,, 0x4190419,, A
Sleep 100
SendPlay /gps - Приволжск - Авто - Тестовый автотрек {enter}
return

:*?:/лента::
SendMessage, 0x50,, 0x4190419,, A
Sleep 100
SendPlay /gps - Приволжск - Интересные места - ТЦ "Лента" {enter}
return

:*?:/вивалэнд::
SendMessage, 0x50,, 0x4190419,, A
Sleep 100
SendPlay /gps - Приволжск - Услуги - ТРК "ВиваЛэнд" {enter}
return

:*?:/цветы::
SendMessage, 0x50,, 0x4190419,, A
Sleep 100
SendPlay /gps - Приволжск - Услуги - Цветочная лавка Николая {enter}
return

:*?:/аренда::
SendMessage, 0x50,, 0x4190419,, A
Sleep 100
SendPlay /gps - Город - Услуги - Аренда авто/великов/лодок {enter}
return

:*?:/бар::
SendMessage, 0x50,, 0x4190419,, A
Sleep 100
SendPlay /gps - Приволжск/Мирный - Услуги - Бар {enter}
return

:*?:/пк::
SendMessage, 0x50,, 0x4190419,, A
Sleep 100
SendPlay /gps - Город - Ближайшие места - Компьютерный клуб {enter}
return

:*?:/спортзал::
SendMessage, 0x50,, 0x4190419,, A
Sleep 100
SendPlay /gps - Мирный - Услуги - Спортивный зал {enter}
return

:*?:/парашют::
SendMessage, 0x50,, 0x4190419,, A
Sleep 100
SendPlay /gps - Мирный/Невский - Услуги - Прыжок с парашютом {enter}
return

:*?:/тир::
SendMessage, 0x50,, 0x4190419,, A
Sleep 100
SendPlay /gps - Невский - Услуги - Тир {enter}
return

:*?:/чат::
SendMessage, 0x50,, 0x4190419,, A
Sleep 100
SendPlay bind t chatbox chatboxsay - IC чат {enter}
return

:*?:/телефон::
SendMessage, 0x50,, 0x4190419,, A
Sleep 100
SendPlay bind u phone - достать/убрать телефон {enter}
return

:*?:/карпанель::
SendMessage, 0x50,, 0x4190419,, A
Sleep 100
SendPlay bind f3 car_panel - панель авто (F3) {enter}
return

:*?:/двигатель::
SendMessage, 0x50,, 0x4190419,, A
Sleep 100
SendPlay bind z engine - зажигание двигателя {enter}
return

:*?:/скрин::
SendMessage, 0x50,, 0x4190419,, A
Sleep 100
SendPlay bind f12 screenshot - Скриншот (F12) {enter}
return

:*?:/карта::
SendMessage, 0x50,, 0x4190419,, A
Sleep 100
SendPlay bind f11 radar - Карта (F11) {enter}
return

; ------------------------------- ОКНА В РАМКЕ (ТЕЛЕПОРТЫ)-------------------------------

:*?:/тпофисп1::
SendMessage, 0x50,, 0x4190419,, A
sleep 200
SendPlay /gps {enter}
Sleep 200
SendEvent {Click, 650, 400}
Sleep 300
SendEvent {Click, 1155, 400}
Sleep 400
SendEvent {Click, 650, 750, 2, right}
Sleep 100
SendPlay {esc}
return

:*?:/тпбу1::
SendMessage, 0x50,, 0x4190419,, A
sleep 200
SendPlay /gps {enter}
Sleep 200
SendEvent {Click, 650, 400}
Sleep 200
SendEvent {Click, 1055, 400}
Sleep 200
SendEvent {Click, 650, 635, 2, right}
Sleep 100
SendPlay {esc}
return

:*?:/тпбанкп1::
SendMessage, 0x50,, 0x4190419,, A
sleep 200
SendPlay /gps {enter}
Sleep 200
SendEvent {Click, 650, 400}
Sleep 200
SendEvent {Click, 1240, 400}
Sleep 200
SendEvent {Click, 650, 635, 2, right}
Sleep 100
SendPlay {esc}
return

:*?:/тпбольницап1::
SendMessage, 0x50,, 0x4190419,, A
sleep 200
SendPlay /gps {enter}
Sleep 200
SendEvent {Click, 650, 400}
Sleep 200
SendEvent {Click, 1240, 400}
Sleep 200
SendEvent {Click, 675, 695, 2, right}
Sleep 100
SendPlay {esc}
return

:*?:/тпбольницам1::
SendMessage, 0x50,, 0x4190419,, A
sleep 200
SendPlay /gps {enter}
Sleep 200
SendEvent {Click, 740, 400}
Sleep 200
SendEvent {Click, 1240, 400}
Sleep 200
SendEvent {Click, 675, 695, 2, right}
Sleep 100
SendPlay {esc}
return

:*?:/тпбольницан1::
SendMessage, 0x50,, 0x4190419,, A
sleep 200
SendPlay /gps {enter}
Sleep 200
SendEvent {Click, 830, 400}
; нева
Sleep 200
SendEvent {Click, 1240, 400}
Sleep 200
SendEvent {Click, 675, 695, 2, right}
Sleep 100
SendPlay {esc}
return

:*?:/тпгувдп1::
SendMessage, 0x50,, 0x4190419,, A
sleep 150
SendPlay /gps {enter}
Sleep 150
SendEvent {Click, 650, 400}
; прива
Sleep 150
SendEvent {Click, 1240, 400}
; гос. учреждения
Sleep 150
SendEvent {Click, 660, 905, 2, right}
Sleep 300
SendPlay {esc}
return

:*?:/тпгувдм1::
SendMessage, 0x50,, 0x4190419,, A
sleep 150
SendPlay /gps {enter}
Sleep 150
SendEvent {Click, 740, 400}
; мирка
Sleep 250
SendEvent {Click, 1240, 400}
; гос. учреждения
Sleep 250
DllCall("SetCursorPos", int, 670, int, 878)
Sleep 250
SendEvent {WheelDown 50}
Sleep 900
SendEvent {Click, 670, 878, 2, right}
sleep 150
SendPlay {esc}
return

:*?:/тпгувдн1::
SendMessage, 0x50,, 0x4190419,, A
sleep 150
SendPlay /gps {enter}
Sleep 150
SendEvent {Click, 830, 400}
; нева
Sleep 150
SendEvent {Click, 1240, 400}
; гос. учреждения
Sleep 400
DllCall("SetCursorPos", int, 670, int, 878)
Sleep 150
SendEvent {WheelDown 50}
Sleep 900
SendEvent {Click, 670, 878, 2, right}
sleep 150
SendPlay {esc}
return

; ------------------------------- ТЕЛЕПОРТЫ ОКНА БЕЗ РАМОК/СТАНДАРТ (ТЕЛЕПОРТЫ)-------------------------------
:*?:/тпофисп::
SendMessage, 0x50,, 0x4190419,, A
sleep 130
SendPlay /gps {enter}
Sleep 120
SendEvent {Click, 650, 400}
Sleep 120
SendEvent {Click, 1111, 400}
Sleep 120
SendEvent {Click, 650, 750, 2, right}
Sleep 500
SendEvent {esc}
Sleep 400
Sendplay {esc}
return

:*?:/тпбу::
SendMessage, 0x50,, 0x4190419,, A
sleep 130
SendPlay /gps {enter}
Sleep 120
SendEvent {Click, 650, 400}
Sleep 120
SendEvent {Click, 1055, 400}
Sleep 120
SendEvent {Click, 650, 616, 2, right}
Sleep 200
SendPlay {esc}
return

:*?:/тпбанкп::
SendMessage, 0x50,, 0x4190419,, A
sleep 130
SendPlay /gps {enter}
Sleep 120
SendEvent {Click, 650, 400}
Sleep 120
SendEvent {Click, 1240, 400}
Sleep 120
SendEvent {Click, 650, 616, 2, right}
Sleep 200
SendPlay {esc}
return

:*?:/тпбольницап::
SendMessage, 0x50,, 0x4190419,, A
sleep 130
SendPlay /gps {enter}
Sleep 120
SendEvent {Click, 650, 400}
Sleep 120
SendEvent {Click, 1240, 400}
Sleep 120
SendEvent {Click, 675, 675, 2, right}
Sleep 200
SendPlay {esc}
return

:*?:/тпбольницам::
SendMessage, 0x50,, 0x4190419,, A
sleep 130
SendPlay /gps {enter}
Sleep 120
SendEvent {Click, 740, 400}
Sleep 120
SendEvent {Click, 1240, 400}
Sleep 120
SendEvent {Click, 675, 675, 2, right}
Sleep 200
SendPlay {esc}
return

:*?:/тпбольницан::
SendMessage, 0x50,, 0x4190419,, A
sleep 130
SendPlay /gps {enter}
Sleep 120
SendEvent {Click, 830, 400}
; нева
Sleep 120
SendEvent {Click, 1240, 400}
Sleep 120
SendEvent {Click, 675, 675, 2, right}
Sleep 200
SendPlay {esc}
return

:*?:/тпгувдп::
SendMessage, 0x50,, 0x4190419,, A
sleep 130
SendPlay /gps {enter}
Sleep 120
SendEvent {Click, 650, 400}
; прива
Sleep 120
SendEvent {Click, 1240, 400}
; гос. учреждения
Sleep 120
SendEvent {Click, 660, 888, 2, right}
Sleep 200
SendPlay {esc}
return

:*?:/тпгувдм::
SendMessage, 0x50,, 0x4190419,, A
sleep 130
SendPlay /gps {enter}
Sleep 120
SendEvent {Click, 740, 400}
; мирка
Sleep 120
SendEvent {Click, 1240, 400}
; гос. учреждения
Sleep 120
DllCall("SetCursorPos", int, 670, int, 878)
Sleep 150
SendEvent {WheelDown 50}
Sleep 500
SendEvent {Click, 670, 878, 2, right}
sleep 222
SendPlay {esc}
return

:*?:/тпгувдн::
SendMessage, 0x50,, 0x4190419,, A
sleep 130
SendPlay /gps {enter}
Sleep 120
SendEvent {Click, 830, 400}
; нева
Sleep 120
SendEvent {Click, 1240, 400}
; гос. учреждения
Sleep 120
DllCall("SetCursorPos", int, 670, int, 878)
Sleep 150
SendEvent {WheelDown 50}
Sleep 400
SendEvent {Click, 670, 878, 2, right}
sleep 222
SendPlay {esc}
return
