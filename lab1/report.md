# Lab1 report 

&emsp;

## 我遇到的bug

&emsp;

### BUG1: 有关qemu命令的问题

&emsp;

问题：在使用`apt`命令安装好`qemu`工具后，可能是由于之前安装的版本问题，没有找到`qemu`命令。

解决：使用软连接，在`/bin`目录下新建`qemu`文件，软连接到已经存在的`qemu-system-i386`。

&emsp;

### BUG2: 有关qemu和gdb配合使用的问题

&emsp;

问题：按照实验指导书的指示正确的按照顺序输入命令，结果报如下错误

```
gtk initialization failed
```

解决：在`VScode` `ssh`远程终端输入启动`qemu`的命令显然无法执行，因为无法显示gui。在虚拟机本地运行即可。

&emsp;

### BUG3: 有关challenge1和2无法在grade.sh中通过的问题

&emsp;

问题：补充好challenge代码之后运行`grade.sh`脚本出错。并且`make qemu`命令也没能正确地显示寄存器的值。应该是`lab1_print_cur_status()`没有执行。

解决：在`kernel_init()`函数中没有解除对`lab1_switch_test()`的注释，解除注释即可。

&emsp;

### BUG4: 有关challenge2部分遇到的问题

&emsp;

问题：一系列问题，包括但不限于无法找到对应答案，汇编语句内联失败，无法正确定位对应代码，切换到用户模式后停顿等。

解决：

1. 首先，阅读gitbook对应章节，了解ucore中中断处理相关原理，可知产生中断的方法为内联对应的汇编代码，并将参数设置为中断向量号。`int`指令为x86的中断触发指令，系统在接收到中断之后会从`tarp_entry.S`进入，在压入原有寄存器等信息之后，跳转至`trap.c`中的`trap`函数当中。`trap`函数的处理过程为`trap_dispatch`通过`switch`语句分类处理各种中断。其中有关内核和用户模式的切换需要对`tf`进行修改，修改`cs`寄存器的值，并将低位修改为0或者3，这样就会让操作系统以为level已被修改。

2. 查看`kernel/drivers`中的`console.c`，内含有关键盘输入字符触发的处理函数`kbd_proc_data`，它会识别传入的`data`，并找到其对应的字符`c`，再返回。其中如果识别出`data == 0x04`或者`data == 0x0b`，即按下的按键为键盘上方的数字3或0，就会执行我们在`trap.c`新定义的函数`switch_to_user`和`switch_to_kernel`，其本质也是内联汇编。

3. 在`trap_dispatch`对应分支下添加`print_trapframe()`，打印中断帧的状态。运行`make qemu`检测是否正确。可以发现按下0时，能够正确切换至内核状态，并继续输出`100ticks`。按下3时，虽然也能正确切换至用户状态，但是无法继续打印`100ticks`了。据猜测应该是用户模式下无法执行中断处理代码，或者中断无法触发。在末尾重新切换会内核状态即可结束调试。

&emsp;

### BUG5: 关于vscode无法远程连接ubuntu虚拟机

&emsp;

问题：vscode在安装remote-ssh插件后，仍无法远程连接ubuntu虚拟机，报错无法获取虚拟机的操作系统类别，且没有.ssh文件夹的权限

解决：在remote-ssh设置中的remote platform中预设虚拟机ip地址及指定平台，并在C盘中找到.ssh文件夹，右键选择属性-安全，编辑其访问权限。

&emsp;

## 吐槽


代码量过大，并且陌生，阅读比较困难。对相关概念理解不够深入。

&emsp;

## 以下为各个练习的部分实现过程。

&emsp;

&emsp;

&emsp;

&emsp;

&emsp;

&emsp;

&emsp;

## [练习1]

[练习1.1] 操作系统镜像文件 `ucore.img` 是如何一步一步生成的?(需要比较详细地解释`Makefile`中
每一条相关命令和命令参数的含义,以及说明命令导致的结果)

理解`ucore.img`系统镜像文件的生成过程，必须充分读懂`Makefile`文件。

首先指定gcc编译器的正确前缀`GCCPREFIX`，该前缀用于在终端输入正确的命令。i386-elf版本的gcc即针对intel的80386指令集，这是本操作系统运行的目标架构。

```
ifndef GCCPREFIX
GCCPREFIX := ......
endif
```

同样的，需要指定正确的QEMU命令为`qemu-system-i386`，`i386-elf-qemu`或`qemu`。

```
ifndef QEMU
QEMU := ......
endif
```

下一步指定所使用的编译器和编译器的flags参数。编译器可以为`gcc`或者`clang`，且使用的参数类似，都制定了警告等级和目标平台架构等。

```
ifndef  USELLVM
HOSTCC        := gcc
......
else
HOSTCC        := clang
......
endif
```

而在`tools/function.mk`文件中定义着`Makefile`中将要使用的一些函数，该函数实际上就是可复用的命令集合，用于实现特定的功能。具体使用过程和详细信息在需要理解时查找资料自行理解。

```
# 列出某一目录下的某一类型的所有文件。（参数一：目录，参数二：类型）
# list all files in some directories: (#directories, #types)
listf = $(filter $(if $(2),$(addprefix %.,$(2)),%),$(wildcard $(addsuffix $(SLASH)*,$(1))))

# 某一文件对应的目标文件.o
# get .o obj files: (#files[, packet])
toobj = $(addprefix $(OBJDIR)$(SLASH)$(if $(2),$(2)$(SLASH)),$(addsuffix .o,$(basename $(1))))

# 某一文件对应的依赖文件.d
# get .d dependency files: (#files[, packet])
todep = $(patsubst %.o,%.d,$(call toobj,$(1),$(2)))

# 目标文件存放目录为/bin/
totarget = $(addprefix $(BINDIR)$(SLASH),$(1))

# 增加目录前缀
# change $(name) to $(OBJPREFIX)$(name): (#names)
packetname = $(if $(1),$(addprefix $(OBJPREFIX),$(1)),$(OBJPREFIX))
......
```

一些`gcc`编译器的关键参数，位于`CFLAGS`变量中，解释其意义。

```
-Wall  指定编译警告等级，将会输出所有的警告，这有助于我们排查程序的细节。
-march=i686  指定目标平台架构为i686，用于在qemu中运行。
-fno-builtin  防止函数名和库函数名冲突。
-fno-PIC  不生成位置无关代码。
-ggdb  生成可供gdb使用的调试信息。
-m32  生成适用于32位环境的代码。
-gstabs  生成stabs格式的调试信息。
-nostdinc  不使用标准库。
-fno-stack-protector  不生成用于检测缓冲区溢出的代码。
-Os  为减小代码大小而进行优化。
-I<dir>  添加搜索头文件的路径。
```

