
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
  100027:	e8 74 2f 00 00       	call   102fa0 <memset>

    cons_init();                // init the console
  10002c:	e8 47 16 00 00       	call   101678 <cons_init>

    const char *message = "(THU.CST) os is loading ...";
  100031:	c7 45 f4 e0 37 10 00 	movl   $0x1037e0,-0xc(%ebp)
    cprintf("%s\n\n", message);
  100038:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10003b:	89 44 24 04          	mov    %eax,0x4(%esp)
  10003f:	c7 04 24 fc 37 10 00 	movl   $0x1037fc,(%esp)
  100046:	e8 49 02 00 00       	call   100294 <cprintf>

    print_kerninfo();
  10004b:	e8 07 09 00 00       	call   100957 <print_kerninfo>

    grade_backtrace();
  100050:	e8 9a 00 00 00       	call   1000ef <grade_backtrace>

    pmm_init();                 // init physical memory management
  100055:	e8 f5 2b 00 00       	call   102c4f <pmm_init>

    pic_init();                 // init interrupt controller
  10005a:	e8 6e 17 00 00       	call   1017cd <pic_init>
    idt_init();                 // init interrupt descriptor table
  10005f:	e8 ee 18 00 00       	call   101952 <idt_init>

    clock_init();               // init clock interrupt
  100064:	e8 63 0d 00 00       	call   100dcc <clock_init>
    intr_enable();              // enable irq interrupt
  100069:	e8 ab 18 00 00       	call   101919 <intr_enable>

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
  100145:	c7 04 24 01 38 10 00 	movl   $0x103801,(%esp)
  10014c:	e8 43 01 00 00       	call   100294 <cprintf>
    cprintf("%d:  cs = %x\n", round, reg1);
  100151:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  100155:	89 c2                	mov    %eax,%edx
  100157:	a1 20 0a 11 00       	mov    0x110a20,%eax
  10015c:	89 54 24 08          	mov    %edx,0x8(%esp)
  100160:	89 44 24 04          	mov    %eax,0x4(%esp)
  100164:	c7 04 24 0f 38 10 00 	movl   $0x10380f,(%esp)
  10016b:	e8 24 01 00 00       	call   100294 <cprintf>
    cprintf("%d:  ds = %x\n", round, reg2);
  100170:	0f b7 45 f4          	movzwl -0xc(%ebp),%eax
  100174:	89 c2                	mov    %eax,%edx
  100176:	a1 20 0a 11 00       	mov    0x110a20,%eax
  10017b:	89 54 24 08          	mov    %edx,0x8(%esp)
  10017f:	89 44 24 04          	mov    %eax,0x4(%esp)
  100183:	c7 04 24 1d 38 10 00 	movl   $0x10381d,(%esp)
  10018a:	e8 05 01 00 00       	call   100294 <cprintf>
    cprintf("%d:  es = %x\n", round, reg3);
  10018f:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  100193:	89 c2                	mov    %eax,%edx
  100195:	a1 20 0a 11 00       	mov    0x110a20,%eax
  10019a:	89 54 24 08          	mov    %edx,0x8(%esp)
  10019e:	89 44 24 04          	mov    %eax,0x4(%esp)
  1001a2:	c7 04 24 2b 38 10 00 	movl   $0x10382b,(%esp)
  1001a9:	e8 e6 00 00 00       	call   100294 <cprintf>
    cprintf("%d:  ss = %x\n", round, reg4);
  1001ae:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
  1001b2:	89 c2                	mov    %eax,%edx
  1001b4:	a1 20 0a 11 00       	mov    0x110a20,%eax
  1001b9:	89 54 24 08          	mov    %edx,0x8(%esp)
  1001bd:	89 44 24 04          	mov    %eax,0x4(%esp)
  1001c1:	c7 04 24 39 38 10 00 	movl   $0x103839,(%esp)
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
  100209:	c7 04 24 48 38 10 00 	movl   $0x103848,(%esp)
  100210:	e8 7f 00 00 00       	call   100294 <cprintf>
    lab1_switch_to_user();
  100215:	e8 c1 ff ff ff       	call   1001db <lab1_switch_to_user>
    lab1_print_cur_status();
  10021a:	e8 fa fe ff ff       	call   100119 <lab1_print_cur_status>
    cprintf("+++ switch to kernel mode +++\n");
  10021f:	c7 04 24 68 38 10 00 	movl   $0x103868,(%esp)
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
  100248:	e8 5c 14 00 00       	call   1016a9 <cons_putc>
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
  10028a:	e8 7d 30 00 00       	call   10330c <vprintfmt>
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
  1002ce:	e8 d6 13 00 00       	call   1016a9 <cons_putc>
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
  100334:	e8 9e 13 00 00       	call   1016d7 <cons_getc>
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
  10035e:	c7 04 24 87 38 10 00 	movl   $0x103887,(%esp)
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
  100431:	c7 04 24 8a 38 10 00 	movl   $0x10388a,(%esp)
  100438:	e8 57 fe ff ff       	call   100294 <cprintf>
    vcprintf(fmt, ap);
  10043d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100440:	89 44 24 04          	mov    %eax,0x4(%esp)
  100444:	8b 45 10             	mov    0x10(%ebp),%eax
  100447:	89 04 24             	mov    %eax,(%esp)
  10044a:	e8 0e fe ff ff       	call   10025d <vcprintf>
    cprintf("\n");
  10044f:	c7 04 24 a6 38 10 00 	movl   $0x1038a6,(%esp)
  100456:	e8 39 fe ff ff       	call   100294 <cprintf>
    
    cprintf("stack trackback:\n");
  10045b:	c7 04 24 a8 38 10 00 	movl   $0x1038a8,(%esp)
  100462:	e8 2d fe ff ff       	call   100294 <cprintf>
    print_stackframe();
  100467:	e8 3d 06 00 00       	call   100aa9 <print_stackframe>
  10046c:	eb 01                	jmp    10046f <__panic+0x6f>
        goto panic_dead;
  10046e:	90                   	nop
    
    va_end(ap);

panic_dead:
    intr_disable();
  10046f:	e8 b1 14 00 00       	call   101925 <intr_disable>
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
  1004a0:	c7 04 24 ba 38 10 00 	movl   $0x1038ba,(%esp)
  1004a7:	e8 e8 fd ff ff       	call   100294 <cprintf>
    vcprintf(fmt, ap);
  1004ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1004af:	89 44 24 04          	mov    %eax,0x4(%esp)
  1004b3:	8b 45 10             	mov    0x10(%ebp),%eax
  1004b6:	89 04 24             	mov    %eax,(%esp)
  1004b9:	e8 9f fd ff ff       	call   10025d <vcprintf>
    cprintf("\n");
  1004be:	c7 04 24 a6 38 10 00 	movl   $0x1038a6,(%esp)
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
  10063a:	c7 00 d8 38 10 00    	movl   $0x1038d8,(%eax)
    info->eip_line = 0;
  100640:	8b 45 0c             	mov    0xc(%ebp),%eax
  100643:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    info->eip_fn_name = "<unknown>";
  10064a:	8b 45 0c             	mov    0xc(%ebp),%eax
  10064d:	c7 40 08 d8 38 10 00 	movl   $0x1038d8,0x8(%eax)
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
  100671:	c7 45 f4 ec 40 10 00 	movl   $0x1040ec,-0xc(%ebp)
    stab_end = __STAB_END__;
  100678:	c7 45 f0 38 d0 10 00 	movl   $0x10d038,-0x10(%ebp)
    stabstr = __STABSTR_BEGIN__;
  10067f:	c7 45 ec 39 d0 10 00 	movl   $0x10d039,-0x14(%ebp)
    stabstr_end = __STABSTR_END__;
  100686:	c7 45 e8 82 f1 10 00 	movl   $0x10f182,-0x18(%ebp)

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
  1007d9:	e8 36 26 00 00       	call   102e14 <strfind>
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
  100961:	c7 04 24 e2 38 10 00 	movl   $0x1038e2,(%esp)
  100968:	e8 27 f9 ff ff       	call   100294 <cprintf>
    cprintf("  entry  0x%08x (phys)\n", kern_init);
  10096d:	c7 44 24 04 00 00 10 	movl   $0x100000,0x4(%esp)
  100974:	00 
  100975:	c7 04 24 fb 38 10 00 	movl   $0x1038fb,(%esp)
  10097c:	e8 13 f9 ff ff       	call   100294 <cprintf>
    cprintf("  etext  0x%08x (phys)\n", etext);
  100981:	c7 44 24 04 c4 37 10 	movl   $0x1037c4,0x4(%esp)
  100988:	00 
  100989:	c7 04 24 13 39 10 00 	movl   $0x103913,(%esp)
  100990:	e8 ff f8 ff ff       	call   100294 <cprintf>
    cprintf("  edata  0x%08x (phys)\n", edata);
  100995:	c7 44 24 04 16 0a 11 	movl   $0x110a16,0x4(%esp)
  10099c:	00 
  10099d:	c7 04 24 2b 39 10 00 	movl   $0x10392b,(%esp)
  1009a4:	e8 eb f8 ff ff       	call   100294 <cprintf>
    cprintf("  end    0x%08x (phys)\n", end);
  1009a9:	c7 44 24 04 80 1d 11 	movl   $0x111d80,0x4(%esp)
  1009b0:	00 
  1009b1:	c7 04 24 43 39 10 00 	movl   $0x103943,(%esp)
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
  1009de:	c7 04 24 5c 39 10 00 	movl   $0x10395c,(%esp)
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
  100a17:	c7 04 24 86 39 10 00 	movl   $0x103986,(%esp)
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
  100a85:	c7 04 24 a2 39 10 00 	movl   $0x1039a2,(%esp)
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
  100ae0:	c7 04 24 b4 39 10 00 	movl   $0x1039b4,(%esp)
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
  100b13:	c7 04 24 d0 39 10 00 	movl   $0x1039d0,(%esp)
  100b1a:	e8 75 f7 ff ff       	call   100294 <cprintf>
        for (int j = 0; j < 4; j ++) {
  100b1f:	ff 45 e8             	incl   -0x18(%ebp)
  100b22:	83 7d e8 03          	cmpl   $0x3,-0x18(%ebp)
  100b26:	7e d6                	jle    100afe <print_stackframe+0x55>
        }
        cprintf("\n");
  100b28:	c7 04 24 d8 39 10 00 	movl   $0x1039d8,(%esp)
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
  100b9f:	c7 04 24 5c 3a 10 00 	movl   $0x103a5c,(%esp)
  100ba6:	e8 33 22 00 00       	call   102dde <strchr>
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
  100bc7:	c7 04 24 61 3a 10 00 	movl   $0x103a61,(%esp)
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
  100c09:	c7 04 24 5c 3a 10 00 	movl   $0x103a5c,(%esp)
  100c10:	e8 c9 21 00 00       	call   102dde <strchr>
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
  100c7a:	e8 bb 20 00 00       	call   102d3a <strcmp>
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
  100cc6:	c7 04 24 7f 3a 10 00 	movl   $0x103a7f,(%esp)
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
  100ce7:	c7 04 24 98 3a 10 00 	movl   $0x103a98,(%esp)
  100cee:	e8 a1 f5 ff ff       	call   100294 <cprintf>
    cprintf("Type 'help' for a list of commands.\n");
  100cf3:	c7 04 24 c0 3a 10 00 	movl   $0x103ac0,(%esp)
  100cfa:	e8 95 f5 ff ff       	call   100294 <cprintf>

    if (tf != NULL) {
  100cff:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  100d03:	74 0b                	je     100d10 <kmonitor+0x33>
        print_trapframe(tf);
  100d05:	8b 45 08             	mov    0x8(%ebp),%eax
  100d08:	89 04 24             	mov    %eax,(%esp)
  100d0b:	e8 05 0e 00 00       	call   101b15 <print_trapframe>
    }

    char *buf;
    while (1) {
        if ((buf = readline("K> ")) != NULL) {
  100d10:	c7 04 24 e5 3a 10 00 	movl   $0x103ae5,(%esp)
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
  100d82:	c7 04 24 e9 3a 10 00 	movl   $0x103ae9,(%esp)
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
  100e1c:	c7 04 24 f2 3a 10 00 	movl   $0x103af2,(%esp)
  100e23:	e8 6c f4 ff ff       	call   100294 <cprintf>
    pic_enable(IRQ_TIMER);
  100e28:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  100e2f:	e8 62 09 00 00       	call   101796 <pic_enable>
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
  101055:	e8 3c 07 00 00       	call   101796 <pic_enable>
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
  10124e:	e8 90 1d 00 00       	call   102fe3 <memmove>
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
  1014b3:	e9 87 01 00 00       	jmp    10163f <kbd_proc_data+0x1b8>
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
  1014e6:	e9 54 01 00 00       	jmp    10163f <kbd_proc_data+0x1b8>
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
  101533:	e9 07 01 00 00       	jmp    10163f <kbd_proc_data+0x1b8>
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

    if (data == 0x04) {
  101555:	80 7d f3 04          	cmpb   $0x4,-0xd(%ebp)
  101559:	75 0c                	jne    101567 <kbd_proc_data+0xe0>
        switch_to_user();
  10155b:	e8 08 0b 00 00       	call   102068 <switch_to_user>
        switch_to_kernel();
  101560:	e8 14 0b 00 00       	call   102079 <switch_to_kernel>
  101565:	eb 0b                	jmp    101572 <kbd_proc_data+0xeb>
    } else if (data == 0x0b) {
  101567:	80 7d f3 0b          	cmpb   $0xb,-0xd(%ebp)
  10156b:	75 05                	jne    101572 <kbd_proc_data+0xeb>
        switch_to_kernel();
  10156d:	e8 07 0b 00 00       	call   102079 <switch_to_kernel>
    }

    shift |= shiftcode[data];
  101572:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101576:	0f b6 80 40 00 11 00 	movzbl 0x110040(%eax),%eax
  10157d:	0f b6 d0             	movzbl %al,%edx
  101580:	a1 88 10 11 00       	mov    0x111088,%eax
  101585:	09 d0                	or     %edx,%eax
  101587:	a3 88 10 11 00       	mov    %eax,0x111088
    shift ^= togglecode[data];
  10158c:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101590:	0f b6 80 40 01 11 00 	movzbl 0x110140(%eax),%eax
  101597:	0f b6 d0             	movzbl %al,%edx
  10159a:	a1 88 10 11 00       	mov    0x111088,%eax
  10159f:	31 d0                	xor    %edx,%eax
  1015a1:	a3 88 10 11 00       	mov    %eax,0x111088

    c = charcode[shift & (CTL | SHIFT)][data];
  1015a6:	a1 88 10 11 00       	mov    0x111088,%eax
  1015ab:	83 e0 03             	and    $0x3,%eax
  1015ae:	8b 14 85 40 05 11 00 	mov    0x110540(,%eax,4),%edx
  1015b5:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  1015b9:	01 d0                	add    %edx,%eax
  1015bb:	0f b6 00             	movzbl (%eax),%eax
  1015be:	0f b6 c0             	movzbl %al,%eax
  1015c1:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (shift & CAPSLOCK) {
  1015c4:	a1 88 10 11 00       	mov    0x111088,%eax
  1015c9:	83 e0 08             	and    $0x8,%eax
  1015cc:	85 c0                	test   %eax,%eax
  1015ce:	74 22                	je     1015f2 <kbd_proc_data+0x16b>
        if ('a' <= c && c <= 'z')
  1015d0:	83 7d f4 60          	cmpl   $0x60,-0xc(%ebp)
  1015d4:	7e 0c                	jle    1015e2 <kbd_proc_data+0x15b>
  1015d6:	83 7d f4 7a          	cmpl   $0x7a,-0xc(%ebp)
  1015da:	7f 06                	jg     1015e2 <kbd_proc_data+0x15b>
            c += 'A' - 'a';
  1015dc:	83 6d f4 20          	subl   $0x20,-0xc(%ebp)
  1015e0:	eb 10                	jmp    1015f2 <kbd_proc_data+0x16b>
        else if ('A' <= c && c <= 'Z')
  1015e2:	83 7d f4 40          	cmpl   $0x40,-0xc(%ebp)
  1015e6:	7e 0a                	jle    1015f2 <kbd_proc_data+0x16b>
  1015e8:	83 7d f4 5a          	cmpl   $0x5a,-0xc(%ebp)
  1015ec:	7f 04                	jg     1015f2 <kbd_proc_data+0x16b>
            c += 'a' - 'A';
  1015ee:	83 45 f4 20          	addl   $0x20,-0xc(%ebp)
    }

    // Process special keys
    // Ctrl-Alt-Del: reboot
    if (!(~shift & (CTL | ALT)) && c == KEY_DEL) {
  1015f2:	a1 88 10 11 00       	mov    0x111088,%eax
  1015f7:	f7 d0                	not    %eax
  1015f9:	83 e0 06             	and    $0x6,%eax
  1015fc:	85 c0                	test   %eax,%eax
  1015fe:	75 28                	jne    101628 <kbd_proc_data+0x1a1>
  101600:	81 7d f4 e9 00 00 00 	cmpl   $0xe9,-0xc(%ebp)
  101607:	75 1f                	jne    101628 <kbd_proc_data+0x1a1>
        cprintf("Rebooting!\n");
  101609:	c7 04 24 0d 3b 10 00 	movl   $0x103b0d,(%esp)
  101610:	e8 7f ec ff ff       	call   100294 <cprintf>
  101615:	66 c7 45 e8 92 00    	movw   $0x92,-0x18(%ebp)
  10161b:	c6 45 e7 03          	movb   $0x3,-0x19(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  10161f:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
  101623:	8b 55 e8             	mov    -0x18(%ebp),%edx
  101626:	ee                   	out    %al,(%dx)
}
  101627:	90                   	nop
        outb(0x92, 0x3); // courtesy of Chris Frost
    }
    cprintf("%d\n", data);
  101628:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  10162c:	89 44 24 04          	mov    %eax,0x4(%esp)
  101630:	c7 04 24 19 3b 10 00 	movl   $0x103b19,(%esp)
  101637:	e8 58 ec ff ff       	call   100294 <cprintf>
    return c;
  10163c:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  10163f:	c9                   	leave  
  101640:	c3                   	ret    

00101641 <kbd_intr>:

/* kbd_intr - try to feed input characters from keyboard */
static void
kbd_intr(void) {
  101641:	f3 0f 1e fb          	endbr32 
  101645:	55                   	push   %ebp
  101646:	89 e5                	mov    %esp,%ebp
  101648:	83 ec 18             	sub    $0x18,%esp
    cons_intr(kbd_proc_data);
  10164b:	c7 04 24 87 14 10 00 	movl   $0x101487,(%esp)
  101652:	e8 62 fd ff ff       	call   1013b9 <cons_intr>
}
  101657:	90                   	nop
  101658:	c9                   	leave  
  101659:	c3                   	ret    

0010165a <kbd_init>:

static void
kbd_init(void) {
  10165a:	f3 0f 1e fb          	endbr32 
  10165e:	55                   	push   %ebp
  10165f:	89 e5                	mov    %esp,%ebp
  101661:	83 ec 18             	sub    $0x18,%esp
    // drain the kbd buffer
    kbd_intr();
  101664:	e8 d8 ff ff ff       	call   101641 <kbd_intr>
    pic_enable(IRQ_KBD);
  101669:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  101670:	e8 21 01 00 00       	call   101796 <pic_enable>
}
  101675:	90                   	nop
  101676:	c9                   	leave  
  101677:	c3                   	ret    

00101678 <cons_init>:

/* cons_init - initializes the console devices */
void
cons_init(void) {
  101678:	f3 0f 1e fb          	endbr32 
  10167c:	55                   	push   %ebp
  10167d:	89 e5                	mov    %esp,%ebp
  10167f:	83 ec 18             	sub    $0x18,%esp
    cga_init();
  101682:	e8 fd f7 ff ff       	call   100e84 <cga_init>
    serial_init();
  101687:	e8 e2 f8 ff ff       	call   100f6e <serial_init>
    kbd_init();
  10168c:	e8 c9 ff ff ff       	call   10165a <kbd_init>
    if (!serial_exists) {
  101691:	a1 68 0e 11 00       	mov    0x110e68,%eax
  101696:	85 c0                	test   %eax,%eax
  101698:	75 0c                	jne    1016a6 <cons_init+0x2e>
        cprintf("serial port does not exist!!\n");
  10169a:	c7 04 24 1d 3b 10 00 	movl   $0x103b1d,(%esp)
  1016a1:	e8 ee eb ff ff       	call   100294 <cprintf>
    }
}
  1016a6:	90                   	nop
  1016a7:	c9                   	leave  
  1016a8:	c3                   	ret    

001016a9 <cons_putc>:

/* cons_putc - print a single character @c to console devices */
void
cons_putc(int c) {
  1016a9:	f3 0f 1e fb          	endbr32 
  1016ad:	55                   	push   %ebp
  1016ae:	89 e5                	mov    %esp,%ebp
  1016b0:	83 ec 18             	sub    $0x18,%esp
    lpt_putc(c);
  1016b3:	8b 45 08             	mov    0x8(%ebp),%eax
  1016b6:	89 04 24             	mov    %eax,(%esp)
  1016b9:	e8 1f fa ff ff       	call   1010dd <lpt_putc>
    cga_putc(c);
  1016be:	8b 45 08             	mov    0x8(%ebp),%eax
  1016c1:	89 04 24             	mov    %eax,(%esp)
  1016c4:	e8 58 fa ff ff       	call   101121 <cga_putc>
    serial_putc(c);
  1016c9:	8b 45 08             	mov    0x8(%ebp),%eax
  1016cc:	89 04 24             	mov    %eax,(%esp)
  1016cf:	e8 a1 fc ff ff       	call   101375 <serial_putc>
}
  1016d4:	90                   	nop
  1016d5:	c9                   	leave  
  1016d6:	c3                   	ret    

001016d7 <cons_getc>:
/* *
 * cons_getc - return the next input character from console,
 * or 0 if none waiting.
 * */
int
cons_getc(void) {
  1016d7:	f3 0f 1e fb          	endbr32 
  1016db:	55                   	push   %ebp
  1016dc:	89 e5                	mov    %esp,%ebp
  1016de:	83 ec 18             	sub    $0x18,%esp
    int c;

    // poll for any pending input characters,
    // so that this function works even when interrupts are disabled
    // (e.g., when called from the kernel monitor).
    serial_intr();
  1016e1:	e8 7f fd ff ff       	call   101465 <serial_intr>
    kbd_intr();
  1016e6:	e8 56 ff ff ff       	call   101641 <kbd_intr>

    // grab the next character from the input buffer.
    if (cons.rpos != cons.wpos) {
  1016eb:	8b 15 80 10 11 00    	mov    0x111080,%edx
  1016f1:	a1 84 10 11 00       	mov    0x111084,%eax
  1016f6:	39 c2                	cmp    %eax,%edx
  1016f8:	74 36                	je     101730 <cons_getc+0x59>
        c = cons.buf[cons.rpos ++];
  1016fa:	a1 80 10 11 00       	mov    0x111080,%eax
  1016ff:	8d 50 01             	lea    0x1(%eax),%edx
  101702:	89 15 80 10 11 00    	mov    %edx,0x111080
  101708:	0f b6 80 80 0e 11 00 	movzbl 0x110e80(%eax),%eax
  10170f:	0f b6 c0             	movzbl %al,%eax
  101712:	89 45 f4             	mov    %eax,-0xc(%ebp)
        if (cons.rpos == CONSBUFSIZE) {
  101715:	a1 80 10 11 00       	mov    0x111080,%eax
  10171a:	3d 00 02 00 00       	cmp    $0x200,%eax
  10171f:	75 0a                	jne    10172b <cons_getc+0x54>
            cons.rpos = 0;
  101721:	c7 05 80 10 11 00 00 	movl   $0x0,0x111080
  101728:	00 00 00 
        }
        return c;
  10172b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10172e:	eb 05                	jmp    101735 <cons_getc+0x5e>
    }
    return 0;
  101730:	b8 00 00 00 00       	mov    $0x0,%eax
}
  101735:	c9                   	leave  
  101736:	c3                   	ret    

00101737 <pic_setmask>:
// Initial IRQ mask has interrupt 2 enabled (for slave 8259A).
static uint16_t irq_mask = 0xFFFF & ~(1 << IRQ_SLAVE);
static bool did_init = 0;

static void
pic_setmask(uint16_t mask) {
  101737:	f3 0f 1e fb          	endbr32 
  10173b:	55                   	push   %ebp
  10173c:	89 e5                	mov    %esp,%ebp
  10173e:	83 ec 14             	sub    $0x14,%esp
  101741:	8b 45 08             	mov    0x8(%ebp),%eax
  101744:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
    irq_mask = mask;
  101748:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10174b:	66 a3 50 05 11 00    	mov    %ax,0x110550
    if (did_init) {
  101751:	a1 8c 10 11 00       	mov    0x11108c,%eax
  101756:	85 c0                	test   %eax,%eax
  101758:	74 39                	je     101793 <pic_setmask+0x5c>
        outb(IO_PIC1 + 1, mask);
  10175a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10175d:	0f b6 c0             	movzbl %al,%eax
  101760:	66 c7 45 fa 21 00    	movw   $0x21,-0x6(%ebp)
  101766:	88 45 f9             	mov    %al,-0x7(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  101769:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  10176d:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  101771:	ee                   	out    %al,(%dx)
}
  101772:	90                   	nop
        outb(IO_PIC2 + 1, mask >> 8);
  101773:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  101777:	c1 e8 08             	shr    $0x8,%eax
  10177a:	0f b7 c0             	movzwl %ax,%eax
  10177d:	0f b6 c0             	movzbl %al,%eax
  101780:	66 c7 45 fe a1 00    	movw   $0xa1,-0x2(%ebp)
  101786:	88 45 fd             	mov    %al,-0x3(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  101789:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
  10178d:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
  101791:	ee                   	out    %al,(%dx)
}
  101792:	90                   	nop
    }
}
  101793:	90                   	nop
  101794:	c9                   	leave  
  101795:	c3                   	ret    

00101796 <pic_enable>:

void
pic_enable(unsigned int irq) {
  101796:	f3 0f 1e fb          	endbr32 
  10179a:	55                   	push   %ebp
  10179b:	89 e5                	mov    %esp,%ebp
  10179d:	83 ec 04             	sub    $0x4,%esp
    pic_setmask(irq_mask & ~(1 << irq));
  1017a0:	8b 45 08             	mov    0x8(%ebp),%eax
  1017a3:	ba 01 00 00 00       	mov    $0x1,%edx
  1017a8:	88 c1                	mov    %al,%cl
  1017aa:	d3 e2                	shl    %cl,%edx
  1017ac:	89 d0                	mov    %edx,%eax
  1017ae:	98                   	cwtl   
  1017af:	f7 d0                	not    %eax
  1017b1:	0f bf d0             	movswl %ax,%edx
  1017b4:	0f b7 05 50 05 11 00 	movzwl 0x110550,%eax
  1017bb:	98                   	cwtl   
  1017bc:	21 d0                	and    %edx,%eax
  1017be:	98                   	cwtl   
  1017bf:	0f b7 c0             	movzwl %ax,%eax
  1017c2:	89 04 24             	mov    %eax,(%esp)
  1017c5:	e8 6d ff ff ff       	call   101737 <pic_setmask>
}
  1017ca:	90                   	nop
  1017cb:	c9                   	leave  
  1017cc:	c3                   	ret    

001017cd <pic_init>:

/* pic_init - initialize the 8259A interrupt controllers */
void
pic_init(void) {
  1017cd:	f3 0f 1e fb          	endbr32 
  1017d1:	55                   	push   %ebp
  1017d2:	89 e5                	mov    %esp,%ebp
  1017d4:	83 ec 44             	sub    $0x44,%esp
    did_init = 1;
  1017d7:	c7 05 8c 10 11 00 01 	movl   $0x1,0x11108c
  1017de:	00 00 00 
  1017e1:	66 c7 45 ca 21 00    	movw   $0x21,-0x36(%ebp)
  1017e7:	c6 45 c9 ff          	movb   $0xff,-0x37(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  1017eb:	0f b6 45 c9          	movzbl -0x37(%ebp),%eax
  1017ef:	0f b7 55 ca          	movzwl -0x36(%ebp),%edx
  1017f3:	ee                   	out    %al,(%dx)
}
  1017f4:	90                   	nop
  1017f5:	66 c7 45 ce a1 00    	movw   $0xa1,-0x32(%ebp)
  1017fb:	c6 45 cd ff          	movb   $0xff,-0x33(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  1017ff:	0f b6 45 cd          	movzbl -0x33(%ebp),%eax
  101803:	0f b7 55 ce          	movzwl -0x32(%ebp),%edx
  101807:	ee                   	out    %al,(%dx)
}
  101808:	90                   	nop
  101809:	66 c7 45 d2 20 00    	movw   $0x20,-0x2e(%ebp)
  10180f:	c6 45 d1 11          	movb   $0x11,-0x2f(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  101813:	0f b6 45 d1          	movzbl -0x2f(%ebp),%eax
  101817:	0f b7 55 d2          	movzwl -0x2e(%ebp),%edx
  10181b:	ee                   	out    %al,(%dx)
}
  10181c:	90                   	nop
  10181d:	66 c7 45 d6 21 00    	movw   $0x21,-0x2a(%ebp)
  101823:	c6 45 d5 20          	movb   $0x20,-0x2b(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  101827:	0f b6 45 d5          	movzbl -0x2b(%ebp),%eax
  10182b:	0f b7 55 d6          	movzwl -0x2a(%ebp),%edx
  10182f:	ee                   	out    %al,(%dx)
}
  101830:	90                   	nop
  101831:	66 c7 45 da 21 00    	movw   $0x21,-0x26(%ebp)
  101837:	c6 45 d9 04          	movb   $0x4,-0x27(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  10183b:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
  10183f:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
  101843:	ee                   	out    %al,(%dx)
}
  101844:	90                   	nop
  101845:	66 c7 45 de 21 00    	movw   $0x21,-0x22(%ebp)
  10184b:	c6 45 dd 03          	movb   $0x3,-0x23(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  10184f:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
  101853:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
  101857:	ee                   	out    %al,(%dx)
}
  101858:	90                   	nop
  101859:	66 c7 45 e2 a0 00    	movw   $0xa0,-0x1e(%ebp)
  10185f:	c6 45 e1 11          	movb   $0x11,-0x1f(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  101863:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
  101867:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
  10186b:	ee                   	out    %al,(%dx)
}
  10186c:	90                   	nop
  10186d:	66 c7 45 e6 a1 00    	movw   $0xa1,-0x1a(%ebp)
  101873:	c6 45 e5 28          	movb   $0x28,-0x1b(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  101877:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  10187b:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  10187f:	ee                   	out    %al,(%dx)
}
  101880:	90                   	nop
  101881:	66 c7 45 ea a1 00    	movw   $0xa1,-0x16(%ebp)
  101887:	c6 45 e9 02          	movb   $0x2,-0x17(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  10188b:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  10188f:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  101893:	ee                   	out    %al,(%dx)
}
  101894:	90                   	nop
  101895:	66 c7 45 ee a1 00    	movw   $0xa1,-0x12(%ebp)
  10189b:	c6 45 ed 03          	movb   $0x3,-0x13(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  10189f:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  1018a3:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  1018a7:	ee                   	out    %al,(%dx)
}
  1018a8:	90                   	nop
  1018a9:	66 c7 45 f2 20 00    	movw   $0x20,-0xe(%ebp)
  1018af:	c6 45 f1 68          	movb   $0x68,-0xf(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  1018b3:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  1018b7:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  1018bb:	ee                   	out    %al,(%dx)
}
  1018bc:	90                   	nop
  1018bd:	66 c7 45 f6 20 00    	movw   $0x20,-0xa(%ebp)
  1018c3:	c6 45 f5 0a          	movb   $0xa,-0xb(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  1018c7:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  1018cb:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  1018cf:	ee                   	out    %al,(%dx)
}
  1018d0:	90                   	nop
  1018d1:	66 c7 45 fa a0 00    	movw   $0xa0,-0x6(%ebp)
  1018d7:	c6 45 f9 68          	movb   $0x68,-0x7(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  1018db:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  1018df:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  1018e3:	ee                   	out    %al,(%dx)
}
  1018e4:	90                   	nop
  1018e5:	66 c7 45 fe a0 00    	movw   $0xa0,-0x2(%ebp)
  1018eb:	c6 45 fd 0a          	movb   $0xa,-0x3(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  1018ef:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
  1018f3:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
  1018f7:	ee                   	out    %al,(%dx)
}
  1018f8:	90                   	nop
    outb(IO_PIC1, 0x0a);    // read IRR by default

    outb(IO_PIC2, 0x68);    // OCW3
    outb(IO_PIC2, 0x0a);    // OCW3

    if (irq_mask != 0xFFFF) {
  1018f9:	0f b7 05 50 05 11 00 	movzwl 0x110550,%eax
  101900:	3d ff ff 00 00       	cmp    $0xffff,%eax
  101905:	74 0f                	je     101916 <pic_init+0x149>
        pic_setmask(irq_mask);
  101907:	0f b7 05 50 05 11 00 	movzwl 0x110550,%eax
  10190e:	89 04 24             	mov    %eax,(%esp)
  101911:	e8 21 fe ff ff       	call   101737 <pic_setmask>
    }
}
  101916:	90                   	nop
  101917:	c9                   	leave  
  101918:	c3                   	ret    

00101919 <intr_enable>:
#include <x86.h>
#include <intr.h>

/* intr_enable - enable irq interrupt */
void
intr_enable(void) {
  101919:	f3 0f 1e fb          	endbr32 
  10191d:	55                   	push   %ebp
  10191e:	89 e5                	mov    %esp,%ebp
    asm volatile ("lidt (%0)" :: "r" (pd));
}

static inline void
sti(void) {
    asm volatile ("sti");
  101920:	fb                   	sti    
}
  101921:	90                   	nop
    sti();
}
  101922:	90                   	nop
  101923:	5d                   	pop    %ebp
  101924:	c3                   	ret    

00101925 <intr_disable>:

/* intr_disable - disable irq interrupt */
void
intr_disable(void) {
  101925:	f3 0f 1e fb          	endbr32 
  101929:	55                   	push   %ebp
  10192a:	89 e5                	mov    %esp,%ebp

static inline void
cli(void) {
    asm volatile ("cli");
  10192c:	fa                   	cli    
}
  10192d:	90                   	nop
    cli();
}
  10192e:	90                   	nop
  10192f:	5d                   	pop    %ebp
  101930:	c3                   	ret    

00101931 <print_ticks>:
#include <kdebug.h>
#include <string.h>

#define TICK_NUM 100

static void print_ticks() {
  101931:	f3 0f 1e fb          	endbr32 
  101935:	55                   	push   %ebp
  101936:	89 e5                	mov    %esp,%ebp
  101938:	83 ec 18             	sub    $0x18,%esp
    cprintf("%d ticks\n",TICK_NUM);
  10193b:	c7 44 24 04 64 00 00 	movl   $0x64,0x4(%esp)
  101942:	00 
  101943:	c7 04 24 40 3b 10 00 	movl   $0x103b40,(%esp)
  10194a:	e8 45 e9 ff ff       	call   100294 <cprintf>
#ifdef DEBUG_GRADE
    cprintf("End of Test.\n");
    panic("EOT: kernel seems ok.");
#endif
}
  10194f:	90                   	nop
  101950:	c9                   	leave  
  101951:	c3                   	ret    

00101952 <idt_init>:
    sizeof(idt) - 1, (uintptr_t)idt
};

