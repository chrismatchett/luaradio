local block = require('radio.core.block')
local types = require('radio.types')

local DifferentialDecoderBlock = block.factory("DifferentialDecoderBlock")

function DifferentialDecoderBlock:instantiate(invert)
    self.invert = (invert == nil) and false or invert

    self.prev_bit = types.BitType(0)
    self:add_type_signature({block.Input("in", types.BitType)}, {block.Output("out", types.BitType)})
end

function DifferentialDecoderBlock:process(x)
    local out = types.BitType.vector(x.length)

    for i = 0, x.length-1 do
        if self.invert then
            out.data[i].value = (bit.bxor(self.prev_bit.value, x.data[i].value) + 1) % 2
        else
            out.data[i].value = bit.bxor(self.prev_bit.value, x.data[i].value)
        end

        self.prev_bit.value = x.data[i].value
    end

    return out
end

return {DifferentialDecoderBlock = DifferentialDecoderBlock}
