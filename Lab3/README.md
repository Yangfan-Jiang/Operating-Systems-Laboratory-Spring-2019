实验三：交叉编译实现内核
开发环境：
win10下使用DOSBox，16位代码
Tcc + Tasm + Tlink
86汇编+C语言
软盘映像在Virtual Box下测试有效

相关代码和最终的软盘映像文件在文件夹Code&Files中
其中myos.img为最终的操作系统软盘映像文件
p#.asm为用户程序（与实验二代码一样，只是改了一些地址的参数）
kernal.asm ckernal.c为内核的汇编以及C代码
kliba.asm同样为内核代码，封装了一些常用的函数（在老师给的基础上修改、增加）给C调用