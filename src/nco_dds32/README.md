# NCO / DDS (Vivado IP)

This block implements a **Numerically Controlled Oscillator (NCO)** using the **Xilinx Vivado DDS Compiler IP**.

## Configuration
- **IP:** DDS Compiler (Xilinx Vivado)
- **Phase accumulator width:** 32 bits
- **Output:** sine and cosine samples
- **Clock (Fclk):** 100 MHz
- **Target carrier (Fout):** 40.7 MHz

## Phase increment
The DDS phase increment is calculated as:

```
phase_inc = Fout * 2^32 / Fclk
```

For **Fout = 40.7 MHz** and **Fclk = 100 MHz**:

```
phase_inc = 1,748,051,689
```

## Integration
- The NCO outputs **cos(θ)** and **sin(θ)** samples.
- These are used in the **QPSK modulator** to mix the baseband I/Q with the carrier:

```
I * cos(θ) + Q * sin(θ) → Data2Ant
```

## Notes
- The implementation is tool-specific (Vivado IP).
- The generated files (`.xci`, `.bd`, `.bda`, `.ui`, etc.) are **not included** in this repository.
- This README documents the configuration and role of the block for clarity and reproducibility.
