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
    char *p;
    for(p = path + strlen(path); p >=path && *p != '/'; p--);
    p++;

    return p;
}

void dir_traverse(const char* path){
    int fd;
    struct stat st;

    if((fd = open(path, 0)) < 0){
        fprintf(2, "cannot open %s\n", path);
        return;
    }

    if(fstat(fd, &st) < 0){
        fprintf(2, "cannot stat %s\n", path);
        close(fd);
        return;
    }

    if(st.type == T_FILE){ //impossible
        close(fd);
        return;
    }
    else if(st.type == T_DIR){
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
            // check if the dir name equal target.
            // if(strncmp( fmtname(buf), target, strlen(target)) == 0){
            //     fprintf(p[1], "<%d> as Watson: %s\n", getpid(), buf);
            //     exist = 1;
            // }
            printf("%s\n", buf);
            if(next_st.type == T_DIR){
                printf("<dir_traverse> next file: %s (from %s)\n",buf ,path);
                dir_traverse(buf);
            }
        }
        close(fd);
    }
}
///////////////////////////////
//////////// Main /////////////
///////////////////////////////
int main(int argc, char* argv[]){
    dir_traverse(".");
    exit(0);

}