进行了一些指令、路径、变量以及函数调用的声明。

```
COPY    := cp
MKDIR   := mkdir -p
SED        := sed
SH        := sh
TR        := tr

objfile = $(call toobj,$(1))
asmfile = $(call cgtype,$(call toobj,$(1)),o,asm)
outfile = $(call cgtype,$(call toobj,$(1)),o,out)
symfile = $(call cgtype,$(call toobj,$(1)),o,sym)

KINCLUDE    += kern/debug/ \
               kern/driver/ \
               kern/trap/ \
               kern/mm/

KSRCDIR        += kern/init \
               kern/libs \
               kern/debug \
               kern/driver \
               kern/trap \
               kern/mm
```

以下为`make`执行时具体运行的代码

```
# 生成ucore.img的顶层命令：
# create ucore.img
UCOREIMG    := $(call totarget,ucore.img)

$(UCOREIMG): $(kernel) $(bootblock)
    $(V)dd if=/dev/zero of=$@ count=10000
    $(V)dd if=$(bootblock) of=$@ conv=notrunc
    $(V)dd if=$(kernel) of=$@ seek=1 conv=notrunc

$(call create_target,ucore.img)

# 该命令先调用了totarget函数，参数为ucore.img，即指定目标的生成路径为/bin/ucore.img。
# 其次需要kernel和bootblock两项作为前提。
# 最终需要执行dd命令输出文件并写入相应内容。

# -------------------------------------------------------------------

# 生成kernel：
# create kernel target
kernel = $(call totarget,kernel)

$(kernel): tools/kernel.ld

$(kernel): $(KOBJS)
    @echo + ld $@
    $(V)$(LD) $(LDFLAGS) -T tools/kernel.ld -o $@ $(KOBJS)
    @$(OBJDUMP) -S $@ > $(call asmfile,kernel)
    @$(OBJDUMP) -t $@ | $(SED) '1,/SYMBOL TABLE/d; s/ .* / /; /^$$/d' > $(call symfile,kernel)

$(call create_target,kernel)

# 指定了kernel的生成路径/bin/kernel，并通过tools/kernel.ld链接器脚本，将已经生成的那些目标文件——从libs和kernel目录下的文件生成，进行链接。

# 编译成.o文件的Makefile代码为：$(call add_files_cc,$(call listf_cc,$(KSRCDIR)),kernel,$(KCFLAGS))，执行的命令举例如下:

gcc -Ikern/libs/ -march=i686 -fno-builtin -fno-PIC -Wall -ggdb -m32 -gstabs -nostdinc  -fno-stack-protector -Ilibs/ -Ikern/debug/ -Ikern/driver/ -Ikern/trap/ -Ikern/mm/ -c kern/libs/stdio.c -o obj/kern/libs/stdio.o

# 链接时实际执行的命令为：

ld -m elf_i386 -nostdlib -T tools/kernel.ld -o bin/kernel \
obj/kern/init/init.o obj/kern/libs/readline.o \
obj/kern/libs/stdio.o obj/kern/debug/kdebug.o \
obj/kern/debug/kmonitor.o obj/kern/debug/panic.o \
obj/kern/driver/clock.o obj/kern/driver/console.o \
obj/kern/driver/intr.o obj/kern/driver/picirq.o \
obj/kern/trap/trap.o obj/kern/trap/trapentry.o \
obj/kern/trap/vectors.o obj/kern/mm/pmm.o \
obj/libs/printfmt.o obj/libs/string.o

# 同时下面两条objdump指令还能从生成的文件中导出符号表和asm文件到/obj目录下。

# -------------------------------------------------------------------

# 生成bootblock

# create bootblock
bootfiles = $(call listf_cc,boot)
$(foreach f,$(bootfiles),$(call cc_compile,$(f),$(CC),$(CFLAGS) -Os -nostdinc))

bootblock = $(call totarget,bootblock)

$(bootblock): $(call toobj,$(bootfiles)) | $(call totarget,sign)
    @echo + ld $@
    $(V)$(LD) $(LDFLAGS) -N -e start -Ttext 0x7C00 $^ -o $(call toobj,bootblock)
    @$(OBJDUMP) -S $(call objfile,bootblock) > $(call asmfile,bootblock)
    @$(OBJCOPY) -S -O binary $(call objfile,bootblock) $(call outfile,bootblock)
    @$(call totarget,sign) $(call outfile,bootblock) $(bootblock)

$(call create_target,bootblock)

# 制定了bootblock的生成路径为/bin/bootblock，将已经生成的那些目标文件——从boot目录下的文件生成，进行链接。但链接之后的bootblock.o目标文件还需要经过sign工具的处理，最后输出为bootblock。

# 从bootmain.c和bootasm.S编译生成bootmain.o和bootasm.o文件的命令为：

gcc -Iboot -fno-builtin -Wall -ggdb -m32 -gstabs -nostdinc  -fno-stack-protector -Ilibs -Os -nostdinc -c boot/bootasm.S -o obj/boot/bootasm.o

gcc -Iboot -fno-builtin -Wall -ggdb -m32 -gstabs -nostdinc -fno-stack-protector -Ilibs/ -Os -nostdinc -c boot/bootmain.c -o obj/boot/bootmain.o

# 链接生成bootblock.o的命令为：
ld -m    elf_i386 -nostdlib -N -e start -Ttext 0x7C00 obj/boot/bootasm.o \
obj/boot/bootmain.o \
-o obj/bootblock.o

# 下一步还需要将bootblock.o拷贝为bootblock.out，将其通过sign工具，生成最终的可执行文件bootblock。

objcopy -S -O binary obj/bootblock.o obj/bootblock.out

# -------------------------------------------------------------------

# sign工具的生成

# 生成sign工具的makefile代码为：
$(call add_files_host,tools/sign.c,sign,sign)
$(call create_target_host,sign,sign)

# 实际执行的命令为：
gcc -Itools -g -Wall -O2 -c tools/sign.c -o obj/sign/tools/sign.o
gcc -g -Wall -O2 obj/sign/tools/sign.o -o bin/sign

# 该sign工具最终会将block文件的最后两个字节改为0x55和0xAA，用于标识该扇区为磁盘的主引导扇区。

bin/sign obj/bootblock.out bin/bootblock

# -------------------------------------------------------------------

# 完成创建ucore.img

# 使用dd命令可以指定linux输入输出文件过程。

# 新建文件ucore.img，具有10000个块，每个块有512字节，初始化数据为0.
dd if=/dev/zero of=bin/ucore.img count=10000

# 将bootblock写入ucore.img的第一个块中。
dd if=bin/bootblock of=bin/ucore.img conv=notrunc

# 从第二个块开始写内核的内容。
dd if=bin/kernel of=bin/ucore.img seek=1 conv=notrunc


#---------------------------------------------------------------------
#评分脚本部分
TARGETS: $(TARGETS)

.DEFAULT_GOAL := TARGETS

.PHONY: qemu qemu-nox debug debug-nox
qemu-mon: $(UCOREIMG)
    $(V)$(QEMU)  -no-reboot -monitor stdio -hda $< -serial null
qemu: $(UCOREIMG)
    $(V)$(QEMU) -no-reboot -parallel stdio -hda $< -serial null
log: $(UCOREIMG)
    $(V)$(QEMU) -no-reboot -d int,cpu_reset  -D q.log -parallel stdio -hda $< -serial null
qemu-nox: $(UCOREIMG)
    $(V)$(QEMU)   -no-reboot -serial mon:stdio -hda $< -nographic
TERMINAL        :=gnome-terminal
```

