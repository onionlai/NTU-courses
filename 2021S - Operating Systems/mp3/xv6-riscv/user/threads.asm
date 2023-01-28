
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
  1e:	a92080e7          	jalr	-1390(ra) # aac <malloc>
  22:	84aa                	mv	s1,a0
    //unsigned long stack_p = 0;
    unsigned long new_stack_p;
    unsigned long new_stack;
    new_stack = (unsigned long) malloc(sizeof(unsigned long)*0x100);
  24:	6505                	lui	a0,0x1
  26:	80050513          	addi	a0,a0,-2048 # 800 <vprintf+0x1e>
  2a:	00001097          	auipc	ra,0x1
  2e:	a82080e7          	jalr	-1406(ra) # aac <malloc>
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
  50:	c2c7a783          	lw	a5,-980(a5) # c78 <is_thread_start>
  54:	c799                	beqz	a5,62 <thread_create+0x62>
        t->remain_execution_time = execution_time_slot;
    else
        t->remain_execution_time = execution_time_slot * __time_slot_size;
  56:	00001797          	auipc	a5,0x1
  5a:	c167a783          	lw	a5,-1002(a5) # c6c <__time_slot_size>
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
  90:	66a080e7          	jalr	1642(ra) # 6f6 <uptime>
  94:	0aa4ac23          	sw	a0,184(s1)
    t->ID  = id;
  98:	00001717          	auipc	a4,0x1
  9c:	bd870713          	addi	a4,a4,-1064 # c70 <id>
  a0:	431c                	lw	a5,0(a4)
  a2:	08f4a823          	sw	a5,144(s1)
    id ++;
  a6:	2785                	addiw	a5,a5,1
  a8:	c31c                	sw	a5,0(a4)
    if(current_thread == NULL){
  aa:	00001797          	auipc	a5,0x1
  ae:	bd67b783          	ld	a5,-1066(a5) # c80 <current_thread>
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
  da:	ba97b523          	sd	s1,-1110(a5) # c80 <current_thread>
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
    // return ;

    ///////////////// SJF /////////////////////
    // printf("----------------------------------\n");
    // printf("current ID=%d, (r.time%d)\n", current_thread->ID, current_thread->remain_execution_time);
    if(! current_thread->is_exited && !current_thread->is_yield && is_thread_start)
  f4:	00001597          	auipc	a1,0x1
  f8:	b8c5b583          	ld	a1,-1140(a1) # c80 <current_thread>
  fc:	0c05a783          	lw	a5,192(a1)
 100:	e3a1                	bnez	a5,140 <schedule+0x52>
 102:	0bc5a783          	lw	a5,188(a1)
 106:	e791                	bnez	a5,112 <schedule+0x24>
 108:	00001797          	auipc	a5,0x1
 10c:	b707a783          	lw	a5,-1168(a5) # c78 <is_thread_start>
 110:	e3a1                	bnez	a5,150 <schedule+0x62>
        return;

    // printf("exit or yield\n");

    struct thread* head = current_thread;
    struct thread* t = current_thread->next;
 112:	75dc                	ld	a5,168(a1)
    struct thread* candidate = current_thread;
 114:	862e                	mv	a2,a1
 116:	a03d                	j	144 <schedule+0x56>
 118:	863e                	mv	a2,a5
    while(t != head){
        if(t->remain_execution_time < candidate->remain_execution_time)
            candidate = t;
        else if(t->remain_execution_time == candidate->remain_execution_time && t->ID < candidate->ID)
            candidate = t;
        t = t->next;
 11a:	77dc                	ld	a5,168(a5)
    while(t != head){
 11c:	02f58663          	beq	a1,a5,148 <schedule+0x5a>
        if(t->remain_execution_time < candidate->remain_execution_time)
 120:	0b47a683          	lw	a3,180(a5)
 124:	0b462703          	lw	a4,180(a2)
 128:	fee6c8e3          	blt	a3,a4,118 <schedule+0x2a>
        else if(t->remain_execution_time == candidate->remain_execution_time && t->ID < candidate->ID)
 12c:	fee697e3          	bne	a3,a4,11a <schedule+0x2c>
 130:	0907a683          	lw	a3,144(a5)
 134:	09062703          	lw	a4,144(a2)
 138:	fee6d1e3          	bge	a3,a4,11a <schedule+0x2c>
 13c:	863e                	mv	a2,a5
 13e:	bff1                	j	11a <schedule+0x2c>
    struct thread* t = current_thread->next;
 140:	75d0                	ld	a2,168(a1)
 142:	87b2                	mv	a5,a2
    while(t != head){
 144:	fcf59ee3          	bne	a1,a5,120 <schedule+0x32>
    }
    // printf("SJF schedule from ID=%d(r.time=%d) to ID=%d(r.time=%d)\n", current_thread->ID, current_thread->remain_execution_time,candidate->ID, candidate->remain_execution_time);
    current_thread = candidate;
 148:	00001797          	auipc	a5,0x1
 14c:	b2c7bc23          	sd	a2,-1224(a5) # c80 <current_thread>
    //     t = t->next;
    // }
    // //printf("PSJF schedule from ID=%d(r.time=%d) to ID=%d(r.time=%d)\n", current_thread->ID, current_thread->remain_execution_time,candidate->ID, candidate->remain_execution_time);
    // current_thread = candidate;
    // return ;
}
 150:	6422                	ld	s0,8(sp)
 152:	0141                	addi	sp,sp,16
 154:	8082                	ret

0000000000000156 <thread_exit>:

void thread_exit(void){
 156:	1101                	addi	sp,sp,-32
 158:	ec06                	sd	ra,24(sp)
 15a:	e822                	sd	s0,16(sp)
 15c:	e426                	sd	s1,8(sp)
 15e:	e04a                	sd	s2,0(sp)
 160:	1000                	addi	s0,sp,32
    // remove the thread immediately, and cancel previous thrdstop.
    thrdresume(current_thread->thrdstop_context_id, 1);
 162:	00001497          	auipc	s1,0x1
 166:	b1e48493          	addi	s1,s1,-1250 # c80 <current_thread>
 16a:	609c                	ld	a5,0(s1)
 16c:	4585                	li	a1,1
 16e:	0b07a503          	lw	a0,176(a5)
 172:	00000097          	auipc	ra,0x0
 176:	594080e7          	jalr	1428(ra) # 706 <thrdresume>
    struct thread* to_remove = current_thread;
 17a:	6084                	ld	s1,0(s1)
    printf("thread id %d exec %d ticks\n", to_remove->ID, uptime() - to_remove->start_time);
 17c:	0904a903          	lw	s2,144(s1)
 180:	00000097          	auipc	ra,0x0
 184:	576080e7          	jalr	1398(ra) # 6f6 <uptime>
 188:	0b84a603          	lw	a2,184(s1)
 18c:	40c5063b          	subw	a2,a0,a2
 190:	85ca                	mv	a1,s2
 192:	00001517          	auipc	a0,0x1
 196:	a7650513          	addi	a0,a0,-1418 # c08 <longjmp_1+0x6>
 19a:	00001097          	auipc	ra,0x1
 19e:	854080e7          	jalr	-1964(ra) # 9ee <printf>

    to_remove->is_exited = 1;
 1a2:	4785                	li	a5,1
 1a4:	0cf4a023          	sw	a5,192(s1)

    if(to_remove->next != to_remove){
 1a8:	74dc                	ld	a5,168(s1)
 1aa:	02978e63          	beq	a5,s1,1e6 <thread_exit+0x90>
        //Still more thread to execute
        schedule() ;
 1ae:	00000097          	auipc	ra,0x0
 1b2:	f40080e7          	jalr	-192(ra) # ee <schedule>
        //Connect the remaining threads
        struct thread* to_remove_next = to_remove->next;
 1b6:	74d8                	ld	a4,168(s1)
        to_remove_next->previous = to_remove->previous;
 1b8:	70dc                	ld	a5,160(s1)
 1ba:	f35c                	sd	a5,160(a4)
        to_remove->previous->next = to_remove_next;
 1bc:	f7d8                	sd	a4,168(a5)


        //free pointers
        free(to_remove->stack);
 1be:	6888                	ld	a0,16(s1)
 1c0:	00001097          	auipc	ra,0x1
 1c4:	864080e7          	jalr	-1948(ra) # a24 <free>
        free(to_remove);
 1c8:	8526                	mv	a0,s1
 1ca:	00001097          	auipc	ra,0x1
 1ce:	85a080e7          	jalr	-1958(ra) # a24 <free>
        dispatch();
 1d2:	00000097          	auipc	ra,0x0
 1d6:	028080e7          	jalr	40(ra) # 1fa <dispatch>
    }
    else{
        //No more thread to execute
        longjmp(env_st, -1);
    }
}
 1da:	60e2                	ld	ra,24(sp)
 1dc:	6442                	ld	s0,16(sp)
 1de:	64a2                	ld	s1,8(sp)
 1e0:	6902                	ld	s2,0(sp)
 1e2:	6105                	addi	sp,sp,32
 1e4:	8082                	ret
        longjmp(env_st, -1);
 1e6:	55fd                	li	a1,-1
 1e8:	00001517          	auipc	a0,0x1
 1ec:	aa850513          	addi	a0,a0,-1368 # c90 <env_st>
 1f0:	00001097          	auipc	ra,0x1
 1f4:	9d8080e7          	jalr	-1576(ra) # bc8 <longjmp>
}
 1f8:	b7cd                	j	1da <thread_exit+0x84>

00000000000001fa <dispatch>:
void dispatch(void){
 1fa:	1101                	addi	sp,sp,-32
 1fc:	ec06                	sd	ra,24(sp)
 1fe:	e822                	sd	s0,16(sp)
 200:	e426                	sd	s1,8(sp)
 202:	e04a                	sd	s2,0(sp)
 204:	1000                	addi	s0,sp,32
    if(current_thread->buf_set)
 206:	00001497          	auipc	s1,0x1
 20a:	a7a4b483          	ld	s1,-1414(s1) # c80 <current_thread>
 20e:	09c4a783          	lw	a5,156(s1)
 212:	cfb1                	beqz	a5,26e <dispatch+0x74>
        thrdstop( next_time, current_thread->thrdstop_context_id, my_thrdstop_handler); // after next_time ticks, my_thrdstop_handler will be called.
 214:	0b04a583          	lw	a1,176(s1)
        int next_time = (__time_slot_size >= current_thread->remain_execution_time )? current_thread->remain_execution_time: __time_slot_size;
 218:	00001797          	auipc	a5,0x1
 21c:	a547a783          	lw	a5,-1452(a5) # c6c <__time_slot_size>
 220:	0b44a503          	lw	a0,180(s1)
 224:	0005069b          	sext.w	a3,a0
 228:	0007871b          	sext.w	a4,a5
 22c:	00d75363          	bge	a4,a3,232 <dispatch+0x38>
 230:	853e                	mv	a0,a5
        thrdstop( next_time, current_thread->thrdstop_context_id, my_thrdstop_handler); // after next_time ticks, my_thrdstop_handler will be called.
 232:	00000617          	auipc	a2,0x0
 236:	09860613          	addi	a2,a2,152 # 2ca <my_thrdstop_handler>
 23a:	2501                	sext.w	a0,a0
 23c:	00000097          	auipc	ra,0x0
 240:	4c2080e7          	jalr	1218(ra) # 6fe <thrdstop>
        thrdresume(current_thread->thrdstop_context_id, 0);
 244:	4581                	li	a1,0
 246:	00001797          	auipc	a5,0x1
 24a:	a3a7b783          	ld	a5,-1478(a5) # c80 <current_thread>
 24e:	0b07a503          	lw	a0,176(a5)
 252:	00000097          	auipc	ra,0x0
 256:	4b4080e7          	jalr	1204(ra) # 706 <thrdresume>
    thread_exit();
 25a:	00000097          	auipc	ra,0x0
 25e:	efc080e7          	jalr	-260(ra) # 156 <thread_exit>
}
 262:	60e2                	ld	ra,24(sp)
 264:	6442                	ld	s0,16(sp)
 266:	64a2                	ld	s1,8(sp)
 268:	6902                	ld	s2,0(sp)
 26a:	6105                	addi	sp,sp,32
 26c:	8082                	ret
        current_thread->buf_set = 1;
 26e:	4785                	li	a5,1
 270:	08f4ae23          	sw	a5,156(s1)
        new_stack_p = (unsigned long) current_thread->stack_p;
 274:	0184b903          	ld	s2,24(s1)
        current_thread->thrdstop_context_id = thrdstop( __time_slot_size, -1, my_thrdstop_handler);
 278:	00000617          	auipc	a2,0x0
 27c:	05260613          	addi	a2,a2,82 # 2ca <my_thrdstop_handler>
 280:	55fd                	li	a1,-1
 282:	00001517          	auipc	a0,0x1
 286:	9ea52503          	lw	a0,-1558(a0) # c6c <__time_slot_size>
 28a:	00000097          	auipc	ra,0x0
 28e:	474080e7          	jalr	1140(ra) # 6fe <thrdstop>
 292:	0aa4a823          	sw	a0,176(s1)
        if( current_thread->thrdstop_context_id < 0 )
 296:	00001797          	auipc	a5,0x1
 29a:	9ea7b783          	ld	a5,-1558(a5) # c80 <current_thread>
 29e:	0b07a703          	lw	a4,176(a5)
 2a2:	00074763          	bltz	a4,2b0 <dispatch+0xb6>
        asm volatile("mv sp, %0" : : "r" (new_stack_p));
 2a6:	814a                	mv	sp,s2
        current_thread->fp(current_thread->arg);
 2a8:	6398                	ld	a4,0(a5)
 2aa:	6788                	ld	a0,8(a5)
 2ac:	9702                	jalr	a4
 2ae:	b775                	j	25a <dispatch+0x60>
            printf("error: number of threads may exceed\n");
 2b0:	00001517          	auipc	a0,0x1
 2b4:	97850513          	addi	a0,a0,-1672 # c28 <longjmp_1+0x26>
 2b8:	00000097          	auipc	ra,0x0
 2bc:	736080e7          	jalr	1846(ra) # 9ee <printf>
            exit(1);
 2c0:	4505                	li	a0,1
 2c2:	00000097          	auipc	ra,0x0
 2c6:	39c080e7          	jalr	924(ra) # 65e <exit>

00000000000002ca <my_thrdstop_handler>:
void my_thrdstop_handler(void){
 2ca:	1141                	addi	sp,sp,-16
 2cc:	e406                	sd	ra,8(sp)
 2ce:	e022                	sd	s0,0(sp)
 2d0:	0800                	addi	s0,sp,16
    current_thread->remain_execution_time -= __time_slot_size ;
 2d2:	00001717          	auipc	a4,0x1
 2d6:	9ae73703          	ld	a4,-1618(a4) # c80 <current_thread>
 2da:	0b472783          	lw	a5,180(a4)
 2de:	00001697          	auipc	a3,0x1
 2e2:	98e6a683          	lw	a3,-1650(a3) # c6c <__time_slot_size>
 2e6:	9f95                	subw	a5,a5,a3
 2e8:	0007869b          	sext.w	a3,a5
 2ec:	0af72a23          	sw	a5,180(a4)
    if( current_thread->remain_execution_time <= 0 )
 2f0:	00d05e63          	blez	a3,30c <my_thrdstop_handler+0x42>
        schedule();
 2f4:	00000097          	auipc	ra,0x0
 2f8:	dfa080e7          	jalr	-518(ra) # ee <schedule>
        dispatch();
 2fc:	00000097          	auipc	ra,0x0
 300:	efe080e7          	jalr	-258(ra) # 1fa <dispatch>
}
 304:	60a2                	ld	ra,8(sp)
 306:	6402                	ld	s0,0(sp)
 308:	0141                	addi	sp,sp,16
 30a:	8082                	ret
        thread_exit();
 30c:	00000097          	auipc	ra,0x0
 310:	e4a080e7          	jalr	-438(ra) # 156 <thread_exit>
 314:	bfc5                	j	304 <my_thrdstop_handler+0x3a>

0000000000000316 <thread_yield>:
void thread_yield(void){
 316:	1101                	addi	sp,sp,-32
 318:	ec06                	sd	ra,24(sp)
 31a:	e822                	sd	s0,16(sp)
 31c:	e426                	sd	s1,8(sp)
 31e:	1000                	addi	s0,sp,32
    int consume_ticks = cancelthrdstop( current_thread->thrdstop_context_id ); // cancel previous thrdstop and save the current thread context
 320:	00001497          	auipc	s1,0x1
 324:	96048493          	addi	s1,s1,-1696 # c80 <current_thread>
 328:	609c                	ld	a5,0(s1)
 32a:	0b07a503          	lw	a0,176(a5)
 32e:	00000097          	auipc	ra,0x0
 332:	3e0080e7          	jalr	992(ra) # 70e <cancelthrdstop>
    if( current_thread->is_yield == 0 )
 336:	609c                	ld	a5,0(s1)
 338:	0bc7a703          	lw	a4,188(a5)
 33c:	ef05                	bnez	a4,374 <thread_yield+0x5e>
        current_thread->remain_execution_time -= consume_ticks ;
 33e:	0b47a703          	lw	a4,180(a5)
 342:	40a7053b          	subw	a0,a4,a0
 346:	0005071b          	sext.w	a4,a0
 34a:	0aa7aa23          	sw	a0,180(a5)
        current_thread->is_yield = 1;
 34e:	4685                	li	a3,1
 350:	0ad7ae23          	sw	a3,188(a5)
        if( current_thread->remain_execution_time <= 0 )
 354:	00e05b63          	blez	a4,36a <thread_yield+0x54>
            schedule();
 358:	00000097          	auipc	ra,0x0
 35c:	d96080e7          	jalr	-618(ra) # ee <schedule>
            dispatch();
 360:	00000097          	auipc	ra,0x0
 364:	e9a080e7          	jalr	-358(ra) # 1fa <dispatch>
 368:	a801                	j	378 <thread_yield+0x62>
            thread_exit();
 36a:	00000097          	auipc	ra,0x0
 36e:	dec080e7          	jalr	-532(ra) # 156 <thread_exit>
 372:	a019                	j	378 <thread_yield+0x62>
        current_thread->is_yield = 0;
 374:	0a07ae23          	sw	zero,188(a5)
}
 378:	60e2                	ld	ra,24(sp)
 37a:	6442                	ld	s0,16(sp)
 37c:	64a2                	ld	s1,8(sp)
 37e:	6105                	addi	sp,sp,32
 380:	8082                	ret

0000000000000382 <thread_start_threading>:
void thread_start_threading(int time_slot_size){
 382:	1141                	addi	sp,sp,-16
 384:	e406                	sd	ra,8(sp)
 386:	e022                	sd	s0,0(sp)
 388:	0800                	addi	s0,sp,16
    __time_slot_size = time_slot_size;
 38a:	00001797          	auipc	a5,0x1
 38e:	8ea7a123          	sw	a0,-1822(a5) # c6c <__time_slot_size>

    struct thread* tmp_thread = current_thread;
 392:	00001697          	auipc	a3,0x1
 396:	8ee6b683          	ld	a3,-1810(a3) # c80 <current_thread>
 39a:	87b6                	mv	a5,a3
    while (tmp_thread != NULL)
 39c:	cb91                	beqz	a5,3b0 <thread_start_threading+0x2e>
    {
        tmp_thread->remain_execution_time *= time_slot_size;
 39e:	0b47a703          	lw	a4,180(a5)
 3a2:	02a7073b          	mulw	a4,a4,a0
 3a6:	0ae7aa23          	sw	a4,180(a5)
        tmp_thread = tmp_thread->next;
 3aa:	77dc                	ld	a5,168(a5)
        if( tmp_thread == current_thread )
 3ac:	fef698e3          	bne	a3,a5,39c <thread_start_threading+0x1a>
            break;
    }

    int r;
    r = setjmp(env_st);
 3b0:	00001517          	auipc	a0,0x1
 3b4:	8e050513          	addi	a0,a0,-1824 # c90 <env_st>
 3b8:	00000097          	auipc	ra,0x0
 3bc:	7d8080e7          	jalr	2008(ra) # b90 <setjmp>

    if(current_thread != NULL && r==0){
 3c0:	00001797          	auipc	a5,0x1
 3c4:	8c07b783          	ld	a5,-1856(a5) # c80 <current_thread>
 3c8:	c391                	beqz	a5,3cc <thread_start_threading+0x4a>
 3ca:	c509                	beqz	a0,3d4 <thread_start_threading+0x52>
        schedule() ;
        is_thread_start = 1;
        dispatch();
    }
}
 3cc:	60a2                	ld	ra,8(sp)
 3ce:	6402                	ld	s0,0(sp)
 3d0:	0141                	addi	sp,sp,16
 3d2:	8082                	ret
        schedule() ;
 3d4:	00000097          	auipc	ra,0x0
 3d8:	d1a080e7          	jalr	-742(ra) # ee <schedule>
        is_thread_start = 1;
 3dc:	4785                	li	a5,1
 3de:	00001717          	auipc	a4,0x1
 3e2:	88f72d23          	sw	a5,-1894(a4) # c78 <is_thread_start>
        dispatch();
 3e6:	00000097          	auipc	ra,0x0
 3ea:	e14080e7          	jalr	-492(ra) # 1fa <dispatch>
}
 3ee:	bff9                	j	3cc <thread_start_threading+0x4a>

