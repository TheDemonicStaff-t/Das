const std = @import("std");
const lines = @import("lines.zig");
const comp = @import("comp.zig");
// imported functions
const dbg = std.debug.print;
const parseIntSizeSuffix = std.fmt.parseIntSizeSuffix;
const parseInt = std.fmt.parseInt;
// imported structs
const Line = lines.Line;
const CodeFile = lines.CodeFile;
const Compiler = comp.Compiler;
// imported values
const alloc = std.heap.c_allocator;

pub fn main() !void {
    // create compiler
    var cmp = Compiler{ .a = alloc, .sym_dump = null };
    var ifname_found = false;
    var ofname_found = false;
    // initialize arg itterator
    var argItter = try std.process.argsWithAllocator(alloc);
    defer argItter.deinit();
    _ = argItter.next();
    var a = argItter.next();

    // find args
    while (a != null) : (a = argItter.next()) {
        var arg = a orelse break;
        if (arg[0] == '-') {
            switch (arg[1]) {
                'm' => {
                    // set the memory limit
                    if (arg.len > 2) {
                        cmp.mem_limit = try parseIntSizeSuffix(arg[2..], 10);
                    } else cmp.mem_limit = try parseIntSizeSuffix(argItter.next().?, 10);
                },
                'p' => {
                    // set the pass limit
                    if (arg.len > 2) {
                        cmp.pass_limit = try parseInt(u16, arg[2..], 1);
                    } else cmp.pass_limit = try parseInt(u16, argItter.next().?, 1);
                },
                's' => {
                    // create a symbol dump file
                    if (arg.len > 2) {
                        cmp.sym_dump = arg[2..];
                    } else cmp.sym_dump = argItter.next();
                },
                else => return error.undefinedArg,
            }
        } else {
            // find input and output files
            if (!ifname_found) {
                ifname_found = true;
                cmp.in_fname = arg;
            } else if (!ofname_found) {
                ofname_found = true;
                cmp.out_fname = arg;
            } else {
                return error.extraArgsError;
            }
        }
    }

    // start compiler (find files)
    try cmp.init();

    // read through lines of each file
    for (cmp.files) |f| {
        dbg("{s}:len{d}/ lines({d})\n", .{ f.fname, f.text.len, f.lines[f.lines.len - 1].ln });
        for (f.lines) |l| dbg("{d}({d}):{s}\n", .{ l.ln, l.line.len, l.line });
    }
    defer cmp.deinit();
}
