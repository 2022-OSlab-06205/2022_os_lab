
bin/kernel：     文件格式 elf32-i386


Disassembly of section .text:

c0100000 <kern_entry>:

.text
.globl kern_entry
kern_entry:
    # load pa of boot pgdir
    movl $REALLOC(__boot_pgdir), %eax
c0100000:	b8 00 b0 11 00       	mov    $0x11b000,%eax
    movl %eax, %cr3
c0100005:	0f 22 d8             	mov    %eax,%cr3

    # enable paging
    movl %cr0, %eax
c0100008:	0f 20 c0             	mov    %cr0,%eax
    orl $(CR0_PE | CR0_PG | CR0_AM | CR0_WP | CR0_NE | CR0_TS | CR0_EM | CR0_MP), %eax
c010000b:	0d 2f 00 05 80       	or     $0x8005002f,%eax
    andl $~(CR0_TS | CR0_EM), %eax
c0100010:	83 e0 f3             	and    $0xfffffff3,%eax
    movl %eax, %cr0
c0100013:	0f 22 c0             	mov    %eax,%cr0

    # update eip
    # now, eip = 0x1.....
    leal next, %eax
c0100016:	8d 05 1e 00 10 c0    	lea    0xc010001e,%eax
    # set eip = KERNBASE + 0x1.....
    jmp *%eax
c010001c:	ff e0                	jmp    *%eax

c010001e <next>:
next:

    # unmap va 0 ~ 4M, it's temporary mapping
    xorl %eax, %eax
c010001e:	31 c0                	xor    %eax,%eax
    movl %eax, __boot_pgdir
c0100020:	a3 00 b0 11 c0       	mov    %eax,0xc011b000

    # set ebp, esp
    movl $0x0, %ebp
c0100025:	bd 00 00 00 00       	mov    $0x0,%ebp
    # the kernel stack region is from bootstack -- bootstacktop,
    # the kernel stack size is KSTACKSIZE (8KB)defined in memlayout.h
    movl $bootstacktop, %esp
c010002a:	bc 00 a0 11 c0       	mov    $0xc011a000,%esp
    # now kernel stack is ready , call the first C function
    call kern_init
c010002f:	e8 02 00 00 00       	call   c0100036 <kern_init>

c0100034 <spin>:

# should never get here
spin:
    jmp spin
c0100034:	eb fe                	jmp    c0100034 <spin>

c0100036 <kern_init>:
int kern_init(void) __attribute__((noreturn));
void grade_backtrace(void);
static void lab1_switch_test(void);

int
kern_init(void) {
c0100036:	f3 0f 1e fb          	endbr32 
c010003a:	55                   	push   %ebp
c010003b:	89 e5                	mov    %esp,%ebp
c010003d:	83 ec 28             	sub    $0x28,%esp
    extern char edata[], end[];
    memset(edata, 0, end - edata);
c0100040:	b8 88 df 11 c0       	mov    $0xc011df88,%eax
c0100045:	2d 00 d0 11 c0       	sub    $0xc011d000,%eax
c010004a:	89 44 24 08          	mov    %eax,0x8(%esp)
c010004e:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0100055:	00 
c0100056:	c7 04 24 00 d0 11 c0 	movl   $0xc011d000,(%esp)
c010005d:	e8 bc 5c 00 00       	call   c0105d1e <memset>

    cons_init();                // init the console
c0100062:	e8 4f 16 00 00       	call   c01016b6 <cons_init>

    const char *message = "(THU.CST) os is loading ...";
c0100067:	c7 45 f4 60 65 10 c0 	movl   $0xc0106560,-0xc(%ebp)
    cprintf("%s\n\n", message);
c010006e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100071:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100075:	c7 04 24 7c 65 10 c0 	movl   $0xc010657c,(%esp)
c010007c:	e8 44 02 00 00       	call   c01002c5 <cprintf>

    print_kerninfo();
c0100081:	e8 02 09 00 00       	call   c0100988 <print_kerninfo>

    grade_backtrace();
c0100086:	e8 95 00 00 00       	call   c0100120 <grade_backtrace>

    pmm_init();                 // init physical memory management
c010008b:	e8 aa 35 00 00       	call   c010363a <pmm_init>

    pic_init();                 // init interrupt controller
c0100090:	e8 9c 17 00 00       	call   c0101831 <pic_init>
    idt_init();                 // init interrupt descriptor table
c0100095:	e8 41 19 00 00       	call   c01019db <idt_init>

    clock_init();               // init clock interrupt
c010009a:	e8 5e 0d 00 00       	call   c0100dfd <clock_init>
    intr_enable();              // enable irq interrupt
c010009f:	e8 d9 18 00 00       	call   c010197d <intr_enable>
    //LAB1: CAHLLENGE 1 If you try to do it, uncomment lab1_switch_test()
    // user/kernel mode switch test
    //lab1_switch_test();

    /* do nothing */
    while (1);
c01000a4:	eb fe                	jmp    c01000a4 <kern_init+0x6e>

c01000a6 <grade_backtrace2>:
}

void __attribute__((noinline))
grade_backtrace2(int arg0, int arg1, int arg2, int arg3) {
c01000a6:	f3 0f 1e fb          	endbr32 
c01000aa:	55                   	push   %ebp
c01000ab:	89 e5                	mov    %esp,%ebp
c01000ad:	83 ec 18             	sub    $0x18,%esp
    mon_backtrace(0, NULL, NULL);
c01000b0:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c01000b7:	00 
c01000b8:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c01000bf:	00 
c01000c0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c01000c7:	e8 1b 0d 00 00       	call   c0100de7 <mon_backtrace>
}
c01000cc:	90                   	nop
c01000cd:	c9                   	leave  
c01000ce:	c3                   	ret    

c01000cf <grade_backtrace1>:

void __attribute__((noinline))
grade_backtrace1(int arg0, int arg1) {
c01000cf:	f3 0f 1e fb          	endbr32 
c01000d3:	55                   	push   %ebp
c01000d4:	89 e5                	mov    %esp,%ebp
c01000d6:	53                   	push   %ebx
c01000d7:	83 ec 14             	sub    $0x14,%esp
    grade_backtrace2(arg0, (int)&arg0, arg1, (int)&arg1);
c01000da:	8d 4d 0c             	lea    0xc(%ebp),%ecx
c01000dd:	8b 55 0c             	mov    0xc(%ebp),%edx
c01000e0:	8d 5d 08             	lea    0x8(%ebp),%ebx
c01000e3:	8b 45 08             	mov    0x8(%ebp),%eax
c01000e6:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
c01000ea:	89 54 24 08          	mov    %edx,0x8(%esp)
c01000ee:	89 5c 24 04          	mov    %ebx,0x4(%esp)
c01000f2:	89 04 24             	mov    %eax,(%esp)
c01000f5:	e8 ac ff ff ff       	call   c01000a6 <grade_backtrace2>
}
c01000fa:	90                   	nop
c01000fb:	83 c4 14             	add    $0x14,%esp
c01000fe:	5b                   	pop    %ebx
c01000ff:	5d                   	pop    %ebp
c0100100:	c3                   	ret    

c0100101 <grade_backtrace0>:

void __attribute__((noinline))
grade_backtrace0(int arg0, int arg1, int arg2) {
c0100101:	f3 0f 1e fb          	endbr32 
c0100105:	55                   	push   %ebp
c0100106:	89 e5                	mov    %esp,%ebp
c0100108:	83 ec 18             	sub    $0x18,%esp
    grade_backtrace1(arg0, arg2);
c010010b:	8b 45 10             	mov    0x10(%ebp),%eax
c010010e:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100112:	8b 45 08             	mov    0x8(%ebp),%eax
c0100115:	89 04 24             	mov    %eax,(%esp)
c0100118:	e8 b2 ff ff ff       	call   c01000cf <grade_backtrace1>
}
c010011d:	90                   	nop
c010011e:	c9                   	leave  
c010011f:	c3                   	ret    

c0100120 <grade_backtrace>:

void
grade_backtrace(void) {
c0100120:	f3 0f 1e fb          	endbr32 
c0100124:	55                   	push   %ebp
c0100125:	89 e5                	mov    %esp,%ebp
c0100127:	83 ec 18             	sub    $0x18,%esp
    grade_backtrace0(0, (int)kern_init, 0xffff0000);
c010012a:	b8 36 00 10 c0       	mov    $0xc0100036,%eax
c010012f:	c7 44 24 08 00 00 ff 	movl   $0xffff0000,0x8(%esp)
c0100136:	ff 
c0100137:	89 44 24 04          	mov    %eax,0x4(%esp)
c010013b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c0100142:	e8 ba ff ff ff       	call   c0100101 <grade_backtrace0>
}
c0100147:	90                   	nop
c0100148:	c9                   	leave  
c0100149:	c3                   	ret    

c010014a <lab1_print_cur_status>:

static void
lab1_print_cur_status(void) {
c010014a:	f3 0f 1e fb          	endbr32 
c010014e:	55                   	push   %ebp
c010014f:	89 e5                	mov    %esp,%ebp
c0100151:	83 ec 28             	sub    $0x28,%esp
    static int round = 0;
    uint16_t reg1, reg2, reg3, reg4;
    asm volatile (
c0100154:	8c 4d f6             	mov    %cs,-0xa(%ebp)
c0100157:	8c 5d f4             	mov    %ds,-0xc(%ebp)
c010015a:	8c 45 f2             	mov    %es,-0xe(%ebp)
c010015d:	8c 55 f0             	mov    %ss,-0x10(%ebp)
            "mov %%cs, %0;"
            "mov %%ds, %1;"
            "mov %%es, %2;"
            "mov %%ss, %3;"
            : "=m"(reg1), "=m"(reg2), "=m"(reg3), "=m"(reg4));
    cprintf("%d: @ring %d\n", round, reg1 & 3);
c0100160:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0100164:	83 e0 03             	and    $0x3,%eax
c0100167:	89 c2                	mov    %eax,%edx
c0100169:	a1 00 d0 11 c0       	mov    0xc011d000,%eax
c010016e:	89 54 24 08          	mov    %edx,0x8(%esp)
c0100172:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100176:	c7 04 24 81 65 10 c0 	movl   $0xc0106581,(%esp)
c010017d:	e8 43 01 00 00       	call   c01002c5 <cprintf>
    cprintf("%d:  cs = %x\n", round, reg1);
c0100182:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0100186:	89 c2                	mov    %eax,%edx
c0100188:	a1 00 d0 11 c0       	mov    0xc011d000,%eax
c010018d:	89 54 24 08          	mov    %edx,0x8(%esp)
c0100191:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100195:	c7 04 24 8f 65 10 c0 	movl   $0xc010658f,(%esp)
c010019c:	e8 24 01 00 00       	call   c01002c5 <cprintf>
    cprintf("%d:  ds = %x\n", round, reg2);
c01001a1:	0f b7 45 f4          	movzwl -0xc(%ebp),%eax
c01001a5:	89 c2                	mov    %eax,%edx
c01001a7:	a1 00 d0 11 c0       	mov    0xc011d000,%eax
c01001ac:	89 54 24 08          	mov    %edx,0x8(%esp)
c01001b0:	89 44 24 04          	mov    %eax,0x4(%esp)
c01001b4:	c7 04 24 9d 65 10 c0 	movl   $0xc010659d,(%esp)
c01001bb:	e8 05 01 00 00       	call   c01002c5 <cprintf>
    cprintf("%d:  es = %x\n", round, reg3);
c01001c0:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c01001c4:	89 c2                	mov    %eax,%edx
c01001c6:	a1 00 d0 11 c0       	mov    0xc011d000,%eax
c01001cb:	89 54 24 08          	mov    %edx,0x8(%esp)
c01001cf:	89 44 24 04          	mov    %eax,0x4(%esp)
c01001d3:	c7 04 24 ab 65 10 c0 	movl   $0xc01065ab,(%esp)
c01001da:	e8 e6 00 00 00       	call   c01002c5 <cprintf>
    cprintf("%d:  ss = %x\n", round, reg4);
c01001df:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
c01001e3:	89 c2                	mov    %eax,%edx
c01001e5:	a1 00 d0 11 c0       	mov    0xc011d000,%eax
c01001ea:	89 54 24 08          	mov    %edx,0x8(%esp)
c01001ee:	89 44 24 04          	mov    %eax,0x4(%esp)
c01001f2:	c7 04 24 b9 65 10 c0 	movl   $0xc01065b9,(%esp)
c01001f9:	e8 c7 00 00 00       	call   c01002c5 <cprintf>
    round ++;
c01001fe:	a1 00 d0 11 c0       	mov    0xc011d000,%eax
c0100203:	40                   	inc    %eax
c0100204:	a3 00 d0 11 c0       	mov    %eax,0xc011d000
}
c0100209:	90                   	nop
c010020a:	c9                   	leave  
c010020b:	c3                   	ret    

c010020c <lab1_switch_to_user>:

static void
lab1_switch_to_user(void) {
c010020c:	f3 0f 1e fb          	endbr32 
c0100210:	55                   	push   %ebp
c0100211:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 : TODO
    asm volatile (
c0100213:	83 ec 08             	sub    $0x8,%esp
c0100216:	cd 78                	int    $0x78
c0100218:	89 ec                	mov    %ebp,%esp
	    "int %0 \n"
	    "movl %%ebp, %%esp"
	    : 
	    : "i"(T_SWITCH_TOU)
	);
}
c010021a:	90                   	nop
c010021b:	5d                   	pop    %ebp
c010021c:	c3                   	ret    

c010021d <lab1_switch_to_kernel>:

static void
lab1_switch_to_kernel(void) {
c010021d:	f3 0f 1e fb          	endbr32 
c0100221:	55                   	push   %ebp
c0100222:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 :  TODO
    asm volatile (
c0100224:	cd 79                	int    $0x79
c0100226:	89 ec                	mov    %ebp,%esp
	    "int %0 \n"
	    "movl %%ebp, %%esp \n"
	    : 
	    : "i"(T_SWITCH_TOK)
	);
}
c0100228:	90                   	nop
c0100229:	5d                   	pop    %ebp
c010022a:	c3                   	ret    

c010022b <lab1_switch_test>:

static void
lab1_switch_test(void) {
c010022b:	f3 0f 1e fb          	endbr32 
c010022f:	55                   	push   %ebp
c0100230:	89 e5                	mov    %esp,%ebp
c0100232:	83 ec 18             	sub    $0x18,%esp
    lab1_print_cur_status();
c0100235:	e8 10 ff ff ff       	call   c010014a <lab1_print_cur_status>
    cprintf("+++ switch to  user  mode +++\n");
c010023a:	c7 04 24 c8 65 10 c0 	movl   $0xc01065c8,(%esp)
c0100241:	e8 7f 00 00 00       	call   c01002c5 <cprintf>
    lab1_switch_to_user();
c0100246:	e8 c1 ff ff ff       	call   c010020c <lab1_switch_to_user>
    lab1_print_cur_status();
c010024b:	e8 fa fe ff ff       	call   c010014a <lab1_print_cur_status>
    cprintf("+++ switch to kernel mode +++\n");
c0100250:	c7 04 24 e8 65 10 c0 	movl   $0xc01065e8,(%esp)
c0100257:	e8 69 00 00 00       	call   c01002c5 <cprintf>
    lab1_switch_to_kernel();
c010025c:	e8 bc ff ff ff       	call   c010021d <lab1_switch_to_kernel>
    lab1_print_cur_status();
c0100261:	e8 e4 fe ff ff       	call   c010014a <lab1_print_cur_status>
}
c0100266:	90                   	nop
c0100267:	c9                   	leave  
c0100268:	c3                   	ret    

c0100269 <cputch>:
/* *
 * cputch - writes a single character @c to stdout, and it will
 * increace the value of counter pointed by @cnt.
 * */
static void
cputch(int c, int *cnt) {
c0100269:	f3 0f 1e fb          	endbr32 
c010026d:	55                   	push   %ebp
c010026e:	89 e5                	mov    %esp,%ebp
c0100270:	83 ec 18             	sub    $0x18,%esp
    cons_putc(c);
c0100273:	8b 45 08             	mov    0x8(%ebp),%eax
c0100276:	89 04 24             	mov    %eax,(%esp)
c0100279:	e8 69 14 00 00       	call   c01016e7 <cons_putc>
    (*cnt) ++;
c010027e:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100281:	8b 00                	mov    (%eax),%eax
c0100283:	8d 50 01             	lea    0x1(%eax),%edx
c0100286:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100289:	89 10                	mov    %edx,(%eax)
}
c010028b:	90                   	nop
c010028c:	c9                   	leave  
c010028d:	c3                   	ret    

c010028e <vcprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want cprintf() instead.
 * */
int
vcprintf(const char *fmt, va_list ap) {
c010028e:	f3 0f 1e fb          	endbr32 
c0100292:	55                   	push   %ebp
c0100293:	89 e5                	mov    %esp,%ebp
c0100295:	83 ec 28             	sub    $0x28,%esp
    int cnt = 0;
c0100298:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    vprintfmt((void*)cputch, &cnt, fmt, ap);
c010029f:	8b 45 0c             	mov    0xc(%ebp),%eax
c01002a2:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01002a6:	8b 45 08             	mov    0x8(%ebp),%eax
c01002a9:	89 44 24 08          	mov    %eax,0x8(%esp)
c01002ad:	8d 45 f4             	lea    -0xc(%ebp),%eax
c01002b0:	89 44 24 04          	mov    %eax,0x4(%esp)
c01002b4:	c7 04 24 69 02 10 c0 	movl   $0xc0100269,(%esp)
c01002bb:	e8 ca 5d 00 00       	call   c010608a <vprintfmt>
    return cnt;
c01002c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c01002c3:	c9                   	leave  
c01002c4:	c3                   	ret    

c01002c5 <cprintf>:
 *
 * The return value is the number of characters which would be
 * written to stdout.
 * */
int
cprintf(const char *fmt, ...) {
c01002c5:	f3 0f 1e fb          	endbr32 
c01002c9:	55                   	push   %ebp
c01002ca:	89 e5                	mov    %esp,%ebp
c01002cc:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
c01002cf:	8d 45 0c             	lea    0xc(%ebp),%eax
c01002d2:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vcprintf(fmt, ap);
c01002d5:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01002d8:	89 44 24 04          	mov    %eax,0x4(%esp)
c01002dc:	8b 45 08             	mov    0x8(%ebp),%eax
c01002df:	89 04 24             	mov    %eax,(%esp)
c01002e2:	e8 a7 ff ff ff       	call   c010028e <vcprintf>
c01002e7:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
c01002ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c01002ed:	c9                   	leave  
c01002ee:	c3                   	ret    

c01002ef <cputchar>:

/* cputchar - writes a single character to stdout */
void
cputchar(int c) {
c01002ef:	f3 0f 1e fb          	endbr32 
c01002f3:	55                   	push   %ebp
c01002f4:	89 e5                	mov    %esp,%ebp
c01002f6:	83 ec 18             	sub    $0x18,%esp
    cons_putc(c);
c01002f9:	8b 45 08             	mov    0x8(%ebp),%eax
c01002fc:	89 04 24             	mov    %eax,(%esp)
c01002ff:	e8 e3 13 00 00       	call   c01016e7 <cons_putc>
}
c0100304:	90                   	nop
c0100305:	c9                   	leave  
c0100306:	c3                   	ret    

c0100307 <cputs>:
/* *
 * cputs- writes the string pointed by @str to stdout and
 * appends a newline character.
 * */
int
cputs(const char *str) {
c0100307:	f3 0f 1e fb          	endbr32 
c010030b:	55                   	push   %ebp
c010030c:	89 e5                	mov    %esp,%ebp
c010030e:	83 ec 28             	sub    $0x28,%esp
    int cnt = 0;
c0100311:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    char c;
    while ((c = *str ++) != '\0') {
c0100318:	eb 13                	jmp    c010032d <cputs+0x26>
        cputch(c, &cnt);
c010031a:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
c010031e:	8d 55 f0             	lea    -0x10(%ebp),%edx
c0100321:	89 54 24 04          	mov    %edx,0x4(%esp)
c0100325:	89 04 24             	mov    %eax,(%esp)
c0100328:	e8 3c ff ff ff       	call   c0100269 <cputch>
    while ((c = *str ++) != '\0') {
c010032d:	8b 45 08             	mov    0x8(%ebp),%eax
c0100330:	8d 50 01             	lea    0x1(%eax),%edx
c0100333:	89 55 08             	mov    %edx,0x8(%ebp)
c0100336:	0f b6 00             	movzbl (%eax),%eax
c0100339:	88 45 f7             	mov    %al,-0x9(%ebp)
c010033c:	80 7d f7 00          	cmpb   $0x0,-0x9(%ebp)
c0100340:	75 d8                	jne    c010031a <cputs+0x13>
    }
    cputch('\n', &cnt);
c0100342:	8d 45 f0             	lea    -0x10(%ebp),%eax
c0100345:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100349:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
c0100350:	e8 14 ff ff ff       	call   c0100269 <cputch>
    return cnt;
c0100355:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
c0100358:	c9                   	leave  
c0100359:	c3                   	ret    

c010035a <getchar>:

/* getchar - reads a single non-zero character from stdin */
int
getchar(void) {
c010035a:	f3 0f 1e fb          	endbr32 
c010035e:	55                   	push   %ebp
c010035f:	89 e5                	mov    %esp,%ebp
c0100361:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = cons_getc()) == 0)
c0100364:	90                   	nop
c0100365:	e8 be 13 00 00       	call   c0101728 <cons_getc>
c010036a:	89 45 f4             	mov    %eax,-0xc(%ebp)
c010036d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0100371:	74 f2                	je     c0100365 <getchar+0xb>
        /* do nothing */;
    return c;
c0100373:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0100376:	c9                   	leave  
c0100377:	c3                   	ret    

c0100378 <readline>:
 * The readline() function returns the text of the line read. If some errors
 * are happened, NULL is returned. The return value is a global variable,
 * thus it should be copied before it is used.
 * */
char *
readline(const char *prompt) {
c0100378:	f3 0f 1e fb          	endbr32 
c010037c:	55                   	push   %ebp
c010037d:	89 e5                	mov    %esp,%ebp
c010037f:	83 ec 28             	sub    $0x28,%esp
    if (prompt != NULL) {
c0100382:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0100386:	74 13                	je     c010039b <readline+0x23>
        cprintf("%s", prompt);
c0100388:	8b 45 08             	mov    0x8(%ebp),%eax
c010038b:	89 44 24 04          	mov    %eax,0x4(%esp)
c010038f:	c7 04 24 07 66 10 c0 	movl   $0xc0106607,(%esp)
c0100396:	e8 2a ff ff ff       	call   c01002c5 <cprintf>
    }
    int i = 0, c;
c010039b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        c = getchar();
c01003a2:	e8 b3 ff ff ff       	call   c010035a <getchar>
c01003a7:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (c < 0) {
c01003aa:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c01003ae:	79 07                	jns    c01003b7 <readline+0x3f>
            return NULL;
c01003b0:	b8 00 00 00 00       	mov    $0x0,%eax
c01003b5:	eb 78                	jmp    c010042f <readline+0xb7>
        }
        else if (c >= ' ' && i < BUFSIZE - 1) {
c01003b7:	83 7d f0 1f          	cmpl   $0x1f,-0x10(%ebp)
c01003bb:	7e 28                	jle    c01003e5 <readline+0x6d>
c01003bd:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
c01003c4:	7f 1f                	jg     c01003e5 <readline+0x6d>
            cputchar(c);
c01003c6:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01003c9:	89 04 24             	mov    %eax,(%esp)
c01003cc:	e8 1e ff ff ff       	call   c01002ef <cputchar>
            buf[i ++] = c;
c01003d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01003d4:	8d 50 01             	lea    0x1(%eax),%edx
c01003d7:	89 55 f4             	mov    %edx,-0xc(%ebp)
c01003da:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01003dd:	88 90 20 d0 11 c0    	mov    %dl,-0x3fee2fe0(%eax)
c01003e3:	eb 45                	jmp    c010042a <readline+0xb2>
        }
        else if (c == '\b' && i > 0) {
c01003e5:	83 7d f0 08          	cmpl   $0x8,-0x10(%ebp)
c01003e9:	75 16                	jne    c0100401 <readline+0x89>
c01003eb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01003ef:	7e 10                	jle    c0100401 <readline+0x89>
            cputchar(c);
c01003f1:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01003f4:	89 04 24             	mov    %eax,(%esp)
c01003f7:	e8 f3 fe ff ff       	call   c01002ef <cputchar>
            i --;
c01003fc:	ff 4d f4             	decl   -0xc(%ebp)
c01003ff:	eb 29                	jmp    c010042a <readline+0xb2>
        }
        else if (c == '\n' || c == '\r') {
c0100401:	83 7d f0 0a          	cmpl   $0xa,-0x10(%ebp)
c0100405:	74 06                	je     c010040d <readline+0x95>
c0100407:	83 7d f0 0d          	cmpl   $0xd,-0x10(%ebp)
c010040b:	75 95                	jne    c01003a2 <readline+0x2a>
            cputchar(c);
c010040d:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100410:	89 04 24             	mov    %eax,(%esp)
c0100413:	e8 d7 fe ff ff       	call   c01002ef <cputchar>
            buf[i] = '\0';
c0100418:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010041b:	05 20 d0 11 c0       	add    $0xc011d020,%eax
c0100420:	c6 00 00             	movb   $0x0,(%eax)
            return buf;
c0100423:	b8 20 d0 11 c0       	mov    $0xc011d020,%eax
c0100428:	eb 05                	jmp    c010042f <readline+0xb7>
        c = getchar();
c010042a:	e9 73 ff ff ff       	jmp    c01003a2 <readline+0x2a>
        }
    }
}
c010042f:	c9                   	leave  
c0100430:	c3                   	ret    

c0100431 <__panic>:
/* *
 * __panic - __panic is called on unresolvable fatal errors. it prints
 * "panic: 'message'", and then enters the kernel monitor.
 * */
void
__panic(const char *file, int line, const char *fmt, ...) {
c0100431:	f3 0f 1e fb          	endbr32 
c0100435:	55                   	push   %ebp
c0100436:	89 e5                	mov    %esp,%ebp
c0100438:	83 ec 28             	sub    $0x28,%esp
    if (is_panic) {
c010043b:	a1 20 d4 11 c0       	mov    0xc011d420,%eax
c0100440:	85 c0                	test   %eax,%eax
c0100442:	75 5b                	jne    c010049f <__panic+0x6e>
        goto panic_dead;
    }
    is_panic = 1;
c0100444:	c7 05 20 d4 11 c0 01 	movl   $0x1,0xc011d420
c010044b:	00 00 00 

    // print the 'message'
    va_list ap;
    va_start(ap, fmt);
c010044e:	8d 45 14             	lea    0x14(%ebp),%eax
c0100451:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel panic at %s:%d:\n    ", file, line);
c0100454:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100457:	89 44 24 08          	mov    %eax,0x8(%esp)
c010045b:	8b 45 08             	mov    0x8(%ebp),%eax
c010045e:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100462:	c7 04 24 0a 66 10 c0 	movl   $0xc010660a,(%esp)
c0100469:	e8 57 fe ff ff       	call   c01002c5 <cprintf>
    vcprintf(fmt, ap);
c010046e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100471:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100475:	8b 45 10             	mov    0x10(%ebp),%eax
c0100478:	89 04 24             	mov    %eax,(%esp)
c010047b:	e8 0e fe ff ff       	call   c010028e <vcprintf>
    cprintf("\n");
c0100480:	c7 04 24 26 66 10 c0 	movl   $0xc0106626,(%esp)
c0100487:	e8 39 fe ff ff       	call   c01002c5 <cprintf>
    
    cprintf("stack trackback:\n");
c010048c:	c7 04 24 28 66 10 c0 	movl   $0xc0106628,(%esp)
c0100493:	e8 2d fe ff ff       	call   c01002c5 <cprintf>
    print_stackframe();
c0100498:	e8 3d 06 00 00       	call   c0100ada <print_stackframe>
c010049d:	eb 01                	jmp    c01004a0 <__panic+0x6f>
        goto panic_dead;
c010049f:	90                   	nop
    
    va_end(ap);

panic_dead:
    intr_disable();
c01004a0:	e8 e4 14 00 00       	call   c0101989 <intr_disable>
    while (1) {
        kmonitor(NULL);
c01004a5:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c01004ac:	e8 5d 08 00 00       	call   c0100d0e <kmonitor>
c01004b1:	eb f2                	jmp    c01004a5 <__panic+0x74>

c01004b3 <__warn>:
    }
}

/* __warn - like panic, but don't */
void
__warn(const char *file, int line, const char *fmt, ...) {
c01004b3:	f3 0f 1e fb          	endbr32 
c01004b7:	55                   	push   %ebp
c01004b8:	89 e5                	mov    %esp,%ebp
c01004ba:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    va_start(ap, fmt);
c01004bd:	8d 45 14             	lea    0x14(%ebp),%eax
c01004c0:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel warning at %s:%d:\n    ", file, line);
c01004c3:	8b 45 0c             	mov    0xc(%ebp),%eax
c01004c6:	89 44 24 08          	mov    %eax,0x8(%esp)
c01004ca:	8b 45 08             	mov    0x8(%ebp),%eax
c01004cd:	89 44 24 04          	mov    %eax,0x4(%esp)
c01004d1:	c7 04 24 3a 66 10 c0 	movl   $0xc010663a,(%esp)
c01004d8:	e8 e8 fd ff ff       	call   c01002c5 <cprintf>
    vcprintf(fmt, ap);
c01004dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01004e0:	89 44 24 04          	mov    %eax,0x4(%esp)
c01004e4:	8b 45 10             	mov    0x10(%ebp),%eax
c01004e7:	89 04 24             	mov    %eax,(%esp)
c01004ea:	e8 9f fd ff ff       	call   c010028e <vcprintf>
    cprintf("\n");
c01004ef:	c7 04 24 26 66 10 c0 	movl   $0xc0106626,(%esp)
c01004f6:	e8 ca fd ff ff       	call   c01002c5 <cprintf>
    va_end(ap);
}
c01004fb:	90                   	nop
c01004fc:	c9                   	leave  
c01004fd:	c3                   	ret    

c01004fe <is_kernel_panic>:

bool
is_kernel_panic(void) {
c01004fe:	f3 0f 1e fb          	endbr32 
c0100502:	55                   	push   %ebp
c0100503:	89 e5                	mov    %esp,%ebp
    return is_panic;
c0100505:	a1 20 d4 11 c0       	mov    0xc011d420,%eax
}
c010050a:	5d                   	pop    %ebp
c010050b:	c3                   	ret    

c010050c <stab_binsearch>:
 *      stab_binsearch(stabs, &left, &right, N_SO, 0xf0100184);
 * will exit setting left = 118, right = 554.
 * */
static void
stab_binsearch(const struct stab *stabs, int *region_left, int *region_right,
           int type, uintptr_t addr) {
c010050c:	f3 0f 1e fb          	endbr32 
c0100510:	55                   	push   %ebp
c0100511:	89 e5                	mov    %esp,%ebp
c0100513:	83 ec 20             	sub    $0x20,%esp
    int l = *region_left, r = *region_right, any_matches = 0;
c0100516:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100519:	8b 00                	mov    (%eax),%eax
c010051b:	89 45 fc             	mov    %eax,-0x4(%ebp)
c010051e:	8b 45 10             	mov    0x10(%ebp),%eax
c0100521:	8b 00                	mov    (%eax),%eax
c0100523:	89 45 f8             	mov    %eax,-0x8(%ebp)
c0100526:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

    while (l <= r) {
c010052d:	e9 ca 00 00 00       	jmp    c01005fc <stab_binsearch+0xf0>
        int true_m = (l + r) / 2, m = true_m;
c0100532:	8b 55 fc             	mov    -0x4(%ebp),%edx
c0100535:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0100538:	01 d0                	add    %edx,%eax
c010053a:	89 c2                	mov    %eax,%edx
c010053c:	c1 ea 1f             	shr    $0x1f,%edx
c010053f:	01 d0                	add    %edx,%eax
c0100541:	d1 f8                	sar    %eax
c0100543:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0100546:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0100549:	89 45 f0             	mov    %eax,-0x10(%ebp)

        // search for earliest stab with right type
        while (m >= l && stabs[m].n_type != type) {
c010054c:	eb 03                	jmp    c0100551 <stab_binsearch+0x45>
            m --;
c010054e:	ff 4d f0             	decl   -0x10(%ebp)
        while (m >= l && stabs[m].n_type != type) {
c0100551:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100554:	3b 45 fc             	cmp    -0x4(%ebp),%eax
c0100557:	7c 1f                	jl     c0100578 <stab_binsearch+0x6c>
c0100559:	8b 55 f0             	mov    -0x10(%ebp),%edx
c010055c:	89 d0                	mov    %edx,%eax
c010055e:	01 c0                	add    %eax,%eax
c0100560:	01 d0                	add    %edx,%eax
c0100562:	c1 e0 02             	shl    $0x2,%eax
c0100565:	89 c2                	mov    %eax,%edx
c0100567:	8b 45 08             	mov    0x8(%ebp),%eax
c010056a:	01 d0                	add    %edx,%eax
c010056c:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c0100570:	0f b6 c0             	movzbl %al,%eax
c0100573:	39 45 14             	cmp    %eax,0x14(%ebp)
c0100576:	75 d6                	jne    c010054e <stab_binsearch+0x42>
        }
        if (m < l) {    // no match in [l, m]
c0100578:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010057b:	3b 45 fc             	cmp    -0x4(%ebp),%eax
c010057e:	7d 09                	jge    c0100589 <stab_binsearch+0x7d>
            l = true_m + 1;
c0100580:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0100583:	40                   	inc    %eax
c0100584:	89 45 fc             	mov    %eax,-0x4(%ebp)
            continue;
c0100587:	eb 73                	jmp    c01005fc <stab_binsearch+0xf0>
        }

        // actual binary search
        any_matches = 1;
c0100589:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
        if (stabs[m].n_value < addr) {
c0100590:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0100593:	89 d0                	mov    %edx,%eax
c0100595:	01 c0                	add    %eax,%eax
c0100597:	01 d0                	add    %edx,%eax
c0100599:	c1 e0 02             	shl    $0x2,%eax
c010059c:	89 c2                	mov    %eax,%edx
c010059e:	8b 45 08             	mov    0x8(%ebp),%eax
c01005a1:	01 d0                	add    %edx,%eax
c01005a3:	8b 40 08             	mov    0x8(%eax),%eax
c01005a6:	39 45 18             	cmp    %eax,0x18(%ebp)
c01005a9:	76 11                	jbe    c01005bc <stab_binsearch+0xb0>
            *region_left = m;
c01005ab:	8b 45 0c             	mov    0xc(%ebp),%eax
c01005ae:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01005b1:	89 10                	mov    %edx,(%eax)
            l = true_m + 1;
c01005b3:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01005b6:	40                   	inc    %eax
c01005b7:	89 45 fc             	mov    %eax,-0x4(%ebp)
c01005ba:	eb 40                	jmp    c01005fc <stab_binsearch+0xf0>
        } else if (stabs[m].n_value > addr) {
c01005bc:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01005bf:	89 d0                	mov    %edx,%eax
c01005c1:	01 c0                	add    %eax,%eax
c01005c3:	01 d0                	add    %edx,%eax
c01005c5:	c1 e0 02             	shl    $0x2,%eax
c01005c8:	89 c2                	mov    %eax,%edx
c01005ca:	8b 45 08             	mov    0x8(%ebp),%eax
c01005cd:	01 d0                	add    %edx,%eax
c01005cf:	8b 40 08             	mov    0x8(%eax),%eax
c01005d2:	39 45 18             	cmp    %eax,0x18(%ebp)
c01005d5:	73 14                	jae    c01005eb <stab_binsearch+0xdf>
            *region_right = m - 1;
c01005d7:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01005da:	8d 50 ff             	lea    -0x1(%eax),%edx
c01005dd:	8b 45 10             	mov    0x10(%ebp),%eax
c01005e0:	89 10                	mov    %edx,(%eax)
            r = m - 1;
c01005e2:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01005e5:	48                   	dec    %eax
c01005e6:	89 45 f8             	mov    %eax,-0x8(%ebp)
c01005e9:	eb 11                	jmp    c01005fc <stab_binsearch+0xf0>
        } else {
            // exact match for 'addr', but continue loop to find
            // *region_right
            *region_left = m;
c01005eb:	8b 45 0c             	mov    0xc(%ebp),%eax
c01005ee:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01005f1:	89 10                	mov    %edx,(%eax)
            l = m;
c01005f3:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01005f6:	89 45 fc             	mov    %eax,-0x4(%ebp)
            addr ++;
c01005f9:	ff 45 18             	incl   0x18(%ebp)
    while (l <= r) {
c01005fc:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01005ff:	3b 45 f8             	cmp    -0x8(%ebp),%eax
c0100602:	0f 8e 2a ff ff ff    	jle    c0100532 <stab_binsearch+0x26>
        }
    }

    if (!any_matches) {
c0100608:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c010060c:	75 0f                	jne    c010061d <stab_binsearch+0x111>
        *region_right = *region_left - 1;
c010060e:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100611:	8b 00                	mov    (%eax),%eax
c0100613:	8d 50 ff             	lea    -0x1(%eax),%edx
c0100616:	8b 45 10             	mov    0x10(%ebp),%eax
c0100619:	89 10                	mov    %edx,(%eax)
        l = *region_right;
        for (; l > *region_left && stabs[l].n_type != type; l --)
            /* do nothing */;
        *region_left = l;
    }
}
c010061b:	eb 3e                	jmp    c010065b <stab_binsearch+0x14f>
        l = *region_right;
c010061d:	8b 45 10             	mov    0x10(%ebp),%eax
c0100620:	8b 00                	mov    (%eax),%eax
c0100622:	89 45 fc             	mov    %eax,-0x4(%ebp)
        for (; l > *region_left && stabs[l].n_type != type; l --)
c0100625:	eb 03                	jmp    c010062a <stab_binsearch+0x11e>
c0100627:	ff 4d fc             	decl   -0x4(%ebp)
c010062a:	8b 45 0c             	mov    0xc(%ebp),%eax
c010062d:	8b 00                	mov    (%eax),%eax
c010062f:	39 45 fc             	cmp    %eax,-0x4(%ebp)
c0100632:	7e 1f                	jle    c0100653 <stab_binsearch+0x147>
c0100634:	8b 55 fc             	mov    -0x4(%ebp),%edx
c0100637:	89 d0                	mov    %edx,%eax
c0100639:	01 c0                	add    %eax,%eax
c010063b:	01 d0                	add    %edx,%eax
c010063d:	c1 e0 02             	shl    $0x2,%eax
c0100640:	89 c2                	mov    %eax,%edx
c0100642:	8b 45 08             	mov    0x8(%ebp),%eax
c0100645:	01 d0                	add    %edx,%eax
c0100647:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c010064b:	0f b6 c0             	movzbl %al,%eax
c010064e:	39 45 14             	cmp    %eax,0x14(%ebp)
c0100651:	75 d4                	jne    c0100627 <stab_binsearch+0x11b>
        *region_left = l;
c0100653:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100656:	8b 55 fc             	mov    -0x4(%ebp),%edx
c0100659:	89 10                	mov    %edx,(%eax)
}
c010065b:	90                   	nop
c010065c:	c9                   	leave  
c010065d:	c3                   	ret    

c010065e <debuginfo_eip>:
 * the specified instruction address, @addr.  Returns 0 if information
 * was found, and negative if not.  But even if it returns negative it
 * has stored some information into '*info'.
 * */
int
debuginfo_eip(uintptr_t addr, struct eipdebuginfo *info) {
c010065e:	f3 0f 1e fb          	endbr32 
c0100662:	55                   	push   %ebp
c0100663:	89 e5                	mov    %esp,%ebp
c0100665:	83 ec 58             	sub    $0x58,%esp
    const struct stab *stabs, *stab_end;
    const char *stabstr, *stabstr_end;

    info->eip_file = "<unknown>";
c0100668:	8b 45 0c             	mov    0xc(%ebp),%eax
c010066b:	c7 00 58 66 10 c0    	movl   $0xc0106658,(%eax)
    info->eip_line = 0;
c0100671:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100674:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    info->eip_fn_name = "<unknown>";
c010067b:	8b 45 0c             	mov    0xc(%ebp),%eax
c010067e:	c7 40 08 58 66 10 c0 	movl   $0xc0106658,0x8(%eax)
    info->eip_fn_namelen = 9;
c0100685:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100688:	c7 40 0c 09 00 00 00 	movl   $0x9,0xc(%eax)
    info->eip_fn_addr = addr;
c010068f:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100692:	8b 55 08             	mov    0x8(%ebp),%edx
c0100695:	89 50 10             	mov    %edx,0x10(%eax)
    info->eip_fn_narg = 0;
c0100698:	8b 45 0c             	mov    0xc(%ebp),%eax
c010069b:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)

    stabs = __STAB_BEGIN__;
c01006a2:	c7 45 f4 10 79 10 c0 	movl   $0xc0107910,-0xc(%ebp)
    stab_end = __STAB_END__;
c01006a9:	c7 45 f0 18 46 11 c0 	movl   $0xc0114618,-0x10(%ebp)
    stabstr = __STABSTR_BEGIN__;
c01006b0:	c7 45 ec 19 46 11 c0 	movl   $0xc0114619,-0x14(%ebp)
    stabstr_end = __STABSTR_END__;
c01006b7:	c7 45 e8 61 71 11 c0 	movl   $0xc0117161,-0x18(%ebp)

    // String table validity checks
    if (stabstr_end <= stabstr || stabstr_end[-1] != 0) {
c01006be:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01006c1:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c01006c4:	76 0b                	jbe    c01006d1 <debuginfo_eip+0x73>
c01006c6:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01006c9:	48                   	dec    %eax
c01006ca:	0f b6 00             	movzbl (%eax),%eax
c01006cd:	84 c0                	test   %al,%al
c01006cf:	74 0a                	je     c01006db <debuginfo_eip+0x7d>
        return -1;
c01006d1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c01006d6:	e9 ab 02 00 00       	jmp    c0100986 <debuginfo_eip+0x328>
    // 'eip'.  First, we find the basic source file containing 'eip'.
    // Then, we look in that source file for the function.  Then we look
    // for the line number.

    // Search the entire set of stabs for the source file (type N_SO).
    int lfile = 0, rfile = (stab_end - stabs) - 1;
c01006db:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
c01006e2:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01006e5:	2b 45 f4             	sub    -0xc(%ebp),%eax
c01006e8:	c1 f8 02             	sar    $0x2,%eax
c01006eb:	69 c0 ab aa aa aa    	imul   $0xaaaaaaab,%eax,%eax
c01006f1:	48                   	dec    %eax
c01006f2:	89 45 e0             	mov    %eax,-0x20(%ebp)
    stab_binsearch(stabs, &lfile, &rfile, N_SO, addr);
c01006f5:	8b 45 08             	mov    0x8(%ebp),%eax
c01006f8:	89 44 24 10          	mov    %eax,0x10(%esp)
c01006fc:	c7 44 24 0c 64 00 00 	movl   $0x64,0xc(%esp)
c0100703:	00 
c0100704:	8d 45 e0             	lea    -0x20(%ebp),%eax
c0100707:	89 44 24 08          	mov    %eax,0x8(%esp)
c010070b:	8d 45 e4             	lea    -0x1c(%ebp),%eax
c010070e:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100712:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100715:	89 04 24             	mov    %eax,(%esp)
c0100718:	e8 ef fd ff ff       	call   c010050c <stab_binsearch>
    if (lfile == 0)
c010071d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0100720:	85 c0                	test   %eax,%eax
c0100722:	75 0a                	jne    c010072e <debuginfo_eip+0xd0>
        return -1;
c0100724:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c0100729:	e9 58 02 00 00       	jmp    c0100986 <debuginfo_eip+0x328>

    // Search within that file's stabs for the function definition
    // (N_FUN).
    int lfun = lfile, rfun = rfile;
c010072e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0100731:	89 45 dc             	mov    %eax,-0x24(%ebp)
c0100734:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0100737:	89 45 d8             	mov    %eax,-0x28(%ebp)
    int lline, rline;
    stab_binsearch(stabs, &lfun, &rfun, N_FUN, addr);
c010073a:	8b 45 08             	mov    0x8(%ebp),%eax
c010073d:	89 44 24 10          	mov    %eax,0x10(%esp)
c0100741:	c7 44 24 0c 24 00 00 	movl   $0x24,0xc(%esp)
c0100748:	00 
c0100749:	8d 45 d8             	lea    -0x28(%ebp),%eax
c010074c:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100750:	8d 45 dc             	lea    -0x24(%ebp),%eax
c0100753:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100757:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010075a:	89 04 24             	mov    %eax,(%esp)
c010075d:	e8 aa fd ff ff       	call   c010050c <stab_binsearch>

    if (lfun <= rfun) {
c0100762:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0100765:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0100768:	39 c2                	cmp    %eax,%edx
c010076a:	7f 78                	jg     c01007e4 <debuginfo_eip+0x186>
        // stabs[lfun] points to the function name
        // in the string table, but check bounds just in case.
        if (stabs[lfun].n_strx < stabstr_end - stabstr) {
c010076c:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010076f:	89 c2                	mov    %eax,%edx
c0100771:	89 d0                	mov    %edx,%eax
c0100773:	01 c0                	add    %eax,%eax
c0100775:	01 d0                	add    %edx,%eax
c0100777:	c1 e0 02             	shl    $0x2,%eax
c010077a:	89 c2                	mov    %eax,%edx
c010077c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010077f:	01 d0                	add    %edx,%eax
c0100781:	8b 10                	mov    (%eax),%edx
c0100783:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0100786:	2b 45 ec             	sub    -0x14(%ebp),%eax
c0100789:	39 c2                	cmp    %eax,%edx
c010078b:	73 22                	jae    c01007af <debuginfo_eip+0x151>
            info->eip_fn_name = stabstr + stabs[lfun].n_strx;
c010078d:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0100790:	89 c2                	mov    %eax,%edx
c0100792:	89 d0                	mov    %edx,%eax
c0100794:	01 c0                	add    %eax,%eax
c0100796:	01 d0                	add    %edx,%eax
c0100798:	c1 e0 02             	shl    $0x2,%eax
c010079b:	89 c2                	mov    %eax,%edx
c010079d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01007a0:	01 d0                	add    %edx,%eax
c01007a2:	8b 10                	mov    (%eax),%edx
c01007a4:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01007a7:	01 c2                	add    %eax,%edx
c01007a9:	8b 45 0c             	mov    0xc(%ebp),%eax
c01007ac:	89 50 08             	mov    %edx,0x8(%eax)
        }
        info->eip_fn_addr = stabs[lfun].n_value;
c01007af:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01007b2:	89 c2                	mov    %eax,%edx
c01007b4:	89 d0                	mov    %edx,%eax
c01007b6:	01 c0                	add    %eax,%eax
c01007b8:	01 d0                	add    %edx,%eax
c01007ba:	c1 e0 02             	shl    $0x2,%eax
c01007bd:	89 c2                	mov    %eax,%edx
c01007bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01007c2:	01 d0                	add    %edx,%eax
c01007c4:	8b 50 08             	mov    0x8(%eax),%edx
c01007c7:	8b 45 0c             	mov    0xc(%ebp),%eax
c01007ca:	89 50 10             	mov    %edx,0x10(%eax)
        addr -= info->eip_fn_addr;
c01007cd:	8b 45 0c             	mov    0xc(%ebp),%eax
c01007d0:	8b 40 10             	mov    0x10(%eax),%eax
c01007d3:	29 45 08             	sub    %eax,0x8(%ebp)
        // Search within the function definition for the line number.
        lline = lfun;
c01007d6:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01007d9:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfun;
c01007dc:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01007df:	89 45 d0             	mov    %eax,-0x30(%ebp)
c01007e2:	eb 15                	jmp    c01007f9 <debuginfo_eip+0x19b>
    } else {
        // Couldn't find function stab!  Maybe we're in an assembly
        // file.  Search the whole file for the line number.
        info->eip_fn_addr = addr;
c01007e4:	8b 45 0c             	mov    0xc(%ebp),%eax
c01007e7:	8b 55 08             	mov    0x8(%ebp),%edx
c01007ea:	89 50 10             	mov    %edx,0x10(%eax)
        lline = lfile;
c01007ed:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01007f0:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfile;
c01007f3:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01007f6:	89 45 d0             	mov    %eax,-0x30(%ebp)
    }
    info->eip_fn_namelen = strfind(info->eip_fn_name, ':') - info->eip_fn_name;
c01007f9:	8b 45 0c             	mov    0xc(%ebp),%eax
c01007fc:	8b 40 08             	mov    0x8(%eax),%eax
c01007ff:	c7 44 24 04 3a 00 00 	movl   $0x3a,0x4(%esp)
c0100806:	00 
c0100807:	89 04 24             	mov    %eax,(%esp)
c010080a:	e8 83 53 00 00       	call   c0105b92 <strfind>
c010080f:	8b 55 0c             	mov    0xc(%ebp),%edx
c0100812:	8b 52 08             	mov    0x8(%edx),%edx
c0100815:	29 d0                	sub    %edx,%eax
c0100817:	89 c2                	mov    %eax,%edx
c0100819:	8b 45 0c             	mov    0xc(%ebp),%eax
c010081c:	89 50 0c             	mov    %edx,0xc(%eax)

    // Search within [lline, rline] for the line number stab.
    // If found, set info->eip_line to the right line number.
    // If not found, return -1.
    stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
c010081f:	8b 45 08             	mov    0x8(%ebp),%eax
c0100822:	89 44 24 10          	mov    %eax,0x10(%esp)
c0100826:	c7 44 24 0c 44 00 00 	movl   $0x44,0xc(%esp)
c010082d:	00 
c010082e:	8d 45 d0             	lea    -0x30(%ebp),%eax
c0100831:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100835:	8d 45 d4             	lea    -0x2c(%ebp),%eax
c0100838:	89 44 24 04          	mov    %eax,0x4(%esp)
c010083c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010083f:	89 04 24             	mov    %eax,(%esp)
c0100842:	e8 c5 fc ff ff       	call   c010050c <stab_binsearch>
    if (lline <= rline) {
c0100847:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c010084a:	8b 45 d0             	mov    -0x30(%ebp),%eax
c010084d:	39 c2                	cmp    %eax,%edx
c010084f:	7f 23                	jg     c0100874 <debuginfo_eip+0x216>
        info->eip_line = stabs[rline].n_desc;
c0100851:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0100854:	89 c2                	mov    %eax,%edx
c0100856:	89 d0                	mov    %edx,%eax
c0100858:	01 c0                	add    %eax,%eax
c010085a:	01 d0                	add    %edx,%eax
c010085c:	c1 e0 02             	shl    $0x2,%eax
c010085f:	89 c2                	mov    %eax,%edx
c0100861:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100864:	01 d0                	add    %edx,%eax
c0100866:	0f b7 40 06          	movzwl 0x6(%eax),%eax
c010086a:	89 c2                	mov    %eax,%edx
c010086c:	8b 45 0c             	mov    0xc(%ebp),%eax
c010086f:	89 50 04             	mov    %edx,0x4(%eax)

    // Search backwards from the line number for the relevant filename stab.
    // We can't just use the "lfile" stab because inlined functions
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
c0100872:	eb 11                	jmp    c0100885 <debuginfo_eip+0x227>
        return -1;
c0100874:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c0100879:	e9 08 01 00 00       	jmp    c0100986 <debuginfo_eip+0x328>
           && stabs[lline].n_type != N_SOL
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
        lline --;
c010087e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0100881:	48                   	dec    %eax
c0100882:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    while (lline >= lfile
c0100885:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0100888:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010088b:	39 c2                	cmp    %eax,%edx
c010088d:	7c 56                	jl     c01008e5 <debuginfo_eip+0x287>
           && stabs[lline].n_type != N_SOL
c010088f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0100892:	89 c2                	mov    %eax,%edx
c0100894:	89 d0                	mov    %edx,%eax
c0100896:	01 c0                	add    %eax,%eax
c0100898:	01 d0                	add    %edx,%eax
c010089a:	c1 e0 02             	shl    $0x2,%eax
c010089d:	89 c2                	mov    %eax,%edx
c010089f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01008a2:	01 d0                	add    %edx,%eax
c01008a4:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c01008a8:	3c 84                	cmp    $0x84,%al
c01008aa:	74 39                	je     c01008e5 <debuginfo_eip+0x287>
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
c01008ac:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01008af:	89 c2                	mov    %eax,%edx
c01008b1:	89 d0                	mov    %edx,%eax
c01008b3:	01 c0                	add    %eax,%eax
c01008b5:	01 d0                	add    %edx,%eax
c01008b7:	c1 e0 02             	shl    $0x2,%eax
c01008ba:	89 c2                	mov    %eax,%edx
c01008bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01008bf:	01 d0                	add    %edx,%eax
c01008c1:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c01008c5:	3c 64                	cmp    $0x64,%al
c01008c7:	75 b5                	jne    c010087e <debuginfo_eip+0x220>
c01008c9:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01008cc:	89 c2                	mov    %eax,%edx
c01008ce:	89 d0                	mov    %edx,%eax
c01008d0:	01 c0                	add    %eax,%eax
c01008d2:	01 d0                	add    %edx,%eax
c01008d4:	c1 e0 02             	shl    $0x2,%eax
c01008d7:	89 c2                	mov    %eax,%edx
c01008d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01008dc:	01 d0                	add    %edx,%eax
c01008de:	8b 40 08             	mov    0x8(%eax),%eax
c01008e1:	85 c0                	test   %eax,%eax
c01008e3:	74 99                	je     c010087e <debuginfo_eip+0x220>
    }
    if (lline >= lfile && stabs[lline].n_strx < stabstr_end - stabstr) {
c01008e5:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01008e8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01008eb:	39 c2                	cmp    %eax,%edx
c01008ed:	7c 42                	jl     c0100931 <debuginfo_eip+0x2d3>
c01008ef:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01008f2:	89 c2                	mov    %eax,%edx
c01008f4:	89 d0                	mov    %edx,%eax
c01008f6:	01 c0                	add    %eax,%eax
c01008f8:	01 d0                	add    %edx,%eax
c01008fa:	c1 e0 02             	shl    $0x2,%eax
c01008fd:	89 c2                	mov    %eax,%edx
c01008ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100902:	01 d0                	add    %edx,%eax
c0100904:	8b 10                	mov    (%eax),%edx
c0100906:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0100909:	2b 45 ec             	sub    -0x14(%ebp),%eax
c010090c:	39 c2                	cmp    %eax,%edx
c010090e:	73 21                	jae    c0100931 <debuginfo_eip+0x2d3>
        info->eip_file = stabstr + stabs[lline].n_strx;
c0100910:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0100913:	89 c2                	mov    %eax,%edx
c0100915:	89 d0                	mov    %edx,%eax
c0100917:	01 c0                	add    %eax,%eax
c0100919:	01 d0                	add    %edx,%eax
c010091b:	c1 e0 02             	shl    $0x2,%eax
c010091e:	89 c2                	mov    %eax,%edx
c0100920:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100923:	01 d0                	add    %edx,%eax
c0100925:	8b 10                	mov    (%eax),%edx
c0100927:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010092a:	01 c2                	add    %eax,%edx
c010092c:	8b 45 0c             	mov    0xc(%ebp),%eax
c010092f:	89 10                	mov    %edx,(%eax)
    }

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
c0100931:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0100934:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0100937:	39 c2                	cmp    %eax,%edx
c0100939:	7d 46                	jge    c0100981 <debuginfo_eip+0x323>
        for (lline = lfun + 1;
c010093b:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010093e:	40                   	inc    %eax
c010093f:	89 45 d4             	mov    %eax,-0x2c(%ebp)
c0100942:	eb 16                	jmp    c010095a <debuginfo_eip+0x2fc>
             lline < rfun && stabs[lline].n_type == N_PSYM;
             lline ++) {
            info->eip_fn_narg ++;
c0100944:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100947:	8b 40 14             	mov    0x14(%eax),%eax
c010094a:	8d 50 01             	lea    0x1(%eax),%edx
c010094d:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100950:	89 50 14             	mov    %edx,0x14(%eax)
             lline ++) {
c0100953:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0100956:	40                   	inc    %eax
c0100957:	89 45 d4             	mov    %eax,-0x2c(%ebp)
             lline < rfun && stabs[lline].n_type == N_PSYM;
c010095a:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c010095d:	8b 45 d8             	mov    -0x28(%ebp),%eax
        for (lline = lfun + 1;
c0100960:	39 c2                	cmp    %eax,%edx
c0100962:	7d 1d                	jge    c0100981 <debuginfo_eip+0x323>
             lline < rfun && stabs[lline].n_type == N_PSYM;
c0100964:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0100967:	89 c2                	mov    %eax,%edx
c0100969:	89 d0                	mov    %edx,%eax
c010096b:	01 c0                	add    %eax,%eax
c010096d:	01 d0                	add    %edx,%eax
c010096f:	c1 e0 02             	shl    $0x2,%eax
c0100972:	89 c2                	mov    %eax,%edx
c0100974:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100977:	01 d0                	add    %edx,%eax
c0100979:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c010097d:	3c a0                	cmp    $0xa0,%al
c010097f:	74 c3                	je     c0100944 <debuginfo_eip+0x2e6>
        }
    }
    return 0;
c0100981:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100986:	c9                   	leave  
c0100987:	c3                   	ret    

c0100988 <print_kerninfo>:
 * print_kerninfo - print the information about kernel, including the location
 * of kernel entry, the start addresses of data and text segements, the start
 * address of free memory and how many memory that kernel has used.
 * */
void
print_kerninfo(void) {
c0100988:	f3 0f 1e fb          	endbr32 
c010098c:	55                   	push   %ebp
c010098d:	89 e5                	mov    %esp,%ebp
c010098f:	83 ec 18             	sub    $0x18,%esp
    extern char etext[], edata[], end[], kern_init[];
    cprintf("Special kernel symbols:\n");
c0100992:	c7 04 24 62 66 10 c0 	movl   $0xc0106662,(%esp)
c0100999:	e8 27 f9 ff ff       	call   c01002c5 <cprintf>
    cprintf("  entry  0x%08x (phys)\n", kern_init);
c010099e:	c7 44 24 04 36 00 10 	movl   $0xc0100036,0x4(%esp)
c01009a5:	c0 
c01009a6:	c7 04 24 7b 66 10 c0 	movl   $0xc010667b,(%esp)
c01009ad:	e8 13 f9 ff ff       	call   c01002c5 <cprintf>
    cprintf("  etext  0x%08x (phys)\n", etext);
c01009b2:	c7 44 24 04 42 65 10 	movl   $0xc0106542,0x4(%esp)
c01009b9:	c0 
c01009ba:	c7 04 24 93 66 10 c0 	movl   $0xc0106693,(%esp)
c01009c1:	e8 ff f8 ff ff       	call   c01002c5 <cprintf>
    cprintf("  edata  0x%08x (phys)\n", edata);
c01009c6:	c7 44 24 04 00 d0 11 	movl   $0xc011d000,0x4(%esp)
c01009cd:	c0 
c01009ce:	c7 04 24 ab 66 10 c0 	movl   $0xc01066ab,(%esp)
c01009d5:	e8 eb f8 ff ff       	call   c01002c5 <cprintf>
    cprintf("  end    0x%08x (phys)\n", end);
c01009da:	c7 44 24 04 88 df 11 	movl   $0xc011df88,0x4(%esp)
c01009e1:	c0 
c01009e2:	c7 04 24 c3 66 10 c0 	movl   $0xc01066c3,(%esp)
c01009e9:	e8 d7 f8 ff ff       	call   c01002c5 <cprintf>
    cprintf("Kernel executable memory footprint: %dKB\n", (end - kern_init + 1023)/1024);
c01009ee:	b8 88 df 11 c0       	mov    $0xc011df88,%eax
c01009f3:	2d 36 00 10 c0       	sub    $0xc0100036,%eax
c01009f8:	05 ff 03 00 00       	add    $0x3ff,%eax
c01009fd:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
c0100a03:	85 c0                	test   %eax,%eax
c0100a05:	0f 48 c2             	cmovs  %edx,%eax
c0100a08:	c1 f8 0a             	sar    $0xa,%eax
c0100a0b:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100a0f:	c7 04 24 dc 66 10 c0 	movl   $0xc01066dc,(%esp)
c0100a16:	e8 aa f8 ff ff       	call   c01002c5 <cprintf>
}
c0100a1b:	90                   	nop
c0100a1c:	c9                   	leave  
c0100a1d:	c3                   	ret    

c0100a1e <print_debuginfo>:
/* *
 * print_debuginfo - read and print the stat information for the address @eip,
 * and info.eip_fn_addr should be the first address of the related function.
 * */
void
print_debuginfo(uintptr_t eip) {
c0100a1e:	f3 0f 1e fb          	endbr32 
c0100a22:	55                   	push   %ebp
c0100a23:	89 e5                	mov    %esp,%ebp
c0100a25:	81 ec 48 01 00 00    	sub    $0x148,%esp
    struct eipdebuginfo info;
    if (debuginfo_eip(eip, &info) != 0) {
c0100a2b:	8d 45 dc             	lea    -0x24(%ebp),%eax
c0100a2e:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100a32:	8b 45 08             	mov    0x8(%ebp),%eax
c0100a35:	89 04 24             	mov    %eax,(%esp)
c0100a38:	e8 21 fc ff ff       	call   c010065e <debuginfo_eip>
c0100a3d:	85 c0                	test   %eax,%eax
c0100a3f:	74 15                	je     c0100a56 <print_debuginfo+0x38>
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
c0100a41:	8b 45 08             	mov    0x8(%ebp),%eax
c0100a44:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100a48:	c7 04 24 06 67 10 c0 	movl   $0xc0106706,(%esp)
c0100a4f:	e8 71 f8 ff ff       	call   c01002c5 <cprintf>
        }
        fnname[j] = '\0';
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
                fnname, eip - info.eip_fn_addr);
    }
}
c0100a54:	eb 6c                	jmp    c0100ac2 <print_debuginfo+0xa4>
        for (j = 0; j < info.eip_fn_namelen; j ++) {
c0100a56:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0100a5d:	eb 1b                	jmp    c0100a7a <print_debuginfo+0x5c>
            fnname[j] = info.eip_fn_name[j];
c0100a5f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0100a62:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100a65:	01 d0                	add    %edx,%eax
c0100a67:	0f b6 10             	movzbl (%eax),%edx
c0100a6a:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
c0100a70:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100a73:	01 c8                	add    %ecx,%eax
c0100a75:	88 10                	mov    %dl,(%eax)
        for (j = 0; j < info.eip_fn_namelen; j ++) {
c0100a77:	ff 45 f4             	incl   -0xc(%ebp)
c0100a7a:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0100a7d:	39 45 f4             	cmp    %eax,-0xc(%ebp)
c0100a80:	7c dd                	jl     c0100a5f <print_debuginfo+0x41>
        fnname[j] = '\0';
c0100a82:	8d 95 dc fe ff ff    	lea    -0x124(%ebp),%edx
c0100a88:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100a8b:	01 d0                	add    %edx,%eax
c0100a8d:	c6 00 00             	movb   $0x0,(%eax)
                fnname, eip - info.eip_fn_addr);
c0100a90:	8b 45 ec             	mov    -0x14(%ebp),%eax
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
c0100a93:	8b 55 08             	mov    0x8(%ebp),%edx
c0100a96:	89 d1                	mov    %edx,%ecx
c0100a98:	29 c1                	sub    %eax,%ecx
c0100a9a:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0100a9d:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0100aa0:	89 4c 24 10          	mov    %ecx,0x10(%esp)
c0100aa4:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
c0100aaa:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
c0100aae:	89 54 24 08          	mov    %edx,0x8(%esp)
c0100ab2:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100ab6:	c7 04 24 22 67 10 c0 	movl   $0xc0106722,(%esp)
c0100abd:	e8 03 f8 ff ff       	call   c01002c5 <cprintf>
}
c0100ac2:	90                   	nop
c0100ac3:	c9                   	leave  
c0100ac4:	c3                   	ret    

c0100ac5 <read_eip>:

static __noinline uint32_t
read_eip(void) {
c0100ac5:	f3 0f 1e fb          	endbr32 
c0100ac9:	55                   	push   %ebp
c0100aca:	89 e5                	mov    %esp,%ebp
c0100acc:	83 ec 10             	sub    $0x10,%esp
    uint32_t eip;
    asm volatile("movl 4(%%ebp), %0" : "=r" (eip));
c0100acf:	8b 45 04             	mov    0x4(%ebp),%eax
c0100ad2:	89 45 fc             	mov    %eax,-0x4(%ebp)
    return eip;
c0100ad5:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c0100ad8:	c9                   	leave  
c0100ad9:	c3                   	ret    

c0100ada <print_stackframe>:
 *
 * Note that, the length of ebp-chain is limited. In boot/bootasm.S, before jumping
 * to the kernel entry, the value of ebp has been set to zero, that's the boundary.
 * */
void
print_stackframe(void) {
c0100ada:	f3 0f 1e fb          	endbr32 
c0100ade:	55                   	push   %ebp
c0100adf:	89 e5                	mov    %esp,%ebp
c0100ae1:	83 ec 38             	sub    $0x38,%esp
}

static inline uint32_t
read_ebp(void) {
    uint32_t ebp;
    asm volatile ("movl %%ebp, %0" : "=r" (ebp));
c0100ae4:	89 e8                	mov    %ebp,%eax
c0100ae6:	89 45 e0             	mov    %eax,-0x20(%ebp)
    return ebp;
c0100ae9:	8b 45 e0             	mov    -0x20(%ebp),%eax
      *           NOTICE: the calling funciton's return addr eip  = ss:[ebp+4]
      *                   the calling funciton's ebp = ss:[ebp]
      */

    // 初始化当前ebp和eip
    uint32_t ebp = read_ebp();
c0100aec:	89 45 f4             	mov    %eax,-0xc(%ebp)
    uint32_t eip = read_eip();
c0100aef:	e8 d1 ff ff ff       	call   c0100ac5 <read_eip>
c0100af4:	89 45 f0             	mov    %eax,-0x10(%ebp)

    // 定义当前深度
    int depth = 0;
c0100af7:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)

    // 循环，以至打印到设定的最大堆栈深度
    // ebp == 0，代表着没有更深的函数栈帧了
    for (; ebp != 0 && depth < STACKFRAME_DEPTH; depth ++) {
c0100afe:	e9 84 00 00 00       	jmp    c0100b87 <print_stackframe+0xad>
        // 打印第一行，标识出ebp和eip的值
        cprintf("ebp:0x%08x eip:0x%08x args:", ebp, eip);
c0100b03:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100b06:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100b0a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100b0d:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100b11:	c7 04 24 34 67 10 c0 	movl   $0xc0106734,(%esp)
c0100b18:	e8 a8 f7 ff ff       	call   c01002c5 <cprintf>
        // 可能的参数存在于ebp底第二个地址
        uint32_t *args = (uint32_t *)ebp + 2;
c0100b1d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100b20:	83 c0 08             	add    $0x8,%eax
c0100b23:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        // 默认最多打印四个参数
        for (int j = 0; j < 4; j ++) {
c0100b26:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
c0100b2d:	eb 24                	jmp    c0100b53 <print_stackframe+0x79>
            cprintf("0x%08x ", args[j]);
c0100b2f:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0100b32:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0100b39:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0100b3c:	01 d0                	add    %edx,%eax
c0100b3e:	8b 00                	mov    (%eax),%eax
c0100b40:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100b44:	c7 04 24 50 67 10 c0 	movl   $0xc0106750,(%esp)
c0100b4b:	e8 75 f7 ff ff       	call   c01002c5 <cprintf>
        for (int j = 0; j < 4; j ++) {
c0100b50:	ff 45 e8             	incl   -0x18(%ebp)
c0100b53:	83 7d e8 03          	cmpl   $0x3,-0x18(%ebp)
c0100b57:	7e d6                	jle    c0100b2f <print_stackframe+0x55>
        }
        cprintf("\n");
c0100b59:	c7 04 24 58 67 10 c0 	movl   $0xc0106758,(%esp)
c0100b60:	e8 60 f7 ff ff       	call   c01002c5 <cprintf>
        // 能够查找到对应的函数相关信息，包括函数名，所在文件的行号等
        // eip - 1
        print_debuginfo(eip - 1);
c0100b65:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100b68:	48                   	dec    %eax
c0100b69:	89 04 24             	mov    %eax,(%esp)
c0100b6c:	e8 ad fe ff ff       	call   c0100a1e <print_debuginfo>
        // 将eip赋为栈底的返回地址，edp赋为其存放的地址中的值
        eip = ((uint32_t *)ebp)[1];
c0100b71:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100b74:	83 c0 04             	add    $0x4,%eax
c0100b77:	8b 00                	mov    (%eax),%eax
c0100b79:	89 45 f0             	mov    %eax,-0x10(%ebp)
        ebp = ((uint32_t *)ebp)[0];
c0100b7c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100b7f:	8b 00                	mov    (%eax),%eax
c0100b81:	89 45 f4             	mov    %eax,-0xc(%ebp)
    for (; ebp != 0 && depth < STACKFRAME_DEPTH; depth ++) {
c0100b84:	ff 45 ec             	incl   -0x14(%ebp)
c0100b87:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0100b8b:	74 0a                	je     c0100b97 <print_stackframe+0xbd>
c0100b8d:	83 7d ec 13          	cmpl   $0x13,-0x14(%ebp)
c0100b91:	0f 8e 6c ff ff ff    	jle    c0100b03 <print_stackframe+0x29>
    }
}
c0100b97:	90                   	nop
c0100b98:	c9                   	leave  
c0100b99:	c3                   	ret    

c0100b9a <parse>:
#define MAXARGS         16
#define WHITESPACE      " \t\n\r"

/* parse - parse the command buffer into whitespace-separated arguments */
static int
parse(char *buf, char **argv) {
c0100b9a:	f3 0f 1e fb          	endbr32 
c0100b9e:	55                   	push   %ebp
c0100b9f:	89 e5                	mov    %esp,%ebp
c0100ba1:	83 ec 28             	sub    $0x28,%esp
    int argc = 0;
c0100ba4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
c0100bab:	eb 0c                	jmp    c0100bb9 <parse+0x1f>
            *buf ++ = '\0';
c0100bad:	8b 45 08             	mov    0x8(%ebp),%eax
c0100bb0:	8d 50 01             	lea    0x1(%eax),%edx
c0100bb3:	89 55 08             	mov    %edx,0x8(%ebp)
c0100bb6:	c6 00 00             	movb   $0x0,(%eax)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
c0100bb9:	8b 45 08             	mov    0x8(%ebp),%eax
c0100bbc:	0f b6 00             	movzbl (%eax),%eax
c0100bbf:	84 c0                	test   %al,%al
c0100bc1:	74 1d                	je     c0100be0 <parse+0x46>
c0100bc3:	8b 45 08             	mov    0x8(%ebp),%eax
c0100bc6:	0f b6 00             	movzbl (%eax),%eax
c0100bc9:	0f be c0             	movsbl %al,%eax
c0100bcc:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100bd0:	c7 04 24 dc 67 10 c0 	movl   $0xc01067dc,(%esp)
c0100bd7:	e8 80 4f 00 00       	call   c0105b5c <strchr>
c0100bdc:	85 c0                	test   %eax,%eax
c0100bde:	75 cd                	jne    c0100bad <parse+0x13>
        }
        if (*buf == '\0') {
c0100be0:	8b 45 08             	mov    0x8(%ebp),%eax
c0100be3:	0f b6 00             	movzbl (%eax),%eax
c0100be6:	84 c0                	test   %al,%al
c0100be8:	74 65                	je     c0100c4f <parse+0xb5>
            break;
        }

        // save and scan past next arg
        if (argc == MAXARGS - 1) {
c0100bea:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
c0100bee:	75 14                	jne    c0100c04 <parse+0x6a>
            cprintf("Too many arguments (max %d).\n", MAXARGS);
c0100bf0:	c7 44 24 04 10 00 00 	movl   $0x10,0x4(%esp)
c0100bf7:	00 
c0100bf8:	c7 04 24 e1 67 10 c0 	movl   $0xc01067e1,(%esp)
c0100bff:	e8 c1 f6 ff ff       	call   c01002c5 <cprintf>
        }
        argv[argc ++] = buf;
c0100c04:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100c07:	8d 50 01             	lea    0x1(%eax),%edx
c0100c0a:	89 55 f4             	mov    %edx,-0xc(%ebp)
c0100c0d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0100c14:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100c17:	01 c2                	add    %eax,%edx
c0100c19:	8b 45 08             	mov    0x8(%ebp),%eax
c0100c1c:	89 02                	mov    %eax,(%edx)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
c0100c1e:	eb 03                	jmp    c0100c23 <parse+0x89>
            buf ++;
c0100c20:	ff 45 08             	incl   0x8(%ebp)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
c0100c23:	8b 45 08             	mov    0x8(%ebp),%eax
c0100c26:	0f b6 00             	movzbl (%eax),%eax
c0100c29:	84 c0                	test   %al,%al
c0100c2b:	74 8c                	je     c0100bb9 <parse+0x1f>
c0100c2d:	8b 45 08             	mov    0x8(%ebp),%eax
c0100c30:	0f b6 00             	movzbl (%eax),%eax
c0100c33:	0f be c0             	movsbl %al,%eax
c0100c36:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100c3a:	c7 04 24 dc 67 10 c0 	movl   $0xc01067dc,(%esp)
c0100c41:	e8 16 4f 00 00       	call   c0105b5c <strchr>
c0100c46:	85 c0                	test   %eax,%eax
c0100c48:	74 d6                	je     c0100c20 <parse+0x86>
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
c0100c4a:	e9 6a ff ff ff       	jmp    c0100bb9 <parse+0x1f>
            break;
c0100c4f:	90                   	nop
        }
    }
    return argc;
c0100c50:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0100c53:	c9                   	leave  
c0100c54:	c3                   	ret    

c0100c55 <runcmd>:
/* *
 * runcmd - parse the input string, split it into separated arguments
 * and then lookup and invoke some related commands/
 * */
static int
runcmd(char *buf, struct trapframe *tf) {
c0100c55:	f3 0f 1e fb          	endbr32 
c0100c59:	55                   	push   %ebp
c0100c5a:	89 e5                	mov    %esp,%ebp
c0100c5c:	53                   	push   %ebx
c0100c5d:	83 ec 64             	sub    $0x64,%esp
    char *argv[MAXARGS];
    int argc = parse(buf, argv);
c0100c60:	8d 45 b0             	lea    -0x50(%ebp),%eax
c0100c63:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100c67:	8b 45 08             	mov    0x8(%ebp),%eax
c0100c6a:	89 04 24             	mov    %eax,(%esp)
c0100c6d:	e8 28 ff ff ff       	call   c0100b9a <parse>
c0100c72:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if (argc == 0) {
c0100c75:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0100c79:	75 0a                	jne    c0100c85 <runcmd+0x30>
        return 0;
c0100c7b:	b8 00 00 00 00       	mov    $0x0,%eax
c0100c80:	e9 83 00 00 00       	jmp    c0100d08 <runcmd+0xb3>
    }
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
c0100c85:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0100c8c:	eb 5a                	jmp    c0100ce8 <runcmd+0x93>
        if (strcmp(commands[i].name, argv[0]) == 0) {
c0100c8e:	8b 4d b0             	mov    -0x50(%ebp),%ecx
c0100c91:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100c94:	89 d0                	mov    %edx,%eax
c0100c96:	01 c0                	add    %eax,%eax
c0100c98:	01 d0                	add    %edx,%eax
c0100c9a:	c1 e0 02             	shl    $0x2,%eax
c0100c9d:	05 00 a0 11 c0       	add    $0xc011a000,%eax
c0100ca2:	8b 00                	mov    (%eax),%eax
c0100ca4:	89 4c 24 04          	mov    %ecx,0x4(%esp)
c0100ca8:	89 04 24             	mov    %eax,(%esp)
c0100cab:	e8 08 4e 00 00       	call   c0105ab8 <strcmp>
c0100cb0:	85 c0                	test   %eax,%eax
c0100cb2:	75 31                	jne    c0100ce5 <runcmd+0x90>
            return commands[i].func(argc - 1, argv + 1, tf);
c0100cb4:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100cb7:	89 d0                	mov    %edx,%eax
c0100cb9:	01 c0                	add    %eax,%eax
c0100cbb:	01 d0                	add    %edx,%eax
c0100cbd:	c1 e0 02             	shl    $0x2,%eax
c0100cc0:	05 08 a0 11 c0       	add    $0xc011a008,%eax
c0100cc5:	8b 10                	mov    (%eax),%edx
c0100cc7:	8d 45 b0             	lea    -0x50(%ebp),%eax
c0100cca:	83 c0 04             	add    $0x4,%eax
c0100ccd:	8b 4d f0             	mov    -0x10(%ebp),%ecx
c0100cd0:	8d 59 ff             	lea    -0x1(%ecx),%ebx
c0100cd3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
c0100cd6:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c0100cda:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100cde:	89 1c 24             	mov    %ebx,(%esp)
c0100ce1:	ff d2                	call   *%edx
c0100ce3:	eb 23                	jmp    c0100d08 <runcmd+0xb3>
    for (i = 0; i < NCOMMANDS; i ++) {
c0100ce5:	ff 45 f4             	incl   -0xc(%ebp)
c0100ce8:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100ceb:	83 f8 02             	cmp    $0x2,%eax
c0100cee:	76 9e                	jbe    c0100c8e <runcmd+0x39>
        }
    }
    cprintf("Unknown command '%s'\n", argv[0]);
c0100cf0:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0100cf3:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100cf7:	c7 04 24 ff 67 10 c0 	movl   $0xc01067ff,(%esp)
c0100cfe:	e8 c2 f5 ff ff       	call   c01002c5 <cprintf>
    return 0;
c0100d03:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100d08:	83 c4 64             	add    $0x64,%esp
c0100d0b:	5b                   	pop    %ebx
c0100d0c:	5d                   	pop    %ebp
c0100d0d:	c3                   	ret    

c0100d0e <kmonitor>:

/***** Implementations of basic kernel monitor commands *****/

void
kmonitor(struct trapframe *tf) {
c0100d0e:	f3 0f 1e fb          	endbr32 
c0100d12:	55                   	push   %ebp
c0100d13:	89 e5                	mov    %esp,%ebp
c0100d15:	83 ec 28             	sub    $0x28,%esp
    cprintf("Welcome to the kernel debug monitor!!\n");
c0100d18:	c7 04 24 18 68 10 c0 	movl   $0xc0106818,(%esp)
c0100d1f:	e8 a1 f5 ff ff       	call   c01002c5 <cprintf>
    cprintf("Type 'help' for a list of commands.\n");
c0100d24:	c7 04 24 40 68 10 c0 	movl   $0xc0106840,(%esp)
c0100d2b:	e8 95 f5 ff ff       	call   c01002c5 <cprintf>

    if (tf != NULL) {
c0100d30:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0100d34:	74 0b                	je     c0100d41 <kmonitor+0x33>
        print_trapframe(tf);
c0100d36:	8b 45 08             	mov    0x8(%ebp),%eax
c0100d39:	89 04 24             	mov    %eax,(%esp)
c0100d3c:	e8 5d 0e 00 00       	call   c0101b9e <print_trapframe>
    }

    char *buf;
    while (1) {
        if ((buf = readline("K> ")) != NULL) {
c0100d41:	c7 04 24 65 68 10 c0 	movl   $0xc0106865,(%esp)
c0100d48:	e8 2b f6 ff ff       	call   c0100378 <readline>
c0100d4d:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0100d50:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0100d54:	74 eb                	je     c0100d41 <kmonitor+0x33>
            if (runcmd(buf, tf) < 0) {
c0100d56:	8b 45 08             	mov    0x8(%ebp),%eax
c0100d59:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100d5d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100d60:	89 04 24             	mov    %eax,(%esp)
c0100d63:	e8 ed fe ff ff       	call   c0100c55 <runcmd>
c0100d68:	85 c0                	test   %eax,%eax
c0100d6a:	78 02                	js     c0100d6e <kmonitor+0x60>
        if ((buf = readline("K> ")) != NULL) {
c0100d6c:	eb d3                	jmp    c0100d41 <kmonitor+0x33>
                break;
c0100d6e:	90                   	nop
            }
        }
    }
}
c0100d6f:	90                   	nop
c0100d70:	c9                   	leave  
c0100d71:	c3                   	ret    

c0100d72 <mon_help>:

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
c0100d72:	f3 0f 1e fb          	endbr32 
c0100d76:	55                   	push   %ebp
c0100d77:	89 e5                	mov    %esp,%ebp
c0100d79:	83 ec 28             	sub    $0x28,%esp
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
c0100d7c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0100d83:	eb 3d                	jmp    c0100dc2 <mon_help+0x50>
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
c0100d85:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100d88:	89 d0                	mov    %edx,%eax
c0100d8a:	01 c0                	add    %eax,%eax
c0100d8c:	01 d0                	add    %edx,%eax
c0100d8e:	c1 e0 02             	shl    $0x2,%eax
c0100d91:	05 04 a0 11 c0       	add    $0xc011a004,%eax
c0100d96:	8b 08                	mov    (%eax),%ecx
c0100d98:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100d9b:	89 d0                	mov    %edx,%eax
c0100d9d:	01 c0                	add    %eax,%eax
c0100d9f:	01 d0                	add    %edx,%eax
c0100da1:	c1 e0 02             	shl    $0x2,%eax
c0100da4:	05 00 a0 11 c0       	add    $0xc011a000,%eax
c0100da9:	8b 00                	mov    (%eax),%eax
c0100dab:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c0100daf:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100db3:	c7 04 24 69 68 10 c0 	movl   $0xc0106869,(%esp)
c0100dba:	e8 06 f5 ff ff       	call   c01002c5 <cprintf>
    for (i = 0; i < NCOMMANDS; i ++) {
c0100dbf:	ff 45 f4             	incl   -0xc(%ebp)
c0100dc2:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100dc5:	83 f8 02             	cmp    $0x2,%eax
c0100dc8:	76 bb                	jbe    c0100d85 <mon_help+0x13>
    }
    return 0;
c0100dca:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100dcf:	c9                   	leave  
c0100dd0:	c3                   	ret    

c0100dd1 <mon_kerninfo>:
/* *
 * mon_kerninfo - call print_kerninfo in kern/debug/kdebug.c to
 * print the memory occupancy in kernel.
 * */
int
mon_kerninfo(int argc, char **argv, struct trapframe *tf) {
c0100dd1:	f3 0f 1e fb          	endbr32 
c0100dd5:	55                   	push   %ebp
c0100dd6:	89 e5                	mov    %esp,%ebp
c0100dd8:	83 ec 08             	sub    $0x8,%esp
    print_kerninfo();
c0100ddb:	e8 a8 fb ff ff       	call   c0100988 <print_kerninfo>
    return 0;
c0100de0:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100de5:	c9                   	leave  
c0100de6:	c3                   	ret    

c0100de7 <mon_backtrace>:
/* *
 * mon_backtrace - call print_stackframe in kern/debug/kdebug.c to
 * print a backtrace of the stack.
 * */
int
mon_backtrace(int argc, char **argv, struct trapframe *tf) {
c0100de7:	f3 0f 1e fb          	endbr32 
c0100deb:	55                   	push   %ebp
c0100dec:	89 e5                	mov    %esp,%ebp
c0100dee:	83 ec 08             	sub    $0x8,%esp
    print_stackframe();
c0100df1:	e8 e4 fc ff ff       	call   c0100ada <print_stackframe>
    return 0;
c0100df6:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100dfb:	c9                   	leave  
c0100dfc:	c3                   	ret    

c0100dfd <clock_init>:
/* *
 * clock_init - initialize 8253 clock to interrupt 100 times per second,
 * and then enable IRQ_TIMER.
 * */
void
clock_init(void) {
c0100dfd:	f3 0f 1e fb          	endbr32 
c0100e01:	55                   	push   %ebp
c0100e02:	89 e5                	mov    %esp,%ebp
c0100e04:	83 ec 28             	sub    $0x28,%esp
c0100e07:	66 c7 45 ee 43 00    	movw   $0x43,-0x12(%ebp)
c0100e0d:	c6 45 ed 34          	movb   $0x34,-0x13(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100e11:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0100e15:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c0100e19:	ee                   	out    %al,(%dx)
}
c0100e1a:	90                   	nop
c0100e1b:	66 c7 45 f2 40 00    	movw   $0x40,-0xe(%ebp)
c0100e21:	c6 45 f1 9c          	movb   $0x9c,-0xf(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100e25:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c0100e29:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0100e2d:	ee                   	out    %al,(%dx)
}
c0100e2e:	90                   	nop
c0100e2f:	66 c7 45 f6 40 00    	movw   $0x40,-0xa(%ebp)
c0100e35:	c6 45 f5 2e          	movb   $0x2e,-0xb(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100e39:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c0100e3d:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c0100e41:	ee                   	out    %al,(%dx)
}
c0100e42:	90                   	nop
    outb(TIMER_MODE, TIMER_SEL0 | TIMER_RATEGEN | TIMER_16BIT);
    outb(IO_TIMER1, TIMER_DIV(100) % 256);
    outb(IO_TIMER1, TIMER_DIV(100) / 256);

    // initialize time counter 'ticks' to zero
    ticks = 0;
c0100e43:	c7 05 0c df 11 c0 00 	movl   $0x0,0xc011df0c
c0100e4a:	00 00 00 

    cprintf("++ setup timer interrupts\n");
c0100e4d:	c7 04 24 72 68 10 c0 	movl   $0xc0106872,(%esp)
c0100e54:	e8 6c f4 ff ff       	call   c01002c5 <cprintf>
    pic_enable(IRQ_TIMER);
c0100e59:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c0100e60:	e8 95 09 00 00       	call   c01017fa <pic_enable>
}
c0100e65:	90                   	nop
c0100e66:	c9                   	leave  
c0100e67:	c3                   	ret    

c0100e68 <__intr_save>:
#include <x86.h>
#include <intr.h>
#include <mmu.h>

static inline bool
__intr_save(void) {
c0100e68:	55                   	push   %ebp
c0100e69:	89 e5                	mov    %esp,%ebp
c0100e6b:	83 ec 18             	sub    $0x18,%esp
}

static inline uint32_t
read_eflags(void) {
    uint32_t eflags;
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
c0100e6e:	9c                   	pushf  
c0100e6f:	58                   	pop    %eax
c0100e70:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return eflags;
c0100e73:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
c0100e76:	25 00 02 00 00       	and    $0x200,%eax
c0100e7b:	85 c0                	test   %eax,%eax
c0100e7d:	74 0c                	je     c0100e8b <__intr_save+0x23>
        intr_disable();
c0100e7f:	e8 05 0b 00 00       	call   c0101989 <intr_disable>
        return 1;
c0100e84:	b8 01 00 00 00       	mov    $0x1,%eax
c0100e89:	eb 05                	jmp    c0100e90 <__intr_save+0x28>
    }
    return 0;
c0100e8b:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100e90:	c9                   	leave  
c0100e91:	c3                   	ret    

c0100e92 <__intr_restore>:

static inline void
__intr_restore(bool flag) {
c0100e92:	55                   	push   %ebp
c0100e93:	89 e5                	mov    %esp,%ebp
c0100e95:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
c0100e98:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0100e9c:	74 05                	je     c0100ea3 <__intr_restore+0x11>
        intr_enable();
c0100e9e:	e8 da 0a 00 00       	call   c010197d <intr_enable>
    }
}
c0100ea3:	90                   	nop
c0100ea4:	c9                   	leave  
c0100ea5:	c3                   	ret    

c0100ea6 <delay>:
#include <memlayout.h>
#include <sync.h>

/* stupid I/O delay routine necessitated by historical PC design flaws */
static void
delay(void) {
c0100ea6:	f3 0f 1e fb          	endbr32 
c0100eaa:	55                   	push   %ebp
c0100eab:	89 e5                	mov    %esp,%ebp
c0100ead:	83 ec 10             	sub    $0x10,%esp
c0100eb0:	66 c7 45 f2 84 00    	movw   $0x84,-0xe(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0100eb6:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c0100eba:	89 c2                	mov    %eax,%edx
c0100ebc:	ec                   	in     (%dx),%al
c0100ebd:	88 45 f1             	mov    %al,-0xf(%ebp)
c0100ec0:	66 c7 45 f6 84 00    	movw   $0x84,-0xa(%ebp)
c0100ec6:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0100eca:	89 c2                	mov    %eax,%edx
c0100ecc:	ec                   	in     (%dx),%al
c0100ecd:	88 45 f5             	mov    %al,-0xb(%ebp)
c0100ed0:	66 c7 45 fa 84 00    	movw   $0x84,-0x6(%ebp)
c0100ed6:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c0100eda:	89 c2                	mov    %eax,%edx
c0100edc:	ec                   	in     (%dx),%al
c0100edd:	88 45 f9             	mov    %al,-0x7(%ebp)
c0100ee0:	66 c7 45 fe 84 00    	movw   $0x84,-0x2(%ebp)
c0100ee6:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
c0100eea:	89 c2                	mov    %eax,%edx
c0100eec:	ec                   	in     (%dx),%al
c0100eed:	88 45 fd             	mov    %al,-0x3(%ebp)
    inb(0x84);
    inb(0x84);
    inb(0x84);
    inb(0x84);
}
c0100ef0:	90                   	nop
c0100ef1:	c9                   	leave  
c0100ef2:	c3                   	ret    

c0100ef3 <cga_init>:
static uint16_t addr_6845;

/* TEXT-mode CGA/VGA display output */

static void
cga_init(void) {
c0100ef3:	f3 0f 1e fb          	endbr32 
c0100ef7:	55                   	push   %ebp
c0100ef8:	89 e5                	mov    %esp,%ebp
c0100efa:	83 ec 20             	sub    $0x20,%esp
    volatile uint16_t *cp = (uint16_t *)(CGA_BUF + KERNBASE);
c0100efd:	c7 45 fc 00 80 0b c0 	movl   $0xc00b8000,-0x4(%ebp)
    uint16_t was = *cp;
c0100f04:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100f07:	0f b7 00             	movzwl (%eax),%eax
c0100f0a:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
    *cp = (uint16_t) 0xA55A;
c0100f0e:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100f11:	66 c7 00 5a a5       	movw   $0xa55a,(%eax)
    if (*cp != 0xA55A) {
c0100f16:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100f19:	0f b7 00             	movzwl (%eax),%eax
c0100f1c:	0f b7 c0             	movzwl %ax,%eax
c0100f1f:	3d 5a a5 00 00       	cmp    $0xa55a,%eax
c0100f24:	74 12                	je     c0100f38 <cga_init+0x45>
        cp = (uint16_t*)(MONO_BUF + KERNBASE);
c0100f26:	c7 45 fc 00 00 0b c0 	movl   $0xc00b0000,-0x4(%ebp)
        addr_6845 = MONO_BASE;
c0100f2d:	66 c7 05 46 d4 11 c0 	movw   $0x3b4,0xc011d446
c0100f34:	b4 03 
c0100f36:	eb 13                	jmp    c0100f4b <cga_init+0x58>
    } else {
        *cp = was;
c0100f38:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100f3b:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
c0100f3f:	66 89 10             	mov    %dx,(%eax)
        addr_6845 = CGA_BASE;
c0100f42:	66 c7 05 46 d4 11 c0 	movw   $0x3d4,0xc011d446
c0100f49:	d4 03 
    }

    // Extract cursor location
    uint32_t pos;
    outb(addr_6845, 14);
c0100f4b:	0f b7 05 46 d4 11 c0 	movzwl 0xc011d446,%eax
c0100f52:	66 89 45 e6          	mov    %ax,-0x1a(%ebp)
c0100f56:	c6 45 e5 0e          	movb   $0xe,-0x1b(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100f5a:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c0100f5e:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
c0100f62:	ee                   	out    %al,(%dx)
}
c0100f63:	90                   	nop
    pos = inb(addr_6845 + 1) << 8;
c0100f64:	0f b7 05 46 d4 11 c0 	movzwl 0xc011d446,%eax
c0100f6b:	40                   	inc    %eax
c0100f6c:	0f b7 c0             	movzwl %ax,%eax
c0100f6f:	66 89 45 ea          	mov    %ax,-0x16(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0100f73:	0f b7 45 ea          	movzwl -0x16(%ebp),%eax
c0100f77:	89 c2                	mov    %eax,%edx
c0100f79:	ec                   	in     (%dx),%al
c0100f7a:	88 45 e9             	mov    %al,-0x17(%ebp)
    return data;
c0100f7d:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c0100f81:	0f b6 c0             	movzbl %al,%eax
c0100f84:	c1 e0 08             	shl    $0x8,%eax
c0100f87:	89 45 f4             	mov    %eax,-0xc(%ebp)
    outb(addr_6845, 15);
c0100f8a:	0f b7 05 46 d4 11 c0 	movzwl 0xc011d446,%eax
c0100f91:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
c0100f95:	c6 45 ed 0f          	movb   $0xf,-0x13(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100f99:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0100f9d:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c0100fa1:	ee                   	out    %al,(%dx)
}
c0100fa2:	90                   	nop
    pos |= inb(addr_6845 + 1);
c0100fa3:	0f b7 05 46 d4 11 c0 	movzwl 0xc011d446,%eax
c0100faa:	40                   	inc    %eax
c0100fab:	0f b7 c0             	movzwl %ax,%eax
c0100fae:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0100fb2:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c0100fb6:	89 c2                	mov    %eax,%edx
c0100fb8:	ec                   	in     (%dx),%al
c0100fb9:	88 45 f1             	mov    %al,-0xf(%ebp)
    return data;
c0100fbc:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c0100fc0:	0f b6 c0             	movzbl %al,%eax
c0100fc3:	09 45 f4             	or     %eax,-0xc(%ebp)

    crt_buf = (uint16_t*) cp;
c0100fc6:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100fc9:	a3 40 d4 11 c0       	mov    %eax,0xc011d440
    crt_pos = pos;
c0100fce:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100fd1:	0f b7 c0             	movzwl %ax,%eax
c0100fd4:	66 a3 44 d4 11 c0    	mov    %ax,0xc011d444
}
c0100fda:	90                   	nop
c0100fdb:	c9                   	leave  
c0100fdc:	c3                   	ret    

c0100fdd <serial_init>:

static bool serial_exists = 0;

static void
serial_init(void) {
c0100fdd:	f3 0f 1e fb          	endbr32 
c0100fe1:	55                   	push   %ebp
c0100fe2:	89 e5                	mov    %esp,%ebp
c0100fe4:	83 ec 48             	sub    $0x48,%esp
c0100fe7:	66 c7 45 d2 fa 03    	movw   $0x3fa,-0x2e(%ebp)
c0100fed:	c6 45 d1 00          	movb   $0x0,-0x2f(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100ff1:	0f b6 45 d1          	movzbl -0x2f(%ebp),%eax
c0100ff5:	0f b7 55 d2          	movzwl -0x2e(%ebp),%edx
c0100ff9:	ee                   	out    %al,(%dx)
}
c0100ffa:	90                   	nop
c0100ffb:	66 c7 45 d6 fb 03    	movw   $0x3fb,-0x2a(%ebp)
c0101001:	c6 45 d5 80          	movb   $0x80,-0x2b(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101005:	0f b6 45 d5          	movzbl -0x2b(%ebp),%eax
c0101009:	0f b7 55 d6          	movzwl -0x2a(%ebp),%edx
c010100d:	ee                   	out    %al,(%dx)
}
c010100e:	90                   	nop
c010100f:	66 c7 45 da f8 03    	movw   $0x3f8,-0x26(%ebp)
c0101015:	c6 45 d9 0c          	movb   $0xc,-0x27(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101019:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
c010101d:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
c0101021:	ee                   	out    %al,(%dx)
}
c0101022:	90                   	nop
c0101023:	66 c7 45 de f9 03    	movw   $0x3f9,-0x22(%ebp)
c0101029:	c6 45 dd 00          	movb   $0x0,-0x23(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c010102d:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
c0101031:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
c0101035:	ee                   	out    %al,(%dx)
}
c0101036:	90                   	nop
c0101037:	66 c7 45 e2 fb 03    	movw   $0x3fb,-0x1e(%ebp)
c010103d:	c6 45 e1 03          	movb   $0x3,-0x1f(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101041:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
c0101045:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
c0101049:	ee                   	out    %al,(%dx)
}
c010104a:	90                   	nop
c010104b:	66 c7 45 e6 fc 03    	movw   $0x3fc,-0x1a(%ebp)
c0101051:	c6 45 e5 00          	movb   $0x0,-0x1b(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101055:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c0101059:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
c010105d:	ee                   	out    %al,(%dx)
}
c010105e:	90                   	nop
c010105f:	66 c7 45 ea f9 03    	movw   $0x3f9,-0x16(%ebp)
c0101065:	c6 45 e9 01          	movb   $0x1,-0x17(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101069:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c010106d:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c0101071:	ee                   	out    %al,(%dx)
}
c0101072:	90                   	nop
c0101073:	66 c7 45 ee fd 03    	movw   $0x3fd,-0x12(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0101079:	0f b7 45 ee          	movzwl -0x12(%ebp),%eax
c010107d:	89 c2                	mov    %eax,%edx
c010107f:	ec                   	in     (%dx),%al
c0101080:	88 45 ed             	mov    %al,-0x13(%ebp)
    return data;
c0101083:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
    // Enable rcv interrupts
    outb(COM1 + COM_IER, COM_IER_RDI);

    // Clear any preexisting overrun indications and interrupts
    // Serial port doesn't exist if COM_LSR returns 0xFF
    serial_exists = (inb(COM1 + COM_LSR) != 0xFF);
c0101087:	3c ff                	cmp    $0xff,%al
c0101089:	0f 95 c0             	setne  %al
c010108c:	0f b6 c0             	movzbl %al,%eax
c010108f:	a3 48 d4 11 c0       	mov    %eax,0xc011d448
c0101094:	66 c7 45 f2 fa 03    	movw   $0x3fa,-0xe(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c010109a:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c010109e:	89 c2                	mov    %eax,%edx
c01010a0:	ec                   	in     (%dx),%al
c01010a1:	88 45 f1             	mov    %al,-0xf(%ebp)
c01010a4:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
c01010aa:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c01010ae:	89 c2                	mov    %eax,%edx
c01010b0:	ec                   	in     (%dx),%al
c01010b1:	88 45 f5             	mov    %al,-0xb(%ebp)
    (void) inb(COM1+COM_IIR);
    (void) inb(COM1+COM_RX);

    if (serial_exists) {
c01010b4:	a1 48 d4 11 c0       	mov    0xc011d448,%eax
c01010b9:	85 c0                	test   %eax,%eax
c01010bb:	74 0c                	je     c01010c9 <serial_init+0xec>
        pic_enable(IRQ_COM1);
c01010bd:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
c01010c4:	e8 31 07 00 00       	call   c01017fa <pic_enable>
    }
}
c01010c9:	90                   	nop
c01010ca:	c9                   	leave  
c01010cb:	c3                   	ret    

c01010cc <lpt_putc_sub>:

static void
lpt_putc_sub(int c) {
c01010cc:	f3 0f 1e fb          	endbr32 
c01010d0:	55                   	push   %ebp
c01010d1:	89 e5                	mov    %esp,%ebp
c01010d3:	83 ec 20             	sub    $0x20,%esp
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
c01010d6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c01010dd:	eb 08                	jmp    c01010e7 <lpt_putc_sub+0x1b>
        delay();
c01010df:	e8 c2 fd ff ff       	call   c0100ea6 <delay>
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
c01010e4:	ff 45 fc             	incl   -0x4(%ebp)
c01010e7:	66 c7 45 fa 79 03    	movw   $0x379,-0x6(%ebp)
c01010ed:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c01010f1:	89 c2                	mov    %eax,%edx
c01010f3:	ec                   	in     (%dx),%al
c01010f4:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
c01010f7:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
c01010fb:	84 c0                	test   %al,%al
c01010fd:	78 09                	js     c0101108 <lpt_putc_sub+0x3c>
c01010ff:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
c0101106:	7e d7                	jle    c01010df <lpt_putc_sub+0x13>
    }
    outb(LPTPORT + 0, c);
c0101108:	8b 45 08             	mov    0x8(%ebp),%eax
c010110b:	0f b6 c0             	movzbl %al,%eax
c010110e:	66 c7 45 ee 78 03    	movw   $0x378,-0x12(%ebp)
c0101114:	88 45 ed             	mov    %al,-0x13(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101117:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c010111b:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c010111f:	ee                   	out    %al,(%dx)
}
c0101120:	90                   	nop
c0101121:	66 c7 45 f2 7a 03    	movw   $0x37a,-0xe(%ebp)
c0101127:	c6 45 f1 0d          	movb   $0xd,-0xf(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c010112b:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c010112f:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101133:	ee                   	out    %al,(%dx)
}
c0101134:	90                   	nop
c0101135:	66 c7 45 f6 7a 03    	movw   $0x37a,-0xa(%ebp)
c010113b:	c6 45 f5 08          	movb   $0x8,-0xb(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c010113f:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c0101143:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c0101147:	ee                   	out    %al,(%dx)
}
c0101148:	90                   	nop
    outb(LPTPORT + 2, 0x08 | 0x04 | 0x01);
    outb(LPTPORT + 2, 0x08);
}
c0101149:	90                   	nop
c010114a:	c9                   	leave  
c010114b:	c3                   	ret    

c010114c <lpt_putc>:

/* lpt_putc - copy console output to parallel port */
static void
lpt_putc(int c) {
c010114c:	f3 0f 1e fb          	endbr32 
c0101150:	55                   	push   %ebp
c0101151:	89 e5                	mov    %esp,%ebp
c0101153:	83 ec 04             	sub    $0x4,%esp
    if (c != '\b') {
c0101156:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
c010115a:	74 0d                	je     c0101169 <lpt_putc+0x1d>
        lpt_putc_sub(c);
c010115c:	8b 45 08             	mov    0x8(%ebp),%eax
c010115f:	89 04 24             	mov    %eax,(%esp)
c0101162:	e8 65 ff ff ff       	call   c01010cc <lpt_putc_sub>
    else {
        lpt_putc_sub('\b');
        lpt_putc_sub(' ');
        lpt_putc_sub('\b');
    }
}
c0101167:	eb 24                	jmp    c010118d <lpt_putc+0x41>
        lpt_putc_sub('\b');
c0101169:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
c0101170:	e8 57 ff ff ff       	call   c01010cc <lpt_putc_sub>
        lpt_putc_sub(' ');
c0101175:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
c010117c:	e8 4b ff ff ff       	call   c01010cc <lpt_putc_sub>
        lpt_putc_sub('\b');
c0101181:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
c0101188:	e8 3f ff ff ff       	call   c01010cc <lpt_putc_sub>
}
c010118d:	90                   	nop
c010118e:	c9                   	leave  
c010118f:	c3                   	ret    

c0101190 <cga_putc>:

/* cga_putc - print character to console */
static void
cga_putc(int c) {
c0101190:	f3 0f 1e fb          	endbr32 
c0101194:	55                   	push   %ebp
c0101195:	89 e5                	mov    %esp,%ebp
c0101197:	53                   	push   %ebx
c0101198:	83 ec 34             	sub    $0x34,%esp
    // set black on white
    if (!(c & ~0xFF)) {
c010119b:	8b 45 08             	mov    0x8(%ebp),%eax
c010119e:	25 00 ff ff ff       	and    $0xffffff00,%eax
c01011a3:	85 c0                	test   %eax,%eax
c01011a5:	75 07                	jne    c01011ae <cga_putc+0x1e>
        c |= 0x0700;
c01011a7:	81 4d 08 00 07 00 00 	orl    $0x700,0x8(%ebp)
    }

    switch (c & 0xff) {
c01011ae:	8b 45 08             	mov    0x8(%ebp),%eax
c01011b1:	0f b6 c0             	movzbl %al,%eax
c01011b4:	83 f8 0d             	cmp    $0xd,%eax
c01011b7:	74 72                	je     c010122b <cga_putc+0x9b>
c01011b9:	83 f8 0d             	cmp    $0xd,%eax
c01011bc:	0f 8f a3 00 00 00    	jg     c0101265 <cga_putc+0xd5>
c01011c2:	83 f8 08             	cmp    $0x8,%eax
c01011c5:	74 0a                	je     c01011d1 <cga_putc+0x41>
c01011c7:	83 f8 0a             	cmp    $0xa,%eax
c01011ca:	74 4c                	je     c0101218 <cga_putc+0x88>
c01011cc:	e9 94 00 00 00       	jmp    c0101265 <cga_putc+0xd5>
    case '\b':
        if (crt_pos > 0) {
c01011d1:	0f b7 05 44 d4 11 c0 	movzwl 0xc011d444,%eax
c01011d8:	85 c0                	test   %eax,%eax
c01011da:	0f 84 af 00 00 00    	je     c010128f <cga_putc+0xff>
            crt_pos --;
c01011e0:	0f b7 05 44 d4 11 c0 	movzwl 0xc011d444,%eax
c01011e7:	48                   	dec    %eax
c01011e8:	0f b7 c0             	movzwl %ax,%eax
c01011eb:	66 a3 44 d4 11 c0    	mov    %ax,0xc011d444
            crt_buf[crt_pos] = (c & ~0xff) | ' ';
c01011f1:	8b 45 08             	mov    0x8(%ebp),%eax
c01011f4:	98                   	cwtl   
c01011f5:	25 00 ff ff ff       	and    $0xffffff00,%eax
c01011fa:	98                   	cwtl   
c01011fb:	83 c8 20             	or     $0x20,%eax
c01011fe:	98                   	cwtl   
c01011ff:	8b 15 40 d4 11 c0    	mov    0xc011d440,%edx
c0101205:	0f b7 0d 44 d4 11 c0 	movzwl 0xc011d444,%ecx
c010120c:	01 c9                	add    %ecx,%ecx
c010120e:	01 ca                	add    %ecx,%edx
c0101210:	0f b7 c0             	movzwl %ax,%eax
c0101213:	66 89 02             	mov    %ax,(%edx)
        }
        break;
c0101216:	eb 77                	jmp    c010128f <cga_putc+0xff>
    case '\n':
        crt_pos += CRT_COLS;
c0101218:	0f b7 05 44 d4 11 c0 	movzwl 0xc011d444,%eax
c010121f:	83 c0 50             	add    $0x50,%eax
c0101222:	0f b7 c0             	movzwl %ax,%eax
c0101225:	66 a3 44 d4 11 c0    	mov    %ax,0xc011d444
    case '\r':
        crt_pos -= (crt_pos % CRT_COLS);
c010122b:	0f b7 1d 44 d4 11 c0 	movzwl 0xc011d444,%ebx
c0101232:	0f b7 0d 44 d4 11 c0 	movzwl 0xc011d444,%ecx
c0101239:	ba cd cc cc cc       	mov    $0xcccccccd,%edx
c010123e:	89 c8                	mov    %ecx,%eax
c0101240:	f7 e2                	mul    %edx
c0101242:	c1 ea 06             	shr    $0x6,%edx
c0101245:	89 d0                	mov    %edx,%eax
c0101247:	c1 e0 02             	shl    $0x2,%eax
c010124a:	01 d0                	add    %edx,%eax
c010124c:	c1 e0 04             	shl    $0x4,%eax
c010124f:	29 c1                	sub    %eax,%ecx
c0101251:	89 c8                	mov    %ecx,%eax
c0101253:	0f b7 c0             	movzwl %ax,%eax
c0101256:	29 c3                	sub    %eax,%ebx
c0101258:	89 d8                	mov    %ebx,%eax
c010125a:	0f b7 c0             	movzwl %ax,%eax
c010125d:	66 a3 44 d4 11 c0    	mov    %ax,0xc011d444
        break;
c0101263:	eb 2b                	jmp    c0101290 <cga_putc+0x100>
    default:
        crt_buf[crt_pos ++] = c;     // write the character
c0101265:	8b 0d 40 d4 11 c0    	mov    0xc011d440,%ecx
c010126b:	0f b7 05 44 d4 11 c0 	movzwl 0xc011d444,%eax
c0101272:	8d 50 01             	lea    0x1(%eax),%edx
c0101275:	0f b7 d2             	movzwl %dx,%edx
c0101278:	66 89 15 44 d4 11 c0 	mov    %dx,0xc011d444
c010127f:	01 c0                	add    %eax,%eax
c0101281:	8d 14 01             	lea    (%ecx,%eax,1),%edx
c0101284:	8b 45 08             	mov    0x8(%ebp),%eax
c0101287:	0f b7 c0             	movzwl %ax,%eax
c010128a:	66 89 02             	mov    %ax,(%edx)
        break;
c010128d:	eb 01                	jmp    c0101290 <cga_putc+0x100>
        break;
c010128f:	90                   	nop
    }

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
c0101290:	0f b7 05 44 d4 11 c0 	movzwl 0xc011d444,%eax
c0101297:	3d cf 07 00 00       	cmp    $0x7cf,%eax
c010129c:	76 5d                	jbe    c01012fb <cga_putc+0x16b>
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
c010129e:	a1 40 d4 11 c0       	mov    0xc011d440,%eax
c01012a3:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
c01012a9:	a1 40 d4 11 c0       	mov    0xc011d440,%eax
c01012ae:	c7 44 24 08 00 0f 00 	movl   $0xf00,0x8(%esp)
c01012b5:	00 
c01012b6:	89 54 24 04          	mov    %edx,0x4(%esp)
c01012ba:	89 04 24             	mov    %eax,(%esp)
c01012bd:	e8 9f 4a 00 00       	call   c0105d61 <memmove>
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
c01012c2:	c7 45 f4 80 07 00 00 	movl   $0x780,-0xc(%ebp)
c01012c9:	eb 14                	jmp    c01012df <cga_putc+0x14f>
            crt_buf[i] = 0x0700 | ' ';
c01012cb:	a1 40 d4 11 c0       	mov    0xc011d440,%eax
c01012d0:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01012d3:	01 d2                	add    %edx,%edx
c01012d5:	01 d0                	add    %edx,%eax
c01012d7:	66 c7 00 20 07       	movw   $0x720,(%eax)
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
c01012dc:	ff 45 f4             	incl   -0xc(%ebp)
c01012df:	81 7d f4 cf 07 00 00 	cmpl   $0x7cf,-0xc(%ebp)
c01012e6:	7e e3                	jle    c01012cb <cga_putc+0x13b>
        }
        crt_pos -= CRT_COLS;
c01012e8:	0f b7 05 44 d4 11 c0 	movzwl 0xc011d444,%eax
c01012ef:	83 e8 50             	sub    $0x50,%eax
c01012f2:	0f b7 c0             	movzwl %ax,%eax
c01012f5:	66 a3 44 d4 11 c0    	mov    %ax,0xc011d444
    }

    // move that little blinky thing
    outb(addr_6845, 14);
c01012fb:	0f b7 05 46 d4 11 c0 	movzwl 0xc011d446,%eax
c0101302:	66 89 45 e6          	mov    %ax,-0x1a(%ebp)
c0101306:	c6 45 e5 0e          	movb   $0xe,-0x1b(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c010130a:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c010130e:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
c0101312:	ee                   	out    %al,(%dx)
}
c0101313:	90                   	nop
    outb(addr_6845 + 1, crt_pos >> 8);
c0101314:	0f b7 05 44 d4 11 c0 	movzwl 0xc011d444,%eax
c010131b:	c1 e8 08             	shr    $0x8,%eax
c010131e:	0f b7 c0             	movzwl %ax,%eax
c0101321:	0f b6 c0             	movzbl %al,%eax
c0101324:	0f b7 15 46 d4 11 c0 	movzwl 0xc011d446,%edx
c010132b:	42                   	inc    %edx
c010132c:	0f b7 d2             	movzwl %dx,%edx
c010132f:	66 89 55 ea          	mov    %dx,-0x16(%ebp)
c0101333:	88 45 e9             	mov    %al,-0x17(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101336:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c010133a:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c010133e:	ee                   	out    %al,(%dx)
}
c010133f:	90                   	nop
    outb(addr_6845, 15);
c0101340:	0f b7 05 46 d4 11 c0 	movzwl 0xc011d446,%eax
c0101347:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
c010134b:	c6 45 ed 0f          	movb   $0xf,-0x13(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c010134f:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0101353:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c0101357:	ee                   	out    %al,(%dx)
}
c0101358:	90                   	nop
    outb(addr_6845 + 1, crt_pos);
c0101359:	0f b7 05 44 d4 11 c0 	movzwl 0xc011d444,%eax
c0101360:	0f b6 c0             	movzbl %al,%eax
c0101363:	0f b7 15 46 d4 11 c0 	movzwl 0xc011d446,%edx
c010136a:	42                   	inc    %edx
c010136b:	0f b7 d2             	movzwl %dx,%edx
c010136e:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
c0101372:	88 45 f1             	mov    %al,-0xf(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101375:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c0101379:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c010137d:	ee                   	out    %al,(%dx)
}
c010137e:	90                   	nop
}
c010137f:	90                   	nop
c0101380:	83 c4 34             	add    $0x34,%esp
c0101383:	5b                   	pop    %ebx
c0101384:	5d                   	pop    %ebp
c0101385:	c3                   	ret    

c0101386 <serial_putc_sub>:

static void
serial_putc_sub(int c) {
c0101386:	f3 0f 1e fb          	endbr32 
c010138a:	55                   	push   %ebp
c010138b:	89 e5                	mov    %esp,%ebp
c010138d:	83 ec 10             	sub    $0x10,%esp
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
c0101390:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c0101397:	eb 08                	jmp    c01013a1 <serial_putc_sub+0x1b>
        delay();
c0101399:	e8 08 fb ff ff       	call   c0100ea6 <delay>
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
c010139e:	ff 45 fc             	incl   -0x4(%ebp)
c01013a1:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c01013a7:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c01013ab:	89 c2                	mov    %eax,%edx
c01013ad:	ec                   	in     (%dx),%al
c01013ae:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
c01013b1:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
c01013b5:	0f b6 c0             	movzbl %al,%eax
c01013b8:	83 e0 20             	and    $0x20,%eax
c01013bb:	85 c0                	test   %eax,%eax
c01013bd:	75 09                	jne    c01013c8 <serial_putc_sub+0x42>
c01013bf:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
c01013c6:	7e d1                	jle    c0101399 <serial_putc_sub+0x13>
    }
    outb(COM1 + COM_TX, c);
c01013c8:	8b 45 08             	mov    0x8(%ebp),%eax
c01013cb:	0f b6 c0             	movzbl %al,%eax
c01013ce:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
c01013d4:	88 45 f5             	mov    %al,-0xb(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c01013d7:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c01013db:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c01013df:	ee                   	out    %al,(%dx)
}
c01013e0:	90                   	nop
}
c01013e1:	90                   	nop
c01013e2:	c9                   	leave  
c01013e3:	c3                   	ret    

c01013e4 <serial_putc>:

/* serial_putc - print character to serial port */
static void
serial_putc(int c) {
c01013e4:	f3 0f 1e fb          	endbr32 
c01013e8:	55                   	push   %ebp
c01013e9:	89 e5                	mov    %esp,%ebp
c01013eb:	83 ec 04             	sub    $0x4,%esp
    if (c != '\b') {
c01013ee:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
c01013f2:	74 0d                	je     c0101401 <serial_putc+0x1d>
        serial_putc_sub(c);
c01013f4:	8b 45 08             	mov    0x8(%ebp),%eax
c01013f7:	89 04 24             	mov    %eax,(%esp)
c01013fa:	e8 87 ff ff ff       	call   c0101386 <serial_putc_sub>
    else {
        serial_putc_sub('\b');
        serial_putc_sub(' ');
        serial_putc_sub('\b');
    }
}
c01013ff:	eb 24                	jmp    c0101425 <serial_putc+0x41>
        serial_putc_sub('\b');
c0101401:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
c0101408:	e8 79 ff ff ff       	call   c0101386 <serial_putc_sub>
        serial_putc_sub(' ');
c010140d:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
c0101414:	e8 6d ff ff ff       	call   c0101386 <serial_putc_sub>
        serial_putc_sub('\b');
c0101419:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
c0101420:	e8 61 ff ff ff       	call   c0101386 <serial_putc_sub>
}
c0101425:	90                   	nop
c0101426:	c9                   	leave  
c0101427:	c3                   	ret    

c0101428 <cons_intr>:
/* *
 * cons_intr - called by device interrupt routines to feed input
 * characters into the circular console input buffer.
 * */
static void
cons_intr(int (*proc)(void)) {
c0101428:	f3 0f 1e fb          	endbr32 
c010142c:	55                   	push   %ebp
c010142d:	89 e5                	mov    %esp,%ebp
c010142f:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = (*proc)()) != -1) {
c0101432:	eb 33                	jmp    c0101467 <cons_intr+0x3f>
        if (c != 0) {
c0101434:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0101438:	74 2d                	je     c0101467 <cons_intr+0x3f>
            cons.buf[cons.wpos ++] = c;
c010143a:	a1 64 d6 11 c0       	mov    0xc011d664,%eax
c010143f:	8d 50 01             	lea    0x1(%eax),%edx
c0101442:	89 15 64 d6 11 c0    	mov    %edx,0xc011d664
c0101448:	8b 55 f4             	mov    -0xc(%ebp),%edx
c010144b:	88 90 60 d4 11 c0    	mov    %dl,-0x3fee2ba0(%eax)
            if (cons.wpos == CONSBUFSIZE) {
c0101451:	a1 64 d6 11 c0       	mov    0xc011d664,%eax
c0101456:	3d 00 02 00 00       	cmp    $0x200,%eax
c010145b:	75 0a                	jne    c0101467 <cons_intr+0x3f>
                cons.wpos = 0;
c010145d:	c7 05 64 d6 11 c0 00 	movl   $0x0,0xc011d664
c0101464:	00 00 00 
    while ((c = (*proc)()) != -1) {
c0101467:	8b 45 08             	mov    0x8(%ebp),%eax
c010146a:	ff d0                	call   *%eax
c010146c:	89 45 f4             	mov    %eax,-0xc(%ebp)
c010146f:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
c0101473:	75 bf                	jne    c0101434 <cons_intr+0xc>
            }
        }
    }
}
c0101475:	90                   	nop
c0101476:	90                   	nop
c0101477:	c9                   	leave  
c0101478:	c3                   	ret    

c0101479 <serial_proc_data>:

/* serial_proc_data - get data from serial port */
static int
serial_proc_data(void) {
c0101479:	f3 0f 1e fb          	endbr32 
c010147d:	55                   	push   %ebp
c010147e:	89 e5                	mov    %esp,%ebp
c0101480:	83 ec 10             	sub    $0x10,%esp
c0101483:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0101489:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c010148d:	89 c2                	mov    %eax,%edx
c010148f:	ec                   	in     (%dx),%al
c0101490:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
c0101493:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
    if (!(inb(COM1 + COM_LSR) & COM_LSR_DATA)) {
c0101497:	0f b6 c0             	movzbl %al,%eax
c010149a:	83 e0 01             	and    $0x1,%eax
c010149d:	85 c0                	test   %eax,%eax
c010149f:	75 07                	jne    c01014a8 <serial_proc_data+0x2f>
        return -1;
c01014a1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c01014a6:	eb 2a                	jmp    c01014d2 <serial_proc_data+0x59>
c01014a8:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c01014ae:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c01014b2:	89 c2                	mov    %eax,%edx
c01014b4:	ec                   	in     (%dx),%al
c01014b5:	88 45 f5             	mov    %al,-0xb(%ebp)
    return data;
c01014b8:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
    }
    int c = inb(COM1 + COM_RX);
c01014bc:	0f b6 c0             	movzbl %al,%eax
c01014bf:	89 45 fc             	mov    %eax,-0x4(%ebp)
    if (c == 127) {
c01014c2:	83 7d fc 7f          	cmpl   $0x7f,-0x4(%ebp)
c01014c6:	75 07                	jne    c01014cf <serial_proc_data+0x56>
        c = '\b';
c01014c8:	c7 45 fc 08 00 00 00 	movl   $0x8,-0x4(%ebp)
    }
    return c;
c01014cf:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c01014d2:	c9                   	leave  
c01014d3:	c3                   	ret    

c01014d4 <serial_intr>:

/* serial_intr - try to feed input characters from serial port */
void
serial_intr(void) {
c01014d4:	f3 0f 1e fb          	endbr32 
c01014d8:	55                   	push   %ebp
c01014d9:	89 e5                	mov    %esp,%ebp
c01014db:	83 ec 18             	sub    $0x18,%esp
    if (serial_exists) {
c01014de:	a1 48 d4 11 c0       	mov    0xc011d448,%eax
c01014e3:	85 c0                	test   %eax,%eax
c01014e5:	74 0c                	je     c01014f3 <serial_intr+0x1f>
        cons_intr(serial_proc_data);
c01014e7:	c7 04 24 79 14 10 c0 	movl   $0xc0101479,(%esp)
c01014ee:	e8 35 ff ff ff       	call   c0101428 <cons_intr>
    }
}
c01014f3:	90                   	nop
c01014f4:	c9                   	leave  
c01014f5:	c3                   	ret    

c01014f6 <kbd_proc_data>:
 *
 * The kbd_proc_data() function gets data from the keyboard.
 * If we finish a character, return it, else 0. And return -1 if no data.
 * */
static int
kbd_proc_data(void) {
c01014f6:	f3 0f 1e fb          	endbr32 
c01014fa:	55                   	push   %ebp
c01014fb:	89 e5                	mov    %esp,%ebp
c01014fd:	83 ec 38             	sub    $0x38,%esp
c0101500:	66 c7 45 f0 64 00    	movw   $0x64,-0x10(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0101506:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0101509:	89 c2                	mov    %eax,%edx
c010150b:	ec                   	in     (%dx),%al
c010150c:	88 45 ef             	mov    %al,-0x11(%ebp)
    return data;
c010150f:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    int c;
    uint8_t data;
    static uint32_t shift;

    if ((inb(KBSTATP) & KBS_DIB) == 0) {
c0101513:	0f b6 c0             	movzbl %al,%eax
c0101516:	83 e0 01             	and    $0x1,%eax
c0101519:	85 c0                	test   %eax,%eax
c010151b:	75 0a                	jne    c0101527 <kbd_proc_data+0x31>
        return -1;
c010151d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c0101522:	e9 56 01 00 00       	jmp    c010167d <kbd_proc_data+0x187>
c0101527:	66 c7 45 ec 60 00    	movw   $0x60,-0x14(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c010152d:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0101530:	89 c2                	mov    %eax,%edx
c0101532:	ec                   	in     (%dx),%al
c0101533:	88 45 eb             	mov    %al,-0x15(%ebp)
    return data;
c0101536:	0f b6 45 eb          	movzbl -0x15(%ebp),%eax
    }

    data = inb(KBDATAP);
c010153a:	88 45 f3             	mov    %al,-0xd(%ebp)

    if (data == 0xE0) {
c010153d:	80 7d f3 e0          	cmpb   $0xe0,-0xd(%ebp)
c0101541:	75 17                	jne    c010155a <kbd_proc_data+0x64>
        // E0 escape character
        shift |= E0ESC;
c0101543:	a1 68 d6 11 c0       	mov    0xc011d668,%eax
c0101548:	83 c8 40             	or     $0x40,%eax
c010154b:	a3 68 d6 11 c0       	mov    %eax,0xc011d668
        return 0;
c0101550:	b8 00 00 00 00       	mov    $0x0,%eax
c0101555:	e9 23 01 00 00       	jmp    c010167d <kbd_proc_data+0x187>
    } else if (data & 0x80) {
c010155a:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c010155e:	84 c0                	test   %al,%al
c0101560:	79 45                	jns    c01015a7 <kbd_proc_data+0xb1>
        // Key released
        data = (shift & E0ESC ? data : data & 0x7F);
c0101562:	a1 68 d6 11 c0       	mov    0xc011d668,%eax
c0101567:	83 e0 40             	and    $0x40,%eax
c010156a:	85 c0                	test   %eax,%eax
c010156c:	75 08                	jne    c0101576 <kbd_proc_data+0x80>
c010156e:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c0101572:	24 7f                	and    $0x7f,%al
c0101574:	eb 04                	jmp    c010157a <kbd_proc_data+0x84>
c0101576:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c010157a:	88 45 f3             	mov    %al,-0xd(%ebp)
        shift &= ~(shiftcode[data] | E0ESC);
c010157d:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c0101581:	0f b6 80 40 a0 11 c0 	movzbl -0x3fee5fc0(%eax),%eax
c0101588:	0c 40                	or     $0x40,%al
c010158a:	0f b6 c0             	movzbl %al,%eax
c010158d:	f7 d0                	not    %eax
c010158f:	89 c2                	mov    %eax,%edx
c0101591:	a1 68 d6 11 c0       	mov    0xc011d668,%eax
c0101596:	21 d0                	and    %edx,%eax
c0101598:	a3 68 d6 11 c0       	mov    %eax,0xc011d668
        return 0;
c010159d:	b8 00 00 00 00       	mov    $0x0,%eax
c01015a2:	e9 d6 00 00 00       	jmp    c010167d <kbd_proc_data+0x187>
    } else if (shift & E0ESC) {
c01015a7:	a1 68 d6 11 c0       	mov    0xc011d668,%eax
c01015ac:	83 e0 40             	and    $0x40,%eax
c01015af:	85 c0                	test   %eax,%eax
c01015b1:	74 11                	je     c01015c4 <kbd_proc_data+0xce>
        // Last character was an E0 escape; or with 0x80
        data |= 0x80;
c01015b3:	80 4d f3 80          	orb    $0x80,-0xd(%ebp)
        shift &= ~E0ESC;
c01015b7:	a1 68 d6 11 c0       	mov    0xc011d668,%eax
c01015bc:	83 e0 bf             	and    $0xffffffbf,%eax
c01015bf:	a3 68 d6 11 c0       	mov    %eax,0xc011d668
    }

    shift |= shiftcode[data];
c01015c4:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c01015c8:	0f b6 80 40 a0 11 c0 	movzbl -0x3fee5fc0(%eax),%eax
c01015cf:	0f b6 d0             	movzbl %al,%edx
c01015d2:	a1 68 d6 11 c0       	mov    0xc011d668,%eax
c01015d7:	09 d0                	or     %edx,%eax
c01015d9:	a3 68 d6 11 c0       	mov    %eax,0xc011d668
    shift ^= togglecode[data];
c01015de:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c01015e2:	0f b6 80 40 a1 11 c0 	movzbl -0x3fee5ec0(%eax),%eax
c01015e9:	0f b6 d0             	movzbl %al,%edx
c01015ec:	a1 68 d6 11 c0       	mov    0xc011d668,%eax
c01015f1:	31 d0                	xor    %edx,%eax
c01015f3:	a3 68 d6 11 c0       	mov    %eax,0xc011d668

    c = charcode[shift & (CTL | SHIFT)][data];
c01015f8:	a1 68 d6 11 c0       	mov    0xc011d668,%eax
c01015fd:	83 e0 03             	and    $0x3,%eax
c0101600:	8b 14 85 40 a5 11 c0 	mov    -0x3fee5ac0(,%eax,4),%edx
c0101607:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c010160b:	01 d0                	add    %edx,%eax
c010160d:	0f b6 00             	movzbl (%eax),%eax
c0101610:	0f b6 c0             	movzbl %al,%eax
c0101613:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (shift & CAPSLOCK) {
c0101616:	a1 68 d6 11 c0       	mov    0xc011d668,%eax
c010161b:	83 e0 08             	and    $0x8,%eax
c010161e:	85 c0                	test   %eax,%eax
c0101620:	74 22                	je     c0101644 <kbd_proc_data+0x14e>
        if ('a' <= c && c <= 'z')
c0101622:	83 7d f4 60          	cmpl   $0x60,-0xc(%ebp)
c0101626:	7e 0c                	jle    c0101634 <kbd_proc_data+0x13e>
c0101628:	83 7d f4 7a          	cmpl   $0x7a,-0xc(%ebp)
c010162c:	7f 06                	jg     c0101634 <kbd_proc_data+0x13e>
            c += 'A' - 'a';
c010162e:	83 6d f4 20          	subl   $0x20,-0xc(%ebp)
c0101632:	eb 10                	jmp    c0101644 <kbd_proc_data+0x14e>
        else if ('A' <= c && c <= 'Z')
c0101634:	83 7d f4 40          	cmpl   $0x40,-0xc(%ebp)
c0101638:	7e 0a                	jle    c0101644 <kbd_proc_data+0x14e>
c010163a:	83 7d f4 5a          	cmpl   $0x5a,-0xc(%ebp)
c010163e:	7f 04                	jg     c0101644 <kbd_proc_data+0x14e>
            c += 'a' - 'A';
c0101640:	83 45 f4 20          	addl   $0x20,-0xc(%ebp)
    }

    // Process special keys
    // Ctrl-Alt-Del: reboot
    if (!(~shift & (CTL | ALT)) && c == KEY_DEL) {
c0101644:	a1 68 d6 11 c0       	mov    0xc011d668,%eax
c0101649:	f7 d0                	not    %eax
c010164b:	83 e0 06             	and    $0x6,%eax
c010164e:	85 c0                	test   %eax,%eax
c0101650:	75 28                	jne    c010167a <kbd_proc_data+0x184>
c0101652:	81 7d f4 e9 00 00 00 	cmpl   $0xe9,-0xc(%ebp)
c0101659:	75 1f                	jne    c010167a <kbd_proc_data+0x184>
        cprintf("Rebooting!\n");
c010165b:	c7 04 24 8d 68 10 c0 	movl   $0xc010688d,(%esp)
c0101662:	e8 5e ec ff ff       	call   c01002c5 <cprintf>
c0101667:	66 c7 45 e8 92 00    	movw   $0x92,-0x18(%ebp)
c010166d:	c6 45 e7 03          	movb   $0x3,-0x19(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101671:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
c0101675:	8b 55 e8             	mov    -0x18(%ebp),%edx
c0101678:	ee                   	out    %al,(%dx)
}
c0101679:	90                   	nop
        outb(0x92, 0x3); // courtesy of Chris Frost
    }
    return c;
c010167a:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c010167d:	c9                   	leave  
c010167e:	c3                   	ret    

c010167f <kbd_intr>:

/* kbd_intr - try to feed input characters from keyboard */
static void
kbd_intr(void) {
c010167f:	f3 0f 1e fb          	endbr32 
c0101683:	55                   	push   %ebp
c0101684:	89 e5                	mov    %esp,%ebp
c0101686:	83 ec 18             	sub    $0x18,%esp
    cons_intr(kbd_proc_data);
c0101689:	c7 04 24 f6 14 10 c0 	movl   $0xc01014f6,(%esp)
c0101690:	e8 93 fd ff ff       	call   c0101428 <cons_intr>
}
c0101695:	90                   	nop
c0101696:	c9                   	leave  
c0101697:	c3                   	ret    

c0101698 <kbd_init>:

static void
kbd_init(void) {
c0101698:	f3 0f 1e fb          	endbr32 
c010169c:	55                   	push   %ebp
c010169d:	89 e5                	mov    %esp,%ebp
c010169f:	83 ec 18             	sub    $0x18,%esp
    // drain the kbd buffer
    kbd_intr();
c01016a2:	e8 d8 ff ff ff       	call   c010167f <kbd_intr>
    pic_enable(IRQ_KBD);
c01016a7:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01016ae:	e8 47 01 00 00       	call   c01017fa <pic_enable>
}
c01016b3:	90                   	nop
c01016b4:	c9                   	leave  
c01016b5:	c3                   	ret    

c01016b6 <cons_init>:

/* cons_init - initializes the console devices */
void
cons_init(void) {
c01016b6:	f3 0f 1e fb          	endbr32 
c01016ba:	55                   	push   %ebp
c01016bb:	89 e5                	mov    %esp,%ebp
c01016bd:	83 ec 18             	sub    $0x18,%esp
    cga_init();
c01016c0:	e8 2e f8 ff ff       	call   c0100ef3 <cga_init>
    serial_init();
c01016c5:	e8 13 f9 ff ff       	call   c0100fdd <serial_init>
    kbd_init();
c01016ca:	e8 c9 ff ff ff       	call   c0101698 <kbd_init>
    if (!serial_exists) {
c01016cf:	a1 48 d4 11 c0       	mov    0xc011d448,%eax
c01016d4:	85 c0                	test   %eax,%eax
c01016d6:	75 0c                	jne    c01016e4 <cons_init+0x2e>
        cprintf("serial port does not exist!!\n");
c01016d8:	c7 04 24 99 68 10 c0 	movl   $0xc0106899,(%esp)
c01016df:	e8 e1 eb ff ff       	call   c01002c5 <cprintf>
    }
}
c01016e4:	90                   	nop
c01016e5:	c9                   	leave  
c01016e6:	c3                   	ret    

c01016e7 <cons_putc>:

/* cons_putc - print a single character @c to console devices */
void
cons_putc(int c) {
c01016e7:	f3 0f 1e fb          	endbr32 
c01016eb:	55                   	push   %ebp
c01016ec:	89 e5                	mov    %esp,%ebp
c01016ee:	83 ec 28             	sub    $0x28,%esp
    bool intr_flag;
    local_intr_save(intr_flag);
c01016f1:	e8 72 f7 ff ff       	call   c0100e68 <__intr_save>
c01016f6:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        lpt_putc(c);
c01016f9:	8b 45 08             	mov    0x8(%ebp),%eax
c01016fc:	89 04 24             	mov    %eax,(%esp)
c01016ff:	e8 48 fa ff ff       	call   c010114c <lpt_putc>
        cga_putc(c);
c0101704:	8b 45 08             	mov    0x8(%ebp),%eax
c0101707:	89 04 24             	mov    %eax,(%esp)
c010170a:	e8 81 fa ff ff       	call   c0101190 <cga_putc>
        serial_putc(c);
c010170f:	8b 45 08             	mov    0x8(%ebp),%eax
c0101712:	89 04 24             	mov    %eax,(%esp)
c0101715:	e8 ca fc ff ff       	call   c01013e4 <serial_putc>
    }
    local_intr_restore(intr_flag);
c010171a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010171d:	89 04 24             	mov    %eax,(%esp)
c0101720:	e8 6d f7 ff ff       	call   c0100e92 <__intr_restore>
}
c0101725:	90                   	nop
c0101726:	c9                   	leave  
c0101727:	c3                   	ret    

c0101728 <cons_getc>:
/* *
 * cons_getc - return the next input character from console,
 * or 0 if none waiting.
 * */
int
cons_getc(void) {
c0101728:	f3 0f 1e fb          	endbr32 
c010172c:	55                   	push   %ebp
c010172d:	89 e5                	mov    %esp,%ebp
c010172f:	83 ec 28             	sub    $0x28,%esp
    int c = 0;
c0101732:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    bool intr_flag;
    local_intr_save(intr_flag);
c0101739:	e8 2a f7 ff ff       	call   c0100e68 <__intr_save>
c010173e:	89 45 f0             	mov    %eax,-0x10(%ebp)
    {
        // poll for any pending input characters,
        // so that this function works even when interrupts are disabled
        // (e.g., when called from the kernel monitor).
        serial_intr();
c0101741:	e8 8e fd ff ff       	call   c01014d4 <serial_intr>
        kbd_intr();
c0101746:	e8 34 ff ff ff       	call   c010167f <kbd_intr>

        // grab the next character from the input buffer.
        if (cons.rpos != cons.wpos) {
c010174b:	8b 15 60 d6 11 c0    	mov    0xc011d660,%edx
c0101751:	a1 64 d6 11 c0       	mov    0xc011d664,%eax
c0101756:	39 c2                	cmp    %eax,%edx
c0101758:	74 31                	je     c010178b <cons_getc+0x63>
            c = cons.buf[cons.rpos ++];
c010175a:	a1 60 d6 11 c0       	mov    0xc011d660,%eax
c010175f:	8d 50 01             	lea    0x1(%eax),%edx
c0101762:	89 15 60 d6 11 c0    	mov    %edx,0xc011d660
c0101768:	0f b6 80 60 d4 11 c0 	movzbl -0x3fee2ba0(%eax),%eax
c010176f:	0f b6 c0             	movzbl %al,%eax
c0101772:	89 45 f4             	mov    %eax,-0xc(%ebp)
            if (cons.rpos == CONSBUFSIZE) {
c0101775:	a1 60 d6 11 c0       	mov    0xc011d660,%eax
c010177a:	3d 00 02 00 00       	cmp    $0x200,%eax
c010177f:	75 0a                	jne    c010178b <cons_getc+0x63>
                cons.rpos = 0;
c0101781:	c7 05 60 d6 11 c0 00 	movl   $0x0,0xc011d660
c0101788:	00 00 00 
            }
        }
    }
    local_intr_restore(intr_flag);
c010178b:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010178e:	89 04 24             	mov    %eax,(%esp)
c0101791:	e8 fc f6 ff ff       	call   c0100e92 <__intr_restore>
    return c;
c0101796:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0101799:	c9                   	leave  
c010179a:	c3                   	ret    

c010179b <pic_setmask>:
// Initial IRQ mask has interrupt 2 enabled (for slave 8259A).
static uint16_t irq_mask = 0xFFFF & ~(1 << IRQ_SLAVE);
static bool did_init = 0;

static void
pic_setmask(uint16_t mask) {
c010179b:	f3 0f 1e fb          	endbr32 
c010179f:	55                   	push   %ebp
c01017a0:	89 e5                	mov    %esp,%ebp
c01017a2:	83 ec 14             	sub    $0x14,%esp
c01017a5:	8b 45 08             	mov    0x8(%ebp),%eax
c01017a8:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
    irq_mask = mask;
c01017ac:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01017af:	66 a3 50 a5 11 c0    	mov    %ax,0xc011a550
    if (did_init) {
c01017b5:	a1 6c d6 11 c0       	mov    0xc011d66c,%eax
c01017ba:	85 c0                	test   %eax,%eax
c01017bc:	74 39                	je     c01017f7 <pic_setmask+0x5c>
        outb(IO_PIC1 + 1, mask);
c01017be:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01017c1:	0f b6 c0             	movzbl %al,%eax
c01017c4:	66 c7 45 fa 21 00    	movw   $0x21,-0x6(%ebp)
c01017ca:	88 45 f9             	mov    %al,-0x7(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c01017cd:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
c01017d1:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
c01017d5:	ee                   	out    %al,(%dx)
}
c01017d6:	90                   	nop
        outb(IO_PIC2 + 1, mask >> 8);
c01017d7:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
c01017db:	c1 e8 08             	shr    $0x8,%eax
c01017de:	0f b7 c0             	movzwl %ax,%eax
c01017e1:	0f b6 c0             	movzbl %al,%eax
c01017e4:	66 c7 45 fe a1 00    	movw   $0xa1,-0x2(%ebp)
c01017ea:	88 45 fd             	mov    %al,-0x3(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c01017ed:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
c01017f1:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
c01017f5:	ee                   	out    %al,(%dx)
}
c01017f6:	90                   	nop
    }
}
c01017f7:	90                   	nop
c01017f8:	c9                   	leave  
c01017f9:	c3                   	ret    

c01017fa <pic_enable>:

void
pic_enable(unsigned int irq) {
c01017fa:	f3 0f 1e fb          	endbr32 
c01017fe:	55                   	push   %ebp
c01017ff:	89 e5                	mov    %esp,%ebp
c0101801:	83 ec 04             	sub    $0x4,%esp
    pic_setmask(irq_mask & ~(1 << irq));
c0101804:	8b 45 08             	mov    0x8(%ebp),%eax
c0101807:	ba 01 00 00 00       	mov    $0x1,%edx
c010180c:	88 c1                	mov    %al,%cl
c010180e:	d3 e2                	shl    %cl,%edx
c0101810:	89 d0                	mov    %edx,%eax
c0101812:	98                   	cwtl   
c0101813:	f7 d0                	not    %eax
c0101815:	0f bf d0             	movswl %ax,%edx
c0101818:	0f b7 05 50 a5 11 c0 	movzwl 0xc011a550,%eax
c010181f:	98                   	cwtl   
c0101820:	21 d0                	and    %edx,%eax
c0101822:	98                   	cwtl   
c0101823:	0f b7 c0             	movzwl %ax,%eax
c0101826:	89 04 24             	mov    %eax,(%esp)
c0101829:	e8 6d ff ff ff       	call   c010179b <pic_setmask>
}
c010182e:	90                   	nop
c010182f:	c9                   	leave  
c0101830:	c3                   	ret    

c0101831 <pic_init>:

/* pic_init - initialize the 8259A interrupt controllers */
void
pic_init(void) {
c0101831:	f3 0f 1e fb          	endbr32 
c0101835:	55                   	push   %ebp
c0101836:	89 e5                	mov    %esp,%ebp
c0101838:	83 ec 44             	sub    $0x44,%esp
    did_init = 1;
c010183b:	c7 05 6c d6 11 c0 01 	movl   $0x1,0xc011d66c
c0101842:	00 00 00 
c0101845:	66 c7 45 ca 21 00    	movw   $0x21,-0x36(%ebp)
c010184b:	c6 45 c9 ff          	movb   $0xff,-0x37(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c010184f:	0f b6 45 c9          	movzbl -0x37(%ebp),%eax
c0101853:	0f b7 55 ca          	movzwl -0x36(%ebp),%edx
c0101857:	ee                   	out    %al,(%dx)
}
c0101858:	90                   	nop
c0101859:	66 c7 45 ce a1 00    	movw   $0xa1,-0x32(%ebp)
c010185f:	c6 45 cd ff          	movb   $0xff,-0x33(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101863:	0f b6 45 cd          	movzbl -0x33(%ebp),%eax
c0101867:	0f b7 55 ce          	movzwl -0x32(%ebp),%edx
c010186b:	ee                   	out    %al,(%dx)
}
c010186c:	90                   	nop
c010186d:	66 c7 45 d2 20 00    	movw   $0x20,-0x2e(%ebp)
c0101873:	c6 45 d1 11          	movb   $0x11,-0x2f(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101877:	0f b6 45 d1          	movzbl -0x2f(%ebp),%eax
c010187b:	0f b7 55 d2          	movzwl -0x2e(%ebp),%edx
c010187f:	ee                   	out    %al,(%dx)
}
c0101880:	90                   	nop
c0101881:	66 c7 45 d6 21 00    	movw   $0x21,-0x2a(%ebp)
c0101887:	c6 45 d5 20          	movb   $0x20,-0x2b(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c010188b:	0f b6 45 d5          	movzbl -0x2b(%ebp),%eax
c010188f:	0f b7 55 d6          	movzwl -0x2a(%ebp),%edx
c0101893:	ee                   	out    %al,(%dx)
}
c0101894:	90                   	nop
c0101895:	66 c7 45 da 21 00    	movw   $0x21,-0x26(%ebp)
c010189b:	c6 45 d9 04          	movb   $0x4,-0x27(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c010189f:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
c01018a3:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
c01018a7:	ee                   	out    %al,(%dx)
}
c01018a8:	90                   	nop
c01018a9:	66 c7 45 de 21 00    	movw   $0x21,-0x22(%ebp)
c01018af:	c6 45 dd 03          	movb   $0x3,-0x23(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c01018b3:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
c01018b7:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
c01018bb:	ee                   	out    %al,(%dx)
}
c01018bc:	90                   	nop
c01018bd:	66 c7 45 e2 a0 00    	movw   $0xa0,-0x1e(%ebp)
c01018c3:	c6 45 e1 11          	movb   $0x11,-0x1f(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c01018c7:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
c01018cb:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
c01018cf:	ee                   	out    %al,(%dx)
}
c01018d0:	90                   	nop
c01018d1:	66 c7 45 e6 a1 00    	movw   $0xa1,-0x1a(%ebp)
c01018d7:	c6 45 e5 28          	movb   $0x28,-0x1b(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c01018db:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c01018df:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
c01018e3:	ee                   	out    %al,(%dx)
}
c01018e4:	90                   	nop
c01018e5:	66 c7 45 ea a1 00    	movw   $0xa1,-0x16(%ebp)
c01018eb:	c6 45 e9 02          	movb   $0x2,-0x17(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c01018ef:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c01018f3:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c01018f7:	ee                   	out    %al,(%dx)
}
c01018f8:	90                   	nop
c01018f9:	66 c7 45 ee a1 00    	movw   $0xa1,-0x12(%ebp)
c01018ff:	c6 45 ed 03          	movb   $0x3,-0x13(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101903:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0101907:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c010190b:	ee                   	out    %al,(%dx)
}
c010190c:	90                   	nop
c010190d:	66 c7 45 f2 20 00    	movw   $0x20,-0xe(%ebp)
c0101913:	c6 45 f1 68          	movb   $0x68,-0xf(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101917:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c010191b:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c010191f:	ee                   	out    %al,(%dx)
}
c0101920:	90                   	nop
c0101921:	66 c7 45 f6 20 00    	movw   $0x20,-0xa(%ebp)
c0101927:	c6 45 f5 0a          	movb   $0xa,-0xb(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c010192b:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c010192f:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c0101933:	ee                   	out    %al,(%dx)
}
c0101934:	90                   	nop
c0101935:	66 c7 45 fa a0 00    	movw   $0xa0,-0x6(%ebp)
c010193b:	c6 45 f9 68          	movb   $0x68,-0x7(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c010193f:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
c0101943:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
c0101947:	ee                   	out    %al,(%dx)
}
c0101948:	90                   	nop
c0101949:	66 c7 45 fe a0 00    	movw   $0xa0,-0x2(%ebp)
c010194f:	c6 45 fd 0a          	movb   $0xa,-0x3(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101953:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
c0101957:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
c010195b:	ee                   	out    %al,(%dx)
}
c010195c:	90                   	nop
    outb(IO_PIC1, 0x0a);    // read IRR by default

    outb(IO_PIC2, 0x68);    // OCW3
    outb(IO_PIC2, 0x0a);    // OCW3

    if (irq_mask != 0xFFFF) {
c010195d:	0f b7 05 50 a5 11 c0 	movzwl 0xc011a550,%eax
c0101964:	3d ff ff 00 00       	cmp    $0xffff,%eax
c0101969:	74 0f                	je     c010197a <pic_init+0x149>
        pic_setmask(irq_mask);
c010196b:	0f b7 05 50 a5 11 c0 	movzwl 0xc011a550,%eax
c0101972:	89 04 24             	mov    %eax,(%esp)
c0101975:	e8 21 fe ff ff       	call   c010179b <pic_setmask>
    }
}
c010197a:	90                   	nop
c010197b:	c9                   	leave  
c010197c:	c3                   	ret    

c010197d <intr_enable>:
#include <x86.h>
#include <intr.h>

/* intr_enable - enable irq interrupt */
void
intr_enable(void) {
c010197d:	f3 0f 1e fb          	endbr32 
c0101981:	55                   	push   %ebp
c0101982:	89 e5                	mov    %esp,%ebp
    asm volatile ("sti");
c0101984:	fb                   	sti    
}
c0101985:	90                   	nop
    sti();
}
c0101986:	90                   	nop
c0101987:	5d                   	pop    %ebp
c0101988:	c3                   	ret    

c0101989 <intr_disable>:

/* intr_disable - disable irq interrupt */
void
intr_disable(void) {
c0101989:	f3 0f 1e fb          	endbr32 
c010198d:	55                   	push   %ebp
c010198e:	89 e5                	mov    %esp,%ebp
    asm volatile ("cli" ::: "memory");
c0101990:	fa                   	cli    
}
c0101991:	90                   	nop
    cli();
}
c0101992:	90                   	nop
c0101993:	5d                   	pop    %ebp
c0101994:	c3                   	ret    

c0101995 <print_ticks>:
#include <console.h>
#include <kdebug.h>

#define TICK_NUM 100

static void print_ticks() {
c0101995:	f3 0f 1e fb          	endbr32 
c0101999:	55                   	push   %ebp
c010199a:	89 e5                	mov    %esp,%ebp
c010199c:	83 ec 18             	sub    $0x18,%esp
    cprintf("%d ticks\n",TICK_NUM);
c010199f:	c7 44 24 04 64 00 00 	movl   $0x64,0x4(%esp)
c01019a6:	00 
c01019a7:	c7 04 24 c0 68 10 c0 	movl   $0xc01068c0,(%esp)
c01019ae:	e8 12 e9 ff ff       	call   c01002c5 <cprintf>
#ifdef DEBUG_GRADE
    cprintf("End of Test.\n");
c01019b3:	c7 04 24 ca 68 10 c0 	movl   $0xc01068ca,(%esp)
c01019ba:	e8 06 e9 ff ff       	call   c01002c5 <cprintf>
    panic("EOT: kernel seems ok.");
c01019bf:	c7 44 24 08 d8 68 10 	movl   $0xc01068d8,0x8(%esp)
c01019c6:	c0 
c01019c7:	c7 44 24 04 12 00 00 	movl   $0x12,0x4(%esp)
c01019ce:	00 
c01019cf:	c7 04 24 ee 68 10 c0 	movl   $0xc01068ee,(%esp)
c01019d6:	e8 56 ea ff ff       	call   c0100431 <__panic>

c01019db <idt_init>:
    sizeof(idt) - 1, (uintptr_t)idt
};

/* idt_init - initialize IDT to each of the entry points in kern/trap/vectors.S */
void
idt_init(void) {
c01019db:	f3 0f 1e fb          	endbr32 
c01019df:	55                   	push   %ebp
c01019e0:	89 e5                	mov    %esp,%ebp
c01019e2:	83 ec 10             	sub    $0x10,%esp
      */
    
    // 定义中断向量表
    extern uintptr_t __vectors[];
    // 向量表的长度为sizeof(idt) / sizeof(struct gatedesc)
    for (int i = 0; i < sizeof(idt) / sizeof(struct gatedesc); i ++) {
c01019e5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c01019ec:	e9 c4 00 00 00       	jmp    c0101ab5 <idt_init+0xda>
    // idt描述表项，0表示是interupt而不是trap，GD_KTEXT为段选择子，__vectors[i]为偏移量，DPL_KERNEL为特权级
        SETGATE(idt[i], 0, GD_KTEXT, __vectors[i], DPL_KERNEL);
c01019f1:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01019f4:	8b 04 85 e0 a5 11 c0 	mov    -0x3fee5a20(,%eax,4),%eax
c01019fb:	0f b7 d0             	movzwl %ax,%edx
c01019fe:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101a01:	66 89 14 c5 80 d6 11 	mov    %dx,-0x3fee2980(,%eax,8)
c0101a08:	c0 
c0101a09:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101a0c:	66 c7 04 c5 82 d6 11 	movw   $0x8,-0x3fee297e(,%eax,8)
c0101a13:	c0 08 00 
c0101a16:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101a19:	0f b6 14 c5 84 d6 11 	movzbl -0x3fee297c(,%eax,8),%edx
c0101a20:	c0 
c0101a21:	80 e2 e0             	and    $0xe0,%dl
c0101a24:	88 14 c5 84 d6 11 c0 	mov    %dl,-0x3fee297c(,%eax,8)
c0101a2b:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101a2e:	0f b6 14 c5 84 d6 11 	movzbl -0x3fee297c(,%eax,8),%edx
c0101a35:	c0 
c0101a36:	80 e2 1f             	and    $0x1f,%dl
c0101a39:	88 14 c5 84 d6 11 c0 	mov    %dl,-0x3fee297c(,%eax,8)
c0101a40:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101a43:	0f b6 14 c5 85 d6 11 	movzbl -0x3fee297b(,%eax,8),%edx
c0101a4a:	c0 
c0101a4b:	80 e2 f0             	and    $0xf0,%dl
c0101a4e:	80 ca 0e             	or     $0xe,%dl
c0101a51:	88 14 c5 85 d6 11 c0 	mov    %dl,-0x3fee297b(,%eax,8)
c0101a58:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101a5b:	0f b6 14 c5 85 d6 11 	movzbl -0x3fee297b(,%eax,8),%edx
c0101a62:	c0 
c0101a63:	80 e2 ef             	and    $0xef,%dl
c0101a66:	88 14 c5 85 d6 11 c0 	mov    %dl,-0x3fee297b(,%eax,8)
c0101a6d:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101a70:	0f b6 14 c5 85 d6 11 	movzbl -0x3fee297b(,%eax,8),%edx
c0101a77:	c0 
c0101a78:	80 e2 9f             	and    $0x9f,%dl
c0101a7b:	88 14 c5 85 d6 11 c0 	mov    %dl,-0x3fee297b(,%eax,8)
c0101a82:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101a85:	0f b6 14 c5 85 d6 11 	movzbl -0x3fee297b(,%eax,8),%edx
c0101a8c:	c0 
c0101a8d:	80 ca 80             	or     $0x80,%dl
c0101a90:	88 14 c5 85 d6 11 c0 	mov    %dl,-0x3fee297b(,%eax,8)
c0101a97:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101a9a:	8b 04 85 e0 a5 11 c0 	mov    -0x3fee5a20(,%eax,4),%eax
c0101aa1:	c1 e8 10             	shr    $0x10,%eax
c0101aa4:	0f b7 d0             	movzwl %ax,%edx
c0101aa7:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101aaa:	66 89 14 c5 86 d6 11 	mov    %dx,-0x3fee297a(,%eax,8)
c0101ab1:	c0 
    for (int i = 0; i < sizeof(idt) / sizeof(struct gatedesc); i ++) {
c0101ab2:	ff 45 fc             	incl   -0x4(%ebp)
c0101ab5:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101ab8:	3d ff 00 00 00       	cmp    $0xff,%eax
c0101abd:	0f 86 2e ff ff ff    	jbe    c01019f1 <idt_init+0x16>
    }
	// set for switch from user to kernel
    // 选择需要从user特权级转化为kernel特权级的项(系统调用中断)
    SETGATE(idt[T_SWITCH_TOK], 1, KERNEL_CS, __vectors[T_SWITCH_TOK], DPL_USER);
c0101ac3:	a1 c4 a7 11 c0       	mov    0xc011a7c4,%eax
c0101ac8:	0f b7 c0             	movzwl %ax,%eax
c0101acb:	66 a3 48 da 11 c0    	mov    %ax,0xc011da48
c0101ad1:	66 c7 05 4a da 11 c0 	movw   $0x8,0xc011da4a
c0101ad8:	08 00 
c0101ada:	0f b6 05 4c da 11 c0 	movzbl 0xc011da4c,%eax
c0101ae1:	24 e0                	and    $0xe0,%al
c0101ae3:	a2 4c da 11 c0       	mov    %al,0xc011da4c
c0101ae8:	0f b6 05 4c da 11 c0 	movzbl 0xc011da4c,%eax
c0101aef:	24 1f                	and    $0x1f,%al
c0101af1:	a2 4c da 11 c0       	mov    %al,0xc011da4c
c0101af6:	0f b6 05 4d da 11 c0 	movzbl 0xc011da4d,%eax
c0101afd:	0c 0f                	or     $0xf,%al
c0101aff:	a2 4d da 11 c0       	mov    %al,0xc011da4d
c0101b04:	0f b6 05 4d da 11 c0 	movzbl 0xc011da4d,%eax
c0101b0b:	24 ef                	and    $0xef,%al
c0101b0d:	a2 4d da 11 c0       	mov    %al,0xc011da4d
c0101b12:	0f b6 05 4d da 11 c0 	movzbl 0xc011da4d,%eax
c0101b19:	0c 60                	or     $0x60,%al
c0101b1b:	a2 4d da 11 c0       	mov    %al,0xc011da4d
c0101b20:	0f b6 05 4d da 11 c0 	movzbl 0xc011da4d,%eax
c0101b27:	0c 80                	or     $0x80,%al
c0101b29:	a2 4d da 11 c0       	mov    %al,0xc011da4d
c0101b2e:	a1 c4 a7 11 c0       	mov    0xc011a7c4,%eax
c0101b33:	c1 e8 10             	shr    $0x10,%eax
c0101b36:	0f b7 c0             	movzwl %ax,%eax
c0101b39:	66 a3 4e da 11 c0    	mov    %ax,0xc011da4e
c0101b3f:	c7 45 f8 60 a5 11 c0 	movl   $0xc011a560,-0x8(%ebp)
    asm volatile ("lidt (%0)" :: "r" (pd) : "memory");
c0101b46:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0101b49:	0f 01 18             	lidtl  (%eax)
}
c0101b4c:	90                   	nop
	// load the IDT
    // 加载IDT
    lidt(&idt_pd);
}
c0101b4d:	90                   	nop
c0101b4e:	c9                   	leave  
c0101b4f:	c3                   	ret    

c0101b50 <trapname>:

static const char *
trapname(int trapno) {
c0101b50:	f3 0f 1e fb          	endbr32 
c0101b54:	55                   	push   %ebp
c0101b55:	89 e5                	mov    %esp,%ebp
        "Alignment Check",
        "Machine-Check",
        "SIMD Floating-Point Exception"
    };

    if (trapno < sizeof(excnames)/sizeof(const char * const)) {
c0101b57:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b5a:	83 f8 13             	cmp    $0x13,%eax
c0101b5d:	77 0c                	ja     c0101b6b <trapname+0x1b>
        return excnames[trapno];
c0101b5f:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b62:	8b 04 85 80 6c 10 c0 	mov    -0x3fef9380(,%eax,4),%eax
c0101b69:	eb 18                	jmp    c0101b83 <trapname+0x33>
    }
    if (trapno >= IRQ_OFFSET && trapno < IRQ_OFFSET + 16) {
c0101b6b:	83 7d 08 1f          	cmpl   $0x1f,0x8(%ebp)
c0101b6f:	7e 0d                	jle    c0101b7e <trapname+0x2e>
c0101b71:	83 7d 08 2f          	cmpl   $0x2f,0x8(%ebp)
c0101b75:	7f 07                	jg     c0101b7e <trapname+0x2e>
        return "Hardware Interrupt";
c0101b77:	b8 ff 68 10 c0       	mov    $0xc01068ff,%eax
c0101b7c:	eb 05                	jmp    c0101b83 <trapname+0x33>
    }
    return "(unknown trap)";
c0101b7e:	b8 12 69 10 c0       	mov    $0xc0106912,%eax
}
c0101b83:	5d                   	pop    %ebp
c0101b84:	c3                   	ret    

c0101b85 <trap_in_kernel>:

/* trap_in_kernel - test if trap happened in kernel */
bool
trap_in_kernel(struct trapframe *tf) {
c0101b85:	f3 0f 1e fb          	endbr32 
c0101b89:	55                   	push   %ebp
c0101b8a:	89 e5                	mov    %esp,%ebp
    return (tf->tf_cs == (uint16_t)KERNEL_CS);
c0101b8c:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b8f:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
c0101b93:	83 f8 08             	cmp    $0x8,%eax
c0101b96:	0f 94 c0             	sete   %al
c0101b99:	0f b6 c0             	movzbl %al,%eax
}
c0101b9c:	5d                   	pop    %ebp
c0101b9d:	c3                   	ret    

c0101b9e <print_trapframe>:
    "TF", "IF", "DF", "OF", NULL, NULL, "NT", NULL,
    "RF", "VM", "AC", "VIF", "VIP", "ID", NULL, NULL,
};

void
print_trapframe(struct trapframe *tf) {
c0101b9e:	f3 0f 1e fb          	endbr32 
c0101ba2:	55                   	push   %ebp
c0101ba3:	89 e5                	mov    %esp,%ebp
c0101ba5:	83 ec 28             	sub    $0x28,%esp
    cprintf("trapframe at %p\n", tf);
c0101ba8:	8b 45 08             	mov    0x8(%ebp),%eax
c0101bab:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101baf:	c7 04 24 53 69 10 c0 	movl   $0xc0106953,(%esp)
c0101bb6:	e8 0a e7 ff ff       	call   c01002c5 <cprintf>
    print_regs(&tf->tf_regs);
c0101bbb:	8b 45 08             	mov    0x8(%ebp),%eax
c0101bbe:	89 04 24             	mov    %eax,(%esp)
c0101bc1:	e8 8d 01 00 00       	call   c0101d53 <print_regs>
    cprintf("  ds   0x----%04x\n", tf->tf_ds);
c0101bc6:	8b 45 08             	mov    0x8(%ebp),%eax
c0101bc9:	0f b7 40 2c          	movzwl 0x2c(%eax),%eax
c0101bcd:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101bd1:	c7 04 24 64 69 10 c0 	movl   $0xc0106964,(%esp)
c0101bd8:	e8 e8 e6 ff ff       	call   c01002c5 <cprintf>
    cprintf("  es   0x----%04x\n", tf->tf_es);
c0101bdd:	8b 45 08             	mov    0x8(%ebp),%eax
c0101be0:	0f b7 40 28          	movzwl 0x28(%eax),%eax
c0101be4:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101be8:	c7 04 24 77 69 10 c0 	movl   $0xc0106977,(%esp)
c0101bef:	e8 d1 e6 ff ff       	call   c01002c5 <cprintf>
    cprintf("  fs   0x----%04x\n", tf->tf_fs);
c0101bf4:	8b 45 08             	mov    0x8(%ebp),%eax
c0101bf7:	0f b7 40 24          	movzwl 0x24(%eax),%eax
c0101bfb:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101bff:	c7 04 24 8a 69 10 c0 	movl   $0xc010698a,(%esp)
c0101c06:	e8 ba e6 ff ff       	call   c01002c5 <cprintf>
    cprintf("  gs   0x----%04x\n", tf->tf_gs);
c0101c0b:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c0e:	0f b7 40 20          	movzwl 0x20(%eax),%eax
c0101c12:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101c16:	c7 04 24 9d 69 10 c0 	movl   $0xc010699d,(%esp)
c0101c1d:	e8 a3 e6 ff ff       	call   c01002c5 <cprintf>
    cprintf("  trap 0x%08x %s\n", tf->tf_trapno, trapname(tf->tf_trapno));
c0101c22:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c25:	8b 40 30             	mov    0x30(%eax),%eax
c0101c28:	89 04 24             	mov    %eax,(%esp)
c0101c2b:	e8 20 ff ff ff       	call   c0101b50 <trapname>
c0101c30:	8b 55 08             	mov    0x8(%ebp),%edx
c0101c33:	8b 52 30             	mov    0x30(%edx),%edx
c0101c36:	89 44 24 08          	mov    %eax,0x8(%esp)
c0101c3a:	89 54 24 04          	mov    %edx,0x4(%esp)
c0101c3e:	c7 04 24 b0 69 10 c0 	movl   $0xc01069b0,(%esp)
c0101c45:	e8 7b e6 ff ff       	call   c01002c5 <cprintf>
    cprintf("  err  0x%08x\n", tf->tf_err);
c0101c4a:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c4d:	8b 40 34             	mov    0x34(%eax),%eax
c0101c50:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101c54:	c7 04 24 c2 69 10 c0 	movl   $0xc01069c2,(%esp)
c0101c5b:	e8 65 e6 ff ff       	call   c01002c5 <cprintf>
    cprintf("  eip  0x%08x\n", tf->tf_eip);
c0101c60:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c63:	8b 40 38             	mov    0x38(%eax),%eax
c0101c66:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101c6a:	c7 04 24 d1 69 10 c0 	movl   $0xc01069d1,(%esp)
c0101c71:	e8 4f e6 ff ff       	call   c01002c5 <cprintf>
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
c0101c76:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c79:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
c0101c7d:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101c81:	c7 04 24 e0 69 10 c0 	movl   $0xc01069e0,(%esp)
c0101c88:	e8 38 e6 ff ff       	call   c01002c5 <cprintf>
    cprintf("  flag 0x%08x ", tf->tf_eflags);
c0101c8d:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c90:	8b 40 40             	mov    0x40(%eax),%eax
c0101c93:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101c97:	c7 04 24 f3 69 10 c0 	movl   $0xc01069f3,(%esp)
c0101c9e:	e8 22 e6 ff ff       	call   c01002c5 <cprintf>

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
c0101ca3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0101caa:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
c0101cb1:	eb 3d                	jmp    c0101cf0 <print_trapframe+0x152>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
c0101cb3:	8b 45 08             	mov    0x8(%ebp),%eax
c0101cb6:	8b 50 40             	mov    0x40(%eax),%edx
c0101cb9:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0101cbc:	21 d0                	and    %edx,%eax
c0101cbe:	85 c0                	test   %eax,%eax
c0101cc0:	74 28                	je     c0101cea <print_trapframe+0x14c>
c0101cc2:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101cc5:	8b 04 85 80 a5 11 c0 	mov    -0x3fee5a80(,%eax,4),%eax
c0101ccc:	85 c0                	test   %eax,%eax
c0101cce:	74 1a                	je     c0101cea <print_trapframe+0x14c>
            cprintf("%s,", IA32flags[i]);
c0101cd0:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101cd3:	8b 04 85 80 a5 11 c0 	mov    -0x3fee5a80(,%eax,4),%eax
c0101cda:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101cde:	c7 04 24 02 6a 10 c0 	movl   $0xc0106a02,(%esp)
c0101ce5:	e8 db e5 ff ff       	call   c01002c5 <cprintf>
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
c0101cea:	ff 45 f4             	incl   -0xc(%ebp)
c0101ced:	d1 65 f0             	shll   -0x10(%ebp)
c0101cf0:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101cf3:	83 f8 17             	cmp    $0x17,%eax
c0101cf6:	76 bb                	jbe    c0101cb3 <print_trapframe+0x115>
        }
    }
    cprintf("IOPL=%d\n", (tf->tf_eflags & FL_IOPL_MASK) >> 12);
c0101cf8:	8b 45 08             	mov    0x8(%ebp),%eax
c0101cfb:	8b 40 40             	mov    0x40(%eax),%eax
c0101cfe:	c1 e8 0c             	shr    $0xc,%eax
c0101d01:	83 e0 03             	and    $0x3,%eax
c0101d04:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101d08:	c7 04 24 06 6a 10 c0 	movl   $0xc0106a06,(%esp)
c0101d0f:	e8 b1 e5 ff ff       	call   c01002c5 <cprintf>

    if (!trap_in_kernel(tf)) {
c0101d14:	8b 45 08             	mov    0x8(%ebp),%eax
c0101d17:	89 04 24             	mov    %eax,(%esp)
c0101d1a:	e8 66 fe ff ff       	call   c0101b85 <trap_in_kernel>
c0101d1f:	85 c0                	test   %eax,%eax
c0101d21:	75 2d                	jne    c0101d50 <print_trapframe+0x1b2>
        cprintf("  esp  0x%08x\n", tf->tf_esp);
c0101d23:	8b 45 08             	mov    0x8(%ebp),%eax
c0101d26:	8b 40 44             	mov    0x44(%eax),%eax
c0101d29:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101d2d:	c7 04 24 0f 6a 10 c0 	movl   $0xc0106a0f,(%esp)
c0101d34:	e8 8c e5 ff ff       	call   c01002c5 <cprintf>
        cprintf("  ss   0x----%04x\n", tf->tf_ss);
c0101d39:	8b 45 08             	mov    0x8(%ebp),%eax
c0101d3c:	0f b7 40 48          	movzwl 0x48(%eax),%eax
c0101d40:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101d44:	c7 04 24 1e 6a 10 c0 	movl   $0xc0106a1e,(%esp)
c0101d4b:	e8 75 e5 ff ff       	call   c01002c5 <cprintf>
    }
}
c0101d50:	90                   	nop
c0101d51:	c9                   	leave  
c0101d52:	c3                   	ret    

c0101d53 <print_regs>:

void
print_regs(struct pushregs *regs) {
c0101d53:	f3 0f 1e fb          	endbr32 
c0101d57:	55                   	push   %ebp
c0101d58:	89 e5                	mov    %esp,%ebp
c0101d5a:	83 ec 18             	sub    $0x18,%esp
    cprintf("  edi  0x%08x\n", regs->reg_edi);
c0101d5d:	8b 45 08             	mov    0x8(%ebp),%eax
c0101d60:	8b 00                	mov    (%eax),%eax
c0101d62:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101d66:	c7 04 24 31 6a 10 c0 	movl   $0xc0106a31,(%esp)
c0101d6d:	e8 53 e5 ff ff       	call   c01002c5 <cprintf>
    cprintf("  esi  0x%08x\n", regs->reg_esi);
c0101d72:	8b 45 08             	mov    0x8(%ebp),%eax
c0101d75:	8b 40 04             	mov    0x4(%eax),%eax
c0101d78:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101d7c:	c7 04 24 40 6a 10 c0 	movl   $0xc0106a40,(%esp)
c0101d83:	e8 3d e5 ff ff       	call   c01002c5 <cprintf>
    cprintf("  ebp  0x%08x\n", regs->reg_ebp);
c0101d88:	8b 45 08             	mov    0x8(%ebp),%eax
c0101d8b:	8b 40 08             	mov    0x8(%eax),%eax
c0101d8e:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101d92:	c7 04 24 4f 6a 10 c0 	movl   $0xc0106a4f,(%esp)
c0101d99:	e8 27 e5 ff ff       	call   c01002c5 <cprintf>
    cprintf("  oesp 0x%08x\n", regs->reg_oesp);
c0101d9e:	8b 45 08             	mov    0x8(%ebp),%eax
c0101da1:	8b 40 0c             	mov    0xc(%eax),%eax
c0101da4:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101da8:	c7 04 24 5e 6a 10 c0 	movl   $0xc0106a5e,(%esp)
c0101daf:	e8 11 e5 ff ff       	call   c01002c5 <cprintf>
    cprintf("  ebx  0x%08x\n", regs->reg_ebx);
c0101db4:	8b 45 08             	mov    0x8(%ebp),%eax
c0101db7:	8b 40 10             	mov    0x10(%eax),%eax
c0101dba:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101dbe:	c7 04 24 6d 6a 10 c0 	movl   $0xc0106a6d,(%esp)
c0101dc5:	e8 fb e4 ff ff       	call   c01002c5 <cprintf>
    cprintf("  edx  0x%08x\n", regs->reg_edx);
c0101dca:	8b 45 08             	mov    0x8(%ebp),%eax
c0101dcd:	8b 40 14             	mov    0x14(%eax),%eax
c0101dd0:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101dd4:	c7 04 24 7c 6a 10 c0 	movl   $0xc0106a7c,(%esp)
c0101ddb:	e8 e5 e4 ff ff       	call   c01002c5 <cprintf>
    cprintf("  ecx  0x%08x\n", regs->reg_ecx);
c0101de0:	8b 45 08             	mov    0x8(%ebp),%eax
c0101de3:	8b 40 18             	mov    0x18(%eax),%eax
c0101de6:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101dea:	c7 04 24 8b 6a 10 c0 	movl   $0xc0106a8b,(%esp)
c0101df1:	e8 cf e4 ff ff       	call   c01002c5 <cprintf>
    cprintf("  eax  0x%08x\n", regs->reg_eax);
c0101df6:	8b 45 08             	mov    0x8(%ebp),%eax
c0101df9:	8b 40 1c             	mov    0x1c(%eax),%eax
c0101dfc:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101e00:	c7 04 24 9a 6a 10 c0 	movl   $0xc0106a9a,(%esp)
c0101e07:	e8 b9 e4 ff ff       	call   c01002c5 <cprintf>
}
c0101e0c:	90                   	nop
c0101e0d:	c9                   	leave  
c0101e0e:	c3                   	ret    

c0101e0f <trap_dispatch>:
/* temporary trapframe or pointer to trapframe */
struct trapframe switchk2u, *switchu2k;

/* trap_dispatch - dispatch based on what type of trap occurred */
static void
trap_dispatch(struct trapframe *tf) {
c0101e0f:	f3 0f 1e fb          	endbr32 
c0101e13:	55                   	push   %ebp
c0101e14:	89 e5                	mov    %esp,%ebp
c0101e16:	57                   	push   %edi
c0101e17:	56                   	push   %esi
c0101e18:	53                   	push   %ebx
c0101e19:	83 ec 2c             	sub    $0x2c,%esp
    char c;

    switch (tf->tf_trapno) {
c0101e1c:	8b 45 08             	mov    0x8(%ebp),%eax
c0101e1f:	8b 40 30             	mov    0x30(%eax),%eax
c0101e22:	83 f8 79             	cmp    $0x79,%eax
c0101e25:	0f 84 87 03 00 00    	je     c01021b2 <trap_dispatch+0x3a3>
c0101e2b:	83 f8 79             	cmp    $0x79,%eax
c0101e2e:	0f 87 12 04 00 00    	ja     c0102246 <trap_dispatch+0x437>
c0101e34:	83 f8 78             	cmp    $0x78,%eax
c0101e37:	0f 84 8d 02 00 00    	je     c01020ca <trap_dispatch+0x2bb>
c0101e3d:	83 f8 78             	cmp    $0x78,%eax
c0101e40:	0f 87 00 04 00 00    	ja     c0102246 <trap_dispatch+0x437>
c0101e46:	83 f8 2f             	cmp    $0x2f,%eax
c0101e49:	0f 87 f7 03 00 00    	ja     c0102246 <trap_dispatch+0x437>
c0101e4f:	83 f8 2e             	cmp    $0x2e,%eax
c0101e52:	0f 83 23 04 00 00    	jae    c010227b <trap_dispatch+0x46c>
c0101e58:	83 f8 24             	cmp    $0x24,%eax
c0101e5b:	74 5e                	je     c0101ebb <trap_dispatch+0xac>
c0101e5d:	83 f8 24             	cmp    $0x24,%eax
c0101e60:	0f 87 e0 03 00 00    	ja     c0102246 <trap_dispatch+0x437>
c0101e66:	83 f8 20             	cmp    $0x20,%eax
c0101e69:	74 0a                	je     c0101e75 <trap_dispatch+0x66>
c0101e6b:	83 f8 21             	cmp    $0x21,%eax
c0101e6e:	74 74                	je     c0101ee4 <trap_dispatch+0xd5>
c0101e70:	e9 d1 03 00 00       	jmp    c0102246 <trap_dispatch+0x437>
        /* handle the timer interrupt */
        /* (1) After a timer interrupt, you should record this event using a global variable (increase it), such as ticks in kern/driver/clock.c
         * (2) Every TICK_NUM cycle, you can print some info using a funciton, such as print_ticks().
         * (3) Too Simple? Yes, I think so!
         */
        ticks ++;
c0101e75:	a1 0c df 11 c0       	mov    0xc011df0c,%eax
c0101e7a:	40                   	inc    %eax
c0101e7b:	a3 0c df 11 c0       	mov    %eax,0xc011df0c
        if (ticks % TICK_NUM == 0) {
c0101e80:	8b 0d 0c df 11 c0    	mov    0xc011df0c,%ecx
c0101e86:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
c0101e8b:	89 c8                	mov    %ecx,%eax
c0101e8d:	f7 e2                	mul    %edx
c0101e8f:	c1 ea 05             	shr    $0x5,%edx
c0101e92:	89 d0                	mov    %edx,%eax
c0101e94:	c1 e0 02             	shl    $0x2,%eax
c0101e97:	01 d0                	add    %edx,%eax
c0101e99:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0101ea0:	01 d0                	add    %edx,%eax
c0101ea2:	c1 e0 02             	shl    $0x2,%eax
c0101ea5:	29 c1                	sub    %eax,%ecx
c0101ea7:	89 ca                	mov    %ecx,%edx
c0101ea9:	85 d2                	test   %edx,%edx
c0101eab:	0f 85 cd 03 00 00    	jne    c010227e <trap_dispatch+0x46f>
            print_ticks();
c0101eb1:	e8 df fa ff ff       	call   c0101995 <print_ticks>
        }
        break;
c0101eb6:	e9 c3 03 00 00       	jmp    c010227e <trap_dispatch+0x46f>
    case IRQ_OFFSET + IRQ_COM1:
        c = cons_getc();
c0101ebb:	e8 68 f8 ff ff       	call   c0101728 <cons_getc>
c0101ec0:	88 45 e7             	mov    %al,-0x19(%ebp)
        cprintf("serial [%03d] %c\n", c, c);
c0101ec3:	0f be 55 e7          	movsbl -0x19(%ebp),%edx
c0101ec7:	0f be 45 e7          	movsbl -0x19(%ebp),%eax
c0101ecb:	89 54 24 08          	mov    %edx,0x8(%esp)
c0101ecf:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101ed3:	c7 04 24 a9 6a 10 c0 	movl   $0xc0106aa9,(%esp)
c0101eda:	e8 e6 e3 ff ff       	call   c01002c5 <cprintf>
        break;
c0101edf:	e9 a4 03 00 00       	jmp    c0102288 <trap_dispatch+0x479>
    case IRQ_OFFSET + IRQ_KBD:
        c = cons_getc();
c0101ee4:	e8 3f f8 ff ff       	call   c0101728 <cons_getc>
c0101ee9:	88 45 e7             	mov    %al,-0x19(%ebp)
        if(c == 48){
c0101eec:	80 7d e7 30          	cmpb   $0x30,-0x19(%ebp)
c0101ef0:	0f 85 b3 00 00 00    	jne    c0101fa9 <trap_dispatch+0x19a>
            cprintf("kbd [%03d] %c\n", c, c);
c0101ef6:	0f be 55 e7          	movsbl -0x19(%ebp),%edx
c0101efa:	0f be 45 e7          	movsbl -0x19(%ebp),%eax
c0101efe:	89 54 24 08          	mov    %edx,0x8(%esp)
c0101f02:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101f06:	c7 04 24 bb 6a 10 c0 	movl   $0xc0106abb,(%esp)
c0101f0d:	e8 b3 e3 ff ff       	call   c01002c5 <cprintf>
            if (tf->tf_cs != KERNEL_CS) {
c0101f12:	8b 45 08             	mov    0x8(%ebp),%eax
c0101f15:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
c0101f19:	83 f8 08             	cmp    $0x8,%eax
c0101f1c:	0f 84 66 03 00 00    	je     c0102288 <trap_dispatch+0x479>
            tf->tf_cs = KERNEL_CS;
c0101f22:	8b 45 08             	mov    0x8(%ebp),%eax
c0101f25:	66 c7 40 3c 08 00    	movw   $0x8,0x3c(%eax)
            tf->tf_ds = tf->tf_es = KERNEL_DS;
c0101f2b:	8b 45 08             	mov    0x8(%ebp),%eax
c0101f2e:	66 c7 40 28 10 00    	movw   $0x10,0x28(%eax)
c0101f34:	8b 45 08             	mov    0x8(%ebp),%eax
c0101f37:	0f b7 50 28          	movzwl 0x28(%eax),%edx
c0101f3b:	8b 45 08             	mov    0x8(%ebp),%eax
c0101f3e:	66 89 50 2c          	mov    %dx,0x2c(%eax)
            tf->tf_eflags &= ~FL_IOPL_MASK;
c0101f42:	8b 45 08             	mov    0x8(%ebp),%eax
c0101f45:	8b 40 40             	mov    0x40(%eax),%eax
c0101f48:	25 ff cf ff ff       	and    $0xffffcfff,%eax
c0101f4d:	89 c2                	mov    %eax,%edx
c0101f4f:	8b 45 08             	mov    0x8(%ebp),%eax
c0101f52:	89 50 40             	mov    %edx,0x40(%eax)
            switchu2k = (struct trapframe *)(tf->tf_esp - (sizeof(struct trapframe) - 8));
c0101f55:	8b 45 08             	mov    0x8(%ebp),%eax
c0101f58:	8b 40 44             	mov    0x44(%eax),%eax
c0101f5b:	83 e8 44             	sub    $0x44,%eax
c0101f5e:	a3 6c df 11 c0       	mov    %eax,0xc011df6c
            memmove(switchu2k, tf, sizeof(struct trapframe) - 8);
c0101f63:	a1 6c df 11 c0       	mov    0xc011df6c,%eax
c0101f68:	c7 44 24 08 44 00 00 	movl   $0x44,0x8(%esp)
c0101f6f:	00 
c0101f70:	8b 55 08             	mov    0x8(%ebp),%edx
c0101f73:	89 54 24 04          	mov    %edx,0x4(%esp)
c0101f77:	89 04 24             	mov    %eax,(%esp)
c0101f7a:	e8 e2 3d 00 00       	call   c0105d61 <memmove>
            *((uint32_t *)tf - 1) = (uint32_t)switchu2k;
c0101f7f:	8b 15 6c df 11 c0    	mov    0xc011df6c,%edx
c0101f85:	8b 45 08             	mov    0x8(%ebp),%eax
c0101f88:	83 e8 04             	sub    $0x4,%eax
c0101f8b:	89 10                	mov    %edx,(%eax)
            cprintf("+++ switch to kernel mode +++\n");
c0101f8d:	c7 04 24 cc 6a 10 c0 	movl   $0xc0106acc,(%esp)
c0101f94:	e8 2c e3 ff ff       	call   c01002c5 <cprintf>
            print_trapframe(tf);
c0101f99:	8b 45 08             	mov    0x8(%ebp),%eax
c0101f9c:	89 04 24             	mov    %eax,(%esp)
c0101f9f:	e8 fa fb ff ff       	call   c0101b9e <print_trapframe>
            print_trapframe(tf);
            panic("unexpected trap in kernel.\n");
        }
    }
}
}
c0101fa4:	e9 df 02 00 00       	jmp    c0102288 <trap_dispatch+0x479>
        else if(c == 51){
c0101fa9:	80 7d e7 33          	cmpb   $0x33,-0x19(%ebp)
c0101fad:	0f 85 d5 02 00 00    	jne    c0102288 <trap_dispatch+0x479>
            if (tf->tf_cs != USER_CS) {
c0101fb3:	8b 45 08             	mov    0x8(%ebp),%eax
c0101fb6:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
c0101fba:	83 f8 1b             	cmp    $0x1b,%eax
c0101fbd:	0f 84 be 02 00 00    	je     c0102281 <trap_dispatch+0x472>
            cprintf("kbd [%03d] %c\n", c, c);
c0101fc3:	0f be 55 e7          	movsbl -0x19(%ebp),%edx
c0101fc7:	0f be 45 e7          	movsbl -0x19(%ebp),%eax
c0101fcb:	89 54 24 08          	mov    %edx,0x8(%esp)
c0101fcf:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101fd3:	c7 04 24 bb 6a 10 c0 	movl   $0xc0106abb,(%esp)
c0101fda:	e8 e6 e2 ff ff       	call   c01002c5 <cprintf>
            switchk2u = *tf;
c0101fdf:	8b 55 08             	mov    0x8(%ebp),%edx
c0101fe2:	b8 20 df 11 c0       	mov    $0xc011df20,%eax
c0101fe7:	bb 4c 00 00 00       	mov    $0x4c,%ebx
c0101fec:	89 c1                	mov    %eax,%ecx
c0101fee:	83 e1 01             	and    $0x1,%ecx
c0101ff1:	85 c9                	test   %ecx,%ecx
c0101ff3:	74 0c                	je     c0102001 <trap_dispatch+0x1f2>
c0101ff5:	0f b6 0a             	movzbl (%edx),%ecx
c0101ff8:	88 08                	mov    %cl,(%eax)
c0101ffa:	8d 40 01             	lea    0x1(%eax),%eax
c0101ffd:	8d 52 01             	lea    0x1(%edx),%edx
c0102000:	4b                   	dec    %ebx
c0102001:	89 c1                	mov    %eax,%ecx
c0102003:	83 e1 02             	and    $0x2,%ecx
c0102006:	85 c9                	test   %ecx,%ecx
c0102008:	74 0f                	je     c0102019 <trap_dispatch+0x20a>
c010200a:	0f b7 0a             	movzwl (%edx),%ecx
c010200d:	66 89 08             	mov    %cx,(%eax)
c0102010:	8d 40 02             	lea    0x2(%eax),%eax
c0102013:	8d 52 02             	lea    0x2(%edx),%edx
c0102016:	83 eb 02             	sub    $0x2,%ebx
c0102019:	89 df                	mov    %ebx,%edi
c010201b:	83 e7 fc             	and    $0xfffffffc,%edi
c010201e:	b9 00 00 00 00       	mov    $0x0,%ecx
c0102023:	8b 34 0a             	mov    (%edx,%ecx,1),%esi
c0102026:	89 34 08             	mov    %esi,(%eax,%ecx,1)
c0102029:	83 c1 04             	add    $0x4,%ecx
c010202c:	39 f9                	cmp    %edi,%ecx
c010202e:	72 f3                	jb     c0102023 <trap_dispatch+0x214>
c0102030:	01 c8                	add    %ecx,%eax
c0102032:	01 ca                	add    %ecx,%edx
c0102034:	b9 00 00 00 00       	mov    $0x0,%ecx
c0102039:	89 de                	mov    %ebx,%esi
c010203b:	83 e6 02             	and    $0x2,%esi
c010203e:	85 f6                	test   %esi,%esi
c0102040:	74 0b                	je     c010204d <trap_dispatch+0x23e>
c0102042:	0f b7 34 0a          	movzwl (%edx,%ecx,1),%esi
c0102046:	66 89 34 08          	mov    %si,(%eax,%ecx,1)
c010204a:	83 c1 02             	add    $0x2,%ecx
c010204d:	83 e3 01             	and    $0x1,%ebx
c0102050:	85 db                	test   %ebx,%ebx
c0102052:	74 07                	je     c010205b <trap_dispatch+0x24c>
c0102054:	0f b6 14 0a          	movzbl (%edx,%ecx,1),%edx
c0102058:	88 14 08             	mov    %dl,(%eax,%ecx,1)
            switchk2u.tf_cs = USER_CS;
c010205b:	66 c7 05 5c df 11 c0 	movw   $0x1b,0xc011df5c
c0102062:	1b 00 
            switchk2u.tf_ds = switchk2u.tf_es = switchk2u.tf_ss = USER_DS;
c0102064:	66 c7 05 68 df 11 c0 	movw   $0x23,0xc011df68
c010206b:	23 00 
c010206d:	0f b7 05 68 df 11 c0 	movzwl 0xc011df68,%eax
c0102074:	66 a3 48 df 11 c0    	mov    %ax,0xc011df48
c010207a:	0f b7 05 48 df 11 c0 	movzwl 0xc011df48,%eax
c0102081:	66 a3 4c df 11 c0    	mov    %ax,0xc011df4c
            switchk2u.tf_esp = (uint32_t)tf + sizeof(struct trapframe) - 8;
c0102087:	8b 45 08             	mov    0x8(%ebp),%eax
c010208a:	83 c0 44             	add    $0x44,%eax
c010208d:	a3 64 df 11 c0       	mov    %eax,0xc011df64
            switchk2u.tf_eflags |= FL_IOPL_MASK;
c0102092:	a1 60 df 11 c0       	mov    0xc011df60,%eax
c0102097:	0d 00 30 00 00       	or     $0x3000,%eax
c010209c:	a3 60 df 11 c0       	mov    %eax,0xc011df60
            *((uint32_t *)tf - 1) = (uint32_t)&switchk2u;
c01020a1:	8b 45 08             	mov    0x8(%ebp),%eax
c01020a4:	83 e8 04             	sub    $0x4,%eax
c01020a7:	ba 20 df 11 c0       	mov    $0xc011df20,%edx
c01020ac:	89 10                	mov    %edx,(%eax)
            cprintf("+++ switch to user mode +++\n");
c01020ae:	c7 04 24 eb 6a 10 c0 	movl   $0xc0106aeb,(%esp)
c01020b5:	e8 0b e2 ff ff       	call   c01002c5 <cprintf>
            print_trapframe(tf);
c01020ba:	8b 45 08             	mov    0x8(%ebp),%eax
c01020bd:	89 04 24             	mov    %eax,(%esp)
c01020c0:	e8 d9 fa ff ff       	call   c0101b9e <print_trapframe>
        break;
c01020c5:	e9 b7 01 00 00       	jmp    c0102281 <trap_dispatch+0x472>
    if (tf->tf_cs != USER_CS) {
c01020ca:	8b 45 08             	mov    0x8(%ebp),%eax
c01020cd:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
c01020d1:	83 f8 1b             	cmp    $0x1b,%eax
c01020d4:	0f 84 aa 01 00 00    	je     c0102284 <trap_dispatch+0x475>
            switchk2u = *tf;
c01020da:	8b 55 08             	mov    0x8(%ebp),%edx
c01020dd:	b8 20 df 11 c0       	mov    $0xc011df20,%eax
c01020e2:	bb 4c 00 00 00       	mov    $0x4c,%ebx
c01020e7:	89 c1                	mov    %eax,%ecx
c01020e9:	83 e1 01             	and    $0x1,%ecx
c01020ec:	85 c9                	test   %ecx,%ecx
c01020ee:	74 0c                	je     c01020fc <trap_dispatch+0x2ed>
c01020f0:	0f b6 0a             	movzbl (%edx),%ecx
c01020f3:	88 08                	mov    %cl,(%eax)
c01020f5:	8d 40 01             	lea    0x1(%eax),%eax
c01020f8:	8d 52 01             	lea    0x1(%edx),%edx
c01020fb:	4b                   	dec    %ebx
c01020fc:	89 c1                	mov    %eax,%ecx
c01020fe:	83 e1 02             	and    $0x2,%ecx
c0102101:	85 c9                	test   %ecx,%ecx
c0102103:	74 0f                	je     c0102114 <trap_dispatch+0x305>
c0102105:	0f b7 0a             	movzwl (%edx),%ecx
c0102108:	66 89 08             	mov    %cx,(%eax)
c010210b:	8d 40 02             	lea    0x2(%eax),%eax
c010210e:	8d 52 02             	lea    0x2(%edx),%edx
c0102111:	83 eb 02             	sub    $0x2,%ebx
c0102114:	89 df                	mov    %ebx,%edi
c0102116:	83 e7 fc             	and    $0xfffffffc,%edi
c0102119:	b9 00 00 00 00       	mov    $0x0,%ecx
c010211e:	8b 34 0a             	mov    (%edx,%ecx,1),%esi
c0102121:	89 34 08             	mov    %esi,(%eax,%ecx,1)
c0102124:	83 c1 04             	add    $0x4,%ecx
c0102127:	39 f9                	cmp    %edi,%ecx
c0102129:	72 f3                	jb     c010211e <trap_dispatch+0x30f>
c010212b:	01 c8                	add    %ecx,%eax
c010212d:	01 ca                	add    %ecx,%edx
c010212f:	b9 00 00 00 00       	mov    $0x0,%ecx
c0102134:	89 de                	mov    %ebx,%esi
c0102136:	83 e6 02             	and    $0x2,%esi
c0102139:	85 f6                	test   %esi,%esi
c010213b:	74 0b                	je     c0102148 <trap_dispatch+0x339>
c010213d:	0f b7 34 0a          	movzwl (%edx,%ecx,1),%esi
c0102141:	66 89 34 08          	mov    %si,(%eax,%ecx,1)
c0102145:	83 c1 02             	add    $0x2,%ecx
c0102148:	83 e3 01             	and    $0x1,%ebx
c010214b:	85 db                	test   %ebx,%ebx
c010214d:	74 07                	je     c0102156 <trap_dispatch+0x347>
c010214f:	0f b6 14 0a          	movzbl (%edx,%ecx,1),%edx
c0102153:	88 14 08             	mov    %dl,(%eax,%ecx,1)
            switchk2u.tf_cs = USER_CS;
c0102156:	66 c7 05 5c df 11 c0 	movw   $0x1b,0xc011df5c
c010215d:	1b 00 
            switchk2u.tf_ds = USER_DS;
c010215f:	66 c7 05 4c df 11 c0 	movw   $0x23,0xc011df4c
c0102166:	23 00 
            switchk2u.tf_es = USER_DS;
c0102168:	66 c7 05 48 df 11 c0 	movw   $0x23,0xc011df48
c010216f:	23 00 
            switchk2u.tf_ss = USER_DS;
c0102171:	66 c7 05 68 df 11 c0 	movw   $0x23,0xc011df68
c0102178:	23 00 
            switchk2u.tf_esp = (uint32_t)tf + sizeof(struct trapframe) - 8;
c010217a:	8b 45 08             	mov    0x8(%ebp),%eax
c010217d:	83 c0 44             	add    $0x44,%eax
c0102180:	a3 64 df 11 c0       	mov    %eax,0xc011df64
            switchk2u.tf_eflags |= FL_IOPL_MASK;
c0102185:	a1 60 df 11 c0       	mov    0xc011df60,%eax
c010218a:	0d 00 30 00 00       	or     $0x3000,%eax
c010218f:	a3 60 df 11 c0       	mov    %eax,0xc011df60
            *((uint32_t *)tf - 1) = (uint32_t)&switchk2u;
c0102194:	8b 45 08             	mov    0x8(%ebp),%eax
c0102197:	83 e8 04             	sub    $0x4,%eax
c010219a:	ba 20 df 11 c0       	mov    $0xc011df20,%edx
c010219f:	89 10                	mov    %edx,(%eax)
            print_trapframe(&switchk2u);
c01021a1:	c7 04 24 20 df 11 c0 	movl   $0xc011df20,(%esp)
c01021a8:	e8 f1 f9 ff ff       	call   c0101b9e <print_trapframe>
        break;
c01021ad:	e9 d2 00 00 00       	jmp    c0102284 <trap_dispatch+0x475>
    print_trapframe(tf);
c01021b2:	8b 45 08             	mov    0x8(%ebp),%eax
c01021b5:	89 04 24             	mov    %eax,(%esp)
c01021b8:	e8 e1 f9 ff ff       	call   c0101b9e <print_trapframe>
    if (tf->tf_cs != KERNEL_CS) {
c01021bd:	8b 45 08             	mov    0x8(%ebp),%eax
c01021c0:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
c01021c4:	83 f8 08             	cmp    $0x8,%eax
c01021c7:	0f 84 ba 00 00 00    	je     c0102287 <trap_dispatch+0x478>
            tf->tf_cs = KERNEL_CS;
c01021cd:	8b 45 08             	mov    0x8(%ebp),%eax
c01021d0:	66 c7 40 3c 08 00    	movw   $0x8,0x3c(%eax)
            tf->tf_ds = tf->tf_es = KERNEL_DS;
c01021d6:	8b 45 08             	mov    0x8(%ebp),%eax
c01021d9:	66 c7 40 28 10 00    	movw   $0x10,0x28(%eax)
c01021df:	8b 45 08             	mov    0x8(%ebp),%eax
c01021e2:	0f b7 50 28          	movzwl 0x28(%eax),%edx
c01021e6:	8b 45 08             	mov    0x8(%ebp),%eax
c01021e9:	66 89 50 2c          	mov    %dx,0x2c(%eax)
            tf->tf_eflags &= ~FL_IOPL_MASK;
c01021ed:	8b 45 08             	mov    0x8(%ebp),%eax
c01021f0:	8b 40 40             	mov    0x40(%eax),%eax
c01021f3:	25 ff cf ff ff       	and    $0xffffcfff,%eax
c01021f8:	89 c2                	mov    %eax,%edx
c01021fa:	8b 45 08             	mov    0x8(%ebp),%eax
c01021fd:	89 50 40             	mov    %edx,0x40(%eax)
            switchu2k = (struct trapframe *)(tf->tf_esp - (sizeof(struct trapframe) - 8));
c0102200:	8b 45 08             	mov    0x8(%ebp),%eax
c0102203:	8b 40 44             	mov    0x44(%eax),%eax
c0102206:	83 e8 44             	sub    $0x44,%eax
c0102209:	a3 6c df 11 c0       	mov    %eax,0xc011df6c
            memmove(switchu2k, tf, sizeof(struct trapframe) - 8);
c010220e:	a1 6c df 11 c0       	mov    0xc011df6c,%eax
c0102213:	c7 44 24 08 44 00 00 	movl   $0x44,0x8(%esp)
c010221a:	00 
c010221b:	8b 55 08             	mov    0x8(%ebp),%edx
c010221e:	89 54 24 04          	mov    %edx,0x4(%esp)
c0102222:	89 04 24             	mov    %eax,(%esp)
c0102225:	e8 37 3b 00 00       	call   c0105d61 <memmove>
            *((uint32_t *)tf - 1) = (uint32_t)switchu2k;
c010222a:	8b 15 6c df 11 c0    	mov    0xc011df6c,%edx
c0102230:	8b 45 08             	mov    0x8(%ebp),%eax
c0102233:	83 e8 04             	sub    $0x4,%eax
c0102236:	89 10                	mov    %edx,(%eax)
            print_trapframe(&switchu2k);
c0102238:	c7 04 24 6c df 11 c0 	movl   $0xc011df6c,(%esp)
c010223f:	e8 5a f9 ff ff       	call   c0101b9e <print_trapframe>
        break;
c0102244:	eb 41                	jmp    c0102287 <trap_dispatch+0x478>
        if ((tf->tf_cs & 3) == 0) {
c0102246:	8b 45 08             	mov    0x8(%ebp),%eax
c0102249:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
c010224d:	83 e0 03             	and    $0x3,%eax
c0102250:	85 c0                	test   %eax,%eax
c0102252:	75 34                	jne    c0102288 <trap_dispatch+0x479>
            print_trapframe(tf);
c0102254:	8b 45 08             	mov    0x8(%ebp),%eax
c0102257:	89 04 24             	mov    %eax,(%esp)
c010225a:	e8 3f f9 ff ff       	call   c0101b9e <print_trapframe>
            panic("unexpected trap in kernel.\n");
c010225f:	c7 44 24 08 08 6b 10 	movl   $0xc0106b08,0x8(%esp)
c0102266:	c0 
c0102267:	c7 44 24 04 fc 00 00 	movl   $0xfc,0x4(%esp)
c010226e:	00 
c010226f:	c7 04 24 ee 68 10 c0 	movl   $0xc01068ee,(%esp)
c0102276:	e8 b6 e1 ff ff       	call   c0100431 <__panic>
        break;
c010227b:	90                   	nop
c010227c:	eb 0a                	jmp    c0102288 <trap_dispatch+0x479>
        break;
c010227e:	90                   	nop
c010227f:	eb 07                	jmp    c0102288 <trap_dispatch+0x479>
        break;
c0102281:	90                   	nop
c0102282:	eb 04                	jmp    c0102288 <trap_dispatch+0x479>
        break;
c0102284:	90                   	nop
c0102285:	eb 01                	jmp    c0102288 <trap_dispatch+0x479>
        break;
c0102287:	90                   	nop
}
c0102288:	90                   	nop
c0102289:	83 c4 2c             	add    $0x2c,%esp
c010228c:	5b                   	pop    %ebx
c010228d:	5e                   	pop    %esi
c010228e:	5f                   	pop    %edi
c010228f:	5d                   	pop    %ebp
c0102290:	c3                   	ret    

c0102291 <trap>:
 * trap - handles or dispatches an exception/interrupt. if and when trap() returns,
 * the code in kern/trap/trapentry.S restores the old CPU state saved in the
 * trapframe and then uses the iret instruction to return from the exception.
 * */
void
trap(struct trapframe *tf) {
c0102291:	f3 0f 1e fb          	endbr32 
c0102295:	55                   	push   %ebp
c0102296:	89 e5                	mov    %esp,%ebp
c0102298:	83 ec 18             	sub    $0x18,%esp
    // dispatch based on what type of trap occurred
    trap_dispatch(tf);
c010229b:	8b 45 08             	mov    0x8(%ebp),%eax
c010229e:	89 04 24             	mov    %eax,(%esp)
c01022a1:	e8 69 fb ff ff       	call   c0101e0f <trap_dispatch>
}
c01022a6:	90                   	nop
c01022a7:	c9                   	leave  
c01022a8:	c3                   	ret    

c01022a9 <vector0>:
# handler
.text
.globl __alltraps
.globl vector0
vector0:
  pushl $0
c01022a9:	6a 00                	push   $0x0
  pushl $0
c01022ab:	6a 00                	push   $0x0
  jmp __alltraps
c01022ad:	e9 69 0a 00 00       	jmp    c0102d1b <__alltraps>

c01022b2 <vector1>:
.globl vector1
vector1:
  pushl $0
c01022b2:	6a 00                	push   $0x0
  pushl $1
c01022b4:	6a 01                	push   $0x1
  jmp __alltraps
c01022b6:	e9 60 0a 00 00       	jmp    c0102d1b <__alltraps>

c01022bb <vector2>:
.globl vector2
vector2:
  pushl $0
c01022bb:	6a 00                	push   $0x0
  pushl $2
c01022bd:	6a 02                	push   $0x2
  jmp __alltraps
c01022bf:	e9 57 0a 00 00       	jmp    c0102d1b <__alltraps>

c01022c4 <vector3>:
.globl vector3
vector3:
  pushl $0
c01022c4:	6a 00                	push   $0x0
  pushl $3
c01022c6:	6a 03                	push   $0x3
  jmp __alltraps
c01022c8:	e9 4e 0a 00 00       	jmp    c0102d1b <__alltraps>

c01022cd <vector4>:
.globl vector4
vector4:
  pushl $0
c01022cd:	6a 00                	push   $0x0
  pushl $4
c01022cf:	6a 04                	push   $0x4
  jmp __alltraps
c01022d1:	e9 45 0a 00 00       	jmp    c0102d1b <__alltraps>

c01022d6 <vector5>:
.globl vector5
vector5:
  pushl $0
c01022d6:	6a 00                	push   $0x0
  pushl $5
c01022d8:	6a 05                	push   $0x5
  jmp __alltraps
c01022da:	e9 3c 0a 00 00       	jmp    c0102d1b <__alltraps>

c01022df <vector6>:
.globl vector6
vector6:
  pushl $0
c01022df:	6a 00                	push   $0x0
  pushl $6
c01022e1:	6a 06                	push   $0x6
  jmp __alltraps
c01022e3:	e9 33 0a 00 00       	jmp    c0102d1b <__alltraps>

c01022e8 <vector7>:
.globl vector7
vector7:
  pushl $0
c01022e8:	6a 00                	push   $0x0
  pushl $7
c01022ea:	6a 07                	push   $0x7
  jmp __alltraps
c01022ec:	e9 2a 0a 00 00       	jmp    c0102d1b <__alltraps>

c01022f1 <vector8>:
.globl vector8
vector8:
  pushl $8
c01022f1:	6a 08                	push   $0x8
  jmp __alltraps
c01022f3:	e9 23 0a 00 00       	jmp    c0102d1b <__alltraps>

c01022f8 <vector9>:
.globl vector9
vector9:
  pushl $0
c01022f8:	6a 00                	push   $0x0
  pushl $9
c01022fa:	6a 09                	push   $0x9
  jmp __alltraps
c01022fc:	e9 1a 0a 00 00       	jmp    c0102d1b <__alltraps>

c0102301 <vector10>:
.globl vector10
vector10:
  pushl $10
c0102301:	6a 0a                	push   $0xa
  jmp __alltraps
c0102303:	e9 13 0a 00 00       	jmp    c0102d1b <__alltraps>

c0102308 <vector11>:
.globl vector11
vector11:
  pushl $11
c0102308:	6a 0b                	push   $0xb
  jmp __alltraps
c010230a:	e9 0c 0a 00 00       	jmp    c0102d1b <__alltraps>

c010230f <vector12>:
.globl vector12
vector12:
  pushl $12
c010230f:	6a 0c                	push   $0xc
  jmp __alltraps
c0102311:	e9 05 0a 00 00       	jmp    c0102d1b <__alltraps>

c0102316 <vector13>:
.globl vector13
vector13:
  pushl $13
c0102316:	6a 0d                	push   $0xd
  jmp __alltraps
c0102318:	e9 fe 09 00 00       	jmp    c0102d1b <__alltraps>

c010231d <vector14>:
.globl vector14
vector14:
  pushl $14
c010231d:	6a 0e                	push   $0xe
  jmp __alltraps
c010231f:	e9 f7 09 00 00       	jmp    c0102d1b <__alltraps>

c0102324 <vector15>:
.globl vector15
vector15:
  pushl $0
c0102324:	6a 00                	push   $0x0
  pushl $15
c0102326:	6a 0f                	push   $0xf
  jmp __alltraps
c0102328:	e9 ee 09 00 00       	jmp    c0102d1b <__alltraps>

c010232d <vector16>:
.globl vector16
vector16:
  pushl $0
c010232d:	6a 00                	push   $0x0
  pushl $16
c010232f:	6a 10                	push   $0x10
  jmp __alltraps
c0102331:	e9 e5 09 00 00       	jmp    c0102d1b <__alltraps>

c0102336 <vector17>:
.globl vector17
vector17:
  pushl $17
c0102336:	6a 11                	push   $0x11
  jmp __alltraps
c0102338:	e9 de 09 00 00       	jmp    c0102d1b <__alltraps>

c010233d <vector18>:
.globl vector18
vector18:
  pushl $0
c010233d:	6a 00                	push   $0x0
  pushl $18
c010233f:	6a 12                	push   $0x12
  jmp __alltraps
c0102341:	e9 d5 09 00 00       	jmp    c0102d1b <__alltraps>

c0102346 <vector19>:
.globl vector19
vector19:
  pushl $0
c0102346:	6a 00                	push   $0x0
  pushl $19
c0102348:	6a 13                	push   $0x13
  jmp __alltraps
c010234a:	e9 cc 09 00 00       	jmp    c0102d1b <__alltraps>

c010234f <vector20>:
.globl vector20
vector20:
  pushl $0
c010234f:	6a 00                	push   $0x0
  pushl $20
c0102351:	6a 14                	push   $0x14
  jmp __alltraps
c0102353:	e9 c3 09 00 00       	jmp    c0102d1b <__alltraps>

c0102358 <vector21>:
.globl vector21
vector21:
  pushl $0
c0102358:	6a 00                	push   $0x0
  pushl $21
c010235a:	6a 15                	push   $0x15
  jmp __alltraps
c010235c:	e9 ba 09 00 00       	jmp    c0102d1b <__alltraps>

c0102361 <vector22>:
.globl vector22
vector22:
  pushl $0
c0102361:	6a 00                	push   $0x0
  pushl $22
c0102363:	6a 16                	push   $0x16
  jmp __alltraps
c0102365:	e9 b1 09 00 00       	jmp    c0102d1b <__alltraps>

c010236a <vector23>:
.globl vector23
vector23:
  pushl $0
c010236a:	6a 00                	push   $0x0
  pushl $23
c010236c:	6a 17                	push   $0x17
  jmp __alltraps
c010236e:	e9 a8 09 00 00       	jmp    c0102d1b <__alltraps>

c0102373 <vector24>:
.globl vector24
vector24:
  pushl $0
c0102373:	6a 00                	push   $0x0
  pushl $24
c0102375:	6a 18                	push   $0x18
  jmp __alltraps
c0102377:	e9 9f 09 00 00       	jmp    c0102d1b <__alltraps>

c010237c <vector25>:
.globl vector25
vector25:
  pushl $0
c010237c:	6a 00                	push   $0x0
  pushl $25
c010237e:	6a 19                	push   $0x19
  jmp __alltraps
c0102380:	e9 96 09 00 00       	jmp    c0102d1b <__alltraps>

c0102385 <vector26>:
.globl vector26
vector26:
  pushl $0
c0102385:	6a 00                	push   $0x0
  pushl $26
c0102387:	6a 1a                	push   $0x1a
  jmp __alltraps
c0102389:	e9 8d 09 00 00       	jmp    c0102d1b <__alltraps>

c010238e <vector27>:
.globl vector27
vector27:
  pushl $0
c010238e:	6a 00                	push   $0x0
  pushl $27
c0102390:	6a 1b                	push   $0x1b
  jmp __alltraps
c0102392:	e9 84 09 00 00       	jmp    c0102d1b <__alltraps>

c0102397 <vector28>:
.globl vector28
vector28:
  pushl $0
c0102397:	6a 00                	push   $0x0
  pushl $28
c0102399:	6a 1c                	push   $0x1c
  jmp __alltraps
c010239b:	e9 7b 09 00 00       	jmp    c0102d1b <__alltraps>

c01023a0 <vector29>:
.globl vector29
vector29:
  pushl $0
c01023a0:	6a 00                	push   $0x0
  pushl $29
c01023a2:	6a 1d                	push   $0x1d
  jmp __alltraps
c01023a4:	e9 72 09 00 00       	jmp    c0102d1b <__alltraps>

c01023a9 <vector30>:
.globl vector30
vector30:
  pushl $0
c01023a9:	6a 00                	push   $0x0
  pushl $30
c01023ab:	6a 1e                	push   $0x1e
  jmp __alltraps
c01023ad:	e9 69 09 00 00       	jmp    c0102d1b <__alltraps>

c01023b2 <vector31>:
.globl vector31
vector31:
  pushl $0
c01023b2:	6a 00                	push   $0x0
  pushl $31
c01023b4:	6a 1f                	push   $0x1f
  jmp __alltraps
c01023b6:	e9 60 09 00 00       	jmp    c0102d1b <__alltraps>

c01023bb <vector32>:
.globl vector32
vector32:
  pushl $0
c01023bb:	6a 00                	push   $0x0
  pushl $32
c01023bd:	6a 20                	push   $0x20
  jmp __alltraps
c01023bf:	e9 57 09 00 00       	jmp    c0102d1b <__alltraps>

c01023c4 <vector33>:
.globl vector33
vector33:
  pushl $0
c01023c4:	6a 00                	push   $0x0
  pushl $33
c01023c6:	6a 21                	push   $0x21
  jmp __alltraps
c01023c8:	e9 4e 09 00 00       	jmp    c0102d1b <__alltraps>

c01023cd <vector34>:
.globl vector34
vector34:
  pushl $0
c01023cd:	6a 00                	push   $0x0
  pushl $34
c01023cf:	6a 22                	push   $0x22
  jmp __alltraps
c01023d1:	e9 45 09 00 00       	jmp    c0102d1b <__alltraps>

c01023d6 <vector35>:
.globl vector35
vector35:
  pushl $0
c01023d6:	6a 00                	push   $0x0
  pushl $35
c01023d8:	6a 23                	push   $0x23
  jmp __alltraps
c01023da:	e9 3c 09 00 00       	jmp    c0102d1b <__alltraps>

c01023df <vector36>:
.globl vector36
vector36:
  pushl $0
c01023df:	6a 00                	push   $0x0
  pushl $36
c01023e1:	6a 24                	push   $0x24
  jmp __alltraps
c01023e3:	e9 33 09 00 00       	jmp    c0102d1b <__alltraps>

c01023e8 <vector37>:
.globl vector37
vector37:
  pushl $0
c01023e8:	6a 00                	push   $0x0
  pushl $37
c01023ea:	6a 25                	push   $0x25
  jmp __alltraps
c01023ec:	e9 2a 09 00 00       	jmp    c0102d1b <__alltraps>

c01023f1 <vector38>:
.globl vector38
vector38:
  pushl $0
c01023f1:	6a 00                	push   $0x0
  pushl $38
c01023f3:	6a 26                	push   $0x26
  jmp __alltraps
c01023f5:	e9 21 09 00 00       	jmp    c0102d1b <__alltraps>

c01023fa <vector39>:
.globl vector39
vector39:
  pushl $0
c01023fa:	6a 00                	push   $0x0
  pushl $39
c01023fc:	6a 27                	push   $0x27
  jmp __alltraps
c01023fe:	e9 18 09 00 00       	jmp    c0102d1b <__alltraps>

c0102403 <vector40>:
.globl vector40
vector40:
  pushl $0
c0102403:	6a 00                	push   $0x0
  pushl $40
c0102405:	6a 28                	push   $0x28
  jmp __alltraps
c0102407:	e9 0f 09 00 00       	jmp    c0102d1b <__alltraps>

c010240c <vector41>:
.globl vector41
vector41:
  pushl $0
c010240c:	6a 00                	push   $0x0
  pushl $41
c010240e:	6a 29                	push   $0x29
  jmp __alltraps
c0102410:	e9 06 09 00 00       	jmp    c0102d1b <__alltraps>

c0102415 <vector42>:
.globl vector42
vector42:
  pushl $0
c0102415:	6a 00                	push   $0x0
  pushl $42
c0102417:	6a 2a                	push   $0x2a
  jmp __alltraps
c0102419:	e9 fd 08 00 00       	jmp    c0102d1b <__alltraps>

c010241e <vector43>:
.globl vector43
vector43:
  pushl $0
c010241e:	6a 00                	push   $0x0
  pushl $43
c0102420:	6a 2b                	push   $0x2b
  jmp __alltraps
c0102422:	e9 f4 08 00 00       	jmp    c0102d1b <__alltraps>

c0102427 <vector44>:
.globl vector44
vector44:
  pushl $0
c0102427:	6a 00                	push   $0x0
  pushl $44
c0102429:	6a 2c                	push   $0x2c
  jmp __alltraps
c010242b:	e9 eb 08 00 00       	jmp    c0102d1b <__alltraps>

c0102430 <vector45>:
.globl vector45
vector45:
  pushl $0
c0102430:	6a 00                	push   $0x0
  pushl $45
c0102432:	6a 2d                	push   $0x2d
  jmp __alltraps
c0102434:	e9 e2 08 00 00       	jmp    c0102d1b <__alltraps>

c0102439 <vector46>:
.globl vector46
vector46:
  pushl $0
c0102439:	6a 00                	push   $0x0
  pushl $46
c010243b:	6a 2e                	push   $0x2e
  jmp __alltraps
c010243d:	e9 d9 08 00 00       	jmp    c0102d1b <__alltraps>

c0102442 <vector47>:
.globl vector47
vector47:
  pushl $0
c0102442:	6a 00                	push   $0x0
  pushl $47
c0102444:	6a 2f                	push   $0x2f
  jmp __alltraps
c0102446:	e9 d0 08 00 00       	jmp    c0102d1b <__alltraps>

c010244b <vector48>:
.globl vector48
vector48:
  pushl $0
c010244b:	6a 00                	push   $0x0
  pushl $48
c010244d:	6a 30                	push   $0x30
  jmp __alltraps
c010244f:	e9 c7 08 00 00       	jmp    c0102d1b <__alltraps>

c0102454 <vector49>:
.globl vector49
vector49:
  pushl $0
c0102454:	6a 00                	push   $0x0
  pushl $49
c0102456:	6a 31                	push   $0x31
  jmp __alltraps
c0102458:	e9 be 08 00 00       	jmp    c0102d1b <__alltraps>

c010245d <vector50>:
.globl vector50
vector50:
  pushl $0
c010245d:	6a 00                	push   $0x0
  pushl $50
c010245f:	6a 32                	push   $0x32
  jmp __alltraps
c0102461:	e9 b5 08 00 00       	jmp    c0102d1b <__alltraps>

c0102466 <vector51>:
.globl vector51
vector51:
  pushl $0
c0102466:	6a 00                	push   $0x0
  pushl $51
c0102468:	6a 33                	push   $0x33
  jmp __alltraps
c010246a:	e9 ac 08 00 00       	jmp    c0102d1b <__alltraps>

c010246f <vector52>:
.globl vector52
vector52:
  pushl $0
c010246f:	6a 00                	push   $0x0
  pushl $52
c0102471:	6a 34                	push   $0x34
  jmp __alltraps
c0102473:	e9 a3 08 00 00       	jmp    c0102d1b <__alltraps>

c0102478 <vector53>:
.globl vector53
vector53:
  pushl $0
c0102478:	6a 00                	push   $0x0
  pushl $53
c010247a:	6a 35                	push   $0x35
  jmp __alltraps
c010247c:	e9 9a 08 00 00       	jmp    c0102d1b <__alltraps>

c0102481 <vector54>:
.globl vector54
vector54:
  pushl $0
c0102481:	6a 00                	push   $0x0
  pushl $54
c0102483:	6a 36                	push   $0x36
  jmp __alltraps
c0102485:	e9 91 08 00 00       	jmp    c0102d1b <__alltraps>

c010248a <vector55>:
.globl vector55
vector55:
  pushl $0
c010248a:	6a 00                	push   $0x0
  pushl $55
c010248c:	6a 37                	push   $0x37
  jmp __alltraps
c010248e:	e9 88 08 00 00       	jmp    c0102d1b <__alltraps>

c0102493 <vector56>:
.globl vector56
vector56:
  pushl $0
c0102493:	6a 00                	push   $0x0
  pushl $56
c0102495:	6a 38                	push   $0x38
  jmp __alltraps
c0102497:	e9 7f 08 00 00       	jmp    c0102d1b <__alltraps>

c010249c <vector57>:
.globl vector57
vector57:
  pushl $0
c010249c:	6a 00                	push   $0x0
  pushl $57
c010249e:	6a 39                	push   $0x39
  jmp __alltraps
c01024a0:	e9 76 08 00 00       	jmp    c0102d1b <__alltraps>

c01024a5 <vector58>:
.globl vector58
vector58:
  pushl $0
c01024a5:	6a 00                	push   $0x0
  pushl $58
c01024a7:	6a 3a                	push   $0x3a
  jmp __alltraps
c01024a9:	e9 6d 08 00 00       	jmp    c0102d1b <__alltraps>

c01024ae <vector59>:
.globl vector59
vector59:
  pushl $0
c01024ae:	6a 00                	push   $0x0
  pushl $59
c01024b0:	6a 3b                	push   $0x3b
  jmp __alltraps
c01024b2:	e9 64 08 00 00       	jmp    c0102d1b <__alltraps>

c01024b7 <vector60>:
.globl vector60
vector60:
  pushl $0
c01024b7:	6a 00                	push   $0x0
  pushl $60
c01024b9:	6a 3c                	push   $0x3c
  jmp __alltraps
c01024bb:	e9 5b 08 00 00       	jmp    c0102d1b <__alltraps>

c01024c0 <vector61>:
.globl vector61
vector61:
  pushl $0
c01024c0:	6a 00                	push   $0x0
  pushl $61
c01024c2:	6a 3d                	push   $0x3d
  jmp __alltraps
c01024c4:	e9 52 08 00 00       	jmp    c0102d1b <__alltraps>

c01024c9 <vector62>:
.globl vector62
vector62:
  pushl $0
c01024c9:	6a 00                	push   $0x0
  pushl $62
c01024cb:	6a 3e                	push   $0x3e
  jmp __alltraps
c01024cd:	e9 49 08 00 00       	jmp    c0102d1b <__alltraps>

c01024d2 <vector63>:
.globl vector63
vector63:
  pushl $0
c01024d2:	6a 00                	push   $0x0
  pushl $63
c01024d4:	6a 3f                	push   $0x3f
  jmp __alltraps
c01024d6:	e9 40 08 00 00       	jmp    c0102d1b <__alltraps>

c01024db <vector64>:
.globl vector64
vector64:
  pushl $0
c01024db:	6a 00                	push   $0x0
  pushl $64
c01024dd:	6a 40                	push   $0x40
  jmp __alltraps
c01024df:	e9 37 08 00 00       	jmp    c0102d1b <__alltraps>

c01024e4 <vector65>:
.globl vector65
vector65:
  pushl $0
c01024e4:	6a 00                	push   $0x0
  pushl $65
c01024e6:	6a 41                	push   $0x41
  jmp __alltraps
c01024e8:	e9 2e 08 00 00       	jmp    c0102d1b <__alltraps>

c01024ed <vector66>:
.globl vector66
vector66:
  pushl $0
c01024ed:	6a 00                	push   $0x0
  pushl $66
c01024ef:	6a 42                	push   $0x42
  jmp __alltraps
c01024f1:	e9 25 08 00 00       	jmp    c0102d1b <__alltraps>

c01024f6 <vector67>:
.globl vector67
vector67:
  pushl $0
c01024f6:	6a 00                	push   $0x0
  pushl $67
c01024f8:	6a 43                	push   $0x43
  jmp __alltraps
c01024fa:	e9 1c 08 00 00       	jmp    c0102d1b <__alltraps>

c01024ff <vector68>:
.globl vector68
vector68:
  pushl $0
c01024ff:	6a 00                	push   $0x0
  pushl $68
c0102501:	6a 44                	push   $0x44
  jmp __alltraps
c0102503:	e9 13 08 00 00       	jmp    c0102d1b <__alltraps>

c0102508 <vector69>:
.globl vector69
vector69:
  pushl $0
c0102508:	6a 00                	push   $0x0
  pushl $69
c010250a:	6a 45                	push   $0x45
  jmp __alltraps
c010250c:	e9 0a 08 00 00       	jmp    c0102d1b <__alltraps>

c0102511 <vector70>:
.globl vector70
vector70:
  pushl $0
c0102511:	6a 00                	push   $0x0
  pushl $70
c0102513:	6a 46                	push   $0x46
  jmp __alltraps
c0102515:	e9 01 08 00 00       	jmp    c0102d1b <__alltraps>

c010251a <vector71>:
.globl vector71
vector71:
  pushl $0
c010251a:	6a 00                	push   $0x0
  pushl $71
c010251c:	6a 47                	push   $0x47
  jmp __alltraps
c010251e:	e9 f8 07 00 00       	jmp    c0102d1b <__alltraps>

c0102523 <vector72>:
.globl vector72
vector72:
  pushl $0
c0102523:	6a 00                	push   $0x0
  pushl $72
c0102525:	6a 48                	push   $0x48
  jmp __alltraps
c0102527:	e9 ef 07 00 00       	jmp    c0102d1b <__alltraps>

c010252c <vector73>:
.globl vector73
vector73:
  pushl $0
c010252c:	6a 00                	push   $0x0
  pushl $73
c010252e:	6a 49                	push   $0x49
  jmp __alltraps
c0102530:	e9 e6 07 00 00       	jmp    c0102d1b <__alltraps>

c0102535 <vector74>:
.globl vector74
vector74:
  pushl $0
c0102535:	6a 00                	push   $0x0
  pushl $74
c0102537:	6a 4a                	push   $0x4a
  jmp __alltraps
c0102539:	e9 dd 07 00 00       	jmp    c0102d1b <__alltraps>

c010253e <vector75>:
.globl vector75
vector75:
  pushl $0
c010253e:	6a 00                	push   $0x0
  pushl $75
c0102540:	6a 4b                	push   $0x4b
  jmp __alltraps
c0102542:	e9 d4 07 00 00       	jmp    c0102d1b <__alltraps>

c0102547 <vector76>:
.globl vector76
vector76:
  pushl $0
c0102547:	6a 00                	push   $0x0
  pushl $76
c0102549:	6a 4c                	push   $0x4c
  jmp __alltraps
c010254b:	e9 cb 07 00 00       	jmp    c0102d1b <__alltraps>

c0102550 <vector77>:
.globl vector77
vector77:
  pushl $0
c0102550:	6a 00                	push   $0x0
  pushl $77
c0102552:	6a 4d                	push   $0x4d
  jmp __alltraps
c0102554:	e9 c2 07 00 00       	jmp    c0102d1b <__alltraps>

c0102559 <vector78>:
.globl vector78
vector78:
  pushl $0
c0102559:	6a 00                	push   $0x0
  pushl $78
c010255b:	6a 4e                	push   $0x4e
  jmp __alltraps
c010255d:	e9 b9 07 00 00       	jmp    c0102d1b <__alltraps>

c0102562 <vector79>:
.globl vector79
vector79:
  pushl $0
c0102562:	6a 00                	push   $0x0
  pushl $79
c0102564:	6a 4f                	push   $0x4f
  jmp __alltraps
c0102566:	e9 b0 07 00 00       	jmp    c0102d1b <__alltraps>

c010256b <vector80>:
.globl vector80
vector80:
  pushl $0
c010256b:	6a 00                	push   $0x0
  pushl $80
c010256d:	6a 50                	push   $0x50
  jmp __alltraps
c010256f:	e9 a7 07 00 00       	jmp    c0102d1b <__alltraps>

c0102574 <vector81>:
.globl vector81
vector81:
  pushl $0
c0102574:	6a 00                	push   $0x0
  pushl $81
c0102576:	6a 51                	push   $0x51
  jmp __alltraps
c0102578:	e9 9e 07 00 00       	jmp    c0102d1b <__alltraps>

c010257d <vector82>:
.globl vector82
vector82:
  pushl $0
c010257d:	6a 00                	push   $0x0
  pushl $82
c010257f:	6a 52                	push   $0x52
  jmp __alltraps
c0102581:	e9 95 07 00 00       	jmp    c0102d1b <__alltraps>

c0102586 <vector83>:
.globl vector83
vector83:
  pushl $0
c0102586:	6a 00                	push   $0x0
  pushl $83
c0102588:	6a 53                	push   $0x53
  jmp __alltraps
c010258a:	e9 8c 07 00 00       	jmp    c0102d1b <__alltraps>

c010258f <vector84>:
.globl vector84
vector84:
  pushl $0
c010258f:	6a 00                	push   $0x0
  pushl $84
c0102591:	6a 54                	push   $0x54
  jmp __alltraps
c0102593:	e9 83 07 00 00       	jmp    c0102d1b <__alltraps>

c0102598 <vector85>:
.globl vector85
vector85:
  pushl $0
c0102598:	6a 00                	push   $0x0
  pushl $85
c010259a:	6a 55                	push   $0x55
  jmp __alltraps
c010259c:	e9 7a 07 00 00       	jmp    c0102d1b <__alltraps>

c01025a1 <vector86>:
.globl vector86
vector86:
  pushl $0
c01025a1:	6a 00                	push   $0x0
  pushl $86
c01025a3:	6a 56                	push   $0x56
  jmp __alltraps
c01025a5:	e9 71 07 00 00       	jmp    c0102d1b <__alltraps>

c01025aa <vector87>:
.globl vector87
vector87:
  pushl $0
c01025aa:	6a 00                	push   $0x0
  pushl $87
c01025ac:	6a 57                	push   $0x57
  jmp __alltraps
c01025ae:	e9 68 07 00 00       	jmp    c0102d1b <__alltraps>

c01025b3 <vector88>:
.globl vector88
vector88:
  pushl $0
c01025b3:	6a 00                	push   $0x0
  pushl $88
c01025b5:	6a 58                	push   $0x58
  jmp __alltraps
c01025b7:	e9 5f 07 00 00       	jmp    c0102d1b <__alltraps>

c01025bc <vector89>:
.globl vector89
vector89:
  pushl $0
c01025bc:	6a 00                	push   $0x0
  pushl $89
c01025be:	6a 59                	push   $0x59
  jmp __alltraps
c01025c0:	e9 56 07 00 00       	jmp    c0102d1b <__alltraps>

c01025c5 <vector90>:
.globl vector90
vector90:
  pushl $0
c01025c5:	6a 00                	push   $0x0
  pushl $90
c01025c7:	6a 5a                	push   $0x5a
  jmp __alltraps
c01025c9:	e9 4d 07 00 00       	jmp    c0102d1b <__alltraps>

c01025ce <vector91>:
.globl vector91
vector91:
  pushl $0
c01025ce:	6a 00                	push   $0x0
  pushl $91
c01025d0:	6a 5b                	push   $0x5b
  jmp __alltraps
c01025d2:	e9 44 07 00 00       	jmp    c0102d1b <__alltraps>

c01025d7 <vector92>:
.globl vector92
vector92:
  pushl $0
c01025d7:	6a 00                	push   $0x0
  pushl $92
c01025d9:	6a 5c                	push   $0x5c
  jmp __alltraps
c01025db:	e9 3b 07 00 00       	jmp    c0102d1b <__alltraps>

c01025e0 <vector93>:
.globl vector93
vector93:
  pushl $0
c01025e0:	6a 00                	push   $0x0
  pushl $93
c01025e2:	6a 5d                	push   $0x5d
  jmp __alltraps
c01025e4:	e9 32 07 00 00       	jmp    c0102d1b <__alltraps>

c01025e9 <vector94>:
.globl vector94
vector94:
  pushl $0
c01025e9:	6a 00                	push   $0x0
  pushl $94
c01025eb:	6a 5e                	push   $0x5e
  jmp __alltraps
c01025ed:	e9 29 07 00 00       	jmp    c0102d1b <__alltraps>

c01025f2 <vector95>:
.globl vector95
vector95:
  pushl $0
c01025f2:	6a 00                	push   $0x0
  pushl $95
c01025f4:	6a 5f                	push   $0x5f
  jmp __alltraps
c01025f6:	e9 20 07 00 00       	jmp    c0102d1b <__alltraps>

c01025fb <vector96>:
.globl vector96
vector96:
  pushl $0
c01025fb:	6a 00                	push   $0x0
  pushl $96
c01025fd:	6a 60                	push   $0x60
  jmp __alltraps
c01025ff:	e9 17 07 00 00       	jmp    c0102d1b <__alltraps>

c0102604 <vector97>:
.globl vector97
vector97:
  pushl $0
c0102604:	6a 00                	push   $0x0
  pushl $97
c0102606:	6a 61                	push   $0x61
  jmp __alltraps
c0102608:	e9 0e 07 00 00       	jmp    c0102d1b <__alltraps>

c010260d <vector98>:
.globl vector98
vector98:
  pushl $0
c010260d:	6a 00                	push   $0x0
  pushl $98
c010260f:	6a 62                	push   $0x62
  jmp __alltraps
c0102611:	e9 05 07 00 00       	jmp    c0102d1b <__alltraps>

c0102616 <vector99>:
.globl vector99
vector99:
  pushl $0
c0102616:	6a 00                	push   $0x0
  pushl $99
c0102618:	6a 63                	push   $0x63
  jmp __alltraps
c010261a:	e9 fc 06 00 00       	jmp    c0102d1b <__alltraps>

c010261f <vector100>:
.globl vector100
vector100:
  pushl $0
c010261f:	6a 00                	push   $0x0
  pushl $100
c0102621:	6a 64                	push   $0x64
  jmp __alltraps
c0102623:	e9 f3 06 00 00       	jmp    c0102d1b <__alltraps>

c0102628 <vector101>:
.globl vector101
vector101:
  pushl $0
c0102628:	6a 00                	push   $0x0
  pushl $101
c010262a:	6a 65                	push   $0x65
  jmp __alltraps
c010262c:	e9 ea 06 00 00       	jmp    c0102d1b <__alltraps>

c0102631 <vector102>:
.globl vector102
vector102:
  pushl $0
c0102631:	6a 00                	push   $0x0
  pushl $102
c0102633:	6a 66                	push   $0x66
  jmp __alltraps
c0102635:	e9 e1 06 00 00       	jmp    c0102d1b <__alltraps>

c010263a <vector103>:
.globl vector103
vector103:
  pushl $0
c010263a:	6a 00                	push   $0x0
  pushl $103
c010263c:	6a 67                	push   $0x67
  jmp __alltraps
c010263e:	e9 d8 06 00 00       	jmp    c0102d1b <__alltraps>

c0102643 <vector104>:
.globl vector104
vector104:
  pushl $0
c0102643:	6a 00                	push   $0x0
  pushl $104
c0102645:	6a 68                	push   $0x68
  jmp __alltraps
c0102647:	e9 cf 06 00 00       	jmp    c0102d1b <__alltraps>

c010264c <vector105>:
.globl vector105
vector105:
  pushl $0
c010264c:	6a 00                	push   $0x0
  pushl $105
c010264e:	6a 69                	push   $0x69
  jmp __alltraps
c0102650:	e9 c6 06 00 00       	jmp    c0102d1b <__alltraps>

c0102655 <vector106>:
.globl vector106
vector106:
  pushl $0
c0102655:	6a 00                	push   $0x0
  pushl $106
c0102657:	6a 6a                	push   $0x6a
  jmp __alltraps
c0102659:	e9 bd 06 00 00       	jmp    c0102d1b <__alltraps>

c010265e <vector107>:
.globl vector107
vector107:
  pushl $0
c010265e:	6a 00                	push   $0x0
  pushl $107
c0102660:	6a 6b                	push   $0x6b
  jmp __alltraps
c0102662:	e9 b4 06 00 00       	jmp    c0102d1b <__alltraps>

c0102667 <vector108>:
.globl vector108
vector108:
  pushl $0
c0102667:	6a 00                	push   $0x0
  pushl $108
c0102669:	6a 6c                	push   $0x6c
  jmp __alltraps
c010266b:	e9 ab 06 00 00       	jmp    c0102d1b <__alltraps>

c0102670 <vector109>:
.globl vector109
vector109:
  pushl $0
c0102670:	6a 00                	push   $0x0
  pushl $109
c0102672:	6a 6d                	push   $0x6d
  jmp __alltraps
c0102674:	e9 a2 06 00 00       	jmp    c0102d1b <__alltraps>

c0102679 <vector110>:
.globl vector110
vector110:
  pushl $0
c0102679:	6a 00                	push   $0x0
  pushl $110
c010267b:	6a 6e                	push   $0x6e
  jmp __alltraps
c010267d:	e9 99 06 00 00       	jmp    c0102d1b <__alltraps>

c0102682 <vector111>:
.globl vector111
vector111:
  pushl $0
c0102682:	6a 00                	push   $0x0
  pushl $111
c0102684:	6a 6f                	push   $0x6f
  jmp __alltraps
c0102686:	e9 90 06 00 00       	jmp    c0102d1b <__alltraps>

c010268b <vector112>:
.globl vector112
vector112:
  pushl $0
c010268b:	6a 00                	push   $0x0
  pushl $112
c010268d:	6a 70                	push   $0x70
  jmp __alltraps
c010268f:	e9 87 06 00 00       	jmp    c0102d1b <__alltraps>

c0102694 <vector113>:
.globl vector113
vector113:
  pushl $0
c0102694:	6a 00                	push   $0x0
  pushl $113
c0102696:	6a 71                	push   $0x71
  jmp __alltraps
c0102698:	e9 7e 06 00 00       	jmp    c0102d1b <__alltraps>

c010269d <vector114>:
.globl vector114
vector114:
  pushl $0
c010269d:	6a 00                	push   $0x0
  pushl $114
c010269f:	6a 72                	push   $0x72
  jmp __alltraps
c01026a1:	e9 75 06 00 00       	jmp    c0102d1b <__alltraps>

c01026a6 <vector115>:
.globl vector115
vector115:
  pushl $0
c01026a6:	6a 00                	push   $0x0
  pushl $115
c01026a8:	6a 73                	push   $0x73
  jmp __alltraps
c01026aa:	e9 6c 06 00 00       	jmp    c0102d1b <__alltraps>

c01026af <vector116>:
.globl vector116
vector116:
  pushl $0
c01026af:	6a 00                	push   $0x0
  pushl $116
c01026b1:	6a 74                	push   $0x74
  jmp __alltraps
c01026b3:	e9 63 06 00 00       	jmp    c0102d1b <__alltraps>

c01026b8 <vector117>:
.globl vector117
vector117:
  pushl $0
c01026b8:	6a 00                	push   $0x0
  pushl $117
c01026ba:	6a 75                	push   $0x75
  jmp __alltraps
c01026bc:	e9 5a 06 00 00       	jmp    c0102d1b <__alltraps>

c01026c1 <vector118>:
.globl vector118
vector118:
  pushl $0
c01026c1:	6a 00                	push   $0x0
  pushl $118
c01026c3:	6a 76                	push   $0x76
  jmp __alltraps
c01026c5:	e9 51 06 00 00       	jmp    c0102d1b <__alltraps>

c01026ca <vector119>:
.globl vector119
vector119:
  pushl $0
c01026ca:	6a 00                	push   $0x0
  pushl $119
c01026cc:	6a 77                	push   $0x77
  jmp __alltraps
c01026ce:	e9 48 06 00 00       	jmp    c0102d1b <__alltraps>

c01026d3 <vector120>:
.globl vector120
vector120:
  pushl $0
c01026d3:	6a 00                	push   $0x0
  pushl $120
c01026d5:	6a 78                	push   $0x78
  jmp __alltraps
c01026d7:	e9 3f 06 00 00       	jmp    c0102d1b <__alltraps>

c01026dc <vector121>:
.globl vector121
vector121:
  pushl $0
c01026dc:	6a 00                	push   $0x0
  pushl $121
c01026de:	6a 79                	push   $0x79
  jmp __alltraps
c01026e0:	e9 36 06 00 00       	jmp    c0102d1b <__alltraps>

c01026e5 <vector122>:
.globl vector122
vector122:
  pushl $0
c01026e5:	6a 00                	push   $0x0
  pushl $122
c01026e7:	6a 7a                	push   $0x7a
  jmp __alltraps
c01026e9:	e9 2d 06 00 00       	jmp    c0102d1b <__alltraps>

c01026ee <vector123>:
.globl vector123
vector123:
  pushl $0
c01026ee:	6a 00                	push   $0x0
  pushl $123
c01026f0:	6a 7b                	push   $0x7b
  jmp __alltraps
c01026f2:	e9 24 06 00 00       	jmp    c0102d1b <__alltraps>

c01026f7 <vector124>:
.globl vector124
vector124:
  pushl $0
c01026f7:	6a 00                	push   $0x0
  pushl $124
c01026f9:	6a 7c                	push   $0x7c
  jmp __alltraps
c01026fb:	e9 1b 06 00 00       	jmp    c0102d1b <__alltraps>

c0102700 <vector125>:
.globl vector125
vector125:
  pushl $0
c0102700:	6a 00                	push   $0x0
  pushl $125
c0102702:	6a 7d                	push   $0x7d
  jmp __alltraps
c0102704:	e9 12 06 00 00       	jmp    c0102d1b <__alltraps>

c0102709 <vector126>:
.globl vector126
vector126:
  pushl $0
c0102709:	6a 00                	push   $0x0
  pushl $126
c010270b:	6a 7e                	push   $0x7e
  jmp __alltraps
c010270d:	e9 09 06 00 00       	jmp    c0102d1b <__alltraps>

c0102712 <vector127>:
.globl vector127
vector127:
  pushl $0
c0102712:	6a 00                	push   $0x0
  pushl $127
c0102714:	6a 7f                	push   $0x7f
  jmp __alltraps
c0102716:	e9 00 06 00 00       	jmp    c0102d1b <__alltraps>

c010271b <vector128>:
.globl vector128
vector128:
  pushl $0
c010271b:	6a 00                	push   $0x0
  pushl $128
c010271d:	68 80 00 00 00       	push   $0x80
  jmp __alltraps
c0102722:	e9 f4 05 00 00       	jmp    c0102d1b <__alltraps>

c0102727 <vector129>:
.globl vector129
vector129:
  pushl $0
c0102727:	6a 00                	push   $0x0
  pushl $129
c0102729:	68 81 00 00 00       	push   $0x81
  jmp __alltraps
c010272e:	e9 e8 05 00 00       	jmp    c0102d1b <__alltraps>

c0102733 <vector130>:
.globl vector130
vector130:
  pushl $0
c0102733:	6a 00                	push   $0x0
  pushl $130
c0102735:	68 82 00 00 00       	push   $0x82
  jmp __alltraps
c010273a:	e9 dc 05 00 00       	jmp    c0102d1b <__alltraps>

c010273f <vector131>:
.globl vector131
vector131:
  pushl $0
c010273f:	6a 00                	push   $0x0
  pushl $131
c0102741:	68 83 00 00 00       	push   $0x83
  jmp __alltraps
c0102746:	e9 d0 05 00 00       	jmp    c0102d1b <__alltraps>

c010274b <vector132>:
.globl vector132
vector132:
  pushl $0
c010274b:	6a 00                	push   $0x0
  pushl $132
c010274d:	68 84 00 00 00       	push   $0x84
  jmp __alltraps
c0102752:	e9 c4 05 00 00       	jmp    c0102d1b <__alltraps>

c0102757 <vector133>:
.globl vector133
vector133:
  pushl $0
c0102757:	6a 00                	push   $0x0
  pushl $133
c0102759:	68 85 00 00 00       	push   $0x85
  jmp __alltraps
c010275e:	e9 b8 05 00 00       	jmp    c0102d1b <__alltraps>

c0102763 <vector134>:
.globl vector134
vector134:
  pushl $0
c0102763:	6a 00                	push   $0x0
  pushl $134
c0102765:	68 86 00 00 00       	push   $0x86
  jmp __alltraps
c010276a:	e9 ac 05 00 00       	jmp    c0102d1b <__alltraps>

c010276f <vector135>:
.globl vector135
vector135:
  pushl $0
c010276f:	6a 00                	push   $0x0
  pushl $135
c0102771:	68 87 00 00 00       	push   $0x87
  jmp __alltraps
c0102776:	e9 a0 05 00 00       	jmp    c0102d1b <__alltraps>

c010277b <vector136>:
.globl vector136
vector136:
  pushl $0
c010277b:	6a 00                	push   $0x0
  pushl $136
c010277d:	68 88 00 00 00       	push   $0x88
  jmp __alltraps
c0102782:	e9 94 05 00 00       	jmp    c0102d1b <__alltraps>

c0102787 <vector137>:
.globl vector137
vector137:
  pushl $0
c0102787:	6a 00                	push   $0x0
  pushl $137
c0102789:	68 89 00 00 00       	push   $0x89
  jmp __alltraps
c010278e:	e9 88 05 00 00       	jmp    c0102d1b <__alltraps>

c0102793 <vector138>:
.globl vector138
vector138:
  pushl $0
c0102793:	6a 00                	push   $0x0
  pushl $138
c0102795:	68 8a 00 00 00       	push   $0x8a
  jmp __alltraps
c010279a:	e9 7c 05 00 00       	jmp    c0102d1b <__alltraps>

c010279f <vector139>:
.globl vector139
vector139:
  pushl $0
c010279f:	6a 00                	push   $0x0
  pushl $139
c01027a1:	68 8b 00 00 00       	push   $0x8b
  jmp __alltraps
c01027a6:	e9 70 05 00 00       	jmp    c0102d1b <__alltraps>

c01027ab <vector140>:
.globl vector140
vector140:
  pushl $0
c01027ab:	6a 00                	push   $0x0
  pushl $140
c01027ad:	68 8c 00 00 00       	push   $0x8c
  jmp __alltraps
c01027b2:	e9 64 05 00 00       	jmp    c0102d1b <__alltraps>

c01027b7 <vector141>:
.globl vector141
vector141:
  pushl $0
c01027b7:	6a 00                	push   $0x0
  pushl $141
c01027b9:	68 8d 00 00 00       	push   $0x8d
  jmp __alltraps
c01027be:	e9 58 05 00 00       	jmp    c0102d1b <__alltraps>

c01027c3 <vector142>:
.globl vector142
vector142:
  pushl $0
c01027c3:	6a 00                	push   $0x0
  pushl $142
c01027c5:	68 8e 00 00 00       	push   $0x8e
  jmp __alltraps
c01027ca:	e9 4c 05 00 00       	jmp    c0102d1b <__alltraps>

c01027cf <vector143>:
.globl vector143
vector143:
  pushl $0
c01027cf:	6a 00                	push   $0x0
  pushl $143
c01027d1:	68 8f 00 00 00       	push   $0x8f
  jmp __alltraps
c01027d6:	e9 40 05 00 00       	jmp    c0102d1b <__alltraps>

c01027db <vector144>:
.globl vector144
vector144:
  pushl $0
c01027db:	6a 00                	push   $0x0
  pushl $144
c01027dd:	68 90 00 00 00       	push   $0x90
  jmp __alltraps
c01027e2:	e9 34 05 00 00       	jmp    c0102d1b <__alltraps>

c01027e7 <vector145>:
.globl vector145
vector145:
  pushl $0
c01027e7:	6a 00                	push   $0x0
  pushl $145
c01027e9:	68 91 00 00 00       	push   $0x91
  jmp __alltraps
c01027ee:	e9 28 05 00 00       	jmp    c0102d1b <__alltraps>

c01027f3 <vector146>:
.globl vector146
vector146:
  pushl $0
c01027f3:	6a 00                	push   $0x0
  pushl $146
c01027f5:	68 92 00 00 00       	push   $0x92
  jmp __alltraps
c01027fa:	e9 1c 05 00 00       	jmp    c0102d1b <__alltraps>

c01027ff <vector147>:
.globl vector147
vector147:
  pushl $0
c01027ff:	6a 00                	push   $0x0
  pushl $147
c0102801:	68 93 00 00 00       	push   $0x93
  jmp __alltraps
c0102806:	e9 10 05 00 00       	jmp    c0102d1b <__alltraps>

c010280b <vector148>:
.globl vector148
vector148:
  pushl $0
c010280b:	6a 00                	push   $0x0
  pushl $148
c010280d:	68 94 00 00 00       	push   $0x94
  jmp __alltraps
c0102812:	e9 04 05 00 00       	jmp    c0102d1b <__alltraps>

c0102817 <vector149>:
.globl vector149
vector149:
  pushl $0
c0102817:	6a 00                	push   $0x0
  pushl $149
c0102819:	68 95 00 00 00       	push   $0x95
  jmp __alltraps
c010281e:	e9 f8 04 00 00       	jmp    c0102d1b <__alltraps>

c0102823 <vector150>:
.globl vector150
vector150:
  pushl $0
c0102823:	6a 00                	push   $0x0
  pushl $150
c0102825:	68 96 00 00 00       	push   $0x96
  jmp __alltraps
c010282a:	e9 ec 04 00 00       	jmp    c0102d1b <__alltraps>

c010282f <vector151>:
.globl vector151
vector151:
  pushl $0
c010282f:	6a 00                	push   $0x0
  pushl $151
c0102831:	68 97 00 00 00       	push   $0x97
  jmp __alltraps
c0102836:	e9 e0 04 00 00       	jmp    c0102d1b <__alltraps>

c010283b <vector152>:
.globl vector152
vector152:
  pushl $0
c010283b:	6a 00                	push   $0x0
  pushl $152
c010283d:	68 98 00 00 00       	push   $0x98
  jmp __alltraps
c0102842:	e9 d4 04 00 00       	jmp    c0102d1b <__alltraps>

c0102847 <vector153>:
.globl vector153
vector153:
  pushl $0
c0102847:	6a 00                	push   $0x0
  pushl $153
c0102849:	68 99 00 00 00       	push   $0x99
  jmp __alltraps
c010284e:	e9 c8 04 00 00       	jmp    c0102d1b <__alltraps>

c0102853 <vector154>:
.globl vector154
vector154:
  pushl $0
c0102853:	6a 00                	push   $0x0
  pushl $154
c0102855:	68 9a 00 00 00       	push   $0x9a
  jmp __alltraps
c010285a:	e9 bc 04 00 00       	jmp    c0102d1b <__alltraps>

c010285f <vector155>:
.globl vector155
vector155:
  pushl $0
c010285f:	6a 00                	push   $0x0
  pushl $155
c0102861:	68 9b 00 00 00       	push   $0x9b
  jmp __alltraps
c0102866:	e9 b0 04 00 00       	jmp    c0102d1b <__alltraps>

c010286b <vector156>:
.globl vector156
vector156:
  pushl $0
c010286b:	6a 00                	push   $0x0
  pushl $156
c010286d:	68 9c 00 00 00       	push   $0x9c
  jmp __alltraps
c0102872:	e9 a4 04 00 00       	jmp    c0102d1b <__alltraps>

c0102877 <vector157>:
.globl vector157
vector157:
  pushl $0
c0102877:	6a 00                	push   $0x0
  pushl $157
c0102879:	68 9d 00 00 00       	push   $0x9d
  jmp __alltraps
c010287e:	e9 98 04 00 00       	jmp    c0102d1b <__alltraps>

c0102883 <vector158>:
.globl vector158
vector158:
  pushl $0
c0102883:	6a 00                	push   $0x0
  pushl $158
c0102885:	68 9e 00 00 00       	push   $0x9e
  jmp __alltraps
c010288a:	e9 8c 04 00 00       	jmp    c0102d1b <__alltraps>

c010288f <vector159>:
.globl vector159
vector159:
  pushl $0
c010288f:	6a 00                	push   $0x0
  pushl $159
c0102891:	68 9f 00 00 00       	push   $0x9f
  jmp __alltraps
c0102896:	e9 80 04 00 00       	jmp    c0102d1b <__alltraps>

c010289b <vector160>:
.globl vector160
vector160:
  pushl $0
c010289b:	6a 00                	push   $0x0
  pushl $160
c010289d:	68 a0 00 00 00       	push   $0xa0
  jmp __alltraps
c01028a2:	e9 74 04 00 00       	jmp    c0102d1b <__alltraps>

c01028a7 <vector161>:
.globl vector161
vector161:
  pushl $0
c01028a7:	6a 00                	push   $0x0
  pushl $161
c01028a9:	68 a1 00 00 00       	push   $0xa1
  jmp __alltraps
c01028ae:	e9 68 04 00 00       	jmp    c0102d1b <__alltraps>

c01028b3 <vector162>:
.globl vector162
vector162:
  pushl $0
c01028b3:	6a 00                	push   $0x0
  pushl $162
c01028b5:	68 a2 00 00 00       	push   $0xa2
  jmp __alltraps
c01028ba:	e9 5c 04 00 00       	jmp    c0102d1b <__alltraps>

c01028bf <vector163>:
.globl vector163
vector163:
  pushl $0
c01028bf:	6a 00                	push   $0x0
  pushl $163
c01028c1:	68 a3 00 00 00       	push   $0xa3
  jmp __alltraps
c01028c6:	e9 50 04 00 00       	jmp    c0102d1b <__alltraps>

c01028cb <vector164>:
.globl vector164
vector164:
  pushl $0
c01028cb:	6a 00                	push   $0x0
  pushl $164
c01028cd:	68 a4 00 00 00       	push   $0xa4
  jmp __alltraps
c01028d2:	e9 44 04 00 00       	jmp    c0102d1b <__alltraps>

c01028d7 <vector165>:
.globl vector165
vector165:
  pushl $0
c01028d7:	6a 00                	push   $0x0
  pushl $165
c01028d9:	68 a5 00 00 00       	push   $0xa5
  jmp __alltraps
c01028de:	e9 38 04 00 00       	jmp    c0102d1b <__alltraps>

c01028e3 <vector166>:
.globl vector166
vector166:
  pushl $0
c01028e3:	6a 00                	push   $0x0
  pushl $166
c01028e5:	68 a6 00 00 00       	push   $0xa6
  jmp __alltraps
c01028ea:	e9 2c 04 00 00       	jmp    c0102d1b <__alltraps>

c01028ef <vector167>:
.globl vector167
vector167:
  pushl $0
c01028ef:	6a 00                	push   $0x0
  pushl $167
c01028f1:	68 a7 00 00 00       	push   $0xa7
  jmp __alltraps
c01028f6:	e9 20 04 00 00       	jmp    c0102d1b <__alltraps>

c01028fb <vector168>:
.globl vector168
vector168:
  pushl $0
c01028fb:	6a 00                	push   $0x0
  pushl $168
c01028fd:	68 a8 00 00 00       	push   $0xa8
  jmp __alltraps
c0102902:	e9 14 04 00 00       	jmp    c0102d1b <__alltraps>

c0102907 <vector169>:
.globl vector169
vector169:
  pushl $0
c0102907:	6a 00                	push   $0x0
  pushl $169
c0102909:	68 a9 00 00 00       	push   $0xa9
  jmp __alltraps
c010290e:	e9 08 04 00 00       	jmp    c0102d1b <__alltraps>

c0102913 <vector170>:
.globl vector170
vector170:
  pushl $0
c0102913:	6a 00                	push   $0x0
  pushl $170
c0102915:	68 aa 00 00 00       	push   $0xaa
  jmp __alltraps
c010291a:	e9 fc 03 00 00       	jmp    c0102d1b <__alltraps>

c010291f <vector171>:
.globl vector171
vector171:
  pushl $0
c010291f:	6a 00                	push   $0x0
  pushl $171
c0102921:	68 ab 00 00 00       	push   $0xab
  jmp __alltraps
c0102926:	e9 f0 03 00 00       	jmp    c0102d1b <__alltraps>

c010292b <vector172>:
.globl vector172
vector172:
  pushl $0
c010292b:	6a 00                	push   $0x0
  pushl $172
c010292d:	68 ac 00 00 00       	push   $0xac
  jmp __alltraps
c0102932:	e9 e4 03 00 00       	jmp    c0102d1b <__alltraps>

c0102937 <vector173>:
.globl vector173
vector173:
  pushl $0
c0102937:	6a 00                	push   $0x0
  pushl $173
c0102939:	68 ad 00 00 00       	push   $0xad
  jmp __alltraps
c010293e:	e9 d8 03 00 00       	jmp    c0102d1b <__alltraps>

c0102943 <vector174>:
.globl vector174
vector174:
  pushl $0
c0102943:	6a 00                	push   $0x0
  pushl $174
c0102945:	68 ae 00 00 00       	push   $0xae
  jmp __alltraps
c010294a:	e9 cc 03 00 00       	jmp    c0102d1b <__alltraps>

c010294f <vector175>:
.globl vector175
vector175:
  pushl $0
c010294f:	6a 00                	push   $0x0
  pushl $175
c0102951:	68 af 00 00 00       	push   $0xaf
  jmp __alltraps
c0102956:	e9 c0 03 00 00       	jmp    c0102d1b <__alltraps>

c010295b <vector176>:
.globl vector176
vector176:
  pushl $0
c010295b:	6a 00                	push   $0x0
  pushl $176
c010295d:	68 b0 00 00 00       	push   $0xb0
  jmp __alltraps
c0102962:	e9 b4 03 00 00       	jmp    c0102d1b <__alltraps>

c0102967 <vector177>:
.globl vector177
vector177:
  pushl $0
c0102967:	6a 00                	push   $0x0
  pushl $177
c0102969:	68 b1 00 00 00       	push   $0xb1
  jmp __alltraps
c010296e:	e9 a8 03 00 00       	jmp    c0102d1b <__alltraps>

c0102973 <vector178>:
.globl vector178
vector178:
  pushl $0
c0102973:	6a 00                	push   $0x0
  pushl $178
c0102975:	68 b2 00 00 00       	push   $0xb2
  jmp __alltraps
c010297a:	e9 9c 03 00 00       	jmp    c0102d1b <__alltraps>

c010297f <vector179>:
.globl vector179
vector179:
  pushl $0
c010297f:	6a 00                	push   $0x0
  pushl $179
c0102981:	68 b3 00 00 00       	push   $0xb3
  jmp __alltraps
c0102986:	e9 90 03 00 00       	jmp    c0102d1b <__alltraps>

c010298b <vector180>:
.globl vector180
vector180:
  pushl $0
c010298b:	6a 00                	push   $0x0
  pushl $180
c010298d:	68 b4 00 00 00       	push   $0xb4
  jmp __alltraps
c0102992:	e9 84 03 00 00       	jmp    c0102d1b <__alltraps>

c0102997 <vector181>:
.globl vector181
vector181:
  pushl $0
c0102997:	6a 00                	push   $0x0
  pushl $181
c0102999:	68 b5 00 00 00       	push   $0xb5
  jmp __alltraps
c010299e:	e9 78 03 00 00       	jmp    c0102d1b <__alltraps>

c01029a3 <vector182>:
.globl vector182
vector182:
  pushl $0
c01029a3:	6a 00                	push   $0x0
  pushl $182
c01029a5:	68 b6 00 00 00       	push   $0xb6
  jmp __alltraps
c01029aa:	e9 6c 03 00 00       	jmp    c0102d1b <__alltraps>

c01029af <vector183>:
.globl vector183
vector183:
  pushl $0
c01029af:	6a 00                	push   $0x0
  pushl $183
c01029b1:	68 b7 00 00 00       	push   $0xb7
  jmp __alltraps
c01029b6:	e9 60 03 00 00       	jmp    c0102d1b <__alltraps>

c01029bb <vector184>:
.globl vector184
vector184:
  pushl $0
c01029bb:	6a 00                	push   $0x0
  pushl $184
c01029bd:	68 b8 00 00 00       	push   $0xb8
  jmp __alltraps
c01029c2:	e9 54 03 00 00       	jmp    c0102d1b <__alltraps>

c01029c7 <vector185>:
.globl vector185
vector185:
  pushl $0
c01029c7:	6a 00                	push   $0x0
  pushl $185
c01029c9:	68 b9 00 00 00       	push   $0xb9
  jmp __alltraps
c01029ce:	e9 48 03 00 00       	jmp    c0102d1b <__alltraps>

c01029d3 <vector186>:
.globl vector186
vector186:
  pushl $0
c01029d3:	6a 00                	push   $0x0
  pushl $186
c01029d5:	68 ba 00 00 00       	push   $0xba
  jmp __alltraps
c01029da:	e9 3c 03 00 00       	jmp    c0102d1b <__alltraps>

c01029df <vector187>:
.globl vector187
vector187:
  pushl $0
c01029df:	6a 00                	push   $0x0
  pushl $187
c01029e1:	68 bb 00 00 00       	push   $0xbb
  jmp __alltraps
c01029e6:	e9 30 03 00 00       	jmp    c0102d1b <__alltraps>

c01029eb <vector188>:
.globl vector188
vector188:
  pushl $0
c01029eb:	6a 00                	push   $0x0
  pushl $188
c01029ed:	68 bc 00 00 00       	push   $0xbc
  jmp __alltraps
c01029f2:	e9 24 03 00 00       	jmp    c0102d1b <__alltraps>

c01029f7 <vector189>:
.globl vector189
vector189:
  pushl $0
c01029f7:	6a 00                	push   $0x0
  pushl $189
c01029f9:	68 bd 00 00 00       	push   $0xbd
  jmp __alltraps
c01029fe:	e9 18 03 00 00       	jmp    c0102d1b <__alltraps>

c0102a03 <vector190>:
.globl vector190
vector190:
  pushl $0
c0102a03:	6a 00                	push   $0x0
  pushl $190
c0102a05:	68 be 00 00 00       	push   $0xbe
  jmp __alltraps
c0102a0a:	e9 0c 03 00 00       	jmp    c0102d1b <__alltraps>

c0102a0f <vector191>:
.globl vector191
vector191:
  pushl $0
c0102a0f:	6a 00                	push   $0x0
  pushl $191
c0102a11:	68 bf 00 00 00       	push   $0xbf
  jmp __alltraps
c0102a16:	e9 00 03 00 00       	jmp    c0102d1b <__alltraps>

c0102a1b <vector192>:
.globl vector192
vector192:
  pushl $0
c0102a1b:	6a 00                	push   $0x0
  pushl $192
c0102a1d:	68 c0 00 00 00       	push   $0xc0
  jmp __alltraps
c0102a22:	e9 f4 02 00 00       	jmp    c0102d1b <__alltraps>

c0102a27 <vector193>:
.globl vector193
vector193:
  pushl $0
c0102a27:	6a 00                	push   $0x0
  pushl $193
c0102a29:	68 c1 00 00 00       	push   $0xc1
  jmp __alltraps
c0102a2e:	e9 e8 02 00 00       	jmp    c0102d1b <__alltraps>

c0102a33 <vector194>:
.globl vector194
vector194:
  pushl $0
c0102a33:	6a 00                	push   $0x0
  pushl $194
c0102a35:	68 c2 00 00 00       	push   $0xc2
  jmp __alltraps
c0102a3a:	e9 dc 02 00 00       	jmp    c0102d1b <__alltraps>

c0102a3f <vector195>:
.globl vector195
vector195:
  pushl $0
c0102a3f:	6a 00                	push   $0x0
  pushl $195
c0102a41:	68 c3 00 00 00       	push   $0xc3
  jmp __alltraps
c0102a46:	e9 d0 02 00 00       	jmp    c0102d1b <__alltraps>

c0102a4b <vector196>:
.globl vector196
vector196:
  pushl $0
c0102a4b:	6a 00                	push   $0x0
  pushl $196
c0102a4d:	68 c4 00 00 00       	push   $0xc4
  jmp __alltraps
c0102a52:	e9 c4 02 00 00       	jmp    c0102d1b <__alltraps>

c0102a57 <vector197>:
.globl vector197
vector197:
  pushl $0
c0102a57:	6a 00                	push   $0x0
  pushl $197
c0102a59:	68 c5 00 00 00       	push   $0xc5
  jmp __alltraps
c0102a5e:	e9 b8 02 00 00       	jmp    c0102d1b <__alltraps>

c0102a63 <vector198>:
.globl vector198
vector198:
  pushl $0
c0102a63:	6a 00                	push   $0x0
  pushl $198
c0102a65:	68 c6 00 00 00       	push   $0xc6
  jmp __alltraps
c0102a6a:	e9 ac 02 00 00       	jmp    c0102d1b <__alltraps>

c0102a6f <vector199>:
.globl vector199
vector199:
  pushl $0
c0102a6f:	6a 00                	push   $0x0
  pushl $199
c0102a71:	68 c7 00 00 00       	push   $0xc7
  jmp __alltraps
c0102a76:	e9 a0 02 00 00       	jmp    c0102d1b <__alltraps>

c0102a7b <vector200>:
.globl vector200
vector200:
  pushl $0
c0102a7b:	6a 00                	push   $0x0
  pushl $200
c0102a7d:	68 c8 00 00 00       	push   $0xc8
  jmp __alltraps
c0102a82:	e9 94 02 00 00       	jmp    c0102d1b <__alltraps>

c0102a87 <vector201>:
.globl vector201
vector201:
  pushl $0
c0102a87:	6a 00                	push   $0x0
  pushl $201
c0102a89:	68 c9 00 00 00       	push   $0xc9
  jmp __alltraps
c0102a8e:	e9 88 02 00 00       	jmp    c0102d1b <__alltraps>

c0102a93 <vector202>:
.globl vector202
vector202:
  pushl $0
c0102a93:	6a 00                	push   $0x0
  pushl $202
c0102a95:	68 ca 00 00 00       	push   $0xca
  jmp __alltraps
c0102a9a:	e9 7c 02 00 00       	jmp    c0102d1b <__alltraps>

c0102a9f <vector203>:
.globl vector203
vector203:
  pushl $0
c0102a9f:	6a 00                	push   $0x0
  pushl $203
c0102aa1:	68 cb 00 00 00       	push   $0xcb
  jmp __alltraps
c0102aa6:	e9 70 02 00 00       	jmp    c0102d1b <__alltraps>

c0102aab <vector204>:
.globl vector204
vector204:
  pushl $0
c0102aab:	6a 00                	push   $0x0
  pushl $204
c0102aad:	68 cc 00 00 00       	push   $0xcc
  jmp __alltraps
c0102ab2:	e9 64 02 00 00       	jmp    c0102d1b <__alltraps>

c0102ab7 <vector205>:
.globl vector205
vector205:
  pushl $0
c0102ab7:	6a 00                	push   $0x0
  pushl $205
c0102ab9:	68 cd 00 00 00       	push   $0xcd
  jmp __alltraps
c0102abe:	e9 58 02 00 00       	jmp    c0102d1b <__alltraps>

c0102ac3 <vector206>:
.globl vector206
vector206:
  pushl $0
c0102ac3:	6a 00                	push   $0x0
  pushl $206
c0102ac5:	68 ce 00 00 00       	push   $0xce
  jmp __alltraps
c0102aca:	e9 4c 02 00 00       	jmp    c0102d1b <__alltraps>

c0102acf <vector207>:
.globl vector207
vector207:
  pushl $0
c0102acf:	6a 00                	push   $0x0
  pushl $207
c0102ad1:	68 cf 00 00 00       	push   $0xcf
  jmp __alltraps
c0102ad6:	e9 40 02 00 00       	jmp    c0102d1b <__alltraps>

c0102adb <vector208>:
.globl vector208
vector208:
  pushl $0
c0102adb:	6a 00                	push   $0x0
  pushl $208
c0102add:	68 d0 00 00 00       	push   $0xd0
  jmp __alltraps
c0102ae2:	e9 34 02 00 00       	jmp    c0102d1b <__alltraps>

c0102ae7 <vector209>:
.globl vector209
vector209:
  pushl $0
c0102ae7:	6a 00                	push   $0x0
  pushl $209
c0102ae9:	68 d1 00 00 00       	push   $0xd1
  jmp __alltraps
c0102aee:	e9 28 02 00 00       	jmp    c0102d1b <__alltraps>

c0102af3 <vector210>:
.globl vector210
vector210:
  pushl $0
c0102af3:	6a 00                	push   $0x0
  pushl $210
c0102af5:	68 d2 00 00 00       	push   $0xd2
  jmp __alltraps
c0102afa:	e9 1c 02 00 00       	jmp    c0102d1b <__alltraps>

c0102aff <vector211>:
.globl vector211
vector211:
  pushl $0
c0102aff:	6a 00                	push   $0x0
  pushl $211
c0102b01:	68 d3 00 00 00       	push   $0xd3
  jmp __alltraps
c0102b06:	e9 10 02 00 00       	jmp    c0102d1b <__alltraps>

c0102b0b <vector212>:
.globl vector212
vector212:
  pushl $0
c0102b0b:	6a 00                	push   $0x0
  pushl $212
c0102b0d:	68 d4 00 00 00       	push   $0xd4
  jmp __alltraps
c0102b12:	e9 04 02 00 00       	jmp    c0102d1b <__alltraps>

c0102b17 <vector213>:
.globl vector213
vector213:
  pushl $0
c0102b17:	6a 00                	push   $0x0
  pushl $213
c0102b19:	68 d5 00 00 00       	push   $0xd5
  jmp __alltraps
c0102b1e:	e9 f8 01 00 00       	jmp    c0102d1b <__alltraps>

c0102b23 <vector214>:
.globl vector214
vector214:
  pushl $0
c0102b23:	6a 00                	push   $0x0
  pushl $214
c0102b25:	68 d6 00 00 00       	push   $0xd6
  jmp __alltraps
c0102b2a:	e9 ec 01 00 00       	jmp    c0102d1b <__alltraps>

c0102b2f <vector215>:
.globl vector215
vector215:
  pushl $0
c0102b2f:	6a 00                	push   $0x0
  pushl $215
c0102b31:	68 d7 00 00 00       	push   $0xd7
  jmp __alltraps
c0102b36:	e9 e0 01 00 00       	jmp    c0102d1b <__alltraps>

c0102b3b <vector216>:
.globl vector216
vector216:
  pushl $0
c0102b3b:	6a 00                	push   $0x0
  pushl $216
c0102b3d:	68 d8 00 00 00       	push   $0xd8
  jmp __alltraps
c0102b42:	e9 d4 01 00 00       	jmp    c0102d1b <__alltraps>

c0102b47 <vector217>:
.globl vector217
vector217:
  pushl $0
c0102b47:	6a 00                	push   $0x0
  pushl $217
c0102b49:	68 d9 00 00 00       	push   $0xd9
  jmp __alltraps
c0102b4e:	e9 c8 01 00 00       	jmp    c0102d1b <__alltraps>

c0102b53 <vector218>:
.globl vector218
vector218:
  pushl $0
c0102b53:	6a 00                	push   $0x0
  pushl $218
c0102b55:	68 da 00 00 00       	push   $0xda
  jmp __alltraps
c0102b5a:	e9 bc 01 00 00       	jmp    c0102d1b <__alltraps>

c0102b5f <vector219>:
.globl vector219
vector219:
  pushl $0
c0102b5f:	6a 00                	push   $0x0
  pushl $219
c0102b61:	68 db 00 00 00       	push   $0xdb
  jmp __alltraps
c0102b66:	e9 b0 01 00 00       	jmp    c0102d1b <__alltraps>

c0102b6b <vector220>:
.globl vector220
vector220:
  pushl $0
c0102b6b:	6a 00                	push   $0x0
  pushl $220
c0102b6d:	68 dc 00 00 00       	push   $0xdc
  jmp __alltraps
c0102b72:	e9 a4 01 00 00       	jmp    c0102d1b <__alltraps>

c0102b77 <vector221>:
.globl vector221
vector221:
  pushl $0
c0102b77:	6a 00                	push   $0x0
  pushl $221
c0102b79:	68 dd 00 00 00       	push   $0xdd
  jmp __alltraps
c0102b7e:	e9 98 01 00 00       	jmp    c0102d1b <__alltraps>

c0102b83 <vector222>:
.globl vector222
vector222:
  pushl $0
c0102b83:	6a 00                	push   $0x0
  pushl $222
c0102b85:	68 de 00 00 00       	push   $0xde
  jmp __alltraps
c0102b8a:	e9 8c 01 00 00       	jmp    c0102d1b <__alltraps>

c0102b8f <vector223>:
.globl vector223
vector223:
  pushl $0
c0102b8f:	6a 00                	push   $0x0
  pushl $223
c0102b91:	68 df 00 00 00       	push   $0xdf
  jmp __alltraps
c0102b96:	e9 80 01 00 00       	jmp    c0102d1b <__alltraps>

c0102b9b <vector224>:
.globl vector224
vector224:
  pushl $0
c0102b9b:	6a 00                	push   $0x0
  pushl $224
c0102b9d:	68 e0 00 00 00       	push   $0xe0
  jmp __alltraps
c0102ba2:	e9 74 01 00 00       	jmp    c0102d1b <__alltraps>

c0102ba7 <vector225>:
.globl vector225
vector225:
  pushl $0
c0102ba7:	6a 00                	push   $0x0
  pushl $225
c0102ba9:	68 e1 00 00 00       	push   $0xe1
  jmp __alltraps
c0102bae:	e9 68 01 00 00       	jmp    c0102d1b <__alltraps>

c0102bb3 <vector226>:
.globl vector226
vector226:
  pushl $0
c0102bb3:	6a 00                	push   $0x0
  pushl $226
c0102bb5:	68 e2 00 00 00       	push   $0xe2
  jmp __alltraps
c0102bba:	e9 5c 01 00 00       	jmp    c0102d1b <__alltraps>

c0102bbf <vector227>:
.globl vector227
vector227:
  pushl $0
c0102bbf:	6a 00                	push   $0x0
  pushl $227
c0102bc1:	68 e3 00 00 00       	push   $0xe3
  jmp __alltraps
c0102bc6:	e9 50 01 00 00       	jmp    c0102d1b <__alltraps>

c0102bcb <vector228>:
.globl vector228
vector228:
  pushl $0
c0102bcb:	6a 00                	push   $0x0
  pushl $228
c0102bcd:	68 e4 00 00 00       	push   $0xe4
  jmp __alltraps
c0102bd2:	e9 44 01 00 00       	jmp    c0102d1b <__alltraps>

c0102bd7 <vector229>:
.globl vector229
vector229:
  pushl $0
c0102bd7:	6a 00                	push   $0x0
  pushl $229
c0102bd9:	68 e5 00 00 00       	push   $0xe5
  jmp __alltraps
c0102bde:	e9 38 01 00 00       	jmp    c0102d1b <__alltraps>

c0102be3 <vector230>:
.globl vector230
vector230:
  pushl $0
c0102be3:	6a 00                	push   $0x0
  pushl $230
c0102be5:	68 e6 00 00 00       	push   $0xe6
  jmp __alltraps
c0102bea:	e9 2c 01 00 00       	jmp    c0102d1b <__alltraps>

c0102bef <vector231>:
.globl vector231
vector231:
  pushl $0
c0102bef:	6a 00                	push   $0x0
  pushl $231
c0102bf1:	68 e7 00 00 00       	push   $0xe7
  jmp __alltraps
c0102bf6:	e9 20 01 00 00       	jmp    c0102d1b <__alltraps>

c0102bfb <vector232>:
.globl vector232
vector232:
  pushl $0
c0102bfb:	6a 00                	push   $0x0
  pushl $232
c0102bfd:	68 e8 00 00 00       	push   $0xe8
  jmp __alltraps
c0102c02:	e9 14 01 00 00       	jmp    c0102d1b <__alltraps>

c0102c07 <vector233>:
.globl vector233
vector233:
  pushl $0
c0102c07:	6a 00                	push   $0x0
  pushl $233
c0102c09:	68 e9 00 00 00       	push   $0xe9
  jmp __alltraps
c0102c0e:	e9 08 01 00 00       	jmp    c0102d1b <__alltraps>

c0102c13 <vector234>:
.globl vector234
vector234:
  pushl $0
c0102c13:	6a 00                	push   $0x0
  pushl $234
c0102c15:	68 ea 00 00 00       	push   $0xea
  jmp __alltraps
c0102c1a:	e9 fc 00 00 00       	jmp    c0102d1b <__alltraps>

c0102c1f <vector235>:
.globl vector235
vector235:
  pushl $0
c0102c1f:	6a 00                	push   $0x0
  pushl $235
c0102c21:	68 eb 00 00 00       	push   $0xeb
  jmp __alltraps
c0102c26:	e9 f0 00 00 00       	jmp    c0102d1b <__alltraps>

c0102c2b <vector236>:
.globl vector236
vector236:
  pushl $0
c0102c2b:	6a 00                	push   $0x0
  pushl $236
c0102c2d:	68 ec 00 00 00       	push   $0xec
  jmp __alltraps
c0102c32:	e9 e4 00 00 00       	jmp    c0102d1b <__alltraps>

c0102c37 <vector237>:
.globl vector237
vector237:
  pushl $0
c0102c37:	6a 00                	push   $0x0
  pushl $237
c0102c39:	68 ed 00 00 00       	push   $0xed
  jmp __alltraps
c0102c3e:	e9 d8 00 00 00       	jmp    c0102d1b <__alltraps>

c0102c43 <vector238>:
.globl vector238
vector238:
  pushl $0
c0102c43:	6a 00                	push   $0x0
  pushl $238
c0102c45:	68 ee 00 00 00       	push   $0xee
  jmp __alltraps
c0102c4a:	e9 cc 00 00 00       	jmp    c0102d1b <__alltraps>

c0102c4f <vector239>:
.globl vector239
vector239:
  pushl $0
c0102c4f:	6a 00                	push   $0x0
  pushl $239
c0102c51:	68 ef 00 00 00       	push   $0xef
  jmp __alltraps
c0102c56:	e9 c0 00 00 00       	jmp    c0102d1b <__alltraps>

c0102c5b <vector240>:
.globl vector240
vector240:
  pushl $0
c0102c5b:	6a 00                	push   $0x0
  pushl $240
c0102c5d:	68 f0 00 00 00       	push   $0xf0
  jmp __alltraps
c0102c62:	e9 b4 00 00 00       	jmp    c0102d1b <__alltraps>

c0102c67 <vector241>:
.globl vector241
vector241:
  pushl $0
c0102c67:	6a 00                	push   $0x0
  pushl $241
c0102c69:	68 f1 00 00 00       	push   $0xf1
  jmp __alltraps
c0102c6e:	e9 a8 00 00 00       	jmp    c0102d1b <__alltraps>

c0102c73 <vector242>:
.globl vector242
vector242:
  pushl $0
c0102c73:	6a 00                	push   $0x0
  pushl $242
c0102c75:	68 f2 00 00 00       	push   $0xf2
  jmp __alltraps
c0102c7a:	e9 9c 00 00 00       	jmp    c0102d1b <__alltraps>

c0102c7f <vector243>:
.globl vector243
vector243:
  pushl $0
c0102c7f:	6a 00                	push   $0x0
  pushl $243
c0102c81:	68 f3 00 00 00       	push   $0xf3
  jmp __alltraps
c0102c86:	e9 90 00 00 00       	jmp    c0102d1b <__alltraps>

c0102c8b <vector244>:
.globl vector244
vector244:
  pushl $0
c0102c8b:	6a 00                	push   $0x0
  pushl $244
c0102c8d:	68 f4 00 00 00       	push   $0xf4
  jmp __alltraps
c0102c92:	e9 84 00 00 00       	jmp    c0102d1b <__alltraps>

c0102c97 <vector245>:
.globl vector245
vector245:
  pushl $0
c0102c97:	6a 00                	push   $0x0
  pushl $245
c0102c99:	68 f5 00 00 00       	push   $0xf5
  jmp __alltraps
c0102c9e:	e9 78 00 00 00       	jmp    c0102d1b <__alltraps>

c0102ca3 <vector246>:
.globl vector246
vector246:
  pushl $0
c0102ca3:	6a 00                	push   $0x0
  pushl $246
c0102ca5:	68 f6 00 00 00       	push   $0xf6
  jmp __alltraps
c0102caa:	e9 6c 00 00 00       	jmp    c0102d1b <__alltraps>

c0102caf <vector247>:
.globl vector247
vector247:
  pushl $0
c0102caf:	6a 00                	push   $0x0
  pushl $247
c0102cb1:	68 f7 00 00 00       	push   $0xf7
  jmp __alltraps
c0102cb6:	e9 60 00 00 00       	jmp    c0102d1b <__alltraps>

c0102cbb <vector248>:
.globl vector248
vector248:
  pushl $0
c0102cbb:	6a 00                	push   $0x0
  pushl $248
c0102cbd:	68 f8 00 00 00       	push   $0xf8
  jmp __alltraps
c0102cc2:	e9 54 00 00 00       	jmp    c0102d1b <__alltraps>

c0102cc7 <vector249>:
.globl vector249
vector249:
  pushl $0
c0102cc7:	6a 00                	push   $0x0
  pushl $249
c0102cc9:	68 f9 00 00 00       	push   $0xf9
  jmp __alltraps
c0102cce:	e9 48 00 00 00       	jmp    c0102d1b <__alltraps>

c0102cd3 <vector250>:
.globl vector250
vector250:
  pushl $0
c0102cd3:	6a 00                	push   $0x0
  pushl $250
c0102cd5:	68 fa 00 00 00       	push   $0xfa
  jmp __alltraps
c0102cda:	e9 3c 00 00 00       	jmp    c0102d1b <__alltraps>

c0102cdf <vector251>:
.globl vector251
vector251:
  pushl $0
c0102cdf:	6a 00                	push   $0x0
  pushl $251
c0102ce1:	68 fb 00 00 00       	push   $0xfb
  jmp __alltraps
c0102ce6:	e9 30 00 00 00       	jmp    c0102d1b <__alltraps>

c0102ceb <vector252>:
.globl vector252
vector252:
  pushl $0
c0102ceb:	6a 00                	push   $0x0
  pushl $252
c0102ced:	68 fc 00 00 00       	push   $0xfc
  jmp __alltraps
c0102cf2:	e9 24 00 00 00       	jmp    c0102d1b <__alltraps>

c0102cf7 <vector253>:
.globl vector253
vector253:
  pushl $0
c0102cf7:	6a 00                	push   $0x0
  pushl $253
c0102cf9:	68 fd 00 00 00       	push   $0xfd
  jmp __alltraps
c0102cfe:	e9 18 00 00 00       	jmp    c0102d1b <__alltraps>

c0102d03 <vector254>:
.globl vector254
vector254:
  pushl $0
c0102d03:	6a 00                	push   $0x0
  pushl $254
c0102d05:	68 fe 00 00 00       	push   $0xfe
  jmp __alltraps
c0102d0a:	e9 0c 00 00 00       	jmp    c0102d1b <__alltraps>

c0102d0f <vector255>:
.globl vector255
vector255:
  pushl $0
c0102d0f:	6a 00                	push   $0x0
  pushl $255
c0102d11:	68 ff 00 00 00       	push   $0xff
  jmp __alltraps
c0102d16:	e9 00 00 00 00       	jmp    c0102d1b <__alltraps>

c0102d1b <__alltraps>:
.text
.globl __alltraps
__alltraps:
    # push registers to build a trap frame
    # therefore make the stack look like a struct trapframe
    pushl %ds
c0102d1b:	1e                   	push   %ds
    pushl %es
c0102d1c:	06                   	push   %es
    pushl %fs
c0102d1d:	0f a0                	push   %fs
    pushl %gs
c0102d1f:	0f a8                	push   %gs
    pushal
c0102d21:	60                   	pusha  

    # load GD_KDATA into %ds and %es to set up data segments for kernel
    movl $GD_KDATA, %eax
c0102d22:	b8 10 00 00 00       	mov    $0x10,%eax
    movw %ax, %ds
c0102d27:	8e d8                	mov    %eax,%ds
    movw %ax, %es
c0102d29:	8e c0                	mov    %eax,%es

    # push %esp to pass a pointer to the trapframe as an argument to trap()
    pushl %esp
c0102d2b:	54                   	push   %esp

    # call trap(tf), where tf=%esp
    call trap
c0102d2c:	e8 60 f5 ff ff       	call   c0102291 <trap>

    # pop the pushed stack pointer
    popl %esp
c0102d31:	5c                   	pop    %esp

c0102d32 <__trapret>:

    # return falls through to trapret...
.globl __trapret
__trapret:
    # restore registers from stack
    popal
c0102d32:	61                   	popa   

    # restore %ds, %es, %fs and %gs
    popl %gs
c0102d33:	0f a9                	pop    %gs
    popl %fs
c0102d35:	0f a1                	pop    %fs
    popl %es
c0102d37:	07                   	pop    %es
    popl %ds
c0102d38:	1f                   	pop    %ds

    # get rid of the trap number and error code
    addl $0x8, %esp
c0102d39:	83 c4 08             	add    $0x8,%esp
    iret
c0102d3c:	cf                   	iret   

c0102d3d <page2ppn>:

extern struct Page *pages;
extern size_t npage;

static inline ppn_t
page2ppn(struct Page *page) {
c0102d3d:	55                   	push   %ebp
c0102d3e:	89 e5                	mov    %esp,%ebp
    return page - pages;
c0102d40:	a1 78 df 11 c0       	mov    0xc011df78,%eax
c0102d45:	8b 55 08             	mov    0x8(%ebp),%edx
c0102d48:	29 c2                	sub    %eax,%edx
c0102d4a:	89 d0                	mov    %edx,%eax
c0102d4c:	c1 f8 02             	sar    $0x2,%eax
c0102d4f:	69 c0 cd cc cc cc    	imul   $0xcccccccd,%eax,%eax
}
c0102d55:	5d                   	pop    %ebp
c0102d56:	c3                   	ret    

c0102d57 <page2pa>:

static inline uintptr_t
page2pa(struct Page *page) {
c0102d57:	55                   	push   %ebp
c0102d58:	89 e5                	mov    %esp,%ebp
c0102d5a:	83 ec 04             	sub    $0x4,%esp
    return page2ppn(page) << PGSHIFT;
c0102d5d:	8b 45 08             	mov    0x8(%ebp),%eax
c0102d60:	89 04 24             	mov    %eax,(%esp)
c0102d63:	e8 d5 ff ff ff       	call   c0102d3d <page2ppn>
c0102d68:	c1 e0 0c             	shl    $0xc,%eax
}
c0102d6b:	c9                   	leave  
c0102d6c:	c3                   	ret    

c0102d6d <pa2page>:

static inline struct Page *
pa2page(uintptr_t pa) {
c0102d6d:	55                   	push   %ebp
c0102d6e:	89 e5                	mov    %esp,%ebp
c0102d70:	83 ec 18             	sub    $0x18,%esp
    if (PPN(pa) >= npage) {
c0102d73:	8b 45 08             	mov    0x8(%ebp),%eax
c0102d76:	c1 e8 0c             	shr    $0xc,%eax
c0102d79:	89 c2                	mov    %eax,%edx
c0102d7b:	a1 80 de 11 c0       	mov    0xc011de80,%eax
c0102d80:	39 c2                	cmp    %eax,%edx
c0102d82:	72 1c                	jb     c0102da0 <pa2page+0x33>
        panic("pa2page called with invalid pa");
c0102d84:	c7 44 24 08 d0 6c 10 	movl   $0xc0106cd0,0x8(%esp)
c0102d8b:	c0 
c0102d8c:	c7 44 24 04 5a 00 00 	movl   $0x5a,0x4(%esp)
c0102d93:	00 
c0102d94:	c7 04 24 ef 6c 10 c0 	movl   $0xc0106cef,(%esp)
c0102d9b:	e8 91 d6 ff ff       	call   c0100431 <__panic>
    }
    return &pages[PPN(pa)];
c0102da0:	8b 0d 78 df 11 c0    	mov    0xc011df78,%ecx
c0102da6:	8b 45 08             	mov    0x8(%ebp),%eax
c0102da9:	c1 e8 0c             	shr    $0xc,%eax
c0102dac:	89 c2                	mov    %eax,%edx
c0102dae:	89 d0                	mov    %edx,%eax
c0102db0:	c1 e0 02             	shl    $0x2,%eax
c0102db3:	01 d0                	add    %edx,%eax
c0102db5:	c1 e0 02             	shl    $0x2,%eax
c0102db8:	01 c8                	add    %ecx,%eax
}
c0102dba:	c9                   	leave  
c0102dbb:	c3                   	ret    

c0102dbc <page2kva>:

static inline void *
page2kva(struct Page *page) {
c0102dbc:	55                   	push   %ebp
c0102dbd:	89 e5                	mov    %esp,%ebp
c0102dbf:	83 ec 28             	sub    $0x28,%esp
    return KADDR(page2pa(page));
c0102dc2:	8b 45 08             	mov    0x8(%ebp),%eax
c0102dc5:	89 04 24             	mov    %eax,(%esp)
c0102dc8:	e8 8a ff ff ff       	call   c0102d57 <page2pa>
c0102dcd:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0102dd0:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102dd3:	c1 e8 0c             	shr    $0xc,%eax
c0102dd6:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0102dd9:	a1 80 de 11 c0       	mov    0xc011de80,%eax
c0102dde:	39 45 f0             	cmp    %eax,-0x10(%ebp)
c0102de1:	72 23                	jb     c0102e06 <page2kva+0x4a>
c0102de3:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102de6:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0102dea:	c7 44 24 08 00 6d 10 	movl   $0xc0106d00,0x8(%esp)
c0102df1:	c0 
c0102df2:	c7 44 24 04 61 00 00 	movl   $0x61,0x4(%esp)
c0102df9:	00 
c0102dfa:	c7 04 24 ef 6c 10 c0 	movl   $0xc0106cef,(%esp)
c0102e01:	e8 2b d6 ff ff       	call   c0100431 <__panic>
c0102e06:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102e09:	2d 00 00 00 40       	sub    $0x40000000,%eax
}
c0102e0e:	c9                   	leave  
c0102e0f:	c3                   	ret    

c0102e10 <pte2page>:
kva2page(void *kva) {
    return pa2page(PADDR(kva));
}

static inline struct Page *
pte2page(pte_t pte) {
c0102e10:	55                   	push   %ebp
c0102e11:	89 e5                	mov    %esp,%ebp
c0102e13:	83 ec 18             	sub    $0x18,%esp
    if (!(pte & PTE_P)) {
c0102e16:	8b 45 08             	mov    0x8(%ebp),%eax
c0102e19:	83 e0 01             	and    $0x1,%eax
c0102e1c:	85 c0                	test   %eax,%eax
c0102e1e:	75 1c                	jne    c0102e3c <pte2page+0x2c>
        panic("pte2page called with invalid pte");
c0102e20:	c7 44 24 08 24 6d 10 	movl   $0xc0106d24,0x8(%esp)
c0102e27:	c0 
c0102e28:	c7 44 24 04 6c 00 00 	movl   $0x6c,0x4(%esp)
c0102e2f:	00 
c0102e30:	c7 04 24 ef 6c 10 c0 	movl   $0xc0106cef,(%esp)
c0102e37:	e8 f5 d5 ff ff       	call   c0100431 <__panic>
    }
    return pa2page(PTE_ADDR(pte));
c0102e3c:	8b 45 08             	mov    0x8(%ebp),%eax
c0102e3f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0102e44:	89 04 24             	mov    %eax,(%esp)
c0102e47:	e8 21 ff ff ff       	call   c0102d6d <pa2page>
}
c0102e4c:	c9                   	leave  
c0102e4d:	c3                   	ret    

c0102e4e <pde2page>:

static inline struct Page *
pde2page(pde_t pde) {
c0102e4e:	55                   	push   %ebp
c0102e4f:	89 e5                	mov    %esp,%ebp
c0102e51:	83 ec 18             	sub    $0x18,%esp
    return pa2page(PDE_ADDR(pde));
c0102e54:	8b 45 08             	mov    0x8(%ebp),%eax
c0102e57:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0102e5c:	89 04 24             	mov    %eax,(%esp)
c0102e5f:	e8 09 ff ff ff       	call   c0102d6d <pa2page>
}
c0102e64:	c9                   	leave  
c0102e65:	c3                   	ret    

c0102e66 <page_ref>:

static inline int
page_ref(struct Page *page) {
c0102e66:	55                   	push   %ebp
c0102e67:	89 e5                	mov    %esp,%ebp
    return page->ref;
c0102e69:	8b 45 08             	mov    0x8(%ebp),%eax
c0102e6c:	8b 00                	mov    (%eax),%eax
}
c0102e6e:	5d                   	pop    %ebp
c0102e6f:	c3                   	ret    

c0102e70 <set_page_ref>:

static inline void
set_page_ref(struct Page *page, int val) {
c0102e70:	55                   	push   %ebp
c0102e71:	89 e5                	mov    %esp,%ebp
    page->ref = val;
c0102e73:	8b 45 08             	mov    0x8(%ebp),%eax
c0102e76:	8b 55 0c             	mov    0xc(%ebp),%edx
c0102e79:	89 10                	mov    %edx,(%eax)
}
c0102e7b:	90                   	nop
c0102e7c:	5d                   	pop    %ebp
c0102e7d:	c3                   	ret    

c0102e7e <page_ref_inc>:

static inline int
page_ref_inc(struct Page *page) {
c0102e7e:	55                   	push   %ebp
c0102e7f:	89 e5                	mov    %esp,%ebp
    page->ref += 1;
c0102e81:	8b 45 08             	mov    0x8(%ebp),%eax
c0102e84:	8b 00                	mov    (%eax),%eax
c0102e86:	8d 50 01             	lea    0x1(%eax),%edx
c0102e89:	8b 45 08             	mov    0x8(%ebp),%eax
c0102e8c:	89 10                	mov    %edx,(%eax)
    return page->ref;
c0102e8e:	8b 45 08             	mov    0x8(%ebp),%eax
c0102e91:	8b 00                	mov    (%eax),%eax
}
c0102e93:	5d                   	pop    %ebp
c0102e94:	c3                   	ret    

c0102e95 <page_ref_dec>:

static inline int
page_ref_dec(struct Page *page) {
c0102e95:	55                   	push   %ebp
c0102e96:	89 e5                	mov    %esp,%ebp
    page->ref -= 1;
c0102e98:	8b 45 08             	mov    0x8(%ebp),%eax
c0102e9b:	8b 00                	mov    (%eax),%eax
c0102e9d:	8d 50 ff             	lea    -0x1(%eax),%edx
c0102ea0:	8b 45 08             	mov    0x8(%ebp),%eax
c0102ea3:	89 10                	mov    %edx,(%eax)
    return page->ref;
c0102ea5:	8b 45 08             	mov    0x8(%ebp),%eax
c0102ea8:	8b 00                	mov    (%eax),%eax
}
c0102eaa:	5d                   	pop    %ebp
c0102eab:	c3                   	ret    

c0102eac <__intr_save>:
__intr_save(void) {
c0102eac:	55                   	push   %ebp
c0102ead:	89 e5                	mov    %esp,%ebp
c0102eaf:	83 ec 18             	sub    $0x18,%esp
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
c0102eb2:	9c                   	pushf  
c0102eb3:	58                   	pop    %eax
c0102eb4:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return eflags;
c0102eb7:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
c0102eba:	25 00 02 00 00       	and    $0x200,%eax
c0102ebf:	85 c0                	test   %eax,%eax
c0102ec1:	74 0c                	je     c0102ecf <__intr_save+0x23>
        intr_disable();
c0102ec3:	e8 c1 ea ff ff       	call   c0101989 <intr_disable>
        return 1;
c0102ec8:	b8 01 00 00 00       	mov    $0x1,%eax
c0102ecd:	eb 05                	jmp    c0102ed4 <__intr_save+0x28>
    return 0;
c0102ecf:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0102ed4:	c9                   	leave  
c0102ed5:	c3                   	ret    

c0102ed6 <__intr_restore>:
__intr_restore(bool flag) {
c0102ed6:	55                   	push   %ebp
c0102ed7:	89 e5                	mov    %esp,%ebp
c0102ed9:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
c0102edc:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0102ee0:	74 05                	je     c0102ee7 <__intr_restore+0x11>
        intr_enable();
c0102ee2:	e8 96 ea ff ff       	call   c010197d <intr_enable>
}
c0102ee7:	90                   	nop
c0102ee8:	c9                   	leave  
c0102ee9:	c3                   	ret    

c0102eea <lgdt>:
/* *
 * lgdt - load the global descriptor table register and reset the
 * data/code segement registers for kernel.
 * */
static inline void
lgdt(struct pseudodesc *pd) {
c0102eea:	55                   	push   %ebp
c0102eeb:	89 e5                	mov    %esp,%ebp
    asm volatile ("lgdt (%0)" :: "r" (pd));
c0102eed:	8b 45 08             	mov    0x8(%ebp),%eax
c0102ef0:	0f 01 10             	lgdtl  (%eax)
    asm volatile ("movw %%ax, %%gs" :: "a" (USER_DS));
c0102ef3:	b8 23 00 00 00       	mov    $0x23,%eax
c0102ef8:	8e e8                	mov    %eax,%gs
    asm volatile ("movw %%ax, %%fs" :: "a" (USER_DS));
c0102efa:	b8 23 00 00 00       	mov    $0x23,%eax
c0102eff:	8e e0                	mov    %eax,%fs
    asm volatile ("movw %%ax, %%es" :: "a" (KERNEL_DS));
c0102f01:	b8 10 00 00 00       	mov    $0x10,%eax
c0102f06:	8e c0                	mov    %eax,%es
    asm volatile ("movw %%ax, %%ds" :: "a" (KERNEL_DS));
c0102f08:	b8 10 00 00 00       	mov    $0x10,%eax
c0102f0d:	8e d8                	mov    %eax,%ds
    asm volatile ("movw %%ax, %%ss" :: "a" (KERNEL_DS));
c0102f0f:	b8 10 00 00 00       	mov    $0x10,%eax
c0102f14:	8e d0                	mov    %eax,%ss
    // reload cs
    asm volatile ("ljmp %0, $1f\n 1:\n" :: "i" (KERNEL_CS));
c0102f16:	ea 1d 2f 10 c0 08 00 	ljmp   $0x8,$0xc0102f1d
}
c0102f1d:	90                   	nop
c0102f1e:	5d                   	pop    %ebp
c0102f1f:	c3                   	ret    

c0102f20 <load_esp0>:
 * load_esp0 - change the ESP0 in default task state segment,
 * so that we can use different kernel stack when we trap frame
 * user to kernel.
 * */
void
load_esp0(uintptr_t esp0) {
c0102f20:	f3 0f 1e fb          	endbr32 
c0102f24:	55                   	push   %ebp
c0102f25:	89 e5                	mov    %esp,%ebp
    ts.ts_esp0 = esp0;
c0102f27:	8b 45 08             	mov    0x8(%ebp),%eax
c0102f2a:	a3 a4 de 11 c0       	mov    %eax,0xc011dea4
}
c0102f2f:	90                   	nop
c0102f30:	5d                   	pop    %ebp
c0102f31:	c3                   	ret    

c0102f32 <gdt_init>:

/* gdt_init - initialize the default GDT and TSS */
static void
gdt_init(void) {
c0102f32:	f3 0f 1e fb          	endbr32 
c0102f36:	55                   	push   %ebp
c0102f37:	89 e5                	mov    %esp,%ebp
c0102f39:	83 ec 14             	sub    $0x14,%esp
    // set boot kernel stack and default SS0
    load_esp0((uintptr_t)bootstacktop);
c0102f3c:	b8 00 a0 11 c0       	mov    $0xc011a000,%eax
c0102f41:	89 04 24             	mov    %eax,(%esp)
c0102f44:	e8 d7 ff ff ff       	call   c0102f20 <load_esp0>
    ts.ts_ss0 = KERNEL_DS;
c0102f49:	66 c7 05 a8 de 11 c0 	movw   $0x10,0xc011dea8
c0102f50:	10 00 

    // initialize the TSS filed of the gdt
    gdt[SEG_TSS] = SEGTSS(STS_T32A, (uintptr_t)&ts, sizeof(ts), DPL_KERNEL);
c0102f52:	66 c7 05 28 aa 11 c0 	movw   $0x68,0xc011aa28
c0102f59:	68 00 
c0102f5b:	b8 a0 de 11 c0       	mov    $0xc011dea0,%eax
c0102f60:	0f b7 c0             	movzwl %ax,%eax
c0102f63:	66 a3 2a aa 11 c0    	mov    %ax,0xc011aa2a
c0102f69:	b8 a0 de 11 c0       	mov    $0xc011dea0,%eax
c0102f6e:	c1 e8 10             	shr    $0x10,%eax
c0102f71:	a2 2c aa 11 c0       	mov    %al,0xc011aa2c
c0102f76:	0f b6 05 2d aa 11 c0 	movzbl 0xc011aa2d,%eax
c0102f7d:	24 f0                	and    $0xf0,%al
c0102f7f:	0c 09                	or     $0x9,%al
c0102f81:	a2 2d aa 11 c0       	mov    %al,0xc011aa2d
c0102f86:	0f b6 05 2d aa 11 c0 	movzbl 0xc011aa2d,%eax
c0102f8d:	24 ef                	and    $0xef,%al
c0102f8f:	a2 2d aa 11 c0       	mov    %al,0xc011aa2d
c0102f94:	0f b6 05 2d aa 11 c0 	movzbl 0xc011aa2d,%eax
c0102f9b:	24 9f                	and    $0x9f,%al
c0102f9d:	a2 2d aa 11 c0       	mov    %al,0xc011aa2d
c0102fa2:	0f b6 05 2d aa 11 c0 	movzbl 0xc011aa2d,%eax
c0102fa9:	0c 80                	or     $0x80,%al
c0102fab:	a2 2d aa 11 c0       	mov    %al,0xc011aa2d
c0102fb0:	0f b6 05 2e aa 11 c0 	movzbl 0xc011aa2e,%eax
c0102fb7:	24 f0                	and    $0xf0,%al
c0102fb9:	a2 2e aa 11 c0       	mov    %al,0xc011aa2e
c0102fbe:	0f b6 05 2e aa 11 c0 	movzbl 0xc011aa2e,%eax
c0102fc5:	24 ef                	and    $0xef,%al
c0102fc7:	a2 2e aa 11 c0       	mov    %al,0xc011aa2e
c0102fcc:	0f b6 05 2e aa 11 c0 	movzbl 0xc011aa2e,%eax
c0102fd3:	24 df                	and    $0xdf,%al
c0102fd5:	a2 2e aa 11 c0       	mov    %al,0xc011aa2e
c0102fda:	0f b6 05 2e aa 11 c0 	movzbl 0xc011aa2e,%eax
c0102fe1:	0c 40                	or     $0x40,%al
c0102fe3:	a2 2e aa 11 c0       	mov    %al,0xc011aa2e
c0102fe8:	0f b6 05 2e aa 11 c0 	movzbl 0xc011aa2e,%eax
c0102fef:	24 7f                	and    $0x7f,%al
c0102ff1:	a2 2e aa 11 c0       	mov    %al,0xc011aa2e
c0102ff6:	b8 a0 de 11 c0       	mov    $0xc011dea0,%eax
c0102ffb:	c1 e8 18             	shr    $0x18,%eax
c0102ffe:	a2 2f aa 11 c0       	mov    %al,0xc011aa2f

    // reload all segment registers
    lgdt(&gdt_pd);
c0103003:	c7 04 24 30 aa 11 c0 	movl   $0xc011aa30,(%esp)
c010300a:	e8 db fe ff ff       	call   c0102eea <lgdt>
c010300f:	66 c7 45 fe 28 00    	movw   $0x28,-0x2(%ebp)
    asm volatile ("ltr %0" :: "r" (sel) : "memory");
c0103015:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
c0103019:	0f 00 d8             	ltr    %ax
}
c010301c:	90                   	nop

    // load the TSS
    ltr(GD_TSS);
}
c010301d:	90                   	nop
c010301e:	c9                   	leave  
c010301f:	c3                   	ret    

c0103020 <init_pmm_manager>:

//init_pmm_manager - initialize a pmm_manager instance
static void
init_pmm_manager(void) {
c0103020:	f3 0f 1e fb          	endbr32 
c0103024:	55                   	push   %ebp
c0103025:	89 e5                	mov    %esp,%ebp
c0103027:	83 ec 18             	sub    $0x18,%esp
    pmm_manager = &default_pmm_manager;
c010302a:	c7 05 70 df 11 c0 f8 	movl   $0xc01076f8,0xc011df70
c0103031:	76 10 c0 
    cprintf("memory management: %s\n", pmm_manager->name);
c0103034:	a1 70 df 11 c0       	mov    0xc011df70,%eax
c0103039:	8b 00                	mov    (%eax),%eax
c010303b:	89 44 24 04          	mov    %eax,0x4(%esp)
c010303f:	c7 04 24 50 6d 10 c0 	movl   $0xc0106d50,(%esp)
c0103046:	e8 7a d2 ff ff       	call   c01002c5 <cprintf>
    pmm_manager->init();
c010304b:	a1 70 df 11 c0       	mov    0xc011df70,%eax
c0103050:	8b 40 04             	mov    0x4(%eax),%eax
c0103053:	ff d0                	call   *%eax
}
c0103055:	90                   	nop
c0103056:	c9                   	leave  
c0103057:	c3                   	ret    

c0103058 <init_memmap>:

//init_memmap - call pmm->init_memmap to build Page struct for free memory  
static void
init_memmap(struct Page *base, size_t n) {
c0103058:	f3 0f 1e fb          	endbr32 
c010305c:	55                   	push   %ebp
c010305d:	89 e5                	mov    %esp,%ebp
c010305f:	83 ec 18             	sub    $0x18,%esp
    pmm_manager->init_memmap(base, n);
c0103062:	a1 70 df 11 c0       	mov    0xc011df70,%eax
c0103067:	8b 40 08             	mov    0x8(%eax),%eax
c010306a:	8b 55 0c             	mov    0xc(%ebp),%edx
c010306d:	89 54 24 04          	mov    %edx,0x4(%esp)
c0103071:	8b 55 08             	mov    0x8(%ebp),%edx
c0103074:	89 14 24             	mov    %edx,(%esp)
c0103077:	ff d0                	call   *%eax
}
c0103079:	90                   	nop
c010307a:	c9                   	leave  
c010307b:	c3                   	ret    

c010307c <alloc_pages>:

//alloc_pages - call pmm->alloc_pages to allocate a continuous n*PAGESIZE memory 
struct Page *
alloc_pages(size_t n) {
c010307c:	f3 0f 1e fb          	endbr32 
c0103080:	55                   	push   %ebp
c0103081:	89 e5                	mov    %esp,%ebp
c0103083:	83 ec 28             	sub    $0x28,%esp
    struct Page *page=NULL;
c0103086:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    bool intr_flag;
    local_intr_save(intr_flag);
c010308d:	e8 1a fe ff ff       	call   c0102eac <__intr_save>
c0103092:	89 45 f0             	mov    %eax,-0x10(%ebp)
    {
        page = pmm_manager->alloc_pages(n);
c0103095:	a1 70 df 11 c0       	mov    0xc011df70,%eax
c010309a:	8b 40 0c             	mov    0xc(%eax),%eax
c010309d:	8b 55 08             	mov    0x8(%ebp),%edx
c01030a0:	89 14 24             	mov    %edx,(%esp)
c01030a3:	ff d0                	call   *%eax
c01030a5:	89 45 f4             	mov    %eax,-0xc(%ebp)
    }
    local_intr_restore(intr_flag);
c01030a8:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01030ab:	89 04 24             	mov    %eax,(%esp)
c01030ae:	e8 23 fe ff ff       	call   c0102ed6 <__intr_restore>
    return page;
c01030b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c01030b6:	c9                   	leave  
c01030b7:	c3                   	ret    

c01030b8 <free_pages>:

//free_pages - call pmm->free_pages to free a continuous n*PAGESIZE memory 
void
free_pages(struct Page *base, size_t n) {
c01030b8:	f3 0f 1e fb          	endbr32 
c01030bc:	55                   	push   %ebp
c01030bd:	89 e5                	mov    %esp,%ebp
c01030bf:	83 ec 28             	sub    $0x28,%esp
    bool intr_flag;
    local_intr_save(intr_flag);
c01030c2:	e8 e5 fd ff ff       	call   c0102eac <__intr_save>
c01030c7:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        pmm_manager->free_pages(base, n);
c01030ca:	a1 70 df 11 c0       	mov    0xc011df70,%eax
c01030cf:	8b 40 10             	mov    0x10(%eax),%eax
c01030d2:	8b 55 0c             	mov    0xc(%ebp),%edx
c01030d5:	89 54 24 04          	mov    %edx,0x4(%esp)
c01030d9:	8b 55 08             	mov    0x8(%ebp),%edx
c01030dc:	89 14 24             	mov    %edx,(%esp)
c01030df:	ff d0                	call   *%eax
    }
    local_intr_restore(intr_flag);
c01030e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01030e4:	89 04 24             	mov    %eax,(%esp)
c01030e7:	e8 ea fd ff ff       	call   c0102ed6 <__intr_restore>
}
c01030ec:	90                   	nop
c01030ed:	c9                   	leave  
c01030ee:	c3                   	ret    

c01030ef <nr_free_pages>:

//nr_free_pages - call pmm->nr_free_pages to get the size (nr*PAGESIZE) 
//of current free memory
size_t
nr_free_pages(void) {
c01030ef:	f3 0f 1e fb          	endbr32 
c01030f3:	55                   	push   %ebp
c01030f4:	89 e5                	mov    %esp,%ebp
c01030f6:	83 ec 28             	sub    $0x28,%esp
    size_t ret;
    bool intr_flag;
    local_intr_save(intr_flag);
c01030f9:	e8 ae fd ff ff       	call   c0102eac <__intr_save>
c01030fe:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        ret = pmm_manager->nr_free_pages();
c0103101:	a1 70 df 11 c0       	mov    0xc011df70,%eax
c0103106:	8b 40 14             	mov    0x14(%eax),%eax
c0103109:	ff d0                	call   *%eax
c010310b:	89 45 f0             	mov    %eax,-0x10(%ebp)
    }
    local_intr_restore(intr_flag);
c010310e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103111:	89 04 24             	mov    %eax,(%esp)
c0103114:	e8 bd fd ff ff       	call   c0102ed6 <__intr_restore>
    return ret;
c0103119:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
c010311c:	c9                   	leave  
c010311d:	c3                   	ret    

c010311e <page_init>:

/* pmm_init - initialize the physical memory management */
static void
page_init(void) {
c010311e:	f3 0f 1e fb          	endbr32 
c0103122:	55                   	push   %ebp
c0103123:	89 e5                	mov    %esp,%ebp
c0103125:	57                   	push   %edi
c0103126:	56                   	push   %esi
c0103127:	53                   	push   %ebx
c0103128:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
    struct e820map *memmap = (struct e820map *)(0x8000 + KERNBASE);
c010312e:	c7 45 c4 00 80 00 c0 	movl   $0xc0008000,-0x3c(%ebp)
    uint64_t maxpa = 0;
c0103135:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
c010313c:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)

    cprintf("e820map:\n");
c0103143:	c7 04 24 67 6d 10 c0 	movl   $0xc0106d67,(%esp)
c010314a:	e8 76 d1 ff ff       	call   c01002c5 <cprintf>
    int i;
    for (i = 0; i < memmap->nr_map; i ++) {
c010314f:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c0103156:	e9 1a 01 00 00       	jmp    c0103275 <page_init+0x157>
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
c010315b:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c010315e:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0103161:	89 d0                	mov    %edx,%eax
c0103163:	c1 e0 02             	shl    $0x2,%eax
c0103166:	01 d0                	add    %edx,%eax
c0103168:	c1 e0 02             	shl    $0x2,%eax
c010316b:	01 c8                	add    %ecx,%eax
c010316d:	8b 50 08             	mov    0x8(%eax),%edx
c0103170:	8b 40 04             	mov    0x4(%eax),%eax
c0103173:	89 45 a0             	mov    %eax,-0x60(%ebp)
c0103176:	89 55 a4             	mov    %edx,-0x5c(%ebp)
c0103179:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c010317c:	8b 55 dc             	mov    -0x24(%ebp),%edx
c010317f:	89 d0                	mov    %edx,%eax
c0103181:	c1 e0 02             	shl    $0x2,%eax
c0103184:	01 d0                	add    %edx,%eax
c0103186:	c1 e0 02             	shl    $0x2,%eax
c0103189:	01 c8                	add    %ecx,%eax
c010318b:	8b 48 0c             	mov    0xc(%eax),%ecx
c010318e:	8b 58 10             	mov    0x10(%eax),%ebx
c0103191:	8b 45 a0             	mov    -0x60(%ebp),%eax
c0103194:	8b 55 a4             	mov    -0x5c(%ebp),%edx
c0103197:	01 c8                	add    %ecx,%eax
c0103199:	11 da                	adc    %ebx,%edx
c010319b:	89 45 98             	mov    %eax,-0x68(%ebp)
c010319e:	89 55 9c             	mov    %edx,-0x64(%ebp)
        cprintf("  memory: %08llx, [%08llx, %08llx], type = %d.\n",
c01031a1:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c01031a4:	8b 55 dc             	mov    -0x24(%ebp),%edx
c01031a7:	89 d0                	mov    %edx,%eax
c01031a9:	c1 e0 02             	shl    $0x2,%eax
c01031ac:	01 d0                	add    %edx,%eax
c01031ae:	c1 e0 02             	shl    $0x2,%eax
c01031b1:	01 c8                	add    %ecx,%eax
c01031b3:	83 c0 14             	add    $0x14,%eax
c01031b6:	8b 00                	mov    (%eax),%eax
c01031b8:	89 45 84             	mov    %eax,-0x7c(%ebp)
c01031bb:	8b 45 98             	mov    -0x68(%ebp),%eax
c01031be:	8b 55 9c             	mov    -0x64(%ebp),%edx
c01031c1:	83 c0 ff             	add    $0xffffffff,%eax
c01031c4:	83 d2 ff             	adc    $0xffffffff,%edx
c01031c7:	89 85 78 ff ff ff    	mov    %eax,-0x88(%ebp)
c01031cd:	89 95 7c ff ff ff    	mov    %edx,-0x84(%ebp)
c01031d3:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c01031d6:	8b 55 dc             	mov    -0x24(%ebp),%edx
c01031d9:	89 d0                	mov    %edx,%eax
c01031db:	c1 e0 02             	shl    $0x2,%eax
c01031de:	01 d0                	add    %edx,%eax
c01031e0:	c1 e0 02             	shl    $0x2,%eax
c01031e3:	01 c8                	add    %ecx,%eax
c01031e5:	8b 48 0c             	mov    0xc(%eax),%ecx
c01031e8:	8b 58 10             	mov    0x10(%eax),%ebx
c01031eb:	8b 55 84             	mov    -0x7c(%ebp),%edx
c01031ee:	89 54 24 1c          	mov    %edx,0x1c(%esp)
c01031f2:	8b 85 78 ff ff ff    	mov    -0x88(%ebp),%eax
c01031f8:	8b 95 7c ff ff ff    	mov    -0x84(%ebp),%edx
c01031fe:	89 44 24 14          	mov    %eax,0x14(%esp)
c0103202:	89 54 24 18          	mov    %edx,0x18(%esp)
c0103206:	8b 45 a0             	mov    -0x60(%ebp),%eax
c0103209:	8b 55 a4             	mov    -0x5c(%ebp),%edx
c010320c:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0103210:	89 54 24 10          	mov    %edx,0x10(%esp)
c0103214:	89 4c 24 04          	mov    %ecx,0x4(%esp)
c0103218:	89 5c 24 08          	mov    %ebx,0x8(%esp)
c010321c:	c7 04 24 74 6d 10 c0 	movl   $0xc0106d74,(%esp)
c0103223:	e8 9d d0 ff ff       	call   c01002c5 <cprintf>
                memmap->map[i].size, begin, end - 1, memmap->map[i].type);
        if (memmap->map[i].type == E820_ARM) {
c0103228:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c010322b:	8b 55 dc             	mov    -0x24(%ebp),%edx
c010322e:	89 d0                	mov    %edx,%eax
c0103230:	c1 e0 02             	shl    $0x2,%eax
c0103233:	01 d0                	add    %edx,%eax
c0103235:	c1 e0 02             	shl    $0x2,%eax
c0103238:	01 c8                	add    %ecx,%eax
c010323a:	83 c0 14             	add    $0x14,%eax
c010323d:	8b 00                	mov    (%eax),%eax
c010323f:	83 f8 01             	cmp    $0x1,%eax
c0103242:	75 2e                	jne    c0103272 <page_init+0x154>
            if (maxpa < end && begin < KMEMSIZE) {
c0103244:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0103247:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c010324a:	3b 45 98             	cmp    -0x68(%ebp),%eax
c010324d:	89 d0                	mov    %edx,%eax
c010324f:	1b 45 9c             	sbb    -0x64(%ebp),%eax
c0103252:	73 1e                	jae    c0103272 <page_init+0x154>
c0103254:	ba ff ff ff 37       	mov    $0x37ffffff,%edx
c0103259:	b8 00 00 00 00       	mov    $0x0,%eax
c010325e:	3b 55 a0             	cmp    -0x60(%ebp),%edx
c0103261:	1b 45 a4             	sbb    -0x5c(%ebp),%eax
c0103264:	72 0c                	jb     c0103272 <page_init+0x154>
                maxpa = end;
c0103266:	8b 45 98             	mov    -0x68(%ebp),%eax
c0103269:	8b 55 9c             	mov    -0x64(%ebp),%edx
c010326c:	89 45 e0             	mov    %eax,-0x20(%ebp)
c010326f:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    for (i = 0; i < memmap->nr_map; i ++) {
c0103272:	ff 45 dc             	incl   -0x24(%ebp)
c0103275:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0103278:	8b 00                	mov    (%eax),%eax
c010327a:	39 45 dc             	cmp    %eax,-0x24(%ebp)
c010327d:	0f 8c d8 fe ff ff    	jl     c010315b <page_init+0x3d>
            }
        }
    }
    if (maxpa > KMEMSIZE) {
c0103283:	ba 00 00 00 38       	mov    $0x38000000,%edx
c0103288:	b8 00 00 00 00       	mov    $0x0,%eax
c010328d:	3b 55 e0             	cmp    -0x20(%ebp),%edx
c0103290:	1b 45 e4             	sbb    -0x1c(%ebp),%eax
c0103293:	73 0e                	jae    c01032a3 <page_init+0x185>
        maxpa = KMEMSIZE;
c0103295:	c7 45 e0 00 00 00 38 	movl   $0x38000000,-0x20(%ebp)
c010329c:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    }

    extern char end[];

    npage = maxpa / PGSIZE;
c01032a3:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01032a6:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c01032a9:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
c01032ad:	c1 ea 0c             	shr    $0xc,%edx
c01032b0:	a3 80 de 11 c0       	mov    %eax,0xc011de80
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
c01032b5:	c7 45 c0 00 10 00 00 	movl   $0x1000,-0x40(%ebp)
c01032bc:	b8 88 df 11 c0       	mov    $0xc011df88,%eax
c01032c1:	8d 50 ff             	lea    -0x1(%eax),%edx
c01032c4:	8b 45 c0             	mov    -0x40(%ebp),%eax
c01032c7:	01 d0                	add    %edx,%eax
c01032c9:	89 45 bc             	mov    %eax,-0x44(%ebp)
c01032cc:	8b 45 bc             	mov    -0x44(%ebp),%eax
c01032cf:	ba 00 00 00 00       	mov    $0x0,%edx
c01032d4:	f7 75 c0             	divl   -0x40(%ebp)
c01032d7:	8b 45 bc             	mov    -0x44(%ebp),%eax
c01032da:	29 d0                	sub    %edx,%eax
c01032dc:	a3 78 df 11 c0       	mov    %eax,0xc011df78

    for (i = 0; i < npage; i ++) {
c01032e1:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c01032e8:	eb 2f                	jmp    c0103319 <page_init+0x1fb>
        SetPageReserved(pages + i);
c01032ea:	8b 0d 78 df 11 c0    	mov    0xc011df78,%ecx
c01032f0:	8b 55 dc             	mov    -0x24(%ebp),%edx
c01032f3:	89 d0                	mov    %edx,%eax
c01032f5:	c1 e0 02             	shl    $0x2,%eax
c01032f8:	01 d0                	add    %edx,%eax
c01032fa:	c1 e0 02             	shl    $0x2,%eax
c01032fd:	01 c8                	add    %ecx,%eax
c01032ff:	83 c0 04             	add    $0x4,%eax
c0103302:	c7 45 94 00 00 00 00 	movl   $0x0,-0x6c(%ebp)
c0103309:	89 45 90             	mov    %eax,-0x70(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c010330c:	8b 45 90             	mov    -0x70(%ebp),%eax
c010330f:	8b 55 94             	mov    -0x6c(%ebp),%edx
c0103312:	0f ab 10             	bts    %edx,(%eax)
}
c0103315:	90                   	nop
    for (i = 0; i < npage; i ++) {
c0103316:	ff 45 dc             	incl   -0x24(%ebp)
c0103319:	8b 55 dc             	mov    -0x24(%ebp),%edx
c010331c:	a1 80 de 11 c0       	mov    0xc011de80,%eax
c0103321:	39 c2                	cmp    %eax,%edx
c0103323:	72 c5                	jb     c01032ea <page_init+0x1cc>
    }

    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * npage);
c0103325:	8b 15 80 de 11 c0    	mov    0xc011de80,%edx
c010332b:	89 d0                	mov    %edx,%eax
c010332d:	c1 e0 02             	shl    $0x2,%eax
c0103330:	01 d0                	add    %edx,%eax
c0103332:	c1 e0 02             	shl    $0x2,%eax
c0103335:	89 c2                	mov    %eax,%edx
c0103337:	a1 78 df 11 c0       	mov    0xc011df78,%eax
c010333c:	01 d0                	add    %edx,%eax
c010333e:	89 45 b8             	mov    %eax,-0x48(%ebp)
c0103341:	81 7d b8 ff ff ff bf 	cmpl   $0xbfffffff,-0x48(%ebp)
c0103348:	77 23                	ja     c010336d <page_init+0x24f>
c010334a:	8b 45 b8             	mov    -0x48(%ebp),%eax
c010334d:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0103351:	c7 44 24 08 a4 6d 10 	movl   $0xc0106da4,0x8(%esp)
c0103358:	c0 
c0103359:	c7 44 24 04 dc 00 00 	movl   $0xdc,0x4(%esp)
c0103360:	00 
c0103361:	c7 04 24 c8 6d 10 c0 	movl   $0xc0106dc8,(%esp)
c0103368:	e8 c4 d0 ff ff       	call   c0100431 <__panic>
c010336d:	8b 45 b8             	mov    -0x48(%ebp),%eax
c0103370:	05 00 00 00 40       	add    $0x40000000,%eax
c0103375:	89 45 b4             	mov    %eax,-0x4c(%ebp)

    for (i = 0; i < memmap->nr_map; i ++) {
c0103378:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c010337f:	e9 4b 01 00 00       	jmp    c01034cf <page_init+0x3b1>
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
c0103384:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0103387:	8b 55 dc             	mov    -0x24(%ebp),%edx
c010338a:	89 d0                	mov    %edx,%eax
c010338c:	c1 e0 02             	shl    $0x2,%eax
c010338f:	01 d0                	add    %edx,%eax
c0103391:	c1 e0 02             	shl    $0x2,%eax
c0103394:	01 c8                	add    %ecx,%eax
c0103396:	8b 50 08             	mov    0x8(%eax),%edx
c0103399:	8b 40 04             	mov    0x4(%eax),%eax
c010339c:	89 45 d0             	mov    %eax,-0x30(%ebp)
c010339f:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c01033a2:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c01033a5:	8b 55 dc             	mov    -0x24(%ebp),%edx
c01033a8:	89 d0                	mov    %edx,%eax
c01033aa:	c1 e0 02             	shl    $0x2,%eax
c01033ad:	01 d0                	add    %edx,%eax
c01033af:	c1 e0 02             	shl    $0x2,%eax
c01033b2:	01 c8                	add    %ecx,%eax
c01033b4:	8b 48 0c             	mov    0xc(%eax),%ecx
c01033b7:	8b 58 10             	mov    0x10(%eax),%ebx
c01033ba:	8b 45 d0             	mov    -0x30(%ebp),%eax
c01033bd:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01033c0:	01 c8                	add    %ecx,%eax
c01033c2:	11 da                	adc    %ebx,%edx
c01033c4:	89 45 c8             	mov    %eax,-0x38(%ebp)
c01033c7:	89 55 cc             	mov    %edx,-0x34(%ebp)
        if (memmap->map[i].type == E820_ARM) {
c01033ca:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c01033cd:	8b 55 dc             	mov    -0x24(%ebp),%edx
c01033d0:	89 d0                	mov    %edx,%eax
c01033d2:	c1 e0 02             	shl    $0x2,%eax
c01033d5:	01 d0                	add    %edx,%eax
c01033d7:	c1 e0 02             	shl    $0x2,%eax
c01033da:	01 c8                	add    %ecx,%eax
c01033dc:	83 c0 14             	add    $0x14,%eax
c01033df:	8b 00                	mov    (%eax),%eax
c01033e1:	83 f8 01             	cmp    $0x1,%eax
c01033e4:	0f 85 e2 00 00 00    	jne    c01034cc <page_init+0x3ae>
            if (begin < freemem) {
c01033ea:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c01033ed:	ba 00 00 00 00       	mov    $0x0,%edx
c01033f2:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
c01033f5:	39 45 d0             	cmp    %eax,-0x30(%ebp)
c01033f8:	19 d1                	sbb    %edx,%ecx
c01033fa:	73 0d                	jae    c0103409 <page_init+0x2eb>
                begin = freemem;
c01033fc:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c01033ff:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0103402:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
            }
            if (end > KMEMSIZE) {
c0103409:	ba 00 00 00 38       	mov    $0x38000000,%edx
c010340e:	b8 00 00 00 00       	mov    $0x0,%eax
c0103413:	3b 55 c8             	cmp    -0x38(%ebp),%edx
c0103416:	1b 45 cc             	sbb    -0x34(%ebp),%eax
c0103419:	73 0e                	jae    c0103429 <page_init+0x30b>
                end = KMEMSIZE;
c010341b:	c7 45 c8 00 00 00 38 	movl   $0x38000000,-0x38(%ebp)
c0103422:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
            }
            if (begin < end) {
c0103429:	8b 45 d0             	mov    -0x30(%ebp),%eax
c010342c:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c010342f:	3b 45 c8             	cmp    -0x38(%ebp),%eax
c0103432:	89 d0                	mov    %edx,%eax
c0103434:	1b 45 cc             	sbb    -0x34(%ebp),%eax
c0103437:	0f 83 8f 00 00 00    	jae    c01034cc <page_init+0x3ae>
                begin = ROUNDUP(begin, PGSIZE);
c010343d:	c7 45 b0 00 10 00 00 	movl   $0x1000,-0x50(%ebp)
c0103444:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0103447:	8b 45 b0             	mov    -0x50(%ebp),%eax
c010344a:	01 d0                	add    %edx,%eax
c010344c:	48                   	dec    %eax
c010344d:	89 45 ac             	mov    %eax,-0x54(%ebp)
c0103450:	8b 45 ac             	mov    -0x54(%ebp),%eax
c0103453:	ba 00 00 00 00       	mov    $0x0,%edx
c0103458:	f7 75 b0             	divl   -0x50(%ebp)
c010345b:	8b 45 ac             	mov    -0x54(%ebp),%eax
c010345e:	29 d0                	sub    %edx,%eax
c0103460:	ba 00 00 00 00       	mov    $0x0,%edx
c0103465:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0103468:	89 55 d4             	mov    %edx,-0x2c(%ebp)
                end = ROUNDDOWN(end, PGSIZE);
c010346b:	8b 45 c8             	mov    -0x38(%ebp),%eax
c010346e:	89 45 a8             	mov    %eax,-0x58(%ebp)
c0103471:	8b 45 a8             	mov    -0x58(%ebp),%eax
c0103474:	ba 00 00 00 00       	mov    $0x0,%edx
c0103479:	89 c3                	mov    %eax,%ebx
c010347b:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
c0103481:	89 de                	mov    %ebx,%esi
c0103483:	89 d0                	mov    %edx,%eax
c0103485:	83 e0 00             	and    $0x0,%eax
c0103488:	89 c7                	mov    %eax,%edi
c010348a:	89 75 c8             	mov    %esi,-0x38(%ebp)
c010348d:	89 7d cc             	mov    %edi,-0x34(%ebp)
                if (begin < end) {
c0103490:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0103493:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0103496:	3b 45 c8             	cmp    -0x38(%ebp),%eax
c0103499:	89 d0                	mov    %edx,%eax
c010349b:	1b 45 cc             	sbb    -0x34(%ebp),%eax
c010349e:	73 2c                	jae    c01034cc <page_init+0x3ae>
                    init_memmap(pa2page(begin), (end - begin) / PGSIZE);
c01034a0:	8b 45 c8             	mov    -0x38(%ebp),%eax
c01034a3:	8b 55 cc             	mov    -0x34(%ebp),%edx
c01034a6:	2b 45 d0             	sub    -0x30(%ebp),%eax
c01034a9:	1b 55 d4             	sbb    -0x2c(%ebp),%edx
c01034ac:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
c01034b0:	c1 ea 0c             	shr    $0xc,%edx
c01034b3:	89 c3                	mov    %eax,%ebx
c01034b5:	8b 45 d0             	mov    -0x30(%ebp),%eax
c01034b8:	89 04 24             	mov    %eax,(%esp)
c01034bb:	e8 ad f8 ff ff       	call   c0102d6d <pa2page>
c01034c0:	89 5c 24 04          	mov    %ebx,0x4(%esp)
c01034c4:	89 04 24             	mov    %eax,(%esp)
c01034c7:	e8 8c fb ff ff       	call   c0103058 <init_memmap>
    for (i = 0; i < memmap->nr_map; i ++) {
c01034cc:	ff 45 dc             	incl   -0x24(%ebp)
c01034cf:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c01034d2:	8b 00                	mov    (%eax),%eax
c01034d4:	39 45 dc             	cmp    %eax,-0x24(%ebp)
c01034d7:	0f 8c a7 fe ff ff    	jl     c0103384 <page_init+0x266>
                }
            }
        }
    }
}
c01034dd:	90                   	nop
c01034de:	90                   	nop
c01034df:	81 c4 9c 00 00 00    	add    $0x9c,%esp
c01034e5:	5b                   	pop    %ebx
c01034e6:	5e                   	pop    %esi
c01034e7:	5f                   	pop    %edi
c01034e8:	5d                   	pop    %ebp
c01034e9:	c3                   	ret    

c01034ea <boot_map_segment>:
//  la:   linear address of this memory need to map (after x86 segment map)
//  size: memory size
//  pa:   physical address of this memory
//  perm: permission of this memory  
static void
boot_map_segment(pde_t *pgdir, uintptr_t la, size_t size, uintptr_t pa, uint32_t perm) {
c01034ea:	f3 0f 1e fb          	endbr32 
c01034ee:	55                   	push   %ebp
c01034ef:	89 e5                	mov    %esp,%ebp
c01034f1:	83 ec 38             	sub    $0x38,%esp
    assert(PGOFF(la) == PGOFF(pa));
c01034f4:	8b 45 0c             	mov    0xc(%ebp),%eax
c01034f7:	33 45 14             	xor    0x14(%ebp),%eax
c01034fa:	25 ff 0f 00 00       	and    $0xfff,%eax
c01034ff:	85 c0                	test   %eax,%eax
c0103501:	74 24                	je     c0103527 <boot_map_segment+0x3d>
c0103503:	c7 44 24 0c d6 6d 10 	movl   $0xc0106dd6,0xc(%esp)
c010350a:	c0 
c010350b:	c7 44 24 08 ed 6d 10 	movl   $0xc0106ded,0x8(%esp)
c0103512:	c0 
c0103513:	c7 44 24 04 fa 00 00 	movl   $0xfa,0x4(%esp)
c010351a:	00 
c010351b:	c7 04 24 c8 6d 10 c0 	movl   $0xc0106dc8,(%esp)
c0103522:	e8 0a cf ff ff       	call   c0100431 <__panic>
    size_t n = ROUNDUP(size + PGOFF(la), PGSIZE) / PGSIZE;
c0103527:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
c010352e:	8b 45 0c             	mov    0xc(%ebp),%eax
c0103531:	25 ff 0f 00 00       	and    $0xfff,%eax
c0103536:	89 c2                	mov    %eax,%edx
c0103538:	8b 45 10             	mov    0x10(%ebp),%eax
c010353b:	01 c2                	add    %eax,%edx
c010353d:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103540:	01 d0                	add    %edx,%eax
c0103542:	48                   	dec    %eax
c0103543:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0103546:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103549:	ba 00 00 00 00       	mov    $0x0,%edx
c010354e:	f7 75 f0             	divl   -0x10(%ebp)
c0103551:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103554:	29 d0                	sub    %edx,%eax
c0103556:	c1 e8 0c             	shr    $0xc,%eax
c0103559:	89 45 f4             	mov    %eax,-0xc(%ebp)
    la = ROUNDDOWN(la, PGSIZE);
c010355c:	8b 45 0c             	mov    0xc(%ebp),%eax
c010355f:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0103562:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103565:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c010356a:	89 45 0c             	mov    %eax,0xc(%ebp)
    pa = ROUNDDOWN(pa, PGSIZE);
c010356d:	8b 45 14             	mov    0x14(%ebp),%eax
c0103570:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0103573:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103576:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c010357b:	89 45 14             	mov    %eax,0x14(%ebp)
    for (; n > 0; n --, la += PGSIZE, pa += PGSIZE) {
c010357e:	eb 68                	jmp    c01035e8 <boot_map_segment+0xfe>
        pte_t *ptep = get_pte(pgdir, la, 1);
c0103580:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
c0103587:	00 
c0103588:	8b 45 0c             	mov    0xc(%ebp),%eax
c010358b:	89 44 24 04          	mov    %eax,0x4(%esp)
c010358f:	8b 45 08             	mov    0x8(%ebp),%eax
c0103592:	89 04 24             	mov    %eax,(%esp)
c0103595:	e8 8a 01 00 00       	call   c0103724 <get_pte>
c010359a:	89 45 e0             	mov    %eax,-0x20(%ebp)
        assert(ptep != NULL);
c010359d:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
c01035a1:	75 24                	jne    c01035c7 <boot_map_segment+0xdd>
c01035a3:	c7 44 24 0c 02 6e 10 	movl   $0xc0106e02,0xc(%esp)
c01035aa:	c0 
c01035ab:	c7 44 24 08 ed 6d 10 	movl   $0xc0106ded,0x8(%esp)
c01035b2:	c0 
c01035b3:	c7 44 24 04 00 01 00 	movl   $0x100,0x4(%esp)
c01035ba:	00 
c01035bb:	c7 04 24 c8 6d 10 c0 	movl   $0xc0106dc8,(%esp)
c01035c2:	e8 6a ce ff ff       	call   c0100431 <__panic>
        *ptep = pa | PTE_P | perm;
c01035c7:	8b 45 14             	mov    0x14(%ebp),%eax
c01035ca:	0b 45 18             	or     0x18(%ebp),%eax
c01035cd:	83 c8 01             	or     $0x1,%eax
c01035d0:	89 c2                	mov    %eax,%edx
c01035d2:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01035d5:	89 10                	mov    %edx,(%eax)
    for (; n > 0; n --, la += PGSIZE, pa += PGSIZE) {
c01035d7:	ff 4d f4             	decl   -0xc(%ebp)
c01035da:	81 45 0c 00 10 00 00 	addl   $0x1000,0xc(%ebp)
c01035e1:	81 45 14 00 10 00 00 	addl   $0x1000,0x14(%ebp)
c01035e8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01035ec:	75 92                	jne    c0103580 <boot_map_segment+0x96>
    }
}
c01035ee:	90                   	nop
c01035ef:	90                   	nop
c01035f0:	c9                   	leave  
c01035f1:	c3                   	ret    

c01035f2 <boot_alloc_page>:

//boot_alloc_page - allocate one page using pmm->alloc_pages(1) 
// return value: the kernel virtual address of this allocated page
//note: this function is used to get the memory for PDT(Page Directory Table)&PT(Page Table)
static void *
boot_alloc_page(void) {
c01035f2:	f3 0f 1e fb          	endbr32 
c01035f6:	55                   	push   %ebp
c01035f7:	89 e5                	mov    %esp,%ebp
c01035f9:	83 ec 28             	sub    $0x28,%esp
    struct Page *p = alloc_page();
c01035fc:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103603:	e8 74 fa ff ff       	call   c010307c <alloc_pages>
c0103608:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (p == NULL) {
c010360b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c010360f:	75 1c                	jne    c010362d <boot_alloc_page+0x3b>
        panic("boot_alloc_page failed.\n");
c0103611:	c7 44 24 08 0f 6e 10 	movl   $0xc0106e0f,0x8(%esp)
c0103618:	c0 
c0103619:	c7 44 24 04 0c 01 00 	movl   $0x10c,0x4(%esp)
c0103620:	00 
c0103621:	c7 04 24 c8 6d 10 c0 	movl   $0xc0106dc8,(%esp)
c0103628:	e8 04 ce ff ff       	call   c0100431 <__panic>
    }
    return page2kva(p);
c010362d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103630:	89 04 24             	mov    %eax,(%esp)
c0103633:	e8 84 f7 ff ff       	call   c0102dbc <page2kva>
}
c0103638:	c9                   	leave  
c0103639:	c3                   	ret    

c010363a <pmm_init>:

//pmm_init - setup a pmm to manage physical memory, build PDT&PT to setup paging mechanism 
//         - check the correctness of pmm & paging mechanism, print PDT&PT
void
pmm_init(void) {
c010363a:	f3 0f 1e fb          	endbr32 
c010363e:	55                   	push   %ebp
c010363f:	89 e5                	mov    %esp,%ebp
c0103641:	83 ec 38             	sub    $0x38,%esp
    // We've already enabled paging
    boot_cr3 = PADDR(boot_pgdir);
c0103644:	a1 e0 a9 11 c0       	mov    0xc011a9e0,%eax
c0103649:	89 45 f4             	mov    %eax,-0xc(%ebp)
c010364c:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
c0103653:	77 23                	ja     c0103678 <pmm_init+0x3e>
c0103655:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103658:	89 44 24 0c          	mov    %eax,0xc(%esp)
c010365c:	c7 44 24 08 a4 6d 10 	movl   $0xc0106da4,0x8(%esp)
c0103663:	c0 
c0103664:	c7 44 24 04 16 01 00 	movl   $0x116,0x4(%esp)
c010366b:	00 
c010366c:	c7 04 24 c8 6d 10 c0 	movl   $0xc0106dc8,(%esp)
c0103673:	e8 b9 cd ff ff       	call   c0100431 <__panic>
c0103678:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010367b:	05 00 00 00 40       	add    $0x40000000,%eax
c0103680:	a3 74 df 11 c0       	mov    %eax,0xc011df74
    //We need to alloc/free the physical memory (granularity is 4KB or other size). 
    //So a framework of physical memory manager (struct pmm_manager)is defined in pmm.h
    //First we should init a physical memory manager(pmm) based on the framework.
    //Then pmm can alloc/free the physical memory. 
    //Now the first_fit/best_fit/worst_fit/buddy_system pmm are available.
    init_pmm_manager();
c0103685:	e8 96 f9 ff ff       	call   c0103020 <init_pmm_manager>

    // detect physical memory space, reserve already used memory,
    // then use pmm->init_memmap to create free page list
    page_init();
c010368a:	e8 8f fa ff ff       	call   c010311e <page_init>

    //use pmm->check to verify the correctness of the alloc/free function in a pmm
    check_alloc_page();
c010368f:	e8 f3 03 00 00       	call   c0103a87 <check_alloc_page>

    check_pgdir();
c0103694:	e8 11 04 00 00       	call   c0103aaa <check_pgdir>

    static_assert(KERNBASE % PTSIZE == 0 && KERNTOP % PTSIZE == 0);

    // recursively insert boot_pgdir in itself
    // to form a virtual page table at virtual address VPT
    boot_pgdir[PDX(VPT)] = PADDR(boot_pgdir) | PTE_P | PTE_W;
c0103699:	a1 e0 a9 11 c0       	mov    0xc011a9e0,%eax
c010369e:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01036a1:	81 7d f0 ff ff ff bf 	cmpl   $0xbfffffff,-0x10(%ebp)
c01036a8:	77 23                	ja     c01036cd <pmm_init+0x93>
c01036aa:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01036ad:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01036b1:	c7 44 24 08 a4 6d 10 	movl   $0xc0106da4,0x8(%esp)
c01036b8:	c0 
c01036b9:	c7 44 24 04 2c 01 00 	movl   $0x12c,0x4(%esp)
c01036c0:	00 
c01036c1:	c7 04 24 c8 6d 10 c0 	movl   $0xc0106dc8,(%esp)
c01036c8:	e8 64 cd ff ff       	call   c0100431 <__panic>
c01036cd:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01036d0:	8d 90 00 00 00 40    	lea    0x40000000(%eax),%edx
c01036d6:	a1 e0 a9 11 c0       	mov    0xc011a9e0,%eax
c01036db:	05 ac 0f 00 00       	add    $0xfac,%eax
c01036e0:	83 ca 03             	or     $0x3,%edx
c01036e3:	89 10                	mov    %edx,(%eax)

    // map all physical memory to linear memory with base linear addr KERNBASE
    // linear_addr KERNBASE ~ KERNBASE + KMEMSIZE = phy_addr 0 ~ KMEMSIZE
    boot_map_segment(boot_pgdir, KERNBASE, KMEMSIZE, 0, PTE_W);
c01036e5:	a1 e0 a9 11 c0       	mov    0xc011a9e0,%eax
c01036ea:	c7 44 24 10 02 00 00 	movl   $0x2,0x10(%esp)
c01036f1:	00 
c01036f2:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
c01036f9:	00 
c01036fa:	c7 44 24 08 00 00 00 	movl   $0x38000000,0x8(%esp)
c0103701:	38 
c0103702:	c7 44 24 04 00 00 00 	movl   $0xc0000000,0x4(%esp)
c0103709:	c0 
c010370a:	89 04 24             	mov    %eax,(%esp)
c010370d:	e8 d8 fd ff ff       	call   c01034ea <boot_map_segment>

    // Since we are using bootloader's GDT,
    // we should reload gdt (second time, the last time) to get user segments and the TSS
    // map virtual_addr 0 ~ 4G = linear_addr 0 ~ 4G
    // then set kernel stack (ss:esp) in TSS, setup TSS in gdt, load TSS
    gdt_init();
c0103712:	e8 1b f8 ff ff       	call   c0102f32 <gdt_init>

    //now the basic virtual memory map(see memalyout.h) is established.
    //check the correctness of the basic virtual memory map.
    check_boot_pgdir();
c0103717:	e8 2e 0a 00 00       	call   c010414a <check_boot_pgdir>

    print_pgdir();
c010371c:	e8 b3 0e 00 00       	call   c01045d4 <print_pgdir>

}
c0103721:	90                   	nop
c0103722:	c9                   	leave  
c0103723:	c3                   	ret    

c0103724 <get_pte>:
//  pgdir:  the kernel virtual base address of PDT
//  la:     the linear address need to map
//  create: a logical value to decide if alloc a page for PT
// return vaule: the kernel virtual address of this pte
pte_t *
get_pte(pde_t *pgdir, uintptr_t la, bool create) {
c0103724:	f3 0f 1e fb          	endbr32 
c0103728:	55                   	push   %ebp
c0103729:	89 e5                	mov    %esp,%ebp
c010372b:	83 ec 38             	sub    $0x38,%esp
                          // (6) clear page content using memset
                          // (7) set page directory entry's permission
    }
    return NULL;          // (8) return page table entry
#endif
    pde_t *pdep = &pgdir[PDX(la)];  //尝试获得页表
c010372e:	8b 45 0c             	mov    0xc(%ebp),%eax
c0103731:	c1 e8 16             	shr    $0x16,%eax
c0103734:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c010373b:	8b 45 08             	mov    0x8(%ebp),%eax
c010373e:	01 d0                	add    %edx,%eax
c0103740:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (!(*pdep & PTE_P)) { //如果获取不成功
c0103743:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103746:	8b 00                	mov    (%eax),%eax
c0103748:	83 e0 01             	and    $0x1,%eax
c010374b:	85 c0                	test   %eax,%eax
c010374d:	0f 85 af 00 00 00    	jne    c0103802 <get_pte+0xde>
        struct Page *page;
        //假如不需要分配或是分配失败
        if (!create || (page = alloc_page()) == NULL) { 
c0103753:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0103757:	74 15                	je     c010376e <get_pte+0x4a>
c0103759:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103760:	e8 17 f9 ff ff       	call   c010307c <alloc_pages>
c0103765:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0103768:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c010376c:	75 0a                	jne    c0103778 <get_pte+0x54>
            return NULL;
c010376e:	b8 00 00 00 00       	mov    $0x0,%eax
c0103773:	e9 e7 00 00 00       	jmp    c010385f <get_pte+0x13b>
        }
        set_page_ref(page, 1); //引用次数加一
c0103778:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c010377f:	00 
c0103780:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103783:	89 04 24             	mov    %eax,(%esp)
c0103786:	e8 e5 f6 ff ff       	call   c0102e70 <set_page_ref>
        uintptr_t pa = page2pa(page);  //得到该页物理地址
c010378b:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010378e:	89 04 24             	mov    %eax,(%esp)
c0103791:	e8 c1 f5 ff ff       	call   c0102d57 <page2pa>
c0103796:	89 45 ec             	mov    %eax,-0x14(%ebp)
        memset(KADDR(pa), 0, PGSIZE); //物理地址转虚拟地址，并初始化
c0103799:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010379c:	89 45 e8             	mov    %eax,-0x18(%ebp)
c010379f:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01037a2:	c1 e8 0c             	shr    $0xc,%eax
c01037a5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c01037a8:	a1 80 de 11 c0       	mov    0xc011de80,%eax
c01037ad:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
c01037b0:	72 23                	jb     c01037d5 <get_pte+0xb1>
c01037b2:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01037b5:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01037b9:	c7 44 24 08 00 6d 10 	movl   $0xc0106d00,0x8(%esp)
c01037c0:	c0 
c01037c1:	c7 44 24 04 73 01 00 	movl   $0x173,0x4(%esp)
c01037c8:	00 
c01037c9:	c7 04 24 c8 6d 10 c0 	movl   $0xc0106dc8,(%esp)
c01037d0:	e8 5c cc ff ff       	call   c0100431 <__panic>
c01037d5:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01037d8:	2d 00 00 00 40       	sub    $0x40000000,%eax
c01037dd:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
c01037e4:	00 
c01037e5:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c01037ec:	00 
c01037ed:	89 04 24             	mov    %eax,(%esp)
c01037f0:	e8 29 25 00 00       	call   c0105d1e <memset>
        *pdep = pa | PTE_U | PTE_W | PTE_P; //设置控制位
c01037f5:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01037f8:	83 c8 07             	or     $0x7,%eax
c01037fb:	89 c2                	mov    %eax,%edx
c01037fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103800:	89 10                	mov    %edx,(%eax)
    }
    return &((pte_t *)KADDR(PDE_ADDR(*pdep)))[PTX(la)]; 
c0103802:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103805:	8b 00                	mov    (%eax),%eax
c0103807:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c010380c:	89 45 e0             	mov    %eax,-0x20(%ebp)
c010380f:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0103812:	c1 e8 0c             	shr    $0xc,%eax
c0103815:	89 45 dc             	mov    %eax,-0x24(%ebp)
c0103818:	a1 80 de 11 c0       	mov    0xc011de80,%eax
c010381d:	39 45 dc             	cmp    %eax,-0x24(%ebp)
c0103820:	72 23                	jb     c0103845 <get_pte+0x121>
c0103822:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0103825:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0103829:	c7 44 24 08 00 6d 10 	movl   $0xc0106d00,0x8(%esp)
c0103830:	c0 
c0103831:	c7 44 24 04 76 01 00 	movl   $0x176,0x4(%esp)
c0103838:	00 
c0103839:	c7 04 24 c8 6d 10 c0 	movl   $0xc0106dc8,(%esp)
c0103840:	e8 ec cb ff ff       	call   c0100431 <__panic>
c0103845:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0103848:	2d 00 00 00 40       	sub    $0x40000000,%eax
c010384d:	89 c2                	mov    %eax,%edx
c010384f:	8b 45 0c             	mov    0xc(%ebp),%eax
c0103852:	c1 e8 0c             	shr    $0xc,%eax
c0103855:	25 ff 03 00 00       	and    $0x3ff,%eax
c010385a:	c1 e0 02             	shl    $0x2,%eax
c010385d:	01 d0                	add    %edx,%eax
    //KADDR(PDE_ADDR(*pdep)):这部分是由页目录项地址得到关联的页表物理地址，再转成虚拟地址
    //PTX(la)：返回虚拟地址la的页表项索引
    //最后返回的是虚拟地址la对应的页表项入口地址
}
c010385f:	c9                   	leave  
c0103860:	c3                   	ret    

c0103861 <get_page>:

//get_page - get related Page struct for linear address la using PDT pgdir
struct Page *
get_page(pde_t *pgdir, uintptr_t la, pte_t **ptep_store) {
c0103861:	f3 0f 1e fb          	endbr32 
c0103865:	55                   	push   %ebp
c0103866:	89 e5                	mov    %esp,%ebp
c0103868:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 0);
c010386b:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0103872:	00 
c0103873:	8b 45 0c             	mov    0xc(%ebp),%eax
c0103876:	89 44 24 04          	mov    %eax,0x4(%esp)
c010387a:	8b 45 08             	mov    0x8(%ebp),%eax
c010387d:	89 04 24             	mov    %eax,(%esp)
c0103880:	e8 9f fe ff ff       	call   c0103724 <get_pte>
c0103885:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep_store != NULL) {
c0103888:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c010388c:	74 08                	je     c0103896 <get_page+0x35>
        *ptep_store = ptep;
c010388e:	8b 45 10             	mov    0x10(%ebp),%eax
c0103891:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0103894:	89 10                	mov    %edx,(%eax)
    }
    if (ptep != NULL && *ptep & PTE_P) {
c0103896:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c010389a:	74 1b                	je     c01038b7 <get_page+0x56>
c010389c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010389f:	8b 00                	mov    (%eax),%eax
c01038a1:	83 e0 01             	and    $0x1,%eax
c01038a4:	85 c0                	test   %eax,%eax
c01038a6:	74 0f                	je     c01038b7 <get_page+0x56>
        return pte2page(*ptep);
c01038a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01038ab:	8b 00                	mov    (%eax),%eax
c01038ad:	89 04 24             	mov    %eax,(%esp)
c01038b0:	e8 5b f5 ff ff       	call   c0102e10 <pte2page>
c01038b5:	eb 05                	jmp    c01038bc <get_page+0x5b>
    }
    return NULL;
c01038b7:	b8 00 00 00 00       	mov    $0x0,%eax
}
c01038bc:	c9                   	leave  
c01038bd:	c3                   	ret    

c01038be <page_remove_pte>:

//page_remove_pte - free an Page sturct which is related linear address la
//                - and clean(invalidate) pte which is related linear address la
//note: PT is changed, so the TLB need to be invalidate 
static inline void
page_remove_pte(pde_t *pgdir, uintptr_t la, pte_t *ptep) {
c01038be:	55                   	push   %ebp
c01038bf:	89 e5                	mov    %esp,%ebp
c01038c1:	83 ec 28             	sub    $0x28,%esp
                                  //(4) and free this page when page reference reachs 0
                                  //(5) clear second page table entry
                                  //(6) flush tlb
    }
#endif
    if (*ptep & PTE_P) {  //页表项存在
c01038c4:	8b 45 10             	mov    0x10(%ebp),%eax
c01038c7:	8b 00                	mov    (%eax),%eax
c01038c9:	83 e0 01             	and    $0x1,%eax
c01038cc:	85 c0                	test   %eax,%eax
c01038ce:	74 4d                	je     c010391d <page_remove_pte+0x5f>
        struct Page *page = pte2page(*ptep); //找到页表项
c01038d0:	8b 45 10             	mov    0x10(%ebp),%eax
c01038d3:	8b 00                	mov    (%eax),%eax
c01038d5:	89 04 24             	mov    %eax,(%esp)
c01038d8:	e8 33 f5 ff ff       	call   c0102e10 <pte2page>
c01038dd:	89 45 f4             	mov    %eax,-0xc(%ebp)
        if (page_ref_dec(page) == 0) {  //只被当前进程引用
c01038e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01038e3:	89 04 24             	mov    %eax,(%esp)
c01038e6:	e8 aa f5 ff ff       	call   c0102e95 <page_ref_dec>
c01038eb:	85 c0                	test   %eax,%eax
c01038ed:	75 13                	jne    c0103902 <page_remove_pte+0x44>
            free_page(page); //释放页
c01038ef:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c01038f6:	00 
c01038f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01038fa:	89 04 24             	mov    %eax,(%esp)
c01038fd:	e8 b6 f7 ff ff       	call   c01030b8 <free_pages>
        }
        *ptep = 0; //该页目录项清零
c0103902:	8b 45 10             	mov    0x10(%ebp),%eax
c0103905:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
        tlb_invalidate(pgdir, la); 
c010390b:	8b 45 0c             	mov    0xc(%ebp),%eax
c010390e:	89 44 24 04          	mov    %eax,0x4(%esp)
c0103912:	8b 45 08             	mov    0x8(%ebp),%eax
c0103915:	89 04 24             	mov    %eax,(%esp)
c0103918:	e8 09 01 00 00       	call   c0103a26 <tlb_invalidate>
        //修改的页表是进程正在使用的那些页表，使之无效
    }
}
c010391d:	90                   	nop
c010391e:	c9                   	leave  
c010391f:	c3                   	ret    

c0103920 <page_remove>:

//page_remove - free an Page which is related linear address la and has an validated pte
void
page_remove(pde_t *pgdir, uintptr_t la) {
c0103920:	f3 0f 1e fb          	endbr32 
c0103924:	55                   	push   %ebp
c0103925:	89 e5                	mov    %esp,%ebp
c0103927:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 0);
c010392a:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0103931:	00 
c0103932:	8b 45 0c             	mov    0xc(%ebp),%eax
c0103935:	89 44 24 04          	mov    %eax,0x4(%esp)
c0103939:	8b 45 08             	mov    0x8(%ebp),%eax
c010393c:	89 04 24             	mov    %eax,(%esp)
c010393f:	e8 e0 fd ff ff       	call   c0103724 <get_pte>
c0103944:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep != NULL) {
c0103947:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c010394b:	74 19                	je     c0103966 <page_remove+0x46>
        page_remove_pte(pgdir, la, ptep);
c010394d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103950:	89 44 24 08          	mov    %eax,0x8(%esp)
c0103954:	8b 45 0c             	mov    0xc(%ebp),%eax
c0103957:	89 44 24 04          	mov    %eax,0x4(%esp)
c010395b:	8b 45 08             	mov    0x8(%ebp),%eax
c010395e:	89 04 24             	mov    %eax,(%esp)
c0103961:	e8 58 ff ff ff       	call   c01038be <page_remove_pte>
    }
}
c0103966:	90                   	nop
c0103967:	c9                   	leave  
c0103968:	c3                   	ret    

c0103969 <page_insert>:
//  la:    the linear address need to map
//  perm:  the permission of this Page which is setted in related pte
// return value: always 0
//note: PT is changed, so the TLB need to be invalidate 
int
page_insert(pde_t *pgdir, struct Page *page, uintptr_t la, uint32_t perm) {
c0103969:	f3 0f 1e fb          	endbr32 
c010396d:	55                   	push   %ebp
c010396e:	89 e5                	mov    %esp,%ebp
c0103970:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 1);
c0103973:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
c010397a:	00 
c010397b:	8b 45 10             	mov    0x10(%ebp),%eax
c010397e:	89 44 24 04          	mov    %eax,0x4(%esp)
c0103982:	8b 45 08             	mov    0x8(%ebp),%eax
c0103985:	89 04 24             	mov    %eax,(%esp)
c0103988:	e8 97 fd ff ff       	call   c0103724 <get_pte>
c010398d:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep == NULL) {
c0103990:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0103994:	75 0a                	jne    c01039a0 <page_insert+0x37>
        return -E_NO_MEM;
c0103996:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
c010399b:	e9 84 00 00 00       	jmp    c0103a24 <page_insert+0xbb>
    }
    page_ref_inc(page);
c01039a0:	8b 45 0c             	mov    0xc(%ebp),%eax
c01039a3:	89 04 24             	mov    %eax,(%esp)
c01039a6:	e8 d3 f4 ff ff       	call   c0102e7e <page_ref_inc>
    if (*ptep & PTE_P) {
c01039ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01039ae:	8b 00                	mov    (%eax),%eax
c01039b0:	83 e0 01             	and    $0x1,%eax
c01039b3:	85 c0                	test   %eax,%eax
c01039b5:	74 3e                	je     c01039f5 <page_insert+0x8c>
        struct Page *p = pte2page(*ptep);
c01039b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01039ba:	8b 00                	mov    (%eax),%eax
c01039bc:	89 04 24             	mov    %eax,(%esp)
c01039bf:	e8 4c f4 ff ff       	call   c0102e10 <pte2page>
c01039c4:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (p == page) {
c01039c7:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01039ca:	3b 45 0c             	cmp    0xc(%ebp),%eax
c01039cd:	75 0d                	jne    c01039dc <page_insert+0x73>
            page_ref_dec(page);
c01039cf:	8b 45 0c             	mov    0xc(%ebp),%eax
c01039d2:	89 04 24             	mov    %eax,(%esp)
c01039d5:	e8 bb f4 ff ff       	call   c0102e95 <page_ref_dec>
c01039da:	eb 19                	jmp    c01039f5 <page_insert+0x8c>
        }
        else {
            page_remove_pte(pgdir, la, ptep);
c01039dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01039df:	89 44 24 08          	mov    %eax,0x8(%esp)
c01039e3:	8b 45 10             	mov    0x10(%ebp),%eax
c01039e6:	89 44 24 04          	mov    %eax,0x4(%esp)
c01039ea:	8b 45 08             	mov    0x8(%ebp),%eax
c01039ed:	89 04 24             	mov    %eax,(%esp)
c01039f0:	e8 c9 fe ff ff       	call   c01038be <page_remove_pte>
        }
    }
    *ptep = page2pa(page) | PTE_P | perm;
c01039f5:	8b 45 0c             	mov    0xc(%ebp),%eax
c01039f8:	89 04 24             	mov    %eax,(%esp)
c01039fb:	e8 57 f3 ff ff       	call   c0102d57 <page2pa>
c0103a00:	0b 45 14             	or     0x14(%ebp),%eax
c0103a03:	83 c8 01             	or     $0x1,%eax
c0103a06:	89 c2                	mov    %eax,%edx
c0103a08:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103a0b:	89 10                	mov    %edx,(%eax)
    tlb_invalidate(pgdir, la);
c0103a0d:	8b 45 10             	mov    0x10(%ebp),%eax
c0103a10:	89 44 24 04          	mov    %eax,0x4(%esp)
c0103a14:	8b 45 08             	mov    0x8(%ebp),%eax
c0103a17:	89 04 24             	mov    %eax,(%esp)
c0103a1a:	e8 07 00 00 00       	call   c0103a26 <tlb_invalidate>
    return 0;
c0103a1f:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0103a24:	c9                   	leave  
c0103a25:	c3                   	ret    

c0103a26 <tlb_invalidate>:

// invalidate a TLB entry, but only if the page tables being
// edited are the ones currently in use by the processor.
void
tlb_invalidate(pde_t *pgdir, uintptr_t la) {
c0103a26:	f3 0f 1e fb          	endbr32 
c0103a2a:	55                   	push   %ebp
c0103a2b:	89 e5                	mov    %esp,%ebp
c0103a2d:	83 ec 28             	sub    $0x28,%esp
}

static inline uintptr_t
rcr3(void) {
    uintptr_t cr3;
    asm volatile ("mov %%cr3, %0" : "=r" (cr3) :: "memory");
c0103a30:	0f 20 d8             	mov    %cr3,%eax
c0103a33:	89 45 f0             	mov    %eax,-0x10(%ebp)
    return cr3;
c0103a36:	8b 55 f0             	mov    -0x10(%ebp),%edx
    if (rcr3() == PADDR(pgdir)) {
c0103a39:	8b 45 08             	mov    0x8(%ebp),%eax
c0103a3c:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0103a3f:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
c0103a46:	77 23                	ja     c0103a6b <tlb_invalidate+0x45>
c0103a48:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103a4b:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0103a4f:	c7 44 24 08 a4 6d 10 	movl   $0xc0106da4,0x8(%esp)
c0103a56:	c0 
c0103a57:	c7 44 24 04 dc 01 00 	movl   $0x1dc,0x4(%esp)
c0103a5e:	00 
c0103a5f:	c7 04 24 c8 6d 10 c0 	movl   $0xc0106dc8,(%esp)
c0103a66:	e8 c6 c9 ff ff       	call   c0100431 <__panic>
c0103a6b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103a6e:	05 00 00 00 40       	add    $0x40000000,%eax
c0103a73:	39 d0                	cmp    %edx,%eax
c0103a75:	75 0d                	jne    c0103a84 <tlb_invalidate+0x5e>
        invlpg((void *)la);
c0103a77:	8b 45 0c             	mov    0xc(%ebp),%eax
c0103a7a:	89 45 ec             	mov    %eax,-0x14(%ebp)
}

static inline void
invlpg(void *addr) {
    asm volatile ("invlpg (%0)" :: "r" (addr) : "memory");
c0103a7d:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103a80:	0f 01 38             	invlpg (%eax)
}
c0103a83:	90                   	nop
    }
}
c0103a84:	90                   	nop
c0103a85:	c9                   	leave  
c0103a86:	c3                   	ret    

c0103a87 <check_alloc_page>:

static void
check_alloc_page(void) {
c0103a87:	f3 0f 1e fb          	endbr32 
c0103a8b:	55                   	push   %ebp
c0103a8c:	89 e5                	mov    %esp,%ebp
c0103a8e:	83 ec 18             	sub    $0x18,%esp
    pmm_manager->check();
c0103a91:	a1 70 df 11 c0       	mov    0xc011df70,%eax
c0103a96:	8b 40 18             	mov    0x18(%eax),%eax
c0103a99:	ff d0                	call   *%eax
    cprintf("check_alloc_page() succeeded!\n");
c0103a9b:	c7 04 24 28 6e 10 c0 	movl   $0xc0106e28,(%esp)
c0103aa2:	e8 1e c8 ff ff       	call   c01002c5 <cprintf>
}
c0103aa7:	90                   	nop
c0103aa8:	c9                   	leave  
c0103aa9:	c3                   	ret    

c0103aaa <check_pgdir>:

static void
check_pgdir(void) {
c0103aaa:	f3 0f 1e fb          	endbr32 
c0103aae:	55                   	push   %ebp
c0103aaf:	89 e5                	mov    %esp,%ebp
c0103ab1:	83 ec 38             	sub    $0x38,%esp
    assert(npage <= KMEMSIZE / PGSIZE);
c0103ab4:	a1 80 de 11 c0       	mov    0xc011de80,%eax
c0103ab9:	3d 00 80 03 00       	cmp    $0x38000,%eax
c0103abe:	76 24                	jbe    c0103ae4 <check_pgdir+0x3a>
c0103ac0:	c7 44 24 0c 47 6e 10 	movl   $0xc0106e47,0xc(%esp)
c0103ac7:	c0 
c0103ac8:	c7 44 24 08 ed 6d 10 	movl   $0xc0106ded,0x8(%esp)
c0103acf:	c0 
c0103ad0:	c7 44 24 04 e9 01 00 	movl   $0x1e9,0x4(%esp)
c0103ad7:	00 
c0103ad8:	c7 04 24 c8 6d 10 c0 	movl   $0xc0106dc8,(%esp)
c0103adf:	e8 4d c9 ff ff       	call   c0100431 <__panic>
    assert(boot_pgdir != NULL && (uint32_t)PGOFF(boot_pgdir) == 0);
c0103ae4:	a1 e0 a9 11 c0       	mov    0xc011a9e0,%eax
c0103ae9:	85 c0                	test   %eax,%eax
c0103aeb:	74 0e                	je     c0103afb <check_pgdir+0x51>
c0103aed:	a1 e0 a9 11 c0       	mov    0xc011a9e0,%eax
c0103af2:	25 ff 0f 00 00       	and    $0xfff,%eax
c0103af7:	85 c0                	test   %eax,%eax
c0103af9:	74 24                	je     c0103b1f <check_pgdir+0x75>
c0103afb:	c7 44 24 0c 64 6e 10 	movl   $0xc0106e64,0xc(%esp)
c0103b02:	c0 
c0103b03:	c7 44 24 08 ed 6d 10 	movl   $0xc0106ded,0x8(%esp)
c0103b0a:	c0 
c0103b0b:	c7 44 24 04 ea 01 00 	movl   $0x1ea,0x4(%esp)
c0103b12:	00 
c0103b13:	c7 04 24 c8 6d 10 c0 	movl   $0xc0106dc8,(%esp)
c0103b1a:	e8 12 c9 ff ff       	call   c0100431 <__panic>
    assert(get_page(boot_pgdir, 0x0, NULL) == NULL);
c0103b1f:	a1 e0 a9 11 c0       	mov    0xc011a9e0,%eax
c0103b24:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0103b2b:	00 
c0103b2c:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0103b33:	00 
c0103b34:	89 04 24             	mov    %eax,(%esp)
c0103b37:	e8 25 fd ff ff       	call   c0103861 <get_page>
c0103b3c:	85 c0                	test   %eax,%eax
c0103b3e:	74 24                	je     c0103b64 <check_pgdir+0xba>
c0103b40:	c7 44 24 0c 9c 6e 10 	movl   $0xc0106e9c,0xc(%esp)
c0103b47:	c0 
c0103b48:	c7 44 24 08 ed 6d 10 	movl   $0xc0106ded,0x8(%esp)
c0103b4f:	c0 
c0103b50:	c7 44 24 04 eb 01 00 	movl   $0x1eb,0x4(%esp)
c0103b57:	00 
c0103b58:	c7 04 24 c8 6d 10 c0 	movl   $0xc0106dc8,(%esp)
c0103b5f:	e8 cd c8 ff ff       	call   c0100431 <__panic>

    struct Page *p1, *p2;
    p1 = alloc_page();
c0103b64:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103b6b:	e8 0c f5 ff ff       	call   c010307c <alloc_pages>
c0103b70:	89 45 f4             	mov    %eax,-0xc(%ebp)
    assert(page_insert(boot_pgdir, p1, 0x0, 0) == 0);
c0103b73:	a1 e0 a9 11 c0       	mov    0xc011a9e0,%eax
c0103b78:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
c0103b7f:	00 
c0103b80:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0103b87:	00 
c0103b88:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0103b8b:	89 54 24 04          	mov    %edx,0x4(%esp)
c0103b8f:	89 04 24             	mov    %eax,(%esp)
c0103b92:	e8 d2 fd ff ff       	call   c0103969 <page_insert>
c0103b97:	85 c0                	test   %eax,%eax
c0103b99:	74 24                	je     c0103bbf <check_pgdir+0x115>
c0103b9b:	c7 44 24 0c c4 6e 10 	movl   $0xc0106ec4,0xc(%esp)
c0103ba2:	c0 
c0103ba3:	c7 44 24 08 ed 6d 10 	movl   $0xc0106ded,0x8(%esp)
c0103baa:	c0 
c0103bab:	c7 44 24 04 ef 01 00 	movl   $0x1ef,0x4(%esp)
c0103bb2:	00 
c0103bb3:	c7 04 24 c8 6d 10 c0 	movl   $0xc0106dc8,(%esp)
c0103bba:	e8 72 c8 ff ff       	call   c0100431 <__panic>

    pte_t *ptep;
    assert((ptep = get_pte(boot_pgdir, 0x0, 0)) != NULL);
c0103bbf:	a1 e0 a9 11 c0       	mov    0xc011a9e0,%eax
c0103bc4:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0103bcb:	00 
c0103bcc:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0103bd3:	00 
c0103bd4:	89 04 24             	mov    %eax,(%esp)
c0103bd7:	e8 48 fb ff ff       	call   c0103724 <get_pte>
c0103bdc:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0103bdf:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0103be3:	75 24                	jne    c0103c09 <check_pgdir+0x15f>
c0103be5:	c7 44 24 0c f0 6e 10 	movl   $0xc0106ef0,0xc(%esp)
c0103bec:	c0 
c0103bed:	c7 44 24 08 ed 6d 10 	movl   $0xc0106ded,0x8(%esp)
c0103bf4:	c0 
c0103bf5:	c7 44 24 04 f2 01 00 	movl   $0x1f2,0x4(%esp)
c0103bfc:	00 
c0103bfd:	c7 04 24 c8 6d 10 c0 	movl   $0xc0106dc8,(%esp)
c0103c04:	e8 28 c8 ff ff       	call   c0100431 <__panic>
    assert(pte2page(*ptep) == p1);
c0103c09:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103c0c:	8b 00                	mov    (%eax),%eax
c0103c0e:	89 04 24             	mov    %eax,(%esp)
c0103c11:	e8 fa f1 ff ff       	call   c0102e10 <pte2page>
c0103c16:	39 45 f4             	cmp    %eax,-0xc(%ebp)
c0103c19:	74 24                	je     c0103c3f <check_pgdir+0x195>
c0103c1b:	c7 44 24 0c 1d 6f 10 	movl   $0xc0106f1d,0xc(%esp)
c0103c22:	c0 
c0103c23:	c7 44 24 08 ed 6d 10 	movl   $0xc0106ded,0x8(%esp)
c0103c2a:	c0 
c0103c2b:	c7 44 24 04 f3 01 00 	movl   $0x1f3,0x4(%esp)
c0103c32:	00 
c0103c33:	c7 04 24 c8 6d 10 c0 	movl   $0xc0106dc8,(%esp)
c0103c3a:	e8 f2 c7 ff ff       	call   c0100431 <__panic>
    assert(page_ref(p1) == 1);
c0103c3f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103c42:	89 04 24             	mov    %eax,(%esp)
c0103c45:	e8 1c f2 ff ff       	call   c0102e66 <page_ref>
c0103c4a:	83 f8 01             	cmp    $0x1,%eax
c0103c4d:	74 24                	je     c0103c73 <check_pgdir+0x1c9>
c0103c4f:	c7 44 24 0c 33 6f 10 	movl   $0xc0106f33,0xc(%esp)
c0103c56:	c0 
c0103c57:	c7 44 24 08 ed 6d 10 	movl   $0xc0106ded,0x8(%esp)
c0103c5e:	c0 
c0103c5f:	c7 44 24 04 f4 01 00 	movl   $0x1f4,0x4(%esp)
c0103c66:	00 
c0103c67:	c7 04 24 c8 6d 10 c0 	movl   $0xc0106dc8,(%esp)
c0103c6e:	e8 be c7 ff ff       	call   c0100431 <__panic>

    ptep = &((pte_t *)KADDR(PDE_ADDR(boot_pgdir[0])))[1];
c0103c73:	a1 e0 a9 11 c0       	mov    0xc011a9e0,%eax
c0103c78:	8b 00                	mov    (%eax),%eax
c0103c7a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0103c7f:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0103c82:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103c85:	c1 e8 0c             	shr    $0xc,%eax
c0103c88:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0103c8b:	a1 80 de 11 c0       	mov    0xc011de80,%eax
c0103c90:	39 45 e8             	cmp    %eax,-0x18(%ebp)
c0103c93:	72 23                	jb     c0103cb8 <check_pgdir+0x20e>
c0103c95:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103c98:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0103c9c:	c7 44 24 08 00 6d 10 	movl   $0xc0106d00,0x8(%esp)
c0103ca3:	c0 
c0103ca4:	c7 44 24 04 f6 01 00 	movl   $0x1f6,0x4(%esp)
c0103cab:	00 
c0103cac:	c7 04 24 c8 6d 10 c0 	movl   $0xc0106dc8,(%esp)
c0103cb3:	e8 79 c7 ff ff       	call   c0100431 <__panic>
c0103cb8:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103cbb:	2d 00 00 00 40       	sub    $0x40000000,%eax
c0103cc0:	83 c0 04             	add    $0x4,%eax
c0103cc3:	89 45 f0             	mov    %eax,-0x10(%ebp)
    assert(get_pte(boot_pgdir, PGSIZE, 0) == ptep);
c0103cc6:	a1 e0 a9 11 c0       	mov    0xc011a9e0,%eax
c0103ccb:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0103cd2:	00 
c0103cd3:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c0103cda:	00 
c0103cdb:	89 04 24             	mov    %eax,(%esp)
c0103cde:	e8 41 fa ff ff       	call   c0103724 <get_pte>
c0103ce3:	39 45 f0             	cmp    %eax,-0x10(%ebp)
c0103ce6:	74 24                	je     c0103d0c <check_pgdir+0x262>
c0103ce8:	c7 44 24 0c 48 6f 10 	movl   $0xc0106f48,0xc(%esp)
c0103cef:	c0 
c0103cf0:	c7 44 24 08 ed 6d 10 	movl   $0xc0106ded,0x8(%esp)
c0103cf7:	c0 
c0103cf8:	c7 44 24 04 f7 01 00 	movl   $0x1f7,0x4(%esp)
c0103cff:	00 
c0103d00:	c7 04 24 c8 6d 10 c0 	movl   $0xc0106dc8,(%esp)
c0103d07:	e8 25 c7 ff ff       	call   c0100431 <__panic>

    p2 = alloc_page();
c0103d0c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103d13:	e8 64 f3 ff ff       	call   c010307c <alloc_pages>
c0103d18:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    assert(page_insert(boot_pgdir, p2, PGSIZE, PTE_U | PTE_W) == 0);
c0103d1b:	a1 e0 a9 11 c0       	mov    0xc011a9e0,%eax
c0103d20:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
c0103d27:	00 
c0103d28:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
c0103d2f:	00 
c0103d30:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0103d33:	89 54 24 04          	mov    %edx,0x4(%esp)
c0103d37:	89 04 24             	mov    %eax,(%esp)
c0103d3a:	e8 2a fc ff ff       	call   c0103969 <page_insert>
c0103d3f:	85 c0                	test   %eax,%eax
c0103d41:	74 24                	je     c0103d67 <check_pgdir+0x2bd>
c0103d43:	c7 44 24 0c 70 6f 10 	movl   $0xc0106f70,0xc(%esp)
c0103d4a:	c0 
c0103d4b:	c7 44 24 08 ed 6d 10 	movl   $0xc0106ded,0x8(%esp)
c0103d52:	c0 
c0103d53:	c7 44 24 04 fa 01 00 	movl   $0x1fa,0x4(%esp)
c0103d5a:	00 
c0103d5b:	c7 04 24 c8 6d 10 c0 	movl   $0xc0106dc8,(%esp)
c0103d62:	e8 ca c6 ff ff       	call   c0100431 <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
c0103d67:	a1 e0 a9 11 c0       	mov    0xc011a9e0,%eax
c0103d6c:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0103d73:	00 
c0103d74:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c0103d7b:	00 
c0103d7c:	89 04 24             	mov    %eax,(%esp)
c0103d7f:	e8 a0 f9 ff ff       	call   c0103724 <get_pte>
c0103d84:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0103d87:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0103d8b:	75 24                	jne    c0103db1 <check_pgdir+0x307>
c0103d8d:	c7 44 24 0c a8 6f 10 	movl   $0xc0106fa8,0xc(%esp)
c0103d94:	c0 
c0103d95:	c7 44 24 08 ed 6d 10 	movl   $0xc0106ded,0x8(%esp)
c0103d9c:	c0 
c0103d9d:	c7 44 24 04 fb 01 00 	movl   $0x1fb,0x4(%esp)
c0103da4:	00 
c0103da5:	c7 04 24 c8 6d 10 c0 	movl   $0xc0106dc8,(%esp)
c0103dac:	e8 80 c6 ff ff       	call   c0100431 <__panic>
    assert(*ptep & PTE_U);
c0103db1:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103db4:	8b 00                	mov    (%eax),%eax
c0103db6:	83 e0 04             	and    $0x4,%eax
c0103db9:	85 c0                	test   %eax,%eax
c0103dbb:	75 24                	jne    c0103de1 <check_pgdir+0x337>
c0103dbd:	c7 44 24 0c d8 6f 10 	movl   $0xc0106fd8,0xc(%esp)
c0103dc4:	c0 
c0103dc5:	c7 44 24 08 ed 6d 10 	movl   $0xc0106ded,0x8(%esp)
c0103dcc:	c0 
c0103dcd:	c7 44 24 04 fc 01 00 	movl   $0x1fc,0x4(%esp)
c0103dd4:	00 
c0103dd5:	c7 04 24 c8 6d 10 c0 	movl   $0xc0106dc8,(%esp)
c0103ddc:	e8 50 c6 ff ff       	call   c0100431 <__panic>
    assert(*ptep & PTE_W);
c0103de1:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103de4:	8b 00                	mov    (%eax),%eax
c0103de6:	83 e0 02             	and    $0x2,%eax
c0103de9:	85 c0                	test   %eax,%eax
c0103deb:	75 24                	jne    c0103e11 <check_pgdir+0x367>
c0103ded:	c7 44 24 0c e6 6f 10 	movl   $0xc0106fe6,0xc(%esp)
c0103df4:	c0 
c0103df5:	c7 44 24 08 ed 6d 10 	movl   $0xc0106ded,0x8(%esp)
c0103dfc:	c0 
c0103dfd:	c7 44 24 04 fd 01 00 	movl   $0x1fd,0x4(%esp)
c0103e04:	00 
c0103e05:	c7 04 24 c8 6d 10 c0 	movl   $0xc0106dc8,(%esp)
c0103e0c:	e8 20 c6 ff ff       	call   c0100431 <__panic>
    assert(boot_pgdir[0] & PTE_U);
c0103e11:	a1 e0 a9 11 c0       	mov    0xc011a9e0,%eax
c0103e16:	8b 00                	mov    (%eax),%eax
c0103e18:	83 e0 04             	and    $0x4,%eax
c0103e1b:	85 c0                	test   %eax,%eax
c0103e1d:	75 24                	jne    c0103e43 <check_pgdir+0x399>
c0103e1f:	c7 44 24 0c f4 6f 10 	movl   $0xc0106ff4,0xc(%esp)
c0103e26:	c0 
c0103e27:	c7 44 24 08 ed 6d 10 	movl   $0xc0106ded,0x8(%esp)
c0103e2e:	c0 
c0103e2f:	c7 44 24 04 fe 01 00 	movl   $0x1fe,0x4(%esp)
c0103e36:	00 
c0103e37:	c7 04 24 c8 6d 10 c0 	movl   $0xc0106dc8,(%esp)
c0103e3e:	e8 ee c5 ff ff       	call   c0100431 <__panic>
    assert(page_ref(p2) == 1);
c0103e43:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103e46:	89 04 24             	mov    %eax,(%esp)
c0103e49:	e8 18 f0 ff ff       	call   c0102e66 <page_ref>
c0103e4e:	83 f8 01             	cmp    $0x1,%eax
c0103e51:	74 24                	je     c0103e77 <check_pgdir+0x3cd>
c0103e53:	c7 44 24 0c 0a 70 10 	movl   $0xc010700a,0xc(%esp)
c0103e5a:	c0 
c0103e5b:	c7 44 24 08 ed 6d 10 	movl   $0xc0106ded,0x8(%esp)
c0103e62:	c0 
c0103e63:	c7 44 24 04 ff 01 00 	movl   $0x1ff,0x4(%esp)
c0103e6a:	00 
c0103e6b:	c7 04 24 c8 6d 10 c0 	movl   $0xc0106dc8,(%esp)
c0103e72:	e8 ba c5 ff ff       	call   c0100431 <__panic>

    assert(page_insert(boot_pgdir, p1, PGSIZE, 0) == 0);
c0103e77:	a1 e0 a9 11 c0       	mov    0xc011a9e0,%eax
c0103e7c:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
c0103e83:	00 
c0103e84:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
c0103e8b:	00 
c0103e8c:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0103e8f:	89 54 24 04          	mov    %edx,0x4(%esp)
c0103e93:	89 04 24             	mov    %eax,(%esp)
c0103e96:	e8 ce fa ff ff       	call   c0103969 <page_insert>
c0103e9b:	85 c0                	test   %eax,%eax
c0103e9d:	74 24                	je     c0103ec3 <check_pgdir+0x419>
c0103e9f:	c7 44 24 0c 1c 70 10 	movl   $0xc010701c,0xc(%esp)
c0103ea6:	c0 
c0103ea7:	c7 44 24 08 ed 6d 10 	movl   $0xc0106ded,0x8(%esp)
c0103eae:	c0 
c0103eaf:	c7 44 24 04 01 02 00 	movl   $0x201,0x4(%esp)
c0103eb6:	00 
c0103eb7:	c7 04 24 c8 6d 10 c0 	movl   $0xc0106dc8,(%esp)
c0103ebe:	e8 6e c5 ff ff       	call   c0100431 <__panic>
    assert(page_ref(p1) == 2);
c0103ec3:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103ec6:	89 04 24             	mov    %eax,(%esp)
c0103ec9:	e8 98 ef ff ff       	call   c0102e66 <page_ref>
c0103ece:	83 f8 02             	cmp    $0x2,%eax
c0103ed1:	74 24                	je     c0103ef7 <check_pgdir+0x44d>
c0103ed3:	c7 44 24 0c 48 70 10 	movl   $0xc0107048,0xc(%esp)
c0103eda:	c0 
c0103edb:	c7 44 24 08 ed 6d 10 	movl   $0xc0106ded,0x8(%esp)
c0103ee2:	c0 
c0103ee3:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
c0103eea:	00 
c0103eeb:	c7 04 24 c8 6d 10 c0 	movl   $0xc0106dc8,(%esp)
c0103ef2:	e8 3a c5 ff ff       	call   c0100431 <__panic>
    assert(page_ref(p2) == 0);
c0103ef7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103efa:	89 04 24             	mov    %eax,(%esp)
c0103efd:	e8 64 ef ff ff       	call   c0102e66 <page_ref>
c0103f02:	85 c0                	test   %eax,%eax
c0103f04:	74 24                	je     c0103f2a <check_pgdir+0x480>
c0103f06:	c7 44 24 0c 5a 70 10 	movl   $0xc010705a,0xc(%esp)
c0103f0d:	c0 
c0103f0e:	c7 44 24 08 ed 6d 10 	movl   $0xc0106ded,0x8(%esp)
c0103f15:	c0 
c0103f16:	c7 44 24 04 03 02 00 	movl   $0x203,0x4(%esp)
c0103f1d:	00 
c0103f1e:	c7 04 24 c8 6d 10 c0 	movl   $0xc0106dc8,(%esp)
c0103f25:	e8 07 c5 ff ff       	call   c0100431 <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
c0103f2a:	a1 e0 a9 11 c0       	mov    0xc011a9e0,%eax
c0103f2f:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0103f36:	00 
c0103f37:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c0103f3e:	00 
c0103f3f:	89 04 24             	mov    %eax,(%esp)
c0103f42:	e8 dd f7 ff ff       	call   c0103724 <get_pte>
c0103f47:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0103f4a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0103f4e:	75 24                	jne    c0103f74 <check_pgdir+0x4ca>
c0103f50:	c7 44 24 0c a8 6f 10 	movl   $0xc0106fa8,0xc(%esp)
c0103f57:	c0 
c0103f58:	c7 44 24 08 ed 6d 10 	movl   $0xc0106ded,0x8(%esp)
c0103f5f:	c0 
c0103f60:	c7 44 24 04 04 02 00 	movl   $0x204,0x4(%esp)
c0103f67:	00 
c0103f68:	c7 04 24 c8 6d 10 c0 	movl   $0xc0106dc8,(%esp)
c0103f6f:	e8 bd c4 ff ff       	call   c0100431 <__panic>
    assert(pte2page(*ptep) == p1);
c0103f74:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103f77:	8b 00                	mov    (%eax),%eax
c0103f79:	89 04 24             	mov    %eax,(%esp)
c0103f7c:	e8 8f ee ff ff       	call   c0102e10 <pte2page>
c0103f81:	39 45 f4             	cmp    %eax,-0xc(%ebp)
c0103f84:	74 24                	je     c0103faa <check_pgdir+0x500>
c0103f86:	c7 44 24 0c 1d 6f 10 	movl   $0xc0106f1d,0xc(%esp)
c0103f8d:	c0 
c0103f8e:	c7 44 24 08 ed 6d 10 	movl   $0xc0106ded,0x8(%esp)
c0103f95:	c0 
c0103f96:	c7 44 24 04 05 02 00 	movl   $0x205,0x4(%esp)
c0103f9d:	00 
c0103f9e:	c7 04 24 c8 6d 10 c0 	movl   $0xc0106dc8,(%esp)
c0103fa5:	e8 87 c4 ff ff       	call   c0100431 <__panic>
    assert((*ptep & PTE_U) == 0);
c0103faa:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103fad:	8b 00                	mov    (%eax),%eax
c0103faf:	83 e0 04             	and    $0x4,%eax
c0103fb2:	85 c0                	test   %eax,%eax
c0103fb4:	74 24                	je     c0103fda <check_pgdir+0x530>
c0103fb6:	c7 44 24 0c 6c 70 10 	movl   $0xc010706c,0xc(%esp)
c0103fbd:	c0 
c0103fbe:	c7 44 24 08 ed 6d 10 	movl   $0xc0106ded,0x8(%esp)
c0103fc5:	c0 
c0103fc6:	c7 44 24 04 06 02 00 	movl   $0x206,0x4(%esp)
c0103fcd:	00 
c0103fce:	c7 04 24 c8 6d 10 c0 	movl   $0xc0106dc8,(%esp)
c0103fd5:	e8 57 c4 ff ff       	call   c0100431 <__panic>

    page_remove(boot_pgdir, 0x0);
c0103fda:	a1 e0 a9 11 c0       	mov    0xc011a9e0,%eax
c0103fdf:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0103fe6:	00 
c0103fe7:	89 04 24             	mov    %eax,(%esp)
c0103fea:	e8 31 f9 ff ff       	call   c0103920 <page_remove>
    assert(page_ref(p1) == 1);
c0103fef:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103ff2:	89 04 24             	mov    %eax,(%esp)
c0103ff5:	e8 6c ee ff ff       	call   c0102e66 <page_ref>
c0103ffa:	83 f8 01             	cmp    $0x1,%eax
c0103ffd:	74 24                	je     c0104023 <check_pgdir+0x579>
c0103fff:	c7 44 24 0c 33 6f 10 	movl   $0xc0106f33,0xc(%esp)
c0104006:	c0 
c0104007:	c7 44 24 08 ed 6d 10 	movl   $0xc0106ded,0x8(%esp)
c010400e:	c0 
c010400f:	c7 44 24 04 09 02 00 	movl   $0x209,0x4(%esp)
c0104016:	00 
c0104017:	c7 04 24 c8 6d 10 c0 	movl   $0xc0106dc8,(%esp)
c010401e:	e8 0e c4 ff ff       	call   c0100431 <__panic>
    assert(page_ref(p2) == 0);
c0104023:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104026:	89 04 24             	mov    %eax,(%esp)
c0104029:	e8 38 ee ff ff       	call   c0102e66 <page_ref>
c010402e:	85 c0                	test   %eax,%eax
c0104030:	74 24                	je     c0104056 <check_pgdir+0x5ac>
c0104032:	c7 44 24 0c 5a 70 10 	movl   $0xc010705a,0xc(%esp)
c0104039:	c0 
c010403a:	c7 44 24 08 ed 6d 10 	movl   $0xc0106ded,0x8(%esp)
c0104041:	c0 
c0104042:	c7 44 24 04 0a 02 00 	movl   $0x20a,0x4(%esp)
c0104049:	00 
c010404a:	c7 04 24 c8 6d 10 c0 	movl   $0xc0106dc8,(%esp)
c0104051:	e8 db c3 ff ff       	call   c0100431 <__panic>

    page_remove(boot_pgdir, PGSIZE);
c0104056:	a1 e0 a9 11 c0       	mov    0xc011a9e0,%eax
c010405b:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c0104062:	00 
c0104063:	89 04 24             	mov    %eax,(%esp)
c0104066:	e8 b5 f8 ff ff       	call   c0103920 <page_remove>
    assert(page_ref(p1) == 0);
c010406b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010406e:	89 04 24             	mov    %eax,(%esp)
c0104071:	e8 f0 ed ff ff       	call   c0102e66 <page_ref>
c0104076:	85 c0                	test   %eax,%eax
c0104078:	74 24                	je     c010409e <check_pgdir+0x5f4>
c010407a:	c7 44 24 0c 81 70 10 	movl   $0xc0107081,0xc(%esp)
c0104081:	c0 
c0104082:	c7 44 24 08 ed 6d 10 	movl   $0xc0106ded,0x8(%esp)
c0104089:	c0 
c010408a:	c7 44 24 04 0d 02 00 	movl   $0x20d,0x4(%esp)
c0104091:	00 
c0104092:	c7 04 24 c8 6d 10 c0 	movl   $0xc0106dc8,(%esp)
c0104099:	e8 93 c3 ff ff       	call   c0100431 <__panic>
    assert(page_ref(p2) == 0);
c010409e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01040a1:	89 04 24             	mov    %eax,(%esp)
c01040a4:	e8 bd ed ff ff       	call   c0102e66 <page_ref>
c01040a9:	85 c0                	test   %eax,%eax
c01040ab:	74 24                	je     c01040d1 <check_pgdir+0x627>
c01040ad:	c7 44 24 0c 5a 70 10 	movl   $0xc010705a,0xc(%esp)
c01040b4:	c0 
c01040b5:	c7 44 24 08 ed 6d 10 	movl   $0xc0106ded,0x8(%esp)
c01040bc:	c0 
c01040bd:	c7 44 24 04 0e 02 00 	movl   $0x20e,0x4(%esp)
c01040c4:	00 
c01040c5:	c7 04 24 c8 6d 10 c0 	movl   $0xc0106dc8,(%esp)
c01040cc:	e8 60 c3 ff ff       	call   c0100431 <__panic>

    assert(page_ref(pde2page(boot_pgdir[0])) == 1);
c01040d1:	a1 e0 a9 11 c0       	mov    0xc011a9e0,%eax
c01040d6:	8b 00                	mov    (%eax),%eax
c01040d8:	89 04 24             	mov    %eax,(%esp)
c01040db:	e8 6e ed ff ff       	call   c0102e4e <pde2page>
c01040e0:	89 04 24             	mov    %eax,(%esp)
c01040e3:	e8 7e ed ff ff       	call   c0102e66 <page_ref>
c01040e8:	83 f8 01             	cmp    $0x1,%eax
c01040eb:	74 24                	je     c0104111 <check_pgdir+0x667>
c01040ed:	c7 44 24 0c 94 70 10 	movl   $0xc0107094,0xc(%esp)
c01040f4:	c0 
c01040f5:	c7 44 24 08 ed 6d 10 	movl   $0xc0106ded,0x8(%esp)
c01040fc:	c0 
c01040fd:	c7 44 24 04 10 02 00 	movl   $0x210,0x4(%esp)
c0104104:	00 
c0104105:	c7 04 24 c8 6d 10 c0 	movl   $0xc0106dc8,(%esp)
c010410c:	e8 20 c3 ff ff       	call   c0100431 <__panic>
    free_page(pde2page(boot_pgdir[0]));
c0104111:	a1 e0 a9 11 c0       	mov    0xc011a9e0,%eax
c0104116:	8b 00                	mov    (%eax),%eax
c0104118:	89 04 24             	mov    %eax,(%esp)
c010411b:	e8 2e ed ff ff       	call   c0102e4e <pde2page>
c0104120:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0104127:	00 
c0104128:	89 04 24             	mov    %eax,(%esp)
c010412b:	e8 88 ef ff ff       	call   c01030b8 <free_pages>
    boot_pgdir[0] = 0;
c0104130:	a1 e0 a9 11 c0       	mov    0xc011a9e0,%eax
c0104135:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    cprintf("check_pgdir() succeeded!\n");
c010413b:	c7 04 24 bb 70 10 c0 	movl   $0xc01070bb,(%esp)
c0104142:	e8 7e c1 ff ff       	call   c01002c5 <cprintf>
}
c0104147:	90                   	nop
c0104148:	c9                   	leave  
c0104149:	c3                   	ret    

c010414a <check_boot_pgdir>:

static void
check_boot_pgdir(void) {
c010414a:	f3 0f 1e fb          	endbr32 
c010414e:	55                   	push   %ebp
c010414f:	89 e5                	mov    %esp,%ebp
c0104151:	83 ec 38             	sub    $0x38,%esp
    pte_t *ptep;
    int i;
    for (i = 0; i < npage; i += PGSIZE) {
c0104154:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c010415b:	e9 ca 00 00 00       	jmp    c010422a <check_boot_pgdir+0xe0>
        assert((ptep = get_pte(boot_pgdir, (uintptr_t)KADDR(i), 0)) != NULL);
c0104160:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104163:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0104166:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104169:	c1 e8 0c             	shr    $0xc,%eax
c010416c:	89 45 e0             	mov    %eax,-0x20(%ebp)
c010416f:	a1 80 de 11 c0       	mov    0xc011de80,%eax
c0104174:	39 45 e0             	cmp    %eax,-0x20(%ebp)
c0104177:	72 23                	jb     c010419c <check_boot_pgdir+0x52>
c0104179:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010417c:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0104180:	c7 44 24 08 00 6d 10 	movl   $0xc0106d00,0x8(%esp)
c0104187:	c0 
c0104188:	c7 44 24 04 1c 02 00 	movl   $0x21c,0x4(%esp)
c010418f:	00 
c0104190:	c7 04 24 c8 6d 10 c0 	movl   $0xc0106dc8,(%esp)
c0104197:	e8 95 c2 ff ff       	call   c0100431 <__panic>
c010419c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010419f:	2d 00 00 00 40       	sub    $0x40000000,%eax
c01041a4:	89 c2                	mov    %eax,%edx
c01041a6:	a1 e0 a9 11 c0       	mov    0xc011a9e0,%eax
c01041ab:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c01041b2:	00 
c01041b3:	89 54 24 04          	mov    %edx,0x4(%esp)
c01041b7:	89 04 24             	mov    %eax,(%esp)
c01041ba:	e8 65 f5 ff ff       	call   c0103724 <get_pte>
c01041bf:	89 45 dc             	mov    %eax,-0x24(%ebp)
c01041c2:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
c01041c6:	75 24                	jne    c01041ec <check_boot_pgdir+0xa2>
c01041c8:	c7 44 24 0c d8 70 10 	movl   $0xc01070d8,0xc(%esp)
c01041cf:	c0 
c01041d0:	c7 44 24 08 ed 6d 10 	movl   $0xc0106ded,0x8(%esp)
c01041d7:	c0 
c01041d8:	c7 44 24 04 1c 02 00 	movl   $0x21c,0x4(%esp)
c01041df:	00 
c01041e0:	c7 04 24 c8 6d 10 c0 	movl   $0xc0106dc8,(%esp)
c01041e7:	e8 45 c2 ff ff       	call   c0100431 <__panic>
        assert(PTE_ADDR(*ptep) == i);
c01041ec:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01041ef:	8b 00                	mov    (%eax),%eax
c01041f1:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c01041f6:	89 c2                	mov    %eax,%edx
c01041f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01041fb:	39 c2                	cmp    %eax,%edx
c01041fd:	74 24                	je     c0104223 <check_boot_pgdir+0xd9>
c01041ff:	c7 44 24 0c 15 71 10 	movl   $0xc0107115,0xc(%esp)
c0104206:	c0 
c0104207:	c7 44 24 08 ed 6d 10 	movl   $0xc0106ded,0x8(%esp)
c010420e:	c0 
c010420f:	c7 44 24 04 1d 02 00 	movl   $0x21d,0x4(%esp)
c0104216:	00 
c0104217:	c7 04 24 c8 6d 10 c0 	movl   $0xc0106dc8,(%esp)
c010421e:	e8 0e c2 ff ff       	call   c0100431 <__panic>
    for (i = 0; i < npage; i += PGSIZE) {
c0104223:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
c010422a:	8b 55 f4             	mov    -0xc(%ebp),%edx
c010422d:	a1 80 de 11 c0       	mov    0xc011de80,%eax
c0104232:	39 c2                	cmp    %eax,%edx
c0104234:	0f 82 26 ff ff ff    	jb     c0104160 <check_boot_pgdir+0x16>
    }

    assert(PDE_ADDR(boot_pgdir[PDX(VPT)]) == PADDR(boot_pgdir));
c010423a:	a1 e0 a9 11 c0       	mov    0xc011a9e0,%eax
c010423f:	05 ac 0f 00 00       	add    $0xfac,%eax
c0104244:	8b 00                	mov    (%eax),%eax
c0104246:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c010424b:	89 c2                	mov    %eax,%edx
c010424d:	a1 e0 a9 11 c0       	mov    0xc011a9e0,%eax
c0104252:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0104255:	81 7d f0 ff ff ff bf 	cmpl   $0xbfffffff,-0x10(%ebp)
c010425c:	77 23                	ja     c0104281 <check_boot_pgdir+0x137>
c010425e:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104261:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0104265:	c7 44 24 08 a4 6d 10 	movl   $0xc0106da4,0x8(%esp)
c010426c:	c0 
c010426d:	c7 44 24 04 20 02 00 	movl   $0x220,0x4(%esp)
c0104274:	00 
c0104275:	c7 04 24 c8 6d 10 c0 	movl   $0xc0106dc8,(%esp)
c010427c:	e8 b0 c1 ff ff       	call   c0100431 <__panic>
c0104281:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104284:	05 00 00 00 40       	add    $0x40000000,%eax
c0104289:	39 d0                	cmp    %edx,%eax
c010428b:	74 24                	je     c01042b1 <check_boot_pgdir+0x167>
c010428d:	c7 44 24 0c 2c 71 10 	movl   $0xc010712c,0xc(%esp)
c0104294:	c0 
c0104295:	c7 44 24 08 ed 6d 10 	movl   $0xc0106ded,0x8(%esp)
c010429c:	c0 
c010429d:	c7 44 24 04 20 02 00 	movl   $0x220,0x4(%esp)
c01042a4:	00 
c01042a5:	c7 04 24 c8 6d 10 c0 	movl   $0xc0106dc8,(%esp)
c01042ac:	e8 80 c1 ff ff       	call   c0100431 <__panic>

    assert(boot_pgdir[0] == 0);
c01042b1:	a1 e0 a9 11 c0       	mov    0xc011a9e0,%eax
c01042b6:	8b 00                	mov    (%eax),%eax
c01042b8:	85 c0                	test   %eax,%eax
c01042ba:	74 24                	je     c01042e0 <check_boot_pgdir+0x196>
c01042bc:	c7 44 24 0c 60 71 10 	movl   $0xc0107160,0xc(%esp)
c01042c3:	c0 
c01042c4:	c7 44 24 08 ed 6d 10 	movl   $0xc0106ded,0x8(%esp)
c01042cb:	c0 
c01042cc:	c7 44 24 04 22 02 00 	movl   $0x222,0x4(%esp)
c01042d3:	00 
c01042d4:	c7 04 24 c8 6d 10 c0 	movl   $0xc0106dc8,(%esp)
c01042db:	e8 51 c1 ff ff       	call   c0100431 <__panic>

    struct Page *p;
    p = alloc_page();
c01042e0:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01042e7:	e8 90 ed ff ff       	call   c010307c <alloc_pages>
c01042ec:	89 45 ec             	mov    %eax,-0x14(%ebp)
    assert(page_insert(boot_pgdir, p, 0x100, PTE_W) == 0);
c01042ef:	a1 e0 a9 11 c0       	mov    0xc011a9e0,%eax
c01042f4:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
c01042fb:	00 
c01042fc:	c7 44 24 08 00 01 00 	movl   $0x100,0x8(%esp)
c0104303:	00 
c0104304:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0104307:	89 54 24 04          	mov    %edx,0x4(%esp)
c010430b:	89 04 24             	mov    %eax,(%esp)
c010430e:	e8 56 f6 ff ff       	call   c0103969 <page_insert>
c0104313:	85 c0                	test   %eax,%eax
c0104315:	74 24                	je     c010433b <check_boot_pgdir+0x1f1>
c0104317:	c7 44 24 0c 74 71 10 	movl   $0xc0107174,0xc(%esp)
c010431e:	c0 
c010431f:	c7 44 24 08 ed 6d 10 	movl   $0xc0106ded,0x8(%esp)
c0104326:	c0 
c0104327:	c7 44 24 04 26 02 00 	movl   $0x226,0x4(%esp)
c010432e:	00 
c010432f:	c7 04 24 c8 6d 10 c0 	movl   $0xc0106dc8,(%esp)
c0104336:	e8 f6 c0 ff ff       	call   c0100431 <__panic>
    assert(page_ref(p) == 1);
c010433b:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010433e:	89 04 24             	mov    %eax,(%esp)
c0104341:	e8 20 eb ff ff       	call   c0102e66 <page_ref>
c0104346:	83 f8 01             	cmp    $0x1,%eax
c0104349:	74 24                	je     c010436f <check_boot_pgdir+0x225>
c010434b:	c7 44 24 0c a2 71 10 	movl   $0xc01071a2,0xc(%esp)
c0104352:	c0 
c0104353:	c7 44 24 08 ed 6d 10 	movl   $0xc0106ded,0x8(%esp)
c010435a:	c0 
c010435b:	c7 44 24 04 27 02 00 	movl   $0x227,0x4(%esp)
c0104362:	00 
c0104363:	c7 04 24 c8 6d 10 c0 	movl   $0xc0106dc8,(%esp)
c010436a:	e8 c2 c0 ff ff       	call   c0100431 <__panic>
    assert(page_insert(boot_pgdir, p, 0x100 + PGSIZE, PTE_W) == 0);
c010436f:	a1 e0 a9 11 c0       	mov    0xc011a9e0,%eax
c0104374:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
c010437b:	00 
c010437c:	c7 44 24 08 00 11 00 	movl   $0x1100,0x8(%esp)
c0104383:	00 
c0104384:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0104387:	89 54 24 04          	mov    %edx,0x4(%esp)
c010438b:	89 04 24             	mov    %eax,(%esp)
c010438e:	e8 d6 f5 ff ff       	call   c0103969 <page_insert>
c0104393:	85 c0                	test   %eax,%eax
c0104395:	74 24                	je     c01043bb <check_boot_pgdir+0x271>
c0104397:	c7 44 24 0c b4 71 10 	movl   $0xc01071b4,0xc(%esp)
c010439e:	c0 
c010439f:	c7 44 24 08 ed 6d 10 	movl   $0xc0106ded,0x8(%esp)
c01043a6:	c0 
c01043a7:	c7 44 24 04 28 02 00 	movl   $0x228,0x4(%esp)
c01043ae:	00 
c01043af:	c7 04 24 c8 6d 10 c0 	movl   $0xc0106dc8,(%esp)
c01043b6:	e8 76 c0 ff ff       	call   c0100431 <__panic>
    assert(page_ref(p) == 2);
c01043bb:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01043be:	89 04 24             	mov    %eax,(%esp)
c01043c1:	e8 a0 ea ff ff       	call   c0102e66 <page_ref>
c01043c6:	83 f8 02             	cmp    $0x2,%eax
c01043c9:	74 24                	je     c01043ef <check_boot_pgdir+0x2a5>
c01043cb:	c7 44 24 0c eb 71 10 	movl   $0xc01071eb,0xc(%esp)
c01043d2:	c0 
c01043d3:	c7 44 24 08 ed 6d 10 	movl   $0xc0106ded,0x8(%esp)
c01043da:	c0 
c01043db:	c7 44 24 04 29 02 00 	movl   $0x229,0x4(%esp)
c01043e2:	00 
c01043e3:	c7 04 24 c8 6d 10 c0 	movl   $0xc0106dc8,(%esp)
c01043ea:	e8 42 c0 ff ff       	call   c0100431 <__panic>

    const char *str = "ucore: Hello world!!";
c01043ef:	c7 45 e8 fc 71 10 c0 	movl   $0xc01071fc,-0x18(%ebp)
    strcpy((void *)0x100, str);
c01043f6:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01043f9:	89 44 24 04          	mov    %eax,0x4(%esp)
c01043fd:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
c0104404:	e8 31 16 00 00       	call   c0105a3a <strcpy>
    assert(strcmp((void *)0x100, (void *)(0x100 + PGSIZE)) == 0);
c0104409:	c7 44 24 04 00 11 00 	movl   $0x1100,0x4(%esp)
c0104410:	00 
c0104411:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
c0104418:	e8 9b 16 00 00       	call   c0105ab8 <strcmp>
c010441d:	85 c0                	test   %eax,%eax
c010441f:	74 24                	je     c0104445 <check_boot_pgdir+0x2fb>
c0104421:	c7 44 24 0c 14 72 10 	movl   $0xc0107214,0xc(%esp)
c0104428:	c0 
c0104429:	c7 44 24 08 ed 6d 10 	movl   $0xc0106ded,0x8(%esp)
c0104430:	c0 
c0104431:	c7 44 24 04 2d 02 00 	movl   $0x22d,0x4(%esp)
c0104438:	00 
c0104439:	c7 04 24 c8 6d 10 c0 	movl   $0xc0106dc8,(%esp)
c0104440:	e8 ec bf ff ff       	call   c0100431 <__panic>

    *(char *)(page2kva(p) + 0x100) = '\0';
c0104445:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104448:	89 04 24             	mov    %eax,(%esp)
c010444b:	e8 6c e9 ff ff       	call   c0102dbc <page2kva>
c0104450:	05 00 01 00 00       	add    $0x100,%eax
c0104455:	c6 00 00             	movb   $0x0,(%eax)
    assert(strlen((const char *)0x100) == 0);
c0104458:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
c010445f:	e8 78 15 00 00       	call   c01059dc <strlen>
c0104464:	85 c0                	test   %eax,%eax
c0104466:	74 24                	je     c010448c <check_boot_pgdir+0x342>
c0104468:	c7 44 24 0c 4c 72 10 	movl   $0xc010724c,0xc(%esp)
c010446f:	c0 
c0104470:	c7 44 24 08 ed 6d 10 	movl   $0xc0106ded,0x8(%esp)
c0104477:	c0 
c0104478:	c7 44 24 04 30 02 00 	movl   $0x230,0x4(%esp)
c010447f:	00 
c0104480:	c7 04 24 c8 6d 10 c0 	movl   $0xc0106dc8,(%esp)
c0104487:	e8 a5 bf ff ff       	call   c0100431 <__panic>

    free_page(p);
c010448c:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0104493:	00 
c0104494:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104497:	89 04 24             	mov    %eax,(%esp)
c010449a:	e8 19 ec ff ff       	call   c01030b8 <free_pages>
    free_page(pde2page(boot_pgdir[0]));
c010449f:	a1 e0 a9 11 c0       	mov    0xc011a9e0,%eax
c01044a4:	8b 00                	mov    (%eax),%eax
c01044a6:	89 04 24             	mov    %eax,(%esp)
c01044a9:	e8 a0 e9 ff ff       	call   c0102e4e <pde2page>
c01044ae:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c01044b5:	00 
c01044b6:	89 04 24             	mov    %eax,(%esp)
c01044b9:	e8 fa eb ff ff       	call   c01030b8 <free_pages>
    boot_pgdir[0] = 0;
c01044be:	a1 e0 a9 11 c0       	mov    0xc011a9e0,%eax
c01044c3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    cprintf("check_boot_pgdir() succeeded!\n");
c01044c9:	c7 04 24 70 72 10 c0 	movl   $0xc0107270,(%esp)
c01044d0:	e8 f0 bd ff ff       	call   c01002c5 <cprintf>
}
c01044d5:	90                   	nop
c01044d6:	c9                   	leave  
c01044d7:	c3                   	ret    

c01044d8 <perm2str>:

//perm2str - use string 'u,r,w,-' to present the permission
static const char *
perm2str(int perm) {
c01044d8:	f3 0f 1e fb          	endbr32 
c01044dc:	55                   	push   %ebp
c01044dd:	89 e5                	mov    %esp,%ebp
    static char str[4];
    str[0] = (perm & PTE_U) ? 'u' : '-';
c01044df:	8b 45 08             	mov    0x8(%ebp),%eax
c01044e2:	83 e0 04             	and    $0x4,%eax
c01044e5:	85 c0                	test   %eax,%eax
c01044e7:	74 04                	je     c01044ed <perm2str+0x15>
c01044e9:	b0 75                	mov    $0x75,%al
c01044eb:	eb 02                	jmp    c01044ef <perm2str+0x17>
c01044ed:	b0 2d                	mov    $0x2d,%al
c01044ef:	a2 08 df 11 c0       	mov    %al,0xc011df08
    str[1] = 'r';
c01044f4:	c6 05 09 df 11 c0 72 	movb   $0x72,0xc011df09
    str[2] = (perm & PTE_W) ? 'w' : '-';
c01044fb:	8b 45 08             	mov    0x8(%ebp),%eax
c01044fe:	83 e0 02             	and    $0x2,%eax
c0104501:	85 c0                	test   %eax,%eax
c0104503:	74 04                	je     c0104509 <perm2str+0x31>
c0104505:	b0 77                	mov    $0x77,%al
c0104507:	eb 02                	jmp    c010450b <perm2str+0x33>
c0104509:	b0 2d                	mov    $0x2d,%al
c010450b:	a2 0a df 11 c0       	mov    %al,0xc011df0a
    str[3] = '\0';
c0104510:	c6 05 0b df 11 c0 00 	movb   $0x0,0xc011df0b
    return str;
c0104517:	b8 08 df 11 c0       	mov    $0xc011df08,%eax
}
c010451c:	5d                   	pop    %ebp
c010451d:	c3                   	ret    

c010451e <get_pgtable_items>:
//  table:       the beginning addr of table
//  left_store:  the pointer of the high side of table's next range
//  right_store: the pointer of the low side of table's next range
// return value: 0 - not a invalid item range, perm - a valid item range with perm permission 
static int
get_pgtable_items(size_t left, size_t right, size_t start, uintptr_t *table, size_t *left_store, size_t *right_store) {
c010451e:	f3 0f 1e fb          	endbr32 
c0104522:	55                   	push   %ebp
c0104523:	89 e5                	mov    %esp,%ebp
c0104525:	83 ec 10             	sub    $0x10,%esp
    if (start >= right) {
c0104528:	8b 45 10             	mov    0x10(%ebp),%eax
c010452b:	3b 45 0c             	cmp    0xc(%ebp),%eax
c010452e:	72 0d                	jb     c010453d <get_pgtable_items+0x1f>
        return 0;
c0104530:	b8 00 00 00 00       	mov    $0x0,%eax
c0104535:	e9 98 00 00 00       	jmp    c01045d2 <get_pgtable_items+0xb4>
    }
    while (start < right && !(table[start] & PTE_P)) {
        start ++;
c010453a:	ff 45 10             	incl   0x10(%ebp)
    while (start < right && !(table[start] & PTE_P)) {
c010453d:	8b 45 10             	mov    0x10(%ebp),%eax
c0104540:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0104543:	73 18                	jae    c010455d <get_pgtable_items+0x3f>
c0104545:	8b 45 10             	mov    0x10(%ebp),%eax
c0104548:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c010454f:	8b 45 14             	mov    0x14(%ebp),%eax
c0104552:	01 d0                	add    %edx,%eax
c0104554:	8b 00                	mov    (%eax),%eax
c0104556:	83 e0 01             	and    $0x1,%eax
c0104559:	85 c0                	test   %eax,%eax
c010455b:	74 dd                	je     c010453a <get_pgtable_items+0x1c>
    }
    if (start < right) {
c010455d:	8b 45 10             	mov    0x10(%ebp),%eax
c0104560:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0104563:	73 68                	jae    c01045cd <get_pgtable_items+0xaf>
        if (left_store != NULL) {
c0104565:	83 7d 18 00          	cmpl   $0x0,0x18(%ebp)
c0104569:	74 08                	je     c0104573 <get_pgtable_items+0x55>
            *left_store = start;
c010456b:	8b 45 18             	mov    0x18(%ebp),%eax
c010456e:	8b 55 10             	mov    0x10(%ebp),%edx
c0104571:	89 10                	mov    %edx,(%eax)
        }
        int perm = (table[start ++] & PTE_USER);
c0104573:	8b 45 10             	mov    0x10(%ebp),%eax
c0104576:	8d 50 01             	lea    0x1(%eax),%edx
c0104579:	89 55 10             	mov    %edx,0x10(%ebp)
c010457c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0104583:	8b 45 14             	mov    0x14(%ebp),%eax
c0104586:	01 d0                	add    %edx,%eax
c0104588:	8b 00                	mov    (%eax),%eax
c010458a:	83 e0 07             	and    $0x7,%eax
c010458d:	89 45 fc             	mov    %eax,-0x4(%ebp)
        while (start < right && (table[start] & PTE_USER) == perm) {
c0104590:	eb 03                	jmp    c0104595 <get_pgtable_items+0x77>
            start ++;
c0104592:	ff 45 10             	incl   0x10(%ebp)
        while (start < right && (table[start] & PTE_USER) == perm) {
c0104595:	8b 45 10             	mov    0x10(%ebp),%eax
c0104598:	3b 45 0c             	cmp    0xc(%ebp),%eax
c010459b:	73 1d                	jae    c01045ba <get_pgtable_items+0x9c>
c010459d:	8b 45 10             	mov    0x10(%ebp),%eax
c01045a0:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c01045a7:	8b 45 14             	mov    0x14(%ebp),%eax
c01045aa:	01 d0                	add    %edx,%eax
c01045ac:	8b 00                	mov    (%eax),%eax
c01045ae:	83 e0 07             	and    $0x7,%eax
c01045b1:	89 c2                	mov    %eax,%edx
c01045b3:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01045b6:	39 c2                	cmp    %eax,%edx
c01045b8:	74 d8                	je     c0104592 <get_pgtable_items+0x74>
        }
        if (right_store != NULL) {
c01045ba:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
c01045be:	74 08                	je     c01045c8 <get_pgtable_items+0xaa>
            *right_store = start;
c01045c0:	8b 45 1c             	mov    0x1c(%ebp),%eax
c01045c3:	8b 55 10             	mov    0x10(%ebp),%edx
c01045c6:	89 10                	mov    %edx,(%eax)
        }
        return perm;
c01045c8:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01045cb:	eb 05                	jmp    c01045d2 <get_pgtable_items+0xb4>
    }
    return 0;
c01045cd:	b8 00 00 00 00       	mov    $0x0,%eax
}
c01045d2:	c9                   	leave  
c01045d3:	c3                   	ret    

c01045d4 <print_pgdir>:

//print_pgdir - print the PDT&PT
void
print_pgdir(void) {
c01045d4:	f3 0f 1e fb          	endbr32 
c01045d8:	55                   	push   %ebp
c01045d9:	89 e5                	mov    %esp,%ebp
c01045db:	57                   	push   %edi
c01045dc:	56                   	push   %esi
c01045dd:	53                   	push   %ebx
c01045de:	83 ec 4c             	sub    $0x4c,%esp
    cprintf("-------------------- BEGIN --------------------\n");
c01045e1:	c7 04 24 90 72 10 c0 	movl   $0xc0107290,(%esp)
c01045e8:	e8 d8 bc ff ff       	call   c01002c5 <cprintf>
    size_t left, right = 0, perm;
c01045ed:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
c01045f4:	e9 fa 00 00 00       	jmp    c01046f3 <print_pgdir+0x11f>
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
c01045f9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01045fc:	89 04 24             	mov    %eax,(%esp)
c01045ff:	e8 d4 fe ff ff       	call   c01044d8 <perm2str>
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
c0104604:	8b 4d dc             	mov    -0x24(%ebp),%ecx
c0104607:	8b 55 e0             	mov    -0x20(%ebp),%edx
c010460a:	29 d1                	sub    %edx,%ecx
c010460c:	89 ca                	mov    %ecx,%edx
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
c010460e:	89 d6                	mov    %edx,%esi
c0104610:	c1 e6 16             	shl    $0x16,%esi
c0104613:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0104616:	89 d3                	mov    %edx,%ebx
c0104618:	c1 e3 16             	shl    $0x16,%ebx
c010461b:	8b 55 e0             	mov    -0x20(%ebp),%edx
c010461e:	89 d1                	mov    %edx,%ecx
c0104620:	c1 e1 16             	shl    $0x16,%ecx
c0104623:	8b 7d dc             	mov    -0x24(%ebp),%edi
c0104626:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0104629:	29 d7                	sub    %edx,%edi
c010462b:	89 fa                	mov    %edi,%edx
c010462d:	89 44 24 14          	mov    %eax,0x14(%esp)
c0104631:	89 74 24 10          	mov    %esi,0x10(%esp)
c0104635:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
c0104639:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c010463d:	89 54 24 04          	mov    %edx,0x4(%esp)
c0104641:	c7 04 24 c1 72 10 c0 	movl   $0xc01072c1,(%esp)
c0104648:	e8 78 bc ff ff       	call   c01002c5 <cprintf>
        size_t l, r = left * NPTEENTRY;
c010464d:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0104650:	c1 e0 0a             	shl    $0xa,%eax
c0104653:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
c0104656:	eb 54                	jmp    c01046ac <print_pgdir+0xd8>
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
c0104658:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010465b:	89 04 24             	mov    %eax,(%esp)
c010465e:	e8 75 fe ff ff       	call   c01044d8 <perm2str>
                    l * PGSIZE, r * PGSIZE, (r - l) * PGSIZE, perm2str(perm));
c0104663:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
c0104666:	8b 55 d8             	mov    -0x28(%ebp),%edx
c0104669:	29 d1                	sub    %edx,%ecx
c010466b:	89 ca                	mov    %ecx,%edx
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
c010466d:	89 d6                	mov    %edx,%esi
c010466f:	c1 e6 0c             	shl    $0xc,%esi
c0104672:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0104675:	89 d3                	mov    %edx,%ebx
c0104677:	c1 e3 0c             	shl    $0xc,%ebx
c010467a:	8b 55 d8             	mov    -0x28(%ebp),%edx
c010467d:	89 d1                	mov    %edx,%ecx
c010467f:	c1 e1 0c             	shl    $0xc,%ecx
c0104682:	8b 7d d4             	mov    -0x2c(%ebp),%edi
c0104685:	8b 55 d8             	mov    -0x28(%ebp),%edx
c0104688:	29 d7                	sub    %edx,%edi
c010468a:	89 fa                	mov    %edi,%edx
c010468c:	89 44 24 14          	mov    %eax,0x14(%esp)
c0104690:	89 74 24 10          	mov    %esi,0x10(%esp)
c0104694:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
c0104698:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c010469c:	89 54 24 04          	mov    %edx,0x4(%esp)
c01046a0:	c7 04 24 e0 72 10 c0 	movl   $0xc01072e0,(%esp)
c01046a7:	e8 19 bc ff ff       	call   c01002c5 <cprintf>
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
c01046ac:	be 00 00 c0 fa       	mov    $0xfac00000,%esi
c01046b1:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01046b4:	8b 55 dc             	mov    -0x24(%ebp),%edx
c01046b7:	89 d3                	mov    %edx,%ebx
c01046b9:	c1 e3 0a             	shl    $0xa,%ebx
c01046bc:	8b 55 e0             	mov    -0x20(%ebp),%edx
c01046bf:	89 d1                	mov    %edx,%ecx
c01046c1:	c1 e1 0a             	shl    $0xa,%ecx
c01046c4:	8d 55 d4             	lea    -0x2c(%ebp),%edx
c01046c7:	89 54 24 14          	mov    %edx,0x14(%esp)
c01046cb:	8d 55 d8             	lea    -0x28(%ebp),%edx
c01046ce:	89 54 24 10          	mov    %edx,0x10(%esp)
c01046d2:	89 74 24 0c          	mov    %esi,0xc(%esp)
c01046d6:	89 44 24 08          	mov    %eax,0x8(%esp)
c01046da:	89 5c 24 04          	mov    %ebx,0x4(%esp)
c01046de:	89 0c 24             	mov    %ecx,(%esp)
c01046e1:	e8 38 fe ff ff       	call   c010451e <get_pgtable_items>
c01046e6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c01046e9:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c01046ed:	0f 85 65 ff ff ff    	jne    c0104658 <print_pgdir+0x84>
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
c01046f3:	b9 00 b0 fe fa       	mov    $0xfafeb000,%ecx
c01046f8:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01046fb:	8d 55 dc             	lea    -0x24(%ebp),%edx
c01046fe:	89 54 24 14          	mov    %edx,0x14(%esp)
c0104702:	8d 55 e0             	lea    -0x20(%ebp),%edx
c0104705:	89 54 24 10          	mov    %edx,0x10(%esp)
c0104709:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
c010470d:	89 44 24 08          	mov    %eax,0x8(%esp)
c0104711:	c7 44 24 04 00 04 00 	movl   $0x400,0x4(%esp)
c0104718:	00 
c0104719:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c0104720:	e8 f9 fd ff ff       	call   c010451e <get_pgtable_items>
c0104725:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0104728:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c010472c:	0f 85 c7 fe ff ff    	jne    c01045f9 <print_pgdir+0x25>
        }
    }
    cprintf("--------------------- END ---------------------\n");
c0104732:	c7 04 24 04 73 10 c0 	movl   $0xc0107304,(%esp)
c0104739:	e8 87 bb ff ff       	call   c01002c5 <cprintf>
}
c010473e:	90                   	nop
c010473f:	83 c4 4c             	add    $0x4c,%esp
c0104742:	5b                   	pop    %ebx
c0104743:	5e                   	pop    %esi
c0104744:	5f                   	pop    %edi
c0104745:	5d                   	pop    %ebp
c0104746:	c3                   	ret    

c0104747 <page2ppn>:
page2ppn(struct Page *page) {
c0104747:	55                   	push   %ebp
c0104748:	89 e5                	mov    %esp,%ebp
    return page - pages;
c010474a:	a1 78 df 11 c0       	mov    0xc011df78,%eax
c010474f:	8b 55 08             	mov    0x8(%ebp),%edx
c0104752:	29 c2                	sub    %eax,%edx
c0104754:	89 d0                	mov    %edx,%eax
c0104756:	c1 f8 02             	sar    $0x2,%eax
c0104759:	69 c0 cd cc cc cc    	imul   $0xcccccccd,%eax,%eax
}
c010475f:	5d                   	pop    %ebp
c0104760:	c3                   	ret    

c0104761 <page2pa>:
page2pa(struct Page *page) {
c0104761:	55                   	push   %ebp
c0104762:	89 e5                	mov    %esp,%ebp
c0104764:	83 ec 04             	sub    $0x4,%esp
    return page2ppn(page) << PGSHIFT;
c0104767:	8b 45 08             	mov    0x8(%ebp),%eax
c010476a:	89 04 24             	mov    %eax,(%esp)
c010476d:	e8 d5 ff ff ff       	call   c0104747 <page2ppn>
c0104772:	c1 e0 0c             	shl    $0xc,%eax
}
c0104775:	c9                   	leave  
c0104776:	c3                   	ret    

c0104777 <page_ref>:
page_ref(struct Page *page) {
c0104777:	55                   	push   %ebp
c0104778:	89 e5                	mov    %esp,%ebp
    return page->ref;
c010477a:	8b 45 08             	mov    0x8(%ebp),%eax
c010477d:	8b 00                	mov    (%eax),%eax
}
c010477f:	5d                   	pop    %ebp
c0104780:	c3                   	ret    

c0104781 <set_page_ref>:
set_page_ref(struct Page *page, int val) {
c0104781:	55                   	push   %ebp
c0104782:	89 e5                	mov    %esp,%ebp
    page->ref = val;
c0104784:	8b 45 08             	mov    0x8(%ebp),%eax
c0104787:	8b 55 0c             	mov    0xc(%ebp),%edx
c010478a:	89 10                	mov    %edx,(%eax)
}
c010478c:	90                   	nop
c010478d:	5d                   	pop    %ebp
c010478e:	c3                   	ret    

c010478f <default_init>:

#define free_list (free_area.free_list)
#define nr_free (free_area.nr_free)

static void
default_init(void) {
c010478f:	f3 0f 1e fb          	endbr32 
c0104793:	55                   	push   %ebp
c0104794:	89 e5                	mov    %esp,%ebp
c0104796:	83 ec 10             	sub    $0x10,%esp
c0104799:	c7 45 fc 7c df 11 c0 	movl   $0xc011df7c,-0x4(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
c01047a0:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01047a3:	8b 55 fc             	mov    -0x4(%ebp),%edx
c01047a6:	89 50 04             	mov    %edx,0x4(%eax)
c01047a9:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01047ac:	8b 50 04             	mov    0x4(%eax),%edx
c01047af:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01047b2:	89 10                	mov    %edx,(%eax)
}
c01047b4:	90                   	nop
    list_init(&free_list);
    nr_free = 0;
c01047b5:	c7 05 84 df 11 c0 00 	movl   $0x0,0xc011df84
c01047bc:	00 00 00 
}
c01047bf:	90                   	nop
c01047c0:	c9                   	leave  
c01047c1:	c3                   	ret    

c01047c2 <default_init_memmap>:

static void
default_init_memmap(struct Page *base, size_t n) {
c01047c2:	f3 0f 1e fb          	endbr32 
c01047c6:	55                   	push   %ebp
c01047c7:	89 e5                	mov    %esp,%ebp
c01047c9:	83 ec 58             	sub    $0x58,%esp
    assert(n > 0);
c01047cc:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c01047d0:	75 24                	jne    c01047f6 <default_init_memmap+0x34>
c01047d2:	c7 44 24 0c 38 73 10 	movl   $0xc0107338,0xc(%esp)
c01047d9:	c0 
c01047da:	c7 44 24 08 3e 73 10 	movl   $0xc010733e,0x8(%esp)
c01047e1:	c0 
c01047e2:	c7 44 24 04 6d 00 00 	movl   $0x6d,0x4(%esp)
c01047e9:	00 
c01047ea:	c7 04 24 53 73 10 c0 	movl   $0xc0107353,(%esp)
c01047f1:	e8 3b bc ff ff       	call   c0100431 <__panic>
    struct Page *p = base;
c01047f6:	8b 45 08             	mov    0x8(%ebp),%eax
c01047f9:	89 45 f4             	mov    %eax,-0xc(%ebp)
    for (; p != base + n; p ++) {
c01047fc:	eb 7d                	jmp    c010487b <default_init_memmap+0xb9>
        assert(PageReserved(p));
c01047fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104801:	83 c0 04             	add    $0x4,%eax
c0104804:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
c010480b:	89 45 ec             	mov    %eax,-0x14(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c010480e:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104811:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0104814:	0f a3 10             	bt     %edx,(%eax)
c0104817:	19 c0                	sbb    %eax,%eax
c0104819:	89 45 e8             	mov    %eax,-0x18(%ebp)
    return oldbit != 0;
c010481c:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0104820:	0f 95 c0             	setne  %al
c0104823:	0f b6 c0             	movzbl %al,%eax
c0104826:	85 c0                	test   %eax,%eax
c0104828:	75 24                	jne    c010484e <default_init_memmap+0x8c>
c010482a:	c7 44 24 0c 69 73 10 	movl   $0xc0107369,0xc(%esp)
c0104831:	c0 
c0104832:	c7 44 24 08 3e 73 10 	movl   $0xc010733e,0x8(%esp)
c0104839:	c0 
c010483a:	c7 44 24 04 70 00 00 	movl   $0x70,0x4(%esp)
c0104841:	00 
c0104842:	c7 04 24 53 73 10 c0 	movl   $0xc0107353,(%esp)
c0104849:	e8 e3 bb ff ff       	call   c0100431 <__panic>
        p->flags = p->property = 0;
c010484e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104851:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
c0104858:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010485b:	8b 50 08             	mov    0x8(%eax),%edx
c010485e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104861:	89 50 04             	mov    %edx,0x4(%eax)
        set_page_ref(p, 0);
c0104864:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c010486b:	00 
c010486c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010486f:	89 04 24             	mov    %eax,(%esp)
c0104872:	e8 0a ff ff ff       	call   c0104781 <set_page_ref>
    for (; p != base + n; p ++) {
c0104877:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
c010487b:	8b 55 0c             	mov    0xc(%ebp),%edx
c010487e:	89 d0                	mov    %edx,%eax
c0104880:	c1 e0 02             	shl    $0x2,%eax
c0104883:	01 d0                	add    %edx,%eax
c0104885:	c1 e0 02             	shl    $0x2,%eax
c0104888:	89 c2                	mov    %eax,%edx
c010488a:	8b 45 08             	mov    0x8(%ebp),%eax
c010488d:	01 d0                	add    %edx,%eax
c010488f:	39 45 f4             	cmp    %eax,-0xc(%ebp)
c0104892:	0f 85 66 ff ff ff    	jne    c01047fe <default_init_memmap+0x3c>
    }
    base->property = n;
c0104898:	8b 45 08             	mov    0x8(%ebp),%eax
c010489b:	8b 55 0c             	mov    0xc(%ebp),%edx
c010489e:	89 50 08             	mov    %edx,0x8(%eax)
    SetPageProperty(base);
c01048a1:	8b 45 08             	mov    0x8(%ebp),%eax
c01048a4:	83 c0 04             	add    $0x4,%eax
c01048a7:	c7 45 c8 01 00 00 00 	movl   $0x1,-0x38(%ebp)
c01048ae:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c01048b1:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c01048b4:	8b 55 c8             	mov    -0x38(%ebp),%edx
c01048b7:	0f ab 10             	bts    %edx,(%eax)
}
c01048ba:	90                   	nop
    nr_free += n;
c01048bb:	8b 15 84 df 11 c0    	mov    0xc011df84,%edx
c01048c1:	8b 45 0c             	mov    0xc(%ebp),%eax
c01048c4:	01 d0                	add    %edx,%eax
c01048c6:	a3 84 df 11 c0       	mov    %eax,0xc011df84
    list_add(&free_list, &(base->page_link));
c01048cb:	8b 45 08             	mov    0x8(%ebp),%eax
c01048ce:	83 c0 0c             	add    $0xc,%eax
c01048d1:	c7 45 e4 7c df 11 c0 	movl   $0xc011df7c,-0x1c(%ebp)
c01048d8:	89 45 e0             	mov    %eax,-0x20(%ebp)
c01048db:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01048de:	89 45 dc             	mov    %eax,-0x24(%ebp)
c01048e1:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01048e4:	89 45 d8             	mov    %eax,-0x28(%ebp)
 * Insert the new element @elm *after* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_after(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm, listelm->next);
c01048e7:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01048ea:	8b 40 04             	mov    0x4(%eax),%eax
c01048ed:	8b 55 d8             	mov    -0x28(%ebp),%edx
c01048f0:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c01048f3:	8b 55 dc             	mov    -0x24(%ebp),%edx
c01048f6:	89 55 d0             	mov    %edx,-0x30(%ebp)
c01048f9:	89 45 cc             	mov    %eax,-0x34(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
c01048fc:	8b 45 cc             	mov    -0x34(%ebp),%eax
c01048ff:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0104902:	89 10                	mov    %edx,(%eax)
c0104904:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0104907:	8b 10                	mov    (%eax),%edx
c0104909:	8b 45 d0             	mov    -0x30(%ebp),%eax
c010490c:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c010490f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0104912:	8b 55 cc             	mov    -0x34(%ebp),%edx
c0104915:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c0104918:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010491b:	8b 55 d0             	mov    -0x30(%ebp),%edx
c010491e:	89 10                	mov    %edx,(%eax)
}
c0104920:	90                   	nop
}
c0104921:	90                   	nop
}
c0104922:	90                   	nop
}
c0104923:	90                   	nop
c0104924:	c9                   	leave  
c0104925:	c3                   	ret    

c0104926 <default_alloc_pages>:

static struct Page *
default_alloc_pages(size_t n) {
c0104926:	f3 0f 1e fb          	endbr32 
c010492a:	55                   	push   %ebp
c010492b:	89 e5                	mov    %esp,%ebp
c010492d:	83 ec 68             	sub    $0x68,%esp
    assert(n > 0);
c0104930:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0104934:	75 24                	jne    c010495a <default_alloc_pages+0x34>
c0104936:	c7 44 24 0c 38 73 10 	movl   $0xc0107338,0xc(%esp)
c010493d:	c0 
c010493e:	c7 44 24 08 3e 73 10 	movl   $0xc010733e,0x8(%esp)
c0104945:	c0 
c0104946:	c7 44 24 04 7c 00 00 	movl   $0x7c,0x4(%esp)
c010494d:	00 
c010494e:	c7 04 24 53 73 10 c0 	movl   $0xc0107353,(%esp)
c0104955:	e8 d7 ba ff ff       	call   c0100431 <__panic>
    if (n > nr_free) {
c010495a:	a1 84 df 11 c0       	mov    0xc011df84,%eax
c010495f:	39 45 08             	cmp    %eax,0x8(%ebp)
c0104962:	76 0a                	jbe    c010496e <default_alloc_pages+0x48>
        return NULL;
c0104964:	b8 00 00 00 00       	mov    $0x0,%eax
c0104969:	e9 4e 01 00 00       	jmp    c0104abc <default_alloc_pages+0x196>
    }
    struct Page *page = NULL;
c010496e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    list_entry_t *le = &free_list;
c0104975:	c7 45 f0 7c df 11 c0 	movl   $0xc011df7c,-0x10(%ebp)
    while ((le = list_next(le)) != &free_list) {
c010497c:	eb 1c                	jmp    c010499a <default_alloc_pages+0x74>
        struct Page *p = le2page(le, page_link);
c010497e:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104981:	83 e8 0c             	sub    $0xc,%eax
c0104984:	89 45 ec             	mov    %eax,-0x14(%ebp)
        if (p->property >= n) {
c0104987:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010498a:	8b 40 08             	mov    0x8(%eax),%eax
c010498d:	39 45 08             	cmp    %eax,0x8(%ebp)
c0104990:	77 08                	ja     c010499a <default_alloc_pages+0x74>
            page = p;
c0104992:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104995:	89 45 f4             	mov    %eax,-0xc(%ebp)
            break;
c0104998:	eb 18                	jmp    c01049b2 <default_alloc_pages+0x8c>
c010499a:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010499d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    return listelm->next;
c01049a0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01049a3:	8b 40 04             	mov    0x4(%eax),%eax
    while ((le = list_next(le)) != &free_list) {
c01049a6:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01049a9:	81 7d f0 7c df 11 c0 	cmpl   $0xc011df7c,-0x10(%ebp)
c01049b0:	75 cc                	jne    c010497e <default_alloc_pages+0x58>
        }
    }
    if (page != NULL) {
c01049b2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01049b6:	0f 84 fd 00 00 00    	je     c0104ab9 <default_alloc_pages+0x193>
        if (page->property > n) {
c01049bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01049bf:	8b 40 08             	mov    0x8(%eax),%eax
c01049c2:	39 45 08             	cmp    %eax,0x8(%ebp)
c01049c5:	0f 83 9a 00 00 00    	jae    c0104a65 <default_alloc_pages+0x13f>
            struct Page *p = page + n;
c01049cb:	8b 55 08             	mov    0x8(%ebp),%edx
c01049ce:	89 d0                	mov    %edx,%eax
c01049d0:	c1 e0 02             	shl    $0x2,%eax
c01049d3:	01 d0                	add    %edx,%eax
c01049d5:	c1 e0 02             	shl    $0x2,%eax
c01049d8:	89 c2                	mov    %eax,%edx
c01049da:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01049dd:	01 d0                	add    %edx,%eax
c01049df:	89 45 e8             	mov    %eax,-0x18(%ebp)
            p->property = page->property - n;
c01049e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01049e5:	8b 40 08             	mov    0x8(%eax),%eax
c01049e8:	2b 45 08             	sub    0x8(%ebp),%eax
c01049eb:	89 c2                	mov    %eax,%edx
c01049ed:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01049f0:	89 50 08             	mov    %edx,0x8(%eax)
            SetPageProperty(p);
c01049f3:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01049f6:	83 c0 04             	add    $0x4,%eax
c01049f9:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
c0104a00:	89 45 c0             	mov    %eax,-0x40(%ebp)
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0104a03:	8b 45 c0             	mov    -0x40(%ebp),%eax
c0104a06:	8b 55 c4             	mov    -0x3c(%ebp),%edx
c0104a09:	0f ab 10             	bts    %edx,(%eax)
}
c0104a0c:	90                   	nop
            list_add(&free_list, &(p->page_link));
c0104a0d:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0104a10:	83 c0 0c             	add    $0xc,%eax
c0104a13:	c7 45 e0 7c df 11 c0 	movl   $0xc011df7c,-0x20(%ebp)
c0104a1a:	89 45 dc             	mov    %eax,-0x24(%ebp)
c0104a1d:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0104a20:	89 45 d8             	mov    %eax,-0x28(%ebp)
c0104a23:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0104a26:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    __list_add(elm, listelm, listelm->next);
c0104a29:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0104a2c:	8b 40 04             	mov    0x4(%eax),%eax
c0104a2f:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0104a32:	89 55 d0             	mov    %edx,-0x30(%ebp)
c0104a35:	8b 55 d8             	mov    -0x28(%ebp),%edx
c0104a38:	89 55 cc             	mov    %edx,-0x34(%ebp)
c0104a3b:	89 45 c8             	mov    %eax,-0x38(%ebp)
    prev->next = next->prev = elm;
c0104a3e:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0104a41:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0104a44:	89 10                	mov    %edx,(%eax)
c0104a46:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0104a49:	8b 10                	mov    (%eax),%edx
c0104a4b:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0104a4e:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c0104a51:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0104a54:	8b 55 c8             	mov    -0x38(%ebp),%edx
c0104a57:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c0104a5a:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0104a5d:	8b 55 cc             	mov    -0x34(%ebp),%edx
c0104a60:	89 10                	mov    %edx,(%eax)
}
c0104a62:	90                   	nop
}
c0104a63:	90                   	nop
}
c0104a64:	90                   	nop
        }
        list_del(&(page->page_link));
c0104a65:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104a68:	83 c0 0c             	add    $0xc,%eax
c0104a6b:	89 45 b4             	mov    %eax,-0x4c(%ebp)
    __list_del(listelm->prev, listelm->next);
c0104a6e:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c0104a71:	8b 40 04             	mov    0x4(%eax),%eax
c0104a74:	8b 55 b4             	mov    -0x4c(%ebp),%edx
c0104a77:	8b 12                	mov    (%edx),%edx
c0104a79:	89 55 b0             	mov    %edx,-0x50(%ebp)
c0104a7c:	89 45 ac             	mov    %eax,-0x54(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
c0104a7f:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0104a82:	8b 55 ac             	mov    -0x54(%ebp),%edx
c0104a85:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
c0104a88:	8b 45 ac             	mov    -0x54(%ebp),%eax
c0104a8b:	8b 55 b0             	mov    -0x50(%ebp),%edx
c0104a8e:	89 10                	mov    %edx,(%eax)
}
c0104a90:	90                   	nop
}
c0104a91:	90                   	nop
        nr_free -= n;
c0104a92:	a1 84 df 11 c0       	mov    0xc011df84,%eax
c0104a97:	2b 45 08             	sub    0x8(%ebp),%eax
c0104a9a:	a3 84 df 11 c0       	mov    %eax,0xc011df84
        ClearPageProperty(page);
c0104a9f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104aa2:	83 c0 04             	add    $0x4,%eax
c0104aa5:	c7 45 bc 01 00 00 00 	movl   $0x1,-0x44(%ebp)
c0104aac:	89 45 b8             	mov    %eax,-0x48(%ebp)
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0104aaf:	8b 45 b8             	mov    -0x48(%ebp),%eax
c0104ab2:	8b 55 bc             	mov    -0x44(%ebp),%edx
c0104ab5:	0f b3 10             	btr    %edx,(%eax)
}
c0104ab8:	90                   	nop
    }
    return page;
c0104ab9:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0104abc:	c9                   	leave  
c0104abd:	c3                   	ret    

c0104abe <default_free_pages>:

static void
default_free_pages(struct Page *base, size_t n) {
c0104abe:	f3 0f 1e fb          	endbr32 
c0104ac2:	55                   	push   %ebp
c0104ac3:	89 e5                	mov    %esp,%ebp
c0104ac5:	81 ec 98 00 00 00    	sub    $0x98,%esp
    assert(n > 0);
c0104acb:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0104acf:	75 24                	jne    c0104af5 <default_free_pages+0x37>
c0104ad1:	c7 44 24 0c 38 73 10 	movl   $0xc0107338,0xc(%esp)
c0104ad8:	c0 
c0104ad9:	c7 44 24 08 3e 73 10 	movl   $0xc010733e,0x8(%esp)
c0104ae0:	c0 
c0104ae1:	c7 44 24 04 99 00 00 	movl   $0x99,0x4(%esp)
c0104ae8:	00 
c0104ae9:	c7 04 24 53 73 10 c0 	movl   $0xc0107353,(%esp)
c0104af0:	e8 3c b9 ff ff       	call   c0100431 <__panic>
    struct Page *p = base;
c0104af5:	8b 45 08             	mov    0x8(%ebp),%eax
c0104af8:	89 45 f4             	mov    %eax,-0xc(%ebp)
    for (; p != base + n; p ++) {
c0104afb:	e9 9d 00 00 00       	jmp    c0104b9d <default_free_pages+0xdf>
        assert(!PageReserved(p) && !PageProperty(p));
c0104b00:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104b03:	83 c0 04             	add    $0x4,%eax
c0104b06:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c0104b0d:	89 45 e8             	mov    %eax,-0x18(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0104b10:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0104b13:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0104b16:	0f a3 10             	bt     %edx,(%eax)
c0104b19:	19 c0                	sbb    %eax,%eax
c0104b1b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    return oldbit != 0;
c0104b1e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0104b22:	0f 95 c0             	setne  %al
c0104b25:	0f b6 c0             	movzbl %al,%eax
c0104b28:	85 c0                	test   %eax,%eax
c0104b2a:	75 2c                	jne    c0104b58 <default_free_pages+0x9a>
c0104b2c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104b2f:	83 c0 04             	add    $0x4,%eax
c0104b32:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
c0104b39:	89 45 dc             	mov    %eax,-0x24(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0104b3c:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0104b3f:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0104b42:	0f a3 10             	bt     %edx,(%eax)
c0104b45:	19 c0                	sbb    %eax,%eax
c0104b47:	89 45 d8             	mov    %eax,-0x28(%ebp)
    return oldbit != 0;
c0104b4a:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
c0104b4e:	0f 95 c0             	setne  %al
c0104b51:	0f b6 c0             	movzbl %al,%eax
c0104b54:	85 c0                	test   %eax,%eax
c0104b56:	74 24                	je     c0104b7c <default_free_pages+0xbe>
c0104b58:	c7 44 24 0c 7c 73 10 	movl   $0xc010737c,0xc(%esp)
c0104b5f:	c0 
c0104b60:	c7 44 24 08 3e 73 10 	movl   $0xc010733e,0x8(%esp)
c0104b67:	c0 
c0104b68:	c7 44 24 04 9c 00 00 	movl   $0x9c,0x4(%esp)
c0104b6f:	00 
c0104b70:	c7 04 24 53 73 10 c0 	movl   $0xc0107353,(%esp)
c0104b77:	e8 b5 b8 ff ff       	call   c0100431 <__panic>
        p->flags = 0;
c0104b7c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104b7f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
        set_page_ref(p, 0);
c0104b86:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0104b8d:	00 
c0104b8e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104b91:	89 04 24             	mov    %eax,(%esp)
c0104b94:	e8 e8 fb ff ff       	call   c0104781 <set_page_ref>
    for (; p != base + n; p ++) {
c0104b99:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
c0104b9d:	8b 55 0c             	mov    0xc(%ebp),%edx
c0104ba0:	89 d0                	mov    %edx,%eax
c0104ba2:	c1 e0 02             	shl    $0x2,%eax
c0104ba5:	01 d0                	add    %edx,%eax
c0104ba7:	c1 e0 02             	shl    $0x2,%eax
c0104baa:	89 c2                	mov    %eax,%edx
c0104bac:	8b 45 08             	mov    0x8(%ebp),%eax
c0104baf:	01 d0                	add    %edx,%eax
c0104bb1:	39 45 f4             	cmp    %eax,-0xc(%ebp)
c0104bb4:	0f 85 46 ff ff ff    	jne    c0104b00 <default_free_pages+0x42>
    }
    base->property = n;
c0104bba:	8b 45 08             	mov    0x8(%ebp),%eax
c0104bbd:	8b 55 0c             	mov    0xc(%ebp),%edx
c0104bc0:	89 50 08             	mov    %edx,0x8(%eax)
    SetPageProperty(base);
c0104bc3:	8b 45 08             	mov    0x8(%ebp),%eax
c0104bc6:	83 c0 04             	add    $0x4,%eax
c0104bc9:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
c0104bd0:	89 45 cc             	mov    %eax,-0x34(%ebp)
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0104bd3:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0104bd6:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0104bd9:	0f ab 10             	bts    %edx,(%eax)
}
c0104bdc:	90                   	nop
c0104bdd:	c7 45 d4 7c df 11 c0 	movl   $0xc011df7c,-0x2c(%ebp)
    return listelm->next;
c0104be4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0104be7:	8b 40 04             	mov    0x4(%eax),%eax
    list_entry_t *le = list_next(&free_list);
c0104bea:	89 45 f0             	mov    %eax,-0x10(%ebp)
    while (le != &free_list) {
c0104bed:	e9 0d 01 00 00       	jmp    c0104cff <default_free_pages+0x241>
        p = le2page(le, page_link);
c0104bf2:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104bf5:	83 e8 0c             	sub    $0xc,%eax
c0104bf8:	89 45 f4             	mov    %eax,-0xc(%ebp)
        if (base + base->property == p) {
c0104bfb:	8b 45 08             	mov    0x8(%ebp),%eax
c0104bfe:	8b 50 08             	mov    0x8(%eax),%edx
c0104c01:	89 d0                	mov    %edx,%eax
c0104c03:	c1 e0 02             	shl    $0x2,%eax
c0104c06:	01 d0                	add    %edx,%eax
c0104c08:	c1 e0 02             	shl    $0x2,%eax
c0104c0b:	89 c2                	mov    %eax,%edx
c0104c0d:	8b 45 08             	mov    0x8(%ebp),%eax
c0104c10:	01 d0                	add    %edx,%eax
c0104c12:	39 45 f4             	cmp    %eax,-0xc(%ebp)
c0104c15:	75 5c                	jne    c0104c73 <default_free_pages+0x1b5>
            base->property += p->property;
c0104c17:	8b 45 08             	mov    0x8(%ebp),%eax
c0104c1a:	8b 50 08             	mov    0x8(%eax),%edx
c0104c1d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104c20:	8b 40 08             	mov    0x8(%eax),%eax
c0104c23:	01 c2                	add    %eax,%edx
c0104c25:	8b 45 08             	mov    0x8(%ebp),%eax
c0104c28:	89 50 08             	mov    %edx,0x8(%eax)
            ClearPageProperty(p);
c0104c2b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104c2e:	83 c0 04             	add    $0x4,%eax
c0104c31:	c7 45 bc 01 00 00 00 	movl   $0x1,-0x44(%ebp)
c0104c38:	89 45 b8             	mov    %eax,-0x48(%ebp)
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0104c3b:	8b 45 b8             	mov    -0x48(%ebp),%eax
c0104c3e:	8b 55 bc             	mov    -0x44(%ebp),%edx
c0104c41:	0f b3 10             	btr    %edx,(%eax)
}
c0104c44:	90                   	nop
            list_del(&(p->page_link));
c0104c45:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104c48:	83 c0 0c             	add    $0xc,%eax
c0104c4b:	89 45 c8             	mov    %eax,-0x38(%ebp)
    __list_del(listelm->prev, listelm->next);
c0104c4e:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0104c51:	8b 40 04             	mov    0x4(%eax),%eax
c0104c54:	8b 55 c8             	mov    -0x38(%ebp),%edx
c0104c57:	8b 12                	mov    (%edx),%edx
c0104c59:	89 55 c4             	mov    %edx,-0x3c(%ebp)
c0104c5c:	89 45 c0             	mov    %eax,-0x40(%ebp)
    prev->next = next;
c0104c5f:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0104c62:	8b 55 c0             	mov    -0x40(%ebp),%edx
c0104c65:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
c0104c68:	8b 45 c0             	mov    -0x40(%ebp),%eax
c0104c6b:	8b 55 c4             	mov    -0x3c(%ebp),%edx
c0104c6e:	89 10                	mov    %edx,(%eax)
}
c0104c70:	90                   	nop
}
c0104c71:	eb 7d                	jmp    c0104cf0 <default_free_pages+0x232>
        }
        else if (p + p->property == base) {
c0104c73:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104c76:	8b 50 08             	mov    0x8(%eax),%edx
c0104c79:	89 d0                	mov    %edx,%eax
c0104c7b:	c1 e0 02             	shl    $0x2,%eax
c0104c7e:	01 d0                	add    %edx,%eax
c0104c80:	c1 e0 02             	shl    $0x2,%eax
c0104c83:	89 c2                	mov    %eax,%edx
c0104c85:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104c88:	01 d0                	add    %edx,%eax
c0104c8a:	39 45 08             	cmp    %eax,0x8(%ebp)
c0104c8d:	75 61                	jne    c0104cf0 <default_free_pages+0x232>
            p->property += base->property;
c0104c8f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104c92:	8b 50 08             	mov    0x8(%eax),%edx
c0104c95:	8b 45 08             	mov    0x8(%ebp),%eax
c0104c98:	8b 40 08             	mov    0x8(%eax),%eax
c0104c9b:	01 c2                	add    %eax,%edx
c0104c9d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104ca0:	89 50 08             	mov    %edx,0x8(%eax)
            ClearPageProperty(base);
c0104ca3:	8b 45 08             	mov    0x8(%ebp),%eax
c0104ca6:	83 c0 04             	add    $0x4,%eax
c0104ca9:	c7 45 a8 01 00 00 00 	movl   $0x1,-0x58(%ebp)
c0104cb0:	89 45 a4             	mov    %eax,-0x5c(%ebp)
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0104cb3:	8b 45 a4             	mov    -0x5c(%ebp),%eax
c0104cb6:	8b 55 a8             	mov    -0x58(%ebp),%edx
c0104cb9:	0f b3 10             	btr    %edx,(%eax)
}
c0104cbc:	90                   	nop
            base = p;
c0104cbd:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104cc0:	89 45 08             	mov    %eax,0x8(%ebp)
            list_del(&(p->page_link));
c0104cc3:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104cc6:	83 c0 0c             	add    $0xc,%eax
c0104cc9:	89 45 b4             	mov    %eax,-0x4c(%ebp)
    __list_del(listelm->prev, listelm->next);
c0104ccc:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c0104ccf:	8b 40 04             	mov    0x4(%eax),%eax
c0104cd2:	8b 55 b4             	mov    -0x4c(%ebp),%edx
c0104cd5:	8b 12                	mov    (%edx),%edx
c0104cd7:	89 55 b0             	mov    %edx,-0x50(%ebp)
c0104cda:	89 45 ac             	mov    %eax,-0x54(%ebp)
    prev->next = next;
c0104cdd:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0104ce0:	8b 55 ac             	mov    -0x54(%ebp),%edx
c0104ce3:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
c0104ce6:	8b 45 ac             	mov    -0x54(%ebp),%eax
c0104ce9:	8b 55 b0             	mov    -0x50(%ebp),%edx
c0104cec:	89 10                	mov    %edx,(%eax)
}
c0104cee:	90                   	nop
}
c0104cef:	90                   	nop
c0104cf0:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104cf3:	89 45 a0             	mov    %eax,-0x60(%ebp)
    return listelm->next;
c0104cf6:	8b 45 a0             	mov    -0x60(%ebp),%eax
c0104cf9:	8b 40 04             	mov    0x4(%eax),%eax
        }
        le = list_next(le);
c0104cfc:	89 45 f0             	mov    %eax,-0x10(%ebp)
    while (le != &free_list) {
c0104cff:	81 7d f0 7c df 11 c0 	cmpl   $0xc011df7c,-0x10(%ebp)
c0104d06:	0f 85 e6 fe ff ff    	jne    c0104bf2 <default_free_pages+0x134>
    }
    nr_free += n;
c0104d0c:	8b 15 84 df 11 c0    	mov    0xc011df84,%edx
c0104d12:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104d15:	01 d0                	add    %edx,%eax
c0104d17:	a3 84 df 11 c0       	mov    %eax,0xc011df84
c0104d1c:	c7 45 9c 7c df 11 c0 	movl   $0xc011df7c,-0x64(%ebp)
c0104d23:	8b 45 9c             	mov    -0x64(%ebp),%eax
c0104d26:	8b 40 04             	mov    0x4(%eax),%eax
    le = list_next(&free_list);
c0104d29:	89 45 f0             	mov    %eax,-0x10(%ebp)
    while (le != &free_list) {
c0104d2c:	eb 74                	jmp    c0104da2 <default_free_pages+0x2e4>
        p = le2page(le, page_link);
c0104d2e:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104d31:	83 e8 0c             	sub    $0xc,%eax
c0104d34:	89 45 f4             	mov    %eax,-0xc(%ebp)
        if (base + base->property <= p) {
c0104d37:	8b 45 08             	mov    0x8(%ebp),%eax
c0104d3a:	8b 50 08             	mov    0x8(%eax),%edx
c0104d3d:	89 d0                	mov    %edx,%eax
c0104d3f:	c1 e0 02             	shl    $0x2,%eax
c0104d42:	01 d0                	add    %edx,%eax
c0104d44:	c1 e0 02             	shl    $0x2,%eax
c0104d47:	89 c2                	mov    %eax,%edx
c0104d49:	8b 45 08             	mov    0x8(%ebp),%eax
c0104d4c:	01 d0                	add    %edx,%eax
c0104d4e:	39 45 f4             	cmp    %eax,-0xc(%ebp)
c0104d51:	72 40                	jb     c0104d93 <default_free_pages+0x2d5>
            assert(base + base->property != p);
c0104d53:	8b 45 08             	mov    0x8(%ebp),%eax
c0104d56:	8b 50 08             	mov    0x8(%eax),%edx
c0104d59:	89 d0                	mov    %edx,%eax
c0104d5b:	c1 e0 02             	shl    $0x2,%eax
c0104d5e:	01 d0                	add    %edx,%eax
c0104d60:	c1 e0 02             	shl    $0x2,%eax
c0104d63:	89 c2                	mov    %eax,%edx
c0104d65:	8b 45 08             	mov    0x8(%ebp),%eax
c0104d68:	01 d0                	add    %edx,%eax
c0104d6a:	39 45 f4             	cmp    %eax,-0xc(%ebp)
c0104d6d:	75 3e                	jne    c0104dad <default_free_pages+0x2ef>
c0104d6f:	c7 44 24 0c a1 73 10 	movl   $0xc01073a1,0xc(%esp)
c0104d76:	c0 
c0104d77:	c7 44 24 08 3e 73 10 	movl   $0xc010733e,0x8(%esp)
c0104d7e:	c0 
c0104d7f:	c7 44 24 04 b7 00 00 	movl   $0xb7,0x4(%esp)
c0104d86:	00 
c0104d87:	c7 04 24 53 73 10 c0 	movl   $0xc0107353,(%esp)
c0104d8e:	e8 9e b6 ff ff       	call   c0100431 <__panic>
c0104d93:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104d96:	89 45 98             	mov    %eax,-0x68(%ebp)
c0104d99:	8b 45 98             	mov    -0x68(%ebp),%eax
c0104d9c:	8b 40 04             	mov    0x4(%eax),%eax
            break;
        }
        le = list_next(le);
c0104d9f:	89 45 f0             	mov    %eax,-0x10(%ebp)
    while (le != &free_list) {
c0104da2:	81 7d f0 7c df 11 c0 	cmpl   $0xc011df7c,-0x10(%ebp)
c0104da9:	75 83                	jne    c0104d2e <default_free_pages+0x270>
c0104dab:	eb 01                	jmp    c0104dae <default_free_pages+0x2f0>
            break;
c0104dad:	90                   	nop
    }
    list_add_before(le, &(base->page_link));
c0104dae:	8b 45 08             	mov    0x8(%ebp),%eax
c0104db1:	8d 50 0c             	lea    0xc(%eax),%edx
c0104db4:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104db7:	89 45 94             	mov    %eax,-0x6c(%ebp)
c0104dba:	89 55 90             	mov    %edx,-0x70(%ebp)
    __list_add(elm, listelm->prev, listelm);
c0104dbd:	8b 45 94             	mov    -0x6c(%ebp),%eax
c0104dc0:	8b 00                	mov    (%eax),%eax
c0104dc2:	8b 55 90             	mov    -0x70(%ebp),%edx
c0104dc5:	89 55 8c             	mov    %edx,-0x74(%ebp)
c0104dc8:	89 45 88             	mov    %eax,-0x78(%ebp)
c0104dcb:	8b 45 94             	mov    -0x6c(%ebp),%eax
c0104dce:	89 45 84             	mov    %eax,-0x7c(%ebp)
    prev->next = next->prev = elm;
c0104dd1:	8b 45 84             	mov    -0x7c(%ebp),%eax
c0104dd4:	8b 55 8c             	mov    -0x74(%ebp),%edx
c0104dd7:	89 10                	mov    %edx,(%eax)
c0104dd9:	8b 45 84             	mov    -0x7c(%ebp),%eax
c0104ddc:	8b 10                	mov    (%eax),%edx
c0104dde:	8b 45 88             	mov    -0x78(%ebp),%eax
c0104de1:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c0104de4:	8b 45 8c             	mov    -0x74(%ebp),%eax
c0104de7:	8b 55 84             	mov    -0x7c(%ebp),%edx
c0104dea:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c0104ded:	8b 45 8c             	mov    -0x74(%ebp),%eax
c0104df0:	8b 55 88             	mov    -0x78(%ebp),%edx
c0104df3:	89 10                	mov    %edx,(%eax)
}
c0104df5:	90                   	nop
}
c0104df6:	90                   	nop
}
c0104df7:	90                   	nop
c0104df8:	c9                   	leave  
c0104df9:	c3                   	ret    

c0104dfa <default_nr_free_pages>:

static size_t
default_nr_free_pages(void) {
c0104dfa:	f3 0f 1e fb          	endbr32 
c0104dfe:	55                   	push   %ebp
c0104dff:	89 e5                	mov    %esp,%ebp
    return nr_free;
c0104e01:	a1 84 df 11 c0       	mov    0xc011df84,%eax
}
c0104e06:	5d                   	pop    %ebp
c0104e07:	c3                   	ret    

c0104e08 <basic_check>:

static void
basic_check(void) {
c0104e08:	f3 0f 1e fb          	endbr32 
c0104e0c:	55                   	push   %ebp
c0104e0d:	89 e5                	mov    %esp,%ebp
c0104e0f:	83 ec 48             	sub    $0x48,%esp
    struct Page *p0, *p1, *p2;
    p0 = p1 = p2 = NULL;
c0104e12:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0104e19:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104e1c:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0104e1f:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104e22:	89 45 ec             	mov    %eax,-0x14(%ebp)
    assert((p0 = alloc_page()) != NULL);
c0104e25:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0104e2c:	e8 4b e2 ff ff       	call   c010307c <alloc_pages>
c0104e31:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0104e34:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c0104e38:	75 24                	jne    c0104e5e <basic_check+0x56>
c0104e3a:	c7 44 24 0c bc 73 10 	movl   $0xc01073bc,0xc(%esp)
c0104e41:	c0 
c0104e42:	c7 44 24 08 3e 73 10 	movl   $0xc010733e,0x8(%esp)
c0104e49:	c0 
c0104e4a:	c7 44 24 04 c8 00 00 	movl   $0xc8,0x4(%esp)
c0104e51:	00 
c0104e52:	c7 04 24 53 73 10 c0 	movl   $0xc0107353,(%esp)
c0104e59:	e8 d3 b5 ff ff       	call   c0100431 <__panic>
    assert((p1 = alloc_page()) != NULL);
c0104e5e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0104e65:	e8 12 e2 ff ff       	call   c010307c <alloc_pages>
c0104e6a:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0104e6d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0104e71:	75 24                	jne    c0104e97 <basic_check+0x8f>
c0104e73:	c7 44 24 0c d8 73 10 	movl   $0xc01073d8,0xc(%esp)
c0104e7a:	c0 
c0104e7b:	c7 44 24 08 3e 73 10 	movl   $0xc010733e,0x8(%esp)
c0104e82:	c0 
c0104e83:	c7 44 24 04 c9 00 00 	movl   $0xc9,0x4(%esp)
c0104e8a:	00 
c0104e8b:	c7 04 24 53 73 10 c0 	movl   $0xc0107353,(%esp)
c0104e92:	e8 9a b5 ff ff       	call   c0100431 <__panic>
    assert((p2 = alloc_page()) != NULL);
c0104e97:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0104e9e:	e8 d9 e1 ff ff       	call   c010307c <alloc_pages>
c0104ea3:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0104ea6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0104eaa:	75 24                	jne    c0104ed0 <basic_check+0xc8>
c0104eac:	c7 44 24 0c f4 73 10 	movl   $0xc01073f4,0xc(%esp)
c0104eb3:	c0 
c0104eb4:	c7 44 24 08 3e 73 10 	movl   $0xc010733e,0x8(%esp)
c0104ebb:	c0 
c0104ebc:	c7 44 24 04 ca 00 00 	movl   $0xca,0x4(%esp)
c0104ec3:	00 
c0104ec4:	c7 04 24 53 73 10 c0 	movl   $0xc0107353,(%esp)
c0104ecb:	e8 61 b5 ff ff       	call   c0100431 <__panic>

    assert(p0 != p1 && p0 != p2 && p1 != p2);
c0104ed0:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104ed3:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c0104ed6:	74 10                	je     c0104ee8 <basic_check+0xe0>
c0104ed8:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104edb:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0104ede:	74 08                	je     c0104ee8 <basic_check+0xe0>
c0104ee0:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104ee3:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0104ee6:	75 24                	jne    c0104f0c <basic_check+0x104>
c0104ee8:	c7 44 24 0c 10 74 10 	movl   $0xc0107410,0xc(%esp)
c0104eef:	c0 
c0104ef0:	c7 44 24 08 3e 73 10 	movl   $0xc010733e,0x8(%esp)
c0104ef7:	c0 
c0104ef8:	c7 44 24 04 cc 00 00 	movl   $0xcc,0x4(%esp)
c0104eff:	00 
c0104f00:	c7 04 24 53 73 10 c0 	movl   $0xc0107353,(%esp)
c0104f07:	e8 25 b5 ff ff       	call   c0100431 <__panic>
    assert(page_ref(p0) == 0 && page_ref(p1) == 0 && page_ref(p2) == 0);
c0104f0c:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104f0f:	89 04 24             	mov    %eax,(%esp)
c0104f12:	e8 60 f8 ff ff       	call   c0104777 <page_ref>
c0104f17:	85 c0                	test   %eax,%eax
c0104f19:	75 1e                	jne    c0104f39 <basic_check+0x131>
c0104f1b:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104f1e:	89 04 24             	mov    %eax,(%esp)
c0104f21:	e8 51 f8 ff ff       	call   c0104777 <page_ref>
c0104f26:	85 c0                	test   %eax,%eax
c0104f28:	75 0f                	jne    c0104f39 <basic_check+0x131>
c0104f2a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104f2d:	89 04 24             	mov    %eax,(%esp)
c0104f30:	e8 42 f8 ff ff       	call   c0104777 <page_ref>
c0104f35:	85 c0                	test   %eax,%eax
c0104f37:	74 24                	je     c0104f5d <basic_check+0x155>
c0104f39:	c7 44 24 0c 34 74 10 	movl   $0xc0107434,0xc(%esp)
c0104f40:	c0 
c0104f41:	c7 44 24 08 3e 73 10 	movl   $0xc010733e,0x8(%esp)
c0104f48:	c0 
c0104f49:	c7 44 24 04 cd 00 00 	movl   $0xcd,0x4(%esp)
c0104f50:	00 
c0104f51:	c7 04 24 53 73 10 c0 	movl   $0xc0107353,(%esp)
c0104f58:	e8 d4 b4 ff ff       	call   c0100431 <__panic>

    assert(page2pa(p0) < npage * PGSIZE);
c0104f5d:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104f60:	89 04 24             	mov    %eax,(%esp)
c0104f63:	e8 f9 f7 ff ff       	call   c0104761 <page2pa>
c0104f68:	8b 15 80 de 11 c0    	mov    0xc011de80,%edx
c0104f6e:	c1 e2 0c             	shl    $0xc,%edx
c0104f71:	39 d0                	cmp    %edx,%eax
c0104f73:	72 24                	jb     c0104f99 <basic_check+0x191>
c0104f75:	c7 44 24 0c 70 74 10 	movl   $0xc0107470,0xc(%esp)
c0104f7c:	c0 
c0104f7d:	c7 44 24 08 3e 73 10 	movl   $0xc010733e,0x8(%esp)
c0104f84:	c0 
c0104f85:	c7 44 24 04 cf 00 00 	movl   $0xcf,0x4(%esp)
c0104f8c:	00 
c0104f8d:	c7 04 24 53 73 10 c0 	movl   $0xc0107353,(%esp)
c0104f94:	e8 98 b4 ff ff       	call   c0100431 <__panic>
    assert(page2pa(p1) < npage * PGSIZE);
c0104f99:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104f9c:	89 04 24             	mov    %eax,(%esp)
c0104f9f:	e8 bd f7 ff ff       	call   c0104761 <page2pa>
c0104fa4:	8b 15 80 de 11 c0    	mov    0xc011de80,%edx
c0104faa:	c1 e2 0c             	shl    $0xc,%edx
c0104fad:	39 d0                	cmp    %edx,%eax
c0104faf:	72 24                	jb     c0104fd5 <basic_check+0x1cd>
c0104fb1:	c7 44 24 0c 8d 74 10 	movl   $0xc010748d,0xc(%esp)
c0104fb8:	c0 
c0104fb9:	c7 44 24 08 3e 73 10 	movl   $0xc010733e,0x8(%esp)
c0104fc0:	c0 
c0104fc1:	c7 44 24 04 d0 00 00 	movl   $0xd0,0x4(%esp)
c0104fc8:	00 
c0104fc9:	c7 04 24 53 73 10 c0 	movl   $0xc0107353,(%esp)
c0104fd0:	e8 5c b4 ff ff       	call   c0100431 <__panic>
    assert(page2pa(p2) < npage * PGSIZE);
c0104fd5:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104fd8:	89 04 24             	mov    %eax,(%esp)
c0104fdb:	e8 81 f7 ff ff       	call   c0104761 <page2pa>
c0104fe0:	8b 15 80 de 11 c0    	mov    0xc011de80,%edx
c0104fe6:	c1 e2 0c             	shl    $0xc,%edx
c0104fe9:	39 d0                	cmp    %edx,%eax
c0104feb:	72 24                	jb     c0105011 <basic_check+0x209>
c0104fed:	c7 44 24 0c aa 74 10 	movl   $0xc01074aa,0xc(%esp)
c0104ff4:	c0 
c0104ff5:	c7 44 24 08 3e 73 10 	movl   $0xc010733e,0x8(%esp)
c0104ffc:	c0 
c0104ffd:	c7 44 24 04 d1 00 00 	movl   $0xd1,0x4(%esp)
c0105004:	00 
c0105005:	c7 04 24 53 73 10 c0 	movl   $0xc0107353,(%esp)
c010500c:	e8 20 b4 ff ff       	call   c0100431 <__panic>

    list_entry_t free_list_store = free_list;
c0105011:	a1 7c df 11 c0       	mov    0xc011df7c,%eax
c0105016:	8b 15 80 df 11 c0    	mov    0xc011df80,%edx
c010501c:	89 45 d0             	mov    %eax,-0x30(%ebp)
c010501f:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c0105022:	c7 45 dc 7c df 11 c0 	movl   $0xc011df7c,-0x24(%ebp)
    elm->prev = elm->next = elm;
c0105029:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010502c:	8b 55 dc             	mov    -0x24(%ebp),%edx
c010502f:	89 50 04             	mov    %edx,0x4(%eax)
c0105032:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0105035:	8b 50 04             	mov    0x4(%eax),%edx
c0105038:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010503b:	89 10                	mov    %edx,(%eax)
}
c010503d:	90                   	nop
c010503e:	c7 45 e0 7c df 11 c0 	movl   $0xc011df7c,-0x20(%ebp)
    return list->next == list;
c0105045:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105048:	8b 40 04             	mov    0x4(%eax),%eax
c010504b:	39 45 e0             	cmp    %eax,-0x20(%ebp)
c010504e:	0f 94 c0             	sete   %al
c0105051:	0f b6 c0             	movzbl %al,%eax
    list_init(&free_list);
    assert(list_empty(&free_list));
c0105054:	85 c0                	test   %eax,%eax
c0105056:	75 24                	jne    c010507c <basic_check+0x274>
c0105058:	c7 44 24 0c c7 74 10 	movl   $0xc01074c7,0xc(%esp)
c010505f:	c0 
c0105060:	c7 44 24 08 3e 73 10 	movl   $0xc010733e,0x8(%esp)
c0105067:	c0 
c0105068:	c7 44 24 04 d5 00 00 	movl   $0xd5,0x4(%esp)
c010506f:	00 
c0105070:	c7 04 24 53 73 10 c0 	movl   $0xc0107353,(%esp)
c0105077:	e8 b5 b3 ff ff       	call   c0100431 <__panic>

    unsigned int nr_free_store = nr_free;
c010507c:	a1 84 df 11 c0       	mov    0xc011df84,%eax
c0105081:	89 45 e8             	mov    %eax,-0x18(%ebp)
    nr_free = 0;
c0105084:	c7 05 84 df 11 c0 00 	movl   $0x0,0xc011df84
c010508b:	00 00 00 

    assert(alloc_page() == NULL);
c010508e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0105095:	e8 e2 df ff ff       	call   c010307c <alloc_pages>
c010509a:	85 c0                	test   %eax,%eax
c010509c:	74 24                	je     c01050c2 <basic_check+0x2ba>
c010509e:	c7 44 24 0c de 74 10 	movl   $0xc01074de,0xc(%esp)
c01050a5:	c0 
c01050a6:	c7 44 24 08 3e 73 10 	movl   $0xc010733e,0x8(%esp)
c01050ad:	c0 
c01050ae:	c7 44 24 04 da 00 00 	movl   $0xda,0x4(%esp)
c01050b5:	00 
c01050b6:	c7 04 24 53 73 10 c0 	movl   $0xc0107353,(%esp)
c01050bd:	e8 6f b3 ff ff       	call   c0100431 <__panic>

    free_page(p0);
c01050c2:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c01050c9:	00 
c01050ca:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01050cd:	89 04 24             	mov    %eax,(%esp)
c01050d0:	e8 e3 df ff ff       	call   c01030b8 <free_pages>
    free_page(p1);
c01050d5:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c01050dc:	00 
c01050dd:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01050e0:	89 04 24             	mov    %eax,(%esp)
c01050e3:	e8 d0 df ff ff       	call   c01030b8 <free_pages>
    free_page(p2);
c01050e8:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c01050ef:	00 
c01050f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01050f3:	89 04 24             	mov    %eax,(%esp)
c01050f6:	e8 bd df ff ff       	call   c01030b8 <free_pages>
    assert(nr_free == 3);
c01050fb:	a1 84 df 11 c0       	mov    0xc011df84,%eax
c0105100:	83 f8 03             	cmp    $0x3,%eax
c0105103:	74 24                	je     c0105129 <basic_check+0x321>
c0105105:	c7 44 24 0c f3 74 10 	movl   $0xc01074f3,0xc(%esp)
c010510c:	c0 
c010510d:	c7 44 24 08 3e 73 10 	movl   $0xc010733e,0x8(%esp)
c0105114:	c0 
c0105115:	c7 44 24 04 df 00 00 	movl   $0xdf,0x4(%esp)
c010511c:	00 
c010511d:	c7 04 24 53 73 10 c0 	movl   $0xc0107353,(%esp)
c0105124:	e8 08 b3 ff ff       	call   c0100431 <__panic>

    assert((p0 = alloc_page()) != NULL);
c0105129:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0105130:	e8 47 df ff ff       	call   c010307c <alloc_pages>
c0105135:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0105138:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c010513c:	75 24                	jne    c0105162 <basic_check+0x35a>
c010513e:	c7 44 24 0c bc 73 10 	movl   $0xc01073bc,0xc(%esp)
c0105145:	c0 
c0105146:	c7 44 24 08 3e 73 10 	movl   $0xc010733e,0x8(%esp)
c010514d:	c0 
c010514e:	c7 44 24 04 e1 00 00 	movl   $0xe1,0x4(%esp)
c0105155:	00 
c0105156:	c7 04 24 53 73 10 c0 	movl   $0xc0107353,(%esp)
c010515d:	e8 cf b2 ff ff       	call   c0100431 <__panic>
    assert((p1 = alloc_page()) != NULL);
c0105162:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0105169:	e8 0e df ff ff       	call   c010307c <alloc_pages>
c010516e:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105171:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0105175:	75 24                	jne    c010519b <basic_check+0x393>
c0105177:	c7 44 24 0c d8 73 10 	movl   $0xc01073d8,0xc(%esp)
c010517e:	c0 
c010517f:	c7 44 24 08 3e 73 10 	movl   $0xc010733e,0x8(%esp)
c0105186:	c0 
c0105187:	c7 44 24 04 e2 00 00 	movl   $0xe2,0x4(%esp)
c010518e:	00 
c010518f:	c7 04 24 53 73 10 c0 	movl   $0xc0107353,(%esp)
c0105196:	e8 96 b2 ff ff       	call   c0100431 <__panic>
    assert((p2 = alloc_page()) != NULL);
c010519b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01051a2:	e8 d5 de ff ff       	call   c010307c <alloc_pages>
c01051a7:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01051aa:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01051ae:	75 24                	jne    c01051d4 <basic_check+0x3cc>
c01051b0:	c7 44 24 0c f4 73 10 	movl   $0xc01073f4,0xc(%esp)
c01051b7:	c0 
c01051b8:	c7 44 24 08 3e 73 10 	movl   $0xc010733e,0x8(%esp)
c01051bf:	c0 
c01051c0:	c7 44 24 04 e3 00 00 	movl   $0xe3,0x4(%esp)
c01051c7:	00 
c01051c8:	c7 04 24 53 73 10 c0 	movl   $0xc0107353,(%esp)
c01051cf:	e8 5d b2 ff ff       	call   c0100431 <__panic>

    assert(alloc_page() == NULL);
c01051d4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01051db:	e8 9c de ff ff       	call   c010307c <alloc_pages>
c01051e0:	85 c0                	test   %eax,%eax
c01051e2:	74 24                	je     c0105208 <basic_check+0x400>
c01051e4:	c7 44 24 0c de 74 10 	movl   $0xc01074de,0xc(%esp)
c01051eb:	c0 
c01051ec:	c7 44 24 08 3e 73 10 	movl   $0xc010733e,0x8(%esp)
c01051f3:	c0 
c01051f4:	c7 44 24 04 e5 00 00 	movl   $0xe5,0x4(%esp)
c01051fb:	00 
c01051fc:	c7 04 24 53 73 10 c0 	movl   $0xc0107353,(%esp)
c0105203:	e8 29 b2 ff ff       	call   c0100431 <__panic>

    free_page(p0);
c0105208:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c010520f:	00 
c0105210:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105213:	89 04 24             	mov    %eax,(%esp)
c0105216:	e8 9d de ff ff       	call   c01030b8 <free_pages>
c010521b:	c7 45 d8 7c df 11 c0 	movl   $0xc011df7c,-0x28(%ebp)
c0105222:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0105225:	8b 40 04             	mov    0x4(%eax),%eax
c0105228:	39 45 d8             	cmp    %eax,-0x28(%ebp)
c010522b:	0f 94 c0             	sete   %al
c010522e:	0f b6 c0             	movzbl %al,%eax
    assert(!list_empty(&free_list));
c0105231:	85 c0                	test   %eax,%eax
c0105233:	74 24                	je     c0105259 <basic_check+0x451>
c0105235:	c7 44 24 0c 00 75 10 	movl   $0xc0107500,0xc(%esp)
c010523c:	c0 
c010523d:	c7 44 24 08 3e 73 10 	movl   $0xc010733e,0x8(%esp)
c0105244:	c0 
c0105245:	c7 44 24 04 e8 00 00 	movl   $0xe8,0x4(%esp)
c010524c:	00 
c010524d:	c7 04 24 53 73 10 c0 	movl   $0xc0107353,(%esp)
c0105254:	e8 d8 b1 ff ff       	call   c0100431 <__panic>

    struct Page *p;
    assert((p = alloc_page()) == p0);
c0105259:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0105260:	e8 17 de ff ff       	call   c010307c <alloc_pages>
c0105265:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0105268:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010526b:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c010526e:	74 24                	je     c0105294 <basic_check+0x48c>
c0105270:	c7 44 24 0c 18 75 10 	movl   $0xc0107518,0xc(%esp)
c0105277:	c0 
c0105278:	c7 44 24 08 3e 73 10 	movl   $0xc010733e,0x8(%esp)
c010527f:	c0 
c0105280:	c7 44 24 04 eb 00 00 	movl   $0xeb,0x4(%esp)
c0105287:	00 
c0105288:	c7 04 24 53 73 10 c0 	movl   $0xc0107353,(%esp)
c010528f:	e8 9d b1 ff ff       	call   c0100431 <__panic>
    assert(alloc_page() == NULL);
c0105294:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c010529b:	e8 dc dd ff ff       	call   c010307c <alloc_pages>
c01052a0:	85 c0                	test   %eax,%eax
c01052a2:	74 24                	je     c01052c8 <basic_check+0x4c0>
c01052a4:	c7 44 24 0c de 74 10 	movl   $0xc01074de,0xc(%esp)
c01052ab:	c0 
c01052ac:	c7 44 24 08 3e 73 10 	movl   $0xc010733e,0x8(%esp)
c01052b3:	c0 
c01052b4:	c7 44 24 04 ec 00 00 	movl   $0xec,0x4(%esp)
c01052bb:	00 
c01052bc:	c7 04 24 53 73 10 c0 	movl   $0xc0107353,(%esp)
c01052c3:	e8 69 b1 ff ff       	call   c0100431 <__panic>

    assert(nr_free == 0);
c01052c8:	a1 84 df 11 c0       	mov    0xc011df84,%eax
c01052cd:	85 c0                	test   %eax,%eax
c01052cf:	74 24                	je     c01052f5 <basic_check+0x4ed>
c01052d1:	c7 44 24 0c 31 75 10 	movl   $0xc0107531,0xc(%esp)
c01052d8:	c0 
c01052d9:	c7 44 24 08 3e 73 10 	movl   $0xc010733e,0x8(%esp)
c01052e0:	c0 
c01052e1:	c7 44 24 04 ee 00 00 	movl   $0xee,0x4(%esp)
c01052e8:	00 
c01052e9:	c7 04 24 53 73 10 c0 	movl   $0xc0107353,(%esp)
c01052f0:	e8 3c b1 ff ff       	call   c0100431 <__panic>
    free_list = free_list_store;
c01052f5:	8b 45 d0             	mov    -0x30(%ebp),%eax
c01052f8:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01052fb:	a3 7c df 11 c0       	mov    %eax,0xc011df7c
c0105300:	89 15 80 df 11 c0    	mov    %edx,0xc011df80
    nr_free = nr_free_store;
c0105306:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105309:	a3 84 df 11 c0       	mov    %eax,0xc011df84

    free_page(p);
c010530e:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0105315:	00 
c0105316:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105319:	89 04 24             	mov    %eax,(%esp)
c010531c:	e8 97 dd ff ff       	call   c01030b8 <free_pages>
    free_page(p1);
c0105321:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0105328:	00 
c0105329:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010532c:	89 04 24             	mov    %eax,(%esp)
c010532f:	e8 84 dd ff ff       	call   c01030b8 <free_pages>
    free_page(p2);
c0105334:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c010533b:	00 
c010533c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010533f:	89 04 24             	mov    %eax,(%esp)
c0105342:	e8 71 dd ff ff       	call   c01030b8 <free_pages>
}
c0105347:	90                   	nop
c0105348:	c9                   	leave  
c0105349:	c3                   	ret    

c010534a <default_check>:

// LAB2: below code is used to check the first fit allocation algorithm (your EXERCISE 1) 
// NOTICE: You SHOULD NOT CHANGE basic_check, default_check functions!
static void
default_check(void) {
c010534a:	f3 0f 1e fb          	endbr32 
c010534e:	55                   	push   %ebp
c010534f:	89 e5                	mov    %esp,%ebp
c0105351:	81 ec 98 00 00 00    	sub    $0x98,%esp
    int count = 0, total = 0;
c0105357:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c010535e:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    list_entry_t *le = &free_list;
c0105365:	c7 45 ec 7c df 11 c0 	movl   $0xc011df7c,-0x14(%ebp)
    while ((le = list_next(le)) != &free_list) {
c010536c:	eb 6a                	jmp    c01053d8 <default_check+0x8e>
        struct Page *p = le2page(le, page_link);
c010536e:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105371:	83 e8 0c             	sub    $0xc,%eax
c0105374:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        assert(PageProperty(p));
c0105377:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010537a:	83 c0 04             	add    $0x4,%eax
c010537d:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
c0105384:	89 45 cc             	mov    %eax,-0x34(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0105387:	8b 45 cc             	mov    -0x34(%ebp),%eax
c010538a:	8b 55 d0             	mov    -0x30(%ebp),%edx
c010538d:	0f a3 10             	bt     %edx,(%eax)
c0105390:	19 c0                	sbb    %eax,%eax
c0105392:	89 45 c8             	mov    %eax,-0x38(%ebp)
    return oldbit != 0;
c0105395:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
c0105399:	0f 95 c0             	setne  %al
c010539c:	0f b6 c0             	movzbl %al,%eax
c010539f:	85 c0                	test   %eax,%eax
c01053a1:	75 24                	jne    c01053c7 <default_check+0x7d>
c01053a3:	c7 44 24 0c 3e 75 10 	movl   $0xc010753e,0xc(%esp)
c01053aa:	c0 
c01053ab:	c7 44 24 08 3e 73 10 	movl   $0xc010733e,0x8(%esp)
c01053b2:	c0 
c01053b3:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
c01053ba:	00 
c01053bb:	c7 04 24 53 73 10 c0 	movl   $0xc0107353,(%esp)
c01053c2:	e8 6a b0 ff ff       	call   c0100431 <__panic>
        count ++, total += p->property;
c01053c7:	ff 45 f4             	incl   -0xc(%ebp)
c01053ca:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01053cd:	8b 50 08             	mov    0x8(%eax),%edx
c01053d0:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01053d3:	01 d0                	add    %edx,%eax
c01053d5:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01053d8:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01053db:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    return listelm->next;
c01053de:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c01053e1:	8b 40 04             	mov    0x4(%eax),%eax
    while ((le = list_next(le)) != &free_list) {
c01053e4:	89 45 ec             	mov    %eax,-0x14(%ebp)
c01053e7:	81 7d ec 7c df 11 c0 	cmpl   $0xc011df7c,-0x14(%ebp)
c01053ee:	0f 85 7a ff ff ff    	jne    c010536e <default_check+0x24>
    }
    assert(total == nr_free_pages());
c01053f4:	e8 f6 dc ff ff       	call   c01030ef <nr_free_pages>
c01053f9:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01053fc:	39 d0                	cmp    %edx,%eax
c01053fe:	74 24                	je     c0105424 <default_check+0xda>
c0105400:	c7 44 24 0c 4e 75 10 	movl   $0xc010754e,0xc(%esp)
c0105407:	c0 
c0105408:	c7 44 24 08 3e 73 10 	movl   $0xc010733e,0x8(%esp)
c010540f:	c0 
c0105410:	c7 44 24 04 02 01 00 	movl   $0x102,0x4(%esp)
c0105417:	00 
c0105418:	c7 04 24 53 73 10 c0 	movl   $0xc0107353,(%esp)
c010541f:	e8 0d b0 ff ff       	call   c0100431 <__panic>

    basic_check();
c0105424:	e8 df f9 ff ff       	call   c0104e08 <basic_check>

    struct Page *p0 = alloc_pages(5), *p1, *p2;
c0105429:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
c0105430:	e8 47 dc ff ff       	call   c010307c <alloc_pages>
c0105435:	89 45 e8             	mov    %eax,-0x18(%ebp)
    assert(p0 != NULL);
c0105438:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c010543c:	75 24                	jne    c0105462 <default_check+0x118>
c010543e:	c7 44 24 0c 67 75 10 	movl   $0xc0107567,0xc(%esp)
c0105445:	c0 
c0105446:	c7 44 24 08 3e 73 10 	movl   $0xc010733e,0x8(%esp)
c010544d:	c0 
c010544e:	c7 44 24 04 07 01 00 	movl   $0x107,0x4(%esp)
c0105455:	00 
c0105456:	c7 04 24 53 73 10 c0 	movl   $0xc0107353,(%esp)
c010545d:	e8 cf af ff ff       	call   c0100431 <__panic>
    assert(!PageProperty(p0));
c0105462:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105465:	83 c0 04             	add    $0x4,%eax
c0105468:	c7 45 c0 01 00 00 00 	movl   $0x1,-0x40(%ebp)
c010546f:	89 45 bc             	mov    %eax,-0x44(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0105472:	8b 45 bc             	mov    -0x44(%ebp),%eax
c0105475:	8b 55 c0             	mov    -0x40(%ebp),%edx
c0105478:	0f a3 10             	bt     %edx,(%eax)
c010547b:	19 c0                	sbb    %eax,%eax
c010547d:	89 45 b8             	mov    %eax,-0x48(%ebp)
    return oldbit != 0;
c0105480:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
c0105484:	0f 95 c0             	setne  %al
c0105487:	0f b6 c0             	movzbl %al,%eax
c010548a:	85 c0                	test   %eax,%eax
c010548c:	74 24                	je     c01054b2 <default_check+0x168>
c010548e:	c7 44 24 0c 72 75 10 	movl   $0xc0107572,0xc(%esp)
c0105495:	c0 
c0105496:	c7 44 24 08 3e 73 10 	movl   $0xc010733e,0x8(%esp)
c010549d:	c0 
c010549e:	c7 44 24 04 08 01 00 	movl   $0x108,0x4(%esp)
c01054a5:	00 
c01054a6:	c7 04 24 53 73 10 c0 	movl   $0xc0107353,(%esp)
c01054ad:	e8 7f af ff ff       	call   c0100431 <__panic>

    list_entry_t free_list_store = free_list;
c01054b2:	a1 7c df 11 c0       	mov    0xc011df7c,%eax
c01054b7:	8b 15 80 df 11 c0    	mov    0xc011df80,%edx
c01054bd:	89 45 80             	mov    %eax,-0x80(%ebp)
c01054c0:	89 55 84             	mov    %edx,-0x7c(%ebp)
c01054c3:	c7 45 b0 7c df 11 c0 	movl   $0xc011df7c,-0x50(%ebp)
    elm->prev = elm->next = elm;
c01054ca:	8b 45 b0             	mov    -0x50(%ebp),%eax
c01054cd:	8b 55 b0             	mov    -0x50(%ebp),%edx
c01054d0:	89 50 04             	mov    %edx,0x4(%eax)
c01054d3:	8b 45 b0             	mov    -0x50(%ebp),%eax
c01054d6:	8b 50 04             	mov    0x4(%eax),%edx
c01054d9:	8b 45 b0             	mov    -0x50(%ebp),%eax
c01054dc:	89 10                	mov    %edx,(%eax)
}
c01054de:	90                   	nop
c01054df:	c7 45 b4 7c df 11 c0 	movl   $0xc011df7c,-0x4c(%ebp)
    return list->next == list;
c01054e6:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c01054e9:	8b 40 04             	mov    0x4(%eax),%eax
c01054ec:	39 45 b4             	cmp    %eax,-0x4c(%ebp)
c01054ef:	0f 94 c0             	sete   %al
c01054f2:	0f b6 c0             	movzbl %al,%eax
    list_init(&free_list);
    assert(list_empty(&free_list));
c01054f5:	85 c0                	test   %eax,%eax
c01054f7:	75 24                	jne    c010551d <default_check+0x1d3>
c01054f9:	c7 44 24 0c c7 74 10 	movl   $0xc01074c7,0xc(%esp)
c0105500:	c0 
c0105501:	c7 44 24 08 3e 73 10 	movl   $0xc010733e,0x8(%esp)
c0105508:	c0 
c0105509:	c7 44 24 04 0c 01 00 	movl   $0x10c,0x4(%esp)
c0105510:	00 
c0105511:	c7 04 24 53 73 10 c0 	movl   $0xc0107353,(%esp)
c0105518:	e8 14 af ff ff       	call   c0100431 <__panic>
    assert(alloc_page() == NULL);
c010551d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0105524:	e8 53 db ff ff       	call   c010307c <alloc_pages>
c0105529:	85 c0                	test   %eax,%eax
c010552b:	74 24                	je     c0105551 <default_check+0x207>
c010552d:	c7 44 24 0c de 74 10 	movl   $0xc01074de,0xc(%esp)
c0105534:	c0 
c0105535:	c7 44 24 08 3e 73 10 	movl   $0xc010733e,0x8(%esp)
c010553c:	c0 
c010553d:	c7 44 24 04 0d 01 00 	movl   $0x10d,0x4(%esp)
c0105544:	00 
c0105545:	c7 04 24 53 73 10 c0 	movl   $0xc0107353,(%esp)
c010554c:	e8 e0 ae ff ff       	call   c0100431 <__panic>

    unsigned int nr_free_store = nr_free;
c0105551:	a1 84 df 11 c0       	mov    0xc011df84,%eax
c0105556:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    nr_free = 0;
c0105559:	c7 05 84 df 11 c0 00 	movl   $0x0,0xc011df84
c0105560:	00 00 00 

    free_pages(p0 + 2, 3);
c0105563:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105566:	83 c0 28             	add    $0x28,%eax
c0105569:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
c0105570:	00 
c0105571:	89 04 24             	mov    %eax,(%esp)
c0105574:	e8 3f db ff ff       	call   c01030b8 <free_pages>
    assert(alloc_pages(4) == NULL);
c0105579:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
c0105580:	e8 f7 da ff ff       	call   c010307c <alloc_pages>
c0105585:	85 c0                	test   %eax,%eax
c0105587:	74 24                	je     c01055ad <default_check+0x263>
c0105589:	c7 44 24 0c 84 75 10 	movl   $0xc0107584,0xc(%esp)
c0105590:	c0 
c0105591:	c7 44 24 08 3e 73 10 	movl   $0xc010733e,0x8(%esp)
c0105598:	c0 
c0105599:	c7 44 24 04 13 01 00 	movl   $0x113,0x4(%esp)
c01055a0:	00 
c01055a1:	c7 04 24 53 73 10 c0 	movl   $0xc0107353,(%esp)
c01055a8:	e8 84 ae ff ff       	call   c0100431 <__panic>
    assert(PageProperty(p0 + 2) && p0[2].property == 3);
c01055ad:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01055b0:	83 c0 28             	add    $0x28,%eax
c01055b3:	83 c0 04             	add    $0x4,%eax
c01055b6:	c7 45 ac 01 00 00 00 	movl   $0x1,-0x54(%ebp)
c01055bd:	89 45 a8             	mov    %eax,-0x58(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c01055c0:	8b 45 a8             	mov    -0x58(%ebp),%eax
c01055c3:	8b 55 ac             	mov    -0x54(%ebp),%edx
c01055c6:	0f a3 10             	bt     %edx,(%eax)
c01055c9:	19 c0                	sbb    %eax,%eax
c01055cb:	89 45 a4             	mov    %eax,-0x5c(%ebp)
    return oldbit != 0;
c01055ce:	83 7d a4 00          	cmpl   $0x0,-0x5c(%ebp)
c01055d2:	0f 95 c0             	setne  %al
c01055d5:	0f b6 c0             	movzbl %al,%eax
c01055d8:	85 c0                	test   %eax,%eax
c01055da:	74 0e                	je     c01055ea <default_check+0x2a0>
c01055dc:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01055df:	83 c0 28             	add    $0x28,%eax
c01055e2:	8b 40 08             	mov    0x8(%eax),%eax
c01055e5:	83 f8 03             	cmp    $0x3,%eax
c01055e8:	74 24                	je     c010560e <default_check+0x2c4>
c01055ea:	c7 44 24 0c 9c 75 10 	movl   $0xc010759c,0xc(%esp)
c01055f1:	c0 
c01055f2:	c7 44 24 08 3e 73 10 	movl   $0xc010733e,0x8(%esp)
c01055f9:	c0 
c01055fa:	c7 44 24 04 14 01 00 	movl   $0x114,0x4(%esp)
c0105601:	00 
c0105602:	c7 04 24 53 73 10 c0 	movl   $0xc0107353,(%esp)
c0105609:	e8 23 ae ff ff       	call   c0100431 <__panic>
    assert((p1 = alloc_pages(3)) != NULL);
c010560e:	c7 04 24 03 00 00 00 	movl   $0x3,(%esp)
c0105615:	e8 62 da ff ff       	call   c010307c <alloc_pages>
c010561a:	89 45 e0             	mov    %eax,-0x20(%ebp)
c010561d:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
c0105621:	75 24                	jne    c0105647 <default_check+0x2fd>
c0105623:	c7 44 24 0c c8 75 10 	movl   $0xc01075c8,0xc(%esp)
c010562a:	c0 
c010562b:	c7 44 24 08 3e 73 10 	movl   $0xc010733e,0x8(%esp)
c0105632:	c0 
c0105633:	c7 44 24 04 15 01 00 	movl   $0x115,0x4(%esp)
c010563a:	00 
c010563b:	c7 04 24 53 73 10 c0 	movl   $0xc0107353,(%esp)
c0105642:	e8 ea ad ff ff       	call   c0100431 <__panic>
    assert(alloc_page() == NULL);
c0105647:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c010564e:	e8 29 da ff ff       	call   c010307c <alloc_pages>
c0105653:	85 c0                	test   %eax,%eax
c0105655:	74 24                	je     c010567b <default_check+0x331>
c0105657:	c7 44 24 0c de 74 10 	movl   $0xc01074de,0xc(%esp)
c010565e:	c0 
c010565f:	c7 44 24 08 3e 73 10 	movl   $0xc010733e,0x8(%esp)
c0105666:	c0 
c0105667:	c7 44 24 04 16 01 00 	movl   $0x116,0x4(%esp)
c010566e:	00 
c010566f:	c7 04 24 53 73 10 c0 	movl   $0xc0107353,(%esp)
c0105676:	e8 b6 ad ff ff       	call   c0100431 <__panic>
    assert(p0 + 2 == p1);
c010567b:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010567e:	83 c0 28             	add    $0x28,%eax
c0105681:	39 45 e0             	cmp    %eax,-0x20(%ebp)
c0105684:	74 24                	je     c01056aa <default_check+0x360>
c0105686:	c7 44 24 0c e6 75 10 	movl   $0xc01075e6,0xc(%esp)
c010568d:	c0 
c010568e:	c7 44 24 08 3e 73 10 	movl   $0xc010733e,0x8(%esp)
c0105695:	c0 
c0105696:	c7 44 24 04 17 01 00 	movl   $0x117,0x4(%esp)
c010569d:	00 
c010569e:	c7 04 24 53 73 10 c0 	movl   $0xc0107353,(%esp)
c01056a5:	e8 87 ad ff ff       	call   c0100431 <__panic>

    p2 = p0 + 1;
c01056aa:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01056ad:	83 c0 14             	add    $0x14,%eax
c01056b0:	89 45 dc             	mov    %eax,-0x24(%ebp)
    free_page(p0);
c01056b3:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c01056ba:	00 
c01056bb:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01056be:	89 04 24             	mov    %eax,(%esp)
c01056c1:	e8 f2 d9 ff ff       	call   c01030b8 <free_pages>
    free_pages(p1, 3);
c01056c6:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
c01056cd:	00 
c01056ce:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01056d1:	89 04 24             	mov    %eax,(%esp)
c01056d4:	e8 df d9 ff ff       	call   c01030b8 <free_pages>
    assert(PageProperty(p0) && p0->property == 1);
c01056d9:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01056dc:	83 c0 04             	add    $0x4,%eax
c01056df:	c7 45 a0 01 00 00 00 	movl   $0x1,-0x60(%ebp)
c01056e6:	89 45 9c             	mov    %eax,-0x64(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c01056e9:	8b 45 9c             	mov    -0x64(%ebp),%eax
c01056ec:	8b 55 a0             	mov    -0x60(%ebp),%edx
c01056ef:	0f a3 10             	bt     %edx,(%eax)
c01056f2:	19 c0                	sbb    %eax,%eax
c01056f4:	89 45 98             	mov    %eax,-0x68(%ebp)
    return oldbit != 0;
c01056f7:	83 7d 98 00          	cmpl   $0x0,-0x68(%ebp)
c01056fb:	0f 95 c0             	setne  %al
c01056fe:	0f b6 c0             	movzbl %al,%eax
c0105701:	85 c0                	test   %eax,%eax
c0105703:	74 0b                	je     c0105710 <default_check+0x3c6>
c0105705:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105708:	8b 40 08             	mov    0x8(%eax),%eax
c010570b:	83 f8 01             	cmp    $0x1,%eax
c010570e:	74 24                	je     c0105734 <default_check+0x3ea>
c0105710:	c7 44 24 0c f4 75 10 	movl   $0xc01075f4,0xc(%esp)
c0105717:	c0 
c0105718:	c7 44 24 08 3e 73 10 	movl   $0xc010733e,0x8(%esp)
c010571f:	c0 
c0105720:	c7 44 24 04 1c 01 00 	movl   $0x11c,0x4(%esp)
c0105727:	00 
c0105728:	c7 04 24 53 73 10 c0 	movl   $0xc0107353,(%esp)
c010572f:	e8 fd ac ff ff       	call   c0100431 <__panic>
    assert(PageProperty(p1) && p1->property == 3);
c0105734:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105737:	83 c0 04             	add    $0x4,%eax
c010573a:	c7 45 94 01 00 00 00 	movl   $0x1,-0x6c(%ebp)
c0105741:	89 45 90             	mov    %eax,-0x70(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0105744:	8b 45 90             	mov    -0x70(%ebp),%eax
c0105747:	8b 55 94             	mov    -0x6c(%ebp),%edx
c010574a:	0f a3 10             	bt     %edx,(%eax)
c010574d:	19 c0                	sbb    %eax,%eax
c010574f:	89 45 8c             	mov    %eax,-0x74(%ebp)
    return oldbit != 0;
c0105752:	83 7d 8c 00          	cmpl   $0x0,-0x74(%ebp)
c0105756:	0f 95 c0             	setne  %al
c0105759:	0f b6 c0             	movzbl %al,%eax
c010575c:	85 c0                	test   %eax,%eax
c010575e:	74 0b                	je     c010576b <default_check+0x421>
c0105760:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105763:	8b 40 08             	mov    0x8(%eax),%eax
c0105766:	83 f8 03             	cmp    $0x3,%eax
c0105769:	74 24                	je     c010578f <default_check+0x445>
c010576b:	c7 44 24 0c 1c 76 10 	movl   $0xc010761c,0xc(%esp)
c0105772:	c0 
c0105773:	c7 44 24 08 3e 73 10 	movl   $0xc010733e,0x8(%esp)
c010577a:	c0 
c010577b:	c7 44 24 04 1d 01 00 	movl   $0x11d,0x4(%esp)
c0105782:	00 
c0105783:	c7 04 24 53 73 10 c0 	movl   $0xc0107353,(%esp)
c010578a:	e8 a2 ac ff ff       	call   c0100431 <__panic>

    assert((p0 = alloc_page()) == p2 - 1);
c010578f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0105796:	e8 e1 d8 ff ff       	call   c010307c <alloc_pages>
c010579b:	89 45 e8             	mov    %eax,-0x18(%ebp)
c010579e:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01057a1:	83 e8 14             	sub    $0x14,%eax
c01057a4:	39 45 e8             	cmp    %eax,-0x18(%ebp)
c01057a7:	74 24                	je     c01057cd <default_check+0x483>
c01057a9:	c7 44 24 0c 42 76 10 	movl   $0xc0107642,0xc(%esp)
c01057b0:	c0 
c01057b1:	c7 44 24 08 3e 73 10 	movl   $0xc010733e,0x8(%esp)
c01057b8:	c0 
c01057b9:	c7 44 24 04 1f 01 00 	movl   $0x11f,0x4(%esp)
c01057c0:	00 
c01057c1:	c7 04 24 53 73 10 c0 	movl   $0xc0107353,(%esp)
c01057c8:	e8 64 ac ff ff       	call   c0100431 <__panic>
    free_page(p0);
c01057cd:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c01057d4:	00 
c01057d5:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01057d8:	89 04 24             	mov    %eax,(%esp)
c01057db:	e8 d8 d8 ff ff       	call   c01030b8 <free_pages>
    assert((p0 = alloc_pages(2)) == p2 + 1);
c01057e0:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
c01057e7:	e8 90 d8 ff ff       	call   c010307c <alloc_pages>
c01057ec:	89 45 e8             	mov    %eax,-0x18(%ebp)
c01057ef:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01057f2:	83 c0 14             	add    $0x14,%eax
c01057f5:	39 45 e8             	cmp    %eax,-0x18(%ebp)
c01057f8:	74 24                	je     c010581e <default_check+0x4d4>
c01057fa:	c7 44 24 0c 60 76 10 	movl   $0xc0107660,0xc(%esp)
c0105801:	c0 
c0105802:	c7 44 24 08 3e 73 10 	movl   $0xc010733e,0x8(%esp)
c0105809:	c0 
c010580a:	c7 44 24 04 21 01 00 	movl   $0x121,0x4(%esp)
c0105811:	00 
c0105812:	c7 04 24 53 73 10 c0 	movl   $0xc0107353,(%esp)
c0105819:	e8 13 ac ff ff       	call   c0100431 <__panic>

    free_pages(p0, 2);
c010581e:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
c0105825:	00 
c0105826:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105829:	89 04 24             	mov    %eax,(%esp)
c010582c:	e8 87 d8 ff ff       	call   c01030b8 <free_pages>
    free_page(p2);
c0105831:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0105838:	00 
c0105839:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010583c:	89 04 24             	mov    %eax,(%esp)
c010583f:	e8 74 d8 ff ff       	call   c01030b8 <free_pages>

    assert((p0 = alloc_pages(5)) != NULL);
c0105844:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
c010584b:	e8 2c d8 ff ff       	call   c010307c <alloc_pages>
c0105850:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0105853:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0105857:	75 24                	jne    c010587d <default_check+0x533>
c0105859:	c7 44 24 0c 80 76 10 	movl   $0xc0107680,0xc(%esp)
c0105860:	c0 
c0105861:	c7 44 24 08 3e 73 10 	movl   $0xc010733e,0x8(%esp)
c0105868:	c0 
c0105869:	c7 44 24 04 26 01 00 	movl   $0x126,0x4(%esp)
c0105870:	00 
c0105871:	c7 04 24 53 73 10 c0 	movl   $0xc0107353,(%esp)
c0105878:	e8 b4 ab ff ff       	call   c0100431 <__panic>
    assert(alloc_page() == NULL);
c010587d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0105884:	e8 f3 d7 ff ff       	call   c010307c <alloc_pages>
c0105889:	85 c0                	test   %eax,%eax
c010588b:	74 24                	je     c01058b1 <default_check+0x567>
c010588d:	c7 44 24 0c de 74 10 	movl   $0xc01074de,0xc(%esp)
c0105894:	c0 
c0105895:	c7 44 24 08 3e 73 10 	movl   $0xc010733e,0x8(%esp)
c010589c:	c0 
c010589d:	c7 44 24 04 27 01 00 	movl   $0x127,0x4(%esp)
c01058a4:	00 
c01058a5:	c7 04 24 53 73 10 c0 	movl   $0xc0107353,(%esp)
c01058ac:	e8 80 ab ff ff       	call   c0100431 <__panic>

    assert(nr_free == 0);
c01058b1:	a1 84 df 11 c0       	mov    0xc011df84,%eax
c01058b6:	85 c0                	test   %eax,%eax
c01058b8:	74 24                	je     c01058de <default_check+0x594>
c01058ba:	c7 44 24 0c 31 75 10 	movl   $0xc0107531,0xc(%esp)
c01058c1:	c0 
c01058c2:	c7 44 24 08 3e 73 10 	movl   $0xc010733e,0x8(%esp)
c01058c9:	c0 
c01058ca:	c7 44 24 04 29 01 00 	movl   $0x129,0x4(%esp)
c01058d1:	00 
c01058d2:	c7 04 24 53 73 10 c0 	movl   $0xc0107353,(%esp)
c01058d9:	e8 53 ab ff ff       	call   c0100431 <__panic>
    nr_free = nr_free_store;
c01058de:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01058e1:	a3 84 df 11 c0       	mov    %eax,0xc011df84

    free_list = free_list_store;
c01058e6:	8b 45 80             	mov    -0x80(%ebp),%eax
c01058e9:	8b 55 84             	mov    -0x7c(%ebp),%edx
c01058ec:	a3 7c df 11 c0       	mov    %eax,0xc011df7c
c01058f1:	89 15 80 df 11 c0    	mov    %edx,0xc011df80
    free_pages(p0, 5);
c01058f7:	c7 44 24 04 05 00 00 	movl   $0x5,0x4(%esp)
c01058fe:	00 
c01058ff:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105902:	89 04 24             	mov    %eax,(%esp)
c0105905:	e8 ae d7 ff ff       	call   c01030b8 <free_pages>

    le = &free_list;
c010590a:	c7 45 ec 7c df 11 c0 	movl   $0xc011df7c,-0x14(%ebp)
    while ((le = list_next(le)) != &free_list) {
c0105911:	eb 5a                	jmp    c010596d <default_check+0x623>
        assert(le->next->prev == le && le->prev->next == le);
c0105913:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105916:	8b 40 04             	mov    0x4(%eax),%eax
c0105919:	8b 00                	mov    (%eax),%eax
c010591b:	39 45 ec             	cmp    %eax,-0x14(%ebp)
c010591e:	75 0d                	jne    c010592d <default_check+0x5e3>
c0105920:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105923:	8b 00                	mov    (%eax),%eax
c0105925:	8b 40 04             	mov    0x4(%eax),%eax
c0105928:	39 45 ec             	cmp    %eax,-0x14(%ebp)
c010592b:	74 24                	je     c0105951 <default_check+0x607>
c010592d:	c7 44 24 0c a0 76 10 	movl   $0xc01076a0,0xc(%esp)
c0105934:	c0 
c0105935:	c7 44 24 08 3e 73 10 	movl   $0xc010733e,0x8(%esp)
c010593c:	c0 
c010593d:	c7 44 24 04 31 01 00 	movl   $0x131,0x4(%esp)
c0105944:	00 
c0105945:	c7 04 24 53 73 10 c0 	movl   $0xc0107353,(%esp)
c010594c:	e8 e0 aa ff ff       	call   c0100431 <__panic>
        struct Page *p = le2page(le, page_link);
c0105951:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105954:	83 e8 0c             	sub    $0xc,%eax
c0105957:	89 45 d8             	mov    %eax,-0x28(%ebp)
        count --, total -= p->property;
c010595a:	ff 4d f4             	decl   -0xc(%ebp)
c010595d:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0105960:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0105963:	8b 40 08             	mov    0x8(%eax),%eax
c0105966:	29 c2                	sub    %eax,%edx
c0105968:	89 d0                	mov    %edx,%eax
c010596a:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010596d:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105970:	89 45 88             	mov    %eax,-0x78(%ebp)
    return listelm->next;
c0105973:	8b 45 88             	mov    -0x78(%ebp),%eax
c0105976:	8b 40 04             	mov    0x4(%eax),%eax
    while ((le = list_next(le)) != &free_list) {
c0105979:	89 45 ec             	mov    %eax,-0x14(%ebp)
c010597c:	81 7d ec 7c df 11 c0 	cmpl   $0xc011df7c,-0x14(%ebp)
c0105983:	75 8e                	jne    c0105913 <default_check+0x5c9>
    }
    assert(count == 0);
c0105985:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0105989:	74 24                	je     c01059af <default_check+0x665>
c010598b:	c7 44 24 0c cd 76 10 	movl   $0xc01076cd,0xc(%esp)
c0105992:	c0 
c0105993:	c7 44 24 08 3e 73 10 	movl   $0xc010733e,0x8(%esp)
c010599a:	c0 
c010599b:	c7 44 24 04 35 01 00 	movl   $0x135,0x4(%esp)
c01059a2:	00 
c01059a3:	c7 04 24 53 73 10 c0 	movl   $0xc0107353,(%esp)
c01059aa:	e8 82 aa ff ff       	call   c0100431 <__panic>
    assert(total == 0);
c01059af:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c01059b3:	74 24                	je     c01059d9 <default_check+0x68f>
c01059b5:	c7 44 24 0c d8 76 10 	movl   $0xc01076d8,0xc(%esp)
c01059bc:	c0 
c01059bd:	c7 44 24 08 3e 73 10 	movl   $0xc010733e,0x8(%esp)
c01059c4:	c0 
c01059c5:	c7 44 24 04 36 01 00 	movl   $0x136,0x4(%esp)
c01059cc:	00 
c01059cd:	c7 04 24 53 73 10 c0 	movl   $0xc0107353,(%esp)
c01059d4:	e8 58 aa ff ff       	call   c0100431 <__panic>
}
c01059d9:	90                   	nop
c01059da:	c9                   	leave  
c01059db:	c3                   	ret    

c01059dc <strlen>:
 * @s:      the input string
 *
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
c01059dc:	f3 0f 1e fb          	endbr32 
c01059e0:	55                   	push   %ebp
c01059e1:	89 e5                	mov    %esp,%ebp
c01059e3:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
c01059e6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (*s ++ != '\0') {
c01059ed:	eb 03                	jmp    c01059f2 <strlen+0x16>
        cnt ++;
c01059ef:	ff 45 fc             	incl   -0x4(%ebp)
    while (*s ++ != '\0') {
c01059f2:	8b 45 08             	mov    0x8(%ebp),%eax
c01059f5:	8d 50 01             	lea    0x1(%eax),%edx
c01059f8:	89 55 08             	mov    %edx,0x8(%ebp)
c01059fb:	0f b6 00             	movzbl (%eax),%eax
c01059fe:	84 c0                	test   %al,%al
c0105a00:	75 ed                	jne    c01059ef <strlen+0x13>
    }
    return cnt;
c0105a02:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c0105a05:	c9                   	leave  
c0105a06:	c3                   	ret    

c0105a07 <strnlen>:
 * The return value is strlen(s), if that is less than @len, or
 * @len if there is no '\0' character among the first @len characters
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
c0105a07:	f3 0f 1e fb          	endbr32 
c0105a0b:	55                   	push   %ebp
c0105a0c:	89 e5                	mov    %esp,%ebp
c0105a0e:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
c0105a11:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (cnt < len && *s ++ != '\0') {
c0105a18:	eb 03                	jmp    c0105a1d <strnlen+0x16>
        cnt ++;
c0105a1a:	ff 45 fc             	incl   -0x4(%ebp)
    while (cnt < len && *s ++ != '\0') {
c0105a1d:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0105a20:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0105a23:	73 10                	jae    c0105a35 <strnlen+0x2e>
c0105a25:	8b 45 08             	mov    0x8(%ebp),%eax
c0105a28:	8d 50 01             	lea    0x1(%eax),%edx
c0105a2b:	89 55 08             	mov    %edx,0x8(%ebp)
c0105a2e:	0f b6 00             	movzbl (%eax),%eax
c0105a31:	84 c0                	test   %al,%al
c0105a33:	75 e5                	jne    c0105a1a <strnlen+0x13>
    }
    return cnt;
c0105a35:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c0105a38:	c9                   	leave  
c0105a39:	c3                   	ret    

c0105a3a <strcpy>:
 * To avoid overflows, the size of array pointed by @dst should be long enough to
 * contain the same string as @src (including the terminating null character), and
 * should not overlap in memory with @src.
 * */
char *
strcpy(char *dst, const char *src) {
c0105a3a:	f3 0f 1e fb          	endbr32 
c0105a3e:	55                   	push   %ebp
c0105a3f:	89 e5                	mov    %esp,%ebp
c0105a41:	57                   	push   %edi
c0105a42:	56                   	push   %esi
c0105a43:	83 ec 20             	sub    $0x20,%esp
c0105a46:	8b 45 08             	mov    0x8(%ebp),%eax
c0105a49:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0105a4c:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105a4f:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCPY
#define __HAVE_ARCH_STRCPY
static inline char *
__strcpy(char *dst, const char *src) {
    int d0, d1, d2;
    asm volatile (
c0105a52:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0105a55:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105a58:	89 d1                	mov    %edx,%ecx
c0105a5a:	89 c2                	mov    %eax,%edx
c0105a5c:	89 ce                	mov    %ecx,%esi
c0105a5e:	89 d7                	mov    %edx,%edi
c0105a60:	ac                   	lods   %ds:(%esi),%al
c0105a61:	aa                   	stos   %al,%es:(%edi)
c0105a62:	84 c0                	test   %al,%al
c0105a64:	75 fa                	jne    c0105a60 <strcpy+0x26>
c0105a66:	89 fa                	mov    %edi,%edx
c0105a68:	89 f1                	mov    %esi,%ecx
c0105a6a:	89 4d ec             	mov    %ecx,-0x14(%ebp)
c0105a6d:	89 55 e8             	mov    %edx,-0x18(%ebp)
c0105a70:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        "stosb;"
        "testb %%al, %%al;"
        "jne 1b;"
        : "=&S" (d0), "=&D" (d1), "=&a" (d2)
        : "0" (src), "1" (dst) : "memory");
    return dst;
c0105a73:	8b 45 f4             	mov    -0xc(%ebp),%eax
    char *p = dst;
    while ((*p ++ = *src ++) != '\0')
        /* nothing */;
    return dst;
#endif /* __HAVE_ARCH_STRCPY */
}
c0105a76:	83 c4 20             	add    $0x20,%esp
c0105a79:	5e                   	pop    %esi
c0105a7a:	5f                   	pop    %edi
c0105a7b:	5d                   	pop    %ebp
c0105a7c:	c3                   	ret    

c0105a7d <strncpy>:
 * @len:    maximum number of characters to be copied from @src
 *
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
c0105a7d:	f3 0f 1e fb          	endbr32 
c0105a81:	55                   	push   %ebp
c0105a82:	89 e5                	mov    %esp,%ebp
c0105a84:	83 ec 10             	sub    $0x10,%esp
    char *p = dst;
c0105a87:	8b 45 08             	mov    0x8(%ebp),%eax
c0105a8a:	89 45 fc             	mov    %eax,-0x4(%ebp)
    while (len > 0) {
c0105a8d:	eb 1e                	jmp    c0105aad <strncpy+0x30>
        if ((*p = *src) != '\0') {
c0105a8f:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105a92:	0f b6 10             	movzbl (%eax),%edx
c0105a95:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0105a98:	88 10                	mov    %dl,(%eax)
c0105a9a:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0105a9d:	0f b6 00             	movzbl (%eax),%eax
c0105aa0:	84 c0                	test   %al,%al
c0105aa2:	74 03                	je     c0105aa7 <strncpy+0x2a>
            src ++;
c0105aa4:	ff 45 0c             	incl   0xc(%ebp)
        }
        p ++, len --;
c0105aa7:	ff 45 fc             	incl   -0x4(%ebp)
c0105aaa:	ff 4d 10             	decl   0x10(%ebp)
    while (len > 0) {
c0105aad:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0105ab1:	75 dc                	jne    c0105a8f <strncpy+0x12>
    }
    return dst;
c0105ab3:	8b 45 08             	mov    0x8(%ebp),%eax
}
c0105ab6:	c9                   	leave  
c0105ab7:	c3                   	ret    

c0105ab8 <strcmp>:
 * - A value greater than zero indicates that the first character that does
 *   not match has a greater value in @s1 than in @s2;
 * - And a value less than zero indicates the opposite.
 * */
int
strcmp(const char *s1, const char *s2) {
c0105ab8:	f3 0f 1e fb          	endbr32 
c0105abc:	55                   	push   %ebp
c0105abd:	89 e5                	mov    %esp,%ebp
c0105abf:	57                   	push   %edi
c0105ac0:	56                   	push   %esi
c0105ac1:	83 ec 20             	sub    $0x20,%esp
c0105ac4:	8b 45 08             	mov    0x8(%ebp),%eax
c0105ac7:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0105aca:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105acd:	89 45 f0             	mov    %eax,-0x10(%ebp)
    asm volatile (
c0105ad0:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0105ad3:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105ad6:	89 d1                	mov    %edx,%ecx
c0105ad8:	89 c2                	mov    %eax,%edx
c0105ada:	89 ce                	mov    %ecx,%esi
c0105adc:	89 d7                	mov    %edx,%edi
c0105ade:	ac                   	lods   %ds:(%esi),%al
c0105adf:	ae                   	scas   %es:(%edi),%al
c0105ae0:	75 08                	jne    c0105aea <strcmp+0x32>
c0105ae2:	84 c0                	test   %al,%al
c0105ae4:	75 f8                	jne    c0105ade <strcmp+0x26>
c0105ae6:	31 c0                	xor    %eax,%eax
c0105ae8:	eb 04                	jmp    c0105aee <strcmp+0x36>
c0105aea:	19 c0                	sbb    %eax,%eax
c0105aec:	0c 01                	or     $0x1,%al
c0105aee:	89 fa                	mov    %edi,%edx
c0105af0:	89 f1                	mov    %esi,%ecx
c0105af2:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0105af5:	89 4d e8             	mov    %ecx,-0x18(%ebp)
c0105af8:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    return ret;
c0105afb:	8b 45 ec             	mov    -0x14(%ebp),%eax
    while (*s1 != '\0' && *s1 == *s2) {
        s1 ++, s2 ++;
    }
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
#endif /* __HAVE_ARCH_STRCMP */
}
c0105afe:	83 c4 20             	add    $0x20,%esp
c0105b01:	5e                   	pop    %esi
c0105b02:	5f                   	pop    %edi
c0105b03:	5d                   	pop    %ebp
c0105b04:	c3                   	ret    

c0105b05 <strncmp>:
 * they are equal to each other, it continues with the following pairs until
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
c0105b05:	f3 0f 1e fb          	endbr32 
c0105b09:	55                   	push   %ebp
c0105b0a:	89 e5                	mov    %esp,%ebp
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
c0105b0c:	eb 09                	jmp    c0105b17 <strncmp+0x12>
        n --, s1 ++, s2 ++;
c0105b0e:	ff 4d 10             	decl   0x10(%ebp)
c0105b11:	ff 45 08             	incl   0x8(%ebp)
c0105b14:	ff 45 0c             	incl   0xc(%ebp)
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
c0105b17:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0105b1b:	74 1a                	je     c0105b37 <strncmp+0x32>
c0105b1d:	8b 45 08             	mov    0x8(%ebp),%eax
c0105b20:	0f b6 00             	movzbl (%eax),%eax
c0105b23:	84 c0                	test   %al,%al
c0105b25:	74 10                	je     c0105b37 <strncmp+0x32>
c0105b27:	8b 45 08             	mov    0x8(%ebp),%eax
c0105b2a:	0f b6 10             	movzbl (%eax),%edx
c0105b2d:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105b30:	0f b6 00             	movzbl (%eax),%eax
c0105b33:	38 c2                	cmp    %al,%dl
c0105b35:	74 d7                	je     c0105b0e <strncmp+0x9>
    }
    return (n == 0) ? 0 : (int)((unsigned char)*s1 - (unsigned char)*s2);
c0105b37:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0105b3b:	74 18                	je     c0105b55 <strncmp+0x50>
c0105b3d:	8b 45 08             	mov    0x8(%ebp),%eax
c0105b40:	0f b6 00             	movzbl (%eax),%eax
c0105b43:	0f b6 d0             	movzbl %al,%edx
c0105b46:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105b49:	0f b6 00             	movzbl (%eax),%eax
c0105b4c:	0f b6 c0             	movzbl %al,%eax
c0105b4f:	29 c2                	sub    %eax,%edx
c0105b51:	89 d0                	mov    %edx,%eax
c0105b53:	eb 05                	jmp    c0105b5a <strncmp+0x55>
c0105b55:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0105b5a:	5d                   	pop    %ebp
c0105b5b:	c3                   	ret    

c0105b5c <strchr>:
 *
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
c0105b5c:	f3 0f 1e fb          	endbr32 
c0105b60:	55                   	push   %ebp
c0105b61:	89 e5                	mov    %esp,%ebp
c0105b63:	83 ec 04             	sub    $0x4,%esp
c0105b66:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105b69:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
c0105b6c:	eb 13                	jmp    c0105b81 <strchr+0x25>
        if (*s == c) {
c0105b6e:	8b 45 08             	mov    0x8(%ebp),%eax
c0105b71:	0f b6 00             	movzbl (%eax),%eax
c0105b74:	38 45 fc             	cmp    %al,-0x4(%ebp)
c0105b77:	75 05                	jne    c0105b7e <strchr+0x22>
            return (char *)s;
c0105b79:	8b 45 08             	mov    0x8(%ebp),%eax
c0105b7c:	eb 12                	jmp    c0105b90 <strchr+0x34>
        }
        s ++;
c0105b7e:	ff 45 08             	incl   0x8(%ebp)
    while (*s != '\0') {
c0105b81:	8b 45 08             	mov    0x8(%ebp),%eax
c0105b84:	0f b6 00             	movzbl (%eax),%eax
c0105b87:	84 c0                	test   %al,%al
c0105b89:	75 e3                	jne    c0105b6e <strchr+0x12>
    }
    return NULL;
c0105b8b:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0105b90:	c9                   	leave  
c0105b91:	c3                   	ret    

c0105b92 <strfind>:
 * The strfind() function is like strchr() except that if @c is
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
c0105b92:	f3 0f 1e fb          	endbr32 
c0105b96:	55                   	push   %ebp
c0105b97:	89 e5                	mov    %esp,%ebp
c0105b99:	83 ec 04             	sub    $0x4,%esp
c0105b9c:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105b9f:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
c0105ba2:	eb 0e                	jmp    c0105bb2 <strfind+0x20>
        if (*s == c) {
c0105ba4:	8b 45 08             	mov    0x8(%ebp),%eax
c0105ba7:	0f b6 00             	movzbl (%eax),%eax
c0105baa:	38 45 fc             	cmp    %al,-0x4(%ebp)
c0105bad:	74 0f                	je     c0105bbe <strfind+0x2c>
            break;
        }
        s ++;
c0105baf:	ff 45 08             	incl   0x8(%ebp)
    while (*s != '\0') {
c0105bb2:	8b 45 08             	mov    0x8(%ebp),%eax
c0105bb5:	0f b6 00             	movzbl (%eax),%eax
c0105bb8:	84 c0                	test   %al,%al
c0105bba:	75 e8                	jne    c0105ba4 <strfind+0x12>
c0105bbc:	eb 01                	jmp    c0105bbf <strfind+0x2d>
            break;
c0105bbe:	90                   	nop
    }
    return (char *)s;
c0105bbf:	8b 45 08             	mov    0x8(%ebp),%eax
}
c0105bc2:	c9                   	leave  
c0105bc3:	c3                   	ret    

c0105bc4 <strtol>:
 * an optional "0x" or "0X" prefix.
 *
 * The strtol() function returns the converted integral number as a long int value.
 * */
long
strtol(const char *s, char **endptr, int base) {
c0105bc4:	f3 0f 1e fb          	endbr32 
c0105bc8:	55                   	push   %ebp
c0105bc9:	89 e5                	mov    %esp,%ebp
c0105bcb:	83 ec 10             	sub    $0x10,%esp
    int neg = 0;
c0105bce:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    long val = 0;
c0105bd5:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
c0105bdc:	eb 03                	jmp    c0105be1 <strtol+0x1d>
        s ++;
c0105bde:	ff 45 08             	incl   0x8(%ebp)
    while (*s == ' ' || *s == '\t') {
c0105be1:	8b 45 08             	mov    0x8(%ebp),%eax
c0105be4:	0f b6 00             	movzbl (%eax),%eax
c0105be7:	3c 20                	cmp    $0x20,%al
c0105be9:	74 f3                	je     c0105bde <strtol+0x1a>
c0105beb:	8b 45 08             	mov    0x8(%ebp),%eax
c0105bee:	0f b6 00             	movzbl (%eax),%eax
c0105bf1:	3c 09                	cmp    $0x9,%al
c0105bf3:	74 e9                	je     c0105bde <strtol+0x1a>
    }

    // plus/minus sign
    if (*s == '+') {
c0105bf5:	8b 45 08             	mov    0x8(%ebp),%eax
c0105bf8:	0f b6 00             	movzbl (%eax),%eax
c0105bfb:	3c 2b                	cmp    $0x2b,%al
c0105bfd:	75 05                	jne    c0105c04 <strtol+0x40>
        s ++;
c0105bff:	ff 45 08             	incl   0x8(%ebp)
c0105c02:	eb 14                	jmp    c0105c18 <strtol+0x54>
    }
    else if (*s == '-') {
c0105c04:	8b 45 08             	mov    0x8(%ebp),%eax
c0105c07:	0f b6 00             	movzbl (%eax),%eax
c0105c0a:	3c 2d                	cmp    $0x2d,%al
c0105c0c:	75 0a                	jne    c0105c18 <strtol+0x54>
        s ++, neg = 1;
c0105c0e:	ff 45 08             	incl   0x8(%ebp)
c0105c11:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
    }

    // hex or octal base prefix
    if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x')) {
c0105c18:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0105c1c:	74 06                	je     c0105c24 <strtol+0x60>
c0105c1e:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
c0105c22:	75 22                	jne    c0105c46 <strtol+0x82>
c0105c24:	8b 45 08             	mov    0x8(%ebp),%eax
c0105c27:	0f b6 00             	movzbl (%eax),%eax
c0105c2a:	3c 30                	cmp    $0x30,%al
c0105c2c:	75 18                	jne    c0105c46 <strtol+0x82>
c0105c2e:	8b 45 08             	mov    0x8(%ebp),%eax
c0105c31:	40                   	inc    %eax
c0105c32:	0f b6 00             	movzbl (%eax),%eax
c0105c35:	3c 78                	cmp    $0x78,%al
c0105c37:	75 0d                	jne    c0105c46 <strtol+0x82>
        s += 2, base = 16;
c0105c39:	83 45 08 02          	addl   $0x2,0x8(%ebp)
c0105c3d:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
c0105c44:	eb 29                	jmp    c0105c6f <strtol+0xab>
    }
    else if (base == 0 && s[0] == '0') {
c0105c46:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0105c4a:	75 16                	jne    c0105c62 <strtol+0x9e>
c0105c4c:	8b 45 08             	mov    0x8(%ebp),%eax
c0105c4f:	0f b6 00             	movzbl (%eax),%eax
c0105c52:	3c 30                	cmp    $0x30,%al
c0105c54:	75 0c                	jne    c0105c62 <strtol+0x9e>
        s ++, base = 8;
c0105c56:	ff 45 08             	incl   0x8(%ebp)
c0105c59:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
c0105c60:	eb 0d                	jmp    c0105c6f <strtol+0xab>
    }
    else if (base == 0) {
c0105c62:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0105c66:	75 07                	jne    c0105c6f <strtol+0xab>
        base = 10;
c0105c68:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

    // digits
    while (1) {
        int dig;

        if (*s >= '0' && *s <= '9') {
c0105c6f:	8b 45 08             	mov    0x8(%ebp),%eax
c0105c72:	0f b6 00             	movzbl (%eax),%eax
c0105c75:	3c 2f                	cmp    $0x2f,%al
c0105c77:	7e 1b                	jle    c0105c94 <strtol+0xd0>
c0105c79:	8b 45 08             	mov    0x8(%ebp),%eax
c0105c7c:	0f b6 00             	movzbl (%eax),%eax
c0105c7f:	3c 39                	cmp    $0x39,%al
c0105c81:	7f 11                	jg     c0105c94 <strtol+0xd0>
            dig = *s - '0';
c0105c83:	8b 45 08             	mov    0x8(%ebp),%eax
c0105c86:	0f b6 00             	movzbl (%eax),%eax
c0105c89:	0f be c0             	movsbl %al,%eax
c0105c8c:	83 e8 30             	sub    $0x30,%eax
c0105c8f:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0105c92:	eb 48                	jmp    c0105cdc <strtol+0x118>
        }
        else if (*s >= 'a' && *s <= 'z') {
c0105c94:	8b 45 08             	mov    0x8(%ebp),%eax
c0105c97:	0f b6 00             	movzbl (%eax),%eax
c0105c9a:	3c 60                	cmp    $0x60,%al
c0105c9c:	7e 1b                	jle    c0105cb9 <strtol+0xf5>
c0105c9e:	8b 45 08             	mov    0x8(%ebp),%eax
c0105ca1:	0f b6 00             	movzbl (%eax),%eax
c0105ca4:	3c 7a                	cmp    $0x7a,%al
c0105ca6:	7f 11                	jg     c0105cb9 <strtol+0xf5>
            dig = *s - 'a' + 10;
c0105ca8:	8b 45 08             	mov    0x8(%ebp),%eax
c0105cab:	0f b6 00             	movzbl (%eax),%eax
c0105cae:	0f be c0             	movsbl %al,%eax
c0105cb1:	83 e8 57             	sub    $0x57,%eax
c0105cb4:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0105cb7:	eb 23                	jmp    c0105cdc <strtol+0x118>
        }
        else if (*s >= 'A' && *s <= 'Z') {
c0105cb9:	8b 45 08             	mov    0x8(%ebp),%eax
c0105cbc:	0f b6 00             	movzbl (%eax),%eax
c0105cbf:	3c 40                	cmp    $0x40,%al
c0105cc1:	7e 3b                	jle    c0105cfe <strtol+0x13a>
c0105cc3:	8b 45 08             	mov    0x8(%ebp),%eax
c0105cc6:	0f b6 00             	movzbl (%eax),%eax
c0105cc9:	3c 5a                	cmp    $0x5a,%al
c0105ccb:	7f 31                	jg     c0105cfe <strtol+0x13a>
            dig = *s - 'A' + 10;
c0105ccd:	8b 45 08             	mov    0x8(%ebp),%eax
c0105cd0:	0f b6 00             	movzbl (%eax),%eax
c0105cd3:	0f be c0             	movsbl %al,%eax
c0105cd6:	83 e8 37             	sub    $0x37,%eax
c0105cd9:	89 45 f4             	mov    %eax,-0xc(%ebp)
        }
        else {
            break;
        }
        if (dig >= base) {
c0105cdc:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105cdf:	3b 45 10             	cmp    0x10(%ebp),%eax
c0105ce2:	7d 19                	jge    c0105cfd <strtol+0x139>
            break;
        }
        s ++, val = (val * base) + dig;
c0105ce4:	ff 45 08             	incl   0x8(%ebp)
c0105ce7:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0105cea:	0f af 45 10          	imul   0x10(%ebp),%eax
c0105cee:	89 c2                	mov    %eax,%edx
c0105cf0:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105cf3:	01 d0                	add    %edx,%eax
c0105cf5:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while (1) {
c0105cf8:	e9 72 ff ff ff       	jmp    c0105c6f <strtol+0xab>
            break;
c0105cfd:	90                   	nop
        // we don't properly detect overflow!
    }

    if (endptr) {
c0105cfe:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0105d02:	74 08                	je     c0105d0c <strtol+0x148>
        *endptr = (char *) s;
c0105d04:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105d07:	8b 55 08             	mov    0x8(%ebp),%edx
c0105d0a:	89 10                	mov    %edx,(%eax)
    }
    return (neg ? -val : val);
c0105d0c:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
c0105d10:	74 07                	je     c0105d19 <strtol+0x155>
c0105d12:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0105d15:	f7 d8                	neg    %eax
c0105d17:	eb 03                	jmp    c0105d1c <strtol+0x158>
c0105d19:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
c0105d1c:	c9                   	leave  
c0105d1d:	c3                   	ret    

c0105d1e <memset>:
 * @n:      number of bytes to be set to the value
 *
 * The memset() function returns @s.
 * */
void *
memset(void *s, char c, size_t n) {
c0105d1e:	f3 0f 1e fb          	endbr32 
c0105d22:	55                   	push   %ebp
c0105d23:	89 e5                	mov    %esp,%ebp
c0105d25:	57                   	push   %edi
c0105d26:	83 ec 24             	sub    $0x24,%esp
c0105d29:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105d2c:	88 45 d8             	mov    %al,-0x28(%ebp)
#ifdef __HAVE_ARCH_MEMSET
    return __memset(s, c, n);
c0105d2f:	0f be 55 d8          	movsbl -0x28(%ebp),%edx
c0105d33:	8b 45 08             	mov    0x8(%ebp),%eax
c0105d36:	89 45 f8             	mov    %eax,-0x8(%ebp)
c0105d39:	88 55 f7             	mov    %dl,-0x9(%ebp)
c0105d3c:	8b 45 10             	mov    0x10(%ebp),%eax
c0105d3f:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_MEMSET
#define __HAVE_ARCH_MEMSET
static inline void *
__memset(void *s, char c, size_t n) {
    int d0, d1;
    asm volatile (
c0105d42:	8b 4d f0             	mov    -0x10(%ebp),%ecx
c0105d45:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
c0105d49:	8b 55 f8             	mov    -0x8(%ebp),%edx
c0105d4c:	89 d7                	mov    %edx,%edi
c0105d4e:	f3 aa                	rep stos %al,%es:(%edi)
c0105d50:	89 fa                	mov    %edi,%edx
c0105d52:	89 4d ec             	mov    %ecx,-0x14(%ebp)
c0105d55:	89 55 e8             	mov    %edx,-0x18(%ebp)
        "rep; stosb;"
        : "=&c" (d0), "=&D" (d1)
        : "0" (n), "a" (c), "1" (s)
        : "memory");
    return s;
c0105d58:	8b 45 f8             	mov    -0x8(%ebp),%eax
    while (n -- > 0) {
        *p ++ = c;
    }
    return s;
#endif /* __HAVE_ARCH_MEMSET */
}
c0105d5b:	83 c4 24             	add    $0x24,%esp
c0105d5e:	5f                   	pop    %edi
c0105d5f:	5d                   	pop    %ebp
c0105d60:	c3                   	ret    

c0105d61 <memmove>:
 * @n:      number of bytes to copy
 *
 * The memmove() function returns @dst.
 * */
void *
memmove(void *dst, const void *src, size_t n) {
c0105d61:	f3 0f 1e fb          	endbr32 
c0105d65:	55                   	push   %ebp
c0105d66:	89 e5                	mov    %esp,%ebp
c0105d68:	57                   	push   %edi
c0105d69:	56                   	push   %esi
c0105d6a:	53                   	push   %ebx
c0105d6b:	83 ec 30             	sub    $0x30,%esp
c0105d6e:	8b 45 08             	mov    0x8(%ebp),%eax
c0105d71:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105d74:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105d77:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0105d7a:	8b 45 10             	mov    0x10(%ebp),%eax
c0105d7d:	89 45 e8             	mov    %eax,-0x18(%ebp)

#ifndef __HAVE_ARCH_MEMMOVE
#define __HAVE_ARCH_MEMMOVE
static inline void *
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
c0105d80:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105d83:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c0105d86:	73 42                	jae    c0105dca <memmove+0x69>
c0105d88:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105d8b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0105d8e:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105d91:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0105d94:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105d97:	89 45 dc             	mov    %eax,-0x24(%ebp)
        "andl $3, %%ecx;"
        "jz 1f;"
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
c0105d9a:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0105d9d:	c1 e8 02             	shr    $0x2,%eax
c0105da0:	89 c1                	mov    %eax,%ecx
    asm volatile (
c0105da2:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0105da5:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105da8:	89 d7                	mov    %edx,%edi
c0105daa:	89 c6                	mov    %eax,%esi
c0105dac:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
c0105dae:	8b 4d dc             	mov    -0x24(%ebp),%ecx
c0105db1:	83 e1 03             	and    $0x3,%ecx
c0105db4:	74 02                	je     c0105db8 <memmove+0x57>
c0105db6:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
c0105db8:	89 f0                	mov    %esi,%eax
c0105dba:	89 fa                	mov    %edi,%edx
c0105dbc:	89 4d d8             	mov    %ecx,-0x28(%ebp)
c0105dbf:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c0105dc2:	89 45 d0             	mov    %eax,-0x30(%ebp)
        : "memory");
    return dst;
c0105dc5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
        return __memcpy(dst, src, n);
c0105dc8:	eb 36                	jmp    c0105e00 <memmove+0x9f>
        : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
c0105dca:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105dcd:	8d 50 ff             	lea    -0x1(%eax),%edx
c0105dd0:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105dd3:	01 c2                	add    %eax,%edx
c0105dd5:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105dd8:	8d 48 ff             	lea    -0x1(%eax),%ecx
c0105ddb:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105dde:	8d 1c 01             	lea    (%ecx,%eax,1),%ebx
    asm volatile (
c0105de1:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105de4:	89 c1                	mov    %eax,%ecx
c0105de6:	89 d8                	mov    %ebx,%eax
c0105de8:	89 d6                	mov    %edx,%esi
c0105dea:	89 c7                	mov    %eax,%edi
c0105dec:	fd                   	std    
c0105ded:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
c0105def:	fc                   	cld    
c0105df0:	89 f8                	mov    %edi,%eax
c0105df2:	89 f2                	mov    %esi,%edx
c0105df4:	89 4d cc             	mov    %ecx,-0x34(%ebp)
c0105df7:	89 55 c8             	mov    %edx,-0x38(%ebp)
c0105dfa:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    return dst;
c0105dfd:	8b 45 f0             	mov    -0x10(%ebp),%eax
            *d ++ = *s ++;
        }
    }
    return dst;
#endif /* __HAVE_ARCH_MEMMOVE */
}
c0105e00:	83 c4 30             	add    $0x30,%esp
c0105e03:	5b                   	pop    %ebx
c0105e04:	5e                   	pop    %esi
c0105e05:	5f                   	pop    %edi
c0105e06:	5d                   	pop    %ebp
c0105e07:	c3                   	ret    

c0105e08 <memcpy>:
 * it always copies exactly @n bytes. To avoid overflows, the size of arrays pointed
 * by both @src and @dst, should be at least @n bytes, and should not overlap
 * (for overlapping memory area, memmove is a safer approach).
 * */
void *
memcpy(void *dst, const void *src, size_t n) {
c0105e08:	f3 0f 1e fb          	endbr32 
c0105e0c:	55                   	push   %ebp
c0105e0d:	89 e5                	mov    %esp,%ebp
c0105e0f:	57                   	push   %edi
c0105e10:	56                   	push   %esi
c0105e11:	83 ec 20             	sub    $0x20,%esp
c0105e14:	8b 45 08             	mov    0x8(%ebp),%eax
c0105e17:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0105e1a:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105e1d:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105e20:	8b 45 10             	mov    0x10(%ebp),%eax
c0105e23:	89 45 ec             	mov    %eax,-0x14(%ebp)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
c0105e26:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105e29:	c1 e8 02             	shr    $0x2,%eax
c0105e2c:	89 c1                	mov    %eax,%ecx
    asm volatile (
c0105e2e:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0105e31:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105e34:	89 d7                	mov    %edx,%edi
c0105e36:	89 c6                	mov    %eax,%esi
c0105e38:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
c0105e3a:	8b 4d ec             	mov    -0x14(%ebp),%ecx
c0105e3d:	83 e1 03             	and    $0x3,%ecx
c0105e40:	74 02                	je     c0105e44 <memcpy+0x3c>
c0105e42:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
c0105e44:	89 f0                	mov    %esi,%eax
c0105e46:	89 fa                	mov    %edi,%edx
c0105e48:	89 4d e8             	mov    %ecx,-0x18(%ebp)
c0105e4b:	89 55 e4             	mov    %edx,-0x1c(%ebp)
c0105e4e:	89 45 e0             	mov    %eax,-0x20(%ebp)
    return dst;
c0105e51:	8b 45 f4             	mov    -0xc(%ebp),%eax
    while (n -- > 0) {
        *d ++ = *s ++;
    }
    return dst;
#endif /* __HAVE_ARCH_MEMCPY */
}
c0105e54:	83 c4 20             	add    $0x20,%esp
c0105e57:	5e                   	pop    %esi
c0105e58:	5f                   	pop    %edi
c0105e59:	5d                   	pop    %ebp
c0105e5a:	c3                   	ret    

c0105e5b <memcmp>:
 *   match in both memory blocks has a greater value in @v1 than in @v2
 *   as if evaluated as unsigned char values;
 * - And a value less than zero indicates the opposite.
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
c0105e5b:	f3 0f 1e fb          	endbr32 
c0105e5f:	55                   	push   %ebp
c0105e60:	89 e5                	mov    %esp,%ebp
c0105e62:	83 ec 10             	sub    $0x10,%esp
    const char *s1 = (const char *)v1;
c0105e65:	8b 45 08             	mov    0x8(%ebp),%eax
c0105e68:	89 45 fc             	mov    %eax,-0x4(%ebp)
    const char *s2 = (const char *)v2;
c0105e6b:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105e6e:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while (n -- > 0) {
c0105e71:	eb 2e                	jmp    c0105ea1 <memcmp+0x46>
        if (*s1 != *s2) {
c0105e73:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0105e76:	0f b6 10             	movzbl (%eax),%edx
c0105e79:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0105e7c:	0f b6 00             	movzbl (%eax),%eax
c0105e7f:	38 c2                	cmp    %al,%dl
c0105e81:	74 18                	je     c0105e9b <memcmp+0x40>
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
c0105e83:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0105e86:	0f b6 00             	movzbl (%eax),%eax
c0105e89:	0f b6 d0             	movzbl %al,%edx
c0105e8c:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0105e8f:	0f b6 00             	movzbl (%eax),%eax
c0105e92:	0f b6 c0             	movzbl %al,%eax
c0105e95:	29 c2                	sub    %eax,%edx
c0105e97:	89 d0                	mov    %edx,%eax
c0105e99:	eb 18                	jmp    c0105eb3 <memcmp+0x58>
        }
        s1 ++, s2 ++;
c0105e9b:	ff 45 fc             	incl   -0x4(%ebp)
c0105e9e:	ff 45 f8             	incl   -0x8(%ebp)
    while (n -- > 0) {
c0105ea1:	8b 45 10             	mov    0x10(%ebp),%eax
c0105ea4:	8d 50 ff             	lea    -0x1(%eax),%edx
c0105ea7:	89 55 10             	mov    %edx,0x10(%ebp)
c0105eaa:	85 c0                	test   %eax,%eax
c0105eac:	75 c5                	jne    c0105e73 <memcmp+0x18>
    }
    return 0;
c0105eae:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0105eb3:	c9                   	leave  
c0105eb4:	c3                   	ret    

c0105eb5 <printnum>:
 * @width:      maximum number of digits, if the actual width is less than @width, use @padc instead
 * @padc:       character that padded on the left if the actual width is less than @width
 * */
static void
printnum(void (*putch)(int, void*), void *putdat,
        unsigned long long num, unsigned base, int width, int padc) {
c0105eb5:	f3 0f 1e fb          	endbr32 
c0105eb9:	55                   	push   %ebp
c0105eba:	89 e5                	mov    %esp,%ebp
c0105ebc:	83 ec 58             	sub    $0x58,%esp
c0105ebf:	8b 45 10             	mov    0x10(%ebp),%eax
c0105ec2:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0105ec5:	8b 45 14             	mov    0x14(%ebp),%eax
c0105ec8:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    unsigned long long result = num;
c0105ecb:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0105ece:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0105ed1:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0105ed4:	89 55 ec             	mov    %edx,-0x14(%ebp)
    unsigned mod = do_div(result, base);
c0105ed7:	8b 45 18             	mov    0x18(%ebp),%eax
c0105eda:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0105edd:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105ee0:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0105ee3:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0105ee6:	89 55 f0             	mov    %edx,-0x10(%ebp)
c0105ee9:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105eec:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0105eef:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0105ef3:	74 1c                	je     c0105f11 <printnum+0x5c>
c0105ef5:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105ef8:	ba 00 00 00 00       	mov    $0x0,%edx
c0105efd:	f7 75 e4             	divl   -0x1c(%ebp)
c0105f00:	89 55 f4             	mov    %edx,-0xc(%ebp)
c0105f03:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105f06:	ba 00 00 00 00       	mov    $0x0,%edx
c0105f0b:	f7 75 e4             	divl   -0x1c(%ebp)
c0105f0e:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105f11:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105f14:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0105f17:	f7 75 e4             	divl   -0x1c(%ebp)
c0105f1a:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0105f1d:	89 55 dc             	mov    %edx,-0x24(%ebp)
c0105f20:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105f23:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0105f26:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0105f29:	89 55 ec             	mov    %edx,-0x14(%ebp)
c0105f2c:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0105f2f:	89 45 d8             	mov    %eax,-0x28(%ebp)

    // first recursively print all preceding (more significant) digits
    if (num >= base) {
c0105f32:	8b 45 18             	mov    0x18(%ebp),%eax
c0105f35:	ba 00 00 00 00       	mov    $0x0,%edx
c0105f3a:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
c0105f3d:	39 45 d0             	cmp    %eax,-0x30(%ebp)
c0105f40:	19 d1                	sbb    %edx,%ecx
c0105f42:	72 4c                	jb     c0105f90 <printnum+0xdb>
        printnum(putch, putdat, result, base, width - 1, padc);
c0105f44:	8b 45 1c             	mov    0x1c(%ebp),%eax
c0105f47:	8d 50 ff             	lea    -0x1(%eax),%edx
c0105f4a:	8b 45 20             	mov    0x20(%ebp),%eax
c0105f4d:	89 44 24 18          	mov    %eax,0x18(%esp)
c0105f51:	89 54 24 14          	mov    %edx,0x14(%esp)
c0105f55:	8b 45 18             	mov    0x18(%ebp),%eax
c0105f58:	89 44 24 10          	mov    %eax,0x10(%esp)
c0105f5c:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105f5f:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0105f62:	89 44 24 08          	mov    %eax,0x8(%esp)
c0105f66:	89 54 24 0c          	mov    %edx,0xc(%esp)
c0105f6a:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105f6d:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105f71:	8b 45 08             	mov    0x8(%ebp),%eax
c0105f74:	89 04 24             	mov    %eax,(%esp)
c0105f77:	e8 39 ff ff ff       	call   c0105eb5 <printnum>
c0105f7c:	eb 1b                	jmp    c0105f99 <printnum+0xe4>
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
            putch(padc, putdat);
c0105f7e:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105f81:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105f85:	8b 45 20             	mov    0x20(%ebp),%eax
c0105f88:	89 04 24             	mov    %eax,(%esp)
c0105f8b:	8b 45 08             	mov    0x8(%ebp),%eax
c0105f8e:	ff d0                	call   *%eax
        while (-- width > 0)
c0105f90:	ff 4d 1c             	decl   0x1c(%ebp)
c0105f93:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
c0105f97:	7f e5                	jg     c0105f7e <printnum+0xc9>
    }
    // then print this (the least significant) digit
    putch("0123456789abcdef"[mod], putdat);
c0105f99:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0105f9c:	05 94 77 10 c0       	add    $0xc0107794,%eax
c0105fa1:	0f b6 00             	movzbl (%eax),%eax
c0105fa4:	0f be c0             	movsbl %al,%eax
c0105fa7:	8b 55 0c             	mov    0xc(%ebp),%edx
c0105faa:	89 54 24 04          	mov    %edx,0x4(%esp)
c0105fae:	89 04 24             	mov    %eax,(%esp)
c0105fb1:	8b 45 08             	mov    0x8(%ebp),%eax
c0105fb4:	ff d0                	call   *%eax
}
c0105fb6:	90                   	nop
c0105fb7:	c9                   	leave  
c0105fb8:	c3                   	ret    

c0105fb9 <getuint>:
 * getuint - get an unsigned int of various possible sizes from a varargs list
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static unsigned long long
getuint(va_list *ap, int lflag) {
c0105fb9:	f3 0f 1e fb          	endbr32 
c0105fbd:	55                   	push   %ebp
c0105fbe:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
c0105fc0:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
c0105fc4:	7e 14                	jle    c0105fda <getuint+0x21>
        return va_arg(*ap, unsigned long long);
c0105fc6:	8b 45 08             	mov    0x8(%ebp),%eax
c0105fc9:	8b 00                	mov    (%eax),%eax
c0105fcb:	8d 48 08             	lea    0x8(%eax),%ecx
c0105fce:	8b 55 08             	mov    0x8(%ebp),%edx
c0105fd1:	89 0a                	mov    %ecx,(%edx)
c0105fd3:	8b 50 04             	mov    0x4(%eax),%edx
c0105fd6:	8b 00                	mov    (%eax),%eax
c0105fd8:	eb 30                	jmp    c010600a <getuint+0x51>
    }
    else if (lflag) {
c0105fda:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0105fde:	74 16                	je     c0105ff6 <getuint+0x3d>
        return va_arg(*ap, unsigned long);
c0105fe0:	8b 45 08             	mov    0x8(%ebp),%eax
c0105fe3:	8b 00                	mov    (%eax),%eax
c0105fe5:	8d 48 04             	lea    0x4(%eax),%ecx
c0105fe8:	8b 55 08             	mov    0x8(%ebp),%edx
c0105feb:	89 0a                	mov    %ecx,(%edx)
c0105fed:	8b 00                	mov    (%eax),%eax
c0105fef:	ba 00 00 00 00       	mov    $0x0,%edx
c0105ff4:	eb 14                	jmp    c010600a <getuint+0x51>
    }
    else {
        return va_arg(*ap, unsigned int);
c0105ff6:	8b 45 08             	mov    0x8(%ebp),%eax
c0105ff9:	8b 00                	mov    (%eax),%eax
c0105ffb:	8d 48 04             	lea    0x4(%eax),%ecx
c0105ffe:	8b 55 08             	mov    0x8(%ebp),%edx
c0106001:	89 0a                	mov    %ecx,(%edx)
c0106003:	8b 00                	mov    (%eax),%eax
c0106005:	ba 00 00 00 00       	mov    $0x0,%edx
    }
}
c010600a:	5d                   	pop    %ebp
c010600b:	c3                   	ret    

c010600c <getint>:
 * getint - same as getuint but signed, we can't use getuint because of sign extension
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static long long
getint(va_list *ap, int lflag) {
c010600c:	f3 0f 1e fb          	endbr32 
c0106010:	55                   	push   %ebp
c0106011:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
c0106013:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
c0106017:	7e 14                	jle    c010602d <getint+0x21>
        return va_arg(*ap, long long);
c0106019:	8b 45 08             	mov    0x8(%ebp),%eax
c010601c:	8b 00                	mov    (%eax),%eax
c010601e:	8d 48 08             	lea    0x8(%eax),%ecx
c0106021:	8b 55 08             	mov    0x8(%ebp),%edx
c0106024:	89 0a                	mov    %ecx,(%edx)
c0106026:	8b 50 04             	mov    0x4(%eax),%edx
c0106029:	8b 00                	mov    (%eax),%eax
c010602b:	eb 28                	jmp    c0106055 <getint+0x49>
    }
    else if (lflag) {
c010602d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0106031:	74 12                	je     c0106045 <getint+0x39>
        return va_arg(*ap, long);
c0106033:	8b 45 08             	mov    0x8(%ebp),%eax
c0106036:	8b 00                	mov    (%eax),%eax
c0106038:	8d 48 04             	lea    0x4(%eax),%ecx
c010603b:	8b 55 08             	mov    0x8(%ebp),%edx
c010603e:	89 0a                	mov    %ecx,(%edx)
c0106040:	8b 00                	mov    (%eax),%eax
c0106042:	99                   	cltd   
c0106043:	eb 10                	jmp    c0106055 <getint+0x49>
    }
    else {
        return va_arg(*ap, int);
c0106045:	8b 45 08             	mov    0x8(%ebp),%eax
c0106048:	8b 00                	mov    (%eax),%eax
c010604a:	8d 48 04             	lea    0x4(%eax),%ecx
c010604d:	8b 55 08             	mov    0x8(%ebp),%edx
c0106050:	89 0a                	mov    %ecx,(%edx)
c0106052:	8b 00                	mov    (%eax),%eax
c0106054:	99                   	cltd   
    }
}
c0106055:	5d                   	pop    %ebp
c0106056:	c3                   	ret    

c0106057 <printfmt>:
 * @putch:      specified putch function, print a single character
 * @putdat:     used by @putch function
 * @fmt:        the format string to use
 * */
void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
c0106057:	f3 0f 1e fb          	endbr32 
c010605b:	55                   	push   %ebp
c010605c:	89 e5                	mov    %esp,%ebp
c010605e:	83 ec 28             	sub    $0x28,%esp
    va_list ap;

    va_start(ap, fmt);
c0106061:	8d 45 14             	lea    0x14(%ebp),%eax
c0106064:	89 45 f4             	mov    %eax,-0xc(%ebp)
    vprintfmt(putch, putdat, fmt, ap);
c0106067:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010606a:	89 44 24 0c          	mov    %eax,0xc(%esp)
c010606e:	8b 45 10             	mov    0x10(%ebp),%eax
c0106071:	89 44 24 08          	mov    %eax,0x8(%esp)
c0106075:	8b 45 0c             	mov    0xc(%ebp),%eax
c0106078:	89 44 24 04          	mov    %eax,0x4(%esp)
c010607c:	8b 45 08             	mov    0x8(%ebp),%eax
c010607f:	89 04 24             	mov    %eax,(%esp)
c0106082:	e8 03 00 00 00       	call   c010608a <vprintfmt>
    va_end(ap);
}
c0106087:	90                   	nop
c0106088:	c9                   	leave  
c0106089:	c3                   	ret    

c010608a <vprintfmt>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want printfmt() instead.
 * */
void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap) {
c010608a:	f3 0f 1e fb          	endbr32 
c010608e:	55                   	push   %ebp
c010608f:	89 e5                	mov    %esp,%ebp
c0106091:	56                   	push   %esi
c0106092:	53                   	push   %ebx
c0106093:	83 ec 40             	sub    $0x40,%esp
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
c0106096:	eb 17                	jmp    c01060af <vprintfmt+0x25>
            if (ch == '\0') {
c0106098:	85 db                	test   %ebx,%ebx
c010609a:	0f 84 c0 03 00 00    	je     c0106460 <vprintfmt+0x3d6>
                return;
            }
            putch(ch, putdat);
c01060a0:	8b 45 0c             	mov    0xc(%ebp),%eax
c01060a3:	89 44 24 04          	mov    %eax,0x4(%esp)
c01060a7:	89 1c 24             	mov    %ebx,(%esp)
c01060aa:	8b 45 08             	mov    0x8(%ebp),%eax
c01060ad:	ff d0                	call   *%eax
        while ((ch = *(unsigned char *)fmt ++) != '%') {
c01060af:	8b 45 10             	mov    0x10(%ebp),%eax
c01060b2:	8d 50 01             	lea    0x1(%eax),%edx
c01060b5:	89 55 10             	mov    %edx,0x10(%ebp)
c01060b8:	0f b6 00             	movzbl (%eax),%eax
c01060bb:	0f b6 d8             	movzbl %al,%ebx
c01060be:	83 fb 25             	cmp    $0x25,%ebx
c01060c1:	75 d5                	jne    c0106098 <vprintfmt+0xe>
        }

        // Process a %-escape sequence
        char padc = ' ';
c01060c3:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
        width = precision = -1;
c01060c7:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
c01060ce:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01060d1:	89 45 e8             	mov    %eax,-0x18(%ebp)
        lflag = altflag = 0;
c01060d4:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c01060db:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01060de:	89 45 e0             	mov    %eax,-0x20(%ebp)

    reswitch:
        switch (ch = *(unsigned char *)fmt ++) {
c01060e1:	8b 45 10             	mov    0x10(%ebp),%eax
c01060e4:	8d 50 01             	lea    0x1(%eax),%edx
c01060e7:	89 55 10             	mov    %edx,0x10(%ebp)
c01060ea:	0f b6 00             	movzbl (%eax),%eax
c01060ed:	0f b6 d8             	movzbl %al,%ebx
c01060f0:	8d 43 dd             	lea    -0x23(%ebx),%eax
c01060f3:	83 f8 55             	cmp    $0x55,%eax
c01060f6:	0f 87 38 03 00 00    	ja     c0106434 <vprintfmt+0x3aa>
c01060fc:	8b 04 85 b8 77 10 c0 	mov    -0x3fef8848(,%eax,4),%eax
c0106103:	3e ff e0             	notrack jmp *%eax

        // flag to pad on the right
        case '-':
            padc = '-';
c0106106:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
            goto reswitch;
c010610a:	eb d5                	jmp    c01060e1 <vprintfmt+0x57>

        // flag to pad with 0's instead of spaces
        case '0':
            padc = '0';
c010610c:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
            goto reswitch;
c0106110:	eb cf                	jmp    c01060e1 <vprintfmt+0x57>

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
c0106112:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
                precision = precision * 10 + ch - '0';
c0106119:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c010611c:	89 d0                	mov    %edx,%eax
c010611e:	c1 e0 02             	shl    $0x2,%eax
c0106121:	01 d0                	add    %edx,%eax
c0106123:	01 c0                	add    %eax,%eax
c0106125:	01 d8                	add    %ebx,%eax
c0106127:	83 e8 30             	sub    $0x30,%eax
c010612a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
                ch = *fmt;
c010612d:	8b 45 10             	mov    0x10(%ebp),%eax
c0106130:	0f b6 00             	movzbl (%eax),%eax
c0106133:	0f be d8             	movsbl %al,%ebx
                if (ch < '0' || ch > '9') {
c0106136:	83 fb 2f             	cmp    $0x2f,%ebx
c0106139:	7e 38                	jle    c0106173 <vprintfmt+0xe9>
c010613b:	83 fb 39             	cmp    $0x39,%ebx
c010613e:	7f 33                	jg     c0106173 <vprintfmt+0xe9>
            for (precision = 0; ; ++ fmt) {
c0106140:	ff 45 10             	incl   0x10(%ebp)
                precision = precision * 10 + ch - '0';
c0106143:	eb d4                	jmp    c0106119 <vprintfmt+0x8f>
                }
            }
            goto process_precision;

        case '*':
            precision = va_arg(ap, int);
c0106145:	8b 45 14             	mov    0x14(%ebp),%eax
c0106148:	8d 50 04             	lea    0x4(%eax),%edx
c010614b:	89 55 14             	mov    %edx,0x14(%ebp)
c010614e:	8b 00                	mov    (%eax),%eax
c0106150:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            goto process_precision;
c0106153:	eb 1f                	jmp    c0106174 <vprintfmt+0xea>

        case '.':
            if (width < 0)
c0106155:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0106159:	79 86                	jns    c01060e1 <vprintfmt+0x57>
                width = 0;
c010615b:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
            goto reswitch;
c0106162:	e9 7a ff ff ff       	jmp    c01060e1 <vprintfmt+0x57>

        case '#':
            altflag = 1;
c0106167:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
            goto reswitch;
c010616e:	e9 6e ff ff ff       	jmp    c01060e1 <vprintfmt+0x57>
            goto process_precision;
c0106173:	90                   	nop

        process_precision:
            if (width < 0)
c0106174:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0106178:	0f 89 63 ff ff ff    	jns    c01060e1 <vprintfmt+0x57>
                width = precision, precision = -1;
c010617e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0106181:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0106184:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
            goto reswitch;
c010618b:	e9 51 ff ff ff       	jmp    c01060e1 <vprintfmt+0x57>

        // long flag (doubled for long long)
        case 'l':
            lflag ++;
c0106190:	ff 45 e0             	incl   -0x20(%ebp)
            goto reswitch;
c0106193:	e9 49 ff ff ff       	jmp    c01060e1 <vprintfmt+0x57>

        // character
        case 'c':
            putch(va_arg(ap, int), putdat);
c0106198:	8b 45 14             	mov    0x14(%ebp),%eax
c010619b:	8d 50 04             	lea    0x4(%eax),%edx
c010619e:	89 55 14             	mov    %edx,0x14(%ebp)
c01061a1:	8b 00                	mov    (%eax),%eax
c01061a3:	8b 55 0c             	mov    0xc(%ebp),%edx
c01061a6:	89 54 24 04          	mov    %edx,0x4(%esp)
c01061aa:	89 04 24             	mov    %eax,(%esp)
c01061ad:	8b 45 08             	mov    0x8(%ebp),%eax
c01061b0:	ff d0                	call   *%eax
            break;
c01061b2:	e9 a4 02 00 00       	jmp    c010645b <vprintfmt+0x3d1>

        // error message
        case 'e':
            err = va_arg(ap, int);
c01061b7:	8b 45 14             	mov    0x14(%ebp),%eax
c01061ba:	8d 50 04             	lea    0x4(%eax),%edx
c01061bd:	89 55 14             	mov    %edx,0x14(%ebp)
c01061c0:	8b 18                	mov    (%eax),%ebx
            if (err < 0) {
c01061c2:	85 db                	test   %ebx,%ebx
c01061c4:	79 02                	jns    c01061c8 <vprintfmt+0x13e>
                err = -err;
c01061c6:	f7 db                	neg    %ebx
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
c01061c8:	83 fb 06             	cmp    $0x6,%ebx
c01061cb:	7f 0b                	jg     c01061d8 <vprintfmt+0x14e>
c01061cd:	8b 34 9d 78 77 10 c0 	mov    -0x3fef8888(,%ebx,4),%esi
c01061d4:	85 f6                	test   %esi,%esi
c01061d6:	75 23                	jne    c01061fb <vprintfmt+0x171>
                printfmt(putch, putdat, "error %d", err);
c01061d8:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
c01061dc:	c7 44 24 08 a5 77 10 	movl   $0xc01077a5,0x8(%esp)
c01061e3:	c0 
c01061e4:	8b 45 0c             	mov    0xc(%ebp),%eax
c01061e7:	89 44 24 04          	mov    %eax,0x4(%esp)
c01061eb:	8b 45 08             	mov    0x8(%ebp),%eax
c01061ee:	89 04 24             	mov    %eax,(%esp)
c01061f1:	e8 61 fe ff ff       	call   c0106057 <printfmt>
            }
            else {
                printfmt(putch, putdat, "%s", p);
            }
            break;
c01061f6:	e9 60 02 00 00       	jmp    c010645b <vprintfmt+0x3d1>
                printfmt(putch, putdat, "%s", p);
c01061fb:	89 74 24 0c          	mov    %esi,0xc(%esp)
c01061ff:	c7 44 24 08 ae 77 10 	movl   $0xc01077ae,0x8(%esp)
c0106206:	c0 
c0106207:	8b 45 0c             	mov    0xc(%ebp),%eax
c010620a:	89 44 24 04          	mov    %eax,0x4(%esp)
c010620e:	8b 45 08             	mov    0x8(%ebp),%eax
c0106211:	89 04 24             	mov    %eax,(%esp)
c0106214:	e8 3e fe ff ff       	call   c0106057 <printfmt>
            break;
c0106219:	e9 3d 02 00 00       	jmp    c010645b <vprintfmt+0x3d1>

        // string
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
c010621e:	8b 45 14             	mov    0x14(%ebp),%eax
c0106221:	8d 50 04             	lea    0x4(%eax),%edx
c0106224:	89 55 14             	mov    %edx,0x14(%ebp)
c0106227:	8b 30                	mov    (%eax),%esi
c0106229:	85 f6                	test   %esi,%esi
c010622b:	75 05                	jne    c0106232 <vprintfmt+0x1a8>
                p = "(null)";
c010622d:	be b1 77 10 c0       	mov    $0xc01077b1,%esi
            }
            if (width > 0 && padc != '-') {
c0106232:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0106236:	7e 76                	jle    c01062ae <vprintfmt+0x224>
c0106238:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
c010623c:	74 70                	je     c01062ae <vprintfmt+0x224>
                for (width -= strnlen(p, precision); width > 0; width --) {
c010623e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0106241:	89 44 24 04          	mov    %eax,0x4(%esp)
c0106245:	89 34 24             	mov    %esi,(%esp)
c0106248:	e8 ba f7 ff ff       	call   c0105a07 <strnlen>
c010624d:	8b 55 e8             	mov    -0x18(%ebp),%edx
c0106250:	29 c2                	sub    %eax,%edx
c0106252:	89 d0                	mov    %edx,%eax
c0106254:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0106257:	eb 16                	jmp    c010626f <vprintfmt+0x1e5>
                    putch(padc, putdat);
c0106259:	0f be 45 db          	movsbl -0x25(%ebp),%eax
c010625d:	8b 55 0c             	mov    0xc(%ebp),%edx
c0106260:	89 54 24 04          	mov    %edx,0x4(%esp)
c0106264:	89 04 24             	mov    %eax,(%esp)
c0106267:	8b 45 08             	mov    0x8(%ebp),%eax
c010626a:	ff d0                	call   *%eax
                for (width -= strnlen(p, precision); width > 0; width --) {
c010626c:	ff 4d e8             	decl   -0x18(%ebp)
c010626f:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0106273:	7f e4                	jg     c0106259 <vprintfmt+0x1cf>
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
c0106275:	eb 37                	jmp    c01062ae <vprintfmt+0x224>
                if (altflag && (ch < ' ' || ch > '~')) {
c0106277:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
c010627b:	74 1f                	je     c010629c <vprintfmt+0x212>
c010627d:	83 fb 1f             	cmp    $0x1f,%ebx
c0106280:	7e 05                	jle    c0106287 <vprintfmt+0x1fd>
c0106282:	83 fb 7e             	cmp    $0x7e,%ebx
c0106285:	7e 15                	jle    c010629c <vprintfmt+0x212>
                    putch('?', putdat);
c0106287:	8b 45 0c             	mov    0xc(%ebp),%eax
c010628a:	89 44 24 04          	mov    %eax,0x4(%esp)
c010628e:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
c0106295:	8b 45 08             	mov    0x8(%ebp),%eax
c0106298:	ff d0                	call   *%eax
c010629a:	eb 0f                	jmp    c01062ab <vprintfmt+0x221>
                }
                else {
                    putch(ch, putdat);
c010629c:	8b 45 0c             	mov    0xc(%ebp),%eax
c010629f:	89 44 24 04          	mov    %eax,0x4(%esp)
c01062a3:	89 1c 24             	mov    %ebx,(%esp)
c01062a6:	8b 45 08             	mov    0x8(%ebp),%eax
c01062a9:	ff d0                	call   *%eax
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
c01062ab:	ff 4d e8             	decl   -0x18(%ebp)
c01062ae:	89 f0                	mov    %esi,%eax
c01062b0:	8d 70 01             	lea    0x1(%eax),%esi
c01062b3:	0f b6 00             	movzbl (%eax),%eax
c01062b6:	0f be d8             	movsbl %al,%ebx
c01062b9:	85 db                	test   %ebx,%ebx
c01062bb:	74 27                	je     c01062e4 <vprintfmt+0x25a>
c01062bd:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c01062c1:	78 b4                	js     c0106277 <vprintfmt+0x1ed>
c01062c3:	ff 4d e4             	decl   -0x1c(%ebp)
c01062c6:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c01062ca:	79 ab                	jns    c0106277 <vprintfmt+0x1ed>
                }
            }
            for (; width > 0; width --) {
c01062cc:	eb 16                	jmp    c01062e4 <vprintfmt+0x25a>
                putch(' ', putdat);
c01062ce:	8b 45 0c             	mov    0xc(%ebp),%eax
c01062d1:	89 44 24 04          	mov    %eax,0x4(%esp)
c01062d5:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
c01062dc:	8b 45 08             	mov    0x8(%ebp),%eax
c01062df:	ff d0                	call   *%eax
            for (; width > 0; width --) {
c01062e1:	ff 4d e8             	decl   -0x18(%ebp)
c01062e4:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c01062e8:	7f e4                	jg     c01062ce <vprintfmt+0x244>
            }
            break;
c01062ea:	e9 6c 01 00 00       	jmp    c010645b <vprintfmt+0x3d1>

        // (signed) decimal
        case 'd':
            num = getint(&ap, lflag);
c01062ef:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01062f2:	89 44 24 04          	mov    %eax,0x4(%esp)
c01062f6:	8d 45 14             	lea    0x14(%ebp),%eax
c01062f9:	89 04 24             	mov    %eax,(%esp)
c01062fc:	e8 0b fd ff ff       	call   c010600c <getint>
c0106301:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0106304:	89 55 f4             	mov    %edx,-0xc(%ebp)
            if ((long long)num < 0) {
c0106307:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010630a:	8b 55 f4             	mov    -0xc(%ebp),%edx
c010630d:	85 d2                	test   %edx,%edx
c010630f:	79 26                	jns    c0106337 <vprintfmt+0x2ad>
                putch('-', putdat);
c0106311:	8b 45 0c             	mov    0xc(%ebp),%eax
c0106314:	89 44 24 04          	mov    %eax,0x4(%esp)
c0106318:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
c010631f:	8b 45 08             	mov    0x8(%ebp),%eax
c0106322:	ff d0                	call   *%eax
                num = -(long long)num;
c0106324:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0106327:	8b 55 f4             	mov    -0xc(%ebp),%edx
c010632a:	f7 d8                	neg    %eax
c010632c:	83 d2 00             	adc    $0x0,%edx
c010632f:	f7 da                	neg    %edx
c0106331:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0106334:	89 55 f4             	mov    %edx,-0xc(%ebp)
            }
            base = 10;
c0106337:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
c010633e:	e9 a8 00 00 00       	jmp    c01063eb <vprintfmt+0x361>

        // unsigned decimal
        case 'u':
            num = getuint(&ap, lflag);
c0106343:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0106346:	89 44 24 04          	mov    %eax,0x4(%esp)
c010634a:	8d 45 14             	lea    0x14(%ebp),%eax
c010634d:	89 04 24             	mov    %eax,(%esp)
c0106350:	e8 64 fc ff ff       	call   c0105fb9 <getuint>
c0106355:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0106358:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 10;
c010635b:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
c0106362:	e9 84 00 00 00       	jmp    c01063eb <vprintfmt+0x361>

        // (unsigned) octal
        case 'o':
            num = getuint(&ap, lflag);
c0106367:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010636a:	89 44 24 04          	mov    %eax,0x4(%esp)
c010636e:	8d 45 14             	lea    0x14(%ebp),%eax
c0106371:	89 04 24             	mov    %eax,(%esp)
c0106374:	e8 40 fc ff ff       	call   c0105fb9 <getuint>
c0106379:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010637c:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 8;
c010637f:	c7 45 ec 08 00 00 00 	movl   $0x8,-0x14(%ebp)
            goto number;
c0106386:	eb 63                	jmp    c01063eb <vprintfmt+0x361>

        // pointer
        case 'p':
            putch('0', putdat);
c0106388:	8b 45 0c             	mov    0xc(%ebp),%eax
c010638b:	89 44 24 04          	mov    %eax,0x4(%esp)
c010638f:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
c0106396:	8b 45 08             	mov    0x8(%ebp),%eax
c0106399:	ff d0                	call   *%eax
            putch('x', putdat);
c010639b:	8b 45 0c             	mov    0xc(%ebp),%eax
c010639e:	89 44 24 04          	mov    %eax,0x4(%esp)
c01063a2:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
c01063a9:	8b 45 08             	mov    0x8(%ebp),%eax
c01063ac:	ff d0                	call   *%eax
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
c01063ae:	8b 45 14             	mov    0x14(%ebp),%eax
c01063b1:	8d 50 04             	lea    0x4(%eax),%edx
c01063b4:	89 55 14             	mov    %edx,0x14(%ebp)
c01063b7:	8b 00                	mov    (%eax),%eax
c01063b9:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01063bc:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
            base = 16;
c01063c3:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
            goto number;
c01063ca:	eb 1f                	jmp    c01063eb <vprintfmt+0x361>

        // (unsigned) hexadecimal
        case 'x':
            num = getuint(&ap, lflag);
c01063cc:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01063cf:	89 44 24 04          	mov    %eax,0x4(%esp)
c01063d3:	8d 45 14             	lea    0x14(%ebp),%eax
c01063d6:	89 04 24             	mov    %eax,(%esp)
c01063d9:	e8 db fb ff ff       	call   c0105fb9 <getuint>
c01063de:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01063e1:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 16;
c01063e4:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
        number:
            printnum(putch, putdat, num, base, width, padc);
c01063eb:	0f be 55 db          	movsbl -0x25(%ebp),%edx
c01063ef:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01063f2:	89 54 24 18          	mov    %edx,0x18(%esp)
c01063f6:	8b 55 e8             	mov    -0x18(%ebp),%edx
c01063f9:	89 54 24 14          	mov    %edx,0x14(%esp)
c01063fd:	89 44 24 10          	mov    %eax,0x10(%esp)
c0106401:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0106404:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0106407:	89 44 24 08          	mov    %eax,0x8(%esp)
c010640b:	89 54 24 0c          	mov    %edx,0xc(%esp)
c010640f:	8b 45 0c             	mov    0xc(%ebp),%eax
c0106412:	89 44 24 04          	mov    %eax,0x4(%esp)
c0106416:	8b 45 08             	mov    0x8(%ebp),%eax
c0106419:	89 04 24             	mov    %eax,(%esp)
c010641c:	e8 94 fa ff ff       	call   c0105eb5 <printnum>
            break;
c0106421:	eb 38                	jmp    c010645b <vprintfmt+0x3d1>

        // escaped '%' character
        case '%':
            putch(ch, putdat);
c0106423:	8b 45 0c             	mov    0xc(%ebp),%eax
c0106426:	89 44 24 04          	mov    %eax,0x4(%esp)
c010642a:	89 1c 24             	mov    %ebx,(%esp)
c010642d:	8b 45 08             	mov    0x8(%ebp),%eax
c0106430:	ff d0                	call   *%eax
            break;
c0106432:	eb 27                	jmp    c010645b <vprintfmt+0x3d1>

        // unrecognized escape sequence - just print it literally
        default:
            putch('%', putdat);
c0106434:	8b 45 0c             	mov    0xc(%ebp),%eax
c0106437:	89 44 24 04          	mov    %eax,0x4(%esp)
c010643b:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
c0106442:	8b 45 08             	mov    0x8(%ebp),%eax
c0106445:	ff d0                	call   *%eax
            for (fmt --; fmt[-1] != '%'; fmt --)
c0106447:	ff 4d 10             	decl   0x10(%ebp)
c010644a:	eb 03                	jmp    c010644f <vprintfmt+0x3c5>
c010644c:	ff 4d 10             	decl   0x10(%ebp)
c010644f:	8b 45 10             	mov    0x10(%ebp),%eax
c0106452:	48                   	dec    %eax
c0106453:	0f b6 00             	movzbl (%eax),%eax
c0106456:	3c 25                	cmp    $0x25,%al
c0106458:	75 f2                	jne    c010644c <vprintfmt+0x3c2>
                /* do nothing */;
            break;
c010645a:	90                   	nop
    while (1) {
c010645b:	e9 36 fc ff ff       	jmp    c0106096 <vprintfmt+0xc>
                return;
c0106460:	90                   	nop
        }
    }
}
c0106461:	83 c4 40             	add    $0x40,%esp
c0106464:	5b                   	pop    %ebx
c0106465:	5e                   	pop    %esi
c0106466:	5d                   	pop    %ebp
c0106467:	c3                   	ret    

c0106468 <sprintputch>:
 * sprintputch - 'print' a single character in a buffer
 * @ch:         the character will be printed
 * @b:          the buffer to place the character @ch
 * */
static void
sprintputch(int ch, struct sprintbuf *b) {
c0106468:	f3 0f 1e fb          	endbr32 
c010646c:	55                   	push   %ebp
c010646d:	89 e5                	mov    %esp,%ebp
    b->cnt ++;
c010646f:	8b 45 0c             	mov    0xc(%ebp),%eax
c0106472:	8b 40 08             	mov    0x8(%eax),%eax
c0106475:	8d 50 01             	lea    0x1(%eax),%edx
c0106478:	8b 45 0c             	mov    0xc(%ebp),%eax
c010647b:	89 50 08             	mov    %edx,0x8(%eax)
    if (b->buf < b->ebuf) {
c010647e:	8b 45 0c             	mov    0xc(%ebp),%eax
c0106481:	8b 10                	mov    (%eax),%edx
c0106483:	8b 45 0c             	mov    0xc(%ebp),%eax
c0106486:	8b 40 04             	mov    0x4(%eax),%eax
c0106489:	39 c2                	cmp    %eax,%edx
c010648b:	73 12                	jae    c010649f <sprintputch+0x37>
        *b->buf ++ = ch;
c010648d:	8b 45 0c             	mov    0xc(%ebp),%eax
c0106490:	8b 00                	mov    (%eax),%eax
c0106492:	8d 48 01             	lea    0x1(%eax),%ecx
c0106495:	8b 55 0c             	mov    0xc(%ebp),%edx
c0106498:	89 0a                	mov    %ecx,(%edx)
c010649a:	8b 55 08             	mov    0x8(%ebp),%edx
c010649d:	88 10                	mov    %dl,(%eax)
    }
}
c010649f:	90                   	nop
c01064a0:	5d                   	pop    %ebp
c01064a1:	c3                   	ret    

c01064a2 <snprintf>:
 * @str:        the buffer to place the result into
 * @size:       the size of buffer, including the trailing null space
 * @fmt:        the format string to use
 * */
int
snprintf(char *str, size_t size, const char *fmt, ...) {
c01064a2:	f3 0f 1e fb          	endbr32 
c01064a6:	55                   	push   %ebp
c01064a7:	89 e5                	mov    %esp,%ebp
c01064a9:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
c01064ac:	8d 45 14             	lea    0x14(%ebp),%eax
c01064af:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vsnprintf(str, size, fmt, ap);
c01064b2:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01064b5:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01064b9:	8b 45 10             	mov    0x10(%ebp),%eax
c01064bc:	89 44 24 08          	mov    %eax,0x8(%esp)
c01064c0:	8b 45 0c             	mov    0xc(%ebp),%eax
c01064c3:	89 44 24 04          	mov    %eax,0x4(%esp)
c01064c7:	8b 45 08             	mov    0x8(%ebp),%eax
c01064ca:	89 04 24             	mov    %eax,(%esp)
c01064cd:	e8 08 00 00 00       	call   c01064da <vsnprintf>
c01064d2:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
c01064d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c01064d8:	c9                   	leave  
c01064d9:	c3                   	ret    

c01064da <vsnprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want snprintf() instead.
 * */
int
vsnprintf(char *str, size_t size, const char *fmt, va_list ap) {
c01064da:	f3 0f 1e fb          	endbr32 
c01064de:	55                   	push   %ebp
c01064df:	89 e5                	mov    %esp,%ebp
c01064e1:	83 ec 28             	sub    $0x28,%esp
    struct sprintbuf b = {str, str + size - 1, 0};
c01064e4:	8b 45 08             	mov    0x8(%ebp),%eax
c01064e7:	89 45 ec             	mov    %eax,-0x14(%ebp)
c01064ea:	8b 45 0c             	mov    0xc(%ebp),%eax
c01064ed:	8d 50 ff             	lea    -0x1(%eax),%edx
c01064f0:	8b 45 08             	mov    0x8(%ebp),%eax
c01064f3:	01 d0                	add    %edx,%eax
c01064f5:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01064f8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if (str == NULL || b.buf > b.ebuf) {
c01064ff:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0106503:	74 0a                	je     c010650f <vsnprintf+0x35>
c0106505:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0106508:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010650b:	39 c2                	cmp    %eax,%edx
c010650d:	76 07                	jbe    c0106516 <vsnprintf+0x3c>
        return -E_INVAL;
c010650f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
c0106514:	eb 2a                	jmp    c0106540 <vsnprintf+0x66>
    }
    // print the string to the buffer
    vprintfmt((void*)sprintputch, &b, fmt, ap);
c0106516:	8b 45 14             	mov    0x14(%ebp),%eax
c0106519:	89 44 24 0c          	mov    %eax,0xc(%esp)
c010651d:	8b 45 10             	mov    0x10(%ebp),%eax
c0106520:	89 44 24 08          	mov    %eax,0x8(%esp)
c0106524:	8d 45 ec             	lea    -0x14(%ebp),%eax
c0106527:	89 44 24 04          	mov    %eax,0x4(%esp)
c010652b:	c7 04 24 68 64 10 c0 	movl   $0xc0106468,(%esp)
c0106532:	e8 53 fb ff ff       	call   c010608a <vprintfmt>
    // null terminate the buffer
    *b.buf = '\0';
c0106537:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010653a:	c6 00 00             	movb   $0x0,(%eax)
    return b.cnt;
c010653d:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0106540:	c9                   	leave  
c0106541:	c3                   	ret    
