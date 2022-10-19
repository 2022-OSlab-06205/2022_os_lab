
bin/kernel：     文件格式 elf32-i386


Disassembly of section .text:

00100000 <kern_init>:
int kern_init(void) __attribute__((noreturn));
void grade_backtrace(void);
static void lab1_switch_test(void);

int
kern_init(void) {
  100000:	f3 0f 1e fb          	endbr32 
  100004:	55                   	push   %ebp
  100005:	89 e5                	mov    %esp,%ebp
  100007:	83 ec 28             	sub    $0x28,%esp
    extern char edata[], end[];
    memset(edata, 0, end - edata);
  10000a:	b8 80 1d 11 00       	mov    $0x111d80,%eax
  10000f:	2d 16 0a 11 00       	sub    $0x110a16,%eax
  100014:	89 44 24 08          	mov    %eax,0x8(%esp)
  100018:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  10001f:	00 
  100020:	c7 04 24 16 0a 11 00 	movl   $0x110a16,(%esp)
  100027:	e8 9c 31 00 00       	call   1031c8 <memset>

    cons_init();                // init the console
  10002c:	e8 16 16 00 00       	call   101647 <cons_init>

    const char *message = "(THU.CST) os is loading ...";
  100031:	c7 45 f4 00 3a 10 00 	movl   $0x103a00,-0xc(%ebp)
    cprintf("%s\n\n", message);
  100038:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10003b:	89 44 24 04          	mov    %eax,0x4(%esp)
  10003f:	c7 04 24 1c 3a 10 00 	movl   $0x103a1c,(%esp)
  100046:	e8 49 02 00 00       	call   100294 <cprintf>

    print_kerninfo();
  10004b:	e8 07 09 00 00       	call   100957 <print_kerninfo>

    grade_backtrace();
  100050:	e8 9a 00 00 00       	call   1000ef <grade_backtrace>

    pmm_init();                 // init physical memory management
  100055:	e8 1d 2e 00 00       	call   102e77 <pmm_init>

    pic_init();                 // init interrupt controller
  10005a:	e8 3d 17 00 00       	call   10179c <pic_init>
    idt_init();                 // init interrupt descriptor table
  10005f:	e8 e2 18 00 00       	call   101946 <idt_init>

    clock_init();               // init clock interrupt
  100064:	e8 63 0d 00 00       	call   100dcc <clock_init>
    intr_enable();              // enable irq interrupt
  100069:	e8 7a 18 00 00       	call   1018e8 <intr_enable>

    //LAB1: CAHLLENGE 1 If you try to do it, uncomment lab1_switch_test()
    // user/kernel mode switch test
    lab1_switch_test();
  10006e:	e8 87 01 00 00       	call   1001fa <lab1_switch_test>

    /* do nothing */
    while (1);
  100073:	eb fe                	jmp    100073 <kern_init+0x73>

00100075 <grade_backtrace2>:
}

void __attribute__((noinline))
grade_backtrace2(int arg0, int arg1, int arg2, int arg3) {
  100075:	f3 0f 1e fb          	endbr32 
  100079:	55                   	push   %ebp
  10007a:	89 e5                	mov    %esp,%ebp
  10007c:	83 ec 18             	sub    $0x18,%esp
    mon_backtrace(0, NULL, NULL);
  10007f:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  100086:	00 
  100087:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  10008e:	00 
  10008f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  100096:	e8 1b 0d 00 00       	call   100db6 <mon_backtrace>
}
  10009b:	90                   	nop
  10009c:	c9                   	leave  
  10009d:	c3                   	ret    

0010009e <grade_backtrace1>:

void __attribute__((noinline))
grade_backtrace1(int arg0, int arg1) {
  10009e:	f3 0f 1e fb          	endbr32 
  1000a2:	55                   	push   %ebp
  1000a3:	89 e5                	mov    %esp,%ebp
  1000a5:	53                   	push   %ebx
  1000a6:	83 ec 14             	sub    $0x14,%esp
    grade_backtrace2(arg0, (int)&arg0, arg1, (int)&arg1);
  1000a9:	8d 4d 0c             	lea    0xc(%ebp),%ecx
  1000ac:	8b 55 0c             	mov    0xc(%ebp),%edx
  1000af:	8d 5d 08             	lea    0x8(%ebp),%ebx
  1000b2:	8b 45 08             	mov    0x8(%ebp),%eax
  1000b5:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  1000b9:	89 54 24 08          	mov    %edx,0x8(%esp)
  1000bd:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  1000c1:	89 04 24             	mov    %eax,(%esp)
  1000c4:	e8 ac ff ff ff       	call   100075 <grade_backtrace2>
}
  1000c9:	90                   	nop
  1000ca:	83 c4 14             	add    $0x14,%esp
  1000cd:	5b                   	pop    %ebx
  1000ce:	5d                   	pop    %ebp
  1000cf:	c3                   	ret    

001000d0 <grade_backtrace0>:

void __attribute__((noinline))
grade_backtrace0(int arg0, int arg1, int arg2) {
  1000d0:	f3 0f 1e fb          	endbr32 
  1000d4:	55                   	push   %ebp
  1000d5:	89 e5                	mov    %esp,%ebp
  1000d7:	83 ec 18             	sub    $0x18,%esp
    grade_backtrace1(arg0, arg2);
  1000da:	8b 45 10             	mov    0x10(%ebp),%eax
  1000dd:	89 44 24 04          	mov    %eax,0x4(%esp)
  1000e1:	8b 45 08             	mov    0x8(%ebp),%eax
  1000e4:	89 04 24             	mov    %eax,(%esp)
  1000e7:	e8 b2 ff ff ff       	call   10009e <grade_backtrace1>
}
  1000ec:	90                   	nop
  1000ed:	c9                   	leave  
  1000ee:	c3                   	ret    

001000ef <grade_backtrace>:

void
grade_backtrace(void) {
  1000ef:	f3 0f 1e fb          	endbr32 
  1000f3:	55                   	push   %ebp
  1000f4:	89 e5                	mov    %esp,%ebp
  1000f6:	83 ec 18             	sub    $0x18,%esp
    grade_backtrace0(0, (int)kern_init, 0xffff0000);
  1000f9:	b8 00 00 10 00       	mov    $0x100000,%eax
  1000fe:	c7 44 24 08 00 00 ff 	movl   $0xffff0000,0x8(%esp)
  100105:	ff 
  100106:	89 44 24 04          	mov    %eax,0x4(%esp)
  10010a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  100111:	e8 ba ff ff ff       	call   1000d0 <grade_backtrace0>
}
  100116:	90                   	nop
  100117:	c9                   	leave  
  100118:	c3                   	ret    

00100119 <lab1_print_cur_status>:

static void
lab1_print_cur_status(void) {
  100119:	f3 0f 1e fb          	endbr32 
  10011d:	55                   	push   %ebp
  10011e:	89 e5                	mov    %esp,%ebp
  100120:	83 ec 28             	sub    $0x28,%esp
    static int round = 0;
    uint16_t reg1, reg2, reg3, reg4;
    asm volatile (
  100123:	8c 4d f6             	mov    %cs,-0xa(%ebp)
  100126:	8c 5d f4             	mov    %ds,-0xc(%ebp)
  100129:	8c 45 f2             	mov    %es,-0xe(%ebp)
  10012c:	8c 55 f0             	mov    %ss,-0x10(%ebp)
            "mov %%cs, %0;"
            "mov %%ds, %1;"
            "mov %%es, %2;"
            "mov %%ss, %3;"
            : "=m"(reg1), "=m"(reg2), "=m"(reg3), "=m"(reg4));
    cprintf("%d: @ring %d\n", round, reg1 & 3);
  10012f:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  100133:	83 e0 03             	and    $0x3,%eax
  100136:	89 c2                	mov    %eax,%edx
  100138:	a1 20 0a 11 00       	mov    0x110a20,%eax
  10013d:	89 54 24 08          	mov    %edx,0x8(%esp)
  100141:	89 44 24 04          	mov    %eax,0x4(%esp)
  100145:	c7 04 24 21 3a 10 00 	movl   $0x103a21,(%esp)
  10014c:	e8 43 01 00 00       	call   100294 <cprintf>
    cprintf("%d:  cs = %x\n", round, reg1);
  100151:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  100155:	89 c2                	mov    %eax,%edx
  100157:	a1 20 0a 11 00       	mov    0x110a20,%eax
  10015c:	89 54 24 08          	mov    %edx,0x8(%esp)
  100160:	89 44 24 04          	mov    %eax,0x4(%esp)
  100164:	c7 04 24 2f 3a 10 00 	movl   $0x103a2f,(%esp)
  10016b:	e8 24 01 00 00       	call   100294 <cprintf>
    cprintf("%d:  ds = %x\n", round, reg2);
  100170:	0f b7 45 f4          	movzwl -0xc(%ebp),%eax
  100174:	89 c2                	mov    %eax,%edx
  100176:	a1 20 0a 11 00       	mov    0x110a20,%eax
  10017b:	89 54 24 08          	mov    %edx,0x8(%esp)
  10017f:	89 44 24 04          	mov    %eax,0x4(%esp)
  100183:	c7 04 24 3d 3a 10 00 	movl   $0x103a3d,(%esp)
  10018a:	e8 05 01 00 00       	call   100294 <cprintf>
    cprintf("%d:  es = %x\n", round, reg3);
  10018f:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  100193:	89 c2                	mov    %eax,%edx
  100195:	a1 20 0a 11 00       	mov    0x110a20,%eax
  10019a:	89 54 24 08          	mov    %edx,0x8(%esp)
  10019e:	89 44 24 04          	mov    %eax,0x4(%esp)
  1001a2:	c7 04 24 4b 3a 10 00 	movl   $0x103a4b,(%esp)
  1001a9:	e8 e6 00 00 00       	call   100294 <cprintf>
    cprintf("%d:  ss = %x\n", round, reg4);
  1001ae:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
  1001b2:	89 c2                	mov    %eax,%edx
  1001b4:	a1 20 0a 11 00       	mov    0x110a20,%eax
  1001b9:	89 54 24 08          	mov    %edx,0x8(%esp)
  1001bd:	89 44 24 04          	mov    %eax,0x4(%esp)
  1001c1:	c7 04 24 59 3a 10 00 	movl   $0x103a59,(%esp)
  1001c8:	e8 c7 00 00 00       	call   100294 <cprintf>
    round ++;
  1001cd:	a1 20 0a 11 00       	mov    0x110a20,%eax
  1001d2:	40                   	inc    %eax
  1001d3:	a3 20 0a 11 00       	mov    %eax,0x110a20
}
  1001d8:	90                   	nop
  1001d9:	c9                   	leave  
  1001da:	c3                   	ret    

001001db <lab1_switch_to_user>:

static void
lab1_switch_to_user(void) {
  1001db:	f3 0f 1e fb          	endbr32 
  1001df:	55                   	push   %ebp
  1001e0:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 : TODO
    asm volatile (
  1001e2:	83 ec 08             	sub    $0x8,%esp
  1001e5:	cd 78                	int    $0x78
  1001e7:	89 ec                	mov    %ebp,%esp
	    "int %0 \n"
	    "movl %%ebp, %%esp"
	    : 
	    : "i"(T_SWITCH_TOU)
	);
}
  1001e9:	90                   	nop
  1001ea:	5d                   	pop    %ebp
  1001eb:	c3                   	ret    

001001ec <lab1_switch_to_kernel>:

static void
lab1_switch_to_kernel(void) {
  1001ec:	f3 0f 1e fb          	endbr32 
  1001f0:	55                   	push   %ebp
  1001f1:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 :  TODO
    asm volatile (
  1001f3:	cd 79                	int    $0x79
  1001f5:	89 ec                	mov    %ebp,%esp
	    "int %0 \n"
	    "movl %%ebp, %%esp \n"
	    : 
	    : "i"(T_SWITCH_TOK)
	);
}
  1001f7:	90                   	nop
  1001f8:	5d                   	pop    %ebp
  1001f9:	c3                   	ret    

001001fa <lab1_switch_test>:

static void
lab1_switch_test(void) {
  1001fa:	f3 0f 1e fb          	endbr32 
  1001fe:	55                   	push   %ebp
  1001ff:	89 e5                	mov    %esp,%ebp
  100201:	83 ec 18             	sub    $0x18,%esp
    lab1_print_cur_status();
  100204:	e8 10 ff ff ff       	call   100119 <lab1_print_cur_status>
    cprintf("+++ switch to  user  mode +++\n");
  100209:	c7 04 24 68 3a 10 00 	movl   $0x103a68,(%esp)
  100210:	e8 7f 00 00 00       	call   100294 <cprintf>
    lab1_switch_to_user();
  100215:	e8 c1 ff ff ff       	call   1001db <lab1_switch_to_user>
    lab1_print_cur_status();
  10021a:	e8 fa fe ff ff       	call   100119 <lab1_print_cur_status>
    cprintf("+++ switch to kernel mode +++\n");
  10021f:	c7 04 24 88 3a 10 00 	movl   $0x103a88,(%esp)
  100226:	e8 69 00 00 00       	call   100294 <cprintf>
    lab1_switch_to_kernel();
  10022b:	e8 bc ff ff ff       	call   1001ec <lab1_switch_to_kernel>
    lab1_print_cur_status();
  100230:	e8 e4 fe ff ff       	call   100119 <lab1_print_cur_status>
}
  100235:	90                   	nop
  100236:	c9                   	leave  
  100237:	c3                   	ret    

00100238 <cputch>:
/* *
 * cputch - writes a single character @c to stdout, and it will
 * increace the value of counter pointed by @cnt.
 * */
static void
cputch(int c, int *cnt) {
  100238:	f3 0f 1e fb          	endbr32 
  10023c:	55                   	push   %ebp
  10023d:	89 e5                	mov    %esp,%ebp
  10023f:	83 ec 18             	sub    $0x18,%esp
    cons_putc(c);
  100242:	8b 45 08             	mov    0x8(%ebp),%eax
  100245:	89 04 24             	mov    %eax,(%esp)
  100248:	e8 2b 14 00 00       	call   101678 <cons_putc>
    (*cnt) ++;
  10024d:	8b 45 0c             	mov    0xc(%ebp),%eax
  100250:	8b 00                	mov    (%eax),%eax
  100252:	8d 50 01             	lea    0x1(%eax),%edx
  100255:	8b 45 0c             	mov    0xc(%ebp),%eax
  100258:	89 10                	mov    %edx,(%eax)
}
  10025a:	90                   	nop
  10025b:	c9                   	leave  
  10025c:	c3                   	ret    

0010025d <vcprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want cprintf() instead.
 * */
int
vcprintf(const char *fmt, va_list ap) {
  10025d:	f3 0f 1e fb          	endbr32 
  100261:	55                   	push   %ebp
  100262:	89 e5                	mov    %esp,%ebp
  100264:	83 ec 28             	sub    $0x28,%esp
    int cnt = 0;
  100267:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    vprintfmt((void*)cputch, &cnt, fmt, ap);
  10026e:	8b 45 0c             	mov    0xc(%ebp),%eax
  100271:	89 44 24 0c          	mov    %eax,0xc(%esp)
  100275:	8b 45 08             	mov    0x8(%ebp),%eax
  100278:	89 44 24 08          	mov    %eax,0x8(%esp)
  10027c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  10027f:	89 44 24 04          	mov    %eax,0x4(%esp)
  100283:	c7 04 24 38 02 10 00 	movl   $0x100238,(%esp)
  10028a:	e8 a5 32 00 00       	call   103534 <vprintfmt>
    return cnt;
  10028f:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  100292:	c9                   	leave  
  100293:	c3                   	ret    

00100294 <cprintf>:
 *
 * The return value is the number of characters which would be
 * written to stdout.
 * */
int
cprintf(const char *fmt, ...) {
  100294:	f3 0f 1e fb          	endbr32 
  100298:	55                   	push   %ebp
  100299:	89 e5                	mov    %esp,%ebp
  10029b:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
  10029e:	8d 45 0c             	lea    0xc(%ebp),%eax
  1002a1:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vcprintf(fmt, ap);
  1002a4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1002a7:	89 44 24 04          	mov    %eax,0x4(%esp)
  1002ab:	8b 45 08             	mov    0x8(%ebp),%eax
  1002ae:	89 04 24             	mov    %eax,(%esp)
  1002b1:	e8 a7 ff ff ff       	call   10025d <vcprintf>
  1002b6:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
  1002b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  1002bc:	c9                   	leave  
  1002bd:	c3                   	ret    

001002be <cputchar>:

/* cputchar - writes a single character to stdout */
void
cputchar(int c) {
  1002be:	f3 0f 1e fb          	endbr32 
  1002c2:	55                   	push   %ebp
  1002c3:	89 e5                	mov    %esp,%ebp
  1002c5:	83 ec 18             	sub    $0x18,%esp
    cons_putc(c);
  1002c8:	8b 45 08             	mov    0x8(%ebp),%eax
  1002cb:	89 04 24             	mov    %eax,(%esp)
  1002ce:	e8 a5 13 00 00       	call   101678 <cons_putc>
}
  1002d3:	90                   	nop
  1002d4:	c9                   	leave  
  1002d5:	c3                   	ret    

001002d6 <cputs>:
/* *
 * cputs- writes the string pointed by @str to stdout and
 * appends a newline character.
 * */
int
cputs(const char *str) {
  1002d6:	f3 0f 1e fb          	endbr32 
  1002da:	55                   	push   %ebp
  1002db:	89 e5                	mov    %esp,%ebp
  1002dd:	83 ec 28             	sub    $0x28,%esp
    int cnt = 0;
  1002e0:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    char c;
    while ((c = *str ++) != '\0') {
  1002e7:	eb 13                	jmp    1002fc <cputs+0x26>
        cputch(c, &cnt);
  1002e9:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  1002ed:	8d 55 f0             	lea    -0x10(%ebp),%edx
  1002f0:	89 54 24 04          	mov    %edx,0x4(%esp)
  1002f4:	89 04 24             	mov    %eax,(%esp)
  1002f7:	e8 3c ff ff ff       	call   100238 <cputch>
    while ((c = *str ++) != '\0') {
  1002fc:	8b 45 08             	mov    0x8(%ebp),%eax
  1002ff:	8d 50 01             	lea    0x1(%eax),%edx
  100302:	89 55 08             	mov    %edx,0x8(%ebp)
  100305:	0f b6 00             	movzbl (%eax),%eax
  100308:	88 45 f7             	mov    %al,-0x9(%ebp)
  10030b:	80 7d f7 00          	cmpb   $0x0,-0x9(%ebp)
  10030f:	75 d8                	jne    1002e9 <cputs+0x13>
    }
    cputch('\n', &cnt);
  100311:	8d 45 f0             	lea    -0x10(%ebp),%eax
  100314:	89 44 24 04          	mov    %eax,0x4(%esp)
  100318:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
  10031f:	e8 14 ff ff ff       	call   100238 <cputch>
    return cnt;
  100324:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  100327:	c9                   	leave  
  100328:	c3                   	ret    

00100329 <getchar>:

/* getchar - reads a single non-zero character from stdin */
int
getchar(void) {
  100329:	f3 0f 1e fb          	endbr32 
  10032d:	55                   	push   %ebp
  10032e:	89 e5                	mov    %esp,%ebp
  100330:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = cons_getc()) == 0)
  100333:	90                   	nop
  100334:	e8 6d 13 00 00       	call   1016a6 <cons_getc>
  100339:	89 45 f4             	mov    %eax,-0xc(%ebp)
  10033c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  100340:	74 f2                	je     100334 <getchar+0xb>
        /* do nothing */;
    return c;
  100342:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  100345:	c9                   	leave  
  100346:	c3                   	ret    

00100347 <readline>:
 * The readline() function returns the text of the line read. If some errors
 * are happened, NULL is returned. The return value is a global variable,
 * thus it should be copied before it is used.
 * */
char *
readline(const char *prompt) {
  100347:	f3 0f 1e fb          	endbr32 
  10034b:	55                   	push   %ebp
  10034c:	89 e5                	mov    %esp,%ebp
  10034e:	83 ec 28             	sub    $0x28,%esp
    if (prompt != NULL) {
  100351:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  100355:	74 13                	je     10036a <readline+0x23>
        cprintf("%s", prompt);
  100357:	8b 45 08             	mov    0x8(%ebp),%eax
  10035a:	89 44 24 04          	mov    %eax,0x4(%esp)
  10035e:	c7 04 24 a7 3a 10 00 	movl   $0x103aa7,(%esp)
  100365:	e8 2a ff ff ff       	call   100294 <cprintf>
    }
    int i = 0, c;
  10036a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        c = getchar();
  100371:	e8 b3 ff ff ff       	call   100329 <getchar>
  100376:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (c < 0) {
  100379:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  10037d:	79 07                	jns    100386 <readline+0x3f>
            return NULL;
  10037f:	b8 00 00 00 00       	mov    $0x0,%eax
  100384:	eb 78                	jmp    1003fe <readline+0xb7>
        }
        else if (c >= ' ' && i < BUFSIZE - 1) {
  100386:	83 7d f0 1f          	cmpl   $0x1f,-0x10(%ebp)
  10038a:	7e 28                	jle    1003b4 <readline+0x6d>
  10038c:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  100393:	7f 1f                	jg     1003b4 <readline+0x6d>
            cputchar(c);
  100395:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100398:	89 04 24             	mov    %eax,(%esp)
  10039b:	e8 1e ff ff ff       	call   1002be <cputchar>
            buf[i ++] = c;
  1003a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1003a3:	8d 50 01             	lea    0x1(%eax),%edx
  1003a6:	89 55 f4             	mov    %edx,-0xc(%ebp)
  1003a9:	8b 55 f0             	mov    -0x10(%ebp),%edx
  1003ac:	88 90 40 0a 11 00    	mov    %dl,0x110a40(%eax)
  1003b2:	eb 45                	jmp    1003f9 <readline+0xb2>
        }
        else if (c == '\b' && i > 0) {
  1003b4:	83 7d f0 08          	cmpl   $0x8,-0x10(%ebp)
  1003b8:	75 16                	jne    1003d0 <readline+0x89>
  1003ba:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1003be:	7e 10                	jle    1003d0 <readline+0x89>
            cputchar(c);
  1003c0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1003c3:	89 04 24             	mov    %eax,(%esp)
  1003c6:	e8 f3 fe ff ff       	call   1002be <cputchar>
            i --;
  1003cb:	ff 4d f4             	decl   -0xc(%ebp)
  1003ce:	eb 29                	jmp    1003f9 <readline+0xb2>
        }
        else if (c == '\n' || c == '\r') {
  1003d0:	83 7d f0 0a          	cmpl   $0xa,-0x10(%ebp)
  1003d4:	74 06                	je     1003dc <readline+0x95>
  1003d6:	83 7d f0 0d          	cmpl   $0xd,-0x10(%ebp)
  1003da:	75 95                	jne    100371 <readline+0x2a>
            cputchar(c);
  1003dc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1003df:	89 04 24             	mov    %eax,(%esp)
  1003e2:	e8 d7 fe ff ff       	call   1002be <cputchar>
            buf[i] = '\0';
  1003e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1003ea:	05 40 0a 11 00       	add    $0x110a40,%eax
  1003ef:	c6 00 00             	movb   $0x0,(%eax)
            return buf;
  1003f2:	b8 40 0a 11 00       	mov    $0x110a40,%eax
  1003f7:	eb 05                	jmp    1003fe <readline+0xb7>
        c = getchar();
  1003f9:	e9 73 ff ff ff       	jmp    100371 <readline+0x2a>
        }
    }
}
  1003fe:	c9                   	leave  
  1003ff:	c3                   	ret    

00100400 <__panic>:
/* *
 * __panic - __panic is called on unresolvable fatal errors. it prints
 * "panic: 'message'", and then enters the kernel monitor.
 * */
void
__panic(const char *file, int line, const char *fmt, ...) {
  100400:	f3 0f 1e fb          	endbr32 
  100404:	55                   	push   %ebp
  100405:	89 e5                	mov    %esp,%ebp
  100407:	83 ec 28             	sub    $0x28,%esp
    if (is_panic) {
  10040a:	a1 40 0e 11 00       	mov    0x110e40,%eax
  10040f:	85 c0                	test   %eax,%eax
  100411:	75 5b                	jne    10046e <__panic+0x6e>
        goto panic_dead;
    }
    is_panic = 1;
  100413:	c7 05 40 0e 11 00 01 	movl   $0x1,0x110e40
  10041a:	00 00 00 

    // print the 'message'
    va_list ap;
    va_start(ap, fmt);
  10041d:	8d 45 14             	lea    0x14(%ebp),%eax
  100420:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel panic at %s:%d:\n    ", file, line);
  100423:	8b 45 0c             	mov    0xc(%ebp),%eax
  100426:	89 44 24 08          	mov    %eax,0x8(%esp)
  10042a:	8b 45 08             	mov    0x8(%ebp),%eax
  10042d:	89 44 24 04          	mov    %eax,0x4(%esp)
  100431:	c7 04 24 aa 3a 10 00 	movl   $0x103aaa,(%esp)
  100438:	e8 57 fe ff ff       	call   100294 <cprintf>
    vcprintf(fmt, ap);
  10043d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100440:	89 44 24 04          	mov    %eax,0x4(%esp)
  100444:	8b 45 10             	mov    0x10(%ebp),%eax
  100447:	89 04 24             	mov    %eax,(%esp)
  10044a:	e8 0e fe ff ff       	call   10025d <vcprintf>
    cprintf("\n");
  10044f:	c7 04 24 c6 3a 10 00 	movl   $0x103ac6,(%esp)
  100456:	e8 39 fe ff ff       	call   100294 <cprintf>
    
    cprintf("stack trackback:\n");
  10045b:	c7 04 24 c8 3a 10 00 	movl   $0x103ac8,(%esp)
  100462:	e8 2d fe ff ff       	call   100294 <cprintf>
    print_stackframe();
  100467:	e8 3d 06 00 00       	call   100aa9 <print_stackframe>
  10046c:	eb 01                	jmp    10046f <__panic+0x6f>
        goto panic_dead;
  10046e:	90                   	nop
    
    va_end(ap);

panic_dead:
    intr_disable();
  10046f:	e8 80 14 00 00       	call   1018f4 <intr_disable>
    while (1) {
        kmonitor(NULL);
  100474:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  10047b:	e8 5d 08 00 00       	call   100cdd <kmonitor>
  100480:	eb f2                	jmp    100474 <__panic+0x74>

00100482 <__warn>:
    }
}

/* __warn - like panic, but don't */
void
__warn(const char *file, int line, const char *fmt, ...) {
  100482:	f3 0f 1e fb          	endbr32 
  100486:	55                   	push   %ebp
  100487:	89 e5                	mov    %esp,%ebp
  100489:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    va_start(ap, fmt);
  10048c:	8d 45 14             	lea    0x14(%ebp),%eax
  10048f:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel warning at %s:%d:\n    ", file, line);
  100492:	8b 45 0c             	mov    0xc(%ebp),%eax
  100495:	89 44 24 08          	mov    %eax,0x8(%esp)
  100499:	8b 45 08             	mov    0x8(%ebp),%eax
  10049c:	89 44 24 04          	mov    %eax,0x4(%esp)
  1004a0:	c7 04 24 da 3a 10 00 	movl   $0x103ada,(%esp)
  1004a7:	e8 e8 fd ff ff       	call   100294 <cprintf>
    vcprintf(fmt, ap);
  1004ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1004af:	89 44 24 04          	mov    %eax,0x4(%esp)
  1004b3:	8b 45 10             	mov    0x10(%ebp),%eax
  1004b6:	89 04 24             	mov    %eax,(%esp)
  1004b9:	e8 9f fd ff ff       	call   10025d <vcprintf>
    cprintf("\n");
  1004be:	c7 04 24 c6 3a 10 00 	movl   $0x103ac6,(%esp)
  1004c5:	e8 ca fd ff ff       	call   100294 <cprintf>
    va_end(ap);
}
  1004ca:	90                   	nop
  1004cb:	c9                   	leave  
  1004cc:	c3                   	ret    

001004cd <is_kernel_panic>:

bool
is_kernel_panic(void) {
  1004cd:	f3 0f 1e fb          	endbr32 
  1004d1:	55                   	push   %ebp
  1004d2:	89 e5                	mov    %esp,%ebp
    return is_panic;
  1004d4:	a1 40 0e 11 00       	mov    0x110e40,%eax
}
  1004d9:	5d                   	pop    %ebp
  1004da:	c3                   	ret    

001004db <stab_binsearch>:
 *      stab_binsearch(stabs, &left, &right, N_SO, 0xf0100184);
 * will exit setting left = 118, right = 554.
 * */
static void
stab_binsearch(const struct stab *stabs, int *region_left, int *region_right,
           int type, uintptr_t addr) {
  1004db:	f3 0f 1e fb          	endbr32 
  1004df:	55                   	push   %ebp
  1004e0:	89 e5                	mov    %esp,%ebp
  1004e2:	83 ec 20             	sub    $0x20,%esp
    int l = *region_left, r = *region_right, any_matches = 0;
  1004e5:	8b 45 0c             	mov    0xc(%ebp),%eax
  1004e8:	8b 00                	mov    (%eax),%eax
  1004ea:	89 45 fc             	mov    %eax,-0x4(%ebp)
  1004ed:	8b 45 10             	mov    0x10(%ebp),%eax
  1004f0:	8b 00                	mov    (%eax),%eax
  1004f2:	89 45 f8             	mov    %eax,-0x8(%ebp)
  1004f5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

    while (l <= r) {
  1004fc:	e9 ca 00 00 00       	jmp    1005cb <stab_binsearch+0xf0>
        int true_m = (l + r) / 2, m = true_m;
  100501:	8b 55 fc             	mov    -0x4(%ebp),%edx
  100504:	8b 45 f8             	mov    -0x8(%ebp),%eax
  100507:	01 d0                	add    %edx,%eax
  100509:	89 c2                	mov    %eax,%edx
  10050b:	c1 ea 1f             	shr    $0x1f,%edx
  10050e:	01 d0                	add    %edx,%eax
  100510:	d1 f8                	sar    %eax
  100512:	89 45 ec             	mov    %eax,-0x14(%ebp)
  100515:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100518:	89 45 f0             	mov    %eax,-0x10(%ebp)

        // search for earliest stab with right type
        while (m >= l && stabs[m].n_type != type) {
  10051b:	eb 03                	jmp    100520 <stab_binsearch+0x45>
            m --;
  10051d:	ff 4d f0             	decl   -0x10(%ebp)
        while (m >= l && stabs[m].n_type != type) {
  100520:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100523:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  100526:	7c 1f                	jl     100547 <stab_binsearch+0x6c>
  100528:	8b 55 f0             	mov    -0x10(%ebp),%edx
  10052b:	89 d0                	mov    %edx,%eax
  10052d:	01 c0                	add    %eax,%eax
  10052f:	01 d0                	add    %edx,%eax
  100531:	c1 e0 02             	shl    $0x2,%eax
  100534:	89 c2                	mov    %eax,%edx
  100536:	8b 45 08             	mov    0x8(%ebp),%eax
  100539:	01 d0                	add    %edx,%eax
  10053b:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  10053f:	0f b6 c0             	movzbl %al,%eax
  100542:	39 45 14             	cmp    %eax,0x14(%ebp)
  100545:	75 d6                	jne    10051d <stab_binsearch+0x42>
        }
        if (m < l) {    // no match in [l, m]
  100547:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10054a:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  10054d:	7d 09                	jge    100558 <stab_binsearch+0x7d>
            l = true_m + 1;
  10054f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100552:	40                   	inc    %eax
  100553:	89 45 fc             	mov    %eax,-0x4(%ebp)
            continue;
  100556:	eb 73                	jmp    1005cb <stab_binsearch+0xf0>
        }

        // actual binary search
        any_matches = 1;
  100558:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
        if (stabs[m].n_value < addr) {
  10055f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100562:	89 d0                	mov    %edx,%eax
  100564:	01 c0                	add    %eax,%eax
  100566:	01 d0                	add    %edx,%eax
  100568:	c1 e0 02             	shl    $0x2,%eax
  10056b:	89 c2                	mov    %eax,%edx
  10056d:	8b 45 08             	mov    0x8(%ebp),%eax
  100570:	01 d0                	add    %edx,%eax
  100572:	8b 40 08             	mov    0x8(%eax),%eax
  100575:	39 45 18             	cmp    %eax,0x18(%ebp)
  100578:	76 11                	jbe    10058b <stab_binsearch+0xb0>
            *region_left = m;
  10057a:	8b 45 0c             	mov    0xc(%ebp),%eax
  10057d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100580:	89 10                	mov    %edx,(%eax)
            l = true_m + 1;
  100582:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100585:	40                   	inc    %eax
  100586:	89 45 fc             	mov    %eax,-0x4(%ebp)
  100589:	eb 40                	jmp    1005cb <stab_binsearch+0xf0>
        } else if (stabs[m].n_value > addr) {
  10058b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  10058e:	89 d0                	mov    %edx,%eax
  100590:	01 c0                	add    %eax,%eax
  100592:	01 d0                	add    %edx,%eax
  100594:	c1 e0 02             	shl    $0x2,%eax
  100597:	89 c2                	mov    %eax,%edx
  100599:	8b 45 08             	mov    0x8(%ebp),%eax
  10059c:	01 d0                	add    %edx,%eax
  10059e:	8b 40 08             	mov    0x8(%eax),%eax
  1005a1:	39 45 18             	cmp    %eax,0x18(%ebp)
  1005a4:	73 14                	jae    1005ba <stab_binsearch+0xdf>
            *region_right = m - 1;
  1005a6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1005a9:	8d 50 ff             	lea    -0x1(%eax),%edx
  1005ac:	8b 45 10             	mov    0x10(%ebp),%eax
  1005af:	89 10                	mov    %edx,(%eax)
            r = m - 1;
  1005b1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1005b4:	48                   	dec    %eax
  1005b5:	89 45 f8             	mov    %eax,-0x8(%ebp)
  1005b8:	eb 11                	jmp    1005cb <stab_binsearch+0xf0>
        } else {
            // exact match for 'addr', but continue loop to find
            // *region_right
            *region_left = m;
  1005ba:	8b 45 0c             	mov    0xc(%ebp),%eax
  1005bd:	8b 55 f0             	mov    -0x10(%ebp),%edx
  1005c0:	89 10                	mov    %edx,(%eax)
            l = m;
  1005c2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1005c5:	89 45 fc             	mov    %eax,-0x4(%ebp)
            addr ++;
  1005c8:	ff 45 18             	incl   0x18(%ebp)
    while (l <= r) {
  1005cb:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1005ce:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  1005d1:	0f 8e 2a ff ff ff    	jle    100501 <stab_binsearch+0x26>
        }
    }

    if (!any_matches) {
  1005d7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1005db:	75 0f                	jne    1005ec <stab_binsearch+0x111>
        *region_right = *region_left - 1;
  1005dd:	8b 45 0c             	mov    0xc(%ebp),%eax
  1005e0:	8b 00                	mov    (%eax),%eax
  1005e2:	8d 50 ff             	lea    -0x1(%eax),%edx
  1005e5:	8b 45 10             	mov    0x10(%ebp),%eax
  1005e8:	89 10                	mov    %edx,(%eax)
        l = *region_right;
        for (; l > *region_left && stabs[l].n_type != type; l --)
            /* do nothing */;
        *region_left = l;
    }
}
  1005ea:	eb 3e                	jmp    10062a <stab_binsearch+0x14f>
        l = *region_right;
  1005ec:	8b 45 10             	mov    0x10(%ebp),%eax
  1005ef:	8b 00                	mov    (%eax),%eax
  1005f1:	89 45 fc             	mov    %eax,-0x4(%ebp)
        for (; l > *region_left && stabs[l].n_type != type; l --)
  1005f4:	eb 03                	jmp    1005f9 <stab_binsearch+0x11e>
  1005f6:	ff 4d fc             	decl   -0x4(%ebp)
  1005f9:	8b 45 0c             	mov    0xc(%ebp),%eax
  1005fc:	8b 00                	mov    (%eax),%eax
  1005fe:	39 45 fc             	cmp    %eax,-0x4(%ebp)
  100601:	7e 1f                	jle    100622 <stab_binsearch+0x147>
  100603:	8b 55 fc             	mov    -0x4(%ebp),%edx
  100606:	89 d0                	mov    %edx,%eax
  100608:	01 c0                	add    %eax,%eax
  10060a:	01 d0                	add    %edx,%eax
  10060c:	c1 e0 02             	shl    $0x2,%eax
  10060f:	89 c2                	mov    %eax,%edx
  100611:	8b 45 08             	mov    0x8(%ebp),%eax
  100614:	01 d0                	add    %edx,%eax
  100616:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  10061a:	0f b6 c0             	movzbl %al,%eax
  10061d:	39 45 14             	cmp    %eax,0x14(%ebp)
  100620:	75 d4                	jne    1005f6 <stab_binsearch+0x11b>
        *region_left = l;
  100622:	8b 45 0c             	mov    0xc(%ebp),%eax
  100625:	8b 55 fc             	mov    -0x4(%ebp),%edx
  100628:	89 10                	mov    %edx,(%eax)
}
  10062a:	90                   	nop
  10062b:	c9                   	leave  
  10062c:	c3                   	ret    

0010062d <debuginfo_eip>:
 * the specified instruction address, @addr.  Returns 0 if information
 * was found, and negative if not.  But even if it returns negative it
 * has stored some information into '*info'.
 * */
int
debuginfo_eip(uintptr_t addr, struct eipdebuginfo *info) {
  10062d:	f3 0f 1e fb          	endbr32 
  100631:	55                   	push   %ebp
  100632:	89 e5                	mov    %esp,%ebp
  100634:	83 ec 58             	sub    $0x58,%esp
    const struct stab *stabs, *stab_end;
    const char *stabstr, *stabstr_end;

    info->eip_file = "<unknown>";
  100637:	8b 45 0c             	mov    0xc(%ebp),%eax
  10063a:	c7 00 f8 3a 10 00    	movl   $0x103af8,(%eax)
    info->eip_line = 0;
  100640:	8b 45 0c             	mov    0xc(%ebp),%eax
  100643:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    info->eip_fn_name = "<unknown>";
  10064a:	8b 45 0c             	mov    0xc(%ebp),%eax
  10064d:	c7 40 08 f8 3a 10 00 	movl   $0x103af8,0x8(%eax)
    info->eip_fn_namelen = 9;
  100654:	8b 45 0c             	mov    0xc(%ebp),%eax
  100657:	c7 40 0c 09 00 00 00 	movl   $0x9,0xc(%eax)
    info->eip_fn_addr = addr;
  10065e:	8b 45 0c             	mov    0xc(%ebp),%eax
  100661:	8b 55 08             	mov    0x8(%ebp),%edx
  100664:	89 50 10             	mov    %edx,0x10(%eax)
    info->eip_fn_narg = 0;
  100667:	8b 45 0c             	mov    0xc(%ebp),%eax
  10066a:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)

    stabs = __STAB_BEGIN__;
  100671:	c7 45 f4 6c 43 10 00 	movl   $0x10436c,-0xc(%ebp)
    stab_end = __STAB_END__;
  100678:	c7 45 f0 44 d4 10 00 	movl   $0x10d444,-0x10(%ebp)
    stabstr = __STABSTR_BEGIN__;
  10067f:	c7 45 ec 45 d4 10 00 	movl   $0x10d445,-0x14(%ebp)
    stabstr_end = __STABSTR_END__;
  100686:	c7 45 e8 8e f5 10 00 	movl   $0x10f58e,-0x18(%ebp)

    // String table validity checks
    if (stabstr_end <= stabstr || stabstr_end[-1] != 0) {
  10068d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100690:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  100693:	76 0b                	jbe    1006a0 <debuginfo_eip+0x73>
  100695:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100698:	48                   	dec    %eax
  100699:	0f b6 00             	movzbl (%eax),%eax
  10069c:	84 c0                	test   %al,%al
  10069e:	74 0a                	je     1006aa <debuginfo_eip+0x7d>
        return -1;
  1006a0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  1006a5:	e9 ab 02 00 00       	jmp    100955 <debuginfo_eip+0x328>
    // 'eip'.  First, we find the basic source file containing 'eip'.
    // Then, we look in that source file for the function.  Then we look
    // for the line number.

    // Search the entire set of stabs for the source file (type N_SO).
    int lfile = 0, rfile = (stab_end - stabs) - 1;
  1006aa:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  1006b1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1006b4:	2b 45 f4             	sub    -0xc(%ebp),%eax
  1006b7:	c1 f8 02             	sar    $0x2,%eax
  1006ba:	69 c0 ab aa aa aa    	imul   $0xaaaaaaab,%eax,%eax
  1006c0:	48                   	dec    %eax
  1006c1:	89 45 e0             	mov    %eax,-0x20(%ebp)
    stab_binsearch(stabs, &lfile, &rfile, N_SO, addr);
  1006c4:	8b 45 08             	mov    0x8(%ebp),%eax
  1006c7:	89 44 24 10          	mov    %eax,0x10(%esp)
  1006cb:	c7 44 24 0c 64 00 00 	movl   $0x64,0xc(%esp)
  1006d2:	00 
  1006d3:	8d 45 e0             	lea    -0x20(%ebp),%eax
  1006d6:	89 44 24 08          	mov    %eax,0x8(%esp)
  1006da:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  1006dd:	89 44 24 04          	mov    %eax,0x4(%esp)
  1006e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1006e4:	89 04 24             	mov    %eax,(%esp)
  1006e7:	e8 ef fd ff ff       	call   1004db <stab_binsearch>
    if (lfile == 0)
  1006ec:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1006ef:	85 c0                	test   %eax,%eax
  1006f1:	75 0a                	jne    1006fd <debuginfo_eip+0xd0>
        return -1;
  1006f3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  1006f8:	e9 58 02 00 00       	jmp    100955 <debuginfo_eip+0x328>

    // Search within that file's stabs for the function definition
    // (N_FUN).
    int lfun = lfile, rfun = rfile;
  1006fd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  100700:	89 45 dc             	mov    %eax,-0x24(%ebp)
  100703:	8b 45 e0             	mov    -0x20(%ebp),%eax
  100706:	89 45 d8             	mov    %eax,-0x28(%ebp)
    int lline, rline;
    stab_binsearch(stabs, &lfun, &rfun, N_FUN, addr);
  100709:	8b 45 08             	mov    0x8(%ebp),%eax
  10070c:	89 44 24 10          	mov    %eax,0x10(%esp)
  100710:	c7 44 24 0c 24 00 00 	movl   $0x24,0xc(%esp)
  100717:	00 
  100718:	8d 45 d8             	lea    -0x28(%ebp),%eax
  10071b:	89 44 24 08          	mov    %eax,0x8(%esp)
  10071f:	8d 45 dc             	lea    -0x24(%ebp),%eax
  100722:	89 44 24 04          	mov    %eax,0x4(%esp)
  100726:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100729:	89 04 24             	mov    %eax,(%esp)
  10072c:	e8 aa fd ff ff       	call   1004db <stab_binsearch>

    if (lfun <= rfun) {
  100731:	8b 55 dc             	mov    -0x24(%ebp),%edx
  100734:	8b 45 d8             	mov    -0x28(%ebp),%eax
  100737:	39 c2                	cmp    %eax,%edx
  100739:	7f 78                	jg     1007b3 <debuginfo_eip+0x186>
        // stabs[lfun] points to the function name
        // in the string table, but check bounds just in case.
        if (stabs[lfun].n_strx < stabstr_end - stabstr) {
  10073b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10073e:	89 c2                	mov    %eax,%edx
  100740:	89 d0                	mov    %edx,%eax
  100742:	01 c0                	add    %eax,%eax
  100744:	01 d0                	add    %edx,%eax
  100746:	c1 e0 02             	shl    $0x2,%eax
  100749:	89 c2                	mov    %eax,%edx
  10074b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10074e:	01 d0                	add    %edx,%eax
  100750:	8b 10                	mov    (%eax),%edx
  100752:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100755:	2b 45 ec             	sub    -0x14(%ebp),%eax
  100758:	39 c2                	cmp    %eax,%edx
  10075a:	73 22                	jae    10077e <debuginfo_eip+0x151>
            info->eip_fn_name = stabstr + stabs[lfun].n_strx;
  10075c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10075f:	89 c2                	mov    %eax,%edx
  100761:	89 d0                	mov    %edx,%eax
  100763:	01 c0                	add    %eax,%eax
  100765:	01 d0                	add    %edx,%eax
  100767:	c1 e0 02             	shl    $0x2,%eax
  10076a:	89 c2                	mov    %eax,%edx
  10076c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10076f:	01 d0                	add    %edx,%eax
  100771:	8b 10                	mov    (%eax),%edx
  100773:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100776:	01 c2                	add    %eax,%edx
  100778:	8b 45 0c             	mov    0xc(%ebp),%eax
  10077b:	89 50 08             	mov    %edx,0x8(%eax)
        }
        info->eip_fn_addr = stabs[lfun].n_value;
  10077e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100781:	89 c2                	mov    %eax,%edx
  100783:	89 d0                	mov    %edx,%eax
  100785:	01 c0                	add    %eax,%eax
  100787:	01 d0                	add    %edx,%eax
  100789:	c1 e0 02             	shl    $0x2,%eax
  10078c:	89 c2                	mov    %eax,%edx
  10078e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100791:	01 d0                	add    %edx,%eax
  100793:	8b 50 08             	mov    0x8(%eax),%edx
  100796:	8b 45 0c             	mov    0xc(%ebp),%eax
  100799:	89 50 10             	mov    %edx,0x10(%eax)
        addr -= info->eip_fn_addr;
  10079c:	8b 45 0c             	mov    0xc(%ebp),%eax
  10079f:	8b 40 10             	mov    0x10(%eax),%eax
  1007a2:	29 45 08             	sub    %eax,0x8(%ebp)
        // Search within the function definition for the line number.
        lline = lfun;
  1007a5:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1007a8:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfun;
  1007ab:	8b 45 d8             	mov    -0x28(%ebp),%eax
  1007ae:	89 45 d0             	mov    %eax,-0x30(%ebp)
  1007b1:	eb 15                	jmp    1007c8 <debuginfo_eip+0x19b>
    } else {
        // Couldn't find function stab!  Maybe we're in an assembly
        // file.  Search the whole file for the line number.
        info->eip_fn_addr = addr;
  1007b3:	8b 45 0c             	mov    0xc(%ebp),%eax
  1007b6:	8b 55 08             	mov    0x8(%ebp),%edx
  1007b9:	89 50 10             	mov    %edx,0x10(%eax)
        lline = lfile;
  1007bc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1007bf:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfile;
  1007c2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1007c5:	89 45 d0             	mov    %eax,-0x30(%ebp)
    }
    info->eip_fn_namelen = strfind(info->eip_fn_name, ':') - info->eip_fn_name;
  1007c8:	8b 45 0c             	mov    0xc(%ebp),%eax
  1007cb:	8b 40 08             	mov    0x8(%eax),%eax
  1007ce:	c7 44 24 04 3a 00 00 	movl   $0x3a,0x4(%esp)
  1007d5:	00 
  1007d6:	89 04 24             	mov    %eax,(%esp)
  1007d9:	e8 5e 28 00 00       	call   10303c <strfind>
  1007de:	8b 55 0c             	mov    0xc(%ebp),%edx
  1007e1:	8b 52 08             	mov    0x8(%edx),%edx
  1007e4:	29 d0                	sub    %edx,%eax
  1007e6:	89 c2                	mov    %eax,%edx
  1007e8:	8b 45 0c             	mov    0xc(%ebp),%eax
  1007eb:	89 50 0c             	mov    %edx,0xc(%eax)

    // Search within [lline, rline] for the line number stab.
    // If found, set info->eip_line to the right line number.
    // If not found, return -1.
    stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
  1007ee:	8b 45 08             	mov    0x8(%ebp),%eax
  1007f1:	89 44 24 10          	mov    %eax,0x10(%esp)
  1007f5:	c7 44 24 0c 44 00 00 	movl   $0x44,0xc(%esp)
  1007fc:	00 
  1007fd:	8d 45 d0             	lea    -0x30(%ebp),%eax
  100800:	89 44 24 08          	mov    %eax,0x8(%esp)
  100804:	8d 45 d4             	lea    -0x2c(%ebp),%eax
  100807:	89 44 24 04          	mov    %eax,0x4(%esp)
  10080b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10080e:	89 04 24             	mov    %eax,(%esp)
  100811:	e8 c5 fc ff ff       	call   1004db <stab_binsearch>
    if (lline <= rline) {
  100816:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  100819:	8b 45 d0             	mov    -0x30(%ebp),%eax
  10081c:	39 c2                	cmp    %eax,%edx
  10081e:	7f 23                	jg     100843 <debuginfo_eip+0x216>
        info->eip_line = stabs[rline].n_desc;
  100820:	8b 45 d0             	mov    -0x30(%ebp),%eax
  100823:	89 c2                	mov    %eax,%edx
  100825:	89 d0                	mov    %edx,%eax
  100827:	01 c0                	add    %eax,%eax
  100829:	01 d0                	add    %edx,%eax
  10082b:	c1 e0 02             	shl    $0x2,%eax
  10082e:	89 c2                	mov    %eax,%edx
  100830:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100833:	01 d0                	add    %edx,%eax
  100835:	0f b7 40 06          	movzwl 0x6(%eax),%eax
  100839:	89 c2                	mov    %eax,%edx
  10083b:	8b 45 0c             	mov    0xc(%ebp),%eax
  10083e:	89 50 04             	mov    %edx,0x4(%eax)

    // Search backwards from the line number for the relevant filename stab.
    // We can't just use the "lfile" stab because inlined functions
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
  100841:	eb 11                	jmp    100854 <debuginfo_eip+0x227>
        return -1;
  100843:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  100848:	e9 08 01 00 00       	jmp    100955 <debuginfo_eip+0x328>
           && stabs[lline].n_type != N_SOL
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
        lline --;
  10084d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100850:	48                   	dec    %eax
  100851:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    while (lline >= lfile
  100854:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  100857:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10085a:	39 c2                	cmp    %eax,%edx
  10085c:	7c 56                	jl     1008b4 <debuginfo_eip+0x287>
           && stabs[lline].n_type != N_SOL
  10085e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100861:	89 c2                	mov    %eax,%edx
  100863:	89 d0                	mov    %edx,%eax
  100865:	01 c0                	add    %eax,%eax
  100867:	01 d0                	add    %edx,%eax
  100869:	c1 e0 02             	shl    $0x2,%eax
  10086c:	89 c2                	mov    %eax,%edx
  10086e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100871:	01 d0                	add    %edx,%eax
  100873:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  100877:	3c 84                	cmp    $0x84,%al
  100879:	74 39                	je     1008b4 <debuginfo_eip+0x287>
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
  10087b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  10087e:	89 c2                	mov    %eax,%edx
  100880:	89 d0                	mov    %edx,%eax
  100882:	01 c0                	add    %eax,%eax
  100884:	01 d0                	add    %edx,%eax
  100886:	c1 e0 02             	shl    $0x2,%eax
  100889:	89 c2                	mov    %eax,%edx
  10088b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10088e:	01 d0                	add    %edx,%eax
  100890:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  100894:	3c 64                	cmp    $0x64,%al
  100896:	75 b5                	jne    10084d <debuginfo_eip+0x220>
  100898:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  10089b:	89 c2                	mov    %eax,%edx
  10089d:	89 d0                	mov    %edx,%eax
  10089f:	01 c0                	add    %eax,%eax
  1008a1:	01 d0                	add    %edx,%eax
  1008a3:	c1 e0 02             	shl    $0x2,%eax
  1008a6:	89 c2                	mov    %eax,%edx
  1008a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1008ab:	01 d0                	add    %edx,%eax
  1008ad:	8b 40 08             	mov    0x8(%eax),%eax
  1008b0:	85 c0                	test   %eax,%eax
  1008b2:	74 99                	je     10084d <debuginfo_eip+0x220>
    }
    if (lline >= lfile && stabs[lline].n_strx < stabstr_end - stabstr) {
  1008b4:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  1008b7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1008ba:	39 c2                	cmp    %eax,%edx
  1008bc:	7c 42                	jl     100900 <debuginfo_eip+0x2d3>
  1008be:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1008c1:	89 c2                	mov    %eax,%edx
  1008c3:	89 d0                	mov    %edx,%eax
  1008c5:	01 c0                	add    %eax,%eax
  1008c7:	01 d0                	add    %edx,%eax
  1008c9:	c1 e0 02             	shl    $0x2,%eax
  1008cc:	89 c2                	mov    %eax,%edx
  1008ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1008d1:	01 d0                	add    %edx,%eax
  1008d3:	8b 10                	mov    (%eax),%edx
  1008d5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1008d8:	2b 45 ec             	sub    -0x14(%ebp),%eax
  1008db:	39 c2                	cmp    %eax,%edx
  1008dd:	73 21                	jae    100900 <debuginfo_eip+0x2d3>
        info->eip_file = stabstr + stabs[lline].n_strx;
  1008df:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1008e2:	89 c2                	mov    %eax,%edx
  1008e4:	89 d0                	mov    %edx,%eax
  1008e6:	01 c0                	add    %eax,%eax
  1008e8:	01 d0                	add    %edx,%eax
  1008ea:	c1 e0 02             	shl    $0x2,%eax
  1008ed:	89 c2                	mov    %eax,%edx
  1008ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1008f2:	01 d0                	add    %edx,%eax
  1008f4:	8b 10                	mov    (%eax),%edx
  1008f6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1008f9:	01 c2                	add    %eax,%edx
  1008fb:	8b 45 0c             	mov    0xc(%ebp),%eax
  1008fe:	89 10                	mov    %edx,(%eax)
    }

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
  100900:	8b 55 dc             	mov    -0x24(%ebp),%edx
  100903:	8b 45 d8             	mov    -0x28(%ebp),%eax
  100906:	39 c2                	cmp    %eax,%edx
  100908:	7d 46                	jge    100950 <debuginfo_eip+0x323>
        for (lline = lfun + 1;
  10090a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10090d:	40                   	inc    %eax
  10090e:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  100911:	eb 16                	jmp    100929 <debuginfo_eip+0x2fc>
             lline < rfun && stabs[lline].n_type == N_PSYM;
             lline ++) {
            info->eip_fn_narg ++;
  100913:	8b 45 0c             	mov    0xc(%ebp),%eax
  100916:	8b 40 14             	mov    0x14(%eax),%eax
  100919:	8d 50 01             	lea    0x1(%eax),%edx
  10091c:	8b 45 0c             	mov    0xc(%ebp),%eax
  10091f:	89 50 14             	mov    %edx,0x14(%eax)
             lline ++) {
  100922:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100925:	40                   	inc    %eax
  100926:	89 45 d4             	mov    %eax,-0x2c(%ebp)
             lline < rfun && stabs[lline].n_type == N_PSYM;
  100929:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  10092c:	8b 45 d8             	mov    -0x28(%ebp),%eax
        for (lline = lfun + 1;
  10092f:	39 c2                	cmp    %eax,%edx
  100931:	7d 1d                	jge    100950 <debuginfo_eip+0x323>
             lline < rfun && stabs[lline].n_type == N_PSYM;
  100933:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100936:	89 c2                	mov    %eax,%edx
  100938:	89 d0                	mov    %edx,%eax
  10093a:	01 c0                	add    %eax,%eax
  10093c:	01 d0                	add    %edx,%eax
  10093e:	c1 e0 02             	shl    $0x2,%eax
  100941:	89 c2                	mov    %eax,%edx
  100943:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100946:	01 d0                	add    %edx,%eax
  100948:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  10094c:	3c a0                	cmp    $0xa0,%al
  10094e:	74 c3                	je     100913 <debuginfo_eip+0x2e6>
        }
    }
    return 0;
  100950:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100955:	c9                   	leave  
  100956:	c3                   	ret    

00100957 <print_kerninfo>:
 * print_kerninfo - print the information about kernel, including the location
 * of kernel entry, the start addresses of data and text segements, the start
 * address of free memory and how many memory that kernel has used.
 * */
void
print_kerninfo(void) {
  100957:	f3 0f 1e fb          	endbr32 
  10095b:	55                   	push   %ebp
  10095c:	89 e5                	mov    %esp,%ebp
  10095e:	83 ec 18             	sub    $0x18,%esp
    extern char etext[], edata[], end[], kern_init[];
    cprintf("Special kernel symbols:\n");
  100961:	c7 04 24 02 3b 10 00 	movl   $0x103b02,(%esp)
  100968:	e8 27 f9 ff ff       	call   100294 <cprintf>
    cprintf("  entry  0x%08x (phys)\n", kern_init);
  10096d:	c7 44 24 04 00 00 10 	movl   $0x100000,0x4(%esp)
  100974:	00 
  100975:	c7 04 24 1b 3b 10 00 	movl   $0x103b1b,(%esp)
  10097c:	e8 13 f9 ff ff       	call   100294 <cprintf>
    cprintf("  etext  0x%08x (phys)\n", etext);
  100981:	c7 44 24 04 ec 39 10 	movl   $0x1039ec,0x4(%esp)
  100988:	00 
  100989:	c7 04 24 33 3b 10 00 	movl   $0x103b33,(%esp)
  100990:	e8 ff f8 ff ff       	call   100294 <cprintf>
    cprintf("  edata  0x%08x (phys)\n", edata);
  100995:	c7 44 24 04 16 0a 11 	movl   $0x110a16,0x4(%esp)
  10099c:	00 
  10099d:	c7 04 24 4b 3b 10 00 	movl   $0x103b4b,(%esp)
  1009a4:	e8 eb f8 ff ff       	call   100294 <cprintf>
    cprintf("  end    0x%08x (phys)\n", end);
  1009a9:	c7 44 24 04 80 1d 11 	movl   $0x111d80,0x4(%esp)
  1009b0:	00 
  1009b1:	c7 04 24 63 3b 10 00 	movl   $0x103b63,(%esp)
  1009b8:	e8 d7 f8 ff ff       	call   100294 <cprintf>
    cprintf("Kernel executable memory footprint: %dKB\n", (end - kern_init + 1023)/1024);
  1009bd:	b8 80 1d 11 00       	mov    $0x111d80,%eax
  1009c2:	2d 00 00 10 00       	sub    $0x100000,%eax
  1009c7:	05 ff 03 00 00       	add    $0x3ff,%eax
  1009cc:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
  1009d2:	85 c0                	test   %eax,%eax
  1009d4:	0f 48 c2             	cmovs  %edx,%eax
  1009d7:	c1 f8 0a             	sar    $0xa,%eax
  1009da:	89 44 24 04          	mov    %eax,0x4(%esp)
  1009de:	c7 04 24 7c 3b 10 00 	movl   $0x103b7c,(%esp)
  1009e5:	e8 aa f8 ff ff       	call   100294 <cprintf>
}
  1009ea:	90                   	nop
  1009eb:	c9                   	leave  
  1009ec:	c3                   	ret    

001009ed <print_debuginfo>:
/* *
 * print_debuginfo - read and print the stat information for the address @eip,
 * and info.eip_fn_addr should be the first address of the related function.
 * */
void
print_debuginfo(uintptr_t eip) {
  1009ed:	f3 0f 1e fb          	endbr32 
  1009f1:	55                   	push   %ebp
  1009f2:	89 e5                	mov    %esp,%ebp
  1009f4:	81 ec 48 01 00 00    	sub    $0x148,%esp
    struct eipdebuginfo info;
    if (debuginfo_eip(eip, &info) != 0) {
  1009fa:	8d 45 dc             	lea    -0x24(%ebp),%eax
  1009fd:	89 44 24 04          	mov    %eax,0x4(%esp)
  100a01:	8b 45 08             	mov    0x8(%ebp),%eax
  100a04:	89 04 24             	mov    %eax,(%esp)
  100a07:	e8 21 fc ff ff       	call   10062d <debuginfo_eip>
  100a0c:	85 c0                	test   %eax,%eax
  100a0e:	74 15                	je     100a25 <print_debuginfo+0x38>
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
  100a10:	8b 45 08             	mov    0x8(%ebp),%eax
  100a13:	89 44 24 04          	mov    %eax,0x4(%esp)
  100a17:	c7 04 24 a6 3b 10 00 	movl   $0x103ba6,(%esp)
  100a1e:	e8 71 f8 ff ff       	call   100294 <cprintf>
        }
        fnname[j] = '\0';
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
                fnname, eip - info.eip_fn_addr);
    }
}
  100a23:	eb 6c                	jmp    100a91 <print_debuginfo+0xa4>
        for (j = 0; j < info.eip_fn_namelen; j ++) {
  100a25:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  100a2c:	eb 1b                	jmp    100a49 <print_debuginfo+0x5c>
            fnname[j] = info.eip_fn_name[j];
  100a2e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  100a31:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100a34:	01 d0                	add    %edx,%eax
  100a36:	0f b6 10             	movzbl (%eax),%edx
  100a39:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
  100a3f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100a42:	01 c8                	add    %ecx,%eax
  100a44:	88 10                	mov    %dl,(%eax)
        for (j = 0; j < info.eip_fn_namelen; j ++) {
  100a46:	ff 45 f4             	incl   -0xc(%ebp)
  100a49:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100a4c:	39 45 f4             	cmp    %eax,-0xc(%ebp)
  100a4f:	7c dd                	jl     100a2e <print_debuginfo+0x41>
        fnname[j] = '\0';
  100a51:	8d 95 dc fe ff ff    	lea    -0x124(%ebp),%edx
  100a57:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100a5a:	01 d0                	add    %edx,%eax
  100a5c:	c6 00 00             	movb   $0x0,(%eax)
                fnname, eip - info.eip_fn_addr);
  100a5f:	8b 45 ec             	mov    -0x14(%ebp),%eax
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
  100a62:	8b 55 08             	mov    0x8(%ebp),%edx
  100a65:	89 d1                	mov    %edx,%ecx
  100a67:	29 c1                	sub    %eax,%ecx
  100a69:	8b 55 e0             	mov    -0x20(%ebp),%edx
  100a6c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100a6f:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  100a73:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
  100a79:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  100a7d:	89 54 24 08          	mov    %edx,0x8(%esp)
  100a81:	89 44 24 04          	mov    %eax,0x4(%esp)
  100a85:	c7 04 24 c2 3b 10 00 	movl   $0x103bc2,(%esp)
  100a8c:	e8 03 f8 ff ff       	call   100294 <cprintf>
}
  100a91:	90                   	nop
  100a92:	c9                   	leave  
  100a93:	c3                   	ret    

00100a94 <read_eip>:

static __noinline uint32_t
read_eip(void) {
  100a94:	f3 0f 1e fb          	endbr32 
  100a98:	55                   	push   %ebp
  100a99:	89 e5                	mov    %esp,%ebp
  100a9b:	83 ec 10             	sub    $0x10,%esp
    uint32_t eip;
    asm volatile("movl 4(%%ebp), %0" : "=r" (eip));
  100a9e:	8b 45 04             	mov    0x4(%ebp),%eax
  100aa1:	89 45 fc             	mov    %eax,-0x4(%ebp)
    return eip;
  100aa4:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  100aa7:	c9                   	leave  
  100aa8:	c3                   	ret    

00100aa9 <print_stackframe>:
 *
 * Note that, the length of ebp-chain is limited. In boot/bootasm.S, before jumping
 * to the kernel entry, the value of ebp has been set to zero, that's the boundary.
 * */
void
print_stackframe(void) {
  100aa9:	f3 0f 1e fb          	endbr32 
  100aad:	55                   	push   %ebp
  100aae:	89 e5                	mov    %esp,%ebp
  100ab0:	83 ec 38             	sub    $0x38,%esp
}

static inline uint32_t
read_ebp(void) {
    uint32_t ebp;
    asm volatile ("movl %%ebp, %0" : "=r" (ebp));
  100ab3:	89 e8                	mov    %ebp,%eax
  100ab5:	89 45 e0             	mov    %eax,-0x20(%ebp)
    return ebp;
  100ab8:	8b 45 e0             	mov    -0x20(%ebp),%eax
      *           NOTICE: the calling funciton's return addr eip  = ss:[ebp+4]
      *                   the calling funciton's ebp = ss:[ebp]
      */

    // 初始化当前ebp和eip
    uint32_t ebp = read_ebp();
  100abb:	89 45 f4             	mov    %eax,-0xc(%ebp)
    uint32_t eip = read_eip();
  100abe:	e8 d1 ff ff ff       	call   100a94 <read_eip>
  100ac3:	89 45 f0             	mov    %eax,-0x10(%ebp)

    // 定义当前深度
    int depth = 0;
  100ac6:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)

    // 循环，以至打印到设定的最大堆栈深度
    // ebp == 0，代表着没有更深的函数栈帧了
    for (; ebp != 0 && depth < STACKFRAME_DEPTH; depth ++) {
  100acd:	e9 84 00 00 00       	jmp    100b56 <print_stackframe+0xad>
        // 打印第一行，标识出ebp和eip的值
        cprintf("ebp:0x%08x eip:0x%08x args:", ebp, eip);
  100ad2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100ad5:	89 44 24 08          	mov    %eax,0x8(%esp)
  100ad9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100adc:	89 44 24 04          	mov    %eax,0x4(%esp)
  100ae0:	c7 04 24 d4 3b 10 00 	movl   $0x103bd4,(%esp)
  100ae7:	e8 a8 f7 ff ff       	call   100294 <cprintf>
        // 可能的参数存在于ebp底第二个地址
        uint32_t *args = (uint32_t *)ebp + 2;
  100aec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100aef:	83 c0 08             	add    $0x8,%eax
  100af2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        // 默认最多打印四个参数
        for (int j = 0; j < 4; j ++) {
  100af5:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  100afc:	eb 24                	jmp    100b22 <print_stackframe+0x79>
            cprintf("0x%08x ", args[j]);
  100afe:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100b01:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  100b08:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  100b0b:	01 d0                	add    %edx,%eax
  100b0d:	8b 00                	mov    (%eax),%eax
  100b0f:	89 44 24 04          	mov    %eax,0x4(%esp)
  100b13:	c7 04 24 f0 3b 10 00 	movl   $0x103bf0,(%esp)
  100b1a:	e8 75 f7 ff ff       	call   100294 <cprintf>
        for (int j = 0; j < 4; j ++) {
  100b1f:	ff 45 e8             	incl   -0x18(%ebp)
  100b22:	83 7d e8 03          	cmpl   $0x3,-0x18(%ebp)
  100b26:	7e d6                	jle    100afe <print_stackframe+0x55>
        }
        cprintf("\n");
  100b28:	c7 04 24 f8 3b 10 00 	movl   $0x103bf8,(%esp)
  100b2f:	e8 60 f7 ff ff       	call   100294 <cprintf>
        // 能够查找到对应的函数相关信息，包括函数名，所在文件的行号等
        // eip - 1
        print_debuginfo(eip - 1);
  100b34:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100b37:	48                   	dec    %eax
  100b38:	89 04 24             	mov    %eax,(%esp)
  100b3b:	e8 ad fe ff ff       	call   1009ed <print_debuginfo>
        // 将eip赋为栈底的返回地址，edp赋为其存放的地址中的值
        eip = ((uint32_t *)ebp)[1];
  100b40:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100b43:	83 c0 04             	add    $0x4,%eax
  100b46:	8b 00                	mov    (%eax),%eax
  100b48:	89 45 f0             	mov    %eax,-0x10(%ebp)
        ebp = ((uint32_t *)ebp)[0];
  100b4b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100b4e:	8b 00                	mov    (%eax),%eax
  100b50:	89 45 f4             	mov    %eax,-0xc(%ebp)
    for (; ebp != 0 && depth < STACKFRAME_DEPTH; depth ++) {
  100b53:	ff 45 ec             	incl   -0x14(%ebp)
  100b56:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  100b5a:	74 0a                	je     100b66 <print_stackframe+0xbd>
  100b5c:	83 7d ec 13          	cmpl   $0x13,-0x14(%ebp)
  100b60:	0f 8e 6c ff ff ff    	jle    100ad2 <print_stackframe+0x29>
    }
}
  100b66:	90                   	nop
  100b67:	c9                   	leave  
  100b68:	c3                   	ret    

00100b69 <parse>:
#define MAXARGS         16
#define WHITESPACE      " \t\n\r"

/* parse - parse the command buffer into whitespace-separated arguments */
static int
parse(char *buf, char **argv) {
  100b69:	f3 0f 1e fb          	endbr32 
  100b6d:	55                   	push   %ebp
  100b6e:	89 e5                	mov    %esp,%ebp
  100b70:	83 ec 28             	sub    $0x28,%esp
    int argc = 0;
  100b73:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100b7a:	eb 0c                	jmp    100b88 <parse+0x1f>
            *buf ++ = '\0';
  100b7c:	8b 45 08             	mov    0x8(%ebp),%eax
  100b7f:	8d 50 01             	lea    0x1(%eax),%edx
  100b82:	89 55 08             	mov    %edx,0x8(%ebp)
  100b85:	c6 00 00             	movb   $0x0,(%eax)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100b88:	8b 45 08             	mov    0x8(%ebp),%eax
  100b8b:	0f b6 00             	movzbl (%eax),%eax
  100b8e:	84 c0                	test   %al,%al
  100b90:	74 1d                	je     100baf <parse+0x46>
  100b92:	8b 45 08             	mov    0x8(%ebp),%eax
  100b95:	0f b6 00             	movzbl (%eax),%eax
  100b98:	0f be c0             	movsbl %al,%eax
  100b9b:	89 44 24 04          	mov    %eax,0x4(%esp)
  100b9f:	c7 04 24 7c 3c 10 00 	movl   $0x103c7c,(%esp)
  100ba6:	e8 5b 24 00 00       	call   103006 <strchr>
  100bab:	85 c0                	test   %eax,%eax
  100bad:	75 cd                	jne    100b7c <parse+0x13>
        }
        if (*buf == '\0') {
  100baf:	8b 45 08             	mov    0x8(%ebp),%eax
  100bb2:	0f b6 00             	movzbl (%eax),%eax
  100bb5:	84 c0                	test   %al,%al
  100bb7:	74 65                	je     100c1e <parse+0xb5>
            break;
        }

        // save and scan past next arg
        if (argc == MAXARGS - 1) {
  100bb9:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
  100bbd:	75 14                	jne    100bd3 <parse+0x6a>
            cprintf("Too many arguments (max %d).\n", MAXARGS);
  100bbf:	c7 44 24 04 10 00 00 	movl   $0x10,0x4(%esp)
  100bc6:	00 
  100bc7:	c7 04 24 81 3c 10 00 	movl   $0x103c81,(%esp)
  100bce:	e8 c1 f6 ff ff       	call   100294 <cprintf>
        }
        argv[argc ++] = buf;
  100bd3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100bd6:	8d 50 01             	lea    0x1(%eax),%edx
  100bd9:	89 55 f4             	mov    %edx,-0xc(%ebp)
  100bdc:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  100be3:	8b 45 0c             	mov    0xc(%ebp),%eax
  100be6:	01 c2                	add    %eax,%edx
  100be8:	8b 45 08             	mov    0x8(%ebp),%eax
  100beb:	89 02                	mov    %eax,(%edx)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
  100bed:	eb 03                	jmp    100bf2 <parse+0x89>
            buf ++;
  100bef:	ff 45 08             	incl   0x8(%ebp)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
  100bf2:	8b 45 08             	mov    0x8(%ebp),%eax
  100bf5:	0f b6 00             	movzbl (%eax),%eax
  100bf8:	84 c0                	test   %al,%al
  100bfa:	74 8c                	je     100b88 <parse+0x1f>
  100bfc:	8b 45 08             	mov    0x8(%ebp),%eax
  100bff:	0f b6 00             	movzbl (%eax),%eax
  100c02:	0f be c0             	movsbl %al,%eax
  100c05:	89 44 24 04          	mov    %eax,0x4(%esp)
  100c09:	c7 04 24 7c 3c 10 00 	movl   $0x103c7c,(%esp)
  100c10:	e8 f1 23 00 00       	call   103006 <strchr>
  100c15:	85 c0                	test   %eax,%eax
  100c17:	74 d6                	je     100bef <parse+0x86>
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100c19:	e9 6a ff ff ff       	jmp    100b88 <parse+0x1f>
            break;
  100c1e:	90                   	nop
        }
    }
    return argc;
  100c1f:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  100c22:	c9                   	leave  
  100c23:	c3                   	ret    

00100c24 <runcmd>:
/* *
 * runcmd - parse the input string, split it into separated arguments
 * and then lookup and invoke some related commands/
 * */
static int
runcmd(char *buf, struct trapframe *tf) {
  100c24:	f3 0f 1e fb          	endbr32 
  100c28:	55                   	push   %ebp
  100c29:	89 e5                	mov    %esp,%ebp
  100c2b:	53                   	push   %ebx
  100c2c:	83 ec 64             	sub    $0x64,%esp
    char *argv[MAXARGS];
    int argc = parse(buf, argv);
  100c2f:	8d 45 b0             	lea    -0x50(%ebp),%eax
  100c32:	89 44 24 04          	mov    %eax,0x4(%esp)
  100c36:	8b 45 08             	mov    0x8(%ebp),%eax
  100c39:	89 04 24             	mov    %eax,(%esp)
  100c3c:	e8 28 ff ff ff       	call   100b69 <parse>
  100c41:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if (argc == 0) {
  100c44:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  100c48:	75 0a                	jne    100c54 <runcmd+0x30>
        return 0;
  100c4a:	b8 00 00 00 00       	mov    $0x0,%eax
  100c4f:	e9 83 00 00 00       	jmp    100cd7 <runcmd+0xb3>
    }
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100c54:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  100c5b:	eb 5a                	jmp    100cb7 <runcmd+0x93>
        if (strcmp(commands[i].name, argv[0]) == 0) {
  100c5d:	8b 4d b0             	mov    -0x50(%ebp),%ecx
  100c60:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100c63:	89 d0                	mov    %edx,%eax
  100c65:	01 c0                	add    %eax,%eax
  100c67:	01 d0                	add    %edx,%eax
  100c69:	c1 e0 02             	shl    $0x2,%eax
  100c6c:	05 00 00 11 00       	add    $0x110000,%eax
  100c71:	8b 00                	mov    (%eax),%eax
  100c73:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  100c77:	89 04 24             	mov    %eax,(%esp)
  100c7a:	e8 e3 22 00 00       	call   102f62 <strcmp>
  100c7f:	85 c0                	test   %eax,%eax
  100c81:	75 31                	jne    100cb4 <runcmd+0x90>
            return commands[i].func(argc - 1, argv + 1, tf);
  100c83:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100c86:	89 d0                	mov    %edx,%eax
  100c88:	01 c0                	add    %eax,%eax
  100c8a:	01 d0                	add    %edx,%eax
  100c8c:	c1 e0 02             	shl    $0x2,%eax
  100c8f:	05 08 00 11 00       	add    $0x110008,%eax
  100c94:	8b 10                	mov    (%eax),%edx
  100c96:	8d 45 b0             	lea    -0x50(%ebp),%eax
  100c99:	83 c0 04             	add    $0x4,%eax
  100c9c:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  100c9f:	8d 59 ff             	lea    -0x1(%ecx),%ebx
  100ca2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  100ca5:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  100ca9:	89 44 24 04          	mov    %eax,0x4(%esp)
  100cad:	89 1c 24             	mov    %ebx,(%esp)
  100cb0:	ff d2                	call   *%edx
  100cb2:	eb 23                	jmp    100cd7 <runcmd+0xb3>
    for (i = 0; i < NCOMMANDS; i ++) {
  100cb4:	ff 45 f4             	incl   -0xc(%ebp)
  100cb7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100cba:	83 f8 02             	cmp    $0x2,%eax
  100cbd:	76 9e                	jbe    100c5d <runcmd+0x39>
        }
    }
    cprintf("Unknown command '%s'\n", argv[0]);
  100cbf:	8b 45 b0             	mov    -0x50(%ebp),%eax
  100cc2:	89 44 24 04          	mov    %eax,0x4(%esp)
  100cc6:	c7 04 24 9f 3c 10 00 	movl   $0x103c9f,(%esp)
  100ccd:	e8 c2 f5 ff ff       	call   100294 <cprintf>
    return 0;
  100cd2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100cd7:	83 c4 64             	add    $0x64,%esp
  100cda:	5b                   	pop    %ebx
  100cdb:	5d                   	pop    %ebp
  100cdc:	c3                   	ret    

00100cdd <kmonitor>:

/***** Implementations of basic kernel monitor commands *****/

void
kmonitor(struct trapframe *tf) {
  100cdd:	f3 0f 1e fb          	endbr32 
  100ce1:	55                   	push   %ebp
  100ce2:	89 e5                	mov    %esp,%ebp
  100ce4:	83 ec 28             	sub    $0x28,%esp
    cprintf("Welcome to the kernel debug monitor!!\n");
  100ce7:	c7 04 24 b8 3c 10 00 	movl   $0x103cb8,(%esp)
  100cee:	e8 a1 f5 ff ff       	call   100294 <cprintf>
    cprintf("Type 'help' for a list of commands.\n");
  100cf3:	c7 04 24 e0 3c 10 00 	movl   $0x103ce0,(%esp)
  100cfa:	e8 95 f5 ff ff       	call   100294 <cprintf>

    if (tf != NULL) {
  100cff:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  100d03:	74 0b                	je     100d10 <kmonitor+0x33>
        print_trapframe(tf);
  100d05:	8b 45 08             	mov    0x8(%ebp),%eax
  100d08:	89 04 24             	mov    %eax,(%esp)
  100d0b:	e8 75 0e 00 00       	call   101b85 <print_trapframe>
    }

    char *buf;
    while (1) {
        if ((buf = readline("K> ")) != NULL) {
  100d10:	c7 04 24 05 3d 10 00 	movl   $0x103d05,(%esp)
  100d17:	e8 2b f6 ff ff       	call   100347 <readline>
  100d1c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  100d1f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  100d23:	74 eb                	je     100d10 <kmonitor+0x33>
            if (runcmd(buf, tf) < 0) {
  100d25:	8b 45 08             	mov    0x8(%ebp),%eax
  100d28:	89 44 24 04          	mov    %eax,0x4(%esp)
  100d2c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100d2f:	89 04 24             	mov    %eax,(%esp)
  100d32:	e8 ed fe ff ff       	call   100c24 <runcmd>
  100d37:	85 c0                	test   %eax,%eax
  100d39:	78 02                	js     100d3d <kmonitor+0x60>
        if ((buf = readline("K> ")) != NULL) {
  100d3b:	eb d3                	jmp    100d10 <kmonitor+0x33>
                break;
  100d3d:	90                   	nop
            }
        }
    }
}
  100d3e:	90                   	nop
  100d3f:	c9                   	leave  
  100d40:	c3                   	ret    

00100d41 <mon_help>:

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
  100d41:	f3 0f 1e fb          	endbr32 
  100d45:	55                   	push   %ebp
  100d46:	89 e5                	mov    %esp,%ebp
  100d48:	83 ec 28             	sub    $0x28,%esp
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100d4b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  100d52:	eb 3d                	jmp    100d91 <mon_help+0x50>
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
  100d54:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100d57:	89 d0                	mov    %edx,%eax
  100d59:	01 c0                	add    %eax,%eax
  100d5b:	01 d0                	add    %edx,%eax
  100d5d:	c1 e0 02             	shl    $0x2,%eax
  100d60:	05 04 00 11 00       	add    $0x110004,%eax
  100d65:	8b 08                	mov    (%eax),%ecx
  100d67:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100d6a:	89 d0                	mov    %edx,%eax
  100d6c:	01 c0                	add    %eax,%eax
  100d6e:	01 d0                	add    %edx,%eax
  100d70:	c1 e0 02             	shl    $0x2,%eax
  100d73:	05 00 00 11 00       	add    $0x110000,%eax
  100d78:	8b 00                	mov    (%eax),%eax
  100d7a:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  100d7e:	89 44 24 04          	mov    %eax,0x4(%esp)
  100d82:	c7 04 24 09 3d 10 00 	movl   $0x103d09,(%esp)
  100d89:	e8 06 f5 ff ff       	call   100294 <cprintf>
    for (i = 0; i < NCOMMANDS; i ++) {
  100d8e:	ff 45 f4             	incl   -0xc(%ebp)
  100d91:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100d94:	83 f8 02             	cmp    $0x2,%eax
  100d97:	76 bb                	jbe    100d54 <mon_help+0x13>
    }
    return 0;
  100d99:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100d9e:	c9                   	leave  
  100d9f:	c3                   	ret    

00100da0 <mon_kerninfo>:
/* *
 * mon_kerninfo - call print_kerninfo in kern/debug/kdebug.c to
 * print the memory occupancy in kernel.
 * */
int
mon_kerninfo(int argc, char **argv, struct trapframe *tf) {
  100da0:	f3 0f 1e fb          	endbr32 
  100da4:	55                   	push   %ebp
  100da5:	89 e5                	mov    %esp,%ebp
  100da7:	83 ec 08             	sub    $0x8,%esp
    print_kerninfo();
  100daa:	e8 a8 fb ff ff       	call   100957 <print_kerninfo>
    return 0;
  100daf:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100db4:	c9                   	leave  
  100db5:	c3                   	ret    

00100db6 <mon_backtrace>:
/* *
 * mon_backtrace - call print_stackframe in kern/debug/kdebug.c to
 * print a backtrace of the stack.
 * */
int
mon_backtrace(int argc, char **argv, struct trapframe *tf) {
  100db6:	f3 0f 1e fb          	endbr32 
  100dba:	55                   	push   %ebp
  100dbb:	89 e5                	mov    %esp,%ebp
  100dbd:	83 ec 08             	sub    $0x8,%esp
    print_stackframe();
  100dc0:	e8 e4 fc ff ff       	call   100aa9 <print_stackframe>
    return 0;
  100dc5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100dca:	c9                   	leave  
  100dcb:	c3                   	ret    

00100dcc <clock_init>:
/* *
 * clock_init - initialize 8253 clock to interrupt 100 times per second,
 * and then enable IRQ_TIMER.
 * */
void
clock_init(void) {
  100dcc:	f3 0f 1e fb          	endbr32 
  100dd0:	55                   	push   %ebp
  100dd1:	89 e5                	mov    %esp,%ebp
  100dd3:	83 ec 28             	sub    $0x28,%esp
  100dd6:	66 c7 45 ee 43 00    	movw   $0x43,-0x12(%ebp)
  100ddc:	c6 45 ed 34          	movb   $0x34,-0x13(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100de0:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  100de4:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  100de8:	ee                   	out    %al,(%dx)
}
  100de9:	90                   	nop
  100dea:	66 c7 45 f2 40 00    	movw   $0x40,-0xe(%ebp)
  100df0:	c6 45 f1 9c          	movb   $0x9c,-0xf(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100df4:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  100df8:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  100dfc:	ee                   	out    %al,(%dx)
}
  100dfd:	90                   	nop
  100dfe:	66 c7 45 f6 40 00    	movw   $0x40,-0xa(%ebp)
  100e04:	c6 45 f5 2e          	movb   $0x2e,-0xb(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100e08:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  100e0c:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  100e10:	ee                   	out    %al,(%dx)
}
  100e11:	90                   	nop
    outb(TIMER_MODE, TIMER_SEL0 | TIMER_RATEGEN | TIMER_16BIT);
    outb(IO_TIMER1, TIMER_DIV(100) % 256);
    outb(IO_TIMER1, TIMER_DIV(100) / 256);

    // initialize time counter 'ticks' to zero
    ticks = 0;
  100e12:	c7 05 08 19 11 00 00 	movl   $0x0,0x111908
  100e19:	00 00 00 

    cprintf("++ setup timer interrupts\n");
  100e1c:	c7 04 24 12 3d 10 00 	movl   $0x103d12,(%esp)
  100e23:	e8 6c f4 ff ff       	call   100294 <cprintf>
    pic_enable(IRQ_TIMER);
  100e28:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  100e2f:	e8 31 09 00 00       	call   101765 <pic_enable>
}
  100e34:	90                   	nop
  100e35:	c9                   	leave  
  100e36:	c3                   	ret    

00100e37 <delay>:
#include <picirq.h>
#include <trap.h>

/* stupid I/O delay routine necessitated by historical PC design flaws */
static void
delay(void) {
  100e37:	f3 0f 1e fb          	endbr32 
  100e3b:	55                   	push   %ebp
  100e3c:	89 e5                	mov    %esp,%ebp
  100e3e:	83 ec 10             	sub    $0x10,%esp
  100e41:	66 c7 45 f2 84 00    	movw   $0x84,-0xe(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  100e47:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  100e4b:	89 c2                	mov    %eax,%edx
  100e4d:	ec                   	in     (%dx),%al
  100e4e:	88 45 f1             	mov    %al,-0xf(%ebp)
  100e51:	66 c7 45 f6 84 00    	movw   $0x84,-0xa(%ebp)
  100e57:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  100e5b:	89 c2                	mov    %eax,%edx
  100e5d:	ec                   	in     (%dx),%al
  100e5e:	88 45 f5             	mov    %al,-0xb(%ebp)
  100e61:	66 c7 45 fa 84 00    	movw   $0x84,-0x6(%ebp)
  100e67:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  100e6b:	89 c2                	mov    %eax,%edx
  100e6d:	ec                   	in     (%dx),%al
  100e6e:	88 45 f9             	mov    %al,-0x7(%ebp)
  100e71:	66 c7 45 fe 84 00    	movw   $0x84,-0x2(%ebp)
  100e77:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
  100e7b:	89 c2                	mov    %eax,%edx
  100e7d:	ec                   	in     (%dx),%al
  100e7e:	88 45 fd             	mov    %al,-0x3(%ebp)
    inb(0x84);
    inb(0x84);
    inb(0x84);
    inb(0x84);
}
  100e81:	90                   	nop
  100e82:	c9                   	leave  
  100e83:	c3                   	ret    

00100e84 <cga_init>:
//    -- 数据寄存器 映射 到 端口 0x3D5或0x3B5 
//    -- 索引寄存器 0x3D4或0x3B4,决定在数据寄存器中的数据表示什么。

/* TEXT-mode CGA/VGA display output */
static void
cga_init(void) {
  100e84:	f3 0f 1e fb          	endbr32 
  100e88:	55                   	push   %ebp
  100e89:	89 e5                	mov    %esp,%ebp
  100e8b:	83 ec 20             	sub    $0x20,%esp
    volatile uint16_t *cp = (uint16_t *)CGA_BUF;   //CGA_BUF: 0xB8000 (彩色显示的显存物理基址)
  100e8e:	c7 45 fc 00 80 0b 00 	movl   $0xb8000,-0x4(%ebp)
    uint16_t was = *cp;                                            //保存当前显存0xB8000处的值
  100e95:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100e98:	0f b7 00             	movzwl (%eax),%eax
  100e9b:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
    *cp = (uint16_t) 0xA55A;                                   // 给这个地址随便写个值，看看能否再读出同样的值
  100e9f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100ea2:	66 c7 00 5a a5       	movw   $0xa55a,(%eax)
    if (*cp != 0xA55A) {                                            // 如果读不出来，说明没有这块显存，即是单显配置
  100ea7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100eaa:	0f b7 00             	movzwl (%eax),%eax
  100ead:	0f b7 c0             	movzwl %ax,%eax
  100eb0:	3d 5a a5 00 00       	cmp    $0xa55a,%eax
  100eb5:	74 12                	je     100ec9 <cga_init+0x45>
        cp = (uint16_t*)MONO_BUF;                         //设置为单显的显存基址 MONO_BUF： 0xB0000
  100eb7:	c7 45 fc 00 00 0b 00 	movl   $0xb0000,-0x4(%ebp)
        addr_6845 = MONO_BASE;                           //设置为单显控制的IO地址，MONO_BASE: 0x3B4
  100ebe:	66 c7 05 66 0e 11 00 	movw   $0x3b4,0x110e66
  100ec5:	b4 03 
  100ec7:	eb 13                	jmp    100edc <cga_init+0x58>
    } else {                                                                // 如果读出来了，有这块显存，即是彩显配置
        *cp = was;                                                      //还原原来显存位置的值
  100ec9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100ecc:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  100ed0:	66 89 10             	mov    %dx,(%eax)
        addr_6845 = CGA_BASE;                               // 设置为彩显控制的IO地址，CGA_BASE: 0x3D4 
  100ed3:	66 c7 05 66 0e 11 00 	movw   $0x3d4,0x110e66
  100eda:	d4 03 
    // Extract cursor location
    // 6845索引寄存器的index 0x0E（及十进制的14）== 光标位置(高位)
    // 6845索引寄存器的index 0x0F（及十进制的15）== 光标位置(低位)
    // 6845 reg 15 : Cursor Address (Low Byte)
    uint32_t pos;
    outb(addr_6845, 14);                                        
  100edc:	0f b7 05 66 0e 11 00 	movzwl 0x110e66,%eax
  100ee3:	66 89 45 e6          	mov    %ax,-0x1a(%ebp)
  100ee7:	c6 45 e5 0e          	movb   $0xe,-0x1b(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100eeb:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  100eef:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  100ef3:	ee                   	out    %al,(%dx)
}
  100ef4:	90                   	nop
    pos = inb(addr_6845 + 1) << 8;                       //读出了光标位置(高位)
  100ef5:	0f b7 05 66 0e 11 00 	movzwl 0x110e66,%eax
  100efc:	40                   	inc    %eax
  100efd:	0f b7 c0             	movzwl %ax,%eax
  100f00:	66 89 45 ea          	mov    %ax,-0x16(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  100f04:	0f b7 45 ea          	movzwl -0x16(%ebp),%eax
  100f08:	89 c2                	mov    %eax,%edx
  100f0a:	ec                   	in     (%dx),%al
  100f0b:	88 45 e9             	mov    %al,-0x17(%ebp)
    return data;
  100f0e:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  100f12:	0f b6 c0             	movzbl %al,%eax
  100f15:	c1 e0 08             	shl    $0x8,%eax
  100f18:	89 45 f4             	mov    %eax,-0xc(%ebp)
    outb(addr_6845, 15);
  100f1b:	0f b7 05 66 0e 11 00 	movzwl 0x110e66,%eax
  100f22:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
  100f26:	c6 45 ed 0f          	movb   $0xf,-0x13(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100f2a:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  100f2e:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  100f32:	ee                   	out    %al,(%dx)
}
  100f33:	90                   	nop
    pos |= inb(addr_6845 + 1);                             //读出了光标位置(低位)
  100f34:	0f b7 05 66 0e 11 00 	movzwl 0x110e66,%eax
  100f3b:	40                   	inc    %eax
  100f3c:	0f b7 c0             	movzwl %ax,%eax
  100f3f:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  100f43:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  100f47:	89 c2                	mov    %eax,%edx
  100f49:	ec                   	in     (%dx),%al
  100f4a:	88 45 f1             	mov    %al,-0xf(%ebp)
    return data;
  100f4d:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  100f51:	0f b6 c0             	movzbl %al,%eax
  100f54:	09 45 f4             	or     %eax,-0xc(%ebp)

    crt_buf = (uint16_t*) cp;                                  //crt_buf是CGA显存起始地址
  100f57:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100f5a:	a3 60 0e 11 00       	mov    %eax,0x110e60
    crt_pos = pos;                                                  //crt_pos是CGA当前光标位置
  100f5f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100f62:	0f b7 c0             	movzwl %ax,%eax
  100f65:	66 a3 64 0e 11 00    	mov    %ax,0x110e64
}
  100f6b:	90                   	nop
  100f6c:	c9                   	leave  
  100f6d:	c3                   	ret    

00100f6e <serial_init>:

static bool serial_exists = 0;

static void
serial_init(void) {
  100f6e:	f3 0f 1e fb          	endbr32 
  100f72:	55                   	push   %ebp
  100f73:	89 e5                	mov    %esp,%ebp
  100f75:	83 ec 48             	sub    $0x48,%esp
  100f78:	66 c7 45 d2 fa 03    	movw   $0x3fa,-0x2e(%ebp)
  100f7e:	c6 45 d1 00          	movb   $0x0,-0x2f(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100f82:	0f b6 45 d1          	movzbl -0x2f(%ebp),%eax
  100f86:	0f b7 55 d2          	movzwl -0x2e(%ebp),%edx
  100f8a:	ee                   	out    %al,(%dx)
}
  100f8b:	90                   	nop
  100f8c:	66 c7 45 d6 fb 03    	movw   $0x3fb,-0x2a(%ebp)
  100f92:	c6 45 d5 80          	movb   $0x80,-0x2b(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100f96:	0f b6 45 d5          	movzbl -0x2b(%ebp),%eax
  100f9a:	0f b7 55 d6          	movzwl -0x2a(%ebp),%edx
  100f9e:	ee                   	out    %al,(%dx)
}
  100f9f:	90                   	nop
  100fa0:	66 c7 45 da f8 03    	movw   $0x3f8,-0x26(%ebp)
  100fa6:	c6 45 d9 0c          	movb   $0xc,-0x27(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100faa:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
  100fae:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
  100fb2:	ee                   	out    %al,(%dx)
}
  100fb3:	90                   	nop
  100fb4:	66 c7 45 de f9 03    	movw   $0x3f9,-0x22(%ebp)
  100fba:	c6 45 dd 00          	movb   $0x0,-0x23(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100fbe:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
  100fc2:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
  100fc6:	ee                   	out    %al,(%dx)
}
  100fc7:	90                   	nop
  100fc8:	66 c7 45 e2 fb 03    	movw   $0x3fb,-0x1e(%ebp)
  100fce:	c6 45 e1 03          	movb   $0x3,-0x1f(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100fd2:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
  100fd6:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
  100fda:	ee                   	out    %al,(%dx)
}
  100fdb:	90                   	nop
  100fdc:	66 c7 45 e6 fc 03    	movw   $0x3fc,-0x1a(%ebp)
  100fe2:	c6 45 e5 00          	movb   $0x0,-0x1b(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100fe6:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  100fea:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  100fee:	ee                   	out    %al,(%dx)
}
  100fef:	90                   	nop
  100ff0:	66 c7 45 ea f9 03    	movw   $0x3f9,-0x16(%ebp)
  100ff6:	c6 45 e9 01          	movb   $0x1,-0x17(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100ffa:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  100ffe:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  101002:	ee                   	out    %al,(%dx)
}
  101003:	90                   	nop
  101004:	66 c7 45 ee fd 03    	movw   $0x3fd,-0x12(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  10100a:	0f b7 45 ee          	movzwl -0x12(%ebp),%eax
  10100e:	89 c2                	mov    %eax,%edx
  101010:	ec                   	in     (%dx),%al
  101011:	88 45 ed             	mov    %al,-0x13(%ebp)
    return data;
  101014:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
    // Enable rcv interrupts
    outb(COM1 + COM_IER, COM_IER_RDI);

    // Clear any preexisting overrun indications and interrupts
    // Serial port doesn't exist if COM_LSR returns 0xFF
    serial_exists = (inb(COM1 + COM_LSR) != 0xFF);
  101018:	3c ff                	cmp    $0xff,%al
  10101a:	0f 95 c0             	setne  %al
  10101d:	0f b6 c0             	movzbl %al,%eax
  101020:	a3 68 0e 11 00       	mov    %eax,0x110e68
  101025:	66 c7 45 f2 fa 03    	movw   $0x3fa,-0xe(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  10102b:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  10102f:	89 c2                	mov    %eax,%edx
  101031:	ec                   	in     (%dx),%al
  101032:	88 45 f1             	mov    %al,-0xf(%ebp)
  101035:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
  10103b:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  10103f:	89 c2                	mov    %eax,%edx
  101041:	ec                   	in     (%dx),%al
  101042:	88 45 f5             	mov    %al,-0xb(%ebp)
    (void) inb(COM1+COM_IIR);
    (void) inb(COM1+COM_RX);

    if (serial_exists) {
  101045:	a1 68 0e 11 00       	mov    0x110e68,%eax
  10104a:	85 c0                	test   %eax,%eax
  10104c:	74 0c                	je     10105a <serial_init+0xec>
        pic_enable(IRQ_COM1);
  10104e:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
  101055:	e8 0b 07 00 00       	call   101765 <pic_enable>
    }
}
  10105a:	90                   	nop
  10105b:	c9                   	leave  
  10105c:	c3                   	ret    

0010105d <lpt_putc_sub>:

static void
lpt_putc_sub(int c) {
  10105d:	f3 0f 1e fb          	endbr32 
  101061:	55                   	push   %ebp
  101062:	89 e5                	mov    %esp,%ebp
  101064:	83 ec 20             	sub    $0x20,%esp
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
  101067:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  10106e:	eb 08                	jmp    101078 <lpt_putc_sub+0x1b>
        delay();
  101070:	e8 c2 fd ff ff       	call   100e37 <delay>
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
  101075:	ff 45 fc             	incl   -0x4(%ebp)
  101078:	66 c7 45 fa 79 03    	movw   $0x379,-0x6(%ebp)
  10107e:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  101082:	89 c2                	mov    %eax,%edx
  101084:	ec                   	in     (%dx),%al
  101085:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
  101088:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  10108c:	84 c0                	test   %al,%al
  10108e:	78 09                	js     101099 <lpt_putc_sub+0x3c>
  101090:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
  101097:	7e d7                	jle    101070 <lpt_putc_sub+0x13>
    }
    outb(LPTPORT + 0, c);
  101099:	8b 45 08             	mov    0x8(%ebp),%eax
  10109c:	0f b6 c0             	movzbl %al,%eax
  10109f:	66 c7 45 ee 78 03    	movw   $0x378,-0x12(%ebp)
  1010a5:	88 45 ed             	mov    %al,-0x13(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  1010a8:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  1010ac:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  1010b0:	ee                   	out    %al,(%dx)
}
  1010b1:	90                   	nop
  1010b2:	66 c7 45 f2 7a 03    	movw   $0x37a,-0xe(%ebp)
  1010b8:	c6 45 f1 0d          	movb   $0xd,-0xf(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  1010bc:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  1010c0:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  1010c4:	ee                   	out    %al,(%dx)
}
  1010c5:	90                   	nop
  1010c6:	66 c7 45 f6 7a 03    	movw   $0x37a,-0xa(%ebp)
  1010cc:	c6 45 f5 08          	movb   $0x8,-0xb(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  1010d0:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  1010d4:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  1010d8:	ee                   	out    %al,(%dx)
}
  1010d9:	90                   	nop
    outb(LPTPORT + 2, 0x08 | 0x04 | 0x01);
    outb(LPTPORT + 2, 0x08);
}
  1010da:	90                   	nop
  1010db:	c9                   	leave  
  1010dc:	c3                   	ret    

001010dd <lpt_putc>:

/* lpt_putc - copy console output to parallel port */
static void
lpt_putc(int c) {
  1010dd:	f3 0f 1e fb          	endbr32 
  1010e1:	55                   	push   %ebp
  1010e2:	89 e5                	mov    %esp,%ebp
  1010e4:	83 ec 04             	sub    $0x4,%esp
    if (c != '\b') {
  1010e7:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
  1010eb:	74 0d                	je     1010fa <lpt_putc+0x1d>
        lpt_putc_sub(c);
  1010ed:	8b 45 08             	mov    0x8(%ebp),%eax
  1010f0:	89 04 24             	mov    %eax,(%esp)
  1010f3:	e8 65 ff ff ff       	call   10105d <lpt_putc_sub>
    else {
        lpt_putc_sub('\b');
        lpt_putc_sub(' ');
        lpt_putc_sub('\b');
    }
}
  1010f8:	eb 24                	jmp    10111e <lpt_putc+0x41>
        lpt_putc_sub('\b');
  1010fa:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  101101:	e8 57 ff ff ff       	call   10105d <lpt_putc_sub>
        lpt_putc_sub(' ');
  101106:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  10110d:	e8 4b ff ff ff       	call   10105d <lpt_putc_sub>
        lpt_putc_sub('\b');
  101112:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  101119:	e8 3f ff ff ff       	call   10105d <lpt_putc_sub>
}
  10111e:	90                   	nop
  10111f:	c9                   	leave  
  101120:	c3                   	ret    

00101121 <cga_putc>:

/* cga_putc - print character to console */
static void
cga_putc(int c) {
  101121:	f3 0f 1e fb          	endbr32 
  101125:	55                   	push   %ebp
  101126:	89 e5                	mov    %esp,%ebp
  101128:	53                   	push   %ebx
  101129:	83 ec 34             	sub    $0x34,%esp
    // set black on white
    if (!(c & ~0xFF)) {
  10112c:	8b 45 08             	mov    0x8(%ebp),%eax
  10112f:	25 00 ff ff ff       	and    $0xffffff00,%eax
  101134:	85 c0                	test   %eax,%eax
  101136:	75 07                	jne    10113f <cga_putc+0x1e>
        c |= 0x0700;
  101138:	81 4d 08 00 07 00 00 	orl    $0x700,0x8(%ebp)
    }

    switch (c & 0xff) {
  10113f:	8b 45 08             	mov    0x8(%ebp),%eax
  101142:	0f b6 c0             	movzbl %al,%eax
  101145:	83 f8 0d             	cmp    $0xd,%eax
  101148:	74 72                	je     1011bc <cga_putc+0x9b>
  10114a:	83 f8 0d             	cmp    $0xd,%eax
  10114d:	0f 8f a3 00 00 00    	jg     1011f6 <cga_putc+0xd5>
  101153:	83 f8 08             	cmp    $0x8,%eax
  101156:	74 0a                	je     101162 <cga_putc+0x41>
  101158:	83 f8 0a             	cmp    $0xa,%eax
  10115b:	74 4c                	je     1011a9 <cga_putc+0x88>
  10115d:	e9 94 00 00 00       	jmp    1011f6 <cga_putc+0xd5>
    case '\b':
        if (crt_pos > 0) {
  101162:	0f b7 05 64 0e 11 00 	movzwl 0x110e64,%eax
  101169:	85 c0                	test   %eax,%eax
  10116b:	0f 84 af 00 00 00    	je     101220 <cga_putc+0xff>
            crt_pos --;
  101171:	0f b7 05 64 0e 11 00 	movzwl 0x110e64,%eax
  101178:	48                   	dec    %eax
  101179:	0f b7 c0             	movzwl %ax,%eax
  10117c:	66 a3 64 0e 11 00    	mov    %ax,0x110e64
            crt_buf[crt_pos] = (c & ~0xff) | ' ';
  101182:	8b 45 08             	mov    0x8(%ebp),%eax
  101185:	98                   	cwtl   
  101186:	25 00 ff ff ff       	and    $0xffffff00,%eax
  10118b:	98                   	cwtl   
  10118c:	83 c8 20             	or     $0x20,%eax
  10118f:	98                   	cwtl   
  101190:	8b 15 60 0e 11 00    	mov    0x110e60,%edx
  101196:	0f b7 0d 64 0e 11 00 	movzwl 0x110e64,%ecx
  10119d:	01 c9                	add    %ecx,%ecx
  10119f:	01 ca                	add    %ecx,%edx
  1011a1:	0f b7 c0             	movzwl %ax,%eax
  1011a4:	66 89 02             	mov    %ax,(%edx)
        }
        break;
  1011a7:	eb 77                	jmp    101220 <cga_putc+0xff>
    case '\n':
        crt_pos += CRT_COLS;
  1011a9:	0f b7 05 64 0e 11 00 	movzwl 0x110e64,%eax
  1011b0:	83 c0 50             	add    $0x50,%eax
  1011b3:	0f b7 c0             	movzwl %ax,%eax
  1011b6:	66 a3 64 0e 11 00    	mov    %ax,0x110e64
    case '\r':
        crt_pos -= (crt_pos % CRT_COLS);
  1011bc:	0f b7 1d 64 0e 11 00 	movzwl 0x110e64,%ebx
  1011c3:	0f b7 0d 64 0e 11 00 	movzwl 0x110e64,%ecx
  1011ca:	ba cd cc cc cc       	mov    $0xcccccccd,%edx
  1011cf:	89 c8                	mov    %ecx,%eax
  1011d1:	f7 e2                	mul    %edx
  1011d3:	c1 ea 06             	shr    $0x6,%edx
  1011d6:	89 d0                	mov    %edx,%eax
  1011d8:	c1 e0 02             	shl    $0x2,%eax
  1011db:	01 d0                	add    %edx,%eax
  1011dd:	c1 e0 04             	shl    $0x4,%eax
  1011e0:	29 c1                	sub    %eax,%ecx
  1011e2:	89 c8                	mov    %ecx,%eax
  1011e4:	0f b7 c0             	movzwl %ax,%eax
  1011e7:	29 c3                	sub    %eax,%ebx
  1011e9:	89 d8                	mov    %ebx,%eax
  1011eb:	0f b7 c0             	movzwl %ax,%eax
  1011ee:	66 a3 64 0e 11 00    	mov    %ax,0x110e64
        break;
  1011f4:	eb 2b                	jmp    101221 <cga_putc+0x100>
    default:
        crt_buf[crt_pos ++] = c;     // write the character
  1011f6:	8b 0d 60 0e 11 00    	mov    0x110e60,%ecx
  1011fc:	0f b7 05 64 0e 11 00 	movzwl 0x110e64,%eax
  101203:	8d 50 01             	lea    0x1(%eax),%edx
  101206:	0f b7 d2             	movzwl %dx,%edx
  101209:	66 89 15 64 0e 11 00 	mov    %dx,0x110e64
  101210:	01 c0                	add    %eax,%eax
  101212:	8d 14 01             	lea    (%ecx,%eax,1),%edx
  101215:	8b 45 08             	mov    0x8(%ebp),%eax
  101218:	0f b7 c0             	movzwl %ax,%eax
  10121b:	66 89 02             	mov    %ax,(%edx)
        break;
  10121e:	eb 01                	jmp    101221 <cga_putc+0x100>
        break;
  101220:	90                   	nop
    }

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
  101221:	0f b7 05 64 0e 11 00 	movzwl 0x110e64,%eax
  101228:	3d cf 07 00 00       	cmp    $0x7cf,%eax
  10122d:	76 5d                	jbe    10128c <cga_putc+0x16b>
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
  10122f:	a1 60 0e 11 00       	mov    0x110e60,%eax
  101234:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
  10123a:	a1 60 0e 11 00       	mov    0x110e60,%eax
  10123f:	c7 44 24 08 00 0f 00 	movl   $0xf00,0x8(%esp)
  101246:	00 
  101247:	89 54 24 04          	mov    %edx,0x4(%esp)
  10124b:	89 04 24             	mov    %eax,(%esp)
  10124e:	e8 b8 1f 00 00       	call   10320b <memmove>
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
  101253:	c7 45 f4 80 07 00 00 	movl   $0x780,-0xc(%ebp)
  10125a:	eb 14                	jmp    101270 <cga_putc+0x14f>
            crt_buf[i] = 0x0700 | ' ';
  10125c:	a1 60 0e 11 00       	mov    0x110e60,%eax
  101261:	8b 55 f4             	mov    -0xc(%ebp),%edx
  101264:	01 d2                	add    %edx,%edx
  101266:	01 d0                	add    %edx,%eax
  101268:	66 c7 00 20 07       	movw   $0x720,(%eax)
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
  10126d:	ff 45 f4             	incl   -0xc(%ebp)
  101270:	81 7d f4 cf 07 00 00 	cmpl   $0x7cf,-0xc(%ebp)
  101277:	7e e3                	jle    10125c <cga_putc+0x13b>
        }
        crt_pos -= CRT_COLS;
  101279:	0f b7 05 64 0e 11 00 	movzwl 0x110e64,%eax
  101280:	83 e8 50             	sub    $0x50,%eax
  101283:	0f b7 c0             	movzwl %ax,%eax
  101286:	66 a3 64 0e 11 00    	mov    %ax,0x110e64
    }

    // move that little blinky thing
    outb(addr_6845, 14);
  10128c:	0f b7 05 66 0e 11 00 	movzwl 0x110e66,%eax
  101293:	66 89 45 e6          	mov    %ax,-0x1a(%ebp)
  101297:	c6 45 e5 0e          	movb   $0xe,-0x1b(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  10129b:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  10129f:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  1012a3:	ee                   	out    %al,(%dx)
}
  1012a4:	90                   	nop
    outb(addr_6845 + 1, crt_pos >> 8);
  1012a5:	0f b7 05 64 0e 11 00 	movzwl 0x110e64,%eax
  1012ac:	c1 e8 08             	shr    $0x8,%eax
  1012af:	0f b7 c0             	movzwl %ax,%eax
  1012b2:	0f b6 c0             	movzbl %al,%eax
  1012b5:	0f b7 15 66 0e 11 00 	movzwl 0x110e66,%edx
  1012bc:	42                   	inc    %edx
  1012bd:	0f b7 d2             	movzwl %dx,%edx
  1012c0:	66 89 55 ea          	mov    %dx,-0x16(%ebp)
  1012c4:	88 45 e9             	mov    %al,-0x17(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  1012c7:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  1012cb:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  1012cf:	ee                   	out    %al,(%dx)
}
  1012d0:	90                   	nop
    outb(addr_6845, 15);
  1012d1:	0f b7 05 66 0e 11 00 	movzwl 0x110e66,%eax
  1012d8:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
  1012dc:	c6 45 ed 0f          	movb   $0xf,-0x13(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  1012e0:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  1012e4:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  1012e8:	ee                   	out    %al,(%dx)
}
  1012e9:	90                   	nop
    outb(addr_6845 + 1, crt_pos);
  1012ea:	0f b7 05 64 0e 11 00 	movzwl 0x110e64,%eax
  1012f1:	0f b6 c0             	movzbl %al,%eax
  1012f4:	0f b7 15 66 0e 11 00 	movzwl 0x110e66,%edx
  1012fb:	42                   	inc    %edx
  1012fc:	0f b7 d2             	movzwl %dx,%edx
  1012ff:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
  101303:	88 45 f1             	mov    %al,-0xf(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  101306:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  10130a:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  10130e:	ee                   	out    %al,(%dx)
}
  10130f:	90                   	nop
}
  101310:	90                   	nop
  101311:	83 c4 34             	add    $0x34,%esp
  101314:	5b                   	pop    %ebx
  101315:	5d                   	pop    %ebp
  101316:	c3                   	ret    

00101317 <serial_putc_sub>:

static void
serial_putc_sub(int c) {
  101317:	f3 0f 1e fb          	endbr32 
  10131b:	55                   	push   %ebp
  10131c:	89 e5                	mov    %esp,%ebp
  10131e:	83 ec 10             	sub    $0x10,%esp
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
  101321:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  101328:	eb 08                	jmp    101332 <serial_putc_sub+0x1b>
        delay();
  10132a:	e8 08 fb ff ff       	call   100e37 <delay>
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
  10132f:	ff 45 fc             	incl   -0x4(%ebp)
  101332:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  101338:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  10133c:	89 c2                	mov    %eax,%edx
  10133e:	ec                   	in     (%dx),%al
  10133f:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
  101342:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  101346:	0f b6 c0             	movzbl %al,%eax
  101349:	83 e0 20             	and    $0x20,%eax
  10134c:	85 c0                	test   %eax,%eax
  10134e:	75 09                	jne    101359 <serial_putc_sub+0x42>
  101350:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
  101357:	7e d1                	jle    10132a <serial_putc_sub+0x13>
    }
    outb(COM1 + COM_TX, c);
  101359:	8b 45 08             	mov    0x8(%ebp),%eax
  10135c:	0f b6 c0             	movzbl %al,%eax
  10135f:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
  101365:	88 45 f5             	mov    %al,-0xb(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  101368:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  10136c:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  101370:	ee                   	out    %al,(%dx)
}
  101371:	90                   	nop
}
  101372:	90                   	nop
  101373:	c9                   	leave  
  101374:	c3                   	ret    

00101375 <serial_putc>:

/* serial_putc - print character to serial port */
static void
serial_putc(int c) {
  101375:	f3 0f 1e fb          	endbr32 
  101379:	55                   	push   %ebp
  10137a:	89 e5                	mov    %esp,%ebp
  10137c:	83 ec 04             	sub    $0x4,%esp
    if (c != '\b') {
  10137f:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
  101383:	74 0d                	je     101392 <serial_putc+0x1d>
        serial_putc_sub(c);
  101385:	8b 45 08             	mov    0x8(%ebp),%eax
  101388:	89 04 24             	mov    %eax,(%esp)
  10138b:	e8 87 ff ff ff       	call   101317 <serial_putc_sub>
    else {
        serial_putc_sub('\b');
        serial_putc_sub(' ');
        serial_putc_sub('\b');
    }
}
  101390:	eb 24                	jmp    1013b6 <serial_putc+0x41>
        serial_putc_sub('\b');
  101392:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  101399:	e8 79 ff ff ff       	call   101317 <serial_putc_sub>
        serial_putc_sub(' ');
  10139e:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  1013a5:	e8 6d ff ff ff       	call   101317 <serial_putc_sub>
        serial_putc_sub('\b');
  1013aa:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  1013b1:	e8 61 ff ff ff       	call   101317 <serial_putc_sub>
}
  1013b6:	90                   	nop
  1013b7:	c9                   	leave  
  1013b8:	c3                   	ret    

001013b9 <cons_intr>:
/* *
 * cons_intr - called by device interrupt routines to feed input
 * characters into the circular console input buffer.
 * */
static void
cons_intr(int (*proc)(void)) {
  1013b9:	f3 0f 1e fb          	endbr32 
  1013bd:	55                   	push   %ebp
  1013be:	89 e5                	mov    %esp,%ebp
  1013c0:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = (*proc)()) != -1) {
  1013c3:	eb 33                	jmp    1013f8 <cons_intr+0x3f>
        if (c != 0) {
  1013c5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1013c9:	74 2d                	je     1013f8 <cons_intr+0x3f>
            cons.buf[cons.wpos ++] = c;
  1013cb:	a1 84 10 11 00       	mov    0x111084,%eax
  1013d0:	8d 50 01             	lea    0x1(%eax),%edx
  1013d3:	89 15 84 10 11 00    	mov    %edx,0x111084
  1013d9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1013dc:	88 90 80 0e 11 00    	mov    %dl,0x110e80(%eax)
            if (cons.wpos == CONSBUFSIZE) {
  1013e2:	a1 84 10 11 00       	mov    0x111084,%eax
  1013e7:	3d 00 02 00 00       	cmp    $0x200,%eax
  1013ec:	75 0a                	jne    1013f8 <cons_intr+0x3f>
                cons.wpos = 0;
  1013ee:	c7 05 84 10 11 00 00 	movl   $0x0,0x111084
  1013f5:	00 00 00 
    while ((c = (*proc)()) != -1) {
  1013f8:	8b 45 08             	mov    0x8(%ebp),%eax
  1013fb:	ff d0                	call   *%eax
  1013fd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  101400:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
  101404:	75 bf                	jne    1013c5 <cons_intr+0xc>
            }
        }
    }
}
  101406:	90                   	nop
  101407:	90                   	nop
  101408:	c9                   	leave  
  101409:	c3                   	ret    

0010140a <serial_proc_data>:

/* serial_proc_data - get data from serial port */
static int
serial_proc_data(void) {
  10140a:	f3 0f 1e fb          	endbr32 
  10140e:	55                   	push   %ebp
  10140f:	89 e5                	mov    %esp,%ebp
  101411:	83 ec 10             	sub    $0x10,%esp
  101414:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  10141a:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  10141e:	89 c2                	mov    %eax,%edx
  101420:	ec                   	in     (%dx),%al
  101421:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
  101424:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
    if (!(inb(COM1 + COM_LSR) & COM_LSR_DATA)) {
  101428:	0f b6 c0             	movzbl %al,%eax
  10142b:	83 e0 01             	and    $0x1,%eax
  10142e:	85 c0                	test   %eax,%eax
  101430:	75 07                	jne    101439 <serial_proc_data+0x2f>
        return -1;
  101432:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  101437:	eb 2a                	jmp    101463 <serial_proc_data+0x59>
  101439:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  10143f:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  101443:	89 c2                	mov    %eax,%edx
  101445:	ec                   	in     (%dx),%al
  101446:	88 45 f5             	mov    %al,-0xb(%ebp)
    return data;
  101449:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
    }
    int c = inb(COM1 + COM_RX);
  10144d:	0f b6 c0             	movzbl %al,%eax
  101450:	89 45 fc             	mov    %eax,-0x4(%ebp)
    if (c == 127) {
  101453:	83 7d fc 7f          	cmpl   $0x7f,-0x4(%ebp)
  101457:	75 07                	jne    101460 <serial_proc_data+0x56>
        c = '\b';
  101459:	c7 45 fc 08 00 00 00 	movl   $0x8,-0x4(%ebp)
    }
    return c;
  101460:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  101463:	c9                   	leave  
  101464:	c3                   	ret    

00101465 <serial_intr>:

/* serial_intr - try to feed input characters from serial port */
void
serial_intr(void) {
  101465:	f3 0f 1e fb          	endbr32 
  101469:	55                   	push   %ebp
  10146a:	89 e5                	mov    %esp,%ebp
  10146c:	83 ec 18             	sub    $0x18,%esp
    if (serial_exists) {
  10146f:	a1 68 0e 11 00       	mov    0x110e68,%eax
  101474:	85 c0                	test   %eax,%eax
  101476:	74 0c                	je     101484 <serial_intr+0x1f>
        cons_intr(serial_proc_data);
  101478:	c7 04 24 0a 14 10 00 	movl   $0x10140a,(%esp)
  10147f:	e8 35 ff ff ff       	call   1013b9 <cons_intr>
    }
}
  101484:	90                   	nop
  101485:	c9                   	leave  
  101486:	c3                   	ret    

00101487 <kbd_proc_data>:
 *
 * The kbd_proc_data() function gets data from the keyboard.
 * If we finish a character, return it, else 0. And return -1 if no data.
 * */
static int
kbd_proc_data(void) {
  101487:	f3 0f 1e fb          	endbr32 
  10148b:	55                   	push   %ebp
  10148c:	89 e5                	mov    %esp,%ebp
  10148e:	83 ec 38             	sub    $0x38,%esp
  101491:	66 c7 45 f0 64 00    	movw   $0x64,-0x10(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  101497:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10149a:	89 c2                	mov    %eax,%edx
  10149c:	ec                   	in     (%dx),%al
  10149d:	88 45 ef             	mov    %al,-0x11(%ebp)
    return data;
  1014a0:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    int c;
    uint8_t data;
    static uint32_t shift;

    if ((inb(KBSTATP) & KBS_DIB) == 0) {
  1014a4:	0f b6 c0             	movzbl %al,%eax
  1014a7:	83 e0 01             	and    $0x1,%eax
  1014aa:	85 c0                	test   %eax,%eax
  1014ac:	75 0a                	jne    1014b8 <kbd_proc_data+0x31>
        return -1;
  1014ae:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  1014b3:	e9 56 01 00 00       	jmp    10160e <kbd_proc_data+0x187>
  1014b8:	66 c7 45 ec 60 00    	movw   $0x60,-0x14(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  1014be:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1014c1:	89 c2                	mov    %eax,%edx
  1014c3:	ec                   	in     (%dx),%al
  1014c4:	88 45 eb             	mov    %al,-0x15(%ebp)
    return data;
  1014c7:	0f b6 45 eb          	movzbl -0x15(%ebp),%eax
    }

    data = inb(KBDATAP);
  1014cb:	88 45 f3             	mov    %al,-0xd(%ebp)

    if (data == 0xE0) {
  1014ce:	80 7d f3 e0          	cmpb   $0xe0,-0xd(%ebp)
  1014d2:	75 17                	jne    1014eb <kbd_proc_data+0x64>
        // E0 escape character
        shift |= E0ESC;
  1014d4:	a1 88 10 11 00       	mov    0x111088,%eax
  1014d9:	83 c8 40             	or     $0x40,%eax
  1014dc:	a3 88 10 11 00       	mov    %eax,0x111088
        return 0;
  1014e1:	b8 00 00 00 00       	mov    $0x0,%eax
  1014e6:	e9 23 01 00 00       	jmp    10160e <kbd_proc_data+0x187>
    } else if (data & 0x80) {
  1014eb:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  1014ef:	84 c0                	test   %al,%al
  1014f1:	79 45                	jns    101538 <kbd_proc_data+0xb1>
        // Key released
        data = (shift & E0ESC ? data : data & 0x7F);
  1014f3:	a1 88 10 11 00       	mov    0x111088,%eax
  1014f8:	83 e0 40             	and    $0x40,%eax
  1014fb:	85 c0                	test   %eax,%eax
  1014fd:	75 08                	jne    101507 <kbd_proc_data+0x80>
  1014ff:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101503:	24 7f                	and    $0x7f,%al
  101505:	eb 04                	jmp    10150b <kbd_proc_data+0x84>
  101507:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  10150b:	88 45 f3             	mov    %al,-0xd(%ebp)
        shift &= ~(shiftcode[data] | E0ESC);
  10150e:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101512:	0f b6 80 40 00 11 00 	movzbl 0x110040(%eax),%eax
  101519:	0c 40                	or     $0x40,%al
  10151b:	0f b6 c0             	movzbl %al,%eax
  10151e:	f7 d0                	not    %eax
  101520:	89 c2                	mov    %eax,%edx
  101522:	a1 88 10 11 00       	mov    0x111088,%eax
  101527:	21 d0                	and    %edx,%eax
  101529:	a3 88 10 11 00       	mov    %eax,0x111088
        return 0;
  10152e:	b8 00 00 00 00       	mov    $0x0,%eax
  101533:	e9 d6 00 00 00       	jmp    10160e <kbd_proc_data+0x187>
    } else if (shift & E0ESC) {
  101538:	a1 88 10 11 00       	mov    0x111088,%eax
  10153d:	83 e0 40             	and    $0x40,%eax
  101540:	85 c0                	test   %eax,%eax
  101542:	74 11                	je     101555 <kbd_proc_data+0xce>
        // Last character was an E0 escape; or with 0x80
        data |= 0x80;
  101544:	80 4d f3 80          	orb    $0x80,-0xd(%ebp)
        shift &= ~E0ESC;
  101548:	a1 88 10 11 00       	mov    0x111088,%eax
  10154d:	83 e0 bf             	and    $0xffffffbf,%eax
  101550:	a3 88 10 11 00       	mov    %eax,0x111088
    }



    shift |= shiftcode[data];
  101555:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101559:	0f b6 80 40 00 11 00 	movzbl 0x110040(%eax),%eax
  101560:	0f b6 d0             	movzbl %al,%edx
  101563:	a1 88 10 11 00       	mov    0x111088,%eax
  101568:	09 d0                	or     %edx,%eax
  10156a:	a3 88 10 11 00       	mov    %eax,0x111088
    shift ^= togglecode[data];
  10156f:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101573:	0f b6 80 40 01 11 00 	movzbl 0x110140(%eax),%eax
  10157a:	0f b6 d0             	movzbl %al,%edx
  10157d:	a1 88 10 11 00       	mov    0x111088,%eax
  101582:	31 d0                	xor    %edx,%eax
  101584:	a3 88 10 11 00       	mov    %eax,0x111088

    c = charcode[shift & (CTL | SHIFT)][data];
  101589:	a1 88 10 11 00       	mov    0x111088,%eax
  10158e:	83 e0 03             	and    $0x3,%eax
  101591:	8b 14 85 40 05 11 00 	mov    0x110540(,%eax,4),%edx
  101598:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  10159c:	01 d0                	add    %edx,%eax
  10159e:	0f b6 00             	movzbl (%eax),%eax
  1015a1:	0f b6 c0             	movzbl %al,%eax
  1015a4:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (shift & CAPSLOCK) {
  1015a7:	a1 88 10 11 00       	mov    0x111088,%eax
  1015ac:	83 e0 08             	and    $0x8,%eax
  1015af:	85 c0                	test   %eax,%eax
  1015b1:	74 22                	je     1015d5 <kbd_proc_data+0x14e>
        if ('a' <= c && c <= 'z')
  1015b3:	83 7d f4 60          	cmpl   $0x60,-0xc(%ebp)
  1015b7:	7e 0c                	jle    1015c5 <kbd_proc_data+0x13e>
  1015b9:	83 7d f4 7a          	cmpl   $0x7a,-0xc(%ebp)
  1015bd:	7f 06                	jg     1015c5 <kbd_proc_data+0x13e>
            c += 'A' - 'a';
  1015bf:	83 6d f4 20          	subl   $0x20,-0xc(%ebp)
  1015c3:	eb 10                	jmp    1015d5 <kbd_proc_data+0x14e>
        else if ('A' <= c && c <= 'Z')
  1015c5:	83 7d f4 40          	cmpl   $0x40,-0xc(%ebp)
  1015c9:	7e 0a                	jle    1015d5 <kbd_proc_data+0x14e>
  1015cb:	83 7d f4 5a          	cmpl   $0x5a,-0xc(%ebp)
  1015cf:	7f 04                	jg     1015d5 <kbd_proc_data+0x14e>
            c += 'a' - 'A';
  1015d1:	83 45 f4 20          	addl   $0x20,-0xc(%ebp)
    }

    // Process special keys
    // Ctrl-Alt-Del: reboot
    if (!(~shift & (CTL | ALT)) && c == KEY_DEL) {
  1015d5:	a1 88 10 11 00       	mov    0x111088,%eax
  1015da:	f7 d0                	not    %eax
  1015dc:	83 e0 06             	and    $0x6,%eax
  1015df:	85 c0                	test   %eax,%eax
  1015e1:	75 28                	jne    10160b <kbd_proc_data+0x184>
  1015e3:	81 7d f4 e9 00 00 00 	cmpl   $0xe9,-0xc(%ebp)
  1015ea:	75 1f                	jne    10160b <kbd_proc_data+0x184>
        cprintf("Rebooting!\n");
  1015ec:	c7 04 24 2d 3d 10 00 	movl   $0x103d2d,(%esp)
  1015f3:	e8 9c ec ff ff       	call   100294 <cprintf>
  1015f8:	66 c7 45 e8 92 00    	movw   $0x92,-0x18(%ebp)
  1015fe:	c6 45 e7 03          	movb   $0x3,-0x19(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  101602:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
  101606:	8b 55 e8             	mov    -0x18(%ebp),%edx
  101609:	ee                   	out    %al,(%dx)
}
  10160a:	90                   	nop
        outb(0x92, 0x3); // courtesy of Chris Frost
    }
    return c;
  10160b:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  10160e:	c9                   	leave  
  10160f:	c3                   	ret    

00101610 <kbd_intr>:

/* kbd_intr - try to feed input characters from keyboard */
static void
kbd_intr(void) {
  101610:	f3 0f 1e fb          	endbr32 
  101614:	55                   	push   %ebp
  101615:	89 e5                	mov    %esp,%ebp
  101617:	83 ec 18             	sub    $0x18,%esp
    cons_intr(kbd_proc_data);
  10161a:	c7 04 24 87 14 10 00 	movl   $0x101487,(%esp)
  101621:	e8 93 fd ff ff       	call   1013b9 <cons_intr>
}
  101626:	90                   	nop
  101627:	c9                   	leave  
  101628:	c3                   	ret    

00101629 <kbd_init>:

static void
kbd_init(void) {
  101629:	f3 0f 1e fb          	endbr32 
  10162d:	55                   	push   %ebp
  10162e:	89 e5                	mov    %esp,%ebp
  101630:	83 ec 18             	sub    $0x18,%esp
    // drain the kbd buffer
    kbd_intr();
  101633:	e8 d8 ff ff ff       	call   101610 <kbd_intr>
    pic_enable(IRQ_KBD);
  101638:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  10163f:	e8 21 01 00 00       	call   101765 <pic_enable>
}
  101644:	90                   	nop
  101645:	c9                   	leave  
  101646:	c3                   	ret    

00101647 <cons_init>:

/* cons_init - initializes the console devices */
void
cons_init(void) {
  101647:	f3 0f 1e fb          	endbr32 
  10164b:	55                   	push   %ebp
  10164c:	89 e5                	mov    %esp,%ebp
  10164e:	83 ec 18             	sub    $0x18,%esp
    cga_init();
  101651:	e8 2e f8 ff ff       	call   100e84 <cga_init>
    serial_init();
  101656:	e8 13 f9 ff ff       	call   100f6e <serial_init>
    kbd_init();
  10165b:	e8 c9 ff ff ff       	call   101629 <kbd_init>
    if (!serial_exists) {
  101660:	a1 68 0e 11 00       	mov    0x110e68,%eax
  101665:	85 c0                	test   %eax,%eax
  101667:	75 0c                	jne    101675 <cons_init+0x2e>
        cprintf("serial port does not exist!!\n");
  101669:	c7 04 24 39 3d 10 00 	movl   $0x103d39,(%esp)
  101670:	e8 1f ec ff ff       	call   100294 <cprintf>
    }
}
  101675:	90                   	nop
  101676:	c9                   	leave  
  101677:	c3                   	ret    

00101678 <cons_putc>:

/* cons_putc - print a single character @c to console devices */
void
cons_putc(int c) {
  101678:	f3 0f 1e fb          	endbr32 
  10167c:	55                   	push   %ebp
  10167d:	89 e5                	mov    %esp,%ebp
  10167f:	83 ec 18             	sub    $0x18,%esp
    lpt_putc(c);
  101682:	8b 45 08             	mov    0x8(%ebp),%eax
  101685:	89 04 24             	mov    %eax,(%esp)
  101688:	e8 50 fa ff ff       	call   1010dd <lpt_putc>
    cga_putc(c);
  10168d:	8b 45 08             	mov    0x8(%ebp),%eax
  101690:	89 04 24             	mov    %eax,(%esp)
  101693:	e8 89 fa ff ff       	call   101121 <cga_putc>
    serial_putc(c);
  101698:	8b 45 08             	mov    0x8(%ebp),%eax
  10169b:	89 04 24             	mov    %eax,(%esp)
  10169e:	e8 d2 fc ff ff       	call   101375 <serial_putc>
}
  1016a3:	90                   	nop
  1016a4:	c9                   	leave  
  1016a5:	c3                   	ret    

001016a6 <cons_getc>:
/* *
 * cons_getc - return the next input character from console,
 * or 0 if none waiting.
 * */
int
cons_getc(void) {
  1016a6:	f3 0f 1e fb          	endbr32 
  1016aa:	55                   	push   %ebp
  1016ab:	89 e5                	mov    %esp,%ebp
  1016ad:	83 ec 18             	sub    $0x18,%esp
    int c;

    // poll for any pending input characters,
    // so that this function works even when interrupts are disabled
    // (e.g., when called from the kernel monitor).
    serial_intr();
  1016b0:	e8 b0 fd ff ff       	call   101465 <serial_intr>
    kbd_intr();
  1016b5:	e8 56 ff ff ff       	call   101610 <kbd_intr>

    // grab the next character from the input buffer.
    if (cons.rpos != cons.wpos) {
  1016ba:	8b 15 80 10 11 00    	mov    0x111080,%edx
  1016c0:	a1 84 10 11 00       	mov    0x111084,%eax
  1016c5:	39 c2                	cmp    %eax,%edx
  1016c7:	74 36                	je     1016ff <cons_getc+0x59>
        c = cons.buf[cons.rpos ++];
  1016c9:	a1 80 10 11 00       	mov    0x111080,%eax
  1016ce:	8d 50 01             	lea    0x1(%eax),%edx
  1016d1:	89 15 80 10 11 00    	mov    %edx,0x111080
  1016d7:	0f b6 80 80 0e 11 00 	movzbl 0x110e80(%eax),%eax
  1016de:	0f b6 c0             	movzbl %al,%eax
  1016e1:	89 45 f4             	mov    %eax,-0xc(%ebp)
        if (cons.rpos == CONSBUFSIZE) {
  1016e4:	a1 80 10 11 00       	mov    0x111080,%eax
  1016e9:	3d 00 02 00 00       	cmp    $0x200,%eax
  1016ee:	75 0a                	jne    1016fa <cons_getc+0x54>
            cons.rpos = 0;
  1016f0:	c7 05 80 10 11 00 00 	movl   $0x0,0x111080
  1016f7:	00 00 00 
        }
        return c;
  1016fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1016fd:	eb 05                	jmp    101704 <cons_getc+0x5e>
    }
    return 0;
  1016ff:	b8 00 00 00 00       	mov    $0x0,%eax
}
  101704:	c9                   	leave  
  101705:	c3                   	ret    

00101706 <pic_setmask>:
// Initial IRQ mask has interrupt 2 enabled (for slave 8259A).
static uint16_t irq_mask = 0xFFFF & ~(1 << IRQ_SLAVE);
static bool did_init = 0;

static void
pic_setmask(uint16_t mask) {
  101706:	f3 0f 1e fb          	endbr32 
  10170a:	55                   	push   %ebp
  10170b:	89 e5                	mov    %esp,%ebp
  10170d:	83 ec 14             	sub    $0x14,%esp
  101710:	8b 45 08             	mov    0x8(%ebp),%eax
  101713:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
    irq_mask = mask;
  101717:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10171a:	66 a3 50 05 11 00    	mov    %ax,0x110550
    if (did_init) {
  101720:	a1 8c 10 11 00       	mov    0x11108c,%eax
  101725:	85 c0                	test   %eax,%eax
  101727:	74 39                	je     101762 <pic_setmask+0x5c>
        outb(IO_PIC1 + 1, mask);
  101729:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10172c:	0f b6 c0             	movzbl %al,%eax
  10172f:	66 c7 45 fa 21 00    	movw   $0x21,-0x6(%ebp)
  101735:	88 45 f9             	mov    %al,-0x7(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  101738:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  10173c:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  101740:	ee                   	out    %al,(%dx)
}
  101741:	90                   	nop
        outb(IO_PIC2 + 1, mask >> 8);
  101742:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  101746:	c1 e8 08             	shr    $0x8,%eax
  101749:	0f b7 c0             	movzwl %ax,%eax
  10174c:	0f b6 c0             	movzbl %al,%eax
  10174f:	66 c7 45 fe a1 00    	movw   $0xa1,-0x2(%ebp)
  101755:	88 45 fd             	mov    %al,-0x3(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  101758:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
  10175c:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
  101760:	ee                   	out    %al,(%dx)
}
  101761:	90                   	nop
    }
}
  101762:	90                   	nop
  101763:	c9                   	leave  
  101764:	c3                   	ret    

00101765 <pic_enable>:

void
pic_enable(unsigned int irq) {
  101765:	f3 0f 1e fb          	endbr32 
  101769:	55                   	push   %ebp
  10176a:	89 e5                	mov    %esp,%ebp
  10176c:	83 ec 04             	sub    $0x4,%esp
    pic_setmask(irq_mask & ~(1 << irq));
  10176f:	8b 45 08             	mov    0x8(%ebp),%eax
  101772:	ba 01 00 00 00       	mov    $0x1,%edx
  101777:	88 c1                	mov    %al,%cl
  101779:	d3 e2                	shl    %cl,%edx
  10177b:	89 d0                	mov    %edx,%eax
  10177d:	98                   	cwtl   
  10177e:	f7 d0                	not    %eax
  101780:	0f bf d0             	movswl %ax,%edx
  101783:	0f b7 05 50 05 11 00 	movzwl 0x110550,%eax
  10178a:	98                   	cwtl   
  10178b:	21 d0                	and    %edx,%eax
  10178d:	98                   	cwtl   
  10178e:	0f b7 c0             	movzwl %ax,%eax
  101791:	89 04 24             	mov    %eax,(%esp)
  101794:	e8 6d ff ff ff       	call   101706 <pic_setmask>
}
  101799:	90                   	nop
  10179a:	c9                   	leave  
  10179b:	c3                   	ret    

0010179c <pic_init>:

/* pic_init - initialize the 8259A interrupt controllers */
void
pic_init(void) {
  10179c:	f3 0f 1e fb          	endbr32 
  1017a0:	55                   	push   %ebp
  1017a1:	89 e5                	mov    %esp,%ebp
  1017a3:	83 ec 44             	sub    $0x44,%esp
    did_init = 1;
  1017a6:	c7 05 8c 10 11 00 01 	movl   $0x1,0x11108c
  1017ad:	00 00 00 
  1017b0:	66 c7 45 ca 21 00    	movw   $0x21,-0x36(%ebp)
  1017b6:	c6 45 c9 ff          	movb   $0xff,-0x37(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  1017ba:	0f b6 45 c9          	movzbl -0x37(%ebp),%eax
  1017be:	0f b7 55 ca          	movzwl -0x36(%ebp),%edx
  1017c2:	ee                   	out    %al,(%dx)
}
  1017c3:	90                   	nop
  1017c4:	66 c7 45 ce a1 00    	movw   $0xa1,-0x32(%ebp)
  1017ca:	c6 45 cd ff          	movb   $0xff,-0x33(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  1017ce:	0f b6 45 cd          	movzbl -0x33(%ebp),%eax
  1017d2:	0f b7 55 ce          	movzwl -0x32(%ebp),%edx
  1017d6:	ee                   	out    %al,(%dx)
}
  1017d7:	90                   	nop
  1017d8:	66 c7 45 d2 20 00    	movw   $0x20,-0x2e(%ebp)
  1017de:	c6 45 d1 11          	movb   $0x11,-0x2f(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  1017e2:	0f b6 45 d1          	movzbl -0x2f(%ebp),%eax
  1017e6:	0f b7 55 d2          	movzwl -0x2e(%ebp),%edx
  1017ea:	ee                   	out    %al,(%dx)
}
  1017eb:	90                   	nop
  1017ec:	66 c7 45 d6 21 00    	movw   $0x21,-0x2a(%ebp)
  1017f2:	c6 45 d5 20          	movb   $0x20,-0x2b(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  1017f6:	0f b6 45 d5          	movzbl -0x2b(%ebp),%eax
  1017fa:	0f b7 55 d6          	movzwl -0x2a(%ebp),%edx
  1017fe:	ee                   	out    %al,(%dx)
}
  1017ff:	90                   	nop
  101800:	66 c7 45 da 21 00    	movw   $0x21,-0x26(%ebp)
  101806:	c6 45 d9 04          	movb   $0x4,-0x27(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  10180a:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
  10180e:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
  101812:	ee                   	out    %al,(%dx)
}
  101813:	90                   	nop
  101814:	66 c7 45 de 21 00    	movw   $0x21,-0x22(%ebp)
  10181a:	c6 45 dd 03          	movb   $0x3,-0x23(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  10181e:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
  101822:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
  101826:	ee                   	out    %al,(%dx)
}
  101827:	90                   	nop
  101828:	66 c7 45 e2 a0 00    	movw   $0xa0,-0x1e(%ebp)
  10182e:	c6 45 e1 11          	movb   $0x11,-0x1f(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  101832:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
  101836:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
  10183a:	ee                   	out    %al,(%dx)
}
  10183b:	90                   	nop
  10183c:	66 c7 45 e6 a1 00    	movw   $0xa1,-0x1a(%ebp)
  101842:	c6 45 e5 28          	movb   $0x28,-0x1b(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  101846:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  10184a:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  10184e:	ee                   	out    %al,(%dx)
}
  10184f:	90                   	nop
  101850:	66 c7 45 ea a1 00    	movw   $0xa1,-0x16(%ebp)
  101856:	c6 45 e9 02          	movb   $0x2,-0x17(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  10185a:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  10185e:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  101862:	ee                   	out    %al,(%dx)
}
  101863:	90                   	nop
  101864:	66 c7 45 ee a1 00    	movw   $0xa1,-0x12(%ebp)
  10186a:	c6 45 ed 03          	movb   $0x3,-0x13(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  10186e:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  101872:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  101876:	ee                   	out    %al,(%dx)
}
  101877:	90                   	nop
  101878:	66 c7 45 f2 20 00    	movw   $0x20,-0xe(%ebp)
  10187e:	c6 45 f1 68          	movb   $0x68,-0xf(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  101882:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  101886:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  10188a:	ee                   	out    %al,(%dx)
}
  10188b:	90                   	nop
  10188c:	66 c7 45 f6 20 00    	movw   $0x20,-0xa(%ebp)
  101892:	c6 45 f5 0a          	movb   $0xa,-0xb(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  101896:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  10189a:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  10189e:	ee                   	out    %al,(%dx)
}
  10189f:	90                   	nop
  1018a0:	66 c7 45 fa a0 00    	movw   $0xa0,-0x6(%ebp)
  1018a6:	c6 45 f9 68          	movb   $0x68,-0x7(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  1018aa:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  1018ae:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  1018b2:	ee                   	out    %al,(%dx)
}
  1018b3:	90                   	nop
  1018b4:	66 c7 45 fe a0 00    	movw   $0xa0,-0x2(%ebp)
  1018ba:	c6 45 fd 0a          	movb   $0xa,-0x3(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  1018be:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
  1018c2:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
  1018c6:	ee                   	out    %al,(%dx)
}
  1018c7:	90                   	nop
    outb(IO_PIC1, 0x0a);    // read IRR by default

    outb(IO_PIC2, 0x68);    // OCW3
    outb(IO_PIC2, 0x0a);    // OCW3

    if (irq_mask != 0xFFFF) {
  1018c8:	0f b7 05 50 05 11 00 	movzwl 0x110550,%eax
  1018cf:	3d ff ff 00 00       	cmp    $0xffff,%eax
  1018d4:	74 0f                	je     1018e5 <pic_init+0x149>
        pic_setmask(irq_mask);
  1018d6:	0f b7 05 50 05 11 00 	movzwl 0x110550,%eax
  1018dd:	89 04 24             	mov    %eax,(%esp)
  1018e0:	e8 21 fe ff ff       	call   101706 <pic_setmask>
    }
}
  1018e5:	90                   	nop
  1018e6:	c9                   	leave  
  1018e7:	c3                   	ret    

001018e8 <intr_enable>:
#include <x86.h>
#include <intr.h>

/* intr_enable - enable irq interrupt */
void
intr_enable(void) {
  1018e8:	f3 0f 1e fb          	endbr32 
  1018ec:	55                   	push   %ebp
  1018ed:	89 e5                	mov    %esp,%ebp
    asm volatile ("lidt (%0)" :: "r" (pd));
}

static inline void
sti(void) {
    asm volatile ("sti");
  1018ef:	fb                   	sti    
}
  1018f0:	90                   	nop
    sti();
}
  1018f1:	90                   	nop
  1018f2:	5d                   	pop    %ebp
  1018f3:	c3                   	ret    

001018f4 <intr_disable>:

/* intr_disable - disable irq interrupt */
void
intr_disable(void) {
  1018f4:	f3 0f 1e fb          	endbr32 
  1018f8:	55                   	push   %ebp
  1018f9:	89 e5                	mov    %esp,%ebp

static inline void
cli(void) {
    asm volatile ("cli");
  1018fb:	fa                   	cli    
}
  1018fc:	90                   	nop
    cli();
}
  1018fd:	90                   	nop
  1018fe:	5d                   	pop    %ebp
  1018ff:	c3                   	ret    

00101900 <print_ticks>:
#include <kdebug.h>
#include <string.h>

#define TICK_NUM 100

static void print_ticks() {
  101900:	f3 0f 1e fb          	endbr32 
  101904:	55                   	push   %ebp
  101905:	89 e5                	mov    %esp,%ebp
  101907:	83 ec 18             	sub    $0x18,%esp
    cprintf("%d ticks\n",TICK_NUM);
  10190a:	c7 44 24 04 64 00 00 	movl   $0x64,0x4(%esp)
  101911:	00 
  101912:	c7 04 24 60 3d 10 00 	movl   $0x103d60,(%esp)
  101919:	e8 76 e9 ff ff       	call   100294 <cprintf>
#ifdef DEBUG_GRADE
    cprintf("End of Test.\n");
  10191e:	c7 04 24 6a 3d 10 00 	movl   $0x103d6a,(%esp)
  101925:	e8 6a e9 ff ff       	call   100294 <cprintf>
    panic("EOT: kernel seems ok.");
  10192a:	c7 44 24 08 78 3d 10 	movl   $0x103d78,0x8(%esp)
  101931:	00 
  101932:	c7 44 24 04 13 00 00 	movl   $0x13,0x4(%esp)
  101939:	00 
  10193a:	c7 04 24 8e 3d 10 00 	movl   $0x103d8e,(%esp)
  101941:	e8 ba ea ff ff       	call   100400 <__panic>

00101946 <idt_init>:
    sizeof(idt) - 1, (uintptr_t)idt
};

/* idt_init - initialize IDT to each of the entry points in kern/trap/vectors.S */
void
idt_init(void) {
  101946:	f3 0f 1e fb          	endbr32 
  10194a:	55                   	push   %ebp
  10194b:	89 e5                	mov    %esp,%ebp
  10194d:	83 ec 10             	sub    $0x10,%esp
      */
    
    // 定义中断向量表
    extern uintptr_t __vectors[];
    // 向量表的长度为sizeof(idt) / sizeof(struct gatedesc)
    for (int i = 0; i < sizeof(idt) / sizeof(struct gatedesc); i ++) {
  101950:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  101957:	e9 c4 00 00 00       	jmp    101a20 <idt_init+0xda>
    // idt描述表项，0表示是interupt而不是trap，GD_KTEXT为段选择子，__vectors[i]为偏移量，DPL_KERNEL为特权级
        SETGATE(idt[i], 0, GD_KTEXT, __vectors[i], DPL_KERNEL);
  10195c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10195f:	8b 04 85 e0 05 11 00 	mov    0x1105e0(,%eax,4),%eax
  101966:	0f b7 d0             	movzwl %ax,%edx
  101969:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10196c:	66 89 14 c5 a0 10 11 	mov    %dx,0x1110a0(,%eax,8)
  101973:	00 
  101974:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101977:	66 c7 04 c5 a2 10 11 	movw   $0x8,0x1110a2(,%eax,8)
  10197e:	00 08 00 
  101981:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101984:	0f b6 14 c5 a4 10 11 	movzbl 0x1110a4(,%eax,8),%edx
  10198b:	00 
  10198c:	80 e2 e0             	and    $0xe0,%dl
  10198f:	88 14 c5 a4 10 11 00 	mov    %dl,0x1110a4(,%eax,8)
  101996:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101999:	0f b6 14 c5 a4 10 11 	movzbl 0x1110a4(,%eax,8),%edx
  1019a0:	00 
  1019a1:	80 e2 1f             	and    $0x1f,%dl
  1019a4:	88 14 c5 a4 10 11 00 	mov    %dl,0x1110a4(,%eax,8)
  1019ab:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1019ae:	0f b6 14 c5 a5 10 11 	movzbl 0x1110a5(,%eax,8),%edx
  1019b5:	00 
  1019b6:	80 e2 f0             	and    $0xf0,%dl
  1019b9:	80 ca 0e             	or     $0xe,%dl
  1019bc:	88 14 c5 a5 10 11 00 	mov    %dl,0x1110a5(,%eax,8)
  1019c3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1019c6:	0f b6 14 c5 a5 10 11 	movzbl 0x1110a5(,%eax,8),%edx
  1019cd:	00 
  1019ce:	80 e2 ef             	and    $0xef,%dl
  1019d1:	88 14 c5 a5 10 11 00 	mov    %dl,0x1110a5(,%eax,8)
  1019d8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1019db:	0f b6 14 c5 a5 10 11 	movzbl 0x1110a5(,%eax,8),%edx
  1019e2:	00 
  1019e3:	80 e2 9f             	and    $0x9f,%dl
  1019e6:	88 14 c5 a5 10 11 00 	mov    %dl,0x1110a5(,%eax,8)
  1019ed:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1019f0:	0f b6 14 c5 a5 10 11 	movzbl 0x1110a5(,%eax,8),%edx
  1019f7:	00 
  1019f8:	80 ca 80             	or     $0x80,%dl
  1019fb:	88 14 c5 a5 10 11 00 	mov    %dl,0x1110a5(,%eax,8)
  101a02:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101a05:	8b 04 85 e0 05 11 00 	mov    0x1105e0(,%eax,4),%eax
  101a0c:	c1 e8 10             	shr    $0x10,%eax
  101a0f:	0f b7 d0             	movzwl %ax,%edx
  101a12:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101a15:	66 89 14 c5 a6 10 11 	mov    %dx,0x1110a6(,%eax,8)
  101a1c:	00 
    for (int i = 0; i < sizeof(idt) / sizeof(struct gatedesc); i ++) {
  101a1d:	ff 45 fc             	incl   -0x4(%ebp)
  101a20:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101a23:	3d ff 00 00 00       	cmp    $0xff,%eax
  101a28:	0f 86 2e ff ff ff    	jbe    10195c <idt_init+0x16>
    }
	// set for switch from user to kernel
    // 选择需要从user特权级转化为kernel特权级的项(系统调用中断)
    SETGATE(idt[T_SWITCH_TOK], 1, KERNEL_CS, __vectors[T_SWITCH_TOK], DPL_USER);
  101a2e:	a1 c4 07 11 00       	mov    0x1107c4,%eax
  101a33:	0f b7 c0             	movzwl %ax,%eax
  101a36:	66 a3 68 14 11 00    	mov    %ax,0x111468
  101a3c:	66 c7 05 6a 14 11 00 	movw   $0x8,0x11146a
  101a43:	08 00 
  101a45:	0f b6 05 6c 14 11 00 	movzbl 0x11146c,%eax
  101a4c:	24 e0                	and    $0xe0,%al
  101a4e:	a2 6c 14 11 00       	mov    %al,0x11146c
  101a53:	0f b6 05 6c 14 11 00 	movzbl 0x11146c,%eax
  101a5a:	24 1f                	and    $0x1f,%al
  101a5c:	a2 6c 14 11 00       	mov    %al,0x11146c
  101a61:	0f b6 05 6d 14 11 00 	movzbl 0x11146d,%eax
  101a68:	0c 0f                	or     $0xf,%al
  101a6a:	a2 6d 14 11 00       	mov    %al,0x11146d
  101a6f:	0f b6 05 6d 14 11 00 	movzbl 0x11146d,%eax
  101a76:	24 ef                	and    $0xef,%al
  101a78:	a2 6d 14 11 00       	mov    %al,0x11146d
  101a7d:	0f b6 05 6d 14 11 00 	movzbl 0x11146d,%eax
  101a84:	0c 60                	or     $0x60,%al
  101a86:	a2 6d 14 11 00       	mov    %al,0x11146d
  101a8b:	0f b6 05 6d 14 11 00 	movzbl 0x11146d,%eax
  101a92:	0c 80                	or     $0x80,%al
  101a94:	a2 6d 14 11 00       	mov    %al,0x11146d
  101a99:	a1 c4 07 11 00       	mov    0x1107c4,%eax
  101a9e:	c1 e8 10             	shr    $0x10,%eax
  101aa1:	0f b7 c0             	movzwl %ax,%eax
  101aa4:	66 a3 6e 14 11 00    	mov    %ax,0x11146e
    SETGATE(idt[T_SYSCALL], 1, KERNEL_CS, __vectors[T_SYSCALL], DPL_USER);
  101aaa:	a1 e0 07 11 00       	mov    0x1107e0,%eax
  101aaf:	0f b7 c0             	movzwl %ax,%eax
  101ab2:	66 a3 a0 14 11 00    	mov    %ax,0x1114a0
  101ab8:	66 c7 05 a2 14 11 00 	movw   $0x8,0x1114a2
  101abf:	08 00 
  101ac1:	0f b6 05 a4 14 11 00 	movzbl 0x1114a4,%eax
  101ac8:	24 e0                	and    $0xe0,%al
  101aca:	a2 a4 14 11 00       	mov    %al,0x1114a4
  101acf:	0f b6 05 a4 14 11 00 	movzbl 0x1114a4,%eax
  101ad6:	24 1f                	and    $0x1f,%al
  101ad8:	a2 a4 14 11 00       	mov    %al,0x1114a4
  101add:	0f b6 05 a5 14 11 00 	movzbl 0x1114a5,%eax
  101ae4:	0c 0f                	or     $0xf,%al
  101ae6:	a2 a5 14 11 00       	mov    %al,0x1114a5
  101aeb:	0f b6 05 a5 14 11 00 	movzbl 0x1114a5,%eax
  101af2:	24 ef                	and    $0xef,%al
  101af4:	a2 a5 14 11 00       	mov    %al,0x1114a5
  101af9:	0f b6 05 a5 14 11 00 	movzbl 0x1114a5,%eax
  101b00:	0c 60                	or     $0x60,%al
  101b02:	a2 a5 14 11 00       	mov    %al,0x1114a5
  101b07:	0f b6 05 a5 14 11 00 	movzbl 0x1114a5,%eax
  101b0e:	0c 80                	or     $0x80,%al
  101b10:	a2 a5 14 11 00       	mov    %al,0x1114a5
  101b15:	a1 e0 07 11 00       	mov    0x1107e0,%eax
  101b1a:	c1 e8 10             	shr    $0x10,%eax
  101b1d:	0f b7 c0             	movzwl %ax,%eax
  101b20:	66 a3 a6 14 11 00    	mov    %ax,0x1114a6
  101b26:	c7 45 f8 60 05 11 00 	movl   $0x110560,-0x8(%ebp)
    asm volatile ("lidt (%0)" :: "r" (pd));
  101b2d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  101b30:	0f 01 18             	lidtl  (%eax)
}
  101b33:	90                   	nop
	// load the IDT
    // 加载IDT
    lidt(&idt_pd);
}
  101b34:	90                   	nop
  101b35:	c9                   	leave  
  101b36:	c3                   	ret    

00101b37 <trapname>:

static const char *
trapname(int trapno) {
  101b37:	f3 0f 1e fb          	endbr32 
  101b3b:	55                   	push   %ebp
  101b3c:	89 e5                	mov    %esp,%ebp
        "Alignment Check",
        "Machine-Check",
        "SIMD Floating-Point Exception"
    };

    if (trapno < sizeof(excnames)/sizeof(const char * const)) {
  101b3e:	8b 45 08             	mov    0x8(%ebp),%eax
  101b41:	83 f8 13             	cmp    $0x13,%eax
  101b44:	77 0c                	ja     101b52 <trapname+0x1b>
        return excnames[trapno];
  101b46:	8b 45 08             	mov    0x8(%ebp),%eax
  101b49:	8b 04 85 20 41 10 00 	mov    0x104120(,%eax,4),%eax
  101b50:	eb 18                	jmp    101b6a <trapname+0x33>
    }
    if (trapno >= IRQ_OFFSET && trapno < IRQ_OFFSET + 16) {
  101b52:	83 7d 08 1f          	cmpl   $0x1f,0x8(%ebp)
  101b56:	7e 0d                	jle    101b65 <trapname+0x2e>
  101b58:	83 7d 08 2f          	cmpl   $0x2f,0x8(%ebp)
  101b5c:	7f 07                	jg     101b65 <trapname+0x2e>
        return "Hardware Interrupt";
  101b5e:	b8 9f 3d 10 00       	mov    $0x103d9f,%eax
  101b63:	eb 05                	jmp    101b6a <trapname+0x33>
    }
    return "(unknown trap)";
  101b65:	b8 b2 3d 10 00       	mov    $0x103db2,%eax
}
  101b6a:	5d                   	pop    %ebp
  101b6b:	c3                   	ret    

00101b6c <trap_in_kernel>:

/* trap_in_kernel - test if trap happened in kernel */
bool
trap_in_kernel(struct trapframe *tf) {
  101b6c:	f3 0f 1e fb          	endbr32 
  101b70:	55                   	push   %ebp
  101b71:	89 e5                	mov    %esp,%ebp
    return (tf->tf_cs == (uint16_t)KERNEL_CS);
  101b73:	8b 45 08             	mov    0x8(%ebp),%eax
  101b76:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101b7a:	83 f8 08             	cmp    $0x8,%eax
  101b7d:	0f 94 c0             	sete   %al
  101b80:	0f b6 c0             	movzbl %al,%eax
}
  101b83:	5d                   	pop    %ebp
  101b84:	c3                   	ret    

00101b85 <print_trapframe>:
    "TF", "IF", "DF", "OF", NULL, NULL, "NT", NULL,
    "RF", "VM", "AC", "VIF", "VIP", "ID", NULL, NULL,
};

void
print_trapframe(struct trapframe *tf) {
  101b85:	f3 0f 1e fb          	endbr32 
  101b89:	55                   	push   %ebp
  101b8a:	89 e5                	mov    %esp,%ebp
  101b8c:	83 ec 28             	sub    $0x28,%esp
    cprintf("trapframe at %p\n", tf);
  101b8f:	8b 45 08             	mov    0x8(%ebp),%eax
  101b92:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b96:	c7 04 24 f3 3d 10 00 	movl   $0x103df3,(%esp)
  101b9d:	e8 f2 e6 ff ff       	call   100294 <cprintf>
    print_regs(&tf->tf_regs);
  101ba2:	8b 45 08             	mov    0x8(%ebp),%eax
  101ba5:	89 04 24             	mov    %eax,(%esp)
  101ba8:	e8 8d 01 00 00       	call   101d3a <print_regs>
    cprintf("  ds   0x----%04x\n", tf->tf_ds);
  101bad:	8b 45 08             	mov    0x8(%ebp),%eax
  101bb0:	0f b7 40 2c          	movzwl 0x2c(%eax),%eax
  101bb4:	89 44 24 04          	mov    %eax,0x4(%esp)
  101bb8:	c7 04 24 04 3e 10 00 	movl   $0x103e04,(%esp)
  101bbf:	e8 d0 e6 ff ff       	call   100294 <cprintf>
    cprintf("  es   0x----%04x\n", tf->tf_es);
  101bc4:	8b 45 08             	mov    0x8(%ebp),%eax
  101bc7:	0f b7 40 28          	movzwl 0x28(%eax),%eax
  101bcb:	89 44 24 04          	mov    %eax,0x4(%esp)
  101bcf:	c7 04 24 17 3e 10 00 	movl   $0x103e17,(%esp)
  101bd6:	e8 b9 e6 ff ff       	call   100294 <cprintf>
    cprintf("  fs   0x----%04x\n", tf->tf_fs);
  101bdb:	8b 45 08             	mov    0x8(%ebp),%eax
  101bde:	0f b7 40 24          	movzwl 0x24(%eax),%eax
  101be2:	89 44 24 04          	mov    %eax,0x4(%esp)
  101be6:	c7 04 24 2a 3e 10 00 	movl   $0x103e2a,(%esp)
  101bed:	e8 a2 e6 ff ff       	call   100294 <cprintf>
    cprintf("  gs   0x----%04x\n", tf->tf_gs);
  101bf2:	8b 45 08             	mov    0x8(%ebp),%eax
  101bf5:	0f b7 40 20          	movzwl 0x20(%eax),%eax
  101bf9:	89 44 24 04          	mov    %eax,0x4(%esp)
  101bfd:	c7 04 24 3d 3e 10 00 	movl   $0x103e3d,(%esp)
  101c04:	e8 8b e6 ff ff       	call   100294 <cprintf>
    cprintf("  trap 0x%08x %s\n", tf->tf_trapno, trapname(tf->tf_trapno));
  101c09:	8b 45 08             	mov    0x8(%ebp),%eax
  101c0c:	8b 40 30             	mov    0x30(%eax),%eax
  101c0f:	89 04 24             	mov    %eax,(%esp)
  101c12:	e8 20 ff ff ff       	call   101b37 <trapname>
  101c17:	8b 55 08             	mov    0x8(%ebp),%edx
  101c1a:	8b 52 30             	mov    0x30(%edx),%edx
  101c1d:	89 44 24 08          	mov    %eax,0x8(%esp)
  101c21:	89 54 24 04          	mov    %edx,0x4(%esp)
  101c25:	c7 04 24 50 3e 10 00 	movl   $0x103e50,(%esp)
  101c2c:	e8 63 e6 ff ff       	call   100294 <cprintf>
    cprintf("  err  0x%08x\n", tf->tf_err);
  101c31:	8b 45 08             	mov    0x8(%ebp),%eax
  101c34:	8b 40 34             	mov    0x34(%eax),%eax
  101c37:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c3b:	c7 04 24 62 3e 10 00 	movl   $0x103e62,(%esp)
  101c42:	e8 4d e6 ff ff       	call   100294 <cprintf>
    cprintf("  eip  0x%08x\n", tf->tf_eip);
  101c47:	8b 45 08             	mov    0x8(%ebp),%eax
  101c4a:	8b 40 38             	mov    0x38(%eax),%eax
  101c4d:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c51:	c7 04 24 71 3e 10 00 	movl   $0x103e71,(%esp)
  101c58:	e8 37 e6 ff ff       	call   100294 <cprintf>
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
  101c5d:	8b 45 08             	mov    0x8(%ebp),%eax
  101c60:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101c64:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c68:	c7 04 24 80 3e 10 00 	movl   $0x103e80,(%esp)
  101c6f:	e8 20 e6 ff ff       	call   100294 <cprintf>
    cprintf("  flag 0x%08x ", tf->tf_eflags);
  101c74:	8b 45 08             	mov    0x8(%ebp),%eax
  101c77:	8b 40 40             	mov    0x40(%eax),%eax
  101c7a:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c7e:	c7 04 24 93 3e 10 00 	movl   $0x103e93,(%esp)
  101c85:	e8 0a e6 ff ff       	call   100294 <cprintf>

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
  101c8a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  101c91:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
  101c98:	eb 3d                	jmp    101cd7 <print_trapframe+0x152>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
  101c9a:	8b 45 08             	mov    0x8(%ebp),%eax
  101c9d:	8b 50 40             	mov    0x40(%eax),%edx
  101ca0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  101ca3:	21 d0                	and    %edx,%eax
  101ca5:	85 c0                	test   %eax,%eax
  101ca7:	74 28                	je     101cd1 <print_trapframe+0x14c>
  101ca9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101cac:	8b 04 85 80 05 11 00 	mov    0x110580(,%eax,4),%eax
  101cb3:	85 c0                	test   %eax,%eax
  101cb5:	74 1a                	je     101cd1 <print_trapframe+0x14c>
            cprintf("%s,", IA32flags[i]);
  101cb7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101cba:	8b 04 85 80 05 11 00 	mov    0x110580(,%eax,4),%eax
  101cc1:	89 44 24 04          	mov    %eax,0x4(%esp)
  101cc5:	c7 04 24 a2 3e 10 00 	movl   $0x103ea2,(%esp)
  101ccc:	e8 c3 e5 ff ff       	call   100294 <cprintf>
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
  101cd1:	ff 45 f4             	incl   -0xc(%ebp)
  101cd4:	d1 65 f0             	shll   -0x10(%ebp)
  101cd7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101cda:	83 f8 17             	cmp    $0x17,%eax
  101cdd:	76 bb                	jbe    101c9a <print_trapframe+0x115>
        }
    }
    cprintf("IOPL=%d\n", (tf->tf_eflags & FL_IOPL_MASK) >> 12);
  101cdf:	8b 45 08             	mov    0x8(%ebp),%eax
  101ce2:	8b 40 40             	mov    0x40(%eax),%eax
  101ce5:	c1 e8 0c             	shr    $0xc,%eax
  101ce8:	83 e0 03             	and    $0x3,%eax
  101ceb:	89 44 24 04          	mov    %eax,0x4(%esp)
  101cef:	c7 04 24 a6 3e 10 00 	movl   $0x103ea6,(%esp)
  101cf6:	e8 99 e5 ff ff       	call   100294 <cprintf>

    if (!trap_in_kernel(tf)) {
  101cfb:	8b 45 08             	mov    0x8(%ebp),%eax
  101cfe:	89 04 24             	mov    %eax,(%esp)
  101d01:	e8 66 fe ff ff       	call   101b6c <trap_in_kernel>
  101d06:	85 c0                	test   %eax,%eax
  101d08:	75 2d                	jne    101d37 <print_trapframe+0x1b2>
        cprintf("  esp  0x%08x\n", tf->tf_esp);
  101d0a:	8b 45 08             	mov    0x8(%ebp),%eax
  101d0d:	8b 40 44             	mov    0x44(%eax),%eax
  101d10:	89 44 24 04          	mov    %eax,0x4(%esp)
  101d14:	c7 04 24 af 3e 10 00 	movl   $0x103eaf,(%esp)
  101d1b:	e8 74 e5 ff ff       	call   100294 <cprintf>
        cprintf("  ss   0x----%04x\n", tf->tf_ss);
  101d20:	8b 45 08             	mov    0x8(%ebp),%eax
  101d23:	0f b7 40 48          	movzwl 0x48(%eax),%eax
  101d27:	89 44 24 04          	mov    %eax,0x4(%esp)
  101d2b:	c7 04 24 be 3e 10 00 	movl   $0x103ebe,(%esp)
  101d32:	e8 5d e5 ff ff       	call   100294 <cprintf>
    }
}
  101d37:	90                   	nop
  101d38:	c9                   	leave  
  101d39:	c3                   	ret    

00101d3a <print_regs>:

void
print_regs(struct pushregs *regs) {
  101d3a:	f3 0f 1e fb          	endbr32 
  101d3e:	55                   	push   %ebp
  101d3f:	89 e5                	mov    %esp,%ebp
  101d41:	83 ec 18             	sub    $0x18,%esp
    cprintf("  edi  0x%08x\n", regs->reg_edi);
  101d44:	8b 45 08             	mov    0x8(%ebp),%eax
  101d47:	8b 00                	mov    (%eax),%eax
  101d49:	89 44 24 04          	mov    %eax,0x4(%esp)
  101d4d:	c7 04 24 d1 3e 10 00 	movl   $0x103ed1,(%esp)
  101d54:	e8 3b e5 ff ff       	call   100294 <cprintf>
    cprintf("  esi  0x%08x\n", regs->reg_esi);
  101d59:	8b 45 08             	mov    0x8(%ebp),%eax
  101d5c:	8b 40 04             	mov    0x4(%eax),%eax
  101d5f:	89 44 24 04          	mov    %eax,0x4(%esp)
  101d63:	c7 04 24 e0 3e 10 00 	movl   $0x103ee0,(%esp)
  101d6a:	e8 25 e5 ff ff       	call   100294 <cprintf>
    cprintf("  ebp  0x%08x\n", regs->reg_ebp);
  101d6f:	8b 45 08             	mov    0x8(%ebp),%eax
  101d72:	8b 40 08             	mov    0x8(%eax),%eax
  101d75:	89 44 24 04          	mov    %eax,0x4(%esp)
  101d79:	c7 04 24 ef 3e 10 00 	movl   $0x103eef,(%esp)
  101d80:	e8 0f e5 ff ff       	call   100294 <cprintf>
    cprintf("  oesp 0x%08x\n", regs->reg_oesp);
  101d85:	8b 45 08             	mov    0x8(%ebp),%eax
  101d88:	8b 40 0c             	mov    0xc(%eax),%eax
  101d8b:	89 44 24 04          	mov    %eax,0x4(%esp)
  101d8f:	c7 04 24 fe 3e 10 00 	movl   $0x103efe,(%esp)
  101d96:	e8 f9 e4 ff ff       	call   100294 <cprintf>
    cprintf("  ebx  0x%08x\n", regs->reg_ebx);
  101d9b:	8b 45 08             	mov    0x8(%ebp),%eax
  101d9e:	8b 40 10             	mov    0x10(%eax),%eax
  101da1:	89 44 24 04          	mov    %eax,0x4(%esp)
  101da5:	c7 04 24 0d 3f 10 00 	movl   $0x103f0d,(%esp)
  101dac:	e8 e3 e4 ff ff       	call   100294 <cprintf>
    cprintf("  edx  0x%08x\n", regs->reg_edx);
  101db1:	8b 45 08             	mov    0x8(%ebp),%eax
  101db4:	8b 40 14             	mov    0x14(%eax),%eax
  101db7:	89 44 24 04          	mov    %eax,0x4(%esp)
  101dbb:	c7 04 24 1c 3f 10 00 	movl   $0x103f1c,(%esp)
  101dc2:	e8 cd e4 ff ff       	call   100294 <cprintf>
    cprintf("  ecx  0x%08x\n", regs->reg_ecx);
  101dc7:	8b 45 08             	mov    0x8(%ebp),%eax
  101dca:	8b 40 18             	mov    0x18(%eax),%eax
  101dcd:	89 44 24 04          	mov    %eax,0x4(%esp)
  101dd1:	c7 04 24 2b 3f 10 00 	movl   $0x103f2b,(%esp)
  101dd8:	e8 b7 e4 ff ff       	call   100294 <cprintf>
    cprintf("  eax  0x%08x\n", regs->reg_eax);
  101ddd:	8b 45 08             	mov    0x8(%ebp),%eax
  101de0:	8b 40 1c             	mov    0x1c(%eax),%eax
  101de3:	89 44 24 04          	mov    %eax,0x4(%esp)
  101de7:	c7 04 24 3a 3f 10 00 	movl   $0x103f3a,(%esp)
  101dee:	e8 a1 e4 ff ff       	call   100294 <cprintf>
}
  101df3:	90                   	nop
  101df4:	c9                   	leave  
  101df5:	c3                   	ret    

00101df6 <trap_dispatch>:
/* temporary trapframe or pointer to trapframe */
struct trapframe switchk2u, *switchu2k;

/* trap_dispatch - dispatch based on what type of trap occurred */
static void
trap_dispatch(struct trapframe *tf) {
  101df6:	f3 0f 1e fb          	endbr32 
  101dfa:	55                   	push   %ebp
  101dfb:	89 e5                	mov    %esp,%ebp
  101dfd:	57                   	push   %edi
  101dfe:	56                   	push   %esi
  101dff:	53                   	push   %ebx
  101e00:	83 ec 2c             	sub    $0x2c,%esp
    char c;

    switch (tf->tf_trapno) {
  101e03:	8b 45 08             	mov    0x8(%ebp),%eax
  101e06:	8b 40 30             	mov    0x30(%eax),%eax
  101e09:	83 f8 79             	cmp    $0x79,%eax
  101e0c:	0f 84 87 03 00 00    	je     102199 <trap_dispatch+0x3a3>
  101e12:	83 f8 79             	cmp    $0x79,%eax
  101e15:	0f 87 12 04 00 00    	ja     10222d <trap_dispatch+0x437>
  101e1b:	83 f8 78             	cmp    $0x78,%eax
  101e1e:	0f 84 8d 02 00 00    	je     1020b1 <trap_dispatch+0x2bb>
  101e24:	83 f8 78             	cmp    $0x78,%eax
  101e27:	0f 87 00 04 00 00    	ja     10222d <trap_dispatch+0x437>
  101e2d:	83 f8 2f             	cmp    $0x2f,%eax
  101e30:	0f 87 f7 03 00 00    	ja     10222d <trap_dispatch+0x437>
  101e36:	83 f8 2e             	cmp    $0x2e,%eax
  101e39:	0f 83 23 04 00 00    	jae    102262 <trap_dispatch+0x46c>
  101e3f:	83 f8 24             	cmp    $0x24,%eax
  101e42:	74 5e                	je     101ea2 <trap_dispatch+0xac>
  101e44:	83 f8 24             	cmp    $0x24,%eax
  101e47:	0f 87 e0 03 00 00    	ja     10222d <trap_dispatch+0x437>
  101e4d:	83 f8 20             	cmp    $0x20,%eax
  101e50:	74 0a                	je     101e5c <trap_dispatch+0x66>
  101e52:	83 f8 21             	cmp    $0x21,%eax
  101e55:	74 74                	je     101ecb <trap_dispatch+0xd5>
  101e57:	e9 d1 03 00 00       	jmp    10222d <trap_dispatch+0x437>
        /* handle the timer interrupt */
        /* (1) After a timer interrupt, you should record this event using a global variable (increase it), such as ticks in kern/driver/clock.c
         * (2) Every TICK_NUM cycle, you can print some info using a funciton, such as print_ticks().
         * (3) Too Simple? Yes, I think so!
         */
        ticks ++;
  101e5c:	a1 08 19 11 00       	mov    0x111908,%eax
  101e61:	40                   	inc    %eax
  101e62:	a3 08 19 11 00       	mov    %eax,0x111908
        if (ticks % TICK_NUM == 0) {
  101e67:	8b 0d 08 19 11 00    	mov    0x111908,%ecx
  101e6d:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
  101e72:	89 c8                	mov    %ecx,%eax
  101e74:	f7 e2                	mul    %edx
  101e76:	c1 ea 05             	shr    $0x5,%edx
  101e79:	89 d0                	mov    %edx,%eax
  101e7b:	c1 e0 02             	shl    $0x2,%eax
  101e7e:	01 d0                	add    %edx,%eax
  101e80:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  101e87:	01 d0                	add    %edx,%eax
  101e89:	c1 e0 02             	shl    $0x2,%eax
  101e8c:	29 c1                	sub    %eax,%ecx
  101e8e:	89 ca                	mov    %ecx,%edx
  101e90:	85 d2                	test   %edx,%edx
  101e92:	0f 85 cd 03 00 00    	jne    102265 <trap_dispatch+0x46f>
            print_ticks();
  101e98:	e8 63 fa ff ff       	call   101900 <print_ticks>
        }
        break;
  101e9d:	e9 c3 03 00 00       	jmp    102265 <trap_dispatch+0x46f>
    case IRQ_OFFSET + IRQ_COM1:
        c = cons_getc();
  101ea2:	e8 ff f7 ff ff       	call   1016a6 <cons_getc>
  101ea7:	88 45 e7             	mov    %al,-0x19(%ebp)
        cprintf("serial [%03d] %c\n", c, c);
  101eaa:	0f be 55 e7          	movsbl -0x19(%ebp),%edx
  101eae:	0f be 45 e7          	movsbl -0x19(%ebp),%eax
  101eb2:	89 54 24 08          	mov    %edx,0x8(%esp)
  101eb6:	89 44 24 04          	mov    %eax,0x4(%esp)
  101eba:	c7 04 24 49 3f 10 00 	movl   $0x103f49,(%esp)
  101ec1:	e8 ce e3 ff ff       	call   100294 <cprintf>
        break;
  101ec6:	e9 a4 03 00 00       	jmp    10226f <trap_dispatch+0x479>
    case IRQ_OFFSET + IRQ_KBD:
        c = cons_getc();
  101ecb:	e8 d6 f7 ff ff       	call   1016a6 <cons_getc>
  101ed0:	88 45 e7             	mov    %al,-0x19(%ebp)
        if(c == 48){
  101ed3:	80 7d e7 30          	cmpb   $0x30,-0x19(%ebp)
  101ed7:	0f 85 b3 00 00 00    	jne    101f90 <trap_dispatch+0x19a>
            cprintf("kbd [%03d] %c\n", c, c);
  101edd:	0f be 55 e7          	movsbl -0x19(%ebp),%edx
  101ee1:	0f be 45 e7          	movsbl -0x19(%ebp),%eax
  101ee5:	89 54 24 08          	mov    %edx,0x8(%esp)
  101ee9:	89 44 24 04          	mov    %eax,0x4(%esp)
  101eed:	c7 04 24 5b 3f 10 00 	movl   $0x103f5b,(%esp)
  101ef4:	e8 9b e3 ff ff       	call   100294 <cprintf>
            if (tf->tf_cs != KERNEL_CS) {
  101ef9:	8b 45 08             	mov    0x8(%ebp),%eax
  101efc:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101f00:	83 f8 08             	cmp    $0x8,%eax
  101f03:	0f 84 66 03 00 00    	je     10226f <trap_dispatch+0x479>
            tf->tf_cs = KERNEL_CS;
  101f09:	8b 45 08             	mov    0x8(%ebp),%eax
  101f0c:	66 c7 40 3c 08 00    	movw   $0x8,0x3c(%eax)
            tf->tf_ds = tf->tf_es = KERNEL_DS;
  101f12:	8b 45 08             	mov    0x8(%ebp),%eax
  101f15:	66 c7 40 28 10 00    	movw   $0x10,0x28(%eax)
  101f1b:	8b 45 08             	mov    0x8(%ebp),%eax
  101f1e:	0f b7 50 28          	movzwl 0x28(%eax),%edx
  101f22:	8b 45 08             	mov    0x8(%ebp),%eax
  101f25:	66 89 50 2c          	mov    %dx,0x2c(%eax)
            tf->tf_eflags &= ~FL_IOPL_MASK;
  101f29:	8b 45 08             	mov    0x8(%ebp),%eax
  101f2c:	8b 40 40             	mov    0x40(%eax),%eax
  101f2f:	25 ff cf ff ff       	and    $0xffffcfff,%eax
  101f34:	89 c2                	mov    %eax,%edx
  101f36:	8b 45 08             	mov    0x8(%ebp),%eax
  101f39:	89 50 40             	mov    %edx,0x40(%eax)
            switchu2k = (struct trapframe *)(tf->tf_esp - (sizeof(struct trapframe) - 8));
  101f3c:	8b 45 08             	mov    0x8(%ebp),%eax
  101f3f:	8b 40 44             	mov    0x44(%eax),%eax
  101f42:	83 e8 44             	sub    $0x44,%eax
  101f45:	a3 6c 19 11 00       	mov    %eax,0x11196c
            memmove(switchu2k, tf, sizeof(struct trapframe) - 8);
  101f4a:	a1 6c 19 11 00       	mov    0x11196c,%eax
  101f4f:	c7 44 24 08 44 00 00 	movl   $0x44,0x8(%esp)
  101f56:	00 
  101f57:	8b 55 08             	mov    0x8(%ebp),%edx
  101f5a:	89 54 24 04          	mov    %edx,0x4(%esp)
  101f5e:	89 04 24             	mov    %eax,(%esp)
  101f61:	e8 a5 12 00 00       	call   10320b <memmove>
            *((uint32_t *)tf - 1) = (uint32_t)switchu2k;
  101f66:	8b 15 6c 19 11 00    	mov    0x11196c,%edx
  101f6c:	8b 45 08             	mov    0x8(%ebp),%eax
  101f6f:	83 e8 04             	sub    $0x4,%eax
  101f72:	89 10                	mov    %edx,(%eax)
            cprintf("+++ switch to kernel mode +++\n");
  101f74:	c7 04 24 6c 3f 10 00 	movl   $0x103f6c,(%esp)
  101f7b:	e8 14 e3 ff ff       	call   100294 <cprintf>
            print_trapframe(tf);
  101f80:	8b 45 08             	mov    0x8(%ebp),%eax
  101f83:	89 04 24             	mov    %eax,(%esp)
  101f86:	e8 fa fb ff ff       	call   101b85 <print_trapframe>
            print_trapframe(tf);
            panic("unexpected trap in kernel.\n");
        }
    }
}
}
  101f8b:	e9 df 02 00 00       	jmp    10226f <trap_dispatch+0x479>
        else if(c == 51){
  101f90:	80 7d e7 33          	cmpb   $0x33,-0x19(%ebp)
  101f94:	0f 85 d5 02 00 00    	jne    10226f <trap_dispatch+0x479>
            if (tf->tf_cs != USER_CS) {
  101f9a:	8b 45 08             	mov    0x8(%ebp),%eax
  101f9d:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101fa1:	83 f8 1b             	cmp    $0x1b,%eax
  101fa4:	0f 84 be 02 00 00    	je     102268 <trap_dispatch+0x472>
            cprintf("kbd [%03d] %c\n", c, c);
  101faa:	0f be 55 e7          	movsbl -0x19(%ebp),%edx
  101fae:	0f be 45 e7          	movsbl -0x19(%ebp),%eax
  101fb2:	89 54 24 08          	mov    %edx,0x8(%esp)
  101fb6:	89 44 24 04          	mov    %eax,0x4(%esp)
  101fba:	c7 04 24 5b 3f 10 00 	movl   $0x103f5b,(%esp)
  101fc1:	e8 ce e2 ff ff       	call   100294 <cprintf>
            switchk2u = *tf;
  101fc6:	8b 55 08             	mov    0x8(%ebp),%edx
  101fc9:	b8 20 19 11 00       	mov    $0x111920,%eax
  101fce:	bb 4c 00 00 00       	mov    $0x4c,%ebx
  101fd3:	89 c1                	mov    %eax,%ecx
  101fd5:	83 e1 01             	and    $0x1,%ecx
  101fd8:	85 c9                	test   %ecx,%ecx
  101fda:	74 0c                	je     101fe8 <trap_dispatch+0x1f2>
  101fdc:	0f b6 0a             	movzbl (%edx),%ecx
  101fdf:	88 08                	mov    %cl,(%eax)
  101fe1:	8d 40 01             	lea    0x1(%eax),%eax
  101fe4:	8d 52 01             	lea    0x1(%edx),%edx
  101fe7:	4b                   	dec    %ebx
  101fe8:	89 c1                	mov    %eax,%ecx
  101fea:	83 e1 02             	and    $0x2,%ecx
  101fed:	85 c9                	test   %ecx,%ecx
  101fef:	74 0f                	je     102000 <trap_dispatch+0x20a>
  101ff1:	0f b7 0a             	movzwl (%edx),%ecx
  101ff4:	66 89 08             	mov    %cx,(%eax)
  101ff7:	8d 40 02             	lea    0x2(%eax),%eax
  101ffa:	8d 52 02             	lea    0x2(%edx),%edx
  101ffd:	83 eb 02             	sub    $0x2,%ebx
  102000:	89 df                	mov    %ebx,%edi
  102002:	83 e7 fc             	and    $0xfffffffc,%edi
  102005:	b9 00 00 00 00       	mov    $0x0,%ecx
  10200a:	8b 34 0a             	mov    (%edx,%ecx,1),%esi
  10200d:	89 34 08             	mov    %esi,(%eax,%ecx,1)
  102010:	83 c1 04             	add    $0x4,%ecx
  102013:	39 f9                	cmp    %edi,%ecx
  102015:	72 f3                	jb     10200a <trap_dispatch+0x214>
  102017:	01 c8                	add    %ecx,%eax
  102019:	01 ca                	add    %ecx,%edx
  10201b:	b9 00 00 00 00       	mov    $0x0,%ecx
  102020:	89 de                	mov    %ebx,%esi
  102022:	83 e6 02             	and    $0x2,%esi
  102025:	85 f6                	test   %esi,%esi
  102027:	74 0b                	je     102034 <trap_dispatch+0x23e>
  102029:	0f b7 34 0a          	movzwl (%edx,%ecx,1),%esi
  10202d:	66 89 34 08          	mov    %si,(%eax,%ecx,1)
  102031:	83 c1 02             	add    $0x2,%ecx
  102034:	83 e3 01             	and    $0x1,%ebx
  102037:	85 db                	test   %ebx,%ebx
  102039:	74 07                	je     102042 <trap_dispatch+0x24c>
  10203b:	0f b6 14 0a          	movzbl (%edx,%ecx,1),%edx
  10203f:	88 14 08             	mov    %dl,(%eax,%ecx,1)
            switchk2u.tf_cs = USER_CS;
  102042:	66 c7 05 5c 19 11 00 	movw   $0x1b,0x11195c
  102049:	1b 00 
            switchk2u.tf_ds = switchk2u.tf_es = switchk2u.tf_ss = USER_DS;
  10204b:	66 c7 05 68 19 11 00 	movw   $0x23,0x111968
  102052:	23 00 
  102054:	0f b7 05 68 19 11 00 	movzwl 0x111968,%eax
  10205b:	66 a3 48 19 11 00    	mov    %ax,0x111948
  102061:	0f b7 05 48 19 11 00 	movzwl 0x111948,%eax
  102068:	66 a3 4c 19 11 00    	mov    %ax,0x11194c
            switchk2u.tf_esp = (uint32_t)tf + sizeof(struct trapframe) - 8;
  10206e:	8b 45 08             	mov    0x8(%ebp),%eax
  102071:	83 c0 44             	add    $0x44,%eax
  102074:	a3 64 19 11 00       	mov    %eax,0x111964
            switchk2u.tf_eflags |= FL_IOPL_MASK;
  102079:	a1 60 19 11 00       	mov    0x111960,%eax
  10207e:	0d 00 30 00 00       	or     $0x3000,%eax
  102083:	a3 60 19 11 00       	mov    %eax,0x111960
            *((uint32_t *)tf - 1) = (uint32_t)&switchk2u;
  102088:	8b 45 08             	mov    0x8(%ebp),%eax
  10208b:	83 e8 04             	sub    $0x4,%eax
  10208e:	ba 20 19 11 00       	mov    $0x111920,%edx
  102093:	89 10                	mov    %edx,(%eax)
            cprintf("+++ switch to user mode +++\n");
  102095:	c7 04 24 8b 3f 10 00 	movl   $0x103f8b,(%esp)
  10209c:	e8 f3 e1 ff ff       	call   100294 <cprintf>
            print_trapframe(tf);
  1020a1:	8b 45 08             	mov    0x8(%ebp),%eax
  1020a4:	89 04 24             	mov    %eax,(%esp)
  1020a7:	e8 d9 fa ff ff       	call   101b85 <print_trapframe>
        break;
  1020ac:	e9 b7 01 00 00       	jmp    102268 <trap_dispatch+0x472>
    if (tf->tf_cs != USER_CS) {
  1020b1:	8b 45 08             	mov    0x8(%ebp),%eax
  1020b4:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  1020b8:	83 f8 1b             	cmp    $0x1b,%eax
  1020bb:	0f 84 aa 01 00 00    	je     10226b <trap_dispatch+0x475>
            switchk2u = *tf;
  1020c1:	8b 55 08             	mov    0x8(%ebp),%edx
  1020c4:	b8 20 19 11 00       	mov    $0x111920,%eax
  1020c9:	bb 4c 00 00 00       	mov    $0x4c,%ebx
  1020ce:	89 c1                	mov    %eax,%ecx
  1020d0:	83 e1 01             	and    $0x1,%ecx
  1020d3:	85 c9                	test   %ecx,%ecx
  1020d5:	74 0c                	je     1020e3 <trap_dispatch+0x2ed>
  1020d7:	0f b6 0a             	movzbl (%edx),%ecx
  1020da:	88 08                	mov    %cl,(%eax)
  1020dc:	8d 40 01             	lea    0x1(%eax),%eax
  1020df:	8d 52 01             	lea    0x1(%edx),%edx
  1020e2:	4b                   	dec    %ebx
  1020e3:	89 c1                	mov    %eax,%ecx
  1020e5:	83 e1 02             	and    $0x2,%ecx
  1020e8:	85 c9                	test   %ecx,%ecx
  1020ea:	74 0f                	je     1020fb <trap_dispatch+0x305>
  1020ec:	0f b7 0a             	movzwl (%edx),%ecx
  1020ef:	66 89 08             	mov    %cx,(%eax)
  1020f2:	8d 40 02             	lea    0x2(%eax),%eax
  1020f5:	8d 52 02             	lea    0x2(%edx),%edx
  1020f8:	83 eb 02             	sub    $0x2,%ebx
  1020fb:	89 df                	mov    %ebx,%edi
  1020fd:	83 e7 fc             	and    $0xfffffffc,%edi
  102100:	b9 00 00 00 00       	mov    $0x0,%ecx
  102105:	8b 34 0a             	mov    (%edx,%ecx,1),%esi
  102108:	89 34 08             	mov    %esi,(%eax,%ecx,1)
  10210b:	83 c1 04             	add    $0x4,%ecx
  10210e:	39 f9                	cmp    %edi,%ecx
  102110:	72 f3                	jb     102105 <trap_dispatch+0x30f>
  102112:	01 c8                	add    %ecx,%eax
  102114:	01 ca                	add    %ecx,%edx
  102116:	b9 00 00 00 00       	mov    $0x0,%ecx
  10211b:	89 de                	mov    %ebx,%esi
  10211d:	83 e6 02             	and    $0x2,%esi
  102120:	85 f6                	test   %esi,%esi
  102122:	74 0b                	je     10212f <trap_dispatch+0x339>
  102124:	0f b7 34 0a          	movzwl (%edx,%ecx,1),%esi
  102128:	66 89 34 08          	mov    %si,(%eax,%ecx,1)
  10212c:	83 c1 02             	add    $0x2,%ecx
  10212f:	83 e3 01             	and    $0x1,%ebx
  102132:	85 db                	test   %ebx,%ebx
  102134:	74 07                	je     10213d <trap_dispatch+0x347>
  102136:	0f b6 14 0a          	movzbl (%edx,%ecx,1),%edx
  10213a:	88 14 08             	mov    %dl,(%eax,%ecx,1)
            switchk2u.tf_cs = USER_CS;
  10213d:	66 c7 05 5c 19 11 00 	movw   $0x1b,0x11195c
  102144:	1b 00 
            switchk2u.tf_ds = USER_DS;
  102146:	66 c7 05 4c 19 11 00 	movw   $0x23,0x11194c
  10214d:	23 00 
            switchk2u.tf_es = USER_DS;
  10214f:	66 c7 05 48 19 11 00 	movw   $0x23,0x111948
  102156:	23 00 
            switchk2u.tf_ss = USER_DS;
  102158:	66 c7 05 68 19 11 00 	movw   $0x23,0x111968
  10215f:	23 00 
            switchk2u.tf_esp = (uint32_t)tf + sizeof(struct trapframe) - 8;
  102161:	8b 45 08             	mov    0x8(%ebp),%eax
  102164:	83 c0 44             	add    $0x44,%eax
  102167:	a3 64 19 11 00       	mov    %eax,0x111964
            switchk2u.tf_eflags |= FL_IOPL_MASK;
  10216c:	a1 60 19 11 00       	mov    0x111960,%eax
  102171:	0d 00 30 00 00       	or     $0x3000,%eax
  102176:	a3 60 19 11 00       	mov    %eax,0x111960
            *((uint32_t *)tf - 1) = (uint32_t)&switchk2u;
  10217b:	8b 45 08             	mov    0x8(%ebp),%eax
  10217e:	83 e8 04             	sub    $0x4,%eax
  102181:	ba 20 19 11 00       	mov    $0x111920,%edx
  102186:	89 10                	mov    %edx,(%eax)
            print_trapframe(&switchk2u);
  102188:	c7 04 24 20 19 11 00 	movl   $0x111920,(%esp)
  10218f:	e8 f1 f9 ff ff       	call   101b85 <print_trapframe>
        break;
  102194:	e9 d2 00 00 00       	jmp    10226b <trap_dispatch+0x475>
    print_trapframe(tf);
  102199:	8b 45 08             	mov    0x8(%ebp),%eax
  10219c:	89 04 24             	mov    %eax,(%esp)
  10219f:	e8 e1 f9 ff ff       	call   101b85 <print_trapframe>
    if (tf->tf_cs != KERNEL_CS) {
  1021a4:	8b 45 08             	mov    0x8(%ebp),%eax
  1021a7:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  1021ab:	83 f8 08             	cmp    $0x8,%eax
  1021ae:	0f 84 ba 00 00 00    	je     10226e <trap_dispatch+0x478>
            tf->tf_cs = KERNEL_CS;
  1021b4:	8b 45 08             	mov    0x8(%ebp),%eax
  1021b7:	66 c7 40 3c 08 00    	movw   $0x8,0x3c(%eax)
            tf->tf_ds = tf->tf_es = KERNEL_DS;
  1021bd:	8b 45 08             	mov    0x8(%ebp),%eax
  1021c0:	66 c7 40 28 10 00    	movw   $0x10,0x28(%eax)
  1021c6:	8b 45 08             	mov    0x8(%ebp),%eax
  1021c9:	0f b7 50 28          	movzwl 0x28(%eax),%edx
  1021cd:	8b 45 08             	mov    0x8(%ebp),%eax
  1021d0:	66 89 50 2c          	mov    %dx,0x2c(%eax)
            tf->tf_eflags &= ~FL_IOPL_MASK;
  1021d4:	8b 45 08             	mov    0x8(%ebp),%eax
  1021d7:	8b 40 40             	mov    0x40(%eax),%eax
  1021da:	25 ff cf ff ff       	and    $0xffffcfff,%eax
  1021df:	89 c2                	mov    %eax,%edx
  1021e1:	8b 45 08             	mov    0x8(%ebp),%eax
  1021e4:	89 50 40             	mov    %edx,0x40(%eax)
            switchu2k = (struct trapframe *)(tf->tf_esp - (sizeof(struct trapframe) - 8));
  1021e7:	8b 45 08             	mov    0x8(%ebp),%eax
  1021ea:	8b 40 44             	mov    0x44(%eax),%eax
  1021ed:	83 e8 44             	sub    $0x44,%eax
  1021f0:	a3 6c 19 11 00       	mov    %eax,0x11196c
            memmove(switchu2k, tf, sizeof(struct trapframe) - 8);
  1021f5:	a1 6c 19 11 00       	mov    0x11196c,%eax
  1021fa:	c7 44 24 08 44 00 00 	movl   $0x44,0x8(%esp)
  102201:	00 
  102202:	8b 55 08             	mov    0x8(%ebp),%edx
  102205:	89 54 24 04          	mov    %edx,0x4(%esp)
  102209:	89 04 24             	mov    %eax,(%esp)
  10220c:	e8 fa 0f 00 00       	call   10320b <memmove>
            *((uint32_t *)tf - 1) = (uint32_t)switchu2k;
  102211:	8b 15 6c 19 11 00    	mov    0x11196c,%edx
  102217:	8b 45 08             	mov    0x8(%ebp),%eax
  10221a:	83 e8 04             	sub    $0x4,%eax
  10221d:	89 10                	mov    %edx,(%eax)
            print_trapframe(&switchu2k);
  10221f:	c7 04 24 6c 19 11 00 	movl   $0x11196c,(%esp)
  102226:	e8 5a f9 ff ff       	call   101b85 <print_trapframe>
        break;
  10222b:	eb 41                	jmp    10226e <trap_dispatch+0x478>
        if ((tf->tf_cs & 3) == 0) {
  10222d:	8b 45 08             	mov    0x8(%ebp),%eax
  102230:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  102234:	83 e0 03             	and    $0x3,%eax
  102237:	85 c0                	test   %eax,%eax
  102239:	75 34                	jne    10226f <trap_dispatch+0x479>
            print_trapframe(tf);
  10223b:	8b 45 08             	mov    0x8(%ebp),%eax
  10223e:	89 04 24             	mov    %eax,(%esp)
  102241:	e8 3f f9 ff ff       	call   101b85 <print_trapframe>
            panic("unexpected trap in kernel.\n");
  102246:	c7 44 24 08 a8 3f 10 	movl   $0x103fa8,0x8(%esp)
  10224d:	00 
  10224e:	c7 44 24 04 fe 00 00 	movl   $0xfe,0x4(%esp)
  102255:	00 
  102256:	c7 04 24 8e 3d 10 00 	movl   $0x103d8e,(%esp)
  10225d:	e8 9e e1 ff ff       	call   100400 <__panic>
        break;
  102262:	90                   	nop
  102263:	eb 0a                	jmp    10226f <trap_dispatch+0x479>
        break;
  102265:	90                   	nop
  102266:	eb 07                	jmp    10226f <trap_dispatch+0x479>
        break;
  102268:	90                   	nop
  102269:	eb 04                	jmp    10226f <trap_dispatch+0x479>
        break;
  10226b:	90                   	nop
  10226c:	eb 01                	jmp    10226f <trap_dispatch+0x479>
        break;
  10226e:	90                   	nop
}
  10226f:	90                   	nop
  102270:	83 c4 2c             	add    $0x2c,%esp
  102273:	5b                   	pop    %ebx
  102274:	5e                   	pop    %esi
  102275:	5f                   	pop    %edi
  102276:	5d                   	pop    %ebp
  102277:	c3                   	ret    

00102278 <trap>:
 * trap - handles or dispatches an exception/interrupt. if and when trap() returns,
 * the code in kern/trap/trapentry.S restores the old CPU state saved in the
 * trapframe and then uses the iret instruction to return from the exception.
 * */
void
trap(struct trapframe *tf) {
  102278:	f3 0f 1e fb          	endbr32 
  10227c:	55                   	push   %ebp
  10227d:	89 e5                	mov    %esp,%ebp
  10227f:	83 ec 18             	sub    $0x18,%esp
    // dispatch based on what type of trap occurred
    trap_dispatch(tf);
  102282:	8b 45 08             	mov    0x8(%ebp),%eax
  102285:	89 04 24             	mov    %eax,(%esp)
  102288:	e8 69 fb ff ff       	call   101df6 <trap_dispatch>
}
  10228d:	90                   	nop
  10228e:	c9                   	leave  
  10228f:	c3                   	ret    

00102290 <switch_to_user>:

void
switch_to_user(void) {
  102290:	f3 0f 1e fb          	endbr32 
  102294:	55                   	push   %ebp
  102295:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 : TODO
    asm volatile (
  102297:	83 ec 08             	sub    $0x8,%esp
  10229a:	cd 78                	int    $0x78
  10229c:	89 ec                	mov    %ebp,%esp
	    "int %0 \n"
	    "movl %%ebp, %%esp"
	    : 
	    : "i"(T_SWITCH_TOU)
	);
}
  10229e:	90                   	nop
  10229f:	5d                   	pop    %ebp
  1022a0:	c3                   	ret    

001022a1 <switch_to_kernel>:

void
switch_to_kernel(void) {
  1022a1:	f3 0f 1e fb          	endbr32 
  1022a5:	55                   	push   %ebp
  1022a6:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 :  TODO
    asm volatile (
  1022a8:	cd 79                	int    $0x79
  1022aa:	89 ec                	mov    %ebp,%esp
	    "int %0 \n"
	    "movl %%ebp, %%esp \n"
	    : 
	    : "i"(T_SWITCH_TOK)
	);
  1022ac:	90                   	nop
  1022ad:	5d                   	pop    %ebp
  1022ae:	c3                   	ret    

001022af <vector0>:
# handler
.text
.globl __alltraps
.globl vector0
vector0:
  pushl $0
  1022af:	6a 00                	push   $0x0
  pushl $0
  1022b1:	6a 00                	push   $0x0
  jmp __alltraps
  1022b3:	e9 69 0a 00 00       	jmp    102d21 <__alltraps>

001022b8 <vector1>:
.globl vector1
vector1:
  pushl $0
  1022b8:	6a 00                	push   $0x0
  pushl $1
  1022ba:	6a 01                	push   $0x1
  jmp __alltraps
  1022bc:	e9 60 0a 00 00       	jmp    102d21 <__alltraps>

001022c1 <vector2>:
.globl vector2
vector2:
  pushl $0
  1022c1:	6a 00                	push   $0x0
  pushl $2
  1022c3:	6a 02                	push   $0x2
  jmp __alltraps
  1022c5:	e9 57 0a 00 00       	jmp    102d21 <__alltraps>

001022ca <vector3>:
.globl vector3
vector3:
  pushl $0
  1022ca:	6a 00                	push   $0x0
  pushl $3
  1022cc:	6a 03                	push   $0x3
  jmp __alltraps
  1022ce:	e9 4e 0a 00 00       	jmp    102d21 <__alltraps>

001022d3 <vector4>:
.globl vector4
vector4:
  pushl $0
  1022d3:	6a 00                	push   $0x0
  pushl $4
  1022d5:	6a 04                	push   $0x4
  jmp __alltraps
  1022d7:	e9 45 0a 00 00       	jmp    102d21 <__alltraps>

001022dc <vector5>:
.globl vector5
vector5:
  pushl $0
  1022dc:	6a 00                	push   $0x0
  pushl $5
  1022de:	6a 05                	push   $0x5
  jmp __alltraps
  1022e0:	e9 3c 0a 00 00       	jmp    102d21 <__alltraps>

001022e5 <vector6>:
.globl vector6
vector6:
  pushl $0
  1022e5:	6a 00                	push   $0x0
  pushl $6
  1022e7:	6a 06                	push   $0x6
  jmp __alltraps
  1022e9:	e9 33 0a 00 00       	jmp    102d21 <__alltraps>

001022ee <vector7>:
.globl vector7
vector7:
  pushl $0
  1022ee:	6a 00                	push   $0x0
  pushl $7
  1022f0:	6a 07                	push   $0x7
  jmp __alltraps
  1022f2:	e9 2a 0a 00 00       	jmp    102d21 <__alltraps>

001022f7 <vector8>:
.globl vector8
vector8:
  pushl $8
  1022f7:	6a 08                	push   $0x8
  jmp __alltraps
  1022f9:	e9 23 0a 00 00       	jmp    102d21 <__alltraps>

001022fe <vector9>:
.globl vector9
vector9:
  pushl $0
  1022fe:	6a 00                	push   $0x0
  pushl $9
  102300:	6a 09                	push   $0x9
  jmp __alltraps
  102302:	e9 1a 0a 00 00       	jmp    102d21 <__alltraps>

00102307 <vector10>:
.globl vector10
vector10:
  pushl $10
  102307:	6a 0a                	push   $0xa
  jmp __alltraps
  102309:	e9 13 0a 00 00       	jmp    102d21 <__alltraps>

0010230e <vector11>:
.globl vector11
vector11:
  pushl $11
  10230e:	6a 0b                	push   $0xb
  jmp __alltraps
  102310:	e9 0c 0a 00 00       	jmp    102d21 <__alltraps>

00102315 <vector12>:
.globl vector12
vector12:
  pushl $12
  102315:	6a 0c                	push   $0xc
  jmp __alltraps
  102317:	e9 05 0a 00 00       	jmp    102d21 <__alltraps>

0010231c <vector13>:
.globl vector13
vector13:
  pushl $13
  10231c:	6a 0d                	push   $0xd
  jmp __alltraps
  10231e:	e9 fe 09 00 00       	jmp    102d21 <__alltraps>

00102323 <vector14>:
.globl vector14
vector14:
  pushl $14
  102323:	6a 0e                	push   $0xe
  jmp __alltraps
  102325:	e9 f7 09 00 00       	jmp    102d21 <__alltraps>

0010232a <vector15>:
.globl vector15
vector15:
  pushl $0
  10232a:	6a 00                	push   $0x0
  pushl $15
  10232c:	6a 0f                	push   $0xf
  jmp __alltraps
  10232e:	e9 ee 09 00 00       	jmp    102d21 <__alltraps>

00102333 <vector16>:
.globl vector16
vector16:
  pushl $0
  102333:	6a 00                	push   $0x0
  pushl $16
  102335:	6a 10                	push   $0x10
  jmp __alltraps
  102337:	e9 e5 09 00 00       	jmp    102d21 <__alltraps>

0010233c <vector17>:
.globl vector17
vector17:
  pushl $17
  10233c:	6a 11                	push   $0x11
  jmp __alltraps
  10233e:	e9 de 09 00 00       	jmp    102d21 <__alltraps>

00102343 <vector18>:
.globl vector18
vector18:
  pushl $0
  102343:	6a 00                	push   $0x0
  pushl $18
  102345:	6a 12                	push   $0x12
  jmp __alltraps
  102347:	e9 d5 09 00 00       	jmp    102d21 <__alltraps>

0010234c <vector19>:
.globl vector19
vector19:
  pushl $0
  10234c:	6a 00                	push   $0x0
  pushl $19
  10234e:	6a 13                	push   $0x13
  jmp __alltraps
  102350:	e9 cc 09 00 00       	jmp    102d21 <__alltraps>

00102355 <vector20>:
.globl vector20
vector20:
  pushl $0
  102355:	6a 00                	push   $0x0
  pushl $20
  102357:	6a 14                	push   $0x14
  jmp __alltraps
  102359:	e9 c3 09 00 00       	jmp    102d21 <__alltraps>

0010235e <vector21>:
.globl vector21
vector21:
  pushl $0
  10235e:	6a 00                	push   $0x0
  pushl $21
  102360:	6a 15                	push   $0x15
  jmp __alltraps
  102362:	e9 ba 09 00 00       	jmp    102d21 <__alltraps>

00102367 <vector22>:
.globl vector22
vector22:
  pushl $0
  102367:	6a 00                	push   $0x0
  pushl $22
  102369:	6a 16                	push   $0x16
  jmp __alltraps
  10236b:	e9 b1 09 00 00       	jmp    102d21 <__alltraps>

00102370 <vector23>:
.globl vector23
vector23:
  pushl $0
  102370:	6a 00                	push   $0x0
  pushl $23
  102372:	6a 17                	push   $0x17
  jmp __alltraps
  102374:	e9 a8 09 00 00       	jmp    102d21 <__alltraps>

00102379 <vector24>:
.globl vector24
vector24:
  pushl $0
  102379:	6a 00                	push   $0x0
  pushl $24
  10237b:	6a 18                	push   $0x18
  jmp __alltraps
  10237d:	e9 9f 09 00 00       	jmp    102d21 <__alltraps>

00102382 <vector25>:
.globl vector25
vector25:
  pushl $0
  102382:	6a 00                	push   $0x0
  pushl $25
  102384:	6a 19                	push   $0x19
  jmp __alltraps
  102386:	e9 96 09 00 00       	jmp    102d21 <__alltraps>

0010238b <vector26>:
.globl vector26
vector26:
  pushl $0
  10238b:	6a 00                	push   $0x0
  pushl $26
  10238d:	6a 1a                	push   $0x1a
  jmp __alltraps
  10238f:	e9 8d 09 00 00       	jmp    102d21 <__alltraps>

00102394 <vector27>:
.globl vector27
vector27:
  pushl $0
  102394:	6a 00                	push   $0x0
  pushl $27
  102396:	6a 1b                	push   $0x1b
  jmp __alltraps
  102398:	e9 84 09 00 00       	jmp    102d21 <__alltraps>

0010239d <vector28>:
.globl vector28
vector28:
  pushl $0
  10239d:	6a 00                	push   $0x0
  pushl $28
  10239f:	6a 1c                	push   $0x1c
  jmp __alltraps
  1023a1:	e9 7b 09 00 00       	jmp    102d21 <__alltraps>

001023a6 <vector29>:
.globl vector29
vector29:
  pushl $0
  1023a6:	6a 00                	push   $0x0
  pushl $29
  1023a8:	6a 1d                	push   $0x1d
  jmp __alltraps
  1023aa:	e9 72 09 00 00       	jmp    102d21 <__alltraps>

001023af <vector30>:
.globl vector30
vector30:
  pushl $0
  1023af:	6a 00                	push   $0x0
  pushl $30
  1023b1:	6a 1e                	push   $0x1e
  jmp __alltraps
  1023b3:	e9 69 09 00 00       	jmp    102d21 <__alltraps>

001023b8 <vector31>:
.globl vector31
vector31:
  pushl $0
  1023b8:	6a 00                	push   $0x0
  pushl $31
  1023ba:	6a 1f                	push   $0x1f
  jmp __alltraps
  1023bc:	e9 60 09 00 00       	jmp    102d21 <__alltraps>

001023c1 <vector32>:
.globl vector32
vector32:
  pushl $0
  1023c1:	6a 00                	push   $0x0
  pushl $32
  1023c3:	6a 20                	push   $0x20
  jmp __alltraps
  1023c5:	e9 57 09 00 00       	jmp    102d21 <__alltraps>

001023ca <vector33>:
.globl vector33
vector33:
  pushl $0
  1023ca:	6a 00                	push   $0x0
  pushl $33
  1023cc:	6a 21                	push   $0x21
  jmp __alltraps
  1023ce:	e9 4e 09 00 00       	jmp    102d21 <__alltraps>

001023d3 <vector34>:
.globl vector34
vector34:
  pushl $0
  1023d3:	6a 00                	push   $0x0
  pushl $34
  1023d5:	6a 22                	push   $0x22
  jmp __alltraps
  1023d7:	e9 45 09 00 00       	jmp    102d21 <__alltraps>

001023dc <vector35>:
.globl vector35
vector35:
  pushl $0
  1023dc:	6a 00                	push   $0x0
  pushl $35
  1023de:	6a 23                	push   $0x23
  jmp __alltraps
  1023e0:	e9 3c 09 00 00       	jmp    102d21 <__alltraps>

001023e5 <vector36>:
.globl vector36
vector36:
  pushl $0
  1023e5:	6a 00                	push   $0x0
  pushl $36
  1023e7:	6a 24                	push   $0x24
  jmp __alltraps
  1023e9:	e9 33 09 00 00       	jmp    102d21 <__alltraps>

001023ee <vector37>:
.globl vector37
vector37:
  pushl $0
  1023ee:	6a 00                	push   $0x0
  pushl $37
  1023f0:	6a 25                	push   $0x25
  jmp __alltraps
  1023f2:	e9 2a 09 00 00       	jmp    102d21 <__alltraps>

001023f7 <vector38>:
.globl vector38
vector38:
  pushl $0
  1023f7:	6a 00                	push   $0x0
  pushl $38
  1023f9:	6a 26                	push   $0x26
  jmp __alltraps
  1023fb:	e9 21 09 00 00       	jmp    102d21 <__alltraps>

00102400 <vector39>:
.globl vector39
vector39:
  pushl $0
  102400:	6a 00                	push   $0x0
  pushl $39
  102402:	6a 27                	push   $0x27
  jmp __alltraps
  102404:	e9 18 09 00 00       	jmp    102d21 <__alltraps>

00102409 <vector40>:
.globl vector40
vector40:
  pushl $0
  102409:	6a 00                	push   $0x0
  pushl $40
  10240b:	6a 28                	push   $0x28
  jmp __alltraps
  10240d:	e9 0f 09 00 00       	jmp    102d21 <__alltraps>

00102412 <vector41>:
.globl vector41
vector41:
  pushl $0
  102412:	6a 00                	push   $0x0
  pushl $41
  102414:	6a 29                	push   $0x29
  jmp __alltraps
  102416:	e9 06 09 00 00       	jmp    102d21 <__alltraps>

0010241b <vector42>:
.globl vector42
vector42:
  pushl $0
  10241b:	6a 00                	push   $0x0
  pushl $42
  10241d:	6a 2a                	push   $0x2a
  jmp __alltraps
  10241f:	e9 fd 08 00 00       	jmp    102d21 <__alltraps>

00102424 <vector43>:
.globl vector43
vector43:
  pushl $0
  102424:	6a 00                	push   $0x0
  pushl $43
  102426:	6a 2b                	push   $0x2b
  jmp __alltraps
  102428:	e9 f4 08 00 00       	jmp    102d21 <__alltraps>

0010242d <vector44>:
.globl vector44
vector44:
  pushl $0
  10242d:	6a 00                	push   $0x0
  pushl $44
  10242f:	6a 2c                	push   $0x2c
  jmp __alltraps
  102431:	e9 eb 08 00 00       	jmp    102d21 <__alltraps>

00102436 <vector45>:
.globl vector45
vector45:
  pushl $0
  102436:	6a 00                	push   $0x0
  pushl $45
  102438:	6a 2d                	push   $0x2d
  jmp __alltraps
  10243a:	e9 e2 08 00 00       	jmp    102d21 <__alltraps>

0010243f <vector46>:
.globl vector46
vector46:
  pushl $0
  10243f:	6a 00                	push   $0x0
  pushl $46
  102441:	6a 2e                	push   $0x2e
  jmp __alltraps
  102443:	e9 d9 08 00 00       	jmp    102d21 <__alltraps>

00102448 <vector47>:
.globl vector47
vector47:
  pushl $0
  102448:	6a 00                	push   $0x0
  pushl $47
  10244a:	6a 2f                	push   $0x2f
  jmp __alltraps
  10244c:	e9 d0 08 00 00       	jmp    102d21 <__alltraps>

00102451 <vector48>:
.globl vector48
vector48:
  pushl $0
  102451:	6a 00                	push   $0x0
  pushl $48
  102453:	6a 30                	push   $0x30
  jmp __alltraps
  102455:	e9 c7 08 00 00       	jmp    102d21 <__alltraps>

0010245a <vector49>:
.globl vector49
vector49:
  pushl $0
  10245a:	6a 00                	push   $0x0
  pushl $49
  10245c:	6a 31                	push   $0x31
  jmp __alltraps
  10245e:	e9 be 08 00 00       	jmp    102d21 <__alltraps>

00102463 <vector50>:
.globl vector50
vector50:
  pushl $0
  102463:	6a 00                	push   $0x0
  pushl $50
  102465:	6a 32                	push   $0x32
  jmp __alltraps
  102467:	e9 b5 08 00 00       	jmp    102d21 <__alltraps>

0010246c <vector51>:
.globl vector51
vector51:
  pushl $0
  10246c:	6a 00                	push   $0x0
  pushl $51
  10246e:	6a 33                	push   $0x33
  jmp __alltraps
  102470:	e9 ac 08 00 00       	jmp    102d21 <__alltraps>

00102475 <vector52>:
.globl vector52
vector52:
  pushl $0
  102475:	6a 00                	push   $0x0
  pushl $52
  102477:	6a 34                	push   $0x34
  jmp __alltraps
  102479:	e9 a3 08 00 00       	jmp    102d21 <__alltraps>

0010247e <vector53>:
.globl vector53
vector53:
  pushl $0
  10247e:	6a 00                	push   $0x0
  pushl $53
  102480:	6a 35                	push   $0x35
  jmp __alltraps
  102482:	e9 9a 08 00 00       	jmp    102d21 <__alltraps>

00102487 <vector54>:
.globl vector54
vector54:
  pushl $0
  102487:	6a 00                	push   $0x0
  pushl $54
  102489:	6a 36                	push   $0x36
  jmp __alltraps
  10248b:	e9 91 08 00 00       	jmp    102d21 <__alltraps>

00102490 <vector55>:
.globl vector55
vector55:
  pushl $0
  102490:	6a 00                	push   $0x0
  pushl $55
  102492:	6a 37                	push   $0x37
  jmp __alltraps
  102494:	e9 88 08 00 00       	jmp    102d21 <__alltraps>

00102499 <vector56>:
.globl vector56
vector56:
  pushl $0
  102499:	6a 00                	push   $0x0
  pushl $56
  10249b:	6a 38                	push   $0x38
  jmp __alltraps
  10249d:	e9 7f 08 00 00       	jmp    102d21 <__alltraps>

001024a2 <vector57>:
.globl vector57
vector57:
  pushl $0
  1024a2:	6a 00                	push   $0x0
  pushl $57
  1024a4:	6a 39                	push   $0x39
  jmp __alltraps
  1024a6:	e9 76 08 00 00       	jmp    102d21 <__alltraps>

001024ab <vector58>:
.globl vector58
vector58:
  pushl $0
  1024ab:	6a 00                	push   $0x0
  pushl $58
  1024ad:	6a 3a                	push   $0x3a
  jmp __alltraps
  1024af:	e9 6d 08 00 00       	jmp    102d21 <__alltraps>

001024b4 <vector59>:
.globl vector59
vector59:
  pushl $0
  1024b4:	6a 00                	push   $0x0
  pushl $59
  1024b6:	6a 3b                	push   $0x3b
  jmp __alltraps
  1024b8:	e9 64 08 00 00       	jmp    102d21 <__alltraps>

001024bd <vector60>:
.globl vector60
vector60:
  pushl $0
  1024bd:	6a 00                	push   $0x0
  pushl $60
  1024bf:	6a 3c                	push   $0x3c
  jmp __alltraps
  1024c1:	e9 5b 08 00 00       	jmp    102d21 <__alltraps>

001024c6 <vector61>:
.globl vector61
vector61:
  pushl $0
  1024c6:	6a 00                	push   $0x0
  pushl $61
  1024c8:	6a 3d                	push   $0x3d
  jmp __alltraps
  1024ca:	e9 52 08 00 00       	jmp    102d21 <__alltraps>

001024cf <vector62>:
.globl vector62
vector62:
  pushl $0
  1024cf:	6a 00                	push   $0x0
  pushl $62
  1024d1:	6a 3e                	push   $0x3e
  jmp __alltraps
  1024d3:	e9 49 08 00 00       	jmp    102d21 <__alltraps>

001024d8 <vector63>:
.globl vector63
vector63:
  pushl $0
  1024d8:	6a 00                	push   $0x0
  pushl $63
  1024da:	6a 3f                	push   $0x3f
  jmp __alltraps
  1024dc:	e9 40 08 00 00       	jmp    102d21 <__alltraps>

001024e1 <vector64>:
.globl vector64
vector64:
  pushl $0
  1024e1:	6a 00                	push   $0x0
  pushl $64
  1024e3:	6a 40                	push   $0x40
  jmp __alltraps
  1024e5:	e9 37 08 00 00       	jmp    102d21 <__alltraps>

001024ea <vector65>:
.globl vector65
vector65:
  pushl $0
  1024ea:	6a 00                	push   $0x0
  pushl $65
  1024ec:	6a 41                	push   $0x41
  jmp __alltraps
  1024ee:	e9 2e 08 00 00       	jmp    102d21 <__alltraps>

001024f3 <vector66>:
.globl vector66
vector66:
  pushl $0
  1024f3:	6a 00                	push   $0x0
  pushl $66
  1024f5:	6a 42                	push   $0x42
  jmp __alltraps
  1024f7:	e9 25 08 00 00       	jmp    102d21 <__alltraps>

001024fc <vector67>:
.globl vector67
vector67:
  pushl $0
  1024fc:	6a 00                	push   $0x0
  pushl $67
  1024fe:	6a 43                	push   $0x43
  jmp __alltraps
  102500:	e9 1c 08 00 00       	jmp    102d21 <__alltraps>

00102505 <vector68>:
.globl vector68
vector68:
  pushl $0
  102505:	6a 00                	push   $0x0
  pushl $68
  102507:	6a 44                	push   $0x44
  jmp __alltraps
  102509:	e9 13 08 00 00       	jmp    102d21 <__alltraps>

0010250e <vector69>:
.globl vector69
vector69:
  pushl $0
  10250e:	6a 00                	push   $0x0
  pushl $69
  102510:	6a 45                	push   $0x45
  jmp __alltraps
  102512:	e9 0a 08 00 00       	jmp    102d21 <__alltraps>

00102517 <vector70>:
.globl vector70
vector70:
  pushl $0
  102517:	6a 00                	push   $0x0
  pushl $70
  102519:	6a 46                	push   $0x46
  jmp __alltraps
  10251b:	e9 01 08 00 00       	jmp    102d21 <__alltraps>

00102520 <vector71>:
.globl vector71
vector71:
  pushl $0
  102520:	6a 00                	push   $0x0
  pushl $71
  102522:	6a 47                	push   $0x47
  jmp __alltraps
  102524:	e9 f8 07 00 00       	jmp    102d21 <__alltraps>

00102529 <vector72>:
.globl vector72
vector72:
  pushl $0
  102529:	6a 00                	push   $0x0
  pushl $72
  10252b:	6a 48                	push   $0x48
  jmp __alltraps
  10252d:	e9 ef 07 00 00       	jmp    102d21 <__alltraps>

00102532 <vector73>:
.globl vector73
vector73:
  pushl $0
  102532:	6a 00                	push   $0x0
  pushl $73
  102534:	6a 49                	push   $0x49
  jmp __alltraps
  102536:	e9 e6 07 00 00       	jmp    102d21 <__alltraps>

0010253b <vector74>:
.globl vector74
vector74:
  pushl $0
  10253b:	6a 00                	push   $0x0
  pushl $74
  10253d:	6a 4a                	push   $0x4a
  jmp __alltraps
  10253f:	e9 dd 07 00 00       	jmp    102d21 <__alltraps>

00102544 <vector75>:
.globl vector75
vector75:
  pushl $0
  102544:	6a 00                	push   $0x0
  pushl $75
  102546:	6a 4b                	push   $0x4b
  jmp __alltraps
  102548:	e9 d4 07 00 00       	jmp    102d21 <__alltraps>

0010254d <vector76>:
.globl vector76
vector76:
  pushl $0
  10254d:	6a 00                	push   $0x0
  pushl $76
  10254f:	6a 4c                	push   $0x4c
  jmp __alltraps
  102551:	e9 cb 07 00 00       	jmp    102d21 <__alltraps>

00102556 <vector77>:
.globl vector77
vector77:
  pushl $0
  102556:	6a 00                	push   $0x0
  pushl $77
  102558:	6a 4d                	push   $0x4d
  jmp __alltraps
  10255a:	e9 c2 07 00 00       	jmp    102d21 <__alltraps>

0010255f <vector78>:
.globl vector78
vector78:
  pushl $0
  10255f:	6a 00                	push   $0x0
  pushl $78
  102561:	6a 4e                	push   $0x4e
  jmp __alltraps
  102563:	e9 b9 07 00 00       	jmp    102d21 <__alltraps>

00102568 <vector79>:
.globl vector79
vector79:
  pushl $0
  102568:	6a 00                	push   $0x0
  pushl $79
  10256a:	6a 4f                	push   $0x4f
  jmp __alltraps
  10256c:	e9 b0 07 00 00       	jmp    102d21 <__alltraps>

00102571 <vector80>:
.globl vector80
vector80:
  pushl $0
  102571:	6a 00                	push   $0x0
  pushl $80
  102573:	6a 50                	push   $0x50
  jmp __alltraps
  102575:	e9 a7 07 00 00       	jmp    102d21 <__alltraps>

0010257a <vector81>:
.globl vector81
vector81:
  pushl $0
  10257a:	6a 00                	push   $0x0
  pushl $81
  10257c:	6a 51                	push   $0x51
  jmp __alltraps
  10257e:	e9 9e 07 00 00       	jmp    102d21 <__alltraps>

00102583 <vector82>:
.globl vector82
vector82:
  pushl $0
  102583:	6a 00                	push   $0x0
  pushl $82
  102585:	6a 52                	push   $0x52
  jmp __alltraps
  102587:	e9 95 07 00 00       	jmp    102d21 <__alltraps>

0010258c <vector83>:
.globl vector83
vector83:
  pushl $0
  10258c:	6a 00                	push   $0x0
  pushl $83
  10258e:	6a 53                	push   $0x53
  jmp __alltraps
  102590:	e9 8c 07 00 00       	jmp    102d21 <__alltraps>

00102595 <vector84>:
.globl vector84
vector84:
  pushl $0
  102595:	6a 00                	push   $0x0
  pushl $84
  102597:	6a 54                	push   $0x54
  jmp __alltraps
  102599:	e9 83 07 00 00       	jmp    102d21 <__alltraps>

0010259e <vector85>:
.globl vector85
vector85:
  pushl $0
  10259e:	6a 00                	push   $0x0
  pushl $85
  1025a0:	6a 55                	push   $0x55
  jmp __alltraps
  1025a2:	e9 7a 07 00 00       	jmp    102d21 <__alltraps>

001025a7 <vector86>:
.globl vector86
vector86:
  pushl $0
  1025a7:	6a 00                	push   $0x0
  pushl $86
  1025a9:	6a 56                	push   $0x56
  jmp __alltraps
  1025ab:	e9 71 07 00 00       	jmp    102d21 <__alltraps>

001025b0 <vector87>:
.globl vector87
vector87:
  pushl $0
  1025b0:	6a 00                	push   $0x0
  pushl $87
  1025b2:	6a 57                	push   $0x57
  jmp __alltraps
  1025b4:	e9 68 07 00 00       	jmp    102d21 <__alltraps>

001025b9 <vector88>:
.globl vector88
vector88:
  pushl $0
  1025b9:	6a 00                	push   $0x0
  pushl $88
  1025bb:	6a 58                	push   $0x58
  jmp __alltraps
  1025bd:	e9 5f 07 00 00       	jmp    102d21 <__alltraps>

001025c2 <vector89>:
.globl vector89
vector89:
  pushl $0
  1025c2:	6a 00                	push   $0x0
  pushl $89
  1025c4:	6a 59                	push   $0x59
  jmp __alltraps
  1025c6:	e9 56 07 00 00       	jmp    102d21 <__alltraps>

001025cb <vector90>:
.globl vector90
vector90:
  pushl $0
  1025cb:	6a 00                	push   $0x0
  pushl $90
  1025cd:	6a 5a                	push   $0x5a
  jmp __alltraps
  1025cf:	e9 4d 07 00 00       	jmp    102d21 <__alltraps>

001025d4 <vector91>:
.globl vector91
vector91:
  pushl $0
  1025d4:	6a 00                	push   $0x0
  pushl $91
  1025d6:	6a 5b                	push   $0x5b
  jmp __alltraps
  1025d8:	e9 44 07 00 00       	jmp    102d21 <__alltraps>

001025dd <vector92>:
.globl vector92
vector92:
  pushl $0
  1025dd:	6a 00                	push   $0x0
  pushl $92
  1025df:	6a 5c                	push   $0x5c
  jmp __alltraps
  1025e1:	e9 3b 07 00 00       	jmp    102d21 <__alltraps>

001025e6 <vector93>:
.globl vector93
vector93:
  pushl $0
  1025e6:	6a 00                	push   $0x0
  pushl $93
  1025e8:	6a 5d                	push   $0x5d
  jmp __alltraps
  1025ea:	e9 32 07 00 00       	jmp    102d21 <__alltraps>

001025ef <vector94>:
.globl vector94
vector94:
  pushl $0
  1025ef:	6a 00                	push   $0x0
  pushl $94
  1025f1:	6a 5e                	push   $0x5e
  jmp __alltraps
  1025f3:	e9 29 07 00 00       	jmp    102d21 <__alltraps>

001025f8 <vector95>:
.globl vector95
vector95:
  pushl $0
  1025f8:	6a 00                	push   $0x0
  pushl $95
  1025fa:	6a 5f                	push   $0x5f
  jmp __alltraps
  1025fc:	e9 20 07 00 00       	jmp    102d21 <__alltraps>

00102601 <vector96>:
.globl vector96
vector96:
  pushl $0
  102601:	6a 00                	push   $0x0
  pushl $96
  102603:	6a 60                	push   $0x60
  jmp __alltraps
  102605:	e9 17 07 00 00       	jmp    102d21 <__alltraps>

0010260a <vector97>:
.globl vector97
vector97:
  pushl $0
  10260a:	6a 00                	push   $0x0
  pushl $97
  10260c:	6a 61                	push   $0x61
  jmp __alltraps
  10260e:	e9 0e 07 00 00       	jmp    102d21 <__alltraps>

00102613 <vector98>:
.globl vector98
vector98:
  pushl $0
  102613:	6a 00                	push   $0x0
  pushl $98
  102615:	6a 62                	push   $0x62
  jmp __alltraps
  102617:	e9 05 07 00 00       	jmp    102d21 <__alltraps>

0010261c <vector99>:
.globl vector99
vector99:
  pushl $0
  10261c:	6a 00                	push   $0x0
  pushl $99
  10261e:	6a 63                	push   $0x63
  jmp __alltraps
  102620:	e9 fc 06 00 00       	jmp    102d21 <__alltraps>

00102625 <vector100>:
.globl vector100
vector100:
  pushl $0
  102625:	6a 00                	push   $0x0
  pushl $100
  102627:	6a 64                	push   $0x64
  jmp __alltraps
  102629:	e9 f3 06 00 00       	jmp    102d21 <__alltraps>

0010262e <vector101>:
.globl vector101
vector101:
  pushl $0
  10262e:	6a 00                	push   $0x0
  pushl $101
  102630:	6a 65                	push   $0x65
  jmp __alltraps
  102632:	e9 ea 06 00 00       	jmp    102d21 <__alltraps>

00102637 <vector102>:
.globl vector102
vector102:
  pushl $0
  102637:	6a 00                	push   $0x0
  pushl $102
  102639:	6a 66                	push   $0x66
  jmp __alltraps
  10263b:	e9 e1 06 00 00       	jmp    102d21 <__alltraps>

00102640 <vector103>:
.globl vector103
vector103:
  pushl $0
  102640:	6a 00                	push   $0x0
  pushl $103
  102642:	6a 67                	push   $0x67
  jmp __alltraps
  102644:	e9 d8 06 00 00       	jmp    102d21 <__alltraps>

00102649 <vector104>:
.globl vector104
vector104:
  pushl $0
  102649:	6a 00                	push   $0x0
  pushl $104
  10264b:	6a 68                	push   $0x68
  jmp __alltraps
  10264d:	e9 cf 06 00 00       	jmp    102d21 <__alltraps>

00102652 <vector105>:
.globl vector105
vector105:
  pushl $0
  102652:	6a 00                	push   $0x0
  pushl $105
  102654:	6a 69                	push   $0x69
  jmp __alltraps
  102656:	e9 c6 06 00 00       	jmp    102d21 <__alltraps>

0010265b <vector106>:
.globl vector106
vector106:
  pushl $0
  10265b:	6a 00                	push   $0x0
  pushl $106
  10265d:	6a 6a                	push   $0x6a
  jmp __alltraps
  10265f:	e9 bd 06 00 00       	jmp    102d21 <__alltraps>

00102664 <vector107>:
.globl vector107
vector107:
  pushl $0
  102664:	6a 00                	push   $0x0
  pushl $107
  102666:	6a 6b                	push   $0x6b
  jmp __alltraps
  102668:	e9 b4 06 00 00       	jmp    102d21 <__alltraps>

0010266d <vector108>:
.globl vector108
vector108:
  pushl $0
  10266d:	6a 00                	push   $0x0
  pushl $108
  10266f:	6a 6c                	push   $0x6c
  jmp __alltraps
  102671:	e9 ab 06 00 00       	jmp    102d21 <__alltraps>

00102676 <vector109>:
.globl vector109
vector109:
  pushl $0
  102676:	6a 00                	push   $0x0
  pushl $109
  102678:	6a 6d                	push   $0x6d
  jmp __alltraps
  10267a:	e9 a2 06 00 00       	jmp    102d21 <__alltraps>

0010267f <vector110>:
.globl vector110
vector110:
  pushl $0
  10267f:	6a 00                	push   $0x0
  pushl $110
  102681:	6a 6e                	push   $0x6e
  jmp __alltraps
  102683:	e9 99 06 00 00       	jmp    102d21 <__alltraps>

00102688 <vector111>:
.globl vector111
vector111:
  pushl $0
  102688:	6a 00                	push   $0x0
  pushl $111
  10268a:	6a 6f                	push   $0x6f
  jmp __alltraps
  10268c:	e9 90 06 00 00       	jmp    102d21 <__alltraps>

00102691 <vector112>:
.globl vector112
vector112:
  pushl $0
  102691:	6a 00                	push   $0x0
  pushl $112
  102693:	6a 70                	push   $0x70
  jmp __alltraps
  102695:	e9 87 06 00 00       	jmp    102d21 <__alltraps>

0010269a <vector113>:
.globl vector113
vector113:
  pushl $0
  10269a:	6a 00                	push   $0x0
  pushl $113
  10269c:	6a 71                	push   $0x71
  jmp __alltraps
  10269e:	e9 7e 06 00 00       	jmp    102d21 <__alltraps>

001026a3 <vector114>:
.globl vector114
vector114:
  pushl $0
  1026a3:	6a 00                	push   $0x0
  pushl $114
  1026a5:	6a 72                	push   $0x72
  jmp __alltraps
  1026a7:	e9 75 06 00 00       	jmp    102d21 <__alltraps>

001026ac <vector115>:
.globl vector115
vector115:
  pushl $0
  1026ac:	6a 00                	push   $0x0
  pushl $115
  1026ae:	6a 73                	push   $0x73
  jmp __alltraps
  1026b0:	e9 6c 06 00 00       	jmp    102d21 <__alltraps>

001026b5 <vector116>:
.globl vector116
vector116:
  pushl $0
  1026b5:	6a 00                	push   $0x0
  pushl $116
  1026b7:	6a 74                	push   $0x74
  jmp __alltraps
  1026b9:	e9 63 06 00 00       	jmp    102d21 <__alltraps>

001026be <vector117>:
.globl vector117
vector117:
  pushl $0
  1026be:	6a 00                	push   $0x0
  pushl $117
  1026c0:	6a 75                	push   $0x75
  jmp __alltraps
  1026c2:	e9 5a 06 00 00       	jmp    102d21 <__alltraps>

001026c7 <vector118>:
.globl vector118
vector118:
  pushl $0
  1026c7:	6a 00                	push   $0x0
  pushl $118
  1026c9:	6a 76                	push   $0x76
  jmp __alltraps
  1026cb:	e9 51 06 00 00       	jmp    102d21 <__alltraps>

001026d0 <vector119>:
.globl vector119
vector119:
  pushl $0
  1026d0:	6a 00                	push   $0x0
  pushl $119
  1026d2:	6a 77                	push   $0x77
  jmp __alltraps
  1026d4:	e9 48 06 00 00       	jmp    102d21 <__alltraps>

001026d9 <vector120>:
.globl vector120
vector120:
  pushl $0
  1026d9:	6a 00                	push   $0x0
  pushl $120
  1026db:	6a 78                	push   $0x78
  jmp __alltraps
  1026dd:	e9 3f 06 00 00       	jmp    102d21 <__alltraps>

001026e2 <vector121>:
.globl vector121
vector121:
  pushl $0
  1026e2:	6a 00                	push   $0x0
  pushl $121
  1026e4:	6a 79                	push   $0x79
  jmp __alltraps
  1026e6:	e9 36 06 00 00       	jmp    102d21 <__alltraps>

001026eb <vector122>:
.globl vector122
vector122:
  pushl $0
  1026eb:	6a 00                	push   $0x0
  pushl $122
  1026ed:	6a 7a                	push   $0x7a
  jmp __alltraps
  1026ef:	e9 2d 06 00 00       	jmp    102d21 <__alltraps>

001026f4 <vector123>:
.globl vector123
vector123:
  pushl $0
  1026f4:	6a 00                	push   $0x0
  pushl $123
  1026f6:	6a 7b                	push   $0x7b
  jmp __alltraps
  1026f8:	e9 24 06 00 00       	jmp    102d21 <__alltraps>

001026fd <vector124>:
.globl vector124
vector124:
  pushl $0
  1026fd:	6a 00                	push   $0x0
  pushl $124
  1026ff:	6a 7c                	push   $0x7c
  jmp __alltraps
  102701:	e9 1b 06 00 00       	jmp    102d21 <__alltraps>

00102706 <vector125>:
.globl vector125
vector125:
  pushl $0
  102706:	6a 00                	push   $0x0
  pushl $125
  102708:	6a 7d                	push   $0x7d
  jmp __alltraps
  10270a:	e9 12 06 00 00       	jmp    102d21 <__alltraps>

0010270f <vector126>:
.globl vector126
vector126:
  pushl $0
  10270f:	6a 00                	push   $0x0
  pushl $126
  102711:	6a 7e                	push   $0x7e
  jmp __alltraps
  102713:	e9 09 06 00 00       	jmp    102d21 <__alltraps>

00102718 <vector127>:
.globl vector127
vector127:
  pushl $0
  102718:	6a 00                	push   $0x0
  pushl $127
  10271a:	6a 7f                	push   $0x7f
  jmp __alltraps
  10271c:	e9 00 06 00 00       	jmp    102d21 <__alltraps>

00102721 <vector128>:
.globl vector128
vector128:
  pushl $0
  102721:	6a 00                	push   $0x0
  pushl $128
  102723:	68 80 00 00 00       	push   $0x80
  jmp __alltraps
  102728:	e9 f4 05 00 00       	jmp    102d21 <__alltraps>

0010272d <vector129>:
.globl vector129
vector129:
  pushl $0
  10272d:	6a 00                	push   $0x0
  pushl $129
  10272f:	68 81 00 00 00       	push   $0x81
  jmp __alltraps
  102734:	e9 e8 05 00 00       	jmp    102d21 <__alltraps>

00102739 <vector130>:
.globl vector130
vector130:
  pushl $0
  102739:	6a 00                	push   $0x0
  pushl $130
  10273b:	68 82 00 00 00       	push   $0x82
  jmp __alltraps
  102740:	e9 dc 05 00 00       	jmp    102d21 <__alltraps>

00102745 <vector131>:
.globl vector131
vector131:
  pushl $0
  102745:	6a 00                	push   $0x0
  pushl $131
  102747:	68 83 00 00 00       	push   $0x83
  jmp __alltraps
  10274c:	e9 d0 05 00 00       	jmp    102d21 <__alltraps>

00102751 <vector132>:
.globl vector132
vector132:
  pushl $0
  102751:	6a 00                	push   $0x0
  pushl $132
  102753:	68 84 00 00 00       	push   $0x84
  jmp __alltraps
  102758:	e9 c4 05 00 00       	jmp    102d21 <__alltraps>

0010275d <vector133>:
.globl vector133
vector133:
  pushl $0
  10275d:	6a 00                	push   $0x0
  pushl $133
  10275f:	68 85 00 00 00       	push   $0x85
  jmp __alltraps
  102764:	e9 b8 05 00 00       	jmp    102d21 <__alltraps>

00102769 <vector134>:
.globl vector134
vector134:
  pushl $0
  102769:	6a 00                	push   $0x0
  pushl $134
  10276b:	68 86 00 00 00       	push   $0x86
  jmp __alltraps
  102770:	e9 ac 05 00 00       	jmp    102d21 <__alltraps>

00102775 <vector135>:
.globl vector135
vector135:
  pushl $0
  102775:	6a 00                	push   $0x0
  pushl $135
  102777:	68 87 00 00 00       	push   $0x87
  jmp __alltraps
  10277c:	e9 a0 05 00 00       	jmp    102d21 <__alltraps>

00102781 <vector136>:
.globl vector136
vector136:
  pushl $0
  102781:	6a 00                	push   $0x0
  pushl $136
  102783:	68 88 00 00 00       	push   $0x88
  jmp __alltraps
  102788:	e9 94 05 00 00       	jmp    102d21 <__alltraps>

0010278d <vector137>:
.globl vector137
vector137:
  pushl $0
  10278d:	6a 00                	push   $0x0
  pushl $137
  10278f:	68 89 00 00 00       	push   $0x89
  jmp __alltraps
  102794:	e9 88 05 00 00       	jmp    102d21 <__alltraps>

00102799 <vector138>:
.globl vector138
vector138:
  pushl $0
  102799:	6a 00                	push   $0x0
  pushl $138
  10279b:	68 8a 00 00 00       	push   $0x8a
  jmp __alltraps
  1027a0:	e9 7c 05 00 00       	jmp    102d21 <__alltraps>

001027a5 <vector139>:
.globl vector139
vector139:
  pushl $0
  1027a5:	6a 00                	push   $0x0
  pushl $139
  1027a7:	68 8b 00 00 00       	push   $0x8b
  jmp __alltraps
  1027ac:	e9 70 05 00 00       	jmp    102d21 <__alltraps>

001027b1 <vector140>:
.globl vector140
vector140:
  pushl $0
  1027b1:	6a 00                	push   $0x0
  pushl $140
  1027b3:	68 8c 00 00 00       	push   $0x8c
  jmp __alltraps
  1027b8:	e9 64 05 00 00       	jmp    102d21 <__alltraps>

001027bd <vector141>:
.globl vector141
vector141:
  pushl $0
  1027bd:	6a 00                	push   $0x0
  pushl $141
  1027bf:	68 8d 00 00 00       	push   $0x8d
  jmp __alltraps
  1027c4:	e9 58 05 00 00       	jmp    102d21 <__alltraps>

001027c9 <vector142>:
.globl vector142
vector142:
  pushl $0
  1027c9:	6a 00                	push   $0x0
  pushl $142
  1027cb:	68 8e 00 00 00       	push   $0x8e
  jmp __alltraps
  1027d0:	e9 4c 05 00 00       	jmp    102d21 <__alltraps>

001027d5 <vector143>:
.globl vector143
vector143:
  pushl $0
  1027d5:	6a 00                	push   $0x0
  pushl $143
  1027d7:	68 8f 00 00 00       	push   $0x8f
  jmp __alltraps
  1027dc:	e9 40 05 00 00       	jmp    102d21 <__alltraps>

001027e1 <vector144>:
.globl vector144
vector144:
  pushl $0
  1027e1:	6a 00                	push   $0x0
  pushl $144
  1027e3:	68 90 00 00 00       	push   $0x90
  jmp __alltraps
  1027e8:	e9 34 05 00 00       	jmp    102d21 <__alltraps>

001027ed <vector145>:
.globl vector145
vector145:
  pushl $0
  1027ed:	6a 00                	push   $0x0
  pushl $145
  1027ef:	68 91 00 00 00       	push   $0x91
  jmp __alltraps
  1027f4:	e9 28 05 00 00       	jmp    102d21 <__alltraps>

001027f9 <vector146>:
.globl vector146
vector146:
  pushl $0
  1027f9:	6a 00                	push   $0x0
  pushl $146
  1027fb:	68 92 00 00 00       	push   $0x92
  jmp __alltraps
  102800:	e9 1c 05 00 00       	jmp    102d21 <__alltraps>

00102805 <vector147>:
.globl vector147
vector147:
  pushl $0
  102805:	6a 00                	push   $0x0
  pushl $147
  102807:	68 93 00 00 00       	push   $0x93
  jmp __alltraps
  10280c:	e9 10 05 00 00       	jmp    102d21 <__alltraps>

00102811 <vector148>:
.globl vector148
vector148:
  pushl $0
  102811:	6a 00                	push   $0x0
  pushl $148
  102813:	68 94 00 00 00       	push   $0x94
  jmp __alltraps
  102818:	e9 04 05 00 00       	jmp    102d21 <__alltraps>

0010281d <vector149>:
.globl vector149
vector149:
  pushl $0
  10281d:	6a 00                	push   $0x0
  pushl $149
  10281f:	68 95 00 00 00       	push   $0x95
  jmp __alltraps
  102824:	e9 f8 04 00 00       	jmp    102d21 <__alltraps>

00102829 <vector150>:
.globl vector150
vector150:
  pushl $0
  102829:	6a 00                	push   $0x0
  pushl $150
  10282b:	68 96 00 00 00       	push   $0x96
  jmp __alltraps
  102830:	e9 ec 04 00 00       	jmp    102d21 <__alltraps>

00102835 <vector151>:
.globl vector151
vector151:
  pushl $0
  102835:	6a 00                	push   $0x0
  pushl $151
  102837:	68 97 00 00 00       	push   $0x97
  jmp __alltraps
  10283c:	e9 e0 04 00 00       	jmp    102d21 <__alltraps>

00102841 <vector152>:
.globl vector152
vector152:
  pushl $0
  102841:	6a 00                	push   $0x0
  pushl $152
  102843:	68 98 00 00 00       	push   $0x98
  jmp __alltraps
  102848:	e9 d4 04 00 00       	jmp    102d21 <__alltraps>

0010284d <vector153>:
.globl vector153
vector153:
  pushl $0
  10284d:	6a 00                	push   $0x0
  pushl $153
  10284f:	68 99 00 00 00       	push   $0x99
  jmp __alltraps
  102854:	e9 c8 04 00 00       	jmp    102d21 <__alltraps>

00102859 <vector154>:
.globl vector154
vector154:
  pushl $0
  102859:	6a 00                	push   $0x0
  pushl $154
  10285b:	68 9a 00 00 00       	push   $0x9a
  jmp __alltraps
  102860:	e9 bc 04 00 00       	jmp    102d21 <__alltraps>

00102865 <vector155>:
.globl vector155
vector155:
  pushl $0
  102865:	6a 00                	push   $0x0
  pushl $155
  102867:	68 9b 00 00 00       	push   $0x9b
  jmp __alltraps
  10286c:	e9 b0 04 00 00       	jmp    102d21 <__alltraps>

00102871 <vector156>:
.globl vector156
vector156:
  pushl $0
  102871:	6a 00                	push   $0x0
  pushl $156
  102873:	68 9c 00 00 00       	push   $0x9c
  jmp __alltraps
  102878:	e9 a4 04 00 00       	jmp    102d21 <__alltraps>

0010287d <vector157>:
.globl vector157
vector157:
  pushl $0
  10287d:	6a 00                	push   $0x0
  pushl $157
  10287f:	68 9d 00 00 00       	push   $0x9d
  jmp __alltraps
  102884:	e9 98 04 00 00       	jmp    102d21 <__alltraps>

00102889 <vector158>:
.globl vector158
vector158:
  pushl $0
  102889:	6a 00                	push   $0x0
  pushl $158
  10288b:	68 9e 00 00 00       	push   $0x9e
  jmp __alltraps
  102890:	e9 8c 04 00 00       	jmp    102d21 <__alltraps>

00102895 <vector159>:
.globl vector159
vector159:
  pushl $0
  102895:	6a 00                	push   $0x0
  pushl $159
  102897:	68 9f 00 00 00       	push   $0x9f
  jmp __alltraps
  10289c:	e9 80 04 00 00       	jmp    102d21 <__alltraps>

001028a1 <vector160>:
.globl vector160
vector160:
  pushl $0
  1028a1:	6a 00                	push   $0x0
  pushl $160
  1028a3:	68 a0 00 00 00       	push   $0xa0
  jmp __alltraps
  1028a8:	e9 74 04 00 00       	jmp    102d21 <__alltraps>

001028ad <vector161>:
.globl vector161
vector161:
  pushl $0
  1028ad:	6a 00                	push   $0x0
  pushl $161
  1028af:	68 a1 00 00 00       	push   $0xa1
  jmp __alltraps
  1028b4:	e9 68 04 00 00       	jmp    102d21 <__alltraps>

001028b9 <vector162>:
.globl vector162
vector162:
  pushl $0
  1028b9:	6a 00                	push   $0x0
  pushl $162
  1028bb:	68 a2 00 00 00       	push   $0xa2
  jmp __alltraps
  1028c0:	e9 5c 04 00 00       	jmp    102d21 <__alltraps>

001028c5 <vector163>:
.globl vector163
vector163:
  pushl $0
  1028c5:	6a 00                	push   $0x0
  pushl $163
  1028c7:	68 a3 00 00 00       	push   $0xa3
  jmp __alltraps
  1028cc:	e9 50 04 00 00       	jmp    102d21 <__alltraps>

001028d1 <vector164>:
.globl vector164
vector164:
  pushl $0
  1028d1:	6a 00                	push   $0x0
  pushl $164
  1028d3:	68 a4 00 00 00       	push   $0xa4
  jmp __alltraps
  1028d8:	e9 44 04 00 00       	jmp    102d21 <__alltraps>

001028dd <vector165>:
.globl vector165
vector165:
  pushl $0
  1028dd:	6a 00                	push   $0x0
  pushl $165
  1028df:	68 a5 00 00 00       	push   $0xa5
  jmp __alltraps
  1028e4:	e9 38 04 00 00       	jmp    102d21 <__alltraps>

001028e9 <vector166>:
.globl vector166
vector166:
  pushl $0
  1028e9:	6a 00                	push   $0x0
  pushl $166
  1028eb:	68 a6 00 00 00       	push   $0xa6
  jmp __alltraps
  1028f0:	e9 2c 04 00 00       	jmp    102d21 <__alltraps>

001028f5 <vector167>:
.globl vector167
vector167:
  pushl $0
  1028f5:	6a 00                	push   $0x0
  pushl $167
  1028f7:	68 a7 00 00 00       	push   $0xa7
  jmp __alltraps
  1028fc:	e9 20 04 00 00       	jmp    102d21 <__alltraps>

00102901 <vector168>:
.globl vector168
vector168:
  pushl $0
  102901:	6a 00                	push   $0x0
  pushl $168
  102903:	68 a8 00 00 00       	push   $0xa8
  jmp __alltraps
  102908:	e9 14 04 00 00       	jmp    102d21 <__alltraps>

0010290d <vector169>:
.globl vector169
vector169:
  pushl $0
  10290d:	6a 00                	push   $0x0
  pushl $169
  10290f:	68 a9 00 00 00       	push   $0xa9
  jmp __alltraps
  102914:	e9 08 04 00 00       	jmp    102d21 <__alltraps>

00102919 <vector170>:
.globl vector170
vector170:
  pushl $0
  102919:	6a 00                	push   $0x0
  pushl $170
  10291b:	68 aa 00 00 00       	push   $0xaa
  jmp __alltraps
  102920:	e9 fc 03 00 00       	jmp    102d21 <__alltraps>

00102925 <vector171>:
.globl vector171
vector171:
  pushl $0
  102925:	6a 00                	push   $0x0
  pushl $171
  102927:	68 ab 00 00 00       	push   $0xab
  jmp __alltraps
  10292c:	e9 f0 03 00 00       	jmp    102d21 <__alltraps>

00102931 <vector172>:
.globl vector172
vector172:
  pushl $0
  102931:	6a 00                	push   $0x0
  pushl $172
  102933:	68 ac 00 00 00       	push   $0xac
  jmp __alltraps
  102938:	e9 e4 03 00 00       	jmp    102d21 <__alltraps>

0010293d <vector173>:
.globl vector173
vector173:
  pushl $0
  10293d:	6a 00                	push   $0x0
  pushl $173
  10293f:	68 ad 00 00 00       	push   $0xad
  jmp __alltraps
  102944:	e9 d8 03 00 00       	jmp    102d21 <__alltraps>

00102949 <vector174>:
.globl vector174
vector174:
  pushl $0
  102949:	6a 00                	push   $0x0
  pushl $174
  10294b:	68 ae 00 00 00       	push   $0xae
  jmp __alltraps
  102950:	e9 cc 03 00 00       	jmp    102d21 <__alltraps>

00102955 <vector175>:
.globl vector175
vector175:
  pushl $0
  102955:	6a 00                	push   $0x0
  pushl $175
  102957:	68 af 00 00 00       	push   $0xaf
  jmp __alltraps
  10295c:	e9 c0 03 00 00       	jmp    102d21 <__alltraps>

00102961 <vector176>:
.globl vector176
vector176:
  pushl $0
  102961:	6a 00                	push   $0x0
  pushl $176
  102963:	68 b0 00 00 00       	push   $0xb0
  jmp __alltraps
  102968:	e9 b4 03 00 00       	jmp    102d21 <__alltraps>

0010296d <vector177>:
.globl vector177
vector177:
  pushl $0
  10296d:	6a 00                	push   $0x0
  pushl $177
  10296f:	68 b1 00 00 00       	push   $0xb1
  jmp __alltraps
  102974:	e9 a8 03 00 00       	jmp    102d21 <__alltraps>

00102979 <vector178>:
.globl vector178
vector178:
  pushl $0
  102979:	6a 00                	push   $0x0
  pushl $178
  10297b:	68 b2 00 00 00       	push   $0xb2
  jmp __alltraps
  102980:	e9 9c 03 00 00       	jmp    102d21 <__alltraps>

00102985 <vector179>:
.globl vector179
vector179:
  pushl $0
  102985:	6a 00                	push   $0x0
  pushl $179
  102987:	68 b3 00 00 00       	push   $0xb3
  jmp __alltraps
  10298c:	e9 90 03 00 00       	jmp    102d21 <__alltraps>

00102991 <vector180>:
.globl vector180
vector180:
  pushl $0
  102991:	6a 00                	push   $0x0
  pushl $180
  102993:	68 b4 00 00 00       	push   $0xb4
  jmp __alltraps
  102998:	e9 84 03 00 00       	jmp    102d21 <__alltraps>

0010299d <vector181>:
.globl vector181
vector181:
  pushl $0
  10299d:	6a 00                	push   $0x0
  pushl $181
  10299f:	68 b5 00 00 00       	push   $0xb5
  jmp __alltraps
  1029a4:	e9 78 03 00 00       	jmp    102d21 <__alltraps>

001029a9 <vector182>:
.globl vector182
vector182:
  pushl $0
  1029a9:	6a 00                	push   $0x0
  pushl $182
  1029ab:	68 b6 00 00 00       	push   $0xb6
  jmp __alltraps
  1029b0:	e9 6c 03 00 00       	jmp    102d21 <__alltraps>

001029b5 <vector183>:
.globl vector183
vector183:
  pushl $0
  1029b5:	6a 00                	push   $0x0
  pushl $183
  1029b7:	68 b7 00 00 00       	push   $0xb7
  jmp __alltraps
  1029bc:	e9 60 03 00 00       	jmp    102d21 <__alltraps>

001029c1 <vector184>:
.globl vector184
vector184:
  pushl $0
  1029c1:	6a 00                	push   $0x0
  pushl $184
  1029c3:	68 b8 00 00 00       	push   $0xb8
  jmp __alltraps
  1029c8:	e9 54 03 00 00       	jmp    102d21 <__alltraps>

001029cd <vector185>:
.globl vector185
vector185:
  pushl $0
  1029cd:	6a 00                	push   $0x0
  pushl $185
  1029cf:	68 b9 00 00 00       	push   $0xb9
  jmp __alltraps
  1029d4:	e9 48 03 00 00       	jmp    102d21 <__alltraps>

001029d9 <vector186>:
.globl vector186
vector186:
  pushl $0
  1029d9:	6a 00                	push   $0x0
  pushl $186
  1029db:	68 ba 00 00 00       	push   $0xba
  jmp __alltraps
  1029e0:	e9 3c 03 00 00       	jmp    102d21 <__alltraps>

001029e5 <vector187>:
.globl vector187
vector187:
  pushl $0
  1029e5:	6a 00                	push   $0x0
  pushl $187
  1029e7:	68 bb 00 00 00       	push   $0xbb
  jmp __alltraps
  1029ec:	e9 30 03 00 00       	jmp    102d21 <__alltraps>

001029f1 <vector188>:
.globl vector188
vector188:
  pushl $0
  1029f1:	6a 00                	push   $0x0
  pushl $188
  1029f3:	68 bc 00 00 00       	push   $0xbc
  jmp __alltraps
  1029f8:	e9 24 03 00 00       	jmp    102d21 <__alltraps>

001029fd <vector189>:
.globl vector189
vector189:
  pushl $0
  1029fd:	6a 00                	push   $0x0
  pushl $189
  1029ff:	68 bd 00 00 00       	push   $0xbd
  jmp __alltraps
  102a04:	e9 18 03 00 00       	jmp    102d21 <__alltraps>

00102a09 <vector190>:
.globl vector190
vector190:
  pushl $0
  102a09:	6a 00                	push   $0x0
  pushl $190
  102a0b:	68 be 00 00 00       	push   $0xbe
  jmp __alltraps
  102a10:	e9 0c 03 00 00       	jmp    102d21 <__alltraps>

00102a15 <vector191>:
.globl vector191
vector191:
  pushl $0
  102a15:	6a 00                	push   $0x0
  pushl $191
  102a17:	68 bf 00 00 00       	push   $0xbf
  jmp __alltraps
  102a1c:	e9 00 03 00 00       	jmp    102d21 <__alltraps>

00102a21 <vector192>:
.globl vector192
vector192:
  pushl $0
  102a21:	6a 00                	push   $0x0
  pushl $192
  102a23:	68 c0 00 00 00       	push   $0xc0
  jmp __alltraps
  102a28:	e9 f4 02 00 00       	jmp    102d21 <__alltraps>

00102a2d <vector193>:
.globl vector193
vector193:
  pushl $0
  102a2d:	6a 00                	push   $0x0
  pushl $193
  102a2f:	68 c1 00 00 00       	push   $0xc1
  jmp __alltraps
  102a34:	e9 e8 02 00 00       	jmp    102d21 <__alltraps>

00102a39 <vector194>:
.globl vector194
vector194:
  pushl $0
  102a39:	6a 00                	push   $0x0
  pushl $194
  102a3b:	68 c2 00 00 00       	push   $0xc2
  jmp __alltraps
  102a40:	e9 dc 02 00 00       	jmp    102d21 <__alltraps>

00102a45 <vector195>:
.globl vector195
vector195:
  pushl $0
  102a45:	6a 00                	push   $0x0
  pushl $195
  102a47:	68 c3 00 00 00       	push   $0xc3
  jmp __alltraps
  102a4c:	e9 d0 02 00 00       	jmp    102d21 <__alltraps>

00102a51 <vector196>:
.globl vector196
vector196:
  pushl $0
  102a51:	6a 00                	push   $0x0
  pushl $196
  102a53:	68 c4 00 00 00       	push   $0xc4
  jmp __alltraps
  102a58:	e9 c4 02 00 00       	jmp    102d21 <__alltraps>

00102a5d <vector197>:
.globl vector197
vector197:
  pushl $0
  102a5d:	6a 00                	push   $0x0
  pushl $197
  102a5f:	68 c5 00 00 00       	push   $0xc5
  jmp __alltraps
  102a64:	e9 b8 02 00 00       	jmp    102d21 <__alltraps>

00102a69 <vector198>:
.globl vector198
vector198:
  pushl $0
  102a69:	6a 00                	push   $0x0
  pushl $198
  102a6b:	68 c6 00 00 00       	push   $0xc6
  jmp __alltraps
  102a70:	e9 ac 02 00 00       	jmp    102d21 <__alltraps>

00102a75 <vector199>:
.globl vector199
vector199:
  pushl $0
  102a75:	6a 00                	push   $0x0
  pushl $199
  102a77:	68 c7 00 00 00       	push   $0xc7
  jmp __alltraps
  102a7c:	e9 a0 02 00 00       	jmp    102d21 <__alltraps>

00102a81 <vector200>:
.globl vector200
vector200:
  pushl $0
  102a81:	6a 00                	push   $0x0
  pushl $200
  102a83:	68 c8 00 00 00       	push   $0xc8
  jmp __alltraps
  102a88:	e9 94 02 00 00       	jmp    102d21 <__alltraps>

00102a8d <vector201>:
.globl vector201
vector201:
  pushl $0
  102a8d:	6a 00                	push   $0x0
  pushl $201
  102a8f:	68 c9 00 00 00       	push   $0xc9
  jmp __alltraps
  102a94:	e9 88 02 00 00       	jmp    102d21 <__alltraps>

00102a99 <vector202>:
.globl vector202
vector202:
  pushl $0
  102a99:	6a 00                	push   $0x0
  pushl $202
  102a9b:	68 ca 00 00 00       	push   $0xca
  jmp __alltraps
  102aa0:	e9 7c 02 00 00       	jmp    102d21 <__alltraps>

00102aa5 <vector203>:
.globl vector203
vector203:
  pushl $0
  102aa5:	6a 00                	push   $0x0
  pushl $203
  102aa7:	68 cb 00 00 00       	push   $0xcb
  jmp __alltraps
  102aac:	e9 70 02 00 00       	jmp    102d21 <__alltraps>

00102ab1 <vector204>:
.globl vector204
vector204:
  pushl $0
  102ab1:	6a 00                	push   $0x0
  pushl $204
  102ab3:	68 cc 00 00 00       	push   $0xcc
  jmp __alltraps
  102ab8:	e9 64 02 00 00       	jmp    102d21 <__alltraps>

00102abd <vector205>:
.globl vector205
vector205:
  pushl $0
  102abd:	6a 00                	push   $0x0
  pushl $205
  102abf:	68 cd 00 00 00       	push   $0xcd
  jmp __alltraps
  102ac4:	e9 58 02 00 00       	jmp    102d21 <__alltraps>

00102ac9 <vector206>:
.globl vector206
vector206:
  pushl $0
  102ac9:	6a 00                	push   $0x0
  pushl $206
  102acb:	68 ce 00 00 00       	push   $0xce
  jmp __alltraps
  102ad0:	e9 4c 02 00 00       	jmp    102d21 <__alltraps>

00102ad5 <vector207>:
.globl vector207
vector207:
  pushl $0
  102ad5:	6a 00                	push   $0x0
  pushl $207
  102ad7:	68 cf 00 00 00       	push   $0xcf
  jmp __alltraps
  102adc:	e9 40 02 00 00       	jmp    102d21 <__alltraps>

00102ae1 <vector208>:
.globl vector208
vector208:
  pushl $0
  102ae1:	6a 00                	push   $0x0
  pushl $208
  102ae3:	68 d0 00 00 00       	push   $0xd0
  jmp __alltraps
  102ae8:	e9 34 02 00 00       	jmp    102d21 <__alltraps>

00102aed <vector209>:
.globl vector209
vector209:
  pushl $0
  102aed:	6a 00                	push   $0x0
  pushl $209
  102aef:	68 d1 00 00 00       	push   $0xd1
  jmp __alltraps
  102af4:	e9 28 02 00 00       	jmp    102d21 <__alltraps>

00102af9 <vector210>:
.globl vector210
vector210:
  pushl $0
  102af9:	6a 00                	push   $0x0
  pushl $210
  102afb:	68 d2 00 00 00       	push   $0xd2
  jmp __alltraps
  102b00:	e9 1c 02 00 00       	jmp    102d21 <__alltraps>

00102b05 <vector211>:
.globl vector211
vector211:
  pushl $0
  102b05:	6a 00                	push   $0x0
  pushl $211
  102b07:	68 d3 00 00 00       	push   $0xd3
  jmp __alltraps
  102b0c:	e9 10 02 00 00       	jmp    102d21 <__alltraps>

00102b11 <vector212>:
.globl vector212
vector212:
  pushl $0
  102b11:	6a 00                	push   $0x0
  pushl $212
  102b13:	68 d4 00 00 00       	push   $0xd4
  jmp __alltraps
  102b18:	e9 04 02 00 00       	jmp    102d21 <__alltraps>

00102b1d <vector213>:
.globl vector213
vector213:
  pushl $0
  102b1d:	6a 00                	push   $0x0
  pushl $213
  102b1f:	68 d5 00 00 00       	push   $0xd5
  jmp __alltraps
  102b24:	e9 f8 01 00 00       	jmp    102d21 <__alltraps>

00102b29 <vector214>:
.globl vector214
vector214:
  pushl $0
  102b29:	6a 00                	push   $0x0
  pushl $214
  102b2b:	68 d6 00 00 00       	push   $0xd6
  jmp __alltraps
  102b30:	e9 ec 01 00 00       	jmp    102d21 <__alltraps>

00102b35 <vector215>:
.globl vector215
vector215:
  pushl $0
  102b35:	6a 00                	push   $0x0
  pushl $215
  102b37:	68 d7 00 00 00       	push   $0xd7
  jmp __alltraps
  102b3c:	e9 e0 01 00 00       	jmp    102d21 <__alltraps>

00102b41 <vector216>:
.globl vector216
vector216:
  pushl $0
  102b41:	6a 00                	push   $0x0
  pushl $216
  102b43:	68 d8 00 00 00       	push   $0xd8
  jmp __alltraps
  102b48:	e9 d4 01 00 00       	jmp    102d21 <__alltraps>

00102b4d <vector217>:
.globl vector217
vector217:
  pushl $0
  102b4d:	6a 00                	push   $0x0
  pushl $217
  102b4f:	68 d9 00 00 00       	push   $0xd9
  jmp __alltraps
  102b54:	e9 c8 01 00 00       	jmp    102d21 <__alltraps>

00102b59 <vector218>:
.globl vector218
vector218:
  pushl $0
  102b59:	6a 00                	push   $0x0
  pushl $218
  102b5b:	68 da 00 00 00       	push   $0xda
  jmp __alltraps
  102b60:	e9 bc 01 00 00       	jmp    102d21 <__alltraps>

00102b65 <vector219>:
.globl vector219
vector219:
  pushl $0
  102b65:	6a 00                	push   $0x0
  pushl $219
  102b67:	68 db 00 00 00       	push   $0xdb
  jmp __alltraps
  102b6c:	e9 b0 01 00 00       	jmp    102d21 <__alltraps>

00102b71 <vector220>:
.globl vector220
vector220:
  pushl $0
  102b71:	6a 00                	push   $0x0
  pushl $220
  102b73:	68 dc 00 00 00       	push   $0xdc
  jmp __alltraps
  102b78:	e9 a4 01 00 00       	jmp    102d21 <__alltraps>

00102b7d <vector221>:
.globl vector221
vector221:
  pushl $0
  102b7d:	6a 00                	push   $0x0
  pushl $221
  102b7f:	68 dd 00 00 00       	push   $0xdd
  jmp __alltraps
  102b84:	e9 98 01 00 00       	jmp    102d21 <__alltraps>

00102b89 <vector222>:
.globl vector222
vector222:
  pushl $0
  102b89:	6a 00                	push   $0x0
  pushl $222
  102b8b:	68 de 00 00 00       	push   $0xde
  jmp __alltraps
  102b90:	e9 8c 01 00 00       	jmp    102d21 <__alltraps>

00102b95 <vector223>:
.globl vector223
vector223:
  pushl $0
  102b95:	6a 00                	push   $0x0
  pushl $223
  102b97:	68 df 00 00 00       	push   $0xdf
  jmp __alltraps
  102b9c:	e9 80 01 00 00       	jmp    102d21 <__alltraps>

00102ba1 <vector224>:
.globl vector224
vector224:
  pushl $0
  102ba1:	6a 00                	push   $0x0
  pushl $224
  102ba3:	68 e0 00 00 00       	push   $0xe0
  jmp __alltraps
  102ba8:	e9 74 01 00 00       	jmp    102d21 <__alltraps>

00102bad <vector225>:
.globl vector225
vector225:
  pushl $0
  102bad:	6a 00                	push   $0x0
  pushl $225
  102baf:	68 e1 00 00 00       	push   $0xe1
  jmp __alltraps
  102bb4:	e9 68 01 00 00       	jmp    102d21 <__alltraps>

00102bb9 <vector226>:
.globl vector226
vector226:
  pushl $0
  102bb9:	6a 00                	push   $0x0
  pushl $226
  102bbb:	68 e2 00 00 00       	push   $0xe2
  jmp __alltraps
  102bc0:	e9 5c 01 00 00       	jmp    102d21 <__alltraps>

00102bc5 <vector227>:
.globl vector227
vector227:
  pushl $0
  102bc5:	6a 00                	push   $0x0
  pushl $227
  102bc7:	68 e3 00 00 00       	push   $0xe3
  jmp __alltraps
  102bcc:	e9 50 01 00 00       	jmp    102d21 <__alltraps>

00102bd1 <vector228>:
.globl vector228
vector228:
  pushl $0
  102bd1:	6a 00                	push   $0x0
  pushl $228
  102bd3:	68 e4 00 00 00       	push   $0xe4
  jmp __alltraps
  102bd8:	e9 44 01 00 00       	jmp    102d21 <__alltraps>

00102bdd <vector229>:
.globl vector229
vector229:
  pushl $0
  102bdd:	6a 00                	push   $0x0
  pushl $229
  102bdf:	68 e5 00 00 00       	push   $0xe5
  jmp __alltraps
  102be4:	e9 38 01 00 00       	jmp    102d21 <__alltraps>

00102be9 <vector230>:
.globl vector230
vector230:
  pushl $0
  102be9:	6a 00                	push   $0x0
  pushl $230
  102beb:	68 e6 00 00 00       	push   $0xe6
  jmp __alltraps
  102bf0:	e9 2c 01 00 00       	jmp    102d21 <__alltraps>

00102bf5 <vector231>:
.globl vector231
vector231:
  pushl $0
  102bf5:	6a 00                	push   $0x0
  pushl $231
  102bf7:	68 e7 00 00 00       	push   $0xe7
  jmp __alltraps
  102bfc:	e9 20 01 00 00       	jmp    102d21 <__alltraps>

00102c01 <vector232>:
.globl vector232
vector232:
  pushl $0
  102c01:	6a 00                	push   $0x0
  pushl $232
  102c03:	68 e8 00 00 00       	push   $0xe8
  jmp __alltraps
  102c08:	e9 14 01 00 00       	jmp    102d21 <__alltraps>

00102c0d <vector233>:
.globl vector233
vector233:
  pushl $0
  102c0d:	6a 00                	push   $0x0
  pushl $233
  102c0f:	68 e9 00 00 00       	push   $0xe9
  jmp __alltraps
  102c14:	e9 08 01 00 00       	jmp    102d21 <__alltraps>

00102c19 <vector234>:
.globl vector234
vector234:
  pushl $0
  102c19:	6a 00                	push   $0x0
  pushl $234
  102c1b:	68 ea 00 00 00       	push   $0xea
  jmp __alltraps
  102c20:	e9 fc 00 00 00       	jmp    102d21 <__alltraps>

00102c25 <vector235>:
.globl vector235
vector235:
  pushl $0
  102c25:	6a 00                	push   $0x0
  pushl $235
  102c27:	68 eb 00 00 00       	push   $0xeb
  jmp __alltraps
  102c2c:	e9 f0 00 00 00       	jmp    102d21 <__alltraps>

00102c31 <vector236>:
.globl vector236
vector236:
  pushl $0
  102c31:	6a 00                	push   $0x0
  pushl $236
  102c33:	68 ec 00 00 00       	push   $0xec
  jmp __alltraps
  102c38:	e9 e4 00 00 00       	jmp    102d21 <__alltraps>

00102c3d <vector237>:
.globl vector237
vector237:
  pushl $0
  102c3d:	6a 00                	push   $0x0
  pushl $237
  102c3f:	68 ed 00 00 00       	push   $0xed
  jmp __alltraps
  102c44:	e9 d8 00 00 00       	jmp    102d21 <__alltraps>

00102c49 <vector238>:
.globl vector238
vector238:
  pushl $0
  102c49:	6a 00                	push   $0x0
  pushl $238
  102c4b:	68 ee 00 00 00       	push   $0xee
  jmp __alltraps
  102c50:	e9 cc 00 00 00       	jmp    102d21 <__alltraps>

00102c55 <vector239>:
.globl vector239
vector239:
  pushl $0
  102c55:	6a 00                	push   $0x0
  pushl $239
  102c57:	68 ef 00 00 00       	push   $0xef
  jmp __alltraps
  102c5c:	e9 c0 00 00 00       	jmp    102d21 <__alltraps>

00102c61 <vector240>:
.globl vector240
vector240:
  pushl $0
  102c61:	6a 00                	push   $0x0
  pushl $240
  102c63:	68 f0 00 00 00       	push   $0xf0
  jmp __alltraps
  102c68:	e9 b4 00 00 00       	jmp    102d21 <__alltraps>

00102c6d <vector241>:
.globl vector241
vector241:
  pushl $0
  102c6d:	6a 00                	push   $0x0
  pushl $241
  102c6f:	68 f1 00 00 00       	push   $0xf1
  jmp __alltraps
  102c74:	e9 a8 00 00 00       	jmp    102d21 <__alltraps>

00102c79 <vector242>:
.globl vector242
vector242:
  pushl $0
  102c79:	6a 00                	push   $0x0
  pushl $242
  102c7b:	68 f2 00 00 00       	push   $0xf2
  jmp __alltraps
  102c80:	e9 9c 00 00 00       	jmp    102d21 <__alltraps>

00102c85 <vector243>:
.globl vector243
vector243:
  pushl $0
  102c85:	6a 00                	push   $0x0
  pushl $243
  102c87:	68 f3 00 00 00       	push   $0xf3
  jmp __alltraps
  102c8c:	e9 90 00 00 00       	jmp    102d21 <__alltraps>

00102c91 <vector244>:
.globl vector244
vector244:
  pushl $0
  102c91:	6a 00                	push   $0x0
  pushl $244
  102c93:	68 f4 00 00 00       	push   $0xf4
  jmp __alltraps
  102c98:	e9 84 00 00 00       	jmp    102d21 <__alltraps>

00102c9d <vector245>:
.globl vector245
vector245:
  pushl $0
  102c9d:	6a 00                	push   $0x0
  pushl $245
  102c9f:	68 f5 00 00 00       	push   $0xf5
  jmp __alltraps
  102ca4:	e9 78 00 00 00       	jmp    102d21 <__alltraps>

00102ca9 <vector246>:
.globl vector246
vector246:
  pushl $0
  102ca9:	6a 00                	push   $0x0
  pushl $246
  102cab:	68 f6 00 00 00       	push   $0xf6
  jmp __alltraps
  102cb0:	e9 6c 00 00 00       	jmp    102d21 <__alltraps>

00102cb5 <vector247>:
.globl vector247
vector247:
  pushl $0
  102cb5:	6a 00                	push   $0x0
  pushl $247
  102cb7:	68 f7 00 00 00       	push   $0xf7
  jmp __alltraps
  102cbc:	e9 60 00 00 00       	jmp    102d21 <__alltraps>

00102cc1 <vector248>:
.globl vector248
vector248:
  pushl $0
  102cc1:	6a 00                	push   $0x0
  pushl $248
  102cc3:	68 f8 00 00 00       	push   $0xf8
  jmp __alltraps
  102cc8:	e9 54 00 00 00       	jmp    102d21 <__alltraps>

00102ccd <vector249>:
.globl vector249
vector249:
  pushl $0
  102ccd:	6a 00                	push   $0x0
  pushl $249
  102ccf:	68 f9 00 00 00       	push   $0xf9
  jmp __alltraps
  102cd4:	e9 48 00 00 00       	jmp    102d21 <__alltraps>

00102cd9 <vector250>:
.globl vector250
vector250:
  pushl $0
  102cd9:	6a 00                	push   $0x0
  pushl $250
  102cdb:	68 fa 00 00 00       	push   $0xfa
  jmp __alltraps
  102ce0:	e9 3c 00 00 00       	jmp    102d21 <__alltraps>

00102ce5 <vector251>:
.globl vector251
vector251:
  pushl $0
  102ce5:	6a 00                	push   $0x0
  pushl $251
  102ce7:	68 fb 00 00 00       	push   $0xfb
  jmp __alltraps
  102cec:	e9 30 00 00 00       	jmp    102d21 <__alltraps>

00102cf1 <vector252>:
.globl vector252
vector252:
  pushl $0
  102cf1:	6a 00                	push   $0x0
  pushl $252
  102cf3:	68 fc 00 00 00       	push   $0xfc
  jmp __alltraps
  102cf8:	e9 24 00 00 00       	jmp    102d21 <__alltraps>

00102cfd <vector253>:
.globl vector253
vector253:
  pushl $0
  102cfd:	6a 00                	push   $0x0
  pushl $253
  102cff:	68 fd 00 00 00       	push   $0xfd
  jmp __alltraps
  102d04:	e9 18 00 00 00       	jmp    102d21 <__alltraps>

00102d09 <vector254>:
.globl vector254
vector254:
  pushl $0
  102d09:	6a 00                	push   $0x0
  pushl $254
  102d0b:	68 fe 00 00 00       	push   $0xfe
  jmp __alltraps
  102d10:	e9 0c 00 00 00       	jmp    102d21 <__alltraps>

00102d15 <vector255>:
.globl vector255
vector255:
  pushl $0
  102d15:	6a 00                	push   $0x0
  pushl $255
  102d17:	68 ff 00 00 00       	push   $0xff
  jmp __alltraps
  102d1c:	e9 00 00 00 00       	jmp    102d21 <__alltraps>

00102d21 <__alltraps>:
.text
.globl __alltraps
__alltraps:
    # push registers to build a trap frame
    # therefore make the stack look like a struct trapframe
    pushl %ds
  102d21:	1e                   	push   %ds
    pushl %es
  102d22:	06                   	push   %es
    pushl %fs
  102d23:	0f a0                	push   %fs
    pushl %gs
  102d25:	0f a8                	push   %gs
    pushal
  102d27:	60                   	pusha  

    # load GD_KDATA into %ds and %es to set up data segments for kernel
    movl $GD_KDATA, %eax
  102d28:	b8 10 00 00 00       	mov    $0x10,%eax
    movw %ax, %ds
  102d2d:	8e d8                	mov    %eax,%ds
    movw %ax, %es
  102d2f:	8e c0                	mov    %eax,%es

    # push %esp to pass a pointer to the trapframe as an argument to trap()
    pushl %esp
  102d31:	54                   	push   %esp

    # call trap(tf), where tf=%esp
    call trap
  102d32:	e8 41 f5 ff ff       	call   102278 <trap>

    # pop the pushed stack pointer
    popl %esp
  102d37:	5c                   	pop    %esp

00102d38 <__trapret>:

    # return falls through to trapret...
.globl __trapret
__trapret:
    # restore registers from stack
    popal
  102d38:	61                   	popa   

    # restore %ds, %es, %fs and %gs
    popl %gs
  102d39:	0f a9                	pop    %gs
    popl %fs
  102d3b:	0f a1                	pop    %fs
    popl %es
  102d3d:	07                   	pop    %es
    popl %ds
  102d3e:	1f                   	pop    %ds

    # get rid of the trap number and error code
    addl $0x8, %esp
  102d3f:	83 c4 08             	add    $0x8,%esp
    iret
  102d42:	cf                   	iret   

00102d43 <lgdt>:
/* *
 * lgdt - load the global descriptor table register and reset the
 * data/code segement registers for kernel.
 * */
static inline void
lgdt(struct pseudodesc *pd) {
  102d43:	55                   	push   %ebp
  102d44:	89 e5                	mov    %esp,%ebp
    asm volatile ("lgdt (%0)" :: "r" (pd));
  102d46:	8b 45 08             	mov    0x8(%ebp),%eax
  102d49:	0f 01 10             	lgdtl  (%eax)
    asm volatile ("movw %%ax, %%gs" :: "a" (USER_DS));
  102d4c:	b8 23 00 00 00       	mov    $0x23,%eax
  102d51:	8e e8                	mov    %eax,%gs
    asm volatile ("movw %%ax, %%fs" :: "a" (USER_DS));
  102d53:	b8 23 00 00 00       	mov    $0x23,%eax
  102d58:	8e e0                	mov    %eax,%fs
    asm volatile ("movw %%ax, %%es" :: "a" (KERNEL_DS));
  102d5a:	b8 10 00 00 00       	mov    $0x10,%eax
  102d5f:	8e c0                	mov    %eax,%es
    asm volatile ("movw %%ax, %%ds" :: "a" (KERNEL_DS));
  102d61:	b8 10 00 00 00       	mov    $0x10,%eax
  102d66:	8e d8                	mov    %eax,%ds
    asm volatile ("movw %%ax, %%ss" :: "a" (KERNEL_DS));
  102d68:	b8 10 00 00 00       	mov    $0x10,%eax
  102d6d:	8e d0                	mov    %eax,%ss
    // reload cs
    asm volatile ("ljmp %0, $1f\n 1:\n" :: "i" (KERNEL_CS));
  102d6f:	ea 76 2d 10 00 08 00 	ljmp   $0x8,$0x102d76
}
  102d76:	90                   	nop
  102d77:	5d                   	pop    %ebp
  102d78:	c3                   	ret    

00102d79 <gdt_init>:
/* temporary kernel stack */
uint8_t stack0[1024];

/* gdt_init - initialize the default GDT and TSS */
static void
gdt_init(void) {
  102d79:	f3 0f 1e fb          	endbr32 
  102d7d:	55                   	push   %ebp
  102d7e:	89 e5                	mov    %esp,%ebp
  102d80:	83 ec 14             	sub    $0x14,%esp
    // Setup a TSS so that we can get the right stack when we trap from
    // user to the kernel. But not safe here, it's only a temporary value,
    // it will be set to KSTACKTOP in lab2.
    ts.ts_esp0 = (uint32_t)&stack0 + sizeof(stack0);
  102d83:	b8 80 19 11 00       	mov    $0x111980,%eax
  102d88:	05 00 04 00 00       	add    $0x400,%eax
  102d8d:	a3 a4 18 11 00       	mov    %eax,0x1118a4
    ts.ts_ss0 = KERNEL_DS;
  102d92:	66 c7 05 a8 18 11 00 	movw   $0x10,0x1118a8
  102d99:	10 00 

    // initialize the TSS filed of the gdt
    gdt[SEG_TSS] = SEG16(STS_T32A, (uint32_t)&ts, sizeof(ts), DPL_KERNEL);
  102d9b:	66 c7 05 08 0a 11 00 	movw   $0x68,0x110a08
  102da2:	68 00 
  102da4:	b8 a0 18 11 00       	mov    $0x1118a0,%eax
  102da9:	0f b7 c0             	movzwl %ax,%eax
  102dac:	66 a3 0a 0a 11 00    	mov    %ax,0x110a0a
  102db2:	b8 a0 18 11 00       	mov    $0x1118a0,%eax
  102db7:	c1 e8 10             	shr    $0x10,%eax
  102dba:	a2 0c 0a 11 00       	mov    %al,0x110a0c
  102dbf:	0f b6 05 0d 0a 11 00 	movzbl 0x110a0d,%eax
  102dc6:	24 f0                	and    $0xf0,%al
  102dc8:	0c 09                	or     $0x9,%al
  102dca:	a2 0d 0a 11 00       	mov    %al,0x110a0d
  102dcf:	0f b6 05 0d 0a 11 00 	movzbl 0x110a0d,%eax
  102dd6:	0c 10                	or     $0x10,%al
  102dd8:	a2 0d 0a 11 00       	mov    %al,0x110a0d
  102ddd:	0f b6 05 0d 0a 11 00 	movzbl 0x110a0d,%eax
  102de4:	24 9f                	and    $0x9f,%al
  102de6:	a2 0d 0a 11 00       	mov    %al,0x110a0d
  102deb:	0f b6 05 0d 0a 11 00 	movzbl 0x110a0d,%eax
  102df2:	0c 80                	or     $0x80,%al
  102df4:	a2 0d 0a 11 00       	mov    %al,0x110a0d
  102df9:	0f b6 05 0e 0a 11 00 	movzbl 0x110a0e,%eax
  102e00:	24 f0                	and    $0xf0,%al
  102e02:	a2 0e 0a 11 00       	mov    %al,0x110a0e
  102e07:	0f b6 05 0e 0a 11 00 	movzbl 0x110a0e,%eax
  102e0e:	24 ef                	and    $0xef,%al
  102e10:	a2 0e 0a 11 00       	mov    %al,0x110a0e
  102e15:	0f b6 05 0e 0a 11 00 	movzbl 0x110a0e,%eax
  102e1c:	24 df                	and    $0xdf,%al
  102e1e:	a2 0e 0a 11 00       	mov    %al,0x110a0e
  102e23:	0f b6 05 0e 0a 11 00 	movzbl 0x110a0e,%eax
  102e2a:	0c 40                	or     $0x40,%al
  102e2c:	a2 0e 0a 11 00       	mov    %al,0x110a0e
  102e31:	0f b6 05 0e 0a 11 00 	movzbl 0x110a0e,%eax
  102e38:	24 7f                	and    $0x7f,%al
  102e3a:	a2 0e 0a 11 00       	mov    %al,0x110a0e
  102e3f:	b8 a0 18 11 00       	mov    $0x1118a0,%eax
  102e44:	c1 e8 18             	shr    $0x18,%eax
  102e47:	a2 0f 0a 11 00       	mov    %al,0x110a0f
    gdt[SEG_TSS].sd_s = 0;
  102e4c:	0f b6 05 0d 0a 11 00 	movzbl 0x110a0d,%eax
  102e53:	24 ef                	and    $0xef,%al
  102e55:	a2 0d 0a 11 00       	mov    %al,0x110a0d

    // reload all segment registers
    lgdt(&gdt_pd);
  102e5a:	c7 04 24 10 0a 11 00 	movl   $0x110a10,(%esp)
  102e61:	e8 dd fe ff ff       	call   102d43 <lgdt>
  102e66:	66 c7 45 fe 28 00    	movw   $0x28,-0x2(%ebp)

static inline void
ltr(uint16_t sel) {
    asm volatile ("ltr %0" :: "r" (sel));
  102e6c:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
  102e70:	0f 00 d8             	ltr    %ax
}
  102e73:	90                   	nop

    // load the TSS
    ltr(GD_TSS);
}
  102e74:	90                   	nop
  102e75:	c9                   	leave  
  102e76:	c3                   	ret    

00102e77 <pmm_init>:

/* pmm_init - initialize the physical memory management */
void
pmm_init(void) {
  102e77:	f3 0f 1e fb          	endbr32 
  102e7b:	55                   	push   %ebp
  102e7c:	89 e5                	mov    %esp,%ebp
    gdt_init();
  102e7e:	e8 f6 fe ff ff       	call   102d79 <gdt_init>
}
  102e83:	90                   	nop
  102e84:	5d                   	pop    %ebp
  102e85:	c3                   	ret    

00102e86 <strlen>:
 * @s:        the input string
 *
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
  102e86:	f3 0f 1e fb          	endbr32 
  102e8a:	55                   	push   %ebp
  102e8b:	89 e5                	mov    %esp,%ebp
  102e8d:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
  102e90:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (*s ++ != '\0') {
  102e97:	eb 03                	jmp    102e9c <strlen+0x16>
        cnt ++;
  102e99:	ff 45 fc             	incl   -0x4(%ebp)
    while (*s ++ != '\0') {
  102e9c:	8b 45 08             	mov    0x8(%ebp),%eax
  102e9f:	8d 50 01             	lea    0x1(%eax),%edx
  102ea2:	89 55 08             	mov    %edx,0x8(%ebp)
  102ea5:	0f b6 00             	movzbl (%eax),%eax
  102ea8:	84 c0                	test   %al,%al
  102eaa:	75 ed                	jne    102e99 <strlen+0x13>
    }
    return cnt;
  102eac:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  102eaf:	c9                   	leave  
  102eb0:	c3                   	ret    

00102eb1 <strnlen>:
 * The return value is strlen(s), if that is less than @len, or
 * @len if there is no '\0' character among the first @len characters
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
  102eb1:	f3 0f 1e fb          	endbr32 
  102eb5:	55                   	push   %ebp
  102eb6:	89 e5                	mov    %esp,%ebp
  102eb8:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
  102ebb:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (cnt < len && *s ++ != '\0') {
  102ec2:	eb 03                	jmp    102ec7 <strnlen+0x16>
        cnt ++;
  102ec4:	ff 45 fc             	incl   -0x4(%ebp)
    while (cnt < len && *s ++ != '\0') {
  102ec7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  102eca:	3b 45 0c             	cmp    0xc(%ebp),%eax
  102ecd:	73 10                	jae    102edf <strnlen+0x2e>
  102ecf:	8b 45 08             	mov    0x8(%ebp),%eax
  102ed2:	8d 50 01             	lea    0x1(%eax),%edx
  102ed5:	89 55 08             	mov    %edx,0x8(%ebp)
  102ed8:	0f b6 00             	movzbl (%eax),%eax
  102edb:	84 c0                	test   %al,%al
  102edd:	75 e5                	jne    102ec4 <strnlen+0x13>
    }
    return cnt;
  102edf:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  102ee2:	c9                   	leave  
  102ee3:	c3                   	ret    

00102ee4 <strcpy>:
 * To avoid overflows, the size of array pointed by @dst should be long enough to
 * contain the same string as @src (including the terminating null character), and
 * should not overlap in memory with @src.
 * */
char *
strcpy(char *dst, const char *src) {
  102ee4:	f3 0f 1e fb          	endbr32 
  102ee8:	55                   	push   %ebp
  102ee9:	89 e5                	mov    %esp,%ebp
  102eeb:	57                   	push   %edi
  102eec:	56                   	push   %esi
  102eed:	83 ec 20             	sub    $0x20,%esp
  102ef0:	8b 45 08             	mov    0x8(%ebp),%eax
  102ef3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  102ef6:	8b 45 0c             	mov    0xc(%ebp),%eax
  102ef9:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCPY
#define __HAVE_ARCH_STRCPY
static inline char *
__strcpy(char *dst, const char *src) {
    int d0, d1, d2;
    asm volatile (
  102efc:	8b 55 f0             	mov    -0x10(%ebp),%edx
  102eff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102f02:	89 d1                	mov    %edx,%ecx
  102f04:	89 c2                	mov    %eax,%edx
  102f06:	89 ce                	mov    %ecx,%esi
  102f08:	89 d7                	mov    %edx,%edi
  102f0a:	ac                   	lods   %ds:(%esi),%al
  102f0b:	aa                   	stos   %al,%es:(%edi)
  102f0c:	84 c0                	test   %al,%al
  102f0e:	75 fa                	jne    102f0a <strcpy+0x26>
  102f10:	89 fa                	mov    %edi,%edx
  102f12:	89 f1                	mov    %esi,%ecx
  102f14:	89 4d ec             	mov    %ecx,-0x14(%ebp)
  102f17:	89 55 e8             	mov    %edx,-0x18(%ebp)
  102f1a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            "stosb;"
            "testb %%al, %%al;"
            "jne 1b;"
            : "=&S" (d0), "=&D" (d1), "=&a" (d2)
            : "0" (src), "1" (dst) : "memory");
    return dst;
  102f1d:	8b 45 f4             	mov    -0xc(%ebp),%eax
    char *p = dst;
    while ((*p ++ = *src ++) != '\0')
        /* nothing */;
    return dst;
#endif /* __HAVE_ARCH_STRCPY */
}
  102f20:	83 c4 20             	add    $0x20,%esp
  102f23:	5e                   	pop    %esi
  102f24:	5f                   	pop    %edi
  102f25:	5d                   	pop    %ebp
  102f26:	c3                   	ret    

00102f27 <strncpy>:
 * @len:    maximum number of characters to be copied from @src
 *
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
  102f27:	f3 0f 1e fb          	endbr32 
  102f2b:	55                   	push   %ebp
  102f2c:	89 e5                	mov    %esp,%ebp
  102f2e:	83 ec 10             	sub    $0x10,%esp
    char *p = dst;
  102f31:	8b 45 08             	mov    0x8(%ebp),%eax
  102f34:	89 45 fc             	mov    %eax,-0x4(%ebp)
    while (len > 0) {
  102f37:	eb 1e                	jmp    102f57 <strncpy+0x30>
        if ((*p = *src) != '\0') {
  102f39:	8b 45 0c             	mov    0xc(%ebp),%eax
  102f3c:	0f b6 10             	movzbl (%eax),%edx
  102f3f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  102f42:	88 10                	mov    %dl,(%eax)
  102f44:	8b 45 fc             	mov    -0x4(%ebp),%eax
  102f47:	0f b6 00             	movzbl (%eax),%eax
  102f4a:	84 c0                	test   %al,%al
  102f4c:	74 03                	je     102f51 <strncpy+0x2a>
            src ++;
  102f4e:	ff 45 0c             	incl   0xc(%ebp)
        }
        p ++, len --;
  102f51:	ff 45 fc             	incl   -0x4(%ebp)
  102f54:	ff 4d 10             	decl   0x10(%ebp)
    while (len > 0) {
  102f57:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  102f5b:	75 dc                	jne    102f39 <strncpy+0x12>
    }
    return dst;
  102f5d:	8b 45 08             	mov    0x8(%ebp),%eax
}
  102f60:	c9                   	leave  
  102f61:	c3                   	ret    

00102f62 <strcmp>:
 * - A value greater than zero indicates that the first character that does
 *   not match has a greater value in @s1 than in @s2;
 * - And a value less than zero indicates the opposite.
 * */
int
strcmp(const char *s1, const char *s2) {
  102f62:	f3 0f 1e fb          	endbr32 
  102f66:	55                   	push   %ebp
  102f67:	89 e5                	mov    %esp,%ebp
  102f69:	57                   	push   %edi
  102f6a:	56                   	push   %esi
  102f6b:	83 ec 20             	sub    $0x20,%esp
  102f6e:	8b 45 08             	mov    0x8(%ebp),%eax
  102f71:	89 45 f4             	mov    %eax,-0xc(%ebp)
  102f74:	8b 45 0c             	mov    0xc(%ebp),%eax
  102f77:	89 45 f0             	mov    %eax,-0x10(%ebp)
    asm volatile (
  102f7a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  102f7d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102f80:	89 d1                	mov    %edx,%ecx
  102f82:	89 c2                	mov    %eax,%edx
  102f84:	89 ce                	mov    %ecx,%esi
  102f86:	89 d7                	mov    %edx,%edi
  102f88:	ac                   	lods   %ds:(%esi),%al
  102f89:	ae                   	scas   %es:(%edi),%al
  102f8a:	75 08                	jne    102f94 <strcmp+0x32>
  102f8c:	84 c0                	test   %al,%al
  102f8e:	75 f8                	jne    102f88 <strcmp+0x26>
  102f90:	31 c0                	xor    %eax,%eax
  102f92:	eb 04                	jmp    102f98 <strcmp+0x36>
  102f94:	19 c0                	sbb    %eax,%eax
  102f96:	0c 01                	or     $0x1,%al
  102f98:	89 fa                	mov    %edi,%edx
  102f9a:	89 f1                	mov    %esi,%ecx
  102f9c:	89 45 ec             	mov    %eax,-0x14(%ebp)
  102f9f:	89 4d e8             	mov    %ecx,-0x18(%ebp)
  102fa2:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    return ret;
  102fa5:	8b 45 ec             	mov    -0x14(%ebp),%eax
    while (*s1 != '\0' && *s1 == *s2) {
        s1 ++, s2 ++;
    }
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
#endif /* __HAVE_ARCH_STRCMP */
}
  102fa8:	83 c4 20             	add    $0x20,%esp
  102fab:	5e                   	pop    %esi
  102fac:	5f                   	pop    %edi
  102fad:	5d                   	pop    %ebp
  102fae:	c3                   	ret    

00102faf <strncmp>:
 * they are equal to each other, it continues with the following pairs until
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
  102faf:	f3 0f 1e fb          	endbr32 
  102fb3:	55                   	push   %ebp
  102fb4:	89 e5                	mov    %esp,%ebp
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
  102fb6:	eb 09                	jmp    102fc1 <strncmp+0x12>
        n --, s1 ++, s2 ++;
  102fb8:	ff 4d 10             	decl   0x10(%ebp)
  102fbb:	ff 45 08             	incl   0x8(%ebp)
  102fbe:	ff 45 0c             	incl   0xc(%ebp)
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
  102fc1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  102fc5:	74 1a                	je     102fe1 <strncmp+0x32>
  102fc7:	8b 45 08             	mov    0x8(%ebp),%eax
  102fca:	0f b6 00             	movzbl (%eax),%eax
  102fcd:	84 c0                	test   %al,%al
  102fcf:	74 10                	je     102fe1 <strncmp+0x32>
  102fd1:	8b 45 08             	mov    0x8(%ebp),%eax
  102fd4:	0f b6 10             	movzbl (%eax),%edx
  102fd7:	8b 45 0c             	mov    0xc(%ebp),%eax
  102fda:	0f b6 00             	movzbl (%eax),%eax
  102fdd:	38 c2                	cmp    %al,%dl
  102fdf:	74 d7                	je     102fb8 <strncmp+0x9>
    }
    return (n == 0) ? 0 : (int)((unsigned char)*s1 - (unsigned char)*s2);
  102fe1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  102fe5:	74 18                	je     102fff <strncmp+0x50>
  102fe7:	8b 45 08             	mov    0x8(%ebp),%eax
  102fea:	0f b6 00             	movzbl (%eax),%eax
  102fed:	0f b6 d0             	movzbl %al,%edx
  102ff0:	8b 45 0c             	mov    0xc(%ebp),%eax
  102ff3:	0f b6 00             	movzbl (%eax),%eax
  102ff6:	0f b6 c0             	movzbl %al,%eax
  102ff9:	29 c2                	sub    %eax,%edx
  102ffb:	89 d0                	mov    %edx,%eax
  102ffd:	eb 05                	jmp    103004 <strncmp+0x55>
  102fff:	b8 00 00 00 00       	mov    $0x0,%eax
}
  103004:	5d                   	pop    %ebp
  103005:	c3                   	ret    

00103006 <strchr>:
 *
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
  103006:	f3 0f 1e fb          	endbr32 
  10300a:	55                   	push   %ebp
  10300b:	89 e5                	mov    %esp,%ebp
  10300d:	83 ec 04             	sub    $0x4,%esp
  103010:	8b 45 0c             	mov    0xc(%ebp),%eax
  103013:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
  103016:	eb 13                	jmp    10302b <strchr+0x25>
        if (*s == c) {
  103018:	8b 45 08             	mov    0x8(%ebp),%eax
  10301b:	0f b6 00             	movzbl (%eax),%eax
  10301e:	38 45 fc             	cmp    %al,-0x4(%ebp)
  103021:	75 05                	jne    103028 <strchr+0x22>
            return (char *)s;
  103023:	8b 45 08             	mov    0x8(%ebp),%eax
  103026:	eb 12                	jmp    10303a <strchr+0x34>
        }
        s ++;
  103028:	ff 45 08             	incl   0x8(%ebp)
    while (*s != '\0') {
  10302b:	8b 45 08             	mov    0x8(%ebp),%eax
  10302e:	0f b6 00             	movzbl (%eax),%eax
  103031:	84 c0                	test   %al,%al
  103033:	75 e3                	jne    103018 <strchr+0x12>
    }
    return NULL;
  103035:	b8 00 00 00 00       	mov    $0x0,%eax
}
  10303a:	c9                   	leave  
  10303b:	c3                   	ret    

0010303c <strfind>:
 * The strfind() function is like strchr() except that if @c is
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
  10303c:	f3 0f 1e fb          	endbr32 
  103040:	55                   	push   %ebp
  103041:	89 e5                	mov    %esp,%ebp
  103043:	83 ec 04             	sub    $0x4,%esp
  103046:	8b 45 0c             	mov    0xc(%ebp),%eax
  103049:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
  10304c:	eb 0e                	jmp    10305c <strfind+0x20>
        if (*s == c) {
  10304e:	8b 45 08             	mov    0x8(%ebp),%eax
  103051:	0f b6 00             	movzbl (%eax),%eax
  103054:	38 45 fc             	cmp    %al,-0x4(%ebp)
  103057:	74 0f                	je     103068 <strfind+0x2c>
            break;
        }
        s ++;
  103059:	ff 45 08             	incl   0x8(%ebp)
    while (*s != '\0') {
  10305c:	8b 45 08             	mov    0x8(%ebp),%eax
  10305f:	0f b6 00             	movzbl (%eax),%eax
  103062:	84 c0                	test   %al,%al
  103064:	75 e8                	jne    10304e <strfind+0x12>
  103066:	eb 01                	jmp    103069 <strfind+0x2d>
            break;
  103068:	90                   	nop
    }
    return (char *)s;
  103069:	8b 45 08             	mov    0x8(%ebp),%eax
}
  10306c:	c9                   	leave  
  10306d:	c3                   	ret    

0010306e <strtol>:
 * an optional "0x" or "0X" prefix.
 *
 * The strtol() function returns the converted integral number as a long int value.
 * */
long
strtol(const char *s, char **endptr, int base) {
  10306e:	f3 0f 1e fb          	endbr32 
  103072:	55                   	push   %ebp
  103073:	89 e5                	mov    %esp,%ebp
  103075:	83 ec 10             	sub    $0x10,%esp
    int neg = 0;
  103078:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    long val = 0;
  10307f:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
  103086:	eb 03                	jmp    10308b <strtol+0x1d>
        s ++;
  103088:	ff 45 08             	incl   0x8(%ebp)
    while (*s == ' ' || *s == '\t') {
  10308b:	8b 45 08             	mov    0x8(%ebp),%eax
  10308e:	0f b6 00             	movzbl (%eax),%eax
  103091:	3c 20                	cmp    $0x20,%al
  103093:	74 f3                	je     103088 <strtol+0x1a>
  103095:	8b 45 08             	mov    0x8(%ebp),%eax
  103098:	0f b6 00             	movzbl (%eax),%eax
  10309b:	3c 09                	cmp    $0x9,%al
  10309d:	74 e9                	je     103088 <strtol+0x1a>
    }

    // plus/minus sign
    if (*s == '+') {
  10309f:	8b 45 08             	mov    0x8(%ebp),%eax
  1030a2:	0f b6 00             	movzbl (%eax),%eax
  1030a5:	3c 2b                	cmp    $0x2b,%al
  1030a7:	75 05                	jne    1030ae <strtol+0x40>
        s ++;
  1030a9:	ff 45 08             	incl   0x8(%ebp)
  1030ac:	eb 14                	jmp    1030c2 <strtol+0x54>
    }
    else if (*s == '-') {
  1030ae:	8b 45 08             	mov    0x8(%ebp),%eax
  1030b1:	0f b6 00             	movzbl (%eax),%eax
  1030b4:	3c 2d                	cmp    $0x2d,%al
  1030b6:	75 0a                	jne    1030c2 <strtol+0x54>
        s ++, neg = 1;
  1030b8:	ff 45 08             	incl   0x8(%ebp)
  1030bb:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
    }

    // hex or octal base prefix
    if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x')) {
  1030c2:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  1030c6:	74 06                	je     1030ce <strtol+0x60>
  1030c8:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  1030cc:	75 22                	jne    1030f0 <strtol+0x82>
  1030ce:	8b 45 08             	mov    0x8(%ebp),%eax
  1030d1:	0f b6 00             	movzbl (%eax),%eax
  1030d4:	3c 30                	cmp    $0x30,%al
  1030d6:	75 18                	jne    1030f0 <strtol+0x82>
  1030d8:	8b 45 08             	mov    0x8(%ebp),%eax
  1030db:	40                   	inc    %eax
  1030dc:	0f b6 00             	movzbl (%eax),%eax
  1030df:	3c 78                	cmp    $0x78,%al
  1030e1:	75 0d                	jne    1030f0 <strtol+0x82>
        s += 2, base = 16;
  1030e3:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  1030e7:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  1030ee:	eb 29                	jmp    103119 <strtol+0xab>
    }
    else if (base == 0 && s[0] == '0') {
  1030f0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  1030f4:	75 16                	jne    10310c <strtol+0x9e>
  1030f6:	8b 45 08             	mov    0x8(%ebp),%eax
  1030f9:	0f b6 00             	movzbl (%eax),%eax
  1030fc:	3c 30                	cmp    $0x30,%al
  1030fe:	75 0c                	jne    10310c <strtol+0x9e>
        s ++, base = 8;
  103100:	ff 45 08             	incl   0x8(%ebp)
  103103:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  10310a:	eb 0d                	jmp    103119 <strtol+0xab>
    }
    else if (base == 0) {
  10310c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  103110:	75 07                	jne    103119 <strtol+0xab>
        base = 10;
  103112:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

    // digits
    while (1) {
        int dig;

        if (*s >= '0' && *s <= '9') {
  103119:	8b 45 08             	mov    0x8(%ebp),%eax
  10311c:	0f b6 00             	movzbl (%eax),%eax
  10311f:	3c 2f                	cmp    $0x2f,%al
  103121:	7e 1b                	jle    10313e <strtol+0xd0>
  103123:	8b 45 08             	mov    0x8(%ebp),%eax
  103126:	0f b6 00             	movzbl (%eax),%eax
  103129:	3c 39                	cmp    $0x39,%al
  10312b:	7f 11                	jg     10313e <strtol+0xd0>
            dig = *s - '0';
  10312d:	8b 45 08             	mov    0x8(%ebp),%eax
  103130:	0f b6 00             	movzbl (%eax),%eax
  103133:	0f be c0             	movsbl %al,%eax
  103136:	83 e8 30             	sub    $0x30,%eax
  103139:	89 45 f4             	mov    %eax,-0xc(%ebp)
  10313c:	eb 48                	jmp    103186 <strtol+0x118>
        }
        else if (*s >= 'a' && *s <= 'z') {
  10313e:	8b 45 08             	mov    0x8(%ebp),%eax
  103141:	0f b6 00             	movzbl (%eax),%eax
  103144:	3c 60                	cmp    $0x60,%al
  103146:	7e 1b                	jle    103163 <strtol+0xf5>
  103148:	8b 45 08             	mov    0x8(%ebp),%eax
  10314b:	0f b6 00             	movzbl (%eax),%eax
  10314e:	3c 7a                	cmp    $0x7a,%al
  103150:	7f 11                	jg     103163 <strtol+0xf5>
            dig = *s - 'a' + 10;
  103152:	8b 45 08             	mov    0x8(%ebp),%eax
  103155:	0f b6 00             	movzbl (%eax),%eax
  103158:	0f be c0             	movsbl %al,%eax
  10315b:	83 e8 57             	sub    $0x57,%eax
  10315e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  103161:	eb 23                	jmp    103186 <strtol+0x118>
        }
        else if (*s >= 'A' && *s <= 'Z') {
  103163:	8b 45 08             	mov    0x8(%ebp),%eax
  103166:	0f b6 00             	movzbl (%eax),%eax
  103169:	3c 40                	cmp    $0x40,%al
  10316b:	7e 3b                	jle    1031a8 <strtol+0x13a>
  10316d:	8b 45 08             	mov    0x8(%ebp),%eax
  103170:	0f b6 00             	movzbl (%eax),%eax
  103173:	3c 5a                	cmp    $0x5a,%al
  103175:	7f 31                	jg     1031a8 <strtol+0x13a>
            dig = *s - 'A' + 10;
  103177:	8b 45 08             	mov    0x8(%ebp),%eax
  10317a:	0f b6 00             	movzbl (%eax),%eax
  10317d:	0f be c0             	movsbl %al,%eax
  103180:	83 e8 37             	sub    $0x37,%eax
  103183:	89 45 f4             	mov    %eax,-0xc(%ebp)
        }
        else {
            break;
        }
        if (dig >= base) {
  103186:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103189:	3b 45 10             	cmp    0x10(%ebp),%eax
  10318c:	7d 19                	jge    1031a7 <strtol+0x139>
            break;
        }
        s ++, val = (val * base) + dig;
  10318e:	ff 45 08             	incl   0x8(%ebp)
  103191:	8b 45 f8             	mov    -0x8(%ebp),%eax
  103194:	0f af 45 10          	imul   0x10(%ebp),%eax
  103198:	89 c2                	mov    %eax,%edx
  10319a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10319d:	01 d0                	add    %edx,%eax
  10319f:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while (1) {
  1031a2:	e9 72 ff ff ff       	jmp    103119 <strtol+0xab>
            break;
  1031a7:	90                   	nop
        // we don't properly detect overflow!
    }

    if (endptr) {
  1031a8:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  1031ac:	74 08                	je     1031b6 <strtol+0x148>
        *endptr = (char *) s;
  1031ae:	8b 45 0c             	mov    0xc(%ebp),%eax
  1031b1:	8b 55 08             	mov    0x8(%ebp),%edx
  1031b4:	89 10                	mov    %edx,(%eax)
    }
    return (neg ? -val : val);
  1031b6:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  1031ba:	74 07                	je     1031c3 <strtol+0x155>
  1031bc:	8b 45 f8             	mov    -0x8(%ebp),%eax
  1031bf:	f7 d8                	neg    %eax
  1031c1:	eb 03                	jmp    1031c6 <strtol+0x158>
  1031c3:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  1031c6:	c9                   	leave  
  1031c7:	c3                   	ret    

001031c8 <memset>:
 * @n:        number of bytes to be set to the value
 *
 * The memset() function returns @s.
 * */
void *
memset(void *s, char c, size_t n) {
  1031c8:	f3 0f 1e fb          	endbr32 
  1031cc:	55                   	push   %ebp
  1031cd:	89 e5                	mov    %esp,%ebp
  1031cf:	57                   	push   %edi
  1031d0:	83 ec 24             	sub    $0x24,%esp
  1031d3:	8b 45 0c             	mov    0xc(%ebp),%eax
  1031d6:	88 45 d8             	mov    %al,-0x28(%ebp)
#ifdef __HAVE_ARCH_MEMSET
    return __memset(s, c, n);
  1031d9:	0f be 55 d8          	movsbl -0x28(%ebp),%edx
  1031dd:	8b 45 08             	mov    0x8(%ebp),%eax
  1031e0:	89 45 f8             	mov    %eax,-0x8(%ebp)
  1031e3:	88 55 f7             	mov    %dl,-0x9(%ebp)
  1031e6:	8b 45 10             	mov    0x10(%ebp),%eax
  1031e9:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_MEMSET
#define __HAVE_ARCH_MEMSET
static inline void *
__memset(void *s, char c, size_t n) {
    int d0, d1;
    asm volatile (
  1031ec:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  1031ef:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  1031f3:	8b 55 f8             	mov    -0x8(%ebp),%edx
  1031f6:	89 d7                	mov    %edx,%edi
  1031f8:	f3 aa                	rep stos %al,%es:(%edi)
  1031fa:	89 fa                	mov    %edi,%edx
  1031fc:	89 4d ec             	mov    %ecx,-0x14(%ebp)
  1031ff:	89 55 e8             	mov    %edx,-0x18(%ebp)
            "rep; stosb;"
            : "=&c" (d0), "=&D" (d1)
            : "0" (n), "a" (c), "1" (s)
            : "memory");
    return s;
  103202:	8b 45 f8             	mov    -0x8(%ebp),%eax
    while (n -- > 0) {
        *p ++ = c;
    }
    return s;
#endif /* __HAVE_ARCH_MEMSET */
}
  103205:	83 c4 24             	add    $0x24,%esp
  103208:	5f                   	pop    %edi
  103209:	5d                   	pop    %ebp
  10320a:	c3                   	ret    

0010320b <memmove>:
 * @n:        number of bytes to copy
 *
 * The memmove() function returns @dst.
 * */
void *
memmove(void *dst, const void *src, size_t n) {
  10320b:	f3 0f 1e fb          	endbr32 
  10320f:	55                   	push   %ebp
  103210:	89 e5                	mov    %esp,%ebp
  103212:	57                   	push   %edi
  103213:	56                   	push   %esi
  103214:	53                   	push   %ebx
  103215:	83 ec 30             	sub    $0x30,%esp
  103218:	8b 45 08             	mov    0x8(%ebp),%eax
  10321b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  10321e:	8b 45 0c             	mov    0xc(%ebp),%eax
  103221:	89 45 ec             	mov    %eax,-0x14(%ebp)
  103224:	8b 45 10             	mov    0x10(%ebp),%eax
  103227:	89 45 e8             	mov    %eax,-0x18(%ebp)

#ifndef __HAVE_ARCH_MEMMOVE
#define __HAVE_ARCH_MEMMOVE
static inline void *
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
  10322a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10322d:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  103230:	73 42                	jae    103274 <memmove+0x69>
  103232:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103235:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  103238:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10323b:	89 45 e0             	mov    %eax,-0x20(%ebp)
  10323e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  103241:	89 45 dc             	mov    %eax,-0x24(%ebp)
            "andl $3, %%ecx;"
            "jz 1f;"
            "rep; movsb;"
            "1:"
            : "=&c" (d0), "=&D" (d1), "=&S" (d2)
            : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
  103244:	8b 45 dc             	mov    -0x24(%ebp),%eax
  103247:	c1 e8 02             	shr    $0x2,%eax
  10324a:	89 c1                	mov    %eax,%ecx
    asm volatile (
  10324c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  10324f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  103252:	89 d7                	mov    %edx,%edi
  103254:	89 c6                	mov    %eax,%esi
  103256:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  103258:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  10325b:	83 e1 03             	and    $0x3,%ecx
  10325e:	74 02                	je     103262 <memmove+0x57>
  103260:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  103262:	89 f0                	mov    %esi,%eax
  103264:	89 fa                	mov    %edi,%edx
  103266:	89 4d d8             	mov    %ecx,-0x28(%ebp)
  103269:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  10326c:	89 45 d0             	mov    %eax,-0x30(%ebp)
            : "memory");
    return dst;
  10326f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
        return __memcpy(dst, src, n);
  103272:	eb 36                	jmp    1032aa <memmove+0x9f>
            : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
  103274:	8b 45 e8             	mov    -0x18(%ebp),%eax
  103277:	8d 50 ff             	lea    -0x1(%eax),%edx
  10327a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10327d:	01 c2                	add    %eax,%edx
  10327f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  103282:	8d 48 ff             	lea    -0x1(%eax),%ecx
  103285:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103288:	8d 1c 01             	lea    (%ecx,%eax,1),%ebx
    asm volatile (
  10328b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10328e:	89 c1                	mov    %eax,%ecx
  103290:	89 d8                	mov    %ebx,%eax
  103292:	89 d6                	mov    %edx,%esi
  103294:	89 c7                	mov    %eax,%edi
  103296:	fd                   	std    
  103297:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  103299:	fc                   	cld    
  10329a:	89 f8                	mov    %edi,%eax
  10329c:	89 f2                	mov    %esi,%edx
  10329e:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  1032a1:	89 55 c8             	mov    %edx,-0x38(%ebp)
  1032a4:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    return dst;
  1032a7:	8b 45 f0             	mov    -0x10(%ebp),%eax
            *d ++ = *s ++;
        }
    }
    return dst;
#endif /* __HAVE_ARCH_MEMMOVE */
}
  1032aa:	83 c4 30             	add    $0x30,%esp
  1032ad:	5b                   	pop    %ebx
  1032ae:	5e                   	pop    %esi
  1032af:	5f                   	pop    %edi
  1032b0:	5d                   	pop    %ebp
  1032b1:	c3                   	ret    

001032b2 <memcpy>:
 * it always copies exactly @n bytes. To avoid overflows, the size of arrays pointed
 * by both @src and @dst, should be at least @n bytes, and should not overlap
 * (for overlapping memory area, memmove is a safer approach).
 * */
void *
memcpy(void *dst, const void *src, size_t n) {
  1032b2:	f3 0f 1e fb          	endbr32 
  1032b6:	55                   	push   %ebp
  1032b7:	89 e5                	mov    %esp,%ebp
  1032b9:	57                   	push   %edi
  1032ba:	56                   	push   %esi
  1032bb:	83 ec 20             	sub    $0x20,%esp
  1032be:	8b 45 08             	mov    0x8(%ebp),%eax
  1032c1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1032c4:	8b 45 0c             	mov    0xc(%ebp),%eax
  1032c7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1032ca:	8b 45 10             	mov    0x10(%ebp),%eax
  1032cd:	89 45 ec             	mov    %eax,-0x14(%ebp)
            : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
  1032d0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1032d3:	c1 e8 02             	shr    $0x2,%eax
  1032d6:	89 c1                	mov    %eax,%ecx
    asm volatile (
  1032d8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1032db:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1032de:	89 d7                	mov    %edx,%edi
  1032e0:	89 c6                	mov    %eax,%esi
  1032e2:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  1032e4:	8b 4d ec             	mov    -0x14(%ebp),%ecx
  1032e7:	83 e1 03             	and    $0x3,%ecx
  1032ea:	74 02                	je     1032ee <memcpy+0x3c>
  1032ec:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  1032ee:	89 f0                	mov    %esi,%eax
  1032f0:	89 fa                	mov    %edi,%edx
  1032f2:	89 4d e8             	mov    %ecx,-0x18(%ebp)
  1032f5:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  1032f8:	89 45 e0             	mov    %eax,-0x20(%ebp)
    return dst;
  1032fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
    while (n -- > 0) {
        *d ++ = *s ++;
    }
    return dst;
#endif /* __HAVE_ARCH_MEMCPY */
}
  1032fe:	83 c4 20             	add    $0x20,%esp
  103301:	5e                   	pop    %esi
  103302:	5f                   	pop    %edi
  103303:	5d                   	pop    %ebp
  103304:	c3                   	ret    

00103305 <memcmp>:
 *   match in both memory blocks has a greater value in @v1 than in @v2
 *   as if evaluated as unsigned char values;
 * - And a value less than zero indicates the opposite.
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
  103305:	f3 0f 1e fb          	endbr32 
  103309:	55                   	push   %ebp
  10330a:	89 e5                	mov    %esp,%ebp
  10330c:	83 ec 10             	sub    $0x10,%esp
    const char *s1 = (const char *)v1;
  10330f:	8b 45 08             	mov    0x8(%ebp),%eax
  103312:	89 45 fc             	mov    %eax,-0x4(%ebp)
    const char *s2 = (const char *)v2;
  103315:	8b 45 0c             	mov    0xc(%ebp),%eax
  103318:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while (n -- > 0) {
  10331b:	eb 2e                	jmp    10334b <memcmp+0x46>
        if (*s1 != *s2) {
  10331d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  103320:	0f b6 10             	movzbl (%eax),%edx
  103323:	8b 45 f8             	mov    -0x8(%ebp),%eax
  103326:	0f b6 00             	movzbl (%eax),%eax
  103329:	38 c2                	cmp    %al,%dl
  10332b:	74 18                	je     103345 <memcmp+0x40>
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
  10332d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  103330:	0f b6 00             	movzbl (%eax),%eax
  103333:	0f b6 d0             	movzbl %al,%edx
  103336:	8b 45 f8             	mov    -0x8(%ebp),%eax
  103339:	0f b6 00             	movzbl (%eax),%eax
  10333c:	0f b6 c0             	movzbl %al,%eax
  10333f:	29 c2                	sub    %eax,%edx
  103341:	89 d0                	mov    %edx,%eax
  103343:	eb 18                	jmp    10335d <memcmp+0x58>
        }
        s1 ++, s2 ++;
  103345:	ff 45 fc             	incl   -0x4(%ebp)
  103348:	ff 45 f8             	incl   -0x8(%ebp)
    while (n -- > 0) {
  10334b:	8b 45 10             	mov    0x10(%ebp),%eax
  10334e:	8d 50 ff             	lea    -0x1(%eax),%edx
  103351:	89 55 10             	mov    %edx,0x10(%ebp)
  103354:	85 c0                	test   %eax,%eax
  103356:	75 c5                	jne    10331d <memcmp+0x18>
    }
    return 0;
  103358:	b8 00 00 00 00       	mov    $0x0,%eax
}
  10335d:	c9                   	leave  
  10335e:	c3                   	ret    

0010335f <printnum>:
 * @width:         maximum number of digits, if the actual width is less than @width, use @padc instead
 * @padc:        character that padded on the left if the actual width is less than @width
 * */
static void
printnum(void (*putch)(int, void*), void *putdat,
        unsigned long long num, unsigned base, int width, int padc) {
  10335f:	f3 0f 1e fb          	endbr32 
  103363:	55                   	push   %ebp
  103364:	89 e5                	mov    %esp,%ebp
  103366:	83 ec 58             	sub    $0x58,%esp
  103369:	8b 45 10             	mov    0x10(%ebp),%eax
  10336c:	89 45 d0             	mov    %eax,-0x30(%ebp)
  10336f:	8b 45 14             	mov    0x14(%ebp),%eax
  103372:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    unsigned long long result = num;
  103375:	8b 45 d0             	mov    -0x30(%ebp),%eax
  103378:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  10337b:	89 45 e8             	mov    %eax,-0x18(%ebp)
  10337e:	89 55 ec             	mov    %edx,-0x14(%ebp)
    unsigned mod = do_div(result, base);
  103381:	8b 45 18             	mov    0x18(%ebp),%eax
  103384:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  103387:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10338a:	8b 55 ec             	mov    -0x14(%ebp),%edx
  10338d:	89 45 e0             	mov    %eax,-0x20(%ebp)
  103390:	89 55 f0             	mov    %edx,-0x10(%ebp)
  103393:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103396:	89 45 f4             	mov    %eax,-0xc(%ebp)
  103399:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  10339d:	74 1c                	je     1033bb <printnum+0x5c>
  10339f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1033a2:	ba 00 00 00 00       	mov    $0x0,%edx
  1033a7:	f7 75 e4             	divl   -0x1c(%ebp)
  1033aa:	89 55 f4             	mov    %edx,-0xc(%ebp)
  1033ad:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1033b0:	ba 00 00 00 00       	mov    $0x0,%edx
  1033b5:	f7 75 e4             	divl   -0x1c(%ebp)
  1033b8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1033bb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1033be:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1033c1:	f7 75 e4             	divl   -0x1c(%ebp)
  1033c4:	89 45 e0             	mov    %eax,-0x20(%ebp)
  1033c7:	89 55 dc             	mov    %edx,-0x24(%ebp)
  1033ca:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1033cd:	8b 55 f0             	mov    -0x10(%ebp),%edx
  1033d0:	89 45 e8             	mov    %eax,-0x18(%ebp)
  1033d3:	89 55 ec             	mov    %edx,-0x14(%ebp)
  1033d6:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1033d9:	89 45 d8             	mov    %eax,-0x28(%ebp)

    // first recursively print all preceding (more significant) digits
    if (num >= base) {
  1033dc:	8b 45 18             	mov    0x18(%ebp),%eax
  1033df:	ba 00 00 00 00       	mov    $0x0,%edx
  1033e4:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  1033e7:	39 45 d0             	cmp    %eax,-0x30(%ebp)
  1033ea:	19 d1                	sbb    %edx,%ecx
  1033ec:	72 4c                	jb     10343a <printnum+0xdb>
        printnum(putch, putdat, result, base, width - 1, padc);
  1033ee:	8b 45 1c             	mov    0x1c(%ebp),%eax
  1033f1:	8d 50 ff             	lea    -0x1(%eax),%edx
  1033f4:	8b 45 20             	mov    0x20(%ebp),%eax
  1033f7:	89 44 24 18          	mov    %eax,0x18(%esp)
  1033fb:	89 54 24 14          	mov    %edx,0x14(%esp)
  1033ff:	8b 45 18             	mov    0x18(%ebp),%eax
  103402:	89 44 24 10          	mov    %eax,0x10(%esp)
  103406:	8b 45 e8             	mov    -0x18(%ebp),%eax
  103409:	8b 55 ec             	mov    -0x14(%ebp),%edx
  10340c:	89 44 24 08          	mov    %eax,0x8(%esp)
  103410:	89 54 24 0c          	mov    %edx,0xc(%esp)
  103414:	8b 45 0c             	mov    0xc(%ebp),%eax
  103417:	89 44 24 04          	mov    %eax,0x4(%esp)
  10341b:	8b 45 08             	mov    0x8(%ebp),%eax
  10341e:	89 04 24             	mov    %eax,(%esp)
  103421:	e8 39 ff ff ff       	call   10335f <printnum>
  103426:	eb 1b                	jmp    103443 <printnum+0xe4>
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
            putch(padc, putdat);
  103428:	8b 45 0c             	mov    0xc(%ebp),%eax
  10342b:	89 44 24 04          	mov    %eax,0x4(%esp)
  10342f:	8b 45 20             	mov    0x20(%ebp),%eax
  103432:	89 04 24             	mov    %eax,(%esp)
  103435:	8b 45 08             	mov    0x8(%ebp),%eax
  103438:	ff d0                	call   *%eax
        while (-- width > 0)
  10343a:	ff 4d 1c             	decl   0x1c(%ebp)
  10343d:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  103441:	7f e5                	jg     103428 <printnum+0xc9>
    }
    // then print this (the least significant) digit
    putch("0123456789abcdef"[mod], putdat);
  103443:	8b 45 d8             	mov    -0x28(%ebp),%eax
  103446:	05 f0 41 10 00       	add    $0x1041f0,%eax
  10344b:	0f b6 00             	movzbl (%eax),%eax
  10344e:	0f be c0             	movsbl %al,%eax
  103451:	8b 55 0c             	mov    0xc(%ebp),%edx
  103454:	89 54 24 04          	mov    %edx,0x4(%esp)
  103458:	89 04 24             	mov    %eax,(%esp)
  10345b:	8b 45 08             	mov    0x8(%ebp),%eax
  10345e:	ff d0                	call   *%eax
}
  103460:	90                   	nop
  103461:	c9                   	leave  
  103462:	c3                   	ret    

00103463 <getuint>:
 * getuint - get an unsigned int of various possible sizes from a varargs list
 * @ap:            a varargs list pointer
 * @lflag:        determines the size of the vararg that @ap points to
 * */
static unsigned long long
getuint(va_list *ap, int lflag) {
  103463:	f3 0f 1e fb          	endbr32 
  103467:	55                   	push   %ebp
  103468:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
  10346a:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  10346e:	7e 14                	jle    103484 <getuint+0x21>
        return va_arg(*ap, unsigned long long);
  103470:	8b 45 08             	mov    0x8(%ebp),%eax
  103473:	8b 00                	mov    (%eax),%eax
  103475:	8d 48 08             	lea    0x8(%eax),%ecx
  103478:	8b 55 08             	mov    0x8(%ebp),%edx
  10347b:	89 0a                	mov    %ecx,(%edx)
  10347d:	8b 50 04             	mov    0x4(%eax),%edx
  103480:	8b 00                	mov    (%eax),%eax
  103482:	eb 30                	jmp    1034b4 <getuint+0x51>
    }
    else if (lflag) {
  103484:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  103488:	74 16                	je     1034a0 <getuint+0x3d>
        return va_arg(*ap, unsigned long);
  10348a:	8b 45 08             	mov    0x8(%ebp),%eax
  10348d:	8b 00                	mov    (%eax),%eax
  10348f:	8d 48 04             	lea    0x4(%eax),%ecx
  103492:	8b 55 08             	mov    0x8(%ebp),%edx
  103495:	89 0a                	mov    %ecx,(%edx)
  103497:	8b 00                	mov    (%eax),%eax
  103499:	ba 00 00 00 00       	mov    $0x0,%edx
  10349e:	eb 14                	jmp    1034b4 <getuint+0x51>
    }
    else {
        return va_arg(*ap, unsigned int);
  1034a0:	8b 45 08             	mov    0x8(%ebp),%eax
  1034a3:	8b 00                	mov    (%eax),%eax
  1034a5:	8d 48 04             	lea    0x4(%eax),%ecx
  1034a8:	8b 55 08             	mov    0x8(%ebp),%edx
  1034ab:	89 0a                	mov    %ecx,(%edx)
  1034ad:	8b 00                	mov    (%eax),%eax
  1034af:	ba 00 00 00 00       	mov    $0x0,%edx
    }
}
  1034b4:	5d                   	pop    %ebp
  1034b5:	c3                   	ret    

001034b6 <getint>:
 * getint - same as getuint but signed, we can't use getuint because of sign extension
 * @ap:            a varargs list pointer
 * @lflag:        determines the size of the vararg that @ap points to
 * */
static long long
getint(va_list *ap, int lflag) {
  1034b6:	f3 0f 1e fb          	endbr32 
  1034ba:	55                   	push   %ebp
  1034bb:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
  1034bd:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  1034c1:	7e 14                	jle    1034d7 <getint+0x21>
        return va_arg(*ap, long long);
  1034c3:	8b 45 08             	mov    0x8(%ebp),%eax
  1034c6:	8b 00                	mov    (%eax),%eax
  1034c8:	8d 48 08             	lea    0x8(%eax),%ecx
  1034cb:	8b 55 08             	mov    0x8(%ebp),%edx
  1034ce:	89 0a                	mov    %ecx,(%edx)
  1034d0:	8b 50 04             	mov    0x4(%eax),%edx
  1034d3:	8b 00                	mov    (%eax),%eax
  1034d5:	eb 28                	jmp    1034ff <getint+0x49>
    }
    else if (lflag) {
  1034d7:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  1034db:	74 12                	je     1034ef <getint+0x39>
        return va_arg(*ap, long);
  1034dd:	8b 45 08             	mov    0x8(%ebp),%eax
  1034e0:	8b 00                	mov    (%eax),%eax
  1034e2:	8d 48 04             	lea    0x4(%eax),%ecx
  1034e5:	8b 55 08             	mov    0x8(%ebp),%edx
  1034e8:	89 0a                	mov    %ecx,(%edx)
  1034ea:	8b 00                	mov    (%eax),%eax
  1034ec:	99                   	cltd   
  1034ed:	eb 10                	jmp    1034ff <getint+0x49>
    }
    else {
        return va_arg(*ap, int);
  1034ef:	8b 45 08             	mov    0x8(%ebp),%eax
  1034f2:	8b 00                	mov    (%eax),%eax
  1034f4:	8d 48 04             	lea    0x4(%eax),%ecx
  1034f7:	8b 55 08             	mov    0x8(%ebp),%edx
  1034fa:	89 0a                	mov    %ecx,(%edx)
  1034fc:	8b 00                	mov    (%eax),%eax
  1034fe:	99                   	cltd   
    }
}
  1034ff:	5d                   	pop    %ebp
  103500:	c3                   	ret    

00103501 <printfmt>:
 * @putch:        specified putch function, print a single character
 * @putdat:        used by @putch function
 * @fmt:        the format string to use
 * */
void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
  103501:	f3 0f 1e fb          	endbr32 
  103505:	55                   	push   %ebp
  103506:	89 e5                	mov    %esp,%ebp
  103508:	83 ec 28             	sub    $0x28,%esp
    va_list ap;

    va_start(ap, fmt);
  10350b:	8d 45 14             	lea    0x14(%ebp),%eax
  10350e:	89 45 f4             	mov    %eax,-0xc(%ebp)
    vprintfmt(putch, putdat, fmt, ap);
  103511:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103514:	89 44 24 0c          	mov    %eax,0xc(%esp)
  103518:	8b 45 10             	mov    0x10(%ebp),%eax
  10351b:	89 44 24 08          	mov    %eax,0x8(%esp)
  10351f:	8b 45 0c             	mov    0xc(%ebp),%eax
  103522:	89 44 24 04          	mov    %eax,0x4(%esp)
  103526:	8b 45 08             	mov    0x8(%ebp),%eax
  103529:	89 04 24             	mov    %eax,(%esp)
  10352c:	e8 03 00 00 00       	call   103534 <vprintfmt>
    va_end(ap);
}
  103531:	90                   	nop
  103532:	c9                   	leave  
  103533:	c3                   	ret    

00103534 <vprintfmt>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want printfmt() instead.
 * */
void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap) {
  103534:	f3 0f 1e fb          	endbr32 
  103538:	55                   	push   %ebp
  103539:	89 e5                	mov    %esp,%ebp
  10353b:	56                   	push   %esi
  10353c:	53                   	push   %ebx
  10353d:	83 ec 40             	sub    $0x40,%esp
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  103540:	eb 17                	jmp    103559 <vprintfmt+0x25>
            if (ch == '\0') {
  103542:	85 db                	test   %ebx,%ebx
  103544:	0f 84 c0 03 00 00    	je     10390a <vprintfmt+0x3d6>
                return;
            }
            putch(ch, putdat);
  10354a:	8b 45 0c             	mov    0xc(%ebp),%eax
  10354d:	89 44 24 04          	mov    %eax,0x4(%esp)
  103551:	89 1c 24             	mov    %ebx,(%esp)
  103554:	8b 45 08             	mov    0x8(%ebp),%eax
  103557:	ff d0                	call   *%eax
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  103559:	8b 45 10             	mov    0x10(%ebp),%eax
  10355c:	8d 50 01             	lea    0x1(%eax),%edx
  10355f:	89 55 10             	mov    %edx,0x10(%ebp)
  103562:	0f b6 00             	movzbl (%eax),%eax
  103565:	0f b6 d8             	movzbl %al,%ebx
  103568:	83 fb 25             	cmp    $0x25,%ebx
  10356b:	75 d5                	jne    103542 <vprintfmt+0xe>
        }

        // Process a %-escape sequence
        char padc = ' ';
  10356d:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
        width = precision = -1;
  103571:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  103578:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10357b:	89 45 e8             	mov    %eax,-0x18(%ebp)
        lflag = altflag = 0;
  10357e:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  103585:	8b 45 dc             	mov    -0x24(%ebp),%eax
  103588:	89 45 e0             	mov    %eax,-0x20(%ebp)

    reswitch:
        switch (ch = *(unsigned char *)fmt ++) {
  10358b:	8b 45 10             	mov    0x10(%ebp),%eax
  10358e:	8d 50 01             	lea    0x1(%eax),%edx
  103591:	89 55 10             	mov    %edx,0x10(%ebp)
  103594:	0f b6 00             	movzbl (%eax),%eax
  103597:	0f b6 d8             	movzbl %al,%ebx
  10359a:	8d 43 dd             	lea    -0x23(%ebx),%eax
  10359d:	83 f8 55             	cmp    $0x55,%eax
  1035a0:	0f 87 38 03 00 00    	ja     1038de <vprintfmt+0x3aa>
  1035a6:	8b 04 85 14 42 10 00 	mov    0x104214(,%eax,4),%eax
  1035ad:	3e ff e0             	notrack jmp *%eax

        // flag to pad on the right
        case '-':
            padc = '-';
  1035b0:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
            goto reswitch;
  1035b4:	eb d5                	jmp    10358b <vprintfmt+0x57>

        // flag to pad with 0's instead of spaces
        case '0':
            padc = '0';
  1035b6:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
            goto reswitch;
  1035ba:	eb cf                	jmp    10358b <vprintfmt+0x57>

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
  1035bc:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
                precision = precision * 10 + ch - '0';
  1035c3:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  1035c6:	89 d0                	mov    %edx,%eax
  1035c8:	c1 e0 02             	shl    $0x2,%eax
  1035cb:	01 d0                	add    %edx,%eax
  1035cd:	01 c0                	add    %eax,%eax
  1035cf:	01 d8                	add    %ebx,%eax
  1035d1:	83 e8 30             	sub    $0x30,%eax
  1035d4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
                ch = *fmt;
  1035d7:	8b 45 10             	mov    0x10(%ebp),%eax
  1035da:	0f b6 00             	movzbl (%eax),%eax
  1035dd:	0f be d8             	movsbl %al,%ebx
                if (ch < '0' || ch > '9') {
  1035e0:	83 fb 2f             	cmp    $0x2f,%ebx
  1035e3:	7e 38                	jle    10361d <vprintfmt+0xe9>
  1035e5:	83 fb 39             	cmp    $0x39,%ebx
  1035e8:	7f 33                	jg     10361d <vprintfmt+0xe9>
            for (precision = 0; ; ++ fmt) {
  1035ea:	ff 45 10             	incl   0x10(%ebp)
                precision = precision * 10 + ch - '0';
  1035ed:	eb d4                	jmp    1035c3 <vprintfmt+0x8f>
                }
            }
            goto process_precision;

        case '*':
            precision = va_arg(ap, int);
  1035ef:	8b 45 14             	mov    0x14(%ebp),%eax
  1035f2:	8d 50 04             	lea    0x4(%eax),%edx
  1035f5:	89 55 14             	mov    %edx,0x14(%ebp)
  1035f8:	8b 00                	mov    (%eax),%eax
  1035fa:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            goto process_precision;
  1035fd:	eb 1f                	jmp    10361e <vprintfmt+0xea>

        case '.':
            if (width < 0)
  1035ff:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  103603:	79 86                	jns    10358b <vprintfmt+0x57>
                width = 0;
  103605:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
            goto reswitch;
  10360c:	e9 7a ff ff ff       	jmp    10358b <vprintfmt+0x57>

        case '#':
            altflag = 1;
  103611:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
            goto reswitch;
  103618:	e9 6e ff ff ff       	jmp    10358b <vprintfmt+0x57>
            goto process_precision;
  10361d:	90                   	nop

        process_precision:
            if (width < 0)
  10361e:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  103622:	0f 89 63 ff ff ff    	jns    10358b <vprintfmt+0x57>
                width = precision, precision = -1;
  103628:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10362b:	89 45 e8             	mov    %eax,-0x18(%ebp)
  10362e:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
            goto reswitch;
  103635:	e9 51 ff ff ff       	jmp    10358b <vprintfmt+0x57>

        // long flag (doubled for long long)
        case 'l':
            lflag ++;
  10363a:	ff 45 e0             	incl   -0x20(%ebp)
            goto reswitch;
  10363d:	e9 49 ff ff ff       	jmp    10358b <vprintfmt+0x57>

        // character
        case 'c':
            putch(va_arg(ap, int), putdat);
  103642:	8b 45 14             	mov    0x14(%ebp),%eax
  103645:	8d 50 04             	lea    0x4(%eax),%edx
  103648:	89 55 14             	mov    %edx,0x14(%ebp)
  10364b:	8b 00                	mov    (%eax),%eax
  10364d:	8b 55 0c             	mov    0xc(%ebp),%edx
  103650:	89 54 24 04          	mov    %edx,0x4(%esp)
  103654:	89 04 24             	mov    %eax,(%esp)
  103657:	8b 45 08             	mov    0x8(%ebp),%eax
  10365a:	ff d0                	call   *%eax
            break;
  10365c:	e9 a4 02 00 00       	jmp    103905 <vprintfmt+0x3d1>

        // error message
        case 'e':
            err = va_arg(ap, int);
  103661:	8b 45 14             	mov    0x14(%ebp),%eax
  103664:	8d 50 04             	lea    0x4(%eax),%edx
  103667:	89 55 14             	mov    %edx,0x14(%ebp)
  10366a:	8b 18                	mov    (%eax),%ebx
            if (err < 0) {
  10366c:	85 db                	test   %ebx,%ebx
  10366e:	79 02                	jns    103672 <vprintfmt+0x13e>
                err = -err;
  103670:	f7 db                	neg    %ebx
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
  103672:	83 fb 06             	cmp    $0x6,%ebx
  103675:	7f 0b                	jg     103682 <vprintfmt+0x14e>
  103677:	8b 34 9d d4 41 10 00 	mov    0x1041d4(,%ebx,4),%esi
  10367e:	85 f6                	test   %esi,%esi
  103680:	75 23                	jne    1036a5 <vprintfmt+0x171>
                printfmt(putch, putdat, "error %d", err);
  103682:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  103686:	c7 44 24 08 01 42 10 	movl   $0x104201,0x8(%esp)
  10368d:	00 
  10368e:	8b 45 0c             	mov    0xc(%ebp),%eax
  103691:	89 44 24 04          	mov    %eax,0x4(%esp)
  103695:	8b 45 08             	mov    0x8(%ebp),%eax
  103698:	89 04 24             	mov    %eax,(%esp)
  10369b:	e8 61 fe ff ff       	call   103501 <printfmt>
            }
            else {
                printfmt(putch, putdat, "%s", p);
            }
            break;
  1036a0:	e9 60 02 00 00       	jmp    103905 <vprintfmt+0x3d1>
                printfmt(putch, putdat, "%s", p);
  1036a5:	89 74 24 0c          	mov    %esi,0xc(%esp)
  1036a9:	c7 44 24 08 0a 42 10 	movl   $0x10420a,0x8(%esp)
  1036b0:	00 
  1036b1:	8b 45 0c             	mov    0xc(%ebp),%eax
  1036b4:	89 44 24 04          	mov    %eax,0x4(%esp)
  1036b8:	8b 45 08             	mov    0x8(%ebp),%eax
  1036bb:	89 04 24             	mov    %eax,(%esp)
  1036be:	e8 3e fe ff ff       	call   103501 <printfmt>
            break;
  1036c3:	e9 3d 02 00 00       	jmp    103905 <vprintfmt+0x3d1>

        // string
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
  1036c8:	8b 45 14             	mov    0x14(%ebp),%eax
  1036cb:	8d 50 04             	lea    0x4(%eax),%edx
  1036ce:	89 55 14             	mov    %edx,0x14(%ebp)
  1036d1:	8b 30                	mov    (%eax),%esi
  1036d3:	85 f6                	test   %esi,%esi
  1036d5:	75 05                	jne    1036dc <vprintfmt+0x1a8>
                p = "(null)";
  1036d7:	be 0d 42 10 00       	mov    $0x10420d,%esi
            }
            if (width > 0 && padc != '-') {
  1036dc:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  1036e0:	7e 76                	jle    103758 <vprintfmt+0x224>
  1036e2:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  1036e6:	74 70                	je     103758 <vprintfmt+0x224>
                for (width -= strnlen(p, precision); width > 0; width --) {
  1036e8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1036eb:	89 44 24 04          	mov    %eax,0x4(%esp)
  1036ef:	89 34 24             	mov    %esi,(%esp)
  1036f2:	e8 ba f7 ff ff       	call   102eb1 <strnlen>
  1036f7:	8b 55 e8             	mov    -0x18(%ebp),%edx
  1036fa:	29 c2                	sub    %eax,%edx
  1036fc:	89 d0                	mov    %edx,%eax
  1036fe:	89 45 e8             	mov    %eax,-0x18(%ebp)
  103701:	eb 16                	jmp    103719 <vprintfmt+0x1e5>
                    putch(padc, putdat);
  103703:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  103707:	8b 55 0c             	mov    0xc(%ebp),%edx
  10370a:	89 54 24 04          	mov    %edx,0x4(%esp)
  10370e:	89 04 24             	mov    %eax,(%esp)
  103711:	8b 45 08             	mov    0x8(%ebp),%eax
  103714:	ff d0                	call   *%eax
                for (width -= strnlen(p, precision); width > 0; width --) {
  103716:	ff 4d e8             	decl   -0x18(%ebp)
  103719:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  10371d:	7f e4                	jg     103703 <vprintfmt+0x1cf>
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  10371f:	eb 37                	jmp    103758 <vprintfmt+0x224>
                if (altflag && (ch < ' ' || ch > '~')) {
  103721:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  103725:	74 1f                	je     103746 <vprintfmt+0x212>
  103727:	83 fb 1f             	cmp    $0x1f,%ebx
  10372a:	7e 05                	jle    103731 <vprintfmt+0x1fd>
  10372c:	83 fb 7e             	cmp    $0x7e,%ebx
  10372f:	7e 15                	jle    103746 <vprintfmt+0x212>
                    putch('?', putdat);
  103731:	8b 45 0c             	mov    0xc(%ebp),%eax
  103734:	89 44 24 04          	mov    %eax,0x4(%esp)
  103738:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  10373f:	8b 45 08             	mov    0x8(%ebp),%eax
  103742:	ff d0                	call   *%eax
  103744:	eb 0f                	jmp    103755 <vprintfmt+0x221>
                }
                else {
                    putch(ch, putdat);
  103746:	8b 45 0c             	mov    0xc(%ebp),%eax
  103749:	89 44 24 04          	mov    %eax,0x4(%esp)
  10374d:	89 1c 24             	mov    %ebx,(%esp)
  103750:	8b 45 08             	mov    0x8(%ebp),%eax
  103753:	ff d0                	call   *%eax
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  103755:	ff 4d e8             	decl   -0x18(%ebp)
  103758:	89 f0                	mov    %esi,%eax
  10375a:	8d 70 01             	lea    0x1(%eax),%esi
  10375d:	0f b6 00             	movzbl (%eax),%eax
  103760:	0f be d8             	movsbl %al,%ebx
  103763:	85 db                	test   %ebx,%ebx
  103765:	74 27                	je     10378e <vprintfmt+0x25a>
  103767:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  10376b:	78 b4                	js     103721 <vprintfmt+0x1ed>
  10376d:	ff 4d e4             	decl   -0x1c(%ebp)
  103770:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  103774:	79 ab                	jns    103721 <vprintfmt+0x1ed>
                }
            }
            for (; width > 0; width --) {
  103776:	eb 16                	jmp    10378e <vprintfmt+0x25a>
                putch(' ', putdat);
  103778:	8b 45 0c             	mov    0xc(%ebp),%eax
  10377b:	89 44 24 04          	mov    %eax,0x4(%esp)
  10377f:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  103786:	8b 45 08             	mov    0x8(%ebp),%eax
  103789:	ff d0                	call   *%eax
            for (; width > 0; width --) {
  10378b:	ff 4d e8             	decl   -0x18(%ebp)
  10378e:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  103792:	7f e4                	jg     103778 <vprintfmt+0x244>
            }
            break;
  103794:	e9 6c 01 00 00       	jmp    103905 <vprintfmt+0x3d1>

        // (signed) decimal
        case 'd':
            num = getint(&ap, lflag);
  103799:	8b 45 e0             	mov    -0x20(%ebp),%eax
  10379c:	89 44 24 04          	mov    %eax,0x4(%esp)
  1037a0:	8d 45 14             	lea    0x14(%ebp),%eax
  1037a3:	89 04 24             	mov    %eax,(%esp)
  1037a6:	e8 0b fd ff ff       	call   1034b6 <getint>
  1037ab:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1037ae:	89 55 f4             	mov    %edx,-0xc(%ebp)
            if ((long long)num < 0) {
  1037b1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1037b4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1037b7:	85 d2                	test   %edx,%edx
  1037b9:	79 26                	jns    1037e1 <vprintfmt+0x2ad>
                putch('-', putdat);
  1037bb:	8b 45 0c             	mov    0xc(%ebp),%eax
  1037be:	89 44 24 04          	mov    %eax,0x4(%esp)
  1037c2:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  1037c9:	8b 45 08             	mov    0x8(%ebp),%eax
  1037cc:	ff d0                	call   *%eax
                num = -(long long)num;
  1037ce:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1037d1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1037d4:	f7 d8                	neg    %eax
  1037d6:	83 d2 00             	adc    $0x0,%edx
  1037d9:	f7 da                	neg    %edx
  1037db:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1037de:	89 55 f4             	mov    %edx,-0xc(%ebp)
            }
            base = 10;
  1037e1:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
  1037e8:	e9 a8 00 00 00       	jmp    103895 <vprintfmt+0x361>

        // unsigned decimal
        case 'u':
            num = getuint(&ap, lflag);
  1037ed:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1037f0:	89 44 24 04          	mov    %eax,0x4(%esp)
  1037f4:	8d 45 14             	lea    0x14(%ebp),%eax
  1037f7:	89 04 24             	mov    %eax,(%esp)
  1037fa:	e8 64 fc ff ff       	call   103463 <getuint>
  1037ff:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103802:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 10;
  103805:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
  10380c:	e9 84 00 00 00       	jmp    103895 <vprintfmt+0x361>

        // (unsigned) octal
        case 'o':
            num = getuint(&ap, lflag);
  103811:	8b 45 e0             	mov    -0x20(%ebp),%eax
  103814:	89 44 24 04          	mov    %eax,0x4(%esp)
  103818:	8d 45 14             	lea    0x14(%ebp),%eax
  10381b:	89 04 24             	mov    %eax,(%esp)
  10381e:	e8 40 fc ff ff       	call   103463 <getuint>
  103823:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103826:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 8;
  103829:	c7 45 ec 08 00 00 00 	movl   $0x8,-0x14(%ebp)
            goto number;
  103830:	eb 63                	jmp    103895 <vprintfmt+0x361>

        // pointer
        case 'p':
            putch('0', putdat);
  103832:	8b 45 0c             	mov    0xc(%ebp),%eax
  103835:	89 44 24 04          	mov    %eax,0x4(%esp)
  103839:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  103840:	8b 45 08             	mov    0x8(%ebp),%eax
  103843:	ff d0                	call   *%eax
            putch('x', putdat);
  103845:	8b 45 0c             	mov    0xc(%ebp),%eax
  103848:	89 44 24 04          	mov    %eax,0x4(%esp)
  10384c:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  103853:	8b 45 08             	mov    0x8(%ebp),%eax
  103856:	ff d0                	call   *%eax
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
  103858:	8b 45 14             	mov    0x14(%ebp),%eax
  10385b:	8d 50 04             	lea    0x4(%eax),%edx
  10385e:	89 55 14             	mov    %edx,0x14(%ebp)
  103861:	8b 00                	mov    (%eax),%eax
  103863:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103866:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
            base = 16;
  10386d:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
            goto number;
  103874:	eb 1f                	jmp    103895 <vprintfmt+0x361>

        // (unsigned) hexadecimal
        case 'x':
            num = getuint(&ap, lflag);
  103876:	8b 45 e0             	mov    -0x20(%ebp),%eax
  103879:	89 44 24 04          	mov    %eax,0x4(%esp)
  10387d:	8d 45 14             	lea    0x14(%ebp),%eax
  103880:	89 04 24             	mov    %eax,(%esp)
  103883:	e8 db fb ff ff       	call   103463 <getuint>
  103888:	89 45 f0             	mov    %eax,-0x10(%ebp)
  10388b:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 16;
  10388e:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
        number:
            printnum(putch, putdat, num, base, width, padc);
  103895:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  103899:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10389c:	89 54 24 18          	mov    %edx,0x18(%esp)
  1038a0:	8b 55 e8             	mov    -0x18(%ebp),%edx
  1038a3:	89 54 24 14          	mov    %edx,0x14(%esp)
  1038a7:	89 44 24 10          	mov    %eax,0x10(%esp)
  1038ab:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1038ae:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1038b1:	89 44 24 08          	mov    %eax,0x8(%esp)
  1038b5:	89 54 24 0c          	mov    %edx,0xc(%esp)
  1038b9:	8b 45 0c             	mov    0xc(%ebp),%eax
  1038bc:	89 44 24 04          	mov    %eax,0x4(%esp)
  1038c0:	8b 45 08             	mov    0x8(%ebp),%eax
  1038c3:	89 04 24             	mov    %eax,(%esp)
  1038c6:	e8 94 fa ff ff       	call   10335f <printnum>
            break;
  1038cb:	eb 38                	jmp    103905 <vprintfmt+0x3d1>

        // escaped '%' character
        case '%':
            putch(ch, putdat);
  1038cd:	8b 45 0c             	mov    0xc(%ebp),%eax
  1038d0:	89 44 24 04          	mov    %eax,0x4(%esp)
  1038d4:	89 1c 24             	mov    %ebx,(%esp)
  1038d7:	8b 45 08             	mov    0x8(%ebp),%eax
  1038da:	ff d0                	call   *%eax
            break;
  1038dc:	eb 27                	jmp    103905 <vprintfmt+0x3d1>

        // unrecognized escape sequence - just print it literally
        default:
            putch('%', putdat);
  1038de:	8b 45 0c             	mov    0xc(%ebp),%eax
  1038e1:	89 44 24 04          	mov    %eax,0x4(%esp)
  1038e5:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  1038ec:	8b 45 08             	mov    0x8(%ebp),%eax
  1038ef:	ff d0                	call   *%eax
            for (fmt --; fmt[-1] != '%'; fmt --)
  1038f1:	ff 4d 10             	decl   0x10(%ebp)
  1038f4:	eb 03                	jmp    1038f9 <vprintfmt+0x3c5>
  1038f6:	ff 4d 10             	decl   0x10(%ebp)
  1038f9:	8b 45 10             	mov    0x10(%ebp),%eax
  1038fc:	48                   	dec    %eax
  1038fd:	0f b6 00             	movzbl (%eax),%eax
  103900:	3c 25                	cmp    $0x25,%al
  103902:	75 f2                	jne    1038f6 <vprintfmt+0x3c2>
                /* do nothing */;
            break;
  103904:	90                   	nop
    while (1) {
  103905:	e9 36 fc ff ff       	jmp    103540 <vprintfmt+0xc>
                return;
  10390a:	90                   	nop
        }
    }
}
  10390b:	83 c4 40             	add    $0x40,%esp
  10390e:	5b                   	pop    %ebx
  10390f:	5e                   	pop    %esi
  103910:	5d                   	pop    %ebp
  103911:	c3                   	ret    

00103912 <sprintputch>:
 * sprintputch - 'print' a single character in a buffer
 * @ch:            the character will be printed
 * @b:            the buffer to place the character @ch
 * */
static void
sprintputch(int ch, struct sprintbuf *b) {
  103912:	f3 0f 1e fb          	endbr32 
  103916:	55                   	push   %ebp
  103917:	89 e5                	mov    %esp,%ebp
    b->cnt ++;
  103919:	8b 45 0c             	mov    0xc(%ebp),%eax
  10391c:	8b 40 08             	mov    0x8(%eax),%eax
  10391f:	8d 50 01             	lea    0x1(%eax),%edx
  103922:	8b 45 0c             	mov    0xc(%ebp),%eax
  103925:	89 50 08             	mov    %edx,0x8(%eax)
    if (b->buf < b->ebuf) {
  103928:	8b 45 0c             	mov    0xc(%ebp),%eax
  10392b:	8b 10                	mov    (%eax),%edx
  10392d:	8b 45 0c             	mov    0xc(%ebp),%eax
  103930:	8b 40 04             	mov    0x4(%eax),%eax
  103933:	39 c2                	cmp    %eax,%edx
  103935:	73 12                	jae    103949 <sprintputch+0x37>
        *b->buf ++ = ch;
  103937:	8b 45 0c             	mov    0xc(%ebp),%eax
  10393a:	8b 00                	mov    (%eax),%eax
  10393c:	8d 48 01             	lea    0x1(%eax),%ecx
  10393f:	8b 55 0c             	mov    0xc(%ebp),%edx
  103942:	89 0a                	mov    %ecx,(%edx)
  103944:	8b 55 08             	mov    0x8(%ebp),%edx
  103947:	88 10                	mov    %dl,(%eax)
    }
}
  103949:	90                   	nop
  10394a:	5d                   	pop    %ebp
  10394b:	c3                   	ret    

0010394c <snprintf>:
 * @str:        the buffer to place the result into
 * @size:        the size of buffer, including the trailing null space
 * @fmt:        the format string to use
 * */
int
snprintf(char *str, size_t size, const char *fmt, ...) {
  10394c:	f3 0f 1e fb          	endbr32 
  103950:	55                   	push   %ebp
  103951:	89 e5                	mov    %esp,%ebp
  103953:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
  103956:	8d 45 14             	lea    0x14(%ebp),%eax
  103959:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vsnprintf(str, size, fmt, ap);
  10395c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10395f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  103963:	8b 45 10             	mov    0x10(%ebp),%eax
  103966:	89 44 24 08          	mov    %eax,0x8(%esp)
  10396a:	8b 45 0c             	mov    0xc(%ebp),%eax
  10396d:	89 44 24 04          	mov    %eax,0x4(%esp)
  103971:	8b 45 08             	mov    0x8(%ebp),%eax
  103974:	89 04 24             	mov    %eax,(%esp)
  103977:	e8 08 00 00 00       	call   103984 <vsnprintf>
  10397c:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
  10397f:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  103982:	c9                   	leave  
  103983:	c3                   	ret    

00103984 <vsnprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want snprintf() instead.
 * */
int
vsnprintf(char *str, size_t size, const char *fmt, va_list ap) {
  103984:	f3 0f 1e fb          	endbr32 
  103988:	55                   	push   %ebp
  103989:	89 e5                	mov    %esp,%ebp
  10398b:	83 ec 28             	sub    $0x28,%esp
    struct sprintbuf b = {str, str + size - 1, 0};
  10398e:	8b 45 08             	mov    0x8(%ebp),%eax
  103991:	89 45 ec             	mov    %eax,-0x14(%ebp)
  103994:	8b 45 0c             	mov    0xc(%ebp),%eax
  103997:	8d 50 ff             	lea    -0x1(%eax),%edx
  10399a:	8b 45 08             	mov    0x8(%ebp),%eax
  10399d:	01 d0                	add    %edx,%eax
  10399f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1039a2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if (str == NULL || b.buf > b.ebuf) {
  1039a9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  1039ad:	74 0a                	je     1039b9 <vsnprintf+0x35>
  1039af:	8b 55 ec             	mov    -0x14(%ebp),%edx
  1039b2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1039b5:	39 c2                	cmp    %eax,%edx
  1039b7:	76 07                	jbe    1039c0 <vsnprintf+0x3c>
        return -E_INVAL;
  1039b9:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  1039be:	eb 2a                	jmp    1039ea <vsnprintf+0x66>
    }
    // print the string to the buffer
    vprintfmt((void*)sprintputch, &b, fmt, ap);
  1039c0:	8b 45 14             	mov    0x14(%ebp),%eax
  1039c3:	89 44 24 0c          	mov    %eax,0xc(%esp)
  1039c7:	8b 45 10             	mov    0x10(%ebp),%eax
  1039ca:	89 44 24 08          	mov    %eax,0x8(%esp)
  1039ce:	8d 45 ec             	lea    -0x14(%ebp),%eax
  1039d1:	89 44 24 04          	mov    %eax,0x4(%esp)
  1039d5:	c7 04 24 12 39 10 00 	movl   $0x103912,(%esp)
  1039dc:	e8 53 fb ff ff       	call   103534 <vprintfmt>
    // null terminate the buffer
    *b.buf = '\0';
  1039e1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1039e4:	c6 00 00             	movb   $0x0,(%eax)
    return b.cnt;
  1039e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  1039ea:	c9                   	leave  
  1039eb:	c3                   	ret    
