#SingleInstance Force

; Проверка на UIA
CheckUIA()
{
    if (!A_IsCompiled && !InStr(A_AhkPath, "_UIA")) {
        Run % "*uiAccess " A_ScriptFullPath
        ExitApp
    }
}
CheckUIA()

; Проверка прав администратора
if not A_IsAdmin
{
    Run *RunAs "%A_ScriptFullPath%"  ; *RunAs запрашивает права администратора
    ExitApp  ; Завершаем текущий экземпляр скрипта
}

;________________________________________________________________________________________________________________________________________________________________________________________

#SingleInstance Force

; Путь к текущему скрипту
scriptPath := A_ScriptFullPath
scriptDir := A_ScriptDir
scriptName := A_ScriptName

; Локальная версия
currentVersion := "1.2.1"  ; Укажите текущую версию скрипта

; Ссылки на GitHub
githubVersionURL := "https://raw.githubusercontent.com/StichneAllen/AdminHelper/refs/heads/main/version.txt"
githubScriptURL := "https://raw.githubusercontent.com/StichneAllen/AdminHelper/refs/heads/main/Admin.ahk"

; Функция для проверки обновлений
CheckForUpdates() {
    global currentVersion, githubVersionURL, githubScriptURL, scriptPath, scriptDir, scriptName

    ; Загружаем версию с GitHub
    whr := ComObjCreate("WinHttp.WinHttpRequest.5.1")
    whr.Open("GET", githubVersionURL, true)
    whr.Send()
    whr.WaitForResponse()

    ; Проверяем статус ответа
    status := whr.Status
    if (status != 200) {
        MsgBox, 16, Ошибка, Не удалось получить версию с сервера. Код статуса: %status%
        return
    }

    ; Убираем все лишние символы (пробелы, переносы строк и т.д.)
    serverVersion := Trim(whr.ResponseText)
    serverVersion := RegExReplace(serverVersion, "[\r\n]+", "")  ; Удаляем переносы строк
    serverVersion := RegExReplace(serverVersion, "\s+", "")     ; Удаляем все пробелы

    ; Убираем лишние символы из локальной версии
    currentVersion := Trim(currentVersion)
    currentVersion := RegExReplace(currentVersion, "[\r\n]+", "")
    currentVersion := RegExReplace(currentVersion, "\s+", "")

    ; Сравниваем версии
    if (serverVersion != currentVersion) {
        MsgBox, 4, Обновление, Доступна новая версия (%serverVersion%). Хотите обновить?
        IfMsgBox, No
            return

        ; Загружаем новый скрипт
        whr.Open("GET", githubScriptURL, true)
        whr.Send()
        whr.WaitForResponse()

        ; Проверяем статус ответа
        status := whr.Status
        if (status != 200) {
            MsgBox, 16, Ошибка, Не удалось загрузить новый скрипт. Код статуса: %status%
            return
        }

        newScript := whr.ResponseText

        ; Переименовываем старый скрипт
        oldScriptPath := scriptDir "\" RegExReplace(scriptName, "\.ahk$", "") " (old).ahk"
        FileMove, %scriptPath%, %oldScriptPath%

        ; Сохраняем новый скрипт
        FileAppend, %newScript%, %scriptPath%

        ; Обновляем текущую версию
        currentVersion := serverVersion

        MsgBox, 64, Успех, Скрипт успешно обновлен. Перезапустите скрипт.
        ExitApp  ; Завершаем текущий скрипт
    }
}

; Проверка обновлений при запуске
CheckForUpdates()

;________________________________________________________________________________________________________________________________________________________________________________________

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

