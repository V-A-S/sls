-- Скрипт добавляется в SB rule того объекта,
-- время изменения состояния которого нам
-- требуется запомнить
obj.set(tostring(Event.ieeeAddr), os.time())

