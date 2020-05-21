local glob = require "glob"

local function match(s, pat)
    return glob.compile(pat):match(s)
end

describe('glob', function()
    it('sanity', function()
        assert.is_true(match("The quick brown fox jumped over the lazy dog", "*quick*fox*dog"))
        assert.is_false(match("The quick brown dog jumped over the lazy dog", "*quick*fox*dog"))

        assert.is_true(match("a.aliyun.b.com", "a.*b.com"))
        assert.is_true(match("a.img.b.com", "a.*b.com"))
        assert.is_false(match("a.bc.com", "a.*b.com"))

        for _, pattern in ipairs({
            "*test",           -- Leading glob
            "this*",           -- Trailing glob
            "this*test",       -- Middle glob
            "*is *",           -- String in between two globs
            "*is*a*",          -- Lots of globs
            "**test**",        -- Double glob characters
            "**is**a***test*", -- Varying number of globs
            "* *",             -- White space between globs
            "*",               -- Lone glob
            "**********",      -- Nothing but globs
        }) do 
            assert.is_true(match("this is a test", pattern))
        end

        for _, pattern in ipairs({
            "test*",               -- Implicit substring match
            "*is",                 -- Partial match
            "*no*",                -- Globs without a match between them
            " ",                   -- Plain white space
            "* ",                  -- Trailing white space
            " *",                  -- Leading white space
            "this*this is a test", -- Repeated prefix
        }) do 
            assert.is_false(match("this is a test", pattern))
        end
    end)

    it('pattern without glob', function()
       assert.is_true(match('t', 't'))
    end)

    it('empty pattern', function()
       assert.is_false(match('t', ''))
       assert.is_true(match('', ''))
    end)

    it('empty string', function()
       assert.is_false(match('', 'a'))
       assert.is_false(match('', 'a*'))
       assert.is_true(match('', '*'))
       assert.is_true(match('', '**'))
       assert.is_true(match('', ''))
    end)
end)