; Основной GUI
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
Gui, Add, Text, x2 x380 y95 w395 h15 , /бх - BH при погоне [1 дн.]
Gui, Add, Text, x2 x380 y110 w395 h15 , /выходрп - Off от РП [7 дн.]
Gui, Add, Text, x2 x380 y125 w395 h15 , /вх - WH [3 ч.]
Gui, Add, Text, x2 x380 y140 w395 h15 , /дмигрока - DM игрока [1.5 дн.]
Gui, Add, Text, x2 x380 y155 w395 h15 , /дмкар - DM car [1.5 дн.]
Gui, Add, Text, x2 x380 y170 w395 h15 , /дмкил - DM kill [2.5 дн.]
Gui, Add, Text, x2 x380 y185 w395 h15 , /дб - DB [3 дн.]
Gui, Add, Text, x2 x380 y200 w395 h15 , /пг - PG [2.5 дн.]
Gui, Add, Text, x2 x380 y215 w395 h15 , /подрезы - Созд. аварийных ситуаций [1.5 дн.]
Gui, Add, Text, x2 x380 y230 w395 h15 , /погоняепт - Езда по газонам/тротуарам при погоне [2.5 дн.]
Gui, Add, Text, x2 x380 y245 w395 h15 , /погоняепп - Езда по полю при погоне [2.5 дн.]
Gui, Add, Text, x2 x380 y260 w395 h15 , /политпров - Полит. провокация [30 дн.]
Gui, Add, Text, x2 x380 y275 w395 h15 , /погонявело - Погоня на велосипеде [1 дн.]
Gui, Add, Text, x2 x380 y290 w395 h15 , /оскпроекта - Оск. проекта [30 дн.]
Gui, Add, Text, x2 x380 y305 w395 h15 , /оскрод - Оск. родных [30 дн.]
Gui, Add, Text, x2 x380 y320 w395 h15 , /оскадм - Оск. администрации [3 дн.]
Gui, Add, Text, x2 x380 y335 w395 h15 , /тк - TK [1.5 дн.]
Gui, Add, Text, x2 x380 y350 w395 h15 , /таран - Таран авто [3 дн.]
Gui, Add, Text, x2 x380 y365 w395 h15 , /упомрод - Упом. родных [15 дн.]
Gui, Add, Text, x2 x380 y380 w395 h15 , /уходрп - Уход от рп [3 дн.]
Gui, Add, Text, x2 x380 y395 w395 h15 , /шантаж - Шантаж и вымогательства [30 дн.]
Gui, Add, Text, x2 x380 y410 w395 h15 , /нацизм - Нацизм/расизм [30 дн.]
Gui, Add, Text, x2 x380 y425 w395 h15 , /ртлц - Рабочий транспорт в ЛЦ [1 дн.]
Gui, Add, Text, x2 x380 y440 w395 h15 , /банбагоюз - Мелкий багоюз [5 дн.]
Gui, Add, Text, x2 x380 y455 w395 h15 , /нонрп - NonRP [2 дн.]
Gui, Add, Text, x2 x380 y470 w395 h15 , /вилка - Вилка в клаве [1 дн.]
Gui, Add, Text, x2 x380 y485 w395 h15 , /рекламачит - Реклама сторонних рес. [перм.]
Gui, Add, Text, x2 x380 y500 w395 h15 , /чит - Читы [перм.]
Gui, Add, Text, x2 x380 y515 w395 h15 , /ботраб - Бот для работы [перм.]
Gui, Font, S8 c747474, Regular, Arial,
Gui, Add, Text, x545 y582 w300 h30 , Создатели: Stich_Allen and German_McKenzy

; ------------------------------- Админ команды джайлы (ОСНОВНОЕ)-------------------------------

Gui 1:Font, s11 c000000 Bold, Arial
Gui 1:Add, GroupBox, x10 y250 w350 h330 c9FFC69, [ ajail | muted | kicked (2 lvl) ]
Gui 1:Font, s8 cWhite Bold, Arial
Gui, Add, Text, x20 y270 w330 h15 , /встречка - Встречка [30 м.]
Gui, Add, Text, x20 y285 w330 h15 , /красные - Красный х2 [30 м.]
Gui, Add, Text, x20 y300 w330 h15 , /епп - Езда по полю [30 м.]
Gui, Add, Text, x20 y315 w330 h15 , /епт - Езда по тротуару/газону [30 м.]
Gui, Add, Text, x20 y330 w330 h15 , /епр - Езда по рельсам [15 м.]
Gui, Add, Text, x20 y345 w330 h15 , /музыка - Музыка в ГЧ [1 ч.]
Gui, Add, Text, x20 y360 w330 h15 , /помеха - Афк помеха [kick]
Gui, Add, Text, x20 y375 w330 h15 , /оффтоп - Offtop in report [1.5 ч.]
Gui, Add, Text, x20 y390 w330 h15 , /мг - MG [30 м.]
Gui, Add, Text, x20 y405 w330 h15 , /капс - Caps Lock [30 м.]
Gui, Add, Text, x20 y420 w330 h15 , /флуд - Flood [1.5 ч.]
Gui, Add, Text, x20 y435 w330 h15 , /мат - Употребление нецензурных слов [1.5 ч.]
Gui, Add, Text, x20 y450 w330 h15 , /оскигрока - Оск. игроков [1.5 ч.]
Gui, Add, Text, x20 y465 w330 h15 , /неувобращение - Неув. обращение в репорт [1.5 ч.]
Gui, Add, Text, x20 y480 w330 h15 , /безсвета - Без света ОТ [kick]
Gui, Add, Text, x20 y495 w330 h15 , /пантограф - Торм. пантографом [лишение 14 дн.]
Gui, Add, Text, x20 y510 w330 h15 , /кикафк - Кик игроков 3+ афк (в хх:х5 (говка))
Gui, Add, Text, x20 y525 w330 h15 ,
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
; Кнопка для изменения тега
Gui 1:Tab, 1
Gui 1:Font, s12 cFD7B7C Bold Arial
Gui 1:Add, Button, x640 y10 w150 h30 gOpenTagMenu BackgroundColor=cWhite TextColor=cFD7B7C, Изменение тега

