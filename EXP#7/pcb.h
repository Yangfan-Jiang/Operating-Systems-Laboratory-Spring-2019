extern void printChar();
extern void stackcopy();
extern void load_pro();
extern void LoadAll();
extern void getChar();
extern void PCBrestart();

char tch;
int NEW = 3;
int READY = 1;
int RUNNING = 2;
int EXIT = 0;
int WAIT = 4;
int segement_list[7] = {0x2000, 0x3000, 0x4000, 0x5000, 0x6000, 0x7000, 0x8000};
int segement_used[7] = {0, 0, 0, 0, 0, 0, 0};
int Offset = 0xa100;
int baseseg = 0x2000;
int curr_seg;
int index = 0;
int hflag = 0;
int new_ss = 0;
int f_ss = 0;


/* 非全局函数，仅被C语言调用 */
void printf(char *str) {
    while(*str!='\0'){
        printChar(*str);
        str++;
    }
}

typedef struct RegisterImage{
	int SS;
	int GS;
	int FS;
	int ES;
	int DS;
	int DI;
	int SI;
	int BP;
	int SP;
	int BX;
	int DX;
	int CX;
	int AX;
	int IP;
	int CS;
	int FLAGS;
}RegisterImage;

typedef struct PCB{
	RegisterImage regImg;
	int Process_Status;
    int ID;
    int FID;
    int SEG;
}PCB;


PCB pcb_list[8];
int CurrentPCBno = 0; 
int Program_Num = 0;


extern void printChar();
extern void printf();

PCB* Current_Process();
void Save_Process(int,int, int, int, int, int, int, int,
		  int,int,int,int, int,int, int,int );
void init(PCB*, int, int);
void Schedule();
void special();


void Save_Process(int gs,int fs,int es,int ds,int di,int si,int bp,
		int sp,int dx,int cx,int bx,int ax,int ss,int ip,int cs,int flags)
{
	pcb_list[CurrentPCBno].regImg.AX = ax;
	pcb_list[CurrentPCBno].regImg.BX = bx;
	pcb_list[CurrentPCBno].regImg.CX = cx;
	pcb_list[CurrentPCBno].regImg.DX = dx;

	pcb_list[CurrentPCBno].regImg.DS = ds;
	pcb_list[CurrentPCBno].regImg.ES = es;
	pcb_list[CurrentPCBno].regImg.FS = fs;
	pcb_list[CurrentPCBno].regImg.GS = gs;
	pcb_list[CurrentPCBno].regImg.SS = ss;

	pcb_list[CurrentPCBno].regImg.IP = ip;
	pcb_list[CurrentPCBno].regImg.CS = cs;
	pcb_list[CurrentPCBno].regImg.FLAGS = flags;
	
	pcb_list[CurrentPCBno].regImg.DI = di;
	pcb_list[CurrentPCBno].regImg.SI = si;
	pcb_list[CurrentPCBno].regImg.SP = sp;
	pcb_list[CurrentPCBno].regImg.BP = bp;
}

void Schedule(){
	pcb_list[CurrentPCBno].Process_Status = READY;
    
    hflag = 0;
    for (index = 1; index <= Program_Num+1 ; index++) {
        
        if (((CurrentPCBno + index) % (Program_Num+1)) == 0) continue;
        
        if (pcb_list[(CurrentPCBno + index) % (Program_Num+1)].Process_Status == NEW
            || pcb_list[(CurrentPCBno + index) % (Program_Num+1)].Process_Status == READY) {
            hflag = 1;
            CurrentPCBno = (CurrentPCBno + index) % (Program_Num+1);
            break;
        }
    }
    if (hflag == 0) {
        CurrentPCBno = 0;
        return;
    }
    
	if( pcb_list[CurrentPCBno].Process_Status != NEW )
		pcb_list[CurrentPCBno].Process_Status = RUNNING;
    
	return;
}

PCB* Current_Process() {
	return &pcb_list[CurrentPCBno];
}

/* segement 应该是es 段地址 （似乎没啥用，随便搞一个就行）,不同的程序最好区分开，
然后可以用统一的内存偏移地址 */
void init(PCB* pcb,int segement, int offset)
{
	pcb->regImg.GS = 0xb800;
	pcb->regImg.SS = segement;
	pcb->regImg.ES = segement;
	pcb->regImg.DS = segement;
	pcb->regImg.CS = segement;
	pcb->regImg.FS = segement;
	pcb->regImg.IP = offset;
	pcb->regImg.SP = offset - 4;
	pcb->regImg.AX = 0;
	pcb->regImg.BX = 0;
	pcb->regImg.CX = 0;
	pcb->regImg.DX = 0;
	pcb->regImg.DI = 0;
	pcb->regImg.SI = 0;
	pcb->regImg.BP = 0;
	pcb->regImg.FLAGS = 512;
	pcb->Process_Status = NEW;
}

void special()
{
	if(pcb_list[CurrentPCBno].Process_Status==NEW)
		pcb_list[CurrentPCBno].Process_Status=RUNNING;
    else if(pcb_list[CurrentPCBno].Process_Status == READY)
        pcb_list[CurrentPCBno].Process_Status=RUNNING;
}


