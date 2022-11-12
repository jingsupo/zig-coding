//! 搜索矩阵中连续为1最多的区域的元素个数
//! 连续的定义：上下左右相邻

const std = @import("std");

const allocator = std.heap.page_allocator;

const SearchContinuousRegions = struct {
    arr: [][]usize,
    elem: *std.ArrayList([]usize),
    rows: usize = 0,
    cols: usize = 0,

    const Self = @This();

    var elem_ = std.ArrayList([]usize).init(allocator);

    fn init(_arr: ?*std.ArrayList([]usize)) !Self {
        var arr_ = std.ArrayList([]usize).init(allocator);
        defer arr_.deinit();
        if (_arr) |v| {
            arr_ = v.*;
            std.debug.print("111\n", .{});
        } else {
            var a = [_]usize{ 1, 0, 0, 1, 0 };
            var b = [_]usize{ 1, 0, 1, 0, 0 };
            var c = [_]usize{ 0, 0, 1, 0, 1 };
            var d = [_]usize{ 1, 0, 1, 0, 1 };
            var e = [_]usize{ 1, 0, 1, 1, 0 };
            var arr = [_][]usize{ &a, &b, &c, &d, &e };
            for (arr) |v| {
                try arr_.append(try allocator.dupe(usize, v)); //关键
            }
            std.debug.print("222\n", .{});
        }
        var arr = arr_.toOwnedSlice();
        var rows = arr.len;
        var cols = arr[0].len;
        return .{ .arr = arr, .elem = &elem_, .rows = rows, .cols = cols };
    }

    fn reset(self: Self, row: usize, col: usize) !void {
        // 置为0
        self.arr[row][col] = 0;
        // 保存当前元素的行列索引
        var index = [_]usize{ row, col };
        try self.elem.append(try allocator.dupe(usize, &index)); //关键
        // 上
        if (@intCast(isize, row) - 1 >= 0 and self.arr[row - 1][col] == 1) try self.reset(row - 1, col);
        // 下
        if (row + 1 <= self.rows - 1 and self.arr[row + 1][col] == 1) try self.reset(row + 1, col);
        // 左
        if (@intCast(isize, col) - 1 >= 0 and self.arr[row][col - 1] == 1) try self.reset(row, col - 1);
        // 右
        if (col + 1 <= self.cols - 1 and self.arr[row][col + 1] == 1) try self.reset(row, col + 1);
    }

    fn search(self: Self) !struct { num: usize, ret: [][][]usize } {
        // 连续为1的区域的数量
        var num: usize = 0;
        // 每个连续为1的区域内的元素的行列索引
        var ret = std.ArrayList([][]usize).init(allocator);
        defer ret.deinit();
        var i: usize = 0;
        while (i < self.rows) : (i += 1) {
            var j: usize = 0;
            while (j < self.cols) : (j += 1) {
                if (self.arr[i][j] == 1) {
                    try self.reset(i, j);
                    try ret.append(self.elem.toOwnedSlice()); //同时清空elem以供下个区域使用
                    num += 1;
                }
            }
        }
        return .{ .num = num, .ret = ret.toOwnedSlice() };
    }

    fn run(self: Self) !void {
        var result = try self.search();
        var count_ = std.ArrayList(usize).init(allocator);
        defer count_.deinit();
        for (result.ret) |v| {
            try count_.append(v.len);
        }
        var count = count_.toOwnedSlice();
        var maxCount = blk: {
            var max: usize = 0;
            for (count) |v| {
                if (max < v) {
                    max = v;
                }
            }
            break :blk max;
        };
        std.debug.print("连续为1的区域的数量为：{}\n", .{result.num});
        std.debug.print("每个连续为1的区域内的元素的行列索引为：{any}\n", .{result.ret});
        std.debug.print("连续为1的区域内元素个数最多为：{}\n", .{maxCount});
    }
};

pub fn main() !void {
    var a = [_]usize{ 1, 0, 0, 1, 0 };
    var b = [_]usize{ 1, 0, 1, 0, 0 };
    var c = [_]usize{ 0, 0, 1, 0, 1 };
    var d = [_]usize{ 1, 0, 1, 0, 1 };
    var e = [_]usize{ 1, 0, 1, 1, 0 };
    var arr_ = [_][]usize{ &a, &b, &c, &d, &e };
    var arr = std.ArrayList([]usize).fromOwnedSlice(allocator, &arr_);
    var scr = try SearchContinuousRegions.init(&arr);
    try scr.run();
    var scr_ = try SearchContinuousRegions.init(null);
    try scr_.run();
}
