pub const Instruction = struct {
    type: enum {},
    inst: union {
        psuedo: psuedoInstructions,
        x64: x86_64Instructions,
        pub const psuedoInstructions = enum {
            // reserve data
            RB,
            RW,
            RD,
            RP,
            RF,
            RQ,
            RT,
            // define data
            DB,
            DW,
            DU,
            DD,
            DP,
            DF,
            DQ,
            DT,
            FILE,
        };
        pub const x86_64Instructions = enum {
            // D(B, W, D) = *
            // data movement instructions
            MOV, // *
            XCHG, // *
            PUSH, // D(W, D)
            PUSHW, //W
            PUSHD, //D
            PUSHA, // D(W, D)
            PUSHAW, //W
            PUSHAD, //D
            POP, // D(W, D)
            POPW, //W
            POPD, //D
            POPA, // D(W, D)
            POPAW, //W
            POPAD, //D
            // type conversion instructions
            CBW, //B
            CWD, //W
            CWDE,
            CDQ, //D
            MOVSX, // D(B, W)
            MOVZX, // D(B, W)
            // arithmatic instructions
            ADD, // *
            ADC, // *
            INC, // *
            SUB, // *
            SBB, // *
            DEC, // *
            CMP, // *
            NEG, // *
            XADD, // *
            MUL, // *
            IMUL, // *
            DIV, // *
            IDIV, // *
            // floating point arithmatic

        };
    },
};
