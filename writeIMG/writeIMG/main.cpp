#include<stdio.h>
#include<stdlib.h>
#include<string.h>

#define BUF_SIZE 20
char buf[BUF_SIZE];
char fileName[BUF_SIZE];

void input();

char scrfpath[100] = "D:\\OS\\Exp#3\\myExp\\";
char destfname[100] = "D:\\OS\\Exp#3\\myExp\\";
FILE *scrFile;
FILE *destFile;

int main()
{
	input();
	getchar();
	getchar();
	return 0;
}

void input() {
	char filePath[150];

	printf("output file name:");
	scanf_s("%s", fileName, 20);
	strcpy_s(filePath, 100, destfname);
	strcat_s(filePath, fileName);
	fopen_s(&destFile, filePath, "wb");
	if (destFile == NULL) {
		printf("can't find file to write");
		getchar();
		getchar();
		exit(1);
	}

	printf("bin file name:");
	scanf_s("%s", fileName, 20);

	strcpy_s(filePath, 100, scrfpath);
	strcat_s(filePath, fileName);
	fopen_s(&scrFile, filePath, "rb");
	if (scrFile == NULL) {
		printf("can't find file!\n");
		getchar();
		getchar();
		exit(1);
	}

	// get file size
	fseek(scrFile, 0L, SEEK_END);
	long fileSize = ftell(scrFile);
	long toAdd = 1440 * 1024 - fileSize;
	//1440*1024
	fclose(scrFile);
	fopen_s(&scrFile, filePath, "rb");
	printf("%d\n", fileSize);
	//write file content
	int len = 0;
	while ((len = fread(buf, 1, BUF_SIZE, scrFile)) >= BUF_SIZE) {
		fwrite(buf, 1, BUF_SIZE, destFile);
	}
	fwrite(buf, 1, len, destFile);
	//printf("%d\n", len);

	bool a = 0;
	//a[0] = 0;
	while (toAdd > 0) {
		fwrite(&a, 1, 1, destFile);
		toAdd--;
	}


	fclose(scrFile);
	fclose(destFile);
}