/* idt_init - initialize IDT to each of the entry points in kern/trap/vectors.S */
void
idt_init(void) {
  101952:	f3 0f 1e fb          	endbr32 
  101956:	55                   	push   %ebp
  101957:	89 e5                	mov    %esp,%ebp
  101959:	83 ec 10             	sub    $0x10,%esp
      */
    
    // 定义中断向量表
    extern uintptr_t __vectors[];
    // 向量表的长度为sizeof(idt) / sizeof(struct gatedesc)
    for (int i = 0; i < sizeof(idt) / sizeof(struct gatedesc); i ++) {
  10195c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  101963:	e9 c4 00 00 00       	jmp    101a2c <idt_init+0xda>
    // idt描述表项，0表示是interupt而不是trap，GD_KTEXT为段选择子，__vectors[i]为偏移量，DPL_KERNEL为特权级
        SETGATE(idt[i], 0, GD_KTEXT, __vectors[i], DPL_KERNEL);
  101968:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10196b:	8b 04 85 e0 05 11 00 	mov    0x1105e0(,%eax,4),%eax
  101972:	0f b7 d0             	movzwl %ax,%edx
  101975:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101978:	66 89 14 c5 a0 10 11 	mov    %dx,0x1110a0(,%eax,8)
  10197f:	00 
  101980:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101983:	66 c7 04 c5 a2 10 11 	movw   $0x8,0x1110a2(,%eax,8)
  10198a:	00 08 00 
  10198d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101990:	0f b6 14 c5 a4 10 11 	movzbl 0x1110a4(,%eax,8),%edx
  101997:	00 
  101998:	80 e2 e0             	and    $0xe0,%dl
  10199b:	88 14 c5 a4 10 11 00 	mov    %dl,0x1110a4(,%eax,8)
  1019a2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1019a5:	0f b6 14 c5 a4 10 11 	movzbl 0x1110a4(,%eax,8),%edx
  1019ac:	00 
  1019ad:	80 e2 1f             	and    $0x1f,%dl
  1019b0:	88 14 c5 a4 10 11 00 	mov    %dl,0x1110a4(,%eax,8)
  1019b7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1019ba:	0f b6 14 c5 a5 10 11 	movzbl 0x1110a5(,%eax,8),%edx
  1019c1:	00 
  1019c2:	80 e2 f0             	and    $0xf0,%dl
  1019c5:	80 ca 0e             	or     $0xe,%dl
  1019c8:	88 14 c5 a5 10 11 00 	mov    %dl,0x1110a5(,%eax,8)
  1019cf:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1019d2:	0f b6 14 c5 a5 10 11 	movzbl 0x1110a5(,%eax,8),%edx
  1019d9:	00 
  1019da:	80 e2 ef             	and    $0xef,%dl
  1019dd:	88 14 c5 a5 10 11 00 	mov    %dl,0x1110a5(,%eax,8)
  1019e4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1019e7:	0f b6 14 c5 a5 10 11 	movzbl 0x1110a5(,%eax,8),%edx
  1019ee:	00 
  1019ef:	80 e2 9f             	and    $0x9f,%dl
  1019f2:	88 14 c5 a5 10 11 00 	mov    %dl,0x1110a5(,%eax,8)
  1019f9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1019fc:	0f b6 14 c5 a5 10 11 	movzbl 0x1110a5(,%eax,8),%edx
  101a03:	00 
  101a04:	80 ca 80             	or     $0x80,%dl
  101a07:	88 14 c5 a5 10 11 00 	mov    %dl,0x1110a5(,%eax,8)
  101a0e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101a11:	8b 04 85 e0 05 11 00 	mov    0x1105e0(,%eax,4),%eax
  101a18:	c1 e8 10             	shr    $0x10,%eax
  101a1b:	0f b7 d0             	movzwl %ax,%edx
  101a1e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101a21:	66 89 14 c5 a6 10 11 	mov    %dx,0x1110a6(,%eax,8)
  101a28:	00 
    for (int i = 0; i < sizeof(idt) / sizeof(struct gatedesc); i ++) {
  101a29:	ff 45 fc             	incl   -0x4(%ebp)
  101a2c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101a2f:	3d ff 00 00 00       	cmp    $0xff,%eax
  101a34:	0f 86 2e ff ff ff    	jbe    101968 <idt_init+0x16>
    }
	// set for switch from user to kernel
    // 选择需要从user特权级转化为kernel特权级的项
    SETGATE(idt[T_SWITCH_TOK], 1, KERNEL_CS, __vectors[T_SWITCH_TOK], DPL_USER);
  101a3a:	a1 c4 07 11 00       	mov    0x1107c4,%eax
  101a3f:	0f b7 c0             	movzwl %ax,%eax
  101a42:	66 a3 68 14 11 00    	mov    %ax,0x111468
  101a48:	66 c7 05 6a 14 11 00 	movw   $0x8,0x11146a
  101a4f:	08 00 
  101a51:	0f b6 05 6c 14 11 00 	movzbl 0x11146c,%eax
  101a58:	24 e0                	and    $0xe0,%al
  101a5a:	a2 6c 14 11 00       	mov    %al,0x11146c
  101a5f:	0f b6 05 6c 14 11 00 	movzbl 0x11146c,%eax
  101a66:	24 1f                	and    $0x1f,%al
  101a68:	a2 6c 14 11 00       	mov    %al,0x11146c
  101a6d:	0f b6 05 6d 14 11 00 	movzbl 0x11146d,%eax
  101a74:	0c 0f                	or     $0xf,%al
  101a76:	a2 6d 14 11 00       	mov    %al,0x11146d
  101a7b:	0f b6 05 6d 14 11 00 	movzbl 0x11146d,%eax
  101a82:	24 ef                	and    $0xef,%al
  101a84:	a2 6d 14 11 00       	mov    %al,0x11146d
  101a89:	0f b6 05 6d 14 11 00 	movzbl 0x11146d,%eax
  101a90:	0c 60                	or     $0x60,%al
  101a92:	a2 6d 14 11 00       	mov    %al,0x11146d
  101a97:	0f b6 05 6d 14 11 00 	movzbl 0x11146d,%eax
  101a9e:	0c 80                	or     $0x80,%al
  101aa0:	a2 6d 14 11 00       	mov    %al,0x11146d
  101aa5:	a1 c4 07 11 00       	mov    0x1107c4,%eax
  101aaa:	c1 e8 10             	shr    $0x10,%eax
  101aad:	0f b7 c0             	movzwl %ax,%eax
  101ab0:	66 a3 6e 14 11 00    	mov    %ax,0x11146e
  101ab6:	c7 45 f8 60 05 11 00 	movl   $0x110560,-0x8(%ebp)
    asm volatile ("lidt (%0)" :: "r" (pd));
  101abd:	8b 45 f8             	mov    -0x8(%ebp),%eax
  101ac0:	0f 01 18             	lidtl  (%eax)
}
  101ac3:	90                   	nop
	// load the IDT
    // 加载IDT
    lidt(&idt_pd);
}
  101ac4:	90                   	nop
  101ac5:	c9                   	leave  
  101ac6:	c3                   	ret    

00101ac7 <trapname>:

static const char *
trapname(int trapno) {
  101ac7:	f3 0f 1e fb          	endbr32 
  101acb:	55                   	push   %ebp
  101acc:	89 e5                	mov    %esp,%ebp
        "Alignment Check",
        "Machine-Check",
        "SIMD Floating-Point Exception"
    };

    if (trapno < sizeof(excnames)/sizeof(const char * const)) {
  101ace:	8b 45 08             	mov    0x8(%ebp),%eax
  101ad1:	83 f8 13             	cmp    $0x13,%eax
  101ad4:	77 0c                	ja     101ae2 <trapname+0x1b>
        return excnames[trapno];
  101ad6:	8b 45 08             	mov    0x8(%ebp),%eax
  101ad9:	8b 04 85 a0 3e 10 00 	mov    0x103ea0(,%eax,4),%eax
  101ae0:	eb 18                	jmp    101afa <trapname+0x33>
    }
    if (trapno >= IRQ_OFFSET && trapno < IRQ_OFFSET + 16) {
  101ae2:	83 7d 08 1f          	cmpl   $0x1f,0x8(%ebp)
  101ae6:	7e 0d                	jle    101af5 <trapname+0x2e>
  101ae8:	83 7d 08 2f          	cmpl   $0x2f,0x8(%ebp)
  101aec:	7f 07                	jg     101af5 <trapname+0x2e>
        return "Hardware Interrupt";
  101aee:	b8 4a 3b 10 00       	mov    $0x103b4a,%eax
  101af3:	eb 05                	jmp    101afa <trapname+0x33>
    }
    return "(unknown trap)";
  101af5:	b8 5d 3b 10 00       	mov    $0x103b5d,%eax
}
  101afa:	5d                   	pop    %ebp
  101afb:	c3                   	ret    

00101afc <trap_in_kernel>:

/* trap_in_kernel - test if trap happened in kernel */
bool
trap_in_kernel(struct trapframe *tf) {
  101afc:	f3 0f 1e fb          	endbr32 
  101b00:	55                   	push   %ebp
  101b01:	89 e5                	mov    %esp,%ebp
    return (tf->tf_cs == (uint16_t)KERNEL_CS);
  101b03:	8b 45 08             	mov    0x8(%ebp),%eax
  101b06:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101b0a:	83 f8 08             	cmp    $0x8,%eax
  101b0d:	0f 94 c0             	sete   %al
  101b10:	0f b6 c0             	movzbl %al,%eax
}
  101b13:	5d                   	pop    %ebp
  101b14:	c3                   	ret    

00101b15 <print_trapframe>:
    "TF", "IF", "DF", "OF", NULL, NULL, "NT", NULL,
    "RF", "VM", "AC", "VIF", "VIP", "ID", NULL, NULL,
};

void
print_trapframe(struct trapframe *tf) {
  101b15:	f3 0f 1e fb          	endbr32 
  101b19:	55                   	push   %ebp
  101b1a:	89 e5                	mov    %esp,%ebp
  101b1c:	83 ec 28             	sub    $0x28,%esp
    cprintf("trapframe at %p\n", tf);
  101b1f:	8b 45 08             	mov    0x8(%ebp),%eax
  101b22:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b26:	c7 04 24 9e 3b 10 00 	movl   $0x103b9e,(%esp)
  101b2d:	e8 62 e7 ff ff       	call   100294 <cprintf>
    print_regs(&tf->tf_regs);
  101b32:	8b 45 08             	mov    0x8(%ebp),%eax
  101b35:	89 04 24             	mov    %eax,(%esp)
  101b38:	e8 8d 01 00 00       	call   101cca <print_regs>
    cprintf("  ds   0x----%04x\n", tf->tf_ds);
  101b3d:	8b 45 08             	mov    0x8(%ebp),%eax
  101b40:	0f b7 40 2c          	movzwl 0x2c(%eax),%eax
  101b44:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b48:	c7 04 24 af 3b 10 00 	movl   $0x103baf,(%esp)
  101b4f:	e8 40 e7 ff ff       	call   100294 <cprintf>
    cprintf("  es   0x----%04x\n", tf->tf_es);
  101b54:	8b 45 08             	mov    0x8(%ebp),%eax
  101b57:	0f b7 40 28          	movzwl 0x28(%eax),%eax
  101b5b:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b5f:	c7 04 24 c2 3b 10 00 	movl   $0x103bc2,(%esp)
  101b66:	e8 29 e7 ff ff       	call   100294 <cprintf>
    cprintf("  fs   0x----%04x\n", tf->tf_fs);
  101b6b:	8b 45 08             	mov    0x8(%ebp),%eax
  101b6e:	0f b7 40 24          	movzwl 0x24(%eax),%eax
  101b72:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b76:	c7 04 24 d5 3b 10 00 	movl   $0x103bd5,(%esp)
  101b7d:	e8 12 e7 ff ff       	call   100294 <cprintf>
    cprintf("  gs   0x----%04x\n", tf->tf_gs);
  101b82:	8b 45 08             	mov    0x8(%ebp),%eax
  101b85:	0f b7 40 20          	movzwl 0x20(%eax),%eax
  101b89:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b8d:	c7 04 24 e8 3b 10 00 	movl   $0x103be8,(%esp)
  101b94:	e8 fb e6 ff ff       	call   100294 <cprintf>
    cprintf("  trap 0x%08x %s\n", tf->tf_trapno, trapname(tf->tf_trapno));
  101b99:	8b 45 08             	mov    0x8(%ebp),%eax
  101b9c:	8b 40 30             	mov    0x30(%eax),%eax
  101b9f:	89 04 24             	mov    %eax,(%esp)
  101ba2:	e8 20 ff ff ff       	call   101ac7 <trapname>
  101ba7:	8b 55 08             	mov    0x8(%ebp),%edx
  101baa:	8b 52 30             	mov    0x30(%edx),%edx
  101bad:	89 44 24 08          	mov    %eax,0x8(%esp)
  101bb1:	89 54 24 04          	mov    %edx,0x4(%esp)
  101bb5:	c7 04 24 fb 3b 10 00 	movl   $0x103bfb,(%esp)
  101bbc:	e8 d3 e6 ff ff       	call   100294 <cprintf>
    cprintf("  err  0x%08x\n", tf->tf_err);
  101bc1:	8b 45 08             	mov    0x8(%ebp),%eax
  101bc4:	8b 40 34             	mov    0x34(%eax),%eax
  101bc7:	89 44 24 04          	mov    %eax,0x4(%esp)
  101bcb:	c7 04 24 0d 3c 10 00 	movl   $0x103c0d,(%esp)
  101bd2:	e8 bd e6 ff ff       	call   100294 <cprintf>
    cprintf("  eip  0x%08x\n", tf->tf_eip);
  101bd7:	8b 45 08             	mov    0x8(%ebp),%eax
  101bda:	8b 40 38             	mov    0x38(%eax),%eax
  101bdd:	89 44 24 04          	mov    %eax,0x4(%esp)
  101be1:	c7 04 24 1c 3c 10 00 	movl   $0x103c1c,(%esp)
  101be8:	e8 a7 e6 ff ff       	call   100294 <cprintf>
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
  101bed:	8b 45 08             	mov    0x8(%ebp),%eax
  101bf0:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101bf4:	89 44 24 04          	mov    %eax,0x4(%esp)
  101bf8:	c7 04 24 2b 3c 10 00 	movl   $0x103c2b,(%esp)
  101bff:	e8 90 e6 ff ff       	call   100294 <cprintf>
    cprintf("  flag 0x%08x ", tf->tf_eflags);
  101c04:	8b 45 08             	mov    0x8(%ebp),%eax
  101c07:	8b 40 40             	mov    0x40(%eax),%eax
  101c0a:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c0e:	c7 04 24 3e 3c 10 00 	movl   $0x103c3e,(%esp)
  101c15:	e8 7a e6 ff ff       	call   100294 <cprintf>

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
  101c1a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  101c21:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
  101c28:	eb 3d                	jmp    101c67 <print_trapframe+0x152>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
  101c2a:	8b 45 08             	mov    0x8(%ebp),%eax
  101c2d:	8b 50 40             	mov    0x40(%eax),%edx
  101c30:	8b 45 f0             	mov    -0x10(%ebp),%eax
  101c33:	21 d0                	and    %edx,%eax
  101c35:	85 c0                	test   %eax,%eax
  101c37:	74 28                	je     101c61 <print_trapframe+0x14c>
  101c39:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101c3c:	8b 04 85 80 05 11 00 	mov    0x110580(,%eax,4),%eax
  101c43:	85 c0                	test   %eax,%eax
  101c45:	74 1a                	je     101c61 <print_trapframe+0x14c>
            cprintf("%s,", IA32flags[i]);
  101c47:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101c4a:	8b 04 85 80 05 11 00 	mov    0x110580(,%eax,4),%eax
  101c51:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c55:	c7 04 24 4d 3c 10 00 	movl   $0x103c4d,(%esp)
  101c5c:	e8 33 e6 ff ff       	call   100294 <cprintf>
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
  101c61:	ff 45 f4             	incl   -0xc(%ebp)
  101c64:	d1 65 f0             	shll   -0x10(%ebp)
  101c67:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101c6a:	83 f8 17             	cmp    $0x17,%eax
  101c6d:	76 bb                	jbe    101c2a <print_trapframe+0x115>
        }
    }
    cprintf("IOPL=%d\n", (tf->tf_eflags & FL_IOPL_MASK) >> 12);
  101c6f:	8b 45 08             	mov    0x8(%ebp),%eax
  101c72:	8b 40 40             	mov    0x40(%eax),%eax
  101c75:	c1 e8 0c             	shr    $0xc,%eax
  101c78:	83 e0 03             	and    $0x3,%eax
  101c7b:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c7f:	c7 04 24 51 3c 10 00 	movl   $0x103c51,(%esp)
  101c86:	e8 09 e6 ff ff       	call   100294 <cprintf>

    if (!trap_in_kernel(tf)) {
  101c8b:	8b 45 08             	mov    0x8(%ebp),%eax
  101c8e:	89 04 24             	mov    %eax,(%esp)
  101c91:	e8 66 fe ff ff       	call   101afc <trap_in_kernel>
  101c96:	85 c0                	test   %eax,%eax
  101c98:	75 2d                	jne    101cc7 <print_trapframe+0x1b2>
        cprintf("  esp  0x%08x\n", tf->tf_esp);
  101c9a:	8b 45 08             	mov    0x8(%ebp),%eax
  101c9d:	8b 40 44             	mov    0x44(%eax),%eax
  101ca0:	89 44 24 04          	mov    %eax,0x4(%esp)
  101ca4:	c7 04 24 5a 3c 10 00 	movl   $0x103c5a,(%esp)
  101cab:	e8 e4 e5 ff ff       	call   100294 <cprintf>
        cprintf("  ss   0x----%04x\n", tf->tf_ss);
  101cb0:	8b 45 08             	mov    0x8(%ebp),%eax
  101cb3:	0f b7 40 48          	movzwl 0x48(%eax),%eax
  101cb7:	89 44 24 04          	mov    %eax,0x4(%esp)
  101cbb:	c7 04 24 69 3c 10 00 	movl   $0x103c69,(%esp)
  101cc2:	e8 cd e5 ff ff       	call   100294 <cprintf>
    }
}
  101cc7:	90                   	nop
  101cc8:	c9                   	leave  
  101cc9:	c3                   	ret    

00101cca <print_regs>:

void
print_regs(struct pushregs *regs) {
  101cca:	f3 0f 1e fb          	endbr32 
  101cce:	55                   	push   %ebp
  101ccf:	89 e5                	mov    %esp,%ebp
  101cd1:	83 ec 18             	sub    $0x18,%esp
    cprintf("  edi  0x%08x\n", regs->reg_edi);
  101cd4:	8b 45 08             	mov    0x8(%ebp),%eax
  101cd7:	8b 00                	mov    (%eax),%eax
  101cd9:	89 44 24 04          	mov    %eax,0x4(%esp)
  101cdd:	c7 04 24 7c 3c 10 00 	movl   $0x103c7c,(%esp)
  101ce4:	e8 ab e5 ff ff       	call   100294 <cprintf>
    cprintf("  esi  0x%08x\n", regs->reg_esi);
  101ce9:	8b 45 08             	mov    0x8(%ebp),%eax
  101cec:	8b 40 04             	mov    0x4(%eax),%eax
  101cef:	89 44 24 04          	mov    %eax,0x4(%esp)
  101cf3:	c7 04 24 8b 3c 10 00 	movl   $0x103c8b,(%esp)
  101cfa:	e8 95 e5 ff ff       	call   100294 <cprintf>
    cprintf("  ebp  0x%08x\n", regs->reg_ebp);
  101cff:	8b 45 08             	mov    0x8(%ebp),%eax
  101d02:	8b 40 08             	mov    0x8(%eax),%eax
  101d05:	89 44 24 04          	mov    %eax,0x4(%esp)
  101d09:	c7 04 24 9a 3c 10 00 	movl   $0x103c9a,(%esp)
  101d10:	e8 7f e5 ff ff       	call   100294 <cprintf>
    cprintf("  oesp 0x%08x\n", regs->reg_oesp);
  101d15:	8b 45 08             	mov    0x8(%ebp),%eax
  101d18:	8b 40 0c             	mov    0xc(%eax),%eax
  101d1b:	89 44 24 04          	mov    %eax,0x4(%esp)
  101d1f:	c7 04 24 a9 3c 10 00 	movl   $0x103ca9,(%esp)
  101d26:	e8 69 e5 ff ff       	call   100294 <cprintf>
    cprintf("  ebx  0x%08x\n", regs->reg_ebx);
  101d2b:	8b 45 08             	mov    0x8(%ebp),%eax
  101d2e:	8b 40 10             	mov    0x10(%eax),%eax
  101d31:	89 44 24 04          	mov    %eax,0x4(%esp)
  101d35:	c7 04 24 b8 3c 10 00 	movl   $0x103cb8,(%esp)
  101d3c:	e8 53 e5 ff ff       	call   100294 <cprintf>
    cprintf("  edx  0x%08x\n", regs->reg_edx);
  101d41:	8b 45 08             	mov    0x8(%ebp),%eax
  101d44:	8b 40 14             	mov    0x14(%eax),%eax
  101d47:	89 44 24 04          	mov    %eax,0x4(%esp)
  101d4b:	c7 04 24 c7 3c 10 00 	movl   $0x103cc7,(%esp)
  101d52:	e8 3d e5 ff ff       	call   100294 <cprintf>
    cprintf("  ecx  0x%08x\n", regs->reg_ecx);
  101d57:	8b 45 08             	mov    0x8(%ebp),%eax
  101d5a:	8b 40 18             	mov    0x18(%eax),%eax
  101d5d:	89 44 24 04          	mov    %eax,0x4(%esp)
  101d61:	c7 04 24 d6 3c 10 00 	movl   $0x103cd6,(%esp)
  101d68:	e8 27 e5 ff ff       	call   100294 <cprintf>
    cprintf("  eax  0x%08x\n", regs->reg_eax);
  101d6d:	8b 45 08             	mov    0x8(%ebp),%eax
  101d70:	8b 40 1c             	mov    0x1c(%eax),%eax
  101d73:	89 44 24 04          	mov    %eax,0x4(%esp)
  101d77:	c7 04 24 e5 3c 10 00 	movl   $0x103ce5,(%esp)
  101d7e:	e8 11 e5 ff ff       	call   100294 <cprintf>
}
  101d83:	90                   	nop
  101d84:	c9                   	leave  
  101d85:	c3                   	ret    

00101d86 <trap_dispatch>:
/* temporary trapframe or pointer to trapframe */
struct trapframe switchk2u, *switchu2k;

