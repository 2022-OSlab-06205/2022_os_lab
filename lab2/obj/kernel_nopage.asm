
bin/kernel_nopage：     文件格式 elf32-i386


Disassembly of section .text:

00100000 <kern_entry>:

.text
.globl kern_entry
kern_entry:
    # load pa of boot pgdir
    movl $REALLOC(__boot_pgdir), %eax
  100000:	b8 00 e0 11 40       	mov    $0x4011e000,%eax
    movl %eax, %cr3
  100005:	0f 22 d8             	mov    %eax,%cr3

    # enable paging
    movl %cr0, %eax
  100008:	0f 20 c0             	mov    %cr0,%eax
    orl $(CR0_PE | CR0_PG | CR0_AM | CR0_WP | CR0_NE | CR0_TS | CR0_EM | CR0_MP), %eax
  10000b:	0d 2f 00 05 80       	or     $0x8005002f,%eax
    andl $~(CR0_TS | CR0_EM), %eax
  100010:	83 e0 f3             	and    $0xfffffff3,%eax
    # 将cr0修改完成后的值，重新送至cr0中(此时第0位PE位已经为1，页机制已经开启，当前页表地址为刚刚构造的__boot_pgdir)
    movl %eax, %cr0
  100013:	0f 22 c0             	mov    %eax,%cr0

    # update eip
    # now, eip = 0x1.....
    leal next, %eax
  100016:	8d 05 1e 00 10 00    	lea    0x10001e,%eax
    # set eip = KERNBASE + 0x1.....
    jmp *%eax
  10001c:	ff e0                	jmp    *%eax

0010001e <next>:
next:

    # unmap va 0 ~ 4M, it's temporary mapping
    xorl %eax, %eax
  10001e:	31 c0                	xor    %eax,%eax
    movl %eax, __boot_pgdir
  100020:	a3 00 e0 11 00       	mov    %eax,0x11e000

    # 设置C的内核栈
    # set ebp, esp
    movl $0x0, %ebp
  100025:	bd 00 00 00 00       	mov    $0x0,%ebp
    # the kernel stack region is from bootstack -- bootstacktop,
    # the kernel stack size is KSTACKSIZE (8KB)defined in memlayout.h
    movl $bootstacktop, %esp
  10002a:	bc 00 d0 11 00       	mov    $0x11d000,%esp
    # now kernel stack is ready , call the first C function
    call kern_init
  10002f:	e8 02 00 00 00       	call   100036 <kern_init>

00100034 <spin>:

# should never get here
spin:
    jmp spin
  100034:	eb fe                	jmp    100034 <spin>

00100036 <kern_init>:
int kern_init(void) __attribute__((noreturn));
void grade_backtrace(void);
static void lab1_switch_test(void);

int
kern_init(void) {
  100036:	f3 0f 1e fb          	endbr32 
  10003a:	55                   	push   %ebp
  10003b:	89 e5                	mov    %esp,%ebp
  10003d:	83 ec 28             	sub    $0x28,%esp
    extern char edata[], end[];
    memset(edata, 0, end - edata);
  100040:	b8 84 10 32 00       	mov    $0x321084,%eax
  100045:	2d 36 da 11 00       	sub    $0x11da36,%eax
  10004a:	89 44 24 08          	mov    %eax,0x8(%esp)
  10004e:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  100055:	00 
  100056:	c7 04 24 36 da 11 00 	movl   $0x11da36,(%esp)
  10005d:	e8 80 6f 00 00       	call   106fe2 <memset>

    cons_init();                // init the console
  100062:	e8 4f 16 00 00       	call   1016b6 <cons_init>

    const char *message = "(THU.CST) os is loading ...";
  100067:	c7 45 f4 20 78 10 00 	movl   $0x107820,-0xc(%ebp)
    cprintf("%s\n\n", message);
  10006e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100071:	89 44 24 04          	mov    %eax,0x4(%esp)
  100075:	c7 04 24 3c 78 10 00 	movl   $0x10783c,(%esp)
  10007c:	e8 44 02 00 00       	call   1002c5 <cprintf>

    print_kerninfo();
  100081:	e8 02 09 00 00       	call   100988 <print_kerninfo>

    grade_backtrace();
  100086:	e8 95 00 00 00       	call   100120 <grade_backtrace>

    pmm_init();                 // init physical memory management
  10008b:	e8 aa 35 00 00       	call   10363a <pmm_init>

    pic_init();                 // init interrupt controller
  100090:	e8 9c 17 00 00       	call   101831 <pic_init>
    idt_init();                 // init interrupt descriptor table
  100095:	e8 41 19 00 00       	call   1019db <idt_init>

    clock_init();               // init clock interrupt
  10009a:	e8 5e 0d 00 00       	call   100dfd <clock_init>
    intr_enable();              // enable irq interrupt
  10009f:	e8 d9 18 00 00       	call   10197d <intr_enable>
    //LAB1: CAHLLENGE 1 If you try to do it, uncomment lab1_switch_test()
    // user/kernel mode switch test
    //lab1_switch_test();

    /* do nothing */
    while (1);
  1000a4:	eb fe                	jmp    1000a4 <kern_init+0x6e>

001000a6 <grade_backtrace2>:
}

void __attribute__((noinline))
grade_backtrace2(int arg0, int arg1, int arg2, int arg3) {
  1000a6:	f3 0f 1e fb          	endbr32 
  1000aa:	55                   	push   %ebp
  1000ab:	89 e5                	mov    %esp,%ebp
  1000ad:	83 ec 18             	sub    $0x18,%esp
    mon_backtrace(0, NULL, NULL);
  1000b0:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  1000b7:	00 
  1000b8:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  1000bf:	00 
  1000c0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  1000c7:	e8 1b 0d 00 00       	call   100de7 <mon_backtrace>
}
  1000cc:	90                   	nop
  1000cd:	c9                   	leave  
  1000ce:	c3                   	ret    

001000cf <grade_backtrace1>:

void __attribute__((noinline))
grade_backtrace1(int arg0, int arg1) {
  1000cf:	f3 0f 1e fb          	endbr32 
  1000d3:	55                   	push   %ebp
  1000d4:	89 e5                	mov    %esp,%ebp
  1000d6:	53                   	push   %ebx
  1000d7:	83 ec 14             	sub    $0x14,%esp
    grade_backtrace2(arg0, (int)&arg0, arg1, (int)&arg1);
  1000da:	8d 4d 0c             	lea    0xc(%ebp),%ecx
  1000dd:	8b 55 0c             	mov    0xc(%ebp),%edx
  1000e0:	8d 5d 08             	lea    0x8(%ebp),%ebx
  1000e3:	8b 45 08             	mov    0x8(%ebp),%eax
  1000e6:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  1000ea:	89 54 24 08          	mov    %edx,0x8(%esp)
  1000ee:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  1000f2:	89 04 24             	mov    %eax,(%esp)
  1000f5:	e8 ac ff ff ff       	call   1000a6 <grade_backtrace2>
}
  1000fa:	90                   	nop
  1000fb:	83 c4 14             	add    $0x14,%esp
  1000fe:	5b                   	pop    %ebx
  1000ff:	5d                   	pop    %ebp
  100100:	c3                   	ret    

00100101 <grade_backtrace0>:

void __attribute__((noinline))
grade_backtrace0(int arg0, int arg1, int arg2) {
  100101:	f3 0f 1e fb          	endbr32 
  100105:	55                   	push   %ebp
  100106:	89 e5                	mov    %esp,%ebp
  100108:	83 ec 18             	sub    $0x18,%esp
    grade_backtrace1(arg0, arg2);
  10010b:	8b 45 10             	mov    0x10(%ebp),%eax
  10010e:	89 44 24 04          	mov    %eax,0x4(%esp)
  100112:	8b 45 08             	mov    0x8(%ebp),%eax
  100115:	89 04 24             	mov    %eax,(%esp)
  100118:	e8 b2 ff ff ff       	call   1000cf <grade_backtrace1>
}
  10011d:	90                   	nop
  10011e:	c9                   	leave  
  10011f:	c3                   	ret    

00100120 <grade_backtrace>:

void
grade_backtrace(void) {
  100120:	f3 0f 1e fb          	endbr32 
  100124:	55                   	push   %ebp
  100125:	89 e5                	mov    %esp,%ebp
  100127:	83 ec 18             	sub    $0x18,%esp
    grade_backtrace0(0, (int)kern_init, 0xffff0000);
  10012a:	b8 36 00 10 00       	mov    $0x100036,%eax
  10012f:	c7 44 24 08 00 00 ff 	movl   $0xffff0000,0x8(%esp)
  100136:	ff 
  100137:	89 44 24 04          	mov    %eax,0x4(%esp)
  10013b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  100142:	e8 ba ff ff ff       	call   100101 <grade_backtrace0>
}
  100147:	90                   	nop
  100148:	c9                   	leave  
  100149:	c3                   	ret    

0010014a <lab1_print_cur_status>:

static void
lab1_print_cur_status(void) {
  10014a:	f3 0f 1e fb          	endbr32 
  10014e:	55                   	push   %ebp
  10014f:	89 e5                	mov    %esp,%ebp
  100151:	83 ec 28             	sub    $0x28,%esp
    static int round = 0;
    uint16_t reg1, reg2, reg3, reg4;
    asm volatile (
  100154:	8c 4d f6             	mov    %cs,-0xa(%ebp)
  100157:	8c 5d f4             	mov    %ds,-0xc(%ebp)
  10015a:	8c 45 f2             	mov    %es,-0xe(%ebp)
  10015d:	8c 55 f0             	mov    %ss,-0x10(%ebp)
            "mov %%cs, %0;"
            "mov %%ds, %1;"
            "mov %%es, %2;"
            "mov %%ss, %3;"
            : "=m"(reg1), "=m"(reg2), "=m"(reg3), "=m"(reg4));
    cprintf("%d: @ring %d\n", round, reg1 & 3);
  100160:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  100164:	83 e0 03             	and    $0x3,%eax
  100167:	89 c2                	mov    %eax,%edx
  100169:	a1 00 00 12 00       	mov    0x120000,%eax
  10016e:	89 54 24 08          	mov    %edx,0x8(%esp)
  100172:	89 44 24 04          	mov    %eax,0x4(%esp)
  100176:	c7 04 24 41 78 10 00 	movl   $0x107841,(%esp)
  10017d:	e8 43 01 00 00       	call   1002c5 <cprintf>
    cprintf("%d:  cs = %x\n", round, reg1);
  100182:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  100186:	89 c2                	mov    %eax,%edx
  100188:	a1 00 00 12 00       	mov    0x120000,%eax
  10018d:	89 54 24 08          	mov    %edx,0x8(%esp)
  100191:	89 44 24 04          	mov    %eax,0x4(%esp)
  100195:	c7 04 24 4f 78 10 00 	movl   $0x10784f,(%esp)
  10019c:	e8 24 01 00 00       	call   1002c5 <cprintf>
    cprintf("%d:  ds = %x\n", round, reg2);
  1001a1:	0f b7 45 f4          	movzwl -0xc(%ebp),%eax
  1001a5:	89 c2                	mov    %eax,%edx
  1001a7:	a1 00 00 12 00       	mov    0x120000,%eax
  1001ac:	89 54 24 08          	mov    %edx,0x8(%esp)
  1001b0:	89 44 24 04          	mov    %eax,0x4(%esp)
  1001b4:	c7 04 24 5d 78 10 00 	movl   $0x10785d,(%esp)
  1001bb:	e8 05 01 00 00       	call   1002c5 <cprintf>
    cprintf("%d:  es = %x\n", round, reg3);
  1001c0:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  1001c4:	89 c2                	mov    %eax,%edx
  1001c6:	a1 00 00 12 00       	mov    0x120000,%eax
  1001cb:	89 54 24 08          	mov    %edx,0x8(%esp)
  1001cf:	89 44 24 04          	mov    %eax,0x4(%esp)
  1001d3:	c7 04 24 6b 78 10 00 	movl   $0x10786b,(%esp)
  1001da:	e8 e6 00 00 00       	call   1002c5 <cprintf>
    cprintf("%d:  ss = %x\n", round, reg4);
  1001df:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
  1001e3:	89 c2                	mov    %eax,%edx
  1001e5:	a1 00 00 12 00       	mov    0x120000,%eax
  1001ea:	89 54 24 08          	mov    %edx,0x8(%esp)
  1001ee:	89 44 24 04          	mov    %eax,0x4(%esp)
  1001f2:	c7 04 24 79 78 10 00 	movl   $0x107879,(%esp)
  1001f9:	e8 c7 00 00 00       	call   1002c5 <cprintf>
    round ++;
  1001fe:	a1 00 00 12 00       	mov    0x120000,%eax
  100203:	40                   	inc    %eax
  100204:	a3 00 00 12 00       	mov    %eax,0x120000
}
  100209:	90                   	nop
  10020a:	c9                   	leave  
  10020b:	c3                   	ret    

0010020c <lab1_switch_to_user>:

static void
lab1_switch_to_user(void) {
  10020c:	f3 0f 1e fb          	endbr32 
  100210:	55                   	push   %ebp
  100211:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 : TODO
    asm volatile (
  100213:	83 ec 08             	sub    $0x8,%esp
  100216:	cd 78                	int    $0x78
  100218:	89 ec                	mov    %ebp,%esp
	    "int %0 \n"
	    "movl %%ebp, %%esp"
	    : 
	    : "i"(T_SWITCH_TOU)
	);
}
  10021a:	90                   	nop
  10021b:	5d                   	pop    %ebp
  10021c:	c3                   	ret    

0010021d <lab1_switch_to_kernel>:

static void
lab1_switch_to_kernel(void) {
  10021d:	f3 0f 1e fb          	endbr32 
  100221:	55                   	push   %ebp
  100222:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 :  TODO
    asm volatile (
  100224:	cd 79                	int    $0x79
  100226:	89 ec                	mov    %ebp,%esp
	    "int %0 \n"
	    "movl %%ebp, %%esp \n"
	    : 
	    : "i"(T_SWITCH_TOK)
	);
}
  100228:	90                   	nop
  100229:	5d                   	pop    %ebp
  10022a:	c3                   	ret    

0010022b <lab1_switch_test>:

static void
lab1_switch_test(void) {
  10022b:	f3 0f 1e fb          	endbr32 
  10022f:	55                   	push   %ebp
  100230:	89 e5                	mov    %esp,%ebp
  100232:	83 ec 18             	sub    $0x18,%esp
    lab1_print_cur_status();
  100235:	e8 10 ff ff ff       	call   10014a <lab1_print_cur_status>
    cprintf("+++ switch to  user  mode +++\n");
  10023a:	c7 04 24 88 78 10 00 	movl   $0x107888,(%esp)
  100241:	e8 7f 00 00 00       	call   1002c5 <cprintf>
    lab1_switch_to_user();
  100246:	e8 c1 ff ff ff       	call   10020c <lab1_switch_to_user>
    lab1_print_cur_status();
  10024b:	e8 fa fe ff ff       	call   10014a <lab1_print_cur_status>
    cprintf("+++ switch to kernel mode +++\n");
  100250:	c7 04 24 a8 78 10 00 	movl   $0x1078a8,(%esp)
  100257:	e8 69 00 00 00       	call   1002c5 <cprintf>
    lab1_switch_to_kernel();
  10025c:	e8 bc ff ff ff       	call   10021d <lab1_switch_to_kernel>
    lab1_print_cur_status();
  100261:	e8 e4 fe ff ff       	call   10014a <lab1_print_cur_status>
}
  100266:	90                   	nop
  100267:	c9                   	leave  
  100268:	c3                   	ret    

00100269 <cputch>:
/* *
 * cputch - writes a single character @c to stdout, and it will
 * increace the value of counter pointed by @cnt.
 * */
static void
cputch(int c, int *cnt) {
  100269:	f3 0f 1e fb          	endbr32 
  10026d:	55                   	push   %ebp
  10026e:	89 e5                	mov    %esp,%ebp
  100270:	83 ec 18             	sub    $0x18,%esp
    cons_putc(c);
  100273:	8b 45 08             	mov    0x8(%ebp),%eax
  100276:	89 04 24             	mov    %eax,(%esp)
  100279:	e8 69 14 00 00       	call   1016e7 <cons_putc>
    (*cnt) ++;
  10027e:	8b 45 0c             	mov    0xc(%ebp),%eax
  100281:	8b 00                	mov    (%eax),%eax
  100283:	8d 50 01             	lea    0x1(%eax),%edx
  100286:	8b 45 0c             	mov    0xc(%ebp),%eax
  100289:	89 10                	mov    %edx,(%eax)
}
  10028b:	90                   	nop
  10028c:	c9                   	leave  
  10028d:	c3                   	ret    

0010028e <vcprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want cprintf() instead.
 * */
int
vcprintf(const char *fmt, va_list ap) {
  10028e:	f3 0f 1e fb          	endbr32 
  100292:	55                   	push   %ebp
  100293:	89 e5                	mov    %esp,%ebp
  100295:	83 ec 28             	sub    $0x28,%esp
    int cnt = 0;
  100298:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    vprintfmt((void*)cputch, &cnt, fmt, ap);
  10029f:	8b 45 0c             	mov    0xc(%ebp),%eax
  1002a2:	89 44 24 0c          	mov    %eax,0xc(%esp)
  1002a6:	8b 45 08             	mov    0x8(%ebp),%eax
  1002a9:	89 44 24 08          	mov    %eax,0x8(%esp)
  1002ad:	8d 45 f4             	lea    -0xc(%ebp),%eax
  1002b0:	89 44 24 04          	mov    %eax,0x4(%esp)
  1002b4:	c7 04 24 69 02 10 00 	movl   $0x100269,(%esp)
  1002bb:	e8 8e 70 00 00       	call   10734e <vprintfmt>
    return cnt;
  1002c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  1002c3:	c9                   	leave  
  1002c4:	c3                   	ret    

001002c5 <cprintf>:
 *
 * The return value is the number of characters which would be
 * written to stdout.
 * */
int
cprintf(const char *fmt, ...) {
  1002c5:	f3 0f 1e fb          	endbr32 
  1002c9:	55                   	push   %ebp
  1002ca:	89 e5                	mov    %esp,%ebp
  1002cc:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
  1002cf:	8d 45 0c             	lea    0xc(%ebp),%eax
  1002d2:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vcprintf(fmt, ap);
  1002d5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1002d8:	89 44 24 04          	mov    %eax,0x4(%esp)
  1002dc:	8b 45 08             	mov    0x8(%ebp),%eax
  1002df:	89 04 24             	mov    %eax,(%esp)
  1002e2:	e8 a7 ff ff ff       	call   10028e <vcprintf>
  1002e7:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
  1002ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  1002ed:	c9                   	leave  
  1002ee:	c3                   	ret    

001002ef <cputchar>:

/* cputchar - writes a single character to stdout */
void
cputchar(int c) {
  1002ef:	f3 0f 1e fb          	endbr32 
  1002f3:	55                   	push   %ebp
  1002f4:	89 e5                	mov    %esp,%ebp
  1002f6:	83 ec 18             	sub    $0x18,%esp
    cons_putc(c);
  1002f9:	8b 45 08             	mov    0x8(%ebp),%eax
  1002fc:	89 04 24             	mov    %eax,(%esp)
  1002ff:	e8 e3 13 00 00       	call   1016e7 <cons_putc>
}
  100304:	90                   	nop
  100305:	c9                   	leave  
  100306:	c3                   	ret    

00100307 <cputs>:
/* *
 * cputs- writes the string pointed by @str to stdout and
 * appends a newline character.
 * */
int
cputs(const char *str) {
  100307:	f3 0f 1e fb          	endbr32 
  10030b:	55                   	push   %ebp
  10030c:	89 e5                	mov    %esp,%ebp
  10030e:	83 ec 28             	sub    $0x28,%esp
    int cnt = 0;
  100311:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    char c;
    while ((c = *str ++) != '\0') {
  100318:	eb 13                	jmp    10032d <cputs+0x26>
        cputch(c, &cnt);
  10031a:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  10031e:	8d 55 f0             	lea    -0x10(%ebp),%edx
  100321:	89 54 24 04          	mov    %edx,0x4(%esp)
  100325:	89 04 24             	mov    %eax,(%esp)
  100328:	e8 3c ff ff ff       	call   100269 <cputch>
    while ((c = *str ++) != '\0') {
  10032d:	8b 45 08             	mov    0x8(%ebp),%eax
  100330:	8d 50 01             	lea    0x1(%eax),%edx
  100333:	89 55 08             	mov    %edx,0x8(%ebp)
  100336:	0f b6 00             	movzbl (%eax),%eax
  100339:	88 45 f7             	mov    %al,-0x9(%ebp)
  10033c:	80 7d f7 00          	cmpb   $0x0,-0x9(%ebp)
  100340:	75 d8                	jne    10031a <cputs+0x13>
    }
    cputch('\n', &cnt);
  100342:	8d 45 f0             	lea    -0x10(%ebp),%eax
  100345:	89 44 24 04          	mov    %eax,0x4(%esp)
  100349:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
  100350:	e8 14 ff ff ff       	call   100269 <cputch>
    return cnt;
  100355:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  100358:	c9                   	leave  
  100359:	c3                   	ret    

0010035a <getchar>:

/* getchar - reads a single non-zero character from stdin */
int
getchar(void) {
  10035a:	f3 0f 1e fb          	endbr32 
  10035e:	55                   	push   %ebp
  10035f:	89 e5                	mov    %esp,%ebp
  100361:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = cons_getc()) == 0)
  100364:	90                   	nop
  100365:	e8 be 13 00 00       	call   101728 <cons_getc>
  10036a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  10036d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  100371:	74 f2                	je     100365 <getchar+0xb>
        /* do nothing */;
    return c;
  100373:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  100376:	c9                   	leave  
  100377:	c3                   	ret    

00100378 <readline>:
 * The readline() function returns the text of the line read. If some errors
 * are happened, NULL is returned. The return value is a global variable,
 * thus it should be copied before it is used.
 * */
char *
readline(const char *prompt) {
  100378:	f3 0f 1e fb          	endbr32 
  10037c:	55                   	push   %ebp
  10037d:	89 e5                	mov    %esp,%ebp
  10037f:	83 ec 28             	sub    $0x28,%esp
    if (prompt != NULL) {
  100382:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  100386:	74 13                	je     10039b <readline+0x23>
        cprintf("%s", prompt);
  100388:	8b 45 08             	mov    0x8(%ebp),%eax
  10038b:	89 44 24 04          	mov    %eax,0x4(%esp)
  10038f:	c7 04 24 c7 78 10 00 	movl   $0x1078c7,(%esp)
  100396:	e8 2a ff ff ff       	call   1002c5 <cprintf>
    }
    int i = 0, c;
  10039b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        c = getchar();
  1003a2:	e8 b3 ff ff ff       	call   10035a <getchar>
  1003a7:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (c < 0) {
  1003aa:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  1003ae:	79 07                	jns    1003b7 <readline+0x3f>
            return NULL;
  1003b0:	b8 00 00 00 00       	mov    $0x0,%eax
  1003b5:	eb 78                	jmp    10042f <readline+0xb7>
        }
        else if (c >= ' ' && i < BUFSIZE - 1) {
  1003b7:	83 7d f0 1f          	cmpl   $0x1f,-0x10(%ebp)
  1003bb:	7e 28                	jle    1003e5 <readline+0x6d>
  1003bd:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  1003c4:	7f 1f                	jg     1003e5 <readline+0x6d>
            cputchar(c);
  1003c6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1003c9:	89 04 24             	mov    %eax,(%esp)
  1003cc:	e8 1e ff ff ff       	call   1002ef <cputchar>
            buf[i ++] = c;
  1003d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1003d4:	8d 50 01             	lea    0x1(%eax),%edx
  1003d7:	89 55 f4             	mov    %edx,-0xc(%ebp)
  1003da:	8b 55 f0             	mov    -0x10(%ebp),%edx
  1003dd:	88 90 20 00 12 00    	mov    %dl,0x120020(%eax)
  1003e3:	eb 45                	jmp    10042a <readline+0xb2>
        }
        else if (c == '\b' && i > 0) {
  1003e5:	83 7d f0 08          	cmpl   $0x8,-0x10(%ebp)
  1003e9:	75 16                	jne    100401 <readline+0x89>
  1003eb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1003ef:	7e 10                	jle    100401 <readline+0x89>
            cputchar(c);
  1003f1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1003f4:	89 04 24             	mov    %eax,(%esp)
  1003f7:	e8 f3 fe ff ff       	call   1002ef <cputchar>
            i --;
  1003fc:	ff 4d f4             	decl   -0xc(%ebp)
  1003ff:	eb 29                	jmp    10042a <readline+0xb2>
        }
        else if (c == '\n' || c == '\r') {
  100401:	83 7d f0 0a          	cmpl   $0xa,-0x10(%ebp)
  100405:	74 06                	je     10040d <readline+0x95>
  100407:	83 7d f0 0d          	cmpl   $0xd,-0x10(%ebp)
  10040b:	75 95                	jne    1003a2 <readline+0x2a>
            cputchar(c);
  10040d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100410:	89 04 24             	mov    %eax,(%esp)
  100413:	e8 d7 fe ff ff       	call   1002ef <cputchar>
            buf[i] = '\0';
  100418:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10041b:	05 20 00 12 00       	add    $0x120020,%eax
  100420:	c6 00 00             	movb   $0x0,(%eax)
            return buf;
  100423:	b8 20 00 12 00       	mov    $0x120020,%eax
  100428:	eb 05                	jmp    10042f <readline+0xb7>
        c = getchar();
  10042a:	e9 73 ff ff ff       	jmp    1003a2 <readline+0x2a>
        }
    }
}
  10042f:	c9                   	leave  
  100430:	c3                   	ret    

00100431 <__panic>:
/* *
 * __panic - __panic is called on unresolvable fatal errors. it prints
 * "panic: 'message'", and then enters the kernel monitor.
 * */
void
__panic(const char *file, int line, const char *fmt, ...) {
  100431:	f3 0f 1e fb          	endbr32 
  100435:	55                   	push   %ebp
  100436:	89 e5                	mov    %esp,%ebp
  100438:	83 ec 28             	sub    $0x28,%esp
    if (is_panic) {
  10043b:	a1 20 04 12 00       	mov    0x120420,%eax
  100440:	85 c0                	test   %eax,%eax
  100442:	75 5b                	jne    10049f <__panic+0x6e>
        goto panic_dead;
    }
    is_panic = 1;
  100444:	c7 05 20 04 12 00 01 	movl   $0x1,0x120420
  10044b:	00 00 00 

    // print the 'message'
    va_list ap;
    va_start(ap, fmt);
  10044e:	8d 45 14             	lea    0x14(%ebp),%eax
  100451:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel panic at %s:%d:\n    ", file, line);
  100454:	8b 45 0c             	mov    0xc(%ebp),%eax
  100457:	89 44 24 08          	mov    %eax,0x8(%esp)
  10045b:	8b 45 08             	mov    0x8(%ebp),%eax
  10045e:	89 44 24 04          	mov    %eax,0x4(%esp)
  100462:	c7 04 24 ca 78 10 00 	movl   $0x1078ca,(%esp)
  100469:	e8 57 fe ff ff       	call   1002c5 <cprintf>
    vcprintf(fmt, ap);
  10046e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100471:	89 44 24 04          	mov    %eax,0x4(%esp)
  100475:	8b 45 10             	mov    0x10(%ebp),%eax
  100478:	89 04 24             	mov    %eax,(%esp)
  10047b:	e8 0e fe ff ff       	call   10028e <vcprintf>
    cprintf("\n");
  100480:	c7 04 24 e6 78 10 00 	movl   $0x1078e6,(%esp)
  100487:	e8 39 fe ff ff       	call   1002c5 <cprintf>
    
    cprintf("stack trackback:\n");
  10048c:	c7 04 24 e8 78 10 00 	movl   $0x1078e8,(%esp)
  100493:	e8 2d fe ff ff       	call   1002c5 <cprintf>
    print_stackframe();
  100498:	e8 3d 06 00 00       	call   100ada <print_stackframe>
  10049d:	eb 01                	jmp    1004a0 <__panic+0x6f>
        goto panic_dead;
  10049f:	90                   	nop
    
    va_end(ap);

panic_dead:
    intr_disable();
  1004a0:	e8 e4 14 00 00       	call   101989 <intr_disable>
    while (1) {
        kmonitor(NULL);
  1004a5:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  1004ac:	e8 5d 08 00 00       	call   100d0e <kmonitor>
  1004b1:	eb f2                	jmp    1004a5 <__panic+0x74>

001004b3 <__warn>:
    }
}

/* __warn - like panic, but don't */
void
__warn(const char *file, int line, const char *fmt, ...) {
  1004b3:	f3 0f 1e fb          	endbr32 
  1004b7:	55                   	push   %ebp
  1004b8:	89 e5                	mov    %esp,%ebp
  1004ba:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    va_start(ap, fmt);
  1004bd:	8d 45 14             	lea    0x14(%ebp),%eax
  1004c0:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel warning at %s:%d:\n    ", file, line);
  1004c3:	8b 45 0c             	mov    0xc(%ebp),%eax
  1004c6:	89 44 24 08          	mov    %eax,0x8(%esp)
  1004ca:	8b 45 08             	mov    0x8(%ebp),%eax
  1004cd:	89 44 24 04          	mov    %eax,0x4(%esp)
  1004d1:	c7 04 24 fa 78 10 00 	movl   $0x1078fa,(%esp)
  1004d8:	e8 e8 fd ff ff       	call   1002c5 <cprintf>
    vcprintf(fmt, ap);
  1004dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1004e0:	89 44 24 04          	mov    %eax,0x4(%esp)
  1004e4:	8b 45 10             	mov    0x10(%ebp),%eax
  1004e7:	89 04 24             	mov    %eax,(%esp)
  1004ea:	e8 9f fd ff ff       	call   10028e <vcprintf>
    cprintf("\n");
  1004ef:	c7 04 24 e6 78 10 00 	movl   $0x1078e6,(%esp)
  1004f6:	e8 ca fd ff ff       	call   1002c5 <cprintf>
    va_end(ap);
}
  1004fb:	90                   	nop
  1004fc:	c9                   	leave  
  1004fd:	c3                   	ret    

001004fe <is_kernel_panic>:

bool
is_kernel_panic(void) {
  1004fe:	f3 0f 1e fb          	endbr32 
  100502:	55                   	push   %ebp
  100503:	89 e5                	mov    %esp,%ebp
    return is_panic;
  100505:	a1 20 04 12 00       	mov    0x120420,%eax
}
  10050a:	5d                   	pop    %ebp
  10050b:	c3                   	ret    

0010050c <stab_binsearch>:
 *      stab_binsearch(stabs, &left, &right, N_SO, 0xf0100184);
 * will exit setting left = 118, right = 554.
 * */
static void
stab_binsearch(const struct stab *stabs, int *region_left, int *region_right,
           int type, uintptr_t addr) {
  10050c:	f3 0f 1e fb          	endbr32 
  100510:	55                   	push   %ebp
  100511:	89 e5                	mov    %esp,%ebp
  100513:	83 ec 20             	sub    $0x20,%esp
    int l = *region_left, r = *region_right, any_matches = 0;
  100516:	8b 45 0c             	mov    0xc(%ebp),%eax
  100519:	8b 00                	mov    (%eax),%eax
  10051b:	89 45 fc             	mov    %eax,-0x4(%ebp)
  10051e:	8b 45 10             	mov    0x10(%ebp),%eax
  100521:	8b 00                	mov    (%eax),%eax
  100523:	89 45 f8             	mov    %eax,-0x8(%ebp)
  100526:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

    while (l <= r) {
  10052d:	e9 ca 00 00 00       	jmp    1005fc <stab_binsearch+0xf0>
        int true_m = (l + r) / 2, m = true_m;
  100532:	8b 55 fc             	mov    -0x4(%ebp),%edx
  100535:	8b 45 f8             	mov    -0x8(%ebp),%eax
  100538:	01 d0                	add    %edx,%eax
  10053a:	89 c2                	mov    %eax,%edx
  10053c:	c1 ea 1f             	shr    $0x1f,%edx
  10053f:	01 d0                	add    %edx,%eax
  100541:	d1 f8                	sar    %eax
  100543:	89 45 ec             	mov    %eax,-0x14(%ebp)
  100546:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100549:	89 45 f0             	mov    %eax,-0x10(%ebp)

        // search for earliest stab with right type
        while (m >= l && stabs[m].n_type != type) {
  10054c:	eb 03                	jmp    100551 <stab_binsearch+0x45>
            m --;
  10054e:	ff 4d f0             	decl   -0x10(%ebp)
        while (m >= l && stabs[m].n_type != type) {
  100551:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100554:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  100557:	7c 1f                	jl     100578 <stab_binsearch+0x6c>
  100559:	8b 55 f0             	mov    -0x10(%ebp),%edx
  10055c:	89 d0                	mov    %edx,%eax
  10055e:	01 c0                	add    %eax,%eax
  100560:	01 d0                	add    %edx,%eax
  100562:	c1 e0 02             	shl    $0x2,%eax
  100565:	89 c2                	mov    %eax,%edx
  100567:	8b 45 08             	mov    0x8(%ebp),%eax
  10056a:	01 d0                	add    %edx,%eax
  10056c:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  100570:	0f b6 c0             	movzbl %al,%eax
  100573:	39 45 14             	cmp    %eax,0x14(%ebp)
  100576:	75 d6                	jne    10054e <stab_binsearch+0x42>
        }
        if (m < l) {    // no match in [l, m]
  100578:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10057b:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  10057e:	7d 09                	jge    100589 <stab_binsearch+0x7d>
            l = true_m + 1;
  100580:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100583:	40                   	inc    %eax
  100584:	89 45 fc             	mov    %eax,-0x4(%ebp)
            continue;
  100587:	eb 73                	jmp    1005fc <stab_binsearch+0xf0>
        }

        // actual binary search
        any_matches = 1;
  100589:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
        if (stabs[m].n_value < addr) {
  100590:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100593:	89 d0                	mov    %edx,%eax
  100595:	01 c0                	add    %eax,%eax
  100597:	01 d0                	add    %edx,%eax
  100599:	c1 e0 02             	shl    $0x2,%eax
  10059c:	89 c2                	mov    %eax,%edx
  10059e:	8b 45 08             	mov    0x8(%ebp),%eax
  1005a1:	01 d0                	add    %edx,%eax
  1005a3:	8b 40 08             	mov    0x8(%eax),%eax
  1005a6:	39 45 18             	cmp    %eax,0x18(%ebp)
  1005a9:	76 11                	jbe    1005bc <stab_binsearch+0xb0>
            *region_left = m;
  1005ab:	8b 45 0c             	mov    0xc(%ebp),%eax
  1005ae:	8b 55 f0             	mov    -0x10(%ebp),%edx
  1005b1:	89 10                	mov    %edx,(%eax)
            l = true_m + 1;
  1005b3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1005b6:	40                   	inc    %eax
  1005b7:	89 45 fc             	mov    %eax,-0x4(%ebp)
  1005ba:	eb 40                	jmp    1005fc <stab_binsearch+0xf0>
        } else if (stabs[m].n_value > addr) {
  1005bc:	8b 55 f0             	mov    -0x10(%ebp),%edx
  1005bf:	89 d0                	mov    %edx,%eax
  1005c1:	01 c0                	add    %eax,%eax
  1005c3:	01 d0                	add    %edx,%eax
  1005c5:	c1 e0 02             	shl    $0x2,%eax
  1005c8:	89 c2                	mov    %eax,%edx
  1005ca:	8b 45 08             	mov    0x8(%ebp),%eax
  1005cd:	01 d0                	add    %edx,%eax
  1005cf:	8b 40 08             	mov    0x8(%eax),%eax
  1005d2:	39 45 18             	cmp    %eax,0x18(%ebp)
  1005d5:	73 14                	jae    1005eb <stab_binsearch+0xdf>
            *region_right = m - 1;
  1005d7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1005da:	8d 50 ff             	lea    -0x1(%eax),%edx
  1005dd:	8b 45 10             	mov    0x10(%ebp),%eax
  1005e0:	89 10                	mov    %edx,(%eax)
            r = m - 1;
  1005e2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1005e5:	48                   	dec    %eax
  1005e6:	89 45 f8             	mov    %eax,-0x8(%ebp)
  1005e9:	eb 11                	jmp    1005fc <stab_binsearch+0xf0>
        } else {
            // exact match for 'addr', but continue loop to find
            // *region_right
            *region_left = m;
  1005eb:	8b 45 0c             	mov    0xc(%ebp),%eax
  1005ee:	8b 55 f0             	mov    -0x10(%ebp),%edx
  1005f1:	89 10                	mov    %edx,(%eax)
            l = m;
  1005f3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1005f6:	89 45 fc             	mov    %eax,-0x4(%ebp)
            addr ++;
  1005f9:	ff 45 18             	incl   0x18(%ebp)
    while (l <= r) {
  1005fc:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1005ff:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  100602:	0f 8e 2a ff ff ff    	jle    100532 <stab_binsearch+0x26>
        }
    }

    if (!any_matches) {
  100608:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  10060c:	75 0f                	jne    10061d <stab_binsearch+0x111>
        *region_right = *region_left - 1;
  10060e:	8b 45 0c             	mov    0xc(%ebp),%eax
  100611:	8b 00                	mov    (%eax),%eax
  100613:	8d 50 ff             	lea    -0x1(%eax),%edx
  100616:	8b 45 10             	mov    0x10(%ebp),%eax
  100619:	89 10                	mov    %edx,(%eax)
        l = *region_right;
        for (; l > *region_left && stabs[l].n_type != type; l --)
            /* do nothing */;
        *region_left = l;
    }
}
  10061b:	eb 3e                	jmp    10065b <stab_binsearch+0x14f>
        l = *region_right;
  10061d:	8b 45 10             	mov    0x10(%ebp),%eax
  100620:	8b 00                	mov    (%eax),%eax
  100622:	89 45 fc             	mov    %eax,-0x4(%ebp)
        for (; l > *region_left && stabs[l].n_type != type; l --)
  100625:	eb 03                	jmp    10062a <stab_binsearch+0x11e>
  100627:	ff 4d fc             	decl   -0x4(%ebp)
  10062a:	8b 45 0c             	mov    0xc(%ebp),%eax
  10062d:	8b 00                	mov    (%eax),%eax
  10062f:	39 45 fc             	cmp    %eax,-0x4(%ebp)
  100632:	7e 1f                	jle    100653 <stab_binsearch+0x147>
  100634:	8b 55 fc             	mov    -0x4(%ebp),%edx
  100637:	89 d0                	mov    %edx,%eax
  100639:	01 c0                	add    %eax,%eax
  10063b:	01 d0                	add    %edx,%eax
  10063d:	c1 e0 02             	shl    $0x2,%eax
  100640:	89 c2                	mov    %eax,%edx
  100642:	8b 45 08             	mov    0x8(%ebp),%eax
  100645:	01 d0                	add    %edx,%eax
  100647:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  10064b:	0f b6 c0             	movzbl %al,%eax
  10064e:	39 45 14             	cmp    %eax,0x14(%ebp)
  100651:	75 d4                	jne    100627 <stab_binsearch+0x11b>
        *region_left = l;
  100653:	8b 45 0c             	mov    0xc(%ebp),%eax
  100656:	8b 55 fc             	mov    -0x4(%ebp),%edx
  100659:	89 10                	mov    %edx,(%eax)
}
  10065b:	90                   	nop
  10065c:	c9                   	leave  
  10065d:	c3                   	ret    

0010065e <debuginfo_eip>:
 * the specified instruction address, @addr.  Returns 0 if information
 * was found, and negative if not.  But even if it returns negative it
 * has stored some information into '*info'.
 * */
int
debuginfo_eip(uintptr_t addr, struct eipdebuginfo *info) {
  10065e:	f3 0f 1e fb          	endbr32 
  100662:	55                   	push   %ebp
  100663:	89 e5                	mov    %esp,%ebp
  100665:	83 ec 58             	sub    $0x58,%esp
    const struct stab *stabs, *stab_end;
    const char *stabstr, *stabstr_end;

    info->eip_file = "<unknown>";
  100668:	8b 45 0c             	mov    0xc(%ebp),%eax
  10066b:	c7 00 18 79 10 00    	movl   $0x107918,(%eax)
    info->eip_line = 0;
  100671:	8b 45 0c             	mov    0xc(%ebp),%eax
  100674:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    info->eip_fn_name = "<unknown>";
  10067b:	8b 45 0c             	mov    0xc(%ebp),%eax
  10067e:	c7 40 08 18 79 10 00 	movl   $0x107918,0x8(%eax)
    info->eip_fn_namelen = 9;
  100685:	8b 45 0c             	mov    0xc(%ebp),%eax
  100688:	c7 40 0c 09 00 00 00 	movl   $0x9,0xc(%eax)
    info->eip_fn_addr = addr;
  10068f:	8b 45 0c             	mov    0xc(%ebp),%eax
  100692:	8b 55 08             	mov    0x8(%ebp),%edx
  100695:	89 50 10             	mov    %edx,0x10(%eax)
    info->eip_fn_narg = 0;
  100698:	8b 45 0c             	mov    0xc(%ebp),%eax
  10069b:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)

    stabs = __STAB_BEGIN__;
  1006a2:	c7 45 f4 e8 8e 10 00 	movl   $0x108ee8,-0xc(%ebp)
    stab_end = __STAB_END__;
  1006a9:	c7 45 f0 84 76 11 00 	movl   $0x117684,-0x10(%ebp)
    stabstr = __STABSTR_BEGIN__;
  1006b0:	c7 45 ec 85 76 11 00 	movl   $0x117685,-0x14(%ebp)
    stabstr_end = __STABSTR_END__;
  1006b7:	c7 45 e8 ef a4 11 00 	movl   $0x11a4ef,-0x18(%ebp)

    // String table validity checks
    if (stabstr_end <= stabstr || stabstr_end[-1] != 0) {
  1006be:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1006c1:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  1006c4:	76 0b                	jbe    1006d1 <debuginfo_eip+0x73>
  1006c6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1006c9:	48                   	dec    %eax
  1006ca:	0f b6 00             	movzbl (%eax),%eax
  1006cd:	84 c0                	test   %al,%al
  1006cf:	74 0a                	je     1006db <debuginfo_eip+0x7d>
        return -1;
  1006d1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  1006d6:	e9 ab 02 00 00       	jmp    100986 <debuginfo_eip+0x328>
    // 'eip'.  First, we find the basic source file containing 'eip'.
    // Then, we look in that source file for the function.  Then we look
    // for the line number.

    // Search the entire set of stabs for the source file (type N_SO).
    int lfile = 0, rfile = (stab_end - stabs) - 1;
  1006db:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  1006e2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1006e5:	2b 45 f4             	sub    -0xc(%ebp),%eax
  1006e8:	c1 f8 02             	sar    $0x2,%eax
  1006eb:	69 c0 ab aa aa aa    	imul   $0xaaaaaaab,%eax,%eax
  1006f1:	48                   	dec    %eax
  1006f2:	89 45 e0             	mov    %eax,-0x20(%ebp)
    stab_binsearch(stabs, &lfile, &rfile, N_SO, addr);
  1006f5:	8b 45 08             	mov    0x8(%ebp),%eax
  1006f8:	89 44 24 10          	mov    %eax,0x10(%esp)
  1006fc:	c7 44 24 0c 64 00 00 	movl   $0x64,0xc(%esp)
  100703:	00 
  100704:	8d 45 e0             	lea    -0x20(%ebp),%eax
  100707:	89 44 24 08          	mov    %eax,0x8(%esp)
  10070b:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  10070e:	89 44 24 04          	mov    %eax,0x4(%esp)
  100712:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100715:	89 04 24             	mov    %eax,(%esp)
  100718:	e8 ef fd ff ff       	call   10050c <stab_binsearch>
    if (lfile == 0)
  10071d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  100720:	85 c0                	test   %eax,%eax
  100722:	75 0a                	jne    10072e <debuginfo_eip+0xd0>
        return -1;
  100724:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  100729:	e9 58 02 00 00       	jmp    100986 <debuginfo_eip+0x328>

    // Search within that file's stabs for the function definition
    // (N_FUN).
    int lfun = lfile, rfun = rfile;
  10072e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  100731:	89 45 dc             	mov    %eax,-0x24(%ebp)
  100734:	8b 45 e0             	mov    -0x20(%ebp),%eax
  100737:	89 45 d8             	mov    %eax,-0x28(%ebp)
    int lline, rline;
    stab_binsearch(stabs, &lfun, &rfun, N_FUN, addr);
  10073a:	8b 45 08             	mov    0x8(%ebp),%eax
  10073d:	89 44 24 10          	mov    %eax,0x10(%esp)
  100741:	c7 44 24 0c 24 00 00 	movl   $0x24,0xc(%esp)
  100748:	00 
  100749:	8d 45 d8             	lea    -0x28(%ebp),%eax
  10074c:	89 44 24 08          	mov    %eax,0x8(%esp)
  100750:	8d 45 dc             	lea    -0x24(%ebp),%eax
  100753:	89 44 24 04          	mov    %eax,0x4(%esp)
  100757:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10075a:	89 04 24             	mov    %eax,(%esp)
  10075d:	e8 aa fd ff ff       	call   10050c <stab_binsearch>

    if (lfun <= rfun) {
  100762:	8b 55 dc             	mov    -0x24(%ebp),%edx
  100765:	8b 45 d8             	mov    -0x28(%ebp),%eax
  100768:	39 c2                	cmp    %eax,%edx
  10076a:	7f 78                	jg     1007e4 <debuginfo_eip+0x186>
        // stabs[lfun] points to the function name
        // in the string table, but check bounds just in case.
        if (stabs[lfun].n_strx < stabstr_end - stabstr) {
  10076c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10076f:	89 c2                	mov    %eax,%edx
  100771:	89 d0                	mov    %edx,%eax
  100773:	01 c0                	add    %eax,%eax
  100775:	01 d0                	add    %edx,%eax
  100777:	c1 e0 02             	shl    $0x2,%eax
  10077a:	89 c2                	mov    %eax,%edx
  10077c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10077f:	01 d0                	add    %edx,%eax
  100781:	8b 10                	mov    (%eax),%edx
  100783:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100786:	2b 45 ec             	sub    -0x14(%ebp),%eax
  100789:	39 c2                	cmp    %eax,%edx
  10078b:	73 22                	jae    1007af <debuginfo_eip+0x151>
            info->eip_fn_name = stabstr + stabs[lfun].n_strx;
  10078d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100790:	89 c2                	mov    %eax,%edx
  100792:	89 d0                	mov    %edx,%eax
  100794:	01 c0                	add    %eax,%eax
  100796:	01 d0                	add    %edx,%eax
  100798:	c1 e0 02             	shl    $0x2,%eax
  10079b:	89 c2                	mov    %eax,%edx
  10079d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1007a0:	01 d0                	add    %edx,%eax
  1007a2:	8b 10                	mov    (%eax),%edx
  1007a4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1007a7:	01 c2                	add    %eax,%edx
  1007a9:	8b 45 0c             	mov    0xc(%ebp),%eax
  1007ac:	89 50 08             	mov    %edx,0x8(%eax)
        }
        info->eip_fn_addr = stabs[lfun].n_value;
  1007af:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1007b2:	89 c2                	mov    %eax,%edx
  1007b4:	89 d0                	mov    %edx,%eax
  1007b6:	01 c0                	add    %eax,%eax
  1007b8:	01 d0                	add    %edx,%eax
  1007ba:	c1 e0 02             	shl    $0x2,%eax
  1007bd:	89 c2                	mov    %eax,%edx
  1007bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1007c2:	01 d0                	add    %edx,%eax
  1007c4:	8b 50 08             	mov    0x8(%eax),%edx
  1007c7:	8b 45 0c             	mov    0xc(%ebp),%eax
  1007ca:	89 50 10             	mov    %edx,0x10(%eax)
        addr -= info->eip_fn_addr;
  1007cd:	8b 45 0c             	mov    0xc(%ebp),%eax
  1007d0:	8b 40 10             	mov    0x10(%eax),%eax
  1007d3:	29 45 08             	sub    %eax,0x8(%ebp)
        // Search within the function definition for the line number.
        lline = lfun;
  1007d6:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1007d9:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfun;
  1007dc:	8b 45 d8             	mov    -0x28(%ebp),%eax
  1007df:	89 45 d0             	mov    %eax,-0x30(%ebp)
  1007e2:	eb 15                	jmp    1007f9 <debuginfo_eip+0x19b>
    } else {
        // Couldn't find function stab!  Maybe we're in an assembly
        // file.  Search the whole file for the line number.
        info->eip_fn_addr = addr;
  1007e4:	8b 45 0c             	mov    0xc(%ebp),%eax
  1007e7:	8b 55 08             	mov    0x8(%ebp),%edx
  1007ea:	89 50 10             	mov    %edx,0x10(%eax)
        lline = lfile;
  1007ed:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1007f0:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfile;
  1007f3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1007f6:	89 45 d0             	mov    %eax,-0x30(%ebp)
    }
    info->eip_fn_namelen = strfind(info->eip_fn_name, ':') - info->eip_fn_name;
  1007f9:	8b 45 0c             	mov    0xc(%ebp),%eax
  1007fc:	8b 40 08             	mov    0x8(%eax),%eax
  1007ff:	c7 44 24 04 3a 00 00 	movl   $0x3a,0x4(%esp)
  100806:	00 
  100807:	89 04 24             	mov    %eax,(%esp)
  10080a:	e8 47 66 00 00       	call   106e56 <strfind>
  10080f:	8b 55 0c             	mov    0xc(%ebp),%edx
  100812:	8b 52 08             	mov    0x8(%edx),%edx
  100815:	29 d0                	sub    %edx,%eax
  100817:	89 c2                	mov    %eax,%edx
  100819:	8b 45 0c             	mov    0xc(%ebp),%eax
  10081c:	89 50 0c             	mov    %edx,0xc(%eax)

    // Search within [lline, rline] for the line number stab.
    // If found, set info->eip_line to the right line number.
    // If not found, return -1.
    stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
  10081f:	8b 45 08             	mov    0x8(%ebp),%eax
  100822:	89 44 24 10          	mov    %eax,0x10(%esp)
  100826:	c7 44 24 0c 44 00 00 	movl   $0x44,0xc(%esp)
  10082d:	00 
  10082e:	8d 45 d0             	lea    -0x30(%ebp),%eax
  100831:	89 44 24 08          	mov    %eax,0x8(%esp)
  100835:	8d 45 d4             	lea    -0x2c(%ebp),%eax
  100838:	89 44 24 04          	mov    %eax,0x4(%esp)
  10083c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10083f:	89 04 24             	mov    %eax,(%esp)
  100842:	e8 c5 fc ff ff       	call   10050c <stab_binsearch>
    if (lline <= rline) {
  100847:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  10084a:	8b 45 d0             	mov    -0x30(%ebp),%eax
  10084d:	39 c2                	cmp    %eax,%edx
  10084f:	7f 23                	jg     100874 <debuginfo_eip+0x216>
        info->eip_line = stabs[rline].n_desc;
  100851:	8b 45 d0             	mov    -0x30(%ebp),%eax
  100854:	89 c2                	mov    %eax,%edx
  100856:	89 d0                	mov    %edx,%eax
  100858:	01 c0                	add    %eax,%eax
  10085a:	01 d0                	add    %edx,%eax
  10085c:	c1 e0 02             	shl    $0x2,%eax
  10085f:	89 c2                	mov    %eax,%edx
  100861:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100864:	01 d0                	add    %edx,%eax
  100866:	0f b7 40 06          	movzwl 0x6(%eax),%eax
  10086a:	89 c2                	mov    %eax,%edx
  10086c:	8b 45 0c             	mov    0xc(%ebp),%eax
  10086f:	89 50 04             	mov    %edx,0x4(%eax)

    // Search backwards from the line number for the relevant filename stab.
    // We can't just use the "lfile" stab because inlined functions
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
  100872:	eb 11                	jmp    100885 <debuginfo_eip+0x227>
        return -1;
  100874:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  100879:	e9 08 01 00 00       	jmp    100986 <debuginfo_eip+0x328>
           && stabs[lline].n_type != N_SOL
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
        lline --;
  10087e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100881:	48                   	dec    %eax
  100882:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    while (lline >= lfile
  100885:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  100888:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10088b:	39 c2                	cmp    %eax,%edx
  10088d:	7c 56                	jl     1008e5 <debuginfo_eip+0x287>
           && stabs[lline].n_type != N_SOL
  10088f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100892:	89 c2                	mov    %eax,%edx
  100894:	89 d0                	mov    %edx,%eax
  100896:	01 c0                	add    %eax,%eax
  100898:	01 d0                	add    %edx,%eax
  10089a:	c1 e0 02             	shl    $0x2,%eax
  10089d:	89 c2                	mov    %eax,%edx
  10089f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1008a2:	01 d0                	add    %edx,%eax
  1008a4:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  1008a8:	3c 84                	cmp    $0x84,%al
  1008aa:	74 39                	je     1008e5 <debuginfo_eip+0x287>
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
  1008ac:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1008af:	89 c2                	mov    %eax,%edx
  1008b1:	89 d0                	mov    %edx,%eax
  1008b3:	01 c0                	add    %eax,%eax
  1008b5:	01 d0                	add    %edx,%eax
  1008b7:	c1 e0 02             	shl    $0x2,%eax
  1008ba:	89 c2                	mov    %eax,%edx
  1008bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1008bf:	01 d0                	add    %edx,%eax
  1008c1:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  1008c5:	3c 64                	cmp    $0x64,%al
  1008c7:	75 b5                	jne    10087e <debuginfo_eip+0x220>
  1008c9:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1008cc:	89 c2                	mov    %eax,%edx
  1008ce:	89 d0                	mov    %edx,%eax
  1008d0:	01 c0                	add    %eax,%eax
  1008d2:	01 d0                	add    %edx,%eax
  1008d4:	c1 e0 02             	shl    $0x2,%eax
  1008d7:	89 c2                	mov    %eax,%edx
  1008d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1008dc:	01 d0                	add    %edx,%eax
  1008de:	8b 40 08             	mov    0x8(%eax),%eax
  1008e1:	85 c0                	test   %eax,%eax
  1008e3:	74 99                	je     10087e <debuginfo_eip+0x220>
    }
    if (lline >= lfile && stabs[lline].n_strx < stabstr_end - stabstr) {
  1008e5:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  1008e8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1008eb:	39 c2                	cmp    %eax,%edx
  1008ed:	7c 42                	jl     100931 <debuginfo_eip+0x2d3>
  1008ef:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1008f2:	89 c2                	mov    %eax,%edx
  1008f4:	89 d0                	mov    %edx,%eax
  1008f6:	01 c0                	add    %eax,%eax
  1008f8:	01 d0                	add    %edx,%eax
  1008fa:	c1 e0 02             	shl    $0x2,%eax
  1008fd:	89 c2                	mov    %eax,%edx
  1008ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100902:	01 d0                	add    %edx,%eax
  100904:	8b 10                	mov    (%eax),%edx
  100906:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100909:	2b 45 ec             	sub    -0x14(%ebp),%eax
  10090c:	39 c2                	cmp    %eax,%edx
  10090e:	73 21                	jae    100931 <debuginfo_eip+0x2d3>
        info->eip_file = stabstr + stabs[lline].n_strx;
  100910:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100913:	89 c2                	mov    %eax,%edx
  100915:	89 d0                	mov    %edx,%eax
  100917:	01 c0                	add    %eax,%eax
  100919:	01 d0                	add    %edx,%eax
  10091b:	c1 e0 02             	shl    $0x2,%eax
  10091e:	89 c2                	mov    %eax,%edx
  100920:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100923:	01 d0                	add    %edx,%eax
  100925:	8b 10                	mov    (%eax),%edx
  100927:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10092a:	01 c2                	add    %eax,%edx
  10092c:	8b 45 0c             	mov    0xc(%ebp),%eax
  10092f:	89 10                	mov    %edx,(%eax)
    }

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
  100931:	8b 55 dc             	mov    -0x24(%ebp),%edx
  100934:	8b 45 d8             	mov    -0x28(%ebp),%eax
  100937:	39 c2                	cmp    %eax,%edx
  100939:	7d 46                	jge    100981 <debuginfo_eip+0x323>
        for (lline = lfun + 1;
  10093b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10093e:	40                   	inc    %eax
  10093f:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  100942:	eb 16                	jmp    10095a <debuginfo_eip+0x2fc>
             lline < rfun && stabs[lline].n_type == N_PSYM;
             lline ++) {
            info->eip_fn_narg ++;
  100944:	8b 45 0c             	mov    0xc(%ebp),%eax
  100947:	8b 40 14             	mov    0x14(%eax),%eax
  10094a:	8d 50 01             	lea    0x1(%eax),%edx
  10094d:	8b 45 0c             	mov    0xc(%ebp),%eax
  100950:	89 50 14             	mov    %edx,0x14(%eax)
             lline ++) {
  100953:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100956:	40                   	inc    %eax
  100957:	89 45 d4             	mov    %eax,-0x2c(%ebp)
             lline < rfun && stabs[lline].n_type == N_PSYM;
  10095a:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  10095d:	8b 45 d8             	mov    -0x28(%ebp),%eax
        for (lline = lfun + 1;
  100960:	39 c2                	cmp    %eax,%edx
  100962:	7d 1d                	jge    100981 <debuginfo_eip+0x323>
             lline < rfun && stabs[lline].n_type == N_PSYM;
  100964:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100967:	89 c2                	mov    %eax,%edx
  100969:	89 d0                	mov    %edx,%eax
  10096b:	01 c0                	add    %eax,%eax
  10096d:	01 d0                	add    %edx,%eax
  10096f:	c1 e0 02             	shl    $0x2,%eax
  100972:	89 c2                	mov    %eax,%edx
  100974:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100977:	01 d0                	add    %edx,%eax
  100979:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  10097d:	3c a0                	cmp    $0xa0,%al
  10097f:	74 c3                	je     100944 <debuginfo_eip+0x2e6>
        }
    }
    return 0;
  100981:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100986:	c9                   	leave  
  100987:	c3                   	ret    

00100988 <print_kerninfo>:
 * print_kerninfo - print the information about kernel, including the location
 * of kernel entry, the start addresses of data and text segements, the start
 * address of free memory and how many memory that kernel has used.
 * */
void
print_kerninfo(void) {
  100988:	f3 0f 1e fb          	endbr32 
  10098c:	55                   	push   %ebp
  10098d:	89 e5                	mov    %esp,%ebp
  10098f:	83 ec 18             	sub    $0x18,%esp
    extern char etext[], edata[], end[], kern_init[];
    cprintf("Special kernel symbols:\n");
  100992:	c7 04 24 22 79 10 00 	movl   $0x107922,(%esp)
  100999:	e8 27 f9 ff ff       	call   1002c5 <cprintf>
    cprintf("  entry  0x%08x (phys)\n", kern_init);
  10099e:	c7 44 24 04 36 00 10 	movl   $0x100036,0x4(%esp)
  1009a5:	00 
  1009a6:	c7 04 24 3b 79 10 00 	movl   $0x10793b,(%esp)
  1009ad:	e8 13 f9 ff ff       	call   1002c5 <cprintf>
    cprintf("  etext  0x%08x (phys)\n", etext);
  1009b2:	c7 44 24 04 06 78 10 	movl   $0x107806,0x4(%esp)
  1009b9:	00 
  1009ba:	c7 04 24 53 79 10 00 	movl   $0x107953,(%esp)
  1009c1:	e8 ff f8 ff ff       	call   1002c5 <cprintf>
    cprintf("  edata  0x%08x (phys)\n", edata);
  1009c6:	c7 44 24 04 36 da 11 	movl   $0x11da36,0x4(%esp)
  1009cd:	00 
  1009ce:	c7 04 24 6b 79 10 00 	movl   $0x10796b,(%esp)
  1009d5:	e8 eb f8 ff ff       	call   1002c5 <cprintf>
    cprintf("  end    0x%08x (phys)\n", end);
  1009da:	c7 44 24 04 84 10 32 	movl   $0x321084,0x4(%esp)
  1009e1:	00 
  1009e2:	c7 04 24 83 79 10 00 	movl   $0x107983,(%esp)
  1009e9:	e8 d7 f8 ff ff       	call   1002c5 <cprintf>
    cprintf("Kernel executable memory footprint: %dKB\n", (end - kern_init + 1023)/1024);
  1009ee:	b8 84 10 32 00       	mov    $0x321084,%eax
  1009f3:	2d 36 00 10 00       	sub    $0x100036,%eax
  1009f8:	05 ff 03 00 00       	add    $0x3ff,%eax
  1009fd:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
  100a03:	85 c0                	test   %eax,%eax
  100a05:	0f 48 c2             	cmovs  %edx,%eax
  100a08:	c1 f8 0a             	sar    $0xa,%eax
  100a0b:	89 44 24 04          	mov    %eax,0x4(%esp)
  100a0f:	c7 04 24 9c 79 10 00 	movl   $0x10799c,(%esp)
  100a16:	e8 aa f8 ff ff       	call   1002c5 <cprintf>
}
  100a1b:	90                   	nop
  100a1c:	c9                   	leave  
  100a1d:	c3                   	ret    

00100a1e <print_debuginfo>:
/* *
 * print_debuginfo - read and print the stat information for the address @eip,
 * and info.eip_fn_addr should be the first address of the related function.
 * */
void
print_debuginfo(uintptr_t eip) {
  100a1e:	f3 0f 1e fb          	endbr32 
  100a22:	55                   	push   %ebp
  100a23:	89 e5                	mov    %esp,%ebp
  100a25:	81 ec 48 01 00 00    	sub    $0x148,%esp
    struct eipdebuginfo info;
    if (debuginfo_eip(eip, &info) != 0) {
  100a2b:	8d 45 dc             	lea    -0x24(%ebp),%eax
  100a2e:	89 44 24 04          	mov    %eax,0x4(%esp)
  100a32:	8b 45 08             	mov    0x8(%ebp),%eax
  100a35:	89 04 24             	mov    %eax,(%esp)
  100a38:	e8 21 fc ff ff       	call   10065e <debuginfo_eip>
  100a3d:	85 c0                	test   %eax,%eax
  100a3f:	74 15                	je     100a56 <print_debuginfo+0x38>
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
  100a41:	8b 45 08             	mov    0x8(%ebp),%eax
  100a44:	89 44 24 04          	mov    %eax,0x4(%esp)
  100a48:	c7 04 24 c6 79 10 00 	movl   $0x1079c6,(%esp)
  100a4f:	e8 71 f8 ff ff       	call   1002c5 <cprintf>
        }
        fnname[j] = '\0';
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
                fnname, eip - info.eip_fn_addr);
    }
}
  100a54:	eb 6c                	jmp    100ac2 <print_debuginfo+0xa4>
        for (j = 0; j < info.eip_fn_namelen; j ++) {
  100a56:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  100a5d:	eb 1b                	jmp    100a7a <print_debuginfo+0x5c>
            fnname[j] = info.eip_fn_name[j];
  100a5f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  100a62:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100a65:	01 d0                	add    %edx,%eax
  100a67:	0f b6 10             	movzbl (%eax),%edx
  100a6a:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
  100a70:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100a73:	01 c8                	add    %ecx,%eax
  100a75:	88 10                	mov    %dl,(%eax)
        for (j = 0; j < info.eip_fn_namelen; j ++) {
  100a77:	ff 45 f4             	incl   -0xc(%ebp)
  100a7a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100a7d:	39 45 f4             	cmp    %eax,-0xc(%ebp)
  100a80:	7c dd                	jl     100a5f <print_debuginfo+0x41>
        fnname[j] = '\0';
  100a82:	8d 95 dc fe ff ff    	lea    -0x124(%ebp),%edx
  100a88:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100a8b:	01 d0                	add    %edx,%eax
  100a8d:	c6 00 00             	movb   $0x0,(%eax)
                fnname, eip - info.eip_fn_addr);
  100a90:	8b 45 ec             	mov    -0x14(%ebp),%eax
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
  100a93:	8b 55 08             	mov    0x8(%ebp),%edx
  100a96:	89 d1                	mov    %edx,%ecx
  100a98:	29 c1                	sub    %eax,%ecx
  100a9a:	8b 55 e0             	mov    -0x20(%ebp),%edx
  100a9d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100aa0:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  100aa4:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
  100aaa:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  100aae:	89 54 24 08          	mov    %edx,0x8(%esp)
  100ab2:	89 44 24 04          	mov    %eax,0x4(%esp)
  100ab6:	c7 04 24 e2 79 10 00 	movl   $0x1079e2,(%esp)
  100abd:	e8 03 f8 ff ff       	call   1002c5 <cprintf>
}
  100ac2:	90                   	nop
  100ac3:	c9                   	leave  
  100ac4:	c3                   	ret    

00100ac5 <read_eip>:

static __noinline uint32_t
read_eip(void) {
  100ac5:	f3 0f 1e fb          	endbr32 
  100ac9:	55                   	push   %ebp
  100aca:	89 e5                	mov    %esp,%ebp
  100acc:	83 ec 10             	sub    $0x10,%esp
    uint32_t eip;
    asm volatile("movl 4(%%ebp), %0" : "=r" (eip));
  100acf:	8b 45 04             	mov    0x4(%ebp),%eax
  100ad2:	89 45 fc             	mov    %eax,-0x4(%ebp)
    return eip;
  100ad5:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  100ad8:	c9                   	leave  
  100ad9:	c3                   	ret    

00100ada <print_stackframe>:
 *
 * Note that, the length of ebp-chain is limited. In boot/bootasm.S, before jumping
 * to the kernel entry, the value of ebp has been set to zero, that's the boundary.
 * */
void
print_stackframe(void) {
  100ada:	f3 0f 1e fb          	endbr32 
  100ade:	55                   	push   %ebp
  100adf:	89 e5                	mov    %esp,%ebp
  100ae1:	83 ec 38             	sub    $0x38,%esp
}

static inline uint32_t
read_ebp(void) {
    uint32_t ebp;
    asm volatile ("movl %%ebp, %0" : "=r" (ebp));
  100ae4:	89 e8                	mov    %ebp,%eax
  100ae6:	89 45 e0             	mov    %eax,-0x20(%ebp)
    return ebp;
  100ae9:	8b 45 e0             	mov    -0x20(%ebp),%eax
      *           NOTICE: the calling funciton's return addr eip  = ss:[ebp+4]
      *                   the calling funciton's ebp = ss:[ebp]
      */

    // 初始化当前ebp和eip
    uint32_t ebp = read_ebp();
  100aec:	89 45 f4             	mov    %eax,-0xc(%ebp)
    uint32_t eip = read_eip();
  100aef:	e8 d1 ff ff ff       	call   100ac5 <read_eip>
  100af4:	89 45 f0             	mov    %eax,-0x10(%ebp)

    // 定义当前深度
    int depth = 0;
  100af7:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)

    // 循环，以至打印到设定的最大堆栈深度
    // ebp == 0，代表着没有更深的函数栈帧了
    for (; ebp != 0 && depth < STACKFRAME_DEPTH; depth ++) {
  100afe:	e9 84 00 00 00       	jmp    100b87 <print_stackframe+0xad>
        // 打印第一行，标识出ebp和eip的值
        cprintf("ebp:0x%08x eip:0x%08x args:", ebp, eip);
  100b03:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100b06:	89 44 24 08          	mov    %eax,0x8(%esp)
  100b0a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100b0d:	89 44 24 04          	mov    %eax,0x4(%esp)
  100b11:	c7 04 24 f4 79 10 00 	movl   $0x1079f4,(%esp)
  100b18:	e8 a8 f7 ff ff       	call   1002c5 <cprintf>
        // 可能的参数存在于ebp底第二个地址
        uint32_t *args = (uint32_t *)ebp + 2;
  100b1d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100b20:	83 c0 08             	add    $0x8,%eax
  100b23:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        // 默认最多打印四个参数
        for (int j = 0; j < 4; j ++) {
  100b26:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  100b2d:	eb 24                	jmp    100b53 <print_stackframe+0x79>
            cprintf("0x%08x ", args[j]);
  100b2f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100b32:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  100b39:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  100b3c:	01 d0                	add    %edx,%eax
  100b3e:	8b 00                	mov    (%eax),%eax
  100b40:	89 44 24 04          	mov    %eax,0x4(%esp)
  100b44:	c7 04 24 10 7a 10 00 	movl   $0x107a10,(%esp)
  100b4b:	e8 75 f7 ff ff       	call   1002c5 <cprintf>
        for (int j = 0; j < 4; j ++) {
  100b50:	ff 45 e8             	incl   -0x18(%ebp)
  100b53:	83 7d e8 03          	cmpl   $0x3,-0x18(%ebp)
  100b57:	7e d6                	jle    100b2f <print_stackframe+0x55>
        }
        cprintf("\n");
  100b59:	c7 04 24 18 7a 10 00 	movl   $0x107a18,(%esp)
  100b60:	e8 60 f7 ff ff       	call   1002c5 <cprintf>
        // 能够查找到对应的函数相关信息，包括函数名，所在文件的行号等
        // eip - 1
        print_debuginfo(eip - 1);
  100b65:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100b68:	48                   	dec    %eax
  100b69:	89 04 24             	mov    %eax,(%esp)
  100b6c:	e8 ad fe ff ff       	call   100a1e <print_debuginfo>
        // 将eip赋为栈底的返回地址，edp赋为其存放的地址中的值
        eip = ((uint32_t *)ebp)[1];
  100b71:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100b74:	83 c0 04             	add    $0x4,%eax
  100b77:	8b 00                	mov    (%eax),%eax
  100b79:	89 45 f0             	mov    %eax,-0x10(%ebp)
        ebp = ((uint32_t *)ebp)[0];
  100b7c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100b7f:	8b 00                	mov    (%eax),%eax
  100b81:	89 45 f4             	mov    %eax,-0xc(%ebp)
    for (; ebp != 0 && depth < STACKFRAME_DEPTH; depth ++) {
  100b84:	ff 45 ec             	incl   -0x14(%ebp)
  100b87:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  100b8b:	74 0a                	je     100b97 <print_stackframe+0xbd>
  100b8d:	83 7d ec 13          	cmpl   $0x13,-0x14(%ebp)
  100b91:	0f 8e 6c ff ff ff    	jle    100b03 <print_stackframe+0x29>
    }
}
  100b97:	90                   	nop
  100b98:	c9                   	leave  
  100b99:	c3                   	ret    

00100b9a <parse>:
#define MAXARGS         16
#define WHITESPACE      " \t\n\r"

/* parse - parse the command buffer into whitespace-separated arguments */
static int
parse(char *buf, char **argv) {
  100b9a:	f3 0f 1e fb          	endbr32 
  100b9e:	55                   	push   %ebp
  100b9f:	89 e5                	mov    %esp,%ebp
  100ba1:	83 ec 28             	sub    $0x28,%esp
    int argc = 0;
  100ba4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100bab:	eb 0c                	jmp    100bb9 <parse+0x1f>
            *buf ++ = '\0';
  100bad:	8b 45 08             	mov    0x8(%ebp),%eax
  100bb0:	8d 50 01             	lea    0x1(%eax),%edx
  100bb3:	89 55 08             	mov    %edx,0x8(%ebp)
  100bb6:	c6 00 00             	movb   $0x0,(%eax)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100bb9:	8b 45 08             	mov    0x8(%ebp),%eax
  100bbc:	0f b6 00             	movzbl (%eax),%eax
  100bbf:	84 c0                	test   %al,%al
  100bc1:	74 1d                	je     100be0 <parse+0x46>
  100bc3:	8b 45 08             	mov    0x8(%ebp),%eax
  100bc6:	0f b6 00             	movzbl (%eax),%eax
  100bc9:	0f be c0             	movsbl %al,%eax
  100bcc:	89 44 24 04          	mov    %eax,0x4(%esp)
  100bd0:	c7 04 24 9c 7a 10 00 	movl   $0x107a9c,(%esp)
  100bd7:	e8 44 62 00 00       	call   106e20 <strchr>
  100bdc:	85 c0                	test   %eax,%eax
  100bde:	75 cd                	jne    100bad <parse+0x13>
        }
        if (*buf == '\0') {
  100be0:	8b 45 08             	mov    0x8(%ebp),%eax
  100be3:	0f b6 00             	movzbl (%eax),%eax
  100be6:	84 c0                	test   %al,%al
  100be8:	74 65                	je     100c4f <parse+0xb5>
            break;
        }

        // save and scan past next arg
        if (argc == MAXARGS - 1) {
  100bea:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
  100bee:	75 14                	jne    100c04 <parse+0x6a>
            cprintf("Too many arguments (max %d).\n", MAXARGS);
  100bf0:	c7 44 24 04 10 00 00 	movl   $0x10,0x4(%esp)
  100bf7:	00 
  100bf8:	c7 04 24 a1 7a 10 00 	movl   $0x107aa1,(%esp)
  100bff:	e8 c1 f6 ff ff       	call   1002c5 <cprintf>
        }
        argv[argc ++] = buf;
  100c04:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100c07:	8d 50 01             	lea    0x1(%eax),%edx
  100c0a:	89 55 f4             	mov    %edx,-0xc(%ebp)
  100c0d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  100c14:	8b 45 0c             	mov    0xc(%ebp),%eax
  100c17:	01 c2                	add    %eax,%edx
  100c19:	8b 45 08             	mov    0x8(%ebp),%eax
  100c1c:	89 02                	mov    %eax,(%edx)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
  100c1e:	eb 03                	jmp    100c23 <parse+0x89>
            buf ++;
  100c20:	ff 45 08             	incl   0x8(%ebp)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
  100c23:	8b 45 08             	mov    0x8(%ebp),%eax
  100c26:	0f b6 00             	movzbl (%eax),%eax
  100c29:	84 c0                	test   %al,%al
  100c2b:	74 8c                	je     100bb9 <parse+0x1f>
  100c2d:	8b 45 08             	mov    0x8(%ebp),%eax
  100c30:	0f b6 00             	movzbl (%eax),%eax
  100c33:	0f be c0             	movsbl %al,%eax
  100c36:	89 44 24 04          	mov    %eax,0x4(%esp)
  100c3a:	c7 04 24 9c 7a 10 00 	movl   $0x107a9c,(%esp)
  100c41:	e8 da 61 00 00       	call   106e20 <strchr>
  100c46:	85 c0                	test   %eax,%eax
  100c48:	74 d6                	je     100c20 <parse+0x86>
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100c4a:	e9 6a ff ff ff       	jmp    100bb9 <parse+0x1f>
            break;
  100c4f:	90                   	nop
        }
    }
    return argc;
  100c50:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  100c53:	c9                   	leave  
  100c54:	c3                   	ret    

00100c55 <runcmd>:
/* *
 * runcmd - parse the input string, split it into separated arguments
 * and then lookup and invoke some related commands/
 * */
static int
runcmd(char *buf, struct trapframe *tf) {
  100c55:	f3 0f 1e fb          	endbr32 
  100c59:	55                   	push   %ebp
  100c5a:	89 e5                	mov    %esp,%ebp
  100c5c:	53                   	push   %ebx
  100c5d:	83 ec 64             	sub    $0x64,%esp
    char *argv[MAXARGS];
    int argc = parse(buf, argv);
  100c60:	8d 45 b0             	lea    -0x50(%ebp),%eax
  100c63:	89 44 24 04          	mov    %eax,0x4(%esp)
  100c67:	8b 45 08             	mov    0x8(%ebp),%eax
  100c6a:	89 04 24             	mov    %eax,(%esp)
  100c6d:	e8 28 ff ff ff       	call   100b9a <parse>
  100c72:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if (argc == 0) {
  100c75:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  100c79:	75 0a                	jne    100c85 <runcmd+0x30>
        return 0;
  100c7b:	b8 00 00 00 00       	mov    $0x0,%eax
  100c80:	e9 83 00 00 00       	jmp    100d08 <runcmd+0xb3>
    }
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100c85:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  100c8c:	eb 5a                	jmp    100ce8 <runcmd+0x93>
        if (strcmp(commands[i].name, argv[0]) == 0) {
  100c8e:	8b 4d b0             	mov    -0x50(%ebp),%ecx
  100c91:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100c94:	89 d0                	mov    %edx,%eax
  100c96:	01 c0                	add    %eax,%eax
  100c98:	01 d0                	add    %edx,%eax
  100c9a:	c1 e0 02             	shl    $0x2,%eax
  100c9d:	05 00 d0 11 00       	add    $0x11d000,%eax
  100ca2:	8b 00                	mov    (%eax),%eax
  100ca4:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  100ca8:	89 04 24             	mov    %eax,(%esp)
  100cab:	e8 cc 60 00 00       	call   106d7c <strcmp>
  100cb0:	85 c0                	test   %eax,%eax
  100cb2:	75 31                	jne    100ce5 <runcmd+0x90>
            return commands[i].func(argc - 1, argv + 1, tf);
  100cb4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100cb7:	89 d0                	mov    %edx,%eax
  100cb9:	01 c0                	add    %eax,%eax
  100cbb:	01 d0                	add    %edx,%eax
  100cbd:	c1 e0 02             	shl    $0x2,%eax
  100cc0:	05 08 d0 11 00       	add    $0x11d008,%eax
  100cc5:	8b 10                	mov    (%eax),%edx
  100cc7:	8d 45 b0             	lea    -0x50(%ebp),%eax
  100cca:	83 c0 04             	add    $0x4,%eax
  100ccd:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  100cd0:	8d 59 ff             	lea    -0x1(%ecx),%ebx
  100cd3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  100cd6:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  100cda:	89 44 24 04          	mov    %eax,0x4(%esp)
  100cde:	89 1c 24             	mov    %ebx,(%esp)
  100ce1:	ff d2                	call   *%edx
  100ce3:	eb 23                	jmp    100d08 <runcmd+0xb3>
    for (i = 0; i < NCOMMANDS; i ++) {
  100ce5:	ff 45 f4             	incl   -0xc(%ebp)
  100ce8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100ceb:	83 f8 02             	cmp    $0x2,%eax
  100cee:	76 9e                	jbe    100c8e <runcmd+0x39>
        }
    }
    cprintf("Unknown command '%s'\n", argv[0]);
  100cf0:	8b 45 b0             	mov    -0x50(%ebp),%eax
  100cf3:	89 44 24 04          	mov    %eax,0x4(%esp)
  100cf7:	c7 04 24 bf 7a 10 00 	movl   $0x107abf,(%esp)
  100cfe:	e8 c2 f5 ff ff       	call   1002c5 <cprintf>
    return 0;
  100d03:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100d08:	83 c4 64             	add    $0x64,%esp
  100d0b:	5b                   	pop    %ebx
  100d0c:	5d                   	pop    %ebp
  100d0d:	c3                   	ret    

00100d0e <kmonitor>:

/***** Implementations of basic kernel monitor commands *****/

void
kmonitor(struct trapframe *tf) {
  100d0e:	f3 0f 1e fb          	endbr32 
  100d12:	55                   	push   %ebp
  100d13:	89 e5                	mov    %esp,%ebp
  100d15:	83 ec 28             	sub    $0x28,%esp
    cprintf("Welcome to the kernel debug monitor!!\n");
  100d18:	c7 04 24 d8 7a 10 00 	movl   $0x107ad8,(%esp)
  100d1f:	e8 a1 f5 ff ff       	call   1002c5 <cprintf>
    cprintf("Type 'help' for a list of commands.\n");
  100d24:	c7 04 24 00 7b 10 00 	movl   $0x107b00,(%esp)
  100d2b:	e8 95 f5 ff ff       	call   1002c5 <cprintf>

    if (tf != NULL) {
  100d30:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  100d34:	74 0b                	je     100d41 <kmonitor+0x33>
        print_trapframe(tf);
  100d36:	8b 45 08             	mov    0x8(%ebp),%eax
  100d39:	89 04 24             	mov    %eax,(%esp)
  100d3c:	e8 5d 0e 00 00       	call   101b9e <print_trapframe>
    }

    char *buf;
    while (1) {
        if ((buf = readline("K> ")) != NULL) {
  100d41:	c7 04 24 25 7b 10 00 	movl   $0x107b25,(%esp)
  100d48:	e8 2b f6 ff ff       	call   100378 <readline>
  100d4d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  100d50:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  100d54:	74 eb                	je     100d41 <kmonitor+0x33>
            if (runcmd(buf, tf) < 0) {
  100d56:	8b 45 08             	mov    0x8(%ebp),%eax
  100d59:	89 44 24 04          	mov    %eax,0x4(%esp)
  100d5d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100d60:	89 04 24             	mov    %eax,(%esp)
  100d63:	e8 ed fe ff ff       	call   100c55 <runcmd>
  100d68:	85 c0                	test   %eax,%eax
  100d6a:	78 02                	js     100d6e <kmonitor+0x60>
        if ((buf = readline("K> ")) != NULL) {
  100d6c:	eb d3                	jmp    100d41 <kmonitor+0x33>
                break;
  100d6e:	90                   	nop
            }
        }
    }
}
  100d6f:	90                   	nop
  100d70:	c9                   	leave  
  100d71:	c3                   	ret    

00100d72 <mon_help>:

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
  100d72:	f3 0f 1e fb          	endbr32 
  100d76:	55                   	push   %ebp
  100d77:	89 e5                	mov    %esp,%ebp
  100d79:	83 ec 28             	sub    $0x28,%esp
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100d7c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  100d83:	eb 3d                	jmp    100dc2 <mon_help+0x50>
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
  100d85:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100d88:	89 d0                	mov    %edx,%eax
  100d8a:	01 c0                	add    %eax,%eax
  100d8c:	01 d0                	add    %edx,%eax
  100d8e:	c1 e0 02             	shl    $0x2,%eax
  100d91:	05 04 d0 11 00       	add    $0x11d004,%eax
  100d96:	8b 08                	mov    (%eax),%ecx
  100d98:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100d9b:	89 d0                	mov    %edx,%eax
  100d9d:	01 c0                	add    %eax,%eax
  100d9f:	01 d0                	add    %edx,%eax
  100da1:	c1 e0 02             	shl    $0x2,%eax
  100da4:	05 00 d0 11 00       	add    $0x11d000,%eax
  100da9:	8b 00                	mov    (%eax),%eax
  100dab:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  100daf:	89 44 24 04          	mov    %eax,0x4(%esp)
  100db3:	c7 04 24 29 7b 10 00 	movl   $0x107b29,(%esp)
  100dba:	e8 06 f5 ff ff       	call   1002c5 <cprintf>
    for (i = 0; i < NCOMMANDS; i ++) {
  100dbf:	ff 45 f4             	incl   -0xc(%ebp)
  100dc2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100dc5:	83 f8 02             	cmp    $0x2,%eax
  100dc8:	76 bb                	jbe    100d85 <mon_help+0x13>
    }
    return 0;
  100dca:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100dcf:	c9                   	leave  
  100dd0:	c3                   	ret    

00100dd1 <mon_kerninfo>:
/* *
 * mon_kerninfo - call print_kerninfo in kern/debug/kdebug.c to
 * print the memory occupancy in kernel.
 * */
int
mon_kerninfo(int argc, char **argv, struct trapframe *tf) {
  100dd1:	f3 0f 1e fb          	endbr32 
  100dd5:	55                   	push   %ebp
  100dd6:	89 e5                	mov    %esp,%ebp
  100dd8:	83 ec 08             	sub    $0x8,%esp
    print_kerninfo();
  100ddb:	e8 a8 fb ff ff       	call   100988 <print_kerninfo>
    return 0;
  100de0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100de5:	c9                   	leave  
  100de6:	c3                   	ret    

00100de7 <mon_backtrace>:
/* *
 * mon_backtrace - call print_stackframe in kern/debug/kdebug.c to
 * print a backtrace of the stack.
 * */
int
mon_backtrace(int argc, char **argv, struct trapframe *tf) {
  100de7:	f3 0f 1e fb          	endbr32 
  100deb:	55                   	push   %ebp
  100dec:	89 e5                	mov    %esp,%ebp
  100dee:	83 ec 08             	sub    $0x8,%esp
    print_stackframe();
  100df1:	e8 e4 fc ff ff       	call   100ada <print_stackframe>
    return 0;
  100df6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100dfb:	c9                   	leave  
  100dfc:	c3                   	ret    

00100dfd <clock_init>:
/* *
 * clock_init - initialize 8253 clock to interrupt 100 times per second,
 * and then enable IRQ_TIMER.
 * */
void
clock_init(void) {
  100dfd:	f3 0f 1e fb          	endbr32 
  100e01:	55                   	push   %ebp
  100e02:	89 e5                	mov    %esp,%ebp
  100e04:	83 ec 28             	sub    $0x28,%esp
  100e07:	66 c7 45 ee 43 00    	movw   $0x43,-0x12(%ebp)
  100e0d:	c6 45 ed 34          	movb   $0x34,-0x13(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  100e11:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  100e15:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  100e19:	ee                   	out    %al,(%dx)
}
  100e1a:	90                   	nop
  100e1b:	66 c7 45 f2 40 00    	movw   $0x40,-0xe(%ebp)
  100e21:	c6 45 f1 9c          	movb   $0x9c,-0xf(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  100e25:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  100e29:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  100e2d:	ee                   	out    %al,(%dx)
}
  100e2e:	90                   	nop
  100e2f:	66 c7 45 f6 40 00    	movw   $0x40,-0xa(%ebp)
  100e35:	c6 45 f5 2e          	movb   $0x2e,-0xb(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  100e39:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  100e3d:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  100e41:	ee                   	out    %al,(%dx)
}
  100e42:	90                   	nop
    outb(TIMER_MODE, TIMER_SEL0 | TIMER_RATEGEN | TIMER_16BIT);
    outb(IO_TIMER1, TIMER_DIV(100) % 256);
    outb(IO_TIMER1, TIMER_DIV(100) / 256);

    // initialize time counter 'ticks' to zero
    ticks = 0;
  100e43:	c7 05 0c 0f 12 00 00 	movl   $0x0,0x120f0c
  100e4a:	00 00 00 

    cprintf("++ setup timer interrupts\n");
  100e4d:	c7 04 24 32 7b 10 00 	movl   $0x107b32,(%esp)
  100e54:	e8 6c f4 ff ff       	call   1002c5 <cprintf>
    pic_enable(IRQ_TIMER);
  100e59:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  100e60:	e8 95 09 00 00       	call   1017fa <pic_enable>
}
  100e65:	90                   	nop
  100e66:	c9                   	leave  
  100e67:	c3                   	ret    

00100e68 <__intr_save>:
#include <x86.h>
#include <intr.h>
#include <mmu.h>

static inline bool
__intr_save(void) {
  100e68:	55                   	push   %ebp
  100e69:	89 e5                	mov    %esp,%ebp
  100e6b:	83 ec 18             	sub    $0x18,%esp
}

static inline uint32_t
read_eflags(void) {
    uint32_t eflags;
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
  100e6e:	9c                   	pushf  
  100e6f:	58                   	pop    %eax
  100e70:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return eflags;
  100e73:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
  100e76:	25 00 02 00 00       	and    $0x200,%eax
  100e7b:	85 c0                	test   %eax,%eax
  100e7d:	74 0c                	je     100e8b <__intr_save+0x23>
        intr_disable();
  100e7f:	e8 05 0b 00 00       	call   101989 <intr_disable>
        return 1;
  100e84:	b8 01 00 00 00       	mov    $0x1,%eax
  100e89:	eb 05                	jmp    100e90 <__intr_save+0x28>
    }
    return 0;
  100e8b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100e90:	c9                   	leave  
  100e91:	c3                   	ret    

00100e92 <__intr_restore>:

static inline void
__intr_restore(bool flag) {
  100e92:	55                   	push   %ebp
  100e93:	89 e5                	mov    %esp,%ebp
  100e95:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
  100e98:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  100e9c:	74 05                	je     100ea3 <__intr_restore+0x11>
        intr_enable();
  100e9e:	e8 da 0a 00 00       	call   10197d <intr_enable>
    }
}
  100ea3:	90                   	nop
  100ea4:	c9                   	leave  
  100ea5:	c3                   	ret    

00100ea6 <delay>:
#include <memlayout.h>
#include <sync.h>

/* stupid I/O delay routine necessitated by historical PC design flaws */
static void
delay(void) {
  100ea6:	f3 0f 1e fb          	endbr32 
  100eaa:	55                   	push   %ebp
  100eab:	89 e5                	mov    %esp,%ebp
  100ead:	83 ec 10             	sub    $0x10,%esp
  100eb0:	66 c7 45 f2 84 00    	movw   $0x84,-0xe(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  100eb6:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  100eba:	89 c2                	mov    %eax,%edx
  100ebc:	ec                   	in     (%dx),%al
  100ebd:	88 45 f1             	mov    %al,-0xf(%ebp)
  100ec0:	66 c7 45 f6 84 00    	movw   $0x84,-0xa(%ebp)
  100ec6:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  100eca:	89 c2                	mov    %eax,%edx
  100ecc:	ec                   	in     (%dx),%al
  100ecd:	88 45 f5             	mov    %al,-0xb(%ebp)
  100ed0:	66 c7 45 fa 84 00    	movw   $0x84,-0x6(%ebp)
  100ed6:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  100eda:	89 c2                	mov    %eax,%edx
  100edc:	ec                   	in     (%dx),%al
  100edd:	88 45 f9             	mov    %al,-0x7(%ebp)
  100ee0:	66 c7 45 fe 84 00    	movw   $0x84,-0x2(%ebp)
  100ee6:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
  100eea:	89 c2                	mov    %eax,%edx
  100eec:	ec                   	in     (%dx),%al
  100eed:	88 45 fd             	mov    %al,-0x3(%ebp)
    inb(0x84);
    inb(0x84);
    inb(0x84);
    inb(0x84);
}
  100ef0:	90                   	nop
  100ef1:	c9                   	leave  
  100ef2:	c3                   	ret    

00100ef3 <cga_init>:
static uint16_t addr_6845;

/* TEXT-mode CGA/VGA display output */

static void
cga_init(void) {
  100ef3:	f3 0f 1e fb          	endbr32 
  100ef7:	55                   	push   %ebp
  100ef8:	89 e5                	mov    %esp,%ebp
  100efa:	83 ec 20             	sub    $0x20,%esp
    volatile uint16_t *cp = (uint16_t *)(CGA_BUF + KERNBASE);
  100efd:	c7 45 fc 00 80 0b c0 	movl   $0xc00b8000,-0x4(%ebp)
    uint16_t was = *cp;
  100f04:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100f07:	0f b7 00             	movzwl (%eax),%eax
  100f0a:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
    *cp = (uint16_t) 0xA55A;
  100f0e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100f11:	66 c7 00 5a a5       	movw   $0xa55a,(%eax)
    if (*cp != 0xA55A) {
  100f16:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100f19:	0f b7 00             	movzwl (%eax),%eax
  100f1c:	0f b7 c0             	movzwl %ax,%eax
  100f1f:	3d 5a a5 00 00       	cmp    $0xa55a,%eax
  100f24:	74 12                	je     100f38 <cga_init+0x45>
        cp = (uint16_t*)(MONO_BUF + KERNBASE);
  100f26:	c7 45 fc 00 00 0b c0 	movl   $0xc00b0000,-0x4(%ebp)
        addr_6845 = MONO_BASE;
  100f2d:	66 c7 05 46 04 12 00 	movw   $0x3b4,0x120446
  100f34:	b4 03 
  100f36:	eb 13                	jmp    100f4b <cga_init+0x58>
    } else {
        *cp = was;
  100f38:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100f3b:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  100f3f:	66 89 10             	mov    %dx,(%eax)
        addr_6845 = CGA_BASE;
  100f42:	66 c7 05 46 04 12 00 	movw   $0x3d4,0x120446
  100f49:	d4 03 
    }

    // Extract cursor location
    uint32_t pos;
    outb(addr_6845, 14);
  100f4b:	0f b7 05 46 04 12 00 	movzwl 0x120446,%eax
  100f52:	66 89 45 e6          	mov    %ax,-0x1a(%ebp)
  100f56:	c6 45 e5 0e          	movb   $0xe,-0x1b(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  100f5a:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  100f5e:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  100f62:	ee                   	out    %al,(%dx)
}
  100f63:	90                   	nop
    pos = inb(addr_6845 + 1) << 8;
  100f64:	0f b7 05 46 04 12 00 	movzwl 0x120446,%eax
  100f6b:	40                   	inc    %eax
  100f6c:	0f b7 c0             	movzwl %ax,%eax
  100f6f:	66 89 45 ea          	mov    %ax,-0x16(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  100f73:	0f b7 45 ea          	movzwl -0x16(%ebp),%eax
  100f77:	89 c2                	mov    %eax,%edx
  100f79:	ec                   	in     (%dx),%al
  100f7a:	88 45 e9             	mov    %al,-0x17(%ebp)
    return data;
  100f7d:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  100f81:	0f b6 c0             	movzbl %al,%eax
  100f84:	c1 e0 08             	shl    $0x8,%eax
  100f87:	89 45 f4             	mov    %eax,-0xc(%ebp)
    outb(addr_6845, 15);
  100f8a:	0f b7 05 46 04 12 00 	movzwl 0x120446,%eax
  100f91:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
  100f95:	c6 45 ed 0f          	movb   $0xf,-0x13(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  100f99:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  100f9d:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  100fa1:	ee                   	out    %al,(%dx)
}
  100fa2:	90                   	nop
    pos |= inb(addr_6845 + 1);
  100fa3:	0f b7 05 46 04 12 00 	movzwl 0x120446,%eax
  100faa:	40                   	inc    %eax
  100fab:	0f b7 c0             	movzwl %ax,%eax
  100fae:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  100fb2:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  100fb6:	89 c2                	mov    %eax,%edx
  100fb8:	ec                   	in     (%dx),%al
  100fb9:	88 45 f1             	mov    %al,-0xf(%ebp)
    return data;
  100fbc:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  100fc0:	0f b6 c0             	movzbl %al,%eax
  100fc3:	09 45 f4             	or     %eax,-0xc(%ebp)

    crt_buf = (uint16_t*) cp;
  100fc6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100fc9:	a3 40 04 12 00       	mov    %eax,0x120440
    crt_pos = pos;
  100fce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100fd1:	0f b7 c0             	movzwl %ax,%eax
  100fd4:	66 a3 44 04 12 00    	mov    %ax,0x120444
}
  100fda:	90                   	nop
  100fdb:	c9                   	leave  
  100fdc:	c3                   	ret    

00100fdd <serial_init>:

static bool serial_exists = 0;

static void
serial_init(void) {
  100fdd:	f3 0f 1e fb          	endbr32 
  100fe1:	55                   	push   %ebp
  100fe2:	89 e5                	mov    %esp,%ebp
  100fe4:	83 ec 48             	sub    $0x48,%esp
  100fe7:	66 c7 45 d2 fa 03    	movw   $0x3fa,-0x2e(%ebp)
  100fed:	c6 45 d1 00          	movb   $0x0,-0x2f(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  100ff1:	0f b6 45 d1          	movzbl -0x2f(%ebp),%eax
  100ff5:	0f b7 55 d2          	movzwl -0x2e(%ebp),%edx
  100ff9:	ee                   	out    %al,(%dx)
}
  100ffa:	90                   	nop
  100ffb:	66 c7 45 d6 fb 03    	movw   $0x3fb,-0x2a(%ebp)
  101001:	c6 45 d5 80          	movb   $0x80,-0x2b(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  101005:	0f b6 45 d5          	movzbl -0x2b(%ebp),%eax
  101009:	0f b7 55 d6          	movzwl -0x2a(%ebp),%edx
  10100d:	ee                   	out    %al,(%dx)
}
  10100e:	90                   	nop
  10100f:	66 c7 45 da f8 03    	movw   $0x3f8,-0x26(%ebp)
  101015:	c6 45 d9 0c          	movb   $0xc,-0x27(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  101019:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
  10101d:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
  101021:	ee                   	out    %al,(%dx)
}
  101022:	90                   	nop
  101023:	66 c7 45 de f9 03    	movw   $0x3f9,-0x22(%ebp)
  101029:	c6 45 dd 00          	movb   $0x0,-0x23(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  10102d:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
  101031:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
  101035:	ee                   	out    %al,(%dx)
}
  101036:	90                   	nop
  101037:	66 c7 45 e2 fb 03    	movw   $0x3fb,-0x1e(%ebp)
  10103d:	c6 45 e1 03          	movb   $0x3,-0x1f(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  101041:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
  101045:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
  101049:	ee                   	out    %al,(%dx)
}
  10104a:	90                   	nop
  10104b:	66 c7 45 e6 fc 03    	movw   $0x3fc,-0x1a(%ebp)
  101051:	c6 45 e5 00          	movb   $0x0,-0x1b(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  101055:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  101059:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  10105d:	ee                   	out    %al,(%dx)
}
  10105e:	90                   	nop
  10105f:	66 c7 45 ea f9 03    	movw   $0x3f9,-0x16(%ebp)
  101065:	c6 45 e9 01          	movb   $0x1,-0x17(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  101069:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  10106d:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  101071:	ee                   	out    %al,(%dx)
}
  101072:	90                   	nop
  101073:	66 c7 45 ee fd 03    	movw   $0x3fd,-0x12(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  101079:	0f b7 45 ee          	movzwl -0x12(%ebp),%eax
  10107d:	89 c2                	mov    %eax,%edx
  10107f:	ec                   	in     (%dx),%al
  101080:	88 45 ed             	mov    %al,-0x13(%ebp)
    return data;
  101083:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
    // Enable rcv interrupts
    outb(COM1 + COM_IER, COM_IER_RDI);

    // Clear any preexisting overrun indications and interrupts
    // Serial port doesn't exist if COM_LSR returns 0xFF
    serial_exists = (inb(COM1 + COM_LSR) != 0xFF);
  101087:	3c ff                	cmp    $0xff,%al
  101089:	0f 95 c0             	setne  %al
  10108c:	0f b6 c0             	movzbl %al,%eax
  10108f:	a3 48 04 12 00       	mov    %eax,0x120448
  101094:	66 c7 45 f2 fa 03    	movw   $0x3fa,-0xe(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  10109a:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  10109e:	89 c2                	mov    %eax,%edx
  1010a0:	ec                   	in     (%dx),%al
  1010a1:	88 45 f1             	mov    %al,-0xf(%ebp)
  1010a4:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
  1010aa:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  1010ae:	89 c2                	mov    %eax,%edx
  1010b0:	ec                   	in     (%dx),%al
  1010b1:	88 45 f5             	mov    %al,-0xb(%ebp)
    (void) inb(COM1+COM_IIR);
    (void) inb(COM1+COM_RX);

    if (serial_exists) {
  1010b4:	a1 48 04 12 00       	mov    0x120448,%eax
  1010b9:	85 c0                	test   %eax,%eax
  1010bb:	74 0c                	je     1010c9 <serial_init+0xec>
        pic_enable(IRQ_COM1);
  1010bd:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
  1010c4:	e8 31 07 00 00       	call   1017fa <pic_enable>
    }
}
  1010c9:	90                   	nop
  1010ca:	c9                   	leave  
  1010cb:	c3                   	ret    

001010cc <lpt_putc_sub>:

static void
lpt_putc_sub(int c) {
  1010cc:	f3 0f 1e fb          	endbr32 
  1010d0:	55                   	push   %ebp
  1010d1:	89 e5                	mov    %esp,%ebp
  1010d3:	83 ec 20             	sub    $0x20,%esp
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
  1010d6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  1010dd:	eb 08                	jmp    1010e7 <lpt_putc_sub+0x1b>
        delay();
  1010df:	e8 c2 fd ff ff       	call   100ea6 <delay>
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
  1010e4:	ff 45 fc             	incl   -0x4(%ebp)
  1010e7:	66 c7 45 fa 79 03    	movw   $0x379,-0x6(%ebp)
  1010ed:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  1010f1:	89 c2                	mov    %eax,%edx
  1010f3:	ec                   	in     (%dx),%al
  1010f4:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
  1010f7:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  1010fb:	84 c0                	test   %al,%al
  1010fd:	78 09                	js     101108 <lpt_putc_sub+0x3c>
  1010ff:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
  101106:	7e d7                	jle    1010df <lpt_putc_sub+0x13>
    }
    outb(LPTPORT + 0, c);
  101108:	8b 45 08             	mov    0x8(%ebp),%eax
  10110b:	0f b6 c0             	movzbl %al,%eax
  10110e:	66 c7 45 ee 78 03    	movw   $0x378,-0x12(%ebp)
  101114:	88 45 ed             	mov    %al,-0x13(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  101117:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  10111b:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  10111f:	ee                   	out    %al,(%dx)
}
  101120:	90                   	nop
  101121:	66 c7 45 f2 7a 03    	movw   $0x37a,-0xe(%ebp)
  101127:	c6 45 f1 0d          	movb   $0xd,-0xf(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  10112b:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  10112f:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  101133:	ee                   	out    %al,(%dx)
}
  101134:	90                   	nop
  101135:	66 c7 45 f6 7a 03    	movw   $0x37a,-0xa(%ebp)
  10113b:	c6 45 f5 08          	movb   $0x8,-0xb(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  10113f:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  101143:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  101147:	ee                   	out    %al,(%dx)
}
  101148:	90                   	nop
    outb(LPTPORT + 2, 0x08 | 0x04 | 0x01);
    outb(LPTPORT + 2, 0x08);
}
  101149:	90                   	nop
  10114a:	c9                   	leave  
  10114b:	c3                   	ret    

0010114c <lpt_putc>:

/* lpt_putc - copy console output to parallel port */
static void
lpt_putc(int c) {
  10114c:	f3 0f 1e fb          	endbr32 
  101150:	55                   	push   %ebp
  101151:	89 e5                	mov    %esp,%ebp
  101153:	83 ec 04             	sub    $0x4,%esp
    if (c != '\b') {
  101156:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
  10115a:	74 0d                	je     101169 <lpt_putc+0x1d>
        lpt_putc_sub(c);
  10115c:	8b 45 08             	mov    0x8(%ebp),%eax
  10115f:	89 04 24             	mov    %eax,(%esp)
  101162:	e8 65 ff ff ff       	call   1010cc <lpt_putc_sub>
    else {
        lpt_putc_sub('\b');
        lpt_putc_sub(' ');
        lpt_putc_sub('\b');
    }
}
  101167:	eb 24                	jmp    10118d <lpt_putc+0x41>
        lpt_putc_sub('\b');
  101169:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  101170:	e8 57 ff ff ff       	call   1010cc <lpt_putc_sub>
        lpt_putc_sub(' ');
  101175:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  10117c:	e8 4b ff ff ff       	call   1010cc <lpt_putc_sub>
        lpt_putc_sub('\b');
  101181:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  101188:	e8 3f ff ff ff       	call   1010cc <lpt_putc_sub>
}
  10118d:	90                   	nop
  10118e:	c9                   	leave  
  10118f:	c3                   	ret    

00101190 <cga_putc>:

/* cga_putc - print character to console */
static void
cga_putc(int c) {
  101190:	f3 0f 1e fb          	endbr32 
  101194:	55                   	push   %ebp
  101195:	89 e5                	mov    %esp,%ebp
  101197:	53                   	push   %ebx
  101198:	83 ec 34             	sub    $0x34,%esp
    // set black on white
    if (!(c & ~0xFF)) {
  10119b:	8b 45 08             	mov    0x8(%ebp),%eax
  10119e:	25 00 ff ff ff       	and    $0xffffff00,%eax
  1011a3:	85 c0                	test   %eax,%eax
  1011a5:	75 07                	jne    1011ae <cga_putc+0x1e>
        c |= 0x0700;
  1011a7:	81 4d 08 00 07 00 00 	orl    $0x700,0x8(%ebp)
    }

    switch (c & 0xff) {
  1011ae:	8b 45 08             	mov    0x8(%ebp),%eax
  1011b1:	0f b6 c0             	movzbl %al,%eax
  1011b4:	83 f8 0d             	cmp    $0xd,%eax
  1011b7:	74 72                	je     10122b <cga_putc+0x9b>
  1011b9:	83 f8 0d             	cmp    $0xd,%eax
  1011bc:	0f 8f a3 00 00 00    	jg     101265 <cga_putc+0xd5>
  1011c2:	83 f8 08             	cmp    $0x8,%eax
  1011c5:	74 0a                	je     1011d1 <cga_putc+0x41>
  1011c7:	83 f8 0a             	cmp    $0xa,%eax
  1011ca:	74 4c                	je     101218 <cga_putc+0x88>
  1011cc:	e9 94 00 00 00       	jmp    101265 <cga_putc+0xd5>
    case '\b':
        if (crt_pos > 0) {
  1011d1:	0f b7 05 44 04 12 00 	movzwl 0x120444,%eax
  1011d8:	85 c0                	test   %eax,%eax
  1011da:	0f 84 af 00 00 00    	je     10128f <cga_putc+0xff>
            crt_pos --;
  1011e0:	0f b7 05 44 04 12 00 	movzwl 0x120444,%eax
  1011e7:	48                   	dec    %eax
  1011e8:	0f b7 c0             	movzwl %ax,%eax
  1011eb:	66 a3 44 04 12 00    	mov    %ax,0x120444
            crt_buf[crt_pos] = (c & ~0xff) | ' ';
  1011f1:	8b 45 08             	mov    0x8(%ebp),%eax
  1011f4:	98                   	cwtl   
  1011f5:	25 00 ff ff ff       	and    $0xffffff00,%eax
  1011fa:	98                   	cwtl   
  1011fb:	83 c8 20             	or     $0x20,%eax
  1011fe:	98                   	cwtl   
  1011ff:	8b 15 40 04 12 00    	mov    0x120440,%edx
  101205:	0f b7 0d 44 04 12 00 	movzwl 0x120444,%ecx
  10120c:	01 c9                	add    %ecx,%ecx
  10120e:	01 ca                	add    %ecx,%edx
  101210:	0f b7 c0             	movzwl %ax,%eax
  101213:	66 89 02             	mov    %ax,(%edx)
        }
        break;
  101216:	eb 77                	jmp    10128f <cga_putc+0xff>
    case '\n':
        crt_pos += CRT_COLS;
  101218:	0f b7 05 44 04 12 00 	movzwl 0x120444,%eax
  10121f:	83 c0 50             	add    $0x50,%eax
  101222:	0f b7 c0             	movzwl %ax,%eax
  101225:	66 a3 44 04 12 00    	mov    %ax,0x120444
    case '\r':
        crt_pos -= (crt_pos % CRT_COLS);
  10122b:	0f b7 1d 44 04 12 00 	movzwl 0x120444,%ebx
  101232:	0f b7 0d 44 04 12 00 	movzwl 0x120444,%ecx
  101239:	ba cd cc cc cc       	mov    $0xcccccccd,%edx
  10123e:	89 c8                	mov    %ecx,%eax
  101240:	f7 e2                	mul    %edx
  101242:	c1 ea 06             	shr    $0x6,%edx
  101245:	89 d0                	mov    %edx,%eax
  101247:	c1 e0 02             	shl    $0x2,%eax
  10124a:	01 d0                	add    %edx,%eax
  10124c:	c1 e0 04             	shl    $0x4,%eax
  10124f:	29 c1                	sub    %eax,%ecx
  101251:	89 c8                	mov    %ecx,%eax
  101253:	0f b7 c0             	movzwl %ax,%eax
  101256:	29 c3                	sub    %eax,%ebx
  101258:	89 d8                	mov    %ebx,%eax
  10125a:	0f b7 c0             	movzwl %ax,%eax
  10125d:	66 a3 44 04 12 00    	mov    %ax,0x120444
        break;
  101263:	eb 2b                	jmp    101290 <cga_putc+0x100>
    default:
        crt_buf[crt_pos ++] = c;     // write the character
  101265:	8b 0d 40 04 12 00    	mov    0x120440,%ecx
  10126b:	0f b7 05 44 04 12 00 	movzwl 0x120444,%eax
  101272:	8d 50 01             	lea    0x1(%eax),%edx
  101275:	0f b7 d2             	movzwl %dx,%edx
  101278:	66 89 15 44 04 12 00 	mov    %dx,0x120444
  10127f:	01 c0                	add    %eax,%eax
  101281:	8d 14 01             	lea    (%ecx,%eax,1),%edx
  101284:	8b 45 08             	mov    0x8(%ebp),%eax
  101287:	0f b7 c0             	movzwl %ax,%eax
  10128a:	66 89 02             	mov    %ax,(%edx)
        break;
  10128d:	eb 01                	jmp    101290 <cga_putc+0x100>
        break;
  10128f:	90                   	nop
    }

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
  101290:	0f b7 05 44 04 12 00 	movzwl 0x120444,%eax
  101297:	3d cf 07 00 00       	cmp    $0x7cf,%eax
  10129c:	76 5d                	jbe    1012fb <cga_putc+0x16b>
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
  10129e:	a1 40 04 12 00       	mov    0x120440,%eax
  1012a3:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
  1012a9:	a1 40 04 12 00       	mov    0x120440,%eax
  1012ae:	c7 44 24 08 00 0f 00 	movl   $0xf00,0x8(%esp)
  1012b5:	00 
  1012b6:	89 54 24 04          	mov    %edx,0x4(%esp)
  1012ba:	89 04 24             	mov    %eax,(%esp)
  1012bd:	e8 63 5d 00 00       	call   107025 <memmove>
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
  1012c2:	c7 45 f4 80 07 00 00 	movl   $0x780,-0xc(%ebp)
  1012c9:	eb 14                	jmp    1012df <cga_putc+0x14f>
            crt_buf[i] = 0x0700 | ' ';
  1012cb:	a1 40 04 12 00       	mov    0x120440,%eax
  1012d0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1012d3:	01 d2                	add    %edx,%edx
  1012d5:	01 d0                	add    %edx,%eax
  1012d7:	66 c7 00 20 07       	movw   $0x720,(%eax)
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
  1012dc:	ff 45 f4             	incl   -0xc(%ebp)
  1012df:	81 7d f4 cf 07 00 00 	cmpl   $0x7cf,-0xc(%ebp)
  1012e6:	7e e3                	jle    1012cb <cga_putc+0x13b>
        }
        crt_pos -= CRT_COLS;
  1012e8:	0f b7 05 44 04 12 00 	movzwl 0x120444,%eax
  1012ef:	83 e8 50             	sub    $0x50,%eax
  1012f2:	0f b7 c0             	movzwl %ax,%eax
  1012f5:	66 a3 44 04 12 00    	mov    %ax,0x120444
    }

    // move that little blinky thing
    outb(addr_6845, 14);
  1012fb:	0f b7 05 46 04 12 00 	movzwl 0x120446,%eax
  101302:	66 89 45 e6          	mov    %ax,-0x1a(%ebp)
  101306:	c6 45 e5 0e          	movb   $0xe,-0x1b(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  10130a:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  10130e:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  101312:	ee                   	out    %al,(%dx)
}
  101313:	90                   	nop
    outb(addr_6845 + 1, crt_pos >> 8);
  101314:	0f b7 05 44 04 12 00 	movzwl 0x120444,%eax
  10131b:	c1 e8 08             	shr    $0x8,%eax
  10131e:	0f b7 c0             	movzwl %ax,%eax
  101321:	0f b6 c0             	movzbl %al,%eax
  101324:	0f b7 15 46 04 12 00 	movzwl 0x120446,%edx
  10132b:	42                   	inc    %edx
  10132c:	0f b7 d2             	movzwl %dx,%edx
  10132f:	66 89 55 ea          	mov    %dx,-0x16(%ebp)
  101333:	88 45 e9             	mov    %al,-0x17(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  101336:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  10133a:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  10133e:	ee                   	out    %al,(%dx)
}
  10133f:	90                   	nop
    outb(addr_6845, 15);
  101340:	0f b7 05 46 04 12 00 	movzwl 0x120446,%eax
  101347:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
  10134b:	c6 45 ed 0f          	movb   $0xf,-0x13(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  10134f:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  101353:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  101357:	ee                   	out    %al,(%dx)
}
  101358:	90                   	nop
    outb(addr_6845 + 1, crt_pos);
  101359:	0f b7 05 44 04 12 00 	movzwl 0x120444,%eax
  101360:	0f b6 c0             	movzbl %al,%eax
  101363:	0f b7 15 46 04 12 00 	movzwl 0x120446,%edx
  10136a:	42                   	inc    %edx
  10136b:	0f b7 d2             	movzwl %dx,%edx
  10136e:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
  101372:	88 45 f1             	mov    %al,-0xf(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  101375:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  101379:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  10137d:	ee                   	out    %al,(%dx)
}
  10137e:	90                   	nop
}
  10137f:	90                   	nop
  101380:	83 c4 34             	add    $0x34,%esp
  101383:	5b                   	pop    %ebx
  101384:	5d                   	pop    %ebp
  101385:	c3                   	ret    

00101386 <serial_putc_sub>:

static void
serial_putc_sub(int c) {
  101386:	f3 0f 1e fb          	endbr32 
  10138a:	55                   	push   %ebp
  10138b:	89 e5                	mov    %esp,%ebp
  10138d:	83 ec 10             	sub    $0x10,%esp
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
  101390:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  101397:	eb 08                	jmp    1013a1 <serial_putc_sub+0x1b>
        delay();
  101399:	e8 08 fb ff ff       	call   100ea6 <delay>
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
  10139e:	ff 45 fc             	incl   -0x4(%ebp)
  1013a1:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  1013a7:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  1013ab:	89 c2                	mov    %eax,%edx
  1013ad:	ec                   	in     (%dx),%al
  1013ae:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
  1013b1:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  1013b5:	0f b6 c0             	movzbl %al,%eax
  1013b8:	83 e0 20             	and    $0x20,%eax
  1013bb:	85 c0                	test   %eax,%eax
  1013bd:	75 09                	jne    1013c8 <serial_putc_sub+0x42>
  1013bf:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
  1013c6:	7e d1                	jle    101399 <serial_putc_sub+0x13>
    }
    outb(COM1 + COM_TX, c);
  1013c8:	8b 45 08             	mov    0x8(%ebp),%eax
  1013cb:	0f b6 c0             	movzbl %al,%eax
  1013ce:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
  1013d4:	88 45 f5             	mov    %al,-0xb(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  1013d7:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  1013db:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  1013df:	ee                   	out    %al,(%dx)
}
  1013e0:	90                   	nop
}
  1013e1:	90                   	nop
  1013e2:	c9                   	leave  
  1013e3:	c3                   	ret    

001013e4 <serial_putc>:

/* serial_putc - print character to serial port */
static void
serial_putc(int c) {
  1013e4:	f3 0f 1e fb          	endbr32 
  1013e8:	55                   	push   %ebp
  1013e9:	89 e5                	mov    %esp,%ebp
  1013eb:	83 ec 04             	sub    $0x4,%esp
    if (c != '\b') {
  1013ee:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
  1013f2:	74 0d                	je     101401 <serial_putc+0x1d>
        serial_putc_sub(c);
  1013f4:	8b 45 08             	mov    0x8(%ebp),%eax
  1013f7:	89 04 24             	mov    %eax,(%esp)
  1013fa:	e8 87 ff ff ff       	call   101386 <serial_putc_sub>
    else {
        serial_putc_sub('\b');
        serial_putc_sub(' ');
        serial_putc_sub('\b');
    }
}
  1013ff:	eb 24                	jmp    101425 <serial_putc+0x41>
        serial_putc_sub('\b');
  101401:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  101408:	e8 79 ff ff ff       	call   101386 <serial_putc_sub>
        serial_putc_sub(' ');
  10140d:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  101414:	e8 6d ff ff ff       	call   101386 <serial_putc_sub>
        serial_putc_sub('\b');
  101419:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  101420:	e8 61 ff ff ff       	call   101386 <serial_putc_sub>
}
  101425:	90                   	nop
  101426:	c9                   	leave  
  101427:	c3                   	ret    

00101428 <cons_intr>:
/* *
 * cons_intr - called by device interrupt routines to feed input
 * characters into the circular console input buffer.
 * */
static void
cons_intr(int (*proc)(void)) {
  101428:	f3 0f 1e fb          	endbr32 
  10142c:	55                   	push   %ebp
  10142d:	89 e5                	mov    %esp,%ebp
  10142f:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = (*proc)()) != -1) {
  101432:	eb 33                	jmp    101467 <cons_intr+0x3f>
        if (c != 0) {
  101434:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  101438:	74 2d                	je     101467 <cons_intr+0x3f>
            cons.buf[cons.wpos ++] = c;
  10143a:	a1 64 06 12 00       	mov    0x120664,%eax
  10143f:	8d 50 01             	lea    0x1(%eax),%edx
  101442:	89 15 64 06 12 00    	mov    %edx,0x120664
  101448:	8b 55 f4             	mov    -0xc(%ebp),%edx
  10144b:	88 90 60 04 12 00    	mov    %dl,0x120460(%eax)
            if (cons.wpos == CONSBUFSIZE) {
  101451:	a1 64 06 12 00       	mov    0x120664,%eax
  101456:	3d 00 02 00 00       	cmp    $0x200,%eax
  10145b:	75 0a                	jne    101467 <cons_intr+0x3f>
                cons.wpos = 0;
  10145d:	c7 05 64 06 12 00 00 	movl   $0x0,0x120664
  101464:	00 00 00 
    while ((c = (*proc)()) != -1) {
  101467:	8b 45 08             	mov    0x8(%ebp),%eax
  10146a:	ff d0                	call   *%eax
  10146c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  10146f:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
  101473:	75 bf                	jne    101434 <cons_intr+0xc>
            }
        }
    }
}
  101475:	90                   	nop
  101476:	90                   	nop
  101477:	c9                   	leave  
  101478:	c3                   	ret    

00101479 <serial_proc_data>:

/* serial_proc_data - get data from serial port */
static int
serial_proc_data(void) {
  101479:	f3 0f 1e fb          	endbr32 
  10147d:	55                   	push   %ebp
  10147e:	89 e5                	mov    %esp,%ebp
  101480:	83 ec 10             	sub    $0x10,%esp
  101483:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  101489:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  10148d:	89 c2                	mov    %eax,%edx
  10148f:	ec                   	in     (%dx),%al
  101490:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
  101493:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
    if (!(inb(COM1 + COM_LSR) & COM_LSR_DATA)) {
  101497:	0f b6 c0             	movzbl %al,%eax
  10149a:	83 e0 01             	and    $0x1,%eax
  10149d:	85 c0                	test   %eax,%eax
  10149f:	75 07                	jne    1014a8 <serial_proc_data+0x2f>
        return -1;
  1014a1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  1014a6:	eb 2a                	jmp    1014d2 <serial_proc_data+0x59>
  1014a8:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  1014ae:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  1014b2:	89 c2                	mov    %eax,%edx
  1014b4:	ec                   	in     (%dx),%al
  1014b5:	88 45 f5             	mov    %al,-0xb(%ebp)
    return data;
  1014b8:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
    }
    int c = inb(COM1 + COM_RX);
  1014bc:	0f b6 c0             	movzbl %al,%eax
  1014bf:	89 45 fc             	mov    %eax,-0x4(%ebp)
    if (c == 127) {
  1014c2:	83 7d fc 7f          	cmpl   $0x7f,-0x4(%ebp)
  1014c6:	75 07                	jne    1014cf <serial_proc_data+0x56>
        c = '\b';
  1014c8:	c7 45 fc 08 00 00 00 	movl   $0x8,-0x4(%ebp)
    }
    return c;
  1014cf:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  1014d2:	c9                   	leave  
  1014d3:	c3                   	ret    

001014d4 <serial_intr>:

/* serial_intr - try to feed input characters from serial port */
void
serial_intr(void) {
  1014d4:	f3 0f 1e fb          	endbr32 
  1014d8:	55                   	push   %ebp
  1014d9:	89 e5                	mov    %esp,%ebp
  1014db:	83 ec 18             	sub    $0x18,%esp
    if (serial_exists) {
  1014de:	a1 48 04 12 00       	mov    0x120448,%eax
  1014e3:	85 c0                	test   %eax,%eax
  1014e5:	74 0c                	je     1014f3 <serial_intr+0x1f>
        cons_intr(serial_proc_data);
  1014e7:	c7 04 24 79 14 10 00 	movl   $0x101479,(%esp)
  1014ee:	e8 35 ff ff ff       	call   101428 <cons_intr>
    }
}
  1014f3:	90                   	nop
  1014f4:	c9                   	leave  
  1014f5:	c3                   	ret    

001014f6 <kbd_proc_data>:
 *
 * The kbd_proc_data() function gets data from the keyboard.
 * If we finish a character, return it, else 0. And return -1 if no data.
 * */
static int
kbd_proc_data(void) {
  1014f6:	f3 0f 1e fb          	endbr32 
  1014fa:	55                   	push   %ebp
  1014fb:	89 e5                	mov    %esp,%ebp
  1014fd:	83 ec 38             	sub    $0x38,%esp
  101500:	66 c7 45 f0 64 00    	movw   $0x64,-0x10(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  101506:	8b 45 f0             	mov    -0x10(%ebp),%eax
  101509:	89 c2                	mov    %eax,%edx
  10150b:	ec                   	in     (%dx),%al
  10150c:	88 45 ef             	mov    %al,-0x11(%ebp)
    return data;
  10150f:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    int c;
    uint8_t data;
    static uint32_t shift;

    if ((inb(KBSTATP) & KBS_DIB) == 0) {
  101513:	0f b6 c0             	movzbl %al,%eax
  101516:	83 e0 01             	and    $0x1,%eax
  101519:	85 c0                	test   %eax,%eax
  10151b:	75 0a                	jne    101527 <kbd_proc_data+0x31>
        return -1;
  10151d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  101522:	e9 56 01 00 00       	jmp    10167d <kbd_proc_data+0x187>
  101527:	66 c7 45 ec 60 00    	movw   $0x60,-0x14(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  10152d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  101530:	89 c2                	mov    %eax,%edx
  101532:	ec                   	in     (%dx),%al
  101533:	88 45 eb             	mov    %al,-0x15(%ebp)
    return data;
  101536:	0f b6 45 eb          	movzbl -0x15(%ebp),%eax
    }

    data = inb(KBDATAP);
  10153a:	88 45 f3             	mov    %al,-0xd(%ebp)

    if (data == 0xE0) {
  10153d:	80 7d f3 e0          	cmpb   $0xe0,-0xd(%ebp)
  101541:	75 17                	jne    10155a <kbd_proc_data+0x64>
        // E0 escape character
        shift |= E0ESC;
  101543:	a1 68 06 12 00       	mov    0x120668,%eax
  101548:	83 c8 40             	or     $0x40,%eax
  10154b:	a3 68 06 12 00       	mov    %eax,0x120668
        return 0;
  101550:	b8 00 00 00 00       	mov    $0x0,%eax
  101555:	e9 23 01 00 00       	jmp    10167d <kbd_proc_data+0x187>
    } else if (data & 0x80) {
  10155a:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  10155e:	84 c0                	test   %al,%al
  101560:	79 45                	jns    1015a7 <kbd_proc_data+0xb1>
        // Key released
        data = (shift & E0ESC ? data : data & 0x7F);
  101562:	a1 68 06 12 00       	mov    0x120668,%eax
  101567:	83 e0 40             	and    $0x40,%eax
  10156a:	85 c0                	test   %eax,%eax
  10156c:	75 08                	jne    101576 <kbd_proc_data+0x80>
  10156e:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101572:	24 7f                	and    $0x7f,%al
  101574:	eb 04                	jmp    10157a <kbd_proc_data+0x84>
  101576:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  10157a:	88 45 f3             	mov    %al,-0xd(%ebp)
        shift &= ~(shiftcode[data] | E0ESC);
  10157d:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101581:	0f b6 80 40 d0 11 00 	movzbl 0x11d040(%eax),%eax
  101588:	0c 40                	or     $0x40,%al
  10158a:	0f b6 c0             	movzbl %al,%eax
  10158d:	f7 d0                	not    %eax
  10158f:	89 c2                	mov    %eax,%edx
  101591:	a1 68 06 12 00       	mov    0x120668,%eax
  101596:	21 d0                	and    %edx,%eax
  101598:	a3 68 06 12 00       	mov    %eax,0x120668
        return 0;
  10159d:	b8 00 00 00 00       	mov    $0x0,%eax
  1015a2:	e9 d6 00 00 00       	jmp    10167d <kbd_proc_data+0x187>
    } else if (shift & E0ESC) {
  1015a7:	a1 68 06 12 00       	mov    0x120668,%eax
  1015ac:	83 e0 40             	and    $0x40,%eax
  1015af:	85 c0                	test   %eax,%eax
  1015b1:	74 11                	je     1015c4 <kbd_proc_data+0xce>
        // Last character was an E0 escape; or with 0x80
        data |= 0x80;
  1015b3:	80 4d f3 80          	orb    $0x80,-0xd(%ebp)
        shift &= ~E0ESC;
  1015b7:	a1 68 06 12 00       	mov    0x120668,%eax
  1015bc:	83 e0 bf             	and    $0xffffffbf,%eax
  1015bf:	a3 68 06 12 00       	mov    %eax,0x120668
    }

    shift |= shiftcode[data];
  1015c4:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  1015c8:	0f b6 80 40 d0 11 00 	movzbl 0x11d040(%eax),%eax
  1015cf:	0f b6 d0             	movzbl %al,%edx
  1015d2:	a1 68 06 12 00       	mov    0x120668,%eax
  1015d7:	09 d0                	or     %edx,%eax
  1015d9:	a3 68 06 12 00       	mov    %eax,0x120668
    shift ^= togglecode[data];
  1015de:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  1015e2:	0f b6 80 40 d1 11 00 	movzbl 0x11d140(%eax),%eax
  1015e9:	0f b6 d0             	movzbl %al,%edx
  1015ec:	a1 68 06 12 00       	mov    0x120668,%eax
  1015f1:	31 d0                	xor    %edx,%eax
  1015f3:	a3 68 06 12 00       	mov    %eax,0x120668

    c = charcode[shift & (CTL | SHIFT)][data];
  1015f8:	a1 68 06 12 00       	mov    0x120668,%eax
  1015fd:	83 e0 03             	and    $0x3,%eax
  101600:	8b 14 85 40 d5 11 00 	mov    0x11d540(,%eax,4),%edx
  101607:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  10160b:	01 d0                	add    %edx,%eax
  10160d:	0f b6 00             	movzbl (%eax),%eax
  101610:	0f b6 c0             	movzbl %al,%eax
  101613:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (shift & CAPSLOCK) {
  101616:	a1 68 06 12 00       	mov    0x120668,%eax
  10161b:	83 e0 08             	and    $0x8,%eax
  10161e:	85 c0                	test   %eax,%eax
  101620:	74 22                	je     101644 <kbd_proc_data+0x14e>
        if ('a' <= c && c <= 'z')
  101622:	83 7d f4 60          	cmpl   $0x60,-0xc(%ebp)
  101626:	7e 0c                	jle    101634 <kbd_proc_data+0x13e>
  101628:	83 7d f4 7a          	cmpl   $0x7a,-0xc(%ebp)
  10162c:	7f 06                	jg     101634 <kbd_proc_data+0x13e>
            c += 'A' - 'a';
  10162e:	83 6d f4 20          	subl   $0x20,-0xc(%ebp)
  101632:	eb 10                	jmp    101644 <kbd_proc_data+0x14e>
        else if ('A' <= c && c <= 'Z')
  101634:	83 7d f4 40          	cmpl   $0x40,-0xc(%ebp)
  101638:	7e 0a                	jle    101644 <kbd_proc_data+0x14e>
  10163a:	83 7d f4 5a          	cmpl   $0x5a,-0xc(%ebp)
  10163e:	7f 04                	jg     101644 <kbd_proc_data+0x14e>
            c += 'a' - 'A';
  101640:	83 45 f4 20          	addl   $0x20,-0xc(%ebp)
    }

    // Process special keys
    // Ctrl-Alt-Del: reboot
    if (!(~shift & (CTL | ALT)) && c == KEY_DEL) {
  101644:	a1 68 06 12 00       	mov    0x120668,%eax
  101649:	f7 d0                	not    %eax
  10164b:	83 e0 06             	and    $0x6,%eax
  10164e:	85 c0                	test   %eax,%eax
  101650:	75 28                	jne    10167a <kbd_proc_data+0x184>
  101652:	81 7d f4 e9 00 00 00 	cmpl   $0xe9,-0xc(%ebp)
  101659:	75 1f                	jne    10167a <kbd_proc_data+0x184>
        cprintf("Rebooting!\n");
  10165b:	c7 04 24 4d 7b 10 00 	movl   $0x107b4d,(%esp)
  101662:	e8 5e ec ff ff       	call   1002c5 <cprintf>
  101667:	66 c7 45 e8 92 00    	movw   $0x92,-0x18(%ebp)
  10166d:	c6 45 e7 03          	movb   $0x3,-0x19(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  101671:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
  101675:	8b 55 e8             	mov    -0x18(%ebp),%edx
  101678:	ee                   	out    %al,(%dx)
}
  101679:	90                   	nop
        outb(0x92, 0x3); // courtesy of Chris Frost
    }
    return c;
  10167a:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  10167d:	c9                   	leave  
  10167e:	c3                   	ret    

0010167f <kbd_intr>:

/* kbd_intr - try to feed input characters from keyboard */
static void
kbd_intr(void) {
  10167f:	f3 0f 1e fb          	endbr32 
  101683:	55                   	push   %ebp
  101684:	89 e5                	mov    %esp,%ebp
  101686:	83 ec 18             	sub    $0x18,%esp
    cons_intr(kbd_proc_data);
  101689:	c7 04 24 f6 14 10 00 	movl   $0x1014f6,(%esp)
  101690:	e8 93 fd ff ff       	call   101428 <cons_intr>
}
  101695:	90                   	nop
  101696:	c9                   	leave  
  101697:	c3                   	ret    

00101698 <kbd_init>:

static void
kbd_init(void) {
  101698:	f3 0f 1e fb          	endbr32 
  10169c:	55                   	push   %ebp
  10169d:	89 e5                	mov    %esp,%ebp
  10169f:	83 ec 18             	sub    $0x18,%esp
    // drain the kbd buffer
    kbd_intr();
  1016a2:	e8 d8 ff ff ff       	call   10167f <kbd_intr>
    pic_enable(IRQ_KBD);
  1016a7:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1016ae:	e8 47 01 00 00       	call   1017fa <pic_enable>
}
  1016b3:	90                   	nop
  1016b4:	c9                   	leave  
  1016b5:	c3                   	ret    

001016b6 <cons_init>:

/* cons_init - initializes the console devices */
void
cons_init(void) {
  1016b6:	f3 0f 1e fb          	endbr32 
  1016ba:	55                   	push   %ebp
  1016bb:	89 e5                	mov    %esp,%ebp
  1016bd:	83 ec 18             	sub    $0x18,%esp
    cga_init();
  1016c0:	e8 2e f8 ff ff       	call   100ef3 <cga_init>
    serial_init();
  1016c5:	e8 13 f9 ff ff       	call   100fdd <serial_init>
    kbd_init();
  1016ca:	e8 c9 ff ff ff       	call   101698 <kbd_init>
    if (!serial_exists) {
  1016cf:	a1 48 04 12 00       	mov    0x120448,%eax
  1016d4:	85 c0                	test   %eax,%eax
  1016d6:	75 0c                	jne    1016e4 <cons_init+0x2e>
        cprintf("serial port does not exist!!\n");
  1016d8:	c7 04 24 59 7b 10 00 	movl   $0x107b59,(%esp)
  1016df:	e8 e1 eb ff ff       	call   1002c5 <cprintf>
    }
}
  1016e4:	90                   	nop
  1016e5:	c9                   	leave  
  1016e6:	c3                   	ret    

001016e7 <cons_putc>:

/* cons_putc - print a single character @c to console devices */
void
cons_putc(int c) {
  1016e7:	f3 0f 1e fb          	endbr32 
  1016eb:	55                   	push   %ebp
  1016ec:	89 e5                	mov    %esp,%ebp
  1016ee:	83 ec 28             	sub    $0x28,%esp
    bool intr_flag;
    local_intr_save(intr_flag);
  1016f1:	e8 72 f7 ff ff       	call   100e68 <__intr_save>
  1016f6:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        lpt_putc(c);
  1016f9:	8b 45 08             	mov    0x8(%ebp),%eax
  1016fc:	89 04 24             	mov    %eax,(%esp)
  1016ff:	e8 48 fa ff ff       	call   10114c <lpt_putc>
        cga_putc(c);
  101704:	8b 45 08             	mov    0x8(%ebp),%eax
  101707:	89 04 24             	mov    %eax,(%esp)
  10170a:	e8 81 fa ff ff       	call   101190 <cga_putc>
        serial_putc(c);
  10170f:	8b 45 08             	mov    0x8(%ebp),%eax
  101712:	89 04 24             	mov    %eax,(%esp)
  101715:	e8 ca fc ff ff       	call   1013e4 <serial_putc>
    }
    local_intr_restore(intr_flag);
  10171a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10171d:	89 04 24             	mov    %eax,(%esp)
  101720:	e8 6d f7 ff ff       	call   100e92 <__intr_restore>
}
  101725:	90                   	nop
  101726:	c9                   	leave  
  101727:	c3                   	ret    

00101728 <cons_getc>:
/* *
 * cons_getc - return the next input character from console,
 * or 0 if none waiting.
 * */
int
cons_getc(void) {
  101728:	f3 0f 1e fb          	endbr32 
  10172c:	55                   	push   %ebp
  10172d:	89 e5                	mov    %esp,%ebp
  10172f:	83 ec 28             	sub    $0x28,%esp
    int c = 0;
  101732:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    bool intr_flag;
    local_intr_save(intr_flag);
  101739:	e8 2a f7 ff ff       	call   100e68 <__intr_save>
  10173e:	89 45 f0             	mov    %eax,-0x10(%ebp)
    {
        // poll for any pending input characters,
        // so that this function works even when interrupts are disabled
        // (e.g., when called from the kernel monitor).
        serial_intr();
  101741:	e8 8e fd ff ff       	call   1014d4 <serial_intr>
        kbd_intr();
  101746:	e8 34 ff ff ff       	call   10167f <kbd_intr>

        // grab the next character from the input buffer.
        if (cons.rpos != cons.wpos) {
  10174b:	8b 15 60 06 12 00    	mov    0x120660,%edx
  101751:	a1 64 06 12 00       	mov    0x120664,%eax
  101756:	39 c2                	cmp    %eax,%edx
  101758:	74 31                	je     10178b <cons_getc+0x63>
            c = cons.buf[cons.rpos ++];
  10175a:	a1 60 06 12 00       	mov    0x120660,%eax
  10175f:	8d 50 01             	lea    0x1(%eax),%edx
  101762:	89 15 60 06 12 00    	mov    %edx,0x120660
  101768:	0f b6 80 60 04 12 00 	movzbl 0x120460(%eax),%eax
  10176f:	0f b6 c0             	movzbl %al,%eax
  101772:	89 45 f4             	mov    %eax,-0xc(%ebp)
            if (cons.rpos == CONSBUFSIZE) {
  101775:	a1 60 06 12 00       	mov    0x120660,%eax
  10177a:	3d 00 02 00 00       	cmp    $0x200,%eax
  10177f:	75 0a                	jne    10178b <cons_getc+0x63>
                cons.rpos = 0;
  101781:	c7 05 60 06 12 00 00 	movl   $0x0,0x120660
  101788:	00 00 00 
            }
        }
    }
    local_intr_restore(intr_flag);
  10178b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10178e:	89 04 24             	mov    %eax,(%esp)
  101791:	e8 fc f6 ff ff       	call   100e92 <__intr_restore>
    return c;
  101796:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  101799:	c9                   	leave  
  10179a:	c3                   	ret    

0010179b <pic_setmask>:
// Initial IRQ mask has interrupt 2 enabled (for slave 8259A).
static uint16_t irq_mask = 0xFFFF & ~(1 << IRQ_SLAVE);
static bool did_init = 0;

static void
pic_setmask(uint16_t mask) {
  10179b:	f3 0f 1e fb          	endbr32 
  10179f:	55                   	push   %ebp
  1017a0:	89 e5                	mov    %esp,%ebp
  1017a2:	83 ec 14             	sub    $0x14,%esp
  1017a5:	8b 45 08             	mov    0x8(%ebp),%eax
  1017a8:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
    irq_mask = mask;
  1017ac:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1017af:	66 a3 50 d5 11 00    	mov    %ax,0x11d550
    if (did_init) {
  1017b5:	a1 6c 06 12 00       	mov    0x12066c,%eax
  1017ba:	85 c0                	test   %eax,%eax
  1017bc:	74 39                	je     1017f7 <pic_setmask+0x5c>
        outb(IO_PIC1 + 1, mask);
  1017be:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1017c1:	0f b6 c0             	movzbl %al,%eax
  1017c4:	66 c7 45 fa 21 00    	movw   $0x21,-0x6(%ebp)
  1017ca:	88 45 f9             	mov    %al,-0x7(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  1017cd:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  1017d1:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  1017d5:	ee                   	out    %al,(%dx)
}
  1017d6:	90                   	nop
        outb(IO_PIC2 + 1, mask >> 8);
  1017d7:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  1017db:	c1 e8 08             	shr    $0x8,%eax
  1017de:	0f b7 c0             	movzwl %ax,%eax
  1017e1:	0f b6 c0             	movzbl %al,%eax
  1017e4:	66 c7 45 fe a1 00    	movw   $0xa1,-0x2(%ebp)
  1017ea:	88 45 fd             	mov    %al,-0x3(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  1017ed:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
  1017f1:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
  1017f5:	ee                   	out    %al,(%dx)
}
  1017f6:	90                   	nop
    }
}
  1017f7:	90                   	nop
  1017f8:	c9                   	leave  
  1017f9:	c3                   	ret    

001017fa <pic_enable>:

void
pic_enable(unsigned int irq) {
  1017fa:	f3 0f 1e fb          	endbr32 
  1017fe:	55                   	push   %ebp
  1017ff:	89 e5                	mov    %esp,%ebp
  101801:	83 ec 04             	sub    $0x4,%esp
    pic_setmask(irq_mask & ~(1 << irq));
  101804:	8b 45 08             	mov    0x8(%ebp),%eax
  101807:	ba 01 00 00 00       	mov    $0x1,%edx
  10180c:	88 c1                	mov    %al,%cl
  10180e:	d3 e2                	shl    %cl,%edx
  101810:	89 d0                	mov    %edx,%eax
  101812:	98                   	cwtl   
  101813:	f7 d0                	not    %eax
  101815:	0f bf d0             	movswl %ax,%edx
  101818:	0f b7 05 50 d5 11 00 	movzwl 0x11d550,%eax
  10181f:	98                   	cwtl   
  101820:	21 d0                	and    %edx,%eax
  101822:	98                   	cwtl   
  101823:	0f b7 c0             	movzwl %ax,%eax
  101826:	89 04 24             	mov    %eax,(%esp)
  101829:	e8 6d ff ff ff       	call   10179b <pic_setmask>
}
  10182e:	90                   	nop
  10182f:	c9                   	leave  
  101830:	c3                   	ret    

00101831 <pic_init>:

/* pic_init - initialize the 8259A interrupt controllers */
void
pic_init(void) {
  101831:	f3 0f 1e fb          	endbr32 
  101835:	55                   	push   %ebp
  101836:	89 e5                	mov    %esp,%ebp
  101838:	83 ec 44             	sub    $0x44,%esp
    did_init = 1;
  10183b:	c7 05 6c 06 12 00 01 	movl   $0x1,0x12066c
  101842:	00 00 00 
  101845:	66 c7 45 ca 21 00    	movw   $0x21,-0x36(%ebp)
  10184b:	c6 45 c9 ff          	movb   $0xff,-0x37(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  10184f:	0f b6 45 c9          	movzbl -0x37(%ebp),%eax
  101853:	0f b7 55 ca          	movzwl -0x36(%ebp),%edx
  101857:	ee                   	out    %al,(%dx)
}
  101858:	90                   	nop
  101859:	66 c7 45 ce a1 00    	movw   $0xa1,-0x32(%ebp)
  10185f:	c6 45 cd ff          	movb   $0xff,-0x33(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  101863:	0f b6 45 cd          	movzbl -0x33(%ebp),%eax
  101867:	0f b7 55 ce          	movzwl -0x32(%ebp),%edx
  10186b:	ee                   	out    %al,(%dx)
}
  10186c:	90                   	nop
  10186d:	66 c7 45 d2 20 00    	movw   $0x20,-0x2e(%ebp)
  101873:	c6 45 d1 11          	movb   $0x11,-0x2f(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  101877:	0f b6 45 d1          	movzbl -0x2f(%ebp),%eax
  10187b:	0f b7 55 d2          	movzwl -0x2e(%ebp),%edx
  10187f:	ee                   	out    %al,(%dx)
}
  101880:	90                   	nop
  101881:	66 c7 45 d6 21 00    	movw   $0x21,-0x2a(%ebp)
  101887:	c6 45 d5 20          	movb   $0x20,-0x2b(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  10188b:	0f b6 45 d5          	movzbl -0x2b(%ebp),%eax
  10188f:	0f b7 55 d6          	movzwl -0x2a(%ebp),%edx
  101893:	ee                   	out    %al,(%dx)
}
  101894:	90                   	nop
  101895:	66 c7 45 da 21 00    	movw   $0x21,-0x26(%ebp)
  10189b:	c6 45 d9 04          	movb   $0x4,-0x27(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  10189f:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
  1018a3:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
  1018a7:	ee                   	out    %al,(%dx)
}
  1018a8:	90                   	nop
  1018a9:	66 c7 45 de 21 00    	movw   $0x21,-0x22(%ebp)
  1018af:	c6 45 dd 03          	movb   $0x3,-0x23(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  1018b3:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
  1018b7:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
  1018bb:	ee                   	out    %al,(%dx)
}
  1018bc:	90                   	nop
  1018bd:	66 c7 45 e2 a0 00    	movw   $0xa0,-0x1e(%ebp)
  1018c3:	c6 45 e1 11          	movb   $0x11,-0x1f(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  1018c7:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
  1018cb:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
  1018cf:	ee                   	out    %al,(%dx)
}
  1018d0:	90                   	nop
  1018d1:	66 c7 45 e6 a1 00    	movw   $0xa1,-0x1a(%ebp)
  1018d7:	c6 45 e5 28          	movb   $0x28,-0x1b(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  1018db:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  1018df:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  1018e3:	ee                   	out    %al,(%dx)
}
  1018e4:	90                   	nop
  1018e5:	66 c7 45 ea a1 00    	movw   $0xa1,-0x16(%ebp)
  1018eb:	c6 45 e9 02          	movb   $0x2,-0x17(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  1018ef:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  1018f3:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  1018f7:	ee                   	out    %al,(%dx)
}
  1018f8:	90                   	nop
  1018f9:	66 c7 45 ee a1 00    	movw   $0xa1,-0x12(%ebp)
  1018ff:	c6 45 ed 03          	movb   $0x3,-0x13(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  101903:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  101907:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  10190b:	ee                   	out    %al,(%dx)
}
  10190c:	90                   	nop
  10190d:	66 c7 45 f2 20 00    	movw   $0x20,-0xe(%ebp)
  101913:	c6 45 f1 68          	movb   $0x68,-0xf(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  101917:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  10191b:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  10191f:	ee                   	out    %al,(%dx)
}
  101920:	90                   	nop
  101921:	66 c7 45 f6 20 00    	movw   $0x20,-0xa(%ebp)
  101927:	c6 45 f5 0a          	movb   $0xa,-0xb(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  10192b:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  10192f:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  101933:	ee                   	out    %al,(%dx)
}
  101934:	90                   	nop
  101935:	66 c7 45 fa a0 00    	movw   $0xa0,-0x6(%ebp)
  10193b:	c6 45 f9 68          	movb   $0x68,-0x7(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  10193f:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  101943:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  101947:	ee                   	out    %al,(%dx)
}
  101948:	90                   	nop
  101949:	66 c7 45 fe a0 00    	movw   $0xa0,-0x2(%ebp)
  10194f:	c6 45 fd 0a          	movb   $0xa,-0x3(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  101953:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
  101957:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
  10195b:	ee                   	out    %al,(%dx)
}
  10195c:	90                   	nop
    outb(IO_PIC1, 0x0a);    // read IRR by default

    outb(IO_PIC2, 0x68);    // OCW3
    outb(IO_PIC2, 0x0a);    // OCW3

    if (irq_mask != 0xFFFF) {
  10195d:	0f b7 05 50 d5 11 00 	movzwl 0x11d550,%eax
  101964:	3d ff ff 00 00       	cmp    $0xffff,%eax
  101969:	74 0f                	je     10197a <pic_init+0x149>
        pic_setmask(irq_mask);
  10196b:	0f b7 05 50 d5 11 00 	movzwl 0x11d550,%eax
  101972:	89 04 24             	mov    %eax,(%esp)
  101975:	e8 21 fe ff ff       	call   10179b <pic_setmask>
    }
}
  10197a:	90                   	nop
  10197b:	c9                   	leave  
  10197c:	c3                   	ret    

0010197d <intr_enable>:
#include <x86.h>
#include <intr.h>

/* intr_enable - enable irq interrupt */
void
intr_enable(void) {
  10197d:	f3 0f 1e fb          	endbr32 
  101981:	55                   	push   %ebp
  101982:	89 e5                	mov    %esp,%ebp
    asm volatile ("sti");
  101984:	fb                   	sti    
}
  101985:	90                   	nop
    sti();
}
  101986:	90                   	nop
  101987:	5d                   	pop    %ebp
  101988:	c3                   	ret    

00101989 <intr_disable>:

/* intr_disable - disable irq interrupt */
void
intr_disable(void) {
  101989:	f3 0f 1e fb          	endbr32 
  10198d:	55                   	push   %ebp
  10198e:	89 e5                	mov    %esp,%ebp
    asm volatile ("cli" ::: "memory");
  101990:	fa                   	cli    
}
  101991:	90                   	nop
    cli();
}
  101992:	90                   	nop
  101993:	5d                   	pop    %ebp
  101994:	c3                   	ret    

00101995 <print_ticks>:
#include <console.h>
#include <kdebug.h>

#define TICK_NUM 100

static void print_ticks() {
  101995:	f3 0f 1e fb          	endbr32 
  101999:	55                   	push   %ebp
  10199a:	89 e5                	mov    %esp,%ebp
  10199c:	83 ec 18             	sub    $0x18,%esp
    cprintf("%d ticks\n",TICK_NUM);
  10199f:	c7 44 24 04 64 00 00 	movl   $0x64,0x4(%esp)
  1019a6:	00 
  1019a7:	c7 04 24 80 7b 10 00 	movl   $0x107b80,(%esp)
  1019ae:	e8 12 e9 ff ff       	call   1002c5 <cprintf>
#ifdef DEBUG_GRADE
    cprintf("End of Test.\n");
  1019b3:	c7 04 24 8a 7b 10 00 	movl   $0x107b8a,(%esp)
  1019ba:	e8 06 e9 ff ff       	call   1002c5 <cprintf>
    panic("EOT: kernel seems ok.");
  1019bf:	c7 44 24 08 98 7b 10 	movl   $0x107b98,0x8(%esp)
  1019c6:	00 
  1019c7:	c7 44 24 04 12 00 00 	movl   $0x12,0x4(%esp)
  1019ce:	00 
  1019cf:	c7 04 24 ae 7b 10 00 	movl   $0x107bae,(%esp)
  1019d6:	e8 56 ea ff ff       	call   100431 <__panic>

001019db <idt_init>:
    sizeof(idt) - 1, (uintptr_t)idt
};

/* idt_init - initialize IDT to each of the entry points in kern/trap/vectors.S */
void
idt_init(void) {
  1019db:	f3 0f 1e fb          	endbr32 
  1019df:	55                   	push   %ebp
  1019e0:	89 e5                	mov    %esp,%ebp
  1019e2:	83 ec 10             	sub    $0x10,%esp
      */
    
    // 定义中断向量表
    extern uintptr_t __vectors[];
    // 向量表的长度为sizeof(idt) / sizeof(struct gatedesc)
    for (int i = 0; i < sizeof(idt) / sizeof(struct gatedesc); i ++) {
  1019e5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  1019ec:	e9 c4 00 00 00       	jmp    101ab5 <idt_init+0xda>
    // idt描述表项，0表示是interupt而不是trap，GD_KTEXT为段选择子，__vectors[i]为偏移量，DPL_KERNEL为特权级
        SETGATE(idt[i], 0, GD_KTEXT, __vectors[i], DPL_KERNEL);
  1019f1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1019f4:	8b 04 85 e0 d5 11 00 	mov    0x11d5e0(,%eax,4),%eax
  1019fb:	0f b7 d0             	movzwl %ax,%edx
  1019fe:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101a01:	66 89 14 c5 80 06 12 	mov    %dx,0x120680(,%eax,8)
  101a08:	00 
  101a09:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101a0c:	66 c7 04 c5 82 06 12 	movw   $0x8,0x120682(,%eax,8)
  101a13:	00 08 00 
  101a16:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101a19:	0f b6 14 c5 84 06 12 	movzbl 0x120684(,%eax,8),%edx
  101a20:	00 
  101a21:	80 e2 e0             	and    $0xe0,%dl
  101a24:	88 14 c5 84 06 12 00 	mov    %dl,0x120684(,%eax,8)
  101a2b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101a2e:	0f b6 14 c5 84 06 12 	movzbl 0x120684(,%eax,8),%edx
  101a35:	00 
  101a36:	80 e2 1f             	and    $0x1f,%dl
  101a39:	88 14 c5 84 06 12 00 	mov    %dl,0x120684(,%eax,8)
  101a40:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101a43:	0f b6 14 c5 85 06 12 	movzbl 0x120685(,%eax,8),%edx
  101a4a:	00 
  101a4b:	80 e2 f0             	and    $0xf0,%dl
  101a4e:	80 ca 0e             	or     $0xe,%dl
  101a51:	88 14 c5 85 06 12 00 	mov    %dl,0x120685(,%eax,8)
  101a58:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101a5b:	0f b6 14 c5 85 06 12 	movzbl 0x120685(,%eax,8),%edx
  101a62:	00 
  101a63:	80 e2 ef             	and    $0xef,%dl
  101a66:	88 14 c5 85 06 12 00 	mov    %dl,0x120685(,%eax,8)
  101a6d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101a70:	0f b6 14 c5 85 06 12 	movzbl 0x120685(,%eax,8),%edx
  101a77:	00 
  101a78:	80 e2 9f             	and    $0x9f,%dl
  101a7b:	88 14 c5 85 06 12 00 	mov    %dl,0x120685(,%eax,8)
  101a82:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101a85:	0f b6 14 c5 85 06 12 	movzbl 0x120685(,%eax,8),%edx
  101a8c:	00 
  101a8d:	80 ca 80             	or     $0x80,%dl
  101a90:	88 14 c5 85 06 12 00 	mov    %dl,0x120685(,%eax,8)
  101a97:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101a9a:	8b 04 85 e0 d5 11 00 	mov    0x11d5e0(,%eax,4),%eax
  101aa1:	c1 e8 10             	shr    $0x10,%eax
  101aa4:	0f b7 d0             	movzwl %ax,%edx
  101aa7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101aaa:	66 89 14 c5 86 06 12 	mov    %dx,0x120686(,%eax,8)
  101ab1:	00 
    for (int i = 0; i < sizeof(idt) / sizeof(struct gatedesc); i ++) {
  101ab2:	ff 45 fc             	incl   -0x4(%ebp)
  101ab5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101ab8:	3d ff 00 00 00       	cmp    $0xff,%eax
  101abd:	0f 86 2e ff ff ff    	jbe    1019f1 <idt_init+0x16>
    }
	// set for switch from user to kernel
    // 选择需要从user特权级转化为kernel特权级的项(系统调用中断)
    SETGATE(idt[T_SWITCH_TOK], 1, KERNEL_CS, __vectors[T_SWITCH_TOK], DPL_USER);
  101ac3:	a1 c4 d7 11 00       	mov    0x11d7c4,%eax
  101ac8:	0f b7 c0             	movzwl %ax,%eax
  101acb:	66 a3 48 0a 12 00    	mov    %ax,0x120a48
  101ad1:	66 c7 05 4a 0a 12 00 	movw   $0x8,0x120a4a
  101ad8:	08 00 
  101ada:	0f b6 05 4c 0a 12 00 	movzbl 0x120a4c,%eax
  101ae1:	24 e0                	and    $0xe0,%al
  101ae3:	a2 4c 0a 12 00       	mov    %al,0x120a4c
  101ae8:	0f b6 05 4c 0a 12 00 	movzbl 0x120a4c,%eax
  101aef:	24 1f                	and    $0x1f,%al
  101af1:	a2 4c 0a 12 00       	mov    %al,0x120a4c
  101af6:	0f b6 05 4d 0a 12 00 	movzbl 0x120a4d,%eax
  101afd:	0c 0f                	or     $0xf,%al
  101aff:	a2 4d 0a 12 00       	mov    %al,0x120a4d
  101b04:	0f b6 05 4d 0a 12 00 	movzbl 0x120a4d,%eax
  101b0b:	24 ef                	and    $0xef,%al
  101b0d:	a2 4d 0a 12 00       	mov    %al,0x120a4d
  101b12:	0f b6 05 4d 0a 12 00 	movzbl 0x120a4d,%eax
  101b19:	0c 60                	or     $0x60,%al
  101b1b:	a2 4d 0a 12 00       	mov    %al,0x120a4d
  101b20:	0f b6 05 4d 0a 12 00 	movzbl 0x120a4d,%eax
  101b27:	0c 80                	or     $0x80,%al
  101b29:	a2 4d 0a 12 00       	mov    %al,0x120a4d
  101b2e:	a1 c4 d7 11 00       	mov    0x11d7c4,%eax
  101b33:	c1 e8 10             	shr    $0x10,%eax
  101b36:	0f b7 c0             	movzwl %ax,%eax
  101b39:	66 a3 4e 0a 12 00    	mov    %ax,0x120a4e
  101b3f:	c7 45 f8 60 d5 11 00 	movl   $0x11d560,-0x8(%ebp)
    asm volatile ("lidt (%0)" :: "r" (pd) : "memory");
  101b46:	8b 45 f8             	mov    -0x8(%ebp),%eax
  101b49:	0f 01 18             	lidtl  (%eax)
}
  101b4c:	90                   	nop
	// load the IDT
    // 加载IDT
    lidt(&idt_pd);
}
  101b4d:	90                   	nop
  101b4e:	c9                   	leave  
  101b4f:	c3                   	ret    

00101b50 <trapname>:

static const char *
trapname(int trapno) {
  101b50:	f3 0f 1e fb          	endbr32 
  101b54:	55                   	push   %ebp
  101b55:	89 e5                	mov    %esp,%ebp
        "Alignment Check",
        "Machine-Check",
        "SIMD Floating-Point Exception"
    };

    if (trapno < sizeof(excnames)/sizeof(const char * const)) {
  101b57:	8b 45 08             	mov    0x8(%ebp),%eax
  101b5a:	83 f8 13             	cmp    $0x13,%eax
  101b5d:	77 0c                	ja     101b6b <trapname+0x1b>
        return excnames[trapno];
  101b5f:	8b 45 08             	mov    0x8(%ebp),%eax
  101b62:	8b 04 85 40 7f 10 00 	mov    0x107f40(,%eax,4),%eax
  101b69:	eb 18                	jmp    101b83 <trapname+0x33>
    }
    if (trapno >= IRQ_OFFSET && trapno < IRQ_OFFSET + 16) {
  101b6b:	83 7d 08 1f          	cmpl   $0x1f,0x8(%ebp)
  101b6f:	7e 0d                	jle    101b7e <trapname+0x2e>
  101b71:	83 7d 08 2f          	cmpl   $0x2f,0x8(%ebp)
  101b75:	7f 07                	jg     101b7e <trapname+0x2e>
        return "Hardware Interrupt";
  101b77:	b8 bf 7b 10 00       	mov    $0x107bbf,%eax
  101b7c:	eb 05                	jmp    101b83 <trapname+0x33>
    }
    return "(unknown trap)";
  101b7e:	b8 d2 7b 10 00       	mov    $0x107bd2,%eax
}
  101b83:	5d                   	pop    %ebp
  101b84:	c3                   	ret    

00101b85 <trap_in_kernel>:

/* trap_in_kernel - test if trap happened in kernel */
bool
trap_in_kernel(struct trapframe *tf) {
  101b85:	f3 0f 1e fb          	endbr32 
  101b89:	55                   	push   %ebp
  101b8a:	89 e5                	mov    %esp,%ebp
    return (tf->tf_cs == (uint16_t)KERNEL_CS);
  101b8c:	8b 45 08             	mov    0x8(%ebp),%eax
  101b8f:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101b93:	83 f8 08             	cmp    $0x8,%eax
  101b96:	0f 94 c0             	sete   %al
  101b99:	0f b6 c0             	movzbl %al,%eax
}
  101b9c:	5d                   	pop    %ebp
  101b9d:	c3                   	ret    

00101b9e <print_trapframe>:
    "TF", "IF", "DF", "OF", NULL, NULL, "NT", NULL,
    "RF", "VM", "AC", "VIF", "VIP", "ID", NULL, NULL,
};

void
print_trapframe(struct trapframe *tf) {
  101b9e:	f3 0f 1e fb          	endbr32 
  101ba2:	55                   	push   %ebp
  101ba3:	89 e5                	mov    %esp,%ebp
  101ba5:	83 ec 28             	sub    $0x28,%esp
    cprintf("trapframe at %p\n", tf);
  101ba8:	8b 45 08             	mov    0x8(%ebp),%eax
  101bab:	89 44 24 04          	mov    %eax,0x4(%esp)
  101baf:	c7 04 24 13 7c 10 00 	movl   $0x107c13,(%esp)
  101bb6:	e8 0a e7 ff ff       	call   1002c5 <cprintf>
    print_regs(&tf->tf_regs);
  101bbb:	8b 45 08             	mov    0x8(%ebp),%eax
  101bbe:	89 04 24             	mov    %eax,(%esp)
  101bc1:	e8 8d 01 00 00       	call   101d53 <print_regs>
    cprintf("  ds   0x----%04x\n", tf->tf_ds);
  101bc6:	8b 45 08             	mov    0x8(%ebp),%eax
  101bc9:	0f b7 40 2c          	movzwl 0x2c(%eax),%eax
  101bcd:	89 44 24 04          	mov    %eax,0x4(%esp)
  101bd1:	c7 04 24 24 7c 10 00 	movl   $0x107c24,(%esp)
  101bd8:	e8 e8 e6 ff ff       	call   1002c5 <cprintf>
    cprintf("  es   0x----%04x\n", tf->tf_es);
  101bdd:	8b 45 08             	mov    0x8(%ebp),%eax
  101be0:	0f b7 40 28          	movzwl 0x28(%eax),%eax
  101be4:	89 44 24 04          	mov    %eax,0x4(%esp)
  101be8:	c7 04 24 37 7c 10 00 	movl   $0x107c37,(%esp)
  101bef:	e8 d1 e6 ff ff       	call   1002c5 <cprintf>
    cprintf("  fs   0x----%04x\n", tf->tf_fs);
  101bf4:	8b 45 08             	mov    0x8(%ebp),%eax
  101bf7:	0f b7 40 24          	movzwl 0x24(%eax),%eax
  101bfb:	89 44 24 04          	mov    %eax,0x4(%esp)
  101bff:	c7 04 24 4a 7c 10 00 	movl   $0x107c4a,(%esp)
  101c06:	e8 ba e6 ff ff       	call   1002c5 <cprintf>
    cprintf("  gs   0x----%04x\n", tf->tf_gs);
  101c0b:	8b 45 08             	mov    0x8(%ebp),%eax
  101c0e:	0f b7 40 20          	movzwl 0x20(%eax),%eax
  101c12:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c16:	c7 04 24 5d 7c 10 00 	movl   $0x107c5d,(%esp)
  101c1d:	e8 a3 e6 ff ff       	call   1002c5 <cprintf>
    cprintf("  trap 0x%08x %s\n", tf->tf_trapno, trapname(tf->tf_trapno));
  101c22:	8b 45 08             	mov    0x8(%ebp),%eax
  101c25:	8b 40 30             	mov    0x30(%eax),%eax
  101c28:	89 04 24             	mov    %eax,(%esp)
  101c2b:	e8 20 ff ff ff       	call   101b50 <trapname>
  101c30:	8b 55 08             	mov    0x8(%ebp),%edx
  101c33:	8b 52 30             	mov    0x30(%edx),%edx
  101c36:	89 44 24 08          	mov    %eax,0x8(%esp)
  101c3a:	89 54 24 04          	mov    %edx,0x4(%esp)
  101c3e:	c7 04 24 70 7c 10 00 	movl   $0x107c70,(%esp)
  101c45:	e8 7b e6 ff ff       	call   1002c5 <cprintf>
    cprintf("  err  0x%08x\n", tf->tf_err);
  101c4a:	8b 45 08             	mov    0x8(%ebp),%eax
  101c4d:	8b 40 34             	mov    0x34(%eax),%eax
  101c50:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c54:	c7 04 24 82 7c 10 00 	movl   $0x107c82,(%esp)
  101c5b:	e8 65 e6 ff ff       	call   1002c5 <cprintf>
    cprintf("  eip  0x%08x\n", tf->tf_eip);
  101c60:	8b 45 08             	mov    0x8(%ebp),%eax
  101c63:	8b 40 38             	mov    0x38(%eax),%eax
  101c66:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c6a:	c7 04 24 91 7c 10 00 	movl   $0x107c91,(%esp)
  101c71:	e8 4f e6 ff ff       	call   1002c5 <cprintf>
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
  101c76:	8b 45 08             	mov    0x8(%ebp),%eax
  101c79:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101c7d:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c81:	c7 04 24 a0 7c 10 00 	movl   $0x107ca0,(%esp)
  101c88:	e8 38 e6 ff ff       	call   1002c5 <cprintf>
    cprintf("  flag 0x%08x ", tf->tf_eflags);
  101c8d:	8b 45 08             	mov    0x8(%ebp),%eax
  101c90:	8b 40 40             	mov    0x40(%eax),%eax
  101c93:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c97:	c7 04 24 b3 7c 10 00 	movl   $0x107cb3,(%esp)
  101c9e:	e8 22 e6 ff ff       	call   1002c5 <cprintf>

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
  101ca3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  101caa:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
  101cb1:	eb 3d                	jmp    101cf0 <print_trapframe+0x152>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
  101cb3:	8b 45 08             	mov    0x8(%ebp),%eax
  101cb6:	8b 50 40             	mov    0x40(%eax),%edx
  101cb9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  101cbc:	21 d0                	and    %edx,%eax
  101cbe:	85 c0                	test   %eax,%eax
  101cc0:	74 28                	je     101cea <print_trapframe+0x14c>
  101cc2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101cc5:	8b 04 85 80 d5 11 00 	mov    0x11d580(,%eax,4),%eax
  101ccc:	85 c0                	test   %eax,%eax
  101cce:	74 1a                	je     101cea <print_trapframe+0x14c>
            cprintf("%s,", IA32flags[i]);
  101cd0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101cd3:	8b 04 85 80 d5 11 00 	mov    0x11d580(,%eax,4),%eax
  101cda:	89 44 24 04          	mov    %eax,0x4(%esp)
  101cde:	c7 04 24 c2 7c 10 00 	movl   $0x107cc2,(%esp)
  101ce5:	e8 db e5 ff ff       	call   1002c5 <cprintf>
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
  101cea:	ff 45 f4             	incl   -0xc(%ebp)
  101ced:	d1 65 f0             	shll   -0x10(%ebp)
  101cf0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101cf3:	83 f8 17             	cmp    $0x17,%eax
  101cf6:	76 bb                	jbe    101cb3 <print_trapframe+0x115>
        }
    }
    cprintf("IOPL=%d\n", (tf->tf_eflags & FL_IOPL_MASK) >> 12);
  101cf8:	8b 45 08             	mov    0x8(%ebp),%eax
  101cfb:	8b 40 40             	mov    0x40(%eax),%eax
  101cfe:	c1 e8 0c             	shr    $0xc,%eax
  101d01:	83 e0 03             	and    $0x3,%eax
  101d04:	89 44 24 04          	mov    %eax,0x4(%esp)
  101d08:	c7 04 24 c6 7c 10 00 	movl   $0x107cc6,(%esp)
  101d0f:	e8 b1 e5 ff ff       	call   1002c5 <cprintf>

    if (!trap_in_kernel(tf)) {
  101d14:	8b 45 08             	mov    0x8(%ebp),%eax
  101d17:	89 04 24             	mov    %eax,(%esp)
  101d1a:	e8 66 fe ff ff       	call   101b85 <trap_in_kernel>
  101d1f:	85 c0                	test   %eax,%eax
  101d21:	75 2d                	jne    101d50 <print_trapframe+0x1b2>
        cprintf("  esp  0x%08x\n", tf->tf_esp);
  101d23:	8b 45 08             	mov    0x8(%ebp),%eax
  101d26:	8b 40 44             	mov    0x44(%eax),%eax
  101d29:	89 44 24 04          	mov    %eax,0x4(%esp)
  101d2d:	c7 04 24 cf 7c 10 00 	movl   $0x107ccf,(%esp)
  101d34:	e8 8c e5 ff ff       	call   1002c5 <cprintf>
        cprintf("  ss   0x----%04x\n", tf->tf_ss);
  101d39:	8b 45 08             	mov    0x8(%ebp),%eax
  101d3c:	0f b7 40 48          	movzwl 0x48(%eax),%eax
  101d40:	89 44 24 04          	mov    %eax,0x4(%esp)
  101d44:	c7 04 24 de 7c 10 00 	movl   $0x107cde,(%esp)
  101d4b:	e8 75 e5 ff ff       	call   1002c5 <cprintf>
    }
}
  101d50:	90                   	nop
  101d51:	c9                   	leave  
  101d52:	c3                   	ret    

00101d53 <print_regs>:

void
print_regs(struct pushregs *regs) {
  101d53:	f3 0f 1e fb          	endbr32 
  101d57:	55                   	push   %ebp
  101d58:	89 e5                	mov    %esp,%ebp
  101d5a:	83 ec 18             	sub    $0x18,%esp
    cprintf("  edi  0x%08x\n", regs->reg_edi);
  101d5d:	8b 45 08             	mov    0x8(%ebp),%eax
  101d60:	8b 00                	mov    (%eax),%eax
  101d62:	89 44 24 04          	mov    %eax,0x4(%esp)
  101d66:	c7 04 24 f1 7c 10 00 	movl   $0x107cf1,(%esp)
  101d6d:	e8 53 e5 ff ff       	call   1002c5 <cprintf>
    cprintf("  esi  0x%08x\n", regs->reg_esi);
  101d72:	8b 45 08             	mov    0x8(%ebp),%eax
  101d75:	8b 40 04             	mov    0x4(%eax),%eax
  101d78:	89 44 24 04          	mov    %eax,0x4(%esp)
  101d7c:	c7 04 24 00 7d 10 00 	movl   $0x107d00,(%esp)
  101d83:	e8 3d e5 ff ff       	call   1002c5 <cprintf>
    cprintf("  ebp  0x%08x\n", regs->reg_ebp);
  101d88:	8b 45 08             	mov    0x8(%ebp),%eax
  101d8b:	8b 40 08             	mov    0x8(%eax),%eax
  101d8e:	89 44 24 04          	mov    %eax,0x4(%esp)
  101d92:	c7 04 24 0f 7d 10 00 	movl   $0x107d0f,(%esp)
  101d99:	e8 27 e5 ff ff       	call   1002c5 <cprintf>
    cprintf("  oesp 0x%08x\n", regs->reg_oesp);
  101d9e:	8b 45 08             	mov    0x8(%ebp),%eax
  101da1:	8b 40 0c             	mov    0xc(%eax),%eax
  101da4:	89 44 24 04          	mov    %eax,0x4(%esp)
  101da8:	c7 04 24 1e 7d 10 00 	movl   $0x107d1e,(%esp)
  101daf:	e8 11 e5 ff ff       	call   1002c5 <cprintf>
    cprintf("  ebx  0x%08x\n", regs->reg_ebx);
  101db4:	8b 45 08             	mov    0x8(%ebp),%eax
  101db7:	8b 40 10             	mov    0x10(%eax),%eax
  101dba:	89 44 24 04          	mov    %eax,0x4(%esp)
  101dbe:	c7 04 24 2d 7d 10 00 	movl   $0x107d2d,(%esp)
  101dc5:	e8 fb e4 ff ff       	call   1002c5 <cprintf>
    cprintf("  edx  0x%08x\n", regs->reg_edx);
  101dca:	8b 45 08             	mov    0x8(%ebp),%eax
  101dcd:	8b 40 14             	mov    0x14(%eax),%eax
  101dd0:	89 44 24 04          	mov    %eax,0x4(%esp)
  101dd4:	c7 04 24 3c 7d 10 00 	movl   $0x107d3c,(%esp)
  101ddb:	e8 e5 e4 ff ff       	call   1002c5 <cprintf>
    cprintf("  ecx  0x%08x\n", regs->reg_ecx);
  101de0:	8b 45 08             	mov    0x8(%ebp),%eax
  101de3:	8b 40 18             	mov    0x18(%eax),%eax
  101de6:	89 44 24 04          	mov    %eax,0x4(%esp)
  101dea:	c7 04 24 4b 7d 10 00 	movl   $0x107d4b,(%esp)
  101df1:	e8 cf e4 ff ff       	call   1002c5 <cprintf>
    cprintf("  eax  0x%08x\n", regs->reg_eax);
  101df6:	8b 45 08             	mov    0x8(%ebp),%eax
  101df9:	8b 40 1c             	mov    0x1c(%eax),%eax
  101dfc:	89 44 24 04          	mov    %eax,0x4(%esp)
  101e00:	c7 04 24 5a 7d 10 00 	movl   $0x107d5a,(%esp)
  101e07:	e8 b9 e4 ff ff       	call   1002c5 <cprintf>
}
  101e0c:	90                   	nop
  101e0d:	c9                   	leave  
  101e0e:	c3                   	ret    

00101e0f <trap_dispatch>:
/* temporary trapframe or pointer to trapframe */
struct trapframe switchk2u, *switchu2k;

/* trap_dispatch - dispatch based on what type of trap occurred */
static void
trap_dispatch(struct trapframe *tf) {
  101e0f:	f3 0f 1e fb          	endbr32 
  101e13:	55                   	push   %ebp
  101e14:	89 e5                	mov    %esp,%ebp
  101e16:	57                   	push   %edi
  101e17:	56                   	push   %esi
  101e18:	53                   	push   %ebx
  101e19:	83 ec 2c             	sub    $0x2c,%esp
    char c;

    switch (tf->tf_trapno) {
  101e1c:	8b 45 08             	mov    0x8(%ebp),%eax
  101e1f:	8b 40 30             	mov    0x30(%eax),%eax
  101e22:	83 f8 79             	cmp    $0x79,%eax
  101e25:	0f 84 87 03 00 00    	je     1021b2 <trap_dispatch+0x3a3>
  101e2b:	83 f8 79             	cmp    $0x79,%eax
  101e2e:	0f 87 12 04 00 00    	ja     102246 <trap_dispatch+0x437>
  101e34:	83 f8 78             	cmp    $0x78,%eax
  101e37:	0f 84 8d 02 00 00    	je     1020ca <trap_dispatch+0x2bb>
  101e3d:	83 f8 78             	cmp    $0x78,%eax
  101e40:	0f 87 00 04 00 00    	ja     102246 <trap_dispatch+0x437>
  101e46:	83 f8 2f             	cmp    $0x2f,%eax
  101e49:	0f 87 f7 03 00 00    	ja     102246 <trap_dispatch+0x437>
  101e4f:	83 f8 2e             	cmp    $0x2e,%eax
  101e52:	0f 83 23 04 00 00    	jae    10227b <trap_dispatch+0x46c>
  101e58:	83 f8 24             	cmp    $0x24,%eax
  101e5b:	74 5e                	je     101ebb <trap_dispatch+0xac>
  101e5d:	83 f8 24             	cmp    $0x24,%eax
  101e60:	0f 87 e0 03 00 00    	ja     102246 <trap_dispatch+0x437>
  101e66:	83 f8 20             	cmp    $0x20,%eax
  101e69:	74 0a                	je     101e75 <trap_dispatch+0x66>
  101e6b:	83 f8 21             	cmp    $0x21,%eax
  101e6e:	74 74                	je     101ee4 <trap_dispatch+0xd5>
  101e70:	e9 d1 03 00 00       	jmp    102246 <trap_dispatch+0x437>
        /* handle the timer interrupt */
        /* (1) After a timer interrupt, you should record this event using a global variable (increase it), such as ticks in kern/driver/clock.c
         * (2) Every TICK_NUM cycle, you can print some info using a funciton, such as print_ticks().
         * (3) Too Simple? Yes, I think so!
         */
        ticks ++;
  101e75:	a1 0c 0f 12 00       	mov    0x120f0c,%eax
  101e7a:	40                   	inc    %eax
  101e7b:	a3 0c 0f 12 00       	mov    %eax,0x120f0c
        if (ticks % TICK_NUM == 0) {
  101e80:	8b 0d 0c 0f 12 00    	mov    0x120f0c,%ecx
  101e86:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
  101e8b:	89 c8                	mov    %ecx,%eax
  101e8d:	f7 e2                	mul    %edx
  101e8f:	c1 ea 05             	shr    $0x5,%edx
  101e92:	89 d0                	mov    %edx,%eax
  101e94:	c1 e0 02             	shl    $0x2,%eax
  101e97:	01 d0                	add    %edx,%eax
  101e99:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  101ea0:	01 d0                	add    %edx,%eax
  101ea2:	c1 e0 02             	shl    $0x2,%eax
  101ea5:	29 c1                	sub    %eax,%ecx
  101ea7:	89 ca                	mov    %ecx,%edx
  101ea9:	85 d2                	test   %edx,%edx
  101eab:	0f 85 cd 03 00 00    	jne    10227e <trap_dispatch+0x46f>
            print_ticks();
  101eb1:	e8 df fa ff ff       	call   101995 <print_ticks>
        }
        break;
  101eb6:	e9 c3 03 00 00       	jmp    10227e <trap_dispatch+0x46f>
    case IRQ_OFFSET + IRQ_COM1:
        c = cons_getc();
  101ebb:	e8 68 f8 ff ff       	call   101728 <cons_getc>
  101ec0:	88 45 e7             	mov    %al,-0x19(%ebp)
        cprintf("serial [%03d] %c\n", c, c);
  101ec3:	0f be 55 e7          	movsbl -0x19(%ebp),%edx
  101ec7:	0f be 45 e7          	movsbl -0x19(%ebp),%eax
  101ecb:	89 54 24 08          	mov    %edx,0x8(%esp)
  101ecf:	89 44 24 04          	mov    %eax,0x4(%esp)
  101ed3:	c7 04 24 69 7d 10 00 	movl   $0x107d69,(%esp)
  101eda:	e8 e6 e3 ff ff       	call   1002c5 <cprintf>
        break;
  101edf:	e9 a4 03 00 00       	jmp    102288 <trap_dispatch+0x479>
    case IRQ_OFFSET + IRQ_KBD:
        c = cons_getc();
  101ee4:	e8 3f f8 ff ff       	call   101728 <cons_getc>
  101ee9:	88 45 e7             	mov    %al,-0x19(%ebp)
        if(c == 48){
  101eec:	80 7d e7 30          	cmpb   $0x30,-0x19(%ebp)
  101ef0:	0f 85 b3 00 00 00    	jne    101fa9 <trap_dispatch+0x19a>
            cprintf("kbd [%03d] %c\n", c, c);
  101ef6:	0f be 55 e7          	movsbl -0x19(%ebp),%edx
  101efa:	0f be 45 e7          	movsbl -0x19(%ebp),%eax
  101efe:	89 54 24 08          	mov    %edx,0x8(%esp)
  101f02:	89 44 24 04          	mov    %eax,0x4(%esp)
  101f06:	c7 04 24 7b 7d 10 00 	movl   $0x107d7b,(%esp)
  101f0d:	e8 b3 e3 ff ff       	call   1002c5 <cprintf>
            if (tf->tf_cs != KERNEL_CS) {
  101f12:	8b 45 08             	mov    0x8(%ebp),%eax
  101f15:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101f19:	83 f8 08             	cmp    $0x8,%eax
  101f1c:	0f 84 66 03 00 00    	je     102288 <trap_dispatch+0x479>
            tf->tf_cs = KERNEL_CS;
  101f22:	8b 45 08             	mov    0x8(%ebp),%eax
  101f25:	66 c7 40 3c 08 00    	movw   $0x8,0x3c(%eax)
            tf->tf_ds = tf->tf_es = KERNEL_DS;
  101f2b:	8b 45 08             	mov    0x8(%ebp),%eax
  101f2e:	66 c7 40 28 10 00    	movw   $0x10,0x28(%eax)
  101f34:	8b 45 08             	mov    0x8(%ebp),%eax
  101f37:	0f b7 50 28          	movzwl 0x28(%eax),%edx
  101f3b:	8b 45 08             	mov    0x8(%ebp),%eax
  101f3e:	66 89 50 2c          	mov    %dx,0x2c(%eax)
            tf->tf_eflags &= ~FL_IOPL_MASK;
  101f42:	8b 45 08             	mov    0x8(%ebp),%eax
  101f45:	8b 40 40             	mov    0x40(%eax),%eax
  101f48:	25 ff cf ff ff       	and    $0xffffcfff,%eax
  101f4d:	89 c2                	mov    %eax,%edx
  101f4f:	8b 45 08             	mov    0x8(%ebp),%eax
  101f52:	89 50 40             	mov    %edx,0x40(%eax)
            switchu2k = (struct trapframe *)(tf->tf_esp - (sizeof(struct trapframe) - 8));
  101f55:	8b 45 08             	mov    0x8(%ebp),%eax
  101f58:	8b 40 44             	mov    0x44(%eax),%eax
  101f5b:	83 e8 44             	sub    $0x44,%eax
  101f5e:	a3 6c 0f 12 00       	mov    %eax,0x120f6c
            memmove(switchu2k, tf, sizeof(struct trapframe) - 8);
  101f63:	a1 6c 0f 12 00       	mov    0x120f6c,%eax
  101f68:	c7 44 24 08 44 00 00 	movl   $0x44,0x8(%esp)
  101f6f:	00 
  101f70:	8b 55 08             	mov    0x8(%ebp),%edx
  101f73:	89 54 24 04          	mov    %edx,0x4(%esp)
  101f77:	89 04 24             	mov    %eax,(%esp)
  101f7a:	e8 a6 50 00 00       	call   107025 <memmove>
            *((uint32_t *)tf - 1) = (uint32_t)switchu2k;
  101f7f:	8b 15 6c 0f 12 00    	mov    0x120f6c,%edx
  101f85:	8b 45 08             	mov    0x8(%ebp),%eax
  101f88:	83 e8 04             	sub    $0x4,%eax
  101f8b:	89 10                	mov    %edx,(%eax)
            cprintf("+++ switch to kernel mode +++\n");
  101f8d:	c7 04 24 8c 7d 10 00 	movl   $0x107d8c,(%esp)
  101f94:	e8 2c e3 ff ff       	call   1002c5 <cprintf>
            print_trapframe(tf);
  101f99:	8b 45 08             	mov    0x8(%ebp),%eax
  101f9c:	89 04 24             	mov    %eax,(%esp)
  101f9f:	e8 fa fb ff ff       	call   101b9e <print_trapframe>
            print_trapframe(tf);
            panic("unexpected trap in kernel.\n");
        }
    }
}
}
  101fa4:	e9 df 02 00 00       	jmp    102288 <trap_dispatch+0x479>
        else if(c == 51){
  101fa9:	80 7d e7 33          	cmpb   $0x33,-0x19(%ebp)
  101fad:	0f 85 d5 02 00 00    	jne    102288 <trap_dispatch+0x479>
            if (tf->tf_cs != USER_CS) {
  101fb3:	8b 45 08             	mov    0x8(%ebp),%eax
  101fb6:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101fba:	83 f8 1b             	cmp    $0x1b,%eax
  101fbd:	0f 84 be 02 00 00    	je     102281 <trap_dispatch+0x472>
            cprintf("kbd [%03d] %c\n", c, c);
  101fc3:	0f be 55 e7          	movsbl -0x19(%ebp),%edx
  101fc7:	0f be 45 e7          	movsbl -0x19(%ebp),%eax
  101fcb:	89 54 24 08          	mov    %edx,0x8(%esp)
  101fcf:	89 44 24 04          	mov    %eax,0x4(%esp)
  101fd3:	c7 04 24 7b 7d 10 00 	movl   $0x107d7b,(%esp)
  101fda:	e8 e6 e2 ff ff       	call   1002c5 <cprintf>
            switchk2u = *tf;
  101fdf:	8b 55 08             	mov    0x8(%ebp),%edx
  101fe2:	b8 20 0f 12 00       	mov    $0x120f20,%eax
  101fe7:	bb 4c 00 00 00       	mov    $0x4c,%ebx
  101fec:	89 c1                	mov    %eax,%ecx
  101fee:	83 e1 01             	and    $0x1,%ecx
  101ff1:	85 c9                	test   %ecx,%ecx
  101ff3:	74 0c                	je     102001 <trap_dispatch+0x1f2>
  101ff5:	0f b6 0a             	movzbl (%edx),%ecx
  101ff8:	88 08                	mov    %cl,(%eax)
  101ffa:	8d 40 01             	lea    0x1(%eax),%eax
  101ffd:	8d 52 01             	lea    0x1(%edx),%edx
  102000:	4b                   	dec    %ebx
  102001:	89 c1                	mov    %eax,%ecx
  102003:	83 e1 02             	and    $0x2,%ecx
  102006:	85 c9                	test   %ecx,%ecx
  102008:	74 0f                	je     102019 <trap_dispatch+0x20a>
  10200a:	0f b7 0a             	movzwl (%edx),%ecx
  10200d:	66 89 08             	mov    %cx,(%eax)
  102010:	8d 40 02             	lea    0x2(%eax),%eax
  102013:	8d 52 02             	lea    0x2(%edx),%edx
  102016:	83 eb 02             	sub    $0x2,%ebx
  102019:	89 df                	mov    %ebx,%edi
  10201b:	83 e7 fc             	and    $0xfffffffc,%edi
  10201e:	b9 00 00 00 00       	mov    $0x0,%ecx
  102023:	8b 34 0a             	mov    (%edx,%ecx,1),%esi
  102026:	89 34 08             	mov    %esi,(%eax,%ecx,1)
  102029:	83 c1 04             	add    $0x4,%ecx
  10202c:	39 f9                	cmp    %edi,%ecx
  10202e:	72 f3                	jb     102023 <trap_dispatch+0x214>
  102030:	01 c8                	add    %ecx,%eax
  102032:	01 ca                	add    %ecx,%edx
  102034:	b9 00 00 00 00       	mov    $0x0,%ecx
  102039:	89 de                	mov    %ebx,%esi
  10203b:	83 e6 02             	and    $0x2,%esi
  10203e:	85 f6                	test   %esi,%esi
  102040:	74 0b                	je     10204d <trap_dispatch+0x23e>
  102042:	0f b7 34 0a          	movzwl (%edx,%ecx,1),%esi
  102046:	66 89 34 08          	mov    %si,(%eax,%ecx,1)
  10204a:	83 c1 02             	add    $0x2,%ecx
  10204d:	83 e3 01             	and    $0x1,%ebx
  102050:	85 db                	test   %ebx,%ebx
  102052:	74 07                	je     10205b <trap_dispatch+0x24c>
  102054:	0f b6 14 0a          	movzbl (%edx,%ecx,1),%edx
  102058:	88 14 08             	mov    %dl,(%eax,%ecx,1)
            switchk2u.tf_cs = USER_CS;
  10205b:	66 c7 05 5c 0f 12 00 	movw   $0x1b,0x120f5c
  102062:	1b 00 
            switchk2u.tf_ds = switchk2u.tf_es = switchk2u.tf_ss = USER_DS;
  102064:	66 c7 05 68 0f 12 00 	movw   $0x23,0x120f68
  10206b:	23 00 
  10206d:	0f b7 05 68 0f 12 00 	movzwl 0x120f68,%eax
  102074:	66 a3 48 0f 12 00    	mov    %ax,0x120f48
  10207a:	0f b7 05 48 0f 12 00 	movzwl 0x120f48,%eax
  102081:	66 a3 4c 0f 12 00    	mov    %ax,0x120f4c
            switchk2u.tf_esp = (uint32_t)tf + sizeof(struct trapframe) - 8;
  102087:	8b 45 08             	mov    0x8(%ebp),%eax
  10208a:	83 c0 44             	add    $0x44,%eax
  10208d:	a3 64 0f 12 00       	mov    %eax,0x120f64
            switchk2u.tf_eflags |= FL_IOPL_MASK;
  102092:	a1 60 0f 12 00       	mov    0x120f60,%eax
  102097:	0d 00 30 00 00       	or     $0x3000,%eax
  10209c:	a3 60 0f 12 00       	mov    %eax,0x120f60
            *((uint32_t *)tf - 1) = (uint32_t)&switchk2u;
  1020a1:	8b 45 08             	mov    0x8(%ebp),%eax
  1020a4:	83 e8 04             	sub    $0x4,%eax
  1020a7:	ba 20 0f 12 00       	mov    $0x120f20,%edx
  1020ac:	89 10                	mov    %edx,(%eax)
            cprintf("+++ switch to user mode +++\n");
  1020ae:	c7 04 24 ab 7d 10 00 	movl   $0x107dab,(%esp)
  1020b5:	e8 0b e2 ff ff       	call   1002c5 <cprintf>
            print_trapframe(tf);
  1020ba:	8b 45 08             	mov    0x8(%ebp),%eax
  1020bd:	89 04 24             	mov    %eax,(%esp)
  1020c0:	e8 d9 fa ff ff       	call   101b9e <print_trapframe>
        break;
  1020c5:	e9 b7 01 00 00       	jmp    102281 <trap_dispatch+0x472>
    if (tf->tf_cs != USER_CS) {
  1020ca:	8b 45 08             	mov    0x8(%ebp),%eax
  1020cd:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  1020d1:	83 f8 1b             	cmp    $0x1b,%eax
  1020d4:	0f 84 aa 01 00 00    	je     102284 <trap_dispatch+0x475>
            switchk2u = *tf;
  1020da:	8b 55 08             	mov    0x8(%ebp),%edx
  1020dd:	b8 20 0f 12 00       	mov    $0x120f20,%eax
  1020e2:	bb 4c 00 00 00       	mov    $0x4c,%ebx
  1020e7:	89 c1                	mov    %eax,%ecx
  1020e9:	83 e1 01             	and    $0x1,%ecx
  1020ec:	85 c9                	test   %ecx,%ecx
  1020ee:	74 0c                	je     1020fc <trap_dispatch+0x2ed>
  1020f0:	0f b6 0a             	movzbl (%edx),%ecx
  1020f3:	88 08                	mov    %cl,(%eax)
  1020f5:	8d 40 01             	lea    0x1(%eax),%eax
  1020f8:	8d 52 01             	lea    0x1(%edx),%edx
  1020fb:	4b                   	dec    %ebx
  1020fc:	89 c1                	mov    %eax,%ecx
  1020fe:	83 e1 02             	and    $0x2,%ecx
  102101:	85 c9                	test   %ecx,%ecx
  102103:	74 0f                	je     102114 <trap_dispatch+0x305>
  102105:	0f b7 0a             	movzwl (%edx),%ecx
  102108:	66 89 08             	mov    %cx,(%eax)
  10210b:	8d 40 02             	lea    0x2(%eax),%eax
  10210e:	8d 52 02             	lea    0x2(%edx),%edx
  102111:	83 eb 02             	sub    $0x2,%ebx
  102114:	89 df                	mov    %ebx,%edi
  102116:	83 e7 fc             	and    $0xfffffffc,%edi
  102119:	b9 00 00 00 00       	mov    $0x0,%ecx
  10211e:	8b 34 0a             	mov    (%edx,%ecx,1),%esi
  102121:	89 34 08             	mov    %esi,(%eax,%ecx,1)
  102124:	83 c1 04             	add    $0x4,%ecx
  102127:	39 f9                	cmp    %edi,%ecx
  102129:	72 f3                	jb     10211e <trap_dispatch+0x30f>
  10212b:	01 c8                	add    %ecx,%eax
  10212d:	01 ca                	add    %ecx,%edx
  10212f:	b9 00 00 00 00       	mov    $0x0,%ecx
  102134:	89 de                	mov    %ebx,%esi
  102136:	83 e6 02             	and    $0x2,%esi
  102139:	85 f6                	test   %esi,%esi
  10213b:	74 0b                	je     102148 <trap_dispatch+0x339>
  10213d:	0f b7 34 0a          	movzwl (%edx,%ecx,1),%esi
  102141:	66 89 34 08          	mov    %si,(%eax,%ecx,1)
  102145:	83 c1 02             	add    $0x2,%ecx
  102148:	83 e3 01             	and    $0x1,%ebx
  10214b:	85 db                	test   %ebx,%ebx
  10214d:	74 07                	je     102156 <trap_dispatch+0x347>
  10214f:	0f b6 14 0a          	movzbl (%edx,%ecx,1),%edx
  102153:	88 14 08             	mov    %dl,(%eax,%ecx,1)
            switchk2u.tf_cs = USER_CS;
  102156:	66 c7 05 5c 0f 12 00 	movw   $0x1b,0x120f5c
  10215d:	1b 00 
            switchk2u.tf_ds = USER_DS;
  10215f:	66 c7 05 4c 0f 12 00 	movw   $0x23,0x120f4c
  102166:	23 00 
            switchk2u.tf_es = USER_DS;
  102168:	66 c7 05 48 0f 12 00 	movw   $0x23,0x120f48
  10216f:	23 00 
            switchk2u.tf_ss = USER_DS;
  102171:	66 c7 05 68 0f 12 00 	movw   $0x23,0x120f68
  102178:	23 00 
            switchk2u.tf_esp = (uint32_t)tf + sizeof(struct trapframe) - 8;
  10217a:	8b 45 08             	mov    0x8(%ebp),%eax
  10217d:	83 c0 44             	add    $0x44,%eax
  102180:	a3 64 0f 12 00       	mov    %eax,0x120f64
            switchk2u.tf_eflags |= FL_IOPL_MASK;
  102185:	a1 60 0f 12 00       	mov    0x120f60,%eax
  10218a:	0d 00 30 00 00       	or     $0x3000,%eax
  10218f:	a3 60 0f 12 00       	mov    %eax,0x120f60
            *((uint32_t *)tf - 1) = (uint32_t)&switchk2u;
  102194:	8b 45 08             	mov    0x8(%ebp),%eax
  102197:	83 e8 04             	sub    $0x4,%eax
  10219a:	ba 20 0f 12 00       	mov    $0x120f20,%edx
  10219f:	89 10                	mov    %edx,(%eax)
            print_trapframe(&switchk2u);
  1021a1:	c7 04 24 20 0f 12 00 	movl   $0x120f20,(%esp)
  1021a8:	e8 f1 f9 ff ff       	call   101b9e <print_trapframe>
        break;
  1021ad:	e9 d2 00 00 00       	jmp    102284 <trap_dispatch+0x475>
    print_trapframe(tf);
  1021b2:	8b 45 08             	mov    0x8(%ebp),%eax
  1021b5:	89 04 24             	mov    %eax,(%esp)
  1021b8:	e8 e1 f9 ff ff       	call   101b9e <print_trapframe>
    if (tf->tf_cs != KERNEL_CS) {
  1021bd:	8b 45 08             	mov    0x8(%ebp),%eax
  1021c0:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  1021c4:	83 f8 08             	cmp    $0x8,%eax
  1021c7:	0f 84 ba 00 00 00    	je     102287 <trap_dispatch+0x478>
            tf->tf_cs = KERNEL_CS;
  1021cd:	8b 45 08             	mov    0x8(%ebp),%eax
  1021d0:	66 c7 40 3c 08 00    	movw   $0x8,0x3c(%eax)
            tf->tf_ds = tf->tf_es = KERNEL_DS;
  1021d6:	8b 45 08             	mov    0x8(%ebp),%eax
  1021d9:	66 c7 40 28 10 00    	movw   $0x10,0x28(%eax)
  1021df:	8b 45 08             	mov    0x8(%ebp),%eax
  1021e2:	0f b7 50 28          	movzwl 0x28(%eax),%edx
  1021e6:	8b 45 08             	mov    0x8(%ebp),%eax
  1021e9:	66 89 50 2c          	mov    %dx,0x2c(%eax)
            tf->tf_eflags &= ~FL_IOPL_MASK;
  1021ed:	8b 45 08             	mov    0x8(%ebp),%eax
  1021f0:	8b 40 40             	mov    0x40(%eax),%eax
  1021f3:	25 ff cf ff ff       	and    $0xffffcfff,%eax
  1021f8:	89 c2                	mov    %eax,%edx
  1021fa:	8b 45 08             	mov    0x8(%ebp),%eax
  1021fd:	89 50 40             	mov    %edx,0x40(%eax)
            switchu2k = (struct trapframe *)(tf->tf_esp - (sizeof(struct trapframe) - 8));
  102200:	8b 45 08             	mov    0x8(%ebp),%eax
  102203:	8b 40 44             	mov    0x44(%eax),%eax
  102206:	83 e8 44             	sub    $0x44,%eax
  102209:	a3 6c 0f 12 00       	mov    %eax,0x120f6c
            memmove(switchu2k, tf, sizeof(struct trapframe) - 8);
  10220e:	a1 6c 0f 12 00       	mov    0x120f6c,%eax
  102213:	c7 44 24 08 44 00 00 	movl   $0x44,0x8(%esp)
  10221a:	00 
  10221b:	8b 55 08             	mov    0x8(%ebp),%edx
  10221e:	89 54 24 04          	mov    %edx,0x4(%esp)
  102222:	89 04 24             	mov    %eax,(%esp)
  102225:	e8 fb 4d 00 00       	call   107025 <memmove>
            *((uint32_t *)tf - 1) = (uint32_t)switchu2k;
  10222a:	8b 15 6c 0f 12 00    	mov    0x120f6c,%edx
  102230:	8b 45 08             	mov    0x8(%ebp),%eax
  102233:	83 e8 04             	sub    $0x4,%eax
  102236:	89 10                	mov    %edx,(%eax)
            print_trapframe(&switchu2k);
  102238:	c7 04 24 6c 0f 12 00 	movl   $0x120f6c,(%esp)
  10223f:	e8 5a f9 ff ff       	call   101b9e <print_trapframe>
        break;
  102244:	eb 41                	jmp    102287 <trap_dispatch+0x478>
        if ((tf->tf_cs & 3) == 0) {
  102246:	8b 45 08             	mov    0x8(%ebp),%eax
  102249:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  10224d:	83 e0 03             	and    $0x3,%eax
  102250:	85 c0                	test   %eax,%eax
  102252:	75 34                	jne    102288 <trap_dispatch+0x479>
            print_trapframe(tf);
  102254:	8b 45 08             	mov    0x8(%ebp),%eax
  102257:	89 04 24             	mov    %eax,(%esp)
  10225a:	e8 3f f9 ff ff       	call   101b9e <print_trapframe>
            panic("unexpected trap in kernel.\n");
  10225f:	c7 44 24 08 c8 7d 10 	movl   $0x107dc8,0x8(%esp)
  102266:	00 
  102267:	c7 44 24 04 fc 00 00 	movl   $0xfc,0x4(%esp)
  10226e:	00 
  10226f:	c7 04 24 ae 7b 10 00 	movl   $0x107bae,(%esp)
  102276:	e8 b6 e1 ff ff       	call   100431 <__panic>
        break;
  10227b:	90                   	nop
  10227c:	eb 0a                	jmp    102288 <trap_dispatch+0x479>
        break;
  10227e:	90                   	nop
  10227f:	eb 07                	jmp    102288 <trap_dispatch+0x479>
        break;
  102281:	90                   	nop
  102282:	eb 04                	jmp    102288 <trap_dispatch+0x479>
        break;
  102284:	90                   	nop
  102285:	eb 01                	jmp    102288 <trap_dispatch+0x479>
        break;
  102287:	90                   	nop
}
  102288:	90                   	nop
  102289:	83 c4 2c             	add    $0x2c,%esp
  10228c:	5b                   	pop    %ebx
  10228d:	5e                   	pop    %esi
  10228e:	5f                   	pop    %edi
  10228f:	5d                   	pop    %ebp
  102290:	c3                   	ret    

00102291 <trap>:
 * trap - handles or dispatches an exception/interrupt. if and when trap() returns,
 * the code in kern/trap/trapentry.S restores the old CPU state saved in the
 * trapframe and then uses the iret instruction to return from the exception.
 * */
void
trap(struct trapframe *tf) {
  102291:	f3 0f 1e fb          	endbr32 
  102295:	55                   	push   %ebp
  102296:	89 e5                	mov    %esp,%ebp
  102298:	83 ec 18             	sub    $0x18,%esp
    // dispatch based on what type of trap occurred
    trap_dispatch(tf);
  10229b:	8b 45 08             	mov    0x8(%ebp),%eax
  10229e:	89 04 24             	mov    %eax,(%esp)
  1022a1:	e8 69 fb ff ff       	call   101e0f <trap_dispatch>
}
  1022a6:	90                   	nop
  1022a7:	c9                   	leave  
  1022a8:	c3                   	ret    

001022a9 <vector0>:
# handler
.text
.globl __alltraps
.globl vector0
vector0:
  pushl $0
  1022a9:	6a 00                	push   $0x0
  pushl $0
  1022ab:	6a 00                	push   $0x0
  jmp __alltraps
  1022ad:	e9 69 0a 00 00       	jmp    102d1b <__alltraps>

001022b2 <vector1>:
.globl vector1
vector1:
  pushl $0
  1022b2:	6a 00                	push   $0x0
  pushl $1
  1022b4:	6a 01                	push   $0x1
  jmp __alltraps
  1022b6:	e9 60 0a 00 00       	jmp    102d1b <__alltraps>

001022bb <vector2>:
.globl vector2
vector2:
  pushl $0
  1022bb:	6a 00                	push   $0x0
  pushl $2
  1022bd:	6a 02                	push   $0x2
  jmp __alltraps
  1022bf:	e9 57 0a 00 00       	jmp    102d1b <__alltraps>

001022c4 <vector3>:
.globl vector3
vector3:
  pushl $0
  1022c4:	6a 00                	push   $0x0
  pushl $3
  1022c6:	6a 03                	push   $0x3
  jmp __alltraps
  1022c8:	e9 4e 0a 00 00       	jmp    102d1b <__alltraps>

001022cd <vector4>:
.globl vector4
vector4:
  pushl $0
  1022cd:	6a 00                	push   $0x0
  pushl $4
  1022cf:	6a 04                	push   $0x4
  jmp __alltraps
  1022d1:	e9 45 0a 00 00       	jmp    102d1b <__alltraps>

001022d6 <vector5>:
.globl vector5
vector5:
  pushl $0
  1022d6:	6a 00                	push   $0x0
  pushl $5
  1022d8:	6a 05                	push   $0x5
  jmp __alltraps
  1022da:	e9 3c 0a 00 00       	jmp    102d1b <__alltraps>

001022df <vector6>:
.globl vector6
vector6:
  pushl $0
  1022df:	6a 00                	push   $0x0
  pushl $6
  1022e1:	6a 06                	push   $0x6
  jmp __alltraps
  1022e3:	e9 33 0a 00 00       	jmp    102d1b <__alltraps>

001022e8 <vector7>:
.globl vector7
vector7:
  pushl $0
  1022e8:	6a 00                	push   $0x0
  pushl $7
  1022ea:	6a 07                	push   $0x7
  jmp __alltraps
  1022ec:	e9 2a 0a 00 00       	jmp    102d1b <__alltraps>

001022f1 <vector8>:
.globl vector8
vector8:
  pushl $8
  1022f1:	6a 08                	push   $0x8
  jmp __alltraps
  1022f3:	e9 23 0a 00 00       	jmp    102d1b <__alltraps>

001022f8 <vector9>:
.globl vector9
vector9:
  pushl $0
  1022f8:	6a 00                	push   $0x0
  pushl $9
  1022fa:	6a 09                	push   $0x9
  jmp __alltraps
  1022fc:	e9 1a 0a 00 00       	jmp    102d1b <__alltraps>

00102301 <vector10>:
.globl vector10
vector10:
  pushl $10
  102301:	6a 0a                	push   $0xa
  jmp __alltraps
  102303:	e9 13 0a 00 00       	jmp    102d1b <__alltraps>

00102308 <vector11>:
.globl vector11
vector11:
  pushl $11
  102308:	6a 0b                	push   $0xb
  jmp __alltraps
  10230a:	e9 0c 0a 00 00       	jmp    102d1b <__alltraps>

0010230f <vector12>:
.globl vector12
vector12:
  pushl $12
  10230f:	6a 0c                	push   $0xc
  jmp __alltraps
  102311:	e9 05 0a 00 00       	jmp    102d1b <__alltraps>

00102316 <vector13>:
.globl vector13
vector13:
  pushl $13
  102316:	6a 0d                	push   $0xd
  jmp __alltraps
  102318:	e9 fe 09 00 00       	jmp    102d1b <__alltraps>

0010231d <vector14>:
.globl vector14
vector14:
  pushl $14
  10231d:	6a 0e                	push   $0xe
  jmp __alltraps
  10231f:	e9 f7 09 00 00       	jmp    102d1b <__alltraps>

00102324 <vector15>:
.globl vector15
vector15:
  pushl $0
  102324:	6a 00                	push   $0x0
  pushl $15
  102326:	6a 0f                	push   $0xf
  jmp __alltraps
  102328:	e9 ee 09 00 00       	jmp    102d1b <__alltraps>

0010232d <vector16>:
.globl vector16
vector16:
  pushl $0
  10232d:	6a 00                	push   $0x0
  pushl $16
  10232f:	6a 10                	push   $0x10
  jmp __alltraps
  102331:	e9 e5 09 00 00       	jmp    102d1b <__alltraps>

00102336 <vector17>:
.globl vector17
vector17:
  pushl $17
  102336:	6a 11                	push   $0x11
  jmp __alltraps
  102338:	e9 de 09 00 00       	jmp    102d1b <__alltraps>

0010233d <vector18>:
.globl vector18
vector18:
  pushl $0
  10233d:	6a 00                	push   $0x0
  pushl $18
  10233f:	6a 12                	push   $0x12
  jmp __alltraps
  102341:	e9 d5 09 00 00       	jmp    102d1b <__alltraps>

00102346 <vector19>:
.globl vector19
vector19:
  pushl $0
  102346:	6a 00                	push   $0x0
  pushl $19
  102348:	6a 13                	push   $0x13
  jmp __alltraps
  10234a:	e9 cc 09 00 00       	jmp    102d1b <__alltraps>

0010234f <vector20>:
.globl vector20
vector20:
  pushl $0
  10234f:	6a 00                	push   $0x0
  pushl $20
  102351:	6a 14                	push   $0x14
  jmp __alltraps
  102353:	e9 c3 09 00 00       	jmp    102d1b <__alltraps>

00102358 <vector21>:
.globl vector21
vector21:
  pushl $0
  102358:	6a 00                	push   $0x0
  pushl $21
  10235a:	6a 15                	push   $0x15
  jmp __alltraps
  10235c:	e9 ba 09 00 00       	jmp    102d1b <__alltraps>

00102361 <vector22>:
.globl vector22
vector22:
  pushl $0
  102361:	6a 00                	push   $0x0
  pushl $22
  102363:	6a 16                	push   $0x16
  jmp __alltraps
  102365:	e9 b1 09 00 00       	jmp    102d1b <__alltraps>

0010236a <vector23>:
.globl vector23
vector23:
  pushl $0
  10236a:	6a 00                	push   $0x0
  pushl $23
  10236c:	6a 17                	push   $0x17
  jmp __alltraps
  10236e:	e9 a8 09 00 00       	jmp    102d1b <__alltraps>

00102373 <vector24>:
.globl vector24
vector24:
  pushl $0
  102373:	6a 00                	push   $0x0
  pushl $24
  102375:	6a 18                	push   $0x18
  jmp __alltraps
  102377:	e9 9f 09 00 00       	jmp    102d1b <__alltraps>

0010237c <vector25>:
.globl vector25
vector25:
  pushl $0
  10237c:	6a 00                	push   $0x0
  pushl $25
  10237e:	6a 19                	push   $0x19
  jmp __alltraps
  102380:	e9 96 09 00 00       	jmp    102d1b <__alltraps>

00102385 <vector26>:
.globl vector26
vector26:
  pushl $0
  102385:	6a 00                	push   $0x0
  pushl $26
  102387:	6a 1a                	push   $0x1a
  jmp __alltraps
  102389:	e9 8d 09 00 00       	jmp    102d1b <__alltraps>

0010238e <vector27>:
.globl vector27
vector27:
  pushl $0
  10238e:	6a 00                	push   $0x0
  pushl $27
  102390:	6a 1b                	push   $0x1b
  jmp __alltraps
  102392:	e9 84 09 00 00       	jmp    102d1b <__alltraps>

00102397 <vector28>:
.globl vector28
vector28:
  pushl $0
  102397:	6a 00                	push   $0x0
  pushl $28
  102399:	6a 1c                	push   $0x1c
  jmp __alltraps
  10239b:	e9 7b 09 00 00       	jmp    102d1b <__alltraps>

001023a0 <vector29>:
.globl vector29
vector29:
  pushl $0
  1023a0:	6a 00                	push   $0x0
  pushl $29
  1023a2:	6a 1d                	push   $0x1d
  jmp __alltraps
  1023a4:	e9 72 09 00 00       	jmp    102d1b <__alltraps>

001023a9 <vector30>:
.globl vector30
vector30:
  pushl $0
  1023a9:	6a 00                	push   $0x0
  pushl $30
  1023ab:	6a 1e                	push   $0x1e
  jmp __alltraps
  1023ad:	e9 69 09 00 00       	jmp    102d1b <__alltraps>

001023b2 <vector31>:
.globl vector31
vector31:
  pushl $0
  1023b2:	6a 00                	push   $0x0
  pushl $31
  1023b4:	6a 1f                	push   $0x1f
  jmp __alltraps
  1023b6:	e9 60 09 00 00       	jmp    102d1b <__alltraps>

001023bb <vector32>:
.globl vector32
vector32:
  pushl $0
  1023bb:	6a 00                	push   $0x0
  pushl $32
  1023bd:	6a 20                	push   $0x20
  jmp __alltraps
  1023bf:	e9 57 09 00 00       	jmp    102d1b <__alltraps>

001023c4 <vector33>:
.globl vector33
vector33:
  pushl $0
  1023c4:	6a 00                	push   $0x0
  pushl $33
  1023c6:	6a 21                	push   $0x21
  jmp __alltraps
  1023c8:	e9 4e 09 00 00       	jmp    102d1b <__alltraps>

001023cd <vector34>:
.globl vector34
vector34:
  pushl $0
  1023cd:	6a 00                	push   $0x0
  pushl $34
  1023cf:	6a 22                	push   $0x22
  jmp __alltraps
  1023d1:	e9 45 09 00 00       	jmp    102d1b <__alltraps>

001023d6 <vector35>:
.globl vector35
vector35:
  pushl $0
  1023d6:	6a 00                	push   $0x0
  pushl $35
  1023d8:	6a 23                	push   $0x23
  jmp __alltraps
  1023da:	e9 3c 09 00 00       	jmp    102d1b <__alltraps>

001023df <vector36>:
.globl vector36
vector36:
  pushl $0
  1023df:	6a 00                	push   $0x0
  pushl $36
  1023e1:	6a 24                	push   $0x24
  jmp __alltraps
  1023e3:	e9 33 09 00 00       	jmp    102d1b <__alltraps>

001023e8 <vector37>:
.globl vector37
vector37:
  pushl $0
  1023e8:	6a 00                	push   $0x0
  pushl $37
  1023ea:	6a 25                	push   $0x25
  jmp __alltraps
  1023ec:	e9 2a 09 00 00       	jmp    102d1b <__alltraps>

001023f1 <vector38>:
.globl vector38
vector38:
  pushl $0
  1023f1:	6a 00                	push   $0x0
  pushl $38
  1023f3:	6a 26                	push   $0x26
  jmp __alltraps
  1023f5:	e9 21 09 00 00       	jmp    102d1b <__alltraps>

001023fa <vector39>:
.globl vector39
vector39:
  pushl $0
  1023fa:	6a 00                	push   $0x0
  pushl $39
  1023fc:	6a 27                	push   $0x27
  jmp __alltraps
  1023fe:	e9 18 09 00 00       	jmp    102d1b <__alltraps>

00102403 <vector40>:
.globl vector40
vector40:
  pushl $0
  102403:	6a 00                	push   $0x0
  pushl $40
  102405:	6a 28                	push   $0x28
  jmp __alltraps
  102407:	e9 0f 09 00 00       	jmp    102d1b <__alltraps>

0010240c <vector41>:
.globl vector41
vector41:
  pushl $0
  10240c:	6a 00                	push   $0x0
  pushl $41
  10240e:	6a 29                	push   $0x29
  jmp __alltraps
  102410:	e9 06 09 00 00       	jmp    102d1b <__alltraps>

00102415 <vector42>:
.globl vector42
vector42:
  pushl $0
  102415:	6a 00                	push   $0x0
  pushl $42
  102417:	6a 2a                	push   $0x2a
  jmp __alltraps
  102419:	e9 fd 08 00 00       	jmp    102d1b <__alltraps>

0010241e <vector43>:
.globl vector43
vector43:
  pushl $0
  10241e:	6a 00                	push   $0x0
  pushl $43
  102420:	6a 2b                	push   $0x2b
  jmp __alltraps
  102422:	e9 f4 08 00 00       	jmp    102d1b <__alltraps>

00102427 <vector44>:
.globl vector44
vector44:
  pushl $0
  102427:	6a 00                	push   $0x0
  pushl $44
  102429:	6a 2c                	push   $0x2c
  jmp __alltraps
  10242b:	e9 eb 08 00 00       	jmp    102d1b <__alltraps>

00102430 <vector45>:
.globl vector45
vector45:
  pushl $0
  102430:	6a 00                	push   $0x0
  pushl $45
  102432:	6a 2d                	push   $0x2d
  jmp __alltraps
  102434:	e9 e2 08 00 00       	jmp    102d1b <__alltraps>

00102439 <vector46>:
.globl vector46
vector46:
  pushl $0
  102439:	6a 00                	push   $0x0
  pushl $46
  10243b:	6a 2e                	push   $0x2e
  jmp __alltraps
  10243d:	e9 d9 08 00 00       	jmp    102d1b <__alltraps>

00102442 <vector47>:
.globl vector47
vector47:
  pushl $0
  102442:	6a 00                	push   $0x0
  pushl $47
  102444:	6a 2f                	push   $0x2f
  jmp __alltraps
  102446:	e9 d0 08 00 00       	jmp    102d1b <__alltraps>

0010244b <vector48>:
.globl vector48
vector48:
  pushl $0
  10244b:	6a 00                	push   $0x0
  pushl $48
  10244d:	6a 30                	push   $0x30
  jmp __alltraps
  10244f:	e9 c7 08 00 00       	jmp    102d1b <__alltraps>

00102454 <vector49>:
.globl vector49
vector49:
  pushl $0
  102454:	6a 00                	push   $0x0
  pushl $49
  102456:	6a 31                	push   $0x31
  jmp __alltraps
  102458:	e9 be 08 00 00       	jmp    102d1b <__alltraps>

0010245d <vector50>:
.globl vector50
vector50:
  pushl $0
  10245d:	6a 00                	push   $0x0
  pushl $50
  10245f:	6a 32                	push   $0x32
  jmp __alltraps
  102461:	e9 b5 08 00 00       	jmp    102d1b <__alltraps>

00102466 <vector51>:
.globl vector51
vector51:
  pushl $0
  102466:	6a 00                	push   $0x0
  pushl $51
  102468:	6a 33                	push   $0x33
  jmp __alltraps
  10246a:	e9 ac 08 00 00       	jmp    102d1b <__alltraps>

0010246f <vector52>:
.globl vector52
vector52:
  pushl $0
  10246f:	6a 00                	push   $0x0
  pushl $52
  102471:	6a 34                	push   $0x34
  jmp __alltraps
  102473:	e9 a3 08 00 00       	jmp    102d1b <__alltraps>

00102478 <vector53>:
.globl vector53
vector53:
  pushl $0
  102478:	6a 00                	push   $0x0
  pushl $53
  10247a:	6a 35                	push   $0x35
  jmp __alltraps
  10247c:	e9 9a 08 00 00       	jmp    102d1b <__alltraps>

00102481 <vector54>:
.globl vector54
vector54:
  pushl $0
  102481:	6a 00                	push   $0x0
  pushl $54
  102483:	6a 36                	push   $0x36
  jmp __alltraps
  102485:	e9 91 08 00 00       	jmp    102d1b <__alltraps>

0010248a <vector55>:
.globl vector55
vector55:
  pushl $0
  10248a:	6a 00                	push   $0x0
  pushl $55
  10248c:	6a 37                	push   $0x37
  jmp __alltraps
  10248e:	e9 88 08 00 00       	jmp    102d1b <__alltraps>

00102493 <vector56>:
.globl vector56
vector56:
  pushl $0
  102493:	6a 00                	push   $0x0
  pushl $56
  102495:	6a 38                	push   $0x38
  jmp __alltraps
  102497:	e9 7f 08 00 00       	jmp    102d1b <__alltraps>

0010249c <vector57>:
.globl vector57
vector57:
  pushl $0
  10249c:	6a 00                	push   $0x0
  pushl $57
  10249e:	6a 39                	push   $0x39
  jmp __alltraps
  1024a0:	e9 76 08 00 00       	jmp    102d1b <__alltraps>

001024a5 <vector58>:
.globl vector58
vector58:
  pushl $0
  1024a5:	6a 00                	push   $0x0
  pushl $58
  1024a7:	6a 3a                	push   $0x3a
  jmp __alltraps
  1024a9:	e9 6d 08 00 00       	jmp    102d1b <__alltraps>

001024ae <vector59>:
.globl vector59
vector59:
  pushl $0
  1024ae:	6a 00                	push   $0x0
  pushl $59
  1024b0:	6a 3b                	push   $0x3b
  jmp __alltraps
  1024b2:	e9 64 08 00 00       	jmp    102d1b <__alltraps>

001024b7 <vector60>:
.globl vector60
vector60:
  pushl $0
  1024b7:	6a 00                	push   $0x0
  pushl $60
  1024b9:	6a 3c                	push   $0x3c
  jmp __alltraps
  1024bb:	e9 5b 08 00 00       	jmp    102d1b <__alltraps>

001024c0 <vector61>:
.globl vector61
vector61:
  pushl $0
  1024c0:	6a 00                	push   $0x0
  pushl $61
  1024c2:	6a 3d                	push   $0x3d
  jmp __alltraps
  1024c4:	e9 52 08 00 00       	jmp    102d1b <__alltraps>

001024c9 <vector62>:
.globl vector62
vector62:
  pushl $0
  1024c9:	6a 00                	push   $0x0
  pushl $62
  1024cb:	6a 3e                	push   $0x3e
  jmp __alltraps
  1024cd:	e9 49 08 00 00       	jmp    102d1b <__alltraps>

001024d2 <vector63>:
.globl vector63
vector63:
  pushl $0
  1024d2:	6a 00                	push   $0x0
  pushl $63
  1024d4:	6a 3f                	push   $0x3f
  jmp __alltraps
  1024d6:	e9 40 08 00 00       	jmp    102d1b <__alltraps>

001024db <vector64>:
.globl vector64
vector64:
  pushl $0
  1024db:	6a 00                	push   $0x0
  pushl $64
  1024dd:	6a 40                	push   $0x40
  jmp __alltraps
  1024df:	e9 37 08 00 00       	jmp    102d1b <__alltraps>

001024e4 <vector65>:
.globl vector65
vector65:
  pushl $0
  1024e4:	6a 00                	push   $0x0
  pushl $65
  1024e6:	6a 41                	push   $0x41
  jmp __alltraps
  1024e8:	e9 2e 08 00 00       	jmp    102d1b <__alltraps>

001024ed <vector66>:
.globl vector66
vector66:
  pushl $0
  1024ed:	6a 00                	push   $0x0
  pushl $66
  1024ef:	6a 42                	push   $0x42
  jmp __alltraps
  1024f1:	e9 25 08 00 00       	jmp    102d1b <__alltraps>

001024f6 <vector67>:
.globl vector67
vector67:
  pushl $0
  1024f6:	6a 00                	push   $0x0
  pushl $67
  1024f8:	6a 43                	push   $0x43
  jmp __alltraps
  1024fa:	e9 1c 08 00 00       	jmp    102d1b <__alltraps>

001024ff <vector68>:
.globl vector68
vector68:
  pushl $0
  1024ff:	6a 00                	push   $0x0
  pushl $68
  102501:	6a 44                	push   $0x44
  jmp __alltraps
  102503:	e9 13 08 00 00       	jmp    102d1b <__alltraps>

00102508 <vector69>:
.globl vector69
vector69:
  pushl $0
  102508:	6a 00                	push   $0x0
  pushl $69
  10250a:	6a 45                	push   $0x45
  jmp __alltraps
  10250c:	e9 0a 08 00 00       	jmp    102d1b <__alltraps>

00102511 <vector70>:
.globl vector70
vector70:
  pushl $0
  102511:	6a 00                	push   $0x0
  pushl $70
  102513:	6a 46                	push   $0x46
  jmp __alltraps
  102515:	e9 01 08 00 00       	jmp    102d1b <__alltraps>

0010251a <vector71>:
.globl vector71
vector71:
  pushl $0
  10251a:	6a 00                	push   $0x0
  pushl $71
  10251c:	6a 47                	push   $0x47
  jmp __alltraps
  10251e:	e9 f8 07 00 00       	jmp    102d1b <__alltraps>

00102523 <vector72>:
.globl vector72
vector72:
  pushl $0
  102523:	6a 00                	push   $0x0
  pushl $72
  102525:	6a 48                	push   $0x48
  jmp __alltraps
  102527:	e9 ef 07 00 00       	jmp    102d1b <__alltraps>

0010252c <vector73>:
.globl vector73
vector73:
  pushl $0
  10252c:	6a 00                	push   $0x0
  pushl $73
  10252e:	6a 49                	push   $0x49
  jmp __alltraps
  102530:	e9 e6 07 00 00       	jmp    102d1b <__alltraps>

00102535 <vector74>:
.globl vector74
vector74:
  pushl $0
  102535:	6a 00                	push   $0x0
  pushl $74
  102537:	6a 4a                	push   $0x4a
  jmp __alltraps
  102539:	e9 dd 07 00 00       	jmp    102d1b <__alltraps>

0010253e <vector75>:
.globl vector75
vector75:
  pushl $0
  10253e:	6a 00                	push   $0x0
  pushl $75
  102540:	6a 4b                	push   $0x4b
  jmp __alltraps
  102542:	e9 d4 07 00 00       	jmp    102d1b <__alltraps>

00102547 <vector76>:
.globl vector76
vector76:
  pushl $0
  102547:	6a 00                	push   $0x0
  pushl $76
  102549:	6a 4c                	push   $0x4c
  jmp __alltraps
  10254b:	e9 cb 07 00 00       	jmp    102d1b <__alltraps>

00102550 <vector77>:
.globl vector77
vector77:
  pushl $0
  102550:	6a 00                	push   $0x0
  pushl $77
  102552:	6a 4d                	push   $0x4d
  jmp __alltraps
  102554:	e9 c2 07 00 00       	jmp    102d1b <__alltraps>

00102559 <vector78>:
.globl vector78
vector78:
  pushl $0
  102559:	6a 00                	push   $0x0
  pushl $78
  10255b:	6a 4e                	push   $0x4e
  jmp __alltraps
  10255d:	e9 b9 07 00 00       	jmp    102d1b <__alltraps>

00102562 <vector79>:
.globl vector79
vector79:
  pushl $0
  102562:	6a 00                	push   $0x0
  pushl $79
  102564:	6a 4f                	push   $0x4f
  jmp __alltraps
  102566:	e9 b0 07 00 00       	jmp    102d1b <__alltraps>

0010256b <vector80>:
.globl vector80
vector80:
  pushl $0
  10256b:	6a 00                	push   $0x0
  pushl $80
  10256d:	6a 50                	push   $0x50
  jmp __alltraps
  10256f:	e9 a7 07 00 00       	jmp    102d1b <__alltraps>

00102574 <vector81>:
.globl vector81
vector81:
  pushl $0
  102574:	6a 00                	push   $0x0
  pushl $81
  102576:	6a 51                	push   $0x51
  jmp __alltraps
  102578:	e9 9e 07 00 00       	jmp    102d1b <__alltraps>

0010257d <vector82>:
.globl vector82
vector82:
  pushl $0
  10257d:	6a 00                	push   $0x0
  pushl $82
  10257f:	6a 52                	push   $0x52
  jmp __alltraps
  102581:	e9 95 07 00 00       	jmp    102d1b <__alltraps>

00102586 <vector83>:
.globl vector83
vector83:
  pushl $0
  102586:	6a 00                	push   $0x0
  pushl $83
  102588:	6a 53                	push   $0x53
  jmp __alltraps
  10258a:	e9 8c 07 00 00       	jmp    102d1b <__alltraps>

0010258f <vector84>:
.globl vector84
vector84:
  pushl $0
  10258f:	6a 00                	push   $0x0
  pushl $84
  102591:	6a 54                	push   $0x54
  jmp __alltraps
  102593:	e9 83 07 00 00       	jmp    102d1b <__alltraps>

00102598 <vector85>:
.globl vector85
vector85:
  pushl $0
  102598:	6a 00                	push   $0x0
  pushl $85
  10259a:	6a 55                	push   $0x55
  jmp __alltraps
  10259c:	e9 7a 07 00 00       	jmp    102d1b <__alltraps>

001025a1 <vector86>:
.globl vector86
vector86:
  pushl $0
  1025a1:	6a 00                	push   $0x0
  pushl $86
  1025a3:	6a 56                	push   $0x56
  jmp __alltraps
  1025a5:	e9 71 07 00 00       	jmp    102d1b <__alltraps>

001025aa <vector87>:
.globl vector87
vector87:
  pushl $0
  1025aa:	6a 00                	push   $0x0
  pushl $87
  1025ac:	6a 57                	push   $0x57
  jmp __alltraps
  1025ae:	e9 68 07 00 00       	jmp    102d1b <__alltraps>

001025b3 <vector88>:
.globl vector88
vector88:
  pushl $0
  1025b3:	6a 00                	push   $0x0
  pushl $88
  1025b5:	6a 58                	push   $0x58
  jmp __alltraps
  1025b7:	e9 5f 07 00 00       	jmp    102d1b <__alltraps>

001025bc <vector89>:
.globl vector89
vector89:
  pushl $0
  1025bc:	6a 00                	push   $0x0
  pushl $89
  1025be:	6a 59                	push   $0x59
  jmp __alltraps
  1025c0:	e9 56 07 00 00       	jmp    102d1b <__alltraps>

001025c5 <vector90>:
.globl vector90
vector90:
  pushl $0
  1025c5:	6a 00                	push   $0x0
  pushl $90
  1025c7:	6a 5a                	push   $0x5a
  jmp __alltraps
  1025c9:	e9 4d 07 00 00       	jmp    102d1b <__alltraps>

001025ce <vector91>:
.globl vector91
vector91:
  pushl $0
  1025ce:	6a 00                	push   $0x0
  pushl $91
  1025d0:	6a 5b                	push   $0x5b
  jmp __alltraps
  1025d2:	e9 44 07 00 00       	jmp    102d1b <__alltraps>

001025d7 <vector92>:
.globl vector92
vector92:
  pushl $0
  1025d7:	6a 00                	push   $0x0
  pushl $92
  1025d9:	6a 5c                	push   $0x5c
  jmp __alltraps
  1025db:	e9 3b 07 00 00       	jmp    102d1b <__alltraps>

001025e0 <vector93>:
.globl vector93
vector93:
  pushl $0
  1025e0:	6a 00                	push   $0x0
  pushl $93
  1025e2:	6a 5d                	push   $0x5d
  jmp __alltraps
  1025e4:	e9 32 07 00 00       	jmp    102d1b <__alltraps>

001025e9 <vector94>:
.globl vector94
vector94:
  pushl $0
  1025e9:	6a 00                	push   $0x0
  pushl $94
  1025eb:	6a 5e                	push   $0x5e
  jmp __alltraps
  1025ed:	e9 29 07 00 00       	jmp    102d1b <__alltraps>

001025f2 <vector95>:
.globl vector95
vector95:
  pushl $0
  1025f2:	6a 00                	push   $0x0
  pushl $95
  1025f4:	6a 5f                	push   $0x5f
  jmp __alltraps
  1025f6:	e9 20 07 00 00       	jmp    102d1b <__alltraps>

001025fb <vector96>:
.globl vector96
vector96:
  pushl $0
  1025fb:	6a 00                	push   $0x0
  pushl $96
  1025fd:	6a 60                	push   $0x60
  jmp __alltraps
  1025ff:	e9 17 07 00 00       	jmp    102d1b <__alltraps>

00102604 <vector97>:
.globl vector97
vector97:
  pushl $0
  102604:	6a 00                	push   $0x0
  pushl $97
  102606:	6a 61                	push   $0x61
  jmp __alltraps
  102608:	e9 0e 07 00 00       	jmp    102d1b <__alltraps>

0010260d <vector98>:
.globl vector98
vector98:
  pushl $0
  10260d:	6a 00                	push   $0x0
  pushl $98
  10260f:	6a 62                	push   $0x62
  jmp __alltraps
  102611:	e9 05 07 00 00       	jmp    102d1b <__alltraps>

00102616 <vector99>:
.globl vector99
vector99:
  pushl $0
  102616:	6a 00                	push   $0x0
  pushl $99
  102618:	6a 63                	push   $0x63
  jmp __alltraps
  10261a:	e9 fc 06 00 00       	jmp    102d1b <__alltraps>

0010261f <vector100>:
.globl vector100
vector100:
  pushl $0
  10261f:	6a 00                	push   $0x0
  pushl $100
  102621:	6a 64                	push   $0x64
  jmp __alltraps
  102623:	e9 f3 06 00 00       	jmp    102d1b <__alltraps>

00102628 <vector101>:
.globl vector101
vector101:
  pushl $0
  102628:	6a 00                	push   $0x0
  pushl $101
  10262a:	6a 65                	push   $0x65
  jmp __alltraps
  10262c:	e9 ea 06 00 00       	jmp    102d1b <__alltraps>

00102631 <vector102>:
.globl vector102
vector102:
  pushl $0
  102631:	6a 00                	push   $0x0
  pushl $102
  102633:	6a 66                	push   $0x66
  jmp __alltraps
  102635:	e9 e1 06 00 00       	jmp    102d1b <__alltraps>

0010263a <vector103>:
.globl vector103
vector103:
  pushl $0
  10263a:	6a 00                	push   $0x0
  pushl $103
  10263c:	6a 67                	push   $0x67
  jmp __alltraps
  10263e:	e9 d8 06 00 00       	jmp    102d1b <__alltraps>

00102643 <vector104>:
.globl vector104
vector104:
  pushl $0
  102643:	6a 00                	push   $0x0
  pushl $104
  102645:	6a 68                	push   $0x68
  jmp __alltraps
  102647:	e9 cf 06 00 00       	jmp    102d1b <__alltraps>

0010264c <vector105>:
.globl vector105
vector105:
  pushl $0
  10264c:	6a 00                	push   $0x0
  pushl $105
  10264e:	6a 69                	push   $0x69
  jmp __alltraps
  102650:	e9 c6 06 00 00       	jmp    102d1b <__alltraps>

00102655 <vector106>:
.globl vector106
vector106:
  pushl $0
  102655:	6a 00                	push   $0x0
  pushl $106
  102657:	6a 6a                	push   $0x6a
  jmp __alltraps
  102659:	e9 bd 06 00 00       	jmp    102d1b <__alltraps>

0010265e <vector107>:
.globl vector107
vector107:
  pushl $0
  10265e:	6a 00                	push   $0x0
  pushl $107
  102660:	6a 6b                	push   $0x6b
  jmp __alltraps
  102662:	e9 b4 06 00 00       	jmp    102d1b <__alltraps>

00102667 <vector108>:
.globl vector108
vector108:
  pushl $0
  102667:	6a 00                	push   $0x0
  pushl $108
  102669:	6a 6c                	push   $0x6c
  jmp __alltraps
  10266b:	e9 ab 06 00 00       	jmp    102d1b <__alltraps>

00102670 <vector109>:
.globl vector109
vector109:
  pushl $0
  102670:	6a 00                	push   $0x0
  pushl $109
  102672:	6a 6d                	push   $0x6d
  jmp __alltraps
  102674:	e9 a2 06 00 00       	jmp    102d1b <__alltraps>

00102679 <vector110>:
.globl vector110
vector110:
  pushl $0
  102679:	6a 00                	push   $0x0
  pushl $110
  10267b:	6a 6e                	push   $0x6e
  jmp __alltraps
  10267d:	e9 99 06 00 00       	jmp    102d1b <__alltraps>

00102682 <vector111>:
.globl vector111
vector111:
  pushl $0
  102682:	6a 00                	push   $0x0
  pushl $111
  102684:	6a 6f                	push   $0x6f
  jmp __alltraps
  102686:	e9 90 06 00 00       	jmp    102d1b <__alltraps>

0010268b <vector112>:
.globl vector112
vector112:
  pushl $0
  10268b:	6a 00                	push   $0x0
  pushl $112
  10268d:	6a 70                	push   $0x70
  jmp __alltraps
  10268f:	e9 87 06 00 00       	jmp    102d1b <__alltraps>

00102694 <vector113>:
.globl vector113
vector113:
  pushl $0
  102694:	6a 00                	push   $0x0
  pushl $113
  102696:	6a 71                	push   $0x71
  jmp __alltraps
  102698:	e9 7e 06 00 00       	jmp    102d1b <__alltraps>

0010269d <vector114>:
.globl vector114
vector114:
  pushl $0
  10269d:	6a 00                	push   $0x0
  pushl $114
  10269f:	6a 72                	push   $0x72
  jmp __alltraps
  1026a1:	e9 75 06 00 00       	jmp    102d1b <__alltraps>

001026a6 <vector115>:
.globl vector115
vector115:
  pushl $0
  1026a6:	6a 00                	push   $0x0
  pushl $115
  1026a8:	6a 73                	push   $0x73
  jmp __alltraps
  1026aa:	e9 6c 06 00 00       	jmp    102d1b <__alltraps>

001026af <vector116>:
.globl vector116
vector116:
  pushl $0
  1026af:	6a 00                	push   $0x0
  pushl $116
  1026b1:	6a 74                	push   $0x74
  jmp __alltraps
  1026b3:	e9 63 06 00 00       	jmp    102d1b <__alltraps>

001026b8 <vector117>:
.globl vector117
vector117:
  pushl $0
  1026b8:	6a 00                	push   $0x0
  pushl $117
  1026ba:	6a 75                	push   $0x75
  jmp __alltraps
  1026bc:	e9 5a 06 00 00       	jmp    102d1b <__alltraps>

001026c1 <vector118>:
.globl vector118
vector118:
  pushl $0
  1026c1:	6a 00                	push   $0x0
  pushl $118
  1026c3:	6a 76                	push   $0x76
  jmp __alltraps
  1026c5:	e9 51 06 00 00       	jmp    102d1b <__alltraps>

001026ca <vector119>:
.globl vector119
vector119:
  pushl $0
  1026ca:	6a 00                	push   $0x0
  pushl $119
  1026cc:	6a 77                	push   $0x77
  jmp __alltraps
  1026ce:	e9 48 06 00 00       	jmp    102d1b <__alltraps>

001026d3 <vector120>:
.globl vector120
vector120:
  pushl $0
  1026d3:	6a 00                	push   $0x0
  pushl $120
  1026d5:	6a 78                	push   $0x78
  jmp __alltraps
  1026d7:	e9 3f 06 00 00       	jmp    102d1b <__alltraps>

001026dc <vector121>:
.globl vector121
vector121:
  pushl $0
  1026dc:	6a 00                	push   $0x0
  pushl $121
  1026de:	6a 79                	push   $0x79
  jmp __alltraps
  1026e0:	e9 36 06 00 00       	jmp    102d1b <__alltraps>

001026e5 <vector122>:
.globl vector122
vector122:
  pushl $0
  1026e5:	6a 00                	push   $0x0
  pushl $122
  1026e7:	6a 7a                	push   $0x7a
  jmp __alltraps
  1026e9:	e9 2d 06 00 00       	jmp    102d1b <__alltraps>

001026ee <vector123>:
.globl vector123
vector123:
  pushl $0
  1026ee:	6a 00                	push   $0x0
  pushl $123
  1026f0:	6a 7b                	push   $0x7b
  jmp __alltraps
  1026f2:	e9 24 06 00 00       	jmp    102d1b <__alltraps>

001026f7 <vector124>:
.globl vector124
vector124:
  pushl $0
  1026f7:	6a 00                	push   $0x0
  pushl $124
  1026f9:	6a 7c                	push   $0x7c
  jmp __alltraps
  1026fb:	e9 1b 06 00 00       	jmp    102d1b <__alltraps>

00102700 <vector125>:
.globl vector125
vector125:
  pushl $0
  102700:	6a 00                	push   $0x0
  pushl $125
  102702:	6a 7d                	push   $0x7d
  jmp __alltraps
  102704:	e9 12 06 00 00       	jmp    102d1b <__alltraps>

00102709 <vector126>:
.globl vector126
vector126:
  pushl $0
  102709:	6a 00                	push   $0x0
  pushl $126
  10270b:	6a 7e                	push   $0x7e
  jmp __alltraps
  10270d:	e9 09 06 00 00       	jmp    102d1b <__alltraps>

00102712 <vector127>:
.globl vector127
vector127:
  pushl $0
  102712:	6a 00                	push   $0x0
  pushl $127
  102714:	6a 7f                	push   $0x7f
  jmp __alltraps
  102716:	e9 00 06 00 00       	jmp    102d1b <__alltraps>

0010271b <vector128>:
.globl vector128
vector128:
  pushl $0
  10271b:	6a 00                	push   $0x0
  pushl $128
  10271d:	68 80 00 00 00       	push   $0x80
  jmp __alltraps
  102722:	e9 f4 05 00 00       	jmp    102d1b <__alltraps>

00102727 <vector129>:
.globl vector129
vector129:
  pushl $0
  102727:	6a 00                	push   $0x0
  pushl $129
  102729:	68 81 00 00 00       	push   $0x81
  jmp __alltraps
  10272e:	e9 e8 05 00 00       	jmp    102d1b <__alltraps>

00102733 <vector130>:
.globl vector130
vector130:
  pushl $0
  102733:	6a 00                	push   $0x0
  pushl $130
  102735:	68 82 00 00 00       	push   $0x82
  jmp __alltraps
  10273a:	e9 dc 05 00 00       	jmp    102d1b <__alltraps>

0010273f <vector131>:
.globl vector131
vector131:
  pushl $0
  10273f:	6a 00                	push   $0x0
  pushl $131
  102741:	68 83 00 00 00       	push   $0x83
  jmp __alltraps
  102746:	e9 d0 05 00 00       	jmp    102d1b <__alltraps>

0010274b <vector132>:
.globl vector132
vector132:
  pushl $0
  10274b:	6a 00                	push   $0x0
  pushl $132
  10274d:	68 84 00 00 00       	push   $0x84
  jmp __alltraps
  102752:	e9 c4 05 00 00       	jmp    102d1b <__alltraps>

00102757 <vector133>:
.globl vector133
vector133:
  pushl $0
  102757:	6a 00                	push   $0x0
  pushl $133
  102759:	68 85 00 00 00       	push   $0x85
  jmp __alltraps
  10275e:	e9 b8 05 00 00       	jmp    102d1b <__alltraps>

00102763 <vector134>:
.globl vector134
vector134:
  pushl $0
  102763:	6a 00                	push   $0x0
  pushl $134
  102765:	68 86 00 00 00       	push   $0x86
  jmp __alltraps
  10276a:	e9 ac 05 00 00       	jmp    102d1b <__alltraps>

0010276f <vector135>:
.globl vector135
vector135:
  pushl $0
  10276f:	6a 00                	push   $0x0
  pushl $135
  102771:	68 87 00 00 00       	push   $0x87
  jmp __alltraps
  102776:	e9 a0 05 00 00       	jmp    102d1b <__alltraps>

0010277b <vector136>:
.globl vector136
vector136:
  pushl $0
  10277b:	6a 00                	push   $0x0
  pushl $136
  10277d:	68 88 00 00 00       	push   $0x88
  jmp __alltraps
  102782:	e9 94 05 00 00       	jmp    102d1b <__alltraps>

00102787 <vector137>:
.globl vector137
vector137:
  pushl $0
  102787:	6a 00                	push   $0x0
  pushl $137
  102789:	68 89 00 00 00       	push   $0x89
  jmp __alltraps
  10278e:	e9 88 05 00 00       	jmp    102d1b <__alltraps>

00102793 <vector138>:
.globl vector138
vector138:
  pushl $0
  102793:	6a 00                	push   $0x0
  pushl $138
  102795:	68 8a 00 00 00       	push   $0x8a
  jmp __alltraps
  10279a:	e9 7c 05 00 00       	jmp    102d1b <__alltraps>

0010279f <vector139>:
.globl vector139
vector139:
  pushl $0
  10279f:	6a 00                	push   $0x0
  pushl $139
  1027a1:	68 8b 00 00 00       	push   $0x8b
  jmp __alltraps
  1027a6:	e9 70 05 00 00       	jmp    102d1b <__alltraps>

001027ab <vector140>:
.globl vector140
vector140:
  pushl $0
  1027ab:	6a 00                	push   $0x0
  pushl $140
  1027ad:	68 8c 00 00 00       	push   $0x8c
  jmp __alltraps
  1027b2:	e9 64 05 00 00       	jmp    102d1b <__alltraps>

001027b7 <vector141>:
.globl vector141
vector141:
  pushl $0
  1027b7:	6a 00                	push   $0x0
  pushl $141
  1027b9:	68 8d 00 00 00       	push   $0x8d
  jmp __alltraps
  1027be:	e9 58 05 00 00       	jmp    102d1b <__alltraps>

001027c3 <vector142>:
.globl vector142
vector142:
  pushl $0
  1027c3:	6a 00                	push   $0x0
  pushl $142
  1027c5:	68 8e 00 00 00       	push   $0x8e
  jmp __alltraps
  1027ca:	e9 4c 05 00 00       	jmp    102d1b <__alltraps>

001027cf <vector143>:
.globl vector143
vector143:
  pushl $0
  1027cf:	6a 00                	push   $0x0
  pushl $143
  1027d1:	68 8f 00 00 00       	push   $0x8f
  jmp __alltraps
  1027d6:	e9 40 05 00 00       	jmp    102d1b <__alltraps>

001027db <vector144>:
.globl vector144
vector144:
  pushl $0
  1027db:	6a 00                	push   $0x0
  pushl $144
  1027dd:	68 90 00 00 00       	push   $0x90
  jmp __alltraps
  1027e2:	e9 34 05 00 00       	jmp    102d1b <__alltraps>

001027e7 <vector145>:
.globl vector145
vector145:
  pushl $0
  1027e7:	6a 00                	push   $0x0
  pushl $145
  1027e9:	68 91 00 00 00       	push   $0x91
  jmp __alltraps
  1027ee:	e9 28 05 00 00       	jmp    102d1b <__alltraps>

001027f3 <vector146>:
.globl vector146
vector146:
  pushl $0
  1027f3:	6a 00                	push   $0x0
  pushl $146
  1027f5:	68 92 00 00 00       	push   $0x92
  jmp __alltraps
  1027fa:	e9 1c 05 00 00       	jmp    102d1b <__alltraps>

001027ff <vector147>:
.globl vector147
vector147:
  pushl $0
  1027ff:	6a 00                	push   $0x0
  pushl $147
  102801:	68 93 00 00 00       	push   $0x93
  jmp __alltraps
  102806:	e9 10 05 00 00       	jmp    102d1b <__alltraps>

0010280b <vector148>:
.globl vector148
vector148:
  pushl $0
  10280b:	6a 00                	push   $0x0
  pushl $148
  10280d:	68 94 00 00 00       	push   $0x94
  jmp __alltraps
  102812:	e9 04 05 00 00       	jmp    102d1b <__alltraps>

00102817 <vector149>:
.globl vector149
vector149:
  pushl $0
  102817:	6a 00                	push   $0x0
  pushl $149
  102819:	68 95 00 00 00       	push   $0x95
  jmp __alltraps
  10281e:	e9 f8 04 00 00       	jmp    102d1b <__alltraps>

00102823 <vector150>:
.globl vector150
vector150:
  pushl $0
  102823:	6a 00                	push   $0x0
  pushl $150
  102825:	68 96 00 00 00       	push   $0x96
  jmp __alltraps
  10282a:	e9 ec 04 00 00       	jmp    102d1b <__alltraps>

0010282f <vector151>:
.globl vector151
vector151:
  pushl $0
  10282f:	6a 00                	push   $0x0
  pushl $151
  102831:	68 97 00 00 00       	push   $0x97
  jmp __alltraps
  102836:	e9 e0 04 00 00       	jmp    102d1b <__alltraps>

0010283b <vector152>:
.globl vector152
vector152:
  pushl $0
  10283b:	6a 00                	push   $0x0
  pushl $152
  10283d:	68 98 00 00 00       	push   $0x98
  jmp __alltraps
  102842:	e9 d4 04 00 00       	jmp    102d1b <__alltraps>

00102847 <vector153>:
.globl vector153
vector153:
  pushl $0
  102847:	6a 00                	push   $0x0
  pushl $153
  102849:	68 99 00 00 00       	push   $0x99
  jmp __alltraps
  10284e:	e9 c8 04 00 00       	jmp    102d1b <__alltraps>

00102853 <vector154>:
.globl vector154
vector154:
  pushl $0
  102853:	6a 00                	push   $0x0
  pushl $154
  102855:	68 9a 00 00 00       	push   $0x9a
  jmp __alltraps
  10285a:	e9 bc 04 00 00       	jmp    102d1b <__alltraps>

0010285f <vector155>:
.globl vector155
vector155:
  pushl $0
  10285f:	6a 00                	push   $0x0
  pushl $155
  102861:	68 9b 00 00 00       	push   $0x9b
  jmp __alltraps
  102866:	e9 b0 04 00 00       	jmp    102d1b <__alltraps>

0010286b <vector156>:
.globl vector156
vector156:
  pushl $0
  10286b:	6a 00                	push   $0x0
  pushl $156
  10286d:	68 9c 00 00 00       	push   $0x9c
  jmp __alltraps
  102872:	e9 a4 04 00 00       	jmp    102d1b <__alltraps>

00102877 <vector157>:
.globl vector157
vector157:
  pushl $0
  102877:	6a 00                	push   $0x0
  pushl $157
  102879:	68 9d 00 00 00       	push   $0x9d
  jmp __alltraps
  10287e:	e9 98 04 00 00       	jmp    102d1b <__alltraps>

00102883 <vector158>:
.globl vector158
vector158:
  pushl $0
  102883:	6a 00                	push   $0x0
  pushl $158
  102885:	68 9e 00 00 00       	push   $0x9e
  jmp __alltraps
  10288a:	e9 8c 04 00 00       	jmp    102d1b <__alltraps>

0010288f <vector159>:
.globl vector159
vector159:
  pushl $0
  10288f:	6a 00                	push   $0x0
  pushl $159
  102891:	68 9f 00 00 00       	push   $0x9f
  jmp __alltraps
  102896:	e9 80 04 00 00       	jmp    102d1b <__alltraps>

0010289b <vector160>:
.globl vector160
vector160:
  pushl $0
  10289b:	6a 00                	push   $0x0
  pushl $160
  10289d:	68 a0 00 00 00       	push   $0xa0
  jmp __alltraps
  1028a2:	e9 74 04 00 00       	jmp    102d1b <__alltraps>

001028a7 <vector161>:
.globl vector161
vector161:
  pushl $0
  1028a7:	6a 00                	push   $0x0
  pushl $161
  1028a9:	68 a1 00 00 00       	push   $0xa1
  jmp __alltraps
  1028ae:	e9 68 04 00 00       	jmp    102d1b <__alltraps>

001028b3 <vector162>:
.globl vector162
vector162:
  pushl $0
  1028b3:	6a 00                	push   $0x0
  pushl $162
  1028b5:	68 a2 00 00 00       	push   $0xa2
  jmp __alltraps
  1028ba:	e9 5c 04 00 00       	jmp    102d1b <__alltraps>

001028bf <vector163>:
.globl vector163
vector163:
  pushl $0
  1028bf:	6a 00                	push   $0x0
  pushl $163
  1028c1:	68 a3 00 00 00       	push   $0xa3
  jmp __alltraps
  1028c6:	e9 50 04 00 00       	jmp    102d1b <__alltraps>

001028cb <vector164>:
.globl vector164
vector164:
  pushl $0
  1028cb:	6a 00                	push   $0x0
  pushl $164
  1028cd:	68 a4 00 00 00       	push   $0xa4
  jmp __alltraps
  1028d2:	e9 44 04 00 00       	jmp    102d1b <__alltraps>

001028d7 <vector165>:
.globl vector165
vector165:
  pushl $0
  1028d7:	6a 00                	push   $0x0
  pushl $165
  1028d9:	68 a5 00 00 00       	push   $0xa5
  jmp __alltraps
  1028de:	e9 38 04 00 00       	jmp    102d1b <__alltraps>

001028e3 <vector166>:
.globl vector166
vector166:
  pushl $0
  1028e3:	6a 00                	push   $0x0
  pushl $166
  1028e5:	68 a6 00 00 00       	push   $0xa6
  jmp __alltraps
  1028ea:	e9 2c 04 00 00       	jmp    102d1b <__alltraps>

001028ef <vector167>:
.globl vector167
vector167:
  pushl $0
  1028ef:	6a 00                	push   $0x0
  pushl $167
  1028f1:	68 a7 00 00 00       	push   $0xa7
  jmp __alltraps
  1028f6:	e9 20 04 00 00       	jmp    102d1b <__alltraps>

001028fb <vector168>:
.globl vector168
vector168:
  pushl $0
  1028fb:	6a 00                	push   $0x0
  pushl $168
  1028fd:	68 a8 00 00 00       	push   $0xa8
  jmp __alltraps
  102902:	e9 14 04 00 00       	jmp    102d1b <__alltraps>

00102907 <vector169>:
.globl vector169
vector169:
  pushl $0
  102907:	6a 00                	push   $0x0
  pushl $169
  102909:	68 a9 00 00 00       	push   $0xa9
  jmp __alltraps
  10290e:	e9 08 04 00 00       	jmp    102d1b <__alltraps>

00102913 <vector170>:
.globl vector170
vector170:
  pushl $0
  102913:	6a 00                	push   $0x0
  pushl $170
  102915:	68 aa 00 00 00       	push   $0xaa
  jmp __alltraps
  10291a:	e9 fc 03 00 00       	jmp    102d1b <__alltraps>

0010291f <vector171>:
.globl vector171
vector171:
  pushl $0
  10291f:	6a 00                	push   $0x0
  pushl $171
  102921:	68 ab 00 00 00       	push   $0xab
  jmp __alltraps
  102926:	e9 f0 03 00 00       	jmp    102d1b <__alltraps>

0010292b <vector172>:
.globl vector172
vector172:
  pushl $0
  10292b:	6a 00                	push   $0x0
  pushl $172
  10292d:	68 ac 00 00 00       	push   $0xac
  jmp __alltraps
  102932:	e9 e4 03 00 00       	jmp    102d1b <__alltraps>

00102937 <vector173>:
.globl vector173
vector173:
  pushl $0
  102937:	6a 00                	push   $0x0
  pushl $173
  102939:	68 ad 00 00 00       	push   $0xad
  jmp __alltraps
  10293e:	e9 d8 03 00 00       	jmp    102d1b <__alltraps>

00102943 <vector174>:
.globl vector174
vector174:
  pushl $0
  102943:	6a 00                	push   $0x0
  pushl $174
  102945:	68 ae 00 00 00       	push   $0xae
  jmp __alltraps
  10294a:	e9 cc 03 00 00       	jmp    102d1b <__alltraps>

0010294f <vector175>:
.globl vector175
vector175:
  pushl $0
  10294f:	6a 00                	push   $0x0
  pushl $175
  102951:	68 af 00 00 00       	push   $0xaf
  jmp __alltraps
  102956:	e9 c0 03 00 00       	jmp    102d1b <__alltraps>

0010295b <vector176>:
.globl vector176
vector176:
  pushl $0
  10295b:	6a 00                	push   $0x0
  pushl $176
  10295d:	68 b0 00 00 00       	push   $0xb0
  jmp __alltraps
  102962:	e9 b4 03 00 00       	jmp    102d1b <__alltraps>

00102967 <vector177>:
.globl vector177
vector177:
  pushl $0
  102967:	6a 00                	push   $0x0
  pushl $177
  102969:	68 b1 00 00 00       	push   $0xb1
  jmp __alltraps
  10296e:	e9 a8 03 00 00       	jmp    102d1b <__alltraps>

00102973 <vector178>:
.globl vector178
vector178:
  pushl $0
  102973:	6a 00                	push   $0x0
  pushl $178
  102975:	68 b2 00 00 00       	push   $0xb2
  jmp __alltraps
  10297a:	e9 9c 03 00 00       	jmp    102d1b <__alltraps>

0010297f <vector179>:
.globl vector179
vector179:
  pushl $0
  10297f:	6a 00                	push   $0x0
  pushl $179
  102981:	68 b3 00 00 00       	push   $0xb3
  jmp __alltraps
  102986:	e9 90 03 00 00       	jmp    102d1b <__alltraps>

0010298b <vector180>:
.globl vector180
vector180:
  pushl $0
  10298b:	6a 00                	push   $0x0
  pushl $180
  10298d:	68 b4 00 00 00       	push   $0xb4
  jmp __alltraps
  102992:	e9 84 03 00 00       	jmp    102d1b <__alltraps>

00102997 <vector181>:
.globl vector181
vector181:
  pushl $0
  102997:	6a 00                	push   $0x0
  pushl $181
  102999:	68 b5 00 00 00       	push   $0xb5
  jmp __alltraps
  10299e:	e9 78 03 00 00       	jmp    102d1b <__alltraps>

001029a3 <vector182>:
.globl vector182
vector182:
  pushl $0
  1029a3:	6a 00                	push   $0x0
  pushl $182
  1029a5:	68 b6 00 00 00       	push   $0xb6
  jmp __alltraps
  1029aa:	e9 6c 03 00 00       	jmp    102d1b <__alltraps>

001029af <vector183>:
.globl vector183
vector183:
  pushl $0
  1029af:	6a 00                	push   $0x0
  pushl $183
  1029b1:	68 b7 00 00 00       	push   $0xb7
  jmp __alltraps
  1029b6:	e9 60 03 00 00       	jmp    102d1b <__alltraps>

001029bb <vector184>:
.globl vector184
vector184:
  pushl $0
  1029bb:	6a 00                	push   $0x0
  pushl $184
  1029bd:	68 b8 00 00 00       	push   $0xb8
  jmp __alltraps
  1029c2:	e9 54 03 00 00       	jmp    102d1b <__alltraps>

001029c7 <vector185>:
.globl vector185
vector185:
  pushl $0
  1029c7:	6a 00                	push   $0x0
  pushl $185
  1029c9:	68 b9 00 00 00       	push   $0xb9
  jmp __alltraps
  1029ce:	e9 48 03 00 00       	jmp    102d1b <__alltraps>

001029d3 <vector186>:
.globl vector186
vector186:
  pushl $0
  1029d3:	6a 00                	push   $0x0
  pushl $186
  1029d5:	68 ba 00 00 00       	push   $0xba
  jmp __alltraps
  1029da:	e9 3c 03 00 00       	jmp    102d1b <__alltraps>

001029df <vector187>:
.globl vector187
vector187:
  pushl $0
  1029df:	6a 00                	push   $0x0
  pushl $187
  1029e1:	68 bb 00 00 00       	push   $0xbb
  jmp __alltraps
  1029e6:	e9 30 03 00 00       	jmp    102d1b <__alltraps>

001029eb <vector188>:
.globl vector188
vector188:
  pushl $0
  1029eb:	6a 00                	push   $0x0
  pushl $188
  1029ed:	68 bc 00 00 00       	push   $0xbc
  jmp __alltraps
  1029f2:	e9 24 03 00 00       	jmp    102d1b <__alltraps>

001029f7 <vector189>:
.globl vector189
vector189:
  pushl $0
  1029f7:	6a 00                	push   $0x0
  pushl $189
  1029f9:	68 bd 00 00 00       	push   $0xbd
  jmp __alltraps
  1029fe:	e9 18 03 00 00       	jmp    102d1b <__alltraps>

00102a03 <vector190>:
.globl vector190
vector190:
  pushl $0
  102a03:	6a 00                	push   $0x0
  pushl $190
  102a05:	68 be 00 00 00       	push   $0xbe
  jmp __alltraps
  102a0a:	e9 0c 03 00 00       	jmp    102d1b <__alltraps>

00102a0f <vector191>:
.globl vector191
vector191:
  pushl $0
  102a0f:	6a 00                	push   $0x0
  pushl $191
  102a11:	68 bf 00 00 00       	push   $0xbf
  jmp __alltraps
  102a16:	e9 00 03 00 00       	jmp    102d1b <__alltraps>

00102a1b <vector192>:
.globl vector192
vector192:
  pushl $0
  102a1b:	6a 00                	push   $0x0
  pushl $192
  102a1d:	68 c0 00 00 00       	push   $0xc0
  jmp __alltraps
  102a22:	e9 f4 02 00 00       	jmp    102d1b <__alltraps>

00102a27 <vector193>:
.globl vector193
vector193:
  pushl $0
  102a27:	6a 00                	push   $0x0
  pushl $193
  102a29:	68 c1 00 00 00       	push   $0xc1
  jmp __alltraps
  102a2e:	e9 e8 02 00 00       	jmp    102d1b <__alltraps>

00102a33 <vector194>:
.globl vector194
vector194:
  pushl $0
  102a33:	6a 00                	push   $0x0
  pushl $194
  102a35:	68 c2 00 00 00       	push   $0xc2
  jmp __alltraps
  102a3a:	e9 dc 02 00 00       	jmp    102d1b <__alltraps>

00102a3f <vector195>:
.globl vector195
vector195:
  pushl $0
  102a3f:	6a 00                	push   $0x0
  pushl $195
  102a41:	68 c3 00 00 00       	push   $0xc3
  jmp __alltraps
  102a46:	e9 d0 02 00 00       	jmp    102d1b <__alltraps>

00102a4b <vector196>:
.globl vector196
vector196:
  pushl $0
  102a4b:	6a 00                	push   $0x0
  pushl $196
  102a4d:	68 c4 00 00 00       	push   $0xc4
  jmp __alltraps
  102a52:	e9 c4 02 00 00       	jmp    102d1b <__alltraps>

00102a57 <vector197>:
.globl vector197
vector197:
  pushl $0
  102a57:	6a 00                	push   $0x0
  pushl $197
  102a59:	68 c5 00 00 00       	push   $0xc5
  jmp __alltraps
  102a5e:	e9 b8 02 00 00       	jmp    102d1b <__alltraps>

00102a63 <vector198>:
.globl vector198
vector198:
  pushl $0
  102a63:	6a 00                	push   $0x0
  pushl $198
  102a65:	68 c6 00 00 00       	push   $0xc6
  jmp __alltraps
  102a6a:	e9 ac 02 00 00       	jmp    102d1b <__alltraps>

00102a6f <vector199>:
.globl vector199
vector199:
  pushl $0
  102a6f:	6a 00                	push   $0x0
  pushl $199
  102a71:	68 c7 00 00 00       	push   $0xc7
  jmp __alltraps
  102a76:	e9 a0 02 00 00       	jmp    102d1b <__alltraps>

00102a7b <vector200>:
.globl vector200
vector200:
  pushl $0
  102a7b:	6a 00                	push   $0x0
  pushl $200
  102a7d:	68 c8 00 00 00       	push   $0xc8
  jmp __alltraps
  102a82:	e9 94 02 00 00       	jmp    102d1b <__alltraps>

00102a87 <vector201>:
.globl vector201
vector201:
  pushl $0
  102a87:	6a 00                	push   $0x0
  pushl $201
  102a89:	68 c9 00 00 00       	push   $0xc9
  jmp __alltraps
  102a8e:	e9 88 02 00 00       	jmp    102d1b <__alltraps>

00102a93 <vector202>:
.globl vector202
vector202:
  pushl $0
  102a93:	6a 00                	push   $0x0
  pushl $202
  102a95:	68 ca 00 00 00       	push   $0xca
  jmp __alltraps
  102a9a:	e9 7c 02 00 00       	jmp    102d1b <__alltraps>

00102a9f <vector203>:
.globl vector203
vector203:
  pushl $0
  102a9f:	6a 00                	push   $0x0
  pushl $203
  102aa1:	68 cb 00 00 00       	push   $0xcb
  jmp __alltraps
  102aa6:	e9 70 02 00 00       	jmp    102d1b <__alltraps>

00102aab <vector204>:
.globl vector204
vector204:
  pushl $0
  102aab:	6a 00                	push   $0x0
  pushl $204
  102aad:	68 cc 00 00 00       	push   $0xcc
  jmp __alltraps
  102ab2:	e9 64 02 00 00       	jmp    102d1b <__alltraps>

00102ab7 <vector205>:
.globl vector205
vector205:
  pushl $0
  102ab7:	6a 00                	push   $0x0
  pushl $205
  102ab9:	68 cd 00 00 00       	push   $0xcd
  jmp __alltraps
  102abe:	e9 58 02 00 00       	jmp    102d1b <__alltraps>

00102ac3 <vector206>:
.globl vector206
vector206:
  pushl $0
  102ac3:	6a 00                	push   $0x0
  pushl $206
  102ac5:	68 ce 00 00 00       	push   $0xce
  jmp __alltraps
  102aca:	e9 4c 02 00 00       	jmp    102d1b <__alltraps>

00102acf <vector207>:
.globl vector207
vector207:
  pushl $0
  102acf:	6a 00                	push   $0x0
  pushl $207
  102ad1:	68 cf 00 00 00       	push   $0xcf
  jmp __alltraps
  102ad6:	e9 40 02 00 00       	jmp    102d1b <__alltraps>

00102adb <vector208>:
.globl vector208
vector208:
  pushl $0
  102adb:	6a 00                	push   $0x0
  pushl $208
  102add:	68 d0 00 00 00       	push   $0xd0
  jmp __alltraps
  102ae2:	e9 34 02 00 00       	jmp    102d1b <__alltraps>

00102ae7 <vector209>:
.globl vector209
vector209:
  pushl $0
  102ae7:	6a 00                	push   $0x0
  pushl $209
  102ae9:	68 d1 00 00 00       	push   $0xd1
  jmp __alltraps
  102aee:	e9 28 02 00 00       	jmp    102d1b <__alltraps>

00102af3 <vector210>:
.globl vector210
vector210:
  pushl $0
  102af3:	6a 00                	push   $0x0
  pushl $210
  102af5:	68 d2 00 00 00       	push   $0xd2
  jmp __alltraps
  102afa:	e9 1c 02 00 00       	jmp    102d1b <__alltraps>

00102aff <vector211>:
.globl vector211
vector211:
  pushl $0
  102aff:	6a 00                	push   $0x0
  pushl $211
  102b01:	68 d3 00 00 00       	push   $0xd3
  jmp __alltraps
  102b06:	e9 10 02 00 00       	jmp    102d1b <__alltraps>

00102b0b <vector212>:
.globl vector212
vector212:
  pushl $0
  102b0b:	6a 00                	push   $0x0
  pushl $212
  102b0d:	68 d4 00 00 00       	push   $0xd4
  jmp __alltraps
  102b12:	e9 04 02 00 00       	jmp    102d1b <__alltraps>

00102b17 <vector213>:
.globl vector213
vector213:
  pushl $0
  102b17:	6a 00                	push   $0x0
  pushl $213
  102b19:	68 d5 00 00 00       	push   $0xd5
  jmp __alltraps
  102b1e:	e9 f8 01 00 00       	jmp    102d1b <__alltraps>

00102b23 <vector214>:
.globl vector214
vector214:
  pushl $0
  102b23:	6a 00                	push   $0x0
  pushl $214
  102b25:	68 d6 00 00 00       	push   $0xd6
  jmp __alltraps
  102b2a:	e9 ec 01 00 00       	jmp    102d1b <__alltraps>

00102b2f <vector215>:
.globl vector215
vector215:
  pushl $0
  102b2f:	6a 00                	push   $0x0
  pushl $215
  102b31:	68 d7 00 00 00       	push   $0xd7
  jmp __alltraps
  102b36:	e9 e0 01 00 00       	jmp    102d1b <__alltraps>

00102b3b <vector216>:
.globl vector216
vector216:
  pushl $0
  102b3b:	6a 00                	push   $0x0
  pushl $216
  102b3d:	68 d8 00 00 00       	push   $0xd8
  jmp __alltraps
  102b42:	e9 d4 01 00 00       	jmp    102d1b <__alltraps>

00102b47 <vector217>:
.globl vector217
vector217:
  pushl $0
  102b47:	6a 00                	push   $0x0
  pushl $217
  102b49:	68 d9 00 00 00       	push   $0xd9
  jmp __alltraps
  102b4e:	e9 c8 01 00 00       	jmp    102d1b <__alltraps>

00102b53 <vector218>:
.globl vector218
vector218:
  pushl $0
  102b53:	6a 00                	push   $0x0
  pushl $218
  102b55:	68 da 00 00 00       	push   $0xda
  jmp __alltraps
  102b5a:	e9 bc 01 00 00       	jmp    102d1b <__alltraps>

00102b5f <vector219>:
.globl vector219
vector219:
  pushl $0
  102b5f:	6a 00                	push   $0x0
  pushl $219
  102b61:	68 db 00 00 00       	push   $0xdb
  jmp __alltraps
  102b66:	e9 b0 01 00 00       	jmp    102d1b <__alltraps>

00102b6b <vector220>:
.globl vector220
vector220:
  pushl $0
  102b6b:	6a 00                	push   $0x0
  pushl $220
  102b6d:	68 dc 00 00 00       	push   $0xdc
  jmp __alltraps
  102b72:	e9 a4 01 00 00       	jmp    102d1b <__alltraps>

00102b77 <vector221>:
.globl vector221
vector221:
  pushl $0
  102b77:	6a 00                	push   $0x0
  pushl $221
  102b79:	68 dd 00 00 00       	push   $0xdd
  jmp __alltraps
  102b7e:	e9 98 01 00 00       	jmp    102d1b <__alltraps>

00102b83 <vector222>:
.globl vector222
vector222:
  pushl $0
  102b83:	6a 00                	push   $0x0
  pushl $222
  102b85:	68 de 00 00 00       	push   $0xde
  jmp __alltraps
  102b8a:	e9 8c 01 00 00       	jmp    102d1b <__alltraps>

00102b8f <vector223>:
.globl vector223
vector223:
  pushl $0
  102b8f:	6a 00                	push   $0x0
  pushl $223
  102b91:	68 df 00 00 00       	push   $0xdf
  jmp __alltraps
  102b96:	e9 80 01 00 00       	jmp    102d1b <__alltraps>

00102b9b <vector224>:
.globl vector224
vector224:
  pushl $0
  102b9b:	6a 00                	push   $0x0
  pushl $224
  102b9d:	68 e0 00 00 00       	push   $0xe0
  jmp __alltraps
  102ba2:	e9 74 01 00 00       	jmp    102d1b <__alltraps>

00102ba7 <vector225>:
.globl vector225
vector225:
  pushl $0
  102ba7:	6a 00                	push   $0x0
  pushl $225
  102ba9:	68 e1 00 00 00       	push   $0xe1
  jmp __alltraps
  102bae:	e9 68 01 00 00       	jmp    102d1b <__alltraps>

00102bb3 <vector226>:
.globl vector226
vector226:
  pushl $0
  102bb3:	6a 00                	push   $0x0
  pushl $226
  102bb5:	68 e2 00 00 00       	push   $0xe2
  jmp __alltraps
  102bba:	e9 5c 01 00 00       	jmp    102d1b <__alltraps>

00102bbf <vector227>:
.globl vector227
vector227:
  pushl $0
  102bbf:	6a 00                	push   $0x0
  pushl $227
  102bc1:	68 e3 00 00 00       	push   $0xe3
  jmp __alltraps
  102bc6:	e9 50 01 00 00       	jmp    102d1b <__alltraps>

00102bcb <vector228>:
.globl vector228
vector228:
  pushl $0
  102bcb:	6a 00                	push   $0x0
  pushl $228
  102bcd:	68 e4 00 00 00       	push   $0xe4
  jmp __alltraps
  102bd2:	e9 44 01 00 00       	jmp    102d1b <__alltraps>

00102bd7 <vector229>:
.globl vector229
vector229:
  pushl $0
  102bd7:	6a 00                	push   $0x0
  pushl $229
  102bd9:	68 e5 00 00 00       	push   $0xe5
  jmp __alltraps
  102bde:	e9 38 01 00 00       	jmp    102d1b <__alltraps>

00102be3 <vector230>:
.globl vector230
vector230:
  pushl $0
  102be3:	6a 00                	push   $0x0
  pushl $230
  102be5:	68 e6 00 00 00       	push   $0xe6
  jmp __alltraps
  102bea:	e9 2c 01 00 00       	jmp    102d1b <__alltraps>

00102bef <vector231>:
.globl vector231
vector231:
  pushl $0
  102bef:	6a 00                	push   $0x0
  pushl $231
  102bf1:	68 e7 00 00 00       	push   $0xe7
  jmp __alltraps
  102bf6:	e9 20 01 00 00       	jmp    102d1b <__alltraps>

00102bfb <vector232>:
.globl vector232
vector232:
  pushl $0
  102bfb:	6a 00                	push   $0x0
  pushl $232
  102bfd:	68 e8 00 00 00       	push   $0xe8
  jmp __alltraps
  102c02:	e9 14 01 00 00       	jmp    102d1b <__alltraps>

00102c07 <vector233>:
.globl vector233
vector233:
  pushl $0
  102c07:	6a 00                	push   $0x0
  pushl $233
  102c09:	68 e9 00 00 00       	push   $0xe9
  jmp __alltraps
  102c0e:	e9 08 01 00 00       	jmp    102d1b <__alltraps>

00102c13 <vector234>:
.globl vector234
vector234:
  pushl $0
  102c13:	6a 00                	push   $0x0
  pushl $234
  102c15:	68 ea 00 00 00       	push   $0xea
  jmp __alltraps
  102c1a:	e9 fc 00 00 00       	jmp    102d1b <__alltraps>

00102c1f <vector235>:
.globl vector235
vector235:
  pushl $0
  102c1f:	6a 00                	push   $0x0
  pushl $235
  102c21:	68 eb 00 00 00       	push   $0xeb
  jmp __alltraps
  102c26:	e9 f0 00 00 00       	jmp    102d1b <__alltraps>

00102c2b <vector236>:
.globl vector236
vector236:
  pushl $0
  102c2b:	6a 00                	push   $0x0
  pushl $236
  102c2d:	68 ec 00 00 00       	push   $0xec
  jmp __alltraps
  102c32:	e9 e4 00 00 00       	jmp    102d1b <__alltraps>

00102c37 <vector237>:
.globl vector237
vector237:
  pushl $0
  102c37:	6a 00                	push   $0x0
  pushl $237
  102c39:	68 ed 00 00 00       	push   $0xed
  jmp __alltraps
  102c3e:	e9 d8 00 00 00       	jmp    102d1b <__alltraps>

00102c43 <vector238>:
.globl vector238
vector238:
  pushl $0
  102c43:	6a 00                	push   $0x0
  pushl $238
  102c45:	68 ee 00 00 00       	push   $0xee
  jmp __alltraps
  102c4a:	e9 cc 00 00 00       	jmp    102d1b <__alltraps>

00102c4f <vector239>:
.globl vector239
vector239:
  pushl $0
  102c4f:	6a 00                	push   $0x0
  pushl $239
  102c51:	68 ef 00 00 00       	push   $0xef
  jmp __alltraps
  102c56:	e9 c0 00 00 00       	jmp    102d1b <__alltraps>

00102c5b <vector240>:
.globl vector240
vector240:
  pushl $0
  102c5b:	6a 00                	push   $0x0
  pushl $240
  102c5d:	68 f0 00 00 00       	push   $0xf0
  jmp __alltraps
  102c62:	e9 b4 00 00 00       	jmp    102d1b <__alltraps>

00102c67 <vector241>:
.globl vector241
vector241:
  pushl $0
  102c67:	6a 00                	push   $0x0
  pushl $241
  102c69:	68 f1 00 00 00       	push   $0xf1
  jmp __alltraps
  102c6e:	e9 a8 00 00 00       	jmp    102d1b <__alltraps>

00102c73 <vector242>:
.globl vector242
vector242:
  pushl $0
  102c73:	6a 00                	push   $0x0
  pushl $242
  102c75:	68 f2 00 00 00       	push   $0xf2
  jmp __alltraps
  102c7a:	e9 9c 00 00 00       	jmp    102d1b <__alltraps>

00102c7f <vector243>:
.globl vector243
vector243:
  pushl $0
  102c7f:	6a 00                	push   $0x0
  pushl $243
  102c81:	68 f3 00 00 00       	push   $0xf3
  jmp __alltraps
  102c86:	e9 90 00 00 00       	jmp    102d1b <__alltraps>

00102c8b <vector244>:
.globl vector244
vector244:
  pushl $0
  102c8b:	6a 00                	push   $0x0
  pushl $244
  102c8d:	68 f4 00 00 00       	push   $0xf4
  jmp __alltraps
  102c92:	e9 84 00 00 00       	jmp    102d1b <__alltraps>

00102c97 <vector245>:
.globl vector245
vector245:
  pushl $0
  102c97:	6a 00                	push   $0x0
  pushl $245
  102c99:	68 f5 00 00 00       	push   $0xf5
  jmp __alltraps
  102c9e:	e9 78 00 00 00       	jmp    102d1b <__alltraps>

00102ca3 <vector246>:
.globl vector246
vector246:
  pushl $0
  102ca3:	6a 00                	push   $0x0
  pushl $246
  102ca5:	68 f6 00 00 00       	push   $0xf6
  jmp __alltraps
  102caa:	e9 6c 00 00 00       	jmp    102d1b <__alltraps>

00102caf <vector247>:
.globl vector247
vector247:
  pushl $0
  102caf:	6a 00                	push   $0x0
  pushl $247
  102cb1:	68 f7 00 00 00       	push   $0xf7
  jmp __alltraps
  102cb6:	e9 60 00 00 00       	jmp    102d1b <__alltraps>

00102cbb <vector248>:
.globl vector248
vector248:
  pushl $0
  102cbb:	6a 00                	push   $0x0
  pushl $248
  102cbd:	68 f8 00 00 00       	push   $0xf8
  jmp __alltraps
  102cc2:	e9 54 00 00 00       	jmp    102d1b <__alltraps>

00102cc7 <vector249>:
.globl vector249
vector249:
  pushl $0
  102cc7:	6a 00                	push   $0x0
  pushl $249
  102cc9:	68 f9 00 00 00       	push   $0xf9
  jmp __alltraps
  102cce:	e9 48 00 00 00       	jmp    102d1b <__alltraps>

00102cd3 <vector250>:
.globl vector250
vector250:
  pushl $0
  102cd3:	6a 00                	push   $0x0
  pushl $250
  102cd5:	68 fa 00 00 00       	push   $0xfa
  jmp __alltraps
  102cda:	e9 3c 00 00 00       	jmp    102d1b <__alltraps>

00102cdf <vector251>:
.globl vector251
vector251:
  pushl $0
  102cdf:	6a 00                	push   $0x0
  pushl $251
  102ce1:	68 fb 00 00 00       	push   $0xfb
  jmp __alltraps
  102ce6:	e9 30 00 00 00       	jmp    102d1b <__alltraps>

00102ceb <vector252>:
.globl vector252
vector252:
  pushl $0
  102ceb:	6a 00                	push   $0x0
  pushl $252
  102ced:	68 fc 00 00 00       	push   $0xfc
  jmp __alltraps
  102cf2:	e9 24 00 00 00       	jmp    102d1b <__alltraps>

00102cf7 <vector253>:
.globl vector253
vector253:
  pushl $0
  102cf7:	6a 00                	push   $0x0
  pushl $253
  102cf9:	68 fd 00 00 00       	push   $0xfd
  jmp __alltraps
  102cfe:	e9 18 00 00 00       	jmp    102d1b <__alltraps>

00102d03 <vector254>:
.globl vector254
vector254:
  pushl $0
  102d03:	6a 00                	push   $0x0
  pushl $254
  102d05:	68 fe 00 00 00       	push   $0xfe
  jmp __alltraps
  102d0a:	e9 0c 00 00 00       	jmp    102d1b <__alltraps>

00102d0f <vector255>:
.globl vector255
vector255:
  pushl $0
  102d0f:	6a 00                	push   $0x0
  pushl $255
  102d11:	68 ff 00 00 00       	push   $0xff
  jmp __alltraps
  102d16:	e9 00 00 00 00       	jmp    102d1b <__alltraps>

00102d1b <__alltraps>:
.text
.globl __alltraps
__alltraps:
    # push registers to build a trap frame
    # therefore make the stack look like a struct trapframe
    pushl %ds
  102d1b:	1e                   	push   %ds
    pushl %es
  102d1c:	06                   	push   %es
    pushl %fs
  102d1d:	0f a0                	push   %fs
    pushl %gs
  102d1f:	0f a8                	push   %gs
    pushal
  102d21:	60                   	pusha  

    # load GD_KDATA into %ds and %es to set up data segments for kernel
    movl $GD_KDATA, %eax
  102d22:	b8 10 00 00 00       	mov    $0x10,%eax
    movw %ax, %ds
  102d27:	8e d8                	mov    %eax,%ds
    movw %ax, %es
  102d29:	8e c0                	mov    %eax,%es

    # push %esp to pass a pointer to the trapframe as an argument to trap()
    pushl %esp
  102d2b:	54                   	push   %esp

    # call trap(tf), where tf=%esp
    call trap
  102d2c:	e8 60 f5 ff ff       	call   102291 <trap>

    # pop the pushed stack pointer
    popl %esp
  102d31:	5c                   	pop    %esp

00102d32 <__trapret>:

    # return falls through to trapret...
.globl __trapret
__trapret:
    # restore registers from stack
    popal
  102d32:	61                   	popa   

    # restore %ds, %es, %fs and %gs
    popl %gs
  102d33:	0f a9                	pop    %gs
    popl %fs
  102d35:	0f a1                	pop    %fs
    popl %es
  102d37:	07                   	pop    %es
    popl %ds
  102d38:	1f                   	pop    %ds

    # get rid of the trap number and error code
    addl $0x8, %esp
  102d39:	83 c4 08             	add    $0x8,%esp
    iret
  102d3c:	cf                   	iret   

00102d3d <page2ppn>:

extern struct Page *pages;
extern size_t npage;

static inline ppn_t
page2ppn(struct Page *page) {
  102d3d:	55                   	push   %ebp
  102d3e:	89 e5                	mov    %esp,%ebp
    return page - pages;
  102d40:	a1 78 0f 12 00       	mov    0x120f78,%eax
  102d45:	8b 55 08             	mov    0x8(%ebp),%edx
  102d48:	29 c2                	sub    %eax,%edx
  102d4a:	89 d0                	mov    %edx,%eax
  102d4c:	c1 f8 02             	sar    $0x2,%eax
  102d4f:	69 c0 cd cc cc cc    	imul   $0xcccccccd,%eax,%eax
}
  102d55:	5d                   	pop    %ebp
  102d56:	c3                   	ret    

00102d57 <page2pa>:

static inline uintptr_t
page2pa(struct Page *page) {
  102d57:	55                   	push   %ebp
  102d58:	89 e5                	mov    %esp,%ebp
  102d5a:	83 ec 04             	sub    $0x4,%esp
    return page2ppn(page) << PGSHIFT;
  102d5d:	8b 45 08             	mov    0x8(%ebp),%eax
  102d60:	89 04 24             	mov    %eax,(%esp)
  102d63:	e8 d5 ff ff ff       	call   102d3d <page2ppn>
  102d68:	c1 e0 0c             	shl    $0xc,%eax
}
  102d6b:	c9                   	leave  
  102d6c:	c3                   	ret    

00102d6d <pa2page>:

static inline struct Page *
pa2page(uintptr_t pa) {
  102d6d:	55                   	push   %ebp
  102d6e:	89 e5                	mov    %esp,%ebp
  102d70:	83 ec 18             	sub    $0x18,%esp
    if (PPN(pa) >= npage) {
  102d73:	8b 45 08             	mov    0x8(%ebp),%eax
  102d76:	c1 e8 0c             	shr    $0xc,%eax
  102d79:	89 c2                	mov    %eax,%edx
  102d7b:	a1 80 0e 12 00       	mov    0x120e80,%eax
  102d80:	39 c2                	cmp    %eax,%edx
  102d82:	72 1c                	jb     102da0 <pa2page+0x33>
        panic("pa2page called with invalid pa");
  102d84:	c7 44 24 08 90 7f 10 	movl   $0x107f90,0x8(%esp)
  102d8b:	00 
  102d8c:	c7 44 24 04 60 00 00 	movl   $0x60,0x4(%esp)
  102d93:	00 
  102d94:	c7 04 24 af 7f 10 00 	movl   $0x107faf,(%esp)
  102d9b:	e8 91 d6 ff ff       	call   100431 <__panic>
    }
    return &pages[PPN(pa)];
  102da0:	8b 0d 78 0f 12 00    	mov    0x120f78,%ecx
  102da6:	8b 45 08             	mov    0x8(%ebp),%eax
  102da9:	c1 e8 0c             	shr    $0xc,%eax
  102dac:	89 c2                	mov    %eax,%edx
  102dae:	89 d0                	mov    %edx,%eax
  102db0:	c1 e0 02             	shl    $0x2,%eax
  102db3:	01 d0                	add    %edx,%eax
  102db5:	c1 e0 02             	shl    $0x2,%eax
  102db8:	01 c8                	add    %ecx,%eax
}
  102dba:	c9                   	leave  
  102dbb:	c3                   	ret    

00102dbc <page2kva>:

static inline void *
page2kva(struct Page *page) {
  102dbc:	55                   	push   %ebp
  102dbd:	89 e5                	mov    %esp,%ebp
  102dbf:	83 ec 28             	sub    $0x28,%esp
    return KADDR(page2pa(page));
  102dc2:	8b 45 08             	mov    0x8(%ebp),%eax
  102dc5:	89 04 24             	mov    %eax,(%esp)
  102dc8:	e8 8a ff ff ff       	call   102d57 <page2pa>
  102dcd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  102dd0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102dd3:	c1 e8 0c             	shr    $0xc,%eax
  102dd6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102dd9:	a1 80 0e 12 00       	mov    0x120e80,%eax
  102dde:	39 45 f0             	cmp    %eax,-0x10(%ebp)
  102de1:	72 23                	jb     102e06 <page2kva+0x4a>
  102de3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102de6:	89 44 24 0c          	mov    %eax,0xc(%esp)
  102dea:	c7 44 24 08 c0 7f 10 	movl   $0x107fc0,0x8(%esp)
  102df1:	00 
  102df2:	c7 44 24 04 67 00 00 	movl   $0x67,0x4(%esp)
  102df9:	00 
  102dfa:	c7 04 24 af 7f 10 00 	movl   $0x107faf,(%esp)
  102e01:	e8 2b d6 ff ff       	call   100431 <__panic>
  102e06:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102e09:	2d 00 00 00 40       	sub    $0x40000000,%eax
}
  102e0e:	c9                   	leave  
  102e0f:	c3                   	ret    

00102e10 <pte2page>:
kva2page(void *kva) {
    return pa2page(PADDR(kva));
}

static inline struct Page *
pte2page(pte_t pte) {
  102e10:	55                   	push   %ebp
  102e11:	89 e5                	mov    %esp,%ebp
  102e13:	83 ec 18             	sub    $0x18,%esp
    if (!(pte & PTE_P)) {
  102e16:	8b 45 08             	mov    0x8(%ebp),%eax
  102e19:	83 e0 01             	and    $0x1,%eax
  102e1c:	85 c0                	test   %eax,%eax
  102e1e:	75 1c                	jne    102e3c <pte2page+0x2c>
        panic("pte2page called with invalid pte");
  102e20:	c7 44 24 08 e4 7f 10 	movl   $0x107fe4,0x8(%esp)
  102e27:	00 
  102e28:	c7 44 24 04 72 00 00 	movl   $0x72,0x4(%esp)
  102e2f:	00 
  102e30:	c7 04 24 af 7f 10 00 	movl   $0x107faf,(%esp)
  102e37:	e8 f5 d5 ff ff       	call   100431 <__panic>
    }
    return pa2page(PTE_ADDR(pte));
  102e3c:	8b 45 08             	mov    0x8(%ebp),%eax
  102e3f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  102e44:	89 04 24             	mov    %eax,(%esp)
  102e47:	e8 21 ff ff ff       	call   102d6d <pa2page>
}
  102e4c:	c9                   	leave  
  102e4d:	c3                   	ret    

00102e4e <pde2page>:

static inline struct Page *
pde2page(pde_t pde) {
  102e4e:	55                   	push   %ebp
  102e4f:	89 e5                	mov    %esp,%ebp
  102e51:	83 ec 18             	sub    $0x18,%esp
    return pa2page(PDE_ADDR(pde));
  102e54:	8b 45 08             	mov    0x8(%ebp),%eax
  102e57:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  102e5c:	89 04 24             	mov    %eax,(%esp)
  102e5f:	e8 09 ff ff ff       	call   102d6d <pa2page>
}
  102e64:	c9                   	leave  
  102e65:	c3                   	ret    

00102e66 <page_ref>:

static inline int
page_ref(struct Page *page) {
  102e66:	55                   	push   %ebp
  102e67:	89 e5                	mov    %esp,%ebp
    return page->ref;
  102e69:	8b 45 08             	mov    0x8(%ebp),%eax
  102e6c:	8b 00                	mov    (%eax),%eax
}
  102e6e:	5d                   	pop    %ebp
  102e6f:	c3                   	ret    

00102e70 <set_page_ref>:

static inline void
set_page_ref(struct Page *page, int val) {
  102e70:	55                   	push   %ebp
  102e71:	89 e5                	mov    %esp,%ebp
    page->ref = val;
  102e73:	8b 45 08             	mov    0x8(%ebp),%eax
  102e76:	8b 55 0c             	mov    0xc(%ebp),%edx
  102e79:	89 10                	mov    %edx,(%eax)
}
  102e7b:	90                   	nop
  102e7c:	5d                   	pop    %ebp
  102e7d:	c3                   	ret    

00102e7e <page_ref_inc>:

static inline int
page_ref_inc(struct Page *page) {
  102e7e:	55                   	push   %ebp
  102e7f:	89 e5                	mov    %esp,%ebp
    page->ref += 1;
  102e81:	8b 45 08             	mov    0x8(%ebp),%eax
  102e84:	8b 00                	mov    (%eax),%eax
  102e86:	8d 50 01             	lea    0x1(%eax),%edx
  102e89:	8b 45 08             	mov    0x8(%ebp),%eax
  102e8c:	89 10                	mov    %edx,(%eax)
    return page->ref;
  102e8e:	8b 45 08             	mov    0x8(%ebp),%eax
  102e91:	8b 00                	mov    (%eax),%eax
}
  102e93:	5d                   	pop    %ebp
  102e94:	c3                   	ret    

00102e95 <page_ref_dec>:

static inline int
page_ref_dec(struct Page *page) {
  102e95:	55                   	push   %ebp
  102e96:	89 e5                	mov    %esp,%ebp
    page->ref -= 1;
  102e98:	8b 45 08             	mov    0x8(%ebp),%eax
  102e9b:	8b 00                	mov    (%eax),%eax
  102e9d:	8d 50 ff             	lea    -0x1(%eax),%edx
  102ea0:	8b 45 08             	mov    0x8(%ebp),%eax
  102ea3:	89 10                	mov    %edx,(%eax)
    return page->ref;
  102ea5:	8b 45 08             	mov    0x8(%ebp),%eax
  102ea8:	8b 00                	mov    (%eax),%eax
}
  102eaa:	5d                   	pop    %ebp
  102eab:	c3                   	ret    

00102eac <__intr_save>:
__intr_save(void) {
  102eac:	55                   	push   %ebp
  102ead:	89 e5                	mov    %esp,%ebp
  102eaf:	83 ec 18             	sub    $0x18,%esp
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
  102eb2:	9c                   	pushf  
  102eb3:	58                   	pop    %eax
  102eb4:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return eflags;
  102eb7:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
  102eba:	25 00 02 00 00       	and    $0x200,%eax
  102ebf:	85 c0                	test   %eax,%eax
  102ec1:	74 0c                	je     102ecf <__intr_save+0x23>
        intr_disable();
  102ec3:	e8 c1 ea ff ff       	call   101989 <intr_disable>
        return 1;
  102ec8:	b8 01 00 00 00       	mov    $0x1,%eax
  102ecd:	eb 05                	jmp    102ed4 <__intr_save+0x28>
    return 0;
  102ecf:	b8 00 00 00 00       	mov    $0x0,%eax
}
  102ed4:	c9                   	leave  
  102ed5:	c3                   	ret    

00102ed6 <__intr_restore>:
__intr_restore(bool flag) {
  102ed6:	55                   	push   %ebp
  102ed7:	89 e5                	mov    %esp,%ebp
  102ed9:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
  102edc:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  102ee0:	74 05                	je     102ee7 <__intr_restore+0x11>
        intr_enable();
  102ee2:	e8 96 ea ff ff       	call   10197d <intr_enable>
}
  102ee7:	90                   	nop
  102ee8:	c9                   	leave  
  102ee9:	c3                   	ret    

00102eea <lgdt>:
/* *
 * lgdt - load the global descriptor table register and reset the
 * data/code segement registers for kernel.
 * */
static inline void
lgdt(struct pseudodesc *pd) {
  102eea:	55                   	push   %ebp
  102eeb:	89 e5                	mov    %esp,%ebp
    asm volatile ("lgdt (%0)" :: "r" (pd));
  102eed:	8b 45 08             	mov    0x8(%ebp),%eax
  102ef0:	0f 01 10             	lgdtl  (%eax)
    asm volatile ("movw %%ax, %%gs" :: "a" (USER_DS));
  102ef3:	b8 23 00 00 00       	mov    $0x23,%eax
  102ef8:	8e e8                	mov    %eax,%gs
    asm volatile ("movw %%ax, %%fs" :: "a" (USER_DS));
  102efa:	b8 23 00 00 00       	mov    $0x23,%eax
  102eff:	8e e0                	mov    %eax,%fs
    asm volatile ("movw %%ax, %%es" :: "a" (KERNEL_DS));
  102f01:	b8 10 00 00 00       	mov    $0x10,%eax
  102f06:	8e c0                	mov    %eax,%es
    asm volatile ("movw %%ax, %%ds" :: "a" (KERNEL_DS));
  102f08:	b8 10 00 00 00       	mov    $0x10,%eax
  102f0d:	8e d8                	mov    %eax,%ds
    asm volatile ("movw %%ax, %%ss" :: "a" (KERNEL_DS));
  102f0f:	b8 10 00 00 00       	mov    $0x10,%eax
  102f14:	8e d0                	mov    %eax,%ss
    // reload cs
    asm volatile ("ljmp %0, $1f\n 1:\n" :: "i" (KERNEL_CS));
  102f16:	ea 1d 2f 10 00 08 00 	ljmp   $0x8,$0x102f1d
}
  102f1d:	90                   	nop
  102f1e:	5d                   	pop    %ebp
  102f1f:	c3                   	ret    

00102f20 <load_esp0>:
 * load_esp0 - change the ESP0 in default task state segment,
 * so that we can use different kernel stack when we trap frame
 * user to kernel.
 * */
void
load_esp0(uintptr_t esp0) {
  102f20:	f3 0f 1e fb          	endbr32 
  102f24:	55                   	push   %ebp
  102f25:	89 e5                	mov    %esp,%ebp
    ts.ts_esp0 = esp0;
  102f27:	8b 45 08             	mov    0x8(%ebp),%eax
  102f2a:	a3 a4 0e 12 00       	mov    %eax,0x120ea4
}
  102f2f:	90                   	nop
  102f30:	5d                   	pop    %ebp
  102f31:	c3                   	ret    

00102f32 <gdt_init>:

/* gdt_init - initialize the default GDT and TSS */
static void
gdt_init(void) {
  102f32:	f3 0f 1e fb          	endbr32 
  102f36:	55                   	push   %ebp
  102f37:	89 e5                	mov    %esp,%ebp
  102f39:	83 ec 14             	sub    $0x14,%esp
    // set boot kernel stack and default SS0
    load_esp0((uintptr_t)bootstacktop);
  102f3c:	b8 00 d0 11 00       	mov    $0x11d000,%eax
  102f41:	89 04 24             	mov    %eax,(%esp)
  102f44:	e8 d7 ff ff ff       	call   102f20 <load_esp0>
    ts.ts_ss0 = KERNEL_DS;
  102f49:	66 c7 05 a8 0e 12 00 	movw   $0x10,0x120ea8
  102f50:	10 00 

    // initialize the TSS filed of the gdt
    gdt[SEG_TSS] = SEGTSS(STS_T32A, (uintptr_t)&ts, sizeof(ts), DPL_KERNEL);
  102f52:	66 c7 05 28 da 11 00 	movw   $0x68,0x11da28
  102f59:	68 00 
  102f5b:	b8 a0 0e 12 00       	mov    $0x120ea0,%eax
  102f60:	0f b7 c0             	movzwl %ax,%eax
  102f63:	66 a3 2a da 11 00    	mov    %ax,0x11da2a
  102f69:	b8 a0 0e 12 00       	mov    $0x120ea0,%eax
  102f6e:	c1 e8 10             	shr    $0x10,%eax
  102f71:	a2 2c da 11 00       	mov    %al,0x11da2c
  102f76:	0f b6 05 2d da 11 00 	movzbl 0x11da2d,%eax
  102f7d:	24 f0                	and    $0xf0,%al
  102f7f:	0c 09                	or     $0x9,%al
  102f81:	a2 2d da 11 00       	mov    %al,0x11da2d
  102f86:	0f b6 05 2d da 11 00 	movzbl 0x11da2d,%eax
  102f8d:	24 ef                	and    $0xef,%al
  102f8f:	a2 2d da 11 00       	mov    %al,0x11da2d
  102f94:	0f b6 05 2d da 11 00 	movzbl 0x11da2d,%eax
  102f9b:	24 9f                	and    $0x9f,%al
  102f9d:	a2 2d da 11 00       	mov    %al,0x11da2d
  102fa2:	0f b6 05 2d da 11 00 	movzbl 0x11da2d,%eax
  102fa9:	0c 80                	or     $0x80,%al
  102fab:	a2 2d da 11 00       	mov    %al,0x11da2d
  102fb0:	0f b6 05 2e da 11 00 	movzbl 0x11da2e,%eax
  102fb7:	24 f0                	and    $0xf0,%al
  102fb9:	a2 2e da 11 00       	mov    %al,0x11da2e
  102fbe:	0f b6 05 2e da 11 00 	movzbl 0x11da2e,%eax
  102fc5:	24 ef                	and    $0xef,%al
  102fc7:	a2 2e da 11 00       	mov    %al,0x11da2e
  102fcc:	0f b6 05 2e da 11 00 	movzbl 0x11da2e,%eax
  102fd3:	24 df                	and    $0xdf,%al
  102fd5:	a2 2e da 11 00       	mov    %al,0x11da2e
  102fda:	0f b6 05 2e da 11 00 	movzbl 0x11da2e,%eax
  102fe1:	0c 40                	or     $0x40,%al
  102fe3:	a2 2e da 11 00       	mov    %al,0x11da2e
  102fe8:	0f b6 05 2e da 11 00 	movzbl 0x11da2e,%eax
  102fef:	24 7f                	and    $0x7f,%al
  102ff1:	a2 2e da 11 00       	mov    %al,0x11da2e
  102ff6:	b8 a0 0e 12 00       	mov    $0x120ea0,%eax
  102ffb:	c1 e8 18             	shr    $0x18,%eax
  102ffe:	a2 2f da 11 00       	mov    %al,0x11da2f

    // reload all segment registers
    lgdt(&gdt_pd);
  103003:	c7 04 24 30 da 11 00 	movl   $0x11da30,(%esp)
  10300a:	e8 db fe ff ff       	call   102eea <lgdt>
  10300f:	66 c7 45 fe 28 00    	movw   $0x28,-0x2(%ebp)
    asm volatile ("ltr %0" :: "r" (sel) : "memory");
  103015:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
  103019:	0f 00 d8             	ltr    %ax
}
  10301c:	90                   	nop

    // load the TSS
    ltr(GD_TSS);
}
  10301d:	90                   	nop
  10301e:	c9                   	leave  
  10301f:	c3                   	ret    

00103020 <init_pmm_manager>:

//init_pmm_manager - initialize a pmm_manager instance
static void
init_pmm_manager(void) {
  103020:	f3 0f 1e fb          	endbr32 
  103024:	55                   	push   %ebp
  103025:	89 e5                	mov    %esp,%ebp
  103027:	83 ec 18             	sub    $0x18,%esp
    pmm_manager = &default_pmm_manager;
  10302a:	c7 05 70 0f 12 00 b8 	movl   $0x1089b8,0x120f70
  103031:	89 10 00 
    cprintf("memory management: %s\n", pmm_manager->name);
  103034:	a1 70 0f 12 00       	mov    0x120f70,%eax
  103039:	8b 00                	mov    (%eax),%eax
  10303b:	89 44 24 04          	mov    %eax,0x4(%esp)
  10303f:	c7 04 24 10 80 10 00 	movl   $0x108010,(%esp)
  103046:	e8 7a d2 ff ff       	call   1002c5 <cprintf>
    pmm_manager->init();
  10304b:	a1 70 0f 12 00       	mov    0x120f70,%eax
  103050:	8b 40 04             	mov    0x4(%eax),%eax
  103053:	ff d0                	call   *%eax
}
  103055:	90                   	nop
  103056:	c9                   	leave  
  103057:	c3                   	ret    

00103058 <init_memmap>:

//init_memmap - call pmm->init_memmap to build Page struct for free memory  
static void
init_memmap(struct Page *base, size_t n) {
  103058:	f3 0f 1e fb          	endbr32 
  10305c:	55                   	push   %ebp
  10305d:	89 e5                	mov    %esp,%ebp
  10305f:	83 ec 18             	sub    $0x18,%esp
    pmm_manager->init_memmap(base, n);
  103062:	a1 70 0f 12 00       	mov    0x120f70,%eax
  103067:	8b 40 08             	mov    0x8(%eax),%eax
  10306a:	8b 55 0c             	mov    0xc(%ebp),%edx
  10306d:	89 54 24 04          	mov    %edx,0x4(%esp)
  103071:	8b 55 08             	mov    0x8(%ebp),%edx
  103074:	89 14 24             	mov    %edx,(%esp)
  103077:	ff d0                	call   *%eax
}
  103079:	90                   	nop
  10307a:	c9                   	leave  
  10307b:	c3                   	ret    

0010307c <alloc_pages>:

// 禁用中断FL_IF

//alloc_pages - call pmm->alloc_pages to allocate a continuous n*PAGESIZE memory 
struct Page *
alloc_pages(size_t n) {
  10307c:	f3 0f 1e fb          	endbr32 
  103080:	55                   	push   %ebp
  103081:	89 e5                	mov    %esp,%ebp
  103083:	83 ec 28             	sub    $0x28,%esp
    struct Page *page=NULL;
  103086:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    bool intr_flag;
    local_intr_save(intr_flag);
  10308d:	e8 1a fe ff ff       	call   102eac <__intr_save>
  103092:	89 45 f0             	mov    %eax,-0x10(%ebp)
    {
        page = pmm_manager->alloc_pages(n);
  103095:	a1 70 0f 12 00       	mov    0x120f70,%eax
  10309a:	8b 40 0c             	mov    0xc(%eax),%eax
  10309d:	8b 55 08             	mov    0x8(%ebp),%edx
  1030a0:	89 14 24             	mov    %edx,(%esp)
  1030a3:	ff d0                	call   *%eax
  1030a5:	89 45 f4             	mov    %eax,-0xc(%ebp)
    }
    local_intr_restore(intr_flag);
  1030a8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1030ab:	89 04 24             	mov    %eax,(%esp)
  1030ae:	e8 23 fe ff ff       	call   102ed6 <__intr_restore>
    return page;
  1030b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  1030b6:	c9                   	leave  
  1030b7:	c3                   	ret    

001030b8 <free_pages>:

// 禁用中断FL_IF

//free_pages - call pmm->free_pages to free a continuous n*PAGESIZE memory 
void
free_pages(struct Page *base, size_t n) {
  1030b8:	f3 0f 1e fb          	endbr32 
  1030bc:	55                   	push   %ebp
  1030bd:	89 e5                	mov    %esp,%ebp
  1030bf:	83 ec 28             	sub    $0x28,%esp
    bool intr_flag;
    local_intr_save(intr_flag);
  1030c2:	e8 e5 fd ff ff       	call   102eac <__intr_save>
  1030c7:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        pmm_manager->free_pages(base, n);
  1030ca:	a1 70 0f 12 00       	mov    0x120f70,%eax
  1030cf:	8b 40 10             	mov    0x10(%eax),%eax
  1030d2:	8b 55 0c             	mov    0xc(%ebp),%edx
  1030d5:	89 54 24 04          	mov    %edx,0x4(%esp)
  1030d9:	8b 55 08             	mov    0x8(%ebp),%edx
  1030dc:	89 14 24             	mov    %edx,(%esp)
  1030df:	ff d0                	call   *%eax
    }
    local_intr_restore(intr_flag);
  1030e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1030e4:	89 04 24             	mov    %eax,(%esp)
  1030e7:	e8 ea fd ff ff       	call   102ed6 <__intr_restore>
}
  1030ec:	90                   	nop
  1030ed:	c9                   	leave  
  1030ee:	c3                   	ret    

001030ef <nr_free_pages>:
// 禁用中断FL_IF

//nr_free_pages - call pmm->nr_free_pages to get the size (nr*PAGESIZE) 
//of current free memory
size_t
nr_free_pages(void) {
  1030ef:	f3 0f 1e fb          	endbr32 
  1030f3:	55                   	push   %ebp
  1030f4:	89 e5                	mov    %esp,%ebp
  1030f6:	83 ec 28             	sub    $0x28,%esp
    size_t ret;
    bool intr_flag;
    local_intr_save(intr_flag);
  1030f9:	e8 ae fd ff ff       	call   102eac <__intr_save>
  1030fe:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        ret = pmm_manager->nr_free_pages();
  103101:	a1 70 0f 12 00       	mov    0x120f70,%eax
  103106:	8b 40 14             	mov    0x14(%eax),%eax
  103109:	ff d0                	call   *%eax
  10310b:	89 45 f0             	mov    %eax,-0x10(%ebp)
    }
    local_intr_restore(intr_flag);
  10310e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103111:	89 04 24             	mov    %eax,(%esp)
  103114:	e8 bd fd ff ff       	call   102ed6 <__intr_restore>
    return ret;
  103119:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  10311c:	c9                   	leave  
  10311d:	c3                   	ret    

0010311e <page_init>:
// 第二次遍历memmap->map[]中的每一项，如果类型为E820_ARM，则计算该块物理内存所被映射的页结构基址和数量
// pa2page计算物理地址所对应的页结构基址， (end - begin) / PGSIZE计算页的数量，随后使用init_memmap进行初始化

/* pmm_init - initialize the physical memory management */
static void
page_init(void) {
  10311e:	f3 0f 1e fb          	endbr32 
  103122:	55                   	push   %ebp
  103123:	89 e5                	mov    %esp,%ebp
  103125:	57                   	push   %edi
  103126:	56                   	push   %esi
  103127:	53                   	push   %ebx
  103128:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
    struct e820map *memmap = (struct e820map *)(0x8000 + KERNBASE);
  10312e:	c7 45 c4 00 80 00 c0 	movl   $0xc0008000,-0x3c(%ebp)
    uint64_t maxpa = 0;
  103135:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  10313c:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)

    cprintf("e820map:\n");
  103143:	c7 04 24 27 80 10 00 	movl   $0x108027,(%esp)
  10314a:	e8 76 d1 ff ff       	call   1002c5 <cprintf>
    int i;
    for (i = 0; i < memmap->nr_map; i ++) {
  10314f:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  103156:	e9 1a 01 00 00       	jmp    103275 <page_init+0x157>
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
  10315b:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  10315e:	8b 55 dc             	mov    -0x24(%ebp),%edx
  103161:	89 d0                	mov    %edx,%eax
  103163:	c1 e0 02             	shl    $0x2,%eax
  103166:	01 d0                	add    %edx,%eax
  103168:	c1 e0 02             	shl    $0x2,%eax
  10316b:	01 c8                	add    %ecx,%eax
  10316d:	8b 50 08             	mov    0x8(%eax),%edx
  103170:	8b 40 04             	mov    0x4(%eax),%eax
  103173:	89 45 a0             	mov    %eax,-0x60(%ebp)
  103176:	89 55 a4             	mov    %edx,-0x5c(%ebp)
  103179:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  10317c:	8b 55 dc             	mov    -0x24(%ebp),%edx
  10317f:	89 d0                	mov    %edx,%eax
  103181:	c1 e0 02             	shl    $0x2,%eax
  103184:	01 d0                	add    %edx,%eax
  103186:	c1 e0 02             	shl    $0x2,%eax
  103189:	01 c8                	add    %ecx,%eax
  10318b:	8b 48 0c             	mov    0xc(%eax),%ecx
  10318e:	8b 58 10             	mov    0x10(%eax),%ebx
  103191:	8b 45 a0             	mov    -0x60(%ebp),%eax
  103194:	8b 55 a4             	mov    -0x5c(%ebp),%edx
  103197:	01 c8                	add    %ecx,%eax
  103199:	11 da                	adc    %ebx,%edx
  10319b:	89 45 98             	mov    %eax,-0x68(%ebp)
  10319e:	89 55 9c             	mov    %edx,-0x64(%ebp)
        cprintf("  memory: %08llx, [%08llx, %08llx], type = %d.\n",
  1031a1:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  1031a4:	8b 55 dc             	mov    -0x24(%ebp),%edx
  1031a7:	89 d0                	mov    %edx,%eax
  1031a9:	c1 e0 02             	shl    $0x2,%eax
  1031ac:	01 d0                	add    %edx,%eax
  1031ae:	c1 e0 02             	shl    $0x2,%eax
  1031b1:	01 c8                	add    %ecx,%eax
  1031b3:	83 c0 14             	add    $0x14,%eax
  1031b6:	8b 00                	mov    (%eax),%eax
  1031b8:	89 45 84             	mov    %eax,-0x7c(%ebp)
  1031bb:	8b 45 98             	mov    -0x68(%ebp),%eax
  1031be:	8b 55 9c             	mov    -0x64(%ebp),%edx
  1031c1:	83 c0 ff             	add    $0xffffffff,%eax
  1031c4:	83 d2 ff             	adc    $0xffffffff,%edx
  1031c7:	89 85 78 ff ff ff    	mov    %eax,-0x88(%ebp)
  1031cd:	89 95 7c ff ff ff    	mov    %edx,-0x84(%ebp)
  1031d3:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  1031d6:	8b 55 dc             	mov    -0x24(%ebp),%edx
  1031d9:	89 d0                	mov    %edx,%eax
  1031db:	c1 e0 02             	shl    $0x2,%eax
  1031de:	01 d0                	add    %edx,%eax
  1031e0:	c1 e0 02             	shl    $0x2,%eax
  1031e3:	01 c8                	add    %ecx,%eax
  1031e5:	8b 48 0c             	mov    0xc(%eax),%ecx
  1031e8:	8b 58 10             	mov    0x10(%eax),%ebx
  1031eb:	8b 55 84             	mov    -0x7c(%ebp),%edx
  1031ee:	89 54 24 1c          	mov    %edx,0x1c(%esp)
  1031f2:	8b 85 78 ff ff ff    	mov    -0x88(%ebp),%eax
  1031f8:	8b 95 7c ff ff ff    	mov    -0x84(%ebp),%edx
  1031fe:	89 44 24 14          	mov    %eax,0x14(%esp)
  103202:	89 54 24 18          	mov    %edx,0x18(%esp)
  103206:	8b 45 a0             	mov    -0x60(%ebp),%eax
  103209:	8b 55 a4             	mov    -0x5c(%ebp),%edx
  10320c:	89 44 24 0c          	mov    %eax,0xc(%esp)
  103210:	89 54 24 10          	mov    %edx,0x10(%esp)
  103214:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  103218:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  10321c:	c7 04 24 34 80 10 00 	movl   $0x108034,(%esp)
  103223:	e8 9d d0 ff ff       	call   1002c5 <cprintf>
                memmap->map[i].size, begin, end - 1, memmap->map[i].type);
        if (memmap->map[i].type == E820_ARM) {
  103228:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  10322b:	8b 55 dc             	mov    -0x24(%ebp),%edx
  10322e:	89 d0                	mov    %edx,%eax
  103230:	c1 e0 02             	shl    $0x2,%eax
  103233:	01 d0                	add    %edx,%eax
  103235:	c1 e0 02             	shl    $0x2,%eax
  103238:	01 c8                	add    %ecx,%eax
  10323a:	83 c0 14             	add    $0x14,%eax
  10323d:	8b 00                	mov    (%eax),%eax
  10323f:	83 f8 01             	cmp    $0x1,%eax
  103242:	75 2e                	jne    103272 <page_init+0x154>
            if (maxpa < end && begin < KMEMSIZE) {
  103244:	8b 45 e0             	mov    -0x20(%ebp),%eax
  103247:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  10324a:	3b 45 98             	cmp    -0x68(%ebp),%eax
  10324d:	89 d0                	mov    %edx,%eax
  10324f:	1b 45 9c             	sbb    -0x64(%ebp),%eax
  103252:	73 1e                	jae    103272 <page_init+0x154>
  103254:	ba ff ff ff 37       	mov    $0x37ffffff,%edx
  103259:	b8 00 00 00 00       	mov    $0x0,%eax
  10325e:	3b 55 a0             	cmp    -0x60(%ebp),%edx
  103261:	1b 45 a4             	sbb    -0x5c(%ebp),%eax
  103264:	72 0c                	jb     103272 <page_init+0x154>
                maxpa = end;
  103266:	8b 45 98             	mov    -0x68(%ebp),%eax
  103269:	8b 55 9c             	mov    -0x64(%ebp),%edx
  10326c:	89 45 e0             	mov    %eax,-0x20(%ebp)
  10326f:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    for (i = 0; i < memmap->nr_map; i ++) {
  103272:	ff 45 dc             	incl   -0x24(%ebp)
  103275:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  103278:	8b 00                	mov    (%eax),%eax
  10327a:	39 45 dc             	cmp    %eax,-0x24(%ebp)
  10327d:	0f 8c d8 fe ff ff    	jl     10315b <page_init+0x3d>
            }
        }
    }
    if (maxpa > KMEMSIZE) {
  103283:	ba 00 00 00 38       	mov    $0x38000000,%edx
  103288:	b8 00 00 00 00       	mov    $0x0,%eax
  10328d:	3b 55 e0             	cmp    -0x20(%ebp),%edx
  103290:	1b 45 e4             	sbb    -0x1c(%ebp),%eax
  103293:	73 0e                	jae    1032a3 <page_init+0x185>
        maxpa = KMEMSIZE;
  103295:	c7 45 e0 00 00 00 38 	movl   $0x38000000,-0x20(%ebp)
  10329c:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    }

    extern char end[];

    npage = maxpa / PGSIZE;
  1032a3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1032a6:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  1032a9:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
  1032ad:	c1 ea 0c             	shr    $0xc,%edx
  1032b0:	a3 80 0e 12 00       	mov    %eax,0x120e80
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
  1032b5:	c7 45 c0 00 10 00 00 	movl   $0x1000,-0x40(%ebp)
  1032bc:	b8 84 10 32 00       	mov    $0x321084,%eax
  1032c1:	8d 50 ff             	lea    -0x1(%eax),%edx
  1032c4:	8b 45 c0             	mov    -0x40(%ebp),%eax
  1032c7:	01 d0                	add    %edx,%eax
  1032c9:	89 45 bc             	mov    %eax,-0x44(%ebp)
  1032cc:	8b 45 bc             	mov    -0x44(%ebp),%eax
  1032cf:	ba 00 00 00 00       	mov    $0x0,%edx
  1032d4:	f7 75 c0             	divl   -0x40(%ebp)
  1032d7:	8b 45 bc             	mov    -0x44(%ebp),%eax
  1032da:	29 d0                	sub    %edx,%eax
  1032dc:	a3 78 0f 12 00       	mov    %eax,0x120f78
    
    for (i = 0; i < npage; i ++) {
  1032e1:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  1032e8:	eb 2f                	jmp    103319 <page_init+0x1fb>
        SetPageReserved(pages + i);
  1032ea:	8b 0d 78 0f 12 00    	mov    0x120f78,%ecx
  1032f0:	8b 55 dc             	mov    -0x24(%ebp),%edx
  1032f3:	89 d0                	mov    %edx,%eax
  1032f5:	c1 e0 02             	shl    $0x2,%eax
  1032f8:	01 d0                	add    %edx,%eax
  1032fa:	c1 e0 02             	shl    $0x2,%eax
  1032fd:	01 c8                	add    %ecx,%eax
  1032ff:	83 c0 04             	add    $0x4,%eax
  103302:	c7 45 94 00 00 00 00 	movl   $0x0,-0x6c(%ebp)
  103309:	89 45 90             	mov    %eax,-0x70(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  10330c:	8b 45 90             	mov    -0x70(%ebp),%eax
  10330f:	8b 55 94             	mov    -0x6c(%ebp),%edx
  103312:	0f ab 10             	bts    %edx,(%eax)
}
  103315:	90                   	nop
    for (i = 0; i < npage; i ++) {
  103316:	ff 45 dc             	incl   -0x24(%ebp)
  103319:	8b 55 dc             	mov    -0x24(%ebp),%edx
  10331c:	a1 80 0e 12 00       	mov    0x120e80,%eax
  103321:	39 c2                	cmp    %eax,%edx
  103323:	72 c5                	jb     1032ea <page_init+0x1cc>
    }

    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * npage);
  103325:	8b 15 80 0e 12 00    	mov    0x120e80,%edx
  10332b:	89 d0                	mov    %edx,%eax
  10332d:	c1 e0 02             	shl    $0x2,%eax
  103330:	01 d0                	add    %edx,%eax
  103332:	c1 e0 02             	shl    $0x2,%eax
  103335:	89 c2                	mov    %eax,%edx
  103337:	a1 78 0f 12 00       	mov    0x120f78,%eax
  10333c:	01 d0                	add    %edx,%eax
  10333e:	89 45 b8             	mov    %eax,-0x48(%ebp)
  103341:	81 7d b8 ff ff ff bf 	cmpl   $0xbfffffff,-0x48(%ebp)
  103348:	77 23                	ja     10336d <page_init+0x24f>
  10334a:	8b 45 b8             	mov    -0x48(%ebp),%eax
  10334d:	89 44 24 0c          	mov    %eax,0xc(%esp)
  103351:	c7 44 24 08 64 80 10 	movl   $0x108064,0x8(%esp)
  103358:	00 
  103359:	c7 44 24 04 ec 00 00 	movl   $0xec,0x4(%esp)
  103360:	00 
  103361:	c7 04 24 88 80 10 00 	movl   $0x108088,(%esp)
  103368:	e8 c4 d0 ff ff       	call   100431 <__panic>
  10336d:	8b 45 b8             	mov    -0x48(%ebp),%eax
  103370:	05 00 00 00 40       	add    $0x40000000,%eax
  103375:	89 45 b4             	mov    %eax,-0x4c(%ebp)

    for (i = 0; i < memmap->nr_map; i ++) {
  103378:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  10337f:	e9 4b 01 00 00       	jmp    1034cf <page_init+0x3b1>
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
  103384:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  103387:	8b 55 dc             	mov    -0x24(%ebp),%edx
  10338a:	89 d0                	mov    %edx,%eax
  10338c:	c1 e0 02             	shl    $0x2,%eax
  10338f:	01 d0                	add    %edx,%eax
  103391:	c1 e0 02             	shl    $0x2,%eax
  103394:	01 c8                	add    %ecx,%eax
  103396:	8b 50 08             	mov    0x8(%eax),%edx
  103399:	8b 40 04             	mov    0x4(%eax),%eax
  10339c:	89 45 d0             	mov    %eax,-0x30(%ebp)
  10339f:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  1033a2:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  1033a5:	8b 55 dc             	mov    -0x24(%ebp),%edx
  1033a8:	89 d0                	mov    %edx,%eax
  1033aa:	c1 e0 02             	shl    $0x2,%eax
  1033ad:	01 d0                	add    %edx,%eax
  1033af:	c1 e0 02             	shl    $0x2,%eax
  1033b2:	01 c8                	add    %ecx,%eax
  1033b4:	8b 48 0c             	mov    0xc(%eax),%ecx
  1033b7:	8b 58 10             	mov    0x10(%eax),%ebx
  1033ba:	8b 45 d0             	mov    -0x30(%ebp),%eax
  1033bd:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  1033c0:	01 c8                	add    %ecx,%eax
  1033c2:	11 da                	adc    %ebx,%edx
  1033c4:	89 45 c8             	mov    %eax,-0x38(%ebp)
  1033c7:	89 55 cc             	mov    %edx,-0x34(%ebp)
        if (memmap->map[i].type == E820_ARM) {
  1033ca:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  1033cd:	8b 55 dc             	mov    -0x24(%ebp),%edx
  1033d0:	89 d0                	mov    %edx,%eax
  1033d2:	c1 e0 02             	shl    $0x2,%eax
  1033d5:	01 d0                	add    %edx,%eax
  1033d7:	c1 e0 02             	shl    $0x2,%eax
  1033da:	01 c8                	add    %ecx,%eax
  1033dc:	83 c0 14             	add    $0x14,%eax
  1033df:	8b 00                	mov    (%eax),%eax
  1033e1:	83 f8 01             	cmp    $0x1,%eax
  1033e4:	0f 85 e2 00 00 00    	jne    1034cc <page_init+0x3ae>
            if (begin < freemem) {
  1033ea:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  1033ed:	ba 00 00 00 00       	mov    $0x0,%edx
  1033f2:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  1033f5:	39 45 d0             	cmp    %eax,-0x30(%ebp)
  1033f8:	19 d1                	sbb    %edx,%ecx
  1033fa:	73 0d                	jae    103409 <page_init+0x2eb>
                begin = freemem;
  1033fc:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  1033ff:	89 45 d0             	mov    %eax,-0x30(%ebp)
  103402:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
            }
            if (end > KMEMSIZE) {
  103409:	ba 00 00 00 38       	mov    $0x38000000,%edx
  10340e:	b8 00 00 00 00       	mov    $0x0,%eax
  103413:	3b 55 c8             	cmp    -0x38(%ebp),%edx
  103416:	1b 45 cc             	sbb    -0x34(%ebp),%eax
  103419:	73 0e                	jae    103429 <page_init+0x30b>
                end = KMEMSIZE;
  10341b:	c7 45 c8 00 00 00 38 	movl   $0x38000000,-0x38(%ebp)
  103422:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
            }
            if (begin < end) {
  103429:	8b 45 d0             	mov    -0x30(%ebp),%eax
  10342c:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  10342f:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  103432:	89 d0                	mov    %edx,%eax
  103434:	1b 45 cc             	sbb    -0x34(%ebp),%eax
  103437:	0f 83 8f 00 00 00    	jae    1034cc <page_init+0x3ae>
                begin = ROUNDUP(begin, PGSIZE);
  10343d:	c7 45 b0 00 10 00 00 	movl   $0x1000,-0x50(%ebp)
  103444:	8b 55 d0             	mov    -0x30(%ebp),%edx
  103447:	8b 45 b0             	mov    -0x50(%ebp),%eax
  10344a:	01 d0                	add    %edx,%eax
  10344c:	48                   	dec    %eax
  10344d:	89 45 ac             	mov    %eax,-0x54(%ebp)
  103450:	8b 45 ac             	mov    -0x54(%ebp),%eax
  103453:	ba 00 00 00 00       	mov    $0x0,%edx
  103458:	f7 75 b0             	divl   -0x50(%ebp)
  10345b:	8b 45 ac             	mov    -0x54(%ebp),%eax
  10345e:	29 d0                	sub    %edx,%eax
  103460:	ba 00 00 00 00       	mov    $0x0,%edx
  103465:	89 45 d0             	mov    %eax,-0x30(%ebp)
  103468:	89 55 d4             	mov    %edx,-0x2c(%ebp)
                end = ROUNDDOWN(end, PGSIZE);
  10346b:	8b 45 c8             	mov    -0x38(%ebp),%eax
  10346e:	89 45 a8             	mov    %eax,-0x58(%ebp)
  103471:	8b 45 a8             	mov    -0x58(%ebp),%eax
  103474:	ba 00 00 00 00       	mov    $0x0,%edx
  103479:	89 c3                	mov    %eax,%ebx
  10347b:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  103481:	89 de                	mov    %ebx,%esi
  103483:	89 d0                	mov    %edx,%eax
  103485:	83 e0 00             	and    $0x0,%eax
  103488:	89 c7                	mov    %eax,%edi
  10348a:	89 75 c8             	mov    %esi,-0x38(%ebp)
  10348d:	89 7d cc             	mov    %edi,-0x34(%ebp)
                if (begin < end) {
  103490:	8b 45 d0             	mov    -0x30(%ebp),%eax
  103493:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  103496:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  103499:	89 d0                	mov    %edx,%eax
  10349b:	1b 45 cc             	sbb    -0x34(%ebp),%eax
  10349e:	73 2c                	jae    1034cc <page_init+0x3ae>
                    init_memmap(pa2page(begin), (end - begin) / PGSIZE);
  1034a0:	8b 45 c8             	mov    -0x38(%ebp),%eax
  1034a3:	8b 55 cc             	mov    -0x34(%ebp),%edx
  1034a6:	2b 45 d0             	sub    -0x30(%ebp),%eax
  1034a9:	1b 55 d4             	sbb    -0x2c(%ebp),%edx
  1034ac:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
  1034b0:	c1 ea 0c             	shr    $0xc,%edx
  1034b3:	89 c3                	mov    %eax,%ebx
  1034b5:	8b 45 d0             	mov    -0x30(%ebp),%eax
  1034b8:	89 04 24             	mov    %eax,(%esp)
  1034bb:	e8 ad f8 ff ff       	call   102d6d <pa2page>
  1034c0:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  1034c4:	89 04 24             	mov    %eax,(%esp)
  1034c7:	e8 8c fb ff ff       	call   103058 <init_memmap>
    for (i = 0; i < memmap->nr_map; i ++) {
  1034cc:	ff 45 dc             	incl   -0x24(%ebp)
  1034cf:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  1034d2:	8b 00                	mov    (%eax),%eax
  1034d4:	39 45 dc             	cmp    %eax,-0x24(%ebp)
  1034d7:	0f 8c a7 fe ff ff    	jl     103384 <page_init+0x266>
                }
            }
        }
    }
}
  1034dd:	90                   	nop
  1034de:	90                   	nop
  1034df:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  1034e5:	5b                   	pop    %ebx
  1034e6:	5e                   	pop    %esi
  1034e7:	5f                   	pop    %edi
  1034e8:	5d                   	pop    %ebp
  1034e9:	c3                   	ret    

001034ea <boot_map_segment>:
//  la:   linear address of this memory need to map (after x86 segment map)
//  size: memory size
//  pa:   physical address of this memory
//  perm: permission of this memory  
static void
boot_map_segment(pde_t *pgdir, uintptr_t la, size_t size, uintptr_t pa, uint32_t perm) {
  1034ea:	f3 0f 1e fb          	endbr32 
  1034ee:	55                   	push   %ebp
  1034ef:	89 e5                	mov    %esp,%ebp
  1034f1:	83 ec 38             	sub    $0x38,%esp
    assert(PGOFF(la) == PGOFF(pa));
  1034f4:	8b 45 0c             	mov    0xc(%ebp),%eax
  1034f7:	33 45 14             	xor    0x14(%ebp),%eax
  1034fa:	25 ff 0f 00 00       	and    $0xfff,%eax
  1034ff:	85 c0                	test   %eax,%eax
  103501:	74 24                	je     103527 <boot_map_segment+0x3d>
  103503:	c7 44 24 0c 96 80 10 	movl   $0x108096,0xc(%esp)
  10350a:	00 
  10350b:	c7 44 24 08 ad 80 10 	movl   $0x1080ad,0x8(%esp)
  103512:	00 
  103513:	c7 44 24 04 0a 01 00 	movl   $0x10a,0x4(%esp)
  10351a:	00 
  10351b:	c7 04 24 88 80 10 00 	movl   $0x108088,(%esp)
  103522:	e8 0a cf ff ff       	call   100431 <__panic>
    size_t n = ROUNDUP(size + PGOFF(la), PGSIZE) / PGSIZE;
  103527:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  10352e:	8b 45 0c             	mov    0xc(%ebp),%eax
  103531:	25 ff 0f 00 00       	and    $0xfff,%eax
  103536:	89 c2                	mov    %eax,%edx
  103538:	8b 45 10             	mov    0x10(%ebp),%eax
  10353b:	01 c2                	add    %eax,%edx
  10353d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103540:	01 d0                	add    %edx,%eax
  103542:	48                   	dec    %eax
  103543:	89 45 ec             	mov    %eax,-0x14(%ebp)
  103546:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103549:	ba 00 00 00 00       	mov    $0x0,%edx
  10354e:	f7 75 f0             	divl   -0x10(%ebp)
  103551:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103554:	29 d0                	sub    %edx,%eax
  103556:	c1 e8 0c             	shr    $0xc,%eax
  103559:	89 45 f4             	mov    %eax,-0xc(%ebp)
    la = ROUNDDOWN(la, PGSIZE);
  10355c:	8b 45 0c             	mov    0xc(%ebp),%eax
  10355f:	89 45 e8             	mov    %eax,-0x18(%ebp)
  103562:	8b 45 e8             	mov    -0x18(%ebp),%eax
  103565:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  10356a:	89 45 0c             	mov    %eax,0xc(%ebp)
    pa = ROUNDDOWN(pa, PGSIZE);
  10356d:	8b 45 14             	mov    0x14(%ebp),%eax
  103570:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  103573:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103576:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  10357b:	89 45 14             	mov    %eax,0x14(%ebp)
    for (; n > 0; n --, la += PGSIZE, pa += PGSIZE) {
  10357e:	eb 68                	jmp    1035e8 <boot_map_segment+0xfe>
        pte_t *ptep = get_pte(pgdir, la, 1);
  103580:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  103587:	00 
  103588:	8b 45 0c             	mov    0xc(%ebp),%eax
  10358b:	89 44 24 04          	mov    %eax,0x4(%esp)
  10358f:	8b 45 08             	mov    0x8(%ebp),%eax
  103592:	89 04 24             	mov    %eax,(%esp)
  103595:	e8 8a 01 00 00       	call   103724 <get_pte>
  10359a:	89 45 e0             	mov    %eax,-0x20(%ebp)
        assert(ptep != NULL);
  10359d:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  1035a1:	75 24                	jne    1035c7 <boot_map_segment+0xdd>
  1035a3:	c7 44 24 0c c2 80 10 	movl   $0x1080c2,0xc(%esp)
  1035aa:	00 
  1035ab:	c7 44 24 08 ad 80 10 	movl   $0x1080ad,0x8(%esp)
  1035b2:	00 
  1035b3:	c7 44 24 04 10 01 00 	movl   $0x110,0x4(%esp)
  1035ba:	00 
  1035bb:	c7 04 24 88 80 10 00 	movl   $0x108088,(%esp)
  1035c2:	e8 6a ce ff ff       	call   100431 <__panic>
        *ptep = pa | PTE_P | perm;
  1035c7:	8b 45 14             	mov    0x14(%ebp),%eax
  1035ca:	0b 45 18             	or     0x18(%ebp),%eax
  1035cd:	83 c8 01             	or     $0x1,%eax
  1035d0:	89 c2                	mov    %eax,%edx
  1035d2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1035d5:	89 10                	mov    %edx,(%eax)
    for (; n > 0; n --, la += PGSIZE, pa += PGSIZE) {
  1035d7:	ff 4d f4             	decl   -0xc(%ebp)
  1035da:	81 45 0c 00 10 00 00 	addl   $0x1000,0xc(%ebp)
  1035e1:	81 45 14 00 10 00 00 	addl   $0x1000,0x14(%ebp)
  1035e8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1035ec:	75 92                	jne    103580 <boot_map_segment+0x96>
    }
}
  1035ee:	90                   	nop
  1035ef:	90                   	nop
  1035f0:	c9                   	leave  
  1035f1:	c3                   	ret    

001035f2 <boot_alloc_page>:

//boot_alloc_page - allocate one page using pmm->alloc_pages(1) 
// return value: the kernel virtual address of this allocated page
//note: this function is used to get the memory for PDT(Page Directory Table)&PT(Page Table)
static void *
boot_alloc_page(void) {
  1035f2:	f3 0f 1e fb          	endbr32 
  1035f6:	55                   	push   %ebp
  1035f7:	89 e5                	mov    %esp,%ebp
  1035f9:	83 ec 28             	sub    $0x28,%esp
    struct Page *p = alloc_page();
  1035fc:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  103603:	e8 74 fa ff ff       	call   10307c <alloc_pages>
  103608:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (p == NULL) {
  10360b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  10360f:	75 1c                	jne    10362d <boot_alloc_page+0x3b>
        panic("boot_alloc_page failed.\n");
  103611:	c7 44 24 08 cf 80 10 	movl   $0x1080cf,0x8(%esp)
  103618:	00 
  103619:	c7 44 24 04 1c 01 00 	movl   $0x11c,0x4(%esp)
  103620:	00 
  103621:	c7 04 24 88 80 10 00 	movl   $0x108088,(%esp)
  103628:	e8 04 ce ff ff       	call   100431 <__panic>
    }
    return page2kva(p);
  10362d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103630:	89 04 24             	mov    %eax,(%esp)
  103633:	e8 84 f7 ff ff       	call   102dbc <page2kva>
}
  103638:	c9                   	leave  
  103639:	c3                   	ret    

0010363a <pmm_init>:

//pmm_init - setup a pmm to manage physical memory, build PDT&PT to setup paging mechanism 
//         - check the correctness of pmm & paging mechanism, print PDT&PT
void
pmm_init(void) {
  10363a:	f3 0f 1e fb          	endbr32 
  10363e:	55                   	push   %ebp
  10363f:	89 e5                	mov    %esp,%ebp
  103641:	83 ec 38             	sub    $0x38,%esp
    // We've already enabled paging
    boot_cr3 = PADDR(boot_pgdir);
  103644:	a1 e0 d9 11 00       	mov    0x11d9e0,%eax
  103649:	89 45 f4             	mov    %eax,-0xc(%ebp)
  10364c:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
  103653:	77 23                	ja     103678 <pmm_init+0x3e>
  103655:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103658:	89 44 24 0c          	mov    %eax,0xc(%esp)
  10365c:	c7 44 24 08 64 80 10 	movl   $0x108064,0x8(%esp)
  103663:	00 
  103664:	c7 44 24 04 26 01 00 	movl   $0x126,0x4(%esp)
  10366b:	00 
  10366c:	c7 04 24 88 80 10 00 	movl   $0x108088,(%esp)
  103673:	e8 b9 cd ff ff       	call   100431 <__panic>
  103678:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10367b:	05 00 00 00 40       	add    $0x40000000,%eax
  103680:	a3 74 0f 12 00       	mov    %eax,0x120f74
    //We need to alloc/free the physical memory (granularity is 4KB or other size). 
    //So a framework of physical memory manager (struct pmm_manager)is defined in pmm.h
    //First we should init a physical memory manager(pmm) based on the framework.
    //Then pmm can alloc/free the physical memory. 
    //Now the first_fit/best_fit/worst_fit/buddy_system pmm are available.
    init_pmm_manager();
  103685:	e8 96 f9 ff ff       	call   103020 <init_pmm_manager>

    // detect physical memory space, reserve already used memory,
    // then use pmm->init_memmap to create free page list
    page_init();
  10368a:	e8 8f fa ff ff       	call   10311e <page_init>

    //use pmm->check to verify the correctness of the alloc/free function in a pmm
    check_alloc_page();
  10368f:	e8 f3 03 00 00       	call   103a87 <check_alloc_page>

    check_pgdir();
  103694:	e8 11 04 00 00       	call   103aaa <check_pgdir>

    static_assert(KERNBASE % PTSIZE == 0 && KERNTOP % PTSIZE == 0);

    // recursively insert boot_pgdir in itself
    // to form a virtual page table at virtual address VPT
    boot_pgdir[PDX(VPT)] = PADDR(boot_pgdir) | PTE_P | PTE_W;
  103699:	a1 e0 d9 11 00       	mov    0x11d9e0,%eax
  10369e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1036a1:	81 7d f0 ff ff ff bf 	cmpl   $0xbfffffff,-0x10(%ebp)
  1036a8:	77 23                	ja     1036cd <pmm_init+0x93>
  1036aa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1036ad:	89 44 24 0c          	mov    %eax,0xc(%esp)
  1036b1:	c7 44 24 08 64 80 10 	movl   $0x108064,0x8(%esp)
  1036b8:	00 
  1036b9:	c7 44 24 04 3c 01 00 	movl   $0x13c,0x4(%esp)
  1036c0:	00 
  1036c1:	c7 04 24 88 80 10 00 	movl   $0x108088,(%esp)
  1036c8:	e8 64 cd ff ff       	call   100431 <__panic>
  1036cd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1036d0:	8d 90 00 00 00 40    	lea    0x40000000(%eax),%edx
  1036d6:	a1 e0 d9 11 00       	mov    0x11d9e0,%eax
  1036db:	05 ac 0f 00 00       	add    $0xfac,%eax
  1036e0:	83 ca 03             	or     $0x3,%edx
  1036e3:	89 10                	mov    %edx,(%eax)

    // map all physical memory to linear memory with base linear addr KERNBASE
    // linear_addr KERNBASE ~ KERNBASE + KMEMSIZE = phy_addr 0 ~ KMEMSIZE
    boot_map_segment(boot_pgdir, KERNBASE, KMEMSIZE, 0, PTE_W);
  1036e5:	a1 e0 d9 11 00       	mov    0x11d9e0,%eax
  1036ea:	c7 44 24 10 02 00 00 	movl   $0x2,0x10(%esp)
  1036f1:	00 
  1036f2:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  1036f9:	00 
  1036fa:	c7 44 24 08 00 00 00 	movl   $0x38000000,0x8(%esp)
  103701:	38 
  103702:	c7 44 24 04 00 00 00 	movl   $0xc0000000,0x4(%esp)
  103709:	c0 
  10370a:	89 04 24             	mov    %eax,(%esp)
  10370d:	e8 d8 fd ff ff       	call   1034ea <boot_map_segment>

    // Since we are using bootloader's GDT,
    // we should reload gdt (second time, the last time) to get user segments and the TSS
    // map virtual_addr 0 ~ 4G = linear_addr 0 ~ 4G
    // then set kernel stack (ss:esp) in TSS, setup TSS in gdt, load TSS
    gdt_init();
  103712:	e8 1b f8 ff ff       	call   102f32 <gdt_init>

    //now the basic virtual memory map(see memalyout.h) is established.
    //check the correctness of the basic virtual memory map.
    check_boot_pgdir();
  103717:	e8 2e 0a 00 00       	call   10414a <check_boot_pgdir>

    print_pgdir();
  10371c:	e8 b3 0e 00 00       	call   1045d4 <print_pgdir>

}
  103721:	90                   	nop
  103722:	c9                   	leave  
  103723:	c3                   	ret    

00103724 <get_pte>:
//  pgdir:  the kernel virtual base address of PDT
//  la:     the linear address need to map
//  create: a logical value to decide if alloc a page for PT
// return vaule: the kernel virtual address of this pte
pte_t *
get_pte(pde_t *pgdir, uintptr_t la, bool create) {
  103724:	f3 0f 1e fb          	endbr32 
  103728:	55                   	push   %ebp
  103729:	89 e5                	mov    %esp,%ebp
  10372b:	83 ec 38             	sub    $0x38,%esp
                          // (6) clear page content using memset
                          // (7) set page directory entry's permission
    }
    return NULL;          // (8) return page table entry
#endif
    pde_t *pdep = &pgdir[PDX(la)];  //尝试获得页表
  10372e:	8b 45 0c             	mov    0xc(%ebp),%eax
  103731:	c1 e8 16             	shr    $0x16,%eax
  103734:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  10373b:	8b 45 08             	mov    0x8(%ebp),%eax
  10373e:	01 d0                	add    %edx,%eax
  103740:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (!(*pdep & PTE_P)) { //如果获取不成功
  103743:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103746:	8b 00                	mov    (%eax),%eax
  103748:	83 e0 01             	and    $0x1,%eax
  10374b:	85 c0                	test   %eax,%eax
  10374d:	0f 85 af 00 00 00    	jne    103802 <get_pte+0xde>
        struct Page *page;
        //假如不需要分配或是分配失败
        if (!create || (page = alloc_page()) == NULL) { 
  103753:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  103757:	74 15                	je     10376e <get_pte+0x4a>
  103759:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  103760:	e8 17 f9 ff ff       	call   10307c <alloc_pages>
  103765:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103768:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  10376c:	75 0a                	jne    103778 <get_pte+0x54>
            return NULL;
  10376e:	b8 00 00 00 00       	mov    $0x0,%eax
  103773:	e9 e7 00 00 00       	jmp    10385f <get_pte+0x13b>
        }
        set_page_ref(page, 1); //引用次数加一
  103778:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  10377f:	00 
  103780:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103783:	89 04 24             	mov    %eax,(%esp)
  103786:	e8 e5 f6 ff ff       	call   102e70 <set_page_ref>
        uintptr_t pa = page2pa(page);  //得到该页物理地址
  10378b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10378e:	89 04 24             	mov    %eax,(%esp)
  103791:	e8 c1 f5 ff ff       	call   102d57 <page2pa>
  103796:	89 45 ec             	mov    %eax,-0x14(%ebp)
        memset(KADDR(pa), 0, PGSIZE); //物理地址转虚拟地址，并初始化
  103799:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10379c:	89 45 e8             	mov    %eax,-0x18(%ebp)
  10379f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1037a2:	c1 e8 0c             	shr    $0xc,%eax
  1037a5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  1037a8:	a1 80 0e 12 00       	mov    0x120e80,%eax
  1037ad:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  1037b0:	72 23                	jb     1037d5 <get_pte+0xb1>
  1037b2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1037b5:	89 44 24 0c          	mov    %eax,0xc(%esp)
  1037b9:	c7 44 24 08 c0 7f 10 	movl   $0x107fc0,0x8(%esp)
  1037c0:	00 
  1037c1:	c7 44 24 04 90 01 00 	movl   $0x190,0x4(%esp)
  1037c8:	00 
  1037c9:	c7 04 24 88 80 10 00 	movl   $0x108088,(%esp)
  1037d0:	e8 5c cc ff ff       	call   100431 <__panic>
  1037d5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1037d8:	2d 00 00 00 40       	sub    $0x40000000,%eax
  1037dd:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  1037e4:	00 
  1037e5:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  1037ec:	00 
  1037ed:	89 04 24             	mov    %eax,(%esp)
  1037f0:	e8 ed 37 00 00       	call   106fe2 <memset>
        *pdep = pa | PTE_U | PTE_W | PTE_P; //设置控制位
  1037f5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1037f8:	83 c8 07             	or     $0x7,%eax
  1037fb:	89 c2                	mov    %eax,%edx
  1037fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103800:	89 10                	mov    %edx,(%eax)
    }
    return &((pte_t *)KADDR(PDE_ADDR(*pdep)))[PTX(la)]; 
  103802:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103805:	8b 00                	mov    (%eax),%eax
  103807:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  10380c:	89 45 e0             	mov    %eax,-0x20(%ebp)
  10380f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  103812:	c1 e8 0c             	shr    $0xc,%eax
  103815:	89 45 dc             	mov    %eax,-0x24(%ebp)
  103818:	a1 80 0e 12 00       	mov    0x120e80,%eax
  10381d:	39 45 dc             	cmp    %eax,-0x24(%ebp)
  103820:	72 23                	jb     103845 <get_pte+0x121>
  103822:	8b 45 e0             	mov    -0x20(%ebp),%eax
  103825:	89 44 24 0c          	mov    %eax,0xc(%esp)
  103829:	c7 44 24 08 c0 7f 10 	movl   $0x107fc0,0x8(%esp)
  103830:	00 
  103831:	c7 44 24 04 93 01 00 	movl   $0x193,0x4(%esp)
  103838:	00 
  103839:	c7 04 24 88 80 10 00 	movl   $0x108088,(%esp)
  103840:	e8 ec cb ff ff       	call   100431 <__panic>
  103845:	8b 45 e0             	mov    -0x20(%ebp),%eax
  103848:	2d 00 00 00 40       	sub    $0x40000000,%eax
  10384d:	89 c2                	mov    %eax,%edx
  10384f:	8b 45 0c             	mov    0xc(%ebp),%eax
  103852:	c1 e8 0c             	shr    $0xc,%eax
  103855:	25 ff 03 00 00       	and    $0x3ff,%eax
  10385a:	c1 e0 02             	shl    $0x2,%eax
  10385d:	01 d0                	add    %edx,%eax
    //KADDR(PDE_ADDR(*pdep)):这部分是由页目录项地址得到关联的页表物理地址，再转成虚拟地址
    //PTX(la)：返回虚拟地址la的页表项索引
    //最后返回的是虚拟地址la对应的页表项入口地址
}
  10385f:	c9                   	leave  
  103860:	c3                   	ret    

00103861 <get_page>:

//get_page - get related Page struct for linear address la using PDT pgdir
struct Page *
get_page(pde_t *pgdir, uintptr_t la, pte_t **ptep_store) {
  103861:	f3 0f 1e fb          	endbr32 
  103865:	55                   	push   %ebp
  103866:	89 e5                	mov    %esp,%ebp
  103868:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 0);
  10386b:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  103872:	00 
  103873:	8b 45 0c             	mov    0xc(%ebp),%eax
  103876:	89 44 24 04          	mov    %eax,0x4(%esp)
  10387a:	8b 45 08             	mov    0x8(%ebp),%eax
  10387d:	89 04 24             	mov    %eax,(%esp)
  103880:	e8 9f fe ff ff       	call   103724 <get_pte>
  103885:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep_store != NULL) {
  103888:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  10388c:	74 08                	je     103896 <get_page+0x35>
        *ptep_store = ptep;
  10388e:	8b 45 10             	mov    0x10(%ebp),%eax
  103891:	8b 55 f4             	mov    -0xc(%ebp),%edx
  103894:	89 10                	mov    %edx,(%eax)
    }
    if (ptep != NULL && *ptep & PTE_P) {
  103896:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  10389a:	74 1b                	je     1038b7 <get_page+0x56>
  10389c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10389f:	8b 00                	mov    (%eax),%eax
  1038a1:	83 e0 01             	and    $0x1,%eax
  1038a4:	85 c0                	test   %eax,%eax
  1038a6:	74 0f                	je     1038b7 <get_page+0x56>
        return pte2page(*ptep);
  1038a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1038ab:	8b 00                	mov    (%eax),%eax
  1038ad:	89 04 24             	mov    %eax,(%esp)
  1038b0:	e8 5b f5 ff ff       	call   102e10 <pte2page>
  1038b5:	eb 05                	jmp    1038bc <get_page+0x5b>
    }
    return NULL;
  1038b7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  1038bc:	c9                   	leave  
  1038bd:	c3                   	ret    

001038be <page_remove_pte>:

//page_remove_pte - free an Page sturct which is related linear address la
//                - and clean(invalidate) pte which is related linear address la
//note: PT is changed, so the TLB need to be invalidate 
static inline void
page_remove_pte(pde_t *pgdir, uintptr_t la, pte_t *ptep) {
  1038be:	55                   	push   %ebp
  1038bf:	89 e5                	mov    %esp,%ebp
  1038c1:	83 ec 28             	sub    $0x28,%esp
                                  //(4) and free this page when page reference reachs 0
                                  //(5) clear second page table entry
                                  //(6) flush tlb
    }
#endif
    if (*ptep & PTE_P) {  //页表项存在
  1038c4:	8b 45 10             	mov    0x10(%ebp),%eax
  1038c7:	8b 00                	mov    (%eax),%eax
  1038c9:	83 e0 01             	and    $0x1,%eax
  1038cc:	85 c0                	test   %eax,%eax
  1038ce:	74 4d                	je     10391d <page_remove_pte+0x5f>
        struct Page *page = pte2page(*ptep); //找到页表项
  1038d0:	8b 45 10             	mov    0x10(%ebp),%eax
  1038d3:	8b 00                	mov    (%eax),%eax
  1038d5:	89 04 24             	mov    %eax,(%esp)
  1038d8:	e8 33 f5 ff ff       	call   102e10 <pte2page>
  1038dd:	89 45 f4             	mov    %eax,-0xc(%ebp)
        if (page_ref_dec(page) == 0) {  //只被当前进程引用
  1038e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1038e3:	89 04 24             	mov    %eax,(%esp)
  1038e6:	e8 aa f5 ff ff       	call   102e95 <page_ref_dec>
  1038eb:	85 c0                	test   %eax,%eax
  1038ed:	75 13                	jne    103902 <page_remove_pte+0x44>
            free_page(page); //释放页
  1038ef:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  1038f6:	00 
  1038f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1038fa:	89 04 24             	mov    %eax,(%esp)
  1038fd:	e8 b6 f7 ff ff       	call   1030b8 <free_pages>
        }
        *ptep = 0; //该页表项清零
  103902:	8b 45 10             	mov    0x10(%ebp),%eax
  103905:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
        tlb_invalidate(pgdir, la); 
  10390b:	8b 45 0c             	mov    0xc(%ebp),%eax
  10390e:	89 44 24 04          	mov    %eax,0x4(%esp)
  103912:	8b 45 08             	mov    0x8(%ebp),%eax
  103915:	89 04 24             	mov    %eax,(%esp)
  103918:	e8 09 01 00 00       	call   103a26 <tlb_invalidate>
        //修改的页表是进程正在使用的那些页表，使之无效
    }
}
  10391d:	90                   	nop
  10391e:	c9                   	leave  
  10391f:	c3                   	ret    

00103920 <page_remove>:

//page_remove - free an Page which is related linear address la and has an validated pte
void
page_remove(pde_t *pgdir, uintptr_t la) {
  103920:	f3 0f 1e fb          	endbr32 
  103924:	55                   	push   %ebp
  103925:	89 e5                	mov    %esp,%ebp
  103927:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 0);
  10392a:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  103931:	00 
  103932:	8b 45 0c             	mov    0xc(%ebp),%eax
  103935:	89 44 24 04          	mov    %eax,0x4(%esp)
  103939:	8b 45 08             	mov    0x8(%ebp),%eax
  10393c:	89 04 24             	mov    %eax,(%esp)
  10393f:	e8 e0 fd ff ff       	call   103724 <get_pte>
  103944:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep != NULL) {
  103947:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  10394b:	74 19                	je     103966 <page_remove+0x46>
        page_remove_pte(pgdir, la, ptep);
  10394d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103950:	89 44 24 08          	mov    %eax,0x8(%esp)
  103954:	8b 45 0c             	mov    0xc(%ebp),%eax
  103957:	89 44 24 04          	mov    %eax,0x4(%esp)
  10395b:	8b 45 08             	mov    0x8(%ebp),%eax
  10395e:	89 04 24             	mov    %eax,(%esp)
  103961:	e8 58 ff ff ff       	call   1038be <page_remove_pte>
    }
}
  103966:	90                   	nop
  103967:	c9                   	leave  
  103968:	c3                   	ret    

00103969 <page_insert>:
//  la:    the linear address need to map
//  perm:  the permission of this Page which is setted in related pte
// return value: always 0
//note: PT is changed, so the TLB need to be invalidate 
int
page_insert(pde_t *pgdir, struct Page *page, uintptr_t la, uint32_t perm) {
  103969:	f3 0f 1e fb          	endbr32 
  10396d:	55                   	push   %ebp
  10396e:	89 e5                	mov    %esp,%ebp
  103970:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 1);
  103973:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  10397a:	00 
  10397b:	8b 45 10             	mov    0x10(%ebp),%eax
  10397e:	89 44 24 04          	mov    %eax,0x4(%esp)
  103982:	8b 45 08             	mov    0x8(%ebp),%eax
  103985:	89 04 24             	mov    %eax,(%esp)
  103988:	e8 97 fd ff ff       	call   103724 <get_pte>
  10398d:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep == NULL) {
  103990:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  103994:	75 0a                	jne    1039a0 <page_insert+0x37>
        return -E_NO_MEM;
  103996:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
  10399b:	e9 84 00 00 00       	jmp    103a24 <page_insert+0xbb>
    }
    page_ref_inc(page);
  1039a0:	8b 45 0c             	mov    0xc(%ebp),%eax
  1039a3:	89 04 24             	mov    %eax,(%esp)
  1039a6:	e8 d3 f4 ff ff       	call   102e7e <page_ref_inc>
    if (*ptep & PTE_P) {
  1039ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1039ae:	8b 00                	mov    (%eax),%eax
  1039b0:	83 e0 01             	and    $0x1,%eax
  1039b3:	85 c0                	test   %eax,%eax
  1039b5:	74 3e                	je     1039f5 <page_insert+0x8c>
        struct Page *p = pte2page(*ptep);
  1039b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1039ba:	8b 00                	mov    (%eax),%eax
  1039bc:	89 04 24             	mov    %eax,(%esp)
  1039bf:	e8 4c f4 ff ff       	call   102e10 <pte2page>
  1039c4:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (p == page) {
  1039c7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1039ca:	3b 45 0c             	cmp    0xc(%ebp),%eax
  1039cd:	75 0d                	jne    1039dc <page_insert+0x73>
            page_ref_dec(page);
  1039cf:	8b 45 0c             	mov    0xc(%ebp),%eax
  1039d2:	89 04 24             	mov    %eax,(%esp)
  1039d5:	e8 bb f4 ff ff       	call   102e95 <page_ref_dec>
  1039da:	eb 19                	jmp    1039f5 <page_insert+0x8c>
        }
        else {
            page_remove_pte(pgdir, la, ptep);
  1039dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1039df:	89 44 24 08          	mov    %eax,0x8(%esp)
  1039e3:	8b 45 10             	mov    0x10(%ebp),%eax
  1039e6:	89 44 24 04          	mov    %eax,0x4(%esp)
  1039ea:	8b 45 08             	mov    0x8(%ebp),%eax
  1039ed:	89 04 24             	mov    %eax,(%esp)
  1039f0:	e8 c9 fe ff ff       	call   1038be <page_remove_pte>
        }
    }
    *ptep = page2pa(page) | PTE_P | perm;
  1039f5:	8b 45 0c             	mov    0xc(%ebp),%eax
  1039f8:	89 04 24             	mov    %eax,(%esp)
  1039fb:	e8 57 f3 ff ff       	call   102d57 <page2pa>
  103a00:	0b 45 14             	or     0x14(%ebp),%eax
  103a03:	83 c8 01             	or     $0x1,%eax
  103a06:	89 c2                	mov    %eax,%edx
  103a08:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103a0b:	89 10                	mov    %edx,(%eax)
    tlb_invalidate(pgdir, la);
  103a0d:	8b 45 10             	mov    0x10(%ebp),%eax
  103a10:	89 44 24 04          	mov    %eax,0x4(%esp)
  103a14:	8b 45 08             	mov    0x8(%ebp),%eax
  103a17:	89 04 24             	mov    %eax,(%esp)
  103a1a:	e8 07 00 00 00       	call   103a26 <tlb_invalidate>
    return 0;
  103a1f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  103a24:	c9                   	leave  
  103a25:	c3                   	ret    

00103a26 <tlb_invalidate>:

// invalidate a TLB entry, but only if the page tables being
// edited are the ones currently in use by the processor.
void
tlb_invalidate(pde_t *pgdir, uintptr_t la) {
  103a26:	f3 0f 1e fb          	endbr32 
  103a2a:	55                   	push   %ebp
  103a2b:	89 e5                	mov    %esp,%ebp
  103a2d:	83 ec 28             	sub    $0x28,%esp
}

static inline uintptr_t
rcr3(void) {
    uintptr_t cr3;
    asm volatile ("mov %%cr3, %0" : "=r" (cr3) :: "memory");
  103a30:	0f 20 d8             	mov    %cr3,%eax
  103a33:	89 45 f0             	mov    %eax,-0x10(%ebp)
    return cr3;
  103a36:	8b 55 f0             	mov    -0x10(%ebp),%edx
    if (rcr3() == PADDR(pgdir)) {
  103a39:	8b 45 08             	mov    0x8(%ebp),%eax
  103a3c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  103a3f:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
  103a46:	77 23                	ja     103a6b <tlb_invalidate+0x45>
  103a48:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103a4b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  103a4f:	c7 44 24 08 64 80 10 	movl   $0x108064,0x8(%esp)
  103a56:	00 
  103a57:	c7 44 24 04 f9 01 00 	movl   $0x1f9,0x4(%esp)
  103a5e:	00 
  103a5f:	c7 04 24 88 80 10 00 	movl   $0x108088,(%esp)
  103a66:	e8 c6 c9 ff ff       	call   100431 <__panic>
  103a6b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103a6e:	05 00 00 00 40       	add    $0x40000000,%eax
  103a73:	39 d0                	cmp    %edx,%eax
  103a75:	75 0d                	jne    103a84 <tlb_invalidate+0x5e>
        invlpg((void *)la);
  103a77:	8b 45 0c             	mov    0xc(%ebp),%eax
  103a7a:	89 45 ec             	mov    %eax,-0x14(%ebp)
}

static inline void
invlpg(void *addr) {
    asm volatile ("invlpg (%0)" :: "r" (addr) : "memory");
  103a7d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103a80:	0f 01 38             	invlpg (%eax)
}
  103a83:	90                   	nop
    }
}
  103a84:	90                   	nop
  103a85:	c9                   	leave  
  103a86:	c3                   	ret    

00103a87 <check_alloc_page>:

static void
check_alloc_page(void) {
  103a87:	f3 0f 1e fb          	endbr32 
  103a8b:	55                   	push   %ebp
  103a8c:	89 e5                	mov    %esp,%ebp
  103a8e:	83 ec 18             	sub    $0x18,%esp
    pmm_manager->check();
  103a91:	a1 70 0f 12 00       	mov    0x120f70,%eax
  103a96:	8b 40 18             	mov    0x18(%eax),%eax
  103a99:	ff d0                	call   *%eax
    cprintf("check_alloc_page() succeeded!\n");
  103a9b:	c7 04 24 e8 80 10 00 	movl   $0x1080e8,(%esp)
  103aa2:	e8 1e c8 ff ff       	call   1002c5 <cprintf>
}
  103aa7:	90                   	nop
  103aa8:	c9                   	leave  
  103aa9:	c3                   	ret    

00103aaa <check_pgdir>:

static void
check_pgdir(void) {
  103aaa:	f3 0f 1e fb          	endbr32 
  103aae:	55                   	push   %ebp
  103aaf:	89 e5                	mov    %esp,%ebp
  103ab1:	83 ec 38             	sub    $0x38,%esp
    assert(npage <= KMEMSIZE / PGSIZE);
  103ab4:	a1 80 0e 12 00       	mov    0x120e80,%eax
  103ab9:	3d 00 80 03 00       	cmp    $0x38000,%eax
  103abe:	76 24                	jbe    103ae4 <check_pgdir+0x3a>
  103ac0:	c7 44 24 0c 07 81 10 	movl   $0x108107,0xc(%esp)
  103ac7:	00 
  103ac8:	c7 44 24 08 ad 80 10 	movl   $0x1080ad,0x8(%esp)
  103acf:	00 
  103ad0:	c7 44 24 04 06 02 00 	movl   $0x206,0x4(%esp)
  103ad7:	00 
  103ad8:	c7 04 24 88 80 10 00 	movl   $0x108088,(%esp)
  103adf:	e8 4d c9 ff ff       	call   100431 <__panic>
    assert(boot_pgdir != NULL && (uint32_t)PGOFF(boot_pgdir) == 0);
  103ae4:	a1 e0 d9 11 00       	mov    0x11d9e0,%eax
  103ae9:	85 c0                	test   %eax,%eax
  103aeb:	74 0e                	je     103afb <check_pgdir+0x51>
  103aed:	a1 e0 d9 11 00       	mov    0x11d9e0,%eax
  103af2:	25 ff 0f 00 00       	and    $0xfff,%eax
  103af7:	85 c0                	test   %eax,%eax
  103af9:	74 24                	je     103b1f <check_pgdir+0x75>
  103afb:	c7 44 24 0c 24 81 10 	movl   $0x108124,0xc(%esp)
  103b02:	00 
  103b03:	c7 44 24 08 ad 80 10 	movl   $0x1080ad,0x8(%esp)
  103b0a:	00 
  103b0b:	c7 44 24 04 07 02 00 	movl   $0x207,0x4(%esp)
  103b12:	00 
  103b13:	c7 04 24 88 80 10 00 	movl   $0x108088,(%esp)
  103b1a:	e8 12 c9 ff ff       	call   100431 <__panic>
    assert(get_page(boot_pgdir, 0x0, NULL) == NULL);
  103b1f:	a1 e0 d9 11 00       	mov    0x11d9e0,%eax
  103b24:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  103b2b:	00 
  103b2c:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  103b33:	00 
  103b34:	89 04 24             	mov    %eax,(%esp)
  103b37:	e8 25 fd ff ff       	call   103861 <get_page>
  103b3c:	85 c0                	test   %eax,%eax
  103b3e:	74 24                	je     103b64 <check_pgdir+0xba>
  103b40:	c7 44 24 0c 5c 81 10 	movl   $0x10815c,0xc(%esp)
  103b47:	00 
  103b48:	c7 44 24 08 ad 80 10 	movl   $0x1080ad,0x8(%esp)
  103b4f:	00 
  103b50:	c7 44 24 04 08 02 00 	movl   $0x208,0x4(%esp)
  103b57:	00 
  103b58:	c7 04 24 88 80 10 00 	movl   $0x108088,(%esp)
  103b5f:	e8 cd c8 ff ff       	call   100431 <__panic>

    struct Page *p1, *p2;
    p1 = alloc_page();
  103b64:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  103b6b:	e8 0c f5 ff ff       	call   10307c <alloc_pages>
  103b70:	89 45 f4             	mov    %eax,-0xc(%ebp)
    assert(page_insert(boot_pgdir, p1, 0x0, 0) == 0);
  103b73:	a1 e0 d9 11 00       	mov    0x11d9e0,%eax
  103b78:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  103b7f:	00 
  103b80:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  103b87:	00 
  103b88:	8b 55 f4             	mov    -0xc(%ebp),%edx
  103b8b:	89 54 24 04          	mov    %edx,0x4(%esp)
  103b8f:	89 04 24             	mov    %eax,(%esp)
  103b92:	e8 d2 fd ff ff       	call   103969 <page_insert>
  103b97:	85 c0                	test   %eax,%eax
  103b99:	74 24                	je     103bbf <check_pgdir+0x115>
  103b9b:	c7 44 24 0c 84 81 10 	movl   $0x108184,0xc(%esp)
  103ba2:	00 
  103ba3:	c7 44 24 08 ad 80 10 	movl   $0x1080ad,0x8(%esp)
  103baa:	00 
  103bab:	c7 44 24 04 0c 02 00 	movl   $0x20c,0x4(%esp)
  103bb2:	00 
  103bb3:	c7 04 24 88 80 10 00 	movl   $0x108088,(%esp)
  103bba:	e8 72 c8 ff ff       	call   100431 <__panic>

    pte_t *ptep;
    assert((ptep = get_pte(boot_pgdir, 0x0, 0)) != NULL);
  103bbf:	a1 e0 d9 11 00       	mov    0x11d9e0,%eax
  103bc4:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  103bcb:	00 
  103bcc:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  103bd3:	00 
  103bd4:	89 04 24             	mov    %eax,(%esp)
  103bd7:	e8 48 fb ff ff       	call   103724 <get_pte>
  103bdc:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103bdf:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  103be3:	75 24                	jne    103c09 <check_pgdir+0x15f>
  103be5:	c7 44 24 0c b0 81 10 	movl   $0x1081b0,0xc(%esp)
  103bec:	00 
  103bed:	c7 44 24 08 ad 80 10 	movl   $0x1080ad,0x8(%esp)
  103bf4:	00 
  103bf5:	c7 44 24 04 0f 02 00 	movl   $0x20f,0x4(%esp)
  103bfc:	00 
  103bfd:	c7 04 24 88 80 10 00 	movl   $0x108088,(%esp)
  103c04:	e8 28 c8 ff ff       	call   100431 <__panic>
    assert(pte2page(*ptep) == p1);
  103c09:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103c0c:	8b 00                	mov    (%eax),%eax
  103c0e:	89 04 24             	mov    %eax,(%esp)
  103c11:	e8 fa f1 ff ff       	call   102e10 <pte2page>
  103c16:	39 45 f4             	cmp    %eax,-0xc(%ebp)
  103c19:	74 24                	je     103c3f <check_pgdir+0x195>
  103c1b:	c7 44 24 0c dd 81 10 	movl   $0x1081dd,0xc(%esp)
  103c22:	00 
  103c23:	c7 44 24 08 ad 80 10 	movl   $0x1080ad,0x8(%esp)
  103c2a:	00 
  103c2b:	c7 44 24 04 10 02 00 	movl   $0x210,0x4(%esp)
  103c32:	00 
  103c33:	c7 04 24 88 80 10 00 	movl   $0x108088,(%esp)
  103c3a:	e8 f2 c7 ff ff       	call   100431 <__panic>
    assert(page_ref(p1) == 1);
  103c3f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103c42:	89 04 24             	mov    %eax,(%esp)
  103c45:	e8 1c f2 ff ff       	call   102e66 <page_ref>
  103c4a:	83 f8 01             	cmp    $0x1,%eax
  103c4d:	74 24                	je     103c73 <check_pgdir+0x1c9>
  103c4f:	c7 44 24 0c f3 81 10 	movl   $0x1081f3,0xc(%esp)
  103c56:	00 
  103c57:	c7 44 24 08 ad 80 10 	movl   $0x1080ad,0x8(%esp)
  103c5e:	00 
  103c5f:	c7 44 24 04 11 02 00 	movl   $0x211,0x4(%esp)
  103c66:	00 
  103c67:	c7 04 24 88 80 10 00 	movl   $0x108088,(%esp)
  103c6e:	e8 be c7 ff ff       	call   100431 <__panic>

    ptep = &((pte_t *)KADDR(PDE_ADDR(boot_pgdir[0])))[1];
  103c73:	a1 e0 d9 11 00       	mov    0x11d9e0,%eax
  103c78:	8b 00                	mov    (%eax),%eax
  103c7a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  103c7f:	89 45 ec             	mov    %eax,-0x14(%ebp)
  103c82:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103c85:	c1 e8 0c             	shr    $0xc,%eax
  103c88:	89 45 e8             	mov    %eax,-0x18(%ebp)
  103c8b:	a1 80 0e 12 00       	mov    0x120e80,%eax
  103c90:	39 45 e8             	cmp    %eax,-0x18(%ebp)
  103c93:	72 23                	jb     103cb8 <check_pgdir+0x20e>
  103c95:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103c98:	89 44 24 0c          	mov    %eax,0xc(%esp)
  103c9c:	c7 44 24 08 c0 7f 10 	movl   $0x107fc0,0x8(%esp)
  103ca3:	00 
  103ca4:	c7 44 24 04 13 02 00 	movl   $0x213,0x4(%esp)
  103cab:	00 
  103cac:	c7 04 24 88 80 10 00 	movl   $0x108088,(%esp)
  103cb3:	e8 79 c7 ff ff       	call   100431 <__panic>
  103cb8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103cbb:	2d 00 00 00 40       	sub    $0x40000000,%eax
  103cc0:	83 c0 04             	add    $0x4,%eax
  103cc3:	89 45 f0             	mov    %eax,-0x10(%ebp)
    assert(get_pte(boot_pgdir, PGSIZE, 0) == ptep);
  103cc6:	a1 e0 d9 11 00       	mov    0x11d9e0,%eax
  103ccb:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  103cd2:	00 
  103cd3:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
  103cda:	00 
  103cdb:	89 04 24             	mov    %eax,(%esp)
  103cde:	e8 41 fa ff ff       	call   103724 <get_pte>
  103ce3:	39 45 f0             	cmp    %eax,-0x10(%ebp)
  103ce6:	74 24                	je     103d0c <check_pgdir+0x262>
  103ce8:	c7 44 24 0c 08 82 10 	movl   $0x108208,0xc(%esp)
  103cef:	00 
  103cf0:	c7 44 24 08 ad 80 10 	movl   $0x1080ad,0x8(%esp)
  103cf7:	00 
  103cf8:	c7 44 24 04 14 02 00 	movl   $0x214,0x4(%esp)
  103cff:	00 
  103d00:	c7 04 24 88 80 10 00 	movl   $0x108088,(%esp)
  103d07:	e8 25 c7 ff ff       	call   100431 <__panic>

    p2 = alloc_page();
  103d0c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  103d13:	e8 64 f3 ff ff       	call   10307c <alloc_pages>
  103d18:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    assert(page_insert(boot_pgdir, p2, PGSIZE, PTE_U | PTE_W) == 0);
  103d1b:	a1 e0 d9 11 00       	mov    0x11d9e0,%eax
  103d20:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
  103d27:	00 
  103d28:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  103d2f:	00 
  103d30:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  103d33:	89 54 24 04          	mov    %edx,0x4(%esp)
  103d37:	89 04 24             	mov    %eax,(%esp)
  103d3a:	e8 2a fc ff ff       	call   103969 <page_insert>
  103d3f:	85 c0                	test   %eax,%eax
  103d41:	74 24                	je     103d67 <check_pgdir+0x2bd>
  103d43:	c7 44 24 0c 30 82 10 	movl   $0x108230,0xc(%esp)
  103d4a:	00 
  103d4b:	c7 44 24 08 ad 80 10 	movl   $0x1080ad,0x8(%esp)
  103d52:	00 
  103d53:	c7 44 24 04 17 02 00 	movl   $0x217,0x4(%esp)
  103d5a:	00 
  103d5b:	c7 04 24 88 80 10 00 	movl   $0x108088,(%esp)
  103d62:	e8 ca c6 ff ff       	call   100431 <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
  103d67:	a1 e0 d9 11 00       	mov    0x11d9e0,%eax
  103d6c:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  103d73:	00 
  103d74:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
  103d7b:	00 
  103d7c:	89 04 24             	mov    %eax,(%esp)
  103d7f:	e8 a0 f9 ff ff       	call   103724 <get_pte>
  103d84:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103d87:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  103d8b:	75 24                	jne    103db1 <check_pgdir+0x307>
  103d8d:	c7 44 24 0c 68 82 10 	movl   $0x108268,0xc(%esp)
  103d94:	00 
  103d95:	c7 44 24 08 ad 80 10 	movl   $0x1080ad,0x8(%esp)
  103d9c:	00 
  103d9d:	c7 44 24 04 18 02 00 	movl   $0x218,0x4(%esp)
  103da4:	00 
  103da5:	c7 04 24 88 80 10 00 	movl   $0x108088,(%esp)
  103dac:	e8 80 c6 ff ff       	call   100431 <__panic>
    assert(*ptep & PTE_U);
  103db1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103db4:	8b 00                	mov    (%eax),%eax
  103db6:	83 e0 04             	and    $0x4,%eax
  103db9:	85 c0                	test   %eax,%eax
  103dbb:	75 24                	jne    103de1 <check_pgdir+0x337>
  103dbd:	c7 44 24 0c 98 82 10 	movl   $0x108298,0xc(%esp)
  103dc4:	00 
  103dc5:	c7 44 24 08 ad 80 10 	movl   $0x1080ad,0x8(%esp)
  103dcc:	00 
  103dcd:	c7 44 24 04 19 02 00 	movl   $0x219,0x4(%esp)
  103dd4:	00 
  103dd5:	c7 04 24 88 80 10 00 	movl   $0x108088,(%esp)
  103ddc:	e8 50 c6 ff ff       	call   100431 <__panic>
    assert(*ptep & PTE_W);
  103de1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103de4:	8b 00                	mov    (%eax),%eax
  103de6:	83 e0 02             	and    $0x2,%eax
  103de9:	85 c0                	test   %eax,%eax
  103deb:	75 24                	jne    103e11 <check_pgdir+0x367>
  103ded:	c7 44 24 0c a6 82 10 	movl   $0x1082a6,0xc(%esp)
  103df4:	00 
  103df5:	c7 44 24 08 ad 80 10 	movl   $0x1080ad,0x8(%esp)
  103dfc:	00 
  103dfd:	c7 44 24 04 1a 02 00 	movl   $0x21a,0x4(%esp)
  103e04:	00 
  103e05:	c7 04 24 88 80 10 00 	movl   $0x108088,(%esp)
  103e0c:	e8 20 c6 ff ff       	call   100431 <__panic>
    assert(boot_pgdir[0] & PTE_U);
  103e11:	a1 e0 d9 11 00       	mov    0x11d9e0,%eax
  103e16:	8b 00                	mov    (%eax),%eax
  103e18:	83 e0 04             	and    $0x4,%eax
  103e1b:	85 c0                	test   %eax,%eax
  103e1d:	75 24                	jne    103e43 <check_pgdir+0x399>
  103e1f:	c7 44 24 0c b4 82 10 	movl   $0x1082b4,0xc(%esp)
  103e26:	00 
  103e27:	c7 44 24 08 ad 80 10 	movl   $0x1080ad,0x8(%esp)
  103e2e:	00 
  103e2f:	c7 44 24 04 1b 02 00 	movl   $0x21b,0x4(%esp)
  103e36:	00 
  103e37:	c7 04 24 88 80 10 00 	movl   $0x108088,(%esp)
  103e3e:	e8 ee c5 ff ff       	call   100431 <__panic>
    assert(page_ref(p2) == 1);
  103e43:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103e46:	89 04 24             	mov    %eax,(%esp)
  103e49:	e8 18 f0 ff ff       	call   102e66 <page_ref>
  103e4e:	83 f8 01             	cmp    $0x1,%eax
  103e51:	74 24                	je     103e77 <check_pgdir+0x3cd>
  103e53:	c7 44 24 0c ca 82 10 	movl   $0x1082ca,0xc(%esp)
  103e5a:	00 
  103e5b:	c7 44 24 08 ad 80 10 	movl   $0x1080ad,0x8(%esp)
  103e62:	00 
  103e63:	c7 44 24 04 1c 02 00 	movl   $0x21c,0x4(%esp)
  103e6a:	00 
  103e6b:	c7 04 24 88 80 10 00 	movl   $0x108088,(%esp)
  103e72:	e8 ba c5 ff ff       	call   100431 <__panic>

    assert(page_insert(boot_pgdir, p1, PGSIZE, 0) == 0);
  103e77:	a1 e0 d9 11 00       	mov    0x11d9e0,%eax
  103e7c:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  103e83:	00 
  103e84:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  103e8b:	00 
  103e8c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  103e8f:	89 54 24 04          	mov    %edx,0x4(%esp)
  103e93:	89 04 24             	mov    %eax,(%esp)
  103e96:	e8 ce fa ff ff       	call   103969 <page_insert>
  103e9b:	85 c0                	test   %eax,%eax
  103e9d:	74 24                	je     103ec3 <check_pgdir+0x419>
  103e9f:	c7 44 24 0c dc 82 10 	movl   $0x1082dc,0xc(%esp)
  103ea6:	00 
  103ea7:	c7 44 24 08 ad 80 10 	movl   $0x1080ad,0x8(%esp)
  103eae:	00 
  103eaf:	c7 44 24 04 1e 02 00 	movl   $0x21e,0x4(%esp)
  103eb6:	00 
  103eb7:	c7 04 24 88 80 10 00 	movl   $0x108088,(%esp)
  103ebe:	e8 6e c5 ff ff       	call   100431 <__panic>
    assert(page_ref(p1) == 2);
  103ec3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103ec6:	89 04 24             	mov    %eax,(%esp)
  103ec9:	e8 98 ef ff ff       	call   102e66 <page_ref>
  103ece:	83 f8 02             	cmp    $0x2,%eax
  103ed1:	74 24                	je     103ef7 <check_pgdir+0x44d>
  103ed3:	c7 44 24 0c 08 83 10 	movl   $0x108308,0xc(%esp)
  103eda:	00 
  103edb:	c7 44 24 08 ad 80 10 	movl   $0x1080ad,0x8(%esp)
  103ee2:	00 
  103ee3:	c7 44 24 04 1f 02 00 	movl   $0x21f,0x4(%esp)
  103eea:	00 
  103eeb:	c7 04 24 88 80 10 00 	movl   $0x108088,(%esp)
  103ef2:	e8 3a c5 ff ff       	call   100431 <__panic>
    assert(page_ref(p2) == 0);
  103ef7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103efa:	89 04 24             	mov    %eax,(%esp)
  103efd:	e8 64 ef ff ff       	call   102e66 <page_ref>
  103f02:	85 c0                	test   %eax,%eax
  103f04:	74 24                	je     103f2a <check_pgdir+0x480>
  103f06:	c7 44 24 0c 1a 83 10 	movl   $0x10831a,0xc(%esp)
  103f0d:	00 
  103f0e:	c7 44 24 08 ad 80 10 	movl   $0x1080ad,0x8(%esp)
  103f15:	00 
  103f16:	c7 44 24 04 20 02 00 	movl   $0x220,0x4(%esp)
  103f1d:	00 
  103f1e:	c7 04 24 88 80 10 00 	movl   $0x108088,(%esp)
  103f25:	e8 07 c5 ff ff       	call   100431 <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
  103f2a:	a1 e0 d9 11 00       	mov    0x11d9e0,%eax
  103f2f:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  103f36:	00 
  103f37:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
  103f3e:	00 
  103f3f:	89 04 24             	mov    %eax,(%esp)
  103f42:	e8 dd f7 ff ff       	call   103724 <get_pte>
  103f47:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103f4a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  103f4e:	75 24                	jne    103f74 <check_pgdir+0x4ca>
  103f50:	c7 44 24 0c 68 82 10 	movl   $0x108268,0xc(%esp)
  103f57:	00 
  103f58:	c7 44 24 08 ad 80 10 	movl   $0x1080ad,0x8(%esp)
  103f5f:	00 
  103f60:	c7 44 24 04 21 02 00 	movl   $0x221,0x4(%esp)
  103f67:	00 
  103f68:	c7 04 24 88 80 10 00 	movl   $0x108088,(%esp)
  103f6f:	e8 bd c4 ff ff       	call   100431 <__panic>
    assert(pte2page(*ptep) == p1);
  103f74:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103f77:	8b 00                	mov    (%eax),%eax
  103f79:	89 04 24             	mov    %eax,(%esp)
  103f7c:	e8 8f ee ff ff       	call   102e10 <pte2page>
  103f81:	39 45 f4             	cmp    %eax,-0xc(%ebp)
  103f84:	74 24                	je     103faa <check_pgdir+0x500>
  103f86:	c7 44 24 0c dd 81 10 	movl   $0x1081dd,0xc(%esp)
  103f8d:	00 
  103f8e:	c7 44 24 08 ad 80 10 	movl   $0x1080ad,0x8(%esp)
  103f95:	00 
  103f96:	c7 44 24 04 22 02 00 	movl   $0x222,0x4(%esp)
  103f9d:	00 
  103f9e:	c7 04 24 88 80 10 00 	movl   $0x108088,(%esp)
  103fa5:	e8 87 c4 ff ff       	call   100431 <__panic>
    assert((*ptep & PTE_U) == 0);
  103faa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103fad:	8b 00                	mov    (%eax),%eax
  103faf:	83 e0 04             	and    $0x4,%eax
  103fb2:	85 c0                	test   %eax,%eax
  103fb4:	74 24                	je     103fda <check_pgdir+0x530>
  103fb6:	c7 44 24 0c 2c 83 10 	movl   $0x10832c,0xc(%esp)
  103fbd:	00 
  103fbe:	c7 44 24 08 ad 80 10 	movl   $0x1080ad,0x8(%esp)
  103fc5:	00 
  103fc6:	c7 44 24 04 23 02 00 	movl   $0x223,0x4(%esp)
  103fcd:	00 
  103fce:	c7 04 24 88 80 10 00 	movl   $0x108088,(%esp)
  103fd5:	e8 57 c4 ff ff       	call   100431 <__panic>

    page_remove(boot_pgdir, 0x0);
  103fda:	a1 e0 d9 11 00       	mov    0x11d9e0,%eax
  103fdf:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  103fe6:	00 
  103fe7:	89 04 24             	mov    %eax,(%esp)
  103fea:	e8 31 f9 ff ff       	call   103920 <page_remove>
    assert(page_ref(p1) == 1);
  103fef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103ff2:	89 04 24             	mov    %eax,(%esp)
  103ff5:	e8 6c ee ff ff       	call   102e66 <page_ref>
  103ffa:	83 f8 01             	cmp    $0x1,%eax
  103ffd:	74 24                	je     104023 <check_pgdir+0x579>
  103fff:	c7 44 24 0c f3 81 10 	movl   $0x1081f3,0xc(%esp)
  104006:	00 
  104007:	c7 44 24 08 ad 80 10 	movl   $0x1080ad,0x8(%esp)
  10400e:	00 
  10400f:	c7 44 24 04 26 02 00 	movl   $0x226,0x4(%esp)
  104016:	00 
  104017:	c7 04 24 88 80 10 00 	movl   $0x108088,(%esp)
  10401e:	e8 0e c4 ff ff       	call   100431 <__panic>
    assert(page_ref(p2) == 0);
  104023:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104026:	89 04 24             	mov    %eax,(%esp)
  104029:	e8 38 ee ff ff       	call   102e66 <page_ref>
  10402e:	85 c0                	test   %eax,%eax
  104030:	74 24                	je     104056 <check_pgdir+0x5ac>
  104032:	c7 44 24 0c 1a 83 10 	movl   $0x10831a,0xc(%esp)
  104039:	00 
  10403a:	c7 44 24 08 ad 80 10 	movl   $0x1080ad,0x8(%esp)
  104041:	00 
  104042:	c7 44 24 04 27 02 00 	movl   $0x227,0x4(%esp)
  104049:	00 
  10404a:	c7 04 24 88 80 10 00 	movl   $0x108088,(%esp)
  104051:	e8 db c3 ff ff       	call   100431 <__panic>

    page_remove(boot_pgdir, PGSIZE);
  104056:	a1 e0 d9 11 00       	mov    0x11d9e0,%eax
  10405b:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
  104062:	00 
  104063:	89 04 24             	mov    %eax,(%esp)
  104066:	e8 b5 f8 ff ff       	call   103920 <page_remove>
    assert(page_ref(p1) == 0);
  10406b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10406e:	89 04 24             	mov    %eax,(%esp)
  104071:	e8 f0 ed ff ff       	call   102e66 <page_ref>
  104076:	85 c0                	test   %eax,%eax
  104078:	74 24                	je     10409e <check_pgdir+0x5f4>
  10407a:	c7 44 24 0c 41 83 10 	movl   $0x108341,0xc(%esp)
  104081:	00 
  104082:	c7 44 24 08 ad 80 10 	movl   $0x1080ad,0x8(%esp)
  104089:	00 
  10408a:	c7 44 24 04 2a 02 00 	movl   $0x22a,0x4(%esp)
  104091:	00 
  104092:	c7 04 24 88 80 10 00 	movl   $0x108088,(%esp)
  104099:	e8 93 c3 ff ff       	call   100431 <__panic>
    assert(page_ref(p2) == 0);
  10409e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1040a1:	89 04 24             	mov    %eax,(%esp)
  1040a4:	e8 bd ed ff ff       	call   102e66 <page_ref>
  1040a9:	85 c0                	test   %eax,%eax
  1040ab:	74 24                	je     1040d1 <check_pgdir+0x627>
  1040ad:	c7 44 24 0c 1a 83 10 	movl   $0x10831a,0xc(%esp)
  1040b4:	00 
  1040b5:	c7 44 24 08 ad 80 10 	movl   $0x1080ad,0x8(%esp)
  1040bc:	00 
  1040bd:	c7 44 24 04 2b 02 00 	movl   $0x22b,0x4(%esp)
  1040c4:	00 
  1040c5:	c7 04 24 88 80 10 00 	movl   $0x108088,(%esp)
  1040cc:	e8 60 c3 ff ff       	call   100431 <__panic>

    assert(page_ref(pde2page(boot_pgdir[0])) == 1);
  1040d1:	a1 e0 d9 11 00       	mov    0x11d9e0,%eax
  1040d6:	8b 00                	mov    (%eax),%eax
  1040d8:	89 04 24             	mov    %eax,(%esp)
  1040db:	e8 6e ed ff ff       	call   102e4e <pde2page>
  1040e0:	89 04 24             	mov    %eax,(%esp)
  1040e3:	e8 7e ed ff ff       	call   102e66 <page_ref>
  1040e8:	83 f8 01             	cmp    $0x1,%eax
  1040eb:	74 24                	je     104111 <check_pgdir+0x667>
  1040ed:	c7 44 24 0c 54 83 10 	movl   $0x108354,0xc(%esp)
  1040f4:	00 
  1040f5:	c7 44 24 08 ad 80 10 	movl   $0x1080ad,0x8(%esp)
  1040fc:	00 
  1040fd:	c7 44 24 04 2d 02 00 	movl   $0x22d,0x4(%esp)
  104104:	00 
  104105:	c7 04 24 88 80 10 00 	movl   $0x108088,(%esp)
  10410c:	e8 20 c3 ff ff       	call   100431 <__panic>
    free_page(pde2page(boot_pgdir[0]));
  104111:	a1 e0 d9 11 00       	mov    0x11d9e0,%eax
  104116:	8b 00                	mov    (%eax),%eax
  104118:	89 04 24             	mov    %eax,(%esp)
  10411b:	e8 2e ed ff ff       	call   102e4e <pde2page>
  104120:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  104127:	00 
  104128:	89 04 24             	mov    %eax,(%esp)
  10412b:	e8 88 ef ff ff       	call   1030b8 <free_pages>
    boot_pgdir[0] = 0;
  104130:	a1 e0 d9 11 00       	mov    0x11d9e0,%eax
  104135:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    cprintf("check_pgdir() succeeded!\n");
  10413b:	c7 04 24 7b 83 10 00 	movl   $0x10837b,(%esp)
  104142:	e8 7e c1 ff ff       	call   1002c5 <cprintf>
}
  104147:	90                   	nop
  104148:	c9                   	leave  
  104149:	c3                   	ret    

0010414a <check_boot_pgdir>:

static void
check_boot_pgdir(void) {
  10414a:	f3 0f 1e fb          	endbr32 
  10414e:	55                   	push   %ebp
  10414f:	89 e5                	mov    %esp,%ebp
  104151:	83 ec 38             	sub    $0x38,%esp
    pte_t *ptep;
    int i;
    for (i = 0; i < npage; i += PGSIZE) {
  104154:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  10415b:	e9 ca 00 00 00       	jmp    10422a <check_boot_pgdir+0xe0>
        assert((ptep = get_pte(boot_pgdir, (uintptr_t)KADDR(i), 0)) != NULL);
  104160:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104163:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  104166:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104169:	c1 e8 0c             	shr    $0xc,%eax
  10416c:	89 45 e0             	mov    %eax,-0x20(%ebp)
  10416f:	a1 80 0e 12 00       	mov    0x120e80,%eax
  104174:	39 45 e0             	cmp    %eax,-0x20(%ebp)
  104177:	72 23                	jb     10419c <check_boot_pgdir+0x52>
  104179:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10417c:	89 44 24 0c          	mov    %eax,0xc(%esp)
  104180:	c7 44 24 08 c0 7f 10 	movl   $0x107fc0,0x8(%esp)
  104187:	00 
  104188:	c7 44 24 04 39 02 00 	movl   $0x239,0x4(%esp)
  10418f:	00 
  104190:	c7 04 24 88 80 10 00 	movl   $0x108088,(%esp)
  104197:	e8 95 c2 ff ff       	call   100431 <__panic>
  10419c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10419f:	2d 00 00 00 40       	sub    $0x40000000,%eax
  1041a4:	89 c2                	mov    %eax,%edx
  1041a6:	a1 e0 d9 11 00       	mov    0x11d9e0,%eax
  1041ab:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  1041b2:	00 
  1041b3:	89 54 24 04          	mov    %edx,0x4(%esp)
  1041b7:	89 04 24             	mov    %eax,(%esp)
  1041ba:	e8 65 f5 ff ff       	call   103724 <get_pte>
  1041bf:	89 45 dc             	mov    %eax,-0x24(%ebp)
  1041c2:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  1041c6:	75 24                	jne    1041ec <check_boot_pgdir+0xa2>
  1041c8:	c7 44 24 0c 98 83 10 	movl   $0x108398,0xc(%esp)
  1041cf:	00 
  1041d0:	c7 44 24 08 ad 80 10 	movl   $0x1080ad,0x8(%esp)
  1041d7:	00 
  1041d8:	c7 44 24 04 39 02 00 	movl   $0x239,0x4(%esp)
  1041df:	00 
  1041e0:	c7 04 24 88 80 10 00 	movl   $0x108088,(%esp)
  1041e7:	e8 45 c2 ff ff       	call   100431 <__panic>
        assert(PTE_ADDR(*ptep) == i);
  1041ec:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1041ef:	8b 00                	mov    (%eax),%eax
  1041f1:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  1041f6:	89 c2                	mov    %eax,%edx
  1041f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1041fb:	39 c2                	cmp    %eax,%edx
  1041fd:	74 24                	je     104223 <check_boot_pgdir+0xd9>
  1041ff:	c7 44 24 0c d5 83 10 	movl   $0x1083d5,0xc(%esp)
  104206:	00 
  104207:	c7 44 24 08 ad 80 10 	movl   $0x1080ad,0x8(%esp)
  10420e:	00 
  10420f:	c7 44 24 04 3a 02 00 	movl   $0x23a,0x4(%esp)
  104216:	00 
  104217:	c7 04 24 88 80 10 00 	movl   $0x108088,(%esp)
  10421e:	e8 0e c2 ff ff       	call   100431 <__panic>
    for (i = 0; i < npage; i += PGSIZE) {
  104223:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
  10422a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  10422d:	a1 80 0e 12 00       	mov    0x120e80,%eax
  104232:	39 c2                	cmp    %eax,%edx
  104234:	0f 82 26 ff ff ff    	jb     104160 <check_boot_pgdir+0x16>
    }

    assert(PDE_ADDR(boot_pgdir[PDX(VPT)]) == PADDR(boot_pgdir));
  10423a:	a1 e0 d9 11 00       	mov    0x11d9e0,%eax
  10423f:	05 ac 0f 00 00       	add    $0xfac,%eax
  104244:	8b 00                	mov    (%eax),%eax
  104246:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  10424b:	89 c2                	mov    %eax,%edx
  10424d:	a1 e0 d9 11 00       	mov    0x11d9e0,%eax
  104252:	89 45 f0             	mov    %eax,-0x10(%ebp)
  104255:	81 7d f0 ff ff ff bf 	cmpl   $0xbfffffff,-0x10(%ebp)
  10425c:	77 23                	ja     104281 <check_boot_pgdir+0x137>
  10425e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104261:	89 44 24 0c          	mov    %eax,0xc(%esp)
  104265:	c7 44 24 08 64 80 10 	movl   $0x108064,0x8(%esp)
  10426c:	00 
  10426d:	c7 44 24 04 3d 02 00 	movl   $0x23d,0x4(%esp)
  104274:	00 
  104275:	c7 04 24 88 80 10 00 	movl   $0x108088,(%esp)
  10427c:	e8 b0 c1 ff ff       	call   100431 <__panic>
  104281:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104284:	05 00 00 00 40       	add    $0x40000000,%eax
  104289:	39 d0                	cmp    %edx,%eax
  10428b:	74 24                	je     1042b1 <check_boot_pgdir+0x167>
  10428d:	c7 44 24 0c ec 83 10 	movl   $0x1083ec,0xc(%esp)
  104294:	00 
  104295:	c7 44 24 08 ad 80 10 	movl   $0x1080ad,0x8(%esp)
  10429c:	00 
  10429d:	c7 44 24 04 3d 02 00 	movl   $0x23d,0x4(%esp)
  1042a4:	00 
  1042a5:	c7 04 24 88 80 10 00 	movl   $0x108088,(%esp)
  1042ac:	e8 80 c1 ff ff       	call   100431 <__panic>

    assert(boot_pgdir[0] == 0);
  1042b1:	a1 e0 d9 11 00       	mov    0x11d9e0,%eax
  1042b6:	8b 00                	mov    (%eax),%eax
  1042b8:	85 c0                	test   %eax,%eax
  1042ba:	74 24                	je     1042e0 <check_boot_pgdir+0x196>
  1042bc:	c7 44 24 0c 20 84 10 	movl   $0x108420,0xc(%esp)
  1042c3:	00 
  1042c4:	c7 44 24 08 ad 80 10 	movl   $0x1080ad,0x8(%esp)
  1042cb:	00 
  1042cc:	c7 44 24 04 3f 02 00 	movl   $0x23f,0x4(%esp)
  1042d3:	00 
  1042d4:	c7 04 24 88 80 10 00 	movl   $0x108088,(%esp)
  1042db:	e8 51 c1 ff ff       	call   100431 <__panic>

    struct Page *p;
    p = alloc_page();
  1042e0:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1042e7:	e8 90 ed ff ff       	call   10307c <alloc_pages>
  1042ec:	89 45 ec             	mov    %eax,-0x14(%ebp)
    assert(page_insert(boot_pgdir, p, 0x100, PTE_W) == 0);
  1042ef:	a1 e0 d9 11 00       	mov    0x11d9e0,%eax
  1042f4:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
  1042fb:	00 
  1042fc:	c7 44 24 08 00 01 00 	movl   $0x100,0x8(%esp)
  104303:	00 
  104304:	8b 55 ec             	mov    -0x14(%ebp),%edx
  104307:	89 54 24 04          	mov    %edx,0x4(%esp)
  10430b:	89 04 24             	mov    %eax,(%esp)
  10430e:	e8 56 f6 ff ff       	call   103969 <page_insert>
  104313:	85 c0                	test   %eax,%eax
  104315:	74 24                	je     10433b <check_boot_pgdir+0x1f1>
  104317:	c7 44 24 0c 34 84 10 	movl   $0x108434,0xc(%esp)
  10431e:	00 
  10431f:	c7 44 24 08 ad 80 10 	movl   $0x1080ad,0x8(%esp)
  104326:	00 
  104327:	c7 44 24 04 43 02 00 	movl   $0x243,0x4(%esp)
  10432e:	00 
  10432f:	c7 04 24 88 80 10 00 	movl   $0x108088,(%esp)
  104336:	e8 f6 c0 ff ff       	call   100431 <__panic>
    assert(page_ref(p) == 1);
  10433b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10433e:	89 04 24             	mov    %eax,(%esp)
  104341:	e8 20 eb ff ff       	call   102e66 <page_ref>
  104346:	83 f8 01             	cmp    $0x1,%eax
  104349:	74 24                	je     10436f <check_boot_pgdir+0x225>
  10434b:	c7 44 24 0c 62 84 10 	movl   $0x108462,0xc(%esp)
  104352:	00 
  104353:	c7 44 24 08 ad 80 10 	movl   $0x1080ad,0x8(%esp)
  10435a:	00 
  10435b:	c7 44 24 04 44 02 00 	movl   $0x244,0x4(%esp)
  104362:	00 
  104363:	c7 04 24 88 80 10 00 	movl   $0x108088,(%esp)
  10436a:	e8 c2 c0 ff ff       	call   100431 <__panic>
    assert(page_insert(boot_pgdir, p, 0x100 + PGSIZE, PTE_W) == 0);
  10436f:	a1 e0 d9 11 00       	mov    0x11d9e0,%eax
  104374:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
  10437b:	00 
  10437c:	c7 44 24 08 00 11 00 	movl   $0x1100,0x8(%esp)
  104383:	00 
  104384:	8b 55 ec             	mov    -0x14(%ebp),%edx
  104387:	89 54 24 04          	mov    %edx,0x4(%esp)
  10438b:	89 04 24             	mov    %eax,(%esp)
  10438e:	e8 d6 f5 ff ff       	call   103969 <page_insert>
  104393:	85 c0                	test   %eax,%eax
  104395:	74 24                	je     1043bb <check_boot_pgdir+0x271>
  104397:	c7 44 24 0c 74 84 10 	movl   $0x108474,0xc(%esp)
  10439e:	00 
  10439f:	c7 44 24 08 ad 80 10 	movl   $0x1080ad,0x8(%esp)
  1043a6:	00 
  1043a7:	c7 44 24 04 45 02 00 	movl   $0x245,0x4(%esp)
  1043ae:	00 
  1043af:	c7 04 24 88 80 10 00 	movl   $0x108088,(%esp)
  1043b6:	e8 76 c0 ff ff       	call   100431 <__panic>
    assert(page_ref(p) == 2);
  1043bb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1043be:	89 04 24             	mov    %eax,(%esp)
  1043c1:	e8 a0 ea ff ff       	call   102e66 <page_ref>
  1043c6:	83 f8 02             	cmp    $0x2,%eax
  1043c9:	74 24                	je     1043ef <check_boot_pgdir+0x2a5>
  1043cb:	c7 44 24 0c ab 84 10 	movl   $0x1084ab,0xc(%esp)
  1043d2:	00 
  1043d3:	c7 44 24 08 ad 80 10 	movl   $0x1080ad,0x8(%esp)
  1043da:	00 
  1043db:	c7 44 24 04 46 02 00 	movl   $0x246,0x4(%esp)
  1043e2:	00 
  1043e3:	c7 04 24 88 80 10 00 	movl   $0x108088,(%esp)
  1043ea:	e8 42 c0 ff ff       	call   100431 <__panic>

    const char *str = "ucore: Hello world!!";
  1043ef:	c7 45 e8 bc 84 10 00 	movl   $0x1084bc,-0x18(%ebp)
    strcpy((void *)0x100, str);
  1043f6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1043f9:	89 44 24 04          	mov    %eax,0x4(%esp)
  1043fd:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
  104404:	e8 f5 28 00 00       	call   106cfe <strcpy>
    assert(strcmp((void *)0x100, (void *)(0x100 + PGSIZE)) == 0);
  104409:	c7 44 24 04 00 11 00 	movl   $0x1100,0x4(%esp)
  104410:	00 
  104411:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
  104418:	e8 5f 29 00 00       	call   106d7c <strcmp>
  10441d:	85 c0                	test   %eax,%eax
  10441f:	74 24                	je     104445 <check_boot_pgdir+0x2fb>
  104421:	c7 44 24 0c d4 84 10 	movl   $0x1084d4,0xc(%esp)
  104428:	00 
  104429:	c7 44 24 08 ad 80 10 	movl   $0x1080ad,0x8(%esp)
  104430:	00 
  104431:	c7 44 24 04 4a 02 00 	movl   $0x24a,0x4(%esp)
  104438:	00 
  104439:	c7 04 24 88 80 10 00 	movl   $0x108088,(%esp)
  104440:	e8 ec bf ff ff       	call   100431 <__panic>

    *(char *)(page2kva(p) + 0x100) = '\0';
  104445:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104448:	89 04 24             	mov    %eax,(%esp)
  10444b:	e8 6c e9 ff ff       	call   102dbc <page2kva>
  104450:	05 00 01 00 00       	add    $0x100,%eax
  104455:	c6 00 00             	movb   $0x0,(%eax)
    assert(strlen((const char *)0x100) == 0);
  104458:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
  10445f:	e8 3c 28 00 00       	call   106ca0 <strlen>
  104464:	85 c0                	test   %eax,%eax
  104466:	74 24                	je     10448c <check_boot_pgdir+0x342>
  104468:	c7 44 24 0c 0c 85 10 	movl   $0x10850c,0xc(%esp)
  10446f:	00 
  104470:	c7 44 24 08 ad 80 10 	movl   $0x1080ad,0x8(%esp)
  104477:	00 
  104478:	c7 44 24 04 4d 02 00 	movl   $0x24d,0x4(%esp)
  10447f:	00 
  104480:	c7 04 24 88 80 10 00 	movl   $0x108088,(%esp)
  104487:	e8 a5 bf ff ff       	call   100431 <__panic>

    free_page(p);
  10448c:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  104493:	00 
  104494:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104497:	89 04 24             	mov    %eax,(%esp)
  10449a:	e8 19 ec ff ff       	call   1030b8 <free_pages>
    free_page(pde2page(boot_pgdir[0]));
  10449f:	a1 e0 d9 11 00       	mov    0x11d9e0,%eax
  1044a4:	8b 00                	mov    (%eax),%eax
  1044a6:	89 04 24             	mov    %eax,(%esp)
  1044a9:	e8 a0 e9 ff ff       	call   102e4e <pde2page>
  1044ae:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  1044b5:	00 
  1044b6:	89 04 24             	mov    %eax,(%esp)
  1044b9:	e8 fa eb ff ff       	call   1030b8 <free_pages>
    boot_pgdir[0] = 0;
  1044be:	a1 e0 d9 11 00       	mov    0x11d9e0,%eax
  1044c3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    cprintf("check_boot_pgdir() succeeded!\n");
  1044c9:	c7 04 24 30 85 10 00 	movl   $0x108530,(%esp)
  1044d0:	e8 f0 bd ff ff       	call   1002c5 <cprintf>
}
  1044d5:	90                   	nop
  1044d6:	c9                   	leave  
  1044d7:	c3                   	ret    

001044d8 <perm2str>:

//perm2str - use string 'u,r,w,-' to present the permission
static const char *
perm2str(int perm) {
  1044d8:	f3 0f 1e fb          	endbr32 
  1044dc:	55                   	push   %ebp
  1044dd:	89 e5                	mov    %esp,%ebp
    static char str[4];
    str[0] = (perm & PTE_U) ? 'u' : '-';
  1044df:	8b 45 08             	mov    0x8(%ebp),%eax
  1044e2:	83 e0 04             	and    $0x4,%eax
  1044e5:	85 c0                	test   %eax,%eax
  1044e7:	74 04                	je     1044ed <perm2str+0x15>
  1044e9:	b0 75                	mov    $0x75,%al
  1044eb:	eb 02                	jmp    1044ef <perm2str+0x17>
  1044ed:	b0 2d                	mov    $0x2d,%al
  1044ef:	a2 08 0f 12 00       	mov    %al,0x120f08
    str[1] = 'r';
  1044f4:	c6 05 09 0f 12 00 72 	movb   $0x72,0x120f09
    str[2] = (perm & PTE_W) ? 'w' : '-';
  1044fb:	8b 45 08             	mov    0x8(%ebp),%eax
  1044fe:	83 e0 02             	and    $0x2,%eax
  104501:	85 c0                	test   %eax,%eax
  104503:	74 04                	je     104509 <perm2str+0x31>
  104505:	b0 77                	mov    $0x77,%al
  104507:	eb 02                	jmp    10450b <perm2str+0x33>
  104509:	b0 2d                	mov    $0x2d,%al
  10450b:	a2 0a 0f 12 00       	mov    %al,0x120f0a
    str[3] = '\0';
  104510:	c6 05 0b 0f 12 00 00 	movb   $0x0,0x120f0b
    return str;
  104517:	b8 08 0f 12 00       	mov    $0x120f08,%eax
}
  10451c:	5d                   	pop    %ebp
  10451d:	c3                   	ret    

0010451e <get_pgtable_items>:
//  table:       the beginning addr of table
//  left_store:  the pointer of the high side of table's next range
//  right_store: the pointer of the low side of table's next range
// return value: 0 - not a invalid item range, perm - a valid item range with perm permission 
static int
get_pgtable_items(size_t left, size_t right, size_t start, uintptr_t *table, size_t *left_store, size_t *right_store) {
  10451e:	f3 0f 1e fb          	endbr32 
  104522:	55                   	push   %ebp
  104523:	89 e5                	mov    %esp,%ebp
  104525:	83 ec 10             	sub    $0x10,%esp
    if (start >= right) {
  104528:	8b 45 10             	mov    0x10(%ebp),%eax
  10452b:	3b 45 0c             	cmp    0xc(%ebp),%eax
  10452e:	72 0d                	jb     10453d <get_pgtable_items+0x1f>
        return 0;
  104530:	b8 00 00 00 00       	mov    $0x0,%eax
  104535:	e9 98 00 00 00       	jmp    1045d2 <get_pgtable_items+0xb4>
    }
    while (start < right && !(table[start] & PTE_P)) {
        start ++;
  10453a:	ff 45 10             	incl   0x10(%ebp)
    while (start < right && !(table[start] & PTE_P)) {
  10453d:	8b 45 10             	mov    0x10(%ebp),%eax
  104540:	3b 45 0c             	cmp    0xc(%ebp),%eax
  104543:	73 18                	jae    10455d <get_pgtable_items+0x3f>
  104545:	8b 45 10             	mov    0x10(%ebp),%eax
  104548:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  10454f:	8b 45 14             	mov    0x14(%ebp),%eax
  104552:	01 d0                	add    %edx,%eax
  104554:	8b 00                	mov    (%eax),%eax
  104556:	83 e0 01             	and    $0x1,%eax
  104559:	85 c0                	test   %eax,%eax
  10455b:	74 dd                	je     10453a <get_pgtable_items+0x1c>
    }
    if (start < right) {
  10455d:	8b 45 10             	mov    0x10(%ebp),%eax
  104560:	3b 45 0c             	cmp    0xc(%ebp),%eax
  104563:	73 68                	jae    1045cd <get_pgtable_items+0xaf>
        if (left_store != NULL) {
  104565:	83 7d 18 00          	cmpl   $0x0,0x18(%ebp)
  104569:	74 08                	je     104573 <get_pgtable_items+0x55>
            *left_store = start;
  10456b:	8b 45 18             	mov    0x18(%ebp),%eax
  10456e:	8b 55 10             	mov    0x10(%ebp),%edx
  104571:	89 10                	mov    %edx,(%eax)
        }
        int perm = (table[start ++] & PTE_USER);
  104573:	8b 45 10             	mov    0x10(%ebp),%eax
  104576:	8d 50 01             	lea    0x1(%eax),%edx
  104579:	89 55 10             	mov    %edx,0x10(%ebp)
  10457c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  104583:	8b 45 14             	mov    0x14(%ebp),%eax
  104586:	01 d0                	add    %edx,%eax
  104588:	8b 00                	mov    (%eax),%eax
  10458a:	83 e0 07             	and    $0x7,%eax
  10458d:	89 45 fc             	mov    %eax,-0x4(%ebp)
        while (start < right && (table[start] & PTE_USER) == perm) {
  104590:	eb 03                	jmp    104595 <get_pgtable_items+0x77>
            start ++;
  104592:	ff 45 10             	incl   0x10(%ebp)
        while (start < right && (table[start] & PTE_USER) == perm) {
  104595:	8b 45 10             	mov    0x10(%ebp),%eax
  104598:	3b 45 0c             	cmp    0xc(%ebp),%eax
  10459b:	73 1d                	jae    1045ba <get_pgtable_items+0x9c>
  10459d:	8b 45 10             	mov    0x10(%ebp),%eax
  1045a0:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  1045a7:	8b 45 14             	mov    0x14(%ebp),%eax
  1045aa:	01 d0                	add    %edx,%eax
  1045ac:	8b 00                	mov    (%eax),%eax
  1045ae:	83 e0 07             	and    $0x7,%eax
  1045b1:	89 c2                	mov    %eax,%edx
  1045b3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1045b6:	39 c2                	cmp    %eax,%edx
  1045b8:	74 d8                	je     104592 <get_pgtable_items+0x74>
        }
        if (right_store != NULL) {
  1045ba:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  1045be:	74 08                	je     1045c8 <get_pgtable_items+0xaa>
            *right_store = start;
  1045c0:	8b 45 1c             	mov    0x1c(%ebp),%eax
  1045c3:	8b 55 10             	mov    0x10(%ebp),%edx
  1045c6:	89 10                	mov    %edx,(%eax)
        }
        return perm;
  1045c8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1045cb:	eb 05                	jmp    1045d2 <get_pgtable_items+0xb4>
    }
    return 0;
  1045cd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  1045d2:	c9                   	leave  
  1045d3:	c3                   	ret    

001045d4 <print_pgdir>:

//print_pgdir - print the PDT&PT
void
print_pgdir(void) {
  1045d4:	f3 0f 1e fb          	endbr32 
  1045d8:	55                   	push   %ebp
  1045d9:	89 e5                	mov    %esp,%ebp
  1045db:	57                   	push   %edi
  1045dc:	56                   	push   %esi
  1045dd:	53                   	push   %ebx
  1045de:	83 ec 4c             	sub    $0x4c,%esp
    cprintf("-------------------- BEGIN --------------------\n");
  1045e1:	c7 04 24 50 85 10 00 	movl   $0x108550,(%esp)
  1045e8:	e8 d8 bc ff ff       	call   1002c5 <cprintf>
    size_t left, right = 0, perm;
  1045ed:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
  1045f4:	e9 fa 00 00 00       	jmp    1046f3 <print_pgdir+0x11f>
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
  1045f9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1045fc:	89 04 24             	mov    %eax,(%esp)
  1045ff:	e8 d4 fe ff ff       	call   1044d8 <perm2str>
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
  104604:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  104607:	8b 55 e0             	mov    -0x20(%ebp),%edx
  10460a:	29 d1                	sub    %edx,%ecx
  10460c:	89 ca                	mov    %ecx,%edx
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
  10460e:	89 d6                	mov    %edx,%esi
  104610:	c1 e6 16             	shl    $0x16,%esi
  104613:	8b 55 dc             	mov    -0x24(%ebp),%edx
  104616:	89 d3                	mov    %edx,%ebx
  104618:	c1 e3 16             	shl    $0x16,%ebx
  10461b:	8b 55 e0             	mov    -0x20(%ebp),%edx
  10461e:	89 d1                	mov    %edx,%ecx
  104620:	c1 e1 16             	shl    $0x16,%ecx
  104623:	8b 7d dc             	mov    -0x24(%ebp),%edi
  104626:	8b 55 e0             	mov    -0x20(%ebp),%edx
  104629:	29 d7                	sub    %edx,%edi
  10462b:	89 fa                	mov    %edi,%edx
  10462d:	89 44 24 14          	mov    %eax,0x14(%esp)
  104631:	89 74 24 10          	mov    %esi,0x10(%esp)
  104635:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  104639:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  10463d:	89 54 24 04          	mov    %edx,0x4(%esp)
  104641:	c7 04 24 81 85 10 00 	movl   $0x108581,(%esp)
  104648:	e8 78 bc ff ff       	call   1002c5 <cprintf>
        size_t l, r = left * NPTEENTRY;
  10464d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  104650:	c1 e0 0a             	shl    $0xa,%eax
  104653:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
  104656:	eb 54                	jmp    1046ac <print_pgdir+0xd8>
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
  104658:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10465b:	89 04 24             	mov    %eax,(%esp)
  10465e:	e8 75 fe ff ff       	call   1044d8 <perm2str>
                    l * PGSIZE, r * PGSIZE, (r - l) * PGSIZE, perm2str(perm));
  104663:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  104666:	8b 55 d8             	mov    -0x28(%ebp),%edx
  104669:	29 d1                	sub    %edx,%ecx
  10466b:	89 ca                	mov    %ecx,%edx
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
  10466d:	89 d6                	mov    %edx,%esi
  10466f:	c1 e6 0c             	shl    $0xc,%esi
  104672:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  104675:	89 d3                	mov    %edx,%ebx
  104677:	c1 e3 0c             	shl    $0xc,%ebx
  10467a:	8b 55 d8             	mov    -0x28(%ebp),%edx
  10467d:	89 d1                	mov    %edx,%ecx
  10467f:	c1 e1 0c             	shl    $0xc,%ecx
  104682:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  104685:	8b 55 d8             	mov    -0x28(%ebp),%edx
  104688:	29 d7                	sub    %edx,%edi
  10468a:	89 fa                	mov    %edi,%edx
  10468c:	89 44 24 14          	mov    %eax,0x14(%esp)
  104690:	89 74 24 10          	mov    %esi,0x10(%esp)
  104694:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  104698:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  10469c:	89 54 24 04          	mov    %edx,0x4(%esp)
  1046a0:	c7 04 24 a0 85 10 00 	movl   $0x1085a0,(%esp)
  1046a7:	e8 19 bc ff ff       	call   1002c5 <cprintf>
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
  1046ac:	be 00 00 c0 fa       	mov    $0xfac00000,%esi
  1046b1:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1046b4:	8b 55 dc             	mov    -0x24(%ebp),%edx
  1046b7:	89 d3                	mov    %edx,%ebx
  1046b9:	c1 e3 0a             	shl    $0xa,%ebx
  1046bc:	8b 55 e0             	mov    -0x20(%ebp),%edx
  1046bf:	89 d1                	mov    %edx,%ecx
  1046c1:	c1 e1 0a             	shl    $0xa,%ecx
  1046c4:	8d 55 d4             	lea    -0x2c(%ebp),%edx
  1046c7:	89 54 24 14          	mov    %edx,0x14(%esp)
  1046cb:	8d 55 d8             	lea    -0x28(%ebp),%edx
  1046ce:	89 54 24 10          	mov    %edx,0x10(%esp)
  1046d2:	89 74 24 0c          	mov    %esi,0xc(%esp)
  1046d6:	89 44 24 08          	mov    %eax,0x8(%esp)
  1046da:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  1046de:	89 0c 24             	mov    %ecx,(%esp)
  1046e1:	e8 38 fe ff ff       	call   10451e <get_pgtable_items>
  1046e6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  1046e9:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  1046ed:	0f 85 65 ff ff ff    	jne    104658 <print_pgdir+0x84>
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
  1046f3:	b9 00 b0 fe fa       	mov    $0xfafeb000,%ecx
  1046f8:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1046fb:	8d 55 dc             	lea    -0x24(%ebp),%edx
  1046fe:	89 54 24 14          	mov    %edx,0x14(%esp)
  104702:	8d 55 e0             	lea    -0x20(%ebp),%edx
  104705:	89 54 24 10          	mov    %edx,0x10(%esp)
  104709:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  10470d:	89 44 24 08          	mov    %eax,0x8(%esp)
  104711:	c7 44 24 04 00 04 00 	movl   $0x400,0x4(%esp)
  104718:	00 
  104719:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  104720:	e8 f9 fd ff ff       	call   10451e <get_pgtable_items>
  104725:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  104728:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  10472c:	0f 85 c7 fe ff ff    	jne    1045f9 <print_pgdir+0x25>
        }
    }
    cprintf("--------------------- END ---------------------\n");
  104732:	c7 04 24 c4 85 10 00 	movl   $0x1085c4,(%esp)
  104739:	e8 87 bb ff ff       	call   1002c5 <cprintf>
}
  10473e:	90                   	nop
  10473f:	83 c4 4c             	add    $0x4c,%esp
  104742:	5b                   	pop    %ebx
  104743:	5e                   	pop    %esi
  104744:	5f                   	pop    %edi
  104745:	5d                   	pop    %ebp
  104746:	c3                   	ret    

00104747 <page2ppn>:
page2ppn(struct Page *page) {
  104747:	55                   	push   %ebp
  104748:	89 e5                	mov    %esp,%ebp
    return page - pages;
  10474a:	a1 78 0f 12 00       	mov    0x120f78,%eax
  10474f:	8b 55 08             	mov    0x8(%ebp),%edx
  104752:	29 c2                	sub    %eax,%edx
  104754:	89 d0                	mov    %edx,%eax
  104756:	c1 f8 02             	sar    $0x2,%eax
  104759:	69 c0 cd cc cc cc    	imul   $0xcccccccd,%eax,%eax
}
  10475f:	5d                   	pop    %ebp
  104760:	c3                   	ret    

00104761 <page2pa>:
page2pa(struct Page *page) {
  104761:	55                   	push   %ebp
  104762:	89 e5                	mov    %esp,%ebp
  104764:	83 ec 04             	sub    $0x4,%esp
    return page2ppn(page) << PGSHIFT;
  104767:	8b 45 08             	mov    0x8(%ebp),%eax
  10476a:	89 04 24             	mov    %eax,(%esp)
  10476d:	e8 d5 ff ff ff       	call   104747 <page2ppn>
  104772:	c1 e0 0c             	shl    $0xc,%eax
}
  104775:	c9                   	leave  
  104776:	c3                   	ret    

00104777 <page_ref>:
page_ref(struct Page *page) {
  104777:	55                   	push   %ebp
  104778:	89 e5                	mov    %esp,%ebp
    return page->ref;
  10477a:	8b 45 08             	mov    0x8(%ebp),%eax
  10477d:	8b 00                	mov    (%eax),%eax
}
  10477f:	5d                   	pop    %ebp
  104780:	c3                   	ret    

00104781 <set_page_ref>:
set_page_ref(struct Page *page, int val) {
  104781:	55                   	push   %ebp
  104782:	89 e5                	mov    %esp,%ebp
    page->ref = val;
  104784:	8b 45 08             	mov    0x8(%ebp),%eax
  104787:	8b 55 0c             	mov    0xc(%ebp),%edx
  10478a:	89 10                	mov    %edx,(%eax)
}
  10478c:	90                   	nop
  10478d:	5d                   	pop    %ebp
  10478e:	c3                   	ret    

0010478f <default_init>:

// 赋给pmm_manager中的函数指针void (*init)(void)
// 物理内存管理器初始化，包括生成内部描述和数据结构（空闲块链表和空闲页总数），总数初始为0
// 在pmm.c中的init_pmm_manager()调用了pmm_manager->init()
static void
default_init(void) {
  10478f:	f3 0f 1e fb          	endbr32 
  104793:	55                   	push   %ebp
  104794:	89 e5                	mov    %esp,%ebp
  104796:	83 ec 10             	sub    $0x10,%esp
  104799:	c7 45 fc a0 0f 32 00 	movl   $0x320fa0,-0x4(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
  1047a0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1047a3:	8b 55 fc             	mov    -0x4(%ebp),%edx
  1047a6:	89 50 04             	mov    %edx,0x4(%eax)
  1047a9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1047ac:	8b 50 04             	mov    0x4(%eax),%edx
  1047af:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1047b2:	89 10                	mov    %edx,(%eax)
}
  1047b4:	90                   	nop
    list_init(&free_list);
    nr_free = 0;
  1047b5:	c7 05 a8 0f 32 00 00 	movl   $0x0,0x320fa8
  1047bc:	00 00 00 
}
  1047bf:	90                   	nop
  1047c0:	c9                   	leave  
  1047c1:	c3                   	ret    

001047c2 <default_init_memmap>:
// 将base首部Page结构的property设置为n，将free_area->nr_free增加n
// 将base首部Page结构的flags的第2位（1位）设置为1，表明该Page是一个空闲块的头部，且没有被分配
// 将这n个Page结构的连续块（base首部Page结构中的page_link）连接到free_area->free_list上，连接位置为free_area->free_list入口之后
// 在pmm.c中的init_memmap()调用了pmm_manager->init_memmap()
static void
default_init_memmap(struct Page *base, size_t n) {
  1047c2:	f3 0f 1e fb          	endbr32 
  1047c6:	55                   	push   %ebp
  1047c7:	89 e5                	mov    %esp,%ebp
  1047c9:	83 ec 58             	sub    $0x58,%esp
    assert(n > 0);
  1047cc:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  1047d0:	75 24                	jne    1047f6 <default_init_memmap+0x34>
  1047d2:	c7 44 24 0c f8 85 10 	movl   $0x1085f8,0xc(%esp)
  1047d9:	00 
  1047da:	c7 44 24 08 fe 85 10 	movl   $0x1085fe,0x8(%esp)
  1047e1:	00 
  1047e2:	c7 44 24 04 7c 00 00 	movl   $0x7c,0x4(%esp)
  1047e9:	00 
  1047ea:	c7 04 24 13 86 10 00 	movl   $0x108613,(%esp)
  1047f1:	e8 3b bc ff ff       	call   100431 <__panic>
    struct Page *p = base;
  1047f6:	8b 45 08             	mov    0x8(%ebp),%eax
  1047f9:	89 45 f4             	mov    %eax,-0xc(%ebp)
    for (; p != base + n; p ++) {
  1047fc:	eb 7d                	jmp    10487b <default_init_memmap+0xb9>
        assert(PageReserved(p));
  1047fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104801:	83 c0 04             	add    $0x4,%eax
  104804:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  10480b:	89 45 ec             	mov    %eax,-0x14(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  10480e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104811:	8b 55 f0             	mov    -0x10(%ebp),%edx
  104814:	0f a3 10             	bt     %edx,(%eax)
  104817:	19 c0                	sbb    %eax,%eax
  104819:	89 45 e8             	mov    %eax,-0x18(%ebp)
    return oldbit != 0;
  10481c:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  104820:	0f 95 c0             	setne  %al
  104823:	0f b6 c0             	movzbl %al,%eax
  104826:	85 c0                	test   %eax,%eax
  104828:	75 24                	jne    10484e <default_init_memmap+0x8c>
  10482a:	c7 44 24 0c 29 86 10 	movl   $0x108629,0xc(%esp)
  104831:	00 
  104832:	c7 44 24 08 fe 85 10 	movl   $0x1085fe,0x8(%esp)
  104839:	00 
  10483a:	c7 44 24 04 7f 00 00 	movl   $0x7f,0x4(%esp)
  104841:	00 
  104842:	c7 04 24 13 86 10 00 	movl   $0x108613,(%esp)
  104849:	e8 e3 bb ff ff       	call   100431 <__panic>
        p->flags = p->property = 0;
  10484e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104851:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  104858:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10485b:	8b 50 08             	mov    0x8(%eax),%edx
  10485e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104861:	89 50 04             	mov    %edx,0x4(%eax)
        set_page_ref(p, 0);
  104864:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  10486b:	00 
  10486c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10486f:	89 04 24             	mov    %eax,(%esp)
  104872:	e8 0a ff ff ff       	call   104781 <set_page_ref>
    for (; p != base + n; p ++) {
  104877:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
  10487b:	8b 55 0c             	mov    0xc(%ebp),%edx
  10487e:	89 d0                	mov    %edx,%eax
  104880:	c1 e0 02             	shl    $0x2,%eax
  104883:	01 d0                	add    %edx,%eax
  104885:	c1 e0 02             	shl    $0x2,%eax
  104888:	89 c2                	mov    %eax,%edx
  10488a:	8b 45 08             	mov    0x8(%ebp),%eax
  10488d:	01 d0                	add    %edx,%eax
  10488f:	39 45 f4             	cmp    %eax,-0xc(%ebp)
  104892:	0f 85 66 ff ff ff    	jne    1047fe <default_init_memmap+0x3c>
    }
    base->property = n;
  104898:	8b 45 08             	mov    0x8(%ebp),%eax
  10489b:	8b 55 0c             	mov    0xc(%ebp),%edx
  10489e:	89 50 08             	mov    %edx,0x8(%eax)
    SetPageProperty(base);
  1048a1:	8b 45 08             	mov    0x8(%ebp),%eax
  1048a4:	83 c0 04             	add    $0x4,%eax
  1048a7:	c7 45 c8 01 00 00 00 	movl   $0x1,-0x38(%ebp)
  1048ae:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  1048b1:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  1048b4:	8b 55 c8             	mov    -0x38(%ebp),%edx
  1048b7:	0f ab 10             	bts    %edx,(%eax)
}
  1048ba:	90                   	nop
    nr_free += n;
  1048bb:	8b 15 a8 0f 32 00    	mov    0x320fa8,%edx
  1048c1:	8b 45 0c             	mov    0xc(%ebp),%eax
  1048c4:	01 d0                	add    %edx,%eax
  1048c6:	a3 a8 0f 32 00       	mov    %eax,0x320fa8
    list_add(&free_list, &(base->page_link));
  1048cb:	8b 45 08             	mov    0x8(%ebp),%eax
  1048ce:	83 c0 0c             	add    $0xc,%eax
  1048d1:	c7 45 e4 a0 0f 32 00 	movl   $0x320fa0,-0x1c(%ebp)
  1048d8:	89 45 e0             	mov    %eax,-0x20(%ebp)
  1048db:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1048de:	89 45 dc             	mov    %eax,-0x24(%ebp)
  1048e1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1048e4:	89 45 d8             	mov    %eax,-0x28(%ebp)
 * Insert the new element @elm *after* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_after(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm, listelm->next);
  1048e7:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1048ea:	8b 40 04             	mov    0x4(%eax),%eax
  1048ed:	8b 55 d8             	mov    -0x28(%ebp),%edx
  1048f0:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  1048f3:	8b 55 dc             	mov    -0x24(%ebp),%edx
  1048f6:	89 55 d0             	mov    %edx,-0x30(%ebp)
  1048f9:	89 45 cc             	mov    %eax,-0x34(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
  1048fc:	8b 45 cc             	mov    -0x34(%ebp),%eax
  1048ff:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  104902:	89 10                	mov    %edx,(%eax)
  104904:	8b 45 cc             	mov    -0x34(%ebp),%eax
  104907:	8b 10                	mov    (%eax),%edx
  104909:	8b 45 d0             	mov    -0x30(%ebp),%eax
  10490c:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
  10490f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  104912:	8b 55 cc             	mov    -0x34(%ebp),%edx
  104915:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
  104918:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  10491b:	8b 55 d0             	mov    -0x30(%ebp),%edx
  10491e:	89 10                	mov    %edx,(%eax)
}
  104920:	90                   	nop
}
  104921:	90                   	nop
}
  104922:	90                   	nop
}
  104923:	90                   	nop
  104924:	c9                   	leave  
  104925:	c3                   	ret    

00104926 <default_alloc_pages>:
// 没有合适的块则return NULL，合适的块如果大于n则将其分割，剩余部分按序连回链表
// 将free_area->nr_free减去n
// 将page->flags的第2位（1位）设置为0，表明该Page是一个空闲块的头部，且已经被分配
// 在pmm.c中的alloc_pages()调用了pmm_manager->alloc_pages()
static struct Page *
default_alloc_pages(size_t n) {
  104926:	f3 0f 1e fb          	endbr32 
  10492a:	55                   	push   %ebp
  10492b:	89 e5                	mov    %esp,%ebp
  10492d:	83 ec 68             	sub    $0x68,%esp
    assert(n > 0);
  104930:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  104934:	75 24                	jne    10495a <default_alloc_pages+0x34>
  104936:	c7 44 24 0c f8 85 10 	movl   $0x1085f8,0xc(%esp)
  10493d:	00 
  10493e:	c7 44 24 08 fe 85 10 	movl   $0x1085fe,0x8(%esp)
  104945:	00 
  104946:	c7 44 24 04 94 00 00 	movl   $0x94,0x4(%esp)
  10494d:	00 
  10494e:	c7 04 24 13 86 10 00 	movl   $0x108613,(%esp)
  104955:	e8 d7 ba ff ff       	call   100431 <__panic>
    if (n > nr_free) {
  10495a:	a1 a8 0f 32 00       	mov    0x320fa8,%eax
  10495f:	39 45 08             	cmp    %eax,0x8(%ebp)
  104962:	76 0a                	jbe    10496e <default_alloc_pages+0x48>
        return NULL;
  104964:	b8 00 00 00 00       	mov    $0x0,%eax
  104969:	e9 43 01 00 00       	jmp    104ab1 <default_alloc_pages+0x18b>
    }
    struct Page *page = NULL;
  10496e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    list_entry_t *le = &free_list;
  104975:	c7 45 f0 a0 0f 32 00 	movl   $0x320fa0,-0x10(%ebp)
    while ((le = list_next(le)) != &free_list) {
  10497c:	eb 1c                	jmp    10499a <default_alloc_pages+0x74>
        struct Page *p = le2page(le, page_link);
  10497e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104981:	83 e8 0c             	sub    $0xc,%eax
  104984:	89 45 ec             	mov    %eax,-0x14(%ebp)
        if (p->property >= n) {
  104987:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10498a:	8b 40 08             	mov    0x8(%eax),%eax
  10498d:	39 45 08             	cmp    %eax,0x8(%ebp)
  104990:	77 08                	ja     10499a <default_alloc_pages+0x74>
            page = p;
  104992:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104995:	89 45 f4             	mov    %eax,-0xc(%ebp)
            break;
  104998:	eb 18                	jmp    1049b2 <default_alloc_pages+0x8c>
  10499a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10499d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    return listelm->next;
  1049a0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1049a3:	8b 40 04             	mov    0x4(%eax),%eax
    while ((le = list_next(le)) != &free_list) {
  1049a6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1049a9:	81 7d f0 a0 0f 32 00 	cmpl   $0x320fa0,-0x10(%ebp)
  1049b0:	75 cc                	jne    10497e <default_alloc_pages+0x58>
        }
    }
    if (page != NULL) {
  1049b2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1049b6:	0f 84 f2 00 00 00    	je     104aae <default_alloc_pages+0x188>
        if (page->property > n) {
  1049bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1049bf:	8b 40 08             	mov    0x8(%eax),%eax
  1049c2:	39 45 08             	cmp    %eax,0x8(%ebp)
  1049c5:	0f 83 8f 00 00 00    	jae    104a5a <default_alloc_pages+0x134>
            struct Page *p = page + n;
  1049cb:	8b 55 08             	mov    0x8(%ebp),%edx
  1049ce:	89 d0                	mov    %edx,%eax
  1049d0:	c1 e0 02             	shl    $0x2,%eax
  1049d3:	01 d0                	add    %edx,%eax
  1049d5:	c1 e0 02             	shl    $0x2,%eax
  1049d8:	89 c2                	mov    %eax,%edx
  1049da:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1049dd:	01 d0                	add    %edx,%eax
  1049df:	89 45 e8             	mov    %eax,-0x18(%ebp)
            p->property = page->property - n;
  1049e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1049e5:	8b 40 08             	mov    0x8(%eax),%eax
  1049e8:	2b 45 08             	sub    0x8(%ebp),%eax
  1049eb:	89 c2                	mov    %eax,%edx
  1049ed:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1049f0:	89 50 08             	mov    %edx,0x8(%eax)
            SetPageProperty(p);
  1049f3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1049f6:	83 c0 04             	add    $0x4,%eax
  1049f9:	c7 45 cc 01 00 00 00 	movl   $0x1,-0x34(%ebp)
  104a00:	89 45 c8             	mov    %eax,-0x38(%ebp)
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  104a03:	8b 45 c8             	mov    -0x38(%ebp),%eax
  104a06:	8b 55 cc             	mov    -0x34(%ebp),%edx
  104a09:	0f ab 10             	bts    %edx,(%eax)
}
  104a0c:	90                   	nop
            list_add_after(&(page->page_link), &(p->page_link));
  104a0d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  104a10:	83 c0 0c             	add    $0xc,%eax
  104a13:	8b 55 f4             	mov    -0xc(%ebp),%edx
  104a16:	83 c2 0c             	add    $0xc,%edx
  104a19:	89 55 e0             	mov    %edx,-0x20(%ebp)
  104a1c:	89 45 dc             	mov    %eax,-0x24(%ebp)
    __list_add(elm, listelm, listelm->next);
  104a1f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  104a22:	8b 40 04             	mov    0x4(%eax),%eax
  104a25:	8b 55 dc             	mov    -0x24(%ebp),%edx
  104a28:	89 55 d8             	mov    %edx,-0x28(%ebp)
  104a2b:	8b 55 e0             	mov    -0x20(%ebp),%edx
  104a2e:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  104a31:	89 45 d0             	mov    %eax,-0x30(%ebp)
    prev->next = next->prev = elm;
  104a34:	8b 45 d0             	mov    -0x30(%ebp),%eax
  104a37:	8b 55 d8             	mov    -0x28(%ebp),%edx
  104a3a:	89 10                	mov    %edx,(%eax)
  104a3c:	8b 45 d0             	mov    -0x30(%ebp),%eax
  104a3f:	8b 10                	mov    (%eax),%edx
  104a41:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  104a44:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
  104a47:	8b 45 d8             	mov    -0x28(%ebp),%eax
  104a4a:	8b 55 d0             	mov    -0x30(%ebp),%edx
  104a4d:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
  104a50:	8b 45 d8             	mov    -0x28(%ebp),%eax
  104a53:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  104a56:	89 10                	mov    %edx,(%eax)
}
  104a58:	90                   	nop
}
  104a59:	90                   	nop
        }
        list_del(&(page->page_link));
  104a5a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104a5d:	83 c0 0c             	add    $0xc,%eax
  104a60:	89 45 bc             	mov    %eax,-0x44(%ebp)
    __list_del(listelm->prev, listelm->next);
  104a63:	8b 45 bc             	mov    -0x44(%ebp),%eax
  104a66:	8b 40 04             	mov    0x4(%eax),%eax
  104a69:	8b 55 bc             	mov    -0x44(%ebp),%edx
  104a6c:	8b 12                	mov    (%edx),%edx
  104a6e:	89 55 b8             	mov    %edx,-0x48(%ebp)
  104a71:	89 45 b4             	mov    %eax,-0x4c(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
  104a74:	8b 45 b8             	mov    -0x48(%ebp),%eax
  104a77:	8b 55 b4             	mov    -0x4c(%ebp),%edx
  104a7a:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
  104a7d:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  104a80:	8b 55 b8             	mov    -0x48(%ebp),%edx
  104a83:	89 10                	mov    %edx,(%eax)
}
  104a85:	90                   	nop
}
  104a86:	90                   	nop
        nr_free -= n;
  104a87:	a1 a8 0f 32 00       	mov    0x320fa8,%eax
  104a8c:	2b 45 08             	sub    0x8(%ebp),%eax
  104a8f:	a3 a8 0f 32 00       	mov    %eax,0x320fa8
        ClearPageProperty(page);
  104a94:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104a97:	83 c0 04             	add    $0x4,%eax
  104a9a:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
  104aa1:	89 45 c0             	mov    %eax,-0x40(%ebp)
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  104aa4:	8b 45 c0             	mov    -0x40(%ebp),%eax
  104aa7:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  104aaa:	0f b3 10             	btr    %edx,(%eax)
}
  104aad:	90                   	nop
    }
    return page;
  104aae:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  104ab1:	c9                   	leave  
  104ab2:	c3                   	ret    

00104ab3 <default_free_pages>:
// 将base首部Page结构的flags的第2位（1位）设置为1，表明该Page是一个空闲块的头部，且没有被分配
// 第一次遍历，寻找链表中和base所在空闲块相邻的空闲块，此处相邻指的是在Page数组中连续分布，寻找到一个之后还能继续寻找
// 第二次遍历，寻找这个（合并后的）空闲块应该插入到链表中的哪个位置。应插入到找到的第一个基址大于base + base->property的空闲块前面。
// 在pmm.c中的void free_pages()调用了pmm_manager->free_pages()
static void
default_free_pages(struct Page *base, size_t n) {
  104ab3:	f3 0f 1e fb          	endbr32 
  104ab7:	55                   	push   %ebp
  104ab8:	89 e5                	mov    %esp,%ebp
  104aba:	81 ec 98 00 00 00    	sub    $0x98,%esp
    assert(n > 0);
  104ac0:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  104ac4:	75 24                	jne    104aea <default_free_pages+0x37>
  104ac6:	c7 44 24 0c f8 85 10 	movl   $0x1085f8,0xc(%esp)
  104acd:	00 
  104ace:	c7 44 24 08 fe 85 10 	movl   $0x1085fe,0x8(%esp)
  104ad5:	00 
  104ad6:	c7 44 24 04 b9 00 00 	movl   $0xb9,0x4(%esp)
  104add:	00 
  104ade:	c7 04 24 13 86 10 00 	movl   $0x108613,(%esp)
  104ae5:	e8 47 b9 ff ff       	call   100431 <__panic>
    struct Page *p = base;
  104aea:	8b 45 08             	mov    0x8(%ebp),%eax
  104aed:	89 45 f4             	mov    %eax,-0xc(%ebp)
    for (; p != base + n; p ++) {
  104af0:	e9 9d 00 00 00       	jmp    104b92 <default_free_pages+0xdf>
        assert(!PageReserved(p) && !PageProperty(p));
  104af5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104af8:	83 c0 04             	add    $0x4,%eax
  104afb:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  104b02:	89 45 e8             	mov    %eax,-0x18(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  104b05:	8b 45 e8             	mov    -0x18(%ebp),%eax
  104b08:	8b 55 ec             	mov    -0x14(%ebp),%edx
  104b0b:	0f a3 10             	bt     %edx,(%eax)
  104b0e:	19 c0                	sbb    %eax,%eax
  104b10:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    return oldbit != 0;
  104b13:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  104b17:	0f 95 c0             	setne  %al
  104b1a:	0f b6 c0             	movzbl %al,%eax
  104b1d:	85 c0                	test   %eax,%eax
  104b1f:	75 2c                	jne    104b4d <default_free_pages+0x9a>
  104b21:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104b24:	83 c0 04             	add    $0x4,%eax
  104b27:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
  104b2e:	89 45 dc             	mov    %eax,-0x24(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  104b31:	8b 45 dc             	mov    -0x24(%ebp),%eax
  104b34:	8b 55 e0             	mov    -0x20(%ebp),%edx
  104b37:	0f a3 10             	bt     %edx,(%eax)
  104b3a:	19 c0                	sbb    %eax,%eax
  104b3c:	89 45 d8             	mov    %eax,-0x28(%ebp)
    return oldbit != 0;
  104b3f:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  104b43:	0f 95 c0             	setne  %al
  104b46:	0f b6 c0             	movzbl %al,%eax
  104b49:	85 c0                	test   %eax,%eax
  104b4b:	74 24                	je     104b71 <default_free_pages+0xbe>
  104b4d:	c7 44 24 0c 3c 86 10 	movl   $0x10863c,0xc(%esp)
  104b54:	00 
  104b55:	c7 44 24 08 fe 85 10 	movl   $0x1085fe,0x8(%esp)
  104b5c:	00 
  104b5d:	c7 44 24 04 bc 00 00 	movl   $0xbc,0x4(%esp)
  104b64:	00 
  104b65:	c7 04 24 13 86 10 00 	movl   $0x108613,(%esp)
  104b6c:	e8 c0 b8 ff ff       	call   100431 <__panic>
        p->flags = 0;
  104b71:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104b74:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
        set_page_ref(p, 0);
  104b7b:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  104b82:	00 
  104b83:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104b86:	89 04 24             	mov    %eax,(%esp)
  104b89:	e8 f3 fb ff ff       	call   104781 <set_page_ref>
    for (; p != base + n; p ++) {
  104b8e:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
  104b92:	8b 55 0c             	mov    0xc(%ebp),%edx
  104b95:	89 d0                	mov    %edx,%eax
  104b97:	c1 e0 02             	shl    $0x2,%eax
  104b9a:	01 d0                	add    %edx,%eax
  104b9c:	c1 e0 02             	shl    $0x2,%eax
  104b9f:	89 c2                	mov    %eax,%edx
  104ba1:	8b 45 08             	mov    0x8(%ebp),%eax
  104ba4:	01 d0                	add    %edx,%eax
  104ba6:	39 45 f4             	cmp    %eax,-0xc(%ebp)
  104ba9:	0f 85 46 ff ff ff    	jne    104af5 <default_free_pages+0x42>
    }
    base->property = n;
  104baf:	8b 45 08             	mov    0x8(%ebp),%eax
  104bb2:	8b 55 0c             	mov    0xc(%ebp),%edx
  104bb5:	89 50 08             	mov    %edx,0x8(%eax)
    SetPageProperty(base);
  104bb8:	8b 45 08             	mov    0x8(%ebp),%eax
  104bbb:	83 c0 04             	add    $0x4,%eax
  104bbe:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
  104bc5:	89 45 cc             	mov    %eax,-0x34(%ebp)
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  104bc8:	8b 45 cc             	mov    -0x34(%ebp),%eax
  104bcb:	8b 55 d0             	mov    -0x30(%ebp),%edx
  104bce:	0f ab 10             	bts    %edx,(%eax)
}
  104bd1:	90                   	nop
  104bd2:	c7 45 d4 a0 0f 32 00 	movl   $0x320fa0,-0x2c(%ebp)
    return listelm->next;
  104bd9:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  104bdc:	8b 40 04             	mov    0x4(%eax),%eax
    list_entry_t *le = list_next(&free_list);
  104bdf:	89 45 f0             	mov    %eax,-0x10(%ebp)
    while (le != &free_list) {
  104be2:	e9 0d 01 00 00       	jmp    104cf4 <default_free_pages+0x241>
        p = le2page(le, page_link);
  104be7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104bea:	83 e8 0c             	sub    $0xc,%eax
  104bed:	89 45 f4             	mov    %eax,-0xc(%ebp)
        if (base + base->property == p) {
  104bf0:	8b 45 08             	mov    0x8(%ebp),%eax
  104bf3:	8b 50 08             	mov    0x8(%eax),%edx
  104bf6:	89 d0                	mov    %edx,%eax
  104bf8:	c1 e0 02             	shl    $0x2,%eax
  104bfb:	01 d0                	add    %edx,%eax
  104bfd:	c1 e0 02             	shl    $0x2,%eax
  104c00:	89 c2                	mov    %eax,%edx
  104c02:	8b 45 08             	mov    0x8(%ebp),%eax
  104c05:	01 d0                	add    %edx,%eax
  104c07:	39 45 f4             	cmp    %eax,-0xc(%ebp)
  104c0a:	75 5c                	jne    104c68 <default_free_pages+0x1b5>
            base->property += p->property;
  104c0c:	8b 45 08             	mov    0x8(%ebp),%eax
  104c0f:	8b 50 08             	mov    0x8(%eax),%edx
  104c12:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104c15:	8b 40 08             	mov    0x8(%eax),%eax
  104c18:	01 c2                	add    %eax,%edx
  104c1a:	8b 45 08             	mov    0x8(%ebp),%eax
  104c1d:	89 50 08             	mov    %edx,0x8(%eax)
            ClearPageProperty(p);
  104c20:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104c23:	83 c0 04             	add    $0x4,%eax
  104c26:	c7 45 bc 01 00 00 00 	movl   $0x1,-0x44(%ebp)
  104c2d:	89 45 b8             	mov    %eax,-0x48(%ebp)
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  104c30:	8b 45 b8             	mov    -0x48(%ebp),%eax
  104c33:	8b 55 bc             	mov    -0x44(%ebp),%edx
  104c36:	0f b3 10             	btr    %edx,(%eax)
}
  104c39:	90                   	nop
            list_del(&(p->page_link));
  104c3a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104c3d:	83 c0 0c             	add    $0xc,%eax
  104c40:	89 45 c8             	mov    %eax,-0x38(%ebp)
    __list_del(listelm->prev, listelm->next);
  104c43:	8b 45 c8             	mov    -0x38(%ebp),%eax
  104c46:	8b 40 04             	mov    0x4(%eax),%eax
  104c49:	8b 55 c8             	mov    -0x38(%ebp),%edx
  104c4c:	8b 12                	mov    (%edx),%edx
  104c4e:	89 55 c4             	mov    %edx,-0x3c(%ebp)
  104c51:	89 45 c0             	mov    %eax,-0x40(%ebp)
    prev->next = next;
  104c54:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  104c57:	8b 55 c0             	mov    -0x40(%ebp),%edx
  104c5a:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
  104c5d:	8b 45 c0             	mov    -0x40(%ebp),%eax
  104c60:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  104c63:	89 10                	mov    %edx,(%eax)
}
  104c65:	90                   	nop
}
  104c66:	eb 7d                	jmp    104ce5 <default_free_pages+0x232>
        }
        else if (p + p->property == base) {
  104c68:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104c6b:	8b 50 08             	mov    0x8(%eax),%edx
  104c6e:	89 d0                	mov    %edx,%eax
  104c70:	c1 e0 02             	shl    $0x2,%eax
  104c73:	01 d0                	add    %edx,%eax
  104c75:	c1 e0 02             	shl    $0x2,%eax
  104c78:	89 c2                	mov    %eax,%edx
  104c7a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104c7d:	01 d0                	add    %edx,%eax
  104c7f:	39 45 08             	cmp    %eax,0x8(%ebp)
  104c82:	75 61                	jne    104ce5 <default_free_pages+0x232>
            p->property += base->property;
  104c84:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104c87:	8b 50 08             	mov    0x8(%eax),%edx
  104c8a:	8b 45 08             	mov    0x8(%ebp),%eax
  104c8d:	8b 40 08             	mov    0x8(%eax),%eax
  104c90:	01 c2                	add    %eax,%edx
  104c92:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104c95:	89 50 08             	mov    %edx,0x8(%eax)
            ClearPageProperty(base);
  104c98:	8b 45 08             	mov    0x8(%ebp),%eax
  104c9b:	83 c0 04             	add    $0x4,%eax
  104c9e:	c7 45 a8 01 00 00 00 	movl   $0x1,-0x58(%ebp)
  104ca5:	89 45 a4             	mov    %eax,-0x5c(%ebp)
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  104ca8:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  104cab:	8b 55 a8             	mov    -0x58(%ebp),%edx
  104cae:	0f b3 10             	btr    %edx,(%eax)
}
  104cb1:	90                   	nop
            base = p;
  104cb2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104cb5:	89 45 08             	mov    %eax,0x8(%ebp)
            list_del(&(p->page_link));
  104cb8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104cbb:	83 c0 0c             	add    $0xc,%eax
  104cbe:	89 45 b4             	mov    %eax,-0x4c(%ebp)
    __list_del(listelm->prev, listelm->next);
  104cc1:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  104cc4:	8b 40 04             	mov    0x4(%eax),%eax
  104cc7:	8b 55 b4             	mov    -0x4c(%ebp),%edx
  104cca:	8b 12                	mov    (%edx),%edx
  104ccc:	89 55 b0             	mov    %edx,-0x50(%ebp)
  104ccf:	89 45 ac             	mov    %eax,-0x54(%ebp)
    prev->next = next;
  104cd2:	8b 45 b0             	mov    -0x50(%ebp),%eax
  104cd5:	8b 55 ac             	mov    -0x54(%ebp),%edx
  104cd8:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
  104cdb:	8b 45 ac             	mov    -0x54(%ebp),%eax
  104cde:	8b 55 b0             	mov    -0x50(%ebp),%edx
  104ce1:	89 10                	mov    %edx,(%eax)
}
  104ce3:	90                   	nop
}
  104ce4:	90                   	nop
  104ce5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104ce8:	89 45 a0             	mov    %eax,-0x60(%ebp)
    return listelm->next;
  104ceb:	8b 45 a0             	mov    -0x60(%ebp),%eax
  104cee:	8b 40 04             	mov    0x4(%eax),%eax
        }
        le = list_next(le);
  104cf1:	89 45 f0             	mov    %eax,-0x10(%ebp)
    while (le != &free_list) {
  104cf4:	81 7d f0 a0 0f 32 00 	cmpl   $0x320fa0,-0x10(%ebp)
  104cfb:	0f 85 e6 fe ff ff    	jne    104be7 <default_free_pages+0x134>
    }
    nr_free += n;
  104d01:	8b 15 a8 0f 32 00    	mov    0x320fa8,%edx
  104d07:	8b 45 0c             	mov    0xc(%ebp),%eax
  104d0a:	01 d0                	add    %edx,%eax
  104d0c:	a3 a8 0f 32 00       	mov    %eax,0x320fa8
  104d11:	c7 45 9c a0 0f 32 00 	movl   $0x320fa0,-0x64(%ebp)
  104d18:	8b 45 9c             	mov    -0x64(%ebp),%eax
  104d1b:	8b 40 04             	mov    0x4(%eax),%eax
    le = list_next(&free_list);
  104d1e:	89 45 f0             	mov    %eax,-0x10(%ebp)
    while (le != &free_list) {
  104d21:	eb 74                	jmp    104d97 <default_free_pages+0x2e4>
        p = le2page(le, page_link);
  104d23:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104d26:	83 e8 0c             	sub    $0xc,%eax
  104d29:	89 45 f4             	mov    %eax,-0xc(%ebp)
        if (base + base->property <= p) {
  104d2c:	8b 45 08             	mov    0x8(%ebp),%eax
  104d2f:	8b 50 08             	mov    0x8(%eax),%edx
  104d32:	89 d0                	mov    %edx,%eax
  104d34:	c1 e0 02             	shl    $0x2,%eax
  104d37:	01 d0                	add    %edx,%eax
  104d39:	c1 e0 02             	shl    $0x2,%eax
  104d3c:	89 c2                	mov    %eax,%edx
  104d3e:	8b 45 08             	mov    0x8(%ebp),%eax
  104d41:	01 d0                	add    %edx,%eax
  104d43:	39 45 f4             	cmp    %eax,-0xc(%ebp)
  104d46:	72 40                	jb     104d88 <default_free_pages+0x2d5>
            assert(base + base->property != p);
  104d48:	8b 45 08             	mov    0x8(%ebp),%eax
  104d4b:	8b 50 08             	mov    0x8(%eax),%edx
  104d4e:	89 d0                	mov    %edx,%eax
  104d50:	c1 e0 02             	shl    $0x2,%eax
  104d53:	01 d0                	add    %edx,%eax
  104d55:	c1 e0 02             	shl    $0x2,%eax
  104d58:	89 c2                	mov    %eax,%edx
  104d5a:	8b 45 08             	mov    0x8(%ebp),%eax
  104d5d:	01 d0                	add    %edx,%eax
  104d5f:	39 45 f4             	cmp    %eax,-0xc(%ebp)
  104d62:	75 3e                	jne    104da2 <default_free_pages+0x2ef>
  104d64:	c7 44 24 0c 61 86 10 	movl   $0x108661,0xc(%esp)
  104d6b:	00 
  104d6c:	c7 44 24 08 fe 85 10 	movl   $0x1085fe,0x8(%esp)
  104d73:	00 
  104d74:	c7 44 24 04 d7 00 00 	movl   $0xd7,0x4(%esp)
  104d7b:	00 
  104d7c:	c7 04 24 13 86 10 00 	movl   $0x108613,(%esp)
  104d83:	e8 a9 b6 ff ff       	call   100431 <__panic>
  104d88:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104d8b:	89 45 98             	mov    %eax,-0x68(%ebp)
  104d8e:	8b 45 98             	mov    -0x68(%ebp),%eax
  104d91:	8b 40 04             	mov    0x4(%eax),%eax
            break;
        }
        le = list_next(le);
  104d94:	89 45 f0             	mov    %eax,-0x10(%ebp)
    while (le != &free_list) {
  104d97:	81 7d f0 a0 0f 32 00 	cmpl   $0x320fa0,-0x10(%ebp)
  104d9e:	75 83                	jne    104d23 <default_free_pages+0x270>
  104da0:	eb 01                	jmp    104da3 <default_free_pages+0x2f0>
            break;
  104da2:	90                   	nop
    }
    list_add_before(le, &(base->page_link));
  104da3:	8b 45 08             	mov    0x8(%ebp),%eax
  104da6:	8d 50 0c             	lea    0xc(%eax),%edx
  104da9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104dac:	89 45 94             	mov    %eax,-0x6c(%ebp)
  104daf:	89 55 90             	mov    %edx,-0x70(%ebp)
    __list_add(elm, listelm->prev, listelm);
  104db2:	8b 45 94             	mov    -0x6c(%ebp),%eax
  104db5:	8b 00                	mov    (%eax),%eax
  104db7:	8b 55 90             	mov    -0x70(%ebp),%edx
  104dba:	89 55 8c             	mov    %edx,-0x74(%ebp)
  104dbd:	89 45 88             	mov    %eax,-0x78(%ebp)
  104dc0:	8b 45 94             	mov    -0x6c(%ebp),%eax
  104dc3:	89 45 84             	mov    %eax,-0x7c(%ebp)
    prev->next = next->prev = elm;
  104dc6:	8b 45 84             	mov    -0x7c(%ebp),%eax
  104dc9:	8b 55 8c             	mov    -0x74(%ebp),%edx
  104dcc:	89 10                	mov    %edx,(%eax)
  104dce:	8b 45 84             	mov    -0x7c(%ebp),%eax
  104dd1:	8b 10                	mov    (%eax),%edx
  104dd3:	8b 45 88             	mov    -0x78(%ebp),%eax
  104dd6:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
  104dd9:	8b 45 8c             	mov    -0x74(%ebp),%eax
  104ddc:	8b 55 84             	mov    -0x7c(%ebp),%edx
  104ddf:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
  104de2:	8b 45 8c             	mov    -0x74(%ebp),%eax
  104de5:	8b 55 88             	mov    -0x78(%ebp),%edx
  104de8:	89 10                	mov    %edx,(%eax)
}
  104dea:	90                   	nop
}
  104deb:	90                   	nop
}
  104dec:	90                   	nop
  104ded:	c9                   	leave  
  104dee:	c3                   	ret    

00104def <default_nr_free_pages>:

static size_t
default_nr_free_pages(void) {
  104def:	f3 0f 1e fb          	endbr32 
  104df3:	55                   	push   %ebp
  104df4:	89 e5                	mov    %esp,%ebp
    return nr_free;
  104df6:	a1 a8 0f 32 00       	mov    0x320fa8,%eax
}
  104dfb:	5d                   	pop    %ebp
  104dfc:	c3                   	ret    

00104dfd <basic_check>:

// default_check()调用了basic_check()
static void
basic_check(void) {
  104dfd:	f3 0f 1e fb          	endbr32 
  104e01:	55                   	push   %ebp
  104e02:	89 e5                	mov    %esp,%ebp
  104e04:	83 ec 48             	sub    $0x48,%esp
    struct Page *p0, *p1, *p2;
    p0 = p1 = p2 = NULL;
  104e07:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  104e0e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104e11:	89 45 f0             	mov    %eax,-0x10(%ebp)
  104e14:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104e17:	89 45 ec             	mov    %eax,-0x14(%ebp)
    assert((p0 = alloc_page()) != NULL);
  104e1a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  104e21:	e8 56 e2 ff ff       	call   10307c <alloc_pages>
  104e26:	89 45 ec             	mov    %eax,-0x14(%ebp)
  104e29:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  104e2d:	75 24                	jne    104e53 <basic_check+0x56>
  104e2f:	c7 44 24 0c 7c 86 10 	movl   $0x10867c,0xc(%esp)
  104e36:	00 
  104e37:	c7 44 24 08 fe 85 10 	movl   $0x1085fe,0x8(%esp)
  104e3e:	00 
  104e3f:	c7 44 24 04 e9 00 00 	movl   $0xe9,0x4(%esp)
  104e46:	00 
  104e47:	c7 04 24 13 86 10 00 	movl   $0x108613,(%esp)
  104e4e:	e8 de b5 ff ff       	call   100431 <__panic>
    assert((p1 = alloc_page()) != NULL);
  104e53:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  104e5a:	e8 1d e2 ff ff       	call   10307c <alloc_pages>
  104e5f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  104e62:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  104e66:	75 24                	jne    104e8c <basic_check+0x8f>
  104e68:	c7 44 24 0c 98 86 10 	movl   $0x108698,0xc(%esp)
  104e6f:	00 
  104e70:	c7 44 24 08 fe 85 10 	movl   $0x1085fe,0x8(%esp)
  104e77:	00 
  104e78:	c7 44 24 04 ea 00 00 	movl   $0xea,0x4(%esp)
  104e7f:	00 
  104e80:	c7 04 24 13 86 10 00 	movl   $0x108613,(%esp)
  104e87:	e8 a5 b5 ff ff       	call   100431 <__panic>
    assert((p2 = alloc_page()) != NULL);
  104e8c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  104e93:	e8 e4 e1 ff ff       	call   10307c <alloc_pages>
  104e98:	89 45 f4             	mov    %eax,-0xc(%ebp)
  104e9b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  104e9f:	75 24                	jne    104ec5 <basic_check+0xc8>
  104ea1:	c7 44 24 0c b4 86 10 	movl   $0x1086b4,0xc(%esp)
  104ea8:	00 
  104ea9:	c7 44 24 08 fe 85 10 	movl   $0x1085fe,0x8(%esp)
  104eb0:	00 
  104eb1:	c7 44 24 04 eb 00 00 	movl   $0xeb,0x4(%esp)
  104eb8:	00 
  104eb9:	c7 04 24 13 86 10 00 	movl   $0x108613,(%esp)
  104ec0:	e8 6c b5 ff ff       	call   100431 <__panic>

    assert(p0 != p1 && p0 != p2 && p1 != p2);
  104ec5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104ec8:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  104ecb:	74 10                	je     104edd <basic_check+0xe0>
  104ecd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104ed0:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  104ed3:	74 08                	je     104edd <basic_check+0xe0>
  104ed5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104ed8:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  104edb:	75 24                	jne    104f01 <basic_check+0x104>
  104edd:	c7 44 24 0c d0 86 10 	movl   $0x1086d0,0xc(%esp)
  104ee4:	00 
  104ee5:	c7 44 24 08 fe 85 10 	movl   $0x1085fe,0x8(%esp)
  104eec:	00 
  104eed:	c7 44 24 04 ed 00 00 	movl   $0xed,0x4(%esp)
  104ef4:	00 
  104ef5:	c7 04 24 13 86 10 00 	movl   $0x108613,(%esp)
  104efc:	e8 30 b5 ff ff       	call   100431 <__panic>
    assert(page_ref(p0) == 0 && page_ref(p1) == 0 && page_ref(p2) == 0);
  104f01:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104f04:	89 04 24             	mov    %eax,(%esp)
  104f07:	e8 6b f8 ff ff       	call   104777 <page_ref>
  104f0c:	85 c0                	test   %eax,%eax
  104f0e:	75 1e                	jne    104f2e <basic_check+0x131>
  104f10:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104f13:	89 04 24             	mov    %eax,(%esp)
  104f16:	e8 5c f8 ff ff       	call   104777 <page_ref>
  104f1b:	85 c0                	test   %eax,%eax
  104f1d:	75 0f                	jne    104f2e <basic_check+0x131>
  104f1f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104f22:	89 04 24             	mov    %eax,(%esp)
  104f25:	e8 4d f8 ff ff       	call   104777 <page_ref>
  104f2a:	85 c0                	test   %eax,%eax
  104f2c:	74 24                	je     104f52 <basic_check+0x155>
  104f2e:	c7 44 24 0c f4 86 10 	movl   $0x1086f4,0xc(%esp)
  104f35:	00 
  104f36:	c7 44 24 08 fe 85 10 	movl   $0x1085fe,0x8(%esp)
  104f3d:	00 
  104f3e:	c7 44 24 04 ee 00 00 	movl   $0xee,0x4(%esp)
  104f45:	00 
  104f46:	c7 04 24 13 86 10 00 	movl   $0x108613,(%esp)
  104f4d:	e8 df b4 ff ff       	call   100431 <__panic>

    assert(page2pa(p0) < npage * PGSIZE);
  104f52:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104f55:	89 04 24             	mov    %eax,(%esp)
  104f58:	e8 04 f8 ff ff       	call   104761 <page2pa>
  104f5d:	8b 15 80 0e 12 00    	mov    0x120e80,%edx
  104f63:	c1 e2 0c             	shl    $0xc,%edx
  104f66:	39 d0                	cmp    %edx,%eax
  104f68:	72 24                	jb     104f8e <basic_check+0x191>
  104f6a:	c7 44 24 0c 30 87 10 	movl   $0x108730,0xc(%esp)
  104f71:	00 
  104f72:	c7 44 24 08 fe 85 10 	movl   $0x1085fe,0x8(%esp)
  104f79:	00 
  104f7a:	c7 44 24 04 f0 00 00 	movl   $0xf0,0x4(%esp)
  104f81:	00 
  104f82:	c7 04 24 13 86 10 00 	movl   $0x108613,(%esp)
  104f89:	e8 a3 b4 ff ff       	call   100431 <__panic>
    assert(page2pa(p1) < npage * PGSIZE);
  104f8e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104f91:	89 04 24             	mov    %eax,(%esp)
  104f94:	e8 c8 f7 ff ff       	call   104761 <page2pa>
  104f99:	8b 15 80 0e 12 00    	mov    0x120e80,%edx
  104f9f:	c1 e2 0c             	shl    $0xc,%edx
  104fa2:	39 d0                	cmp    %edx,%eax
  104fa4:	72 24                	jb     104fca <basic_check+0x1cd>
  104fa6:	c7 44 24 0c 4d 87 10 	movl   $0x10874d,0xc(%esp)
  104fad:	00 
  104fae:	c7 44 24 08 fe 85 10 	movl   $0x1085fe,0x8(%esp)
  104fb5:	00 
  104fb6:	c7 44 24 04 f1 00 00 	movl   $0xf1,0x4(%esp)
  104fbd:	00 
  104fbe:	c7 04 24 13 86 10 00 	movl   $0x108613,(%esp)
  104fc5:	e8 67 b4 ff ff       	call   100431 <__panic>
    assert(page2pa(p2) < npage * PGSIZE);
  104fca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104fcd:	89 04 24             	mov    %eax,(%esp)
  104fd0:	e8 8c f7 ff ff       	call   104761 <page2pa>
  104fd5:	8b 15 80 0e 12 00    	mov    0x120e80,%edx
  104fdb:	c1 e2 0c             	shl    $0xc,%edx
  104fde:	39 d0                	cmp    %edx,%eax
  104fe0:	72 24                	jb     105006 <basic_check+0x209>
  104fe2:	c7 44 24 0c 6a 87 10 	movl   $0x10876a,0xc(%esp)
  104fe9:	00 
  104fea:	c7 44 24 08 fe 85 10 	movl   $0x1085fe,0x8(%esp)
  104ff1:	00 
  104ff2:	c7 44 24 04 f2 00 00 	movl   $0xf2,0x4(%esp)
  104ff9:	00 
  104ffa:	c7 04 24 13 86 10 00 	movl   $0x108613,(%esp)
  105001:	e8 2b b4 ff ff       	call   100431 <__panic>

    list_entry_t free_list_store = free_list;
  105006:	a1 a0 0f 32 00       	mov    0x320fa0,%eax
  10500b:	8b 15 a4 0f 32 00    	mov    0x320fa4,%edx
  105011:	89 45 d0             	mov    %eax,-0x30(%ebp)
  105014:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  105017:	c7 45 dc a0 0f 32 00 	movl   $0x320fa0,-0x24(%ebp)
    elm->prev = elm->next = elm;
  10501e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  105021:	8b 55 dc             	mov    -0x24(%ebp),%edx
  105024:	89 50 04             	mov    %edx,0x4(%eax)
  105027:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10502a:	8b 50 04             	mov    0x4(%eax),%edx
  10502d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  105030:	89 10                	mov    %edx,(%eax)
}
  105032:	90                   	nop
  105033:	c7 45 e0 a0 0f 32 00 	movl   $0x320fa0,-0x20(%ebp)
    return list->next == list;
  10503a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  10503d:	8b 40 04             	mov    0x4(%eax),%eax
  105040:	39 45 e0             	cmp    %eax,-0x20(%ebp)
  105043:	0f 94 c0             	sete   %al
  105046:	0f b6 c0             	movzbl %al,%eax
    list_init(&free_list);
    assert(list_empty(&free_list));
  105049:	85 c0                	test   %eax,%eax
  10504b:	75 24                	jne    105071 <basic_check+0x274>
  10504d:	c7 44 24 0c 87 87 10 	movl   $0x108787,0xc(%esp)
  105054:	00 
  105055:	c7 44 24 08 fe 85 10 	movl   $0x1085fe,0x8(%esp)
  10505c:	00 
  10505d:	c7 44 24 04 f6 00 00 	movl   $0xf6,0x4(%esp)
  105064:	00 
  105065:	c7 04 24 13 86 10 00 	movl   $0x108613,(%esp)
  10506c:	e8 c0 b3 ff ff       	call   100431 <__panic>

    unsigned int nr_free_store = nr_free;
  105071:	a1 a8 0f 32 00       	mov    0x320fa8,%eax
  105076:	89 45 e8             	mov    %eax,-0x18(%ebp)
    nr_free = 0;
  105079:	c7 05 a8 0f 32 00 00 	movl   $0x0,0x320fa8
  105080:	00 00 00 

    assert(alloc_page() == NULL);
  105083:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  10508a:	e8 ed df ff ff       	call   10307c <alloc_pages>
  10508f:	85 c0                	test   %eax,%eax
  105091:	74 24                	je     1050b7 <basic_check+0x2ba>
  105093:	c7 44 24 0c 9e 87 10 	movl   $0x10879e,0xc(%esp)
  10509a:	00 
  10509b:	c7 44 24 08 fe 85 10 	movl   $0x1085fe,0x8(%esp)
  1050a2:	00 
  1050a3:	c7 44 24 04 fb 00 00 	movl   $0xfb,0x4(%esp)
  1050aa:	00 
  1050ab:	c7 04 24 13 86 10 00 	movl   $0x108613,(%esp)
  1050b2:	e8 7a b3 ff ff       	call   100431 <__panic>

    free_page(p0);
  1050b7:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  1050be:	00 
  1050bf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1050c2:	89 04 24             	mov    %eax,(%esp)
  1050c5:	e8 ee df ff ff       	call   1030b8 <free_pages>
    free_page(p1);
  1050ca:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  1050d1:	00 
  1050d2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1050d5:	89 04 24             	mov    %eax,(%esp)
  1050d8:	e8 db df ff ff       	call   1030b8 <free_pages>
    free_page(p2);
  1050dd:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  1050e4:	00 
  1050e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1050e8:	89 04 24             	mov    %eax,(%esp)
  1050eb:	e8 c8 df ff ff       	call   1030b8 <free_pages>
    assert(nr_free == 3);
  1050f0:	a1 a8 0f 32 00       	mov    0x320fa8,%eax
  1050f5:	83 f8 03             	cmp    $0x3,%eax
  1050f8:	74 24                	je     10511e <basic_check+0x321>
  1050fa:	c7 44 24 0c b3 87 10 	movl   $0x1087b3,0xc(%esp)
  105101:	00 
  105102:	c7 44 24 08 fe 85 10 	movl   $0x1085fe,0x8(%esp)
  105109:	00 
  10510a:	c7 44 24 04 00 01 00 	movl   $0x100,0x4(%esp)
  105111:	00 
  105112:	c7 04 24 13 86 10 00 	movl   $0x108613,(%esp)
  105119:	e8 13 b3 ff ff       	call   100431 <__panic>

    assert((p0 = alloc_page()) != NULL);
  10511e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  105125:	e8 52 df ff ff       	call   10307c <alloc_pages>
  10512a:	89 45 ec             	mov    %eax,-0x14(%ebp)
  10512d:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  105131:	75 24                	jne    105157 <basic_check+0x35a>
  105133:	c7 44 24 0c 7c 86 10 	movl   $0x10867c,0xc(%esp)
  10513a:	00 
  10513b:	c7 44 24 08 fe 85 10 	movl   $0x1085fe,0x8(%esp)
  105142:	00 
  105143:	c7 44 24 04 02 01 00 	movl   $0x102,0x4(%esp)
  10514a:	00 
  10514b:	c7 04 24 13 86 10 00 	movl   $0x108613,(%esp)
  105152:	e8 da b2 ff ff       	call   100431 <__panic>
    assert((p1 = alloc_page()) != NULL);
  105157:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  10515e:	e8 19 df ff ff       	call   10307c <alloc_pages>
  105163:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105166:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  10516a:	75 24                	jne    105190 <basic_check+0x393>
  10516c:	c7 44 24 0c 98 86 10 	movl   $0x108698,0xc(%esp)
  105173:	00 
  105174:	c7 44 24 08 fe 85 10 	movl   $0x1085fe,0x8(%esp)
  10517b:	00 
  10517c:	c7 44 24 04 03 01 00 	movl   $0x103,0x4(%esp)
  105183:	00 
  105184:	c7 04 24 13 86 10 00 	movl   $0x108613,(%esp)
  10518b:	e8 a1 b2 ff ff       	call   100431 <__panic>
    assert((p2 = alloc_page()) != NULL);
  105190:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  105197:	e8 e0 de ff ff       	call   10307c <alloc_pages>
  10519c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  10519f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1051a3:	75 24                	jne    1051c9 <basic_check+0x3cc>
  1051a5:	c7 44 24 0c b4 86 10 	movl   $0x1086b4,0xc(%esp)
  1051ac:	00 
  1051ad:	c7 44 24 08 fe 85 10 	movl   $0x1085fe,0x8(%esp)
  1051b4:	00 
  1051b5:	c7 44 24 04 04 01 00 	movl   $0x104,0x4(%esp)
  1051bc:	00 
  1051bd:	c7 04 24 13 86 10 00 	movl   $0x108613,(%esp)
  1051c4:	e8 68 b2 ff ff       	call   100431 <__panic>

    assert(alloc_page() == NULL);
  1051c9:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1051d0:	e8 a7 de ff ff       	call   10307c <alloc_pages>
  1051d5:	85 c0                	test   %eax,%eax
  1051d7:	74 24                	je     1051fd <basic_check+0x400>
  1051d9:	c7 44 24 0c 9e 87 10 	movl   $0x10879e,0xc(%esp)
  1051e0:	00 
  1051e1:	c7 44 24 08 fe 85 10 	movl   $0x1085fe,0x8(%esp)
  1051e8:	00 
  1051e9:	c7 44 24 04 06 01 00 	movl   $0x106,0x4(%esp)
  1051f0:	00 
  1051f1:	c7 04 24 13 86 10 00 	movl   $0x108613,(%esp)
  1051f8:	e8 34 b2 ff ff       	call   100431 <__panic>

    free_page(p0);
  1051fd:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  105204:	00 
  105205:	8b 45 ec             	mov    -0x14(%ebp),%eax
  105208:	89 04 24             	mov    %eax,(%esp)
  10520b:	e8 a8 de ff ff       	call   1030b8 <free_pages>
  105210:	c7 45 d8 a0 0f 32 00 	movl   $0x320fa0,-0x28(%ebp)
  105217:	8b 45 d8             	mov    -0x28(%ebp),%eax
  10521a:	8b 40 04             	mov    0x4(%eax),%eax
  10521d:	39 45 d8             	cmp    %eax,-0x28(%ebp)
  105220:	0f 94 c0             	sete   %al
  105223:	0f b6 c0             	movzbl %al,%eax
    assert(!list_empty(&free_list));
  105226:	85 c0                	test   %eax,%eax
  105228:	74 24                	je     10524e <basic_check+0x451>
  10522a:	c7 44 24 0c c0 87 10 	movl   $0x1087c0,0xc(%esp)
  105231:	00 
  105232:	c7 44 24 08 fe 85 10 	movl   $0x1085fe,0x8(%esp)
  105239:	00 
  10523a:	c7 44 24 04 09 01 00 	movl   $0x109,0x4(%esp)
  105241:	00 
  105242:	c7 04 24 13 86 10 00 	movl   $0x108613,(%esp)
  105249:	e8 e3 b1 ff ff       	call   100431 <__panic>

    struct Page *p;
    assert((p = alloc_page()) == p0);
  10524e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  105255:	e8 22 de ff ff       	call   10307c <alloc_pages>
  10525a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  10525d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  105260:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  105263:	74 24                	je     105289 <basic_check+0x48c>
  105265:	c7 44 24 0c d8 87 10 	movl   $0x1087d8,0xc(%esp)
  10526c:	00 
  10526d:	c7 44 24 08 fe 85 10 	movl   $0x1085fe,0x8(%esp)
  105274:	00 
  105275:	c7 44 24 04 0c 01 00 	movl   $0x10c,0x4(%esp)
  10527c:	00 
  10527d:	c7 04 24 13 86 10 00 	movl   $0x108613,(%esp)
  105284:	e8 a8 b1 ff ff       	call   100431 <__panic>
    assert(alloc_page() == NULL);
  105289:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  105290:	e8 e7 dd ff ff       	call   10307c <alloc_pages>
  105295:	85 c0                	test   %eax,%eax
  105297:	74 24                	je     1052bd <basic_check+0x4c0>
  105299:	c7 44 24 0c 9e 87 10 	movl   $0x10879e,0xc(%esp)
  1052a0:	00 
  1052a1:	c7 44 24 08 fe 85 10 	movl   $0x1085fe,0x8(%esp)
  1052a8:	00 
  1052a9:	c7 44 24 04 0d 01 00 	movl   $0x10d,0x4(%esp)
  1052b0:	00 
  1052b1:	c7 04 24 13 86 10 00 	movl   $0x108613,(%esp)
  1052b8:	e8 74 b1 ff ff       	call   100431 <__panic>

    assert(nr_free == 0);
  1052bd:	a1 a8 0f 32 00       	mov    0x320fa8,%eax
  1052c2:	85 c0                	test   %eax,%eax
  1052c4:	74 24                	je     1052ea <basic_check+0x4ed>
  1052c6:	c7 44 24 0c f1 87 10 	movl   $0x1087f1,0xc(%esp)
  1052cd:	00 
  1052ce:	c7 44 24 08 fe 85 10 	movl   $0x1085fe,0x8(%esp)
  1052d5:	00 
  1052d6:	c7 44 24 04 0f 01 00 	movl   $0x10f,0x4(%esp)
  1052dd:	00 
  1052de:	c7 04 24 13 86 10 00 	movl   $0x108613,(%esp)
  1052e5:	e8 47 b1 ff ff       	call   100431 <__panic>
    free_list = free_list_store;
  1052ea:	8b 45 d0             	mov    -0x30(%ebp),%eax
  1052ed:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  1052f0:	a3 a0 0f 32 00       	mov    %eax,0x320fa0
  1052f5:	89 15 a4 0f 32 00    	mov    %edx,0x320fa4
    nr_free = nr_free_store;
  1052fb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1052fe:	a3 a8 0f 32 00       	mov    %eax,0x320fa8

    free_page(p);
  105303:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  10530a:	00 
  10530b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10530e:	89 04 24             	mov    %eax,(%esp)
  105311:	e8 a2 dd ff ff       	call   1030b8 <free_pages>
    free_page(p1);
  105316:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  10531d:	00 
  10531e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105321:	89 04 24             	mov    %eax,(%esp)
  105324:	e8 8f dd ff ff       	call   1030b8 <free_pages>
    free_page(p2);
  105329:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  105330:	00 
  105331:	8b 45 f4             	mov    -0xc(%ebp),%eax
  105334:	89 04 24             	mov    %eax,(%esp)
  105337:	e8 7c dd ff ff       	call   1030b8 <free_pages>
}
  10533c:	90                   	nop
  10533d:	c9                   	leave  
  10533e:	c3                   	ret    

0010533f <default_check>:
// 在pmm.c中的void check_alloc_page()调用了pmm_manager->check()

// LAB2: below code is used to check the first fit allocation algorithm (your EXERCISE 1) 
// NOTICE: You SHOULD NOT CHANGE basic_check, default_check functions!
static void
default_check(void) {
  10533f:	f3 0f 1e fb          	endbr32 
  105343:	55                   	push   %ebp
  105344:	89 e5                	mov    %esp,%ebp
  105346:	81 ec 98 00 00 00    	sub    $0x98,%esp
    int count = 0, total = 0;
  10534c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  105353:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    list_entry_t *le = &free_list;
  10535a:	c7 45 ec a0 0f 32 00 	movl   $0x320fa0,-0x14(%ebp)
    while ((le = list_next(le)) != &free_list) {
  105361:	eb 6a                	jmp    1053cd <default_check+0x8e>
        struct Page *p = le2page(le, page_link);
  105363:	8b 45 ec             	mov    -0x14(%ebp),%eax
  105366:	83 e8 0c             	sub    $0xc,%eax
  105369:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        assert(PageProperty(p));
  10536c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  10536f:	83 c0 04             	add    $0x4,%eax
  105372:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
  105379:	89 45 cc             	mov    %eax,-0x34(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  10537c:	8b 45 cc             	mov    -0x34(%ebp),%eax
  10537f:	8b 55 d0             	mov    -0x30(%ebp),%edx
  105382:	0f a3 10             	bt     %edx,(%eax)
  105385:	19 c0                	sbb    %eax,%eax
  105387:	89 45 c8             	mov    %eax,-0x38(%ebp)
    return oldbit != 0;
  10538a:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  10538e:	0f 95 c0             	setne  %al
  105391:	0f b6 c0             	movzbl %al,%eax
  105394:	85 c0                	test   %eax,%eax
  105396:	75 24                	jne    1053bc <default_check+0x7d>
  105398:	c7 44 24 0c fe 87 10 	movl   $0x1087fe,0xc(%esp)
  10539f:	00 
  1053a0:	c7 44 24 08 fe 85 10 	movl   $0x1085fe,0x8(%esp)
  1053a7:	00 
  1053a8:	c7 44 24 04 25 01 00 	movl   $0x125,0x4(%esp)
  1053af:	00 
  1053b0:	c7 04 24 13 86 10 00 	movl   $0x108613,(%esp)
  1053b7:	e8 75 b0 ff ff       	call   100431 <__panic>
        count ++, total += p->property;
  1053bc:	ff 45 f4             	incl   -0xc(%ebp)
  1053bf:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1053c2:	8b 50 08             	mov    0x8(%eax),%edx
  1053c5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1053c8:	01 d0                	add    %edx,%eax
  1053ca:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1053cd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1053d0:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    return listelm->next;
  1053d3:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  1053d6:	8b 40 04             	mov    0x4(%eax),%eax
    while ((le = list_next(le)) != &free_list) {
  1053d9:	89 45 ec             	mov    %eax,-0x14(%ebp)
  1053dc:	81 7d ec a0 0f 32 00 	cmpl   $0x320fa0,-0x14(%ebp)
  1053e3:	0f 85 7a ff ff ff    	jne    105363 <default_check+0x24>
    }
    assert(total == nr_free_pages());
  1053e9:	e8 01 dd ff ff       	call   1030ef <nr_free_pages>
  1053ee:	8b 55 f0             	mov    -0x10(%ebp),%edx
  1053f1:	39 d0                	cmp    %edx,%eax
  1053f3:	74 24                	je     105419 <default_check+0xda>
  1053f5:	c7 44 24 0c 0e 88 10 	movl   $0x10880e,0xc(%esp)
  1053fc:	00 
  1053fd:	c7 44 24 08 fe 85 10 	movl   $0x1085fe,0x8(%esp)
  105404:	00 
  105405:	c7 44 24 04 28 01 00 	movl   $0x128,0x4(%esp)
  10540c:	00 
  10540d:	c7 04 24 13 86 10 00 	movl   $0x108613,(%esp)
  105414:	e8 18 b0 ff ff       	call   100431 <__panic>

    basic_check();
  105419:	e8 df f9 ff ff       	call   104dfd <basic_check>

    struct Page *p0 = alloc_pages(5), *p1, *p2;
  10541e:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
  105425:	e8 52 dc ff ff       	call   10307c <alloc_pages>
  10542a:	89 45 e8             	mov    %eax,-0x18(%ebp)
    assert(p0 != NULL);
  10542d:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  105431:	75 24                	jne    105457 <default_check+0x118>
  105433:	c7 44 24 0c 27 88 10 	movl   $0x108827,0xc(%esp)
  10543a:	00 
  10543b:	c7 44 24 08 fe 85 10 	movl   $0x1085fe,0x8(%esp)
  105442:	00 
  105443:	c7 44 24 04 2d 01 00 	movl   $0x12d,0x4(%esp)
  10544a:	00 
  10544b:	c7 04 24 13 86 10 00 	movl   $0x108613,(%esp)
  105452:	e8 da af ff ff       	call   100431 <__panic>
    assert(!PageProperty(p0));
  105457:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10545a:	83 c0 04             	add    $0x4,%eax
  10545d:	c7 45 c0 01 00 00 00 	movl   $0x1,-0x40(%ebp)
  105464:	89 45 bc             	mov    %eax,-0x44(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  105467:	8b 45 bc             	mov    -0x44(%ebp),%eax
  10546a:	8b 55 c0             	mov    -0x40(%ebp),%edx
  10546d:	0f a3 10             	bt     %edx,(%eax)
  105470:	19 c0                	sbb    %eax,%eax
  105472:	89 45 b8             	mov    %eax,-0x48(%ebp)
    return oldbit != 0;
  105475:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
  105479:	0f 95 c0             	setne  %al
  10547c:	0f b6 c0             	movzbl %al,%eax
  10547f:	85 c0                	test   %eax,%eax
  105481:	74 24                	je     1054a7 <default_check+0x168>
  105483:	c7 44 24 0c 32 88 10 	movl   $0x108832,0xc(%esp)
  10548a:	00 
  10548b:	c7 44 24 08 fe 85 10 	movl   $0x1085fe,0x8(%esp)
  105492:	00 
  105493:	c7 44 24 04 2e 01 00 	movl   $0x12e,0x4(%esp)
  10549a:	00 
  10549b:	c7 04 24 13 86 10 00 	movl   $0x108613,(%esp)
  1054a2:	e8 8a af ff ff       	call   100431 <__panic>

    list_entry_t free_list_store = free_list;
  1054a7:	a1 a0 0f 32 00       	mov    0x320fa0,%eax
  1054ac:	8b 15 a4 0f 32 00    	mov    0x320fa4,%edx
  1054b2:	89 45 80             	mov    %eax,-0x80(%ebp)
  1054b5:	89 55 84             	mov    %edx,-0x7c(%ebp)
  1054b8:	c7 45 b0 a0 0f 32 00 	movl   $0x320fa0,-0x50(%ebp)
    elm->prev = elm->next = elm;
  1054bf:	8b 45 b0             	mov    -0x50(%ebp),%eax
  1054c2:	8b 55 b0             	mov    -0x50(%ebp),%edx
  1054c5:	89 50 04             	mov    %edx,0x4(%eax)
  1054c8:	8b 45 b0             	mov    -0x50(%ebp),%eax
  1054cb:	8b 50 04             	mov    0x4(%eax),%edx
  1054ce:	8b 45 b0             	mov    -0x50(%ebp),%eax
  1054d1:	89 10                	mov    %edx,(%eax)
}
  1054d3:	90                   	nop
  1054d4:	c7 45 b4 a0 0f 32 00 	movl   $0x320fa0,-0x4c(%ebp)
    return list->next == list;
  1054db:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  1054de:	8b 40 04             	mov    0x4(%eax),%eax
  1054e1:	39 45 b4             	cmp    %eax,-0x4c(%ebp)
  1054e4:	0f 94 c0             	sete   %al
  1054e7:	0f b6 c0             	movzbl %al,%eax
    list_init(&free_list);
    assert(list_empty(&free_list));
  1054ea:	85 c0                	test   %eax,%eax
  1054ec:	75 24                	jne    105512 <default_check+0x1d3>
  1054ee:	c7 44 24 0c 87 87 10 	movl   $0x108787,0xc(%esp)
  1054f5:	00 
  1054f6:	c7 44 24 08 fe 85 10 	movl   $0x1085fe,0x8(%esp)
  1054fd:	00 
  1054fe:	c7 44 24 04 32 01 00 	movl   $0x132,0x4(%esp)
  105505:	00 
  105506:	c7 04 24 13 86 10 00 	movl   $0x108613,(%esp)
  10550d:	e8 1f af ff ff       	call   100431 <__panic>
    assert(alloc_page() == NULL);
  105512:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  105519:	e8 5e db ff ff       	call   10307c <alloc_pages>
  10551e:	85 c0                	test   %eax,%eax
  105520:	74 24                	je     105546 <default_check+0x207>
  105522:	c7 44 24 0c 9e 87 10 	movl   $0x10879e,0xc(%esp)
  105529:	00 
  10552a:	c7 44 24 08 fe 85 10 	movl   $0x1085fe,0x8(%esp)
  105531:	00 
  105532:	c7 44 24 04 33 01 00 	movl   $0x133,0x4(%esp)
  105539:	00 
  10553a:	c7 04 24 13 86 10 00 	movl   $0x108613,(%esp)
  105541:	e8 eb ae ff ff       	call   100431 <__panic>

    unsigned int nr_free_store = nr_free;
  105546:	a1 a8 0f 32 00       	mov    0x320fa8,%eax
  10554b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    nr_free = 0;
  10554e:	c7 05 a8 0f 32 00 00 	movl   $0x0,0x320fa8
  105555:	00 00 00 

    free_pages(p0 + 2, 3);
  105558:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10555b:	83 c0 28             	add    $0x28,%eax
  10555e:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
  105565:	00 
  105566:	89 04 24             	mov    %eax,(%esp)
  105569:	e8 4a db ff ff       	call   1030b8 <free_pages>
    assert(alloc_pages(4) == NULL);
  10556e:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
  105575:	e8 02 db ff ff       	call   10307c <alloc_pages>
  10557a:	85 c0                	test   %eax,%eax
  10557c:	74 24                	je     1055a2 <default_check+0x263>
  10557e:	c7 44 24 0c 44 88 10 	movl   $0x108844,0xc(%esp)
  105585:	00 
  105586:	c7 44 24 08 fe 85 10 	movl   $0x1085fe,0x8(%esp)
  10558d:	00 
  10558e:	c7 44 24 04 39 01 00 	movl   $0x139,0x4(%esp)
  105595:	00 
  105596:	c7 04 24 13 86 10 00 	movl   $0x108613,(%esp)
  10559d:	e8 8f ae ff ff       	call   100431 <__panic>
    assert(PageProperty(p0 + 2) && p0[2].property == 3);
  1055a2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1055a5:	83 c0 28             	add    $0x28,%eax
  1055a8:	83 c0 04             	add    $0x4,%eax
  1055ab:	c7 45 ac 01 00 00 00 	movl   $0x1,-0x54(%ebp)
  1055b2:	89 45 a8             	mov    %eax,-0x58(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  1055b5:	8b 45 a8             	mov    -0x58(%ebp),%eax
  1055b8:	8b 55 ac             	mov    -0x54(%ebp),%edx
  1055bb:	0f a3 10             	bt     %edx,(%eax)
  1055be:	19 c0                	sbb    %eax,%eax
  1055c0:	89 45 a4             	mov    %eax,-0x5c(%ebp)
    return oldbit != 0;
  1055c3:	83 7d a4 00          	cmpl   $0x0,-0x5c(%ebp)
  1055c7:	0f 95 c0             	setne  %al
  1055ca:	0f b6 c0             	movzbl %al,%eax
  1055cd:	85 c0                	test   %eax,%eax
  1055cf:	74 0e                	je     1055df <default_check+0x2a0>
  1055d1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1055d4:	83 c0 28             	add    $0x28,%eax
  1055d7:	8b 40 08             	mov    0x8(%eax),%eax
  1055da:	83 f8 03             	cmp    $0x3,%eax
  1055dd:	74 24                	je     105603 <default_check+0x2c4>
  1055df:	c7 44 24 0c 5c 88 10 	movl   $0x10885c,0xc(%esp)
  1055e6:	00 
  1055e7:	c7 44 24 08 fe 85 10 	movl   $0x1085fe,0x8(%esp)
  1055ee:	00 
  1055ef:	c7 44 24 04 3a 01 00 	movl   $0x13a,0x4(%esp)
  1055f6:	00 
  1055f7:	c7 04 24 13 86 10 00 	movl   $0x108613,(%esp)
  1055fe:	e8 2e ae ff ff       	call   100431 <__panic>
    assert((p1 = alloc_pages(3)) != NULL);
  105603:	c7 04 24 03 00 00 00 	movl   $0x3,(%esp)
  10560a:	e8 6d da ff ff       	call   10307c <alloc_pages>
  10560f:	89 45 e0             	mov    %eax,-0x20(%ebp)
  105612:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  105616:	75 24                	jne    10563c <default_check+0x2fd>
  105618:	c7 44 24 0c 88 88 10 	movl   $0x108888,0xc(%esp)
  10561f:	00 
  105620:	c7 44 24 08 fe 85 10 	movl   $0x1085fe,0x8(%esp)
  105627:	00 
  105628:	c7 44 24 04 3b 01 00 	movl   $0x13b,0x4(%esp)
  10562f:	00 
  105630:	c7 04 24 13 86 10 00 	movl   $0x108613,(%esp)
  105637:	e8 f5 ad ff ff       	call   100431 <__panic>
    assert(alloc_page() == NULL);
  10563c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  105643:	e8 34 da ff ff       	call   10307c <alloc_pages>
  105648:	85 c0                	test   %eax,%eax
  10564a:	74 24                	je     105670 <default_check+0x331>
  10564c:	c7 44 24 0c 9e 87 10 	movl   $0x10879e,0xc(%esp)
  105653:	00 
  105654:	c7 44 24 08 fe 85 10 	movl   $0x1085fe,0x8(%esp)
  10565b:	00 
  10565c:	c7 44 24 04 3c 01 00 	movl   $0x13c,0x4(%esp)
  105663:	00 
  105664:	c7 04 24 13 86 10 00 	movl   $0x108613,(%esp)
  10566b:	e8 c1 ad ff ff       	call   100431 <__panic>
    assert(p0 + 2 == p1);
  105670:	8b 45 e8             	mov    -0x18(%ebp),%eax
  105673:	83 c0 28             	add    $0x28,%eax
  105676:	39 45 e0             	cmp    %eax,-0x20(%ebp)
  105679:	74 24                	je     10569f <default_check+0x360>
  10567b:	c7 44 24 0c a6 88 10 	movl   $0x1088a6,0xc(%esp)
  105682:	00 
  105683:	c7 44 24 08 fe 85 10 	movl   $0x1085fe,0x8(%esp)
  10568a:	00 
  10568b:	c7 44 24 04 3d 01 00 	movl   $0x13d,0x4(%esp)
  105692:	00 
  105693:	c7 04 24 13 86 10 00 	movl   $0x108613,(%esp)
  10569a:	e8 92 ad ff ff       	call   100431 <__panic>

    p2 = p0 + 1;
  10569f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1056a2:	83 c0 14             	add    $0x14,%eax
  1056a5:	89 45 dc             	mov    %eax,-0x24(%ebp)
    free_page(p0);
  1056a8:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  1056af:	00 
  1056b0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1056b3:	89 04 24             	mov    %eax,(%esp)
  1056b6:	e8 fd d9 ff ff       	call   1030b8 <free_pages>
    free_pages(p1, 3);
  1056bb:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
  1056c2:	00 
  1056c3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1056c6:	89 04 24             	mov    %eax,(%esp)
  1056c9:	e8 ea d9 ff ff       	call   1030b8 <free_pages>
    assert(PageProperty(p0) && p0->property == 1);
  1056ce:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1056d1:	83 c0 04             	add    $0x4,%eax
  1056d4:	c7 45 a0 01 00 00 00 	movl   $0x1,-0x60(%ebp)
  1056db:	89 45 9c             	mov    %eax,-0x64(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  1056de:	8b 45 9c             	mov    -0x64(%ebp),%eax
  1056e1:	8b 55 a0             	mov    -0x60(%ebp),%edx
  1056e4:	0f a3 10             	bt     %edx,(%eax)
  1056e7:	19 c0                	sbb    %eax,%eax
  1056e9:	89 45 98             	mov    %eax,-0x68(%ebp)
    return oldbit != 0;
  1056ec:	83 7d 98 00          	cmpl   $0x0,-0x68(%ebp)
  1056f0:	0f 95 c0             	setne  %al
  1056f3:	0f b6 c0             	movzbl %al,%eax
  1056f6:	85 c0                	test   %eax,%eax
  1056f8:	74 0b                	je     105705 <default_check+0x3c6>
  1056fa:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1056fd:	8b 40 08             	mov    0x8(%eax),%eax
  105700:	83 f8 01             	cmp    $0x1,%eax
  105703:	74 24                	je     105729 <default_check+0x3ea>
  105705:	c7 44 24 0c b4 88 10 	movl   $0x1088b4,0xc(%esp)
  10570c:	00 
  10570d:	c7 44 24 08 fe 85 10 	movl   $0x1085fe,0x8(%esp)
  105714:	00 
  105715:	c7 44 24 04 42 01 00 	movl   $0x142,0x4(%esp)
  10571c:	00 
  10571d:	c7 04 24 13 86 10 00 	movl   $0x108613,(%esp)
  105724:	e8 08 ad ff ff       	call   100431 <__panic>
    assert(PageProperty(p1) && p1->property == 3);
  105729:	8b 45 e0             	mov    -0x20(%ebp),%eax
  10572c:	83 c0 04             	add    $0x4,%eax
  10572f:	c7 45 94 01 00 00 00 	movl   $0x1,-0x6c(%ebp)
  105736:	89 45 90             	mov    %eax,-0x70(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  105739:	8b 45 90             	mov    -0x70(%ebp),%eax
  10573c:	8b 55 94             	mov    -0x6c(%ebp),%edx
  10573f:	0f a3 10             	bt     %edx,(%eax)
  105742:	19 c0                	sbb    %eax,%eax
  105744:	89 45 8c             	mov    %eax,-0x74(%ebp)
    return oldbit != 0;
  105747:	83 7d 8c 00          	cmpl   $0x0,-0x74(%ebp)
  10574b:	0f 95 c0             	setne  %al
  10574e:	0f b6 c0             	movzbl %al,%eax
  105751:	85 c0                	test   %eax,%eax
  105753:	74 0b                	je     105760 <default_check+0x421>
  105755:	8b 45 e0             	mov    -0x20(%ebp),%eax
  105758:	8b 40 08             	mov    0x8(%eax),%eax
  10575b:	83 f8 03             	cmp    $0x3,%eax
  10575e:	74 24                	je     105784 <default_check+0x445>
  105760:	c7 44 24 0c dc 88 10 	movl   $0x1088dc,0xc(%esp)
  105767:	00 
  105768:	c7 44 24 08 fe 85 10 	movl   $0x1085fe,0x8(%esp)
  10576f:	00 
  105770:	c7 44 24 04 43 01 00 	movl   $0x143,0x4(%esp)
  105777:	00 
  105778:	c7 04 24 13 86 10 00 	movl   $0x108613,(%esp)
  10577f:	e8 ad ac ff ff       	call   100431 <__panic>

    assert((p0 = alloc_page()) == p2 - 1);
  105784:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  10578b:	e8 ec d8 ff ff       	call   10307c <alloc_pages>
  105790:	89 45 e8             	mov    %eax,-0x18(%ebp)
  105793:	8b 45 dc             	mov    -0x24(%ebp),%eax
  105796:	83 e8 14             	sub    $0x14,%eax
  105799:	39 45 e8             	cmp    %eax,-0x18(%ebp)
  10579c:	74 24                	je     1057c2 <default_check+0x483>
  10579e:	c7 44 24 0c 02 89 10 	movl   $0x108902,0xc(%esp)
  1057a5:	00 
  1057a6:	c7 44 24 08 fe 85 10 	movl   $0x1085fe,0x8(%esp)
  1057ad:	00 
  1057ae:	c7 44 24 04 45 01 00 	movl   $0x145,0x4(%esp)
  1057b5:	00 
  1057b6:	c7 04 24 13 86 10 00 	movl   $0x108613,(%esp)
  1057bd:	e8 6f ac ff ff       	call   100431 <__panic>
    free_page(p0);
  1057c2:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  1057c9:	00 
  1057ca:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1057cd:	89 04 24             	mov    %eax,(%esp)
  1057d0:	e8 e3 d8 ff ff       	call   1030b8 <free_pages>
    assert((p0 = alloc_pages(2)) == p2 + 1);
  1057d5:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  1057dc:	e8 9b d8 ff ff       	call   10307c <alloc_pages>
  1057e1:	89 45 e8             	mov    %eax,-0x18(%ebp)
  1057e4:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1057e7:	83 c0 14             	add    $0x14,%eax
  1057ea:	39 45 e8             	cmp    %eax,-0x18(%ebp)
  1057ed:	74 24                	je     105813 <default_check+0x4d4>
  1057ef:	c7 44 24 0c 20 89 10 	movl   $0x108920,0xc(%esp)
  1057f6:	00 
  1057f7:	c7 44 24 08 fe 85 10 	movl   $0x1085fe,0x8(%esp)
  1057fe:	00 
  1057ff:	c7 44 24 04 47 01 00 	movl   $0x147,0x4(%esp)
  105806:	00 
  105807:	c7 04 24 13 86 10 00 	movl   $0x108613,(%esp)
  10580e:	e8 1e ac ff ff       	call   100431 <__panic>

    free_pages(p0, 2);
  105813:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
  10581a:	00 
  10581b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10581e:	89 04 24             	mov    %eax,(%esp)
  105821:	e8 92 d8 ff ff       	call   1030b8 <free_pages>
    free_page(p2);
  105826:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  10582d:	00 
  10582e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  105831:	89 04 24             	mov    %eax,(%esp)
  105834:	e8 7f d8 ff ff       	call   1030b8 <free_pages>

    assert((p0 = alloc_pages(5)) != NULL);
  105839:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
  105840:	e8 37 d8 ff ff       	call   10307c <alloc_pages>
  105845:	89 45 e8             	mov    %eax,-0x18(%ebp)
  105848:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  10584c:	75 24                	jne    105872 <default_check+0x533>
  10584e:	c7 44 24 0c 40 89 10 	movl   $0x108940,0xc(%esp)
  105855:	00 
  105856:	c7 44 24 08 fe 85 10 	movl   $0x1085fe,0x8(%esp)
  10585d:	00 
  10585e:	c7 44 24 04 4c 01 00 	movl   $0x14c,0x4(%esp)
  105865:	00 
  105866:	c7 04 24 13 86 10 00 	movl   $0x108613,(%esp)
  10586d:	e8 bf ab ff ff       	call   100431 <__panic>
    assert(alloc_page() == NULL);
  105872:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  105879:	e8 fe d7 ff ff       	call   10307c <alloc_pages>
  10587e:	85 c0                	test   %eax,%eax
  105880:	74 24                	je     1058a6 <default_check+0x567>
  105882:	c7 44 24 0c 9e 87 10 	movl   $0x10879e,0xc(%esp)
  105889:	00 
  10588a:	c7 44 24 08 fe 85 10 	movl   $0x1085fe,0x8(%esp)
  105891:	00 
  105892:	c7 44 24 04 4d 01 00 	movl   $0x14d,0x4(%esp)
  105899:	00 
  10589a:	c7 04 24 13 86 10 00 	movl   $0x108613,(%esp)
  1058a1:	e8 8b ab ff ff       	call   100431 <__panic>

    assert(nr_free == 0);
  1058a6:	a1 a8 0f 32 00       	mov    0x320fa8,%eax
  1058ab:	85 c0                	test   %eax,%eax
  1058ad:	74 24                	je     1058d3 <default_check+0x594>
  1058af:	c7 44 24 0c f1 87 10 	movl   $0x1087f1,0xc(%esp)
  1058b6:	00 
  1058b7:	c7 44 24 08 fe 85 10 	movl   $0x1085fe,0x8(%esp)
  1058be:	00 
  1058bf:	c7 44 24 04 4f 01 00 	movl   $0x14f,0x4(%esp)
  1058c6:	00 
  1058c7:	c7 04 24 13 86 10 00 	movl   $0x108613,(%esp)
  1058ce:	e8 5e ab ff ff       	call   100431 <__panic>
    nr_free = nr_free_store;
  1058d3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1058d6:	a3 a8 0f 32 00       	mov    %eax,0x320fa8

    free_list = free_list_store;
  1058db:	8b 45 80             	mov    -0x80(%ebp),%eax
  1058de:	8b 55 84             	mov    -0x7c(%ebp),%edx
  1058e1:	a3 a0 0f 32 00       	mov    %eax,0x320fa0
  1058e6:	89 15 a4 0f 32 00    	mov    %edx,0x320fa4
    free_pages(p0, 5);
  1058ec:	c7 44 24 04 05 00 00 	movl   $0x5,0x4(%esp)
  1058f3:	00 
  1058f4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1058f7:	89 04 24             	mov    %eax,(%esp)
  1058fa:	e8 b9 d7 ff ff       	call   1030b8 <free_pages>

    le = &free_list;
  1058ff:	c7 45 ec a0 0f 32 00 	movl   $0x320fa0,-0x14(%ebp)
    while ((le = list_next(le)) != &free_list) {
  105906:	eb 5a                	jmp    105962 <default_check+0x623>
        assert(le->next->prev == le && le->prev->next == le);
  105908:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10590b:	8b 40 04             	mov    0x4(%eax),%eax
  10590e:	8b 00                	mov    (%eax),%eax
  105910:	39 45 ec             	cmp    %eax,-0x14(%ebp)
  105913:	75 0d                	jne    105922 <default_check+0x5e3>
  105915:	8b 45 ec             	mov    -0x14(%ebp),%eax
  105918:	8b 00                	mov    (%eax),%eax
  10591a:	8b 40 04             	mov    0x4(%eax),%eax
  10591d:	39 45 ec             	cmp    %eax,-0x14(%ebp)
  105920:	74 24                	je     105946 <default_check+0x607>
  105922:	c7 44 24 0c 60 89 10 	movl   $0x108960,0xc(%esp)
  105929:	00 
  10592a:	c7 44 24 08 fe 85 10 	movl   $0x1085fe,0x8(%esp)
  105931:	00 
  105932:	c7 44 24 04 57 01 00 	movl   $0x157,0x4(%esp)
  105939:	00 
  10593a:	c7 04 24 13 86 10 00 	movl   $0x108613,(%esp)
  105941:	e8 eb aa ff ff       	call   100431 <__panic>
        struct Page *p = le2page(le, page_link);
  105946:	8b 45 ec             	mov    -0x14(%ebp),%eax
  105949:	83 e8 0c             	sub    $0xc,%eax
  10594c:	89 45 d8             	mov    %eax,-0x28(%ebp)
        count --, total -= p->property;
  10594f:	ff 4d f4             	decl   -0xc(%ebp)
  105952:	8b 55 f0             	mov    -0x10(%ebp),%edx
  105955:	8b 45 d8             	mov    -0x28(%ebp),%eax
  105958:	8b 40 08             	mov    0x8(%eax),%eax
  10595b:	29 c2                	sub    %eax,%edx
  10595d:	89 d0                	mov    %edx,%eax
  10595f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105962:	8b 45 ec             	mov    -0x14(%ebp),%eax
  105965:	89 45 88             	mov    %eax,-0x78(%ebp)
    return listelm->next;
  105968:	8b 45 88             	mov    -0x78(%ebp),%eax
  10596b:	8b 40 04             	mov    0x4(%eax),%eax
    while ((le = list_next(le)) != &free_list) {
  10596e:	89 45 ec             	mov    %eax,-0x14(%ebp)
  105971:	81 7d ec a0 0f 32 00 	cmpl   $0x320fa0,-0x14(%ebp)
  105978:	75 8e                	jne    105908 <default_check+0x5c9>
    }
    assert(count == 0);
  10597a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  10597e:	74 24                	je     1059a4 <default_check+0x665>
  105980:	c7 44 24 0c 8d 89 10 	movl   $0x10898d,0xc(%esp)
  105987:	00 
  105988:	c7 44 24 08 fe 85 10 	movl   $0x1085fe,0x8(%esp)
  10598f:	00 
  105990:	c7 44 24 04 5b 01 00 	movl   $0x15b,0x4(%esp)
  105997:	00 
  105998:	c7 04 24 13 86 10 00 	movl   $0x108613,(%esp)
  10599f:	e8 8d aa ff ff       	call   100431 <__panic>
    assert(total == 0);
  1059a4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  1059a8:	74 24                	je     1059ce <default_check+0x68f>
  1059aa:	c7 44 24 0c 98 89 10 	movl   $0x108998,0xc(%esp)
  1059b1:	00 
  1059b2:	c7 44 24 08 fe 85 10 	movl   $0x1085fe,0x8(%esp)
  1059b9:	00 
  1059ba:	c7 44 24 04 5c 01 00 	movl   $0x15c,0x4(%esp)
  1059c1:	00 
  1059c2:	c7 04 24 13 86 10 00 	movl   $0x108613,(%esp)
  1059c9:	e8 63 aa ff ff       	call   100431 <__panic>
}
  1059ce:	90                   	nop
  1059cf:	c9                   	leave  
  1059d0:	c3                   	ret    

001059d1 <page_ref>:
page_ref(struct Page *page) {
  1059d1:	55                   	push   %ebp
  1059d2:	89 e5                	mov    %esp,%ebp
    return page->ref;
  1059d4:	8b 45 08             	mov    0x8(%ebp),%eax
  1059d7:	8b 00                	mov    (%eax),%eax
}
  1059d9:	5d                   	pop    %ebp
  1059da:	c3                   	ret    

001059db <set_page_ref>:
set_page_ref(struct Page *page, int val) {
  1059db:	55                   	push   %ebp
  1059dc:	89 e5                	mov    %esp,%ebp
    page->ref = val;
  1059de:	8b 45 08             	mov    0x8(%ebp),%eax
  1059e1:	8b 55 0c             	mov    0xc(%ebp),%edx
  1059e4:	89 10                	mov    %edx,(%eax)
}
  1059e6:	90                   	nop
  1059e7:	5d                   	pop    %ebp
  1059e8:	c3                   	ret    

001059e9 <fixsize>:
// 简化使用
#define free_list(n) (free_area[(n)].free_list)
#define nr_free(n) (free_area[(n)].nr_free)

// 大于size的2的次幂
static unsigned fixsize(unsigned size) {
  1059e9:	f3 0f 1e fb          	endbr32 
  1059ed:	55                   	push   %ebp
  1059ee:	89 e5                	mov    %esp,%ebp
  	size |= size >> 1;
  1059f0:	8b 45 08             	mov    0x8(%ebp),%eax
  1059f3:	d1 e8                	shr    %eax
  1059f5:	09 45 08             	or     %eax,0x8(%ebp)
  	size |= size >> 2;
  1059f8:	8b 45 08             	mov    0x8(%ebp),%eax
  1059fb:	c1 e8 02             	shr    $0x2,%eax
  1059fe:	09 45 08             	or     %eax,0x8(%ebp)
  	size |= size >> 4;
  105a01:	8b 45 08             	mov    0x8(%ebp),%eax
  105a04:	c1 e8 04             	shr    $0x4,%eax
  105a07:	09 45 08             	or     %eax,0x8(%ebp)
  	size |= size >> 8;
  105a0a:	8b 45 08             	mov    0x8(%ebp),%eax
  105a0d:	c1 e8 08             	shr    $0x8,%eax
  105a10:	09 45 08             	or     %eax,0x8(%ebp)
  	size |= size >> 16;
  105a13:	8b 45 08             	mov    0x8(%ebp),%eax
  105a16:	c1 e8 10             	shr    $0x10,%eax
  105a19:	09 45 08             	or     %eax,0x8(%ebp)
  	return size + 1;
  105a1c:	8b 45 08             	mov    0x8(%ebp),%eax
  105a1f:	40                   	inc    %eax
}
  105a20:	5d                   	pop    %ebp
  105a21:	c3                   	ret    

00105a22 <log>:

// 阶数
static unsigned log(unsigned size) {
  105a22:	f3 0f 1e fb          	endbr32 
  105a26:	55                   	push   %ebp
  105a27:	89 e5                	mov    %esp,%ebp
  105a29:	83 ec 28             	sub    $0x28,%esp
	assert(IS_POWER_OF_2(size));
  105a2c:	8b 45 08             	mov    0x8(%ebp),%eax
  105a2f:	48                   	dec    %eax
  105a30:	23 45 08             	and    0x8(%ebp),%eax
  105a33:	85 c0                	test   %eax,%eax
  105a35:	74 24                	je     105a5b <log+0x39>
  105a37:	c7 44 24 0c d4 89 10 	movl   $0x1089d4,0xc(%esp)
  105a3e:	00 
  105a3f:	c7 44 24 08 e8 89 10 	movl   $0x1089e8,0x8(%esp)
  105a46:	00 
  105a47:	c7 44 24 04 2c 00 00 	movl   $0x2c,0x4(%esp)
  105a4e:	00 
  105a4f:	c7 04 24 fd 89 10 00 	movl   $0x1089fd,(%esp)
  105a56:	e8 d6 a9 ff ff       	call   100431 <__panic>
	unsigned i = 0;
  105a5b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (;i <= MAX_LENGTH_LOG; i++) {
  105a62:	eb 1d                	jmp    105a81 <log+0x5f>
		if ((1 << i) & size) {
  105a64:	8b 45 f4             	mov    -0xc(%ebp),%eax
  105a67:	ba 01 00 00 00       	mov    $0x1,%edx
  105a6c:	88 c1                	mov    %al,%cl
  105a6e:	d3 e2                	shl    %cl,%edx
  105a70:	89 d0                	mov    %edx,%eax
  105a72:	23 45 08             	and    0x8(%ebp),%eax
  105a75:	85 c0                	test   %eax,%eax
  105a77:	74 05                	je     105a7e <log+0x5c>
			return i;
  105a79:	8b 45 f4             	mov    -0xc(%ebp),%eax
  105a7c:	eb 2d                	jmp    105aab <log+0x89>
	for (;i <= MAX_LENGTH_LOG; i++) {
  105a7e:	ff 45 f4             	incl   -0xc(%ebp)
  105a81:	83 7d f4 12          	cmpl   $0x12,-0xc(%ebp)
  105a85:	76 dd                	jbe    105a64 <log+0x42>
		}
	}
	assert(0);
  105a87:	c7 44 24 0c 11 8a 10 	movl   $0x108a11,0xc(%esp)
  105a8e:	00 
  105a8f:	c7 44 24 08 e8 89 10 	movl   $0x1089e8,0x8(%esp)
  105a96:	00 
  105a97:	c7 44 24 04 33 00 00 	movl   $0x33,0x4(%esp)
  105a9e:	00 
  105a9f:	c7 04 24 fd 89 10 00 	movl   $0x1089fd,(%esp)
  105aa6:	e8 86 a9 ff ff       	call   100431 <__panic>
}
  105aab:	c9                   	leave  
  105aac:	c3                   	ret    

00105aad <buddy_new>:

// 初始化buddy结构
void buddy_new(int size) {
  105aad:	f3 0f 1e fb          	endbr32 
  105ab1:	55                   	push   %ebp
  105ab2:	89 e5                	mov    %esp,%ebp
  105ab4:	83 ec 28             	sub    $0x28,%esp
  	if (size < 1 || !IS_POWER_OF_2(size))
  105ab7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  105abb:	7e 60                	jle    105b1d <buddy_new+0x70>
  105abd:	8b 45 08             	mov    0x8(%ebp),%eax
  105ac0:	48                   	dec    %eax
  105ac1:	23 45 08             	and    0x8(%ebp),%eax
  105ac4:	85 c0                	test   %eax,%eax
  105ac6:	75 55                	jne    105b1d <buddy_new+0x70>
    	return;

  	buddy.size = size;
  105ac8:	8b 45 08             	mov    0x8(%ebp),%eax
  105acb:	a3 80 0f 12 00       	mov    %eax,0x120f80
	memset(buddy.longest, 0, 2 * size * sizeof(unsigned) - 1);
  105ad0:	8b 45 08             	mov    0x8(%ebp),%eax
  105ad3:	c1 e0 03             	shl    $0x3,%eax
  105ad6:	48                   	dec    %eax
  105ad7:	89 44 24 08          	mov    %eax,0x8(%esp)
  105adb:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  105ae2:	00 
  105ae3:	c7 04 24 84 0f 12 00 	movl   $0x120f84,(%esp)
  105aea:	e8 f3 14 00 00       	call   106fe2 <memset>

	extern char end[];
	buddy.base = (struct Page *)ROUNDUP((void *)end, PGSIZE);
  105aef:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  105af6:	b8 84 10 32 00       	mov    $0x321084,%eax
  105afb:	8d 50 ff             	lea    -0x1(%eax),%edx
  105afe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  105b01:	01 d0                	add    %edx,%eax
  105b03:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105b06:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105b09:	ba 00 00 00 00       	mov    $0x0,%edx
  105b0e:	f7 75 f4             	divl   -0xc(%ebp)
  105b11:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105b14:	29 d0                	sub    %edx,%eax
  105b16:	a3 80 0f 32 00       	mov    %eax,0x320f80
  	return;
  105b1b:	eb 01                	jmp    105b1e <buddy_new+0x71>
    	return;
  105b1d:	90                   	nop
}
  105b1e:	c9                   	leave  
  105b1f:	c3                   	ret    

00105b20 <buddy_init>:

// 初始化链表数组并且传入MAX_LENGTH
static void buddy_init(void) {
  105b20:	f3 0f 1e fb          	endbr32 
  105b24:	55                   	push   %ebp
  105b25:	89 e5                	mov    %esp,%ebp
  105b27:	83 ec 28             	sub    $0x28,%esp
	int i = 0;
  105b2a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (; i <= MAX_LENGTH_LOG; i++) {
  105b31:	eb 43                	jmp    105b76 <buddy_init+0x56>
		list_init(&free_list(i));
  105b33:	8b 55 f4             	mov    -0xc(%ebp),%edx
  105b36:	89 d0                	mov    %edx,%eax
  105b38:	01 c0                	add    %eax,%eax
  105b3a:	01 d0                	add    %edx,%eax
  105b3c:	c1 e0 02             	shl    $0x2,%eax
  105b3f:	05 a0 0f 32 00       	add    $0x320fa0,%eax
  105b44:	89 45 f0             	mov    %eax,-0x10(%ebp)
    elm->prev = elm->next = elm;
  105b47:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105b4a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  105b4d:	89 50 04             	mov    %edx,0x4(%eax)
  105b50:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105b53:	8b 50 04             	mov    0x4(%eax),%edx
  105b56:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105b59:	89 10                	mov    %edx,(%eax)
}
  105b5b:	90                   	nop
    	nr_free(i) = 0;
  105b5c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  105b5f:	89 d0                	mov    %edx,%eax
  105b61:	01 c0                	add    %eax,%eax
  105b63:	01 d0                	add    %edx,%eax
  105b65:	c1 e0 02             	shl    $0x2,%eax
  105b68:	05 a8 0f 32 00       	add    $0x320fa8,%eax
  105b6d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	for (; i <= MAX_LENGTH_LOG; i++) {
  105b73:	ff 45 f4             	incl   -0xc(%ebp)
  105b76:	83 7d f4 12          	cmpl   $0x12,-0xc(%ebp)
  105b7a:	7e b7                	jle    105b33 <buddy_init+0x13>
	}
	buddy_new(MAX_LENGTH);
  105b7c:	c7 04 24 00 00 04 00 	movl   $0x40000,(%esp)
  105b83:	e8 25 ff ff ff       	call   105aad <buddy_new>
}
  105b88:	90                   	nop
  105b89:	c9                   	leave  
  105b8a:	c3                   	ret    

00105b8b <buddy_free_pages>:

// 释放页，大小必须为2的次幂
static void buddy_free_pages(struct Page* base, size_t n) {
  105b8b:	f3 0f 1e fb          	endbr32 
  105b8f:	55                   	push   %ebp
  105b90:	89 e5                	mov    %esp,%ebp
  105b92:	81 ec c8 00 00 00    	sub    $0xc8,%esp
	assert(n > 0);
  105b98:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  105b9c:	75 24                	jne    105bc2 <buddy_free_pages+0x37>
  105b9e:	c7 44 24 0c 13 8a 10 	movl   $0x108a13,0xc(%esp)
  105ba5:	00 
  105ba6:	c7 44 24 08 e8 89 10 	movl   $0x1089e8,0x8(%esp)
  105bad:	00 
  105bae:	c7 44 24 04 4f 00 00 	movl   $0x4f,0x4(%esp)
  105bb5:	00 
  105bb6:	c7 04 24 fd 89 10 00 	movl   $0x1089fd,(%esp)
  105bbd:	e8 6f a8 ff ff       	call   100431 <__panic>
	assert (IS_POWER_OF_2(n));
  105bc2:	8b 45 0c             	mov    0xc(%ebp),%eax
  105bc5:	48                   	dec    %eax
  105bc6:	23 45 0c             	and    0xc(%ebp),%eax
  105bc9:	85 c0                	test   %eax,%eax
  105bcb:	74 24                	je     105bf1 <buddy_free_pages+0x66>
  105bcd:	c7 44 24 0c 19 8a 10 	movl   $0x108a19,0xc(%esp)
  105bd4:	00 
  105bd5:	c7 44 24 08 e8 89 10 	movl   $0x1089e8,0x8(%esp)
  105bdc:	00 
  105bdd:	c7 44 24 04 50 00 00 	movl   $0x50,0x4(%esp)
  105be4:	00 
  105be5:	c7 04 24 fd 89 10 00 	movl   $0x1089fd,(%esp)
  105bec:	e8 40 a8 ff ff       	call   100431 <__panic>
    struct Page *p = base;
  105bf1:	8b 45 08             	mov    0x8(%ebp),%eax
  105bf4:	89 45 f4             	mov    %eax,-0xc(%ebp)
    for (; p != base + n; p ++) {
  105bf7:	e9 9d 00 00 00       	jmp    105c99 <buddy_free_pages+0x10e>
        assert(!PageReserved(p) && !PageProperty(p));
  105bfc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  105bff:	83 c0 04             	add    $0x4,%eax
  105c02:	c7 45 b4 00 00 00 00 	movl   $0x0,-0x4c(%ebp)
  105c09:	89 45 b0             	mov    %eax,-0x50(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  105c0c:	8b 45 b0             	mov    -0x50(%ebp),%eax
  105c0f:	8b 55 b4             	mov    -0x4c(%ebp),%edx
  105c12:	0f a3 10             	bt     %edx,(%eax)
  105c15:	19 c0                	sbb    %eax,%eax
  105c17:	89 45 ac             	mov    %eax,-0x54(%ebp)
    return oldbit != 0;
  105c1a:	83 7d ac 00          	cmpl   $0x0,-0x54(%ebp)
  105c1e:	0f 95 c0             	setne  %al
  105c21:	0f b6 c0             	movzbl %al,%eax
  105c24:	85 c0                	test   %eax,%eax
  105c26:	75 2c                	jne    105c54 <buddy_free_pages+0xc9>
  105c28:	8b 45 f4             	mov    -0xc(%ebp),%eax
  105c2b:	83 c0 04             	add    $0x4,%eax
  105c2e:	c7 45 a8 01 00 00 00 	movl   $0x1,-0x58(%ebp)
  105c35:	89 45 a4             	mov    %eax,-0x5c(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  105c38:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  105c3b:	8b 55 a8             	mov    -0x58(%ebp),%edx
  105c3e:	0f a3 10             	bt     %edx,(%eax)
  105c41:	19 c0                	sbb    %eax,%eax
  105c43:	89 45 a0             	mov    %eax,-0x60(%ebp)
    return oldbit != 0;
  105c46:	83 7d a0 00          	cmpl   $0x0,-0x60(%ebp)
  105c4a:	0f 95 c0             	setne  %al
  105c4d:	0f b6 c0             	movzbl %al,%eax
  105c50:	85 c0                	test   %eax,%eax
  105c52:	74 24                	je     105c78 <buddy_free_pages+0xed>
  105c54:	c7 44 24 0c 2c 8a 10 	movl   $0x108a2c,0xc(%esp)
  105c5b:	00 
  105c5c:	c7 44 24 08 e8 89 10 	movl   $0x1089e8,0x8(%esp)
  105c63:	00 
  105c64:	c7 44 24 04 53 00 00 	movl   $0x53,0x4(%esp)
  105c6b:	00 
  105c6c:	c7 04 24 fd 89 10 00 	movl   $0x1089fd,(%esp)
  105c73:	e8 b9 a7 ff ff       	call   100431 <__panic>
        p->flags = 0;
  105c78:	8b 45 f4             	mov    -0xc(%ebp),%eax
  105c7b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
        set_page_ref(p, 0);
  105c82:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  105c89:	00 
  105c8a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  105c8d:	89 04 24             	mov    %eax,(%esp)
  105c90:	e8 46 fd ff ff       	call   1059db <set_page_ref>
    for (; p != base + n; p ++) {
  105c95:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
  105c99:	8b 55 0c             	mov    0xc(%ebp),%edx
  105c9c:	89 d0                	mov    %edx,%eax
  105c9e:	c1 e0 02             	shl    $0x2,%eax
  105ca1:	01 d0                	add    %edx,%eax
  105ca3:	c1 e0 02             	shl    $0x2,%eax
  105ca6:	89 c2                	mov    %eax,%edx
  105ca8:	8b 45 08             	mov    0x8(%ebp),%eax
  105cab:	01 d0                	add    %edx,%eax
  105cad:	39 45 f4             	cmp    %eax,-0xc(%ebp)
  105cb0:	0f 85 46 ff ff ff    	jne    105bfc <buddy_free_pages+0x71>
    }
    base->property = n;
  105cb6:	8b 45 08             	mov    0x8(%ebp),%eax
  105cb9:	8b 55 0c             	mov    0xc(%ebp),%edx
  105cbc:	89 50 08             	mov    %edx,0x8(%eax)
    SetPageProperty(base);
  105cbf:	8b 45 08             	mov    0x8(%ebp),%eax
  105cc2:	83 c0 04             	add    $0x4,%eax
  105cc5:	c7 45 84 01 00 00 00 	movl   $0x1,-0x7c(%ebp)
  105ccc:	89 45 80             	mov    %eax,-0x80(%ebp)
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  105ccf:	8b 45 80             	mov    -0x80(%ebp),%eax
  105cd2:	8b 55 84             	mov    -0x7c(%ebp),%edx
  105cd5:	0f ab 10             	bts    %edx,(%eax)
}
  105cd8:	90                   	nop
	
	// 计算阶数，插回对应的链表里
	unsigned logn = log(n);
  105cd9:	8b 45 0c             	mov    0xc(%ebp),%eax
  105cdc:	89 04 24             	mov    %eax,(%esp)
  105cdf:	e8 3e fd ff ff       	call   105a22 <log>
  105ce4:	89 45 e8             	mov    %eax,-0x18(%ebp)
	nr_free(logn) += n;
  105ce7:	8b 55 e8             	mov    -0x18(%ebp),%edx
  105cea:	89 d0                	mov    %edx,%eax
  105cec:	01 c0                	add    %eax,%eax
  105cee:	01 d0                	add    %edx,%eax
  105cf0:	c1 e0 02             	shl    $0x2,%eax
  105cf3:	05 a8 0f 32 00       	add    $0x320fa8,%eax
  105cf8:	8b 10                	mov    (%eax),%edx
  105cfa:	8b 45 0c             	mov    0xc(%ebp),%eax
  105cfd:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  105d00:	8b 55 e8             	mov    -0x18(%ebp),%edx
  105d03:	89 d0                	mov    %edx,%eax
  105d05:	01 c0                	add    %eax,%eax
  105d07:	01 d0                	add    %edx,%eax
  105d09:	c1 e0 02             	shl    $0x2,%eax
  105d0c:	05 a8 0f 32 00       	add    $0x320fa8,%eax
  105d11:	89 08                	mov    %ecx,(%eax)
	list_entry_t *le = &free_list(logn);
  105d13:	8b 55 e8             	mov    -0x18(%ebp),%edx
  105d16:	89 d0                	mov    %edx,%eax
  105d18:	01 c0                	add    %eax,%eax
  105d1a:	01 d0                	add    %edx,%eax
  105d1c:	c1 e0 02             	shl    $0x2,%eax
  105d1f:	05 a0 0f 32 00       	add    $0x320fa0,%eax
  105d24:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	list_add_before(list_next(le), &(base->page_link));
  105d27:	8b 45 08             	mov    0x8(%ebp),%eax
  105d2a:	8d 50 0c             	lea    0xc(%eax),%edx
  105d2d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  105d30:	89 45 88             	mov    %eax,-0x78(%ebp)
    return listelm->next;
  105d33:	8b 45 88             	mov    -0x78(%ebp),%eax
  105d36:	8b 40 04             	mov    0x4(%eax),%eax
  105d39:	89 45 9c             	mov    %eax,-0x64(%ebp)
  105d3c:	89 55 98             	mov    %edx,-0x68(%ebp)
    __list_add(elm, listelm->prev, listelm);
  105d3f:	8b 45 9c             	mov    -0x64(%ebp),%eax
  105d42:	8b 00                	mov    (%eax),%eax
  105d44:	8b 55 98             	mov    -0x68(%ebp),%edx
  105d47:	89 55 94             	mov    %edx,-0x6c(%ebp)
  105d4a:	89 45 90             	mov    %eax,-0x70(%ebp)
  105d4d:	8b 45 9c             	mov    -0x64(%ebp),%eax
  105d50:	89 45 8c             	mov    %eax,-0x74(%ebp)
    prev->next = next->prev = elm;
  105d53:	8b 45 8c             	mov    -0x74(%ebp),%eax
  105d56:	8b 55 94             	mov    -0x6c(%ebp),%edx
  105d59:	89 10                	mov    %edx,(%eax)
  105d5b:	8b 45 8c             	mov    -0x74(%ebp),%eax
  105d5e:	8b 10                	mov    (%eax),%edx
  105d60:	8b 45 90             	mov    -0x70(%ebp),%eax
  105d63:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
  105d66:	8b 45 94             	mov    -0x6c(%ebp),%eax
  105d69:	8b 55 8c             	mov    -0x74(%ebp),%edx
  105d6c:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
  105d6f:	8b 45 94             	mov    -0x6c(%ebp),%eax
  105d72:	8b 55 90             	mov    -0x70(%ebp),%edx
  105d75:	89 10                	mov    %edx,(%eax)
}
  105d77:	90                   	nop
}
  105d78:	90                   	nop

  	unsigned index, node_size = n;
  105d79:	8b 45 0c             	mov    0xc(%ebp),%eax
  105d7c:	89 45 ec             	mov    %eax,-0x14(%ebp)
  	unsigned left_longest, right_longest;
	unsigned offset = base - buddy.base;
  105d7f:	a1 80 0f 32 00       	mov    0x320f80,%eax
  105d84:	8b 55 08             	mov    0x8(%ebp),%edx
  105d87:	29 c2                	sub    %eax,%edx
  105d89:	89 d0                	mov    %edx,%eax
  105d8b:	c1 f8 02             	sar    $0x2,%eax
  105d8e:	69 c0 cd cc cc cc    	imul   $0xcccccccd,%eax,%eax
  105d94:	89 45 e0             	mov    %eax,-0x20(%ebp)

  	assert(offset >= 0 && offset < buddy.size * 2 - 1);
  105d97:	a1 80 0f 12 00       	mov    0x120f80,%eax
  105d9c:	01 c0                	add    %eax,%eax
  105d9e:	48                   	dec    %eax
  105d9f:	39 45 e0             	cmp    %eax,-0x20(%ebp)
  105da2:	72 24                	jb     105dc8 <buddy_free_pages+0x23d>
  105da4:	c7 44 24 0c 54 8a 10 	movl   $0x108a54,0xc(%esp)
  105dab:	00 
  105dac:	c7 44 24 08 e8 89 10 	movl   $0x1089e8,0x8(%esp)
  105db3:	00 
  105db4:	c7 44 24 04 64 00 00 	movl   $0x64,0x4(%esp)
  105dbb:	00 
  105dbc:	c7 04 24 fd 89 10 00 	movl   $0x1089fd,(%esp)
  105dc3:	e8 69 a6 ff ff       	call   100431 <__panic>

  	index = (offset + buddy.size) / n - 1;
  105dc8:	8b 15 80 0f 12 00    	mov    0x120f80,%edx
  105dce:	8b 45 e0             	mov    -0x20(%ebp),%eax
  105dd1:	01 d0                	add    %edx,%eax
  105dd3:	ba 00 00 00 00       	mov    $0x0,%edx
  105dd8:	f7 75 0c             	divl   0xc(%ebp)
  105ddb:	48                   	dec    %eax
  105ddc:	89 45 f0             	mov    %eax,-0x10(%ebp)

	// 恢复二叉树原节点的longest
  	buddy.longest[index] = n;
  105ddf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105de2:	8b 55 0c             	mov    0xc(%ebp),%edx
  105de5:	89 14 85 84 0f 12 00 	mov    %edx,0x120f84(,%eax,4)

	// 遍历，恢复上层节点并检查合并
  	while (index) {
  105dec:	e9 84 02 00 00       	jmp    106075 <buddy_free_pages+0x4ea>
    	index = PARENT(index);
  105df1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105df4:	40                   	inc    %eax
  105df5:	d1 e8                	shr    %eax
  105df7:	48                   	dec    %eax
  105df8:	89 45 f0             	mov    %eax,-0x10(%ebp)
    	node_size *= 2;
  105dfb:	d1 65 ec             	shll   -0x14(%ebp)

    	left_longest = buddy.longest[LEFT_LEAF(index)];
  105dfe:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105e01:	01 c0                	add    %eax,%eax
  105e03:	40                   	inc    %eax
  105e04:	8b 04 85 84 0f 12 00 	mov    0x120f84(,%eax,4),%eax
  105e0b:	89 45 dc             	mov    %eax,-0x24(%ebp)
    	right_longest = buddy.longest[RIGHT_LEAF(index)];
  105e0e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105e11:	40                   	inc    %eax
  105e12:	01 c0                	add    %eax,%eax
  105e14:	8b 04 85 84 0f 12 00 	mov    0x120f84(,%eax,4),%eax
  105e1b:	89 45 d8             	mov    %eax,-0x28(%ebp)
    
		// 可合并
    	if (left_longest + right_longest == node_size) {
  105e1e:	8b 55 dc             	mov    -0x24(%ebp),%edx
  105e21:	8b 45 d8             	mov    -0x28(%ebp),%eax
  105e24:	01 d0                	add    %edx,%eax
  105e26:	39 45 ec             	cmp    %eax,-0x14(%ebp)
  105e29:	0f 85 30 02 00 00    	jne    10605f <buddy_free_pages+0x4d4>
      		buddy.longest[index] = node_size;
  105e2f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105e32:	8b 55 ec             	mov    -0x14(%ebp),%edx
  105e35:	89 14 85 84 0f 12 00 	mov    %edx,0x120f84(,%eax,4)
			unsigned logn = log(node_size);
  105e3c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  105e3f:	89 04 24             	mov    %eax,(%esp)
  105e42:	e8 db fb ff ff       	call   105a22 <log>
  105e47:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			unsigned left_offset, right_offset;
			// 计算出左右块的头page
			left_offset = (LEFT_LEAF(index) + 1) * node_size / 2 - buddy.size;
  105e4a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105e4d:	40                   	inc    %eax
  105e4e:	0f af 45 ec          	imul   -0x14(%ebp),%eax
  105e52:	25 ff ff ff 7f       	and    $0x7fffffff,%eax
  105e57:	89 c2                	mov    %eax,%edx
  105e59:	a1 80 0f 12 00       	mov    0x120f80,%eax
  105e5e:	29 c2                	sub    %eax,%edx
  105e60:	89 d0                	mov    %edx,%eax
  105e62:	89 45 d0             	mov    %eax,-0x30(%ebp)
			right_offset = (RIGHT_LEAF(index) + 1) * node_size / 2 - buddy.size;
  105e65:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105e68:	40                   	inc    %eax
  105e69:	01 c0                	add    %eax,%eax
  105e6b:	40                   	inc    %eax
  105e6c:	0f af 45 ec          	imul   -0x14(%ebp),%eax
  105e70:	d1 e8                	shr    %eax
  105e72:	89 c2                	mov    %eax,%edx
  105e74:	a1 80 0f 12 00       	mov    0x120f80,%eax
  105e79:	29 c2                	sub    %eax,%edx
  105e7b:	89 d0                	mov    %edx,%eax
  105e7d:	89 45 cc             	mov    %eax,-0x34(%ebp)
			struct Page *left_page = &buddy.base[left_offset], *right_page = &buddy.base[right_offset];
  105e80:	8b 0d 80 0f 32 00    	mov    0x320f80,%ecx
  105e86:	8b 55 d0             	mov    -0x30(%ebp),%edx
  105e89:	89 d0                	mov    %edx,%eax
  105e8b:	c1 e0 02             	shl    $0x2,%eax
  105e8e:	01 d0                	add    %edx,%eax
  105e90:	c1 e0 02             	shl    $0x2,%eax
  105e93:	01 c8                	add    %ecx,%eax
  105e95:	89 45 c8             	mov    %eax,-0x38(%ebp)
  105e98:	8b 0d 80 0f 32 00    	mov    0x320f80,%ecx
  105e9e:	8b 55 cc             	mov    -0x34(%ebp),%edx
  105ea1:	89 d0                	mov    %edx,%eax
  105ea3:	c1 e0 02             	shl    $0x2,%eax
  105ea6:	01 d0                	add    %edx,%eax
  105ea8:	c1 e0 02             	shl    $0x2,%eax
  105eab:	01 c8                	add    %ecx,%eax
  105ead:	89 45 c4             	mov    %eax,-0x3c(%ebp)
			list_entry_t *lle = &left_page->page_link, *rle = &right_page->page_link;
  105eb0:	8b 45 c8             	mov    -0x38(%ebp),%eax
  105eb3:	83 c0 0c             	add    $0xc,%eax
  105eb6:	89 45 c0             	mov    %eax,-0x40(%ebp)
  105eb9:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  105ebc:	83 c0 0c             	add    $0xc,%eax
  105ebf:	89 45 bc             	mov    %eax,-0x44(%ebp)
  105ec2:	8b 45 c0             	mov    -0x40(%ebp),%eax
  105ec5:	89 85 58 ff ff ff    	mov    %eax,-0xa8(%ebp)
    __list_del(listelm->prev, listelm->next);
  105ecb:	8b 85 58 ff ff ff    	mov    -0xa8(%ebp),%eax
  105ed1:	8b 40 04             	mov    0x4(%eax),%eax
  105ed4:	8b 95 58 ff ff ff    	mov    -0xa8(%ebp),%edx
  105eda:	8b 12                	mov    (%edx),%edx
  105edc:	89 95 54 ff ff ff    	mov    %edx,-0xac(%ebp)
  105ee2:	89 85 50 ff ff ff    	mov    %eax,-0xb0(%ebp)
    prev->next = next;
  105ee8:	8b 85 54 ff ff ff    	mov    -0xac(%ebp),%eax
  105eee:	8b 95 50 ff ff ff    	mov    -0xb0(%ebp),%edx
  105ef4:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
  105ef7:	8b 85 50 ff ff ff    	mov    -0xb0(%ebp),%eax
  105efd:	8b 95 54 ff ff ff    	mov    -0xac(%ebp),%edx
  105f03:	89 10                	mov    %edx,(%eax)
}
  105f05:	90                   	nop
}
  105f06:	90                   	nop
  105f07:	8b 45 bc             	mov    -0x44(%ebp),%eax
  105f0a:	89 85 64 ff ff ff    	mov    %eax,-0x9c(%ebp)
    __list_del(listelm->prev, listelm->next);
  105f10:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
  105f16:	8b 40 04             	mov    0x4(%eax),%eax
  105f19:	8b 95 64 ff ff ff    	mov    -0x9c(%ebp),%edx
  105f1f:	8b 12                	mov    (%edx),%edx
  105f21:	89 95 60 ff ff ff    	mov    %edx,-0xa0(%ebp)
  105f27:	89 85 5c ff ff ff    	mov    %eax,-0xa4(%ebp)
    prev->next = next;
  105f2d:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
  105f33:	8b 95 5c ff ff ff    	mov    -0xa4(%ebp),%edx
  105f39:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
  105f3c:	8b 85 5c ff ff ff    	mov    -0xa4(%ebp),%eax
  105f42:	8b 95 60 ff ff ff    	mov    -0xa0(%ebp),%edx
  105f48:	89 10                	mov    %edx,(%eax)
}
  105f4a:	90                   	nop
}
  105f4b:	90                   	nop
			// 从原链表中取出
			list_del(lle);
			list_del(rle);
			nr_free(logn - 1) -= node_size;
  105f4c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  105f4f:	8d 50 ff             	lea    -0x1(%eax),%edx
  105f52:	89 d0                	mov    %edx,%eax
  105f54:	01 c0                	add    %eax,%eax
  105f56:	01 d0                	add    %edx,%eax
  105f58:	c1 e0 02             	shl    $0x2,%eax
  105f5b:	05 a8 0f 32 00       	add    $0x320fa8,%eax
  105f60:	8b 00                	mov    (%eax),%eax
  105f62:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  105f65:	4a                   	dec    %edx
  105f66:	2b 45 ec             	sub    -0x14(%ebp),%eax
  105f69:	89 c1                	mov    %eax,%ecx
  105f6b:	89 d0                	mov    %edx,%eax
  105f6d:	01 c0                	add    %eax,%eax
  105f6f:	01 d0                	add    %edx,%eax
  105f71:	c1 e0 02             	shl    $0x2,%eax
  105f74:	05 a8 0f 32 00       	add    $0x320fa8,%eax
  105f79:	89 08                	mov    %ecx,(%eax)
			left_page->property = node_size; 
  105f7b:	8b 45 c8             	mov    -0x38(%ebp),%eax
  105f7e:	8b 55 ec             	mov    -0x14(%ebp),%edx
  105f81:	89 50 08             	mov    %edx,0x8(%eax)
			right_page->property = 0;
  105f84:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  105f87:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			right_page->flags = 0;
  105f8e:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  105f91:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
			// 插入新链表中
			list_entry_t *le = &free_list(logn);
  105f98:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  105f9b:	89 d0                	mov    %edx,%eax
  105f9d:	01 c0                	add    %eax,%eax
  105f9f:	01 d0                	add    %edx,%eax
  105fa1:	c1 e0 02             	shl    $0x2,%eax
  105fa4:	05 a0 0f 32 00       	add    $0x320fa0,%eax
  105fa9:	89 45 b8             	mov    %eax,-0x48(%ebp)
  105fac:	8b 45 b8             	mov    -0x48(%ebp),%eax
  105faf:	89 85 68 ff ff ff    	mov    %eax,-0x98(%ebp)
    return listelm->next;
  105fb5:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
  105fbb:	8b 40 04             	mov    0x4(%eax),%eax
  105fbe:	89 85 7c ff ff ff    	mov    %eax,-0x84(%ebp)
  105fc4:	8b 45 c0             	mov    -0x40(%ebp),%eax
  105fc7:	89 85 78 ff ff ff    	mov    %eax,-0x88(%ebp)
    __list_add(elm, listelm->prev, listelm);
  105fcd:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
  105fd3:	8b 00                	mov    (%eax),%eax
  105fd5:	8b 95 78 ff ff ff    	mov    -0x88(%ebp),%edx
  105fdb:	89 95 74 ff ff ff    	mov    %edx,-0x8c(%ebp)
  105fe1:	89 85 70 ff ff ff    	mov    %eax,-0x90(%ebp)
  105fe7:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
  105fed:	89 85 6c ff ff ff    	mov    %eax,-0x94(%ebp)
    prev->next = next->prev = elm;
  105ff3:	8b 85 6c ff ff ff    	mov    -0x94(%ebp),%eax
  105ff9:	8b 95 74 ff ff ff    	mov    -0x8c(%ebp),%edx
  105fff:	89 10                	mov    %edx,(%eax)
  106001:	8b 85 6c ff ff ff    	mov    -0x94(%ebp),%eax
  106007:	8b 10                	mov    (%eax),%edx
  106009:	8b 85 70 ff ff ff    	mov    -0x90(%ebp),%eax
  10600f:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
  106012:	8b 85 74 ff ff ff    	mov    -0x8c(%ebp),%eax
  106018:	8b 95 6c ff ff ff    	mov    -0x94(%ebp),%edx
  10601e:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
  106021:	8b 85 74 ff ff ff    	mov    -0x8c(%ebp),%eax
  106027:	8b 95 70 ff ff ff    	mov    -0x90(%ebp),%edx
  10602d:	89 10                	mov    %edx,(%eax)
}
  10602f:	90                   	nop
}
  106030:	90                   	nop
			list_add_before(list_next(le), lle);
			nr_free(logn) += node_size;
  106031:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  106034:	89 d0                	mov    %edx,%eax
  106036:	01 c0                	add    %eax,%eax
  106038:	01 d0                	add    %edx,%eax
  10603a:	c1 e0 02             	shl    $0x2,%eax
  10603d:	05 a8 0f 32 00       	add    $0x320fa8,%eax
  106042:	8b 10                	mov    (%eax),%edx
  106044:	8b 45 ec             	mov    -0x14(%ebp),%eax
  106047:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  10604a:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  10604d:	89 d0                	mov    %edx,%eax
  10604f:	01 c0                	add    %eax,%eax
  106051:	01 d0                	add    %edx,%eax
  106053:	c1 e0 02             	shl    $0x2,%eax
  106056:	05 a8 0f 32 00       	add    $0x320fa8,%eax
  10605b:	89 08                	mov    %ecx,(%eax)
  10605d:	eb 16                	jmp    106075 <buddy_free_pages+0x4ea>
		}
    	else
      		buddy.longest[index] = MAX(left_longest, right_longest);
  10605f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  106062:	39 45 d8             	cmp    %eax,-0x28(%ebp)
  106065:	0f 43 45 d8          	cmovae -0x28(%ebp),%eax
  106069:	89 c2                	mov    %eax,%edx
  10606b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10606e:	89 14 85 84 0f 12 00 	mov    %edx,0x120f84(,%eax,4)
  	while (index) {
  106075:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  106079:	0f 85 72 fd ff ff    	jne    105df1 <buddy_free_pages+0x266>
  	}
}
  10607f:	90                   	nop
  106080:	90                   	nop
  106081:	c9                   	leave  
  106082:	c3                   	ret    

00106083 <buddy_init_memmap>:

// 将初始化的空闲块细分，一个个插入以保证二叉树longest正确更新
static void buddy_init_memmap(struct Page *base, size_t n) {
  106083:	f3 0f 1e fb          	endbr32 
  106087:	55                   	push   %ebp
  106088:	89 e5                	mov    %esp,%ebp
  10608a:	83 ec 28             	sub    $0x28,%esp
	assert(n > 0);
  10608d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  106091:	75 24                	jne    1060b7 <buddy_init_memmap+0x34>
  106093:	c7 44 24 0c 13 8a 10 	movl   $0x108a13,0xc(%esp)
  10609a:	00 
  10609b:	c7 44 24 08 e8 89 10 	movl   $0x1089e8,0x8(%esp)
  1060a2:	00 
  1060a3:	c7 44 24 04 90 00 00 	movl   $0x90,0x4(%esp)
  1060aa:	00 
  1060ab:	c7 04 24 fd 89 10 00 	movl   $0x1089fd,(%esp)
  1060b2:	e8 7a a3 ff ff       	call   100431 <__panic>
    struct Page *p = base;
  1060b7:	8b 45 08             	mov    0x8(%ebp),%eax
  1060ba:	89 45 f4             	mov    %eax,-0xc(%ebp)
    for (; p != base + n; p ++) {
  1060bd:	e9 8e 00 00 00       	jmp    106150 <buddy_init_memmap+0xcd>
        assert(PageReserved(p));
  1060c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1060c5:	83 c0 04             	add    $0x4,%eax
  1060c8:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  1060cf:	89 45 ec             	mov    %eax,-0x14(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  1060d2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1060d5:	8b 55 f0             	mov    -0x10(%ebp),%edx
  1060d8:	0f a3 10             	bt     %edx,(%eax)
  1060db:	19 c0                	sbb    %eax,%eax
  1060dd:	89 45 e8             	mov    %eax,-0x18(%ebp)
    return oldbit != 0;
  1060e0:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  1060e4:	0f 95 c0             	setne  %al
  1060e7:	0f b6 c0             	movzbl %al,%eax
  1060ea:	85 c0                	test   %eax,%eax
  1060ec:	75 24                	jne    106112 <buddy_init_memmap+0x8f>
  1060ee:	c7 44 24 0c 7f 8a 10 	movl   $0x108a7f,0xc(%esp)
  1060f5:	00 
  1060f6:	c7 44 24 08 e8 89 10 	movl   $0x1089e8,0x8(%esp)
  1060fd:	00 
  1060fe:	c7 44 24 04 93 00 00 	movl   $0x93,0x4(%esp)
  106105:	00 
  106106:	c7 04 24 fd 89 10 00 	movl   $0x1089fd,(%esp)
  10610d:	e8 1f a3 ff ff       	call   100431 <__panic>
		p->flags = 0;
  106112:	8b 45 f4             	mov    -0xc(%ebp),%eax
  106115:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
        set_page_ref(p, 0);
  10611c:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  106123:	00 
  106124:	8b 45 f4             	mov    -0xc(%ebp),%eax
  106127:	89 04 24             	mov    %eax,(%esp)
  10612a:	e8 ac f8 ff ff       	call   1059db <set_page_ref>
		p->property = 1;
  10612f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  106132:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
		buddy_free_pages(p, 1);
  106139:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  106140:	00 
  106141:	8b 45 f4             	mov    -0xc(%ebp),%eax
  106144:	89 04 24             	mov    %eax,(%esp)
  106147:	e8 3f fa ff ff       	call   105b8b <buddy_free_pages>
    for (; p != base + n; p ++) {
  10614c:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
  106150:	8b 55 0c             	mov    0xc(%ebp),%edx
  106153:	89 d0                	mov    %edx,%eax
  106155:	c1 e0 02             	shl    $0x2,%eax
  106158:	01 d0                	add    %edx,%eax
  10615a:	c1 e0 02             	shl    $0x2,%eax
  10615d:	89 c2                	mov    %eax,%edx
  10615f:	8b 45 08             	mov    0x8(%ebp),%eax
  106162:	01 d0                	add    %edx,%eax
  106164:	39 45 f4             	cmp    %eax,-0xc(%ebp)
  106167:	0f 85 55 ff ff ff    	jne    1060c2 <buddy_init_memmap+0x3f>
    }
}
  10616d:	90                   	nop
  10616e:	90                   	nop
  10616f:	c9                   	leave  
  106170:	c3                   	ret    

00106171 <buddy_alloc_pages>:

// 分配适合大小的空闲块
static struct Page *buddy_alloc_pages(size_t n) {
  106171:	f3 0f 1e fb          	endbr32 
  106175:	55                   	push   %ebp
  106176:	89 e5                	mov    %esp,%ebp
  106178:	81 ec a8 00 00 00    	sub    $0xa8,%esp
    assert(n > 0);
  10617e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  106182:	75 24                	jne    1061a8 <buddy_alloc_pages+0x37>
  106184:	c7 44 24 0c 13 8a 10 	movl   $0x108a13,0xc(%esp)
  10618b:	00 
  10618c:	c7 44 24 08 e8 89 10 	movl   $0x1089e8,0x8(%esp)
  106193:	00 
  106194:	c7 44 24 04 9d 00 00 	movl   $0x9d,0x4(%esp)
  10619b:	00 
  10619c:	c7 04 24 fd 89 10 00 	movl   $0x1089fd,(%esp)
  1061a3:	e8 89 a2 ff ff       	call   100431 <__panic>
	if (!IS_POWER_OF_2(n))
  1061a8:	8b 45 08             	mov    0x8(%ebp),%eax
  1061ab:	48                   	dec    %eax
  1061ac:	23 45 08             	and    0x8(%ebp),%eax
  1061af:	85 c0                	test   %eax,%eax
  1061b1:	74 0e                	je     1061c1 <buddy_alloc_pages+0x50>
    	n = fixsize(n);
  1061b3:	8b 45 08             	mov    0x8(%ebp),%eax
  1061b6:	89 04 24             	mov    %eax,(%esp)
  1061b9:	e8 2b f8 ff ff       	call   1059e9 <fixsize>
  1061be:	89 45 08             	mov    %eax,0x8(%ebp)
	unsigned logn;
	unsigned index = 0;
  1061c1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  	unsigned node_size;
  	unsigned offset = 0;
  1061c8:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
	struct Page* p = NULL, *lp = NULL, *rp = NULL;
  1061cf:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  1061d6:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  1061dd:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)

	// 二叉树中从上至下遍历，遍历的路径中将大空闲块分割成小空闲块
	if (buddy.longest[index] < n)
  1061e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1061e7:	8b 04 85 84 0f 12 00 	mov    0x120f84(,%eax,4),%eax
  1061ee:	39 45 08             	cmp    %eax,0x8(%ebp)
  1061f1:	76 0a                	jbe    1061fd <buddy_alloc_pages+0x8c>
    	return NULL;
  1061f3:	b8 00 00 00 00       	mov    $0x0,%eax
  1061f8:	e9 fb 03 00 00       	jmp    1065f8 <buddy_alloc_pages+0x487>
	for(node_size = buddy.size; node_size != n; node_size /= 2 ) {
  1061fd:	a1 80 0f 12 00       	mov    0x120f80,%eax
  106202:	89 45 f0             	mov    %eax,-0x10(%ebp)
  106205:	e9 b1 02 00 00       	jmp    1064bb <buddy_alloc_pages+0x34a>
		// 该空闲块完整，需要分割
		if (buddy.longest[index] == node_size) {
  10620a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10620d:	8b 04 85 84 0f 12 00 	mov    0x120f84(,%eax,4),%eax
  106214:	39 45 f0             	cmp    %eax,-0x10(%ebp)
  106217:	0f 85 70 02 00 00    	jne    10648d <buddy_alloc_pages+0x31c>
			offset = (index + 1) * node_size - buddy.size;
  10621d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  106220:	40                   	inc    %eax
  106221:	0f af 45 f0          	imul   -0x10(%ebp),%eax
  106225:	89 c2                	mov    %eax,%edx
  106227:	a1 80 0f 12 00       	mov    0x120f80,%eax
  10622c:	29 c2                	sub    %eax,%edx
  10622e:	89 d0                	mov    %edx,%eax
  106230:	89 45 ec             	mov    %eax,-0x14(%ebp)
			p = &buddy.base[offset];
  106233:	8b 0d 80 0f 32 00    	mov    0x320f80,%ecx
  106239:	8b 55 ec             	mov    -0x14(%ebp),%edx
  10623c:	89 d0                	mov    %edx,%eax
  10623e:	c1 e0 02             	shl    $0x2,%eax
  106241:	01 d0                	add    %edx,%eax
  106243:	c1 e0 02             	shl    $0x2,%eax
  106246:	01 c8                	add    %ecx,%eax
  106248:	89 45 e8             	mov    %eax,-0x18(%ebp)
			assert(PageProperty(p));
  10624b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10624e:	83 c0 04             	add    $0x4,%eax
  106251:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
  106258:	89 45 d0             	mov    %eax,-0x30(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  10625b:	8b 45 d0             	mov    -0x30(%ebp),%eax
  10625e:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  106261:	0f a3 10             	bt     %edx,(%eax)
  106264:	19 c0                	sbb    %eax,%eax
  106266:	89 45 cc             	mov    %eax,-0x34(%ebp)
    return oldbit != 0;
  106269:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  10626d:	0f 95 c0             	setne  %al
  106270:	0f b6 c0             	movzbl %al,%eax
  106273:	85 c0                	test   %eax,%eax
  106275:	75 24                	jne    10629b <buddy_alloc_pages+0x12a>
  106277:	c7 44 24 0c 8f 8a 10 	movl   $0x108a8f,0xc(%esp)
  10627e:	00 
  10627f:	c7 44 24 08 e8 89 10 	movl   $0x1089e8,0x8(%esp)
  106286:	00 
  106287:	c7 44 24 04 ae 00 00 	movl   $0xae,0x4(%esp)
  10628e:	00 
  10628f:	c7 04 24 fd 89 10 00 	movl   $0x1089fd,(%esp)
  106296:	e8 96 a1 ff ff       	call   100431 <__panic>
			assert(p->property == node_size);
  10629b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10629e:	8b 40 08             	mov    0x8(%eax),%eax
  1062a1:	39 45 f0             	cmp    %eax,-0x10(%ebp)
  1062a4:	74 24                	je     1062ca <buddy_alloc_pages+0x159>
  1062a6:	c7 44 24 0c 9f 8a 10 	movl   $0x108a9f,0xc(%esp)
  1062ad:	00 
  1062ae:	c7 44 24 08 e8 89 10 	movl   $0x1089e8,0x8(%esp)
  1062b5:	00 
  1062b6:	c7 44 24 04 af 00 00 	movl   $0xaf,0x4(%esp)
  1062bd:	00 
  1062be:	c7 04 24 fd 89 10 00 	movl   $0x1089fd,(%esp)
  1062c5:	e8 67 a1 ff ff       	call   100431 <__panic>
			logn = log(node_size);
  1062ca:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1062cd:	89 04 24             	mov    %eax,(%esp)
  1062d0:	e8 4d f7 ff ff       	call   105a22 <log>
  1062d5:	89 45 dc             	mov    %eax,-0x24(%ebp)
			nr_free(logn) -= node_size;
  1062d8:	8b 55 dc             	mov    -0x24(%ebp),%edx
  1062db:	89 d0                	mov    %edx,%eax
  1062dd:	01 c0                	add    %eax,%eax
  1062df:	01 d0                	add    %edx,%eax
  1062e1:	c1 e0 02             	shl    $0x2,%eax
  1062e4:	05 a8 0f 32 00       	add    $0x320fa8,%eax
  1062e9:	8b 00                	mov    (%eax),%eax
  1062eb:	2b 45 f0             	sub    -0x10(%ebp),%eax
  1062ee:	89 c1                	mov    %eax,%ecx
  1062f0:	8b 55 dc             	mov    -0x24(%ebp),%edx
  1062f3:	89 d0                	mov    %edx,%eax
  1062f5:	01 c0                	add    %eax,%eax
  1062f7:	01 d0                	add    %edx,%eax
  1062f9:	c1 e0 02             	shl    $0x2,%eax
  1062fc:	05 a8 0f 32 00       	add    $0x320fa8,%eax
  106301:	89 08                	mov    %ecx,(%eax)
			list_del(&p->page_link);
  106303:	8b 45 e8             	mov    -0x18(%ebp),%eax
  106306:	83 c0 0c             	add    $0xc,%eax
  106309:	89 45 88             	mov    %eax,-0x78(%ebp)
    __list_del(listelm->prev, listelm->next);
  10630c:	8b 45 88             	mov    -0x78(%ebp),%eax
  10630f:	8b 40 04             	mov    0x4(%eax),%eax
  106312:	8b 55 88             	mov    -0x78(%ebp),%edx
  106315:	8b 12                	mov    (%edx),%edx
  106317:	89 55 84             	mov    %edx,-0x7c(%ebp)
  10631a:	89 45 80             	mov    %eax,-0x80(%ebp)
    prev->next = next;
  10631d:	8b 45 84             	mov    -0x7c(%ebp),%eax
  106320:	8b 55 80             	mov    -0x80(%ebp),%edx
  106323:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
  106326:	8b 45 80             	mov    -0x80(%ebp),%eax
  106329:	8b 55 84             	mov    -0x7c(%ebp),%edx
  10632c:	89 10                	mov    %edx,(%eax)
}
  10632e:	90                   	nop
}
  10632f:	90                   	nop
			lp = p;
  106330:	8b 45 e8             	mov    -0x18(%ebp),%eax
  106333:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			rp = p + node_size / 2;
  106336:	8b 45 f0             	mov    -0x10(%ebp),%eax
  106339:	d1 e8                	shr    %eax
  10633b:	89 c2                	mov    %eax,%edx
  10633d:	89 d0                	mov    %edx,%eax
  10633f:	c1 e0 02             	shl    $0x2,%eax
  106342:	01 d0                	add    %edx,%eax
  106344:	c1 e0 02             	shl    $0x2,%eax
  106347:	89 c2                	mov    %eax,%edx
  106349:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10634c:	01 d0                	add    %edx,%eax
  10634e:	89 45 e0             	mov    %eax,-0x20(%ebp)
			SetPageProperty(lp);
  106351:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  106354:	83 c0 04             	add    $0x4,%eax
  106357:	c7 45 90 01 00 00 00 	movl   $0x1,-0x70(%ebp)
  10635e:	89 45 8c             	mov    %eax,-0x74(%ebp)
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  106361:	8b 45 8c             	mov    -0x74(%ebp),%eax
  106364:	8b 55 90             	mov    -0x70(%ebp),%edx
  106367:	0f ab 10             	bts    %edx,(%eax)
}
  10636a:	90                   	nop
			SetPageProperty(rp);
  10636b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  10636e:	83 c0 04             	add    $0x4,%eax
  106371:	c7 45 98 01 00 00 00 	movl   $0x1,-0x68(%ebp)
  106378:	89 45 94             	mov    %eax,-0x6c(%ebp)
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  10637b:	8b 45 94             	mov    -0x6c(%ebp),%eax
  10637e:	8b 55 98             	mov    -0x68(%ebp),%edx
  106381:	0f ab 10             	bts    %edx,(%eax)
}
  106384:	90                   	nop
			lp->property = node_size / 2;
  106385:	8b 45 f0             	mov    -0x10(%ebp),%eax
  106388:	d1 e8                	shr    %eax
  10638a:	89 c2                	mov    %eax,%edx
  10638c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10638f:	89 50 08             	mov    %edx,0x8(%eax)
			rp->property = node_size / 2;
  106392:	8b 45 f0             	mov    -0x10(%ebp),%eax
  106395:	d1 e8                	shr    %eax
  106397:	89 c2                	mov    %eax,%edx
  106399:	8b 45 e0             	mov    -0x20(%ebp),%eax
  10639c:	89 50 08             	mov    %edx,0x8(%eax)
			nr_free(logn - 1) += node_size;
  10639f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1063a2:	8d 50 ff             	lea    -0x1(%eax),%edx
  1063a5:	89 d0                	mov    %edx,%eax
  1063a7:	01 c0                	add    %eax,%eax
  1063a9:	01 d0                	add    %edx,%eax
  1063ab:	c1 e0 02             	shl    $0x2,%eax
  1063ae:	05 a8 0f 32 00       	add    $0x320fa8,%eax
  1063b3:	8b 08                	mov    (%eax),%ecx
  1063b5:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1063b8:	8d 50 ff             	lea    -0x1(%eax),%edx
  1063bb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1063be:	01 c1                	add    %eax,%ecx
  1063c0:	89 d0                	mov    %edx,%eax
  1063c2:	01 c0                	add    %eax,%eax
  1063c4:	01 d0                	add    %edx,%eax
  1063c6:	c1 e0 02             	shl    $0x2,%eax
  1063c9:	05 a8 0f 32 00       	add    $0x320fa8,%eax
  1063ce:	89 08                	mov    %ecx,(%eax)
			list_entry_t* le = &free_list(logn - 1);
  1063d0:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1063d3:	8d 50 ff             	lea    -0x1(%eax),%edx
  1063d6:	89 d0                	mov    %edx,%eax
  1063d8:	01 c0                	add    %eax,%eax
  1063da:	01 d0                	add    %edx,%eax
  1063dc:	c1 e0 02             	shl    $0x2,%eax
  1063df:	05 a0 0f 32 00       	add    $0x320fa0,%eax
  1063e4:	89 45 d8             	mov    %eax,-0x28(%ebp)
			list_add_after(list_next(le), &(lp->page_link));
  1063e7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1063ea:	8d 50 0c             	lea    0xc(%eax),%edx
  1063ed:	8b 45 d8             	mov    -0x28(%ebp),%eax
  1063f0:	89 45 9c             	mov    %eax,-0x64(%ebp)
    return listelm->next;
  1063f3:	8b 45 9c             	mov    -0x64(%ebp),%eax
  1063f6:	8b 40 04             	mov    0x4(%eax),%eax
  1063f9:	89 45 b0             	mov    %eax,-0x50(%ebp)
  1063fc:	89 55 ac             	mov    %edx,-0x54(%ebp)
    __list_add(elm, listelm, listelm->next);
  1063ff:	8b 45 b0             	mov    -0x50(%ebp),%eax
  106402:	8b 40 04             	mov    0x4(%eax),%eax
  106405:	8b 55 ac             	mov    -0x54(%ebp),%edx
  106408:	89 55 a8             	mov    %edx,-0x58(%ebp)
  10640b:	8b 55 b0             	mov    -0x50(%ebp),%edx
  10640e:	89 55 a4             	mov    %edx,-0x5c(%ebp)
  106411:	89 45 a0             	mov    %eax,-0x60(%ebp)
    prev->next = next->prev = elm;
  106414:	8b 45 a0             	mov    -0x60(%ebp),%eax
  106417:	8b 55 a8             	mov    -0x58(%ebp),%edx
  10641a:	89 10                	mov    %edx,(%eax)
  10641c:	8b 45 a0             	mov    -0x60(%ebp),%eax
  10641f:	8b 10                	mov    (%eax),%edx
  106421:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  106424:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
  106427:	8b 45 a8             	mov    -0x58(%ebp),%eax
  10642a:	8b 55 a0             	mov    -0x60(%ebp),%edx
  10642d:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
  106430:	8b 45 a8             	mov    -0x58(%ebp),%eax
  106433:	8b 55 a4             	mov    -0x5c(%ebp),%edx
  106436:	89 10                	mov    %edx,(%eax)
}
  106438:	90                   	nop
}
  106439:	90                   	nop
			list_add_after(list_next(le), &(rp->page_link));
  10643a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  10643d:	8d 50 0c             	lea    0xc(%eax),%edx
  106440:	8b 45 d8             	mov    -0x28(%ebp),%eax
  106443:	89 45 b4             	mov    %eax,-0x4c(%ebp)
    return listelm->next;
  106446:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  106449:	8b 40 04             	mov    0x4(%eax),%eax
  10644c:	89 45 c8             	mov    %eax,-0x38(%ebp)
  10644f:	89 55 c4             	mov    %edx,-0x3c(%ebp)
    __list_add(elm, listelm, listelm->next);
  106452:	8b 45 c8             	mov    -0x38(%ebp),%eax
  106455:	8b 40 04             	mov    0x4(%eax),%eax
  106458:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  10645b:	89 55 c0             	mov    %edx,-0x40(%ebp)
  10645e:	8b 55 c8             	mov    -0x38(%ebp),%edx
  106461:	89 55 bc             	mov    %edx,-0x44(%ebp)
  106464:	89 45 b8             	mov    %eax,-0x48(%ebp)
    prev->next = next->prev = elm;
  106467:	8b 45 b8             	mov    -0x48(%ebp),%eax
  10646a:	8b 55 c0             	mov    -0x40(%ebp),%edx
  10646d:	89 10                	mov    %edx,(%eax)
  10646f:	8b 45 b8             	mov    -0x48(%ebp),%eax
  106472:	8b 10                	mov    (%eax),%edx
  106474:	8b 45 bc             	mov    -0x44(%ebp),%eax
  106477:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
  10647a:	8b 45 c0             	mov    -0x40(%ebp),%eax
  10647d:	8b 55 b8             	mov    -0x48(%ebp),%edx
  106480:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
  106483:	8b 45 c0             	mov    -0x40(%ebp),%eax
  106486:	8b 55 bc             	mov    -0x44(%ebp),%edx
  106489:	89 10                	mov    %edx,(%eax)
}
  10648b:	90                   	nop
}
  10648c:	90                   	nop
		}
		if (buddy.longest[LEFT_LEAF(index)] >= n)
  10648d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  106490:	01 c0                	add    %eax,%eax
  106492:	40                   	inc    %eax
  106493:	8b 04 85 84 0f 12 00 	mov    0x120f84(,%eax,4),%eax
  10649a:	39 45 08             	cmp    %eax,0x8(%ebp)
  10649d:	77 0b                	ja     1064aa <buddy_alloc_pages+0x339>
			index = LEFT_LEAF(index);
  10649f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1064a2:	01 c0                	add    %eax,%eax
  1064a4:	40                   	inc    %eax
  1064a5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1064a8:	eb 09                	jmp    1064b3 <buddy_alloc_pages+0x342>
    	else 
			index = RIGHT_LEAF(index);
  1064aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1064ad:	40                   	inc    %eax
  1064ae:	01 c0                	add    %eax,%eax
  1064b0:	89 45 f4             	mov    %eax,-0xc(%ebp)
	for(node_size = buddy.size; node_size != n; node_size /= 2 ) {
  1064b3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1064b6:	d1 e8                	shr    %eax
  1064b8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1064bb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1064be:	3b 45 08             	cmp    0x8(%ebp),%eax
  1064c1:	0f 85 43 fd ff ff    	jne    10620a <buddy_alloc_pages+0x99>
  	}

	// 计算出下标，获得对应块的首页
	offset = (index + 1) * node_size - buddy.size;
  1064c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1064ca:	40                   	inc    %eax
  1064cb:	0f af 45 f0          	imul   -0x10(%ebp),%eax
  1064cf:	89 c2                	mov    %eax,%edx
  1064d1:	a1 80 0f 12 00       	mov    0x120f80,%eax
  1064d6:	29 c2                	sub    %eax,%edx
  1064d8:	89 d0                	mov    %edx,%eax
  1064da:	89 45 ec             	mov    %eax,-0x14(%ebp)
	logn = log(node_size);
  1064dd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1064e0:	89 04 24             	mov    %eax,(%esp)
  1064e3:	e8 3a f5 ff ff       	call   105a22 <log>
  1064e8:	89 45 dc             	mov    %eax,-0x24(%ebp)
	p = &buddy.base[offset];
  1064eb:	8b 0d 80 0f 32 00    	mov    0x320f80,%ecx
  1064f1:	8b 55 ec             	mov    -0x14(%ebp),%edx
  1064f4:	89 d0                	mov    %edx,%eax
  1064f6:	c1 e0 02             	shl    $0x2,%eax
  1064f9:	01 d0                	add    %edx,%eax
  1064fb:	c1 e0 02             	shl    $0x2,%eax
  1064fe:	01 c8                	add    %ecx,%eax
  106500:	89 45 e8             	mov    %eax,-0x18(%ebp)
	if (p == NULL) {
  106503:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  106507:	75 0a                	jne    106513 <buddy_alloc_pages+0x3a2>
		return NULL;
  106509:	b8 00 00 00 00       	mov    $0x0,%eax
  10650e:	e9 e5 00 00 00       	jmp    1065f8 <buddy_alloc_pages+0x487>
	}
	buddy.longest[index] = 0;
  106513:	8b 45 f4             	mov    -0xc(%ebp),%eax
  106516:	c7 04 85 84 0f 12 00 	movl   $0x0,0x120f84(,%eax,4)
  10651d:	00 00 00 00 
	// 更新上层节点的longest
	while (index) {
  106521:	eb 33                	jmp    106556 <buddy_alloc_pages+0x3e5>
    	index = PARENT(index);
  106523:	8b 45 f4             	mov    -0xc(%ebp),%eax
  106526:	40                   	inc    %eax
  106527:	d1 e8                	shr    %eax
  106529:	48                   	dec    %eax
  10652a:	89 45 f4             	mov    %eax,-0xc(%ebp)
    	buddy.longest[index] = MAX(buddy.longest[LEFT_LEAF(index)], buddy.longest[RIGHT_LEAF(index)]);
  10652d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  106530:	40                   	inc    %eax
  106531:	01 c0                	add    %eax,%eax
  106533:	8b 14 85 84 0f 12 00 	mov    0x120f84(,%eax,4),%edx
  10653a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10653d:	01 c0                	add    %eax,%eax
  10653f:	40                   	inc    %eax
  106540:	8b 04 85 84 0f 12 00 	mov    0x120f84(,%eax,4),%eax
  106547:	39 c2                	cmp    %eax,%edx
  106549:	0f 42 d0             	cmovb  %eax,%edx
  10654c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10654f:	89 14 85 84 0f 12 00 	mov    %edx,0x120f84(,%eax,4)
	while (index) {
  106556:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  10655a:	75 c7                	jne    106523 <buddy_alloc_pages+0x3b2>
  	}

	// 从链表中删除
	list_del(&(p->page_link));
  10655c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10655f:	83 c0 0c             	add    $0xc,%eax
  106562:	89 85 74 ff ff ff    	mov    %eax,-0x8c(%ebp)
    __list_del(listelm->prev, listelm->next);
  106568:	8b 85 74 ff ff ff    	mov    -0x8c(%ebp),%eax
  10656e:	8b 40 04             	mov    0x4(%eax),%eax
  106571:	8b 95 74 ff ff ff    	mov    -0x8c(%ebp),%edx
  106577:	8b 12                	mov    (%edx),%edx
  106579:	89 95 70 ff ff ff    	mov    %edx,-0x90(%ebp)
  10657f:	89 85 6c ff ff ff    	mov    %eax,-0x94(%ebp)
    prev->next = next;
  106585:	8b 85 70 ff ff ff    	mov    -0x90(%ebp),%eax
  10658b:	8b 95 6c ff ff ff    	mov    -0x94(%ebp),%edx
  106591:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
  106594:	8b 85 6c ff ff ff    	mov    -0x94(%ebp),%eax
  10659a:	8b 95 70 ff ff ff    	mov    -0x90(%ebp),%edx
  1065a0:	89 10                	mov    %edx,(%eax)
}
  1065a2:	90                   	nop
}
  1065a3:	90                   	nop
    nr_free(logn) -= node_size;
  1065a4:	8b 55 dc             	mov    -0x24(%ebp),%edx
  1065a7:	89 d0                	mov    %edx,%eax
  1065a9:	01 c0                	add    %eax,%eax
  1065ab:	01 d0                	add    %edx,%eax
  1065ad:	c1 e0 02             	shl    $0x2,%eax
  1065b0:	05 a8 0f 32 00       	add    $0x320fa8,%eax
  1065b5:	8b 00                	mov    (%eax),%eax
  1065b7:	2b 45 f0             	sub    -0x10(%ebp),%eax
  1065ba:	89 c1                	mov    %eax,%ecx
  1065bc:	8b 55 dc             	mov    -0x24(%ebp),%edx
  1065bf:	89 d0                	mov    %edx,%eax
  1065c1:	01 c0                	add    %eax,%eax
  1065c3:	01 d0                	add    %edx,%eax
  1065c5:	c1 e0 02             	shl    $0x2,%eax
  1065c8:	05 a8 0f 32 00       	add    $0x320fa8,%eax
  1065cd:	89 08                	mov    %ecx,(%eax)
    ClearPageProperty(p);
  1065cf:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1065d2:	83 c0 04             	add    $0x4,%eax
  1065d5:	c7 85 7c ff ff ff 01 	movl   $0x1,-0x84(%ebp)
  1065dc:	00 00 00 
  1065df:	89 85 78 ff ff ff    	mov    %eax,-0x88(%ebp)
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  1065e5:	8b 85 78 ff ff ff    	mov    -0x88(%ebp),%eax
  1065eb:	8b 95 7c ff ff ff    	mov    -0x84(%ebp),%edx
  1065f1:	0f b3 10             	btr    %edx,(%eax)
}
  1065f4:	90                   	nop
    return p;
  1065f5:	8b 45 e8             	mov    -0x18(%ebp),%eax
}
  1065f8:	c9                   	leave  
  1065f9:	c3                   	ret    

001065fa <buddy_nr_free_pages>:

// 计算空闲块的页总数
static size_t buddy_nr_free_pages(void) {
  1065fa:	f3 0f 1e fb          	endbr32 
  1065fe:	55                   	push   %ebp
  1065ff:	89 e5                	mov    %esp,%ebp
  106601:	83 ec 10             	sub    $0x10,%esp
	size_t nr = 0;
  106604:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int i = 0;
  10660b:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (; i <= MAX_LENGTH_LOG; i++) {
  106612:	eb 19                	jmp    10662d <buddy_nr_free_pages+0x33>
		nr += nr_free(i);
  106614:	8b 55 f8             	mov    -0x8(%ebp),%edx
  106617:	89 d0                	mov    %edx,%eax
  106619:	01 c0                	add    %eax,%eax
  10661b:	01 d0                	add    %edx,%eax
  10661d:	c1 e0 02             	shl    $0x2,%eax
  106620:	05 a8 0f 32 00       	add    $0x320fa8,%eax
  106625:	8b 00                	mov    (%eax),%eax
  106627:	01 45 fc             	add    %eax,-0x4(%ebp)
	for (; i <= MAX_LENGTH_LOG; i++) {
  10662a:	ff 45 f8             	incl   -0x8(%ebp)
  10662d:	83 7d f8 12          	cmpl   $0x12,-0x8(%ebp)
  106631:	7e e1                	jle    106614 <buddy_nr_free_pages+0x1a>
	}
    return nr;
  106633:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  106636:	c9                   	leave  
  106637:	c3                   	ret    

00106638 <buddy_check_tree>:

// 检查链表数组和二叉树各层完整节点
static void buddy_check_tree(void) {
  106638:	f3 0f 1e fb          	endbr32 
  10663c:	55                   	push   %ebp
  10663d:	89 e5                	mov    %esp,%ebp
  10663f:	53                   	push   %ebx
  106640:	83 ec 24             	sub    $0x24,%esp
	cprintf("free_pages: %d\n", buddy_nr_free_pages());
  106643:	e8 b2 ff ff ff       	call   1065fa <buddy_nr_free_pages>
  106648:	89 44 24 04          	mov    %eax,0x4(%esp)
  10664c:	c7 04 24 b8 8a 10 00 	movl   $0x108ab8,(%esp)
  106653:	e8 6d 9c ff ff       	call   1002c5 <cprintf>
	cprintf("---------------------------------------------------------------\n");
  106658:	c7 04 24 c8 8a 10 00 	movl   $0x108ac8,(%esp)
  10665f:	e8 61 9c ff ff       	call   1002c5 <cprintf>
	unsigned i = 0;
  106664:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (; i <= MAX_LENGTH_LOG; i++) {
  10666b:	e9 88 00 00 00       	jmp    1066f8 <buddy_check_tree+0xc0>
		unsigned num = 0;
  106670:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
		unsigned j = MAX_LENGTH >> i;
  106677:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10667a:	ba 00 00 04 00       	mov    $0x40000,%edx
  10667f:	88 c1                	mov    %al,%cl
  106681:	d3 fa                	sar    %cl,%edx
  106683:	89 d0                	mov    %edx,%eax
  106685:	89 45 ec             	mov    %eax,-0x14(%ebp)
		for (; j < ((MAX_LENGTH * 2) >> i); j++) {
  106688:	eb 27                	jmp    1066b1 <buddy_check_tree+0x79>
			if (buddy.longest[j] == (MAX_LENGTH >> (MAX_LENGTH_LOG - i))) {
  10668a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10668d:	8b 14 85 84 0f 12 00 	mov    0x120f84(,%eax,4),%edx
  106694:	b8 12 00 00 00       	mov    $0x12,%eax
  106699:	2b 45 f4             	sub    -0xc(%ebp),%eax
  10669c:	bb 00 00 04 00       	mov    $0x40000,%ebx
  1066a1:	88 c1                	mov    %al,%cl
  1066a3:	d3 fb                	sar    %cl,%ebx
  1066a5:	89 d8                	mov    %ebx,%eax
  1066a7:	39 c2                	cmp    %eax,%edx
  1066a9:	75 03                	jne    1066ae <buddy_check_tree+0x76>
				num++;
  1066ab:	ff 45 f0             	incl   -0x10(%ebp)
		for (; j < ((MAX_LENGTH * 2) >> i); j++) {
  1066ae:	ff 45 ec             	incl   -0x14(%ebp)
  1066b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1066b4:	ba 00 00 08 00       	mov    $0x80000,%edx
  1066b9:	88 c1                	mov    %al,%cl
  1066bb:	d3 fa                	sar    %cl,%edx
  1066bd:	89 d0                	mov    %edx,%eax
  1066bf:	39 45 ec             	cmp    %eax,-0x14(%ebp)
  1066c2:	72 c6                	jb     10668a <buddy_check_tree+0x52>
			}
		}
		cprintf("index: %d\ttotal: %d\tnum: %d\n", i, nr_free(i), num);
  1066c4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1066c7:	89 d0                	mov    %edx,%eax
  1066c9:	01 c0                	add    %eax,%eax
  1066cb:	01 d0                	add    %edx,%eax
  1066cd:	c1 e0 02             	shl    $0x2,%eax
  1066d0:	05 a8 0f 32 00       	add    $0x320fa8,%eax
  1066d5:	8b 00                	mov    (%eax),%eax
  1066d7:	8b 55 f0             	mov    -0x10(%ebp),%edx
  1066da:	89 54 24 0c          	mov    %edx,0xc(%esp)
  1066de:	89 44 24 08          	mov    %eax,0x8(%esp)
  1066e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1066e5:	89 44 24 04          	mov    %eax,0x4(%esp)
  1066e9:	c7 04 24 09 8b 10 00 	movl   $0x108b09,(%esp)
  1066f0:	e8 d0 9b ff ff       	call   1002c5 <cprintf>
	for (; i <= MAX_LENGTH_LOG; i++) {
  1066f5:	ff 45 f4             	incl   -0xc(%ebp)
  1066f8:	83 7d f4 12          	cmpl   $0x12,-0xc(%ebp)
  1066fc:	0f 86 6e ff ff ff    	jbe    106670 <buddy_check_tree+0x38>
	}
	cprintf("---------------------------------------------------------------\n");
  106702:	c7 04 24 c8 8a 10 00 	movl   $0x108ac8,(%esp)
  106709:	e8 b7 9b ff ff       	call   1002c5 <cprintf>
}
  10670e:	90                   	nop
  10670f:	83 c4 24             	add    $0x24,%esp
  106712:	5b                   	pop    %ebx
  106713:	5d                   	pop    %ebp
  106714:	c3                   	ret    

00106715 <buddy_check>:

static void buddy_check(void) {
  106715:	f3 0f 1e fb          	endbr32 
  106719:	55                   	push   %ebp
  10671a:	89 e5                	mov    %esp,%ebp
  10671c:	83 ec 28             	sub    $0x28,%esp
    struct Page  *p0, *p1;
    p0 = p1 =NULL;
  10671f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  106726:	8b 45 f4             	mov    -0xc(%ebp),%eax
  106729:	89 45 f0             	mov    %eax,-0x10(%ebp)

    assert((p0 = alloc_page()) != NULL);
  10672c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  106733:	e8 44 c9 ff ff       	call   10307c <alloc_pages>
  106738:	89 45 f0             	mov    %eax,-0x10(%ebp)
  10673b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  10673f:	75 24                	jne    106765 <buddy_check+0x50>
  106741:	c7 44 24 0c 26 8b 10 	movl   $0x108b26,0xc(%esp)
  106748:	00 
  106749:	c7 44 24 08 e8 89 10 	movl   $0x1089e8,0x8(%esp)
  106750:	00 
  106751:	c7 44 24 04 f9 00 00 	movl   $0xf9,0x4(%esp)
  106758:	00 
  106759:	c7 04 24 fd 89 10 00 	movl   $0x1089fd,(%esp)
  106760:	e8 cc 9c ff ff       	call   100431 <__panic>
    assert((p1 = alloc_page()) != NULL);
  106765:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  10676c:	e8 0b c9 ff ff       	call   10307c <alloc_pages>
  106771:	89 45 f4             	mov    %eax,-0xc(%ebp)
  106774:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  106778:	75 24                	jne    10679e <buddy_check+0x89>
  10677a:	c7 44 24 0c 42 8b 10 	movl   $0x108b42,0xc(%esp)
  106781:	00 
  106782:	c7 44 24 08 e8 89 10 	movl   $0x1089e8,0x8(%esp)
  106789:	00 
  10678a:	c7 44 24 04 fa 00 00 	movl   $0xfa,0x4(%esp)
  106791:	00 
  106792:	c7 04 24 fd 89 10 00 	movl   $0x1089fd,(%esp)
  106799:	e8 93 9c ff ff       	call   100431 <__panic>

    assert(p0 != p1);
  10679e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1067a1:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  1067a4:	75 24                	jne    1067ca <buddy_check+0xb5>
  1067a6:	c7 44 24 0c 5e 8b 10 	movl   $0x108b5e,0xc(%esp)
  1067ad:	00 
  1067ae:	c7 44 24 08 e8 89 10 	movl   $0x1089e8,0x8(%esp)
  1067b5:	00 
  1067b6:	c7 44 24 04 fc 00 00 	movl   $0xfc,0x4(%esp)
  1067bd:	00 
  1067be:	c7 04 24 fd 89 10 00 	movl   $0x1089fd,(%esp)
  1067c5:	e8 67 9c ff ff       	call   100431 <__panic>
    assert(page_ref(p0) == 0 && page_ref(p1) == 0);
  1067ca:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1067cd:	89 04 24             	mov    %eax,(%esp)
  1067d0:	e8 fc f1 ff ff       	call   1059d1 <page_ref>
  1067d5:	85 c0                	test   %eax,%eax
  1067d7:	75 0f                	jne    1067e8 <buddy_check+0xd3>
  1067d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1067dc:	89 04 24             	mov    %eax,(%esp)
  1067df:	e8 ed f1 ff ff       	call   1059d1 <page_ref>
  1067e4:	85 c0                	test   %eax,%eax
  1067e6:	74 24                	je     10680c <buddy_check+0xf7>
  1067e8:	c7 44 24 0c 68 8b 10 	movl   $0x108b68,0xc(%esp)
  1067ef:	00 
  1067f0:	c7 44 24 08 e8 89 10 	movl   $0x1089e8,0x8(%esp)
  1067f7:	00 
  1067f8:	c7 44 24 04 fd 00 00 	movl   $0xfd,0x4(%esp)
  1067ff:	00 
  106800:	c7 04 24 fd 89 10 00 	movl   $0x1089fd,(%esp)
  106807:	e8 25 9c ff ff       	call   100431 <__panic>

	cprintf("%d\n", 1);
  10680c:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  106813:	00 
  106814:	c7 04 24 8f 8b 10 00 	movl   $0x108b8f,(%esp)
  10681b:	e8 a5 9a ff ff       	call   1002c5 <cprintf>
	buddy_check_tree();
  106820:	e8 13 fe ff ff       	call   106638 <buddy_check_tree>

    free_page(p0);
  106825:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  10682c:	00 
  10682d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  106830:	89 04 24             	mov    %eax,(%esp)
  106833:	e8 80 c8 ff ff       	call   1030b8 <free_pages>
    free_page(p1);
  106838:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  10683f:	00 
  106840:	8b 45 f4             	mov    -0xc(%ebp),%eax
  106843:	89 04 24             	mov    %eax,(%esp)
  106846:	e8 6d c8 ff ff       	call   1030b8 <free_pages>

	buddy_check_tree();
  10684b:	e8 e8 fd ff ff       	call   106638 <buddy_check_tree>

	p0 = p1 =NULL;
  106850:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  106857:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10685a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	assert((p0 = alloc_pages(256)) != NULL);
  10685d:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
  106864:	e8 13 c8 ff ff       	call   10307c <alloc_pages>
  106869:	89 45 f0             	mov    %eax,-0x10(%ebp)
  10686c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  106870:	75 24                	jne    106896 <buddy_check+0x181>
  106872:	c7 44 24 0c 94 8b 10 	movl   $0x108b94,0xc(%esp)
  106879:	00 
  10687a:	c7 44 24 08 e8 89 10 	movl   $0x1089e8,0x8(%esp)
  106881:	00 
  106882:	c7 44 24 04 08 01 00 	movl   $0x108,0x4(%esp)
  106889:	00 
  10688a:	c7 04 24 fd 89 10 00 	movl   $0x1089fd,(%esp)
  106891:	e8 9b 9b ff ff       	call   100431 <__panic>
    assert((p1 = alloc_pages(256)) != NULL);
  106896:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
  10689d:	e8 da c7 ff ff       	call   10307c <alloc_pages>
  1068a2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1068a5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1068a9:	75 24                	jne    1068cf <buddy_check+0x1ba>
  1068ab:	c7 44 24 0c b4 8b 10 	movl   $0x108bb4,0xc(%esp)
  1068b2:	00 
  1068b3:	c7 44 24 08 e8 89 10 	movl   $0x1089e8,0x8(%esp)
  1068ba:	00 
  1068bb:	c7 44 24 04 09 01 00 	movl   $0x109,0x4(%esp)
  1068c2:	00 
  1068c3:	c7 04 24 fd 89 10 00 	movl   $0x1089fd,(%esp)
  1068ca:	e8 62 9b ff ff       	call   100431 <__panic>
	assert(p0 != p1);
  1068cf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1068d2:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  1068d5:	75 24                	jne    1068fb <buddy_check+0x1e6>
  1068d7:	c7 44 24 0c 5e 8b 10 	movl   $0x108b5e,0xc(%esp)
  1068de:	00 
  1068df:	c7 44 24 08 e8 89 10 	movl   $0x1089e8,0x8(%esp)
  1068e6:	00 
  1068e7:	c7 44 24 04 0a 01 00 	movl   $0x10a,0x4(%esp)
  1068ee:	00 
  1068ef:	c7 04 24 fd 89 10 00 	movl   $0x1089fd,(%esp)
  1068f6:	e8 36 9b ff ff       	call   100431 <__panic>
    assert(page_ref(p0) == 0 && page_ref(p1) == 0);
  1068fb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1068fe:	89 04 24             	mov    %eax,(%esp)
  106901:	e8 cb f0 ff ff       	call   1059d1 <page_ref>
  106906:	85 c0                	test   %eax,%eax
  106908:	75 0f                	jne    106919 <buddy_check+0x204>
  10690a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10690d:	89 04 24             	mov    %eax,(%esp)
  106910:	e8 bc f0 ff ff       	call   1059d1 <page_ref>
  106915:	85 c0                	test   %eax,%eax
  106917:	74 24                	je     10693d <buddy_check+0x228>
  106919:	c7 44 24 0c 68 8b 10 	movl   $0x108b68,0xc(%esp)
  106920:	00 
  106921:	c7 44 24 08 e8 89 10 	movl   $0x1089e8,0x8(%esp)
  106928:	00 
  106929:	c7 44 24 04 0b 01 00 	movl   $0x10b,0x4(%esp)
  106930:	00 
  106931:	c7 04 24 fd 89 10 00 	movl   $0x1089fd,(%esp)
  106938:	e8 f4 9a ff ff       	call   100431 <__panic>
	assert(p0->property == 256 && p1->property == 256);
  10693d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  106940:	8b 40 08             	mov    0x8(%eax),%eax
  106943:	3d 00 01 00 00       	cmp    $0x100,%eax
  106948:	75 0d                	jne    106957 <buddy_check+0x242>
  10694a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10694d:	8b 40 08             	mov    0x8(%eax),%eax
  106950:	3d 00 01 00 00       	cmp    $0x100,%eax
  106955:	74 24                	je     10697b <buddy_check+0x266>
  106957:	c7 44 24 0c d4 8b 10 	movl   $0x108bd4,0xc(%esp)
  10695e:	00 
  10695f:	c7 44 24 08 e8 89 10 	movl   $0x1089e8,0x8(%esp)
  106966:	00 
  106967:	c7 44 24 04 0c 01 00 	movl   $0x10c,0x4(%esp)
  10696e:	00 
  10696f:	c7 04 24 fd 89 10 00 	movl   $0x1089fd,(%esp)
  106976:	e8 b6 9a ff ff       	call   100431 <__panic>

	cprintf("%d\n", 256);
  10697b:	c7 44 24 04 00 01 00 	movl   $0x100,0x4(%esp)
  106982:	00 
  106983:	c7 04 24 8f 8b 10 00 	movl   $0x108b8f,(%esp)
  10698a:	e8 36 99 ff ff       	call   1002c5 <cprintf>
	buddy_check_tree();
  10698f:	e8 a4 fc ff ff       	call   106638 <buddy_check_tree>

    free_pages(p0, 256);
  106994:	c7 44 24 04 00 01 00 	movl   $0x100,0x4(%esp)
  10699b:	00 
  10699c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10699f:	89 04 24             	mov    %eax,(%esp)
  1069a2:	e8 11 c7 ff ff       	call   1030b8 <free_pages>
    free_pages(p1, 256);
  1069a7:	c7 44 24 04 00 01 00 	movl   $0x100,0x4(%esp)
  1069ae:	00 
  1069af:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1069b2:	89 04 24             	mov    %eax,(%esp)
  1069b5:	e8 fe c6 ff ff       	call   1030b8 <free_pages>

	buddy_check_tree();
  1069ba:	e8 79 fc ff ff       	call   106638 <buddy_check_tree>

	p0 = p1 =NULL;
  1069bf:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  1069c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1069c9:	89 45 f0             	mov    %eax,-0x10(%ebp)
	assert((p0 = alloc_pages(1024)) != NULL);
  1069cc:	c7 04 24 00 04 00 00 	movl   $0x400,(%esp)
  1069d3:	e8 a4 c6 ff ff       	call   10307c <alloc_pages>
  1069d8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1069db:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  1069df:	75 24                	jne    106a05 <buddy_check+0x2f0>
  1069e1:	c7 44 24 0c 00 8c 10 	movl   $0x108c00,0xc(%esp)
  1069e8:	00 
  1069e9:	c7 44 24 08 e8 89 10 	movl   $0x1089e8,0x8(%esp)
  1069f0:	00 
  1069f1:	c7 44 24 04 17 01 00 	movl   $0x117,0x4(%esp)
  1069f8:	00 
  1069f9:	c7 04 24 fd 89 10 00 	movl   $0x1089fd,(%esp)
  106a00:	e8 2c 9a ff ff       	call   100431 <__panic>
    assert((p1 = alloc_pages(1024)) != NULL);
  106a05:	c7 04 24 00 04 00 00 	movl   $0x400,(%esp)
  106a0c:	e8 6b c6 ff ff       	call   10307c <alloc_pages>
  106a11:	89 45 f4             	mov    %eax,-0xc(%ebp)
  106a14:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  106a18:	75 24                	jne    106a3e <buddy_check+0x329>
  106a1a:	c7 44 24 0c 24 8c 10 	movl   $0x108c24,0xc(%esp)
  106a21:	00 
  106a22:	c7 44 24 08 e8 89 10 	movl   $0x1089e8,0x8(%esp)
  106a29:	00 
  106a2a:	c7 44 24 04 18 01 00 	movl   $0x118,0x4(%esp)
  106a31:	00 
  106a32:	c7 04 24 fd 89 10 00 	movl   $0x1089fd,(%esp)
  106a39:	e8 f3 99 ff ff       	call   100431 <__panic>
	assert(p0 != p1);
  106a3e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  106a41:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  106a44:	75 24                	jne    106a6a <buddy_check+0x355>
  106a46:	c7 44 24 0c 5e 8b 10 	movl   $0x108b5e,0xc(%esp)
  106a4d:	00 
  106a4e:	c7 44 24 08 e8 89 10 	movl   $0x1089e8,0x8(%esp)
  106a55:	00 
  106a56:	c7 44 24 04 19 01 00 	movl   $0x119,0x4(%esp)
  106a5d:	00 
  106a5e:	c7 04 24 fd 89 10 00 	movl   $0x1089fd,(%esp)
  106a65:	e8 c7 99 ff ff       	call   100431 <__panic>
    assert(page_ref(p0) == 0 && page_ref(p1) == 0);
  106a6a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  106a6d:	89 04 24             	mov    %eax,(%esp)
  106a70:	e8 5c ef ff ff       	call   1059d1 <page_ref>
  106a75:	85 c0                	test   %eax,%eax
  106a77:	75 0f                	jne    106a88 <buddy_check+0x373>
  106a79:	8b 45 f4             	mov    -0xc(%ebp),%eax
  106a7c:	89 04 24             	mov    %eax,(%esp)
  106a7f:	e8 4d ef ff ff       	call   1059d1 <page_ref>
  106a84:	85 c0                	test   %eax,%eax
  106a86:	74 24                	je     106aac <buddy_check+0x397>
  106a88:	c7 44 24 0c 68 8b 10 	movl   $0x108b68,0xc(%esp)
  106a8f:	00 
  106a90:	c7 44 24 08 e8 89 10 	movl   $0x1089e8,0x8(%esp)
  106a97:	00 
  106a98:	c7 44 24 04 1a 01 00 	movl   $0x11a,0x4(%esp)
  106a9f:	00 
  106aa0:	c7 04 24 fd 89 10 00 	movl   $0x1089fd,(%esp)
  106aa7:	e8 85 99 ff ff       	call   100431 <__panic>
	assert(p0->property == 1024 && p1->property == 1024);
  106aac:	8b 45 f0             	mov    -0x10(%ebp),%eax
  106aaf:	8b 40 08             	mov    0x8(%eax),%eax
  106ab2:	3d 00 04 00 00       	cmp    $0x400,%eax
  106ab7:	75 0d                	jne    106ac6 <buddy_check+0x3b1>
  106ab9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  106abc:	8b 40 08             	mov    0x8(%eax),%eax
  106abf:	3d 00 04 00 00       	cmp    $0x400,%eax
  106ac4:	74 24                	je     106aea <buddy_check+0x3d5>
  106ac6:	c7 44 24 0c 48 8c 10 	movl   $0x108c48,0xc(%esp)
  106acd:	00 
  106ace:	c7 44 24 08 e8 89 10 	movl   $0x1089e8,0x8(%esp)
  106ad5:	00 
  106ad6:	c7 44 24 04 1b 01 00 	movl   $0x11b,0x4(%esp)
  106add:	00 
  106ade:	c7 04 24 fd 89 10 00 	movl   $0x1089fd,(%esp)
  106ae5:	e8 47 99 ff ff       	call   100431 <__panic>

	cprintf("%d\n", 1024);
  106aea:	c7 44 24 04 00 04 00 	movl   $0x400,0x4(%esp)
  106af1:	00 
  106af2:	c7 04 24 8f 8b 10 00 	movl   $0x108b8f,(%esp)
  106af9:	e8 c7 97 ff ff       	call   1002c5 <cprintf>
	buddy_check_tree();
  106afe:	e8 35 fb ff ff       	call   106638 <buddy_check_tree>

    free_pages(p0, 1024);
  106b03:	c7 44 24 04 00 04 00 	movl   $0x400,0x4(%esp)
  106b0a:	00 
  106b0b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  106b0e:	89 04 24             	mov    %eax,(%esp)
  106b11:	e8 a2 c5 ff ff       	call   1030b8 <free_pages>
    free_pages(p1, 1024);
  106b16:	c7 44 24 04 00 04 00 	movl   $0x400,0x4(%esp)
  106b1d:	00 
  106b1e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  106b21:	89 04 24             	mov    %eax,(%esp)
  106b24:	e8 8f c5 ff ff       	call   1030b8 <free_pages>

	buddy_check_tree();
  106b29:	e8 0a fb ff ff       	call   106638 <buddy_check_tree>

	p0 = p1 =NULL;
  106b2e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  106b35:	8b 45 f4             	mov    -0xc(%ebp),%eax
  106b38:	89 45 f0             	mov    %eax,-0x10(%ebp)
	assert((p0 = alloc_pages(1000)) != NULL);
  106b3b:	c7 04 24 e8 03 00 00 	movl   $0x3e8,(%esp)
  106b42:	e8 35 c5 ff ff       	call   10307c <alloc_pages>
  106b47:	89 45 f0             	mov    %eax,-0x10(%ebp)
  106b4a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  106b4e:	75 24                	jne    106b74 <buddy_check+0x45f>
  106b50:	c7 44 24 0c 78 8c 10 	movl   $0x108c78,0xc(%esp)
  106b57:	00 
  106b58:	c7 44 24 08 e8 89 10 	movl   $0x1089e8,0x8(%esp)
  106b5f:	00 
  106b60:	c7 44 24 04 26 01 00 	movl   $0x126,0x4(%esp)
  106b67:	00 
  106b68:	c7 04 24 fd 89 10 00 	movl   $0x1089fd,(%esp)
  106b6f:	e8 bd 98 ff ff       	call   100431 <__panic>
    assert((p1 = alloc_pages(1000)) != NULL);
  106b74:	c7 04 24 e8 03 00 00 	movl   $0x3e8,(%esp)
  106b7b:	e8 fc c4 ff ff       	call   10307c <alloc_pages>
  106b80:	89 45 f4             	mov    %eax,-0xc(%ebp)
  106b83:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  106b87:	75 24                	jne    106bad <buddy_check+0x498>
  106b89:	c7 44 24 0c 9c 8c 10 	movl   $0x108c9c,0xc(%esp)
  106b90:	00 
  106b91:	c7 44 24 08 e8 89 10 	movl   $0x1089e8,0x8(%esp)
  106b98:	00 
  106b99:	c7 44 24 04 27 01 00 	movl   $0x127,0x4(%esp)
  106ba0:	00 
  106ba1:	c7 04 24 fd 89 10 00 	movl   $0x1089fd,(%esp)
  106ba8:	e8 84 98 ff ff       	call   100431 <__panic>
	assert(p0 != p1);
  106bad:	8b 45 f0             	mov    -0x10(%ebp),%eax
  106bb0:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  106bb3:	75 24                	jne    106bd9 <buddy_check+0x4c4>
  106bb5:	c7 44 24 0c 5e 8b 10 	movl   $0x108b5e,0xc(%esp)
  106bbc:	00 
  106bbd:	c7 44 24 08 e8 89 10 	movl   $0x1089e8,0x8(%esp)
  106bc4:	00 
  106bc5:	c7 44 24 04 28 01 00 	movl   $0x128,0x4(%esp)
  106bcc:	00 
  106bcd:	c7 04 24 fd 89 10 00 	movl   $0x1089fd,(%esp)
  106bd4:	e8 58 98 ff ff       	call   100431 <__panic>
    assert(page_ref(p0) == 0 && page_ref(p1) == 0);
  106bd9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  106bdc:	89 04 24             	mov    %eax,(%esp)
  106bdf:	e8 ed ed ff ff       	call   1059d1 <page_ref>
  106be4:	85 c0                	test   %eax,%eax
  106be6:	75 0f                	jne    106bf7 <buddy_check+0x4e2>
  106be8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  106beb:	89 04 24             	mov    %eax,(%esp)
  106bee:	e8 de ed ff ff       	call   1059d1 <page_ref>
  106bf3:	85 c0                	test   %eax,%eax
  106bf5:	74 24                	je     106c1b <buddy_check+0x506>
  106bf7:	c7 44 24 0c 68 8b 10 	movl   $0x108b68,0xc(%esp)
  106bfe:	00 
  106bff:	c7 44 24 08 e8 89 10 	movl   $0x1089e8,0x8(%esp)
  106c06:	00 
  106c07:	c7 44 24 04 29 01 00 	movl   $0x129,0x4(%esp)
  106c0e:	00 
  106c0f:	c7 04 24 fd 89 10 00 	movl   $0x1089fd,(%esp)
  106c16:	e8 16 98 ff ff       	call   100431 <__panic>
	assert(p0->property == 1024 && p1->property == 1024);
  106c1b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  106c1e:	8b 40 08             	mov    0x8(%eax),%eax
  106c21:	3d 00 04 00 00       	cmp    $0x400,%eax
  106c26:	75 0d                	jne    106c35 <buddy_check+0x520>
  106c28:	8b 45 f4             	mov    -0xc(%ebp),%eax
  106c2b:	8b 40 08             	mov    0x8(%eax),%eax
  106c2e:	3d 00 04 00 00       	cmp    $0x400,%eax
  106c33:	74 24                	je     106c59 <buddy_check+0x544>
  106c35:	c7 44 24 0c 48 8c 10 	movl   $0x108c48,0xc(%esp)
  106c3c:	00 
  106c3d:	c7 44 24 08 e8 89 10 	movl   $0x1089e8,0x8(%esp)
  106c44:	00 
  106c45:	c7 44 24 04 2a 01 00 	movl   $0x12a,0x4(%esp)
  106c4c:	00 
  106c4d:	c7 04 24 fd 89 10 00 	movl   $0x1089fd,(%esp)
  106c54:	e8 d8 97 ff ff       	call   100431 <__panic>

	cprintf("%d\n", 1000);
  106c59:	c7 44 24 04 e8 03 00 	movl   $0x3e8,0x4(%esp)
  106c60:	00 
  106c61:	c7 04 24 8f 8b 10 00 	movl   $0x108b8f,(%esp)
  106c68:	e8 58 96 ff ff       	call   1002c5 <cprintf>
	buddy_check_tree();
  106c6d:	e8 c6 f9 ff ff       	call   106638 <buddy_check_tree>

    free_pages(p0, 1024);
  106c72:	c7 44 24 04 00 04 00 	movl   $0x400,0x4(%esp)
  106c79:	00 
  106c7a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  106c7d:	89 04 24             	mov    %eax,(%esp)
  106c80:	e8 33 c4 ff ff       	call   1030b8 <free_pages>
    free_pages(p1, 1024);
  106c85:	c7 44 24 04 00 04 00 	movl   $0x400,0x4(%esp)
  106c8c:	00 
  106c8d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  106c90:	89 04 24             	mov    %eax,(%esp)
  106c93:	e8 20 c4 ff ff       	call   1030b8 <free_pages>

	buddy_check_tree();
  106c98:	e8 9b f9 ff ff       	call   106638 <buddy_check_tree>
}
  106c9d:	90                   	nop
  106c9e:	c9                   	leave  
  106c9f:	c3                   	ret    

00106ca0 <strlen>:
 * @s:      the input string
 *
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
  106ca0:	f3 0f 1e fb          	endbr32 
  106ca4:	55                   	push   %ebp
  106ca5:	89 e5                	mov    %esp,%ebp
  106ca7:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
  106caa:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (*s ++ != '\0') {
  106cb1:	eb 03                	jmp    106cb6 <strlen+0x16>
        cnt ++;
  106cb3:	ff 45 fc             	incl   -0x4(%ebp)
    while (*s ++ != '\0') {
  106cb6:	8b 45 08             	mov    0x8(%ebp),%eax
  106cb9:	8d 50 01             	lea    0x1(%eax),%edx
  106cbc:	89 55 08             	mov    %edx,0x8(%ebp)
  106cbf:	0f b6 00             	movzbl (%eax),%eax
  106cc2:	84 c0                	test   %al,%al
  106cc4:	75 ed                	jne    106cb3 <strlen+0x13>
    }
    return cnt;
  106cc6:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  106cc9:	c9                   	leave  
  106cca:	c3                   	ret    

00106ccb <strnlen>:
 * The return value is strlen(s), if that is less than @len, or
 * @len if there is no '\0' character among the first @len characters
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
  106ccb:	f3 0f 1e fb          	endbr32 
  106ccf:	55                   	push   %ebp
  106cd0:	89 e5                	mov    %esp,%ebp
  106cd2:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
  106cd5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (cnt < len && *s ++ != '\0') {
  106cdc:	eb 03                	jmp    106ce1 <strnlen+0x16>
        cnt ++;
  106cde:	ff 45 fc             	incl   -0x4(%ebp)
    while (cnt < len && *s ++ != '\0') {
  106ce1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  106ce4:	3b 45 0c             	cmp    0xc(%ebp),%eax
  106ce7:	73 10                	jae    106cf9 <strnlen+0x2e>
  106ce9:	8b 45 08             	mov    0x8(%ebp),%eax
  106cec:	8d 50 01             	lea    0x1(%eax),%edx
  106cef:	89 55 08             	mov    %edx,0x8(%ebp)
  106cf2:	0f b6 00             	movzbl (%eax),%eax
  106cf5:	84 c0                	test   %al,%al
  106cf7:	75 e5                	jne    106cde <strnlen+0x13>
    }
    return cnt;
  106cf9:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  106cfc:	c9                   	leave  
  106cfd:	c3                   	ret    

00106cfe <strcpy>:
 * To avoid overflows, the size of array pointed by @dst should be long enough to
 * contain the same string as @src (including the terminating null character), and
 * should not overlap in memory with @src.
 * */
char *
strcpy(char *dst, const char *src) {
  106cfe:	f3 0f 1e fb          	endbr32 
  106d02:	55                   	push   %ebp
  106d03:	89 e5                	mov    %esp,%ebp
  106d05:	57                   	push   %edi
  106d06:	56                   	push   %esi
  106d07:	83 ec 20             	sub    $0x20,%esp
  106d0a:	8b 45 08             	mov    0x8(%ebp),%eax
  106d0d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  106d10:	8b 45 0c             	mov    0xc(%ebp),%eax
  106d13:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCPY
#define __HAVE_ARCH_STRCPY
static inline char *
__strcpy(char *dst, const char *src) {
    int d0, d1, d2;
    asm volatile (
  106d16:	8b 55 f0             	mov    -0x10(%ebp),%edx
  106d19:	8b 45 f4             	mov    -0xc(%ebp),%eax
  106d1c:	89 d1                	mov    %edx,%ecx
  106d1e:	89 c2                	mov    %eax,%edx
  106d20:	89 ce                	mov    %ecx,%esi
  106d22:	89 d7                	mov    %edx,%edi
  106d24:	ac                   	lods   %ds:(%esi),%al
  106d25:	aa                   	stos   %al,%es:(%edi)
  106d26:	84 c0                	test   %al,%al
  106d28:	75 fa                	jne    106d24 <strcpy+0x26>
  106d2a:	89 fa                	mov    %edi,%edx
  106d2c:	89 f1                	mov    %esi,%ecx
  106d2e:	89 4d ec             	mov    %ecx,-0x14(%ebp)
  106d31:	89 55 e8             	mov    %edx,-0x18(%ebp)
  106d34:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        "stosb;"
        "testb %%al, %%al;"
        "jne 1b;"
        : "=&S" (d0), "=&D" (d1), "=&a" (d2)
        : "0" (src), "1" (dst) : "memory");
    return dst;
  106d37:	8b 45 f4             	mov    -0xc(%ebp),%eax
    char *p = dst;
    while ((*p ++ = *src ++) != '\0')
        /* nothing */;
    return dst;
#endif /* __HAVE_ARCH_STRCPY */
}
  106d3a:	83 c4 20             	add    $0x20,%esp
  106d3d:	5e                   	pop    %esi
  106d3e:	5f                   	pop    %edi
  106d3f:	5d                   	pop    %ebp
  106d40:	c3                   	ret    

00106d41 <strncpy>:
 * @len:    maximum number of characters to be copied from @src
 *
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
  106d41:	f3 0f 1e fb          	endbr32 
  106d45:	55                   	push   %ebp
  106d46:	89 e5                	mov    %esp,%ebp
  106d48:	83 ec 10             	sub    $0x10,%esp
    char *p = dst;
  106d4b:	8b 45 08             	mov    0x8(%ebp),%eax
  106d4e:	89 45 fc             	mov    %eax,-0x4(%ebp)
    while (len > 0) {
  106d51:	eb 1e                	jmp    106d71 <strncpy+0x30>
        if ((*p = *src) != '\0') {
  106d53:	8b 45 0c             	mov    0xc(%ebp),%eax
  106d56:	0f b6 10             	movzbl (%eax),%edx
  106d59:	8b 45 fc             	mov    -0x4(%ebp),%eax
  106d5c:	88 10                	mov    %dl,(%eax)
  106d5e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  106d61:	0f b6 00             	movzbl (%eax),%eax
  106d64:	84 c0                	test   %al,%al
  106d66:	74 03                	je     106d6b <strncpy+0x2a>
            src ++;
  106d68:	ff 45 0c             	incl   0xc(%ebp)
        }
        p ++, len --;
  106d6b:	ff 45 fc             	incl   -0x4(%ebp)
  106d6e:	ff 4d 10             	decl   0x10(%ebp)
    while (len > 0) {
  106d71:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  106d75:	75 dc                	jne    106d53 <strncpy+0x12>
    }
    return dst;
  106d77:	8b 45 08             	mov    0x8(%ebp),%eax
}
  106d7a:	c9                   	leave  
  106d7b:	c3                   	ret    

00106d7c <strcmp>:
 * - A value greater than zero indicates that the first character that does
 *   not match has a greater value in @s1 than in @s2;
 * - And a value less than zero indicates the opposite.
 * */
int
strcmp(const char *s1, const char *s2) {
  106d7c:	f3 0f 1e fb          	endbr32 
  106d80:	55                   	push   %ebp
  106d81:	89 e5                	mov    %esp,%ebp
  106d83:	57                   	push   %edi
  106d84:	56                   	push   %esi
  106d85:	83 ec 20             	sub    $0x20,%esp
  106d88:	8b 45 08             	mov    0x8(%ebp),%eax
  106d8b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  106d8e:	8b 45 0c             	mov    0xc(%ebp),%eax
  106d91:	89 45 f0             	mov    %eax,-0x10(%ebp)
    asm volatile (
  106d94:	8b 55 f4             	mov    -0xc(%ebp),%edx
  106d97:	8b 45 f0             	mov    -0x10(%ebp),%eax
  106d9a:	89 d1                	mov    %edx,%ecx
  106d9c:	89 c2                	mov    %eax,%edx
  106d9e:	89 ce                	mov    %ecx,%esi
  106da0:	89 d7                	mov    %edx,%edi
  106da2:	ac                   	lods   %ds:(%esi),%al
  106da3:	ae                   	scas   %es:(%edi),%al
  106da4:	75 08                	jne    106dae <strcmp+0x32>
  106da6:	84 c0                	test   %al,%al
  106da8:	75 f8                	jne    106da2 <strcmp+0x26>
  106daa:	31 c0                	xor    %eax,%eax
  106dac:	eb 04                	jmp    106db2 <strcmp+0x36>
  106dae:	19 c0                	sbb    %eax,%eax
  106db0:	0c 01                	or     $0x1,%al
  106db2:	89 fa                	mov    %edi,%edx
  106db4:	89 f1                	mov    %esi,%ecx
  106db6:	89 45 ec             	mov    %eax,-0x14(%ebp)
  106db9:	89 4d e8             	mov    %ecx,-0x18(%ebp)
  106dbc:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    return ret;
  106dbf:	8b 45 ec             	mov    -0x14(%ebp),%eax
    while (*s1 != '\0' && *s1 == *s2) {
        s1 ++, s2 ++;
    }
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
#endif /* __HAVE_ARCH_STRCMP */
}
  106dc2:	83 c4 20             	add    $0x20,%esp
  106dc5:	5e                   	pop    %esi
  106dc6:	5f                   	pop    %edi
  106dc7:	5d                   	pop    %ebp
  106dc8:	c3                   	ret    

00106dc9 <strncmp>:
 * they are equal to each other, it continues with the following pairs until
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
  106dc9:	f3 0f 1e fb          	endbr32 
  106dcd:	55                   	push   %ebp
  106dce:	89 e5                	mov    %esp,%ebp
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
  106dd0:	eb 09                	jmp    106ddb <strncmp+0x12>
        n --, s1 ++, s2 ++;
  106dd2:	ff 4d 10             	decl   0x10(%ebp)
  106dd5:	ff 45 08             	incl   0x8(%ebp)
  106dd8:	ff 45 0c             	incl   0xc(%ebp)
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
  106ddb:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  106ddf:	74 1a                	je     106dfb <strncmp+0x32>
  106de1:	8b 45 08             	mov    0x8(%ebp),%eax
  106de4:	0f b6 00             	movzbl (%eax),%eax
  106de7:	84 c0                	test   %al,%al
  106de9:	74 10                	je     106dfb <strncmp+0x32>
  106deb:	8b 45 08             	mov    0x8(%ebp),%eax
  106dee:	0f b6 10             	movzbl (%eax),%edx
  106df1:	8b 45 0c             	mov    0xc(%ebp),%eax
  106df4:	0f b6 00             	movzbl (%eax),%eax
  106df7:	38 c2                	cmp    %al,%dl
  106df9:	74 d7                	je     106dd2 <strncmp+0x9>
    }
    return (n == 0) ? 0 : (int)((unsigned char)*s1 - (unsigned char)*s2);
  106dfb:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  106dff:	74 18                	je     106e19 <strncmp+0x50>
  106e01:	8b 45 08             	mov    0x8(%ebp),%eax
  106e04:	0f b6 00             	movzbl (%eax),%eax
  106e07:	0f b6 d0             	movzbl %al,%edx
  106e0a:	8b 45 0c             	mov    0xc(%ebp),%eax
  106e0d:	0f b6 00             	movzbl (%eax),%eax
  106e10:	0f b6 c0             	movzbl %al,%eax
  106e13:	29 c2                	sub    %eax,%edx
  106e15:	89 d0                	mov    %edx,%eax
  106e17:	eb 05                	jmp    106e1e <strncmp+0x55>
  106e19:	b8 00 00 00 00       	mov    $0x0,%eax
}
  106e1e:	5d                   	pop    %ebp
  106e1f:	c3                   	ret    

00106e20 <strchr>:
 *
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
  106e20:	f3 0f 1e fb          	endbr32 
  106e24:	55                   	push   %ebp
  106e25:	89 e5                	mov    %esp,%ebp
  106e27:	83 ec 04             	sub    $0x4,%esp
  106e2a:	8b 45 0c             	mov    0xc(%ebp),%eax
  106e2d:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
  106e30:	eb 13                	jmp    106e45 <strchr+0x25>
        if (*s == c) {
  106e32:	8b 45 08             	mov    0x8(%ebp),%eax
  106e35:	0f b6 00             	movzbl (%eax),%eax
  106e38:	38 45 fc             	cmp    %al,-0x4(%ebp)
  106e3b:	75 05                	jne    106e42 <strchr+0x22>
            return (char *)s;
  106e3d:	8b 45 08             	mov    0x8(%ebp),%eax
  106e40:	eb 12                	jmp    106e54 <strchr+0x34>
        }
        s ++;
  106e42:	ff 45 08             	incl   0x8(%ebp)
    while (*s != '\0') {
  106e45:	8b 45 08             	mov    0x8(%ebp),%eax
  106e48:	0f b6 00             	movzbl (%eax),%eax
  106e4b:	84 c0                	test   %al,%al
  106e4d:	75 e3                	jne    106e32 <strchr+0x12>
    }
    return NULL;
  106e4f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  106e54:	c9                   	leave  
  106e55:	c3                   	ret    

00106e56 <strfind>:
 * The strfind() function is like strchr() except that if @c is
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
  106e56:	f3 0f 1e fb          	endbr32 
  106e5a:	55                   	push   %ebp
  106e5b:	89 e5                	mov    %esp,%ebp
  106e5d:	83 ec 04             	sub    $0x4,%esp
  106e60:	8b 45 0c             	mov    0xc(%ebp),%eax
  106e63:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
  106e66:	eb 0e                	jmp    106e76 <strfind+0x20>
        if (*s == c) {
  106e68:	8b 45 08             	mov    0x8(%ebp),%eax
  106e6b:	0f b6 00             	movzbl (%eax),%eax
  106e6e:	38 45 fc             	cmp    %al,-0x4(%ebp)
  106e71:	74 0f                	je     106e82 <strfind+0x2c>
            break;
        }
        s ++;
  106e73:	ff 45 08             	incl   0x8(%ebp)
    while (*s != '\0') {
  106e76:	8b 45 08             	mov    0x8(%ebp),%eax
  106e79:	0f b6 00             	movzbl (%eax),%eax
  106e7c:	84 c0                	test   %al,%al
  106e7e:	75 e8                	jne    106e68 <strfind+0x12>
  106e80:	eb 01                	jmp    106e83 <strfind+0x2d>
            break;
  106e82:	90                   	nop
    }
    return (char *)s;
  106e83:	8b 45 08             	mov    0x8(%ebp),%eax
}
  106e86:	c9                   	leave  
  106e87:	c3                   	ret    

00106e88 <strtol>:
 * an optional "0x" or "0X" prefix.
 *
 * The strtol() function returns the converted integral number as a long int value.
 * */
long
strtol(const char *s, char **endptr, int base) {
  106e88:	f3 0f 1e fb          	endbr32 
  106e8c:	55                   	push   %ebp
  106e8d:	89 e5                	mov    %esp,%ebp
  106e8f:	83 ec 10             	sub    $0x10,%esp
    int neg = 0;
  106e92:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    long val = 0;
  106e99:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
  106ea0:	eb 03                	jmp    106ea5 <strtol+0x1d>
        s ++;
  106ea2:	ff 45 08             	incl   0x8(%ebp)
    while (*s == ' ' || *s == '\t') {
  106ea5:	8b 45 08             	mov    0x8(%ebp),%eax
  106ea8:	0f b6 00             	movzbl (%eax),%eax
  106eab:	3c 20                	cmp    $0x20,%al
  106ead:	74 f3                	je     106ea2 <strtol+0x1a>
  106eaf:	8b 45 08             	mov    0x8(%ebp),%eax
  106eb2:	0f b6 00             	movzbl (%eax),%eax
  106eb5:	3c 09                	cmp    $0x9,%al
  106eb7:	74 e9                	je     106ea2 <strtol+0x1a>
    }

    // plus/minus sign
    if (*s == '+') {
  106eb9:	8b 45 08             	mov    0x8(%ebp),%eax
  106ebc:	0f b6 00             	movzbl (%eax),%eax
  106ebf:	3c 2b                	cmp    $0x2b,%al
  106ec1:	75 05                	jne    106ec8 <strtol+0x40>
        s ++;
  106ec3:	ff 45 08             	incl   0x8(%ebp)
  106ec6:	eb 14                	jmp    106edc <strtol+0x54>
    }
    else if (*s == '-') {
  106ec8:	8b 45 08             	mov    0x8(%ebp),%eax
  106ecb:	0f b6 00             	movzbl (%eax),%eax
  106ece:	3c 2d                	cmp    $0x2d,%al
  106ed0:	75 0a                	jne    106edc <strtol+0x54>
        s ++, neg = 1;
  106ed2:	ff 45 08             	incl   0x8(%ebp)
  106ed5:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
    }

    // hex or octal base prefix
    if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x')) {
  106edc:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  106ee0:	74 06                	je     106ee8 <strtol+0x60>
  106ee2:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  106ee6:	75 22                	jne    106f0a <strtol+0x82>
  106ee8:	8b 45 08             	mov    0x8(%ebp),%eax
  106eeb:	0f b6 00             	movzbl (%eax),%eax
  106eee:	3c 30                	cmp    $0x30,%al
  106ef0:	75 18                	jne    106f0a <strtol+0x82>
  106ef2:	8b 45 08             	mov    0x8(%ebp),%eax
  106ef5:	40                   	inc    %eax
  106ef6:	0f b6 00             	movzbl (%eax),%eax
  106ef9:	3c 78                	cmp    $0x78,%al
  106efb:	75 0d                	jne    106f0a <strtol+0x82>
        s += 2, base = 16;
  106efd:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  106f01:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  106f08:	eb 29                	jmp    106f33 <strtol+0xab>
    }
    else if (base == 0 && s[0] == '0') {
  106f0a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  106f0e:	75 16                	jne    106f26 <strtol+0x9e>
  106f10:	8b 45 08             	mov    0x8(%ebp),%eax
  106f13:	0f b6 00             	movzbl (%eax),%eax
  106f16:	3c 30                	cmp    $0x30,%al
  106f18:	75 0c                	jne    106f26 <strtol+0x9e>
        s ++, base = 8;
  106f1a:	ff 45 08             	incl   0x8(%ebp)
  106f1d:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  106f24:	eb 0d                	jmp    106f33 <strtol+0xab>
    }
    else if (base == 0) {
  106f26:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  106f2a:	75 07                	jne    106f33 <strtol+0xab>
        base = 10;
  106f2c:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

    // digits
    while (1) {
        int dig;

        if (*s >= '0' && *s <= '9') {
  106f33:	8b 45 08             	mov    0x8(%ebp),%eax
  106f36:	0f b6 00             	movzbl (%eax),%eax
  106f39:	3c 2f                	cmp    $0x2f,%al
  106f3b:	7e 1b                	jle    106f58 <strtol+0xd0>
  106f3d:	8b 45 08             	mov    0x8(%ebp),%eax
  106f40:	0f b6 00             	movzbl (%eax),%eax
  106f43:	3c 39                	cmp    $0x39,%al
  106f45:	7f 11                	jg     106f58 <strtol+0xd0>
            dig = *s - '0';
  106f47:	8b 45 08             	mov    0x8(%ebp),%eax
  106f4a:	0f b6 00             	movzbl (%eax),%eax
  106f4d:	0f be c0             	movsbl %al,%eax
  106f50:	83 e8 30             	sub    $0x30,%eax
  106f53:	89 45 f4             	mov    %eax,-0xc(%ebp)
  106f56:	eb 48                	jmp    106fa0 <strtol+0x118>
        }
        else if (*s >= 'a' && *s <= 'z') {
  106f58:	8b 45 08             	mov    0x8(%ebp),%eax
  106f5b:	0f b6 00             	movzbl (%eax),%eax
  106f5e:	3c 60                	cmp    $0x60,%al
  106f60:	7e 1b                	jle    106f7d <strtol+0xf5>
  106f62:	8b 45 08             	mov    0x8(%ebp),%eax
  106f65:	0f b6 00             	movzbl (%eax),%eax
  106f68:	3c 7a                	cmp    $0x7a,%al
  106f6a:	7f 11                	jg     106f7d <strtol+0xf5>
            dig = *s - 'a' + 10;
  106f6c:	8b 45 08             	mov    0x8(%ebp),%eax
  106f6f:	0f b6 00             	movzbl (%eax),%eax
  106f72:	0f be c0             	movsbl %al,%eax
  106f75:	83 e8 57             	sub    $0x57,%eax
  106f78:	89 45 f4             	mov    %eax,-0xc(%ebp)
  106f7b:	eb 23                	jmp    106fa0 <strtol+0x118>
        }
        else if (*s >= 'A' && *s <= 'Z') {
  106f7d:	8b 45 08             	mov    0x8(%ebp),%eax
  106f80:	0f b6 00             	movzbl (%eax),%eax
  106f83:	3c 40                	cmp    $0x40,%al
  106f85:	7e 3b                	jle    106fc2 <strtol+0x13a>
  106f87:	8b 45 08             	mov    0x8(%ebp),%eax
  106f8a:	0f b6 00             	movzbl (%eax),%eax
  106f8d:	3c 5a                	cmp    $0x5a,%al
  106f8f:	7f 31                	jg     106fc2 <strtol+0x13a>
            dig = *s - 'A' + 10;
  106f91:	8b 45 08             	mov    0x8(%ebp),%eax
  106f94:	0f b6 00             	movzbl (%eax),%eax
  106f97:	0f be c0             	movsbl %al,%eax
  106f9a:	83 e8 37             	sub    $0x37,%eax
  106f9d:	89 45 f4             	mov    %eax,-0xc(%ebp)
        }
        else {
            break;
        }
        if (dig >= base) {
  106fa0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  106fa3:	3b 45 10             	cmp    0x10(%ebp),%eax
  106fa6:	7d 19                	jge    106fc1 <strtol+0x139>
            break;
        }
        s ++, val = (val * base) + dig;
  106fa8:	ff 45 08             	incl   0x8(%ebp)
  106fab:	8b 45 f8             	mov    -0x8(%ebp),%eax
  106fae:	0f af 45 10          	imul   0x10(%ebp),%eax
  106fb2:	89 c2                	mov    %eax,%edx
  106fb4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  106fb7:	01 d0                	add    %edx,%eax
  106fb9:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while (1) {
  106fbc:	e9 72 ff ff ff       	jmp    106f33 <strtol+0xab>
            break;
  106fc1:	90                   	nop
        // we don't properly detect overflow!
    }

    if (endptr) {
  106fc2:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  106fc6:	74 08                	je     106fd0 <strtol+0x148>
        *endptr = (char *) s;
  106fc8:	8b 45 0c             	mov    0xc(%ebp),%eax
  106fcb:	8b 55 08             	mov    0x8(%ebp),%edx
  106fce:	89 10                	mov    %edx,(%eax)
    }
    return (neg ? -val : val);
  106fd0:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  106fd4:	74 07                	je     106fdd <strtol+0x155>
  106fd6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  106fd9:	f7 d8                	neg    %eax
  106fdb:	eb 03                	jmp    106fe0 <strtol+0x158>
  106fdd:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  106fe0:	c9                   	leave  
  106fe1:	c3                   	ret    

00106fe2 <memset>:
 * @n:      number of bytes to be set to the value
 *
 * The memset() function returns @s.
 * */
void *
memset(void *s, char c, size_t n) {
  106fe2:	f3 0f 1e fb          	endbr32 
  106fe6:	55                   	push   %ebp
  106fe7:	89 e5                	mov    %esp,%ebp
  106fe9:	57                   	push   %edi
  106fea:	83 ec 24             	sub    $0x24,%esp
  106fed:	8b 45 0c             	mov    0xc(%ebp),%eax
  106ff0:	88 45 d8             	mov    %al,-0x28(%ebp)
#ifdef __HAVE_ARCH_MEMSET
    return __memset(s, c, n);
  106ff3:	0f be 55 d8          	movsbl -0x28(%ebp),%edx
  106ff7:	8b 45 08             	mov    0x8(%ebp),%eax
  106ffa:	89 45 f8             	mov    %eax,-0x8(%ebp)
  106ffd:	88 55 f7             	mov    %dl,-0x9(%ebp)
  107000:	8b 45 10             	mov    0x10(%ebp),%eax
  107003:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_MEMSET
#define __HAVE_ARCH_MEMSET
static inline void *
__memset(void *s, char c, size_t n) {
    int d0, d1;
    asm volatile (
  107006:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  107009:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  10700d:	8b 55 f8             	mov    -0x8(%ebp),%edx
  107010:	89 d7                	mov    %edx,%edi
  107012:	f3 aa                	rep stos %al,%es:(%edi)
  107014:	89 fa                	mov    %edi,%edx
  107016:	89 4d ec             	mov    %ecx,-0x14(%ebp)
  107019:	89 55 e8             	mov    %edx,-0x18(%ebp)
        "rep; stosb;"
        : "=&c" (d0), "=&D" (d1)
        : "0" (n), "a" (c), "1" (s)
        : "memory");
    return s;
  10701c:	8b 45 f8             	mov    -0x8(%ebp),%eax
    while (n -- > 0) {
        *p ++ = c;
    }
    return s;
#endif /* __HAVE_ARCH_MEMSET */
}
  10701f:	83 c4 24             	add    $0x24,%esp
  107022:	5f                   	pop    %edi
  107023:	5d                   	pop    %ebp
  107024:	c3                   	ret    

00107025 <memmove>:
 * @n:      number of bytes to copy
 *
 * The memmove() function returns @dst.
 * */
void *
memmove(void *dst, const void *src, size_t n) {
  107025:	f3 0f 1e fb          	endbr32 
  107029:	55                   	push   %ebp
  10702a:	89 e5                	mov    %esp,%ebp
  10702c:	57                   	push   %edi
  10702d:	56                   	push   %esi
  10702e:	53                   	push   %ebx
  10702f:	83 ec 30             	sub    $0x30,%esp
  107032:	8b 45 08             	mov    0x8(%ebp),%eax
  107035:	89 45 f0             	mov    %eax,-0x10(%ebp)
  107038:	8b 45 0c             	mov    0xc(%ebp),%eax
  10703b:	89 45 ec             	mov    %eax,-0x14(%ebp)
  10703e:	8b 45 10             	mov    0x10(%ebp),%eax
  107041:	89 45 e8             	mov    %eax,-0x18(%ebp)

#ifndef __HAVE_ARCH_MEMMOVE
#define __HAVE_ARCH_MEMMOVE
static inline void *
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
  107044:	8b 45 f0             	mov    -0x10(%ebp),%eax
  107047:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  10704a:	73 42                	jae    10708e <memmove+0x69>
  10704c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10704f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  107052:	8b 45 ec             	mov    -0x14(%ebp),%eax
  107055:	89 45 e0             	mov    %eax,-0x20(%ebp)
  107058:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10705b:	89 45 dc             	mov    %eax,-0x24(%ebp)
        "andl $3, %%ecx;"
        "jz 1f;"
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
  10705e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  107061:	c1 e8 02             	shr    $0x2,%eax
  107064:	89 c1                	mov    %eax,%ecx
    asm volatile (
  107066:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  107069:	8b 45 e0             	mov    -0x20(%ebp),%eax
  10706c:	89 d7                	mov    %edx,%edi
  10706e:	89 c6                	mov    %eax,%esi
  107070:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  107072:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  107075:	83 e1 03             	and    $0x3,%ecx
  107078:	74 02                	je     10707c <memmove+0x57>
  10707a:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  10707c:	89 f0                	mov    %esi,%eax
  10707e:	89 fa                	mov    %edi,%edx
  107080:	89 4d d8             	mov    %ecx,-0x28(%ebp)
  107083:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  107086:	89 45 d0             	mov    %eax,-0x30(%ebp)
        : "memory");
    return dst;
  107089:	8b 45 e4             	mov    -0x1c(%ebp),%eax
        return __memcpy(dst, src, n);
  10708c:	eb 36                	jmp    1070c4 <memmove+0x9f>
        : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
  10708e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  107091:	8d 50 ff             	lea    -0x1(%eax),%edx
  107094:	8b 45 ec             	mov    -0x14(%ebp),%eax
  107097:	01 c2                	add    %eax,%edx
  107099:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10709c:	8d 48 ff             	lea    -0x1(%eax),%ecx
  10709f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1070a2:	8d 1c 01             	lea    (%ecx,%eax,1),%ebx
    asm volatile (
  1070a5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1070a8:	89 c1                	mov    %eax,%ecx
  1070aa:	89 d8                	mov    %ebx,%eax
  1070ac:	89 d6                	mov    %edx,%esi
  1070ae:	89 c7                	mov    %eax,%edi
  1070b0:	fd                   	std    
  1070b1:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  1070b3:	fc                   	cld    
  1070b4:	89 f8                	mov    %edi,%eax
  1070b6:	89 f2                	mov    %esi,%edx
  1070b8:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  1070bb:	89 55 c8             	mov    %edx,-0x38(%ebp)
  1070be:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    return dst;
  1070c1:	8b 45 f0             	mov    -0x10(%ebp),%eax
            *d ++ = *s ++;
        }
    }
    return dst;
#endif /* __HAVE_ARCH_MEMMOVE */
}
  1070c4:	83 c4 30             	add    $0x30,%esp
  1070c7:	5b                   	pop    %ebx
  1070c8:	5e                   	pop    %esi
  1070c9:	5f                   	pop    %edi
  1070ca:	5d                   	pop    %ebp
  1070cb:	c3                   	ret    

001070cc <memcpy>:
 * it always copies exactly @n bytes. To avoid overflows, the size of arrays pointed
 * by both @src and @dst, should be at least @n bytes, and should not overlap
 * (for overlapping memory area, memmove is a safer approach).
 * */
void *
memcpy(void *dst, const void *src, size_t n) {
  1070cc:	f3 0f 1e fb          	endbr32 
  1070d0:	55                   	push   %ebp
  1070d1:	89 e5                	mov    %esp,%ebp
  1070d3:	57                   	push   %edi
  1070d4:	56                   	push   %esi
  1070d5:	83 ec 20             	sub    $0x20,%esp
  1070d8:	8b 45 08             	mov    0x8(%ebp),%eax
  1070db:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1070de:	8b 45 0c             	mov    0xc(%ebp),%eax
  1070e1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1070e4:	8b 45 10             	mov    0x10(%ebp),%eax
  1070e7:	89 45 ec             	mov    %eax,-0x14(%ebp)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
  1070ea:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1070ed:	c1 e8 02             	shr    $0x2,%eax
  1070f0:	89 c1                	mov    %eax,%ecx
    asm volatile (
  1070f2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1070f5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1070f8:	89 d7                	mov    %edx,%edi
  1070fa:	89 c6                	mov    %eax,%esi
  1070fc:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  1070fe:	8b 4d ec             	mov    -0x14(%ebp),%ecx
  107101:	83 e1 03             	and    $0x3,%ecx
  107104:	74 02                	je     107108 <memcpy+0x3c>
  107106:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  107108:	89 f0                	mov    %esi,%eax
  10710a:	89 fa                	mov    %edi,%edx
  10710c:	89 4d e8             	mov    %ecx,-0x18(%ebp)
  10710f:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  107112:	89 45 e0             	mov    %eax,-0x20(%ebp)
    return dst;
  107115:	8b 45 f4             	mov    -0xc(%ebp),%eax
    while (n -- > 0) {
        *d ++ = *s ++;
    }
    return dst;
#endif /* __HAVE_ARCH_MEMCPY */
}
  107118:	83 c4 20             	add    $0x20,%esp
  10711b:	5e                   	pop    %esi
  10711c:	5f                   	pop    %edi
  10711d:	5d                   	pop    %ebp
  10711e:	c3                   	ret    

0010711f <memcmp>:
 *   match in both memory blocks has a greater value in @v1 than in @v2
 *   as if evaluated as unsigned char values;
 * - And a value less than zero indicates the opposite.
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
  10711f:	f3 0f 1e fb          	endbr32 
  107123:	55                   	push   %ebp
  107124:	89 e5                	mov    %esp,%ebp
  107126:	83 ec 10             	sub    $0x10,%esp
    const char *s1 = (const char *)v1;
  107129:	8b 45 08             	mov    0x8(%ebp),%eax
  10712c:	89 45 fc             	mov    %eax,-0x4(%ebp)
    const char *s2 = (const char *)v2;
  10712f:	8b 45 0c             	mov    0xc(%ebp),%eax
  107132:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while (n -- > 0) {
  107135:	eb 2e                	jmp    107165 <memcmp+0x46>
        if (*s1 != *s2) {
  107137:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10713a:	0f b6 10             	movzbl (%eax),%edx
  10713d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  107140:	0f b6 00             	movzbl (%eax),%eax
  107143:	38 c2                	cmp    %al,%dl
  107145:	74 18                	je     10715f <memcmp+0x40>
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
  107147:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10714a:	0f b6 00             	movzbl (%eax),%eax
  10714d:	0f b6 d0             	movzbl %al,%edx
  107150:	8b 45 f8             	mov    -0x8(%ebp),%eax
  107153:	0f b6 00             	movzbl (%eax),%eax
  107156:	0f b6 c0             	movzbl %al,%eax
  107159:	29 c2                	sub    %eax,%edx
  10715b:	89 d0                	mov    %edx,%eax
  10715d:	eb 18                	jmp    107177 <memcmp+0x58>
        }
        s1 ++, s2 ++;
  10715f:	ff 45 fc             	incl   -0x4(%ebp)
  107162:	ff 45 f8             	incl   -0x8(%ebp)
    while (n -- > 0) {
  107165:	8b 45 10             	mov    0x10(%ebp),%eax
  107168:	8d 50 ff             	lea    -0x1(%eax),%edx
  10716b:	89 55 10             	mov    %edx,0x10(%ebp)
  10716e:	85 c0                	test   %eax,%eax
  107170:	75 c5                	jne    107137 <memcmp+0x18>
    }
    return 0;
  107172:	b8 00 00 00 00       	mov    $0x0,%eax
}
  107177:	c9                   	leave  
  107178:	c3                   	ret    

00107179 <printnum>:
 * @width:      maximum number of digits, if the actual width is less than @width, use @padc instead
 * @padc:       character that padded on the left if the actual width is less than @width
 * */
static void
printnum(void (*putch)(int, void*), void *putdat,
        unsigned long long num, unsigned base, int width, int padc) {
  107179:	f3 0f 1e fb          	endbr32 
  10717d:	55                   	push   %ebp
  10717e:	89 e5                	mov    %esp,%ebp
  107180:	83 ec 58             	sub    $0x58,%esp
  107183:	8b 45 10             	mov    0x10(%ebp),%eax
  107186:	89 45 d0             	mov    %eax,-0x30(%ebp)
  107189:	8b 45 14             	mov    0x14(%ebp),%eax
  10718c:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    unsigned long long result = num;
  10718f:	8b 45 d0             	mov    -0x30(%ebp),%eax
  107192:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  107195:	89 45 e8             	mov    %eax,-0x18(%ebp)
  107198:	89 55 ec             	mov    %edx,-0x14(%ebp)
    unsigned mod = do_div(result, base);
  10719b:	8b 45 18             	mov    0x18(%ebp),%eax
  10719e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  1071a1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1071a4:	8b 55 ec             	mov    -0x14(%ebp),%edx
  1071a7:	89 45 e0             	mov    %eax,-0x20(%ebp)
  1071aa:	89 55 f0             	mov    %edx,-0x10(%ebp)
  1071ad:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1071b0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1071b3:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  1071b7:	74 1c                	je     1071d5 <printnum+0x5c>
  1071b9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1071bc:	ba 00 00 00 00       	mov    $0x0,%edx
  1071c1:	f7 75 e4             	divl   -0x1c(%ebp)
  1071c4:	89 55 f4             	mov    %edx,-0xc(%ebp)
  1071c7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1071ca:	ba 00 00 00 00       	mov    $0x0,%edx
  1071cf:	f7 75 e4             	divl   -0x1c(%ebp)
  1071d2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1071d5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1071d8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1071db:	f7 75 e4             	divl   -0x1c(%ebp)
  1071de:	89 45 e0             	mov    %eax,-0x20(%ebp)
  1071e1:	89 55 dc             	mov    %edx,-0x24(%ebp)
  1071e4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1071e7:	8b 55 f0             	mov    -0x10(%ebp),%edx
  1071ea:	89 45 e8             	mov    %eax,-0x18(%ebp)
  1071ed:	89 55 ec             	mov    %edx,-0x14(%ebp)
  1071f0:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1071f3:	89 45 d8             	mov    %eax,-0x28(%ebp)

    // first recursively print all preceding (more significant) digits
    if (num >= base) {
  1071f6:	8b 45 18             	mov    0x18(%ebp),%eax
  1071f9:	ba 00 00 00 00       	mov    $0x0,%edx
  1071fe:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  107201:	39 45 d0             	cmp    %eax,-0x30(%ebp)
  107204:	19 d1                	sbb    %edx,%ecx
  107206:	72 4c                	jb     107254 <printnum+0xdb>
        printnum(putch, putdat, result, base, width - 1, padc);
  107208:	8b 45 1c             	mov    0x1c(%ebp),%eax
  10720b:	8d 50 ff             	lea    -0x1(%eax),%edx
  10720e:	8b 45 20             	mov    0x20(%ebp),%eax
  107211:	89 44 24 18          	mov    %eax,0x18(%esp)
  107215:	89 54 24 14          	mov    %edx,0x14(%esp)
  107219:	8b 45 18             	mov    0x18(%ebp),%eax
  10721c:	89 44 24 10          	mov    %eax,0x10(%esp)
  107220:	8b 45 e8             	mov    -0x18(%ebp),%eax
  107223:	8b 55 ec             	mov    -0x14(%ebp),%edx
  107226:	89 44 24 08          	mov    %eax,0x8(%esp)
  10722a:	89 54 24 0c          	mov    %edx,0xc(%esp)
  10722e:	8b 45 0c             	mov    0xc(%ebp),%eax
  107231:	89 44 24 04          	mov    %eax,0x4(%esp)
  107235:	8b 45 08             	mov    0x8(%ebp),%eax
  107238:	89 04 24             	mov    %eax,(%esp)
  10723b:	e8 39 ff ff ff       	call   107179 <printnum>
  107240:	eb 1b                	jmp    10725d <printnum+0xe4>
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
            putch(padc, putdat);
  107242:	8b 45 0c             	mov    0xc(%ebp),%eax
  107245:	89 44 24 04          	mov    %eax,0x4(%esp)
  107249:	8b 45 20             	mov    0x20(%ebp),%eax
  10724c:	89 04 24             	mov    %eax,(%esp)
  10724f:	8b 45 08             	mov    0x8(%ebp),%eax
  107252:	ff d0                	call   *%eax
        while (-- width > 0)
  107254:	ff 4d 1c             	decl   0x1c(%ebp)
  107257:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  10725b:	7f e5                	jg     107242 <printnum+0xc9>
    }
    // then print this (the least significant) digit
    putch("0123456789abcdef"[mod], putdat);
  10725d:	8b 45 d8             	mov    -0x28(%ebp),%eax
  107260:	05 6c 8d 10 00       	add    $0x108d6c,%eax
  107265:	0f b6 00             	movzbl (%eax),%eax
  107268:	0f be c0             	movsbl %al,%eax
  10726b:	8b 55 0c             	mov    0xc(%ebp),%edx
  10726e:	89 54 24 04          	mov    %edx,0x4(%esp)
  107272:	89 04 24             	mov    %eax,(%esp)
  107275:	8b 45 08             	mov    0x8(%ebp),%eax
  107278:	ff d0                	call   *%eax
}
  10727a:	90                   	nop
  10727b:	c9                   	leave  
  10727c:	c3                   	ret    

0010727d <getuint>:
 * getuint - get an unsigned int of various possible sizes from a varargs list
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static unsigned long long
getuint(va_list *ap, int lflag) {
  10727d:	f3 0f 1e fb          	endbr32 
  107281:	55                   	push   %ebp
  107282:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
  107284:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  107288:	7e 14                	jle    10729e <getuint+0x21>
        return va_arg(*ap, unsigned long long);
  10728a:	8b 45 08             	mov    0x8(%ebp),%eax
  10728d:	8b 00                	mov    (%eax),%eax
  10728f:	8d 48 08             	lea    0x8(%eax),%ecx
  107292:	8b 55 08             	mov    0x8(%ebp),%edx
  107295:	89 0a                	mov    %ecx,(%edx)
  107297:	8b 50 04             	mov    0x4(%eax),%edx
  10729a:	8b 00                	mov    (%eax),%eax
  10729c:	eb 30                	jmp    1072ce <getuint+0x51>
    }
    else if (lflag) {
  10729e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  1072a2:	74 16                	je     1072ba <getuint+0x3d>
        return va_arg(*ap, unsigned long);
  1072a4:	8b 45 08             	mov    0x8(%ebp),%eax
  1072a7:	8b 00                	mov    (%eax),%eax
  1072a9:	8d 48 04             	lea    0x4(%eax),%ecx
  1072ac:	8b 55 08             	mov    0x8(%ebp),%edx
  1072af:	89 0a                	mov    %ecx,(%edx)
  1072b1:	8b 00                	mov    (%eax),%eax
  1072b3:	ba 00 00 00 00       	mov    $0x0,%edx
  1072b8:	eb 14                	jmp    1072ce <getuint+0x51>
    }
    else {
        return va_arg(*ap, unsigned int);
  1072ba:	8b 45 08             	mov    0x8(%ebp),%eax
  1072bd:	8b 00                	mov    (%eax),%eax
  1072bf:	8d 48 04             	lea    0x4(%eax),%ecx
  1072c2:	8b 55 08             	mov    0x8(%ebp),%edx
  1072c5:	89 0a                	mov    %ecx,(%edx)
  1072c7:	8b 00                	mov    (%eax),%eax
  1072c9:	ba 00 00 00 00       	mov    $0x0,%edx
    }
}
  1072ce:	5d                   	pop    %ebp
  1072cf:	c3                   	ret    

001072d0 <getint>:
 * getint - same as getuint but signed, we can't use getuint because of sign extension
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static long long
getint(va_list *ap, int lflag) {
  1072d0:	f3 0f 1e fb          	endbr32 
  1072d4:	55                   	push   %ebp
  1072d5:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
  1072d7:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  1072db:	7e 14                	jle    1072f1 <getint+0x21>
        return va_arg(*ap, long long);
  1072dd:	8b 45 08             	mov    0x8(%ebp),%eax
  1072e0:	8b 00                	mov    (%eax),%eax
  1072e2:	8d 48 08             	lea    0x8(%eax),%ecx
  1072e5:	8b 55 08             	mov    0x8(%ebp),%edx
  1072e8:	89 0a                	mov    %ecx,(%edx)
  1072ea:	8b 50 04             	mov    0x4(%eax),%edx
  1072ed:	8b 00                	mov    (%eax),%eax
  1072ef:	eb 28                	jmp    107319 <getint+0x49>
    }
    else if (lflag) {
  1072f1:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  1072f5:	74 12                	je     107309 <getint+0x39>
        return va_arg(*ap, long);
  1072f7:	8b 45 08             	mov    0x8(%ebp),%eax
  1072fa:	8b 00                	mov    (%eax),%eax
  1072fc:	8d 48 04             	lea    0x4(%eax),%ecx
  1072ff:	8b 55 08             	mov    0x8(%ebp),%edx
  107302:	89 0a                	mov    %ecx,(%edx)
  107304:	8b 00                	mov    (%eax),%eax
  107306:	99                   	cltd   
  107307:	eb 10                	jmp    107319 <getint+0x49>
    }
    else {
        return va_arg(*ap, int);
  107309:	8b 45 08             	mov    0x8(%ebp),%eax
  10730c:	8b 00                	mov    (%eax),%eax
  10730e:	8d 48 04             	lea    0x4(%eax),%ecx
  107311:	8b 55 08             	mov    0x8(%ebp),%edx
  107314:	89 0a                	mov    %ecx,(%edx)
  107316:	8b 00                	mov    (%eax),%eax
  107318:	99                   	cltd   
    }
}
  107319:	5d                   	pop    %ebp
  10731a:	c3                   	ret    

0010731b <printfmt>:
 * @putch:      specified putch function, print a single character
 * @putdat:     used by @putch function
 * @fmt:        the format string to use
 * */
void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
  10731b:	f3 0f 1e fb          	endbr32 
  10731f:	55                   	push   %ebp
  107320:	89 e5                	mov    %esp,%ebp
  107322:	83 ec 28             	sub    $0x28,%esp
    va_list ap;

    va_start(ap, fmt);
  107325:	8d 45 14             	lea    0x14(%ebp),%eax
  107328:	89 45 f4             	mov    %eax,-0xc(%ebp)
    vprintfmt(putch, putdat, fmt, ap);
  10732b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10732e:	89 44 24 0c          	mov    %eax,0xc(%esp)
  107332:	8b 45 10             	mov    0x10(%ebp),%eax
  107335:	89 44 24 08          	mov    %eax,0x8(%esp)
  107339:	8b 45 0c             	mov    0xc(%ebp),%eax
  10733c:	89 44 24 04          	mov    %eax,0x4(%esp)
  107340:	8b 45 08             	mov    0x8(%ebp),%eax
  107343:	89 04 24             	mov    %eax,(%esp)
  107346:	e8 03 00 00 00       	call   10734e <vprintfmt>
    va_end(ap);
}
  10734b:	90                   	nop
  10734c:	c9                   	leave  
  10734d:	c3                   	ret    

0010734e <vprintfmt>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want printfmt() instead.
 * */
void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap) {
  10734e:	f3 0f 1e fb          	endbr32 
  107352:	55                   	push   %ebp
  107353:	89 e5                	mov    %esp,%ebp
  107355:	56                   	push   %esi
  107356:	53                   	push   %ebx
  107357:	83 ec 40             	sub    $0x40,%esp
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  10735a:	eb 17                	jmp    107373 <vprintfmt+0x25>
            if (ch == '\0') {
  10735c:	85 db                	test   %ebx,%ebx
  10735e:	0f 84 c0 03 00 00    	je     107724 <vprintfmt+0x3d6>
                return;
            }
            putch(ch, putdat);
  107364:	8b 45 0c             	mov    0xc(%ebp),%eax
  107367:	89 44 24 04          	mov    %eax,0x4(%esp)
  10736b:	89 1c 24             	mov    %ebx,(%esp)
  10736e:	8b 45 08             	mov    0x8(%ebp),%eax
  107371:	ff d0                	call   *%eax
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  107373:	8b 45 10             	mov    0x10(%ebp),%eax
  107376:	8d 50 01             	lea    0x1(%eax),%edx
  107379:	89 55 10             	mov    %edx,0x10(%ebp)
  10737c:	0f b6 00             	movzbl (%eax),%eax
  10737f:	0f b6 d8             	movzbl %al,%ebx
  107382:	83 fb 25             	cmp    $0x25,%ebx
  107385:	75 d5                	jne    10735c <vprintfmt+0xe>
        }

        // Process a %-escape sequence
        char padc = ' ';
  107387:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
        width = precision = -1;
  10738b:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  107392:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  107395:	89 45 e8             	mov    %eax,-0x18(%ebp)
        lflag = altflag = 0;
  107398:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  10739f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1073a2:	89 45 e0             	mov    %eax,-0x20(%ebp)

    reswitch:
        switch (ch = *(unsigned char *)fmt ++) {
  1073a5:	8b 45 10             	mov    0x10(%ebp),%eax
  1073a8:	8d 50 01             	lea    0x1(%eax),%edx
  1073ab:	89 55 10             	mov    %edx,0x10(%ebp)
  1073ae:	0f b6 00             	movzbl (%eax),%eax
  1073b1:	0f b6 d8             	movzbl %al,%ebx
  1073b4:	8d 43 dd             	lea    -0x23(%ebx),%eax
  1073b7:	83 f8 55             	cmp    $0x55,%eax
  1073ba:	0f 87 38 03 00 00    	ja     1076f8 <vprintfmt+0x3aa>
  1073c0:	8b 04 85 90 8d 10 00 	mov    0x108d90(,%eax,4),%eax
  1073c7:	3e ff e0             	notrack jmp *%eax

        // flag to pad on the right
        case '-':
            padc = '-';
  1073ca:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
            goto reswitch;
  1073ce:	eb d5                	jmp    1073a5 <vprintfmt+0x57>

        // flag to pad with 0's instead of spaces
        case '0':
            padc = '0';
  1073d0:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
            goto reswitch;
  1073d4:	eb cf                	jmp    1073a5 <vprintfmt+0x57>

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
  1073d6:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
                precision = precision * 10 + ch - '0';
  1073dd:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  1073e0:	89 d0                	mov    %edx,%eax
  1073e2:	c1 e0 02             	shl    $0x2,%eax
  1073e5:	01 d0                	add    %edx,%eax
  1073e7:	01 c0                	add    %eax,%eax
  1073e9:	01 d8                	add    %ebx,%eax
  1073eb:	83 e8 30             	sub    $0x30,%eax
  1073ee:	89 45 e4             	mov    %eax,-0x1c(%ebp)
                ch = *fmt;
  1073f1:	8b 45 10             	mov    0x10(%ebp),%eax
  1073f4:	0f b6 00             	movzbl (%eax),%eax
  1073f7:	0f be d8             	movsbl %al,%ebx
                if (ch < '0' || ch > '9') {
  1073fa:	83 fb 2f             	cmp    $0x2f,%ebx
  1073fd:	7e 38                	jle    107437 <vprintfmt+0xe9>
  1073ff:	83 fb 39             	cmp    $0x39,%ebx
  107402:	7f 33                	jg     107437 <vprintfmt+0xe9>
            for (precision = 0; ; ++ fmt) {
  107404:	ff 45 10             	incl   0x10(%ebp)
                precision = precision * 10 + ch - '0';
  107407:	eb d4                	jmp    1073dd <vprintfmt+0x8f>
                }
            }
            goto process_precision;

        case '*':
            precision = va_arg(ap, int);
  107409:	8b 45 14             	mov    0x14(%ebp),%eax
  10740c:	8d 50 04             	lea    0x4(%eax),%edx
  10740f:	89 55 14             	mov    %edx,0x14(%ebp)
  107412:	8b 00                	mov    (%eax),%eax
  107414:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            goto process_precision;
  107417:	eb 1f                	jmp    107438 <vprintfmt+0xea>

        case '.':
            if (width < 0)
  107419:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  10741d:	79 86                	jns    1073a5 <vprintfmt+0x57>
                width = 0;
  10741f:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
            goto reswitch;
  107426:	e9 7a ff ff ff       	jmp    1073a5 <vprintfmt+0x57>

        case '#':
            altflag = 1;
  10742b:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
            goto reswitch;
  107432:	e9 6e ff ff ff       	jmp    1073a5 <vprintfmt+0x57>
            goto process_precision;
  107437:	90                   	nop

        process_precision:
            if (width < 0)
  107438:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  10743c:	0f 89 63 ff ff ff    	jns    1073a5 <vprintfmt+0x57>
                width = precision, precision = -1;
  107442:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  107445:	89 45 e8             	mov    %eax,-0x18(%ebp)
  107448:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
            goto reswitch;
  10744f:	e9 51 ff ff ff       	jmp    1073a5 <vprintfmt+0x57>

        // long flag (doubled for long long)
        case 'l':
            lflag ++;
  107454:	ff 45 e0             	incl   -0x20(%ebp)
            goto reswitch;
  107457:	e9 49 ff ff ff       	jmp    1073a5 <vprintfmt+0x57>

        // character
        case 'c':
            putch(va_arg(ap, int), putdat);
  10745c:	8b 45 14             	mov    0x14(%ebp),%eax
  10745f:	8d 50 04             	lea    0x4(%eax),%edx
  107462:	89 55 14             	mov    %edx,0x14(%ebp)
  107465:	8b 00                	mov    (%eax),%eax
  107467:	8b 55 0c             	mov    0xc(%ebp),%edx
  10746a:	89 54 24 04          	mov    %edx,0x4(%esp)
  10746e:	89 04 24             	mov    %eax,(%esp)
  107471:	8b 45 08             	mov    0x8(%ebp),%eax
  107474:	ff d0                	call   *%eax
            break;
  107476:	e9 a4 02 00 00       	jmp    10771f <vprintfmt+0x3d1>

        // error message
        case 'e':
            err = va_arg(ap, int);
  10747b:	8b 45 14             	mov    0x14(%ebp),%eax
  10747e:	8d 50 04             	lea    0x4(%eax),%edx
  107481:	89 55 14             	mov    %edx,0x14(%ebp)
  107484:	8b 18                	mov    (%eax),%ebx
            if (err < 0) {
  107486:	85 db                	test   %ebx,%ebx
  107488:	79 02                	jns    10748c <vprintfmt+0x13e>
                err = -err;
  10748a:	f7 db                	neg    %ebx
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
  10748c:	83 fb 06             	cmp    $0x6,%ebx
  10748f:	7f 0b                	jg     10749c <vprintfmt+0x14e>
  107491:	8b 34 9d 50 8d 10 00 	mov    0x108d50(,%ebx,4),%esi
  107498:	85 f6                	test   %esi,%esi
  10749a:	75 23                	jne    1074bf <vprintfmt+0x171>
                printfmt(putch, putdat, "error %d", err);
  10749c:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  1074a0:	c7 44 24 08 7d 8d 10 	movl   $0x108d7d,0x8(%esp)
  1074a7:	00 
  1074a8:	8b 45 0c             	mov    0xc(%ebp),%eax
  1074ab:	89 44 24 04          	mov    %eax,0x4(%esp)
  1074af:	8b 45 08             	mov    0x8(%ebp),%eax
  1074b2:	89 04 24             	mov    %eax,(%esp)
  1074b5:	e8 61 fe ff ff       	call   10731b <printfmt>
            }
            else {
                printfmt(putch, putdat, "%s", p);
            }
            break;
  1074ba:	e9 60 02 00 00       	jmp    10771f <vprintfmt+0x3d1>
                printfmt(putch, putdat, "%s", p);
  1074bf:	89 74 24 0c          	mov    %esi,0xc(%esp)
  1074c3:	c7 44 24 08 86 8d 10 	movl   $0x108d86,0x8(%esp)
  1074ca:	00 
  1074cb:	8b 45 0c             	mov    0xc(%ebp),%eax
  1074ce:	89 44 24 04          	mov    %eax,0x4(%esp)
  1074d2:	8b 45 08             	mov    0x8(%ebp),%eax
  1074d5:	89 04 24             	mov    %eax,(%esp)
  1074d8:	e8 3e fe ff ff       	call   10731b <printfmt>
            break;
  1074dd:	e9 3d 02 00 00       	jmp    10771f <vprintfmt+0x3d1>

        // string
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
  1074e2:	8b 45 14             	mov    0x14(%ebp),%eax
  1074e5:	8d 50 04             	lea    0x4(%eax),%edx
  1074e8:	89 55 14             	mov    %edx,0x14(%ebp)
  1074eb:	8b 30                	mov    (%eax),%esi
  1074ed:	85 f6                	test   %esi,%esi
  1074ef:	75 05                	jne    1074f6 <vprintfmt+0x1a8>
                p = "(null)";
  1074f1:	be 89 8d 10 00       	mov    $0x108d89,%esi
            }
            if (width > 0 && padc != '-') {
  1074f6:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  1074fa:	7e 76                	jle    107572 <vprintfmt+0x224>
  1074fc:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  107500:	74 70                	je     107572 <vprintfmt+0x224>
                for (width -= strnlen(p, precision); width > 0; width --) {
  107502:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  107505:	89 44 24 04          	mov    %eax,0x4(%esp)
  107509:	89 34 24             	mov    %esi,(%esp)
  10750c:	e8 ba f7 ff ff       	call   106ccb <strnlen>
  107511:	8b 55 e8             	mov    -0x18(%ebp),%edx
  107514:	29 c2                	sub    %eax,%edx
  107516:	89 d0                	mov    %edx,%eax
  107518:	89 45 e8             	mov    %eax,-0x18(%ebp)
  10751b:	eb 16                	jmp    107533 <vprintfmt+0x1e5>
                    putch(padc, putdat);
  10751d:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  107521:	8b 55 0c             	mov    0xc(%ebp),%edx
  107524:	89 54 24 04          	mov    %edx,0x4(%esp)
  107528:	89 04 24             	mov    %eax,(%esp)
  10752b:	8b 45 08             	mov    0x8(%ebp),%eax
  10752e:	ff d0                	call   *%eax
                for (width -= strnlen(p, precision); width > 0; width --) {
  107530:	ff 4d e8             	decl   -0x18(%ebp)
  107533:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  107537:	7f e4                	jg     10751d <vprintfmt+0x1cf>
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  107539:	eb 37                	jmp    107572 <vprintfmt+0x224>
                if (altflag && (ch < ' ' || ch > '~')) {
  10753b:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  10753f:	74 1f                	je     107560 <vprintfmt+0x212>
  107541:	83 fb 1f             	cmp    $0x1f,%ebx
  107544:	7e 05                	jle    10754b <vprintfmt+0x1fd>
  107546:	83 fb 7e             	cmp    $0x7e,%ebx
  107549:	7e 15                	jle    107560 <vprintfmt+0x212>
                    putch('?', putdat);
  10754b:	8b 45 0c             	mov    0xc(%ebp),%eax
  10754e:	89 44 24 04          	mov    %eax,0x4(%esp)
  107552:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  107559:	8b 45 08             	mov    0x8(%ebp),%eax
  10755c:	ff d0                	call   *%eax
  10755e:	eb 0f                	jmp    10756f <vprintfmt+0x221>
                }
                else {
                    putch(ch, putdat);
  107560:	8b 45 0c             	mov    0xc(%ebp),%eax
  107563:	89 44 24 04          	mov    %eax,0x4(%esp)
  107567:	89 1c 24             	mov    %ebx,(%esp)
  10756a:	8b 45 08             	mov    0x8(%ebp),%eax
  10756d:	ff d0                	call   *%eax
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  10756f:	ff 4d e8             	decl   -0x18(%ebp)
  107572:	89 f0                	mov    %esi,%eax
  107574:	8d 70 01             	lea    0x1(%eax),%esi
  107577:	0f b6 00             	movzbl (%eax),%eax
  10757a:	0f be d8             	movsbl %al,%ebx
  10757d:	85 db                	test   %ebx,%ebx
  10757f:	74 27                	je     1075a8 <vprintfmt+0x25a>
  107581:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  107585:	78 b4                	js     10753b <vprintfmt+0x1ed>
  107587:	ff 4d e4             	decl   -0x1c(%ebp)
  10758a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  10758e:	79 ab                	jns    10753b <vprintfmt+0x1ed>
                }
            }
            for (; width > 0; width --) {
  107590:	eb 16                	jmp    1075a8 <vprintfmt+0x25a>
                putch(' ', putdat);
  107592:	8b 45 0c             	mov    0xc(%ebp),%eax
  107595:	89 44 24 04          	mov    %eax,0x4(%esp)
  107599:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  1075a0:	8b 45 08             	mov    0x8(%ebp),%eax
  1075a3:	ff d0                	call   *%eax
            for (; width > 0; width --) {
  1075a5:	ff 4d e8             	decl   -0x18(%ebp)
  1075a8:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  1075ac:	7f e4                	jg     107592 <vprintfmt+0x244>
            }
            break;
  1075ae:	e9 6c 01 00 00       	jmp    10771f <vprintfmt+0x3d1>

        // (signed) decimal
        case 'd':
            num = getint(&ap, lflag);
  1075b3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1075b6:	89 44 24 04          	mov    %eax,0x4(%esp)
  1075ba:	8d 45 14             	lea    0x14(%ebp),%eax
  1075bd:	89 04 24             	mov    %eax,(%esp)
  1075c0:	e8 0b fd ff ff       	call   1072d0 <getint>
  1075c5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1075c8:	89 55 f4             	mov    %edx,-0xc(%ebp)
            if ((long long)num < 0) {
  1075cb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1075ce:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1075d1:	85 d2                	test   %edx,%edx
  1075d3:	79 26                	jns    1075fb <vprintfmt+0x2ad>
                putch('-', putdat);
  1075d5:	8b 45 0c             	mov    0xc(%ebp),%eax
  1075d8:	89 44 24 04          	mov    %eax,0x4(%esp)
  1075dc:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  1075e3:	8b 45 08             	mov    0x8(%ebp),%eax
  1075e6:	ff d0                	call   *%eax
                num = -(long long)num;
  1075e8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1075eb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1075ee:	f7 d8                	neg    %eax
  1075f0:	83 d2 00             	adc    $0x0,%edx
  1075f3:	f7 da                	neg    %edx
  1075f5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1075f8:	89 55 f4             	mov    %edx,-0xc(%ebp)
            }
            base = 10;
  1075fb:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
  107602:	e9 a8 00 00 00       	jmp    1076af <vprintfmt+0x361>

        // unsigned decimal
        case 'u':
            num = getuint(&ap, lflag);
  107607:	8b 45 e0             	mov    -0x20(%ebp),%eax
  10760a:	89 44 24 04          	mov    %eax,0x4(%esp)
  10760e:	8d 45 14             	lea    0x14(%ebp),%eax
  107611:	89 04 24             	mov    %eax,(%esp)
  107614:	e8 64 fc ff ff       	call   10727d <getuint>
  107619:	89 45 f0             	mov    %eax,-0x10(%ebp)
  10761c:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 10;
  10761f:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
  107626:	e9 84 00 00 00       	jmp    1076af <vprintfmt+0x361>

        // (unsigned) octal
        case 'o':
            num = getuint(&ap, lflag);
  10762b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  10762e:	89 44 24 04          	mov    %eax,0x4(%esp)
  107632:	8d 45 14             	lea    0x14(%ebp),%eax
  107635:	89 04 24             	mov    %eax,(%esp)
  107638:	e8 40 fc ff ff       	call   10727d <getuint>
  10763d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  107640:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 8;
  107643:	c7 45 ec 08 00 00 00 	movl   $0x8,-0x14(%ebp)
            goto number;
  10764a:	eb 63                	jmp    1076af <vprintfmt+0x361>

        // pointer
        case 'p':
            putch('0', putdat);
  10764c:	8b 45 0c             	mov    0xc(%ebp),%eax
  10764f:	89 44 24 04          	mov    %eax,0x4(%esp)
  107653:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  10765a:	8b 45 08             	mov    0x8(%ebp),%eax
  10765d:	ff d0                	call   *%eax
            putch('x', putdat);
  10765f:	8b 45 0c             	mov    0xc(%ebp),%eax
  107662:	89 44 24 04          	mov    %eax,0x4(%esp)
  107666:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  10766d:	8b 45 08             	mov    0x8(%ebp),%eax
  107670:	ff d0                	call   *%eax
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
  107672:	8b 45 14             	mov    0x14(%ebp),%eax
  107675:	8d 50 04             	lea    0x4(%eax),%edx
  107678:	89 55 14             	mov    %edx,0x14(%ebp)
  10767b:	8b 00                	mov    (%eax),%eax
  10767d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  107680:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
            base = 16;
  107687:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
            goto number;
  10768e:	eb 1f                	jmp    1076af <vprintfmt+0x361>

        // (unsigned) hexadecimal
        case 'x':
            num = getuint(&ap, lflag);
  107690:	8b 45 e0             	mov    -0x20(%ebp),%eax
  107693:	89 44 24 04          	mov    %eax,0x4(%esp)
  107697:	8d 45 14             	lea    0x14(%ebp),%eax
  10769a:	89 04 24             	mov    %eax,(%esp)
  10769d:	e8 db fb ff ff       	call   10727d <getuint>
  1076a2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1076a5:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 16;
  1076a8:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
        number:
            printnum(putch, putdat, num, base, width, padc);
  1076af:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  1076b3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1076b6:	89 54 24 18          	mov    %edx,0x18(%esp)
  1076ba:	8b 55 e8             	mov    -0x18(%ebp),%edx
  1076bd:	89 54 24 14          	mov    %edx,0x14(%esp)
  1076c1:	89 44 24 10          	mov    %eax,0x10(%esp)
  1076c5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1076c8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1076cb:	89 44 24 08          	mov    %eax,0x8(%esp)
  1076cf:	89 54 24 0c          	mov    %edx,0xc(%esp)
  1076d3:	8b 45 0c             	mov    0xc(%ebp),%eax
  1076d6:	89 44 24 04          	mov    %eax,0x4(%esp)
  1076da:	8b 45 08             	mov    0x8(%ebp),%eax
  1076dd:	89 04 24             	mov    %eax,(%esp)
  1076e0:	e8 94 fa ff ff       	call   107179 <printnum>
            break;
  1076e5:	eb 38                	jmp    10771f <vprintfmt+0x3d1>

        // escaped '%' character
        case '%':
            putch(ch, putdat);
  1076e7:	8b 45 0c             	mov    0xc(%ebp),%eax
  1076ea:	89 44 24 04          	mov    %eax,0x4(%esp)
  1076ee:	89 1c 24             	mov    %ebx,(%esp)
  1076f1:	8b 45 08             	mov    0x8(%ebp),%eax
  1076f4:	ff d0                	call   *%eax
            break;
  1076f6:	eb 27                	jmp    10771f <vprintfmt+0x3d1>

        // unrecognized escape sequence - just print it literally
        default:
            putch('%', putdat);
  1076f8:	8b 45 0c             	mov    0xc(%ebp),%eax
  1076fb:	89 44 24 04          	mov    %eax,0x4(%esp)
  1076ff:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  107706:	8b 45 08             	mov    0x8(%ebp),%eax
  107709:	ff d0                	call   *%eax
            for (fmt --; fmt[-1] != '%'; fmt --)
  10770b:	ff 4d 10             	decl   0x10(%ebp)
  10770e:	eb 03                	jmp    107713 <vprintfmt+0x3c5>
  107710:	ff 4d 10             	decl   0x10(%ebp)
  107713:	8b 45 10             	mov    0x10(%ebp),%eax
  107716:	48                   	dec    %eax
  107717:	0f b6 00             	movzbl (%eax),%eax
  10771a:	3c 25                	cmp    $0x25,%al
  10771c:	75 f2                	jne    107710 <vprintfmt+0x3c2>
                /* do nothing */;
            break;
  10771e:	90                   	nop
    while (1) {
  10771f:	e9 36 fc ff ff       	jmp    10735a <vprintfmt+0xc>
                return;
  107724:	90                   	nop
        }
    }
}
  107725:	83 c4 40             	add    $0x40,%esp
  107728:	5b                   	pop    %ebx
  107729:	5e                   	pop    %esi
  10772a:	5d                   	pop    %ebp
  10772b:	c3                   	ret    

0010772c <sprintputch>:
 * sprintputch - 'print' a single character in a buffer
 * @ch:         the character will be printed
 * @b:          the buffer to place the character @ch
 * */
static void
sprintputch(int ch, struct sprintbuf *b) {
  10772c:	f3 0f 1e fb          	endbr32 
  107730:	55                   	push   %ebp
  107731:	89 e5                	mov    %esp,%ebp
    b->cnt ++;
  107733:	8b 45 0c             	mov    0xc(%ebp),%eax
  107736:	8b 40 08             	mov    0x8(%eax),%eax
  107739:	8d 50 01             	lea    0x1(%eax),%edx
  10773c:	8b 45 0c             	mov    0xc(%ebp),%eax
  10773f:	89 50 08             	mov    %edx,0x8(%eax)
    if (b->buf < b->ebuf) {
  107742:	8b 45 0c             	mov    0xc(%ebp),%eax
  107745:	8b 10                	mov    (%eax),%edx
  107747:	8b 45 0c             	mov    0xc(%ebp),%eax
  10774a:	8b 40 04             	mov    0x4(%eax),%eax
  10774d:	39 c2                	cmp    %eax,%edx
  10774f:	73 12                	jae    107763 <sprintputch+0x37>
        *b->buf ++ = ch;
  107751:	8b 45 0c             	mov    0xc(%ebp),%eax
  107754:	8b 00                	mov    (%eax),%eax
  107756:	8d 48 01             	lea    0x1(%eax),%ecx
  107759:	8b 55 0c             	mov    0xc(%ebp),%edx
  10775c:	89 0a                	mov    %ecx,(%edx)
  10775e:	8b 55 08             	mov    0x8(%ebp),%edx
  107761:	88 10                	mov    %dl,(%eax)
    }
}
  107763:	90                   	nop
  107764:	5d                   	pop    %ebp
  107765:	c3                   	ret    

00107766 <snprintf>:
 * @str:        the buffer to place the result into
 * @size:       the size of buffer, including the trailing null space
 * @fmt:        the format string to use
 * */
int
snprintf(char *str, size_t size, const char *fmt, ...) {
  107766:	f3 0f 1e fb          	endbr32 
  10776a:	55                   	push   %ebp
  10776b:	89 e5                	mov    %esp,%ebp
  10776d:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
  107770:	8d 45 14             	lea    0x14(%ebp),%eax
  107773:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vsnprintf(str, size, fmt, ap);
  107776:	8b 45 f0             	mov    -0x10(%ebp),%eax
  107779:	89 44 24 0c          	mov    %eax,0xc(%esp)
  10777d:	8b 45 10             	mov    0x10(%ebp),%eax
  107780:	89 44 24 08          	mov    %eax,0x8(%esp)
  107784:	8b 45 0c             	mov    0xc(%ebp),%eax
  107787:	89 44 24 04          	mov    %eax,0x4(%esp)
  10778b:	8b 45 08             	mov    0x8(%ebp),%eax
  10778e:	89 04 24             	mov    %eax,(%esp)
  107791:	e8 08 00 00 00       	call   10779e <vsnprintf>
  107796:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
  107799:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  10779c:	c9                   	leave  
  10779d:	c3                   	ret    

0010779e <vsnprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want snprintf() instead.
 * */
int
vsnprintf(char *str, size_t size, const char *fmt, va_list ap) {
  10779e:	f3 0f 1e fb          	endbr32 
  1077a2:	55                   	push   %ebp
  1077a3:	89 e5                	mov    %esp,%ebp
  1077a5:	83 ec 28             	sub    $0x28,%esp
    struct sprintbuf b = {str, str + size - 1, 0};
  1077a8:	8b 45 08             	mov    0x8(%ebp),%eax
  1077ab:	89 45 ec             	mov    %eax,-0x14(%ebp)
  1077ae:	8b 45 0c             	mov    0xc(%ebp),%eax
  1077b1:	8d 50 ff             	lea    -0x1(%eax),%edx
  1077b4:	8b 45 08             	mov    0x8(%ebp),%eax
  1077b7:	01 d0                	add    %edx,%eax
  1077b9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1077bc:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if (str == NULL || b.buf > b.ebuf) {
  1077c3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  1077c7:	74 0a                	je     1077d3 <vsnprintf+0x35>
  1077c9:	8b 55 ec             	mov    -0x14(%ebp),%edx
  1077cc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1077cf:	39 c2                	cmp    %eax,%edx
  1077d1:	76 07                	jbe    1077da <vsnprintf+0x3c>
        return -E_INVAL;
  1077d3:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  1077d8:	eb 2a                	jmp    107804 <vsnprintf+0x66>
    }
    // print the string to the buffer
    vprintfmt((void*)sprintputch, &b, fmt, ap);
  1077da:	8b 45 14             	mov    0x14(%ebp),%eax
  1077dd:	89 44 24 0c          	mov    %eax,0xc(%esp)
  1077e1:	8b 45 10             	mov    0x10(%ebp),%eax
  1077e4:	89 44 24 08          	mov    %eax,0x8(%esp)
  1077e8:	8d 45 ec             	lea    -0x14(%ebp),%eax
  1077eb:	89 44 24 04          	mov    %eax,0x4(%esp)
  1077ef:	c7 04 24 2c 77 10 00 	movl   $0x10772c,(%esp)
  1077f6:	e8 53 fb ff ff       	call   10734e <vprintfmt>
    // null terminate the buffer
    *b.buf = '\0';
  1077fb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1077fe:	c6 00 00             	movb   $0x0,(%eax)
    return b.cnt;
  107801:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  107804:	c9                   	leave  
  107805:	c3                   	ret    
