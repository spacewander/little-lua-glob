-- Ported from https://github.com/ryanuber/go-glob
local _M = {}
local _E = {}
local mt = {__index = _E}
local GLOB = '*'
local GLOB_BYTE = string.byte(GLOB, 1)

-- http://lua-users.org/wiki/SplitJoin
local function split(s, sep)
   local res = {}

   if #s > 0 then
      local n, start = 1, 1
      local first,last = s:find(sep, start, true)
      while first do
         res[n] = s:sub(start, first-1)
         n = n+1
         start = last+1
         first,last = s:find(sep, start, true)
      end
      res[n] = s:sub(start)
   end

   return res
end

function _M.compile(pat)
    local exp = {}
    exp.pattern = pat
    exp.parts = split(pat, GLOB)
    exp.n_part = #exp.parts
    exp.leading_glob = pat:byte(1) == GLOB_BYTE
    exp.trailing_glob = pat:byte(#pat) == GLOB_BYTE
    return setmetatable(exp, {__index = _E})
end

local function has_suffix(s, offset, suffix)
    if #suffix + offset > #s then
        return false
    end

    local start = #s - #suffix
    for i = 1, #suffix do
        if suffix:byte(i) ~= s:byte(i + start) then
            return false
        end
    end

    return true
end

function _E.match(self, subj)
    if self.pattern == GLOB then
        return true
    end

    if self.pattern == "" or self.n_part == 1 then
        return subj == self.pattern
    end

    local start = 1
    for i = 1, self.n_part - 1 do
        local part = self.parts[i]
        local from, to = subj:find(part, start, true)
        if i == 1 then
            if not self.leading_glob and from ~= 1 then
                return false
            end
            to = 0

        else
            if not from then
                return false
            end
        end

        start = to + 1
    end

    return self.trailing_glob or
        has_suffix(subj, start, self.parts[self.n_part])
end

return _M
