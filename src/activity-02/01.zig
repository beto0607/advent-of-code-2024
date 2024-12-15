const std = @import("std");
const print = @import("std").debug.print;

pub fn main() !void {
    const dir = std.fs.cwd();
    var file = try dir.openFile("input.txt", .{ .mode = std.fs.File.OpenMode.read_only });
    defer file.close();

    const file_reader = file.reader();
    var buf: [50]u8 = undefined;

    var safe_reports: u16 = 0;
    while (try file_reader.readUntilDelimiterOrEof(&buf, '\n')) |line| {
        const values = splitLine(line);
        if (isSafeReport(values)) {
            safe_reports += 1;
        }
    }
    print("Number of safe reports: {d}\n", .{safe_reports});
}

fn splitLine(line: []u8) *std.ArrayList(u32) {
    var list = std.ArrayList(u32).init(std.heap.page_allocator);

    var split_iterator = std.mem.splitScalar(u8, line, ' ');
    while (split_iterator.next()) |chunk| {
        if (chunk.len == 0) {
            continue;
        }
        const value = std.fmt.parseInt(u32, chunk, 10) catch 0;
        list.append(value) catch break;
    }
    return &list;
}

fn isSafeReport(values: *std.ArrayList(u32)) bool {
    const items = values.items;
    if (!isSortedReport(items)) {
        return false;
    }
    if (!hasValidDelta(items)) {
        return false;
    }
    return true;
}

fn hasValidDelta(values: []u32) bool {
    for (values, 0..) |value, i| {
        if (i != 0) {
            std.debug.print("{d} {d} {d}\n", .{ i, value, values[i - 1] });

            const delta = @abs(std.math.sub(i33, value, values[i - 1]) catch return false);
            if (delta < 1 or delta > 3) {
                return false;
            }
        }
    }
    std.debug.print("\n", .{});
    return true;
}

fn isSortedReport(values: []u32) bool {
    return std.sort.isSorted(u32, values, {}, std.sort.asc(u32)) or
        std.sort.isSorted(u32, values, {}, std.sort.desc(u32));
}