00000000000003f0 <strcpy>:
#include "kernel/fcntl.h"
#include "user/user.h"

char*
strcpy(char *s, const char *t)
{
 3f0:	1141                	addi	sp,sp,-16
 3f2:	e422                	sd	s0,8(sp)
 3f4:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 3f6:	87aa                	mv	a5,a0
 3f8:	0585                	addi	a1,a1,1
 3fa:	0785                	addi	a5,a5,1
 3fc:	fff5c703          	lbu	a4,-1(a1)
 400:	fee78fa3          	sb	a4,-1(a5)
 404:	fb75                	bnez	a4,3f8 <strcpy+0x8>
    ;
  return os;
}
 406:	6422                	ld	s0,8(sp)
 408:	0141                	addi	sp,sp,16
 40a:	8082                	ret

000000000000040c <strcmp>:

int
strcmp(const char *p, const char *q)
{
 40c:	1141                	addi	sp,sp,-16
 40e:	e422                	sd	s0,8(sp)
 410:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 412:	00054783          	lbu	a5,0(a0)
 416:	cb91                	beqz	a5,42a <strcmp+0x1e>
 418:	0005c703          	lbu	a4,0(a1)
 41c:	00f71763          	bne	a4,a5,42a <strcmp+0x1e>
    p++, q++;
 420:	0505                	addi	a0,a0,1
 422:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 424:	00054783          	lbu	a5,0(a0)
 428:	fbe5                	bnez	a5,418 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 42a:	0005c503          	lbu	a0,0(a1)
}
 42e:	40a7853b          	subw	a0,a5,a0
 432:	6422                	ld	s0,8(sp)
 434:	0141                	addi	sp,sp,16
 436:	8082                	ret

