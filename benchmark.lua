#!/usr/bin/env resty
-- the library itself doesn't depend on OpenResty's API.
-- here we use 'resty' just to compare with a PCRE regex implementation.
require "resty.core"
local glob = require "glob"

local pat = "a.*b.com"
local matcher = glob.compile(pat)
local re_match = function(s)
    -- assume we have a complex function to convert glob pattern to regex one,
    -- without allowing user to inject their favourite regex.
    return ngx.re.find(s, [[^a\..*?b\.com$]], "jo") ~= nil
end

local r
local total = 1e7
ngx.update_time()
local start = ngx.now()
for i = 1, total do
    -- the match is almost as fast as the regex implementation
    --r = matcher:match("a.aliyun.b.com")
    r = re_match("a.aliyun.b.com")
end

ngx.update_time()
ngx.say(ngx.now() - start)
ngx.say(r)
