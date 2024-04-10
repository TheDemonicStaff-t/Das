const std = @import("std");
const list = @import("list.zig");
const token = @import("token.zig");
// imported values
const cwd = std.fs.cwd();
const stderr = std.io.getStdErr().writer();
const c_allocator = std.heap.c_allocator;
const TType = token.TType;
// imported structs
const Allocator = std.mem.Allocator;
const Dir = std.fs.Dir;
const File = std.fs.File;
const OpenFlags = File.OpenFlags;
const Token = token.Token;
const TData = token.TData;
// imported functions
const List = list.List;
const expect = std.testing.expect;
const eql = std.mem.eql;

pub const Line = struct { ln: usize, line: []u8 };
pub const CodeFile = struct {
    fname: []const u8,
    text: []u8,
    lines: []Line,
    toks: []Token,
    a: Allocator = c_allocator,
    pub fn init(fname: []const u8) !CodeFile {
        // generate first file base data
        var f: File = try cwd.openFile(fname, .{ .mode = .read_only });
        var cf = CodeFile{
            .fname = fname,
            .text = try f.readToEndAlloc(.a, 1000000000),
            .lines = null,
            .toks = null,
        };

        // find lines
        try cf.findLInes();
        return cf;
    }
    pub fn initAlloc(fname: []const u8, a: Allocator) !CodeFile {
        // init with specified allocator
        var f: File = try cwd.openFile(fname, .{ .mode = .read_only });
        var cf = CodeFile{
            .fname = fname,
            .a = a,
            .text = try f.readToEndAlloc(a, 1000000000),
            .lines = undefined,
        };

        // find lines
        try cf.findLines();
        return cf;
    }

    pub fn findLines(self: *CodeFile) !void {
        // initial variables
        var start: usize = 0;
        var lines = try List(Line).init(self.*.a);
        var ln: usize = 1;
        for (self.*.text, 0..) |c, i| {
            // detect end of lines
            if (c == '\n') {
                if (start != i) {
                    // add if line is empty
                    try lines.add(Line{ .ln = ln, .line = self.*.text[start..i] });
                }
                // adjust ln and start
                ln += 1;
                start = i + 1;
            }
        }
        // make sure all lines are found before continuing
        if (start != self.*.text.len) try lines.add(Line{ .ln = ln, .line = self.*.text[start..self.*.text.len] });
        self.*.lines = try lines.toArray();
    }

    pub fn findTokens(self: *CodeFile) !void {}

    pub fn err(self: *CodeFile, err_msg: []const u8, ln: usize, idx: usize) !void {
        // ERROR FORMAT:
        // fname:line_number:index: error
        // this is the line in question
        //             ^~~~~~ (points to the error index)
        try stderr.print("error:{s}:{d}:{d}: {s}\n{s}\n", .{ self.*.fname, ln, idx, err_msg, self.*.lines[ln - 1].line });
        for (0..idx) |_| {
            try stderr.print(" ", .{});
        }
        try stderr.print("^~~~~\n", .{});
    }

    pub fn deinit(self: *CodeFile) void {
        self.*.a.free(self.*.lines);
        self.*.a.free(self.*.text);
    }
    test init {
        var f = try CodeFile.init();
        f.deinit();
    }
    test findLines {
        var tmp_data =
            \\ this is a test
            \\ that should be processed
            \\
            \\ correctly
        ;
        var f = CodeFile{
            .fname = "test.asm",
            .text = tmp_data,
            .lines = null,
        };
        f.findLines();
        defer f.deinit();
        try expect(eql(u8, f.lines[0], "this is a test"));
        try expect(f.lines[3].ln == 4);
    }
};