0000000000000438 <strlen>:

uint
strlen(const char *s)
{
 438:	1141                	addi	sp,sp,-16
 43a:	e422                	sd	s0,8(sp)
 43c:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 43e:	00054783          	lbu	a5,0(a0)
 442:	cf91                	beqz	a5,45e <strlen+0x26>
 444:	0505                	addi	a0,a0,1
 446:	87aa                	mv	a5,a0
 448:	4685                	li	a3,1
 44a:	9e89                	subw	a3,a3,a0
 44c:	00f6853b          	addw	a0,a3,a5
 450:	0785                	addi	a5,a5,1
 452:	fff7c703          	lbu	a4,-1(a5)
 456:	fb7d                	bnez	a4,44c <strlen+0x14>
    ;
  return n;
}
 458:	6422                	ld	s0,8(sp)
 45a:	0141                	addi	sp,sp,16
 45c:	8082                	ret
  for(n = 0; s[n]; n++)
 45e:	4501                	li	a0,0
 460:	bfe5                	j	458 <strlen+0x20>

0000000000000462 <memset>:

void*
memset(void *dst, int c, uint n)
{
 462:	1141                	addi	sp,sp,-16
 464:	e422                	sd	s0,8(sp)
 466:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 468:	ca19                	beqz	a2,47e <memset+0x1c>
 46a:	87aa                	mv	a5,a0
 46c:	1602                	slli	a2,a2,0x20
 46e:	9201                	srli	a2,a2,0x20
 470:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 474:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 478:	0785                	addi	a5,a5,1
 47a:	fee79de3          	bne	a5,a4,474 <memset+0x12>
  }
  return dst;
}
 47e:	6422                	ld	s0,8(sp)
 480:	0141                	addi	sp,sp,16
 482:	8082                	ret

