const std = @import("std");
pub fn main() !void {
    // const file_name = "example.txt";
    const file_name = "input.txt";
    const data = loadInput(file_name) catch return;
    if (data) |d| {
        var sum: u64 = 0;

        for (d, 0..) |row, y| {
            for (row, 0..) |char, x| {
                if (char == 'X') {
                    sum += getNumberOfXMASStartingAt(d, x, y);
                }
            }
        }

        std.debug.print("\n Sum:{d}\n", .{sum});
    }
}

fn getNumberOfXMASStartingAt(data: [][]u8, x: usize, y: usize) u8 {
    var result: u8 = 0;
    // Horizontal - LTR
    if (x + 3 < data[y].len) {
        if (data[y][x + 1] == 'M' and
            data[y][x + 2] == 'A' and
            data[y][x + 3] == 'S')
        {
            result += 1;
        }
    }
    // Horizontal - RTL
    if (x >= 3) {
        if (data[y][x - 1] == 'M' and
            data[y][x - 2] == 'A' and
            data[y][x - 3] == 'S')
        {
            result += 1;
        }
    }
    // Vertical - TopToBottom
    if (y + 3 < data.len) {
        if (data[y + 1][x] == 'M' and
            data[y + 2][x] == 'A' and
            data[y + 3][x] == 'S')
        {
            result += 1;
        }
    }
    // Vertical - BottomToTop
    if (y >= 3) {
        if (data[y - 1][x] == 'M' and
            data[y - 2][x] == 'A' and
            data[y - 3][x] == 'S')
        {
            result += 1;
        }
    }
    // Diagonally - "forward slash" LTR
    if (y >= 3 and x + 3 < data.len) {
        if (data[y - 1][x + 1] == 'M' and
            data[y - 2][x + 2] == 'A' and
            data[y - 3][x + 3] == 'S')
        {
            result += 1;
        }
    }
    // Diagonally - "forward slash" RTL
    if (y + 3 < data.len and x >= 3) {
        if (data[y + 1][x - 1] == 'M' and
            data[y + 2][x - 2] == 'A' and
            data[y + 3][x - 3] == 'S')
        {
            result += 1;
        }
    }
    // Diagonally - "backwards slash" LTR
    if (y + 3 < data.len and x + 3 < data.len) {
        if (data[y + 1][x + 1] == 'M' and
            data[y + 2][x + 2] == 'A' and
            data[y + 3][x + 3] == 'S')
        {
            result += 1;
        }
    }
    // Diagonally - "backwards slash" RTL
    if (y >= 3 and x >= 3) {
        if (data[y - 1][x - 1] == 'M' and
            data[y - 2][x - 2] == 'A' and
            data[y - 3][x - 3] == 'S')
        {
            result += 1;
        }
    }
    return result;
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
