#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"
#include "kernel/fs.h"

char target[32];
int p[2];

void dir_traverse(char* path){
    write(p[1], "y", 1);
    return;
}

int main(int argc, char *argv[]){
    strcpy(target, argv[1]);
    printf("%s\n", target);
    pipe(p);
    int pid = fork();

    if(pid == 0){ //parent: Holmes
        close(p[1]);
        char rst[1] = {};
        read(p[0], rst, sizeof(rst));
        if(rst[0] == 'y'){
            printf("<%d> as Holmes: This is the evidence\n", getpid());
        }
        else if(rst[0] == 'n'){
            printf("<%d> as Holmes: This is the alibi\n", getpid());
        }
        wait(&pid);
    }
    else{ //child: Watson
        close(p[0]);
        dir_traverse(".");
    }
    printf("%s\n", target);
    exit(0);
}