0000000000000484 <strchr>:

char*
strchr(const char *s, char c)
{
 484:	1141                	addi	sp,sp,-16
 486:	e422                	sd	s0,8(sp)
 488:	0800                	addi	s0,sp,16
  for(; *s; s++)
 48a:	00054783          	lbu	a5,0(a0)
 48e:	cb99                	beqz	a5,4a4 <strchr+0x20>
    if(*s == c)
 490:	00f58763          	beq	a1,a5,49e <strchr+0x1a>
  for(; *s; s++)
 494:	0505                	addi	a0,a0,1
 496:	00054783          	lbu	a5,0(a0)
 49a:	fbfd                	bnez	a5,490 <strchr+0xc>
      return (char*)s;
  return 0;
 49c:	4501                	li	a0,0
}
 49e:	6422                	ld	s0,8(sp)
 4a0:	0141                	addi	sp,sp,16
 4a2:	8082                	ret
  return 0;
 4a4:	4501                	li	a0,0
 4a6:	bfe5                	j	49e <strchr+0x1a>

00000000000004a8 <gets>:

char*
gets(char *buf, int max)
{
 4a8:	711d                	addi	sp,sp,-96
 4aa:	ec86                	sd	ra,88(sp)
 4ac:	e8a2                	sd	s0,80(sp)
 4ae:	e4a6                	sd	s1,72(sp)
 4b0:	e0ca                	sd	s2,64(sp)
 4b2:	fc4e                	sd	s3,56(sp)
 4b4:	f852                	sd	s4,48(sp)
 4b6:	f456                	sd	s5,40(sp)
 4b8:	f05a                	sd	s6,32(sp)
 4ba:	ec5e                	sd	s7,24(sp)
 4bc:	1080                	addi	s0,sp,96
 4be:	8baa                	mv	s7,a0
 4c0:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 4c2:	892a                	mv	s2,a0
 4c4:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 4c6:	4aa9                	li	s5,10
 4c8:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 4ca:	89a6                	mv	s3,s1
 4cc:	2485                	addiw	s1,s1,1
 4ce:	0344d863          	bge	s1,s4,4fe <gets+0x56>
    cc = read(0, &c, 1);
 4d2:	4605                	li	a2,1
 4d4:	faf40593          	addi	a1,s0,-81
 4d8:	4501                	li	a0,0
 4da:	00000097          	auipc	ra,0x0
 4de:	19c080e7          	jalr	412(ra) # 676 <read>
    if(cc < 1)
 4e2:	00a05e63          	blez	a0,4fe <gets+0x56>
    buf[i++] = c;
 4e6:	faf44783          	lbu	a5,-81(s0)
 4ea:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 4ee:	01578763          	beq	a5,s5,4fc <gets+0x54>
 4f2:	0905                	addi	s2,s2,1
 4f4:	fd679be3          	bne	a5,s6,4ca <gets+0x22>
  for(i=0; i+1 < max; ){
 4f8:	89a6                	mv	s3,s1
 4fa:	a011                	j	4fe <gets+0x56>
 4fc:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 4fe:	99de                	add	s3,s3,s7
 500:	00098023          	sb	zero,0(s3)
  return buf;
}
 504:	855e                	mv	a0,s7
 506:	60e6                	ld	ra,88(sp)
 508:	6446                	ld	s0,80(sp)
 50a:	64a6                	ld	s1,72(sp)
 50c:	6906                	ld	s2,64(sp)
 50e:	79e2                	ld	s3,56(sp)
 510:	7a42                	ld	s4,48(sp)
 512:	7aa2                	ld	s5,40(sp)
 514:	7b02                	ld	s6,32(sp)
 516:	6be2                	ld	s7,24(sp)
 518:	6125                	addi	sp,sp,96
 51a:	8082                	ret

000000000000051c <stat>:

int
stat(const char *n, struct stat *st)
{
 51c:	1101                	addi	sp,sp,-32
 51e:	ec06                	sd	ra,24(sp)
 520:	e822                	sd	s0,16(sp)
 522:	e426                	sd	s1,8(sp)
 524:	e04a                	sd	s2,0(sp)
 526:	1000                	addi	s0,sp,32
 528:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 52a:	4581                	li	a1,0
 52c:	00000097          	auipc	ra,0x0
 530:	172080e7          	jalr	370(ra) # 69e <open>
  if(fd < 0)
 534:	02054563          	bltz	a0,55e <stat+0x42>
 538:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 53a:	85ca                	mv	a1,s2
 53c:	00000097          	auipc	ra,0x0
 540:	17a080e7          	jalr	378(ra) # 6b6 <fstat>
 544:	892a                	mv	s2,a0
  close(fd);
 546:	8526                	mv	a0,s1
 548:	00000097          	auipc	ra,0x0
 54c:	13e080e7          	jalr	318(ra) # 686 <close>
  return r;
}
 550:	854a                	mv	a0,s2
 552:	60e2                	ld	ra,24(sp)
 554:	6442                	ld	s0,16(sp)
 556:	64a2                	ld	s1,8(sp)
 558:	6902                	ld	s2,0(sp)
 55a:	6105                	addi	sp,sp,32
 55c:	8082                	ret
    return -1;
 55e:	597d                	li	s2,-1
 560:	bfc5                	j	550 <stat+0x34>

0000000000000562 <atoi>:

int
atoi(const char *s)
{
 562:	1141                	addi	sp,sp,-16
 564:	e422                	sd	s0,8(sp)
 566:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 568:	00054603          	lbu	a2,0(a0)
 56c:	fd06079b          	addiw	a5,a2,-48
 570:	0ff7f793          	andi	a5,a5,255
 574:	4725                	li	a4,9
 576:	02f76963          	bltu	a4,a5,5a8 <atoi+0x46>
 57a:	86aa                	mv	a3,a0
  n = 0;
 57c:	4501                	li	a0,0
  while('0' <= *s && *s <= '9')
 57e:	45a5                	li	a1,9
    n = n*10 + *s++ - '0';
 580:	0685                	addi	a3,a3,1
 582:	0025179b          	slliw	a5,a0,0x2
 586:	9fa9                	addw	a5,a5,a0
 588:	0017979b          	slliw	a5,a5,0x1
 58c:	9fb1                	addw	a5,a5,a2
 58e:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 592:	0006c603          	lbu	a2,0(a3)
 596:	fd06071b          	addiw	a4,a2,-48
 59a:	0ff77713          	andi	a4,a4,255
 59e:	fee5f1e3          	bgeu	a1,a4,580 <atoi+0x1e>
  return n;
}
 5a2:	6422                	ld	s0,8(sp)
 5a4:	0141                	addi	sp,sp,16
 5a6:	8082                	ret
  n = 0;
 5a8:	4501                	li	a0,0
 5aa:	bfe5                	j	5a2 <atoi+0x40>

00000000000005ac <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 5ac:	1141                	addi	sp,sp,-16
 5ae:	e422                	sd	s0,8(sp)
 5b0:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 5b2:	02b57463          	bgeu	a0,a1,5da <memmove+0x2e>
    while(n-- > 0)
 5b6:	00c05f63          	blez	a2,5d4 <memmove+0x28>
 5ba:	1602                	slli	a2,a2,0x20
 5bc:	9201                	srli	a2,a2,0x20
 5be:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 5c2:	872a                	mv	a4,a0
      *dst++ = *src++;
 5c4:	0585                	addi	a1,a1,1
 5c6:	0705                	addi	a4,a4,1
 5c8:	fff5c683          	lbu	a3,-1(a1)
 5cc:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 5d0:	fee79ae3          	bne	a5,a4,5c4 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 5d4:	6422                	ld	s0,8(sp)
 5d6:	0141                	addi	sp,sp,16
 5d8:	8082                	ret
    dst += n;
 5da:	00c50733          	add	a4,a0,a2
    src += n;
 5de:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 5e0:	fec05ae3          	blez	a2,5d4 <memmove+0x28>
 5e4:	fff6079b          	addiw	a5,a2,-1
 5e8:	1782                	slli	a5,a5,0x20
 5ea:	9381                	srli	a5,a5,0x20
 5ec:	fff7c793          	not	a5,a5
 5f0:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 5f2:	15fd                	addi	a1,a1,-1
 5f4:	177d                	addi	a4,a4,-1
 5f6:	0005c683          	lbu	a3,0(a1)
 5fa:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 5fe:	fee79ae3          	bne	a5,a4,5f2 <memmove+0x46>
 602:	bfc9                	j	5d4 <memmove+0x28>

0000000000000604 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 604:	1141                	addi	sp,sp,-16
 606:	e422                	sd	s0,8(sp)
 608:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 60a:	ca05                	beqz	a2,63a <memcmp+0x36>
 60c:	fff6069b          	addiw	a3,a2,-1
 610:	1682                	slli	a3,a3,0x20
 612:	9281                	srli	a3,a3,0x20
 614:	0685                	addi	a3,a3,1
 616:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 618:	00054783          	lbu	a5,0(a0)
 61c:	0005c703          	lbu	a4,0(a1)
 620:	00e79863          	bne	a5,a4,630 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 624:	0505                	addi	a0,a0,1
    p2++;
 626:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 628:	fed518e3          	bne	a0,a3,618 <memcmp+0x14>
  }
  return 0;
 62c:	4501                	li	a0,0
 62e:	a019                	j	634 <memcmp+0x30>
      return *p1 - *p2;
 630:	40e7853b          	subw	a0,a5,a4
}
 634:	6422                	ld	s0,8(sp)
 636:	0141                	addi	sp,sp,16
 638:	8082                	ret
  return 0;
 63a:	4501                	li	a0,0
 63c:	bfe5                	j	634 <memcmp+0x30>

