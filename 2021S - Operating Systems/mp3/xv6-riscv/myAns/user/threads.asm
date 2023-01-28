
user/_threads:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <thread_create>:
static int __time_slot_size = 10;
static int is_thread_start = 0;
static jmp_buf env_st;
// static jmp_buf env_tmp;

struct thread *thread_create(void (*f)(void *), void *arg, int execution_time_slot){
   0:	7179                	addi	sp,sp,-48
   2:	f406                	sd	ra,40(sp)
   4:	f022                	sd	s0,32(sp)
   6:	ec26                	sd	s1,24(sp)
   8:	e84a                	sd	s2,16(sp)
   a:	e44e                	sd	s3,8(sp)
   c:	e052                	sd	s4,0(sp)
   e:	1800                	addi	s0,sp,48
  10:	8a2a                	mv	s4,a0
  12:	89ae                	mv	s3,a1
  14:	8932                	mv	s2,a2
    struct thread *t = (struct thread*) malloc(sizeof(struct thread));
  16:	0c800513          	li	a0,200
  1a:	00001097          	auipc	ra,0x1
  1e:	a4e080e7          	jalr	-1458(ra) # a68 <malloc>
  22:	84aa                	mv	s1,a0
    //unsigned long stack_p = 0;
    unsigned long new_stack_p;
    unsigned long new_stack;
    new_stack = (unsigned long) malloc(sizeof(unsigned long)*0x100);
  24:	6505                	lui	a0,0x1
  26:	80050513          	addi	a0,a0,-2048 # 800 <vprintf+0x62>
  2a:	00001097          	auipc	ra,0x1
  2e:	a3e080e7          	jalr	-1474(ra) # a68 <malloc>
    new_stack_p = new_stack +0x100*8-0x2*8;
    t->fp = f;
  32:	0144b023          	sd	s4,0(s1)
    t->arg = arg;
  36:	0134b423          	sd	s3,8(s1)
    t->ID  = -1;
  3a:	57fd                	li	a5,-1
  3c:	08f4a823          	sw	a5,144(s1)
    t->buf_set = 0;
  40:	0804ae23          	sw	zero,156(s1)
    t->stack = (void*) new_stack;
  44:	e888                	sd	a0,16(s1)
    new_stack_p = new_stack +0x100*8-0x2*8;
  46:	7f050513          	addi	a0,a0,2032
    t->stack_p = (void*) new_stack_p;
  4a:	ec88                	sd	a0,24(s1)

    if( is_thread_start == 0 )
  4c:	00001797          	auipc	a5,0x1
  50:	bec7a783          	lw	a5,-1044(a5) # c38 <is_thread_start>
  54:	c799                	beqz	a5,62 <thread_create+0x62>
        t->remain_execution_time = execution_time_slot;
    else
        t->remain_execution_time = execution_time_slot * __time_slot_size;
  56:	00001797          	auipc	a5,0x1
  5a:	bd67a783          	lw	a5,-1066(a5) # c2c <__time_slot_size>
  5e:	0327893b          	mulw	s2,a5,s2
  62:	0b24aa23          	sw	s2,180(s1)

    t->is_yield = 0;
  66:	0a04ae23          	sw	zero,188(s1)
    t->is_exited = 0;
  6a:	0c04a023          	sw	zero,192(s1)
    return t;
}
  6e:	8526                	mv	a0,s1
  70:	70a2                	ld	ra,40(sp)
  72:	7402                	ld	s0,32(sp)
  74:	64e2                	ld	s1,24(sp)
  76:	6942                	ld	s2,16(sp)
  78:	69a2                	ld	s3,8(sp)
  7a:	6a02                	ld	s4,0(sp)
  7c:	6145                	addi	sp,sp,48
  7e:	8082                	ret

0000000000000080 <thread_add_runqueue>:
void thread_add_runqueue(struct thread *t){
  80:	1101                	addi	sp,sp,-32
  82:	ec06                	sd	ra,24(sp)
  84:	e822                	sd	s0,16(sp)
  86:	e426                	sd	s1,8(sp)
  88:	1000                	addi	s0,sp,32
  8a:	84aa                	mv	s1,a0
    t->start_time = uptime();
  8c:	00000097          	auipc	ra,0x0
  90:	626080e7          	jalr	1574(ra) # 6b2 <uptime>
  94:	0aa4ac23          	sw	a0,184(s1)
    t->ID  = id;
  98:	00001717          	auipc	a4,0x1
  9c:	b9870713          	addi	a4,a4,-1128 # c30 <id>
  a0:	431c                	lw	a5,0(a4)
  a2:	08f4a823          	sw	a5,144(s1)
    id ++;
  a6:	2785                	addiw	a5,a5,1
  a8:	c31c                	sw	a5,0(a4)
    if(current_thread == NULL){
  aa:	00001797          	auipc	a5,0x1
  ae:	b967b783          	ld	a5,-1130(a5) # c40 <current_thread>
  b2:	c395                	beqz	a5,d6 <thread_add_runqueue+0x56>
        current_thread->previous = t;
        current_thread->next = t;
        return;
    }
    else{
        if(current_thread->previous->ID == current_thread->ID){
  b4:	73d8                	ld	a4,160(a5)
  b6:	09072603          	lw	a2,144(a4)
  ba:	0907a683          	lw	a3,144(a5)
  be:	02d60363          	beq	a2,a3,e4 <thread_add_runqueue+0x64>
            t->previous = current_thread;
            t->next = current_thread;
        }
        else{
            //Two or more threads in queue
            current_thread->previous->next = t;
  c2:	f744                	sd	s1,168(a4)
            t->previous = current_thread->previous;
  c4:	73d8                	ld	a4,160(a5)
  c6:	f0d8                	sd	a4,160(s1)
            t->next = current_thread;
  c8:	f4dc                	sd	a5,168(s1)
            current_thread->previous = t;
  ca:	f3c4                	sd	s1,160(a5)
        }
    }
}
  cc:	60e2                	ld	ra,24(sp)
  ce:	6442                	ld	s0,16(sp)
  d0:	64a2                	ld	s1,8(sp)
  d2:	6105                	addi	sp,sp,32
  d4:	8082                	ret
        current_thread = t;
  d6:	00001797          	auipc	a5,0x1
  da:	b697b523          	sd	s1,-1174(a5) # c40 <current_thread>
        current_thread->previous = t;
  de:	f0c4                	sd	s1,160(s1)
        current_thread->next = t;
  e0:	f4c4                	sd	s1,168(s1)
        return;
  e2:	b7ed                	j	cc <thread_add_runqueue+0x4c>
            current_thread->previous = t;
  e4:	f3c4                	sd	s1,160(a5)
            current_thread->next = t;
  e6:	f7c4                	sd	s1,168(a5)
            t->previous = current_thread;
  e8:	f0dc                	sd	a5,160(s1)
            t->next = current_thread;
  ea:	f4dc                	sd	a5,168(s1)
  ec:	b7c5                	j	cc <thread_add_runqueue+0x4c>

00000000000000ee <schedule>:


    }
    thread_exit();
}
void schedule(void){
  ee:	1141                	addi	sp,sp,-16
  f0:	e422                	sd	s0,8(sp)
  f2:	0800                	addi	s0,sp,16
    /////////////// default ////////////////
    if( is_thread_start == 0 )
  f4:	00001797          	auipc	a5,0x1
  f8:	b447a783          	lw	a5,-1212(a5) # c38 <is_thread_start>
  fc:	cb81                	beqz	a5,10c <schedule+0x1e>
        return;
    else
        current_thread = current_thread->next;
  fe:	00001797          	auipc	a5,0x1
 102:	b4278793          	addi	a5,a5,-1214 # c40 <current_thread>
 106:	6398                	ld	a4,0(a5)
 108:	7758                	ld	a4,168(a4)
 10a:	e398                	sd	a4,0(a5)
    //     t = t->next;
    // }
    // //printf("PSJF schedule from ID=%d(r.time=%d) to ID=%d(r.time=%d)\n", current_thread->ID, current_thread->remain_execution_time,candidate->ID, candidate->remain_execution_time);
    // current_thread = candidate;
    // return ;
}
 10c:	6422                	ld	s0,8(sp)
 10e:	0141                	addi	sp,sp,16
 110:	8082                	ret

0000000000000112 <thread_exit>:

