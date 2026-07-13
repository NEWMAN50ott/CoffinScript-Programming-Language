# CoffinScript-Programming-Language
This is a open source bare metal programming language
# CoffinScript (`.cf`) 🪦⚡

An independent, functional systems language designed for bare-metal execution utilizing a single `r0` scratch accumulator. 

CoffinScript bridges the gap between raw C-like pointer control and functional call-site safety. It is architected to work in tandem with a fast imperative bootstrap loader to drive bulletproof hardware subsystems.

---

## 🏛️ Architectural Highlights

*   **Hybrid Borrow Checker:** Completely skips input verification inside function bodies for unrestricted low-level manipulation. Lifetime tracking and data-race safety are strictly enforced **at the call site**.
*   **Dual Reference Operators:** Features `&` (read-only mutable pointer—the reference can re-target, but data cannot change) and `&mut` (normal mutable reference—allows data modification).
*   **Visual Eternity Loops:** Infinite execution blocks (`loop: {}`) physically omit trailing block closure keywords. Block termination is handled natively via an internal `end` statement loop-break rule.
*   **Four-Type Model:** Complete memory transparency separating `args` (CPU register inputs), `struct` (C-style blueprints), `var` (stack frame allocation), and `obj` (managed heap blocks using built-in bare-metal page allocators).

---

## ✒️ Syntax Blueprint: `kernel.cf`

```coffinscript
struct.HardwareNode: {
    id: u32
    state: u32
}
end

@interrupt
fn.main(): {
    let.counter: var.u32
    counter: 0
    
    let.packet: mem.alloc(128) // Native allocation returns an 'obj' type
    smp.print(“Booting Coffin Engine Toolchain...”)
    
    loop: {
        counter: counter + 1
        
        if: counter == 10 {
            end // Internal statement block termination rule!
        }
    }
    
    mem.free(packet) // Explicit memory burial
}
end
```

---

## 🛠️ The `csc` Compiler Driver

The **`csc` (CoffinScript Compiler)** is a self-hosting binary toolchain. It tokenizes `.cf` structures, runs reference sweeps, completely bypasses intermediate text streams, and emits flat, raw machine code binaries (`.bin`).

### Instruction Encoding Format

Every instruction maps directly to fixed 16-bit encoding slots processed by the `r0` scratch accumulator:
*   `0x0000` (`nop`) - No operation.
*   `0xA9[val]` (`ldr0`) - Loads register `r0` with a targeted operand or memory location.
*   `0x8D[addr]` (`str0`) - Flushes register `r0` state down to a RAM memory slot.
*   `0xCD[val]` (`cmpr0`) - Evaluates register `r0` status against a condition.
*   `0x4C[dest]` (`jmp`) - Permanent unconditional hardware jump to a fixed destination.

---

## 🚀 Building the Toolchain

Use the provided build scripts (`build.bat` or `build.sh`) to assemble the pure assembly implementation of the compiler directly into an executable binary image file via `customasm`.

```bash
# Windows
build.bat

# Linux / macOS
chmod +x build.sh
./build.sh
```
