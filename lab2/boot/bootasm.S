#include <asm.h>

# Start the CPU: switch to 32-bit protected mode, jump into C.
# The BIOS loads this code from the first sector of the hard disk into
# memory at physical address 0x7c00 and starts executing in real mode
# with %cs=0 %ip=7c00.

.set PROT_MODE_CSEG,        0x8                     # kernel code segment selector
.set PROT_MODE_DSEG,        0x10                    # kernel data segment selector
.set CR0_PE_ON,             0x1                     # protected mode enable flag
.set SMAP,                  0x534d4150

# start address should be 0:7c00, in real mode, the beginning address of the running bootloader
.globl start
start:
.code16                                             # Assemble for 16-bit mode
    cli                                             # Disable interrupts
    cld                                             # String operations increment

    # Set up the important data segment registers (DS, ES, SS).
    xorw %ax, %ax                                   # Segment number zero
    movw %ax, %ds                                   # -> Data Segment
    movw %ax, %es                                   # -> Extra Segment
    movw %ax, %ss                                   # -> Stack Segment

    # Enable A20:
    #  For backwards compatibility with the earliest PCs, physical
    #  address line 20 is tied low, so that addresses higher than
    #  1MB wrap around to zero by default. This code undoes this.
seta20.1:
    inb $0x64, %al                                  # Wait for not busy(8042 input buffer empty).
    testb $0x2, %al
    jnz seta20.1

    movb $0xd1, %al                                 # 0xd1 -> port 0x64
    outb %al, $0x64                                 # 0xd1 means: write data to 8042's P2 port

seta20.2:
    inb $0x64, %al                                  # Wait for not busy(8042 input buffer empty).
    testb $0x2, %al
    jnz seta20.2

    movb $0xdf, %al                                 # 0xdf -> port 0x60
    outb %al, $0x60                                 # 0xdf = 11011111, means set P2's A20 bit(the 1 bit) to 1

probe_memory:
    movl $0, 0x8000                                 # 将0x8000处清零，struct e820map的成员变量nr_map清零
    xorl %ebx, %ebx                                 # 将ebx清零，如果是第一次调用或内存区域扫描完毕，则为0。 如果不是，则存放上次调用之后的计数值；
    movw $0x8004, %di                               # di指向保存地址范围描述符（ARD）的缓冲区
start_probe:
    movl $0xE820, %eax                              # 参数e820h：INT 15的中断调用参数；
    movl $20, %ecx                                  # 保存地址范围描述符的内存大小，应该大于等于20字节；
    movl $SMAP, %edx                                # 单纯用作签名
    int $0x15                                       # 触发中断0x15
    jnc cont                                        # 若eflags中的cf位为0，说明执行成功，仍需继续调用中断
    movw $12345, 0x8000
    jmp finish_probe
cont:
    addw $20, %di                                   # 设置下一个BIOS返回的映射地址描述符的起始地址，应自增20
    incl 0x8000                                     # 递增struct e820map的成员变量nr_map，计数
    cmpl $0, %ebx                                   # 如果INT0x15返回的ebx为零，表示探测结束，否则继续探测
    jnz start_probe

    # 上述代码正常执行完毕后，在0x8000地址处保存了从BIOS中获得的内存分布信息。
    # 此信息按照struct e820map的设置来进行填充。
    # 这部分信息将在bootloader启动ucore后，由ucore的page_init函数
    # 来根据struct e820map的memmap（定义了起始地址为0x8000）来完成对整个机器中的物理内存的总体管理。
    # 0x8000    int nr_map
    # 0x8004    struct map[E820MAX]
    # 0x8004    uint64_t addr
    # 0x800b    uint64_t size
    # 0x8014    uint32_t type
    # 0x8018    uint64_t addr
    # ......    .............
    # ......    .............
    
finish_probe:

    # Switch from real to protected mode, using a bootstrap GDT
    # and segment translation that makes virtual addresses
    # identical to physical addresses, so that the
    # effective memory map does not change during the switch.
    lgdt gdtdesc
    movl %cr0, %eax
    orl $CR0_PE_ON, %eax
    movl %eax, %cr0

    # Jump to next instruction, but in 32-bit code segment.
    # Switches processor into 32-bit mode.
    ljmp $PROT_MODE_CSEG, $protcseg

.code32                                             # Assemble for 32-bit mode
protcseg:
    # Set up the protected-mode data segment registers
    movw $PROT_MODE_DSEG, %ax                       # Our data segment selector
    movw %ax, %ds                                   # -> DS: Data Segment
    movw %ax, %es                                   # -> ES: Extra Segment
    movw %ax, %fs                                   # -> FS
    movw %ax, %gs                                   # -> GS
    movw %ax, %ss                                   # -> SS: Stack Segment

    # Set up the stack pointer and call into C. The stack region is from 0--start(0x7c00)
    movl $0x0, %ebp
    movl $start, %esp
    call bootmain

    # If bootmain returns (it shouldn't), loop.
spin:
    jmp spin

.data
# Bootstrap GDT
.p2align 2                                          # force 4 byte alignment
gdt:
    SEG_NULLASM                                     # null seg
    SEG_ASM(STA_X|STA_R, 0x0, 0xffffffff)           # code seg for bootloader and kernel
    SEG_ASM(STA_W, 0x0, 0xffffffff)                 # data seg for bootloader and kernel

gdtdesc:
    .word 0x17                                      # sizeof(gdt) - 1
    .long gdt                                       # address gdt