void thread_exit(void){
 112:	1101                	addi	sp,sp,-32
 114:	ec06                	sd	ra,24(sp)
 116:	e822                	sd	s0,16(sp)
 118:	e426                	sd	s1,8(sp)
 11a:	e04a                	sd	s2,0(sp)
 11c:	1000                	addi	s0,sp,32
    // remove the thread immediately, and cancel previous thrdstop.
    thrdresume(current_thread->thrdstop_context_id, 1);
 11e:	00001497          	auipc	s1,0x1
 122:	b2248493          	addi	s1,s1,-1246 # c40 <current_thread>
 126:	609c                	ld	a5,0(s1)
 128:	4585                	li	a1,1
 12a:	0b07a503          	lw	a0,176(a5)
 12e:	00000097          	auipc	ra,0x0
 132:	594080e7          	jalr	1428(ra) # 6c2 <thrdresume>
    struct thread* to_remove = current_thread;
 136:	6084                	ld	s1,0(s1)
    printf("thread id %d exec %d ticks\n", to_remove->ID, uptime() - to_remove->start_time);
 138:	0904a903          	lw	s2,144(s1)
 13c:	00000097          	auipc	ra,0x0
 140:	576080e7          	jalr	1398(ra) # 6b2 <uptime>
 144:	0b84a603          	lw	a2,184(s1)
 148:	40c5063b          	subw	a2,a0,a2
 14c:	85ca                	mv	a1,s2
 14e:	00001517          	auipc	a0,0x1
 152:	a7a50513          	addi	a0,a0,-1414 # bc8 <longjmp_1+0xa>
 156:	00001097          	auipc	ra,0x1
 15a:	854080e7          	jalr	-1964(ra) # 9aa <printf>

    to_remove->is_exited = 1;
 15e:	4785                	li	a5,1
 160:	0cf4a023          	sw	a5,192(s1)

    if(to_remove->next != to_remove){
 164:	74dc                	ld	a5,168(s1)
 166:	02978e63          	beq	a5,s1,1a2 <thread_exit+0x90>
        //Still more thread to execute
        schedule() ;
 16a:	00000097          	auipc	ra,0x0
 16e:	f84080e7          	jalr	-124(ra) # ee <schedule>
        //Connect the remaining threads
        struct thread* to_remove_next = to_remove->next;
 172:	74d8                	ld	a4,168(s1)
        to_remove_next->previous = to_remove->previous;
 174:	70dc                	ld	a5,160(s1)
 176:	f35c                	sd	a5,160(a4)
        to_remove->previous->next = to_remove_next;
 178:	f7d8                	sd	a4,168(a5)


        //free pointers
        free(to_remove->stack);
 17a:	6888                	ld	a0,16(s1)
 17c:	00001097          	auipc	ra,0x1
 180:	864080e7          	jalr	-1948(ra) # 9e0 <free>
        free(to_remove);
 184:	8526                	mv	a0,s1
 186:	00001097          	auipc	ra,0x1
 18a:	85a080e7          	jalr	-1958(ra) # 9e0 <free>
        dispatch();
 18e:	00000097          	auipc	ra,0x0
 192:	028080e7          	jalr	40(ra) # 1b6 <dispatch>
    }
    else{
        //No more thread to execute
        longjmp(env_st, -1);
    }
}
 196:	60e2                	ld	ra,24(sp)
 198:	6442                	ld	s0,16(sp)
 19a:	64a2                	ld	s1,8(sp)
 19c:	6902                	ld	s2,0(sp)
 19e:	6105                	addi	sp,sp,32
 1a0:	8082                	ret
        longjmp(env_st, -1);
 1a2:	55fd                	li	a1,-1
 1a4:	00001517          	auipc	a0,0x1
 1a8:	aac50513          	addi	a0,a0,-1364 # c50 <env_st>
 1ac:	00001097          	auipc	ra,0x1
 1b0:	9d8080e7          	jalr	-1576(ra) # b84 <longjmp>
}
 1b4:	b7cd                	j	196 <thread_exit+0x84>

00000000000001b6 <dispatch>:
void dispatch(void){
 1b6:	1101                	addi	sp,sp,-32
 1b8:	ec06                	sd	ra,24(sp)
 1ba:	e822                	sd	s0,16(sp)
 1bc:	e426                	sd	s1,8(sp)
 1be:	e04a                	sd	s2,0(sp)
 1c0:	1000                	addi	s0,sp,32
    if(current_thread->buf_set)
 1c2:	00001497          	auipc	s1,0x1
 1c6:	a7e4b483          	ld	s1,-1410(s1) # c40 <current_thread>
 1ca:	09c4a783          	lw	a5,156(s1)
 1ce:	cfb1                	beqz	a5,22a <dispatch+0x74>
        thrdstop( next_time, current_thread->thrdstop_context_id, my_thrdstop_handler); // after next_time ticks, my_thrdstop_handler will be called.
 1d0:	0b04a583          	lw	a1,176(s1)
        int next_time = (__time_slot_size >= current_thread->remain_execution_time )? current_thread->remain_execution_time: __time_slot_size;
 1d4:	00001797          	auipc	a5,0x1
 1d8:	a587a783          	lw	a5,-1448(a5) # c2c <__time_slot_size>
 1dc:	0b44a503          	lw	a0,180(s1)
 1e0:	0005069b          	sext.w	a3,a0
 1e4:	0007871b          	sext.w	a4,a5
 1e8:	00d75363          	bge	a4,a3,1ee <dispatch+0x38>
 1ec:	853e                	mv	a0,a5
        thrdstop( next_time, current_thread->thrdstop_context_id, my_thrdstop_handler); // after next_time ticks, my_thrdstop_handler will be called.
 1ee:	00000617          	auipc	a2,0x0
 1f2:	09860613          	addi	a2,a2,152 # 286 <my_thrdstop_handler>
 1f6:	2501                	sext.w	a0,a0
 1f8:	00000097          	auipc	ra,0x0
 1fc:	4c2080e7          	jalr	1218(ra) # 6ba <thrdstop>
        thrdresume(current_thread->thrdstop_context_id, 0);
 200:	4581                	li	a1,0
 202:	00001797          	auipc	a5,0x1
 206:	a3e7b783          	ld	a5,-1474(a5) # c40 <current_thread>
 20a:	0b07a503          	lw	a0,176(a5)
 20e:	00000097          	auipc	ra,0x0
 212:	4b4080e7          	jalr	1204(ra) # 6c2 <thrdresume>
    thread_exit();
 216:	00000097          	auipc	ra,0x0
 21a:	efc080e7          	jalr	-260(ra) # 112 <thread_exit>
}
 21e:	60e2                	ld	ra,24(sp)
 220:	6442                	ld	s0,16(sp)
 222:	64a2                	ld	s1,8(sp)
 224:	6902                	ld	s2,0(sp)
 226:	6105                	addi	sp,sp,32
 228:	8082                	ret
        current_thread->buf_set = 1;
 22a:	4785                	li	a5,1
 22c:	08f4ae23          	sw	a5,156(s1)
        new_stack_p = (unsigned long) current_thread->stack_p;
 230:	0184b903          	ld	s2,24(s1)
        current_thread->thrdstop_context_id = thrdstop( __time_slot_size, -1, my_thrdstop_handler);
 234:	00000617          	auipc	a2,0x0
 238:	05260613          	addi	a2,a2,82 # 286 <my_thrdstop_handler>
 23c:	55fd                	li	a1,-1
 23e:	00001517          	auipc	a0,0x1
 242:	9ee52503          	lw	a0,-1554(a0) # c2c <__time_slot_size>
 246:	00000097          	auipc	ra,0x0
 24a:	474080e7          	jalr	1140(ra) # 6ba <thrdstop>
 24e:	0aa4a823          	sw	a0,176(s1)
        if( current_thread->thrdstop_context_id < 0 )
 252:	00001797          	auipc	a5,0x1
 256:	9ee7b783          	ld	a5,-1554(a5) # c40 <current_thread>
 25a:	0b07a703          	lw	a4,176(a5)
 25e:	00074763          	bltz	a4,26c <dispatch+0xb6>
        asm volatile("mv sp, %0" : : "r" (new_stack_p));
 262:	814a                	mv	sp,s2
        current_thread->fp(current_thread->arg);
 264:	6398                	ld	a4,0(a5)
 266:	6788                	ld	a0,8(a5)
 268:	9702                	jalr	a4
 26a:	b775                	j	216 <dispatch+0x60>
            printf("error: number of threads may exceed\n");
 26c:	00001517          	auipc	a0,0x1
 270:	97c50513          	addi	a0,a0,-1668 # be8 <longjmp_1+0x2a>
 274:	00000097          	auipc	ra,0x0
 278:	736080e7          	jalr	1846(ra) # 9aa <printf>
            exit(1);
 27c:	4505                	li	a0,1
 27e:	00000097          	auipc	ra,0x0
 282:	39c080e7          	jalr	924(ra) # 61a <exit>