/* trap_dispatch - dispatch based on what type of trap occurred */
static void
trap_dispatch(struct trapframe *tf) {
  101d86:	f3 0f 1e fb          	endbr32 
  101d8a:	55                   	push   %ebp
  101d8b:	89 e5                	mov    %esp,%ebp
  101d8d:	57                   	push   %edi
  101d8e:	56                   	push   %esi
  101d8f:	53                   	push   %ebx
  101d90:	83 ec 2c             	sub    $0x2c,%esp
    char c;

    switch (tf->tf_trapno) {
  101d93:	8b 45 08             	mov    0x8(%ebp),%eax
  101d96:	8b 40 30             	mov    0x30(%eax),%eax
  101d99:	83 f8 79             	cmp    $0x79,%eax
  101d9c:	0f 84 d2 01 00 00    	je     101f74 <trap_dispatch+0x1ee>
  101da2:	83 f8 79             	cmp    $0x79,%eax
  101da5:	0f 87 5d 02 00 00    	ja     102008 <trap_dispatch+0x282>
  101dab:	83 f8 78             	cmp    $0x78,%eax
  101dae:	0f 84 d0 00 00 00    	je     101e84 <trap_dispatch+0xfe>
  101db4:	83 f8 78             	cmp    $0x78,%eax
  101db7:	0f 87 4b 02 00 00    	ja     102008 <trap_dispatch+0x282>
  101dbd:	83 f8 2f             	cmp    $0x2f,%eax
  101dc0:	0f 87 42 02 00 00    	ja     102008 <trap_dispatch+0x282>
  101dc6:	83 f8 2e             	cmp    $0x2e,%eax
  101dc9:	0f 83 6e 02 00 00    	jae    10203d <trap_dispatch+0x2b7>
  101dcf:	83 f8 24             	cmp    $0x24,%eax
  101dd2:	74 5e                	je     101e32 <trap_dispatch+0xac>
  101dd4:	83 f8 24             	cmp    $0x24,%eax
  101dd7:	0f 87 2b 02 00 00    	ja     102008 <trap_dispatch+0x282>
  101ddd:	83 f8 20             	cmp    $0x20,%eax
  101de0:	74 0a                	je     101dec <trap_dispatch+0x66>
  101de2:	83 f8 21             	cmp    $0x21,%eax
  101de5:	74 74                	je     101e5b <trap_dispatch+0xd5>
  101de7:	e9 1c 02 00 00       	jmp    102008 <trap_dispatch+0x282>
        /* handle the timer interrupt */
        /* (1) After a timer interrupt, you should record this event using a global variable (increase it), such as ticks in kern/driver/clock.c
         * (2) Every TICK_NUM cycle, you can print some info using a funciton, such as print_ticks().
         * (3) Too Simple? Yes, I think so!
         */
        ticks ++;
  101dec:	a1 08 19 11 00       	mov    0x111908,%eax
  101df1:	40                   	inc    %eax
  101df2:	a3 08 19 11 00       	mov    %eax,0x111908
        if (ticks % TICK_NUM == 0) {
  101df7:	8b 0d 08 19 11 00    	mov    0x111908,%ecx
  101dfd:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
  101e02:	89 c8                	mov    %ecx,%eax
  101e04:	f7 e2                	mul    %edx
  101e06:	c1 ea 05             	shr    $0x5,%edx
  101e09:	89 d0                	mov    %edx,%eax
  101e0b:	c1 e0 02             	shl    $0x2,%eax
  101e0e:	01 d0                	add    %edx,%eax
  101e10:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  101e17:	01 d0                	add    %edx,%eax
  101e19:	c1 e0 02             	shl    $0x2,%eax
  101e1c:	29 c1                	sub    %eax,%ecx
  101e1e:	89 ca                	mov    %ecx,%edx
  101e20:	85 d2                	test   %edx,%edx
  101e22:	0f 85 18 02 00 00    	jne    102040 <trap_dispatch+0x2ba>
            print_ticks();
  101e28:	e8 04 fb ff ff       	call   101931 <print_ticks>
        }
        break;
  101e2d:	e9 0e 02 00 00       	jmp    102040 <trap_dispatch+0x2ba>
    case IRQ_OFFSET + IRQ_COM1:
        c = cons_getc();
  101e32:	e8 a0 f8 ff ff       	call   1016d7 <cons_getc>
  101e37:	88 45 e7             	mov    %al,-0x19(%ebp)
        cprintf("serial [%03d] %c\n", c, c);
  101e3a:	0f be 55 e7          	movsbl -0x19(%ebp),%edx
  101e3e:	0f be 45 e7          	movsbl -0x19(%ebp),%eax
  101e42:	89 54 24 08          	mov    %edx,0x8(%esp)
  101e46:	89 44 24 04          	mov    %eax,0x4(%esp)
  101e4a:	c7 04 24 f4 3c 10 00 	movl   $0x103cf4,(%esp)
  101e51:	e8 3e e4 ff ff       	call   100294 <cprintf>
        break;
  101e56:	e9 ec 01 00 00       	jmp    102047 <trap_dispatch+0x2c1>
    case IRQ_OFFSET + IRQ_KBD:
        c = cons_getc();
  101e5b:	e8 77 f8 ff ff       	call   1016d7 <cons_getc>
  101e60:	88 45 e7             	mov    %al,-0x19(%ebp)
        cprintf("kbd [%03d] %c\n", c, c);
  101e63:	0f be 55 e7          	movsbl -0x19(%ebp),%edx
  101e67:	0f be 45 e7          	movsbl -0x19(%ebp),%eax
  101e6b:	89 54 24 08          	mov    %edx,0x8(%esp)
  101e6f:	89 44 24 04          	mov    %eax,0x4(%esp)
  101e73:	c7 04 24 06 3d 10 00 	movl   $0x103d06,(%esp)
  101e7a:	e8 15 e4 ff ff       	call   100294 <cprintf>
        break;
  101e7f:	e9 c3 01 00 00       	jmp    102047 <trap_dispatch+0x2c1>
    //LAB1 CHALLENGE 1 : YOUR CODE you should modify below codes.
    case T_SWITCH_TOU:
    
    if (tf->tf_cs != USER_CS) {
  101e84:	8b 45 08             	mov    0x8(%ebp),%eax
  101e87:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101e8b:	83 f8 1b             	cmp    $0x1b,%eax
  101e8e:	0f 84 af 01 00 00    	je     102043 <trap_dispatch+0x2bd>
            switchk2u = *tf;
  101e94:	8b 55 08             	mov    0x8(%ebp),%edx
  101e97:	b8 20 19 11 00       	mov    $0x111920,%eax
  101e9c:	bb 4c 00 00 00       	mov    $0x4c,%ebx
  101ea1:	89 c1                	mov    %eax,%ecx
  101ea3:	83 e1 01             	and    $0x1,%ecx
  101ea6:	85 c9                	test   %ecx,%ecx
  101ea8:	74 0c                	je     101eb6 <trap_dispatch+0x130>
  101eaa:	0f b6 0a             	movzbl (%edx),%ecx
  101ead:	88 08                	mov    %cl,(%eax)
  101eaf:	8d 40 01             	lea    0x1(%eax),%eax
  101eb2:	8d 52 01             	lea    0x1(%edx),%edx
  101eb5:	4b                   	dec    %ebx
  101eb6:	89 c1                	mov    %eax,%ecx
  101eb8:	83 e1 02             	and    $0x2,%ecx
  101ebb:	85 c9                	test   %ecx,%ecx
  101ebd:	74 0f                	je     101ece <trap_dispatch+0x148>
  101ebf:	0f b7 0a             	movzwl (%edx),%ecx
  101ec2:	66 89 08             	mov    %cx,(%eax)
  101ec5:	8d 40 02             	lea    0x2(%eax),%eax
  101ec8:	8d 52 02             	lea    0x2(%edx),%edx
  101ecb:	83 eb 02             	sub    $0x2,%ebx
  101ece:	89 df                	mov    %ebx,%edi
  101ed0:	83 e7 fc             	and    $0xfffffffc,%edi
  101ed3:	b9 00 00 00 00       	mov    $0x0,%ecx
  101ed8:	8b 34 0a             	mov    (%edx,%ecx,1),%esi
  101edb:	89 34 08             	mov    %esi,(%eax,%ecx,1)
  101ede:	83 c1 04             	add    $0x4,%ecx
  101ee1:	39 f9                	cmp    %edi,%ecx
  101ee3:	72 f3                	jb     101ed8 <trap_dispatch+0x152>
  101ee5:	01 c8                	add    %ecx,%eax
  101ee7:	01 ca                	add    %ecx,%edx
  101ee9:	b9 00 00 00 00       	mov    $0x0,%ecx
  101eee:	89 de                	mov    %ebx,%esi
  101ef0:	83 e6 02             	and    $0x2,%esi
  101ef3:	85 f6                	test   %esi,%esi
  101ef5:	74 0b                	je     101f02 <trap_dispatch+0x17c>
  101ef7:	0f b7 34 0a          	movzwl (%edx,%ecx,1),%esi
  101efb:	66 89 34 08          	mov    %si,(%eax,%ecx,1)
  101eff:	83 c1 02             	add    $0x2,%ecx
  101f02:	83 e3 01             	and    $0x1,%ebx
  101f05:	85 db                	test   %ebx,%ebx
  101f07:	74 07                	je     101f10 <trap_dispatch+0x18a>
  101f09:	0f b6 14 0a          	movzbl (%edx,%ecx,1),%edx
  101f0d:	88 14 08             	mov    %dl,(%eax,%ecx,1)
            switchk2u.tf_cs = USER_CS;
  101f10:	66 c7 05 5c 19 11 00 	movw   $0x1b,0x11195c
  101f17:	1b 00 
            switchk2u.tf_ds = switchk2u.tf_es = switchk2u.tf_ss = USER_DS;
  101f19:	66 c7 05 68 19 11 00 	movw   $0x23,0x111968
  101f20:	23 00 
  101f22:	0f b7 05 68 19 11 00 	movzwl 0x111968,%eax
  101f29:	66 a3 48 19 11 00    	mov    %ax,0x111948
  101f2f:	0f b7 05 48 19 11 00 	movzwl 0x111948,%eax
  101f36:	66 a3 4c 19 11 00    	mov    %ax,0x11194c
            switchk2u.tf_esp = (uint32_t)tf + sizeof(struct trapframe) - 8;
  101f3c:	8b 45 08             	mov    0x8(%ebp),%eax
  101f3f:	83 c0 44             	add    $0x44,%eax
  101f42:	a3 64 19 11 00       	mov    %eax,0x111964
		
            // set eflags, make sure ucore can use io under user mode.
            // if CPL > IOPL, then cpu will generate a general protection.
            switchk2u.tf_eflags |= FL_IOPL_MASK;
  101f47:	a1 60 19 11 00       	mov    0x111960,%eax
  101f4c:	0d 00 30 00 00       	or     $0x3000,%eax
  101f51:	a3 60 19 11 00       	mov    %eax,0x111960
		
            // set temporary stack
            // then iret will jump to the right stack
            *((uint32_t *)tf - 1) = (uint32_t)&switchk2u;
  101f56:	8b 45 08             	mov    0x8(%ebp),%eax
  101f59:	83 e8 04             	sub    $0x4,%eax
  101f5c:	ba 20 19 11 00       	mov    $0x111920,%edx
  101f61:	89 10                	mov    %edx,(%eax)
            print_trapframe(&switchk2u);
  101f63:	c7 04 24 20 19 11 00 	movl   $0x111920,(%esp)
  101f6a:	e8 a6 fb ff ff       	call   101b15 <print_trapframe>
        }
        break;
  101f6f:	e9 cf 00 00 00       	jmp    102043 <trap_dispatch+0x2bd>
    case T_SWITCH_TOK:
    print_trapframe(tf);
  101f74:	8b 45 08             	mov    0x8(%ebp),%eax
  101f77:	89 04 24             	mov    %eax,(%esp)
  101f7a:	e8 96 fb ff ff       	call   101b15 <print_trapframe>
    if (tf->tf_cs != KERNEL_CS) {
  101f7f:	8b 45 08             	mov    0x8(%ebp),%eax
  101f82:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101f86:	83 f8 08             	cmp    $0x8,%eax
  101f89:	0f 84 b7 00 00 00    	je     102046 <trap_dispatch+0x2c0>
            tf->tf_cs = KERNEL_CS;
  101f8f:	8b 45 08             	mov    0x8(%ebp),%eax
  101f92:	66 c7 40 3c 08 00    	movw   $0x8,0x3c(%eax)
            tf->tf_ds = tf->tf_es = KERNEL_DS;
  101f98:	8b 45 08             	mov    0x8(%ebp),%eax
  101f9b:	66 c7 40 28 10 00    	movw   $0x10,0x28(%eax)
  101fa1:	8b 45 08             	mov    0x8(%ebp),%eax
  101fa4:	0f b7 50 28          	movzwl 0x28(%eax),%edx
  101fa8:	8b 45 08             	mov    0x8(%ebp),%eax
  101fab:	66 89 50 2c          	mov    %dx,0x2c(%eax)
            tf->tf_eflags &= ~FL_IOPL_MASK;
  101faf:	8b 45 08             	mov    0x8(%ebp),%eax
  101fb2:	8b 40 40             	mov    0x40(%eax),%eax
  101fb5:	25 ff cf ff ff       	and    $0xffffcfff,%eax
  101fba:	89 c2                	mov    %eax,%edx
  101fbc:	8b 45 08             	mov    0x8(%ebp),%eax
  101fbf:	89 50 40             	mov    %edx,0x40(%eax)
            switchu2k = (struct trapframe *)(tf->tf_esp - (sizeof(struct trapframe) - 8));
  101fc2:	8b 45 08             	mov    0x8(%ebp),%eax
  101fc5:	8b 40 44             	mov    0x44(%eax),%eax
  101fc8:	83 e8 44             	sub    $0x44,%eax
  101fcb:	a3 6c 19 11 00       	mov    %eax,0x11196c
            memmove(switchu2k, tf, sizeof(struct trapframe) - 8);
  101fd0:	a1 6c 19 11 00       	mov    0x11196c,%eax
  101fd5:	c7 44 24 08 44 00 00 	movl   $0x44,0x8(%esp)
  101fdc:	00 
  101fdd:	8b 55 08             	mov    0x8(%ebp),%edx
  101fe0:	89 54 24 04          	mov    %edx,0x4(%esp)
  101fe4:	89 04 24             	mov    %eax,(%esp)
  101fe7:	e8 f7 0f 00 00       	call   102fe3 <memmove>
            *((uint32_t *)tf - 1) = (uint32_t)switchu2k;
  101fec:	8b 15 6c 19 11 00    	mov    0x11196c,%edx
  101ff2:	8b 45 08             	mov    0x8(%ebp),%eax
  101ff5:	83 e8 04             	sub    $0x4,%eax
  101ff8:	89 10                	mov    %edx,(%eax)
            print_trapframe(&switchu2k);
  101ffa:	c7 04 24 6c 19 11 00 	movl   $0x11196c,(%esp)
  102001:	e8 0f fb ff ff       	call   101b15 <print_trapframe>
        }
        break;
  102006:	eb 3e                	jmp    102046 <trap_dispatch+0x2c0>
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
    default:
        // in kernel, it must be a mistake
        if ((tf->tf_cs & 3) == 0) {
  102008:	8b 45 08             	mov    0x8(%ebp),%eax
  10200b:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  10200f:	83 e0 03             	and    $0x3,%eax
  102012:	85 c0                	test   %eax,%eax
  102014:	75 31                	jne    102047 <trap_dispatch+0x2c1>
            print_trapframe(tf);
  102016:	8b 45 08             	mov    0x8(%ebp),%eax
  102019:	89 04 24             	mov    %eax,(%esp)
  10201c:	e8 f4 fa ff ff       	call   101b15 <print_trapframe>
            panic("unexpected trap in kernel.\n");
  102021:	c7 44 24 08 15 3d 10 	movl   $0x103d15,0x8(%esp)
  102028:	00 
  102029:	c7 44 24 04 dc 00 00 	movl   $0xdc,0x4(%esp)
  102030:	00 
  102031:	c7 04 24 31 3d 10 00 	movl   $0x103d31,(%esp)
  102038:	e8 c3 e3 ff ff       	call   100400 <__panic>
        break;
  10203d:	90                   	nop
  10203e:	eb 07                	jmp    102047 <trap_dispatch+0x2c1>
        break;
  102040:	90                   	nop
  102041:	eb 04                	jmp    102047 <trap_dispatch+0x2c1>
        break;
  102043:	90                   	nop
  102044:	eb 01                	jmp    102047 <trap_dispatch+0x2c1>
        break;
  102046:	90                   	nop
        }
    }
}
  102047:	90                   	nop
  102048:	83 c4 2c             	add    $0x2c,%esp
  10204b:	5b                   	pop    %ebx
  10204c:	5e                   	pop    %esi
  10204d:	5f                   	pop    %edi
  10204e:	5d                   	pop    %ebp
  10204f:	c3                   	ret    

00102050 <trap>:
 * trap - handles or dispatches an exception/interrupt. if and when trap() returns,
 * the code in kern/trap/trapentry.S restores the old CPU state saved in the
 * trapframe and then uses the iret instruction to return from the exception.
 * */
void
trap(struct trapframe *tf) {
  102050:	f3 0f 1e fb          	endbr32 
  102054:	55                   	push   %ebp
  102055:	89 e5                	mov    %esp,%ebp
  102057:	83 ec 18             	sub    $0x18,%esp
    // dispatch based on what type of trap occurred
    trap_dispatch(tf);
  10205a:	8b 45 08             	mov    0x8(%ebp),%eax
  10205d:	89 04 24             	mov    %eax,(%esp)
  102060:	e8 21 fd ff ff       	call   101d86 <trap_dispatch>
}
  102065:	90                   	nop
  102066:	c9                   	leave  
  102067:	c3                   	ret    

00102068 <switch_to_user>:

void
switch_to_user(void) {
  102068:	f3 0f 1e fb          	endbr32 
  10206c:	55                   	push   %ebp
  10206d:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 : TODO
    asm volatile (
  10206f:	83 ec 08             	sub    $0x8,%esp
  102072:	cd 78                	int    $0x78
  102074:	89 ec                	mov    %ebp,%esp
	    "int %0 \n"
	    "movl %%ebp, %%esp"
	    : 
	    : "i"(T_SWITCH_TOU)
	);
}
  102076:	90                   	nop
  102077:	5d                   	pop    %ebp
  102078:	c3                   	ret    

00102079 <switch_to_kernel>:

void
switch_to_kernel(void) {
  102079:	f3 0f 1e fb          	endbr32 
  10207d:	55                   	push   %ebp
  10207e:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 :  TODO
    asm volatile (
  102080:	cd 79                	int    $0x79
  102082:	89 ec                	mov    %ebp,%esp
	    "int %0 \n"
	    "movl %%ebp, %%esp \n"
	    : 
	    : "i"(T_SWITCH_TOK)
	);
}
  102084:	90                   	nop
  102085:	5d                   	pop    %ebp
  102086:	c3                   	ret    

00102087 <vector0>:
# handler
.text
.globl __alltraps
.globl vector0
vector0:
  pushl $0
  102087:	6a 00                	push   $0x0
  pushl $0
  102089:	6a 00                	push   $0x0
  jmp __alltraps
  10208b:	e9 69 0a 00 00       	jmp    102af9 <__alltraps>

00102090 <vector1>:
.globl vector1
vector1:
  pushl $0
  102090:	6a 00                	push   $0x0
  pushl $1
  102092:	6a 01                	push   $0x1
  jmp __alltraps
  102094:	e9 60 0a 00 00       	jmp    102af9 <__alltraps>

00102099 <vector2>:
.globl vector2
vector2:
  pushl $0
  102099:	6a 00                	push   $0x0
  pushl $2
  10209b:	6a 02                	push   $0x2
  jmp __alltraps
  10209d:	e9 57 0a 00 00       	jmp    102af9 <__alltraps>

001020a2 <vector3>:
.globl vector3
vector3:
  pushl $0
  1020a2:	6a 00                	push   $0x0
  pushl $3
  1020a4:	6a 03                	push   $0x3
  jmp __alltraps
  1020a6:	e9 4e 0a 00 00       	jmp    102af9 <__alltraps>

001020ab <vector4>:
.globl vector4
vector4:
  pushl $0
  1020ab:	6a 00                	push   $0x0
  pushl $4
  1020ad:	6a 04                	push   $0x4
  jmp __alltraps
  1020af:	e9 45 0a 00 00       	jmp    102af9 <__alltraps>

001020b4 <vector5>:
.globl vector5
vector5:
  pushl $0
  1020b4:	6a 00                	push   $0x0
  pushl $5
  1020b6:	6a 05                	push   $0x5
  jmp __alltraps
  1020b8:	e9 3c 0a 00 00       	jmp    102af9 <__alltraps>

001020bd <vector6>:
.globl vector6
vector6:
  pushl $0
  1020bd:	6a 00                	push   $0x0
  pushl $6
  1020bf:	6a 06                	push   $0x6
  jmp __alltraps
  1020c1:	e9 33 0a 00 00       	jmp    102af9 <__alltraps>

001020c6 <vector7>:
.globl vector7
vector7:
  pushl $0
  1020c6:	6a 00                	push   $0x0
  pushl $7
  1020c8:	6a 07                	push   $0x7
  jmp __alltraps
  1020ca:	e9 2a 0a 00 00       	jmp    102af9 <__alltraps>

001020cf <vector8>:
.globl vector8
vector8:
  pushl $8
  1020cf:	6a 08                	push   $0x8
  jmp __alltraps
  1020d1:	e9 23 0a 00 00       	jmp    102af9 <__alltraps>

001020d6 <vector9>:
.globl vector9
vector9:
  pushl $0
  1020d6:	6a 00                	push   $0x0
  pushl $9
  1020d8:	6a 09                	push   $0x9
  jmp __alltraps
  1020da:	e9 1a 0a 00 00       	jmp    102af9 <__alltraps>

001020df <vector10>:
.globl vector10
vector10:
  pushl $10
  1020df:	6a 0a                	push   $0xa
  jmp __alltraps
  1020e1:	e9 13 0a 00 00       	jmp    102af9 <__alltraps>

001020e6 <vector11>:
.globl vector11
vector11:
  pushl $11
  1020e6:	6a 0b                	push   $0xb
  jmp __alltraps
  1020e8:	e9 0c 0a 00 00       	jmp    102af9 <__alltraps>

001020ed <vector12>:
.globl vector12
vector12:
  pushl $12
  1020ed:	6a 0c                	push   $0xc
  jmp __alltraps
  1020ef:	e9 05 0a 00 00       	jmp    102af9 <__alltraps>

001020f4 <vector13>:
.globl vector13
vector13:
  pushl $13
  1020f4:	6a 0d                	push   $0xd
  jmp __alltraps
  1020f6:	e9 fe 09 00 00       	jmp    102af9 <__alltraps>

001020fb <vector14>:
.globl vector14
vector14:
  pushl $14
  1020fb:	6a 0e                	push   $0xe
  jmp __alltraps
  1020fd:	e9 f7 09 00 00       	jmp    102af9 <__alltraps>

00102102 <vector15>:
.globl vector15
vector15:
  pushl $0
  102102:	6a 00                	push   $0x0
  pushl $15
  102104:	6a 0f                	push   $0xf
  jmp __alltraps
  102106:	e9 ee 09 00 00       	jmp    102af9 <__alltraps>

0010210b <vector16>:
.globl vector16
vector16:
  pushl $0
  10210b:	6a 00                	push   $0x0
  pushl $16
  10210d:	6a 10                	push   $0x10
  jmp __alltraps
  10210f:	e9 e5 09 00 00       	jmp    102af9 <__alltraps>

00102114 <vector17>:
.globl vector17
vector17:
  pushl $17
  102114:	6a 11                	push   $0x11
  jmp __alltraps
  102116:	e9 de 09 00 00       	jmp    102af9 <__alltraps>

0010211b <vector18>:
.globl vector18
vector18:
  pushl $0
  10211b:	6a 00                	push   $0x0
  pushl $18
  10211d:	6a 12                	push   $0x12
  jmp __alltraps
  10211f:	e9 d5 09 00 00       	jmp    102af9 <__alltraps>

00102124 <vector19>:
.globl vector19
vector19:
  pushl $0
  102124:	6a 00                	push   $0x0
  pushl $19
  102126:	6a 13                	push   $0x13
  jmp __alltraps
  102128:	e9 cc 09 00 00       	jmp    102af9 <__alltraps>

0010212d <vector20>:
.globl vector20
vector20:
  pushl $0
  10212d:	6a 00                	push   $0x0
  pushl $20
  10212f:	6a 14                	push   $0x14
  jmp __alltraps
  102131:	e9 c3 09 00 00       	jmp    102af9 <__alltraps>

00102136 <vector21>:
.globl vector21
vector21:
  pushl $0
  102136:	6a 00                	push   $0x0
  pushl $21
  102138:	6a 15                	push   $0x15
  jmp __alltraps
  10213a:	e9 ba 09 00 00       	jmp    102af9 <__alltraps>

0010213f <vector22>:
.globl vector22
vector22:
  pushl $0
  10213f:	6a 00                	push   $0x0
  pushl $22
  102141:	6a 16                	push   $0x16
  jmp __alltraps
  102143:	e9 b1 09 00 00       	jmp    102af9 <__alltraps>

00102148 <vector23>:
.globl vector23
vector23:
  pushl $0
  102148:	6a 00                	push   $0x0
  pushl $23
  10214a:	6a 17                	push   $0x17
  jmp __alltraps
  10214c:	e9 a8 09 00 00       	jmp    102af9 <__alltraps>

00102151 <vector24>:
.globl vector24
vector24:
  pushl $0
  102151:	6a 00                	push   $0x0
  pushl $24
  102153:	6a 18                	push   $0x18
  jmp __alltraps
  102155:	e9 9f 09 00 00       	jmp    102af9 <__alltraps>

0010215a <vector25>:
.globl vector25
vector25:
  pushl $0
  10215a:	6a 00                	push   $0x0
  pushl $25
  10215c:	6a 19                	push   $0x19
  jmp __alltraps
  10215e:	e9 96 09 00 00       	jmp    102af9 <__alltraps>

00102163 <vector26>:
.globl vector26
vector26:
  pushl $0
  102163:	6a 00                	push   $0x0
  pushl $26
  102165:	6a 1a                	push   $0x1a
  jmp __alltraps
  102167:	e9 8d 09 00 00       	jmp    102af9 <__alltraps>

0010216c <vector27>:
.globl vector27
vector27:
  pushl $0
  10216c:	6a 00                	push   $0x0
  pushl $27
  10216e:	6a 1b                	push   $0x1b
  jmp __alltraps
  102170:	e9 84 09 00 00       	jmp    102af9 <__alltraps>

00102175 <vector28>:
.globl vector28
vector28:
  pushl $0
  102175:	6a 00                	push   $0x0
  pushl $28
  102177:	6a 1c                	push   $0x1c
  jmp __alltraps
  102179:	e9 7b 09 00 00       	jmp    102af9 <__alltraps>

0010217e <vector29>:
.globl vector29
vector29:
  pushl $0
  10217e:	6a 00                	push   $0x0
  pushl $29
  102180:	6a 1d                	push   $0x1d
  jmp __alltraps
  102182:	e9 72 09 00 00       	jmp    102af9 <__alltraps>

00102187 <vector30>:
.globl vector30
vector30:
  pushl $0
  102187:	6a 00                	push   $0x0
  pushl $30
  102189:	6a 1e                	push   $0x1e
  jmp __alltraps
  10218b:	e9 69 09 00 00       	jmp    102af9 <__alltraps>

00102190 <vector31>:
.globl vector31
vector31:
  pushl $0
  102190:	6a 00                	push   $0x0
  pushl $31
  102192:	6a 1f                	push   $0x1f
  jmp __alltraps
  102194:	e9 60 09 00 00       	jmp    102af9 <__alltraps>

00102199 <vector32>:
.globl vector32
vector32:
  pushl $0
  102199:	6a 00                	push   $0x0
  pushl $32
  10219b:	6a 20                	push   $0x20
  jmp __alltraps
  10219d:	e9 57 09 00 00       	jmp    102af9 <__alltraps>

001021a2 <vector33>:
.globl vector33
vector33:
  pushl $0
  1021a2:	6a 00                	push   $0x0
  pushl $33
  1021a4:	6a 21                	push   $0x21
  jmp __alltraps
  1021a6:	e9 4e 09 00 00       	jmp    102af9 <__alltraps>

001021ab <vector34>:
.globl vector34
vector34:
  pushl $0
  1021ab:	6a 00                	push   $0x0
  pushl $34
  1021ad:	6a 22                	push   $0x22
  jmp __alltraps
  1021af:	e9 45 09 00 00       	jmp    102af9 <__alltraps>

001021b4 <vector35>:
.globl vector35
vector35:
  pushl $0
  1021b4:	6a 00                	push   $0x0
  pushl $35
  1021b6:	6a 23                	push   $0x23
  jmp __alltraps
  1021b8:	e9 3c 09 00 00       	jmp    102af9 <__alltraps>

001021bd <vector36>:
.globl vector36
vector36:
  pushl $0
  1021bd:	6a 00                	push   $0x0
  pushl $36
  1021bf:	6a 24                	push   $0x24
  jmp __alltraps
  1021c1:	e9 33 09 00 00       	jmp    102af9 <__alltraps>

001021c6 <vector37>:
.globl vector37
vector37:
  pushl $0
  1021c6:	6a 00                	push   $0x0
  pushl $37
  1021c8:	6a 25                	push   $0x25
  jmp __alltraps
  1021ca:	e9 2a 09 00 00       	jmp    102af9 <__alltraps>

001021cf <vector38>:
.globl vector38
vector38:
  pushl $0
  1021cf:	6a 00                	push   $0x0
  pushl $38
  1021d1:	6a 26                	push   $0x26
  jmp __alltraps
  1021d3:	e9 21 09 00 00       	jmp    102af9 <__alltraps>

