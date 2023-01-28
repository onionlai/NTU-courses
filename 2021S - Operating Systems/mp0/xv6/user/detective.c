#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"
#include "kernel/fs.h"

#define MAXSIZ 32

char target[32]; //target of file name
int p[2];  // pipe
int exist = 0; // Watson to check before telling Holmes

///////////////////////////////
////////// Function ///////////
///////////////////////////////

char* fmtname(char* path){
// Input: file full path
// Output: only the local path name (name after last '/')
    static char buf[DIRSIZ+1];
    char *p;
    for(p = path + strlen(path); p >=path && *p != '/'; p--);
    p++;

    memmove(buf, p, strlen(p));
    memset(buf + strlen(p), '\0', DIRSIZ - strlen(p));
    return buf;
}

void dir_traverse(const char* path){
    int fd;
    //struct stat st;

    if((fd = open(path, 0)) < 0){
        fprintf(2, "cannot open %s\n", path);
        return;
    }

    // if(fstat(fd, &st) < 0){
    //     fprintf(2, "cannot stat %s\n", path);
    //     close(fd);
    //     return;
    // }

    char buf[512], *p;
    struct dirent de;
    struct stat next_st;

    strcpy(buf, path);
    p = buf + strlen(buf);
    *p++ = '/'; //先另最後為'/' 再p++  所以p指向'/'的下一個

    // traverse all file in the dir
    while(read(fd, &de, sizeof(de)) == sizeof(de)){
        if(de.name[0] == '.' || de.inum == 0){
            continue;
        }
        memmove(p, de.name, DIRSIZ);
        p[DIRSIZ] = 0; // 完整path的結束最後一個字元的下一個為0
        if(stat(buf, &next_st) < 0){
            printf("cannot stat %s\n", buf);
        }
        //check if the dir name equal target.
        if(strcmp( fmtname(buf), target) == 0){
            printf("%d as Watson: %s\n", getpid(), buf);
            exist = 1;
        }
        //printf("%s\n", buf);
        if(next_st.type == T_DIR){
            //printf("<dir_traverse> next file: %s (from %s)\n",buf ,path);
            dir_traverse(buf);
        }
    }
    close(fd);

}
///////////////////////////////
//////////// Main /////////////
///////////////////////////////
int main(int argc, char* argv[]){
    strcpy(target, argv[1]);
    pipe(p);
    int pid = fork();
    if(pid == 0){ //child
        close(p[0]);
        dir_traverse(".");
        if(exist == 1){
            write(p[1], "y", 2);
        }
        else{
            write(p[1], "n", 2);
        }
        //sleep(3);
    }
    else{
        close(p[1]);
        char rst[2];
        read(p[0], rst, 2);
        wait(&pid);
        if(rst[0] == 'y'){
            printf("%d as Holmes: This is the evidence\n", getpid());
        }
        else if(rst[0] == 'n'){
            printf("%d as Holmes: This is the alibi\n", getpid());
        }
        else{
            printf("ERROR.");
        }
        wait(&pid);
    }
    exit(0);

}