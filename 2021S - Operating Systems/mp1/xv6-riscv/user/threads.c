#include "kernel/types.h"
#include "user/setjmp.h"
#include "user/threads.h"
#include "user/user.h"
#define NULL 0


static struct thread* current_thread = NULL;
static int id = 1;
static jmp_buf env_st;
//static jmp_buf env_tmp;

struct thread *thread_create(void (*f)(void *), void *arg){
    struct thread *t = (struct thread*) malloc(sizeof(struct thread));
    //unsigned long stack_p = 0;
    unsigned long new_stack_p;
    unsigned long new_stack;
    new_stack = (unsigned long) malloc(sizeof(unsigned long)*0x100);
    new_stack_p = new_stack +0x100*8-0x2*8;
    t->fp = f;
    t->arg = arg;
    t->ID  = id;
    t->buf_set = 0;
    t->stack = (void*) new_stack;
    t->stack_p = (void*) new_stack_p;
    id++;
    return t;
}
void thread_add_runqueue(struct thread *t){
    if(current_thread == NULL){
        current_thread = t;
        current_thread->previous = t;
        current_thread->next = t;
    }
    else{
        current_thread->previous->next = t;
        t->previous = current_thread->previous;
        t->next = current_thread;
        current_thread->previous = t;
    }
}
void thread_yield(void){
    // TODO. suspend the current thread by saving env(jump_buf)
    if(setjmp(current_thread->env) == 0){ //從function裡叫thread_yield
        schedule();
        dispatch();
    }
    else{ //從別的thread的long jump過來
        // printf("Jump to Thread%d ", current_thread->ID);
        return;
    }
}
void dispatch(void){
    // TODO. execute the new thread
    if(current_thread->buf_set == 0){ //not yet initialized
        current_thread->buf_set = 1;
        if(setjmp(current_thread->env) == 0){
            //因為叫完setjmp他會把env->sp指定為現在程式執行的位子，但我們希望之後stack不要在現在執行的位子，而是一個我們指定的stack pointer的位子。所以先故意setjmp進去，把sp換掉，再longjmp進function，longjump完之後，stack pointer就會是sp了。
            //如果不這樣做的話，進去function裡面的stack pointer和stack就不會被放在thread structure，然後就會隨著各種long jump被覆蓋寫掉....（因為只有當初malloc的那些位子才是確保不會不見ㄉ！
            current_thread->env->sp = (unsigned long)current_thread->stack_p;
            longjmp(current_thread->env, 1);
        }
        else{
            current_thread->fp(current_thread->arg);
            thread_exit();
        }
    }
    else{
        longjmp(current_thread->env, 1);
    }
}
void schedule(void){
    current_thread = current_thread->next;
}
void thread_exit(void){
    if(current_thread->next != current_thread){
        // TODO
        current_thread->previous->next = current_thread->next;
        current_thread->next->previous = current_thread->previous;
        struct thread *next = current_thread->next;
        // free the thread
        free(current_thread->stack);
        free(current_thread);
        current_thread = next;
        // schedule();
        dispatch();
    }
    else{
        // TODO
        // Hint: No more thread to execute
        longjmp(env_st, 1);
        return;
    }
}
void thread_start_threading(void){
    // TODO
    if(setjmp(env_st) == 0){ // main thread
        schedule();
        dispatch();
    }
    else{
        return;
    }
}
