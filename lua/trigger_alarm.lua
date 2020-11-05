-- 
-- попытка сделать универсальный скрипт алерта при изменении состояния девайса
-- почему-то не получилось сделать отправку сообщения через функцию, поэтому 
-- telegram.send напихано в каждом if'е
--

if (Event.State.Name == "water_leak") then
  if (Event.State.Value == "true" and Event.State.Value ~= Event.State.OldValue) then
    telegram.send("\xF0\x9F\x92\xA7 Протечка \"" .. Event.FriendlyName .. "\" зафиксирована")
  elseif (Event.State.Value == "false" and Event.State.Value ~= Event.State.OldValue) then
    telegram.send("\xE2\x9C\x85 Протечка \"" .. Event.FriendlyName .. "\" устранена")
  end
elseif (Event.State.Name == "contact") then
  if (Event.State.Value == "false" and Event.State.Value ~= Event.State.OldValue) then
    telegram.send("\xF0\x9F\x94\x93 " .. Event.FriendlyName .. " открыта")
  elseif (Event.State.Value == "true" and Event.State.Value ~= Event.State.OldValue) then
    telegram.send("\xF0\x9F\x94\x90 " .. Event.FriendlyName .. " закрыта")
  end
end

