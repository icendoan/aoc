#include<stdlib.h>
#include<stdio.h>
#define _(z) ({z;})
#define R return
#define P(x,y) if(x){return _(y);}
#define $(x,y) if(x){y;}
#define W(p,z...) while(p){z;}
typedef int I;typedef char C,*S;typedef void V;typedef const void *Z;
FILE*f;I l[1000]={},r[1000]={},m[1000]={};C c[128]={};S s;
I rd(){I i=0;W(*s==' ',s++);W((*s!='\n')&&(*s!=' '),i*=10,i+=(*s++-'0'));R i;}
I cmp(Z x,Z y){I a=*(I*)x,b=*(I*)y;R(a>b)-(a<b);}
I num(I x){I n=0,i=0;W(i++<1000,$(x==r[i],n++));R n;}
int main(){I n=0,p=0,q=0;
  P(!(f=fopen("./1.in","r")),1);W((s=fgets(c,127,f)),l[n]=rd(),r[n++]=rd());
  qsort(l,1000,4,cmp);qsort(r,1000,4,cmp);n=0;W(n<1000,p+=abs(l[n]-r[n]),q+=l[n]*num(l[n]),n++);
  printf("%i %i\n",p,q);
}
