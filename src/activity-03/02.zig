const std = @import("std");
pub fn main() !void {
    const dir = std.fs.cwd();
    var file = try dir.openFile("input.txt", .{ .mode = std.fs.File.OpenMode.read_only });
    defer file.close();
    const file_reader = file.reader();

    var mul_enabled = true;
    var sum: u64 = 0;
    var next_byte = try file_reader.readByte();

    for (0..99999) |_| {
        // while ((file_reader.readByte() catch null)) |byte| {
        // var next_byte = byte;

        if (next_byte == 'd') {
            next_byte = try file_reader.readByte();
            if (next_byte == 'o') {
                next_byte = try file_reader.readByte();
                if (next_byte == '(') {
                    next_byte = try file_reader.readByte();
                    if (next_byte == ')') {
                        mul_enabled = true;
                        next_byte = try file_reader.readByte();
                        continue;
                    }
                } else if (next_byte == 'n') {
                    next_byte = try file_reader.readByte();
                    if (next_byte == '\'') {
                        next_byte = try file_reader.readByte();
                        if (next_byte == 't') {
                            next_byte = try file_reader.readByte();
                            if (next_byte == '(') {
                                next_byte = try file_reader.readByte();
                                if (next_byte == ')') {
                                    mul_enabled = false;
                                    next_byte = try file_reader.readByte();
                                    continue;
                                }
                            }
                        }
                    }
                }
            }
        }
        if (next_byte != 'm') {
            next_byte = file_reader.readByte() catch break;
            continue;
        }
        next_byte = try file_reader.readByte();
        if (next_byte != 'u') {
            continue;
        }
        next_byte = try file_reader.readByte();
        if (next_byte != 'l') {
            continue;
        }
        next_byte = try file_reader.readByte();
        if (next_byte != '(') {
            continue;
        }
        var first_num: usize = 0;
        var discard: bool = false;
        for (0..3) |_| {
            if (file_reader.readByte() catch null) |number_byte| {
                if (number_byte >= '0' and number_byte <= '9') {
                    first_num = first_num * 10 + (number_byte - '0');
                    continue;
                }
                discard = number_byte != ',';
                break;
            } else {
                discard = true;
                break;
            }
        }
        if (discard) {
            continue;
        }
        var second_number: usize = 0;
        for (0..5) |i| {
            if (file_reader.readByte() catch null) |number_byte| {
                // ignore first character if it's ,
                if (number_byte == ',' and i == 0) {
                    continue;
                }
                if (number_byte >= '0' and number_byte <= '9') {
                    second_number = second_number * 10 + (number_byte - '0');
                    continue;
                }
                discard = number_byte != ')';
                break;
            } else {
                discard = true;
                break;
            }
        }
        if (discard) {
            continue;
        }

        if (mul_enabled) {
            std.debug.print("first_num:{d} ", .{first_num});
            std.debug.print("second_number:{d}\n", .{second_number});
            sum += first_num * second_number;
        }
    }

    std.debug.print("\n Sum:{d}\n", .{sum});
}
