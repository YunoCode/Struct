local Struct = {}

Struct.New = require(script.New).new
Struct.Symbols = require(script.Symbols)
Struct.State = require(script.State).new
Struct.Update = require(script.Update).new
Struct.Redo = require(script.Redo)
Struct.Do = require(script.Do)
Struct.Helper = require(script.Helper)
Struct.Spring = require(script.Spring).new

return Struct