0000000000000286 <my_thrdstop_handler>:
void my_thrdstop_handler(void){
 286:	1141                	addi	sp,sp,-16
 288:	e406                	sd	ra,8(sp)
 28a:	e022                	sd	s0,0(sp)
 28c:	0800                	addi	s0,sp,16
    current_thread->remain_execution_time -= __time_slot_size ;
 28e:	00001717          	auipc	a4,0x1
 292:	9b273703          	ld	a4,-1614(a4) # c40 <current_thread>
 296:	0b472783          	lw	a5,180(a4)
 29a:	00001697          	auipc	a3,0x1
 29e:	9926a683          	lw	a3,-1646(a3) # c2c <__time_slot_size>
 2a2:	9f95                	subw	a5,a5,a3
 2a4:	0007869b          	sext.w	a3,a5
 2a8:	0af72a23          	sw	a5,180(a4)
    if( current_thread->remain_execution_time <= 0 )
 2ac:	00d05e63          	blez	a3,2c8 <my_thrdstop_handler+0x42>
        schedule();
 2b0:	00000097          	auipc	ra,0x0
 2b4:	e3e080e7          	jalr	-450(ra) # ee <schedule>
        dispatch();
 2b8:	00000097          	auipc	ra,0x0
 2bc:	efe080e7          	jalr	-258(ra) # 1b6 <dispatch>
}
 2c0:	60a2                	ld	ra,8(sp)
 2c2:	6402                	ld	s0,0(sp)
 2c4:	0141                	addi	sp,sp,16
 2c6:	8082                	ret
        thread_exit();
 2c8:	00000097          	auipc	ra,0x0
 2cc:	e4a080e7          	jalr	-438(ra) # 112 <thread_exit>
 2d0:	bfc5                	j	2c0 <my_thrdstop_handler+0x3a>

00000000000002d2 <thread_yield>:
void thread_yield(void){
 2d2:	1101                	addi	sp,sp,-32
 2d4:	ec06                	sd	ra,24(sp)
 2d6:	e822                	sd	s0,16(sp)
 2d8:	e426                	sd	s1,8(sp)
 2da:	1000                	addi	s0,sp,32
    int consume_ticks = cancelthrdstop( current_thread->thrdstop_context_id ); // cancel previous thrdstop and save the current thread context
 2dc:	00001497          	auipc	s1,0x1
 2e0:	96448493          	addi	s1,s1,-1692 # c40 <current_thread>
 2e4:	609c                	ld	a5,0(s1)
 2e6:	0b07a503          	lw	a0,176(a5)
 2ea:	00000097          	auipc	ra,0x0
 2ee:	3e0080e7          	jalr	992(ra) # 6ca <cancelthrdstop>
    if( current_thread->is_yield == 0 )
 2f2:	609c                	ld	a5,0(s1)
 2f4:	0bc7a703          	lw	a4,188(a5)
 2f8:	ef05                	bnez	a4,330 <thread_yield+0x5e>
        current_thread->remain_execution_time -= consume_ticks ;
 2fa:	0b47a703          	lw	a4,180(a5)
 2fe:	40a7053b          	subw	a0,a4,a0
 302:	0005071b          	sext.w	a4,a0
 306:	0aa7aa23          	sw	a0,180(a5)
        current_thread->is_yield = 1;
 30a:	4685                	li	a3,1
 30c:	0ad7ae23          	sw	a3,188(a5)
        if( current_thread->remain_execution_time <= 0 )
 310:	00e05b63          	blez	a4,326 <thread_yield+0x54>
            schedule();
 314:	00000097          	auipc	ra,0x0
 318:	dda080e7          	jalr	-550(ra) # ee <schedule>
            dispatch();
 31c:	00000097          	auipc	ra,0x0
 320:	e9a080e7          	jalr	-358(ra) # 1b6 <dispatch>
 324:	a801                	j	334 <thread_yield+0x62>
            thread_exit();
 326:	00000097          	auipc	ra,0x0
 32a:	dec080e7          	jalr	-532(ra) # 112 <thread_exit>
 32e:	a019                	j	334 <thread_yield+0x62>
        current_thread->is_yield = 0;
 330:	0a07ae23          	sw	zero,188(a5)
}
 334:	60e2                	ld	ra,24(sp)
 336:	6442                	ld	s0,16(sp)
 338:	64a2                	ld	s1,8(sp)
 33a:	6105                	addi	sp,sp,32
 33c:	8082                	ret

000000000000033e <thread_start_threading>:
void thread_start_threading(int time_slot_size){
 33e:	1141                	addi	sp,sp,-16
 340:	e406                	sd	ra,8(sp)
 342:	e022                	sd	s0,0(sp)
 344:	0800                	addi	s0,sp,16
    __time_slot_size = time_slot_size;
 346:	00001797          	auipc	a5,0x1
 34a:	8ea7a323          	sw	a0,-1818(a5) # c2c <__time_slot_size>

    struct thread* tmp_thread = current_thread;
 34e:	00001697          	auipc	a3,0x1
 352:	8f26b683          	ld	a3,-1806(a3) # c40 <current_thread>
 356:	87b6                	mv	a5,a3
    while (tmp_thread != NULL)
 358:	cb91                	beqz	a5,36c <thread_start_threading+0x2e>
    {
        tmp_thread->remain_execution_time *= time_slot_size;
 35a:	0b47a703          	lw	a4,180(a5)
 35e:	02a7073b          	mulw	a4,a4,a0
 362:	0ae7aa23          	sw	a4,180(a5)
        tmp_thread = tmp_thread->next;
 366:	77dc                	ld	a5,168(a5)
        if( tmp_thread == current_thread )
 368:	fef698e3          	bne	a3,a5,358 <thread_start_threading+0x1a>
            break;
    }

    int r;
    r = setjmp(env_st);
 36c:	00001517          	auipc	a0,0x1
 370:	8e450513          	addi	a0,a0,-1820 # c50 <env_st>
 374:	00000097          	auipc	ra,0x0
 378:	7d8080e7          	jalr	2008(ra) # b4c <setjmp>

    if(current_thread != NULL && r==0){
 37c:	00001797          	auipc	a5,0x1
 380:	8c47b783          	ld	a5,-1852(a5) # c40 <current_thread>
 384:	c391                	beqz	a5,388 <thread_start_threading+0x4a>
 386:	c509                	beqz	a0,390 <thread_start_threading+0x52>
        schedule() ;
        is_thread_start = 1;
        dispatch();
    }
}
 388:	60a2                	ld	ra,8(sp)
 38a:	6402                	ld	s0,0(sp)
 38c:	0141                	addi	sp,sp,16
 38e:	8082                	ret
        schedule() ;
 390:	00000097          	auipc	ra,0x0
 394:	d5e080e7          	jalr	-674(ra) # ee <schedule>
        is_thread_start = 1;
 398:	4785                	li	a5,1
 39a:	00001717          	auipc	a4,0x1
 39e:	88f72f23          	sw	a5,-1890(a4) # c38 <is_thread_start>
        dispatch();
 3a2:	00000097          	auipc	ra,0x0
 3a6:	e14080e7          	jalr	-492(ra) # 1b6 <dispatch>
}
 3aa:	bff9                	j	388 <thread_start_threading+0x4a>

00000000000003ac <strcpy>:
#include "kernel/fcntl.h"
#include "user/user.h"

char*
strcpy(char *s, const char *t)
{
 3ac:	1141                	addi	sp,sp,-16
 3ae:	e422                	sd	s0,8(sp)
 3b0:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 3b2:	87aa                	mv	a5,a0
 3b4:	0585                	addi	a1,a1,1
 3b6:	0785                	addi	a5,a5,1
 3b8:	fff5c703          	lbu	a4,-1(a1)
 3bc:	fee78fa3          	sb	a4,-1(a5)
 3c0:	fb75                	bnez	a4,3b4 <strcpy+0x8>
    ;
  return os;
}
 3c2:	6422                	ld	s0,8(sp)
 3c4:	0141                	addi	sp,sp,16
 3c6:	8082                	ret