具体生成流程

```
1)调用GCC将部分.c和.S文件，编译成了目标文件。
kern/init目录：init.c（系统初始化部分）
kern/libs目录：stdio.c、readline.c（公共库部分）
kern/debug目录：panic.c、kdebug.c、kmonitor.c（内核调试部分）
kern/driver目录：clock.c、console.c、picirq.c、intr.c（外设驱动部分）
kern/trap目录：trap.c、vectors.S、trapentry.S（中断处理部分）
kern/mm目录：pmm.c（内存管理部分）
libs目录：string.c、printfmt.c（公共库部分）
即代码+ cc kern/init/init.c以下到+ ld bin/kernel以上的过程
(2)通过ld，将目标文件链接，生成kernel可执行文件。
使用ld命令链接上面生成的各目标文件，并根据tools/kernel.ld脚本文件进行链接，
链接后生成bin/kernel即OS内核文件。
(3)编译并链接生成bootloader。
首先使用gcc将bootasm.S（定义并实现了bootloader最先执行的函数start，此函数进行了一定
的初始化，完成了从实模式到保护模式的转换，并调用bootmain.c中的bootmain函数）、
bootmain.c（定义并实现了bootmain函数实现了通过屏幕、串口和并口显示字符串。
bootmain函数加载ucore操作系统到内存，然后跳转到ucore的入口处执行）生成目标文件，
再使用ld将两个目标文件链接，设置entry入口为start段，代码段起始位置为0x7c00，
使用sign程序将bootblock.o文件添加主引导扇区的标志，使其作为bootloader。
(4)生成OS镜像文件
dd是一个Unix和类Unix系统上的命令，主要功能为转换和复制文件，这里使用dd来生成最终的
ucore镜像文件，块大小（bs）默认为512B。
使用/dev/zero虚拟设备，生成10000个块的空字符（0x00），每个块大小为512B，
因此ucore.img总大小为5,120,000B。
接下来两行代码中的转换选项为notrunc，意味着不缩减输出文件。换言之，如果输出文件已经存在，
那么只改变指定的字节，然后退出，并保留输出文件的剩余部分。如果没有这个选项，dd命令将创建
一个512B长的文件。
将bootloader（bin/bootblock文件）代码复制到ucore.img文件头处，共512B大小，即只修
改ucore.img的文件头处的512B。
将kernel（bin/kernel文件）复制到ucore.img距文件头偏移1个块大小的地方，也即
ucore.img前512B放bootloader，紧接着放kernel。
```

总结：

```
ucore.img是一个包含了bootloader和OS的硬盘镜像。kernel即内核，一个用来管理软件发出
的资料I/O（输入与输出）要求的电脑程序，将这些要求转译为资料处理的指令并交由中央处理
器（CPU）及电脑中其他电子组件进行处理。bootloader即引导加载器，一个用来通电后自检并
引导装载操作系统或其他系统软件的计算机程序。ucore.img的生成实际上也是在生成这两个程序。
```

[练习1.2] 一个被系统认为是符合规范的硬盘主引导扇区的特征是什么?

在`sign.c`的代码中，它将输入的二进制目标文件输出为512字节的扇区文件。并将最后两个字节设置为`0x55`和`0xAA`。

在BIOS执行boot阶段时，会从硬盘的第一个扇区开始寻找是否存在以`0x550xAA`为结尾的扇区，如果存在就将其加载到内存的0x7C00位置，随后PC将从这一位置开始。

## [练习2]

[练习2.1] 从 CPU 加电后执行的第一条指令开始,单步跟踪 BIOS 的执行。

（提示：此操作无法通过ssh远程终端运行）

1. 单步跟踪BIOS的执行，必须修改`gdbinit`配置，使得`gdb`能够和`qemu`配合运行。

```
target remote 127.0.0.1:1234
file bin/kernel
```

2. 启动`qemu`

```
qemu -S -s -hda ucore.img -monitor stdio    # 用于与gdb配合进行源码调试
```

此时出现了`qemu`的监视端，不过由于此时cpu还未开始运行，并未显示什么内容。

3. 运行`gdb`

```
gdb -x tools/gdbinit
```

启动`gdb`之后，可以发现`qemu`的界面发生了变化，输出了`Booting from hard disk`。下一步在gdb中输入`si`命令或者`step`命令，进入单步调试阶段。

4. 在`memset`处设置断点查看相关内容

```
(gdb) break memset
Breakpoint 2 at 0x102b43: file libs/string.c, line 271.
(gdb) continue
Continuing.

Breakpoint 2, memset (s=0x10fa16, c=0 '\000', n=4874) at libs/string.c:271
271    memset(void *s, char c, size_t n) {
```

```
(gdb) break cprintf
Breakpoint 2 at 0x100284: file kern/libs/stdio.c, line 40.
(gdb) continue
Continuing.

Breakpoint 2, cprintf (fmt=0x10339c "%s\n\n") at kern/libs/stdio.c:40
40    cprintf(const char *fmt, ...) {
(gdb) continue
Continuing.

Breakpoint 2, cprintf (fmt=0x103482 "Special kernel symbols:\n")
    at kern/libs/stdio.c:40
40    cprintf(const char *fmt, ...) {
```

