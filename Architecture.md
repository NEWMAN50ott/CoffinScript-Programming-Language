# 🏛️ CoffinScript (`.cf`) System & Microarchitecture Specification

This document defines the formal architectural boundaries, memory models, hardware registers, and toolchain pipelines of the **CoffinScript** language.

---

## 💾 1. ISA & Hardware Registry

The CoffinScript microarchitecture completely discards traditional abstract register configurations or named accumulator files. It is an unbloated, low-overhead systems execution layout designed to run on a raw, flat memory model.

### 🕹️ The Hardware Register
*   **`r0`**: The primary 16-bit scratch and math accumulator register. All calculations, memory loads, and comparison evaluations pass through `r0`.
*   **`sp`**: The Hardware Stack Pointer. Tracks the boundary of the local execution frame in RAM.
*   **`pc`**: The Program Counter. Tracks the memory address of the instruction currently being executed.

### 📟 Machine Byte Opcode Dictionary
The **`csc`** compiler emits flat, raw **`.bin`** executable packages composed of fixed 16-bit instructions. The instruction encoding format uses a highly deterministic hex mapping:

| Hex Opcode | Mnemonic Syntax | Architectural Behavior |
| :--- | :--- | :--- |
| `0x0000` | `nop` | No operation. Advances the `pc` register by 1 instruction frame. |
| `0xA9[val]` | `ldr0 {val}` | Loads the register **`r0`** with a targeted immediate operand or memory pointer. |
| `0x8D[addr]`| `str0 {addr}`| Flushes the active contents of register **`r0`** down to a fixed RAM variable slot. |
| `0xCD[val]` | `cmpr0 {val}`| Evaluates the status of **`r0`** directly against an explicit numeric operand byte. |
| `0xD0[dest]`| `bne {dest}` | Conditional Branch. Alters `pc` to `dest` if the CPU Zero Flag is unasserted (Z=0). |
| `0x4C[dest]`| `jmp {dest}` | Permanent Unconditional Jump. Forces `pc` straight to the targeted address offset. |
| `0x20[dest]`| `call {dest}`| Pushes `pc` to the stack and jumps to a built-in peripheral or driver routine vector. |
| `0x6000` | `ret` | Pulls the saved execution address back off the stack, unwinding the active frame. |

---

## 🧱 2. The Four-Type Memory Blueprint

Memory allocation and transparency are built directly into CoffinScript’s syntax tokens. Programmers know exactly where every byte lives by reading the declaration prefixes:

1.  **`args` (Register Allocation):** Read-only inputs passed into a function block. The compiler prioritizes binding `args` directly to raw CPU registers or local input buffers.
2.  **`struct` (C-Style Blueprint):** A contiguous, zero-overhead sequence layout defining raw fields in memory. It contains no embedded routines—only fields—and is used for mapping memory-mapped hardware (MMIO) and packets.
3.  **`var` (Stack Scoping):** Allocates memory strictly on the local **CPU Stack Frame** via the `sp` register. Its lifetime is explicitly tied to the current function block.
4.  **`obj` (Inbuilt Heap Malloc):** Instantiates a tracking type dynamically on the **Bare-Metal Kernel Heap Page Pool** utilizing the built-in `malloc.alloc` or `mem.alloc` namespace.

---

## 🛡️ 3. The Call-Site Borrow Checker (Hybrid Safety Model)

CoffinScript solves the systems safety problem using a split-brain validation pipeline:

*   **Inside Function Bodies:** The borrow checker deliberately **skips all code checking**. This grants the systems programmer complete C-like, unrestricted freedom to execute pointer arithmetic, memory overrides, or low-level register manipulation without compiler complaints.
*   **At the Call Site:** The borrow checker enforces rigorous safety boundaries at the exact line where a function is called. It guarantees data-race immunity and use-after-free protection across multiple CPU loops by evaluating reference operators:
    *   **`&` (Read-Only Mutable Reference):** The reference pointer can be re-targeted dynamically, but the underlying data cannot be altered through it. Multiple `&` borrows can exist simultaneously (Race-Free Multi-Reader).
    *   **`&mut` (Normal Mutable Reference):** Grants complete write access to the underlying data. Only a single `&mut` reference can exist for a memory block at one time, locking out all other borrows (Exclusive Single-Writer).

---

## ♾️ 4. Loop Mechanics & Control Flow

CoffinScript replaces standard loop keyword bloat (`break`, `continue`, labels) with an elegant syntax layout that reflects physical hardware reality:

### Visual Eternity (`loop: {}`)
An infinite hardware loop is opened simply via `loop: {`. It **completely omits trailing block keywords** (like `end` or `}`) outside its closing brace. Because it runs forever, forcing a trailing keyword on the page is logically incorrect.

### Internal `end` Block Termination
The `end` keyword does not sit outside loop brackets as a structural marker. Instead, it lives **inside** execution blocks as an active statement. When placed inside a loop (typically nested behind an `if:` or `match:` condition), `end` serves as your native **break command** to escape the block bounds.

---


