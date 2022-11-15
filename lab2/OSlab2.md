# OSlab2--by：孙博言，王辰旭，侯宇睿

实验一过后大家做出来了一个可以启动的系统，实验二主要涉及操作系统的物理内存管理。 操作系统为了使用内存，还需高效地管理内存资源。在实验二中大家会了解并且自己动手完 成一个简单的物理内存管理系统。

实验目的如下

- 理解基于段页式内存地址的转换机制
- 理解页表的建立和使用方法
- 理解物理内存的管理方法

## 遇到的问题和bug

- 在完成练习一时，在进行物理内存空间初始化、分配、释放时，只对页进行了初始化设置，忘记对其在空表中进行操作。
- 在完成练习三时，忘记在页表移除后使其在tlb中无效。
- 要充分讨论不同可能性，如练习二中需讨论访问的页表是否存在，练习三中需讨论页是否被其他进程使用；此外，尤其注意边界条件的判断，如在Fisrt Fit算法的块合并过程中，如果是地址最大的块，则停止向后合并。
- challenge1中ppn（页结构偏移量）的计算出错，原因是对int offset = page - base的结果又除以了sizeof(struct Page)，实际上不需要。
- challenge1中buddy_nr_free_pages()计算出错，原因是未对变量进行初始化，很低级的错误。
- challenge1中buddy_alloc_pages()时没有对搜索到的空闲块进行分割，并返回最合适大小。应该参照代码样例，在二叉树进行搜索时，将路径上完整的空闲块进行对半分割，并从原链表中取下，双双放进新链表中。
- challenge1中buddy_init_mmap()时没有将传入的大空闲块分割成大小为1的空闲块，就在链表和二叉树中插入，导致二叉树中的节点值未能正确更新。应该按照单个页大小分割，并调用buddy_free_pages()。因为二叉树初始化时节点内容均为0。
- challenge1中buddy_free_pages()时，没有从下至上对能够合并的空闲块进行合并，应当在放回之后检查上层节点的记录并更新。还要在从原链表中双双取出，合并并更新page->property后放进新链表。
- challenge1的测试中，应当在pmm.c中正确包含头文件为buddy_pmm.h，再在init_pmm_manager()中设定pmm_mamager=&buddy_pmm_manager。
- challenge1的测试样例中应当能够打印二叉树和多个链表的基础信息。

## 练习1：实现first-fit连续物理内存分配算法(需要编程)

> 在实现first fit 内存分配算法的回收函数时，要考虑地址连续的空闲块之间的合并操作。提示: 在建立空闲页块链表时，需要按照空闲页块起始地址来排序，形成一个有序的链表。可能会 修改default_pmm.c中的default_init，default_init_memmap，default_alloc_pages， default_free_pages等相关函数。请仔细查看和理解default_pmm.c中的注释。
>
> 请在实验报告中简要说明你的设计实现过程。请回答如下问题：
>
> - 你的first fit算法是否有进一步的改进空间

当ucore被启动之后，最重要的事情就是知道还有多少内存可用，一般来说，获取内存大小的方法由BIOS中断调用和直接探测两种。BIOS中断调用方法是一般只能在实模式下完成，而直接探测方法必须在保护模式下完成。ucore是通过BIOS中断调用来帮助完成的，由于BIOS中断调用必须在实模式下进行，所以在bootloader进入保护模式前完成这部分工作相对比较合适。通过BIOS中断获取内存可调用参数为e820h的INT 15h BIOS中断，BIOS通过系统内存映射地址描述符（Address Range Descriptor）格式来表示系统物理内存布局。探测功能在bootasm.S中实现：

``` c
probe_memory:

    movl $0, 0x8000 //对0x8000处的32位单元清零,即给位于0x8000处的struct e820map的成员变量nr_map清零
    xorl %ebx, %ebx 
    movw $0x8004, %di //表示设置调用INT 15h BIOS中断后，BIOS返回的映射地址描述符的起始地址
start_probe:
    movl $0xE820, %eax //INT 15的中断调用参数
    movl $20, %ecx //设置地址范围描述符的大小为20字节，其大小等于struct e820map的成员变量map的大小
    movl $SMAP, %edx //设置edx为534D4150h (即4个ASCII字符“SMAP”)，这是一个约定
    int $0x15 //调用int 0x15中断，要求BIOS返回一个用地址范围描述符表示的内存段信息
    jnc cont //如果eflags的CF位为0，则表示还有内存段需要探测
    movw $12345, 0x8000 //探测有问题，结束探测
    jmp finish_probe 
cont:
    addw $20, %di //设置下一个BIOS返回的映射地址描述符的起始地址
    incl 0x8000 //递增struct e820map的成员变量nr_map
    cmpl $0, %ebx //如果INT0x15返回的ebx为零，表示探测结束，否则继续探测
    jnz start_probe
finish_probe:    

```

探查出的信息存放在物理地址0x8000，程序使用结构体struct e820map作为保存地址范围描述符结构的缓冲区来保存内存布局，e820map定义在kern/mm/memlayout.h：

``` c
// some constants for bios interrupt 15h AX = 0xE820
#define E820MAX             20      // number of entries in E820MAP
#define E820_ARM            1       // address range memory
#define E820_ARR            2       // address range reserved

struct e820map {
    int nr_map;
    struct {
        uint64_t addr;
        uint64_t size;
        uint32_t type;
    } __attribute__((packed)) map[E820MAX];
};

```

完成物理内存页管理初始化工作后，其物理地址的分布空间如下:

```
+----------------------+ <- 0xFFFFFFFF(4GB)       ----------------------------  4GB
|  一些保留内存，例如用于|                                保留空间
|   32bit设备映射空间等  |
+----------------------+ <- 实际物理内存空间结束地址 ----------------------------
|                      |
|                      |
|     用于分配的         |                                 可用的空间
|    空闲内存区域        |
|                      |
|                      |
|                      |
+----------------------+ <- 空闲内存起始地址      ----------------------------  
|     VPT页表存放位置      |                                VPT页表存放的空间   (4MB左右)
+----------------------+ <- bss段结束处           ----------------------------
|uCore的text、data、bss |                              uCore各段的空间
+----------------------+ <- 0x00100000(1MB)       ---------------------------- 1MB
|       BIOS ROM       |
+----------------------+ <- 0x000F0000(960KB)
|     16bit设备扩展ROM  |                             显存与其他ROM映射的空间
+----------------------+ <- 0x000C0000(768KB)
|     CGA显存空间       |
+----------------------+ <- 0x000B8000            ---------------------------- 736KB
|        空闲内存       |
+----------------------+ <- 0x00011000(+4KB)          uCore header的内存空间
| uCore的ELF header数据 |
+----------------------+ <-0x00010000             ---------------------------- 64KB
|       空闲内存        |
+----------------------+ <- 基于bootloader的大小          bootloader的
|      bootloader的   |                                    内存空间
|     text段和data段    |
+----------------------+ <- 0x00007C00            ---------------------------- 31KB
|   bootloader和uCore  |
|      共用的堆栈       |                                 堆栈的内存空间
+----------------------+ <- 基于栈的使用情况
|     低地址空闲空间    |
+----------------------+ <-  0x00000000           ---------------------------- 0KB

```

