# OSlab2--by：孙博言，王辰旭，侯宇睿

实验一过后大家做出来了一个可以启动的系统，实验二主要涉及操作系统的物理内存管理。 操作系统为了使用内存，还需高效地管理内存资源。在实验二中大家会了解并且自己动手完 成一个简单的物理内存管理系统。

实验目的如下

- 理解基于段页式内存地址的转换机制
- 理解页表的建立和使用方法
- 理解物理内存的管理方法

在开始实验前，别忘了将lab1中已经完成的代码填入本实验中代码有LAB1的注释的相应部分。可以采用diff和patch工具进行半自动的合并(merge)，也可以用一些图形化的比较/merge工具来合并，比如meld，eclipse中的diff/merge工具，understand中的diff/merge工具
## 练习0：合并Lab0和Lab1代码
![image-20201102235653991.png](https://i.loli.net/2020/11/05/wrHk5b68dyYtceK.png)

使用meld工具打开文件进行比较，因为lab1只修改了trap.c，init.c和kdegub.c这三个文件，所以一一比较合并即可。

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

### 另解

出现页访问异常，硬件要做的事情
当启动分页机制以后，如果一条指令或数据的虚拟地址所对应的物理页不在内存中或者访问的类型有误（比如写一个只读页或用户态程序访问内核态的数据等），就会发生页错误异常。
而产生页面异常的原因主要有:
①目标页面不存在（页表项全为0，即该线性地址与物理地址尚未建立映射或者已经撤销）；
②相应的物理页面不在内存中（页表项非空，但Present标志位=0，比如将页表交换到磁盘）；
③访问权限不符合（比如企图写只读页面）。
当出现上面情况之一,那么就会产生页面page fault(#PF)异常。产生异常的虚拟地址存储在CR2中，并且将是page fault的错误类型保存在error code中。引发异常后将外存的数据换到内存中，进行上下文切换，退出中断，返回到中断前的状态。
Linux中对于page fault有详细的分类：
![pde.png](https://img-blog.csdnimg.cn/img_convert/657103a6f795d09d9931c7fcb3e23d4b.png)

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

### 另解

#### 2

当页目录项或页表项有效时，Page数组中的项与页目录项或页表项存在对应关系。
Page的每一项记录一个物理页的信息，而每个页目录项记录一个页表的信息，每个页表项则记录一个物理页的信息。假设系统中共有N个物理页，那么Page共有N项，第i项对应第i个物理页的信息。而页目录项和页表项的第31~12位构成的20位数分别对应一个物理页编号，因此也就和Page的对应元素一一对应。页目录项和页表项的前20位就可以表明它是哪个Page。
(1)将虚拟地址向下对齐到页大小，换算成物理地址(-KERNBASE), 再将其右移GSHIFT(12)位获得在pages数组中的索引PPN，&pages[PPN]就是所求的Page结构地址。
(2)PTE按位与0xFFF获得其指向页的物理地址，再右移PGSHIFT(12)位获得在pages数组中的索引PPN，&pages[PPN]就PTE指向的地址对应的Page结构。
如果按照书上的知识，VA如下：
![pde.png](https://img-blog.csdnimg.cn/img_convert/41189b52d19dd81f23721b7bacf1ba35.png)
页目录项PDE的地址：PDEAddr = PageDirBase +（PDIndex×sizeof（PDE））
页表项PTE的地址：PTEAddr = (PDE.PFN << SHIFT) + (PTIndex * sizeof(PTE))
物理地址：PhysAddr =（PTE.PFN << SHIFT）+ offset

#### 3
相关背景知识：
系统执行中地址映射的四个阶段：
在lab1中，我们已经碰到到了简单的段映射，即对等映射关系，保证了物理地址和虚拟地址相等，也就是通过建立全局段描述符表，让每个段的基址为0，从而确定了对等映射关系。在lab2中，由于在段地址映射的基础上进一步引入了页地址映射，形成了组合式的段页式地址映射。从计算机加电，启动段式管理机制，启动段页式管理机制，在段页式管理机制下运行这整个过程中，虚地址到物理地址的映射产生了多次变化，实现了最终的段页式映射关系：
virt addr = linear addr = phy addr + 0xC0000000
第一个阶段是bootloader阶段，这个阶段其虚拟地址，线性地址以及物理地址之间的映射关系与lab1的一样，即：
lab2 stage 1： virt addr = linear addr = phy addr
第二个阶段是从kern_\entry函数开始，到执行enable_page函数（在kern/mm/pmm.c中）之前再次更新了段映射，还没有启动页映射机制。由于gcc编译出的虚拟起始地址从0xC0100000开始，ucore被bootloader放置在从物理地址0x100000处开始的物理内存中。所以当kern_entry函数完成新的段映射关系后，且ucore在没有建立好页映射机制前，CPU按照ucore中的虚拟地址执行，能够被分段机制映射到正确的物理地址上，确保ucore运行正确。这时的虚拟地址，线性地址以及物理地址之间的映射关系为：
lab2 stage 2： virt addr - 0xC0000000 = linear addr = phy addr
此时CPU在寻址时还是只采用了分段机制，一旦执行完enable_paging函数中的加载cr0指令（即让CPU使能分页机制），则接下来的访问是基于段页式的映射关系了。
第三个阶段是从enable_page函数开始，到执行gdt_init函数（在kern/mm/pmm.c中）之前，启动了页映射机制，但没有第三次更新段映射。这是候映射关系是：

```
 lab2 stage 3:  virt addr - 0xC0000000 = linear addr  = phy addr + 0xC0000000 # 物理地址在0~4MB之外的三者映射关系
                virt addr - 0xC0000000 = linear addr  = phy addr # 物理地址在0~4MB之内的三者映射关系

```
请注意pmm_init函数中的一条语句：
boot_pgdir[0] = boot_pgdir[PDX(KERNBASE)];
就是用来建立物理地址在0~4MB之内的三个地址间的临时映射关系virt addr - 0xC0000000 = linear addr = phy addr。
第四个阶段是从gdt_init函数开始，第三次更新了段映射，形成了新的段页式映射机制，并且取消了临时映射关系，即执行语句“boot_pgdir[0] = 0;”把boot_pgdir[0]的第一个页目录表项（0~4MB）清零来取消临时的页映射关系。这时形成了我们期望的虚拟地址，线性地址以及物理地址之间的映射关系：
lab2 stage 4： virt addr = linear addr = phy addr + 0xC0000000

使能分页机制后的虚拟地址空间图：

``` c
/* *
 * Virtual memory map:                                          Permissions
 *                                                              kernel/user
 *
 *     4G -----------> +---------------------------------+
 *                     |                                 |
 *                     |         Empty Memory (*)        |
 *                     |                                 |
 *                     +---------------------------------+ 0xFB000000
 *                     |   Cur. Page Table (Kern, RW)    | RW/-- PTSIZE
 *     VPT ----------> +---------------------------------+ 0xFAC00000
 *                     |        Invalid Memory (*)       | --/--
 *     KERNTOP ------> +---------------------------------+ 0xF8000000
 *                     |                                 |
 *                     |    Remapped Physical Memory     | RW/-- KMEMSIZE
 *                     |                                 |
 *     KERNBASE -----> +---------------------------------+ 0xC0000000
 *                     |                                 |
 *                     |                                 |
 *                     |                                 |
 *                     ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 * (*) Note: The kernel ensures that "Invalid Memory" is *never* mapped.
 *     "Empty Memory" is normally unmapped, but user programs may map pages
 *     there if desired.
 *
 * */

```

（1）修改虚拟起始地址
由背景知识知，gcc编译出的虚拟起始地址从0xC0100000开始，ucore被bootloader放置在从物理地址0x100000处开始的物理内存中，因此我们首先得将虚拟起始地址设置为0x100000。而ucore kernel各个部分由组成kernel的各个.o或.a文件构成，且各个部分在内存中地址位置由ld工具根据kernel.ld链接脚本（linker script）来设定。ld工具使用命令-T指定链接脚本。链接脚本主要用于规定如何把输入文件（各个.o或.a文件）内的section放入输出文件（lab2/bin/kernel，即ELF格式的ucore内核）内，并控制输出文件内各部分在程序地址空间内的布局。因此虚拟起始地址应该在kernel.ld中有所定义，其内容如下所示：
```
/* Simple linker script for the ucore kernel.
   See the GNU ld 'info' manual ("info ld") to learn the syntax. */

OUTPUT_FORMAT("elf32-i386", "elf32-i386", "elf32-i386")
OUTPUT_ARCH(i386)
ENTRY(kern_entry)

SECTIONS {
    /* Load the kernel at this address: "." means the current address */
    . = 0xC0100000; //改为0x100000

    .text : {
        *(.text .stub .text.* .gnu.linkonce.t.*)
    }

    PROVIDE(etext = .); /* Define the 'etext' symbol to this value */

    .rodata : {
        *(.rodata .rodata.* .gnu.linkonce.r.*)
    }

    /* Include debugging information in kernel memory */
    .stab : {
        PROVIDE(__STAB_BEGIN__ = .);
        *(.stab);
        PROVIDE(__STAB_END__ = .);
        BYTE(0)     /* Force the linker to allocate space
                   for this section */
    }

    .stabstr : {
        PROVIDE(__STABSTR_BEGIN__ = .);
        *(.stabstr);
        PROVIDE(__STABSTR_END__ = .);
        BYTE(0)     /* Force the linker to allocate space
                   for this section */
    }

    /* Adjust the address for the data segment to the next page */
    . = ALIGN(0x1000);

    /* The data segment */
    .data : {
        *(.data)
    }

    PROVIDE(edata = .);

    .bss : {
        *(.bss)
    }

    PROVIDE(end = .);

    /DISCARD/ : {
        *(.eh_frame .note.GNU-stack)
    }
}

```
其实从链接脚本的内容可知：内核加载地址：0xC0100000，入口（起始代码）地址： ENTRY(kern_entry)，cpu机器类型：i386。我们将0xC0100000，修改为0x100000。

（2）保留临时映射
在上一步中，ucore设置了虚拟地址 0 ~ 4M 到物理地址 0 ~ 4M 的映射以确保开启页表后kern_entry能够正常执行，在将 eip 修改为对应的虚拟地址（加KERNBASE）后就取消了这个临时映射。因为我们要让物理地址等于虚拟地址，所以保留这个映射不变，即将entry.S中movl %eax, __boot_pgdir这一行清除临时映射的代码注释掉。entry.S部分代码如下：

```
next:

    # unmap va 0 ~ 4M, it's temporary mapping
    #xorl %eax, %eax
    movl %eax, __boot_pgdir //注释掉

```

（3）修改KERNBASE
由背景知识得，最后虚拟地址和物理地址的映射关系满足：
physical address + KERNBASE = virtual address
因此我们需要将KERNBASE改为0，即在memlayout.h中修改KERNBASE:

```
/* All physical memory mapped at this address */
#define KERNBASE            0xc0000000 //改为0
#define KMEMSIZE            0x38000000                  // the maximum amount of physical memory
#define KERNTOP             (KERNBASE + KMEMSIZE)

```

由于我们修改了映射关系，因此我们还要在pmm_init中对check_pgdir和check_boot_pgdir的调用给注释掉，免得检查无法通过：

（4）修改boot_map_segment函数
完成以上操作后，理论上虚拟地址和物理地址的映射关系修改完毕，但是ucore会在boot_map_segment中设置页表后异常终止或跳转到别的地方执行。通过gdb调试，发现在设置boot_pgdir[1]时会获取和boot_pgdir[0]相同的页表。也就是说，页目录项 PDE 0 和 PDE 1共同指向同一个页表__boot_pt1，在设置虚拟地址4 ~ 8M 到物理地址 4 ~ 8M 的映射时，同时将虚拟地址地址0 ~ 4M 映射到了 4 ~ 8M ，导致ucore运行异常。
entry.S中这一段关于_boot_pgdir的代码或许能解释为什么会出现上述情况，但由于本人水平有限，因此暂且略过。

```
# kernel builtin pgdir
# an initial page directory (Page Directory Table, PDT)
# These page directory table and page table can be reused!
.section .data.pgdir
.align PGSIZE
__boot_pgdir:
.globl __boot_pgdir
    # map va 0 ~ 4M to pa 0 ~ 4M (temporary)
    .long REALLOC(__boot_pt1) + (PTE_P | PTE_U | PTE_W)
    .space (KERNBASE >> PGSHIFT >> 10 << 2) - (. - __boot_pgdir) # pad to PDE of KERNBASE
    # map va KERNBASE + (0 ~ 4M) to pa 0 ~ 4M
    .long REALLOC(__boot_pt1) + (PTE_P | PTE_U | PTE_W)
    .space PGSIZE - (. - __boot_pgdir) # pad to PGSIZE

```
想要解决这个问题，我们可以回到boot_map_segment函数中，将boot_pgdir[1]的Present位给设置为0，让get_pte函数重新分配，避免了boot_pgdir[1]获取错误以及麻烦的代码修改。

```
//boot_map_segment - setup&enable the paging mechanism
// parameters
//  la:   linear address of this memory need to map (after x86 segment map)
//  size: memory size
//  pa:   physical address of this memory
//  perm: permission of this memory  
static void
boot_map_segment(pde_t *pgdir, uintptr_t la, size_t size, uintptr_t pa, uint32_t perm) {
    boot_pgdir[1] &= ~PTE_P; //添加这一行
    assert(PGOFF(la) == PGOFF(pa));
    size_t n = ROUNDUP(size + PGOFF(la), PGSIZE) / PGSIZE;
    la = ROUNDDOWN(la, PGSIZE);
    pa = ROUNDDOWN(pa, PGSIZE);
    for (; n > 0; n --, la += PGSIZE, pa += PGSIZE) {
        pte_t *ptep = get_pte(pgdir, la, 1);
        assert(ptep != NULL);
        *ptep = pa | PTE_P | perm;
    }
}

```

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

​       基于上面的理论准备，我们可以开始写代码了。因为buddy system替代的是之前的first fit算法，所以可以仿照default_pmm的格式来写。

​       首先，编写buddy.h（仿照default_pmm.h），唯一修改的地方是引入的pmm_manager不一样，要改成buddy system所使用的buddy_pmm_manager

```C
#ifndef __KERN_MM_BUDDY_PMM_H__
#define  __KERN_MM_BUDDY_PMM_H__

#include <pmm.h>

extern const struct pmm_manager buddy_pmm_manager;

#endif /* ! __KERN_MM_DEFAULT_PMM_H__ */
```

​        而后，进入buddy.c文件

   1. 因为这里使用数组来表示二叉树结构，所以需要建立正确的索引机制：每level的第一左子树的下标为2^level-1，所以如果我们得到[index]节点的所在level，那么offset的计算可以归结为(index-2^level+1) * node_size = (index+1)*node_size – node_size*2^level。其中size的计算为2^(max_depth-level)，所以node_size * 2^level = 2^max_depth = size。综上所述，可得公式offset=(index+1)*node_size – size。
      PS：式中索引的下标均从0开始，size为内存总大小，node_size为内存块对应大小。

      由上，完成宏定义。

```C++
#define LEFT_LEAF(index) ((index) * 2 + 1)
#define RIGHT_LEAF(index) ((index) * 2 + 2)
#define PARENT(index) ( ((index) + 1) / 2 - 1)
```

          2.  因为buddy system的块大小都是2的倍数，所以我们对于输入的所需的块大小，要先计算出最接近于它的2的倍数的值以匹配buddy system的最合适块的查找。

```C
static unsigned fixsize(unsigned size) {
  size |= size >> 1;
  size |= size >> 2;
  size |= size >> 4;
  size |= size >> 8;
  size |= size >> 16;
  return size+1;
}
```

3. 构造buddy system最基本的数据结构，并初始化一个用来存放二叉树的数组。

```C++
struct buddy {
  unsigned size;//表明管理内存
  unsigned longest; 
};
struct buddy root[10000];//存放二叉树的数组，用于内存分配
```

4. buddy system是需要和实际指向空闲块双链表配合使用的，所以需要先各自初始化数组和指向空闲块的双链表。

```C++
//先初始化双链表
free_area_t free_area;
#define free_list (free_area.free_list)
#define nr_free (free_area.nr_free)

static void buddy_init()
{
    list_init(&free_list);
    nr_free=0;
}

//再初始化buddy system的数组
void buddy_new( int size ) {
  unsigned node_size;    //传入的size是这个buddy system表示的总空闲空间；node_size是对应节点所表示的空闲空间的块数
  int i;
  nr_block=0;
  if (size < 1 || !IS_POWER_OF_2(size))
    return;

  root[0].size = size;
  node_size = size * 2;   //认为总结点数是size*2

  for (i = 0; i < 2 * size - 1; ++i) {
    if (IS_POWER_OF_2(i+1))    //如果i+1是2的倍数，那么该节点所表示的二叉树就要到下一层了
      node_size /= 2;
    root[i].longest = node_size;   //longest是该节点所表示的初始空闲空间块数
  }
  return;
}
```

5. 根据pmm.h里面对于pmm_manager的统一结构化定义，我们需要对buddy system完成如下函数：

```C++
const struct pmm_manager buddy_pmm_manager = {
    .name = "buddy_pmm_manager",      // 管理器的名称
    .init = buddy_init,               // 初始化管理器
    .init_memmap = buddy_init_memmap, // 设置可管理的内存,初始化可分配的物理内存空间
    .alloc_pages = buddy_alloc_pages, // 分配>=N个连续物理页,返回分配块首地址指针 
    .free_pages = buddy_free_pages,   // 释放包括自Base基址在内的，起始的>=N个连续物理内存页
    .nr_free_pages = buddy_nr_free_pages, // 返回全局的空闲物理页数量
    .check = buddy_check,             //举例检测这个pmm_manager的正确性
};
```

​    5.1 初始化管理器（这个已在上面完成）

​    5.2 初始化可管理的物理内存空间

```C++
static void
buddy_init_memmap(struct Page *base, size_t n)
{
    assert(n>0);
    struct Page* p=base;
    for(;p!=base + n;p++)
    {
        assert(PageReserved(p));
        p->flags = 0;
        p->property = 1;
        set_page_ref(p, 0);    //表明空闲可用
        SetPageProperty(p);
        list_add_before(&free_list,&(p->page_link));     //向双链表中加入页的管理部分
    }
    nr_free += n;     //表示总共可用的空闲页数
    int allocpages=UINT32_ROUND_DOWN(n);
    buddy2_new(allocpages);    //传入所需要表示的总内存页大小，让buddy system的数组得以初始化
}
```

​    5.3 分配所需的物理页，返回分配块首地址指针

```C++
//分配的逻辑是：首先在buddy的“二叉树”结构中找到应该分配的物理页在整个实际双向链表中的位置，而后把相应的page进行标识表明该物理页已经分出去了。
static struct Page*
buddy_alloc_pages(size_t n){
  assert(n>0);
  if(n>nr_free)
   return NULL;
  struct Page* page=NULL;
  struct Page* p;
  list_entry_t *le=&free_list,*len;
  rec[nr_block].offset=buddy2_alloc(root,n);//记录偏移量
  int i;
  for(i=0;i<rec[nr_block].offset+1;i++)
    le=list_next(le);
  page=le2page(le,page_link);
  int allocpages;
  if(!IS_POWER_OF_2(n))
   allocpages=fixsize(n);
  else
  {
     allocpages=n;
  }
  //根据需求n得到块大小
  rec[nr_block].base=page;//记录分配块首页
  rec[nr_block].nr=allocpages;//记录分配的页数
  nr_block++;
  for(i=0;i<allocpages;i++)
  {
    len=list_next(le);
    p=le2page(le,page_link);
    ClearPageProperty(p);
    le=len;
  }//修改每一页的状态
  nr_free-=allocpages;//减去已被分配的页数
  page->property=n;
  return page;
}


//以下是在上面的分配物理内存函数中用到的结构和辅助函数
struct allocRecord//记录分配块的信息
{
  struct Page* base;
  int offset;
  size_t nr;//块大小，即包含了多少页
};

struct allocRecord rec[80000];//存放偏移量的数组
int nr_block;//已分配的块数

int buddy2_alloc(struct buddy2* self, int size) { //size就是这次要分配的物理页大小
  unsigned index = 0;  //节点的标号
  unsigned node_size;  //用于后续循环寻找合适的节点
  unsigned offset = 0;

  if (self==NULL)//无法分配
    return -1;

  if (size <= 0)//分配不合理
    size = 1;
  else if (!IS_POWER_OF_2(size))//不为2的幂时，取比size更大的2的n次幂
    size = fixsize(size);

  if (self[index].longest < size)//根据根节点的longest，发现可分配内存不足，也返回
    return -1;

  //从根节点开始，向下寻找左右子树里面找到最合适的节点
  for(node_size = self->size; node_size != size; node_size /= 2 ) {
    if (self[LEFT_LEAF(index)].longest >= size)
    {
       if(self[RIGHT_LEAF(index)].longest>=size)
        {
           index=self[LEFT_LEAF(index)].longest <= self[RIGHT_LEAF(index)].longest? LEFT_LEAF(index):RIGHT_LEAF(index);
         //找到两个相符合的节点中内存较小的结点
        }
       else
       {
         index=LEFT_LEAF(index);
       }  
    }
    else
      index = RIGHT_LEAF(index);
  }

  self[index].longest = 0;//标记节点为已使用
  offset = (index + 1) * node_size - self->size;  //offset得到的是该物理页在双向链表中距离“根节点”的偏移
  //这个节点被标记使用后，要层层向上回溯，改变父节点的longest值
  while (index) {
    index = PARENT(index);
    self[index].longest = 
      MAX(self[LEFT_LEAF(index)].longest, self[RIGHT_LEAF(index)].longest);
  }
  return offset;
}

```

   5.4 释放指定的内存页大小

```C++
void buddy_free_pages(struct Page* base, size_t n) {
  unsigned node_size, index = 0;
  unsigned left_longest, right_longest;
  struct buddy2* self=root;
  
  list_entry_t *le=list_next(&free_list);
  int i=0;
  for(i=0;i<nr_block;i++)  //nr_block是已分配的块数
  {
    if(rec[i].base==base)  
     break;
  }
  int offset=rec[i].offset;
  int pos=i;//暂存i
  i=0;
  while(i<offset)
  {
    le=list_next(le);
    i++;     //根据该分配块的记录信息，可以找到双链表中对应的page
  }
  int allocpages;
  if(!IS_POWER_OF_2(n))
   allocpages=fixsize(n);
  else
  {
     allocpages=n;
  }
  assert(self && offset >= 0 && offset < self->size);//是否合法
  nr_free+=allocpages;//更新空闲页的数量
  struct Page* p;
  for(i=0;i<allocpages;i++)//回收已分配的页
  {
     p=le2page(le,page_link);
     p->flags=0;
     p->property=1;
     SetPageProperty(p);
     le=list_next(le);
  }
  
  //实际的双链表信息复原后，还要对“二叉树”里面的节点信息进行更新
  node_size = 1;
  index = offset + self->size - 1;   //从原始的分配节点的最底节点开始改变longest
  self[index].longest = node_size;   //这里应该是node_size，也就是从1那层开始改变
  while (index) {//向上合并，修改父节点的记录值
    index = PARENT(index);
    node_size *= 2;
    left_longest = self[LEFT_LEAF(index)].longest;
    right_longest = self[RIGHT_LEAF(index)].longest;
    
    if (left_longest + right_longest == node_size) 
      self[index].longest = node_size;
    else
      self[index].longest = MAX(left_longest, right_longest);
  }
  for(i=pos;i<nr_block-1;i++)//清除此次的分配记录，即从分配数组里面把后面的数据往前挪
  {
    rec[i]=rec[i+1];
  }
  nr_block--;//更新分配块数的值
}
```

   5.5 返回全局的空闲物理页数

```C++
static size_t
buddy_nr_free_pages(void) {
    return nr_free;
}
```

​    5.6 检查这个pmm_manager是否正确

```C++
//以下是一个测试函数
static void
buddy_check(void) {
    struct Page  *A, *B;
    A = B  =NULL;

    assert((A = alloc_page()) != NULL);
    assert((B = alloc_page()) != NULL);

    assert( A != B);
    assert(page_ref(A) == 0 && page_ref(B) == 0);
  //free page就是free pages(p0,1)
    free_page(A);
    free_page(B);
    
    A=alloc_pages(500);     //alloc_pages返回的是开始分配的那一页的地址
    B=alloc_pages(500);
    cprintf("A %p\n",A);
    cprintf("B %p\n",B);
    free_pages(A,250);     //free_pages没有返回值
    free_pages(B,500);
    free_pages(A+250,250);
    
}
```



## Challenge2：任意大小的内存单元slub分配算法(需要编程)

> slub算法，实现两层架构的高效内存单元分配，第一层是基于页大小的内存分配，第二层是在 第一层基础上实现基于任意大小的内存分配。可简化实现，能够体现其主体思想即可。 
>
> - 参考linux的slub分配算法/，在ucore中实现slub分配算法。要求有比较充分的测试用例说 明实现的正确性，需要有设计文档。

上一个challenge中的buddy system像是一个批发商，按页批发大量的内存。但是很多时候你买东西并不需要去批发，而是去零售。零售商就是我们的slub分配算法。slub运行在buddy system之上，为内核（客户）提供小内存的管理功能。

slub算法将内存分组管理，每个组分别为2^3^,2^4^,2^5^,...,2^11^B和两个特殊组96B和192B。为什么这么分，因为我们的页大小默认为4KB=2^12^B，也就是说如果我们需要大于等于2^12^B的内存，就用buddy system批发，而需要小内存的时候就用slub来分配就行。

我们可以用一个kmem_cache数组 kmalloc_caches[12]来存放上面的12个组，可以把kmem_cache想象为12个零售商，每个零售商只卖一种东西。零售商有自己的仓库和自己的店面，店面里只有一个slab，如果slab卖完了再从仓库中换出其他的slab。

在slub的使用过程中有如下几种情况

1. 刚刚创建slub系统，第一次申请空间

   此时slub刚刚建立起来，不管是仓库还是店面都没有slab，这个时候首先需要从buddy system中申请空闲的内存页，然后把这些内存页slub划分为很多的零售品object，选择一个摆在商店中，剩下的放在仓库里。然后把商品中分一个给顾客

2. 商店里有可用的object

   这个时候就直接给呗，还能不给的咯

3. 商店没东西，仓库有

   从仓库里换出一个新的空的slub，并分一个空闲object给顾客

4. 商店和仓库都没有了

   这个时候只能重新批发新的slub回来，重复1

至于其他的嘛...

![1.jpg](https://i.loli.net/2020/11/13/pYGHkwqbLjKsQWr.jpg)

我是真的不会了，写了400多行bug的挫败感确实有点大，等过段时间把手上的活忙完了再写。