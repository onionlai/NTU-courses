#include "kernel/types.h"
#include "user/setjmp.h"
#include "user/threads.h"
#include "user/user.h"
#define NULL 0


static struct thread* current_thread = NULL;
static int id = 1;
static int __time_slot_size = 10;
static int is_thread_start = 0;
static jmp_buf env_st;
// static jmp_buf env_tmp;

struct thread *thread_create(void (*f)(void *), void *arg, int execution_time_slot){
    struct thread *t = (struct thread*) malloc(sizeof(struct thread));
    //unsigned long stack_p = 0;
    unsigned long new_stack_p;
    unsigned long new_stack;
    new_stack = (unsigned long) malloc(sizeof(unsigned long)*0x100);
    new_stack_p = new_stack +0x100*8-0x2*8;
    t->fp = f;
    t->arg = arg;
    t->ID  = -1;
    t->buf_set = 0;
    t->stack = (void*) new_stack;
    t->stack_p = (void*) new_stack_p;

    if( is_thread_start == 0 )
        t->remain_execution_time = execution_time_slot;
    else
        t->remain_execution_time = execution_time_slot * __time_slot_size;

    t->is_yield = 0;
    t->is_exited = 0;
    return t;
}
void thread_add_runqueue(struct thread *t){
    t->start_time = uptime();
    t->ID  = id;
    id ++;
    if(current_thread == NULL){
        current_thread = t;
        current_thread->previous = t;
        current_thread->next = t;
        return;
    }
    else{
        if(current_thread->previous->ID == current_thread->ID){
            //Single thread in queue
            current_thread->previous = t;
            current_thread->next = t;
            t->previous = current_thread;
            t->next = current_thread;
        }
        else{
            //Two or more threads in queue
            current_thread->previous->next = t;
            t->previous = current_thread->previous;
            t->next = current_thread;
            current_thread->previous = t;
        }
    }
}

// 每__time_slot_size都會進來這裡
void my_thrdstop_handler(void){
    current_thread->remain_execution_time -= __time_slot_size ;
    // printf("+++ ID=%d handler, remain_exec_time = %d \n", current_thread->ID, current_thread->remain_execution_time);
    if( current_thread->remain_execution_time <= 0 )
    {
        thread_exit();
    }
    else
    {
        schedule();
        dispatch();
    }
}

void thread_yield(void){
    int consume_ticks = cancelthrdstop( current_thread->thrdstop_context_id ); // cancel previous thrdstop and save the current thread context
    if( current_thread->is_yield == 0 )
    {
        current_thread->remain_execution_time -= consume_ticks ;

        current_thread->is_yield = 1;

        if( current_thread->remain_execution_time <= 0 )
        {
            thread_exit();
        }
        else
        {
            schedule();
            dispatch();
        }
    }
    else{
        current_thread->is_yield = 0;
    }
}

