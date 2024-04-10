# REFFERENCES

- zig documentation: https://ziglang.org/documentation/master/
- zig std documentation: https://ziglang.org/documentation/master/std/#A;std
- fasm documentation: https://flatassembler.net/docs.php?article=manual#1.1
- x86_64 encoding: http://ref.x86asm.net/coder64.html

# BASIC INFO

an implimentation of the fasm assembler

# Place Holder Motivation

- args
  - unknown args parsed
  - m and p args set limit values
  - s sets a symbol file
- includes
  - files are searched for include key word
  - file name is found
  - all unique file names are added
  - all files are processed into lines
- lexing
  - recognise single character symbols
  - ignore comments