001021d8 <vector39>:
.globl vector39
vector39:
  pushl $0
  1021d8:	6a 00                	push   $0x0
  pushl $39
  1021da:	6a 27                	push   $0x27
  jmp __alltraps
  1021dc:	e9 18 09 00 00       	jmp    102af9 <__alltraps>

001021e1 <vector40>:
.globl vector40
vector40:
  pushl $0
  1021e1:	6a 00                	push   $0x0
  pushl $40
  1021e3:	6a 28                	push   $0x28
  jmp __alltraps
  1021e5:	e9 0f 09 00 00       	jmp    102af9 <__alltraps>

001021ea <vector41>:
.globl vector41
vector41:
  pushl $0
  1021ea:	6a 00                	push   $0x0
  pushl $41
  1021ec:	6a 29                	push   $0x29
  jmp __alltraps
  1021ee:	e9 06 09 00 00       	jmp    102af9 <__alltraps>

001021f3 <vector42>:
.globl vector42
vector42:
  pushl $0
  1021f3:	6a 00                	push   $0x0
  pushl $42
  1021f5:	6a 2a                	push   $0x2a
  jmp __alltraps
  1021f7:	e9 fd 08 00 00       	jmp    102af9 <__alltraps>

001021fc <vector43>:
.globl vector43
vector43:
  pushl $0
  1021fc:	6a 00                	push   $0x0
  pushl $43
  1021fe:	6a 2b                	push   $0x2b
  jmp __alltraps
  102200:	e9 f4 08 00 00       	jmp    102af9 <__alltraps>

00102205 <vector44>:
.globl vector44
vector44:
  pushl $0
  102205:	6a 00                	push   $0x0
  pushl $44
  102207:	6a 2c                	push   $0x2c
  jmp __alltraps
  102209:	e9 eb 08 00 00       	jmp    102af9 <__alltraps>

0010220e <vector45>:
.globl vector45
vector45:
  pushl $0
  10220e:	6a 00                	push   $0x0
  pushl $45
  102210:	6a 2d                	push   $0x2d
  jmp __alltraps
  102212:	e9 e2 08 00 00       	jmp    102af9 <__alltraps>

00102217 <vector46>:
.globl vector46
vector46:
  pushl $0
  102217:	6a 00                	push   $0x0
  pushl $46
  102219:	6a 2e                	push   $0x2e
  jmp __alltraps
  10221b:	e9 d9 08 00 00       	jmp    102af9 <__alltraps>

00102220 <vector47>:
.globl vector47
vector47:
  pushl $0
  102220:	6a 00                	push   $0x0
  pushl $47
  102222:	6a 2f                	push   $0x2f
  jmp __alltraps
  102224:	e9 d0 08 00 00       	jmp    102af9 <__alltraps>

00102229 <vector48>:
.globl vector48
vector48:
  pushl $0
  102229:	6a 00                	push   $0x0
  pushl $48
  10222b:	6a 30                	push   $0x30
  jmp __alltraps
  10222d:	e9 c7 08 00 00       	jmp    102af9 <__alltraps>

00102232 <vector49>:
.globl vector49
vector49:
  pushl $0
  102232:	6a 00                	push   $0x0
  pushl $49
  102234:	6a 31                	push   $0x31
  jmp __alltraps
  102236:	e9 be 08 00 00       	jmp    102af9 <__alltraps>

0010223b <vector50>:
.globl vector50
vector50:
  pushl $0
  10223b:	6a 00                	push   $0x0
  pushl $50
  10223d:	6a 32                	push   $0x32
  jmp __alltraps
  10223f:	e9 b5 08 00 00       	jmp    102af9 <__alltraps>

00102244 <vector51>:
.globl vector51
vector51:
  pushl $0
  102244:	6a 00                	push   $0x0
  pushl $51
  102246:	6a 33                	push   $0x33
  jmp __alltraps
  102248:	e9 ac 08 00 00       	jmp    102af9 <__alltraps>

0010224d <vector52>:
.globl vector52
vector52:
  pushl $0
  10224d:	6a 00                	push   $0x0
  pushl $52
  10224f:	6a 34                	push   $0x34
  jmp __alltraps
  102251:	e9 a3 08 00 00       	jmp    102af9 <__alltraps>

00102256 <vector53>:
.globl vector53
vector53:
  pushl $0
  102256:	6a 00                	push   $0x0
  pushl $53
  102258:	6a 35                	push   $0x35
  jmp __alltraps
  10225a:	e9 9a 08 00 00       	jmp    102af9 <__alltraps>

0010225f <vector54>:
.globl vector54
vector54:
  pushl $0
  10225f:	6a 00                	push   $0x0
  pushl $54
  102261:	6a 36                	push   $0x36
  jmp __alltraps
  102263:	e9 91 08 00 00       	jmp    102af9 <__alltraps>

00102268 <vector55>:
.globl vector55
vector55:
  pushl $0
  102268:	6a 00                	push   $0x0
  pushl $55
  10226a:	6a 37                	push   $0x37
  jmp __alltraps
  10226c:	e9 88 08 00 00       	jmp    102af9 <__alltraps>

00102271 <vector56>:
.globl vector56
vector56:
  pushl $0
  102271:	6a 00                	push   $0x0
  pushl $56
  102273:	6a 38                	push   $0x38
  jmp __alltraps
  102275:	e9 7f 08 00 00       	jmp    102af9 <__alltraps>

0010227a <vector57>:
.globl vector57
vector57:
  pushl $0
  10227a:	6a 00                	push   $0x0
  pushl $57
  10227c:	6a 39                	push   $0x39
  jmp __alltraps
  10227e:	e9 76 08 00 00       	jmp    102af9 <__alltraps>

00102283 <vector58>:
.globl vector58
vector58:
  pushl $0
  102283:	6a 00                	push   $0x0
  pushl $58
  102285:	6a 3a                	push   $0x3a
  jmp __alltraps
  102287:	e9 6d 08 00 00       	jmp    102af9 <__alltraps>

0010228c <vector59>:
.globl vector59
vector59:
  pushl $0
  10228c:	6a 00                	push   $0x0
  pushl $59
  10228e:	6a 3b                	push   $0x3b
  jmp __alltraps
  102290:	e9 64 08 00 00       	jmp    102af9 <__alltraps>

00102295 <vector60>:
.globl vector60
vector60:
  pushl $0
  102295:	6a 00                	push   $0x0
  pushl $60
  102297:	6a 3c                	push   $0x3c
  jmp __alltraps
  102299:	e9 5b 08 00 00       	jmp    102af9 <__alltraps>

0010229e <vector61>:
.globl vector61
vector61:
  pushl $0
  10229e:	6a 00                	push   $0x0
  pushl $61
  1022a0:	6a 3d                	push   $0x3d
  jmp __alltraps
  1022a2:	e9 52 08 00 00       	jmp    102af9 <__alltraps>

001022a7 <vector62>:
.globl vector62
vector62:
  pushl $0
  1022a7:	6a 00                	push   $0x0
  pushl $62
  1022a9:	6a 3e                	push   $0x3e
  jmp __alltraps
  1022ab:	e9 49 08 00 00       	jmp    102af9 <__alltraps>

001022b0 <vector63>:
.globl vector63
vector63:
  pushl $0
  1022b0:	6a 00                	push   $0x0
  pushl $63
  1022b2:	6a 3f                	push   $0x3f
  jmp __alltraps
  1022b4:	e9 40 08 00 00       	jmp    102af9 <__alltraps>

001022b9 <vector64>:
.globl vector64
vector64:
  pushl $0
  1022b9:	6a 00                	push   $0x0
  pushl $64
  1022bb:	6a 40                	push   $0x40
  jmp __alltraps
  1022bd:	e9 37 08 00 00       	jmp    102af9 <__alltraps>

001022c2 <vector65>:
.globl vector65
vector65:
  pushl $0
  1022c2:	6a 00                	push   $0x0
  pushl $65
  1022c4:	6a 41                	push   $0x41
  jmp __alltraps
  1022c6:	e9 2e 08 00 00       	jmp    102af9 <__alltraps>

001022cb <vector66>:
.globl vector66
vector66:
  pushl $0
  1022cb:	6a 00                	push   $0x0
  pushl $66
  1022cd:	6a 42                	push   $0x42
  jmp __alltraps
  1022cf:	e9 25 08 00 00       	jmp    102af9 <__alltraps>

001022d4 <vector67>:
.globl vector67
vector67:
  pushl $0
  1022d4:	6a 00                	push   $0x0
  pushl $67
  1022d6:	6a 43                	push   $0x43
  jmp __alltraps
  1022d8:	e9 1c 08 00 00       	jmp    102af9 <__alltraps>

001022dd <vector68>:
.globl vector68
vector68:
  pushl $0
  1022dd:	6a 00                	push   $0x0
  pushl $68
  1022df:	6a 44                	push   $0x44
  jmp __alltraps
  1022e1:	e9 13 08 00 00       	jmp    102af9 <__alltraps>

001022e6 <vector69>:
.globl vector69
vector69:
  pushl $0
  1022e6:	6a 00                	push   $0x0
  pushl $69
  1022e8:	6a 45                	push   $0x45
  jmp __alltraps
  1022ea:	e9 0a 08 00 00       	jmp    102af9 <__alltraps>

001022ef <vector70>:
.globl vector70
vector70:
  pushl $0
  1022ef:	6a 00                	push   $0x0
  pushl $70
  1022f1:	6a 46                	push   $0x46
  jmp __alltraps
  1022f3:	e9 01 08 00 00       	jmp    102af9 <__alltraps>

001022f8 <vector71>:
.globl vector71
vector71:
  pushl $0
  1022f8:	6a 00                	push   $0x0
  pushl $71
  1022fa:	6a 47                	push   $0x47
  jmp __alltraps
  1022fc:	e9 f8 07 00 00       	jmp    102af9 <__alltraps>

00102301 <vector72>:
.globl vector72
vector72:
  pushl $0
  102301:	6a 00                	push   $0x0
  pushl $72
  102303:	6a 48                	push   $0x48
  jmp __alltraps
  102305:	e9 ef 07 00 00       	jmp    102af9 <__alltraps>

0010230a <vector73>:
.globl vector73
vector73:
  pushl $0
  10230a:	6a 00                	push   $0x0
  pushl $73
  10230c:	6a 49                	push   $0x49
  jmp __alltraps
  10230e:	e9 e6 07 00 00       	jmp    102af9 <__alltraps>

00102313 <vector74>:
.globl vector74
vector74:
  pushl $0
  102313:	6a 00                	push   $0x0
  pushl $74
  102315:	6a 4a                	push   $0x4a
  jmp __alltraps
  102317:	e9 dd 07 00 00       	jmp    102af9 <__alltraps>

0010231c <vector75>:
.globl vector75
vector75:
  pushl $0
  10231c:	6a 00                	push   $0x0
  pushl $75
  10231e:	6a 4b                	push   $0x4b
  jmp __alltraps
  102320:	e9 d4 07 00 00       	jmp    102af9 <__alltraps>

00102325 <vector76>:
.globl vector76
vector76:
  pushl $0
  102325:	6a 00                	push   $0x0
  pushl $76
  102327:	6a 4c                	push   $0x4c
  jmp __alltraps
  102329:	e9 cb 07 00 00       	jmp    102af9 <__alltraps>

0010232e <vector77>:
.globl vector77
vector77:
  pushl $0
  10232e:	6a 00                	push   $0x0
  pushl $77
  102330:	6a 4d                	push   $0x4d
  jmp __alltraps
  102332:	e9 c2 07 00 00       	jmp    102af9 <__alltraps>

00102337 <vector78>:
.globl vector78
vector78:
  pushl $0
  102337:	6a 00                	push   $0x0
  pushl $78
  102339:	6a 4e                	push   $0x4e
  jmp __alltraps
  10233b:	e9 b9 07 00 00       	jmp    102af9 <__alltraps>

00102340 <vector79>:
.globl vector79
vector79:
  pushl $0
  102340:	6a 00                	push   $0x0
  pushl $79
  102342:	6a 4f                	push   $0x4f
  jmp __alltraps
  102344:	e9 b0 07 00 00       	jmp    102af9 <__alltraps>

00102349 <vector80>:
.globl vector80
vector80:
  pushl $0
  102349:	6a 00                	push   $0x0
  pushl $80
  10234b:	6a 50                	push   $0x50
  jmp __alltraps
  10234d:	e9 a7 07 00 00       	jmp    102af9 <__alltraps>

00102352 <vector81>:
.globl vector81
vector81:
  pushl $0
  102352:	6a 00                	push   $0x0
  pushl $81
  102354:	6a 51                	push   $0x51
  jmp __alltraps
  102356:	e9 9e 07 00 00       	jmp    102af9 <__alltraps>

0010235b <vector82>:
.globl vector82
vector82:
  pushl $0
  10235b:	6a 00                	push   $0x0
  pushl $82
  10235d:	6a 52                	push   $0x52
  jmp __alltraps
  10235f:	e9 95 07 00 00       	jmp    102af9 <__alltraps>

00102364 <vector83>:
.globl vector83
vector83:
  pushl $0
  102364:	6a 00                	push   $0x0
  pushl $83
  102366:	6a 53                	push   $0x53
  jmp __alltraps
  102368:	e9 8c 07 00 00       	jmp    102af9 <__alltraps>

0010236d <vector84>:
.globl vector84
vector84:
  pushl $0
  10236d:	6a 00                	push   $0x0
  pushl $84
  10236f:	6a 54                	push   $0x54
  jmp __alltraps
  102371:	e9 83 07 00 00       	jmp    102af9 <__alltraps>

00102376 <vector85>:
.globl vector85
vector85:
  pushl $0
  102376:	6a 00                	push   $0x0
  pushl $85
  102378:	6a 55                	push   $0x55
  jmp __alltraps
  10237a:	e9 7a 07 00 00       	jmp    102af9 <__alltraps>

0010237f <vector86>:
.globl vector86
vector86:
  pushl $0
  10237f:	6a 00                	push   $0x0
  pushl $86
  102381:	6a 56                	push   $0x56
  jmp __alltraps
  102383:	e9 71 07 00 00       	jmp    102af9 <__alltraps>

00102388 <vector87>:
.globl vector87
vector87:
  pushl $0
  102388:	6a 00                	push   $0x0
  pushl $87
  10238a:	6a 57                	push   $0x57
  jmp __alltraps
  10238c:	e9 68 07 00 00       	jmp    102af9 <__alltraps>

00102391 <vector88>:
.globl vector88
vector88:
  pushl $0
  102391:	6a 00                	push   $0x0
  pushl $88
  102393:	6a 58                	push   $0x58
  jmp __alltraps
  102395:	e9 5f 07 00 00       	jmp    102af9 <__alltraps>

0010239a <vector89>:
.globl vector89
vector89:
  pushl $0
  10239a:	6a 00                	push   $0x0
  pushl $89
  10239c:	6a 59                	push   $0x59
  jmp __alltraps
  10239e:	e9 56 07 00 00       	jmp    102af9 <__alltraps>

001023a3 <vector90>:
.globl vector90
vector90:
  pushl $0
  1023a3:	6a 00                	push   $0x0
  pushl $90
  1023a5:	6a 5a                	push   $0x5a
  jmp __alltraps
  1023a7:	e9 4d 07 00 00       	jmp    102af9 <__alltraps>

001023ac <vector91>:
.globl vector91
vector91:
  pushl $0
  1023ac:	6a 00                	push   $0x0
  pushl $91
  1023ae:	6a 5b                	push   $0x5b
  jmp __alltraps
  1023b0:	e9 44 07 00 00       	jmp    102af9 <__alltraps>

001023b5 <vector92>:
.globl vector92
vector92:
  pushl $0
  1023b5:	6a 00                	push   $0x0
  pushl $92
  1023b7:	6a 5c                	push   $0x5c
  jmp __alltraps
  1023b9:	e9 3b 07 00 00       	jmp    102af9 <__alltraps>

001023be <vector93>:
.globl vector93
vector93:
  pushl $0
  1023be:	6a 00                	push   $0x0
  pushl $93
  1023c0:	6a 5d                	push   $0x5d
  jmp __alltraps
  1023c2:	e9 32 07 00 00       	jmp    102af9 <__alltraps>

001023c7 <vector94>:
.globl vector94
vector94:
  pushl $0
  1023c7:	6a 00                	push   $0x0
  pushl $94
  1023c9:	6a 5e                	push   $0x5e
  jmp __alltraps
  1023cb:	e9 29 07 00 00       	jmp    102af9 <__alltraps>

001023d0 <vector95>:
.globl vector95
vector95:
  pushl $0
  1023d0:	6a 00                	push   $0x0
  pushl $95
  1023d2:	6a 5f                	push   $0x5f
  jmp __alltraps
  1023d4:	e9 20 07 00 00       	jmp    102af9 <__alltraps>

001023d9 <vector96>:
.globl vector96
vector96:
  pushl $0
  1023d9:	6a 00                	push   $0x0
  pushl $96
  1023db:	6a 60                	push   $0x60
  jmp __alltraps
  1023dd:	e9 17 07 00 00       	jmp    102af9 <__alltraps>

001023e2 <vector97>:
.globl vector97
vector97:
  pushl $0
  1023e2:	6a 00                	push   $0x0
  pushl $97
  1023e4:	6a 61                	push   $0x61
  jmp __alltraps
  1023e6:	e9 0e 07 00 00       	jmp    102af9 <__alltraps>

001023eb <vector98>:
.globl vector98
vector98:
  pushl $0
  1023eb:	6a 00                	push   $0x0
  pushl $98
  1023ed:	6a 62                	push   $0x62
  jmp __alltraps
  1023ef:	e9 05 07 00 00       	jmp    102af9 <__alltraps>

001023f4 <vector99>:
.globl vector99
vector99:
  pushl $0
  1023f4:	6a 00                	push   $0x0
  pushl $99
  1023f6:	6a 63                	push   $0x63
  jmp __alltraps
  1023f8:	e9 fc 06 00 00       	jmp    102af9 <__alltraps>

001023fd <vector100>:
.globl vector100
vector100:
  pushl $0
  1023fd:	6a 00                	push   $0x0
  pushl $100
  1023ff:	6a 64                	push   $0x64
  jmp __alltraps
  102401:	e9 f3 06 00 00       	jmp    102af9 <__alltraps>

00102406 <vector101>:
.globl vector101
vector101:
  pushl $0
  102406:	6a 00                	push   $0x0
  pushl $101
  102408:	6a 65                	push   $0x65
  jmp __alltraps
  10240a:	e9 ea 06 00 00       	jmp    102af9 <__alltraps>

0010240f <vector102>:
.globl vector102
vector102:
  pushl $0
  10240f:	6a 00                	push   $0x0
  pushl $102
  102411:	6a 66                	push   $0x66
  jmp __alltraps
  102413:	e9 e1 06 00 00       	jmp    102af9 <__alltraps>

00102418 <vector103>:
.globl vector103
vector103:
  pushl $0
  102418:	6a 00                	push   $0x0
  pushl $103
  10241a:	6a 67                	push   $0x67
  jmp __alltraps
  10241c:	e9 d8 06 00 00       	jmp    102af9 <__alltraps>

00102421 <vector104>:
.globl vector104
vector104:
  pushl $0
  102421:	6a 00                	push   $0x0
  pushl $104
  102423:	6a 68                	push   $0x68
  jmp __alltraps
  102425:	e9 cf 06 00 00       	jmp    102af9 <__alltraps>

0010242a <vector105>:
.globl vector105
vector105:
  pushl $0
  10242a:	6a 00                	push   $0x0
  pushl $105
  10242c:	6a 69                	push   $0x69
  jmp __alltraps
  10242e:	e9 c6 06 00 00       	jmp    102af9 <__alltraps>

00102433 <vector106>:
.globl vector106
vector106:
  pushl $0
  102433:	6a 00                	push   $0x0
  pushl $106
  102435:	6a 6a                	push   $0x6a
  jmp __alltraps
  102437:	e9 bd 06 00 00       	jmp    102af9 <__alltraps>

0010243c <vector107>:
.globl vector107
vector107:
  pushl $0
  10243c:	6a 00                	push   $0x0
  pushl $107
  10243e:	6a 6b                	push   $0x6b
  jmp __alltraps
  102440:	e9 b4 06 00 00       	jmp    102af9 <__alltraps>

00102445 <vector108>:
.globl vector108
vector108:
  pushl $0
  102445:	6a 00                	push   $0x0
  pushl $108
  102447:	6a 6c                	push   $0x6c
  jmp __alltraps
  102449:	e9 ab 06 00 00       	jmp    102af9 <__alltraps>

0010244e <vector109>:
.globl vector109
vector109:
  pushl $0
  10244e:	6a 00                	push   $0x0
  pushl $109
  102450:	6a 6d                	push   $0x6d
  jmp __alltraps
  102452:	e9 a2 06 00 00       	jmp    102af9 <__alltraps>

00102457 <vector110>:
.globl vector110
vector110:
  pushl $0
  102457:	6a 00                	push   $0x0
  pushl $110
  102459:	6a 6e                	push   $0x6e
  jmp __alltraps
  10245b:	e9 99 06 00 00       	jmp    102af9 <__alltraps>

00102460 <vector111>:
.globl vector111
vector111:
  pushl $0
  102460:	6a 00                	push   $0x0
  pushl $111
  102462:	6a 6f                	push   $0x6f
  jmp __alltraps
  102464:	e9 90 06 00 00       	jmp    102af9 <__alltraps>

00102469 <vector112>:
.globl vector112
vector112:
  pushl $0
  102469:	6a 00                	push   $0x0
  pushl $112
  10246b:	6a 70                	push   $0x70
  jmp __alltraps
  10246d:	e9 87 06 00 00       	jmp    102af9 <__alltraps>

00102472 <vector113>:
.globl vector113
vector113:
  pushl $0
  102472:	6a 00                	push   $0x0
  pushl $113
  102474:	6a 71                	push   $0x71
  jmp __alltraps
  102476:	e9 7e 06 00 00       	jmp    102af9 <__alltraps>

0010247b <vector114>:
.globl vector114
vector114:
  pushl $0
  10247b:	6a 00                	push   $0x0
  pushl $114
  10247d:	6a 72                	push   $0x72
  jmp __alltraps
  10247f:	e9 75 06 00 00       	jmp    102af9 <__alltraps>

00102484 <vector115>:
.globl vector115
vector115:
  pushl $0
  102484:	6a 00                	push   $0x0
  pushl $115
  102486:	6a 73                	push   $0x73
  jmp __alltraps
  102488:	e9 6c 06 00 00       	jmp    102af9 <__alltraps>

0010248d <vector116>:
.globl vector116
vector116:
  pushl $0
  10248d:	6a 00                	push   $0x0
  pushl $116
  10248f:	6a 74                	push   $0x74
  jmp __alltraps
  102491:	e9 63 06 00 00       	jmp    102af9 <__alltraps>

00102496 <vector117>:
.globl vector117
vector117:
  pushl $0
  102496:	6a 00                	push   $0x0
  pushl $117
  102498:	6a 75                	push   $0x75
  jmp __alltraps
  10249a:	e9 5a 06 00 00       	jmp    102af9 <__alltraps>

0010249f <vector118>:
.globl vector118
vector118:
  pushl $0
  10249f:	6a 00                	push   $0x0
  pushl $118
  1024a1:	6a 76                	push   $0x76
  jmp __alltraps
  1024a3:	e9 51 06 00 00       	jmp    102af9 <__alltraps>

001024a8 <vector119>:
.globl vector119
vector119:
  pushl $0
  1024a8:	6a 00                	push   $0x0
  pushl $119
  1024aa:	6a 77                	push   $0x77
  jmp __alltraps
  1024ac:	e9 48 06 00 00       	jmp    102af9 <__alltraps>

001024b1 <vector120>:
.globl vector120
vector120:
  pushl $0
  1024b1:	6a 00                	push   $0x0
  pushl $120
  1024b3:	6a 78                	push   $0x78
  jmp __alltraps
  1024b5:	e9 3f 06 00 00       	jmp    102af9 <__alltraps>

001024ba <vector121>:
.globl vector121
vector121:
  pushl $0
  1024ba:	6a 00                	push   $0x0
  pushl $121
  1024bc:	6a 79                	push   $0x79
  jmp __alltraps
  1024be:	e9 36 06 00 00       	jmp    102af9 <__alltraps>

001024c3 <vector122>:
.globl vector122
vector122:
  pushl $0
  1024c3:	6a 00                	push   $0x0
  pushl $122
  1024c5:	6a 7a                	push   $0x7a
  jmp __alltraps
  1024c7:	e9 2d 06 00 00       	jmp    102af9 <__alltraps>

001024cc <vector123>:
.globl vector123
vector123:
  pushl $0
  1024cc:	6a 00                	push   $0x0
  pushl $123
  1024ce:	6a 7b                	push   $0x7b
  jmp __alltraps
  1024d0:	e9 24 06 00 00       	jmp    102af9 <__alltraps>

001024d5 <vector124>:
.globl vector124
vector124:
  pushl $0
  1024d5:	6a 00                	push   $0x0
  pushl $124
  1024d7:	6a 7c                	push   $0x7c
  jmp __alltraps
  1024d9:	e9 1b 06 00 00       	jmp    102af9 <__alltraps>

001024de <vector125>:
.globl vector125
vector125:
  pushl $0
  1024de:	6a 00                	push   $0x0
  pushl $125
  1024e0:	6a 7d                	push   $0x7d
  jmp __alltraps
  1024e2:	e9 12 06 00 00       	jmp    102af9 <__alltraps>

001024e7 <vector126>:
.globl vector126
vector126:
  pushl $0
  1024e7:	6a 00                	push   $0x0
  pushl $126
  1024e9:	6a 7e                	push   $0x7e
  jmp __alltraps
  1024eb:	e9 09 06 00 00       	jmp    102af9 <__alltraps>

001024f0 <vector127>:
.globl vector127
vector127:
  pushl $0
  1024f0:	6a 00                	push   $0x0
  pushl $127
  1024f2:	6a 7f                	push   $0x7f
  jmp __alltraps
  1024f4:	e9 00 06 00 00       	jmp    102af9 <__alltraps>

001024f9 <vector128>:
.globl vector128
vector128:
  pushl $0
  1024f9:	6a 00                	push   $0x0
  pushl $128
  1024fb:	68 80 00 00 00       	push   $0x80
  jmp __alltraps
  102500:	e9 f4 05 00 00       	jmp    102af9 <__alltraps>

00102505 <vector129>:
.globl vector129
vector129:
  pushl $0
  102505:	6a 00                	push   $0x0
  pushl $129
  102507:	68 81 00 00 00       	push   $0x81
  jmp __alltraps
  10250c:	e9 e8 05 00 00       	jmp    102af9 <__alltraps>

00102511 <vector130>:
.globl vector130
vector130:
  pushl $0
  102511:	6a 00                	push   $0x0
  pushl $130
  102513:	68 82 00 00 00       	push   $0x82
  jmp __alltraps
  102518:	e9 dc 05 00 00       	jmp    102af9 <__alltraps>

0010251d <vector131>:
.globl vector131
vector131:
  pushl $0
  10251d:	6a 00                	push   $0x0
  pushl $131
  10251f:	68 83 00 00 00       	push   $0x83
  jmp __alltraps
  102524:	e9 d0 05 00 00       	jmp    102af9 <__alltraps>

00102529 <vector132>:
.globl vector132
vector132:
  pushl $0
  102529:	6a 00                	push   $0x0
  pushl $132
  10252b:	68 84 00 00 00       	push   $0x84
  jmp __alltraps
  102530:	e9 c4 05 00 00       	jmp    102af9 <__alltraps>

00102535 <vector133>:
.globl vector133
vector133:
  pushl $0
  102535:	6a 00                	push   $0x0
  pushl $133
  102537:	68 85 00 00 00       	push   $0x85
  jmp __alltraps
  10253c:	e9 b8 05 00 00       	jmp    102af9 <__alltraps>

00102541 <vector134>:
.globl vector134
vector134:
  pushl $0
  102541:	6a 00                	push   $0x0
  pushl $134
  102543:	68 86 00 00 00       	push   $0x86
  jmp __alltraps
  102548:	e9 ac 05 00 00       	jmp    102af9 <__alltraps>

0010254d <vector135>:
.globl vector135
vector135:
  pushl $0
  10254d:	6a 00                	push   $0x0
  pushl $135
  10254f:	68 87 00 00 00       	push   $0x87
  jmp __alltraps
  102554:	e9 a0 05 00 00       	jmp    102af9 <__alltraps>

00102559 <vector136>:
.globl vector136
vector136:
  pushl $0
  102559:	6a 00                	push   $0x0
  pushl $136
  10255b:	68 88 00 00 00       	push   $0x88
  jmp __alltraps
  102560:	e9 94 05 00 00       	jmp    102af9 <__alltraps>

00102565 <vector137>:
.globl vector137
vector137:
  pushl $0
  102565:	6a 00                	push   $0x0
  pushl $137
  102567:	68 89 00 00 00       	push   $0x89
  jmp __alltraps
  10256c:	e9 88 05 00 00       	jmp    102af9 <__alltraps>

00102571 <vector138>:
.globl vector138
vector138:
  pushl $0
  102571:	6a 00                	push   $0x0
  pushl $138
  102573:	68 8a 00 00 00       	push   $0x8a
  jmp __alltraps
  102578:	e9 7c 05 00 00       	jmp    102af9 <__alltraps>

