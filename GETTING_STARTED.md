# Quick Start Guide

## Prerequisites

- **OS:** Linux Mint 21+ or Ubuntu 22.04+
- **Rust:** 1.75+ (install via rustup)
- **GPU Drivers:**
  - AMD: `sudo apt install rocm-opencl-runtime`
  - NVIDIA: `sudo apt install nvidia-driver-535 mesa-vulkan-drivers`

## Installation

```bash
# Clone the repository
git clone https://github.com/daavfx/OPenclawd---No-GC-SIR-RUNTIME.git
cd OPenclawd---No-GC-SIR-RUNTIME/ryiuk-core

# Build the project
cargo build --release --features typescript

# Run tests
cargo test --release
```

## Your First GPU Program

Create `hello_gpu.ts`:

```typescript
// This runs on your Vega 7 iGPU
function transform(data: number[]): number[] {
    return data.map(x => {
        // Heavy computation - automatically detected
        let result = x;
        for (let i = 0; i < 1000; i++) {
            result = Math.sin(result) * Math.cos(result);
        }
        return result;
    });
}

const input = Array.from({length: 100000}, (_, i) => i * 0.001);
const output = transform(input);
console.log(`Processed ${output.length} elements`);
```

Run it:

```bash
cargo run --bin ts-to-gpu -- hello_gpu.ts --verbose
```

Expected output:
```
✓ Parsed TypeScript (42 AST nodes)
✓ Type checking passed
✓ Generated SIR (1 functions, 1 GPU candidates)
✓ Executing on iGPU (Vega 7)
✓ Completed in 45ms (CPU would take 320ms)
🌡️  Peak temp: 72°C (under 85°C limit)
```

## Understanding the Output

### Tiered Execution

The system automatically chooses where to run your code:

- **Cold code:** Interpreter (immediate start)
- **Warm code:** JIT compiled (~10ms overhead)
- **Hot loops:** GPU kernel (~500ms compile, then 10x faster)
- **Critical paths:** AOT native (build time)

### Thermal Management

Watch the temperatures:

```
Current: CPU=65°C iGPU=62°C dGPU=45°C
GPU offload approved (17°C headroom)
Executing on iGPU...
Peak: CPU=72°C iGPU=68°C dGPU=45°C ✅ Under limit
```

If temps rise too high, work automatically migrates to CPU.

### Memory Transfers

For iGPU (AMD APU), there's **zero copy**:

```
CPU RAM <-> iGPU RAM = Same physical memory
Transfer = Cache flush only (~0.1ms)
```

For dGPU (NVIDIA), data copies over PCIe:

```
CPU RAM -> dGPU VRAM = DMA transfer (~2ms for 100MB)
```

## Common Patterns

### Pattern 1: Array.map (GPU)

```typescript
const result = array.map(x => heavyComputation(x));
// Automatically goes to GPU if:
// - Array size > 1000 elements
// - Compute per element > 100 ops
// - Thermal headroom > 10°C
```

### Pattern 2: Matrix Math (GPU)

```typescript
function matmul(a: number[][], b: number[][]): number[][] {
    // Nested loops automatically parallelized
}
// Goes to GPU if matrices > 128x128
```

### Pattern 3: Reduce (GPU)

```typescript
const sum = array.reduce((acc, x) => acc + x, 0);
// Parallel reduction tree on GPU
```

### Pattern 4: Sequential (Stays CPU)

```typescript
// Control flow heavy, stays on CPU
function processItems(items: Item[]): Result {
    const results = [];
    for (const item of items) {
        if (item.valid) {
            results.push(transform(item));
        }
    }
    return merge(results);
}
```

## Command Line Options

```bash
# Basic execution
ts-to-gpu input.ts

# Specify device
-ts-to-gpu input.ts --device cpu        # Force CPU
-ts-to-gpu input.ts --device igpu       # Force iGPU (Vega 7)
ts-to-gpu input.ts --device dgpu       # Force dGPU (GTX 1650)

# Thermal limits
ts-to-gpu input.ts --thermal-limit 80  # Lower threshold

# Optimization level
ts-to-gpu input.ts --opt-level 3       # Aggressive optimization

# Verbose output
ts-to-gpu input.ts --verbose           # Show all steps

# Benchmark mode
ts-to-gpu input.ts --benchmark         # Run 100x and report
```

## Troubleshooting

### "GPU not detected"

```bash
# Check ROCm (AMD)
rocminfo | grep "Name:"

# Check Vulkan (NVIDIA)
vulkaninfo | grep "deviceName"

# Install drivers
sudo apt install rocm-opencl-runtime mesa-vulkan-drivers
```

### "Thermal limit exceeded"

```bash
# Lower the threshold
ts-to-gpu input.ts --thermal-limit 75

# Or force CPU
ts-to-gpu input.ts --device cpu
```

### "Out of memory"

```bash
# Reduce batch size
# Or use streaming mode
ts-to-gpu input.ts --streaming
```

## Benchmarking Your Code

```bash
# Compare CPU vs GPU
ts-to-gpu input.ts --benchmark --compare

# Output:
# CPU:  1250ms (baseline)
# iGPU:  180ms (6.9x speedup)
# dGPU:  120ms (10.4x speedup)
```

## Next Steps

- Read `ARCHITECTURE.md` for technical details
- Check `examples/` for more patterns
- Run `cargo test` to verify your installation
- Join discussions in GitHub Issues

## Getting Help

```bash
# Show all options
ts-to-gpu --help

# Check system compatibility
ts-to-gpu --diagnostics

# Run self-test
cargo test --release
```

---

**Pro Tip:** Start with small examples and verify thermal behavior before running large workloads. The system is safe by default (85°C limit), but it's good to understand your hardware's thermal profile.