[练习2.2] 在初始化位置`0x7c00` 设置实地址断点,测试断点正常。

此时需要将20位实地址作为程序运行的断点。所以应该告诉`gdb`目前平台架构为i8086。设置断点完毕，并确认之后，要将架构改为i386。

在tools/gdbinit设置：

```
set architecture i8086
b *0x7c00
c
x /2i $pc
set architecture i386
```

重新查看输出结果：

```
0x0000fff0 in ?? ()
Breakpoint 1 at 0x100000: file kern/init/init.c, line 17.
The target architecture is assumed to be i8086
Breakpoint 2 at 0x7c00

Breakpoint 2, 0x00007c00 in ?? ()
=> 0x7c00:      cli
--Type <RET> for more, q to quit, c to continue without paging--
```

[练习2.3] 在调用`qemu` 时增加`-d in_asm -D q.log` 参数，便可以将运行的汇编指令保存在`q.log`中。
将执行的汇编代码与`bootasm.S` 和 `bootblock.asm` 进行比较，看看二者是否一致。

在`Makefile`中的`debug`选项下，修改`qemu`的执行命令，可以将每次运行时的汇编指令保存到日志文件下。运行`qemu debug`即可查看。

```
改写Makefile文件
    debug: $(UCOREIMG)
        $(V)$(TERMINAL) -e "$(QEMU) -S -s -d in_asm -D $(BINDIR)/q.log -parallel stdio -hda $< -serial null"
        $(V)sleep 2
        $(V)$(TERMINAL) -e "gdb -q -tui -x tools/gdbinit"
```

查看，在`0x00007c00`处，比较汇编代码。可以发现执行的指令无不一致之处。但是存在一些微小的改变，比如日志中实际执行的代码，将原汇编代码中跳转指令的标签，直接修改为地址。

## [练习3]

分析`bootloader` 进入保护模式的过程。

这一过程位于`bootasm`的汇编代码中，大致可以分为几个步骤。

1. 定义常量与宏
   
   bootasm.S一开始先定义了三个常量。PROT_MODE_CSEG和PROT_MODE_DSEG分别作为内核代码段、数据段的选择子。并且由图可知，二者分别指向GDT[1]和GDT[2]，RPL为0，CPL为0。而CRO_PE_ON则是切换到保护模式时的使能标志。

2. 初始化寄存器

```
cli
cld
xorw %ax, %ax
movw %ax, %ds
movw %ax, %es
movw %ax, %ss
```

bootloader入口地址为start函数，此时处于实模式。首先需要关闭中断，避免产生中断被BIOS中断处理程序处理。之后将各个段寄存器基址设为0。

3. 开启a20模式，将总线从20位变为32位

```
    # Enable A20:
    #  For backwards compatibility with the earliest PCs, physical
    #  address line 20 is tied low, so that addresses higher than
    #  1MB wrap around to zero by default. This code undoes this.

    # 等待8042 Input buffer为空，即等待8042芯片为空闲状态。判断8042是否空闲可以通过循环读取8042的状态寄存器到CPU寄存器al，判断al是否为0x2(芯片初始系统状态)来实现。
seta20.1:
    inb $0x64, %al                                  # Wait for not busy(8042 input buffer empty).
    testb $0x2, %al
    jnz seta20.1

    # 发送Write 8042 Output Port （P2）命令到8042 Input buffer。
    movb $0xd1, %al                                 # 0xd1 -> port 0x64
    outb %al, $0x64                                 # 0xd1 means: write data to 8042's P2 port

seta20.2:
    # 等待8042输入端口空闲
    inb $0x64, %al                                  # Wait for not busy(8042 input buffer empty).
    testb $0x2, %al
    jnz seta20.2

    # 发送Write 8042 Output Port （P2）命令到8042 Input buffer。
    movb $0xdf, %al                                 # 0xdf -> port 0x60
    outb %al, $0x60                                 # 0xdf = 11011111, means set P2's A20 bit(the 1 bit) to 1
```

4. 初始化GDT表

在分段存储管理机制的保护模式下，每个段由如下三个参数进行定义：段基地址、段界限和段属性。而asm.h文件通过宏的方式来定义了初始化段描述符的宏函数，因此我们来查看asm.h：

```
/* Normal segment */
#define SEG_NULLASM                                             \
    .word 0, 0;                                                 \
    .byte 0, 0, 0, 0
```

SEG_NULLASM中.word代表生成一个字长度（此处2字节，由16位实模式所决定)的数, 而.byte代表生成一个字节的数。因此SEG_NULLASM声明要生成两个字（每个字2字节）长度的数0，接着生成4个字节的数0。

```
#define SEG_ASM(type,base,lim)                                  \
    .word (((lim) >> 12) & 0xffff), ((base) & 0xffff);          \
    .byte (((base) >> 16) & 0xff), (0x90 | (type)),             \
        (0xC0 | (((lim) >> 28) & 0xf)), (((base) >> 24) & 0xff)
```

SEG_ASM中，两个word分别定义为0xffff和0x0000。前者是0xffffffff右移12位变为0x000fffff，然后与0x0000ffff项相与得到0xffff，而后者是0x0000&0xffff=0x0000。对于后面的4个byte，第一个为0x00（段基址23~16 ），第二个为0x90（ P=1、DPL=00、S=1、TYPE=type），第三个为0xcf（G=1、D/B=1、L=0、AVL=0、段界限19~16 ），第四个为0x00（段基址31~24）。
我们可知这个段描述符大小为8字节，即64位，0xffff对应段描述符0-15位，0x0000对应16-31位，然后4个byte对应高位。所以最后得到的段基地址就是0x00000000。

在bootasm.S，查看GDT的初始化。

```
# Bootstrap GDT，设置GDT表
.p2align 2                                          # force 4 byte alignment，强制4字节对齐
gdt:                                                    
    SEG_NULLASM                                     # null seg，空段
    SEG_ASM(STA_X|STA_R, 0x0, 0xffffffff)           # code seg for bootloader and kernel
    SEG_ASM(STA_W, 0x0, 0xffffffff)                 # data seg for bootloader and kernel

gdtdesc:
    .word 0x17                                      # sizeof(gdt) - 1，GDT边界，三个段，共3 * 8 = 24 B，值为24 - 1 = 23 (0x17)
    .long gdt                                       # address gdt，GTD基址，长度32
```

