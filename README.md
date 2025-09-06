# digital-radio-vhdl


A complete **QPSK transmitter** designed and implemented in **VHDL**. This repository organizes the source code, testbenches, and documentation of a full digital radio chain, originally developed as a university practice, but restructured and documented as a standalone project.


---


## 📛 Badges
![Language](https://img.shields.io/badge/language-VHDL-blue)
![License](https://img.shields.io/badge/license-MIT-green)
![Simulator](https://img.shields.io/badge/simulator-GHDL-orange)
![Release](https://img.shields.io/github/v/release/AlbertoMarquillas/digital-radio-vhdl)


---

## 📡 Overview
This project implements a **QPSK modulation chain** from bit generation to RF output. The design is modular, with each functional block isolated for clarity and reusability.

### Signal chain
```
[QPSK Generator] → [Zero Padding (×200)] → [RRC FIR Filter] → [NCO (DDS)] → [I/Q Modulator] → Data2Ant
```

- **Bit generation:** pseudo-random I/Q symbols using 11-bit LFSRs.
- **Symbol mapping:** QPSK Gray mapping to 8-bit two's complement values.
- **Interpolation:** ×200 zero-padding (199 zeros inserted between symbols).
- **Pulse shaping:** Root-Raised Cosine FIR filter.
- **Carrier generation:** 32-bit NCO DDS (Vivado DDS Compiler IP).
- **Modulation:** I·cos(θ) + Q·sin(θ) produces the RF signal.

---

## ⚙️ System parameters
- **Bit rate:** 1 Mbit/s → **500 kSym/s** (QPSK).
- **Interpolation factor:** ×200.
- **Sampling rate (fs):** 100 MHz.
- **Carrier frequency:** 40.7 MHz.
- **DDS phase increment:** `1,748,051,689` (`Fout·2^32/Fclk`).

---

## 📂 Repository structure
```
digital-radio-vhdl/
├─ src/                       # VHDL source files (modular blocks)
│  ├─ qpsk_generator/          # LFSR-based I/Q symbol generator
│  ├─ interpolator_zero_padding/ # Zero-padding interpolation ×200
│  ├─ lpf_rrc/                 # RRC FIR filter implementation
│  ├─ nco_dds32/               # Vivado DDS Compiler IP (documented)
│  └─ qpsk_modulator_top/      # Top-level integration
├─ tb/                         # Testbenches for each block and top
├─ sim/                        # Simulation outputs (VCD, logs)
├─ docs/                       # Reports, diagrams, RaisedCosine.txt
└─ README.md                   # Project description
```

---

## 🧪 Testbenches
Each block has a dedicated **testbench** under `tb/`. These can be run with **GHDL** to produce simulation waveforms.

Example (Windows PowerShell):
```powershell
# Compile and simulate the QPSK generator
ghdl -a src\qpsk_generator\qpsk_generator.vhd tb\tb_qpsk_generator.vhd
ghdl -e tb_qpsk_generator
ghdl -r tb_qpsk_generator --vcd=sim\qpsk_generator.vcd

# Run top-level transmitter
ghdl -a src\**\*.vhd tb\tb_modulador_qpsk.vhd
ghdl -e tb_modulador_qpsk
ghdl -r tb_modulador_qpsk --vcd=sim\qpsk_full.vcd
```
The generated `.vcd` files can be opened with [GTKWave](http://gtkwave.sourceforge.net/) for waveform inspection.

---

## 📖 Documentation
- `docs/Memoria_practica.pdf` — original project report with theoretical background and results.
- `src/nco_dds32/README.md` — explanation of the Vivado DDS Compiler IP configuration.

---


## 💡 What I learned
Working on this project gave me hands-on experience with:
- **Digital modulation (QPSK)** and its practical implementation in VHDL.
- **Interpolation and filtering** using zero-padding and Root-Raised Cosine FIR.
- **Numerically Controlled Oscillators (DDS/NCO)** and parameter calculation.
- Organizing a **modular VHDL project** with clear separation of blocks and testbenches.
- Using **Vivado IPs** alongside handwritten VHDL for a real communication system.
- Documenting and restructuring a university project into a **professional-grade repository**.


---

## 📜 License
MIT License — see [LICENSE](LICENSE).

---

## 🙋 About
This project was initially developed as part of coursework in software radio, but has been restructured and documented as a standalone repository to demonstrate VHDL design, testbenching, and modular DSP implementation.
