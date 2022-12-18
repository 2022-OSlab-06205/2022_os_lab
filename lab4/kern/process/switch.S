.text
.globl switch_to
switch_to:                      # switch_to(from, to)

    # save from registers
    # 令eax保存第一个参数from(context)的地址
    movl 4(%esp), %eax          # eax points to from
    # from.context 保存eip、esp等等寄存器的当前快照值
    popl 0(%eax)                # save eip !popl
    movl %esp, 4(%eax)          # save esp::context of from
    movl %ebx, 8(%eax)          # save ebx::context of from
    movl %ecx, 12(%eax)         # save ecx::context of from
    movl %edx, 16(%eax)         # save edx::context of from
    movl %esi, 20(%eax)         # save esi::context of from
    movl %edi, 24(%eax)         # save edi::context of from
    movl %ebp, 28(%eax)         # save ebp::context of from

    # restore to registers
    # 令eax保存第二个参数next(context)的地址,因为之前popl了一次，所以4(%esp)目前指向第二个参数
    movl 4(%esp), %eax          # not 8(%esp): popped return address already
                                # eax now points to to
    # 恢复next.context中的各个寄存器的值
    movl 28(%eax), %ebp         # restore ebp::context of to
    movl 24(%eax), %edi         # restore edi::context of to
    movl 20(%eax), %esi         # restore esi::context of to
    movl 16(%eax), %edx         # restore edx::context of to
    movl 12(%eax), %ecx         # restore ecx::context of to
    movl 8(%eax), %ebx          # restore ebx::context of to
    movl 4(%eax), %esp          # restore esp::context of to
    pushl 0(%eax)               # push eip

    # ret时栈上的eip为next(context)中设置的值(fork时，eip指向forkret,esp指向分配好的trap_frame)
    ret