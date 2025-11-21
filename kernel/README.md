# Nova Microkernel

Example microkernel written in Athōn.

## Target: Q3 2026 (Jun - Aug 2026)

## Goals

- Bootable on QEMU and real RISC-V hardware
- Capability-based security throughout
- Process isolation with revocable permissions
- Minimal trusted computing base

## Architecture

```
Hardware
    ↓
Bootloader
    ↓
Nova Kernel (Athōn)
    ↓
User Processes (Capability-isolated)
```

## Features

- **Process Management**: Spawn, suspend, terminate
- **Memory Management**: Region allocator, capability references
- **IPC**: Capability-multiplexed message passing
- **Device Drivers**: Capability-secured hardware access
- **Scheduling**: Preemptive multitasking

## Files (To Be Created)

- `boot.at` - Bootloader entry point
- `kernel.at` - Main kernel code
- `scheduler.at` - Process scheduler
- `ipc.at` - Inter-process communication
- `drivers/` - Device drivers

## Memory Layout

```
0x80000000: Kernel code
0x80100000: Kernel data
0x80200000: Process 1
0x80300000: Process 2
...
0x80F00000: Kernel stack
```

## Capability Model

Every resource is a capability:
- Memory regions
- Device access
- IPC channels
- File handles

Capabilities can be:
- Granted at process spawn
- Transferred between processes
- Revoked at any time

## Status

- [ ] Boot sequence
- [ ] Memory management
- [ ] Process spawning
- [ ] IPC implementation
- [ ] Device drivers
- [ ] Scheduler

## Next Steps

1. Implement boot sequence
2. Set up memory management
3. Add process spawning
4. Test on QEMU
5. Boot on real hardware
