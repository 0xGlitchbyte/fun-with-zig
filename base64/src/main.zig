const std = @import("std");

const Base64 = struct {
    _table: *const [64]u8,

    pub fn init() Base64 {
        const upper = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
        const lower = "abcdefghijklmnopqrstuvwxyz";
        const num_sym = "0123456789+/";
        return Base64{
            ._table = upper ++ lower ++ num_sym,
        };
    }

    pub fn _char_at(self: Base64, index: u8) u8 {
        return self._table[index];
    }
};

pub fn main() !void {
    const base64 = Base64.init();
    std.debug.print("Character at index 28: {c}\n", .{base64._char_at(28)});
}