00000000000003c8 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 3c8:	1141                	addi	sp,sp,-16
 3ca:	e422                	sd	s0,8(sp)
 3cc:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 3ce:	00054783          	lbu	a5,0(a0)
 3d2:	cb91                	beqz	a5,3e6 <strcmp+0x1e>
 3d4:	0005c703          	lbu	a4,0(a1)
 3d8:	00f71763          	bne	a4,a5,3e6 <strcmp+0x1e>
    p++, q++;
 3dc:	0505                	addi	a0,a0,1
 3de:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 3e0:	00054783          	lbu	a5,0(a0)
 3e4:	fbe5                	bnez	a5,3d4 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 3e6:	0005c503          	lbu	a0,0(a1)
}
 3ea:	40a7853b          	subw	a0,a5,a0
 3ee:	6422                	ld	s0,8(sp)
 3f0:	0141                	addi	sp,sp,16
 3f2:	8082                	ret

00000000000003f4 <strlen>:

uint
strlen(const char *s)
{
 3f4:	1141                	addi	sp,sp,-16
 3f6:	e422                	sd	s0,8(sp)
 3f8:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 3fa:	00054783          	lbu	a5,0(a0)
 3fe:	cf91                	beqz	a5,41a <strlen+0x26>
 400:	0505                	addi	a0,a0,1
 402:	87aa                	mv	a5,a0
 404:	4685                	li	a3,1
 406:	9e89                	subw	a3,a3,a0
 408:	00f6853b          	addw	a0,a3,a5
 40c:	0785                	addi	a5,a5,1
 40e:	fff7c703          	lbu	a4,-1(a5)
 412:	fb7d                	bnez	a4,408 <strlen+0x14>
    ;
  return n;
}
 414:	6422                	ld	s0,8(sp)
 416:	0141                	addi	sp,sp,16
 418:	8082                	ret
  for(n = 0; s[n]; n++)
 41a:	4501                	li	a0,0
 41c:	bfe5                	j	414 <strlen+0x20>

000000000000041e <memset>:

void*
memset(void *dst, int c, uint n)
{
 41e:	1141                	addi	sp,sp,-16
 420:	e422                	sd	s0,8(sp)
 422:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 424:	ca19                	beqz	a2,43a <memset+0x1c>
 426:	87aa                	mv	a5,a0
 428:	1602                	slli	a2,a2,0x20
 42a:	9201                	srli	a2,a2,0x20
 42c:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 430:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 434:	0785                	addi	a5,a5,1
 436:	fee79de3          	bne	a5,a4,430 <memset+0x12>
  }
  return dst;
}
 43a:	6422                	ld	s0,8(sp)
 43c:	0141                	addi	sp,sp,16
 43e:	8082                	ret

0000000000000440 <strchr>:

char*
strchr(const char *s, char c)
{
 440:	1141                	addi	sp,sp,-16
 442:	e422                	sd	s0,8(sp)
 444:	0800                	addi	s0,sp,16
  for(; *s; s++)
 446:	00054783          	lbu	a5,0(a0)
 44a:	cb99                	beqz	a5,460 <strchr+0x20>
    if(*s == c)
 44c:	00f58763          	beq	a1,a5,45a <strchr+0x1a>
  for(; *s; s++)
 450:	0505                	addi	a0,a0,1
 452:	00054783          	lbu	a5,0(a0)
 456:	fbfd                	bnez	a5,44c <strchr+0xc>
      return (char*)s;
  return 0;
 458:	4501                	li	a0,0
}
 45a:	6422                	ld	s0,8(sp)
 45c:	0141                	addi	sp,sp,16
 45e:	8082                	ret
  return 0;
 460:	4501                	li	a0,0
 462:	bfe5                	j	45a <strchr+0x1a>

0000000000000464 <gets>:

char*
gets(char *buf, int max)
{
 464:	711d                	addi	sp,sp,-96
 466:	ec86                	sd	ra,88(sp)
 468:	e8a2                	sd	s0,80(sp)
 46a:	e4a6                	sd	s1,72(sp)
 46c:	e0ca                	sd	s2,64(sp)
 46e:	fc4e                	sd	s3,56(sp)
 470:	f852                	sd	s4,48(sp)
 472:	f456                	sd	s5,40(sp)
 474:	f05a                	sd	s6,32(sp)
 476:	ec5e                	sd	s7,24(sp)
 478:	1080                	addi	s0,sp,96
 47a:	8baa                	mv	s7,a0
 47c:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 47e:	892a                	mv	s2,a0
 480:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 482:	4aa9                	li	s5,10
 484:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 486:	89a6                	mv	s3,s1
 488:	2485                	addiw	s1,s1,1
 48a:	0344d863          	bge	s1,s4,4ba <gets+0x56>
    cc = read(0, &c, 1);
 48e:	4605                	li	a2,1
 490:	faf40593          	addi	a1,s0,-81
 494:	4501                	li	a0,0
 496:	00000097          	auipc	ra,0x0
 49a:	19c080e7          	jalr	412(ra) # 632 <read>
    if(cc < 1)
 49e:	00a05e63          	blez	a0,4ba <gets+0x56>
    buf[i++] = c;
 4a2:	faf44783          	lbu	a5,-81(s0)
 4a6:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 4aa:	01578763          	beq	a5,s5,4b8 <gets+0x54>
 4ae:	0905                	addi	s2,s2,1
 4b0:	fd679be3          	bne	a5,s6,486 <gets+0x22>
  for(i=0; i+1 < max; ){
 4b4:	89a6                	mv	s3,s1
 4b6:	a011                	j	4ba <gets+0x56>
 4b8:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 4ba:	99de                	add	s3,s3,s7
 4bc:	00098023          	sb	zero,0(s3)
  return buf;
}
 4c0:	855e                	mv	a0,s7
 4c2:	60e6                	ld	ra,88(sp)
 4c4:	6446                	ld	s0,80(sp)
 4c6:	64a6                	ld	s1,72(sp)
 4c8:	6906                	ld	s2,64(sp)
 4ca:	79e2                	ld	s3,56(sp)
 4cc:	7a42                	ld	s4,48(sp)
 4ce:	7aa2                	ld	s5,40(sp)
 4d0:	7b02                	ld	s6,32(sp)
 4d2:	6be2                	ld	s7,24(sp)
 4d4:	6125                	addi	sp,sp,96
 4d6:	8082                	ret

00000000000004d8 <stat>:

int
stat(const char *n, struct stat *st)
{
 4d8:	1101                	addi	sp,sp,-32
 4da:	ec06                	sd	ra,24(sp)
 4dc:	e822                	sd	s0,16(sp)
 4de:	e426                	sd	s1,8(sp)
 4e0:	e04a                	sd	s2,0(sp)
 4e2:	1000                	addi	s0,sp,32
 4e4:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 4e6:	4581                	li	a1,0
 4e8:	00000097          	auipc	ra,0x0
 4ec:	172080e7          	jalr	370(ra) # 65a <open>
  if(fd < 0)
 4f0:	02054563          	bltz	a0,51a <stat+0x42>
 4f4:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 4f6:	85ca                	mv	a1,s2
 4f8:	00000097          	auipc	ra,0x0
 4fc:	17a080e7          	jalr	378(ra) # 672 <fstat>
 500:	892a                	mv	s2,a0
  close(fd);
 502:	8526                	mv	a0,s1
 504:	00000097          	auipc	ra,0x0
 508:	13e080e7          	jalr	318(ra) # 642 <close>
  return r;
}
 50c:	854a                	mv	a0,s2
 50e:	60e2                	ld	ra,24(sp)
 510:	6442                	ld	s0,16(sp)
 512:	64a2                	ld	s1,8(sp)
 514:	6902                	ld	s2,0(sp)
 516:	6105                	addi	sp,sp,32
 518:	8082                	ret
    return -1;
 51a:	597d                	li	s2,-1
 51c:	bfc5                	j	50c <stat+0x34>

000000000000051e <atoi>:

int
atoi(const char *s)
{
 51e:	1141                	addi	sp,sp,-16
 520:	e422                	sd	s0,8(sp)
 522:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 524:	00054603          	lbu	a2,0(a0)
 528:	fd06079b          	addiw	a5,a2,-48
 52c:	0ff7f793          	andi	a5,a5,255
 530:	4725                	li	a4,9
 532:	02f76963          	bltu	a4,a5,564 <atoi+0x46>
 536:	86aa                	mv	a3,a0
  n = 0;
 538:	4501                	li	a0,0
  while('0' <= *s && *s <= '9')
 53a:	45a5                	li	a1,9
    n = n*10 + *s++ - '0';
 53c:	0685                	addi	a3,a3,1
 53e:	0025179b          	slliw	a5,a0,0x2
 542:	9fa9                	addw	a5,a5,a0
 544:	0017979b          	slliw	a5,a5,0x1
 548:	9fb1                	addw	a5,a5,a2
 54a:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 54e:	0006c603          	lbu	a2,0(a3)
 552:	fd06071b          	addiw	a4,a2,-48
 556:	0ff77713          	andi	a4,a4,255
 55a:	fee5f1e3          	bgeu	a1,a4,53c <atoi+0x1e>
  return n;
}
 55e:	6422                	ld	s0,8(sp)
 560:	0141                	addi	sp,sp,16
 562:	8082                	ret
  n = 0;
 564:	4501                	li	a0,0
 566:	bfe5                	j	55e <atoi+0x40>

0000000000000568 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 568:	1141                	addi	sp,sp,-16
 56a:	e422                	sd	s0,8(sp)
 56c:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 56e:	02b57463          	bgeu	a0,a1,596 <memmove+0x2e>
    while(n-- > 0)
 572:	00c05f63          	blez	a2,590 <memmove+0x28>
 576:	1602                	slli	a2,a2,0x20
 578:	9201                	srli	a2,a2,0x20
 57a:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 57e:	872a                	mv	a4,a0
      *dst++ = *src++;
 580:	0585                	addi	a1,a1,1
 582:	0705                	addi	a4,a4,1
 584:	fff5c683          	lbu	a3,-1(a1)
 588:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 58c:	fee79ae3          	bne	a5,a4,580 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 590:	6422                	ld	s0,8(sp)
 592:	0141                	addi	sp,sp,16
 594:	8082                	ret
    dst += n;
 596:	00c50733          	add	a4,a0,a2
    src += n;
 59a:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 59c:	fec05ae3          	blez	a2,590 <memmove+0x28>
 5a0:	fff6079b          	addiw	a5,a2,-1
 5a4:	1782                	slli	a5,a5,0x20
 5a6:	9381                	srli	a5,a5,0x20
 5a8:	fff7c793          	not	a5,a5
 5ac:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 5ae:	15fd                	addi	a1,a1,-1
 5b0:	177d                	addi	a4,a4,-1
 5b2:	0005c683          	lbu	a3,0(a1)
 5b6:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 5ba:	fee79ae3          	bne	a5,a4,5ae <memmove+0x46>
 5be:	bfc9                	j	590 <memmove+0x28>

00000000000005c0 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 5c0:	1141                	addi	sp,sp,-16
 5c2:	e422                	sd	s0,8(sp)
 5c4:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 5c6:	ca05                	beqz	a2,5f6 <memcmp+0x36>
 5c8:	fff6069b          	addiw	a3,a2,-1
 5cc:	1682                	slli	a3,a3,0x20
 5ce:	9281                	srli	a3,a3,0x20
 5d0:	0685                	addi	a3,a3,1
 5d2:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 5d4:	00054783          	lbu	a5,0(a0)
 5d8:	0005c703          	lbu	a4,0(a1)
 5dc:	00e79863          	bne	a5,a4,5ec <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 5e0:	0505                	addi	a0,a0,1
    p2++;
 5e2:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 5e4:	fed518e3          	bne	a0,a3,5d4 <memcmp+0x14>
  }
  return 0;
 5e8:	4501                	li	a0,0
 5ea:	a019                	j	5f0 <memcmp+0x30>
      return *p1 - *p2;
 5ec:	40e7853b          	subw	a0,a5,a4
}
 5f0:	6422                	ld	s0,8(sp)
 5f2:	0141                	addi	sp,sp,16
 5f4:	8082                	ret
  return 0;
 5f6:	4501                	li	a0,0
 5f8:	bfe5                	j	5f0 <memcmp+0x30>

