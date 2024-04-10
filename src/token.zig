const std = @import("std");
const inst = @import("inst.zig");
// imported structs
const Instruction = inst.Instruction;

pub const Bits = enum { B512, B256, B128, B80, B64, B32, B16, B8 };

pub const TType = enum {
    KEYWORD,
    OPERATOR,
    INSTRUCTION,
    REGISTER,
    INTEGER_LIT,
    FLOAT_LIT,
    STRING_LIT,
    IDENTIFIER,
};

pub const TData = union {
    keyword: Keyword,
    operator: Operator,
    instruction: Instruction,
    register: Register,
    chr: u8,
    float: f64,
    int: i64,
    str: []const u8,
    id: []const u8,
    anon_id: bool, //@@
    const Keyword = enum {
        FORMAT,
        LABEL,
    };
    const Operator = enum {
        // address manipulation
        LBRACE,
        RBRACE,
        PTR,
        COLON,
        // arithmetic operators
        RVA, //p7
        PLT,
        BSF, //p6
        BSR,
        NOT, //p5
        SHL, //p4
        SHR,
        AND, //p3
        OR,
        XOR,
        MOD, //p2
        MUL, //p1
        DIV,
        ADD, //p0
        SUB,
        // memory operators
        BYTE, // 8b
        WORD, // 16b
        DWORD, // 32b
        FWORD, // 48b
        PWORD, // 48b
        QWORD, // 64b
        TBYTE, // 80b
        TWORD, // 80b
        DQWORD, // 128b
        XWORD, // 128b
        QQWORD, // 256b
        YWORD, // 256b
        DQQWORD, // 512b
        ZWORD, // 512b
        // asignment operators
        EQUAL,
        AT,
        // comptime val operators
        CURRENT_OFFSET, //$
        BASE_ADDRESS, //$$
        REP_COUNT, //%
        TIMESTAMP, //%t
        PREV_ANON, //@b @r
        POST_ANON, //@f
        // jump operators
        SHORT,
        NEAR,
        FAR,
    };
    const Register = union {
        gp: enum {
            // 8 bit
            AL,
            CL,
            DL,
            BL,
            AH,
            CH,
            DH,
            BH,
            R8B,
            R9B,
            R10B,
            R11B,
            R12B,
            R13B,
            R14B,
            R15B,
            // 16 bit
            AX, //gp
            CX,
            DX,
            BX,
            SP,
            BP,
            SI,
            DI,
            R8W,
            R9W,
            R10W,
            R11W,
            R12W,
            R13W,
            R14W,
            R15W,
            ES, //seg
            CS,
            SS,
            DS,
            FS,
            GS,
            // 32 bit
            EAX, //gp
            ECX,
            EBX,
            EDX,
            ESP,
            EBP,
            ESI,
            EDI,
            R8D,
            R9D,
            R10D,
            R11D,
            R12D,
            R13D,
            R14D,
            R15D,
            CR0, //ctrl
            CR2,
            CR3,
            CR4,
            DR0, //dbg
            DR1,
            DR2,
            DR3,
            DR6,
            DR7,
            // 64 bit
            RAX, //gp
            RCX,
            RDX,
            RBX,
            RSP,
            RBP,
            RSI,
            RDI,
            R8,
            R9,
            R10,
            R11,
            R12,
            R13,
            R14,
            R15,
            MM0, //mmx
            MM1,
            MM2,
            MM3,
            MM4,
            MM5,
            MM6,
            MM7,
            K0, //opmask
            K1,
            K2,
            K3,
            K4,
            K5,
            K6,
            K7,
            // 80 bit
            ST0, //fpu
            ST1,
            ST2,
            ST3,
            ST4,
            ST5,
            ST6,
            ST7,
            // 128 bit
            XMM0, //sse
            XMM1,
            XMM2,
            XMM3,
            XMM4,
            XMM5,
            XMM6,
            XMM7,
            BND0, //bnd
            BND1,
            BND2,
            BND3,
            // 256 bit
            YMM0, //avx
            YMM1,
            YMM2,
            YMM3,
            YMM4,
            YMM5,
            YMM6,
            YMM7,
            // 512 bit
            ZMM0, //zvx-512
            ZMM1,
            ZMM2,
            ZMM3,
            ZMM4,
            ZMM5,
            ZMM6,
            ZMM7,
        },
    };
};

pub const Token = struct {
    ln: usize,
    idx: usize,
    tok_type: TType,
    tok_data: TData,
};