物理内存页管理器顺着双向链表进行搜索空闲内存区域，直到找到一个足够大的空闲区域，因为它尽可能少地搜索链表。如果空闲区域的大小和申请分配的大小正好一样，则把这个空闲区域分配出去，成功返回；否则将该空闲区分为两部分，一部分区域与申请分配的大小相等，把它分配出去，剩下的一部分区域形成新的空闲区。其释放内存的设计思路很简单，只需把这块区域重新放回双向链表中即可。

ucore中采用面向对象编程的思想，将物理内存管理的内容抽象成若干个特定的函数，并以结构体pmm_manager作为物理内存管理器封装各个内存管理函数的指针，这样在管理物理内存时只需调用结构体内封装的函数，从而可将内存管理功能的具体实现与系统中其他部分隔离开。pmm_manager中保存的函数及其功能如下所述：

```c
struct pmm_manager {
    const char *name;                                 /*某种物理内存管理器的名称（可根据算法等具体实现的不同自定义新的内存管理器，这样也更加符合面向对象的思想）*/
    void (*init)(void);                               /*物理内存管理器初始化，包括生成内部描述和数据结构（空闲块链表和空闲页总数）*/ 
    void (*init_memmap)(struct Page *base, size_t n); /*初始化空闲页，根据初始时的空闲物理内存区域将页映射到物理内存上*/
    struct Page *(*alloc_pages)(size_t n);            //申请分配指定数量的物理页
    void (*free_pages)(struct Page *base, size_t n);  //申请释放若干指定物理页
    size_t (*nr_free_pages)(void);                    //查询当前空闲页总数
    void (*check)(void);                              //检查物理内存管理器的正确性
};
```

接下来对结构体中的各个部分的注释进行解释：

const char *name:某种物理内存管理器的名称（可根据算法等具体实现的不同自定义新的内存管理器)

*void (*init)(void):物理内存管理器初始化，包括生成内部描述和数据结构（空闲块链表和空闲页总数）

void (*init_memmap)(struct Page *base, size_t n):初始化空闲页，根据初始时的空闲物理内存区域将页映射到物理内存上

struct Page *(*alloc_pages)(size_t n):申请分配指定数量的物理页

void (*free_pages)(struct Page *base, size_t n):申请释放若干指定物理页

size_t (*nr_free_pages)(void):查询当前空闲页总数

void (*check)(void):检查物理内存管理器的正确性

> 上图为pmm.h当中定义的结构体pmm_manager

涉及的结构体和宏定义：

memlayout.h中：

```c
struct Page {
    int ref;                        // page frame's reference counter
    uint32_t flags;                 //描述物理页帧状态的标志位
    unsigned int property;          //只在空闲块内第一页中用于记录该块中页数，其他页都是0
    list_entry_t page_link;         //空闲物理内存块双向链表
};
```

ref:注释中可以翻译为“引用的计数器”，这样可能比较抽象。具体的说ref表示的是，这个页被页表的引用记数，也就是映射此物理页的虚拟页个数。如果这个页被页表引用了即在某页表中有一个页表项设置了一个虚拟页到这个Page管理的物理页的映射关系，就会把Page的ref加一；反之，若页表项取消，即映射关系解除，就会把Page的ref减一。

flags：此物理页的状态标记，有两个标志位状态，为1的时候，代表这一页是free状态，可以被分配，但不能对它进行释放；如果为0，那么说明这个页已经分配了，不能被分配，但是可以被释放掉。简单地说，就是可不可以被分配的一个标志位。

propert：记录某连续空闲页的数量，这里需要注意的是用到此成员变量的这个Page一定是连续内存块的开始地址（第一页的地址）。

page_link：便于把多个连续内存空闲块链接在一起的双向链表指针，连续内存空闲块利用这个页的成员变量page_link来链接比它地址小和大的其他连续内存空闲块，释放的时候只要将这个空间通过指针放回到双向链表中。


接下来是上述定义的数据结构中会用到的宏定义：
```c
/* Flags describing the status of a page frame */
#define PG_reserved                 0       // if this bit=1: the Page is reserved for kernel, cannot be used in alloc/free_pages; otherwise, this bit=0 
#define PG_property                 1       // if this bit=1: the Page is the head page of a free memory block(contains some continuous_addrress pages), and can be used in alloc_pages; if this bit=0: if the Page is the the head page of a free memory block, then this Page and the memory block is alloced. Or this Page isn't the head page.

#define SetPageReserved(page)       set_bit(PG_reserved, &((page)->flags))
#define ClearPageReserved(page)     clear_bit(PG_reserved, &((page)->flags))
#define PageReserved(page)          test_bit(PG_reserved, &((page)->flags))
#define SetPageProperty(page)       set_bit(PG_property, &((page)->flags))
#define ClearPageProperty(page)     clear_bit(PG_property, &((page)->flags))
#define PageProperty(page)          test_bit(PG_property, &((page)->flags))
```

同时，我们发现我们定义的数据结构里面的操作是和名字绑定在一起的，这里我们猜测我们定义的数据结构的名字是default_pmm_manager，接下来找到对应的定义：

这里看一下里面的成员变量，首先就是一个list_entry结构的双向链表指针和记录当前空闲页的个数的无符号整型变量nr_free。其中的链表指针指向了空闲的物理页，也就是链表的头部。

```c
const struct pmm_manager default_pmm_manager = {
    .name = "default_pmm_manager",
    .init = default_init,
    .init_memmap = default_init_memmap,
    .alloc_pages = default_alloc_pages,
    .free_pages = default_free_pages,
    .nr_free_pages = default_nr_free_pages,
    .check = default_check,
};
```

发现这里把对应的函数和名字相绑定到了一起。

```c
/* free_area_t - maintains a doubly linked list to record free (unused) pages */
typedef struct {
    list_entry_t free_list;         // the list header(@ with a forward ptr & a backward ptr)
    unsigned int nr_free;           // # of free pages in this free list
} free_area_t;
```

list.h：

```c
struct list_entry {
    struct list_entry *prev, *next;
};
/*list_entry_t是双链表结点的两个指针构成的集合，这个空闲块链表实际上是将各个块首页的指针集合（由prev和next构成）的指针（或者说指针集合所在地址）相连*/
typedef struct list_entry list_entry_t;
```

练习一共需实现四个函数：

- default_init：初始化物理内存管理器；
- default_init_memmap：初始化空闲页；
- default_alloc_pages：申请分配指定数量的物理页；
- default_free_pages: 申请释放若干指定物理页；

