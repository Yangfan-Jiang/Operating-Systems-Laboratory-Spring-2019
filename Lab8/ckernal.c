/*程序源代码（upper.c）*/

#include "pcb.h"

extern void restart();
extern void RunProm1();
extern void RunProm2();
extern void RunProm3();
extern void getChar();
extern void backspace();
extern void cls();
extern void runPro1ByInt();
extern void runPro2ByInt();
extern void runPro3ByInt();
extern void runPro4ByInt();
extern void syscallMsg();
extern void myreboot();
extern void setClock();

int num=0;
char chBuf;

int Segment = 0x2000;
int pinfo[5];

char CMDline[15]="aaaaaaaaaaaaaaa";
char shell1[15]="table";
char shell2[15]="run ";
char shell3[15]="reboot";

int i=0;
int j=0;
int jj=0;
int flag=0;
int pnum = 0;
int pid = 0;


int tab() {
    j=0;
    while(CMDline[j]!='a'){
        if(CMDline[j]==shell1[j]){
            j++;
        }
        else break;
    }
    if(CMDline[j]=='a'&&j>0){
        for(j=0;j<5;j++)
            CMDline[j]=shell1[j];
        return 1;
    }
    
    j=0;
    while(CMDline[j]!='a'){
        if(CMDline[j]==shell2[j]){
            j++;
        }
        else break;
    }
    if(CMDline[j]=='a'&&j>0){
        for(j=0;j<4;j++)
            CMDline[j]=shell2[j];
        return 2;
    }
    j=0;
    while(CMDline[j]!='a'){
        if(CMDline[j]==shell3[j]){
            j++;
        }
        else break;
    }
    if(CMDline[j]=='a'&&j>0){
        for(j=0;j<6;j++)
            CMDline[j]=shell3[j];
        return 3;
    }
    return 0;
}

void ReadCommand() {
    i=0;
    getChar();
    printChar(chBuf);
    CMDline[i++]=chBuf;
    while(chBuf!=13) {
        getChar();
        if(chBuf!=8 && chBuf!=9){
            printChar(chBuf);
            CMDline[i++]=chBuf;
        }
        else if(chBuf==8){
            backspace(' ');
            CMDline[i--]='a';
            chBuf='a';
        }
        else {
            printChar(' ');
            backspace(' ');
            flag = tab();
            if(flag==1) {
                for(i;i<5;i++)
                    printChar(shell1[i]);
            }
            else if(flag==2) {
                for(i;i<4;i++)
                    printChar(shell2[i]);
            }
            else if(flag==3){
                for(i;i<6;i++)
                    printChar(shell3[i]);
            }
        }
    }
    printf("\n\r");
    i=0;
}

void printProInfo(){
    cls();
    printf("\n\n\n");
    printf("           Program Information \n\r");
    printf(" ______________ ______________  _________\n\r");
    printf("| Program name | size (bytes) |  address |\n\r");
    printf("|--------------|--------------|----------|\n\r");
    printf("|    Pro1      |     509      |  0xA100H |\n\r");
    printf("|    Pro2      |     418      |  0xA200H |\n\r");
    printf("|    Pro3      |     509      |  0xA300H |\n\r");
    printf(" -------------  -------------- ---------- \n\r");
    printf("\nPress any key to continue...\n\r");
}


void printmsg(){
    cls();
    printf("                    Welcome to my OS...\n\n\r");
    printf("           ----------- Introduction ----------- \n\r");
    printf("       1.Enter 'run #' to run different programs\n\r");
    printf("       2.Enter 'table' to get information about the programs\n\r");
    printf("       3.Run multiple programs at once By press 'RUN #numbers'\n\r");
    printf("       4.Enter '-sys-' to get systemcall information\n\r");
    printf("       5.Enter 'reboot' to reboot the system\n\r");
    printf("       6.You can run programs in parallel program using '-p' command\n\r");
    printf("       7.You can also run 4 programs in parallel using 'run all' command\n\r");
    
}

void printSysCallMsg(){
    cls();
    printf("system call introduction:\n\r");
    printf("System call number is 21h\n\r");
    printf("System call parameters (by setting AL registers):\n\r");
    printf("0: print system call introduction\n\r");
    printf("1: reboot the system\n\r");
    printf("2: getChar function\n\r");
    printf("3: clear the screen\n\r");
    printf("4: print char\n\r");
    printf("5: back space\n\r");
}

void mypro1() {
    cls();
    RunProm1();
}

		
void mypro2() {
    cls();
    RunProm2();
}

void mypro3() {
    cls();
    RunProm3();
}

void myrestart() {
    cls();
    printf("Program has finished!\n\r");
    printf("Press any key to continue\n\r");
    restart();
}

void shu()           /*批处理 根据指令，执行一连串程序，遇到'a'字符后退出*/
{
    printf(">>");
	ReadCommand();
	num=4; 
    if(CMDline[0]=='r'&&CMDline[1]=='u'&&
        CMDline[2]=='n'&&CMDline[3]==' '){
        if(CMDline[4]=='a'&&CMDline[5]=='l'&&CMDline[6]=='l') {
            cls();
            init_Pro();
        }
        else if(CMDline[num]>='1'&&CMDline[num]<='4') {
            while(CMDline[num]>='1'&&CMDline[num]<='4') {
                if(CMDline[num]=='1'){
                    cls();
                    runPro1ByInt();
                }
                else if(CMDline[num]=='2'){
                    cls();
                    runPro2ByInt();
                }
                else if(CMDline[num]=='3'){
                    cls();
                    runPro3ByInt();
                }
                else if(CMDline[num]=='4'){
                    cls();
                    runPro4ByInt(); 
                }
                num++;
            }
            num=3;
        }
        else if(CMDline[4] == '-' && CMDline[5] == 'p') {       /* run -p 1234  */
            num = 7;
            pnum = 0;
            while(CMDline[num]>='1' && CMDline[num]<='4') {
                pinfo[pnum++] = CMDline[num] - '0';
                num++;
            }
            cls();
            runPar(pinfo, pnum);
            num = 3;
            pnum = 0;
        }
        else printf("Invalid Command!\n\r");
    }
    else if(CMDline[0]=='t'&&CMDline[1]=='a'&&CMDline[2]=='b'
            &&CMDline[3]=='l'&&CMDline[4]=='e'){
        printProInfo();        
    }
    else if(CMDline[0]=='-'&&CMDline[1]=='s'&&CMDline[2]=='y'
            &&CMDline[3]=='s'&&CMDline[4]=='-'){
        syscallMsg();
    }
    else if(CMDline[0]=='r'&&CMDline[1]=='e'&&CMDline[2]=='b'
            &&CMDline[3]=='o'&&CMDline[4]=='o'&&CMDline[5]=='t'){
        myreboot();
    }
    else if(CMDline[0]=='t'&&CMDline[1]=='e'&&CMDline[2]=='s'
            &&CMDline[3]=='t'){
        run_test();
    }
    else {
        printf("Invalid Command!\n\r");
    }
    getChar();
    for(jj=0;jj<28;jj++)
        CMDline[jj]='a';
    printf("Press any key to continue...\n\r");
	myrestart();
}


void cmain() {
    pcb_list[0].ID = 0;
    /*
    LoadAll(); 
    */
    setClock();
     while(1) {
       printmsg();
       shu();
    }
    
}
