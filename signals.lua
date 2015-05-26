local signals = {}

local s = {}

signals.connect = function (signal_name, callback)
    if not s[signal_name] then
        s[signal_name] = {}
    end
    s[signal_name][#s[signal_name]+1] = callback
end

signals.disconnect = function (signal_name, callback)
    if s[signal_name] then
        for i=1,#s[signal_name] do
            if s[signal_name][i] == callback then
                s[signal_name][i] = function () end
            end
        end
    end
end

signals.send = function (signal_name, sender, ...)
    if s[signal_name] then
        for i=1,#s[signal_name] do
            s[signal_name][i](sender, ...)
        end
    end
end


return signals
