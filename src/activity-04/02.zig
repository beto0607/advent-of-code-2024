const std = @import("std");
pub fn main() !void {
    // const file_name = "example.txt";
    const file_name = "input.txt";
    const data = loadInput(file_name) catch return;
    if (data) |d| {
        var sum: u64 = 0;

        for (d, 0..) |row, y| {
            for (row, 0..) |char, x| {
                if (char == 'A') {
                    if (isX_MASMiddlePoint(d, x, y)) {
                        sum += 1;
                    }
                }
                // if (char == 'X') {
                //     sum += getNumberOfXMASStartingAt(d, x, y);
                // }
            }
        }

        std.debug.print("\n Sum:{d}\n", .{sum});
    }
}

fn isX_MASMiddlePoint(data: [][]u8, x: usize, y: usize) bool {
    // edges
    if ((x < 1 or x + 1 >= data.len) or (y < 1 or y + 1 >= data.len)) {
        return false;
    }
    const forward_diag =
        (data[y - 1][x + 1] == 'S' and data[y + 1][x - 1] == 'M') or
        (data[y - 1][x + 1] == 'M' and data[y + 1][x - 1] == 'S');
    const backward_diag =
        (data[y - 1][x - 1] == 'S' and data[y + 1][x + 1] == 'M') or
        (data[y - 1][x - 1] == 'M' and data[y + 1][x + 1] == 'S');
    return forward_diag and backward_diag;
}

fn loadInput(file_name: []const u8) !?[][]u8 {
    const dir = std.fs.cwd();
    var file = dir.openFile(file_name, .{ .mode = std.fs.File.OpenMode.read_only }) catch return undefined;
    defer file.close();
    const file_reader = file.reader();
    var result = std.ArrayList([]u8).init(std.heap.page_allocator);
    var buf: [150]u8 = undefined;
    while (file_reader.readUntilDelimiterOrEof(&buf, '\n') catch return undefined) |line| {
        var row = std.ArrayList(u8).init(std.heap.page_allocator);

        for (line) |char| {
            try row.append(char);
        }

        try result.append(row.items);
    }
    return result.items;
}
