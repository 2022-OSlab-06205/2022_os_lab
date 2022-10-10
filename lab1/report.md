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

1. 首先，阅读gitbook对应章节，了解ucore中中断处理相关原理，可知产生中断的方法为内联对应的汇编代码，并将参数设置为中断向量号。int指令为x86的中断触发指令，系统在接收到中断之后会从tarp_entry.S进入，在压入原有寄存器等信息之后，跳转至trap.c中的trap函数当中。trap函数的处理过程为trap_dispatch通过switch语句分类处理各种中断。其中有关内核和用户模式的切换需要对tf进行修改，修改cs寄存器的值，并将低位修改为0或者3，这样就会让操作系统以为level已被修改。

2. 查看kernel/drivers中的console.c，内含有关键盘输入字符触发的处理函数kbd_proc_data，它会识别传入的data，并找到其对应的字符c，再返回。其中如果识别出data == 0x04或者data == 0x0b，即按下的按键为键盘上方的数字3或0，就会执行我们在trap.c新定义的函数switch_to_user和switch_to_kernel，其本质也是内联汇编。

3. 在trap_dispatch对应分支下添加print_trapframe()，打印中断帧的状态。运行make qemu检测是否正确。可以发现按下0时，能够正确切换至内核状态，并继续输出100ticks。按下3时，虽然也能正确切换至用户状态，但是无法继续打印100ticks了。据猜测应该是用户模式下无法执行中断处理代码，或者中断无法触发。在末尾重新切换会内核状态即可结束调试。

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
HOSTCC		:= gcc
......
else
HOSTCC		:= clang
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

以下为`make`执行时具体运行的代码

```
# 生成ucore.img的顶层命令：
# create ucore.img
UCOREIMG	:= $(call totarget,ucore.img)

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

# 从bootmain.c和bootasm.S编译生成bootmain
.o和bootasm.o文件的命令为：

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
271	memset(void *s, char c, size_t n) {
```

```
(gdb) break cprintf
Breakpoint 2 at 0x100284: file kern/libs/stdio.c, line 40.
(gdb) continue
Continuing.

Breakpoint 2, cprintf (fmt=0x10339c "%s\n\n") at kern/libs/stdio.c:40
40	cprintf(const char *fmt, ...) {
(gdb) continue
Continuing.

Breakpoint 2, cprintf (fmt=0x103482 "Special kernel symbols:\n")
    at kern/libs/stdio.c:40
40	cprintf(const char *fmt, ...) {
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

1. 初始化寄存器

```
cli
cld
xorw %ax, %ax
movw %ax, %ds
movw %ax, %es
movw %ax, %ss
```
分别将ax，ds，es，ss寄存器置为0。

2. 开启a20模式，将总线从20位变为32位

```
    # Enable A20:
    #  For backwards compatibility with the earliest PCs, physical
    #  address line 20 is tied low, so that addresses higher than
    #  1MB wrap around to zero by default. This code undoes this.

	# 等待8042输入端口空闲
seta20.1:
    inb $0x64, %al                                  # Wait for not busy(8042 input buffer empty).
    testb $0x2, %al
    jnz seta20.1

	# 向端口发送写指令
    movb $0xd1, %al                                 # 0xd1 -> port 0x64
    outb %al, $0x64                                 # 0xd1 means: write data to 8042's P2 port

seta20.2:
	# 等待8042输入端口空闲
    inb $0x64, %al                                  # Wait for not busy(8042 input buffer empty).
    testb $0x2, %al
    jnz seta20.2

	# 发送打开A20指令
    movb $0xdf, %al                                 # 0xdf -> port 0x60
    outb %al, $0x60                                 # 0xdf = 11011111, means set P2's A20 bit(the 1 bit) to 1
```

3. 初始化GDT表


在实模式中，CPU通过段地址和段偏移量寻址。其中段地址保存到段寄存器，包含：`CS、SS、DS、ES、FS、GS`。段偏移量可以保存到`IP、BX、SI、DI`寄存器。

而在保护模式下，也是通过段寄存器和段偏移量寻址，但是此时段寄存器保存的数据意义不同了。
此时的`CS`和`SS`寄存器后13位相当于GDT表中某个描述符的索引，即段选择子。第2位存储了TI值（0代表GDT，1代表LDT），第0、1位存储了当前的特权级（CPL）。

```
    lgdt gdtdesc
```

4. 进入保护模式：

打开保护模式标志位，相当于按下了保护模式的开关。`cr0`寄存器的第0位就是这个开关，通过`CR0_PE_ON`或`cr0`寄存器，将第0位置1。

```
    movl %cr0, %eax
    orl $CR0_PE_ON, %eax
    movl %eax, %cr0
```

更新cs的基地址，此时地址就不是实地址了，而是通过了GDT表转换的逻辑地址。

```
     ljmp $PROT_MODE_CSEG, $protcseg
    .code32
    protcseg:
```

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

ELF文件头结构定义在`/usr/include/elf.h`头文件下，此处应为32位。其头部的幻数为`0x7f454c46`分别对应ascii码的Del(删除)、字母E、字母L、字母F。其余结构成员如下

| **成员**    | **readelf输出结果**           |
|-----------|----------------------------|
| e_ident   | Magic,类别，数据，版本，OS/ABI,ABI  |
| e_type    | 类型                         |
| e_machine | 系统架构                       |
| e_version | 版本                         |
| e_entry   | 入口点地址                      |
| e_phoff   | 程序头起点  |
| e_shoff   | 段起点   |
| e_flags   | 标志                         |
| e_ehsize  | 文件头的大小                     |


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

    // 初始化当前ebp和eip
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


