#include <list.h>
#include <sync.h>
#include <proc.h>
#include <sched.h>
#include <assert.h>

void
wakeup_proc(struct proc_struct *proc) {
    assert(proc->state != PROC_ZOMBIE && proc->state != PROC_RUNNABLE);
    proc->state = PROC_RUNNABLE;
}

void schedule(void) {
    bool intr_flag;
    list_entry_t *le, *last;
    struct proc_struct *next = NULL;
    // 暂时关闭中断，避免被中断打断，引起并发问题
    local_intr_save(intr_flag);
    {
        // 令current线程处于不需要调度的状态
        current->need_resched = 0;
        // lab4中暂时没有更多的线程，没有引入线程调度框架，而是直接先进先出的获取init_main线程进行调度
        last = (current == idleproc) ? &proc_list : &(current->list_link);
        le = last;
        do {
            if ((le = list_next(le)) != &proc_list) {
                next = le2proc(le, list_link);
                // 找到一个处于PROC_RUNNABLE就绪态的线程
                if (next->state == PROC_RUNNABLE) {
                    break;
                }
            }
        } while (le != last);
        if (next == NULL || next->state != PROC_RUNNABLE) {
            // 没有找到，则next指向idleproc线程
            next = idleproc;
        }
        // 找到的需要被调度的next线程runs自增
        next->runs++;
        if (next != current) {
            // next与current进行上下文切换，令next获得CPU资源
            proc_run(next);
        }
    }
    // 恢复中断
    local_intr_restore(intr_flag);
}

