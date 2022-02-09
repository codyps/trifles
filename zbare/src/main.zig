const std = @import("std");

export var stack_bytes: [16 * 1024]u8 align(16) linksection(".bss") = undefined;
const stack_bytes_slice = stack_bytes[0..];

export fn _start() callconv(.Naked) noreturn {
    @call(.{ .stack = stack_bytes_slice }, kmain, .{});
}
pub fn panic(_: []const u8, _: ?*std.builtin.StackTrace) noreturn {
    while (true) {}
}

fn kmain() noreturn {
    var i: usize = 1;
    var acc: usize = 0;
    while (true) {
        acc +%= i;
        if (i > 6_0000_0000) {
            break;
        }
        i += 1;
    }
    unreachable;
}