GDT被设置为４字节对齐，仅定义了GDT[0]（空段）、GDT[1]（内核代码段）、GDT[2]（内核数据段）。代码段和数据段基址均为0，总长度都为整个内存空间4G大小，因此逻辑地址=线性地址

在实模式中，CPU通过段地址和段偏移量寻址。其中段地址保存到段寄存器，包含：`CS、SS、DS、ES、FS、GS`。段偏移量可以保存到`IP、BX、SI、DI`寄存器。

而在保护模式下，也是通过段寄存器和段偏移量寻址，但是此时段寄存器保存的数据意义不同了。
此时的`CS`和`SS`寄存器后13位相当于GDT表中某个描述符的索引，即段选择子。第2位存储了TI值（0代表GDT，1代表LDT），第0、1位存储了当前的特权级（CPL）。

```
    lgdt gdtdesc
```

4. 进入保护模式：

初始化GDT后，通过lgdt指令来将GDT信息写入GDTR。此时我们已经完成bootloader切换到保护模式的全部准备工作。开启保护模式仅需要打开控制寄存器CR0中相应的标志位，通过异或之前定义的CR0_PE_ON即可实现。

```
    # Switch from real to protected mode, using a bootstrap GDT
    # and segment translation that makes virtual addresses
    # identical to physical addresses, so that the
    # effective memory map does not change during the switch.
    lgdt gdtdesc    #将GDT信息写入GDTR。
    movl %cr0, %eax
    orl $CR0_PE_ON, %eax  
    movl %eax, %cr0  #打开保护模式
```

此时CPU真正进入了32位模式，即保护模式。进入该模式后，ljmp指令重新初始化了代码段寄存器CS的值，其中CS的前12位为0x001，将其乘以8为0x008作为gdt表的偏移值来选择段描述符，所以其选择即为CS段描述符，其Base为0，偏移地址即为protcseg的地址。需要注意的是，由于我们bootloader程序代码段在实模式加载到内存时其从0x7c00的物理地址向高位内存加载，故当我们在分段模式下设定Base地址为0时，偏移地址为protcseg地址时，在保护模式下正好能运行bootloader中protcseg段代码。

```
    # Jump to next instruction, but in 32-bit code segment.
    # Switches processor into 32-bit mode.
    ljmp $PROT_MODE_CSEG, $protcseg
```

随后将所有段寄存器设置为PROT_MODE_DSEG（指向内核数据段）。将栈区域设置为0x00~0x7c00，即bootloader之下都是栈的空间，然后使用call指令执行bootmain.c，开始加载kernel。bootmain函数正常情况不会返回，如果返回肯定是bootloader产生错误，进入死循环。

重新设置寄存器的值，在建立好段和堆栈之后进入主方法。

```
        movw $PROT_MODE_DSEG, %ax
        movw %ax, %ds
        movw %ax, %es
        movw %ax, %fs
        movw %ax, %gs
        movw %ax, %ss
        movl $0x0, %ebp
        movl $start, %esp
        call bootmain
```

[一些需要解释的地方]>

1. 为什么要用8042键盘输入口？

IBM公司发明了使用一个开关来开启或禁止`0x100000`地址比特位。由于当时的8042键盘控制器上恰好有空闲的端口引脚（输出端口P2，引脚P21），于是便使用了该引脚来作为与门控制这个地址比特位。该信号即被称为A20。如果它为零，则比特20及以上地址都被清除。其实也有其它更快的方法。

2. CR0寄存器是什么？

是系统内的控制寄存器之一。控制寄存器是一些特殊的寄存器，它们可以控制CPU的一些重要特性。
0位是保护允许位PE(Protedted Enable)，用于启动保护模式，如果PE位置1，则保护模式启动，如果PE=0，则在实模式下运行。
其它几位具有其他的作用。

## [练习4]

分析`bootloader`加载ELF格式的OS的过程。

`bootloader`需要把kernel从虚拟磁盘读取到内存中。在`bootmain.c`文件中定义了三个函数：`waitdisk()`，`readsect()`，`readseg()`和`bootmain()`。

1. 首先查看`waitdisk()`函数，它的作用是等待磁盘准备工作完成。

```
while ((inb (0x1F7) & 0xC0) != 0x40)
```

意思是不断查询读`0x1F7`寄存器的最高两位，直到最高位为0、次高位为1才返回。而0x1F7就是磁盘的状态寄存器。最高位为0表示磁盘不繁忙，次高位为1代表磁盘空闲。

2. 查看readsect()函数。

`readsect`从设备的第secno扇区读取数据到dst位置

```
    static void
    readsect(void *dst, uint32_t secno) {
        waitdisk();

        outb(0x1F2, 1);                         // 设置读取扇区的数目为1
        outb(0x1F3, secno & 0xFF);
        outb(0x1F4, (secno >> 8) & 0xFF);
        outb(0x1F5, (secno >> 16) & 0xFF);
        outb(0x1F6, ((secno >> 24) & 0xF) | 0xE0);
            // 上面四条指令联合制定了扇区号
            // 在这4个字节线联合构成的32位参数中
            //   29-31位强制设为1
            //   28位(=0)表示访问"Disk 0"
            //   0-27位是28位的偏移量
        outb(0x1F7, 0x20);                      // 0x20命令，读取扇区

        waitdisk();

        insl(0x1F0, dst, SECTSIZE / 4);         // 读取到dst位置，
                                                // 幻数4因为这里以DW为单位
    }
```

此处就需要了解其它和磁盘驱动有关的寄存器了。

`0x1F0/Data`，唯一一个16bit的寄存器，用来传输数据。

`0x1F1/Error`，读的时候表示错误，8bit，每一位表示一种错误。

`0x1F2/Sector Count`，表扇区总数，读写的时候指定要操作的扇区总数。

`0x1F3,0x1F4,0x1F5` 分别表示LBA地址的低中高8位，

`0x1F6`中，0~3位为LBA地址的最高4位，DRV位为1表示该盘是主盘，0表示该盘是从盘，LBA位为1表示采用LBA寻址，0表示采用CHS寻址，bit 5和bit 1固定为1。

在LBA模式下，硬盘上的一个数据区域由它所在的磁头、柱面（也就是磁道）和扇区所唯一确定。通过以上输入输出操作可以从磁盘的指定扇区读取数据到dst所指的位置。

3. 查看`readseg()`函数

