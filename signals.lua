local signals = {
    _VERSION         = 'signals v1.1.0',
    _DESCRIPTION    = 'An simple signals module in Lua',
    _URL            = 'http://github.com/superzazu/signals.lua',
    _LICENSE        = [[
Copyright (c) 2014 Nicolas Allemand

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

local _s = {}

signals.connect = function (signal_name, callback)
    -- if type(signal_name) == 'function' then
    --     -- nil event: trigger everything
    --     callback = signal_name
    --     signal_name = '__nil_signal' -- not good enough.
    -- end
    if not _s[signal_name] then
        _s[signal_name] = {}
    end
    local id = #_s[signal_name]+1
    _s[signal_name][id] = callback
    return id
end

signals.disconnect = function (signal_name, id)
    if _s[signal_name] then
        _s[signal_name][id] = nil
    end
end

signals.send = function (signal_name, ...)
    if _s[signal_name] then
        for i=1,#_s[signal_name] do
            _s[signal_name][i](...)
        end
    end
end


return signals