000000000000063e <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 63e:	1141                	addi	sp,sp,-16
 640:	e406                	sd	ra,8(sp)
 642:	e022                	sd	s0,0(sp)
 644:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 646:	00000097          	auipc	ra,0x0
 64a:	f66080e7          	jalr	-154(ra) # 5ac <memmove>
}
 64e:	60a2                	ld	ra,8(sp)
 650:	6402                	ld	s0,0(sp)
 652:	0141                	addi	sp,sp,16
 654:	8082                	ret

0000000000000656 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 656:	4885                	li	a7,1
 ecall
 658:	00000073          	ecall
 ret
 65c:	8082                	ret

000000000000065e <exit>:
.global exit
exit:
 li a7, SYS_exit
 65e:	4889                	li	a7,2
 ecall
 660:	00000073          	ecall
 ret
 664:	8082                	ret

0000000000000666 <wait>:
.global wait
wait:
 li a7, SYS_wait
 666:	488d                	li	a7,3
 ecall
 668:	00000073          	ecall
 ret
 66c:	8082                	ret

000000000000066e <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 66e:	4891                	li	a7,4
 ecall
 670:	00000073          	ecall
 ret
 674:	8082                	ret

0000000000000676 <read>:
.global read
read:
 li a7, SYS_read
 676:	4895                	li	a7,5
 ecall
 678:	00000073          	ecall
 ret
 67c:	8082                	ret

000000000000067e <write>:
.global write
write:
 li a7, SYS_write
 67e:	48c1                	li	a7,16
 ecall
 680:	00000073          	ecall
 ret
 684:	8082                	ret

0000000000000686 <close>:
.global close
close:
 li a7, SYS_close
 686:	48d5                	li	a7,21
 ecall
 688:	00000073          	ecall
 ret
 68c:	8082                	ret

000000000000068e <kill>:
.global kill
kill:
 li a7, SYS_kill
 68e:	4899                	li	a7,6
 ecall
 690:	00000073          	ecall
 ret
 694:	8082                	ret

0000000000000696 <exec>:
.global exec
exec:
 li a7, SYS_exec
 696:	489d                	li	a7,7
 ecall
 698:	00000073          	ecall
 ret
 69c:	8082                	ret

000000000000069e <open>:
.global open
open:
 li a7, SYS_open
 69e:	48bd                	li	a7,15
 ecall
 6a0:	00000073          	ecall
 ret
 6a4:	8082                	ret

00000000000006a6 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 6a6:	48c5                	li	a7,17
 ecall
 6a8:	00000073          	ecall
 ret
 6ac:	8082                	ret

00000000000006ae <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 6ae:	48c9                	li	a7,18
 ecall
 6b0:	00000073          	ecall
 ret
 6b4:	8082                	ret

00000000000006b6 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 6b6:	48a1                	li	a7,8
 ecall
 6b8:	00000073          	ecall
 ret
 6bc:	8082                	ret

00000000000006be <link>:
.global link
link:
 li a7, SYS_link
 6be:	48cd                	li	a7,19
 ecall
 6c0:	00000073          	ecall
 ret
 6c4:	8082                	ret

00000000000006c6 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 6c6:	48d1                	li	a7,20
 ecall
 6c8:	00000073          	ecall
 ret
 6cc:	8082                	ret

00000000000006ce <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 6ce:	48a5                	li	a7,9
 ecall
 6d0:	00000073          	ecall
 ret
 6d4:	8082                	ret

00000000000006d6 <dup>:
.global dup
dup:
 li a7, SYS_dup
 6d6:	48a9                	li	a7,10
 ecall
 6d8:	00000073          	ecall
 ret
 6dc:	8082                	ret

00000000000006de <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 6de:	48ad                	li	a7,11
 ecall
 6e0:	00000073          	ecall
 ret
 6e4:	8082                	ret

00000000000006e6 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 6e6:	48b1                	li	a7,12
 ecall
 6e8:	00000073          	ecall
 ret
 6ec:	8082                	ret

00000000000006ee <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 6ee:	48b5                	li	a7,13
 ecall
 6f0:	00000073          	ecall
 ret
 6f4:	8082                	ret

00000000000006f6 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 6f6:	48b9                	li	a7,14
 ecall
 6f8:	00000073          	ecall
 ret
 6fc:	8082                	ret

00000000000006fe <thrdstop>:
.global thrdstop
thrdstop:
 li a7, SYS_thrdstop
 6fe:	48d9                	li	a7,22
 ecall
 700:	00000073          	ecall
 ret
 704:	8082                	ret

0000000000000706 <thrdresume>:
.global thrdresume
thrdresume:
 li a7, SYS_thrdresume
 706:	48dd                	li	a7,23
 ecall
 708:	00000073          	ecall
 ret
 70c:	8082                	ret

000000000000070e <cancelthrdstop>:
.global cancelthrdstop
cancelthrdstop:
 li a7, SYS_cancelthrdstop
 70e:	48e1                	li	a7,24
 ecall
 710:	00000073          	ecall
 ret
 714:	8082                	ret

0000000000000716 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 716:	1101                	addi	sp,sp,-32
 718:	ec06                	sd	ra,24(sp)
 71a:	e822                	sd	s0,16(sp)
 71c:	1000                	addi	s0,sp,32
 71e:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 722:	4605                	li	a2,1
 724:	fef40593          	addi	a1,s0,-17
 728:	00000097          	auipc	ra,0x0
 72c:	f56080e7          	jalr	-170(ra) # 67e <write>
}
 730:	60e2                	ld	ra,24(sp)
 732:	6442                	ld	s0,16(sp)
 734:	6105                	addi	sp,sp,32
 736:	8082                	ret

