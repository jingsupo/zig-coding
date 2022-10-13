const clib = @cImport({
    @cInclude("add.c");
});
const std = @import("std");
const testing = std.testing;
export const num: i32 = 100;

pub export fn add(a: i32, b: i32) i32 {
    return a + b;
}

pub fn main() !void {
    std.debug.print("{}\n", .{666});
}

test "basic add functionality" {
    try testing.expectEqual(@as(i32, 10), clib.c_add(3, 7));
    try testing.expectEqual(@as(i32, 10), add(3, 7));
}

test "counting bytes in C" {
    try testing.expectEqual(@as(i32, 3), clib.count_bytes("ABC"));
}