`readseg`简单包装了`readsect`，可以从设备读取任意长度的内容。其核心逻辑实现从多个扇区读取数据时的跳转。

readseg函数提供的功能是从磁盘读取count字节数据到虚拟地址va中，但是读取硬盘是以512字节的扇区为单位的。所以实际读入的字节数很可能大于要求读入的字节数。考虑到readseg的偏移读取，通过va -= offset % SECTSIZE来向下对准到磁盘边界，如果读取磁盘中内核文件的起始数据不位于一个扇区的开始，应将va减小，使得完整读取一个扇区后，原va处正好就是内核文件经过偏移offset后的起始数据。

```
    static void
    readseg(uintptr_t va, uint32_t count, uint32_t offset) {
        uintptr_t end_va = va + count;

        va -= offset % SECTSIZE;

        uint32_t secno = (offset / SECTSIZE) + 1; 
        // 加1因为0扇区被引导占用
        // ELF文件从1扇区开始

        for (; va < end_va; va += SECTSIZE, secno ++) {
            readsect((void *)va, secno);
        }
    }
```

4. 查看`bootmain()`函数

```
    void
    bootmain(void) {
        // 首先读取ELF的头部
        readseg((uintptr_t)ELFHDR, SECTSIZE * 8, 0);

        // 通过储存在头部的幻数判断是否是合法的ELF文件
        if (ELFHDR->e_magic != ELF_MAGIC) {
            goto bad;
        }

        struct proghdr *ph, *eph;

        // ELF头部有描述ELF文件应加载到内存什么位置的描述表，
        // 先将描述表的头地址存在ph
        ph = (struct proghdr *)((uintptr_t)ELFHDR + ELFHDR->e_phoff);
        eph = ph + ELFHDR->e_phnum;

        // 按照描述表将ELF文件中数据载入内存
        for (; ph < eph; ph ++) {
            readseg(ph->p_va & 0xFFFFFF, ph->p_memsz, ph->p_offset);
        }
        // ELF文件0x1000位置后面的0xd1ec比特被载入内存0x00100000
        // ELF文件0xf000位置后面的0x1d20比特被载入内存0x0010e000

        // 根据ELF头部储存的入口信息，找到内核的入口
        ((void (*)(void))(ELFHDR->e_entry & 0xFFFFFF))();

    bad:
        outw(0x8A00, 0x8A00);
        outw(0x8A00, 0x8E00);
        while (1);
    }
```

分析可得载入流程为：
（1）先从硬盘读取一页大小数据（4K）到内存0x10000地址处，即读取kernel的ELF文件头和程序头表加载到ELFHDR（0x10000）处。
（2）然后通过ELF文件头的魔数判断ELF文件格式是否合法。
（3）如果格式合法就根据kernel中的ELF文件头和程序头表中的信息将kernel各段加载到内存中。
（4）最后根据ELF文件头储存的入口信息，找到内核的入口。

ELF文件头结构定义在`/usr/include/elf.h`头文件下，此处应为32位。其头部的幻数为`0x7f454c46`分别对应ascii码的Del(删除)、字母E、字母L、字母F。其余结构成员如下

| **成员**    | **readelf输出结果**           |
| --------- | ------------------------- |
| e_ident   | Magic,类别，数据，版本，OS/ABI,ABI |
| e_type    | 类型                        |
| e_machine | 系统架构                      |
| e_version | 版本                        |
| e_entry   | 入口点地址                     |
| e_phoff   | 程序头起点                     |
| e_shoff   | 段起点                       |
| e_flags   | 标志                        |
| e_ehsize  | 文件头的大小                    |

## [练习5]

实现函数调用堆栈跟踪函数 

我们需要完成`kdebug.c`中函数`print_stackframe`的实现，可以通过函数`print_stackframe`来跟踪函数调用堆栈中记录的返回地址。如果能够正确实现此函数，`make qemu`后，在`qemu`模拟器中得到输出：

`ss:ebp`指向的堆栈位置储存着`caller`的`ebp`，以此为线索可以得到所有使用堆栈的函数ebp。
`ss:ebp+4`指向`caller`调用时的`eip`，`ss:ebp+8`等是可能的参数。

由于显示完整的栈结构需要解析内核文件中的调试符号，较为复杂和繁琐。代码中有一些辅助函数可以使用。例如可以通过调用`print_debuginfo`函数完成查找对应函数名并打印至屏幕的功能。具体可以参见`kdebug.c`代码中的注释。

```
void print_stackframe(void) {
     /* LAB1 YOUR CODE : STEP 1 */
     /* (1) call read_ebp() to get the value of ebp. the type is (uint32_t);
      * (2) call read_eip() to get the value of eip. the type is (uint32_t);
      * (3) from 0 .. STACKFRAME_DEPTH
      *    (3.1) printf value of ebp, eip
      *    (3.2) (uint32_t)calling arguments [0..4] = the contents in address (uint32_t)ebp +2 [0..4]
      *    (3.3) cprintf("\n");
      *    (3.4) call print_debuginfo(eip-1) to print the C calling function name and line number, etc.
      *    (3.5) popup a calling stackframe
      *           NOTICE: the calling funciton's return addr eip  = ss:[ebp+4]
      *                   the calling funciton's ebp = ss:[ebp]
      */

    // 通过函数读取ebp、eip寄存器值，分别表示指向栈底的地址、当前指令的地址
    uint32_t ebp = read_ebp();
    uint32_t eip = read_eip();

    // 定义当前深度
    int depth = 0;

    // 循环，以至打印到设定的最大堆栈深度
    // ebp == 0，代表着没有更深的函数栈帧了
    for (; ebp != 0 && depth < STACKFRAME_DEPTH; depth ++) {
        // 打印第一行，标识出ebp和eip的值
        cprintf("ebp:0x%08x eip:0x%08x args:", ebp, eip);
        // 可能的参数存在于ebp底第二个地址
        uint32_t *args = (uint32_t *)ebp + 2;
        // 默认最多打印四个参数
        for (int j = 0; j < 4; j ++) {
            cprintf("0x%08x ", args[j]);
        }
        cprintf("\n");
        // 能够查找到对应的函数相关信息，包括函数名，所在文件的行号等
        // eip - 1
        print_debuginfo(eip - 1);
        // 将eip赋为栈底的返回地址，edp赋为其存放的地址中的值
        eip = ((uint32_t *)ebp)[1];
        ebp = ((uint32_t *)ebp)[0];
    }
```