直接修改default_pmm.c中的内存管理函数来实现。

**default_init：**

```c
free_area_t free_area; /*allocate blank memory for the doublely linked list*/

#define free_list (free_area.free_list)
#define nr_free (free_area.nr_free)

static void
default_init(void) {
    list_init(&free_list);
    nr_free = 0;
}
```

初始化双向链表，将空闲页总数nr_free初始化为0。

**default_init_memmap：**

初始化一整个空闲物理内存块，将块内每一页对应的Page结构初始化，参数为基址和页数（因为相邻编号的页对应的Page结构在内存上是相邻的，所以可将第一个空闲物理页对应的Page结构地址作为基址，以基址+偏移量的方式访问所有空闲物理页的Page结构，**根据指导书，这个空闲块链表正是将各个块首页的指针集合（由prev和next构成）的指针（或者说指针集合所在地址）相连，并以基址区分不同的连续内存物理块**）。

根据注释，**具体流程为**：遍历块内所有空闲物理页的Page结构，将各个flags置为0以标记物理页帧有效，将property成员置零，使用 SetPageProperty宏置PG_Property标志位来标记各个页有效（具体而言，如果一页的该位为1，则对应页应是一个空闲块的块首页；若为0，则对应页要么是一个已分配块的块首页，要么不是块中首页；另一个标志位PG_Reserved在pmm_init函数里已被置位，这里用于确认对应页不是被OS内核占用的保留页，因而可用于用户程序的分配和回收），清空各物理页的引用计数ref；最后再将首页Page结构的property置为块内总页数，将全局总页数nr_free加上块内总页数，并用page_link这个双链表结点指针集合将块首页连接到空闲块链表里。

写出代码如下：

```c
static void
default_init_memmap(struct Page *base, size_t n) {
    assert(n > 0);
    struct Page *p = base;
    for (; p != base + n; p ++) {
        assert(PageReserved(p));
        p->flags = p->property = 0;
        set_page_ref(p, 0);
    }
    base->property = n;
    SetPageProperty(base);
    nr_free += n;
    list_add(&free_list, &(base->page_link));
}
```

**default_alloc_pages(size_t n)：**

该函数分配指定页数的连续空闲物理内存空间，返回分配的空间中第一页的Page结构的指针。

流程：从起始位置开始顺序搜索空闲块链表，找到第一个页数不小于所申请页数n的块（只需检查每个Page的property成员，在其值>=n的第一个页停下），如果这个块的页数正好等于申请的页数，则可直接分配；如果块页数比申请的页数多，要将块分成两半，将起始地址较低的一半分配出去，将起始地址较高的一半作为链表内新的块，分配完成后重新计算块内空闲页数和全局空闲页数；若遍历整个空闲链表仍找不到足够大的块，则返回NULL表示分配失败。

```c
static struct Page *
default_alloc_pages(size_t n) {
    assert(n > 0);
    if (n > nr_free) {
        return NULL;
    }
    struct Page *page = NULL;
    list_entry_t *le = &free_list;
    while ((le = list_next(le)) != &free_list) {
        struct Page *p = le2page(le, page_link);
        if (p->property >= n) {
            page = p;
            break;
        }
    }
    if (page != NULL) {
        if (page->property > n) {
            struct Page *p = page + n;
            p->property = page->property - n;
            SetPageProperty(p);
            list_add(&free_list, &(p->page_link));
        }
        list_del(&(page->page_link));
        nr_free -= n;
        ClearPageProperty(page);
    }
    return page;
}
```

**default_free_pages(struct Page *base, size_t n)：**

释放从指定的某一物理页开始的若干个被占用的连续物理页，将这些页连回空闲块链表，重置其中的标志信息，最后进行一些碎片整理性质的块合并操作。

首先根据参数提供的块基址，遍历链表找到待插入位置，插入这些页。然后将引用计数ref、flags标志位置位，最后**调用merge_blocks函数迭代地进行块合并，以获取尽可能大的连续内存块**。规则是从新插入的块开始，首先正序遍历链表，不断将链表内基址与新插入块物理地址较大一端相邻的空闲块合并到新插入块里（也是对应着分配内存块时将物理基址较大的块留在链表里）；然后反序遍历链表，不断将链表内的基址与新插入块物理地址较小一端相邻的空闲块合并到新插入块里。

代码实现如下：

```c
static void
default_free_pages(struct Page *base, size_t n) {
    assert(n > 0);
    struct Page *p = base;
    for (; p != base + n; p ++) {
        assert(!PageReserved(p) && !PageProperty(p));
        p->flags = 0;
        set_page_ref(p, 0);
    }
    base->property = n;
    SetPageProperty(base);
    list_entry_t *le = list_next(&free_list);
    while (le != &free_list) {
        p = le2page(le, page_link);
        if (base + base->property == p) {
            base->property += p->property;
            ClearPageProperty(p);
            list_del(&(p->page_link));
        }
        else if (p + p->property == base) {
            p->property += base->property;
            ClearPageProperty(base);
            base = p;
            list_del(&(p->page_link));
        }
        le = list_next(le);
    }
    nr_free += n;
    le = list_next(&free_list);
    while (le != &free_list) {
        p = le2page(le, page_link);
        if (base + base->property <= p) {
            assert(base + base->property != p);
            break;
        }
        le = list_next(le);
    }
    list_add_before(le, &(base->page_link));
}
```



## 练习2：实现寻找虚拟地址对应的页表项(需要编程)

> 通过设置页表和对应的页表项，可建立虚拟内存地址和物理内存地址的对应关系。其中的 get_pte函数是设置页表项环节中的一个重要步骤。此函数找到一个虚地址对应的二级页表项 的内核虚地址，如果此二级页表项不存在，则分配一个包含此项的二级页表。本练习需要补全get_pte函数 in kern/mm/pmm.c，实现其功能。
>
> 请在实验报告中简要说明你的设计实现过程。请回答如下问题： 
>
> - 请描述页目录项（Pag Director Entry）和页表（Page Table Entry）中每个组成部分的含 义和以及对ucore而言的潜在用处。
> -  如果ucore执行过程中访问内存，出现了页访问异常，请问硬件要做哪些事情？

首先需要知道PDT(页目录表),PDE(页目录项),PTT(页表),PTE(页表项)之间的关系:页表保存页表项，页表项被映射到物理内存地址；页目录表保存页目录项，页目录项映射到页表。

###### PDE和PTE的各部分含义及用途

PDE和PTE都是4B大小的一个元素，其高20bit被用于保存索引，低12bit用于保存属性，但是由于用处不同，内部具有细小差异，如图所示：

