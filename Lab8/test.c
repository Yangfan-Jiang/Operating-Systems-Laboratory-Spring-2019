#include "pcb.h"

void main() {
    int pid = 0;
    printf("father\n\r");
    pid = do_fork();
    if(pid > 0) {
        printf('0' + pid);
        printf("print from father\n\r");
        do_wait();
    }
    else if(pid == 0) {
        printf("print from son\n\r");
        do_exit();
    }
    else {
        printf("fork error\n\r");
    }
}