0010257d <vector139>:
.globl vector139
vector139:
  pushl $0
  10257d:	6a 00                	push   $0x0
  pushl $139
  10257f:	68 8b 00 00 00       	push   $0x8b
  jmp __alltraps
  102584:	e9 70 05 00 00       	jmp    102af9 <__alltraps>

00102589 <vector140>:
.globl vector140
vector140:
  pushl $0
  102589:	6a 00                	push   $0x0
  pushl $140
  10258b:	68 8c 00 00 00       	push   $0x8c
  jmp __alltraps
  102590:	e9 64 05 00 00       	jmp    102af9 <__alltraps>

00102595 <vector141>:
.globl vector141
vector141:
  pushl $0
  102595:	6a 00                	push   $0x0
  pushl $141
  102597:	68 8d 00 00 00       	push   $0x8d
  jmp __alltraps
  10259c:	e9 58 05 00 00       	jmp    102af9 <__alltraps>

001025a1 <vector142>:
.globl vector142
vector142:
  pushl $0
  1025a1:	6a 00                	push   $0x0
  pushl $142
  1025a3:	68 8e 00 00 00       	push   $0x8e
  jmp __alltraps
  1025a8:	e9 4c 05 00 00       	jmp    102af9 <__alltraps>

001025ad <vector143>:
.globl vector143
vector143:
  pushl $0
  1025ad:	6a 00                	push   $0x0
  pushl $143
  1025af:	68 8f 00 00 00       	push   $0x8f
  jmp __alltraps
  1025b4:	e9 40 05 00 00       	jmp    102af9 <__alltraps>

001025b9 <vector144>:
.globl vector144
vector144:
  pushl $0
  1025b9:	6a 00                	push   $0x0
  pushl $144
  1025bb:	68 90 00 00 00       	push   $0x90
  jmp __alltraps
  1025c0:	e9 34 05 00 00       	jmp    102af9 <__alltraps>

001025c5 <vector145>:
.globl vector145
vector145:
  pushl $0
  1025c5:	6a 00                	push   $0x0
  pushl $145
  1025c7:	68 91 00 00 00       	push   $0x91
  jmp __alltraps
  1025cc:	e9 28 05 00 00       	jmp    102af9 <__alltraps>

001025d1 <vector146>:
.globl vector146
vector146:
  pushl $0
  1025d1:	6a 00                	push   $0x0
  pushl $146
  1025d3:	68 92 00 00 00       	push   $0x92
  jmp __alltraps
  1025d8:	e9 1c 05 00 00       	jmp    102af9 <__alltraps>

001025dd <vector147>:
.globl vector147
vector147:
  pushl $0
  1025dd:	6a 00                	push   $0x0
  pushl $147
  1025df:	68 93 00 00 00       	push   $0x93
  jmp __alltraps
  1025e4:	e9 10 05 00 00       	jmp    102af9 <__alltraps>

001025e9 <vector148>:
.globl vector148
vector148:
  pushl $0
  1025e9:	6a 00                	push   $0x0
  pushl $148
  1025eb:	68 94 00 00 00       	push   $0x94
  jmp __alltraps
  1025f0:	e9 04 05 00 00       	jmp    102af9 <__alltraps>

001025f5 <vector149>:
.globl vector149
vector149:
  pushl $0
  1025f5:	6a 00                	push   $0x0
  pushl $149
  1025f7:	68 95 00 00 00       	push   $0x95
  jmp __alltraps
  1025fc:	e9 f8 04 00 00       	jmp    102af9 <__alltraps>

00102601 <vector150>:
.globl vector150
vector150:
  pushl $0
  102601:	6a 00                	push   $0x0
  pushl $150
  102603:	68 96 00 00 00       	push   $0x96
  jmp __alltraps
  102608:	e9 ec 04 00 00       	jmp    102af9 <__alltraps>

0010260d <vector151>:
.globl vector151
vector151:
  pushl $0
  10260d:	6a 00                	push   $0x0
  pushl $151
  10260f:	68 97 00 00 00       	push   $0x97
  jmp __alltraps
  102614:	e9 e0 04 00 00       	jmp    102af9 <__alltraps>

00102619 <vector152>:
.globl vector152
vector152:
  pushl $0
  102619:	6a 00                	push   $0x0
  pushl $152
  10261b:	68 98 00 00 00       	push   $0x98
  jmp __alltraps
  102620:	e9 d4 04 00 00       	jmp    102af9 <__alltraps>

00102625 <vector153>:
.globl vector153
vector153:
  pushl $0
  102625:	6a 00                	push   $0x0
  pushl $153
  102627:	68 99 00 00 00       	push   $0x99
  jmp __alltraps
  10262c:	e9 c8 04 00 00       	jmp    102af9 <__alltraps>

00102631 <vector154>:
.globl vector154
vector154:
  pushl $0
  102631:	6a 00                	push   $0x0
  pushl $154
  102633:	68 9a 00 00 00       	push   $0x9a
  jmp __alltraps
  102638:	e9 bc 04 00 00       	jmp    102af9 <__alltraps>

0010263d <vector155>:
.globl vector155
vector155:
  pushl $0
  10263d:	6a 00                	push   $0x0
  pushl $155
  10263f:	68 9b 00 00 00       	push   $0x9b
  jmp __alltraps
  102644:	e9 b0 04 00 00       	jmp    102af9 <__alltraps>

00102649 <vector156>:
.globl vector156
vector156:
  pushl $0
  102649:	6a 00                	push   $0x0
  pushl $156
  10264b:	68 9c 00 00 00       	push   $0x9c
  jmp __alltraps
  102650:	e9 a4 04 00 00       	jmp    102af9 <__alltraps>

00102655 <vector157>:
.globl vector157
vector157:
  pushl $0
  102655:	6a 00                	push   $0x0
  pushl $157
  102657:	68 9d 00 00 00       	push   $0x9d
  jmp __alltraps
  10265c:	e9 98 04 00 00       	jmp    102af9 <__alltraps>

00102661 <vector158>:
.globl vector158
vector158:
  pushl $0
  102661:	6a 00                	push   $0x0
  pushl $158
  102663:	68 9e 00 00 00       	push   $0x9e
  jmp __alltraps
  102668:	e9 8c 04 00 00       	jmp    102af9 <__alltraps>

0010266d <vector159>:
.globl vector159
vector159:
  pushl $0
  10266d:	6a 00                	push   $0x0
  pushl $159
  10266f:	68 9f 00 00 00       	push   $0x9f
  jmp __alltraps
  102674:	e9 80 04 00 00       	jmp    102af9 <__alltraps>

00102679 <vector160>:
.globl vector160
vector160:
  pushl $0
  102679:	6a 00                	push   $0x0
  pushl $160
  10267b:	68 a0 00 00 00       	push   $0xa0
  jmp __alltraps
  102680:	e9 74 04 00 00       	jmp    102af9 <__alltraps>

00102685 <vector161>:
.globl vector161
vector161:
  pushl $0
  102685:	6a 00                	push   $0x0
  pushl $161
  102687:	68 a1 00 00 00       	push   $0xa1
  jmp __alltraps
  10268c:	e9 68 04 00 00       	jmp    102af9 <__alltraps>

00102691 <vector162>:
.globl vector162
vector162:
  pushl $0
  102691:	6a 00                	push   $0x0
  pushl $162
  102693:	68 a2 00 00 00       	push   $0xa2
  jmp __alltraps
  102698:	e9 5c 04 00 00       	jmp    102af9 <__alltraps>

0010269d <vector163>:
.globl vector163
vector163:
  pushl $0
  10269d:	6a 00                	push   $0x0
  pushl $163
  10269f:	68 a3 00 00 00       	push   $0xa3
  jmp __alltraps
  1026a4:	e9 50 04 00 00       	jmp    102af9 <__alltraps>

001026a9 <vector164>:
.globl vector164
vector164:
  pushl $0
  1026a9:	6a 00                	push   $0x0
  pushl $164
  1026ab:	68 a4 00 00 00       	push   $0xa4
  jmp __alltraps
  1026b0:	e9 44 04 00 00       	jmp    102af9 <__alltraps>

001026b5 <vector165>:
.globl vector165
vector165:
  pushl $0
  1026b5:	6a 00                	push   $0x0
  pushl $165
  1026b7:	68 a5 00 00 00       	push   $0xa5
  jmp __alltraps
  1026bc:	e9 38 04 00 00       	jmp    102af9 <__alltraps>

001026c1 <vector166>:
.globl vector166
vector166:
  pushl $0
  1026c1:	6a 00                	push   $0x0
  pushl $166
  1026c3:	68 a6 00 00 00       	push   $0xa6
  jmp __alltraps
  1026c8:	e9 2c 04 00 00       	jmp    102af9 <__alltraps>

001026cd <vector167>:
.globl vector167
vector167:
  pushl $0
  1026cd:	6a 00                	push   $0x0
  pushl $167
  1026cf:	68 a7 00 00 00       	push   $0xa7
  jmp __alltraps
  1026d4:	e9 20 04 00 00       	jmp    102af9 <__alltraps>

001026d9 <vector168>:
.globl vector168
vector168:
  pushl $0
  1026d9:	6a 00                	push   $0x0
  pushl $168
  1026db:	68 a8 00 00 00       	push   $0xa8
  jmp __alltraps
  1026e0:	e9 14 04 00 00       	jmp    102af9 <__alltraps>

001026e5 <vector169>:
.globl vector169
vector169:
  pushl $0
  1026e5:	6a 00                	push   $0x0
  pushl $169
  1026e7:	68 a9 00 00 00       	push   $0xa9
  jmp __alltraps
  1026ec:	e9 08 04 00 00       	jmp    102af9 <__alltraps>

001026f1 <vector170>:
.globl vector170
vector170:
  pushl $0
  1026f1:	6a 00                	push   $0x0
  pushl $170
  1026f3:	68 aa 00 00 00       	push   $0xaa
  jmp __alltraps
  1026f8:	e9 fc 03 00 00       	jmp    102af9 <__alltraps>

001026fd <vector171>:
.globl vector171
vector171:
  pushl $0
  1026fd:	6a 00                	push   $0x0
  pushl $171
  1026ff:	68 ab 00 00 00       	push   $0xab
  jmp __alltraps
  102704:	e9 f0 03 00 00       	jmp    102af9 <__alltraps>

00102709 <vector172>:
.globl vector172
vector172:
  pushl $0
  102709:	6a 00                	push   $0x0
  pushl $172
  10270b:	68 ac 00 00 00       	push   $0xac
  jmp __alltraps
  102710:	e9 e4 03 00 00       	jmp    102af9 <__alltraps>

00102715 <vector173>:
.globl vector173
vector173:
  pushl $0
  102715:	6a 00                	push   $0x0
  pushl $173
  102717:	68 ad 00 00 00       	push   $0xad
  jmp __alltraps
  10271c:	e9 d8 03 00 00       	jmp    102af9 <__alltraps>

00102721 <vector174>:
.globl vector174
vector174:
  pushl $0
  102721:	6a 00                	push   $0x0
  pushl $174
  102723:	68 ae 00 00 00       	push   $0xae
  jmp __alltraps
  102728:	e9 cc 03 00 00       	jmp    102af9 <__alltraps>

0010272d <vector175>:
.globl vector175
vector175:
  pushl $0
  10272d:	6a 00                	push   $0x0
  pushl $175
  10272f:	68 af 00 00 00       	push   $0xaf
  jmp __alltraps
  102734:	e9 c0 03 00 00       	jmp    102af9 <__alltraps>

00102739 <vector176>:
.globl vector176
vector176:
  pushl $0
  102739:	6a 00                	push   $0x0
  pushl $176
  10273b:	68 b0 00 00 00       	push   $0xb0
  jmp __alltraps
  102740:	e9 b4 03 00 00       	jmp    102af9 <__alltraps>

00102745 <vector177>:
.globl vector177
vector177:
  pushl $0
  102745:	6a 00                	push   $0x0
  pushl $177
  102747:	68 b1 00 00 00       	push   $0xb1
  jmp __alltraps
  10274c:	e9 a8 03 00 00       	jmp    102af9 <__alltraps>

00102751 <vector178>:
.globl vector178
vector178:
  pushl $0
  102751:	6a 00                	push   $0x0
  pushl $178
  102753:	68 b2 00 00 00       	push   $0xb2
  jmp __alltraps
  102758:	e9 9c 03 00 00       	jmp    102af9 <__alltraps>

0010275d <vector179>:
.globl vector179
vector179:
  pushl $0
  10275d:	6a 00                	push   $0x0
  pushl $179
  10275f:	68 b3 00 00 00       	push   $0xb3
  jmp __alltraps
  102764:	e9 90 03 00 00       	jmp    102af9 <__alltraps>

00102769 <vector180>:
.globl vector180
vector180:
  pushl $0
  102769:	6a 00                	push   $0x0
  pushl $180
  10276b:	68 b4 00 00 00       	push   $0xb4
  jmp __alltraps
  102770:	e9 84 03 00 00       	jmp    102af9 <__alltraps>

00102775 <vector181>:
.globl vector181
vector181:
  pushl $0
  102775:	6a 00                	push   $0x0
  pushl $181
  102777:	68 b5 00 00 00       	push   $0xb5
  jmp __alltraps
  10277c:	e9 78 03 00 00       	jmp    102af9 <__alltraps>

00102781 <vector182>:
.globl vector182
vector182:
  pushl $0
  102781:	6a 00                	push   $0x0
  pushl $182
  102783:	68 b6 00 00 00       	push   $0xb6
  jmp __alltraps
  102788:	e9 6c 03 00 00       	jmp    102af9 <__alltraps>

0010278d <vector183>:
.globl vector183
vector183:
  pushl $0
  10278d:	6a 00                	push   $0x0
  pushl $183
  10278f:	68 b7 00 00 00       	push   $0xb7
  jmp __alltraps
  102794:	e9 60 03 00 00       	jmp    102af9 <__alltraps>

00102799 <vector184>:
.globl vector184
vector184:
  pushl $0
  102799:	6a 00                	push   $0x0
  pushl $184
  10279b:	68 b8 00 00 00       	push   $0xb8
  jmp __alltraps
  1027a0:	e9 54 03 00 00       	jmp    102af9 <__alltraps>

001027a5 <vector185>:
.globl vector185
vector185:
  pushl $0
  1027a5:	6a 00                	push   $0x0
  pushl $185
  1027a7:	68 b9 00 00 00       	push   $0xb9
  jmp __alltraps
  1027ac:	e9 48 03 00 00       	jmp    102af9 <__alltraps>

001027b1 <vector186>:
.globl vector186
vector186:
  pushl $0
  1027b1:	6a 00                	push   $0x0
  pushl $186
  1027b3:	68 ba 00 00 00       	push   $0xba
  jmp __alltraps
  1027b8:	e9 3c 03 00 00       	jmp    102af9 <__alltraps>

001027bd <vector187>:
.globl vector187
vector187:
  pushl $0
  1027bd:	6a 00                	push   $0x0
  pushl $187
  1027bf:	68 bb 00 00 00       	push   $0xbb
  jmp __alltraps
  1027c4:	e9 30 03 00 00       	jmp    102af9 <__alltraps>

001027c9 <vector188>:
.globl vector188
vector188:
  pushl $0
  1027c9:	6a 00                	push   $0x0
  pushl $188
  1027cb:	68 bc 00 00 00       	push   $0xbc
  jmp __alltraps
  1027d0:	e9 24 03 00 00       	jmp    102af9 <__alltraps>

001027d5 <vector189>:
.globl vector189
vector189:
  pushl $0
  1027d5:	6a 00                	push   $0x0
  pushl $189
  1027d7:	68 bd 00 00 00       	push   $0xbd
  jmp __alltraps
  1027dc:	e9 18 03 00 00       	jmp    102af9 <__alltraps>

001027e1 <vector190>:
.globl vector190
vector190:
  pushl $0
  1027e1:	6a 00                	push   $0x0
  pushl $190
  1027e3:	68 be 00 00 00       	push   $0xbe
  jmp __alltraps
  1027e8:	e9 0c 03 00 00       	jmp    102af9 <__alltraps>

001027ed <vector191>:
.globl vector191
vector191:
  pushl $0
  1027ed:	6a 00                	push   $0x0
  pushl $191
  1027ef:	68 bf 00 00 00       	push   $0xbf
  jmp __alltraps
  1027f4:	e9 00 03 00 00       	jmp    102af9 <__alltraps>

001027f9 <vector192>:
.globl vector192
vector192:
  pushl $0
  1027f9:	6a 00                	push   $0x0
  pushl $192
  1027fb:	68 c0 00 00 00       	push   $0xc0
  jmp __alltraps
  102800:	e9 f4 02 00 00       	jmp    102af9 <__alltraps>

00102805 <vector193>:
.globl vector193
vector193:
  pushl $0
  102805:	6a 00                	push   $0x0
  pushl $193
  102807:	68 c1 00 00 00       	push   $0xc1
  jmp __alltraps
  10280c:	e9 e8 02 00 00       	jmp    102af9 <__alltraps>

00102811 <vector194>:
.globl vector194
vector194:
  pushl $0
  102811:	6a 00                	push   $0x0
  pushl $194
  102813:	68 c2 00 00 00       	push   $0xc2
  jmp __alltraps
  102818:	e9 dc 02 00 00       	jmp    102af9 <__alltraps>

0010281d <vector195>:
.globl vector195
vector195:
  pushl $0
  10281d:	6a 00                	push   $0x0
  pushl $195
  10281f:	68 c3 00 00 00       	push   $0xc3
  jmp __alltraps
  102824:	e9 d0 02 00 00       	jmp    102af9 <__alltraps>

00102829 <vector196>:
.globl vector196
vector196:
  pushl $0
  102829:	6a 00                	push   $0x0
  pushl $196
  10282b:	68 c4 00 00 00       	push   $0xc4
  jmp __alltraps
  102830:	e9 c4 02 00 00       	jmp    102af9 <__alltraps>

00102835 <vector197>:
.globl vector197
vector197:
  pushl $0
  102835:	6a 00                	push   $0x0
  pushl $197
  102837:	68 c5 00 00 00       	push   $0xc5
  jmp __alltraps
  10283c:	e9 b8 02 00 00       	jmp    102af9 <__alltraps>

00102841 <vector198>:
.globl vector198
vector198:
  pushl $0
  102841:	6a 00                	push   $0x0
  pushl $198
  102843:	68 c6 00 00 00       	push   $0xc6
  jmp __alltraps
  102848:	e9 ac 02 00 00       	jmp    102af9 <__alltraps>

0010284d <vector199>:
.globl vector199
vector199:
  pushl $0
  10284d:	6a 00                	push   $0x0
  pushl $199
  10284f:	68 c7 00 00 00       	push   $0xc7
  jmp __alltraps
  102854:	e9 a0 02 00 00       	jmp    102af9 <__alltraps>

00102859 <vector200>:
.globl vector200
vector200:
  pushl $0
  102859:	6a 00                	push   $0x0
  pushl $200
  10285b:	68 c8 00 00 00       	push   $0xc8
  jmp __alltraps
  102860:	e9 94 02 00 00       	jmp    102af9 <__alltraps>

00102865 <vector201>:
.globl vector201
vector201:
  pushl $0
  102865:	6a 00                	push   $0x0
  pushl $201
  102867:	68 c9 00 00 00       	push   $0xc9
  jmp __alltraps
  10286c:	e9 88 02 00 00       	jmp    102af9 <__alltraps>

00102871 <vector202>:
.globl vector202
vector202:
  pushl $0
  102871:	6a 00                	push   $0x0
  pushl $202
  102873:	68 ca 00 00 00       	push   $0xca
  jmp __alltraps
  102878:	e9 7c 02 00 00       	jmp    102af9 <__alltraps>

0010287d <vector203>:
.globl vector203
vector203:
  pushl $0
  10287d:	6a 00                	push   $0x0
  pushl $203
  10287f:	68 cb 00 00 00       	push   $0xcb
  jmp __alltraps
  102884:	e9 70 02 00 00       	jmp    102af9 <__alltraps>

00102889 <vector204>:
.globl vector204
vector204:
  pushl $0
  102889:	6a 00                	push   $0x0
  pushl $204
  10288b:	68 cc 00 00 00       	push   $0xcc
  jmp __alltraps
  102890:	e9 64 02 00 00       	jmp    102af9 <__alltraps>

00102895 <vector205>:
.globl vector205
vector205:
  pushl $0
  102895:	6a 00                	push   $0x0
  pushl $205
  102897:	68 cd 00 00 00       	push   $0xcd
  jmp __alltraps
  10289c:	e9 58 02 00 00       	jmp    102af9 <__alltraps>

001028a1 <vector206>:
.globl vector206
vector206:
  pushl $0
  1028a1:	6a 00                	push   $0x0
  pushl $206
  1028a3:	68 ce 00 00 00       	push   $0xce
  jmp __alltraps
  1028a8:	e9 4c 02 00 00       	jmp    102af9 <__alltraps>

001028ad <vector207>:
.globl vector207
vector207:
  pushl $0
  1028ad:	6a 00                	push   $0x0
  pushl $207
  1028af:	68 cf 00 00 00       	push   $0xcf
  jmp __alltraps
  1028b4:	e9 40 02 00 00       	jmp    102af9 <__alltraps>

001028b9 <vector208>:
.globl vector208
vector208:
  pushl $0
  1028b9:	6a 00                	push   $0x0
  pushl $208
  1028bb:	68 d0 00 00 00       	push   $0xd0
  jmp __alltraps
  1028c0:	e9 34 02 00 00       	jmp    102af9 <__alltraps>

001028c5 <vector209>:
.globl vector209
vector209:
  pushl $0
  1028c5:	6a 00                	push   $0x0
  pushl $209
  1028c7:	68 d1 00 00 00       	push   $0xd1
  jmp __alltraps
  1028cc:	e9 28 02 00 00       	jmp    102af9 <__alltraps>

001028d1 <vector210>:
.globl vector210
vector210:
  pushl $0
  1028d1:	6a 00                	push   $0x0
  pushl $210
  1028d3:	68 d2 00 00 00       	push   $0xd2
  jmp __alltraps
  1028d8:	e9 1c 02 00 00       	jmp    102af9 <__alltraps>

001028dd <vector211>:
.globl vector211
vector211:
  pushl $0
  1028dd:	6a 00                	push   $0x0
  pushl $211
  1028df:	68 d3 00 00 00       	push   $0xd3
  jmp __alltraps
  1028e4:	e9 10 02 00 00       	jmp    102af9 <__alltraps>

001028e9 <vector212>:
.globl vector212
vector212:
  pushl $0
  1028e9:	6a 00                	push   $0x0
  pushl $212
  1028eb:	68 d4 00 00 00       	push   $0xd4
  jmp __alltraps
  1028f0:	e9 04 02 00 00       	jmp    102af9 <__alltraps>

001028f5 <vector213>:
.globl vector213
vector213:
  pushl $0
  1028f5:	6a 00                	push   $0x0
  pushl $213
  1028f7:	68 d5 00 00 00       	push   $0xd5
  jmp __alltraps
  1028fc:	e9 f8 01 00 00       	jmp    102af9 <__alltraps>

00102901 <vector214>:
.globl vector214
vector214:
  pushl $0
  102901:	6a 00                	push   $0x0
  pushl $214
  102903:	68 d6 00 00 00       	push   $0xd6
  jmp __alltraps
  102908:	e9 ec 01 00 00       	jmp    102af9 <__alltraps>

0010290d <vector215>:
.globl vector215
vector215:
  pushl $0
  10290d:	6a 00                	push   $0x0
  pushl $215
  10290f:	68 d7 00 00 00       	push   $0xd7
  jmp __alltraps
  102914:	e9 e0 01 00 00       	jmp    102af9 <__alltraps>

00102919 <vector216>:
.globl vector216
vector216:
  pushl $0
  102919:	6a 00                	push   $0x0
  pushl $216
  10291b:	68 d8 00 00 00       	push   $0xd8
  jmp __alltraps
  102920:	e9 d4 01 00 00       	jmp    102af9 <__alltraps>

00102925 <vector217>:
.globl vector217
vector217:
  pushl $0
  102925:	6a 00                	push   $0x0
  pushl $217
  102927:	68 d9 00 00 00       	push   $0xd9
  jmp __alltraps
  10292c:	e9 c8 01 00 00       	jmp    102af9 <__alltraps>

00102931 <vector218>:
.globl vector218
vector218:
  pushl $0
  102931:	6a 00                	push   $0x0
  pushl $218
  102933:	68 da 00 00 00       	push   $0xda
  jmp __alltraps
  102938:	e9 bc 01 00 00       	jmp    102af9 <__alltraps>

0010293d <vector219>:
.globl vector219
vector219:
  pushl $0
  10293d:	6a 00                	push   $0x0
  pushl $219
  10293f:	68 db 00 00 00       	push   $0xdb
  jmp __alltraps
  102944:	e9 b0 01 00 00       	jmp    102af9 <__alltraps>

00102949 <vector220>:
.globl vector220
vector220:
  pushl $0
  102949:	6a 00                	push   $0x0
  pushl $220
  10294b:	68 dc 00 00 00       	push   $0xdc
  jmp __alltraps
  102950:	e9 a4 01 00 00       	jmp    102af9 <__alltraps>

00102955 <vector221>:
.globl vector221
vector221:
  pushl $0
  102955:	6a 00                	push   $0x0
  pushl $221
  102957:	68 dd 00 00 00       	push   $0xdd
  jmp __alltraps
  10295c:	e9 98 01 00 00       	jmp    102af9 <__alltraps>

00102961 <vector222>:
.globl vector222
vector222:
  pushl $0
  102961:	6a 00                	push   $0x0
  pushl $222
  102963:	68 de 00 00 00       	push   $0xde
  jmp __alltraps
  102968:	e9 8c 01 00 00       	jmp    102af9 <__alltraps>

0010296d <vector223>:
.globl vector223
vector223:
  pushl $0
  10296d:	6a 00                	push   $0x0
  pushl $223
  10296f:	68 df 00 00 00       	push   $0xdf
  jmp __alltraps
  102974:	e9 80 01 00 00       	jmp    102af9 <__alltraps>

00102979 <vector224>:
.globl vector224
vector224:
  pushl $0
  102979:	6a 00                	push   $0x0
  pushl $224
  10297b:	68 e0 00 00 00       	push   $0xe0
  jmp __alltraps
  102980:	e9 74 01 00 00       	jmp    102af9 <__alltraps>

00102985 <vector225>:
.globl vector225
vector225:
  pushl $0
  102985:	6a 00                	push   $0x0
  pushl $225
  102987:	68 e1 00 00 00       	push   $0xe1
  jmp __alltraps
  10298c:	e9 68 01 00 00       	jmp    102af9 <__alltraps>

00102991 <vector226>:
.globl vector226
vector226:
  pushl $0
  102991:	6a 00                	push   $0x0
  pushl $226
  102993:	68 e2 00 00 00       	push   $0xe2
  jmp __alltraps
  102998:	e9 5c 01 00 00       	jmp    102af9 <__alltraps>

0010299d <vector227>:
.globl vector227
vector227:
  pushl $0
  10299d:	6a 00                	push   $0x0
  pushl $227
  10299f:	68 e3 00 00 00       	push   $0xe3
  jmp __alltraps
  1029a4:	e9 50 01 00 00       	jmp    102af9 <__alltraps>

001029a9 <vector228>:
.globl vector228
vector228:
  pushl $0
  1029a9:	6a 00                	push   $0x0
  pushl $228
  1029ab:	68 e4 00 00 00       	push   $0xe4
  jmp __alltraps
  1029b0:	e9 44 01 00 00       	jmp    102af9 <__alltraps>

001029b5 <vector229>:
.globl vector229
vector229:
  pushl $0
  1029b5:	6a 00                	push   $0x0
  pushl $229
  1029b7:	68 e5 00 00 00       	push   $0xe5
  jmp __alltraps
  1029bc:	e9 38 01 00 00       	jmp    102af9 <__alltraps>

001029c1 <vector230>:
.globl vector230
vector230:
  pushl $0
  1029c1:	6a 00                	push   $0x0
  pushl $230
  1029c3:	68 e6 00 00 00       	push   $0xe6
  jmp __alltraps
  1029c8:	e9 2c 01 00 00       	jmp    102af9 <__alltraps>

001029cd <vector231>:
.globl vector231
vector231:
  pushl $0
  1029cd:	6a 00                	push   $0x0
  pushl $231
  1029cf:	68 e7 00 00 00       	push   $0xe7
  jmp __alltraps
  1029d4:	e9 20 01 00 00       	jmp    102af9 <__alltraps>

001029d9 <vector232>:
.globl vector232
vector232:
  pushl $0
  1029d9:	6a 00                	push   $0x0
  pushl $232
  1029db:	68 e8 00 00 00       	push   $0xe8
  jmp __alltraps
  1029e0:	e9 14 01 00 00       	jmp    102af9 <__alltraps>

001029e5 <vector233>:
.globl vector233
vector233:
  pushl $0
  1029e5:	6a 00                	push   $0x0
  pushl $233
  1029e7:	68 e9 00 00 00       	push   $0xe9
  jmp __alltraps
  1029ec:	e9 08 01 00 00       	jmp    102af9 <__alltraps>

001029f1 <vector234>:
.globl vector234
vector234:
  pushl $0
  1029f1:	6a 00                	push   $0x0
  pushl $234
  1029f3:	68 ea 00 00 00       	push   $0xea
  jmp __alltraps
  1029f8:	e9 fc 00 00 00       	jmp    102af9 <__alltraps>

