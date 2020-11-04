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

