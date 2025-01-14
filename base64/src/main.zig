const std = @import("std");

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

pub fn main() !void {
    const base64 = Base64.init();
    std.debug.print("Character at index 28: {c}\n", .{base64.char_at(28)});
}