001029fd <vector235>:
.globl vector235
vector235:
  pushl $0
  1029fd:	6a 00                	push   $0x0
  pushl $235
  1029ff:	68 eb 00 00 00       	push   $0xeb
  jmp __alltraps
  102a04:	e9 f0 00 00 00       	jmp    102af9 <__alltraps>

00102a09 <vector236>:
.globl vector236
vector236:
  pushl $0
  102a09:	6a 00                	push   $0x0
  pushl $236
  102a0b:	68 ec 00 00 00       	push   $0xec
  jmp __alltraps
  102a10:	e9 e4 00 00 00       	jmp    102af9 <__alltraps>

00102a15 <vector237>:
.globl vector237
vector237:
  pushl $0
  102a15:	6a 00                	push   $0x0
  pushl $237
  102a17:	68 ed 00 00 00       	push   $0xed
  jmp __alltraps
  102a1c:	e9 d8 00 00 00       	jmp    102af9 <__alltraps>

00102a21 <vector238>:
.globl vector238
vector238:
  pushl $0
  102a21:	6a 00                	push   $0x0
  pushl $238
  102a23:	68 ee 00 00 00       	push   $0xee
  jmp __alltraps
  102a28:	e9 cc 00 00 00       	jmp    102af9 <__alltraps>

00102a2d <vector239>:
.globl vector239
vector239:
  pushl $0
  102a2d:	6a 00                	push   $0x0
  pushl $239
  102a2f:	68 ef 00 00 00       	push   $0xef
  jmp __alltraps
  102a34:	e9 c0 00 00 00       	jmp    102af9 <__alltraps>

00102a39 <vector240>:
.globl vector240
vector240:
  pushl $0
  102a39:	6a 00                	push   $0x0
  pushl $240
  102a3b:	68 f0 00 00 00       	push   $0xf0
  jmp __alltraps
  102a40:	e9 b4 00 00 00       	jmp    102af9 <__alltraps>

00102a45 <vector241>:
.globl vector241
vector241:
  pushl $0
  102a45:	6a 00                	push   $0x0
  pushl $241
  102a47:	68 f1 00 00 00       	push   $0xf1
  jmp __alltraps
  102a4c:	e9 a8 00 00 00       	jmp    102af9 <__alltraps>

00102a51 <vector242>:
.globl vector242
vector242:
  pushl $0
  102a51:	6a 00                	push   $0x0
  pushl $242
  102a53:	68 f2 00 00 00       	push   $0xf2
  jmp __alltraps
  102a58:	e9 9c 00 00 00       	jmp    102af9 <__alltraps>

00102a5d <vector243>:
.globl vector243
vector243:
  pushl $0
  102a5d:	6a 00                	push   $0x0
  pushl $243
  102a5f:	68 f3 00 00 00       	push   $0xf3
  jmp __alltraps
  102a64:	e9 90 00 00 00       	jmp    102af9 <__alltraps>

00102a69 <vector244>:
.globl vector244
vector244:
  pushl $0
  102a69:	6a 00                	push   $0x0
  pushl $244
  102a6b:	68 f4 00 00 00       	push   $0xf4
  jmp __alltraps
  102a70:	e9 84 00 00 00       	jmp    102af9 <__alltraps>

00102a75 <vector245>:
.globl vector245
vector245:
  pushl $0
  102a75:	6a 00                	push   $0x0
  pushl $245
  102a77:	68 f5 00 00 00       	push   $0xf5
  jmp __alltraps
  102a7c:	e9 78 00 00 00       	jmp    102af9 <__alltraps>

00102a81 <vector246>:
.globl vector246
vector246:
  pushl $0
  102a81:	6a 00                	push   $0x0
  pushl $246
  102a83:	68 f6 00 00 00       	push   $0xf6
  jmp __alltraps
  102a88:	e9 6c 00 00 00       	jmp    102af9 <__alltraps>

00102a8d <vector247>:
.globl vector247
vector247:
  pushl $0
  102a8d:	6a 00                	push   $0x0
  pushl $247
  102a8f:	68 f7 00 00 00       	push   $0xf7
  jmp __alltraps
  102a94:	e9 60 00 00 00       	jmp    102af9 <__alltraps>

00102a99 <vector248>:
.globl vector248
vector248:
  pushl $0
  102a99:	6a 00                	push   $0x0
  pushl $248
  102a9b:	68 f8 00 00 00       	push   $0xf8
  jmp __alltraps
  102aa0:	e9 54 00 00 00       	jmp    102af9 <__alltraps>

00102aa5 <vector249>:
.globl vector249
vector249:
  pushl $0
  102aa5:	6a 00                	push   $0x0
  pushl $249
  102aa7:	68 f9 00 00 00       	push   $0xf9
  jmp __alltraps
  102aac:	e9 48 00 00 00       	jmp    102af9 <__alltraps>

00102ab1 <vector250>:
.globl vector250
vector250:
  pushl $0
  102ab1:	6a 00                	push   $0x0
  pushl $250
  102ab3:	68 fa 00 00 00       	push   $0xfa
  jmp __alltraps
  102ab8:	e9 3c 00 00 00       	jmp    102af9 <__alltraps>

00102abd <vector251>:
.globl vector251
vector251:
  pushl $0
  102abd:	6a 00                	push   $0x0
  pushl $251
  102abf:	68 fb 00 00 00       	push   $0xfb
  jmp __alltraps
  102ac4:	e9 30 00 00 00       	jmp    102af9 <__alltraps>

00102ac9 <vector252>:
.globl vector252
vector252:
  pushl $0
  102ac9:	6a 00                	push   $0x0
  pushl $252
  102acb:	68 fc 00 00 00       	push   $0xfc
  jmp __alltraps
  102ad0:	e9 24 00 00 00       	jmp    102af9 <__alltraps>

00102ad5 <vector253>:
.globl vector253
vector253:
  pushl $0
  102ad5:	6a 00                	push   $0x0
  pushl $253
  102ad7:	68 fd 00 00 00       	push   $0xfd
  jmp __alltraps
  102adc:	e9 18 00 00 00       	jmp    102af9 <__alltraps>

00102ae1 <vector254>:
.globl vector254
vector254:
  pushl $0
  102ae1:	6a 00                	push   $0x0
  pushl $254
  102ae3:	68 fe 00 00 00       	push   $0xfe
  jmp __alltraps
  102ae8:	e9 0c 00 00 00       	jmp    102af9 <__alltraps>

00102aed <vector255>:
.globl vector255
vector255:
  pushl $0
  102aed:	6a 00                	push   $0x0
  pushl $255
  102aef:	68 ff 00 00 00       	push   $0xff
  jmp __alltraps
  102af4:	e9 00 00 00 00       	jmp    102af9 <__alltraps>

00102af9 <__alltraps>:
.text
.globl __alltraps
__alltraps:
    # push registers to build a trap frame
    # therefore make the stack look like a struct trapframe
    pushl %ds
  102af9:	1e                   	push   %ds
    pushl %es
  102afa:	06                   	push   %es
    pushl %fs
  102afb:	0f a0                	push   %fs
    pushl %gs
  102afd:	0f a8                	push   %gs
    pushal
  102aff:	60                   	pusha  

    # load GD_KDATA into %ds and %es to set up data segments for kernel
    movl $GD_KDATA, %eax
  102b00:	b8 10 00 00 00       	mov    $0x10,%eax
    movw %ax, %ds
  102b05:	8e d8                	mov    %eax,%ds
    movw %ax, %es
  102b07:	8e c0                	mov    %eax,%es

    # push %esp to pass a pointer to the trapframe as an argument to trap()
    pushl %esp
  102b09:	54                   	push   %esp

    # call trap(tf), where tf=%esp
    call trap
  102b0a:	e8 41 f5 ff ff       	call   102050 <trap>

    # pop the pushed stack pointer
    popl %esp
  102b0f:	5c                   	pop    %esp

00102b10 <__trapret>:

    # return falls through to trapret...
.globl __trapret
__trapret:
    # restore registers from stack
    popal
  102b10:	61                   	popa   

    # restore %ds, %es, %fs and %gs
    popl %gs
  102b11:	0f a9                	pop    %gs
    popl %fs
  102b13:	0f a1                	pop    %fs
    popl %es
  102b15:	07                   	pop    %es
    popl %ds
  102b16:	1f                   	pop    %ds

    # get rid of the trap number and error code
    addl $0x8, %esp
  102b17:	83 c4 08             	add    $0x8,%esp
    iret
  102b1a:	cf                   	iret   

00102b1b <lgdt>:
/* *
 * lgdt - load the global descriptor table register and reset the
 * data/code segement registers for kernel.
 * */
static inline void
lgdt(struct pseudodesc *pd) {
  102b1b:	55                   	push   %ebp
  102b1c:	89 e5                	mov    %esp,%ebp
    asm volatile ("lgdt (%0)" :: "r" (pd));
  102b1e:	8b 45 08             	mov    0x8(%ebp),%eax
  102b21:	0f 01 10             	lgdtl  (%eax)
    asm volatile ("movw %%ax, %%gs" :: "a" (USER_DS));
  102b24:	b8 23 00 00 00       	mov    $0x23,%eax
  102b29:	8e e8                	mov    %eax,%gs
    asm volatile ("movw %%ax, %%fs" :: "a" (USER_DS));
  102b2b:	b8 23 00 00 00       	mov    $0x23,%eax
  102b30:	8e e0                	mov    %eax,%fs
    asm volatile ("movw %%ax, %%es" :: "a" (KERNEL_DS));
  102b32:	b8 10 00 00 00       	mov    $0x10,%eax
  102b37:	8e c0                	mov    %eax,%es
    asm volatile ("movw %%ax, %%ds" :: "a" (KERNEL_DS));
  102b39:	b8 10 00 00 00       	mov    $0x10,%eax
  102b3e:	8e d8                	mov    %eax,%ds
    asm volatile ("movw %%ax, %%ss" :: "a" (KERNEL_DS));
  102b40:	b8 10 00 00 00       	mov    $0x10,%eax
  102b45:	8e d0                	mov    %eax,%ss
    // reload cs
    asm volatile ("ljmp %0, $1f\n 1:\n" :: "i" (KERNEL_CS));
  102b47:	ea 4e 2b 10 00 08 00 	ljmp   $0x8,$0x102b4e
}
  102b4e:	90                   	nop
  102b4f:	5d                   	pop    %ebp
  102b50:	c3                   	ret    

00102b51 <gdt_init>:
/* temporary kernel stack */
uint8_t stack0[1024];

/* gdt_init - initialize the default GDT and TSS */
static void
gdt_init(void) {
  102b51:	f3 0f 1e fb          	endbr32 
  102b55:	55                   	push   %ebp
  102b56:	89 e5                	mov    %esp,%ebp
  102b58:	83 ec 14             	sub    $0x14,%esp
    // Setup a TSS so that we can get the right stack when we trap from
    // user to the kernel. But not safe here, it's only a temporary value,
    // it will be set to KSTACKTOP in lab2.
    ts.ts_esp0 = (uint32_t)&stack0 + sizeof(stack0);
  102b5b:	b8 80 19 11 00       	mov    $0x111980,%eax
  102b60:	05 00 04 00 00       	add    $0x400,%eax
  102b65:	a3 a4 18 11 00       	mov    %eax,0x1118a4
    ts.ts_ss0 = KERNEL_DS;
  102b6a:	66 c7 05 a8 18 11 00 	movw   $0x10,0x1118a8
  102b71:	10 00 

    // initialize the TSS filed of the gdt
    gdt[SEG_TSS] = SEG16(STS_T32A, (uint32_t)&ts, sizeof(ts), DPL_KERNEL);
  102b73:	66 c7 05 08 0a 11 00 	movw   $0x68,0x110a08
  102b7a:	68 00 
  102b7c:	b8 a0 18 11 00       	mov    $0x1118a0,%eax
  102b81:	0f b7 c0             	movzwl %ax,%eax
  102b84:	66 a3 0a 0a 11 00    	mov    %ax,0x110a0a
  102b8a:	b8 a0 18 11 00       	mov    $0x1118a0,%eax
  102b8f:	c1 e8 10             	shr    $0x10,%eax
  102b92:	a2 0c 0a 11 00       	mov    %al,0x110a0c
  102b97:	0f b6 05 0d 0a 11 00 	movzbl 0x110a0d,%eax
  102b9e:	24 f0                	and    $0xf0,%al
  102ba0:	0c 09                	or     $0x9,%al
  102ba2:	a2 0d 0a 11 00       	mov    %al,0x110a0d
  102ba7:	0f b6 05 0d 0a 11 00 	movzbl 0x110a0d,%eax
  102bae:	0c 10                	or     $0x10,%al
  102bb0:	a2 0d 0a 11 00       	mov    %al,0x110a0d
  102bb5:	0f b6 05 0d 0a 11 00 	movzbl 0x110a0d,%eax
  102bbc:	24 9f                	and    $0x9f,%al
  102bbe:	a2 0d 0a 11 00       	mov    %al,0x110a0d
  102bc3:	0f b6 05 0d 0a 11 00 	movzbl 0x110a0d,%eax
  102bca:	0c 80                	or     $0x80,%al
  102bcc:	a2 0d 0a 11 00       	mov    %al,0x110a0d
  102bd1:	0f b6 05 0e 0a 11 00 	movzbl 0x110a0e,%eax
  102bd8:	24 f0                	and    $0xf0,%al
  102bda:	a2 0e 0a 11 00       	mov    %al,0x110a0e
  102bdf:	0f b6 05 0e 0a 11 00 	movzbl 0x110a0e,%eax
  102be6:	24 ef                	and    $0xef,%al
  102be8:	a2 0e 0a 11 00       	mov    %al,0x110a0e
  102bed:	0f b6 05 0e 0a 11 00 	movzbl 0x110a0e,%eax
  102bf4:	24 df                	and    $0xdf,%al
  102bf6:	a2 0e 0a 11 00       	mov    %al,0x110a0e
  102bfb:	0f b6 05 0e 0a 11 00 	movzbl 0x110a0e,%eax
  102c02:	0c 40                	or     $0x40,%al
  102c04:	a2 0e 0a 11 00       	mov    %al,0x110a0e
  102c09:	0f b6 05 0e 0a 11 00 	movzbl 0x110a0e,%eax
  102c10:	24 7f                	and    $0x7f,%al
  102c12:	a2 0e 0a 11 00       	mov    %al,0x110a0e
  102c17:	b8 a0 18 11 00       	mov    $0x1118a0,%eax
  102c1c:	c1 e8 18             	shr    $0x18,%eax
  102c1f:	a2 0f 0a 11 00       	mov    %al,0x110a0f
    gdt[SEG_TSS].sd_s = 0;
  102c24:	0f b6 05 0d 0a 11 00 	movzbl 0x110a0d,%eax
  102c2b:	24 ef                	and    $0xef,%al
  102c2d:	a2 0d 0a 11 00       	mov    %al,0x110a0d

    // reload all segment registers
    lgdt(&gdt_pd);
  102c32:	c7 04 24 10 0a 11 00 	movl   $0x110a10,(%esp)
  102c39:	e8 dd fe ff ff       	call   102b1b <lgdt>
  102c3e:	66 c7 45 fe 28 00    	movw   $0x28,-0x2(%ebp)

static inline void
ltr(uint16_t sel) {
    asm volatile ("ltr %0" :: "r" (sel));
  102c44:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
  102c48:	0f 00 d8             	ltr    %ax
}
  102c4b:	90                   	nop

    // load the TSS
    ltr(GD_TSS);
}
  102c4c:	90                   	nop
  102c4d:	c9                   	leave  
  102c4e:	c3                   	ret    

00102c4f <pmm_init>:

/* pmm_init - initialize the physical memory management */
void
pmm_init(void) {
  102c4f:	f3 0f 1e fb          	endbr32 
  102c53:	55                   	push   %ebp
  102c54:	89 e5                	mov    %esp,%ebp
    gdt_init();
  102c56:	e8 f6 fe ff ff       	call   102b51 <gdt_init>
}
  102c5b:	90                   	nop
  102c5c:	5d                   	pop    %ebp
  102c5d:	c3                   	ret    