; Загрузка тега из файла
if FileExist(iniFile) {
    IniRead, SavedTag, %iniFile%, Settings, Tag  ; читаем тег из файла
    if (SavedTag = "ERROR" || SavedTag = "") {  ; если тег пустой или файл поврежден
        MsgBox, Ошибка: Тег не найден или файл поврежден. Пожалуйста, введите новый тег.
        SavedTag := ""  ; оставляет тег пустым
    }
} else {
    SavedTag := ""  ; Если файла нет, оставляем тег пустым
}

; GUI для ввода тега
Gui 3:Font, s12
Gui 3:Add, Edit, vNewTagInput w200 BackgroundColor=White TextColor=Black, %SavedTag%  ; поле для ввода нового тега
Gui 3:Add, Button, gSaveTag, save
Gui 3:Add, Button, gCloseTagGUI, close

; Основной GUI для тега
Gui 2:Font, s14 Bold Arial
Gui 2:Color, c202127
Gui 2:Add, Edit, vCurrentTag w200 x100 y50 Center, %SavedTag%
Gui 2:Font, s11 Bold Arial
Gui 2:Add, Text, x160 y30 w120 h15 cWhite, Новый тег:
Gui 2:Font, s14 c202127
Gui 2:Add, Button, x140 y120 w120 h40 gButtonReset, Reset
Gui 2:Add, Button, x10 y120 w120 h40 gButtonSave, Save
Gui 2:Add, Button, x270 y120 w120 h40 gButtonCancel, Close

; Показываем основной GUI (Gui 2)
Gui 2:Hide

; Запускаем таймер для проверки тега каждые 30 секунд
SetTimer, CheckTag, 30000  ; 30000 мс = 30 секунд

; Основной код скрипта
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

; Обработчик кнопки "Сохранить" в GUI 3 (для тега)
SaveTag:
Gui 3:Submit, NoHide  ; Сохраняем введенные данные без закрытия GUI
if (NewTagInput = "") {
    MsgBox, Ошибка: Тег не может быть пустым!
    return
}

; Проверяем, существует ли папка, и создаем её, если нет
if !EnsureFolderExists()
{
    return
}

; Сохраняем тег в файл
IniWrite, %NewTagInput%, %iniFile%, Settings, Tag
if ErrorLevel {
    MsgBox, Ошибка при сохранении тега!
    return
}
MsgBox, Новый тег сохранен: %NewTagInput%
SavedTag := NewTagInput  ; Обновляем переменную SavedTag
GuiControl, 2:, CurrentTag, %NewTagInput%  ; Обновляем поле в GUI 2
return

; Обработчик кнопки "Закрыть" в GUI 3
CloseTagGUI:
Gui 3:Hide  ; Скрываем GUI 3
return

; Обработчик кнопки "Сбросить" в GUI 2
ButtonReset:
MsgBox, 4,, Вы уверены, что хотите сбросить тег?
IfMsgBox, No
    return
GuiControl, 2:, CurrentTag,  ; Очищаем поле ввода

; Проверяем, существует ли папка, и создаем её, если нет
if !EnsureFolderExists()
{
    return
}

IniDelete, %iniFile%, Settings, Tag  ; Удаляем тег из файла
SavedTag := ""  ; Очищаем переменную SavedTag
MsgBox, Тег сброшен.
return

