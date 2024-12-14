const std = @import("std");
const print = @import("std").debug.print;

pub fn main() !void {
    const input = try loadFile("input.txt");

    var left_values: [1000]u32 = input[0];
    var right_values: [1000]u32 = input[1];

    std.sort.insertion(u32, &left_values, {}, std.sort.asc(u32));
    std.sort.insertion(u32, &right_values, {}, std.sort.asc(u32));

    var i: u16 = 0;
    var sum: i64 = 0;

    while (i < 1000) {
        const difference = try std.math.sub(i33, right_values[i], left_values[i]);
        sum += @abs(difference);
        i += 1;
    }
    print("Value: {d}\n", .{sum});
}

fn splitLine(line: []u8) [2]u32 {
    var result: [2]u32 = .{ 0, 0 };
    var split_iterator = std.mem.splitScalar(u8, line, ' ');
    var i: u8 = 0;
    while (split_iterator.next()) |chunk| {
        if (chunk.len == 0) {
            continue;
        }
        const value = std.fmt.parseInt(u32, chunk, 10) catch 0;
        result[i] = value;
        i += 1;
        if (i == 2) {
            break;
        }
    }
    return result;
}

fn loadFile(file_name: []const u8) ![2][1000]u32 {
    const dir = std.fs.cwd();
    var file = try dir.openFile(file_name, .{ .mode = std.fs.File.OpenMode.read_only });
    defer file.close();

    const file_reader = file.reader();
    var buf: [14]u8 = undefined;

    var i: u16 = 0;
    var left_values: [1000]u32 = undefined;
    var right_values: [1000]u32 = undefined;
    while (try file_reader.readUntilDelimiterOrEof(&buf, '\n')) |line| {
        const values = splitLine(line);
        left_values[i] = values[0];
        right_values[i] = values[1];
        i += 1;
    }
    return .{ left_values, right_values };
}
