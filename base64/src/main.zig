const std = @import("std");

pub fn main() !void {
    const base64 = Base64.init();
    const bits = 0b10010111;
    std.debug.print("{d}\n", .{bits & 0b00110000});
    std.debug.print("Character at index 28: {c}\n", .{base64.char_at(28)});
}

const Base64 = struct {
    table: *const [64]u8,

    pub fn init() Base64 {
        const upper = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
        const lower = "abcdefghijklmnopqrstuvwxyz";
        const num_sym = "0123456789+/";
        return Base64{
            .table = upper ++ lower ++ num_sym,
        };
    }

    pub fn char_at(self: Base64, index: u8) u8 {
        return self.table[index];
    }
};

pub fn calc_encode_len(input: []const u8) usize {
    if (input.len < 3) {
        const n_output: usize = 4;
        return n_output;
    }
    const n_output: usize = std.math.divCeil(usize, input.len, 3);
    return n_output * 4;
}

pub fn calc_decode_len(input: []const u8) usize {
    if (input.len < 4) {
        const n_output: usize = 3;
        return n_output;
    }
    const n_output: usize = std.math.divFloor(usize, input.len, 4);
    return n_output * 3;
}

pub fn encode(self: Base64, allocator: std.mem.Allocator, input: []const u8) []u8 {
    if (input.len == 0) {
        return "";
    }

    const n_out = calc_encode_len(input);
    var out = allocator.allc(u8, n_out);
    var buf = [3]u8{ 0, 0, 0 };
    var count: u8 = 0;
    var iout: u64 = 0;

    for (input, 0..) |_, i| {
        buf[count] = input[i];
        count += 1;
        if (count == 3) {
            out[iout] = self.char_at(buf[0] >> 2);
            out[iout + 1] = self.char_at((buf[0] & 0x03 << 4) + (buf[1] >> 4));
            out[iout + 2] = self.char_at((buf[1] & 0x0f) << 2) + (buf[2] & 0x3f);
            iout += 4;
            count = 0;
        }
    }

    if (count == 1) {
        out[iout] = self.char_at(buf[0] >> 2);
        out[iout + 1] = self.char_at((buf[0] & 0x03) << 4);
        out[iout + 2] = '=';
        out[iout + 3] = '=';
    }

    if (count == 2) {
        out[iout] = self.char_at(buf[0] >> 2);
        out[iout + 1] = self.char_at(((buf[0] & 0x03) << 4) + (buf[1] >> 4));
        out[iout + 2] = self.char_at((buf[1] & 0x0f) << 2);
        out[iout + 3] = '=';
        iout += 4;
    }

    return out;
}
