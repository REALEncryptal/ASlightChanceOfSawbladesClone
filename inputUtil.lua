local input = {
    keydown={},
    keyup={},
    keys={}
}

function _listen(event)
    local callbacks = {}

    if event.phase == "up" then
        input.keys[event.keyName] = nil
        callbacks = input.keyup[event.keyName] or {}
    else
        input.keys[event.keyName] = os.time()
        callbacks = input.keydown[event.keyName] or {}
    end

    for _, callback in ipairs(callbacks) do
        callback()
    end

    -- If the "back" key was pressed on Android, prevent it from backing out of the app
    if ( event.keyName == "back" ) then
        if ( system.getInfo("platform") == "android" ) then
            return true
        end
    end
    
    return false
end

--api
function input.isKeyDown(Key) 
    return input.keys[Key]
end

function input.onInputBegan(Key, Callback)
    if not input.keydown[Key] then
        input.keydown[Key] = {}
    end

    table.insert(input.keydown[Key], Callback)
end

function input.onInputEnded(Key, Callback)
    if not input.keyup[Key] then
        input.keyup[Key] = {}
    end

    table.insert(input.keyup[Key], Callback)
end

Runtime:addEventListener("key", _listen)

return input