0000000000000738 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 738:	7139                	addi	sp,sp,-64
 73a:	fc06                	sd	ra,56(sp)
 73c:	f822                	sd	s0,48(sp)
 73e:	f426                	sd	s1,40(sp)
 740:	f04a                	sd	s2,32(sp)
 742:	ec4e                	sd	s3,24(sp)
 744:	0080                	addi	s0,sp,64
 746:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 748:	c299                	beqz	a3,74e <printint+0x16>
 74a:	0805c863          	bltz	a1,7da <printint+0xa2>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 74e:	2581                	sext.w	a1,a1
  neg = 0;
 750:	4881                	li	a7,0
 752:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 756:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 758:	2601                	sext.w	a2,a2
 75a:	00000517          	auipc	a0,0x0
 75e:	4fe50513          	addi	a0,a0,1278 # c58 <digits>
 762:	883a                	mv	a6,a4
 764:	2705                	addiw	a4,a4,1
 766:	02c5f7bb          	remuw	a5,a1,a2
 76a:	1782                	slli	a5,a5,0x20
 76c:	9381                	srli	a5,a5,0x20
 76e:	97aa                	add	a5,a5,a0
 770:	0007c783          	lbu	a5,0(a5)
 774:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 778:	0005879b          	sext.w	a5,a1
 77c:	02c5d5bb          	divuw	a1,a1,a2
 780:	0685                	addi	a3,a3,1
 782:	fec7f0e3          	bgeu	a5,a2,762 <printint+0x2a>
  if(neg)
 786:	00088b63          	beqz	a7,79c <printint+0x64>
    buf[i++] = '-';
 78a:	fd040793          	addi	a5,s0,-48
 78e:	973e                	add	a4,a4,a5
 790:	02d00793          	li	a5,45
 794:	fef70823          	sb	a5,-16(a4)
 798:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 79c:	02e05863          	blez	a4,7cc <printint+0x94>
 7a0:	fc040793          	addi	a5,s0,-64
 7a4:	00e78933          	add	s2,a5,a4
 7a8:	fff78993          	addi	s3,a5,-1
 7ac:	99ba                	add	s3,s3,a4
 7ae:	377d                	addiw	a4,a4,-1
 7b0:	1702                	slli	a4,a4,0x20
 7b2:	9301                	srli	a4,a4,0x20
 7b4:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 7b8:	fff94583          	lbu	a1,-1(s2)
 7bc:	8526                	mv	a0,s1
 7be:	00000097          	auipc	ra,0x0
 7c2:	f58080e7          	jalr	-168(ra) # 716 <putc>
  while(--i >= 0)
 7c6:	197d                	addi	s2,s2,-1
 7c8:	ff3918e3          	bne	s2,s3,7b8 <printint+0x80>
}
 7cc:	70e2                	ld	ra,56(sp)
 7ce:	7442                	ld	s0,48(sp)
 7d0:	74a2                	ld	s1,40(sp)
 7d2:	7902                	ld	s2,32(sp)
 7d4:	69e2                	ld	s3,24(sp)
 7d6:	6121                	addi	sp,sp,64
 7d8:	8082                	ret
    x = -xx;
 7da:	40b005bb          	negw	a1,a1
    neg = 1;
 7de:	4885                	li	a7,1
    x = -xx;
 7e0:	bf8d                	j	752 <printint+0x1a>

