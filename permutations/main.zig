const std = @import("std");

const allocator = std.heap.page_allocator;

/// Combinations returns combinations of k elements for a given slice.
/// Refer to https://github.com/mxschmitt/golang-combinations.
pub fn Combinations(comptime T: type, set: []T, k: usize) ![][]T {
    var subsets = std.ArrayList([]T).init(allocator);
    defer subsets.deinit();

    var length: usize = set.len;
    var n = k;
    if (k > set.len) n = set.len;

    // Go through all possible combinations of objects
    // from 1 (only first object in subset) to 2^length (all objects in subset)
    var subsetBits: usize = 1;
    while (subsetBits < (@as(usize, 1) << @intCast(u6, length))) : (subsetBits += 1) {
        if (n > 0 and @popCount(subsetBits) != n) continue;

        var subset = std.ArrayList(T).init(allocator);
        defer subset.deinit();

        var object: usize = 0;
        while (object < length) : (object += 1) {
            // checks if object is contained in subset
            // by checking if bit 'object' is set in subsetBits
            if ((subsetBits >> @intCast(u6, object)) & 1 == 1) {
                // add object to subset
                try subset.append(set[object]);
            }
        }
        // add subset to subsets
        try subsets.append(subset.toOwnedSlice());
    }
    return subsets.toOwnedSlice();
}

pub fn Permute(arr: []isize) ![][]isize {
    var ret = std.ArrayList([]isize).init(allocator);
    defer ret.deinit();

    try toNext(arr, 0, &ret);

    return ret.toOwnedSlice();
}

fn toNext(arr: []isize, n: usize, ret: *std.ArrayList([]isize)) !void {
    if (n == arr.len - 1) {
        var tmp = try allocator.alloc(isize, arr.len);
        std.mem.copy(isize, tmp, arr);
        try ret.append(tmp);
    }
    var i: usize = n;
    while (i < arr.len) : (i += 1) {
        std.mem.swap(isize, &arr[i], &arr[n]);
        try toNext(arr, n + 1, ret);
        std.mem.swap(isize, &arr[i], &arr[n]);
    }
}

pub fn Permutations(arr: []isize, k: usize) ![][]isize {
    var ret = std.ArrayList([]isize).init(allocator);
    defer ret.deinit();

    const _ret = try Combinations(isize, arr, k);
    for (_ret) |v| try ret.appendSlice(try Permute(v));

    return ret.toOwnedSlice();
}

pub fn main() !void {
    var arr = [_]isize{ 3, 4, 6, 10, 15, 17 };
    var ret = try Permutations(&arr, 2);
    std.debug.print("{}\n", .{ret.len});
    std.debug.print("{any}\n", .{ret});
}
