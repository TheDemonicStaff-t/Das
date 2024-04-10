const std = @import("std");
const lines = @import("lines.zig");
// imported structs
const Line = lines.Line;
const CodeFile = lines.CodeFile;
const Allocator = std.mem.Allocator;
// imported functions
const eql = std.mem.eql;
const dbg = std.debug.print;

pub const Compiler = struct {
    in_fname: []const u8 = undefined,
    out_fname: []const u8 = undefined,
    files: []CodeFile = undefined,
    a: Allocator,
    mem_limit: usize = 1024 * 1024 * 16,
    pass_limit: u16 = 100,
    sym_dump: ?[]const u8,

    pub fn init(self: *Compiler) !void {
        // reallocate for file
        self.*.files = try self.*.a.alloc(CodeFile, 1);
        try self.parse_files();
    }

    pub fn parse_files(self: *Compiler) !void {
        // parse file
        self.*.files[0] = try CodeFile.initAlloc(self.*.in_fname, self.*.a);

        // search for other included files
        for (self.*.files[0].lines) |line| {
            for (line.line, 0..) |c, i| {
                if (c == 'i' and line.line.len > i + 10) {
                    if (eql(u8, "include", line.line[i .. i + 7])) {
                        dbg("include detected:{s}:{d}:{d}: {s}\n", .{ self.*.files[0].fname, line.ln, i, line.line });
                        var tmp_i = i + 7;
                        // find new file name
                        while (line.line[tmp_i] != '\'') {
                            tmp_i += 1;
                            if (tmp_i >= line.line.len) {
                                try self.*.files[0].err("File name started but never finalized.", line.ln, i + tmp_i);
                                return error.IncompleteFname;
                            }
                        }
                        tmp_i += 1;
                        var start = tmp_i;
                        while (line.line[tmp_i] != '\'' and tmp_i < line.line.len) {
                            tmp_i += 1;
                        }

                        // verify filename is new
                        var tst = false;
                        for (self.*.files) |f| {
                            tst = tst or eql(u8, f.fname, line.line[start..tmp_i]);
                        }

                        // parse lines
                        if (!tst) try self.parse_file(line.line[start..tmp_i], self.*.files.len);
                    }
                }
            }
        }
    }

    pub fn parse_file(self: *Compiler, fname: []const u8, index: usize) !void {
        // parse file
        self.*.files = try self.*.a.realloc(self.*.files, self.*.files.len + 1);
        self.*.files[index] = try CodeFile.initAlloc(fname, self.*.a);

        // search for other included files
        for (self.*.files[0].lines) |line| {
            for (line.line, 0..) |c, i| {
                if (c == 'i' and line.line.len > i + 10) {
                    if (eql(u8, "include", line.line[i .. i + 7])) {
                        var tmp_i = i + 7;
                        // find new file name
                        while (line.line[tmp_i] != '\'') {
                            tmp_i += 1;
                            if (tmp_i >= line.line.len) {
                                try self.*.files[0].err("File name started but never finalized.", line.ln, i + tmp_i);
                                return error.IncompleteFname;
                            }
                        }
                        tmp_i += 1;
                        var start = tmp_i;
                        while (line.line[tmp_i] != '\'' and tmp_i < line.line.len) {
                            tmp_i += 1;
                        }

                        // verify new file found
                        var tst = false;
                        for (self.*.files) |f| {
                            tst = tst or eql(u8, f.fname, line.line[start..tmp_i]);
                        }

                        // parse new file
                        if (!tst) try self.parse_file(line.line[start..tmp_i], self.*.files.len);
                    }
                }
            }
        }
    }

    pub fn deinit(self: *Compiler) void {
        for (0..self.*.files.len) |i| {
            self.*.files[i].deinit();
        }
        self.*.a.free(self.*.files);
    }
};
