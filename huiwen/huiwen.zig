const std = @import("std");
const print = std.debug.print;
const time = std.time;

fn isHuiwen(n: i32) bool {
    var sn: i32 = n;
    var tn: i32 = 0;
    while (sn != 0) {
        tn = tn * 10 + @mod(sn, 10);
        sn = @divTrunc(sn, 10);
    }
    if (tn == n) {
        return true;
    }
    return false;
}

fn hw() i32 {
    var tx: i32 = 0;
    var i: i32 = 0;
    var max: i32 = 100000000;
    while (i < max) : (i += 1) {
        if (isHuiwen(i) == true) {
            tx += 1;
        }
    }
    return tx;
}

fn runhw() void {
    var s: i64 = time.milliTimestamp();
    var r: i32 = hw();
    var e: i64 = time.milliTimestamp();
    print("Hello, {s} == result::{} -- start::{} -- end::{} -- time::{}!\n", .{ "world", r, s, e, e - s });
}

pub fn main() !void {
    runhw();
}
