local Check = {}

local THROW_ERR = {}

local function clear(s)
    local split = s:split(": ")
    table.remove(split, 1)
    return table.concat(split, ": ")
end

function Check.describe(description)
    return function (fn)
        local scs, err = pcall(fn)
        if not scs then
            error(description.." it "..clear(err))
        end
    end
end

function Check.it(description)
    return function (fn)
        local scs, err = pcall(fn)
        if not scs then
            -- .." but "..clear(err)
            return error(description)
        end
    end
end

function Check.expect(value)
    local inverse = false
    local message = (if type(value) == "function" or type(value) == "table" then type(value) else tostring(value)).." "

    -- "this test, it should return true but function did not equal false

    return {
        to = setmetatable({
            equal = function(compare)
                message ..= (if not inverse then "did not equal to " else "equal to ")..tostring(compare)
                local result
                if value == compare then
                    result = inverse or true
                else
                    result = inverse or false
                end

                if not result then
                    return error(message)
                end
            end,

            a = function(Type)
                message ..= (if not inverse then "is not a " else "is a ")..Type
                local result
                if type(value) == type then
                    result = inverse or true
                else
                    result = inverse or false
                end

                if not result then
                    return error(message)
                end
            end,

            throw = function(errMsg)
                if type(value) == "function" then
                    message ..= (if not inverse then "did not threw " else "threw ")..tostring(errMsg)
                    local scs, err = value()
                    local result
                    if not scs and errMsg then
                        if err == errMsg then
                            result = inverse or false
                        else
                            result = inverse or true
                        end
                    elseif not scs then
                        result = inverse or true
                    end

                    if not result then
                        return error(message)
                    end
                else
                    return error "not a function"
                end
            end
        }, {
            __index = function(self, key)
                if key == "never" then
                    inverse = true
                    return self
                elseif key == "be" then
                    return self
                end
            end
        })
    }
end

Check.describe "this test" (function()
    Check.it "should return true"  (function()
        Check.expect(true).to.equal(true)
    end)

    Check.it "should not return true"  (function()
        print(Check.expect(false).to)
        Check.expect(false).to.never.equal(true)
    end)
end)

return Check
