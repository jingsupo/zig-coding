const std = @import("std");
const expect = std.testing.expect;
const print = std.debug.print;

pub fn main() !void {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();

    const allocator = arena.allocator();

    const file_path = "tmp.txt";
    const out_path = "out.txt";

    const cwd = std.fs.cwd(); //不能在函数最外层声明，否则报错

    const in_file = try cwd.openFile(file_path, .{ .mode = .read_only });
    defer in_file.close();
    const out_file = try cwd.createFile(out_path, .{ .read = true, .truncate = false });
    defer out_file.close();

    const stat = try in_file.stat();
    var size = stat.size;
    print("Total Size: {}\n", .{size});

    var buf = try allocator.alloc(u8, size + 1);
    defer allocator.free(buf);

    _ = try in_file.readAll(buf);

    const _buf = try cwd.readFileAlloc(allocator, file_path, 10_0000_0000);
    print("{s}\n", .{_buf[0..18]});

    var fbs = std.io.fixedBufferStream(buf);
    const reader = fbs.reader();

    var i: usize = 0;
    while (true) : (i += 1) {
        var line = reader.readUntilDelimiter(buf, '\n') catch break;
        _ = try out_file.write(line);
        _ = try out_file.write("\n");

        if (@mod(i, 10_0000) == 0) {
            print("{}\n", .{i});
        }
    }

    print("{}: Done.\n", .{buf.len});
}
