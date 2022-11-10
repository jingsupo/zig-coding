//! DP算法（动态规划）。DP算法适用于前一步决策影响后一步决策的问题。

const std = @import("std");

/// 假设有一个6 * 6的棋盘，每个格子里面有一个奖品（每个奖品的价值在100到1000之间），现在要求从左上角开始到右下角结束，
/// 每次只能往右或往下走一个格子，所经过的格子里的奖品归自己所有。问最多能收集价值多少的奖品。
pub fn DynamicProgramming() void {
    var r = std.rand.DefaultPrng.init(@intCast(u64, std.time.nanoTimestamp()));

    var arr = [_][6]usize{[_]usize{0} ** 6} ** 6;
    var i: usize = 0;
    while (i < 6) : (i += 1) {
        var j: usize = 0;
        while (j < 6) : (j += 1) {
            arr[i][j] = r.random().intRangeAtMost(usize, 100, 1000);
        }
    }
    std.debug.print("随机生成一个6*6的二维数组作为棋盘中的权值: \n{any}\n", .{arr});

    // 将第一行和第一列的格子向右或向下累加
    i = 1;
    while (i < 6) : (i += 1) {
        // 除了第一个格子，其余格子的值为前一个格子的值加当前格子的值，
        // 因此，横向的a[i][j]应该取a[i][j-1] + a[i][j], 纵向的a[i][j]应该取a[i-1][j] + a[i][j]。
        arr[0][i] = arr[0][i - 1] + arr[0][i];
        arr[i][0] = arr[i - 1][0] + arr[i][0];
    }
    // 计算每个格子的最大值
    i = 1;
    while (i < 6) : (i += 1) {
        var j: usize = 1;
        while (j < 6) : (j += 1) {
            // 右下角格子的决策取决于其左边和上边的最优决策，因此，右下角a[i][j]只需要取max(a[i-1][j], a[i][j-1]) + a[i][j]。
            arr[i][j] = @max(arr[i - 1][j], arr[i][j - 1]) + arr[i][j];
        }
    }
    std.debug.print("变化后的数组: \n{any}\n", .{arr});
}

pub fn main() void {
    DynamicProgramming();
}