00102c5e <strlen>:
 * @s:        the input string
 *
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
  102c5e:	f3 0f 1e fb          	endbr32 
  102c62:	55                   	push   %ebp
  102c63:	89 e5                	mov    %esp,%ebp
  102c65:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
  102c68:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (*s ++ != '\0') {
  102c6f:	eb 03                	jmp    102c74 <strlen+0x16>
        cnt ++;
  102c71:	ff 45 fc             	incl   -0x4(%ebp)
    while (*s ++ != '\0') {
  102c74:	8b 45 08             	mov    0x8(%ebp),%eax
  102c77:	8d 50 01             	lea    0x1(%eax),%edx
  102c7a:	89 55 08             	mov    %edx,0x8(%ebp)
  102c7d:	0f b6 00             	movzbl (%eax),%eax
  102c80:	84 c0                	test   %al,%al
  102c82:	75 ed                	jne    102c71 <strlen+0x13>
    }
    return cnt;
  102c84:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  102c87:	c9                   	leave  
  102c88:	c3                   	ret    

00102c89 <strnlen>:
 * The return value is strlen(s), if that is less than @len, or
 * @len if there is no '\0' character among the first @len characters
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
  102c89:	f3 0f 1e fb          	endbr32 
  102c8d:	55                   	push   %ebp
  102c8e:	89 e5                	mov    %esp,%ebp
  102c90:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
  102c93:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (cnt < len && *s ++ != '\0') {
  102c9a:	eb 03                	jmp    102c9f <strnlen+0x16>
        cnt ++;
  102c9c:	ff 45 fc             	incl   -0x4(%ebp)
    while (cnt < len && *s ++ != '\0') {
  102c9f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  102ca2:	3b 45 0c             	cmp    0xc(%ebp),%eax
  102ca5:	73 10                	jae    102cb7 <strnlen+0x2e>
  102ca7:	8b 45 08             	mov    0x8(%ebp),%eax
  102caa:	8d 50 01             	lea    0x1(%eax),%edx
  102cad:	89 55 08             	mov    %edx,0x8(%ebp)
  102cb0:	0f b6 00             	movzbl (%eax),%eax
  102cb3:	84 c0                	test   %al,%al
  102cb5:	75 e5                	jne    102c9c <strnlen+0x13>
    }
    return cnt;
  102cb7:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  102cba:	c9                   	leave  
  102cbb:	c3                   	ret    

00102cbc <strcpy>:
 * To avoid overflows, the size of array pointed by @dst should be long enough to
 * contain the same string as @src (including the terminating null character), and
 * should not overlap in memory with @src.
 * */
char *
strcpy(char *dst, const char *src) {
  102cbc:	f3 0f 1e fb          	endbr32 
  102cc0:	55                   	push   %ebp
  102cc1:	89 e5                	mov    %esp,%ebp
  102cc3:	57                   	push   %edi
  102cc4:	56                   	push   %esi
  102cc5:	83 ec 20             	sub    $0x20,%esp
  102cc8:	8b 45 08             	mov    0x8(%ebp),%eax
  102ccb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  102cce:	8b 45 0c             	mov    0xc(%ebp),%eax
  102cd1:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCPY
#define __HAVE_ARCH_STRCPY
static inline char *
__strcpy(char *dst, const char *src) {
    int d0, d1, d2;
    asm volatile (
  102cd4:	8b 55 f0             	mov    -0x10(%ebp),%edx
  102cd7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102cda:	89 d1                	mov    %edx,%ecx
  102cdc:	89 c2                	mov    %eax,%edx
  102cde:	89 ce                	mov    %ecx,%esi
  102ce0:	89 d7                	mov    %edx,%edi
  102ce2:	ac                   	lods   %ds:(%esi),%al
  102ce3:	aa                   	stos   %al,%es:(%edi)
  102ce4:	84 c0                	test   %al,%al
  102ce6:	75 fa                	jne    102ce2 <strcpy+0x26>
  102ce8:	89 fa                	mov    %edi,%edx
  102cea:	89 f1                	mov    %esi,%ecx
  102cec:	89 4d ec             	mov    %ecx,-0x14(%ebp)
  102cef:	89 55 e8             	mov    %edx,-0x18(%ebp)
  102cf2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            "stosb;"
            "testb %%al, %%al;"
            "jne 1b;"
            : "=&S" (d0), "=&D" (d1), "=&a" (d2)
            : "0" (src), "1" (dst) : "memory");
    return dst;
  102cf5:	8b 45 f4             	mov    -0xc(%ebp),%eax
    char *p = dst;
    while ((*p ++ = *src ++) != '\0')
        /* nothing */;
    return dst;
#endif /* __HAVE_ARCH_STRCPY */
}
  102cf8:	83 c4 20             	add    $0x20,%esp
  102cfb:	5e                   	pop    %esi
  102cfc:	5f                   	pop    %edi
  102cfd:	5d                   	pop    %ebp
  102cfe:	c3                   	ret    

00102cff <strncpy>:
 * @len:    maximum number of characters to be copied from @src
 *
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
  102cff:	f3 0f 1e fb          	endbr32 
  102d03:	55                   	push   %ebp
  102d04:	89 e5                	mov    %esp,%ebp
  102d06:	83 ec 10             	sub    $0x10,%esp
    char *p = dst;
  102d09:	8b 45 08             	mov    0x8(%ebp),%eax
  102d0c:	89 45 fc             	mov    %eax,-0x4(%ebp)
    while (len > 0) {
  102d0f:	eb 1e                	jmp    102d2f <strncpy+0x30>
        if ((*p = *src) != '\0') {
  102d11:	8b 45 0c             	mov    0xc(%ebp),%eax
  102d14:	0f b6 10             	movzbl (%eax),%edx
  102d17:	8b 45 fc             	mov    -0x4(%ebp),%eax
  102d1a:	88 10                	mov    %dl,(%eax)
  102d1c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  102d1f:	0f b6 00             	movzbl (%eax),%eax
  102d22:	84 c0                	test   %al,%al
  102d24:	74 03                	je     102d29 <strncpy+0x2a>
            src ++;
  102d26:	ff 45 0c             	incl   0xc(%ebp)
        }
        p ++, len --;
  102d29:	ff 45 fc             	incl   -0x4(%ebp)
  102d2c:	ff 4d 10             	decl   0x10(%ebp)
    while (len > 0) {
  102d2f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  102d33:	75 dc                	jne    102d11 <strncpy+0x12>
    }
    return dst;
  102d35:	8b 45 08             	mov    0x8(%ebp),%eax
}
  102d38:	c9                   	leave  
  102d39:	c3                   	ret    

00102d3a <strcmp>:
 * - A value greater than zero indicates that the first character that does
 *   not match has a greater value in @s1 than in @s2;
 * - And a value less than zero indicates the opposite.
 * */
int
strcmp(const char *s1, const char *s2) {
  102d3a:	f3 0f 1e fb          	endbr32 
  102d3e:	55                   	push   %ebp
  102d3f:	89 e5                	mov    %esp,%ebp
  102d41:	57                   	push   %edi
  102d42:	56                   	push   %esi
  102d43:	83 ec 20             	sub    $0x20,%esp
  102d46:	8b 45 08             	mov    0x8(%ebp),%eax
  102d49:	89 45 f4             	mov    %eax,-0xc(%ebp)
  102d4c:	8b 45 0c             	mov    0xc(%ebp),%eax
  102d4f:	89 45 f0             	mov    %eax,-0x10(%ebp)
    asm volatile (
  102d52:	8b 55 f4             	mov    -0xc(%ebp),%edx
  102d55:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102d58:	89 d1                	mov    %edx,%ecx
  102d5a:	89 c2                	mov    %eax,%edx
  102d5c:	89 ce                	mov    %ecx,%esi
  102d5e:	89 d7                	mov    %edx,%edi
  102d60:	ac                   	lods   %ds:(%esi),%al
  102d61:	ae                   	scas   %es:(%edi),%al
  102d62:	75 08                	jne    102d6c <strcmp+0x32>
  102d64:	84 c0                	test   %al,%al
  102d66:	75 f8                	jne    102d60 <strcmp+0x26>
  102d68:	31 c0                	xor    %eax,%eax
  102d6a:	eb 04                	jmp    102d70 <strcmp+0x36>
  102d6c:	19 c0                	sbb    %eax,%eax
  102d6e:	0c 01                	or     $0x1,%al
  102d70:	89 fa                	mov    %edi,%edx
  102d72:	89 f1                	mov    %esi,%ecx
  102d74:	89 45 ec             	mov    %eax,-0x14(%ebp)
  102d77:	89 4d e8             	mov    %ecx,-0x18(%ebp)
  102d7a:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    return ret;
  102d7d:	8b 45 ec             	mov    -0x14(%ebp),%eax
    while (*s1 != '\0' && *s1 == *s2) {
        s1 ++, s2 ++;
    }
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
#endif /* __HAVE_ARCH_STRCMP */
}
  102d80:	83 c4 20             	add    $0x20,%esp
  102d83:	5e                   	pop    %esi
  102d84:	5f                   	pop    %edi
  102d85:	5d                   	pop    %ebp
  102d86:	c3                   	ret    

00102d87 <strncmp>:
 * they are equal to each other, it continues with the following pairs until
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
  102d87:	f3 0f 1e fb          	endbr32 
  102d8b:	55                   	push   %ebp
  102d8c:	89 e5                	mov    %esp,%ebp
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
  102d8e:	eb 09                	jmp    102d99 <strncmp+0x12>
        n --, s1 ++, s2 ++;
  102d90:	ff 4d 10             	decl   0x10(%ebp)
  102d93:	ff 45 08             	incl   0x8(%ebp)
  102d96:	ff 45 0c             	incl   0xc(%ebp)
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
  102d99:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  102d9d:	74 1a                	je     102db9 <strncmp+0x32>
  102d9f:	8b 45 08             	mov    0x8(%ebp),%eax
  102da2:	0f b6 00             	movzbl (%eax),%eax
  102da5:	84 c0                	test   %al,%al
  102da7:	74 10                	je     102db9 <strncmp+0x32>
  102da9:	8b 45 08             	mov    0x8(%ebp),%eax
  102dac:	0f b6 10             	movzbl (%eax),%edx
  102daf:	8b 45 0c             	mov    0xc(%ebp),%eax
  102db2:	0f b6 00             	movzbl (%eax),%eax
  102db5:	38 c2                	cmp    %al,%dl
  102db7:	74 d7                	je     102d90 <strncmp+0x9>
    }
    return (n == 0) ? 0 : (int)((unsigned char)*s1 - (unsigned char)*s2);
  102db9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  102dbd:	74 18                	je     102dd7 <strncmp+0x50>
  102dbf:	8b 45 08             	mov    0x8(%ebp),%eax
  102dc2:	0f b6 00             	movzbl (%eax),%eax
  102dc5:	0f b6 d0             	movzbl %al,%edx
  102dc8:	8b 45 0c             	mov    0xc(%ebp),%eax
  102dcb:	0f b6 00             	movzbl (%eax),%eax
  102dce:	0f b6 c0             	movzbl %al,%eax
  102dd1:	29 c2                	sub    %eax,%edx
  102dd3:	89 d0                	mov    %edx,%eax
  102dd5:	eb 05                	jmp    102ddc <strncmp+0x55>
  102dd7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  102ddc:	5d                   	pop    %ebp
  102ddd:	c3                   	ret    

00102dde <strchr>:
 *
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
  102dde:	f3 0f 1e fb          	endbr32 
  102de2:	55                   	push   %ebp
  102de3:	89 e5                	mov    %esp,%ebp
  102de5:	83 ec 04             	sub    $0x4,%esp
  102de8:	8b 45 0c             	mov    0xc(%ebp),%eax
  102deb:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
  102dee:	eb 13                	jmp    102e03 <strchr+0x25>
        if (*s == c) {
  102df0:	8b 45 08             	mov    0x8(%ebp),%eax
  102df3:	0f b6 00             	movzbl (%eax),%eax
  102df6:	38 45 fc             	cmp    %al,-0x4(%ebp)
  102df9:	75 05                	jne    102e00 <strchr+0x22>
            return (char *)s;
  102dfb:	8b 45 08             	mov    0x8(%ebp),%eax
  102dfe:	eb 12                	jmp    102e12 <strchr+0x34>
        }
        s ++;
  102e00:	ff 45 08             	incl   0x8(%ebp)
    while (*s != '\0') {
  102e03:	8b 45 08             	mov    0x8(%ebp),%eax
  102e06:	0f b6 00             	movzbl (%eax),%eax
  102e09:	84 c0                	test   %al,%al
  102e0b:	75 e3                	jne    102df0 <strchr+0x12>
    }
    return NULL;
  102e0d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  102e12:	c9                   	leave  
  102e13:	c3                   	ret    

00102e14 <strfind>:
 * The strfind() function is like strchr() except that if @c is
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
  102e14:	f3 0f 1e fb          	endbr32 
  102e18:	55                   	push   %ebp
  102e19:	89 e5                	mov    %esp,%ebp
  102e1b:	83 ec 04             	sub    $0x4,%esp
  102e1e:	8b 45 0c             	mov    0xc(%ebp),%eax
  102e21:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
  102e24:	eb 0e                	jmp    102e34 <strfind+0x20>
        if (*s == c) {
  102e26:	8b 45 08             	mov    0x8(%ebp),%eax
  102e29:	0f b6 00             	movzbl (%eax),%eax
  102e2c:	38 45 fc             	cmp    %al,-0x4(%ebp)
  102e2f:	74 0f                	je     102e40 <strfind+0x2c>
            break;
        }
        s ++;
  102e31:	ff 45 08             	incl   0x8(%ebp)
    while (*s != '\0') {
  102e34:	8b 45 08             	mov    0x8(%ebp),%eax
  102e37:	0f b6 00             	movzbl (%eax),%eax
  102e3a:	84 c0                	test   %al,%al
  102e3c:	75 e8                	jne    102e26 <strfind+0x12>
  102e3e:	eb 01                	jmp    102e41 <strfind+0x2d>
            break;
  102e40:	90                   	nop
    }
    return (char *)s;
  102e41:	8b 45 08             	mov    0x8(%ebp),%eax
}
  102e44:	c9                   	leave  
  102e45:	c3                   	ret    

00102e46 <strtol>:
 * an optional "0x" or "0X" prefix.
 *
 * The strtol() function returns the converted integral number as a long int value.
 * */
long
strtol(const char *s, char **endptr, int base) {
  102e46:	f3 0f 1e fb          	endbr32 
  102e4a:	55                   	push   %ebp
  102e4b:	89 e5                	mov    %esp,%ebp
  102e4d:	83 ec 10             	sub    $0x10,%esp
    int neg = 0;
  102e50:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    long val = 0;
  102e57:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
  102e5e:	eb 03                	jmp    102e63 <strtol+0x1d>
        s ++;
  102e60:	ff 45 08             	incl   0x8(%ebp)
    while (*s == ' ' || *s == '\t') {
  102e63:	8b 45 08             	mov    0x8(%ebp),%eax
  102e66:	0f b6 00             	movzbl (%eax),%eax
  102e69:	3c 20                	cmp    $0x20,%al
  102e6b:	74 f3                	je     102e60 <strtol+0x1a>
  102e6d:	8b 45 08             	mov    0x8(%ebp),%eax
  102e70:	0f b6 00             	movzbl (%eax),%eax
  102e73:	3c 09                	cmp    $0x9,%al
  102e75:	74 e9                	je     102e60 <strtol+0x1a>
    }

    // plus/minus sign
    if (*s == '+') {
  102e77:	8b 45 08             	mov    0x8(%ebp),%eax
  102e7a:	0f b6 00             	movzbl (%eax),%eax
  102e7d:	3c 2b                	cmp    $0x2b,%al
  102e7f:	75 05                	jne    102e86 <strtol+0x40>
        s ++;
  102e81:	ff 45 08             	incl   0x8(%ebp)
  102e84:	eb 14                	jmp    102e9a <strtol+0x54>
    }
    else if (*s == '-') {
  102e86:	8b 45 08             	mov    0x8(%ebp),%eax
  102e89:	0f b6 00             	movzbl (%eax),%eax
  102e8c:	3c 2d                	cmp    $0x2d,%al
  102e8e:	75 0a                	jne    102e9a <strtol+0x54>
        s ++, neg = 1;
  102e90:	ff 45 08             	incl   0x8(%ebp)
  102e93:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
    }

    // hex or octal base prefix
    if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x')) {
  102e9a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  102e9e:	74 06                	je     102ea6 <strtol+0x60>
  102ea0:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  102ea4:	75 22                	jne    102ec8 <strtol+0x82>
  102ea6:	8b 45 08             	mov    0x8(%ebp),%eax
  102ea9:	0f b6 00             	movzbl (%eax),%eax
  102eac:	3c 30                	cmp    $0x30,%al
  102eae:	75 18                	jne    102ec8 <strtol+0x82>
  102eb0:	8b 45 08             	mov    0x8(%ebp),%eax
  102eb3:	40                   	inc    %eax
  102eb4:	0f b6 00             	movzbl (%eax),%eax
  102eb7:	3c 78                	cmp    $0x78,%al
  102eb9:	75 0d                	jne    102ec8 <strtol+0x82>
        s += 2, base = 16;
  102ebb:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  102ebf:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  102ec6:	eb 29                	jmp    102ef1 <strtol+0xab>
    }
    else if (base == 0 && s[0] == '0') {
  102ec8:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  102ecc:	75 16                	jne    102ee4 <strtol+0x9e>
  102ece:	8b 45 08             	mov    0x8(%ebp),%eax
  102ed1:	0f b6 00             	movzbl (%eax),%eax
  102ed4:	3c 30                	cmp    $0x30,%al
  102ed6:	75 0c                	jne    102ee4 <strtol+0x9e>
        s ++, base = 8;
  102ed8:	ff 45 08             	incl   0x8(%ebp)
  102edb:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  102ee2:	eb 0d                	jmp    102ef1 <strtol+0xab>
    }
    else if (base == 0) {
  102ee4:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  102ee8:	75 07                	jne    102ef1 <strtol+0xab>
        base = 10;
  102eea:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

    // digits
    while (1) {
        int dig;

        if (*s >= '0' && *s <= '9') {
  102ef1:	8b 45 08             	mov    0x8(%ebp),%eax
  102ef4:	0f b6 00             	movzbl (%eax),%eax
  102ef7:	3c 2f                	cmp    $0x2f,%al
  102ef9:	7e 1b                	jle    102f16 <strtol+0xd0>
  102efb:	8b 45 08             	mov    0x8(%ebp),%eax
  102efe:	0f b6 00             	movzbl (%eax),%eax
  102f01:	3c 39                	cmp    $0x39,%al
  102f03:	7f 11                	jg     102f16 <strtol+0xd0>
            dig = *s - '0';
  102f05:	8b 45 08             	mov    0x8(%ebp),%eax
  102f08:	0f b6 00             	movzbl (%eax),%eax
  102f0b:	0f be c0             	movsbl %al,%eax
  102f0e:	83 e8 30             	sub    $0x30,%eax
  102f11:	89 45 f4             	mov    %eax,-0xc(%ebp)
  102f14:	eb 48                	jmp    102f5e <strtol+0x118>
        }
        else if (*s >= 'a' && *s <= 'z') {
  102f16:	8b 45 08             	mov    0x8(%ebp),%eax
  102f19:	0f b6 00             	movzbl (%eax),%eax
  102f1c:	3c 60                	cmp    $0x60,%al
  102f1e:	7e 1b                	jle    102f3b <strtol+0xf5>
  102f20:	8b 45 08             	mov    0x8(%ebp),%eax
  102f23:	0f b6 00             	movzbl (%eax),%eax
  102f26:	3c 7a                	cmp    $0x7a,%al
  102f28:	7f 11                	jg     102f3b <strtol+0xf5>
            dig = *s - 'a' + 10;
  102f2a:	8b 45 08             	mov    0x8(%ebp),%eax
  102f2d:	0f b6 00             	movzbl (%eax),%eax
  102f30:	0f be c0             	movsbl %al,%eax
  102f33:	83 e8 57             	sub    $0x57,%eax
  102f36:	89 45 f4             	mov    %eax,-0xc(%ebp)
  102f39:	eb 23                	jmp    102f5e <strtol+0x118>
        }
        else if (*s >= 'A' && *s <= 'Z') {
  102f3b:	8b 45 08             	mov    0x8(%ebp),%eax
  102f3e:	0f b6 00             	movzbl (%eax),%eax
  102f41:	3c 40                	cmp    $0x40,%al
  102f43:	7e 3b                	jle    102f80 <strtol+0x13a>
  102f45:	8b 45 08             	mov    0x8(%ebp),%eax
  102f48:	0f b6 00             	movzbl (%eax),%eax
  102f4b:	3c 5a                	cmp    $0x5a,%al
  102f4d:	7f 31                	jg     102f80 <strtol+0x13a>
            dig = *s - 'A' + 10;
  102f4f:	8b 45 08             	mov    0x8(%ebp),%eax
  102f52:	0f b6 00             	movzbl (%eax),%eax
  102f55:	0f be c0             	movsbl %al,%eax
  102f58:	83 e8 37             	sub    $0x37,%eax
  102f5b:	89 45 f4             	mov    %eax,-0xc(%ebp)
        }
        else {
            break;
        }
        if (dig >= base) {
  102f5e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102f61:	3b 45 10             	cmp    0x10(%ebp),%eax
  102f64:	7d 19                	jge    102f7f <strtol+0x139>
            break;
        }
        s ++, val = (val * base) + dig;
  102f66:	ff 45 08             	incl   0x8(%ebp)
  102f69:	8b 45 f8             	mov    -0x8(%ebp),%eax
  102f6c:	0f af 45 10          	imul   0x10(%ebp),%eax
  102f70:	89 c2                	mov    %eax,%edx
  102f72:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102f75:	01 d0                	add    %edx,%eax
  102f77:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while (1) {
  102f7a:	e9 72 ff ff ff       	jmp    102ef1 <strtol+0xab>
            break;
  102f7f:	90                   	nop
        // we don't properly detect overflow!
    }

    if (endptr) {
  102f80:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  102f84:	74 08                	je     102f8e <strtol+0x148>
        *endptr = (char *) s;
  102f86:	8b 45 0c             	mov    0xc(%ebp),%eax
  102f89:	8b 55 08             	mov    0x8(%ebp),%edx
  102f8c:	89 10                	mov    %edx,(%eax)
    }
    return (neg ? -val : val);
  102f8e:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  102f92:	74 07                	je     102f9b <strtol+0x155>
  102f94:	8b 45 f8             	mov    -0x8(%ebp),%eax
  102f97:	f7 d8                	neg    %eax
  102f99:	eb 03                	jmp    102f9e <strtol+0x158>
  102f9b:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  102f9e:	c9                   	leave  
  102f9f:	c3                   	ret    

00102fa0 <memset>:
 * @n:        number of bytes to be set to the value
 *
 * The memset() function returns @s.
 * */
void *
memset(void *s, char c, size_t n) {
  102fa0:	f3 0f 1e fb          	endbr32 
  102fa4:	55                   	push   %ebp
  102fa5:	89 e5                	mov    %esp,%ebp
  102fa7:	57                   	push   %edi
  102fa8:	83 ec 24             	sub    $0x24,%esp
  102fab:	8b 45 0c             	mov    0xc(%ebp),%eax
  102fae:	88 45 d8             	mov    %al,-0x28(%ebp)
#ifdef __HAVE_ARCH_MEMSET
    return __memset(s, c, n);
  102fb1:	0f be 55 d8          	movsbl -0x28(%ebp),%edx
  102fb5:	8b 45 08             	mov    0x8(%ebp),%eax
  102fb8:	89 45 f8             	mov    %eax,-0x8(%ebp)
  102fbb:	88 55 f7             	mov    %dl,-0x9(%ebp)
  102fbe:	8b 45 10             	mov    0x10(%ebp),%eax
  102fc1:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_MEMSET
#define __HAVE_ARCH_MEMSET
static inline void *
__memset(void *s, char c, size_t n) {
    int d0, d1;
    asm volatile (
  102fc4:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  102fc7:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  102fcb:	8b 55 f8             	mov    -0x8(%ebp),%edx
  102fce:	89 d7                	mov    %edx,%edi
  102fd0:	f3 aa                	rep stos %al,%es:(%edi)
  102fd2:	89 fa                	mov    %edi,%edx
  102fd4:	89 4d ec             	mov    %ecx,-0x14(%ebp)
  102fd7:	89 55 e8             	mov    %edx,-0x18(%ebp)
            "rep; stosb;"
            : "=&c" (d0), "=&D" (d1)
            : "0" (n), "a" (c), "1" (s)
            : "memory");
    return s;
  102fda:	8b 45 f8             	mov    -0x8(%ebp),%eax
    while (n -- > 0) {
        *p ++ = c;
    }
    return s;
#endif /* __HAVE_ARCH_MEMSET */
}
  102fdd:	83 c4 24             	add    $0x24,%esp
  102fe0:	5f                   	pop    %edi
  102fe1:	5d                   	pop    %ebp
  102fe2:	c3                   	ret    

00102fe3 <memmove>:
 * @n:        number of bytes to copy
 *
 * The memmove() function returns @dst.
 * */
void *
memmove(void *dst, const void *src, size_t n) {
  102fe3:	f3 0f 1e fb          	endbr32 
  102fe7:	55                   	push   %ebp
  102fe8:	89 e5                	mov    %esp,%ebp
  102fea:	57                   	push   %edi
  102feb:	56                   	push   %esi
  102fec:	53                   	push   %ebx
  102fed:	83 ec 30             	sub    $0x30,%esp
  102ff0:	8b 45 08             	mov    0x8(%ebp),%eax
  102ff3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102ff6:	8b 45 0c             	mov    0xc(%ebp),%eax
  102ff9:	89 45 ec             	mov    %eax,-0x14(%ebp)
  102ffc:	8b 45 10             	mov    0x10(%ebp),%eax
  102fff:	89 45 e8             	mov    %eax,-0x18(%ebp)

#ifndef __HAVE_ARCH_MEMMOVE
#define __HAVE_ARCH_MEMMOVE
static inline void *
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
  103002:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103005:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  103008:	73 42                	jae    10304c <memmove+0x69>
  10300a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10300d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  103010:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103013:	89 45 e0             	mov    %eax,-0x20(%ebp)
  103016:	8b 45 e8             	mov    -0x18(%ebp),%eax
  103019:	89 45 dc             	mov    %eax,-0x24(%ebp)
            "andl $3, %%ecx;"
            "jz 1f;"
            "rep; movsb;"
            "1:"
            : "=&c" (d0), "=&D" (d1), "=&S" (d2)
            : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
  10301c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10301f:	c1 e8 02             	shr    $0x2,%eax
  103022:	89 c1                	mov    %eax,%ecx
    asm volatile (
  103024:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  103027:	8b 45 e0             	mov    -0x20(%ebp),%eax
  10302a:	89 d7                	mov    %edx,%edi
  10302c:	89 c6                	mov    %eax,%esi
  10302e:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  103030:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  103033:	83 e1 03             	and    $0x3,%ecx
  103036:	74 02                	je     10303a <memmove+0x57>
  103038:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  10303a:	89 f0                	mov    %esi,%eax
  10303c:	89 fa                	mov    %edi,%edx
  10303e:	89 4d d8             	mov    %ecx,-0x28(%ebp)
  103041:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  103044:	89 45 d0             	mov    %eax,-0x30(%ebp)
            : "memory");
    return dst;
  103047:	8b 45 e4             	mov    -0x1c(%ebp),%eax
        return __memcpy(dst, src, n);
  10304a:	eb 36                	jmp    103082 <memmove+0x9f>
            : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
  10304c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10304f:	8d 50 ff             	lea    -0x1(%eax),%edx
  103052:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103055:	01 c2                	add    %eax,%edx
  103057:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10305a:	8d 48 ff             	lea    -0x1(%eax),%ecx
  10305d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103060:	8d 1c 01             	lea    (%ecx,%eax,1),%ebx
    asm volatile (
  103063:	8b 45 e8             	mov    -0x18(%ebp),%eax
  103066:	89 c1                	mov    %eax,%ecx
  103068:	89 d8                	mov    %ebx,%eax
  10306a:	89 d6                	mov    %edx,%esi
  10306c:	89 c7                	mov    %eax,%edi
  10306e:	fd                   	std    
  10306f:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  103071:	fc                   	cld    
  103072:	89 f8                	mov    %edi,%eax
  103074:	89 f2                	mov    %esi,%edx
  103076:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  103079:	89 55 c8             	mov    %edx,-0x38(%ebp)
  10307c:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    return dst;
  10307f:	8b 45 f0             	mov    -0x10(%ebp),%eax
            *d ++ = *s ++;
        }
    }
    return dst;
#endif /* __HAVE_ARCH_MEMMOVE */
}
  103082:	83 c4 30             	add    $0x30,%esp
  103085:	5b                   	pop    %ebx
  103086:	5e                   	pop    %esi
  103087:	5f                   	pop    %edi
  103088:	5d                   	pop    %ebp
  103089:	c3                   	ret    

0010308a <memcpy>:
 * it always copies exactly @n bytes. To avoid overflows, the size of arrays pointed
 * by both @src and @dst, should be at least @n bytes, and should not overlap
 * (for overlapping memory area, memmove is a safer approach).
 * */
void *
memcpy(void *dst, const void *src, size_t n) {
  10308a:	f3 0f 1e fb          	endbr32 
  10308e:	55                   	push   %ebp
  10308f:	89 e5                	mov    %esp,%ebp
  103091:	57                   	push   %edi
  103092:	56                   	push   %esi
  103093:	83 ec 20             	sub    $0x20,%esp
  103096:	8b 45 08             	mov    0x8(%ebp),%eax
  103099:	89 45 f4             	mov    %eax,-0xc(%ebp)
  10309c:	8b 45 0c             	mov    0xc(%ebp),%eax
  10309f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1030a2:	8b 45 10             	mov    0x10(%ebp),%eax
  1030a5:	89 45 ec             	mov    %eax,-0x14(%ebp)
            : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
  1030a8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1030ab:	c1 e8 02             	shr    $0x2,%eax
  1030ae:	89 c1                	mov    %eax,%ecx
    asm volatile (
  1030b0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1030b3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1030b6:	89 d7                	mov    %edx,%edi
  1030b8:	89 c6                	mov    %eax,%esi
  1030ba:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  1030bc:	8b 4d ec             	mov    -0x14(%ebp),%ecx
  1030bf:	83 e1 03             	and    $0x3,%ecx
  1030c2:	74 02                	je     1030c6 <memcpy+0x3c>
  1030c4:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  1030c6:	89 f0                	mov    %esi,%eax
  1030c8:	89 fa                	mov    %edi,%edx
  1030ca:	89 4d e8             	mov    %ecx,-0x18(%ebp)
  1030cd:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  1030d0:	89 45 e0             	mov    %eax,-0x20(%ebp)
    return dst;
  1030d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
    while (n -- > 0) {
        *d ++ = *s ++;
    }
    return dst;
#endif /* __HAVE_ARCH_MEMCPY */
}
  1030d6:	83 c4 20             	add    $0x20,%esp
  1030d9:	5e                   	pop    %esi
  1030da:	5f                   	pop    %edi
  1030db:	5d                   	pop    %ebp
  1030dc:	c3                   	ret    

001030dd <memcmp>:
 *   match in both memory blocks has a greater value in @v1 than in @v2
 *   as if evaluated as unsigned char values;
 * - And a value less than zero indicates the opposite.
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
  1030dd:	f3 0f 1e fb          	endbr32 
  1030e1:	55                   	push   %ebp
  1030e2:	89 e5                	mov    %esp,%ebp
  1030e4:	83 ec 10             	sub    $0x10,%esp
    const char *s1 = (const char *)v1;
  1030e7:	8b 45 08             	mov    0x8(%ebp),%eax
  1030ea:	89 45 fc             	mov    %eax,-0x4(%ebp)
    const char *s2 = (const char *)v2;
  1030ed:	8b 45 0c             	mov    0xc(%ebp),%eax
  1030f0:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while (n -- > 0) {
  1030f3:	eb 2e                	jmp    103123 <memcmp+0x46>
        if (*s1 != *s2) {
  1030f5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1030f8:	0f b6 10             	movzbl (%eax),%edx
  1030fb:	8b 45 f8             	mov    -0x8(%ebp),%eax
  1030fe:	0f b6 00             	movzbl (%eax),%eax
  103101:	38 c2                	cmp    %al,%dl
  103103:	74 18                	je     10311d <memcmp+0x40>
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
  103105:	8b 45 fc             	mov    -0x4(%ebp),%eax
  103108:	0f b6 00             	movzbl (%eax),%eax
  10310b:	0f b6 d0             	movzbl %al,%edx
  10310e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  103111:	0f b6 00             	movzbl (%eax),%eax
  103114:	0f b6 c0             	movzbl %al,%eax
  103117:	29 c2                	sub    %eax,%edx
  103119:	89 d0                	mov    %edx,%eax
  10311b:	eb 18                	jmp    103135 <memcmp+0x58>
        }
        s1 ++, s2 ++;
  10311d:	ff 45 fc             	incl   -0x4(%ebp)
  103120:	ff 45 f8             	incl   -0x8(%ebp)
    while (n -- > 0) {
  103123:	8b 45 10             	mov    0x10(%ebp),%eax
  103126:	8d 50 ff             	lea    -0x1(%eax),%edx
  103129:	89 55 10             	mov    %edx,0x10(%ebp)
  10312c:	85 c0                	test   %eax,%eax
  10312e:	75 c5                	jne    1030f5 <memcmp+0x18>
    }
    return 0;
  103130:	b8 00 00 00 00       	mov    $0x0,%eax
}
  103135:	c9                   	leave  
  103136:	c3                   	ret    

00103137 <printnum>:
 * @width:         maximum number of digits, if the actual width is less than @width, use @padc instead
 * @padc:        character that padded on the left if the actual width is less than @width
 * */
static void
printnum(void (*putch)(int, void*), void *putdat,
        unsigned long long num, unsigned base, int width, int padc) {
  103137:	f3 0f 1e fb          	endbr32 
  10313b:	55                   	push   %ebp
  10313c:	89 e5                	mov    %esp,%ebp
  10313e:	83 ec 58             	sub    $0x58,%esp
  103141:	8b 45 10             	mov    0x10(%ebp),%eax
  103144:	89 45 d0             	mov    %eax,-0x30(%ebp)
  103147:	8b 45 14             	mov    0x14(%ebp),%eax
  10314a:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    unsigned long long result = num;
  10314d:	8b 45 d0             	mov    -0x30(%ebp),%eax
  103150:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  103153:	89 45 e8             	mov    %eax,-0x18(%ebp)
  103156:	89 55 ec             	mov    %edx,-0x14(%ebp)
    unsigned mod = do_div(result, base);
  103159:	8b 45 18             	mov    0x18(%ebp),%eax
  10315c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  10315f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  103162:	8b 55 ec             	mov    -0x14(%ebp),%edx
  103165:	89 45 e0             	mov    %eax,-0x20(%ebp)
  103168:	89 55 f0             	mov    %edx,-0x10(%ebp)
  10316b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10316e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  103171:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  103175:	74 1c                	je     103193 <printnum+0x5c>
  103177:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10317a:	ba 00 00 00 00       	mov    $0x0,%edx
  10317f:	f7 75 e4             	divl   -0x1c(%ebp)
  103182:	89 55 f4             	mov    %edx,-0xc(%ebp)
  103185:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103188:	ba 00 00 00 00       	mov    $0x0,%edx
  10318d:	f7 75 e4             	divl   -0x1c(%ebp)
  103190:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103193:	8b 45 e0             	mov    -0x20(%ebp),%eax
  103196:	8b 55 f4             	mov    -0xc(%ebp),%edx
  103199:	f7 75 e4             	divl   -0x1c(%ebp)
  10319c:	89 45 e0             	mov    %eax,-0x20(%ebp)
  10319f:	89 55 dc             	mov    %edx,-0x24(%ebp)
  1031a2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1031a5:	8b 55 f0             	mov    -0x10(%ebp),%edx
  1031a8:	89 45 e8             	mov    %eax,-0x18(%ebp)
  1031ab:	89 55 ec             	mov    %edx,-0x14(%ebp)
  1031ae:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1031b1:	89 45 d8             	mov    %eax,-0x28(%ebp)

    // first recursively print all preceding (more significant) digits
    if (num >= base) {
  1031b4:	8b 45 18             	mov    0x18(%ebp),%eax
  1031b7:	ba 00 00 00 00       	mov    $0x0,%edx
  1031bc:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  1031bf:	39 45 d0             	cmp    %eax,-0x30(%ebp)
  1031c2:	19 d1                	sbb    %edx,%ecx
  1031c4:	72 4c                	jb     103212 <printnum+0xdb>
        printnum(putch, putdat, result, base, width - 1, padc);
  1031c6:	8b 45 1c             	mov    0x1c(%ebp),%eax
  1031c9:	8d 50 ff             	lea    -0x1(%eax),%edx
  1031cc:	8b 45 20             	mov    0x20(%ebp),%eax
  1031cf:	89 44 24 18          	mov    %eax,0x18(%esp)
  1031d3:	89 54 24 14          	mov    %edx,0x14(%esp)
  1031d7:	8b 45 18             	mov    0x18(%ebp),%eax
  1031da:	89 44 24 10          	mov    %eax,0x10(%esp)
  1031de:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1031e1:	8b 55 ec             	mov    -0x14(%ebp),%edx
  1031e4:	89 44 24 08          	mov    %eax,0x8(%esp)
  1031e8:	89 54 24 0c          	mov    %edx,0xc(%esp)
  1031ec:	8b 45 0c             	mov    0xc(%ebp),%eax
  1031ef:	89 44 24 04          	mov    %eax,0x4(%esp)
  1031f3:	8b 45 08             	mov    0x8(%ebp),%eax
  1031f6:	89 04 24             	mov    %eax,(%esp)
  1031f9:	e8 39 ff ff ff       	call   103137 <printnum>
  1031fe:	eb 1b                	jmp    10321b <printnum+0xe4>
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
            putch(padc, putdat);
  103200:	8b 45 0c             	mov    0xc(%ebp),%eax
  103203:	89 44 24 04          	mov    %eax,0x4(%esp)
  103207:	8b 45 20             	mov    0x20(%ebp),%eax
  10320a:	89 04 24             	mov    %eax,(%esp)
  10320d:	8b 45 08             	mov    0x8(%ebp),%eax
  103210:	ff d0                	call   *%eax
        while (-- width > 0)
  103212:	ff 4d 1c             	decl   0x1c(%ebp)
  103215:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  103219:	7f e5                	jg     103200 <printnum+0xc9>
    }
    // then print this (the least significant) digit
    putch("0123456789abcdef"[mod], putdat);
  10321b:	8b 45 d8             	mov    -0x28(%ebp),%eax
  10321e:	05 70 3f 10 00       	add    $0x103f70,%eax
  103223:	0f b6 00             	movzbl (%eax),%eax
  103226:	0f be c0             	movsbl %al,%eax
  103229:	8b 55 0c             	mov    0xc(%ebp),%edx
  10322c:	89 54 24 04          	mov    %edx,0x4(%esp)
  103230:	89 04 24             	mov    %eax,(%esp)
  103233:	8b 45 08             	mov    0x8(%ebp),%eax
  103236:	ff d0                	call   *%eax
}
  103238:	90                   	nop
  103239:	c9                   	leave  
  10323a:	c3                   	ret    

0010323b <getuint>:
 * getuint - get an unsigned int of various possible sizes from a varargs list
 * @ap:            a varargs list pointer
 * @lflag:        determines the size of the vararg that @ap points to
 * */
static unsigned long long
getuint(va_list *ap, int lflag) {
  10323b:	f3 0f 1e fb          	endbr32 
  10323f:	55                   	push   %ebp
  103240:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
  103242:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  103246:	7e 14                	jle    10325c <getuint+0x21>
        return va_arg(*ap, unsigned long long);
  103248:	8b 45 08             	mov    0x8(%ebp),%eax
  10324b:	8b 00                	mov    (%eax),%eax
  10324d:	8d 48 08             	lea    0x8(%eax),%ecx
  103250:	8b 55 08             	mov    0x8(%ebp),%edx
  103253:	89 0a                	mov    %ecx,(%edx)
  103255:	8b 50 04             	mov    0x4(%eax),%edx
  103258:	8b 00                	mov    (%eax),%eax
  10325a:	eb 30                	jmp    10328c <getuint+0x51>
    }
    else if (lflag) {
  10325c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  103260:	74 16                	je     103278 <getuint+0x3d>
        return va_arg(*ap, unsigned long);
  103262:	8b 45 08             	mov    0x8(%ebp),%eax
  103265:	8b 00                	mov    (%eax),%eax
  103267:	8d 48 04             	lea    0x4(%eax),%ecx
  10326a:	8b 55 08             	mov    0x8(%ebp),%edx
  10326d:	89 0a                	mov    %ecx,(%edx)
  10326f:	8b 00                	mov    (%eax),%eax
  103271:	ba 00 00 00 00       	mov    $0x0,%edx
  103276:	eb 14                	jmp    10328c <getuint+0x51>
    }
    else {
        return va_arg(*ap, unsigned int);
  103278:	8b 45 08             	mov    0x8(%ebp),%eax
  10327b:	8b 00                	mov    (%eax),%eax
  10327d:	8d 48 04             	lea    0x4(%eax),%ecx
  103280:	8b 55 08             	mov    0x8(%ebp),%edx
  103283:	89 0a                	mov    %ecx,(%edx)
  103285:	8b 00                	mov    (%eax),%eax
  103287:	ba 00 00 00 00       	mov    $0x0,%edx
    }
}
  10328c:	5d                   	pop    %ebp
  10328d:	c3                   	ret    

0010328e <getint>:
 * getint - same as getuint but signed, we can't use getuint because of sign extension
 * @ap:            a varargs list pointer
 * @lflag:        determines the size of the vararg that @ap points to
 * */
static long long
getint(va_list *ap, int lflag) {
  10328e:	f3 0f 1e fb          	endbr32 
  103292:	55                   	push   %ebp
  103293:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
  103295:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  103299:	7e 14                	jle    1032af <getint+0x21>
        return va_arg(*ap, long long);
  10329b:	8b 45 08             	mov    0x8(%ebp),%eax
  10329e:	8b 00                	mov    (%eax),%eax
  1032a0:	8d 48 08             	lea    0x8(%eax),%ecx
  1032a3:	8b 55 08             	mov    0x8(%ebp),%edx
  1032a6:	89 0a                	mov    %ecx,(%edx)
  1032a8:	8b 50 04             	mov    0x4(%eax),%edx
  1032ab:	8b 00                	mov    (%eax),%eax
  1032ad:	eb 28                	jmp    1032d7 <getint+0x49>
    }
    else if (lflag) {
  1032af:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  1032b3:	74 12                	je     1032c7 <getint+0x39>
        return va_arg(*ap, long);
  1032b5:	8b 45 08             	mov    0x8(%ebp),%eax
  1032b8:	8b 00                	mov    (%eax),%eax
  1032ba:	8d 48 04             	lea    0x4(%eax),%ecx
  1032bd:	8b 55 08             	mov    0x8(%ebp),%edx
  1032c0:	89 0a                	mov    %ecx,(%edx)
  1032c2:	8b 00                	mov    (%eax),%eax
  1032c4:	99                   	cltd   
  1032c5:	eb 10                	jmp    1032d7 <getint+0x49>
    }
    else {
        return va_arg(*ap, int);
  1032c7:	8b 45 08             	mov    0x8(%ebp),%eax
  1032ca:	8b 00                	mov    (%eax),%eax
  1032cc:	8d 48 04             	lea    0x4(%eax),%ecx
  1032cf:	8b 55 08             	mov    0x8(%ebp),%edx
  1032d2:	89 0a                	mov    %ecx,(%edx)
  1032d4:	8b 00                	mov    (%eax),%eax
  1032d6:	99                   	cltd   
    }
}
  1032d7:	5d                   	pop    %ebp
  1032d8:	c3                   	ret    

001032d9 <printfmt>:
 * @putch:        specified putch function, print a single character
 * @putdat:        used by @putch function
 * @fmt:        the format string to use
 * */
void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
  1032d9:	f3 0f 1e fb          	endbr32 
  1032dd:	55                   	push   %ebp
  1032de:	89 e5                	mov    %esp,%ebp
  1032e0:	83 ec 28             	sub    $0x28,%esp
    va_list ap;

    va_start(ap, fmt);
  1032e3:	8d 45 14             	lea    0x14(%ebp),%eax
  1032e6:	89 45 f4             	mov    %eax,-0xc(%ebp)
    vprintfmt(putch, putdat, fmt, ap);
  1032e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1032ec:	89 44 24 0c          	mov    %eax,0xc(%esp)
  1032f0:	8b 45 10             	mov    0x10(%ebp),%eax
  1032f3:	89 44 24 08          	mov    %eax,0x8(%esp)
  1032f7:	8b 45 0c             	mov    0xc(%ebp),%eax
  1032fa:	89 44 24 04          	mov    %eax,0x4(%esp)
  1032fe:	8b 45 08             	mov    0x8(%ebp),%eax
  103301:	89 04 24             	mov    %eax,(%esp)
  103304:	e8 03 00 00 00       	call   10330c <vprintfmt>
    va_end(ap);
}
  103309:	90                   	nop
  10330a:	c9                   	leave  
  10330b:	c3                   	ret    

0010330c <vprintfmt>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want printfmt() instead.
 * */
void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap) {
  10330c:	f3 0f 1e fb          	endbr32 
  103310:	55                   	push   %ebp
  103311:	89 e5                	mov    %esp,%ebp
  103313:	56                   	push   %esi
  103314:	53                   	push   %ebx
  103315:	83 ec 40             	sub    $0x40,%esp
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  103318:	eb 17                	jmp    103331 <vprintfmt+0x25>
            if (ch == '\0') {
  10331a:	85 db                	test   %ebx,%ebx
  10331c:	0f 84 c0 03 00 00    	je     1036e2 <vprintfmt+0x3d6>
                return;
            }
            putch(ch, putdat);
  103322:	8b 45 0c             	mov    0xc(%ebp),%eax
  103325:	89 44 24 04          	mov    %eax,0x4(%esp)
  103329:	89 1c 24             	mov    %ebx,(%esp)
  10332c:	8b 45 08             	mov    0x8(%ebp),%eax
  10332f:	ff d0                	call   *%eax
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  103331:	8b 45 10             	mov    0x10(%ebp),%eax
  103334:	8d 50 01             	lea    0x1(%eax),%edx
  103337:	89 55 10             	mov    %edx,0x10(%ebp)
  10333a:	0f b6 00             	movzbl (%eax),%eax
  10333d:	0f b6 d8             	movzbl %al,%ebx
  103340:	83 fb 25             	cmp    $0x25,%ebx
  103343:	75 d5                	jne    10331a <vprintfmt+0xe>
        }

        // Process a %-escape sequence
        char padc = ' ';
  103345:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
        width = precision = -1;
  103349:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  103350:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103353:	89 45 e8             	mov    %eax,-0x18(%ebp)
        lflag = altflag = 0;
  103356:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  10335d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  103360:	89 45 e0             	mov    %eax,-0x20(%ebp)

    reswitch:
        switch (ch = *(unsigned char *)fmt ++) {
  103363:	8b 45 10             	mov    0x10(%ebp),%eax
  103366:	8d 50 01             	lea    0x1(%eax),%edx
  103369:	89 55 10             	mov    %edx,0x10(%ebp)
  10336c:	0f b6 00             	movzbl (%eax),%eax
  10336f:	0f b6 d8             	movzbl %al,%ebx
  103372:	8d 43 dd             	lea    -0x23(%ebx),%eax
  103375:	83 f8 55             	cmp    $0x55,%eax
  103378:	0f 87 38 03 00 00    	ja     1036b6 <vprintfmt+0x3aa>
  10337e:	8b 04 85 94 3f 10 00 	mov    0x103f94(,%eax,4),%eax
  103385:	3e ff e0             	notrack jmp *%eax

        // flag to pad on the right
        case '-':
            padc = '-';
  103388:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
            goto reswitch;
  10338c:	eb d5                	jmp    103363 <vprintfmt+0x57>

        // flag to pad with 0's instead of spaces
        case '0':
            padc = '0';
  10338e:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
            goto reswitch;
  103392:	eb cf                	jmp    103363 <vprintfmt+0x57>

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
  103394:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
                precision = precision * 10 + ch - '0';
  10339b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  10339e:	89 d0                	mov    %edx,%eax
  1033a0:	c1 e0 02             	shl    $0x2,%eax
  1033a3:	01 d0                	add    %edx,%eax
  1033a5:	01 c0                	add    %eax,%eax
  1033a7:	01 d8                	add    %ebx,%eax
  1033a9:	83 e8 30             	sub    $0x30,%eax
  1033ac:	89 45 e4             	mov    %eax,-0x1c(%ebp)
                ch = *fmt;
  1033af:	8b 45 10             	mov    0x10(%ebp),%eax
  1033b2:	0f b6 00             	movzbl (%eax),%eax
  1033b5:	0f be d8             	movsbl %al,%ebx
                if (ch < '0' || ch > '9') {
  1033b8:	83 fb 2f             	cmp    $0x2f,%ebx
  1033bb:	7e 38                	jle    1033f5 <vprintfmt+0xe9>
  1033bd:	83 fb 39             	cmp    $0x39,%ebx
  1033c0:	7f 33                	jg     1033f5 <vprintfmt+0xe9>
            for (precision = 0; ; ++ fmt) {
  1033c2:	ff 45 10             	incl   0x10(%ebp)
                precision = precision * 10 + ch - '0';
  1033c5:	eb d4                	jmp    10339b <vprintfmt+0x8f>
                }
            }
            goto process_precision;

        case '*':
            precision = va_arg(ap, int);
  1033c7:	8b 45 14             	mov    0x14(%ebp),%eax
  1033ca:	8d 50 04             	lea    0x4(%eax),%edx
  1033cd:	89 55 14             	mov    %edx,0x14(%ebp)
  1033d0:	8b 00                	mov    (%eax),%eax
  1033d2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            goto process_precision;
  1033d5:	eb 1f                	jmp    1033f6 <vprintfmt+0xea>

        case '.':
            if (width < 0)
  1033d7:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  1033db:	79 86                	jns    103363 <vprintfmt+0x57>
                width = 0;
  1033dd:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
            goto reswitch;
  1033e4:	e9 7a ff ff ff       	jmp    103363 <vprintfmt+0x57>

        case '#':
            altflag = 1;
  1033e9:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
            goto reswitch;
  1033f0:	e9 6e ff ff ff       	jmp    103363 <vprintfmt+0x57>
            goto process_precision;
  1033f5:	90                   	nop

        process_precision:
            if (width < 0)
  1033f6:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  1033fa:	0f 89 63 ff ff ff    	jns    103363 <vprintfmt+0x57>
                width = precision, precision = -1;
  103400:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103403:	89 45 e8             	mov    %eax,-0x18(%ebp)
  103406:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
            goto reswitch;
  10340d:	e9 51 ff ff ff       	jmp    103363 <vprintfmt+0x57>

        // long flag (doubled for long long)
        case 'l':
            lflag ++;
  103412:	ff 45 e0             	incl   -0x20(%ebp)
            goto reswitch;
  103415:	e9 49 ff ff ff       	jmp    103363 <vprintfmt+0x57>

        // character
        case 'c':
            putch(va_arg(ap, int), putdat);
  10341a:	8b 45 14             	mov    0x14(%ebp),%eax
  10341d:	8d 50 04             	lea    0x4(%eax),%edx
  103420:	89 55 14             	mov    %edx,0x14(%ebp)
  103423:	8b 00                	mov    (%eax),%eax
  103425:	8b 55 0c             	mov    0xc(%ebp),%edx
  103428:	89 54 24 04          	mov    %edx,0x4(%esp)
  10342c:	89 04 24             	mov    %eax,(%esp)
  10342f:	8b 45 08             	mov    0x8(%ebp),%eax
  103432:	ff d0                	call   *%eax
            break;
  103434:	e9 a4 02 00 00       	jmp    1036dd <vprintfmt+0x3d1>

        // error message
        case 'e':
            err = va_arg(ap, int);
  103439:	8b 45 14             	mov    0x14(%ebp),%eax
  10343c:	8d 50 04             	lea    0x4(%eax),%edx
  10343f:	89 55 14             	mov    %edx,0x14(%ebp)
  103442:	8b 18                	mov    (%eax),%ebx
            if (err < 0) {
  103444:	85 db                	test   %ebx,%ebx
  103446:	79 02                	jns    10344a <vprintfmt+0x13e>
                err = -err;
  103448:	f7 db                	neg    %ebx
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
  10344a:	83 fb 06             	cmp    $0x6,%ebx
  10344d:	7f 0b                	jg     10345a <vprintfmt+0x14e>
  10344f:	8b 34 9d 54 3f 10 00 	mov    0x103f54(,%ebx,4),%esi
  103456:	85 f6                	test   %esi,%esi
  103458:	75 23                	jne    10347d <vprintfmt+0x171>
                printfmt(putch, putdat, "error %d", err);
  10345a:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  10345e:	c7 44 24 08 81 3f 10 	movl   $0x103f81,0x8(%esp)
  103465:	00 
  103466:	8b 45 0c             	mov    0xc(%ebp),%eax
  103469:	89 44 24 04          	mov    %eax,0x4(%esp)
  10346d:	8b 45 08             	mov    0x8(%ebp),%eax
  103470:	89 04 24             	mov    %eax,(%esp)
  103473:	e8 61 fe ff ff       	call   1032d9 <printfmt>
            }
            else {
                printfmt(putch, putdat, "%s", p);
            }
            break;
  103478:	e9 60 02 00 00       	jmp    1036dd <vprintfmt+0x3d1>
                printfmt(putch, putdat, "%s", p);
  10347d:	89 74 24 0c          	mov    %esi,0xc(%esp)
  103481:	c7 44 24 08 8a 3f 10 	movl   $0x103f8a,0x8(%esp)
  103488:	00 
  103489:	8b 45 0c             	mov    0xc(%ebp),%eax
  10348c:	89 44 24 04          	mov    %eax,0x4(%esp)
  103490:	8b 45 08             	mov    0x8(%ebp),%eax
  103493:	89 04 24             	mov    %eax,(%esp)
  103496:	e8 3e fe ff ff       	call   1032d9 <printfmt>
            break;
  10349b:	e9 3d 02 00 00       	jmp    1036dd <vprintfmt+0x3d1>

        // string
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
  1034a0:	8b 45 14             	mov    0x14(%ebp),%eax
  1034a3:	8d 50 04             	lea    0x4(%eax),%edx
  1034a6:	89 55 14             	mov    %edx,0x14(%ebp)
  1034a9:	8b 30                	mov    (%eax),%esi
  1034ab:	85 f6                	test   %esi,%esi
  1034ad:	75 05                	jne    1034b4 <vprintfmt+0x1a8>
                p = "(null)";
  1034af:	be 8d 3f 10 00       	mov    $0x103f8d,%esi
            }
            if (width > 0 && padc != '-') {
  1034b4:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  1034b8:	7e 76                	jle    103530 <vprintfmt+0x224>
  1034ba:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  1034be:	74 70                	je     103530 <vprintfmt+0x224>
                for (width -= strnlen(p, precision); width > 0; width --) {
  1034c0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1034c3:	89 44 24 04          	mov    %eax,0x4(%esp)
  1034c7:	89 34 24             	mov    %esi,(%esp)
  1034ca:	e8 ba f7 ff ff       	call   102c89 <strnlen>
  1034cf:	8b 55 e8             	mov    -0x18(%ebp),%edx
  1034d2:	29 c2                	sub    %eax,%edx
  1034d4:	89 d0                	mov    %edx,%eax
  1034d6:	89 45 e8             	mov    %eax,-0x18(%ebp)
  1034d9:	eb 16                	jmp    1034f1 <vprintfmt+0x1e5>
                    putch(padc, putdat);
  1034db:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  1034df:	8b 55 0c             	mov    0xc(%ebp),%edx
  1034e2:	89 54 24 04          	mov    %edx,0x4(%esp)
  1034e6:	89 04 24             	mov    %eax,(%esp)
  1034e9:	8b 45 08             	mov    0x8(%ebp),%eax
  1034ec:	ff d0                	call   *%eax
                for (width -= strnlen(p, precision); width > 0; width --) {
  1034ee:	ff 4d e8             	decl   -0x18(%ebp)
  1034f1:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  1034f5:	7f e4                	jg     1034db <vprintfmt+0x1cf>
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  1034f7:	eb 37                	jmp    103530 <vprintfmt+0x224>
                if (altflag && (ch < ' ' || ch > '~')) {
  1034f9:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  1034fd:	74 1f                	je     10351e <vprintfmt+0x212>
  1034ff:	83 fb 1f             	cmp    $0x1f,%ebx
  103502:	7e 05                	jle    103509 <vprintfmt+0x1fd>
  103504:	83 fb 7e             	cmp    $0x7e,%ebx
  103507:	7e 15                	jle    10351e <vprintfmt+0x212>
                    putch('?', putdat);
  103509:	8b 45 0c             	mov    0xc(%ebp),%eax
  10350c:	89 44 24 04          	mov    %eax,0x4(%esp)
  103510:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  103517:	8b 45 08             	mov    0x8(%ebp),%eax
  10351a:	ff d0                	call   *%eax
  10351c:	eb 0f                	jmp    10352d <vprintfmt+0x221>
                }
                else {
                    putch(ch, putdat);
  10351e:	8b 45 0c             	mov    0xc(%ebp),%eax
  103521:	89 44 24 04          	mov    %eax,0x4(%esp)
  103525:	89 1c 24             	mov    %ebx,(%esp)
  103528:	8b 45 08             	mov    0x8(%ebp),%eax
  10352b:	ff d0                	call   *%eax
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  10352d:	ff 4d e8             	decl   -0x18(%ebp)
  103530:	89 f0                	mov    %esi,%eax
  103532:	8d 70 01             	lea    0x1(%eax),%esi
  103535:	0f b6 00             	movzbl (%eax),%eax
  103538:	0f be d8             	movsbl %al,%ebx
  10353b:	85 db                	test   %ebx,%ebx
  10353d:	74 27                	je     103566 <vprintfmt+0x25a>
  10353f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  103543:	78 b4                	js     1034f9 <vprintfmt+0x1ed>
  103545:	ff 4d e4             	decl   -0x1c(%ebp)
  103548:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  10354c:	79 ab                	jns    1034f9 <vprintfmt+0x1ed>
                }
            }
            for (; width > 0; width --) {
  10354e:	eb 16                	jmp    103566 <vprintfmt+0x25a>
                putch(' ', putdat);
  103550:	8b 45 0c             	mov    0xc(%ebp),%eax
  103553:	89 44 24 04          	mov    %eax,0x4(%esp)
  103557:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  10355e:	8b 45 08             	mov    0x8(%ebp),%eax
  103561:	ff d0                	call   *%eax
            for (; width > 0; width --) {
  103563:	ff 4d e8             	decl   -0x18(%ebp)
  103566:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  10356a:	7f e4                	jg     103550 <vprintfmt+0x244>
            }
            break;
  10356c:	e9 6c 01 00 00       	jmp    1036dd <vprintfmt+0x3d1>

        // (signed) decimal
        case 'd':
            num = getint(&ap, lflag);
  103571:	8b 45 e0             	mov    -0x20(%ebp),%eax
  103574:	89 44 24 04          	mov    %eax,0x4(%esp)
  103578:	8d 45 14             	lea    0x14(%ebp),%eax
  10357b:	89 04 24             	mov    %eax,(%esp)
  10357e:	e8 0b fd ff ff       	call   10328e <getint>
  103583:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103586:	89 55 f4             	mov    %edx,-0xc(%ebp)
            if ((long long)num < 0) {
  103589:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10358c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  10358f:	85 d2                	test   %edx,%edx
  103591:	79 26                	jns    1035b9 <vprintfmt+0x2ad>
                putch('-', putdat);
  103593:	8b 45 0c             	mov    0xc(%ebp),%eax
  103596:	89 44 24 04          	mov    %eax,0x4(%esp)
  10359a:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  1035a1:	8b 45 08             	mov    0x8(%ebp),%eax
  1035a4:	ff d0                	call   *%eax
                num = -(long long)num;
  1035a6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1035a9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1035ac:	f7 d8                	neg    %eax
  1035ae:	83 d2 00             	adc    $0x0,%edx
  1035b1:	f7 da                	neg    %edx
  1035b3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1035b6:	89 55 f4             	mov    %edx,-0xc(%ebp)
            }
            base = 10;
  1035b9:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
  1035c0:	e9 a8 00 00 00       	jmp    10366d <vprintfmt+0x361>

        // unsigned decimal
        case 'u':
            num = getuint(&ap, lflag);
  1035c5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1035c8:	89 44 24 04          	mov    %eax,0x4(%esp)
  1035cc:	8d 45 14             	lea    0x14(%ebp),%eax
  1035cf:	89 04 24             	mov    %eax,(%esp)
  1035d2:	e8 64 fc ff ff       	call   10323b <getuint>
  1035d7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1035da:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 10;
  1035dd:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
  1035e4:	e9 84 00 00 00       	jmp    10366d <vprintfmt+0x361>

        // (unsigned) octal
        case 'o':
            num = getuint(&ap, lflag);
  1035e9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1035ec:	89 44 24 04          	mov    %eax,0x4(%esp)
  1035f0:	8d 45 14             	lea    0x14(%ebp),%eax
  1035f3:	89 04 24             	mov    %eax,(%esp)
  1035f6:	e8 40 fc ff ff       	call   10323b <getuint>
  1035fb:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1035fe:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 8;
  103601:	c7 45 ec 08 00 00 00 	movl   $0x8,-0x14(%ebp)
            goto number;
  103608:	eb 63                	jmp    10366d <vprintfmt+0x361>

        // pointer
        case 'p':
            putch('0', putdat);
  10360a:	8b 45 0c             	mov    0xc(%ebp),%eax
  10360d:	89 44 24 04          	mov    %eax,0x4(%esp)
  103611:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  103618:	8b 45 08             	mov    0x8(%ebp),%eax
  10361b:	ff d0                	call   *%eax
            putch('x', putdat);
  10361d:	8b 45 0c             	mov    0xc(%ebp),%eax
  103620:	89 44 24 04          	mov    %eax,0x4(%esp)
  103624:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  10362b:	8b 45 08             	mov    0x8(%ebp),%eax
  10362e:	ff d0                	call   *%eax
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
  103630:	8b 45 14             	mov    0x14(%ebp),%eax
  103633:	8d 50 04             	lea    0x4(%eax),%edx
  103636:	89 55 14             	mov    %edx,0x14(%ebp)
  103639:	8b 00                	mov    (%eax),%eax
  10363b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  10363e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
            base = 16;
  103645:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
            goto number;
  10364c:	eb 1f                	jmp    10366d <vprintfmt+0x361>

        // (unsigned) hexadecimal
        case 'x':
            num = getuint(&ap, lflag);
  10364e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  103651:	89 44 24 04          	mov    %eax,0x4(%esp)
  103655:	8d 45 14             	lea    0x14(%ebp),%eax
  103658:	89 04 24             	mov    %eax,(%esp)
  10365b:	e8 db fb ff ff       	call   10323b <getuint>
  103660:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103663:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 16;
  103666:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
        number:
            printnum(putch, putdat, num, base, width, padc);
  10366d:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  103671:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103674:	89 54 24 18          	mov    %edx,0x18(%esp)
  103678:	8b 55 e8             	mov    -0x18(%ebp),%edx
  10367b:	89 54 24 14          	mov    %edx,0x14(%esp)
  10367f:	89 44 24 10          	mov    %eax,0x10(%esp)
  103683:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103686:	8b 55 f4             	mov    -0xc(%ebp),%edx
  103689:	89 44 24 08          	mov    %eax,0x8(%esp)
  10368d:	89 54 24 0c          	mov    %edx,0xc(%esp)
  103691:	8b 45 0c             	mov    0xc(%ebp),%eax
  103694:	89 44 24 04          	mov    %eax,0x4(%esp)
  103698:	8b 45 08             	mov    0x8(%ebp),%eax
  10369b:	89 04 24             	mov    %eax,(%esp)
  10369e:	e8 94 fa ff ff       	call   103137 <printnum>
            break;
  1036a3:	eb 38                	jmp    1036dd <vprintfmt+0x3d1>

        // escaped '%' character
        case '%':
            putch(ch, putdat);
  1036a5:	8b 45 0c             	mov    0xc(%ebp),%eax
  1036a8:	89 44 24 04          	mov    %eax,0x4(%esp)
  1036ac:	89 1c 24             	mov    %ebx,(%esp)
  1036af:	8b 45 08             	mov    0x8(%ebp),%eax
  1036b2:	ff d0                	call   *%eax
            break;
  1036b4:	eb 27                	jmp    1036dd <vprintfmt+0x3d1>

        // unrecognized escape sequence - just print it literally
        default:
            putch('%', putdat);
  1036b6:	8b 45 0c             	mov    0xc(%ebp),%eax
  1036b9:	89 44 24 04          	mov    %eax,0x4(%esp)
  1036bd:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  1036c4:	8b 45 08             	mov    0x8(%ebp),%eax
  1036c7:	ff d0                	call   *%eax
            for (fmt --; fmt[-1] != '%'; fmt --)
  1036c9:	ff 4d 10             	decl   0x10(%ebp)
  1036cc:	eb 03                	jmp    1036d1 <vprintfmt+0x3c5>
  1036ce:	ff 4d 10             	decl   0x10(%ebp)
  1036d1:	8b 45 10             	mov    0x10(%ebp),%eax
  1036d4:	48                   	dec    %eax
  1036d5:	0f b6 00             	movzbl (%eax),%eax
  1036d8:	3c 25                	cmp    $0x25,%al
  1036da:	75 f2                	jne    1036ce <vprintfmt+0x3c2>
                /* do nothing */;
            break;
  1036dc:	90                   	nop
    while (1) {
  1036dd:	e9 36 fc ff ff       	jmp    103318 <vprintfmt+0xc>
                return;
  1036e2:	90                   	nop
        }
    }
}
  1036e3:	83 c4 40             	add    $0x40,%esp
  1036e6:	5b                   	pop    %ebx
  1036e7:	5e                   	pop    %esi
  1036e8:	5d                   	pop    %ebp
  1036e9:	c3                   	ret    

001036ea <sprintputch>:
 * sprintputch - 'print' a single character in a buffer
 * @ch:            the character will be printed
 * @b:            the buffer to place the character @ch
 * */
static void
sprintputch(int ch, struct sprintbuf *b) {
  1036ea:	f3 0f 1e fb          	endbr32 
  1036ee:	55                   	push   %ebp
  1036ef:	89 e5                	mov    %esp,%ebp
    b->cnt ++;
  1036f1:	8b 45 0c             	mov    0xc(%ebp),%eax
  1036f4:	8b 40 08             	mov    0x8(%eax),%eax
  1036f7:	8d 50 01             	lea    0x1(%eax),%edx
  1036fa:	8b 45 0c             	mov    0xc(%ebp),%eax
  1036fd:	89 50 08             	mov    %edx,0x8(%eax)
    if (b->buf < b->ebuf) {
  103700:	8b 45 0c             	mov    0xc(%ebp),%eax
  103703:	8b 10                	mov    (%eax),%edx
  103705:	8b 45 0c             	mov    0xc(%ebp),%eax
  103708:	8b 40 04             	mov    0x4(%eax),%eax
  10370b:	39 c2                	cmp    %eax,%edx
  10370d:	73 12                	jae    103721 <sprintputch+0x37>
        *b->buf ++ = ch;
  10370f:	8b 45 0c             	mov    0xc(%ebp),%eax
  103712:	8b 00                	mov    (%eax),%eax
  103714:	8d 48 01             	lea    0x1(%eax),%ecx
  103717:	8b 55 0c             	mov    0xc(%ebp),%edx
  10371a:	89 0a                	mov    %ecx,(%edx)
  10371c:	8b 55 08             	mov    0x8(%ebp),%edx
  10371f:	88 10                	mov    %dl,(%eax)
    }
}
  103721:	90                   	nop
  103722:	5d                   	pop    %ebp
  103723:	c3                   	ret    

00103724 <snprintf>:
 * @str:        the buffer to place the result into
 * @size:        the size of buffer, including the trailing null space
 * @fmt:        the format string to use
 * */
int
snprintf(char *str, size_t size, const char *fmt, ...) {
  103724:	f3 0f 1e fb          	endbr32 
  103728:	55                   	push   %ebp
  103729:	89 e5                	mov    %esp,%ebp
  10372b:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
  10372e:	8d 45 14             	lea    0x14(%ebp),%eax
  103731:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vsnprintf(str, size, fmt, ap);
  103734:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103737:	89 44 24 0c          	mov    %eax,0xc(%esp)
  10373b:	8b 45 10             	mov    0x10(%ebp),%eax
  10373e:	89 44 24 08          	mov    %eax,0x8(%esp)
  103742:	8b 45 0c             	mov    0xc(%ebp),%eax
  103745:	89 44 24 04          	mov    %eax,0x4(%esp)
  103749:	8b 45 08             	mov    0x8(%ebp),%eax
  10374c:	89 04 24             	mov    %eax,(%esp)
  10374f:	e8 08 00 00 00       	call   10375c <vsnprintf>
  103754:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
  103757:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  10375a:	c9                   	leave  
  10375b:	c3                   	ret    

0010375c <vsnprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want snprintf() instead.
 * */
int
vsnprintf(char *str, size_t size, const char *fmt, va_list ap) {
  10375c:	f3 0f 1e fb          	endbr32 
  103760:	55                   	push   %ebp
  103761:	89 e5                	mov    %esp,%ebp
  103763:	83 ec 28             	sub    $0x28,%esp
    struct sprintbuf b = {str, str + size - 1, 0};
  103766:	8b 45 08             	mov    0x8(%ebp),%eax
  103769:	89 45 ec             	mov    %eax,-0x14(%ebp)
  10376c:	8b 45 0c             	mov    0xc(%ebp),%eax
  10376f:	8d 50 ff             	lea    -0x1(%eax),%edx
  103772:	8b 45 08             	mov    0x8(%ebp),%eax
  103775:	01 d0                	add    %edx,%eax
  103777:	89 45 f0             	mov    %eax,-0x10(%ebp)
  10377a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if (str == NULL || b.buf > b.ebuf) {
  103781:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  103785:	74 0a                	je     103791 <vsnprintf+0x35>
  103787:	8b 55 ec             	mov    -0x14(%ebp),%edx
  10378a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10378d:	39 c2                	cmp    %eax,%edx
  10378f:	76 07                	jbe    103798 <vsnprintf+0x3c>
        return -E_INVAL;
  103791:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  103796:	eb 2a                	jmp    1037c2 <vsnprintf+0x66>
    }
    // print the string to the buffer
    vprintfmt((void*)sprintputch, &b, fmt, ap);
  103798:	8b 45 14             	mov    0x14(%ebp),%eax
  10379b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  10379f:	8b 45 10             	mov    0x10(%ebp),%eax
  1037a2:	89 44 24 08          	mov    %eax,0x8(%esp)
  1037a6:	8d 45 ec             	lea    -0x14(%ebp),%eax
  1037a9:	89 44 24 04          	mov    %eax,0x4(%esp)
  1037ad:	c7 04 24 ea 36 10 00 	movl   $0x1036ea,(%esp)
  1037b4:	e8 53 fb ff ff       	call   10330c <vprintfmt>
    // null terminate the buffer
    *b.buf = '\0';
  1037b9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1037bc:	c6 00 00             	movb   $0x0,(%eax)
    return b.cnt;
  1037bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  1037c2:	c9                   	leave  
  1037c3:	c3                   	ret    
