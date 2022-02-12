ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)


ESX.RegisterServerCallback('wipemenu:getUserGroup', function(source, cb)
  local xPlayer = ESX.GetPlayerFromId(source)
  local group = xPlayer.getGroup()
  print(GetPlayerName(source).." - "..group)
  cb(group)
end)



RegisterServerEvent('wipemenu:wipeplayer')
AddEventHandler('wipemenu:wipeplayer', function(id, raison, user)

  local xPlayer = ESX.GetPlayerFromId(source)
  local group = xPlayer.getGroup()

  id_player = id
  raison_wipe = raison
  user_wipe = user

  
  local identifiers = GetPlayerIdentifiers(id_player)


  for i = 0, GetNumPlayerIdentifiers(id_player) - 1 do
    local id = GetPlayerIdentifier(id_player, i)

    if string.find(id, "steam") then
      identifiers.steam = id
    end
  end 

  print(identifiers.steam)
  steamid = identifiers.steam


  if group == "superadmin" or group == "owner" then

    MySQL.Async.fetchAll([[
          DELETE FROM billing WHERE identifier = @id;
          DELETE FROM billing WHERE sender = @id;
          DELETE FROM open_car WHERE identifier = @id;
          DELETE FROM owned_vehicles WHERE owner = @id;
          DELETE FROM user_accounts WHERE identifier = @id;
          DELETE FROM user_accessories WHERE identifier = @id;
          DELETE FROM phone_users_contacts WHERE identifier = @id;
          DELETE FROM user_inventory WHERE identifier = @id;
          DELETE FROM user_licenses WHERE owner = @id;
          DELETE FROM user_tenue WHERE identifier = @id;
          DELETE FROM owned_properties WHERE owner = @id;
          DELETE FROM playerstattoos WHERE identifier = @id;
          DELETE FROM owned_boats WHERE owner = @id;
          DELETE FROM users WHERE identifier = @id;  ]], {
            ['@id'] = steamid,
        }, function(result)
              if result then 
                    MySQL.Async.fetchAll('INSERT INTO wipe (steamid, raison, user) VALUES (@id, @raison, @user)', {
                            ['@id'] = steamid, ['@raison'] = raison_wipe, ['@user'] = user_wipe
                    }, function(result2)
                    if result2 then return cb(true) end
                    end) 
                end
      end)

    print("WIPE AVEC SUCCES")
  else
    TriggerEvent("BanSql:ICheatServer", source, "CHEAT")
  end

end)

RegisterServerEvent("wipemenu:kick")
AddEventHandler("wipemenu:kick", function (mod_source, target_id, reason)

  local xPlayer = ESX.GetPlayerFromId(source)
  local group = xPlayer.getGroup()

  if group == "superadmin" or group == "owner" then
    local Source = source

    if Source ~= "" then
        mod_source = Source
    end

    local target_group = getGroup(target_id)
    local local_group = getGroup(mod_source)
    local target_name = getName(target_id)

    if mod_source == "superadmin" or mod_source == "owner" then
        local admin_name = "owner"
    else
        local admin_name = getName(mod_source)
    end

    if not inArray(local_group, "superadmin") or not inArray(local_group, "owner") then
      TriggerClientEvent("chatMessage", "[WipeMenu]", {255, 0, 0}, "Tu n'as pas assez de permission pour kick.")
      CancelEvent()
      return
  end



    if lowerGroup(local_group, target_group) then
      TriggerClientEvent("chatMessage", "[WipeMenu]", {255, 0, 0}, "DANGER.")
        CancelEvent()
        return
    end

    DropPlayer(target_id, reason)

    if mod_source ~= "superadmin" or mod_source ~= "owner" then
      TriggerClientEvent("chatMessage", "[WipeMenu]", {255, 0, 0}, "Succes.")
    end


  else
    TriggerEvent("BanSql:ICheatServer", source, "CHEAT")
  end



end)