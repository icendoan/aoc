#include <stdlib.h>
#include <stdio.h>
#include <stdint.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <sys/mman.h>
#include <fcntl.h>
#include <errno.h>
#include <string.h>

const uint64_t SIZE = ((uint64_t) 1) << 36;

struct instr {
  uint8_t type;
  union {
    struct {
      uint64_t zeroes;
      uint64_t ones;
    };
    struct {
      uint64_t addr;
      uint64_t data;
    };
  } data;
};

int parse(char *text, size_t len, struct instr* arr) {
  size_t start = 0, end = 0;
  struct instr i;
  while (start < len) {
    end = start;
    while (end < len && text[end] != '\n') {
      end++;
    }
    if (0 == strncmp(text + start, "mask = ", 7)) {
      i.type = 0;
      i.data.zeroes = i.data.ones = 0;
      start += 7;
      while (start < end) {
	i.data.zeroes |= text[start] == '0';
	i.data.ones   |= text[start] == '1';
	i.data.zeroes <<= 1;
	i.data.ones   <<= 1;
	start++;
      }
      i.data.ones>>=1;
      i.data.zeroes>>=1;
    } else {
      start += 4; // "mem["
      i.type = 1;
      i.data.addr = 0;
      i.data.data = 0;
      while (text[start] >= '0' && text[start] <= '9') {
	i.data.addr *= 10;
	i.data.addr += text[start] - '0';
	start++;
      }
      start += 4; // "] = "
      while (start<end) {
	i.data.data *= 10;
	i.data.data += text[start] - '0';
	start++;
      }
    }
    *arr++ = i;
    start++;
  }
  return 0;
}

uint64_t p1(size_t len, struct instr *instrs) {
  uint64_t total = 0, *data = mmap(NULL, SIZE<<3, PROT_READ | PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS|MAP_NORESERVE, 0, 0);
  uint64_t zero, one, value;
  uint8_t type;
  size_t i = 0;
  for (; i < len; i++) {
    type = instrs[i].type;
    if (type == 0) {
      zero = instrs[i].data.zeroes;
      one  = instrs[i].data.ones;
    } else {
      value = instrs[i].data.data;
      value |= one;
      value &= ~zero;
      data[instrs[i].data.addr] = value;
    }
  }

  for (i=0;i<SIZE;i++) {
    total += data[i];
  }

  munmap(data, SIZE<<3);
  return total;
}

size_t popcnt(uint64_t x) {
  size_t n = 0;
  while (x > 0) {
    n += x % 2;
    x >>= 2;
  }
  return n;
}

uint64_t p2(size_t len, struct instr *instrs) {
  uint64_t total = 0, *data = mmap(NULL, SIZE<<3, PROT_READ | PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS|MAP_NORESERVE, 0, 0);
  uint64_t mask, bitset;
  size_t i,j,k,n;
  for (i=0; i < len; i++) {
    if (instrs[i].type == 0) {
      bitset = ~(mask | ~instrs[i].data.zeroes);
      n=((36-popcnt(mask))<<1);
      for (j=0;j<n;j++) {
	mask = instrs[i].data.ones;
	for (k=0;k<36;k++) {
	  
	}
      }
    }
  }
  munmap(data, SIZE<<3);
  return total;
}

int main(void) {
  struct stat meta;
  struct instr *arr;
  size_t len = 0, i = 0;
  int fd;
  char *text;
  if (-1 == (fd = open("14.input", 0))) {
    printf("Could not open file");
    return errno;
  }

  if (-1 == fstat(fd, &meta)) {
    printf("Could not stat file");
    return errno;
  }

  text = mmap(NULL, meta.st_size, PROT_READ, MAP_SHARED, fd, 0);
  for (i = 0; i < (size_t) meta.st_size; i++) {
    len += text[i] == '\n';
  }
  arr = malloc(sizeof(struct instr) * len);
  if (parse(text, meta.st_size, arr)) {
    printf("Could not parse input");
    return -1;
  }

  printf("%lui\n", p1(len, arr));
}