; Обработчик кнопки "Сохранить" в GUI 2
ButtonSave:
Gui 2:Submit, NoHide
GuiControlGet, CurrentTag,, CurrentTag
if (CurrentTag = "") {
    MsgBox, Ошибка: Тег не может быть пустым!
    return
}

; Проверяем, существует ли папка, и создаем её, если нет
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

; Обработчик кнопки для открытия меню изменения тега
OpenTagMenu:
Gui 2:Show, w400 h170, Admin tag
return

; Обработчик кнопки "Закрыть" в GUI 2
ButtonCancel:
Gui 1:-Disabled
Gui 2:Cancel
return

; Горячая клавиша для открытия GUI 3 (управление тегом)
^!t::  ; Ctrl+Alt+T для открытия GUI 3
Gui 3:Show,, Настройка тега
return


;Закрыть скрипт на крестик
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
SendPlay, {space}Приятной игры с администрацией второго сервера {^}{-}{^} {enter}
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
SendPlay, /a ВНИМАНИЕ{!} Занимаю админ новости{!} {enter}
Sleep 5000
SendMessage, 0x50,, 0x4190419,, A
SendPlay, {T}
Sleep 500
SendPlay, /p Уважаемые игроки{!} {enter}
Sleep 500
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
SendPlay, banname  d 3 Уход от РП by %SavedTag%
Sleep 100
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
SendPlay, banname  d 5 Багоюз by %SavedTag%
Sleep 100
SendPlay, {Home}{Right 8}
return

:*?:/чит::
SendMessage, 0x50,, 0x4190419,, A
Sleep 100
SendPlay banname  d 0 Читы by %SavedTag%
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

:*?:/дмигрока::
SendMessage, 0x50,, 0x4190419,, A
Sleep 100
SendPlay banname  d 1.5 DM by %SavedTag%
Sleep 100
SendPlay, {Home}{Right 8}
return

:*?:/дб::
SendMessage, 0x50,, 0x4190419,, A
Sleep 100
SendPlay banname  d 3 DB by %SavedTag%
Sleep 100
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
SendPlay banname  d 1 BH при погоне by %SavedTag%
Sleep 100
SendPlay, {Home}{Right 8}
return

:*?:/тк::
SendMessage, 0x50,, 0x4190419,, A
Sleep 100
SendPlay banname  d 1.5 TK by %SavedTag%
Sleep 100
SendPlay, {Home}{Right 8}
return

:*?:/пг::
SendMessage, 0x50,, 0x4190419,, A
Sleep 100
SendPlay banname  d 2.5 PG by %SavedTag%
Sleep 100
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
SendPlay banname  d 3 Оск. администрации by %SavedTag%
Sleep 100
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

:*?:/оскпроекта::
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
SendPlay banname  d 30 Шантаж игрока by %SavedTag%
Sleep 100
SendPlay, {Home}{Right 8}
return

:*?:/таран::
SendMessage, 0x50,, 0x4190419,, A
Sleep 100
SendPlay banname  d 3 Таран by %SavedTag%
Sleep 100
SendPlay, {Home}{Right 8}
return

:*?:/подрезы::
SendMessage, 0x50,, 0x4190419,, A
Sleep 100
SendPlay banname  d 1.5 Созд. аварийных ситуаций by %SavedTag%
Sleep 100
SendPlay, {Home}{Right 8}
return

:*?:/погоняепт::
SendMessage, 0x50,, 0x4190419,, A
Sleep 100
SendPlay banname  d 2.5 Езда по газонам/тротуарам при погоне by %SavedTag%
Sleep 100
SendPlay, {Home}{Right 8}
return

:*?:/погоняепп::
SendMessage, 0x50,, 0x4190419,, A
Sleep 100
SendPlay banname  d 2.5 ЕПП при погоне by %SavedTag%
Sleep 100
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
SendPlay banname  d 2 NonRP by %SavedTag%
Sleep 100
SendPlay, {Home}{Right 8}
return

:*?:/вилка::
SendMessage, 0x50,, 0x4190419,, A
Sleep 100
SendPlay banname  d 1 Анти-афк by %SavedTag%
Sleep 100
SendPlay, {Home}{Right 8}
return

:*?:/дмкар::
SendMessage, 0x50,, 0x4190419,, A
Sleep 100
SendPlay banname  d 1.5 DM car by %SavedTag%
Sleep 100
SendPlay, {Home}{Right 8}
return

