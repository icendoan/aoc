#include<stdio.h>
#include<sys/types.h>
#include<sys/stat.h>
#include<unistd.h>
#include<sys/mman.h>
#include<limits.h>
int main() {
	struct stat s;
	printf("sizeof(struct stat) = %lu\n",sizeof(struct stat));
	printf("offsetof(struct stat.st_size) = %lu\n",((size_t)&s.st_size) - (size_t)&s);
	printf("PROT_READ | PROT_WRITE = %i\n",PROT_READ|PROT_WRITE);
	printf("MAP_ANONYMOUS | MAP_PRIVATE = %i\n",MAP_ANONYMOUS | MAP_PRIVATE);
	printf("INT_MAX/3 = %i\n",INT_MAX/3);
	return 0;
}