00000000000007e2 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 7e2:	7119                	addi	sp,sp,-128
 7e4:	fc86                	sd	ra,120(sp)
 7e6:	f8a2                	sd	s0,112(sp)
 7e8:	f4a6                	sd	s1,104(sp)
 7ea:	f0ca                	sd	s2,96(sp)
 7ec:	ecce                	sd	s3,88(sp)
 7ee:	e8d2                	sd	s4,80(sp)
 7f0:	e4d6                	sd	s5,72(sp)
 7f2:	e0da                	sd	s6,64(sp)
 7f4:	fc5e                	sd	s7,56(sp)
 7f6:	f862                	sd	s8,48(sp)
 7f8:	f466                	sd	s9,40(sp)
 7fa:	f06a                	sd	s10,32(sp)
 7fc:	ec6e                	sd	s11,24(sp)
 7fe:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 800:	0005c903          	lbu	s2,0(a1)
 804:	18090f63          	beqz	s2,9a2 <vprintf+0x1c0>
 808:	8aaa                	mv	s5,a0
 80a:	8b32                	mv	s6,a2
 80c:	00158493          	addi	s1,a1,1
  state = 0;
 810:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 812:	02500a13          	li	s4,37
      if(c == 'd'){
 816:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c == 'l') {
 81a:	06c00c93          	li	s9,108
        printint(fd, va_arg(ap, uint64), 10, 0);
      } else if(c == 'x') {
 81e:	07800d13          	li	s10,120
        printint(fd, va_arg(ap, int), 16, 0);
      } else if(c == 'p') {
 822:	07000d93          	li	s11,112
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 826:	00000b97          	auipc	s7,0x0
 82a:	432b8b93          	addi	s7,s7,1074 # c58 <digits>
 82e:	a839                	j	84c <vprintf+0x6a>
        putc(fd, c);
 830:	85ca                	mv	a1,s2
 832:	8556                	mv	a0,s5
 834:	00000097          	auipc	ra,0x0
 838:	ee2080e7          	jalr	-286(ra) # 716 <putc>
 83c:	a019                	j	842 <vprintf+0x60>
    } else if(state == '%'){
 83e:	01498f63          	beq	s3,s4,85c <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
 842:	0485                	addi	s1,s1,1
 844:	fff4c903          	lbu	s2,-1(s1)
 848:	14090d63          	beqz	s2,9a2 <vprintf+0x1c0>
    c = fmt[i] & 0xff;
 84c:	0009079b          	sext.w	a5,s2
    if(state == 0){
 850:	fe0997e3          	bnez	s3,83e <vprintf+0x5c>
      if(c == '%'){
 854:	fd479ee3          	bne	a5,s4,830 <vprintf+0x4e>
        state = '%';
 858:	89be                	mv	s3,a5
 85a:	b7e5                	j	842 <vprintf+0x60>
      if(c == 'd'){
 85c:	05878063          	beq	a5,s8,89c <vprintf+0xba>
      } else if(c == 'l') {
 860:	05978c63          	beq	a5,s9,8b8 <vprintf+0xd6>
      } else if(c == 'x') {
 864:	07a78863          	beq	a5,s10,8d4 <vprintf+0xf2>
      } else if(c == 'p') {
 868:	09b78463          	beq	a5,s11,8f0 <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
 86c:	07300713          	li	a4,115
 870:	0ce78663          	beq	a5,a4,93c <vprintf+0x15a>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 874:	06300713          	li	a4,99
 878:	0ee78e63          	beq	a5,a4,974 <vprintf+0x192>
        putc(fd, va_arg(ap, uint));
      } else if(c == '%'){
 87c:	11478863          	beq	a5,s4,98c <vprintf+0x1aa>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 880:	85d2                	mv	a1,s4
 882:	8556                	mv	a0,s5
 884:	00000097          	auipc	ra,0x0
 888:	e92080e7          	jalr	-366(ra) # 716 <putc>
        putc(fd, c);
 88c:	85ca                	mv	a1,s2
 88e:	8556                	mv	a0,s5
 890:	00000097          	auipc	ra,0x0
 894:	e86080e7          	jalr	-378(ra) # 716 <putc>
      }
      state = 0;
 898:	4981                	li	s3,0
 89a:	b765                	j	842 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 10, 1);
 89c:	008b0913          	addi	s2,s6,8
 8a0:	4685                	li	a3,1
 8a2:	4629                	li	a2,10
 8a4:	000b2583          	lw	a1,0(s6)
 8a8:	8556                	mv	a0,s5
 8aa:	00000097          	auipc	ra,0x0
 8ae:	e8e080e7          	jalr	-370(ra) # 738 <printint>
 8b2:	8b4a                	mv	s6,s2
      state = 0;
 8b4:	4981                	li	s3,0
 8b6:	b771                	j	842 <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
 8b8:	008b0913          	addi	s2,s6,8
 8bc:	4681                	li	a3,0
 8be:	4629                	li	a2,10
 8c0:	000b2583          	lw	a1,0(s6)
 8c4:	8556                	mv	a0,s5
 8c6:	00000097          	auipc	ra,0x0
 8ca:	e72080e7          	jalr	-398(ra) # 738 <printint>
 8ce:	8b4a                	mv	s6,s2
      state = 0;
 8d0:	4981                	li	s3,0
 8d2:	bf85                	j	842 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
 8d4:	008b0913          	addi	s2,s6,8
 8d8:	4681                	li	a3,0
 8da:	4641                	li	a2,16
 8dc:	000b2583          	lw	a1,0(s6)
 8e0:	8556                	mv	a0,s5
 8e2:	00000097          	auipc	ra,0x0
 8e6:	e56080e7          	jalr	-426(ra) # 738 <printint>
 8ea:	8b4a                	mv	s6,s2
      state = 0;
 8ec:	4981                	li	s3,0
 8ee:	bf91                	j	842 <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
 8f0:	008b0793          	addi	a5,s6,8
 8f4:	f8f43423          	sd	a5,-120(s0)
 8f8:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
 8fc:	03000593          	li	a1,48
 900:	8556                	mv	a0,s5
 902:	00000097          	auipc	ra,0x0
 906:	e14080e7          	jalr	-492(ra) # 716 <putc>
  putc(fd, 'x');
 90a:	85ea                	mv	a1,s10
 90c:	8556                	mv	a0,s5
 90e:	00000097          	auipc	ra,0x0
 912:	e08080e7          	jalr	-504(ra) # 716 <putc>
 916:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 918:	03c9d793          	srli	a5,s3,0x3c
 91c:	97de                	add	a5,a5,s7
 91e:	0007c583          	lbu	a1,0(a5)
 922:	8556                	mv	a0,s5
 924:	00000097          	auipc	ra,0x0
 928:	df2080e7          	jalr	-526(ra) # 716 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 92c:	0992                	slli	s3,s3,0x4
 92e:	397d                	addiw	s2,s2,-1
 930:	fe0914e3          	bnez	s2,918 <vprintf+0x136>
        printptr(fd, va_arg(ap, uint64));
 934:	f8843b03          	ld	s6,-120(s0)
      state = 0;
 938:	4981                	li	s3,0
 93a:	b721                	j	842 <vprintf+0x60>
        s = va_arg(ap, char*);
 93c:	008b0993          	addi	s3,s6,8
 940:	000b3903          	ld	s2,0(s6)
        if(s == 0)
 944:	02090163          	beqz	s2,966 <vprintf+0x184>
        while(*s != 0){
 948:	00094583          	lbu	a1,0(s2)
 94c:	c9a1                	beqz	a1,99c <vprintf+0x1ba>
          putc(fd, *s);
 94e:	8556                	mv	a0,s5
 950:	00000097          	auipc	ra,0x0
 954:	dc6080e7          	jalr	-570(ra) # 716 <putc>
          s++;
 958:	0905                	addi	s2,s2,1
        while(*s != 0){
 95a:	00094583          	lbu	a1,0(s2)
 95e:	f9e5                	bnez	a1,94e <vprintf+0x16c>
        s = va_arg(ap, char*);
 960:	8b4e                	mv	s6,s3
      state = 0;
 962:	4981                	li	s3,0
 964:	bdf9                	j	842 <vprintf+0x60>
          s = "(null)";
 966:	00000917          	auipc	s2,0x0
 96a:	2ea90913          	addi	s2,s2,746 # c50 <longjmp_1+0x4e>
        while(*s != 0){
 96e:	02800593          	li	a1,40
 972:	bff1                	j	94e <vprintf+0x16c>
        putc(fd, va_arg(ap, uint));
 974:	008b0913          	addi	s2,s6,8
 978:	000b4583          	lbu	a1,0(s6)
 97c:	8556                	mv	a0,s5
 97e:	00000097          	auipc	ra,0x0
 982:	d98080e7          	jalr	-616(ra) # 716 <putc>
 986:	8b4a                	mv	s6,s2
      state = 0;
 988:	4981                	li	s3,0
 98a:	bd65                	j	842 <vprintf+0x60>
        putc(fd, c);
 98c:	85d2                	mv	a1,s4
 98e:	8556                	mv	a0,s5
 990:	00000097          	auipc	ra,0x0
 994:	d86080e7          	jalr	-634(ra) # 716 <putc>
      state = 0;
 998:	4981                	li	s3,0
 99a:	b565                	j	842 <vprintf+0x60>
        s = va_arg(ap, char*);
 99c:	8b4e                	mv	s6,s3
      state = 0;
 99e:	4981                	li	s3,0
 9a0:	b54d                	j	842 <vprintf+0x60>
    }
  }
}
 9a2:	70e6                	ld	ra,120(sp)
 9a4:	7446                	ld	s0,112(sp)
 9a6:	74a6                	ld	s1,104(sp)
 9a8:	7906                	ld	s2,96(sp)
 9aa:	69e6                	ld	s3,88(sp)
 9ac:	6a46                	ld	s4,80(sp)
 9ae:	6aa6                	ld	s5,72(sp)
 9b0:	6b06                	ld	s6,64(sp)
 9b2:	7be2                	ld	s7,56(sp)
 9b4:	7c42                	ld	s8,48(sp)
 9b6:	7ca2                	ld	s9,40(sp)
 9b8:	7d02                	ld	s10,32(sp)
 9ba:	6de2                	ld	s11,24(sp)
 9bc:	6109                	addi	sp,sp,128
 9be:	8082                	ret

00000000000009c0 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 9c0:	715d                	addi	sp,sp,-80
 9c2:	ec06                	sd	ra,24(sp)
 9c4:	e822                	sd	s0,16(sp)
 9c6:	1000                	addi	s0,sp,32
 9c8:	e010                	sd	a2,0(s0)
 9ca:	e414                	sd	a3,8(s0)
 9cc:	e818                	sd	a4,16(s0)
 9ce:	ec1c                	sd	a5,24(s0)
 9d0:	03043023          	sd	a6,32(s0)
 9d4:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 9d8:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 9dc:	8622                	mv	a2,s0
 9de:	00000097          	auipc	ra,0x0
 9e2:	e04080e7          	jalr	-508(ra) # 7e2 <vprintf>
}
 9e6:	60e2                	ld	ra,24(sp)
 9e8:	6442                	ld	s0,16(sp)
 9ea:	6161                	addi	sp,sp,80
 9ec:	8082                	ret

00000000000009ee <printf>:

void
printf(const char *fmt, ...)
{
 9ee:	711d                	addi	sp,sp,-96
 9f0:	ec06                	sd	ra,24(sp)
 9f2:	e822                	sd	s0,16(sp)
 9f4:	1000                	addi	s0,sp,32
 9f6:	e40c                	sd	a1,8(s0)
 9f8:	e810                	sd	a2,16(s0)
 9fa:	ec14                	sd	a3,24(s0)
 9fc:	f018                	sd	a4,32(s0)
 9fe:	f41c                	sd	a5,40(s0)
 a00:	03043823          	sd	a6,48(s0)
 a04:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 a08:	00840613          	addi	a2,s0,8
 a0c:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 a10:	85aa                	mv	a1,a0
 a12:	4505                	li	a0,1
 a14:	00000097          	auipc	ra,0x0
 a18:	dce080e7          	jalr	-562(ra) # 7e2 <vprintf>
}
 a1c:	60e2                	ld	ra,24(sp)
 a1e:	6442                	ld	s0,16(sp)
 a20:	6125                	addi	sp,sp,96
 a22:	8082                	ret

0000000000000a24 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 a24:	1141                	addi	sp,sp,-16
 a26:	e422                	sd	s0,8(sp)
 a28:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 a2a:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 a2e:	00000797          	auipc	a5,0x0
 a32:	25a7b783          	ld	a5,602(a5) # c88 <freep>
 a36:	a805                	j	a66 <free+0x42>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 a38:	4618                	lw	a4,8(a2)
 a3a:	9db9                	addw	a1,a1,a4
 a3c:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 a40:	6398                	ld	a4,0(a5)
 a42:	6318                	ld	a4,0(a4)
 a44:	fee53823          	sd	a4,-16(a0)
 a48:	a091                	j	a8c <free+0x68>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 a4a:	ff852703          	lw	a4,-8(a0)
 a4e:	9e39                	addw	a2,a2,a4
 a50:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
 a52:	ff053703          	ld	a4,-16(a0)
 a56:	e398                	sd	a4,0(a5)
 a58:	a099                	j	a9e <free+0x7a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 a5a:	6398                	ld	a4,0(a5)
 a5c:	00e7e463          	bltu	a5,a4,a64 <free+0x40>
 a60:	00e6ea63          	bltu	a3,a4,a74 <free+0x50>
{
 a64:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 a66:	fed7fae3          	bgeu	a5,a3,a5a <free+0x36>
 a6a:	6398                	ld	a4,0(a5)
 a6c:	00e6e463          	bltu	a3,a4,a74 <free+0x50>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 a70:	fee7eae3          	bltu	a5,a4,a64 <free+0x40>
  if(bp + bp->s.size == p->s.ptr){
 a74:	ff852583          	lw	a1,-8(a0)
 a78:	6390                	ld	a2,0(a5)
 a7a:	02059713          	slli	a4,a1,0x20
 a7e:	9301                	srli	a4,a4,0x20
 a80:	0712                	slli	a4,a4,0x4
 a82:	9736                	add	a4,a4,a3
 a84:	fae60ae3          	beq	a2,a4,a38 <free+0x14>
    bp->s.ptr = p->s.ptr;
 a88:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 a8c:	4790                	lw	a2,8(a5)
 a8e:	02061713          	slli	a4,a2,0x20
 a92:	9301                	srli	a4,a4,0x20
 a94:	0712                	slli	a4,a4,0x4
 a96:	973e                	add	a4,a4,a5
 a98:	fae689e3          	beq	a3,a4,a4a <free+0x26>
  } else
    p->s.ptr = bp;
 a9c:	e394                	sd	a3,0(a5)
  freep = p;
 a9e:	00000717          	auipc	a4,0x0
 aa2:	1ef73523          	sd	a5,490(a4) # c88 <freep>
}
 aa6:	6422                	ld	s0,8(sp)
 aa8:	0141                	addi	sp,sp,16
 aaa:	8082                	ret

0000000000000aac <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 aac:	7139                	addi	sp,sp,-64
 aae:	fc06                	sd	ra,56(sp)
 ab0:	f822                	sd	s0,48(sp)
 ab2:	f426                	sd	s1,40(sp)
 ab4:	f04a                	sd	s2,32(sp)
 ab6:	ec4e                	sd	s3,24(sp)
 ab8:	e852                	sd	s4,16(sp)
 aba:	e456                	sd	s5,8(sp)
 abc:	e05a                	sd	s6,0(sp)
 abe:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 ac0:	02051493          	slli	s1,a0,0x20
 ac4:	9081                	srli	s1,s1,0x20
 ac6:	04bd                	addi	s1,s1,15
 ac8:	8091                	srli	s1,s1,0x4
 aca:	0014899b          	addiw	s3,s1,1
 ace:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 ad0:	00000517          	auipc	a0,0x0
 ad4:	1b853503          	ld	a0,440(a0) # c88 <freep>
 ad8:	c515                	beqz	a0,b04 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 ada:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 adc:	4798                	lw	a4,8(a5)
 ade:	02977f63          	bgeu	a4,s1,b1c <malloc+0x70>
 ae2:	8a4e                	mv	s4,s3
 ae4:	0009871b          	sext.w	a4,s3
 ae8:	6685                	lui	a3,0x1
 aea:	00d77363          	bgeu	a4,a3,af0 <malloc+0x44>
 aee:	6a05                	lui	s4,0x1
 af0:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 af4:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 af8:	00000917          	auipc	s2,0x0
 afc:	19090913          	addi	s2,s2,400 # c88 <freep>
  if(p == (char*)-1)
 b00:	5afd                	li	s5,-1
 b02:	a88d                	j	b74 <malloc+0xc8>
    base.s.ptr = freep = prevp = &base;
 b04:	00000797          	auipc	a5,0x0
 b08:	1fc78793          	addi	a5,a5,508 # d00 <base>
 b0c:	00000717          	auipc	a4,0x0
 b10:	16f73e23          	sd	a5,380(a4) # c88 <freep>
 b14:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 b16:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 b1a:	b7e1                	j	ae2 <malloc+0x36>
      if(p->s.size == nunits)
 b1c:	02e48b63          	beq	s1,a4,b52 <malloc+0xa6>
        p->s.size -= nunits;
 b20:	4137073b          	subw	a4,a4,s3
 b24:	c798                	sw	a4,8(a5)
        p += p->s.size;
 b26:	1702                	slli	a4,a4,0x20
 b28:	9301                	srli	a4,a4,0x20
 b2a:	0712                	slli	a4,a4,0x4
 b2c:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 b2e:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 b32:	00000717          	auipc	a4,0x0
 b36:	14a73b23          	sd	a0,342(a4) # c88 <freep>
      return (void*)(p + 1);
 b3a:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 b3e:	70e2                	ld	ra,56(sp)
 b40:	7442                	ld	s0,48(sp)
 b42:	74a2                	ld	s1,40(sp)
 b44:	7902                	ld	s2,32(sp)
 b46:	69e2                	ld	s3,24(sp)
 b48:	6a42                	ld	s4,16(sp)
 b4a:	6aa2                	ld	s5,8(sp)
 b4c:	6b02                	ld	s6,0(sp)
 b4e:	6121                	addi	sp,sp,64
 b50:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 b52:	6398                	ld	a4,0(a5)
 b54:	e118                	sd	a4,0(a0)
 b56:	bff1                	j	b32 <malloc+0x86>
  hp->s.size = nu;
 b58:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 b5c:	0541                	addi	a0,a0,16
 b5e:	00000097          	auipc	ra,0x0
 b62:	ec6080e7          	jalr	-314(ra) # a24 <free>
  return freep;
 b66:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 b6a:	d971                	beqz	a0,b3e <malloc+0x92>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 b6c:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 b6e:	4798                	lw	a4,8(a5)
 b70:	fa9776e3          	bgeu	a4,s1,b1c <malloc+0x70>
    if(p == freep)
 b74:	00093703          	ld	a4,0(s2)
 b78:	853e                	mv	a0,a5
 b7a:	fef719e3          	bne	a4,a5,b6c <malloc+0xc0>
  p = sbrk(nu * sizeof(Header));
 b7e:	8552                	mv	a0,s4
 b80:	00000097          	auipc	ra,0x0
 b84:	b66080e7          	jalr	-1178(ra) # 6e6 <sbrk>
  if(p == (char*)-1)
 b88:	fd5518e3          	bne	a0,s5,b58 <malloc+0xac>
        return 0;
 b8c:	4501                	li	a0,0
 b8e:	bf45                	j	b3e <malloc+0x92>

0000000000000b90 <setjmp>:
 b90:	e100                	sd	s0,0(a0)
 b92:	e504                	sd	s1,8(a0)
 b94:	01253823          	sd	s2,16(a0)
 b98:	01353c23          	sd	s3,24(a0)
 b9c:	03453023          	sd	s4,32(a0)
 ba0:	03553423          	sd	s5,40(a0)
 ba4:	03653823          	sd	s6,48(a0)
 ba8:	03753c23          	sd	s7,56(a0)
 bac:	05853023          	sd	s8,64(a0)
 bb0:	05953423          	sd	s9,72(a0)
 bb4:	05a53823          	sd	s10,80(a0)
 bb8:	05b53c23          	sd	s11,88(a0)
 bbc:	06153023          	sd	ra,96(a0)
 bc0:	06253423          	sd	sp,104(a0)
 bc4:	4501                	li	a0,0
 bc6:	8082                	ret

0000000000000bc8 <longjmp>:
 bc8:	6100                	ld	s0,0(a0)
 bca:	6504                	ld	s1,8(a0)
 bcc:	01053903          	ld	s2,16(a0)
 bd0:	01853983          	ld	s3,24(a0)
 bd4:	02053a03          	ld	s4,32(a0)
 bd8:	02853a83          	ld	s5,40(a0)
 bdc:	03053b03          	ld	s6,48(a0)
 be0:	03853b83          	ld	s7,56(a0)
 be4:	04053c03          	ld	s8,64(a0)
 be8:	04853c83          	ld	s9,72(a0)
 bec:	05053d03          	ld	s10,80(a0)
 bf0:	05853d83          	ld	s11,88(a0)
 bf4:	06053083          	ld	ra,96(a0)
 bf8:	06853103          	ld	sp,104(a0)
 bfc:	c199                	beqz	a1,c02 <longjmp_1>
 bfe:	852e                	mv	a0,a1
 c00:	8082                	ret

0000000000000c02 <longjmp_1>:
 c02:	4505                	li	a0,1
 c04:	8082                	ret
