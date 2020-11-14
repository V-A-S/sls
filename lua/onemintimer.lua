-- 
-- Проверка состояния дверей
-- Если дверь в состоянии "открыто"
-- больше threshhold (секунды), 
-- то шлется сообщение в телеграм
-- 
-- не нашел способа из "крона" получить
-- FriendlyName девайса, закостылил
-- через таблицу doors
-- 

local threshhold = 120
doors = {["0x00158D00039A8616"]="Дверь балкона", ["0x00158D000284EEED"]="Входная дверь"}
for device, devicename in pairs(doors) do
  if not zigbee.value(device, "contact") and obj.get(device) then
    if (os.time()-obj.get(device) >= threshhold) then
      telegram.send ("\xe2\x9a\xa0 " .. devicename .. " открыта уже " .. math.ceil( (os.time()-obj.get(device))/60 ) .. " мин.")
    end
  else 
--    print ("Дверь " .. devicename .. " закрыта")
  end
end

--
-- Проверка температуры горячей воды
--
local gmt = 3
local time = os.time()
local hour = (math.modf(time / 3600) + gmt) % 24
if hour >= 22 or hour <6 then
  threshhold = 7200
else
  threshhold = 3600
end

if (zigbee.value("0x00158D000533D108", "temperature")) <= 30 then
  if not obj.get("hot_water_over") or obj.get("hot_water_over") == "1" then
    obj.set("hot_water_over", os.time())
  end
  if obj.get("hot_water_alert_last_sent") and (os.time()-obj.get("hot_water_alert_last_sent") >= threshhold) then
    telegram.send ("\xef\xbf\xbc\xf0\x9f\x9a\xb1 Похоже, отключили горячую воду. Температура трубы: ".. string.format("%.2f", zigbee.value("0x00158D000533D108", "temperature")) .. " °C")
    obj.set("hot_water_alert_last_sent", os.time())
  elseif not obj.get("hot_water_alert_last_sent") then
    telegram.send ("\xef\xbf\xbc\xf0\x9f\x9a\xb1 Похоже, отключили горячую воду. Температура трубы: ".. string.format("%.2f", zigbee.value("0x00158D000533D108", "temperature")) .. " °C")
    obj.set("hot_water_alert_last_sent", os.time())
  end
else
  if obj.get("hot_water_over") ~= "1" then
    telegram.send ("\xef\xbf\xbc\xf0\x9f\x9a\xb0 УРА! Дали горячую воду. Температура трубы: " .. string.format("%.2f", zigbee.value("0x00158D000533D108", "temperature")) .. " °C. Воды не было " .. string.format("%.2f", (os.time()-obj.get("hot_water_over"))/3600) .. " час.")
    obj.set("hot_water_over", "1")
    obj.set("hot_water_alert_last_sent", "1")
  end
end

--
-- Опрос розеток SHP-13
--
shp13_sockets = {["0x842E14FFFE1394F4"]="Чайник", ["0x842E14FFFE139336"]="Бойлер", ["0x842E14FFFE139485"]="Стиральная машина"}
for device, devicename in pairs(shp13_sockets) do
--  if zigbee.value(device, "state") == "ON" then
    zigbee.get(device, "power")
    zigbee.get(device, "current")
--  end
end