![pde.png](https://i.loli.net/2020/11/04/7DvHaPVIACfyjbN.png)

![pte.png](https://i.loli.net/2020/11/04/Yqdz7hTnWtEBsSc.png)

| bit  | PDE                                                          | PTE                                                        |
| ---- | ------------------------------------------------------------ | ---------------------------------------------------------- |
| 0    | Present位，0不存在，1存在下级页表                            | 同                                                         |
| 1    | Read/Write位，0只读，1可写                                   | 同                                                         |
| 2    | User/Supervisor位，0则其下页表/物理页用户无法访问，1可以访问 | 同                                                         |
| 3    | Page level Write Through，1则开启页层次的写回机制，0不开启   | 同                                                         |
| 4    | Page level Cache Disable， 1则禁止页层次缓存，0不禁止        | 同                                                         |
| 5    | Accessed位，1代表在地址翻译过程中曾被访问，0没有             | 同                                                         |
| 6    | 忽略                                                         | 脏位，判断是否有写入                                       |
| 7    | PS，当且仅当PS=1且CR4.PSE=1，页大小为4M，否则为4K            | 如果支持 PAT 分页，间接决定这项访问的页的内存类型，否则为0 |
| 8    | 忽略                                                         | Global 位。当 CR4.PGE 位为 1 时,该位为1则全局翻译          |
| 9    | 忽略                                                         | 忽略                                                       |
| 10   | 忽略                                                         | 忽略                                                       |
| 11   | 忽略                                                         | 忽略                                                       |

一些接下来写函数可能会遇到的函数定义和宏定义：

```c
PDX(la)： 返回虚拟地址la的页目录索引

KADDR(pa): 返回物理地址pa相关的内核虚拟地址

set_page_ref(page,1): 设置此页被引用一次

page2pa(page): 得到page管理的那一页的物理地址

struct Page * alloc_page() : 分配一页出来

memset(void * s, char c, size_t n) : 设置s指向地址的前面n个字节为字节‘c’

PTE_P 0x001 表示物理内存页存在

PTE_W 0x002 表示物理内存页内容可写

PTE_U 0x004 表示可以读取对应地址的物理内存页内容
```

![pde.png](https://img-blog.csdnimg.cn/702bdbd470964d8893bc2288b30db6dd.png)
如图在保护模式中，x86 体系结构将内存地址分成三种：逻辑地址（也称虚地址）、线性地址和物理地址。逻辑地址即是程序指令中使用的地址，物理地址是实际访问内存的地址。逻辑地址通过段式管理的地址映射可以得到线性地址，线性地址通过页式管理的地址映射得到物理地址。

但是该实验将逻辑地址不加转换直接映射成线性地址，所以我们在下面的讨论中可以对这两个地址不加区分（目前的 OS 实现也是不加区分的）。

如图所示，页式管理将线性地址分成三部分（图中的 Linear Address 的 Directory 部分、 Table 部分和 Offset 部分）。ucore 的页式管理通过一个二级的页表实现。一级页表的起始物理地址存放在 cr3 寄存器中，这个地址必须是一个页对齐的地址，也就是低 12 位必须为 0。目前，ucore 用boot_cr3（mm/pmm.c）记录这个值。
![pde.png](https://img-blog.csdnimg.cn/37a5ef5169f74ee1a3f0854b247d5e08.png)
从图中我们可以看到一级页表存放在高10位中，二级页表存放于中间10位中，最后的12位表示偏移量，据此可以证明，页大小为4KB（2的12次方，4096）。
这里涉及到三个类型pte_t、pde_t和uintptr_t。通过查看定义：
```c
typedef unsigned int uint32_t;
typedef uint32_t uintptr_t;
typedef uintptr_t pte_t;
typedef uintptr_t pde_t;
```
可知它们其实都是unsigned int类型。其中，pde_t 全称为page directory entry，也就是一级页表的表项，前10位；

pte_t 全称为page table entry，表示二级页表的表项，中10位
### 出现页访问异常时，硬件执行的工作

- 首先需要将发生错误的线性地址la保存在CR2寄存器中
  - 这里说一下控制寄存器CR0-4的作用
  - CR0的0位是PE位，如果为1则启动保护模式，其余位也有自己的作用
  - CR1是未定义控制寄存器，留着以后用
  - CR2是**页故障线性地址寄存器**，保存最后一次出现页故障的全32位线性地址
  - CR3是**页目录基址寄存器**，保存PDT的物理地址
  - CR4在Pentium系列处理器中才实现，它处理的事务包括诸如何时启用虚拟8086模式等
- 之后需要往中断时的栈中压入EFLAGS,CS,EIP,ERROR CODE，如果这页访问异常很不巧发生在用户态，还需要先压入SS,ESP并切换到内核态
- 最后根据IDT表查询到对应的也访问异常的ISR，跳转过去并将剩下的部分交给软件处理。

###### 代码的实现

为了获取PTE，很自然需要先获取PDE，通过PDX(la)可以获得对应的PDE的索引，之后在pkdir中根据索引找到对应的PDE指针，写成代码即为

```
pde_t *pdep = &pgdir[PDX(la)];
```

之后判断其Present位是否为1(若不为1则需要为其创建新的PTT)，在创建时如果失败(创建标志为0或者分配物理内存页失败)需要立即返回，对应代码为

```c
if(!(*pdep & PTE_P))
{
	struct Page *temPage;

	if(!create || (temPage = alloc_page()) == NULL )
	{
        return NULL;
	}
    
}
```

分配物理内存页之后，把这个物理页的引用的计数通过set_page_ref更新。

获取这个temPage的物理地址，然后把这个物理页全部初始化为0(需要用KADDR转换为内核虚拟地址)。到此完成了pte的设置，还需要更新pde中的几个标识位。对应代码如下

```c
	set_page_ref(temPage,1);
	uintptr_t pa = page2pa(temPage);
	memset(KADDR(pa), 0, PGSIZE);
	// pa的地址，用户级，可写，存在
	*pdep = pa | PTE_U | PTE_W | PTE_P;
```

最后需要返回这个对应的PTE，而目前我们有的是一个pdep，存放着PTT的物理地址，根据PDE的结构，可以得出这样一个流程

1. 抹去低12位，只保留对应的PTT的起始基地址
2. 用PTX(la)获得PTT对应的PTE的索引
3. 用数组和对应的索引得到PTE并返回

~~~c
return &((pte_t *)KADDR(PDE_ADDR(*pdep)))[PTX(la)]; 
~~~

完整代码如下：

```c
pte_t *
get_pte(pde_t *pgdir, uintptr_t la, bool create) {
    /* LAB2 EXERCISE 2: YOUR CODE
     *
     * If you need to visit a physical address, please use KADDR()
     * please read pmm.h for useful macros
     *
     * Maybe you want help comment, BELOW comments can help you finish the code
     *
     * Some Useful MACROs and DEFINEs, you can use them in below implementation.
     * MACROs or Functions:
     *   PDX(la) = the index of page directory entry of VIRTUAL ADDRESS la.
     *   KADDR(pa) : takes a physical address and returns the corresponding kernel virtual address.
     *   set_page_ref(page,1) : means the page be referenced by one time
     *   page2pa(page): get the physical address of memory which this (struct Page *) page  manages
     *   struct Page * alloc_page() : allocation a page
     *   memset(void *s, char c, size_t n) : sets the first n bytes of the memory area pointed by s
     *                                       to the specified value c.
     * DEFINEs:
     *   PTE_P           0x001                   // page table/directory entry flags bit : Present
     *   PTE_W           0x002                   // page table/directory entry flags bit : Writeable
     *   PTE_U           0x004                   // page table/directory entry flags bit : User can access
     */
#if 0
    pde_t *pdep = NULL;   // (1) find page directory entry
    if (0) {              // (2) check if entry is not present
                          // (3) check if creating is needed, then alloc page for page table
                          // CAUTION: this page is used for page table, not for common data page
                          // (4) set page reference
        uintptr_t pa = 0; // (5) get linear address of page
                          // (6) clear page content using memset
                          // (7) set page directory entry's permission
    }
    return NULL;          // (8) return page table entry
#endif
    pde_t *pdep = &pgdir[PDX(la)];  //尝试获得页表
    if (!(*pdep & PTE_P)) { //如果获取不成功
        struct Page *page;
        //假如不需要分配或是分配失败
        if (!create || (page = alloc_page()) == NULL) { 
            return NULL;
        }
        set_page_ref(page, 1); //引用次数加一
        uintptr_t pa = page2pa(page);  //得到该页物理地址
        memset(KADDR(pa), 0, PGSIZE); //物理地址转虚拟地址，并初始化
        *pdep = pa | PTE_U | PTE_W | PTE_P; //设置控制位
    }
    return &((pte_t *)KADDR(PDE_ADDR(*pdep)))[PTX(la)]; 
    //KADDR(PDE_ADDR(*pdep)):这部分是由页目录项地址得到关联的页表物理地址，再转成虚拟地址
    //PTX(la)：返回虚拟地址la的页表项索引
    //最后返回的是虚拟地址la对应的页表项入口地址
}
```
首先尝试使用PDX函数，获取一级页表的位置，如果获取成功，可以直接返回一个东西。

如果获取不成功，那么需要根据create标记位来决定是否创建这一个二级页表（注意，一级页表中，存储的都是二级页表的起始地址）。如果create为0，那么不创建，否则创建。

既然需要查找这个页表，那么页表的引用次数就要加一。

之后，需要使用memset将新建的这个页表虚拟地址，全部设置为0，因为这个页所代表的虚拟地址都没有被映射。

接下来是设置控制位。这里应该设置同时设置上PTE_U、PTE_W和PTE_P，分别代表用户态的软件可以读取对应地址的物理内存页内容、物理内存页内容可写、物理内存页存在。
![pde.png](https://img-blog.csdnimg.cn/aa37453ea892490fa8a52d84478f9a95.png)
只有当一级二级页表的项都设置了用户写权限后，用户才能对对应的物理地址进行读写。所以我们可以在一级页表先给用户写权限，再在二级页表上面根据需要限制用户的权限，对物理页进行保护。由于一个物理页可能被映射到不同的虚拟地址上去（譬如一块内存在不同进程间共享），当这个页需要在一个地址上解除映射时，操作系统不能直接把这个页回收，而是要先看看它还有没有映射到别的虚拟地址上。这是通过查找管理该物理页的Page数据结构的成员变量ref（用来表示虚拟页到物理页的映射关系的个数）来实现的，如果ref为0了，表示没有虚拟页到物理页的映射关系了，就可以把这个物理页给回收了，从而这个物理页是free的了，可以再被分配。page_insert函数将物理页映射在了页表上。可参看page_insert函数的实现来了解ucore内核是如何维护这个变量的。当不需要再访问这块虚拟地址时，可以把这块物理页回收并在将来用在其他地方。取消映射由page_remove来做，这其实是page_insert的逆操作

la,PDX,PTX,PTE_ADDR,PDE_ADDR的定义可以在mmu.h下看到，具体内容如下

~~~c
// A linear address 'la' has a three-part structure as follows:
//
// +--------10------+-------10-------+---------12----------+
// | Page Directory |   Page Table   | Offset within Page  |
// |      Index     |     Index      |                     |
// +----------------+----------------+---------------------+
//  \--- PDX(la) --/ \--- PTX(la) --/ \---- PGOFF(la) ----/
//  \----------- PPN(la) -----------/
//
// The PDX, PTX, PGOFF, and PPN macros decompose linear addresses as shown.
// To construct a linear address la from PDX(la), PTX(la), and PGOFF(la),
// use PGADDR(PDX(la), PTX(la), PGOFF(la)).

// page directory index
#define PDX(la) ((((uintptr_t)(la)) >> PDXSHIFT) & 0x3FF)

// page table index
#define PTX(la) ((((uintptr_t)(la)) >> PTXSHIFT) & 0x3FF)

// offset in page
#define PGOFF(la) (((uintptr_t)(la)) & 0xFFF)

// address in page table or page directory entry
#define PTE_ADDR(pte)   ((uintptr_t)(pte) & ~0xFFF)
#define PDE_ADDR(pde)   PTE_ADDR(pde)
~~~

la是线性地址，32位，需要提取出该字段内容，才能获取页表内容。

其中，PDXSHIFT的值为22，右移22位，再与10个1与，就可以获取directory；PTXSHIFT的值为12，右移12位，再与10个1与，这样就能提取table部分。同时也有偏移量的定义，还有知道了如何构造线性地址。

综上，页表保存页表项，页表项被映射到物理内存地址；页目录表保存页目录项，页目录项映射到页表。

KADDR，page2pa可以在pmm.h中看到

```c
/* *
 * KADDR - takes a physical address and returns the corresponding kernel virtual
 * address. It panics if you pass an invalid physical address.
 * */
#define KADDR(pa) ({                                                    \
            uintptr_t __m_pa = (pa);                                    \
            size_t __m_ppn = PPN(__m_pa);                               \
            if (__m_ppn >= npage) {                                     \
                panic("KADDR called with invalid pa %08lx", __m_pa);    \
            }                                                           \
            (void *) (__m_pa + KERNBASE);                               \
        })

static inline ppn_t
page2ppn(struct Page *page) {
    return page - pages;
}
// PGSHIFT = log2(PGSIZE) = 12
static inline uintptr_t
page2pa(struct Page *page) {
    return page2ppn(page) << PGSHIFT;
}
```

## 练习3：释放某虚地址所在的页并取消对应二级页表项的映射(需要编程)

> 当释放一个包含某虚地址的物理内存页时，需要让对应此物理内存页的管理数据结构Page做相关的清除处理，使得此物理内存页成为空闲；另外还需把表示虚地址与物理地址对应关系的二级页表项清除。请仔细查看和理解page_remove_pte函数中的注释。为此，需要补全在 kern/mm/pmm.c中的page_remove_pte函数。
>
> 请在实验报告中简要说明你的设计实现过程。请回答如下问题：
>
> - 数据结构Page的全局变量（其实是一个数组）的每一项与页表中的页目录项和页表项有无对应关系？如果有，其对应关系是啥？
> - 如果希望虚拟地址与物理地址相等，则需要如何修改lab2，完成此事？ 鼓励通过编程来具体完成这个问题
##### 关于代码：

练习3可以看成是练习2的简单的逆过程，在理解了练习2的基础上，释放虚地址所在的页和取消对应二级页表项的映射可以大概分为如下步骤：

1. 通过PTE_P判断该ptep是否存在；
2. 判断Page的ref的值是否为0，若为0，则说明此时没有任何逻辑地址被映射到此物理地址，换句话说当前物理页已没人使用，因此调用free_page函数回收此物理页，使得该物理页空闲；若不为0，则说明此时仍有至少一个逻辑地址被映射到此物理地址，因此不需回收此物理页；
3. 把表示虚地址与物理地址对应关系的二级页表项清除；
4. 更新TLB；

根据Lab2中的代码提示，我们将MACROs 和 DEFINES拿出进行理解：

```c
static inline struct Page *
pte2page(pte_t pte) {//从ptep值中获取相应的页面
    if (!(pte & PTE_P)) {
        panic("pte2page called with invalid pte");
    }
    return pa2page(PTE_ADDR(pte));
}

//减少该页的引用次数，返回剩下的引用次数。
static inline int  
page_ref_dec(struct Page *page) {
    page->ref -= 1;
    return page->ref;
}

//当修改的页表目前正在被进程使用时，使之无效。
void 
tlb_invalidate(pde_t *pgdir, uintptr_t la) {
    if (rcr3() == PADDR(pgdir)) {
        invlpg((void *)la);
    }
}



#define PTE_P           0x001                   // Present，即最低位为1；

```

在此基础之上，我们给出完整的代码：

```C
static inline void
page_remove_pte(pde_t *pgdir, uintptr_t la, pte_t *ptep) {
    /* LAB2 EXERCISE 3: YOUR CODE
     *
     * Please check if ptep is valid, and tlb must be manually updated if mapping is updated
     *
     * Maybe you want help comment, BELOW comments can help you finish the code
     *
     * Some Useful MACROs and DEFINEs, you can use them in below implementation.
     * MACROs or Functions:
     *   struct Page *page pte2page(*ptep): get the according page from the value of a ptep
     *   free_page : free a page
     *   page_ref_dec(page) : decrease page->ref. NOTICE: ff page->ref == 0 , then this page should be free.
     *   tlb_invalidate(pde_t *pgdir, uintptr_t la) : Invalidate a TLB entry, but only if the page tables being
     *                        edited are the ones currently in use by the processor.
     * DEFINEs:
     *   PTE_P           0x001                   // page table/directory entry flags bit : Present
     */
#if 0
    if (0) {                      //(1) check if this page table entry is present
        struct Page *page = NULL; //(2) find corresponding page to pte
                                  //(3) decrease page reference
                                  //(4) and free this page when page reference reachs 0
                                  //(5) clear second page table entry
                                  //(6) flush tlb
    }
#endif
    if (*ptep & PTE_P) {  //页表项存在
        struct Page *page = pte2page(*ptep); //找到页表项
        if (page_ref_dec(page) == 0) {  //只被当前进程引用
            free_page(page); //释放页
        }
        *ptep = 0; //该页目录项清零
        tlb_invalidate(pgdir, la); 
        //修改的页表是进程正在使用的那些页表，使之无效
    }
}
```

##### 关于问题：

Q1：数据结构Page的全局变量（其实是一个数组）的每一项与页表中的页目录项和页表项有无对应关系？如果有，其对应关系是啥？

A：所有的物理页都有一个描述它的Page结构，所有的页表都是通过alloc_page()分配的，每个页表项都存放在一个Page结构描述的物理页中；如果 PTE 指向某物理页，同时也有一个Page结构描述这个物理页。所以有两种对应关系：

(1)可以通过 PTE 的地址计算其所在的页表的Page结构：

 将虚拟地址向下对齐到页大小，换算成物理地址(减 KERNBASE), 再将其右移 PGSHIFT(12)位获得在pages数组中的索引PPN，&pages[PPN]就是所求的Page结构地址。

(2)可以通过 PTE 指向的物理地址计算出该物理页对应的Page结构：

PTE 按位与 0xFFF获得其指向页的物理地址，再右移 PGSHIFT(12)位获得在pages数组中的索引PPN，&pages[PPN]就 PTE 指向的地址对应的Page结构。



Q2：如果希望虚拟地址与物理地址相等，则需要如何修改lab2，完成此事？ 鼓励通过编程来具体完成这个问题。

ucore 设置虚拟地址到物理地址的映射分为两步：

lab 2 中 ucore的入口点kern_entry()（定义在 kern/init/entry.s）中，设置了一个临时页表，将虚拟地址 KERNBASE ~ KERNBASE + 4M 映射到物理地址 0 ~ 4M ，并将 eip 修改到对应的虚拟地址。ucore 所有代码和本实验操作的所有数据结构（Page数组）都在这个虚拟地址范围内。
在确保程序可以正常运行后，调用boot_map_segment(boot_pgdir, KERNBASE, KMEMSIZE, 0, PTE_W);将虚拟地址KERNBASE ~ KERNBASE + KMEMSIZE。

因为在编译链接时 ld 脚本 kern/tools/kernel.ld设置链接地址（虚拟地址），代码段基地址为0xC0100000（对应物理地址0x00100000)，必须将该地址修改为0x00100000以确保内核加载正确。

``` c
    /* Load the kernel at this address: "." means the current address */
     /* . = 0xC0100000; */ 
     . = 0x00100000; 
    .text : {
        *(.text .stub .text.* .gnu.linkonce.t.*)
    }

```

在第1步中，ucore 设置了虚拟地址 0 ~ 4M 到物理地址 0 ~ 4M 的映射以确保开启页表后kern_entry能够正常执行，在将 eip 修改为对应的虚拟地址（加KERNBASE）后就取消了这个临时映射。因为我们要让物理地址等于虚拟地址，所以保留这个映射不变（将清除映射的代码注释掉）。

``` 
next:
    # unmap va 0 ~ 4M, it's temporary mapping
	#xorl %eax, %eax
	#movl %eax, __boot_pgdir

```

ucore的代码大量使用了KERNBASE+物理地址等于虚拟地址的映射，为了尽可能降低修改的代码数，仍使用宏KERNBASE和VPT（lab2中没有用到，为了避免bug仍然修改它），但是将他们减去0x38000000。

``` c
// #define KERNBASE            0xC0000000
#define KERNBASE            0x00000000

// #define VPT                 0xFAC00000
#define VPT                 0xC2C00000

```

修改了KERNBASE后，虚拟地址和物理地址的关系就变成了：

``` c
physical address + 0 == virtual address
```

在boot_map_segment()中，先清除boot_pgdir[1]的 present 位，再进行其他操作。这是get_pte会分配一个物理页作为boot_pgdir[1]指向的页表。

```c
static void
boot_map_segment(pde_t *pgdir, uintptr_t la, size_t size, uintptr_t pa, uint32_t perm) 
{
	boot_pgdir[1] &= ~PTE_P;
    ...
}
```

虚拟地址到物理地址的映射改变了，不可能通过check_pgdir()和check_boot_pgdir()的测试，所以要注释掉这两行调用。

## Challenge1：buddy system(伙伴系统)分配算法(需要编程)

> Buddy System算法把系统中的可用存储空间划分为存储块(Block)来进行管理, 每个存储块的 大小必须是2的n次幂(Pow(2, n)), 即1, 2, 4, 8, 16, 32, 64, 128... 
>
> - 参考伙伴分配器的一个极简实现， 在ucore中实现buddy system分配算法，要求有比较充分的测试用例说明实现的正确性，需要有设计文档。

   Buddy system是一种连续物理内存的分配算法，主要应用二叉树来完成内存的分配；可以用来替换exe1中的first-fit算法。

网上对buddy system的算法定义如下：

**分配内存：**

1.寻找大小合适的内存块（大于等于所需大小并且最接近2的幂，比如需要27，实际分配32）

​    1.1 如果找到了，分配给应用程序。
​    1.2 如果没找到，分出合适的内存块。

​       1.2.1 对半分离出高于所需大小的空闲内存块
​       1.2.2 如果分到最低限度，分配这个大小。
​       1.2.3 回溯到步骤1（寻找合适大小的块）
​       1.2.4 重复该步骤直到一个合适的块

**释放内存：**

1.释放该内存块

   1.1 寻找相邻的块，看其是否释放了。
   1.2 如果相邻块也释放了，合并这两个块，重复上述步骤直到遇上未释放的相邻块，或者达到最高上限（即所有内存都释放了）。

​        在此定义之下，我们使用数组分配器来模拟构建这样完全二叉树结构而不是真的用指针建立树结构——树结构中向上或向下的指针索引都通过数组分配器里面的下标偏移来实现。在这个“完全二叉树”结构中，二叉树的节点用于标记相应内存块的使用状态，高层节点对应大的块，低层节点对应小的块，在分配和释放中我们就通过这些节点的标记属性来进行块的分离合并。

​        在分配阶段，首先要搜索大小适配的块——这个块所表示的内存大小刚好大于等于最接近所需内存的2次幂；通过对树深度遍历，从左右子树里面找到最合适的，将内存分配。

​        在释放阶段，我们将之前分配出去的内存占有情况还原，并考察能否和同一父节点下的另一节点合并，而后递归合并，直至不能合并为止。

![image-20201110000901267.png](https://i.loli.net/2020/11/11/rVJYyaZokCqDPT1.png)

pmm.h
```c
#ifndef __KERN_MM_BUDDY_PMM_H__
#define  __KERN_MM_BUDDY_PMM_H__

#include <pmm.h>

extern const struct pmm_manager buddy_pmm_manager;

#endif /* ! __KERN_MM_BUDDY_PMM_H__ */

```

pmm.c
```c
#include <list.h>
#include <string.h>
#include <assert.h>
#include <buddy_pmm.h>

// 最大页数（基于KMEMSIZE）
#define MAX_LENGTH 262144
#define MAX_LENGTH_LOG 18
#define LEFT_LEAF(index) ((index) * 2 + 1)
#define RIGHT_LEAF(index) ((index) * 2 + 2)
#define PARENT(index) ( ((index) + 1) / 2 - 1)

#define IS_POWER_OF_2(x) (!((x)&((x)-1)))
#define MAX(a, b) ((a) > (b) ? (a) : (b))


struct buddy2 {
  	unsigned size; // 最大页数
  	unsigned longest[2 * MAX_LENGTH - 1]; // 二叉树
	struct Page* base; // &pages[0]
};

struct buddy2 buddy;

// 空表，包含双向链表的入口和空闲页的总数
free_area_t free_area[MAX_LENGTH_LOG + 1];

// 简化使用
#define free_list(n) (free_area[(n)].free_list)
#define nr_free(n) (free_area[(n)].nr_free)

// 大于size的2的次幂
static unsigned fixsize(unsigned size) {
  	size |= size >> 1;
  	size |= size >> 2;
  	size |= size >> 4;
  	size |= size >> 8;
  	size |= size >> 16;
  	return size + 1;
}

// 阶数
static unsigned log(unsigned size) {
	assert(IS_POWER_OF_2(size));
	unsigned i = 0;
	for (;i <= MAX_LENGTH_LOG; i++) {
		if ((1 << i) & size) {
			return i;
		}
	}
	assert(0);
}

// 初始化buddy结构
void buddy_new(int size) {
  	if (size < 1 || !IS_POWER_OF_2(size))
    	return;

  	buddy.size = size;
	memset(buddy.longest, 0, 2 * size * sizeof(unsigned) - 1);

	extern char end[];
	buddy.base = (struct Page *)ROUNDUP((void *)end, PGSIZE);
  	return;
}

// 初始化链表数组并且传入MAX_LENGTH
static void buddy_init(void) {
	int i = 0;
	for (; i <= MAX_LENGTH_LOG; i++) {
		list_init(&free_list(i));
    	nr_free(i) = 0;
	}
	buddy_new(MAX_LENGTH);
}

// 释放页，大小必须为2的次幂
static void buddy_free_pages(struct Page* base, size_t n) {
	assert(n > 0);
	assert (IS_POWER_OF_2(n));
    struct Page *p = base;
    for (; p != base + n; p ++) {
        assert(!PageReserved(p) && !PageProperty(p));
        p->flags = 0;
        set_page_ref(p, 0);
    }
    base->property = n;
    SetPageProperty(base);
	
	// 计算阶数，插回对应的链表里
	unsigned logn = log(n);
	nr_free(logn) += n;
	list_entry_t *le = &free_list(logn);
	list_add_before(list_next(le), &(base->page_link));

  	unsigned index, node_size = n;
  	unsigned left_longest, right_longest;
	unsigned offset = base - buddy.base;

  	assert(offset >= 0 && offset < buddy.size * 2 - 1);

  	index = (offset + buddy.size) / n - 1;

	// 恢复二叉树原节点的longest
  	buddy.longest[index] = n;

	// 遍历，恢复上层节点并检查合并
  	while (index) {
    	index = PARENT(index);
    	node_size *= 2;

    	left_longest = buddy.longest[LEFT_LEAF(index)];
    	right_longest = buddy.longest[RIGHT_LEAF(index)];
    
		// 可合并
    	if (left_longest + right_longest == node_size) {
      		buddy.longest[index] = node_size;
			unsigned logn = log(node_size);
			unsigned left_offset, right_offset;
			// 计算出左右块的头page
			left_offset = (LEFT_LEAF(index) + 1) * node_size / 2 - buddy.size;
			right_offset = (RIGHT_LEAF(index) + 1) * node_size / 2 - buddy.size;
			struct Page *left_page = &buddy.base[left_offset], *right_page = &buddy.base[right_offset];
			list_entry_t *lle = &left_page->page_link, *rle = &right_page->page_link;
			// 从原链表中取出
			list_del(lle);
			list_del(rle);
			nr_free(logn - 1) -= node_size;
			left_page->property = node_size; 
			right_page->property = 0;
			right_page->flags = 0;
			// 插入新链表中
			list_entry_t *le = &free_list(logn);
			list_add_before(list_next(le), lle);
			nr_free(logn) += node_size;
		}
    	else
      		buddy.longest[index] = MAX(left_longest, right_longest);
  	}
}

// 将初始化的空闲块细分，一个个插入以保证二叉树longest正确更新
static void buddy_init_memmap(struct Page *base, size_t n) {
	assert(n > 0);
    struct Page *p = base;
    for (; p != base + n; p ++) {
        assert(PageReserved(p));
		p->flags = 0;
        set_page_ref(p, 0);
		p->property = 1;
		buddy_free_pages(p, 1);
    }
}

// 分配适合大小的空闲块
static struct Page *buddy_alloc_pages(size_t n) {
    assert(n > 0);
	if (!IS_POWER_OF_2(n))
    	n = fixsize(n);
	unsigned logn;
	unsigned index = 0;
  	unsigned node_size;
  	unsigned offset = 0;
	struct Page* p = NULL, *lp = NULL, *rp = NULL;

	// 二叉树中从上至下遍历，遍历的路径中将大空闲块分割成小空闲块
	if (buddy.longest[index] < n)
    	return NULL;
	for(node_size = buddy.size; node_size != n; node_size /= 2 ) {
		// 该空闲块完整，需要分割
		if (buddy.longest[index] == node_size) {
			offset = (index + 1) * node_size - buddy.size;
			p = &buddy.base[offset];
			assert(PageProperty(p));
			assert(p->property == node_size);
			logn = log(node_size);
			nr_free(logn) -= node_size;
			list_del(&p->page_link);
			lp = p;
			rp = p + node_size / 2;
			SetPageProperty(lp);
			SetPageProperty(rp);
			lp->property = node_size / 2;
			rp->property = node_size / 2;
			nr_free(logn - 1) += node_size;
			list_entry_t* le = &free_list(logn - 1);
			list_add_after(list_next(le), &(lp->page_link));
			list_add_after(list_next(le), &(rp->page_link));
		}
		if (buddy.longest[LEFT_LEAF(index)] >= n)
			index = LEFT_LEAF(index);
    	else 
			index = RIGHT_LEAF(index);
  	}

	// 计算出下标，获得对应块的首页
	offset = (index + 1) * node_size - buddy.size;
	logn = log(node_size);
	p = &buddy.base[offset];
	if (p == NULL) {
		return NULL;
	}
	buddy.longest[index] = 0;
	// 更新上层节点的longest
	while (index) {
    	index = PARENT(index);
    	buddy.longest[index] = MAX(buddy.longest[LEFT_LEAF(index)], buddy.longest[RIGHT_LEAF(index)]);
  	}

	// 从链表中删除
	list_del(&(p->page_link));
    nr_free(logn) -= node_size;
    ClearPageProperty(p);
    return p;
}

// 计算空闲块的页总数
static size_t buddy_nr_free_pages(void) {
	size_t nr = 0;
	int i = 0;
	for (; i <= MAX_LENGTH_LOG; i++) {
		nr += nr_free(i);
	}
    return nr;
}

// 检查链表数组和二叉树各层完整节点
static void buddy_check_tree(void) {
	cprintf("free_pages: %d\n", buddy_nr_free_pages());
	cprintf("---------------------------------------------------------------\n");
	unsigned i = 0;
	for (; i <= MAX_LENGTH_LOG; i++) {
		unsigned num = 0;
		unsigned j = MAX_LENGTH >> i;
		for (; j < ((MAX_LENGTH * 2) >> i); j++) {
			if (buddy.longest[j] == (MAX_LENGTH >> (MAX_LENGTH_LOG - i))) {
				num++;
			}
		}
		cprintf("index: %d\ttotal: %d\tnum: %d\n", i, nr_free(i), num);
	}
	cprintf("---------------------------------------------------------------\n");
}

static void buddy_check(void) {
    struct Page  *p0, *p1;
    p0 = p1 =NULL;

    assert((p0 = alloc_page()) != NULL);
    assert((p1 = alloc_page()) != NULL);

    assert(p0 != p1);
    assert(page_ref(p0) == 0 && page_ref(p1) == 0);

	cprintf("%d\n", 1);
	buddy_check_tree();

    free_page(p0);
    free_page(p1);

	buddy_check_tree();

	p0 = p1 =NULL;
	assert((p0 = alloc_pages(256)) != NULL);
    assert((p1 = alloc_pages(256)) != NULL);
	assert(p0 != p1);
    assert(page_ref(p0) == 0 && page_ref(p1) == 0);
	assert(p0->property == 256 && p1->property == 256);

	cprintf("%d\n", 256);
	buddy_check_tree();

    free_pages(p0, 256);
    free_pages(p1, 256);

	buddy_check_tree();

	p0 = p1 =NULL;
	assert((p0 = alloc_pages(1024)) != NULL);
    assert((p1 = alloc_pages(1024)) != NULL);
	assert(p0 != p1);
    assert(page_ref(p0) == 0 && page_ref(p1) == 0);
	assert(p0->property == 1024 && p1->property == 1024);

	cprintf("%d\n", 1024);
	buddy_check_tree();

    free_pages(p0, 1024);
    free_pages(p1, 1024);

	buddy_check_tree();

	p0 = p1 =NULL;
	assert((p0 = alloc_pages(1000)) != NULL);
    assert((p1 = alloc_pages(1000)) != NULL);
	assert(p0 != p1);
    assert(page_ref(p0) == 0 && page_ref(p1) == 0);
	assert(p0->property == 1024 && p1->property == 1024);

	cprintf("%d\n", 1000);
	buddy_check_tree();

    free_pages(p0, 1024);
    free_pages(p1, 1024);

	buddy_check_tree();
}

const struct pmm_manager buddy_pmm_manager = {
    .name = "buddy_pmm_manager",
    .init = buddy_init,
    .init_memmap = buddy_init_memmap,
    .alloc_pages = buddy_alloc_pages,
    .free_pages = buddy_free_pages,
    .nr_free_pages = buddy_nr_free_pages,
    .check = buddy_check,
};

```
