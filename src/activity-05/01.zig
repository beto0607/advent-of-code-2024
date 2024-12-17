const std = @import("std");

pub fn main() !void {
    const dir = std.fs.cwd();
    // var file = try dir.openFile("example.txt", .{ .mode = std.fs.File.OpenMode.read_only });
    var file = try dir.openFile("input.txt", .{ .mode = std.fs.File.OpenMode.read_only });
    defer file.close();

    const file_reader = file.reader();
    var buf: [80]u8 = undefined;

    var rules = std.AutoHashMap(u32, std.ArrayList(u8)).init(std.heap.page_allocator);
    defer rules.deinit();

    // rules
    while (try file_reader.readUntilDelimiterOrEof(&buf, '\n')) |line| {
        if (line.len == 0) {
            break;
        }
        const rule = splitRule(line);
        const from = rule[0];
        const to = rule[1];

        const list = rules.getOrPut(from) catch return;
        if (!list.found_existing) {
            list.value_ptr.* = std.ArrayList(u8).init(std.heap.page_allocator);
        }
        list.value_ptr.append(to) catch return;
    }

    var sum: u32 = 0;

    // updates
    while (try file_reader.readUntilDelimiterOrEof(&buf, '\n')) |line| {
        const update = splitUpdate(line);
        var isValid = true;
        for (update, 0..) |item, i| {
            if (i == 0) {
                continue;
            }
            const rule = rules.get(item) orelse continue;

            for (0..i) |j| {
                for (rule.items) |ruleItem| {
                    if (ruleItem == update[j]) {
                        isValid = false;
                        break;
                    }
                }
                if (!isValid) {
                    break;
                }
            }
            if (!isValid) {
                break;
            }
        }
        if (isValid) {
            sum += update[update.len / 2];
        }
    }
    std.debug.print("Sum: {d}\n", .{sum});
}

fn splitRule(line: []u8) [2]u8 {
    var result: [2]u8 = .{ 0, 0 };
    var split_iterator = std.mem.splitScalar(u8, line, '|');
    var i: u8 = 0;
    while (split_iterator.next()) |chunk| {
        if (chunk.len == 0) {
            continue;
        }
        const value = std.fmt.parseInt(u8, chunk, 10) catch 0;
        result[i] = value;
        i += 1;
        if (i == 2) {
            break;
        }
    }
    return result;
}

fn splitUpdate(line: []u8) []u8 {
    var result = std.ArrayList(u8).init(std.heap.page_allocator);
    var split_iterator = std.mem.splitScalar(u8, line, ',');
    while (split_iterator.next()) |chunk| {
        if (chunk.len == 0) {
            continue;
        }
        const value = std.fmt.parseInt(u8, chunk, 10) catch 0;
        result.append(value) catch break;
    }
    return result.items;
}