00000000000005fa <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 5fa:	1141                	addi	sp,sp,-16
 5fc:	e406                	sd	ra,8(sp)
 5fe:	e022                	sd	s0,0(sp)
 600:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 602:	00000097          	auipc	ra,0x0
 606:	f66080e7          	jalr	-154(ra) # 568 <memmove>
}
 60a:	60a2                	ld	ra,8(sp)
 60c:	6402                	ld	s0,0(sp)
 60e:	0141                	addi	sp,sp,16
 610:	8082                	ret

0000000000000612 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 612:	4885                	li	a7,1
 ecall
 614:	00000073          	ecall
 ret
 618:	8082                	ret

000000000000061a <exit>:
.global exit
exit:
 li a7, SYS_exit
 61a:	4889                	li	a7,2
 ecall
 61c:	00000073          	ecall
 ret
 620:	8082                	ret

0000000000000622 <wait>:
.global wait
wait:
 li a7, SYS_wait
 622:	488d                	li	a7,3
 ecall
 624:	00000073          	ecall
 ret
 628:	8082                	ret

000000000000062a <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 62a:	4891                	li	a7,4
 ecall
 62c:	00000073          	ecall
 ret
 630:	8082                	ret

0000000000000632 <read>:
.global read
read:
 li a7, SYS_read
 632:	4895                	li	a7,5
 ecall
 634:	00000073          	ecall
 ret
 638:	8082                	ret

000000000000063a <write>:
.global write
write:
 li a7, SYS_write
 63a:	48c1                	li	a7,16
 ecall
 63c:	00000073          	ecall
 ret
 640:	8082                	ret

0000000000000642 <close>:
.global close
close:
 li a7, SYS_close
 642:	48d5                	li	a7,21
 ecall
 644:	00000073          	ecall
 ret
 648:	8082                	ret

000000000000064a <kill>:
.global kill
kill:
 li a7, SYS_kill
 64a:	4899                	li	a7,6
 ecall
 64c:	00000073          	ecall
 ret
 650:	8082                	ret

0000000000000652 <exec>:
.global exec
exec:
 li a7, SYS_exec
 652:	489d                	li	a7,7
 ecall
 654:	00000073          	ecall
 ret
 658:	8082                	ret

000000000000065a <open>:
.global open
open:
 li a7, SYS_open
 65a:	48bd                	li	a7,15
 ecall
 65c:	00000073          	ecall
 ret
 660:	8082                	ret

0000000000000662 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 662:	48c5                	li	a7,17
 ecall
 664:	00000073          	ecall
 ret
 668:	8082                	ret

000000000000066a <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 66a:	48c9                	li	a7,18
 ecall
 66c:	00000073          	ecall
 ret
 670:	8082                	ret

0000000000000672 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 672:	48a1                	li	a7,8
 ecall
 674:	00000073          	ecall
 ret
 678:	8082                	ret

000000000000067a <link>:
.global link
link:
 li a7, SYS_link
 67a:	48cd                	li	a7,19
 ecall
 67c:	00000073          	ecall
 ret
 680:	8082                	ret

0000000000000682 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 682:	48d1                	li	a7,20
 ecall
 684:	00000073          	ecall
 ret
 688:	8082                	ret

000000000000068a <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 68a:	48a5                	li	a7,9
 ecall
 68c:	00000073          	ecall
 ret
 690:	8082                	ret

0000000000000692 <dup>:
.global dup
dup:
 li a7, SYS_dup
 692:	48a9                	li	a7,10
 ecall
 694:	00000073          	ecall
 ret
 698:	8082                	ret

000000000000069a <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 69a:	48ad                	li	a7,11
 ecall
 69c:	00000073          	ecall
 ret
 6a0:	8082                	ret

00000000000006a2 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 6a2:	48b1                	li	a7,12
 ecall
 6a4:	00000073          	ecall
 ret
 6a8:	8082                	ret

00000000000006aa <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 6aa:	48b5                	li	a7,13
 ecall
 6ac:	00000073          	ecall
 ret
 6b0:	8082                	ret

00000000000006b2 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 6b2:	48b9                	li	a7,14
 ecall
 6b4:	00000073          	ecall
 ret
 6b8:	8082                	ret

00000000000006ba <thrdstop>:
.global thrdstop
thrdstop:
 li a7, SYS_thrdstop
 6ba:	48d9                	li	a7,22
 ecall
 6bc:	00000073          	ecall
 ret
 6c0:	8082                	ret

00000000000006c2 <thrdresume>:
.global thrdresume
thrdresume:
 li a7, SYS_thrdresume
 6c2:	48dd                	li	a7,23
 ecall
 6c4:	00000073          	ecall
 ret
 6c8:	8082                	ret

00000000000006ca <cancelthrdstop>:
.global cancelthrdstop
cancelthrdstop:
 li a7, SYS_cancelthrdstop
 6ca:	48e1                	li	a7,24
 ecall
 6cc:	00000073          	ecall
 ret
 6d0:	8082                	ret