:*?:/дмкил::
SendMessage, 0x50,, 0x4190419,, A
Sleep 100
SendPlay banname  d 2.5 DM kill by %SavedTag%
Sleep 100
SendPlay, {Home}{Right 8}
return

:*?:/погонявело::
SendMessage, 0x50,, 0x4190419,, A
Sleep 100
SendPlay banname  d 1 Погоня на велосипеде by %SavedTag%
Sleep 100
SendPlay, {Home}{Right 8}
return

:*?:/епп::
SendMessage, 0x50,, 0x4190419,, A
Sleep 100
SendPlay ajail  30 ЕПП by %SavedTag%
Sleep 100
SendPlay, {Home}{Right 6}
return

:*?:/епт::
SendMessage, 0x50,, 0x4190419,, A
Sleep 100
SendPlay ajail  30 Езда по газонам/тротуарам by %SavedTag%
Sleep 100
SendPlay, {Home}{Right 6}
return

:*?:/епр::
SendMessage, 0x50,, 0x4190419,, A
Sleep 100
SendPlay ajail  15 Движение по рельсам by %SavedTag%
Sleep 100
SendPlay, {Home}{Right 6}
return

:*?:/красные::
SendMessage, 0x50,, 0x4190419,, A
Sleep 100
SendPlay ajail  30 Проезд на красный светофор х2 by %SavedTag%
Sleep 100
SendPlay, {Home}{Right 6}
return

:*?:/встречка::
SendMessage, 0x50,, 0x4190419,, A
Sleep 100
SendPlay ajail  30 Движение по встречной полосе by %SavedTag%
Sleep 100
SendPlay, {Home}{Right 6}
return

:*?:/музыка::
SendMessage, 0x50,, 0x4190419,, A
Sleep 100
SendPlay muted  h 1 music in voice chat by %SavedTag%
Sleep 100
SendPlay, {Home}{Right 6}
return

:*?:/оффтоп::
SendMessage, 0x50,, 0x4190419,, A
Sleep 100
SendPlay muted  h 1.5 Offtop in report by %SavedTag%
Sleep 100
SendPlay, {Home}{Right 6}
return

:*?:/мг::
SendMessage, 0x50,, 0x4190419,, A
Sleep 100
SendPlay muted  m 30 MG by %SavedTag%
Sleep 100
SendPlay, {Home}{Right 6}
return

:*?:/капс::
SendMessage, 0x50,, 0x4190419,, A
Sleep 100
SendPlay muted  m 30 Caps Lock by %SavedTag%
Sleep 100
SendPlay, {Home}{Right 6}
return

:*?:/флуд::
SendMessage, 0x50,, 0x4190419,, A
Sleep 100
SendPlay muted  h 1.5 Flood by %SavedTag%
Sleep 100
SendPlay, {Home}{Right 6}
return

:*?:/мат::
SendMessage, 0x50,, 0x4190419,, A
Sleep 100
SendPlay muted  h 1.5 Употребление нецензурных слов by %SavedTag%
Sleep 100
SendPlay, {Home}{Right 6}
return

:*?:/оскигрока::
SendMessage, 0x50,, 0x4190419,, A
Sleep 100
SendPlay muted  h 1.5 Оск. игрока by %SavedTag%
Sleep 100
SendPlay, {Home}{Right 6}
return

:*?:/неувобращение::
SendMessage, 0x50,, 0x4190419,, A
Sleep 100
SendPlay muted  h 1.5 Неув. обращение в репорт by %SavedTag%
Sleep 100
SendPlay, {Home}{Right 6}
return

:*?:/помеха::
SendMessage, 0x50,, 0x4190419,, A
Sleep 100
SendPlay kicked  AFK (помеха) by %SavedTag%
Sleep 100
SendPlay, {Home}{Right 7}
return

:*?:/безсвета::
SendMessage, 0x50,, 0x4190419,, A
Sleep 100
SendPlay kicked  Движение с выкл. фарами/светом в салоне by %SavedTag%
Sleep 100
SendPlay, {Home}{Right 7}
return

:*?:/пантограф::
SendMessage, 0x50,, 0x4190419,, A
Sleep 100
SendPlay tramoff  Торможение с помощью пантографа by %SavedTag%
Sleep 100
SendPlay, {Home}{Right 8}
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

; АРБУЗ АРБУЗ
; НЕ АРБУЗ АРБУЗ
