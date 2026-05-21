# IEEE 754 Single-Precision Floating-Point Adder (Verilog)

A combinational 32-bit IEEE 754 single-precision floating-point adder implemented in Verilog, with a set of testbenches and a hex input file.

## Pipeline

The adder follows the textbook stages of IEEE-754 single-precision addition:

1. **Unpack** sign / exponent / mantissa from `a` and `b`; restore hidden bit.
2. **Align** the smaller operand by shifting its mantissa right by the exponent difference (with guard, round, and sticky bits).
3. **Two's-complement** representation for signed mantissa addition.
4. **Add** the aligned mantissas.
5. **Normalize** the result by counting leading zeros and shifting.
6. **Round** using guard/round/sticky bits.
7. **Pack** the result back into IEEE-754 form (`{sign, exponent, fraction}`).

## Repository Structure

```
fp_adder.v          — RTL: combinational fp adder module
fp_adder_test.v     — Original testbench
fp_adder__tb.v      — Additional Verilog testbench
fp_adder__tb2.sv    — SystemVerilog testbench
fp_adder__tb3.sv    — SystemVerilog testbench
fp.hex              — Hex stimulus / expected-value file
transcript          — ModelSim simulation transcript
```

## How to Simulate (ModelSim / QuestaSim)

```tcl
vlib work
vlog fp_adder.v fp_adder__tb.sv
vsim -c work.fp_adder_tb -do "run -all; quit"
```

Or with Icarus Verilog (for the `.v` testbench only):

```bash
iverilog -o fp_adder_sim fp_adder.v fp_adder_test.v
vvp fp_adder_sim
```

## License

MIT — see [LICENSE](LICENSE).
