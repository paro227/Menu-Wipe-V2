ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

local ServersIdSession = {}
local joueurPed = GetPlayerPed(IdSelected)

Citizen.CreateThread(function()
    while true do
        Wait(500)
        for k,v in pairs(GetActivePlayers()) do
            local found = false
            for _,j in pairs(ServersIdSession) do
                if GetPlayerServerId(v) == j then
                    found = true
                end
            end
            if not found then
                table.insert(ServersIdSession, GetPlayerServerId(v))
            end
        end
    end
end)

local function XpersonalmenuKeyboardInput(TextEntry, ExampleText)
    AddTextEntry('FMMC_KEY_TIP1', TextEntry)
    DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP1", "", ExampleText, "", "", "", 100)
    blockinput = true

    while UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2 do
        Citizen.Wait(0)
    end

    if UpdateOnscreenKeyboard() ~= 2 then
        local result = GetOnscreenKeyboardResult()
        Citizen.Wait(500)
        blockinput = false
        return result
    else
        Citizen.Wait(500)
        blockinput = false
        return nil
    end
end

local function Wipe(id ,raison, user)

    TriggerServerEvent('wipemenu:wipeplayer', id, raison, user)
    TriggerServerEvent('wipemenu:kick', playergroup, id, "Tu as ete deconnecte car tu as ete WIPE")

end

------------ Création du Menu / Sous Menu -----------

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Await(10)
    end


end)

RMenu.Add('wipemenu', 'main', RageUI.CreateMenu("Wipe Menu", "Wipe Menu by Lee Pong"))
RMenu.Add('wipemenu', 'listplayer', RageUI.CreateSubMenu(RMenu:Get('wipemenu', 'main'), "Liste des joueurs", "Menu Wipe"))
RMenu.Add('wipemenu', 'gestj', RageUI.CreateSubMenu(RMenu:Get('admin', 'listej'), "Gestion joueurs", "Pour gérer les joueurs"))


Citizen.CreateThread(function()
    while true do
        RageUI.IsVisible(RMenu:Get('wipemenu', 'main'), true, true, true, function()
            

            RageUI.ButtonWithStyle("~b~Liste des joueurs", nil, {RightLabel = "→→"}, true, function(Hovered, Active, Selected)
            end, RMenu:Get('wipemenu', 'listplayer'))
            

            RageUI.ButtonWithStyle("~r~Wipe avec ID", nil, {RightLabel = "→→"}, true, function(Hovered, Active, Selected)
                if (Selected) then
                    local post1, id = XpersonalmenuKeyboardInput("Entrez l'ID du joueur a WIPE", "", "")
                    local post2, raison = XpersonalmenuKeyboardInput("Entrez la raison pour laquel vous WIPER le joueur", "", "")
                    local post3, user = XpersonalmenuKeyboardInput("Entrez le nom du Staff qui la WIPE", "", "")

                    if post3 then
                        id = post1
                        raison = post2
                        user = post3

                        Wipe(id, raison, user)
                    end

                end
            end)


        end, function()
        end)

        RageUI.IsVisible(RMenu:Get('wipemenu', 'listplayer'), true, true, true, function()
            RageUI.Separator("~r~↓ Liste des joueurs : ↓")
            for k,v in ipairs(ServersIdSession) do
                if GetPlayerName(GetPlayerFromServerId(v)) == "**Pas connecter**" then table.remove(ServersIdSession, k) end
                RageUI.ButtonWithStyle("[ID : "..v.."~s~] - ~b~"..GetPlayerName(GetPlayerFromServerId(v)), nil, {RightLabel = "→→"}, true, function(Hovered, Active, Selected)
                    if (Selected) then
                        local post2, raison = XpersonalmenuKeyboardInput("Entrez la raison pour laquel vous WIPER le joueur", "", "")
                        local post3, user = XpersonalmenuKeyboardInput("Entrez le nom du Staff qui la WIPE", "", "")
                        local post4, verif = XpersonalmenuKeyboardInput("Etes vous sure de vouloir WIPE ce joueur (Y/N)", "", "")

                        if post4 == "Y" then
                            if post3 then
                                id = v
                                raison = post2
                                user = post3

                                Wipe(id, raison, user)
                            end
                        end
                    end
                end, RMenu:Get('wipemenu', 'gestj'))
            end
        end, function()
        end)
        
        Citizen.Wait(0)
    end
end)


RegisterCommand("wipemenu", function()
	ESX.TriggerServerCallback('wipemenu:getUserGroup', function(group, data)
        playergroup = group
    end)

    Citizen.Wait(1000)

    print(playergroup)

    if playergroup == "superadmin" or playergroup == "owner" then 
        RageUI.Visible(RMenu:Get('wipemenu', 'main'), not RageUI.Visible(RMenu:Get('wipemenu', 'main')))
    else
        TriggerEvent("chatMessage", "[WipeMenu]", {255, 0, 0}, "Tu n'as pas assez de permission pour acceder au WipeMenu.")
    end
end, false)