`make qemu`正常运行

```
Kernel executable memory footprint: 68KB
ebp:0x00007b28 eip:0x00100ab3 args:0x00010094 0x00010094 0x00007b58 0x00100096 
    kern/debug/kdebug.c:308: print_stackframe+25
ebp:0x00007b38 eip:0x00100db5 args:0x00000000 0x00000000 0x00000000 0x00007ba8 
    kern/debug/kmonitor.c:125: mon_backtrace+14
ebp:0x00007b58 eip:0x00100096 args:0x00000000 0x00007b80 0xffff0000 0x00007b84 
    kern/init/init.c:48: grade_backtrace2+37
ebp:0x00007b78 eip:0x001000c4 args:0x00000000 0xffff0000 0x00007ba4 0x00000029 
    kern/init/init.c:53: grade_backtrace1+42
ebp:0x00007b98 eip:0x001000e7 args:0x00000000 0x00100000 0xffff0000 0x0000001d 
    kern/init/init.c:58: grade_backtrace0+27
ebp:0x00007bb8 eip:0x00100111 args:0x0010343c 0x00103420 0x0000130a 0x00000000 
    kern/init/init.c:63: grade_backtrace+38
ebp:0x00007be8 eip:0x00100055 args:0x00000000 0x00000000 0x00000000 0x00007c4f 
    kern/init/init.c:28: kern_init+84
ebp:0x00007bf8 eip:0x00007d74 args:0xc031fcfa 0xc08ed88e 0x64e4d08e 0xfa7502a8 
    <unknow>: -- 0x00007d73 --
```

最后一行是ebp:0x00007bf8 eip:0x00007d74 args:0xc031fcfa 0xc08ed88e 0x64e4d08e 0xfa7502a8，共有ebp，eip和args三类参数，下面分别给出解释。

ebp:0x00007bf8：此时ebp的值是kern_init函数的栈顶地址，从前面练习我们知道，整个栈的栈顶地址为0x00007c00，ebp指向的栈位置存放调用者的ebp寄存器的值，ebp+4指向的栈位置存放返回地址的值，这意味着kern_init函数的调用者（也就是bootmain函数）没有传递任何输入参数给它！因为单是存放旧的ebp、返回地址已经占用8字节了。

eip:0x00007d74：eip的值是kern_init函数的返回地址，也就是bootmain函数调用kern_init对应的指令的下一条指令的地址，反汇编bootmain函数证实了这个判断。

## [练习六]

1. 中断描述符表（也可简称为保护模式下的中断向量表）中一个表项占多少字节？其中哪几位代表中断处理代码的入口？

操作系统需要对计算机系统中的各种外设进行管理，这就需要CPU和外设能够相互通信才行。一般外设的速度远慢于CPU的速度。如果让操作系统通过CPU“主动关心”外设的事件，即采用通常的轮询(polling)机制，则太浪费CPU资源了。所以需要操作系统和CPU能够一起提供某种机制，让外设在需要操作系统处理外设相关事件的时候，能够“主动通知”操作系统，即打断操作系统和应用的正常执行，让操作系统完成外设的相关处理，然后在恢复操作系统和应用的正常执行。在操作系统中，这种机制称为中断机制。

主要的中断类型有外部中断（中断）、内部中断（异常）、软中断（陷阱、系统调用）。
外部中断：用于cpu与外设进行通信，当外设需要输入或输出时主动向cpu发出中断请求。
内部中断：cpu执行期间检测到不正常或非法条件（如除零错、地址访问越界）时会引起内部中断。
系统调用：用于程序使用系统调用服务。

当中断发生时，cpu会得到一个中断向量号，作为IDT（中断描述符表）的索引，IDT表起始地址由IDTR寄存器存储，cpu会从IDT表中找到该中断向量号相应的中断服务程序入口地址，跳转到中断处理程序处执行，并保存当前现场；当中断程序执行完毕，恢复现场，跳转到原中断点处继续执行。而IDT的表项为中断描述符，主要类型有中断门、陷阱门、调用门。
中断描述符作为IDT的表项，每个表项占据8字节（64位），其中段选择子和偏移地址用来代表中断处理程序入口地址，即0到31位，47到63位代表中断处理代码的入口。具体流程是，先通过选择子查找GDT对应段描述符，得到该代码段的基址，基址加上偏移地址为中断处理程序入口地址。
而mmu.h中对中断描述符的定义也佐证了以上结论：

```
/* Gate descriptors for interrupts and traps */
struct gatedesc {
    unsigned gd_off_15_0 : 16;        // low 16 bits of offset in segment
    unsigned gd_ss : 16;            // segment selector
    unsigned gd_args : 5;            // # args, 0 for interrupt/trap gates
    unsigned gd_rsv1 : 3;            // reserved(should be zero I guess)
    unsigned gd_type : 4;            // type(STS_{TG,IG32,TG32})
    unsigned gd_s : 1;                // must be 0 (system)
    unsigned gd_dpl : 2;            // descriptor(meaning new) privilege level
    unsigned gd_p : 1;                // Present
    unsigned gd_off_31_16 : 16;        // high bits of offset in segment
};
```

2. 请编程完善kern/trap/trap.c中对中断向量表进行初始化的函数idt_init。在idt_init函数中，依次对所有中断入口进行初始化。使用mmu.h中的SETGATE宏，填充idt数组内容。每个中断的入口由tools/vectors.c生成，使用trap.c中声明的vectors数组即可。

由于每个中断的入口由tools/vectors.c生成，而kern/trap/vectors.S是由tools/vector.c在编译ucore期间动态生成的，包括256个中断服务例程的入口地址和第一步初步处理实现

```
# handler
.text
.globl __alltraps
.globl vector0
vector0:
 pushl $0
 pushl $0
 jmp __alltraps
.globl vector1
vector1:
 pushl $0
 pushl $1
 jmp __alltraps
...

# vector table
.data
.globl __vectors
__vectors:
 .long vector0
 .long vector1
 .long vector2
...
```

__vectors存储了各中断处理程序入口地址，每一个中断处理程序依次将错误码、中断向量号压栈（一些由cpu自动压入错误码的只压入中断向量号），再调用trapentry.S中的__alltraps进行处理。

根据中断描述符格式使用SETGATE宏函数对IDT进行初始化后，在这里先全部设为中断门（istrap为0），中断处理程序均在内核态执行，因此代码段为内核的代码段，DPL应为内核态的0。
id_init函数：

