extern int fork();
extern void wait();
extern void exit();
extern void printChar();
extern void cls();
extern int getsem();
extern int freesem();
extern void p();
extern void v();

char words[100];
int fruit_disk = 0;
int s;
int f;

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


void putwords(char *p) {
    int i = 0;
    while(*p != '\0') {
        words[i++] = *p++;
    }
}

void putfruit() {
    fruit_disk %= 5;
    fruit_disk += 1;
}

void main() 
{
   int pid;
   /* s:words, f: fruit */
   s = getsem(0);
   f = getsem(0);
   printf("\n\rUser program: forking...\n\r");
   pid = fork();
   /* father */
   if(pid) {
       while(1) {
           p(s);
           p(s);
           printf("words:");
           printf(words);
           printf("\n\r");
           printf("the fruit is :");
           printint(fruit_disk);
           printf("\n\r");
       }
   }
   /* first child */
   else {
       printf("first child:\n\r");
       pid = fork();
       /* first child */
       if(pid) {
           while(1) {
               printf("put words\n\r");
               putwords("Father will live one year after another forever!");
               v(s);
               delay();
           }
       }
       /* second child */
       else {
           while(1) {
               printf("put fruit\n\r");
               putfruit();
               v(s);
               delay();
           }
       }
   }
}