void dispatch(void){
    if(current_thread->buf_set)
    {
        // If remain_execution_time is smaller than time_slot_size, we interrupt the thread after remain_execution_time ticks.
        int next_time = (__time_slot_size >= current_thread->remain_execution_time )? current_thread->remain_execution_time: __time_slot_size;

        thrdstop( next_time, current_thread->thrdstop_context_id, my_thrdstop_handler); // after next_time ticks, my_thrdstop_handler will be called.
        thrdresume(current_thread->thrdstop_context_id, 0);
    }
    else // init
    {

        current_thread->buf_set = 1;
        unsigned long new_stack_p;
        new_stack_p = (unsigned long) current_thread->stack_p;

        current_thread->thrdstop_context_id = thrdstop( __time_slot_size, -1, my_thrdstop_handler);
        if( current_thread->thrdstop_context_id < 0 )
        {
            printf("error: number of threads may exceed\n");
            exit(1);
        }

        // set sp to stack pointer of current thread.
        asm volatile("mv sp, %0" : : "r" (new_stack_p));
        current_thread->fp(current_thread->arg);


    }
    thread_exit();
}
void schedule(void){
    /////////////// default ////////////////
    // if( is_thread_start == 0 )
    //     return;
    // else
    //     current_thread = current_thread->next;
    // return;

    ///////////////// FCFS /////////////////////

    if(current_thread->is_exited)
        current_thread = current_thread->next;
    return ;

    ///////////////// RR /////////////////////
    // static int tq_count;
    // // printf("----------------------------------\n");
    // // printf("ID %d, (before count)tq_count = %d\n",current_thread->ID, tq_count);
    // if(is_thread_start == 0){
    //     tq_count = 0;
    //     return;
    // }
    // if(current_thread->is_exited || current_thread->is_yield){
    //     // printf("exit or yield\n");
    //     current_thread = current_thread->next;
    //     tq_count = 0;
    //     return;
    // }

    // tq_count ++;
    // // printf("ID %d, (after count)tq_count = %d\n",current_thread->ID, tq_count);
    // if(tq_count == 3){
    //     // printf("RR change from ID= %d to ID=%d\n ", current_thread->ID, current_thread->next->ID);
    //     current_thread = current_thread->next;
    //     tq_count = 0;
    // }
    // return ;

    ///////////////// SJF /////////////////////
    // // printf("----------------------------------\n");
    // // printf("current ID=%d, (r.time%d)\n", current_thread->ID, current_thread->remain_execution_time);
    // if(! current_thread->is_exited && !current_thread->is_yield)
    //     return;

    // // printf("exit or yield\n");

    // struct thread* head = current_thread;
    // struct thread* t = current_thread->next;
    // struct thread* candidate = current_thread;
    // if(current_thread->is_exited)
    //     candidate = current_thread->next;

    // while(t != head){
    //     if(t->remain_execution_time < candidate->remain_execution_time)
    //         candidate = t;
    //     else if(t->remain_execution_time == candidate->remain_execution_time && t->ID < candidate->ID)
    //         candidate = t;
    //     t = t->next;
    // }
    // // printf("SJF schedule from ID=%d(r.time=%d) to ID=%d(r.time=%d)\n", current_thread->ID, current_thread->remain_execution_time,candidate->ID, candidate->remain_execution_time);
    // current_thread = candidate;
    // return;


    ///////////// PSJF ///////////////
    // // printf("----------------------------------\n");
    // // printf("current ID=%d, (r.time=%d)\n", current_thread->ID, current_thread->remain_execution_time);

    // struct thread* head = current_thread;
    // struct thread* t = current_thread->next;
    // struct thread* candidate = current_thread;
    // if(current_thread->is_exited)
    //     candidate = current_thread->next;

    // while(t != head){
    //     if(t->remain_execution_time < candidate->remain_execution_time)
    //         candidate = t;
    //     else if(t->remain_execution_time == candidate->remain_execution_time && t->ID < candidate->ID)
    //         candidate = t;
    //     t = t->next;
    // }
    // //printf("PSJF schedule from ID=%d(r.time=%d) to ID=%d(r.time=%d)\n", current_thread->ID, current_thread->remain_execution_time,candidate->ID, candidate->remain_execution_time);
    // current_thread = candidate;
    // return ;
}

void thread_exit(void){
    // remove the thread immediately, and cancel previous thrdstop.
    thrdresume(current_thread->thrdstop_context_id, 1);
    struct thread* to_remove = current_thread;
    printf("thread id %d exec %d ticks\n", to_remove->ID, uptime() - to_remove->start_time);

    to_remove->is_exited = 1;

    if(to_remove->next != to_remove){
        //Still more thread to execute
        schedule() ;
        //Connect the remaining threads
        struct thread* to_remove_next = to_remove->next;
        to_remove_next->previous = to_remove->previous;
        to_remove->previous->next = to_remove_next;


        //free pointers
        free(to_remove->stack);
        free(to_remove);
        dispatch();
    }
    else{
        //No more thread to execute
        longjmp(env_st, -1);
    }
}
void thread_start_threading(int time_slot_size){
    __time_slot_size = time_slot_size;

    struct thread* tmp_thread = current_thread;
    while (tmp_thread != NULL)
    {
        tmp_thread->remain_execution_time *= time_slot_size;
        tmp_thread = tmp_thread->next;
        if( tmp_thread == current_thread )
            break;
    }

    int r;
    r = setjmp(env_st);

    if(current_thread != NULL && r==0){
        schedule() ;
        is_thread_start = 1;
        dispatch();
    }
}