00000000000006d2 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 6d2:	1101                	addi	sp,sp,-32
 6d4:	ec06                	sd	ra,24(sp)
 6d6:	e822                	sd	s0,16(sp)
 6d8:	1000                	addi	s0,sp,32
 6da:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 6de:	4605                	li	a2,1
 6e0:	fef40593          	addi	a1,s0,-17
 6e4:	00000097          	auipc	ra,0x0
 6e8:	f56080e7          	jalr	-170(ra) # 63a <write>
}
 6ec:	60e2                	ld	ra,24(sp)
 6ee:	6442                	ld	s0,16(sp)
 6f0:	6105                	addi	sp,sp,32
 6f2:	8082                	ret

00000000000006f4 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 6f4:	7139                	addi	sp,sp,-64
 6f6:	fc06                	sd	ra,56(sp)
 6f8:	f822                	sd	s0,48(sp)
 6fa:	f426                	sd	s1,40(sp)
 6fc:	f04a                	sd	s2,32(sp)
 6fe:	ec4e                	sd	s3,24(sp)
 700:	0080                	addi	s0,sp,64
 702:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 704:	c299                	beqz	a3,70a <printint+0x16>
 706:	0805c863          	bltz	a1,796 <printint+0xa2>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 70a:	2581                	sext.w	a1,a1
  neg = 0;
 70c:	4881                	li	a7,0
 70e:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 712:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 714:	2601                	sext.w	a2,a2
 716:	00000517          	auipc	a0,0x0
 71a:	50250513          	addi	a0,a0,1282 # c18 <digits>
 71e:	883a                	mv	a6,a4
 720:	2705                	addiw	a4,a4,1
 722:	02c5f7bb          	remuw	a5,a1,a2
 726:	1782                	slli	a5,a5,0x20
 728:	9381                	srli	a5,a5,0x20
 72a:	97aa                	add	a5,a5,a0
 72c:	0007c783          	lbu	a5,0(a5)
 730:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 734:	0005879b          	sext.w	a5,a1
 738:	02c5d5bb          	divuw	a1,a1,a2
 73c:	0685                	addi	a3,a3,1
 73e:	fec7f0e3          	bgeu	a5,a2,71e <printint+0x2a>
  if(neg)
 742:	00088b63          	beqz	a7,758 <printint+0x64>
    buf[i++] = '-';
 746:	fd040793          	addi	a5,s0,-48
 74a:	973e                	add	a4,a4,a5
 74c:	02d00793          	li	a5,45
 750:	fef70823          	sb	a5,-16(a4)
 754:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 758:	02e05863          	blez	a4,788 <printint+0x94>
 75c:	fc040793          	addi	a5,s0,-64
 760:	00e78933          	add	s2,a5,a4
 764:	fff78993          	addi	s3,a5,-1
 768:	99ba                	add	s3,s3,a4
 76a:	377d                	addiw	a4,a4,-1
 76c:	1702                	slli	a4,a4,0x20
 76e:	9301                	srli	a4,a4,0x20
 770:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 774:	fff94583          	lbu	a1,-1(s2)
 778:	8526                	mv	a0,s1
 77a:	00000097          	auipc	ra,0x0
 77e:	f58080e7          	jalr	-168(ra) # 6d2 <putc>
  while(--i >= 0)
 782:	197d                	addi	s2,s2,-1
 784:	ff3918e3          	bne	s2,s3,774 <printint+0x80>
}
 788:	70e2                	ld	ra,56(sp)
 78a:	7442                	ld	s0,48(sp)
 78c:	74a2                	ld	s1,40(sp)
 78e:	7902                	ld	s2,32(sp)
 790:	69e2                	ld	s3,24(sp)
 792:	6121                	addi	sp,sp,64
 794:	8082                	ret
    x = -xx;
 796:	40b005bb          	negw	a1,a1
    neg = 1;
 79a:	4885                	li	a7,1
    x = -xx;
 79c:	bf8d                	j	70e <printint+0x1a>

