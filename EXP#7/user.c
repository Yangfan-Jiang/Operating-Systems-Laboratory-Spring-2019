extern int fork();
extern void wait();
extern void exit();
extern void printChar();
extern void cls();

char str[80]="129djwqhdsajd128dw9i39ie93i8494urjoiew98kdkd";
int count = 0;
int i = 0;

void printf(char *str) {
    while(*str!='\0') {
        printChar(*str);
        str++;
    }
}

void printint(int n) {
    int i = 0;
    int tmp = 0;
    int len = 0;
    char ans[100];
    char out[100];
    if (n == 0) {
        printf("0");
        return;
    }
    
    while(n) {
        tmp = n % 10;
        n /= 10;
        ans[len++] = '0' + tmp;
    }
    for(i=0 ;i<len; i++) {
        out[i] = ans[len -1 - i];
    }
    out[i] = '\0';
    printf(out);
}

void main() 
{
    int pid = 0;
   
    cls();
    
    pid = fork();
    if(pid > 0) {
        printf("print from father:\n\r");
        wait();
        printf("father: AFTER WAITING \n\r");
        printf("The letter number is: \n\r");
        printint(count);
        printf("\n\r");
        exit();
    }
    else if(pid == 0) {
        printf("\n\r");
        printf("print from son:\n\r");
        i = 0;
        while(str[i]!='\0') {
            if('a'<=str[i] && str[i]<='z')
                count++;
            i++;
        }
        exit();
    }
    else {
        printf("fork error\n\r");
    }
}