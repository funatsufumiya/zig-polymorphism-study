const std = @import("std");
const lib = @import("lib.zig");

pub fn main() !void {
    std.debug.print("(This main does nothing. Please run `zig build test`)\n", .{});
}
