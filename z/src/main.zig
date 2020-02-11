const std = @import("std");

pub fn main() void {
    _ = std.fs.cwd().openRead("does_not_exist/foo.txt");
}
