local signals = {
    _VERSION        = "signals v1.2.0",
    _DESCRIPTION    = "An simple signals module in Lua",
    _URL            = "http://github.com/superzazu/signals.lua",
    _LICENSE        = [[
Copyright (c) 2014-2017 Nicolas Allemand

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
    ]]
}

local s = {}

signals.connect = function(signal_name, callback, group_name)
    local id = #s + 1
    s[id] = {}
    s[id].callback = callback
    s[id].signal_name = signal_name or ""
    s[id].group_name = group_name

    return id
end

signals.disconnect = function(id)
    s[id] = nil
end

signals.disconnectGroup = function(group_name)
    for i, v in pairs(s) do
        if s[i].group_name == group_name then
            s[i] = nil
        end
    end
end

signals.send = function(signal_name, ...)
    for i, v in pairs(s) do
        if s[i].signal_name == signal_name or s[i].signal_name == "" then
            s[i].callback(...)
        end
    end
end

signals.reset = function()
    s = {}
end

return signals