```
/* idt_init - initialize IDT to each of the entry points in kern/trap/vectors.S */
void
idt_init(void) {
     /* LAB1  : STEP 2 */
     /* (1) Where are the entry addrs of each Interrupt Service Routine (ISR)?
      *     All ISR's entry addrs are stored in __vectors. where is uintptr_t __vectors[] ?
      *     __vectors[] is in kern/trap/vector.S which is produced by tools/vector.c
      *     (try "make" command in lab1, then you will find vector.S in kern/trap DIR)
      *     You can use  "extern uintptr_t __vectors[];" to define this extern variable which will be used later.
      * (2) Now you should setup the entries of ISR in Interrupt Description Table (IDT).
      *     Can you see idt[256] in this file? Yes, it's IDT! you can use SETGATE macro to setup each item of IDT
      * (3) After setup the contents of IDT, you will let CPU know where is the IDT by using 'lidt' instruction.
      *     You don't know the meaning of this instruction? just google it! and check the libs/x86.h to know more.
      *     Notice: the argument of lidt is idt_pd. try to find it!
      */
    extern uintptr_t __vectors[];
    //引用另一个文件中的__vectors
    for (int i = 0; i < 256; i++)
    SETGATE(idt[i], 0, GD_KTEXT, __vectors[i], DPL_KERNEL);
    //在IDT中建立中断描述符，其中存储了中断处理例程的代码段GD_KTEXT和偏移量__vectors[i]，特权级为DPL_KERNEL。这样通过查询idt[i]就可定位到中断服务例程的起始地址。
    SETGATE(idt[T_SYSCALL], 0, GD_KTEXT, __vectors[T_SYSCALL], DPL_USER);
    //为系统调用中断设置用户态权限（DPL3）
    lidt(&idt_pd);
    //载入LDT，即将LDT存入LDTR
}
```

3. 请编程完善trap.c中的中断处理函数trap，在对时钟中断进行处理的部分填写trap函数中处理时钟中断的部分，使操作系统每遇到100次时钟中断后，调用print_ticks子程序，向屏幕上打印一行文字”100 ticks”。

根据注释可以了解到，trap函数是对中断进行处理的过程，所有的中断在经过中断入口函数__alltraps预处理后 (定义在 trapasm.S中) ，都会跳转到这里。在处理过程中，根据不同的中断类型，进行相应的处理。在相应的处理过程结束以后，trap将会返回，被中断的程序会继续运行。而被打断程序会保存trapframe（栈帧）中。

```
Struct trapframe
{
uint edi;
uint esi;
uint ebp;
...
ushort es;
ushort padding1;
ushort ds;
ushort padding2;
uint trapno;
uint err;
uint eip;
...
}
```

而_alltraps为各中断处理程序的前置代码，用于继续在栈中完成trapframe结构，依次压入ds、es、fs、gs、通用寄存器，并将数据段切换为内核数据段（代码段在IDT初始化过程中设置为内核代码段），最后压入trapframe结构体指针作为trap函数的参数，再调用trap函数完成具体的中断处理，代码如下：

```
# vectors.S sends all traps here.
.text
.globl __alltraps
__alltraps:
    # push registers to build a trap frame
    # therefore make the stack look like a struct trapframe
    pushl %ds
    pushl %es
    pushl %fs
    pushl %gs
    pushal

    # load GD_KDATA into %ds and %es to set up data segments for kernel
    movl $GD_KDATA, %eax
    movw %ax, %ds
    movw %ax, %es

    # push %esp to pass a pointer to the trapframe as an argument to trap()
    pushl %esp

    # call trap(tf), where tf=%esp
    call trap

    # pop the pushed stack pointer
    popl %esp

    # return falls through to trapret...
```

而_alltraps为各中断处理程序的前置代码，用于继续在栈中完成trapframe结构，依次压入ds、es、fs、gs、通用寄存器，并将数据段切换为内核数据段（代码段在IDT初始化过程中设置为内核代码段），最后压入trapframe结构体指针作为trap函数的参数，再调用trap函数完成具体的中断处理，代码如下：

```
# vectors.S sends all traps here.
.text
.globl __alltraps
__alltraps:
    # push registers to build a trap frame
    # therefore make the stack look like a struct trapframe
    pushl %ds
    pushl %es
    pushl %fs
    pushl %gs
    pushal

    # load GD_KDATA into %ds and %es to set up data segments for kernel
    movl $GD_KDATA, %eax
    movw %ax, %ds
    movw %ax, %es

    # push %esp to pass a pointer to the trapframe as an argument to trap()
    pushl %esp

    # call trap(tf), where tf=%esp
    call trap

    # pop the pushed stack pointer
    popl %esp

    # return falls through to trapret...
```

然后trap_dispatch函数根据trapframe获取中断号去处理相应中断，处理时钟中断的代码如下：

```
/* trap_dispatch - dispatch based on what type of trap occurred */
static void
trap_dispatch(struct trapframe *tf) {
    char c;

    switch (tf->tf_trapno) {
    case IRQ_OFFSET + IRQ_TIMER:
        /* LAB1  : STEP 3 */
        /* handle the timer interrupt */
        /* (1) After a timer interrupt, you should record this event using a global variable (increase it), such as ticks in kern/driver/clock.c
         * (2) Every TICK_NUM cycle, you can print some info using a funciton, such as print_ticks().
         * (3) Too Simple? Yes, I think so!
         */
        ticks++;
        if (ticks % TICK_NUM == 0) {
            print_ticks();
        }
        break;
    case IRQ_OFFSET + IRQ_COM1:
        c = cons_getc();
        cprintf("serial [%03d] %c\n", c, c);
        break;
    case IRQ_OFFSET + IRQ_KBD:
        c = cons_getc();
        cprintf("kbd [%03d] %c\n", c, c);
        break;
    //LAB1 CHALLENGE 1 : YOUR CODE you should modify below codes.
    case T_SWITCH_TOU:
    case T_SWITCH_TOK:
        panic("T_SWITCH_** ??\n");
        break;
    case IRQ_OFFSET + IRQ_IDE1:
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
    default:
        // in kernel, it must be a mistake
        if ((tf->tf_cs & 3) == 0) {
            print_trapframe(tf);
            panic("unexpected trap in kernel.\n");
        }
    }
}
```

运行结果如下：

```
++ setup timer interrupts
100 ticks
100 ticks
100 ticks
100 ticks
100 ticks
```
