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
