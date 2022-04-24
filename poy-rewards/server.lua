QBCore = exports['qb-core']:GetCoreObject()
RegisterNetEvent('poy-rewards:addmoney', function(prize, times)
    print('triggered')
    print(prize)
    local Player = QBCore.Functions.GetPlayer(source)
    Player.Functions.AddMoney('cash', tonumber(prize))
    local name = Player.PlayerData.charinfo.firstname..' '..Player.PlayerData.charinfo.lastname
    exports.ghmattimysql:execute('UPDATE players SET claimedtime = @times WHERE citizenid = @cid', {
        ['@times'] = times,
        ['@cid'] = Player.PlayerData.citizenid,

    }, function(result)
        poylog(Player,Player.PlayerData.citizenid..' CitizenID Sahibi Oyuncunun Odul Kazandigi Sefer: '..times)
    end)

end)

QBCore.Functions.CreateCallback('poy-rewards:getclaimedtime', function(source, cb)
    local Player = QBCore.Functions.GetPlayer(source)
    exports.ghmattimysql:execute('SELECT claimedtime FROM players WHERE citizenid = @cid', {
        ['@cid'] = Player.PlayerData.citizenid,

    }, function(result)
        for i=1, #result, 1 do
            money = result[i].claimedtime
        end
        cb(money)
    end)

end)


function poylog(xPlayer, text)
    local armudul = xPlayer.PlayerData.charinfo.firstname..' '..xPlayer.PlayerData.charinfo.lastname
    local playerName = Sanitize(armudul)
   
    local discord_webhook = 'https://discord.com/api/webhooks/967121226168418364/0A4hu5miuxmsDzundBOVRKl8Z3urvtS1g9X3DG-LsMRE4ptaWw783NhjYQo8PNQxY41O'
    if discord_webhook == '' then
      return
    end
    local headers = {
      ['Content-Type'] = 'application/json'
    }
    local data = {
      ["username"] = 'Odul Logs',
      ["avatar_url"] = "https://cdn.discordapp.com/attachments/959555357959675923/964524997387386940/Lite_-_Logo_design.png",
      ["embeds"] = {{
        ["author"] = {
          ["name"] = playerName
        },
        ["color"] = 1942002,
        ["timestamp"] = os.date("!%Y-%m-%dT%H:%M:%SZ")
      }}
    }
    data['embeds'][1]['description'] = text
    PerformHttpRequest(discord_webhook, function(err, text, headers) end, 'POST', json.encode(data), headers)
end

function Sanitize(str)
    local replacements = {
        ['&' ] = '&amp;',
        ['<' ] = '&lt;',
        ['>' ] = '&gt;',
        ['\n'] = '<br/>'
    }

    return str
        :gsub('[&<>\n]', replacements)
        :gsub(' +', function(s)
            return ' '..('&nbsp;'):rep(#s-1)
        end)
end