void init_Pro()
{
	init(&pcb_list[0],64*1024/16,0x100);    /* 0号进程是内核程序 */
	init(&pcb_list[1],0x2000,0xa100);
	init(&pcb_list[2],0x3000,0xa100);
	init(&pcb_list[3],0x4000,0xa100);
	init(&pcb_list[4],0x5000,0xa100);
    Program_Num = 4;
}

void runPar(int *a, int n)
{
    for (index = 0; index < n; index++)
    {
        init(&pcb_list[index + 1],segement_list[a[index] - 1],Offset);
    }
    Program_Num = n;
}

int select_seg() {
    for (index = 0; index < 7; index++) {
        if(segement_used[index] == 0) {
            segement_used[index] = 1;
            return index;
        }
    }
    return -1;
}

int do_fork() {
    PCB* curr_pro = Current_Process();
    PCB* new_PCB;
    int pcb_num;
    
    curr_pro->Process_Status = READY;
    
    if (Program_Num == 7) {
        printf("Program_Num == 7\n\r");
        curr_pro->regImg.AX = -1;
        return -1;
    }
    hflag = 0;
    /* find a free PCB */
    for(index = 1; index <=7; index++) {
        if(pcb_list[index].Process_Status == EXIT) {
            new_PCB = &pcb_list[index];
            hflag = 1;
            break;
        }
    }
    
    pcb_num = index;
    /* 没有空闲的进程块 */
    if (!hflag) {
        printf("No free PCB\n\r");
        curr_pro->regImg.AX = -1;
        return -1;
    }
    
    new_PCB->ID = index;
    
    new_PCB->Process_Status = READY;
    new_PCB->FID = curr_pro->ID;
    
    curr_pro->regImg.AX = pcb_num;
    
    new_PCB->SEG = select_seg();
    
    if(new_PCB->SEG == -1) {
        printf("No free segment\n\r");
        curr_pro->regImg.AX = -1;
        return -1;
    }
    
    curr_seg = segement_list[new_PCB->SEG];
    
    {
    new_PCB->regImg.GS = 0xb800;
    new_PCB->regImg.SS = curr_seg;
	new_PCB->regImg.ES = curr_pro->regImg.ES;
	new_PCB->regImg.DS = curr_pro->regImg.DS;
	new_PCB->regImg.CS = curr_pro->regImg.CS;
	new_PCB->regImg.FS = curr_pro->regImg.FS;
	new_PCB->regImg.IP = curr_pro->regImg.IP;
    new_PCB->regImg.SP = curr_pro->regImg.SP;
	new_PCB->regImg.AX = 0;
	new_PCB->regImg.BX = curr_pro->regImg.BX;
	new_PCB->regImg.CX = curr_pro->regImg.CX;
	new_PCB->regImg.DX = curr_pro->regImg.DX;
	new_PCB->regImg.DI = curr_pro->regImg.DI;
	new_PCB->regImg.SI = curr_pro->regImg.SI;
	new_PCB->regImg.BP = curr_pro->regImg.BP;
	new_PCB->regImg.FLAGS = curr_pro->regImg.FLAGS;
    }
    new_ss = new_PCB->regImg.SS;
    f_ss = curr_pro->regImg.SS;
    /* copy stack */
    stackcopy();

    Program_Num++;
    
    /* 直接改变寄存器继续fork后的代码，
    相当于PCB执行后，不执行这之后的语句了，
    父进程AX已经改变，所以相当于已经返回了 */
    PCBrestart();
}

void blocked() {
    PCB* curr_pro = Current_Process();
    curr_pro->Process_Status = WAIT;
    Schedule();
    PCBrestart();
}

void do_wait() {
    printf("wating...\n\r");
    blocked();
}

void wakeup() {
    PCB* curr_pro = Current_Process();
    curr_pro->Process_Status = READY;
    Schedule();
    PCBrestart();
}

void do_exit() {
    PCB* curr_pro = Current_Process();
    printf("exiting...\n\r");
    curr_pro->Process_Status = EXIT;
    segement_used[curr_pro->SEG] = 0;
    
    CurrentPCBno = curr_pro->FID;
    Program_Num--;
    wakeup();
}

void run_test() {
    int pcb_num = 0;
    /* find a free PCB */
    for(index = 1; index <=7; index++) {
        if(pcb_list[index].Process_Status == EXIT) {
            hflag = 1;
            break;
        }
    }
    
    pcb_num = index;
    printf("index\n\r");
    printChar('0' + index);
    
    /* 没有空闲的进程块 */
    if (!hflag) {
        printf("run test<> No free PCB\n\r");
        return;
    }
    
    curr_seg = select_seg();
    printf("\n\rseg\n\r");
    printChar('0' + curr_seg);
    if(curr_seg == -1) {
        printf("run test<> No free segment\n\r");
        return;
    }
    
    curr_seg = segement_list[curr_seg];
    load_pro();
    
    init(&pcb_list[pcb_num], curr_seg, 0x100);
    pcb_list[pcb_num].ID = pcb_num;
    
    Program_Num++;
}