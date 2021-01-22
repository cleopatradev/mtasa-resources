local langs = {}

local addEventHandler = addEventHandler
local fileOpen = fileOpen
local fromJSON = fromJSON
local fileRead = fileRead
local fileGetSize = fileGetSize

if triggerClientEvent then
    addEventHandler("onResourceStart", resourceRoot,
        function()
            local file = fileOpen("langs/langs.json")
            if file then
                local fileContent = fromJSON(fileRead(file, fileGetSize(file))) or {}
                if fileContent then

                    for index, lang in ipairs(fileContent) do
                        local langFile = fileOpen(("langs/%s.json"):format(lang))
                        if langFile then
                            local langContent = fromJSON(fileRead(langFile, fileGetSize(langFile))) or {}
                            langs[lang] = langContent
                        end
                    end
                
                end
            end
        end
    )

    addEvent("editor_lang.send", true)
    addEventHandler("editor_lang.send", root,
        function(lang)
            setElementData(source, "lang", lang.code, false)
        end
    )

    function getStringData(player, str)
        local playerLang = getElementData(player, "lang") or "en"
        local lang = langs[playerLang] or langs["en"]
        if lang["strings"][str] then
            return lang["strings"][str]
        end
        return "UNKNOWN"
    end
else
    local localLang
    addEventHandler("onClientResourceStart", resourceRoot,
        function()
            localLang = getLocalization()
            triggerServerEvent("editor_lang.send", localPlayer, localLang)

            local file = fileOpen("langs/langs.json")
            if file then
                local fileContent = fromJSON(fileRead(file, fileGetSize(file))) or {}
                if fileContent then
                    for index, lang in ipairs(fileContent) do
                        local langFile = fileOpen(("langs/%s.json"):format(lang))
                        if langFile then
                            local langContent = fromJSON(fileRead(langFile, fileGetSize(langFile))) or {}
                            langs[lang] = langContent
                        end
                    end
                end
            end
        end
    )

    function getStringData(str)
        local lang = langs[localLang.code] or langs["en"]
        if lang["strings"][str] then
            return lang["strings"][str]
        end
        return "UNKNOWN"
    end
end