000000000000079e <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 79e:	7119                	addi	sp,sp,-128
 7a0:	fc86                	sd	ra,120(sp)
 7a2:	f8a2                	sd	s0,112(sp)
 7a4:	f4a6                	sd	s1,104(sp)
 7a6:	f0ca                	sd	s2,96(sp)
 7a8:	ecce                	sd	s3,88(sp)
 7aa:	e8d2                	sd	s4,80(sp)
 7ac:	e4d6                	sd	s5,72(sp)
 7ae:	e0da                	sd	s6,64(sp)
 7b0:	fc5e                	sd	s7,56(sp)
 7b2:	f862                	sd	s8,48(sp)
 7b4:	f466                	sd	s9,40(sp)
 7b6:	f06a                	sd	s10,32(sp)
 7b8:	ec6e                	sd	s11,24(sp)
 7ba:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 7bc:	0005c903          	lbu	s2,0(a1)
 7c0:	18090f63          	beqz	s2,95e <vprintf+0x1c0>
 7c4:	8aaa                	mv	s5,a0
 7c6:	8b32                	mv	s6,a2
 7c8:	00158493          	addi	s1,a1,1
  state = 0;
 7cc:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 7ce:	02500a13          	li	s4,37
      if(c == 'd'){
 7d2:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c == 'l') {
 7d6:	06c00c93          	li	s9,108
        printint(fd, va_arg(ap, uint64), 10, 0);
      } else if(c == 'x') {
 7da:	07800d13          	li	s10,120
        printint(fd, va_arg(ap, int), 16, 0);
      } else if(c == 'p') {
 7de:	07000d93          	li	s11,112
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 7e2:	00000b97          	auipc	s7,0x0
 7e6:	436b8b93          	addi	s7,s7,1078 # c18 <digits>
 7ea:	a839                	j	808 <vprintf+0x6a>
        putc(fd, c);
 7ec:	85ca                	mv	a1,s2
 7ee:	8556                	mv	a0,s5
 7f0:	00000097          	auipc	ra,0x0
 7f4:	ee2080e7          	jalr	-286(ra) # 6d2 <putc>
 7f8:	a019                	j	7fe <vprintf+0x60>
    } else if(state == '%'){
 7fa:	01498f63          	beq	s3,s4,818 <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
 7fe:	0485                	addi	s1,s1,1
 800:	fff4c903          	lbu	s2,-1(s1)
 804:	14090d63          	beqz	s2,95e <vprintf+0x1c0>
    c = fmt[i] & 0xff;
 808:	0009079b          	sext.w	a5,s2
    if(state == 0){
 80c:	fe0997e3          	bnez	s3,7fa <vprintf+0x5c>
      if(c == '%'){
 810:	fd479ee3          	bne	a5,s4,7ec <vprintf+0x4e>
        state = '%';
 814:	89be                	mv	s3,a5
 816:	b7e5                	j	7fe <vprintf+0x60>
      if(c == 'd'){
 818:	05878063          	beq	a5,s8,858 <vprintf+0xba>
      } else if(c == 'l') {
 81c:	05978c63          	beq	a5,s9,874 <vprintf+0xd6>
      } else if(c == 'x') {
 820:	07a78863          	beq	a5,s10,890 <vprintf+0xf2>
      } else if(c == 'p') {
 824:	09b78463          	beq	a5,s11,8ac <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
 828:	07300713          	li	a4,115
 82c:	0ce78663          	beq	a5,a4,8f8 <vprintf+0x15a>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 830:	06300713          	li	a4,99
 834:	0ee78e63          	beq	a5,a4,930 <vprintf+0x192>
        putc(fd, va_arg(ap, uint));
      } else if(c == '%'){
 838:	11478863          	beq	a5,s4,948 <vprintf+0x1aa>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 83c:	85d2                	mv	a1,s4
 83e:	8556                	mv	a0,s5
 840:	00000097          	auipc	ra,0x0
 844:	e92080e7          	jalr	-366(ra) # 6d2 <putc>
        putc(fd, c);
 848:	85ca                	mv	a1,s2
 84a:	8556                	mv	a0,s5
 84c:	00000097          	auipc	ra,0x0
 850:	e86080e7          	jalr	-378(ra) # 6d2 <putc>
      }
      state = 0;
 854:	4981                	li	s3,0
 856:	b765                	j	7fe <vprintf+0x60>
        printint(fd, va_arg(ap, int), 10, 1);
 858:	008b0913          	addi	s2,s6,8
 85c:	4685                	li	a3,1
 85e:	4629                	li	a2,10
 860:	000b2583          	lw	a1,0(s6)
 864:	8556                	mv	a0,s5
 866:	00000097          	auipc	ra,0x0
 86a:	e8e080e7          	jalr	-370(ra) # 6f4 <printint>
 86e:	8b4a                	mv	s6,s2
      state = 0;
 870:	4981                	li	s3,0
 872:	b771                	j	7fe <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
 874:	008b0913          	addi	s2,s6,8
 878:	4681                	li	a3,0
 87a:	4629                	li	a2,10
 87c:	000b2583          	lw	a1,0(s6)
 880:	8556                	mv	a0,s5
 882:	00000097          	auipc	ra,0x0
 886:	e72080e7          	jalr	-398(ra) # 6f4 <printint>
 88a:	8b4a                	mv	s6,s2
      state = 0;
 88c:	4981                	li	s3,0
 88e:	bf85                	j	7fe <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
 890:	008b0913          	addi	s2,s6,8
 894:	4681                	li	a3,0
 896:	4641                	li	a2,16
 898:	000b2583          	lw	a1,0(s6)
 89c:	8556                	mv	a0,s5
 89e:	00000097          	auipc	ra,0x0
 8a2:	e56080e7          	jalr	-426(ra) # 6f4 <printint>
 8a6:	8b4a                	mv	s6,s2
      state = 0;
 8a8:	4981                	li	s3,0
 8aa:	bf91                	j	7fe <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
 8ac:	008b0793          	addi	a5,s6,8
 8b0:	f8f43423          	sd	a5,-120(s0)
 8b4:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
 8b8:	03000593          	li	a1,48
 8bc:	8556                	mv	a0,s5
 8be:	00000097          	auipc	ra,0x0
 8c2:	e14080e7          	jalr	-492(ra) # 6d2 <putc>
  putc(fd, 'x');
 8c6:	85ea                	mv	a1,s10
 8c8:	8556                	mv	a0,s5
 8ca:	00000097          	auipc	ra,0x0
 8ce:	e08080e7          	jalr	-504(ra) # 6d2 <putc>
 8d2:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 8d4:	03c9d793          	srli	a5,s3,0x3c
 8d8:	97de                	add	a5,a5,s7
 8da:	0007c583          	lbu	a1,0(a5)
 8de:	8556                	mv	a0,s5
 8e0:	00000097          	auipc	ra,0x0
 8e4:	df2080e7          	jalr	-526(ra) # 6d2 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 8e8:	0992                	slli	s3,s3,0x4
 8ea:	397d                	addiw	s2,s2,-1
 8ec:	fe0914e3          	bnez	s2,8d4 <vprintf+0x136>
        printptr(fd, va_arg(ap, uint64));
 8f0:	f8843b03          	ld	s6,-120(s0)
      state = 0;
 8f4:	4981                	li	s3,0
 8f6:	b721                	j	7fe <vprintf+0x60>
        s = va_arg(ap, char*);
 8f8:	008b0993          	addi	s3,s6,8
 8fc:	000b3903          	ld	s2,0(s6)
        if(s == 0)
 900:	02090163          	beqz	s2,922 <vprintf+0x184>
        while(*s != 0){
 904:	00094583          	lbu	a1,0(s2)
 908:	c9a1                	beqz	a1,958 <vprintf+0x1ba>
          putc(fd, *s);
 90a:	8556                	mv	a0,s5
 90c:	00000097          	auipc	ra,0x0
 910:	dc6080e7          	jalr	-570(ra) # 6d2 <putc>
          s++;
 914:	0905                	addi	s2,s2,1
        while(*s != 0){
 916:	00094583          	lbu	a1,0(s2)
 91a:	f9e5                	bnez	a1,90a <vprintf+0x16c>
        s = va_arg(ap, char*);
 91c:	8b4e                	mv	s6,s3
      state = 0;
 91e:	4981                	li	s3,0
 920:	bdf9                	j	7fe <vprintf+0x60>
          s = "(null)";
 922:	00000917          	auipc	s2,0x0
 926:	2ee90913          	addi	s2,s2,750 # c10 <longjmp_1+0x52>
        while(*s != 0){
 92a:	02800593          	li	a1,40
 92e:	bff1                	j	90a <vprintf+0x16c>
        putc(fd, va_arg(ap, uint));
 930:	008b0913          	addi	s2,s6,8
 934:	000b4583          	lbu	a1,0(s6)
 938:	8556                	mv	a0,s5
 93a:	00000097          	auipc	ra,0x0
 93e:	d98080e7          	jalr	-616(ra) # 6d2 <putc>
 942:	8b4a                	mv	s6,s2
      state = 0;
 944:	4981                	li	s3,0
 946:	bd65                	j	7fe <vprintf+0x60>
        putc(fd, c);
 948:	85d2                	mv	a1,s4
 94a:	8556                	mv	a0,s5
 94c:	00000097          	auipc	ra,0x0
 950:	d86080e7          	jalr	-634(ra) # 6d2 <putc>
      state = 0;
 954:	4981                	li	s3,0
 956:	b565                	j	7fe <vprintf+0x60>
        s = va_arg(ap, char*);
 958:	8b4e                	mv	s6,s3
      state = 0;
 95a:	4981                	li	s3,0
 95c:	b54d                	j	7fe <vprintf+0x60>
    }
  }
}
 95e:	70e6                	ld	ra,120(sp)
 960:	7446                	ld	s0,112(sp)
 962:	74a6                	ld	s1,104(sp)
 964:	7906                	ld	s2,96(sp)
 966:	69e6                	ld	s3,88(sp)
 968:	6a46                	ld	s4,80(sp)
 96a:	6aa6                	ld	s5,72(sp)
 96c:	6b06                	ld	s6,64(sp)
 96e:	7be2                	ld	s7,56(sp)
 970:	7c42                	ld	s8,48(sp)
 972:	7ca2                	ld	s9,40(sp)
 974:	7d02                	ld	s10,32(sp)
 976:	6de2                	ld	s11,24(sp)
 978:	6109                	addi	sp,sp,128
 97a:	8082                	ret

000000000000097c <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 97c:	715d                	addi	sp,sp,-80
 97e:	ec06                	sd	ra,24(sp)
 980:	e822                	sd	s0,16(sp)
 982:	1000                	addi	s0,sp,32
 984:	e010                	sd	a2,0(s0)
 986:	e414                	sd	a3,8(s0)
 988:	e818                	sd	a4,16(s0)
 98a:	ec1c                	sd	a5,24(s0)
 98c:	03043023          	sd	a6,32(s0)
 990:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 994:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 998:	8622                	mv	a2,s0
 99a:	00000097          	auipc	ra,0x0
 99e:	e04080e7          	jalr	-508(ra) # 79e <vprintf>
}
 9a2:	60e2                	ld	ra,24(sp)
 9a4:	6442                	ld	s0,16(sp)
 9a6:	6161                	addi	sp,sp,80
 9a8:	8082                	ret

00000000000009aa <printf>:

void
printf(const char *fmt, ...)
{
 9aa:	711d                	addi	sp,sp,-96
 9ac:	ec06                	sd	ra,24(sp)
 9ae:	e822                	sd	s0,16(sp)
 9b0:	1000                	addi	s0,sp,32
 9b2:	e40c                	sd	a1,8(s0)
 9b4:	e810                	sd	a2,16(s0)
 9b6:	ec14                	sd	a3,24(s0)
 9b8:	f018                	sd	a4,32(s0)
 9ba:	f41c                	sd	a5,40(s0)
 9bc:	03043823          	sd	a6,48(s0)
 9c0:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 9c4:	00840613          	addi	a2,s0,8
 9c8:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 9cc:	85aa                	mv	a1,a0
 9ce:	4505                	li	a0,1
 9d0:	00000097          	auipc	ra,0x0
 9d4:	dce080e7          	jalr	-562(ra) # 79e <vprintf>
}
 9d8:	60e2                	ld	ra,24(sp)
 9da:	6442                	ld	s0,16(sp)
 9dc:	6125                	addi	sp,sp,96
 9de:	8082                	ret

00000000000009e0 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 9e0:	1141                	addi	sp,sp,-16
 9e2:	e422                	sd	s0,8(sp)
 9e4:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 9e6:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 9ea:	00000797          	auipc	a5,0x0
 9ee:	25e7b783          	ld	a5,606(a5) # c48 <freep>
 9f2:	a805                	j	a22 <free+0x42>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 9f4:	4618                	lw	a4,8(a2)
 9f6:	9db9                	addw	a1,a1,a4
 9f8:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 9fc:	6398                	ld	a4,0(a5)
 9fe:	6318                	ld	a4,0(a4)
 a00:	fee53823          	sd	a4,-16(a0)
 a04:	a091                	j	a48 <free+0x68>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 a06:	ff852703          	lw	a4,-8(a0)
 a0a:	9e39                	addw	a2,a2,a4
 a0c:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
 a0e:	ff053703          	ld	a4,-16(a0)
 a12:	e398                	sd	a4,0(a5)
 a14:	a099                	j	a5a <free+0x7a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 a16:	6398                	ld	a4,0(a5)
 a18:	00e7e463          	bltu	a5,a4,a20 <free+0x40>
 a1c:	00e6ea63          	bltu	a3,a4,a30 <free+0x50>
{
 a20:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 a22:	fed7fae3          	bgeu	a5,a3,a16 <free+0x36>
 a26:	6398                	ld	a4,0(a5)
 a28:	00e6e463          	bltu	a3,a4,a30 <free+0x50>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 a2c:	fee7eae3          	bltu	a5,a4,a20 <free+0x40>
  if(bp + bp->s.size == p->s.ptr){
 a30:	ff852583          	lw	a1,-8(a0)
 a34:	6390                	ld	a2,0(a5)
 a36:	02059713          	slli	a4,a1,0x20
 a3a:	9301                	srli	a4,a4,0x20
 a3c:	0712                	slli	a4,a4,0x4
 a3e:	9736                	add	a4,a4,a3
 a40:	fae60ae3          	beq	a2,a4,9f4 <free+0x14>
    bp->s.ptr = p->s.ptr;
 a44:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 a48:	4790                	lw	a2,8(a5)
 a4a:	02061713          	slli	a4,a2,0x20
 a4e:	9301                	srli	a4,a4,0x20
 a50:	0712                	slli	a4,a4,0x4
 a52:	973e                	add	a4,a4,a5
 a54:	fae689e3          	beq	a3,a4,a06 <free+0x26>
  } else
    p->s.ptr = bp;
 a58:	e394                	sd	a3,0(a5)
  freep = p;
 a5a:	00000717          	auipc	a4,0x0
 a5e:	1ef73723          	sd	a5,494(a4) # c48 <freep>
}
 a62:	6422                	ld	s0,8(sp)
 a64:	0141                	addi	sp,sp,16
 a66:	8082                	ret

0000000000000a68 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 a68:	7139                	addi	sp,sp,-64
 a6a:	fc06                	sd	ra,56(sp)
 a6c:	f822                	sd	s0,48(sp)
 a6e:	f426                	sd	s1,40(sp)
 a70:	f04a                	sd	s2,32(sp)
 a72:	ec4e                	sd	s3,24(sp)
 a74:	e852                	sd	s4,16(sp)
 a76:	e456                	sd	s5,8(sp)
 a78:	e05a                	sd	s6,0(sp)
 a7a:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 a7c:	02051493          	slli	s1,a0,0x20
 a80:	9081                	srli	s1,s1,0x20
 a82:	04bd                	addi	s1,s1,15
 a84:	8091                	srli	s1,s1,0x4
 a86:	0014899b          	addiw	s3,s1,1
 a8a:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 a8c:	00000517          	auipc	a0,0x0
 a90:	1bc53503          	ld	a0,444(a0) # c48 <freep>
 a94:	c515                	beqz	a0,ac0 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a96:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 a98:	4798                	lw	a4,8(a5)
 a9a:	02977f63          	bgeu	a4,s1,ad8 <malloc+0x70>
 a9e:	8a4e                	mv	s4,s3
 aa0:	0009871b          	sext.w	a4,s3
 aa4:	6685                	lui	a3,0x1
 aa6:	00d77363          	bgeu	a4,a3,aac <malloc+0x44>
 aaa:	6a05                	lui	s4,0x1
 aac:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 ab0:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 ab4:	00000917          	auipc	s2,0x0
 ab8:	19490913          	addi	s2,s2,404 # c48 <freep>
  if(p == (char*)-1)
 abc:	5afd                	li	s5,-1
 abe:	a88d                	j	b30 <malloc+0xc8>
    base.s.ptr = freep = prevp = &base;
 ac0:	00000797          	auipc	a5,0x0
 ac4:	20078793          	addi	a5,a5,512 # cc0 <base>
 ac8:	00000717          	auipc	a4,0x0
 acc:	18f73023          	sd	a5,384(a4) # c48 <freep>
 ad0:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 ad2:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 ad6:	b7e1                	j	a9e <malloc+0x36>
      if(p->s.size == nunits)
 ad8:	02e48b63          	beq	s1,a4,b0e <malloc+0xa6>
        p->s.size -= nunits;
 adc:	4137073b          	subw	a4,a4,s3
 ae0:	c798                	sw	a4,8(a5)
        p += p->s.size;
 ae2:	1702                	slli	a4,a4,0x20
 ae4:	9301                	srli	a4,a4,0x20
 ae6:	0712                	slli	a4,a4,0x4
 ae8:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 aea:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 aee:	00000717          	auipc	a4,0x0
 af2:	14a73d23          	sd	a0,346(a4) # c48 <freep>
      return (void*)(p + 1);
 af6:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 afa:	70e2                	ld	ra,56(sp)
 afc:	7442                	ld	s0,48(sp)
 afe:	74a2                	ld	s1,40(sp)
 b00:	7902                	ld	s2,32(sp)
 b02:	69e2                	ld	s3,24(sp)
 b04:	6a42                	ld	s4,16(sp)
 b06:	6aa2                	ld	s5,8(sp)
 b08:	6b02                	ld	s6,0(sp)
 b0a:	6121                	addi	sp,sp,64
 b0c:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 b0e:	6398                	ld	a4,0(a5)
 b10:	e118                	sd	a4,0(a0)
 b12:	bff1                	j	aee <malloc+0x86>
  hp->s.size = nu;
 b14:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 b18:	0541                	addi	a0,a0,16
 b1a:	00000097          	auipc	ra,0x0
 b1e:	ec6080e7          	jalr	-314(ra) # 9e0 <free>
  return freep;
 b22:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 b26:	d971                	beqz	a0,afa <malloc+0x92>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 b28:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 b2a:	4798                	lw	a4,8(a5)
 b2c:	fa9776e3          	bgeu	a4,s1,ad8 <malloc+0x70>
    if(p == freep)
 b30:	00093703          	ld	a4,0(s2)
 b34:	853e                	mv	a0,a5
 b36:	fef719e3          	bne	a4,a5,b28 <malloc+0xc0>
  p = sbrk(nu * sizeof(Header));
 b3a:	8552                	mv	a0,s4
 b3c:	00000097          	auipc	ra,0x0
 b40:	b66080e7          	jalr	-1178(ra) # 6a2 <sbrk>
  if(p == (char*)-1)
 b44:	fd5518e3          	bne	a0,s5,b14 <malloc+0xac>
        return 0;
 b48:	4501                	li	a0,0
 b4a:	bf45                	j	afa <malloc+0x92>

0000000000000b4c <setjmp>:
 b4c:	e100                	sd	s0,0(a0)
 b4e:	e504                	sd	s1,8(a0)
 b50:	01253823          	sd	s2,16(a0)
 b54:	01353c23          	sd	s3,24(a0)
 b58:	03453023          	sd	s4,32(a0)
 b5c:	03553423          	sd	s5,40(a0)
 b60:	03653823          	sd	s6,48(a0)
 b64:	03753c23          	sd	s7,56(a0)
 b68:	05853023          	sd	s8,64(a0)
 b6c:	05953423          	sd	s9,72(a0)
 b70:	05a53823          	sd	s10,80(a0)
 b74:	05b53c23          	sd	s11,88(a0)
 b78:	06153023          	sd	ra,96(a0)
 b7c:	06253423          	sd	sp,104(a0)
 b80:	4501                	li	a0,0
 b82:	8082                	ret

0000000000000b84 <longjmp>:
 b84:	6100                	ld	s0,0(a0)
 b86:	6504                	ld	s1,8(a0)
 b88:	01053903          	ld	s2,16(a0)
 b8c:	01853983          	ld	s3,24(a0)
 b90:	02053a03          	ld	s4,32(a0)
 b94:	02853a83          	ld	s5,40(a0)
 b98:	03053b03          	ld	s6,48(a0)
 b9c:	03853b83          	ld	s7,56(a0)
 ba0:	04053c03          	ld	s8,64(a0)
 ba4:	04853c83          	ld	s9,72(a0)
 ba8:	05053d03          	ld	s10,80(a0)
 bac:	05853d83          	ld	s11,88(a0)
 bb0:	06053083          	ld	ra,96(a0)
 bb4:	06853103          	ld	sp,104(a0)
 bb8:	c199                	beqz	a1,bbe <longjmp_1>
 bba:	852e                	mv	a0,a1
 bbc:	8082                	ret

0000000000000bbe <longjmp_1>:
 bbe:	4505                	li	a0,1
 bc0:	8082                	ret
