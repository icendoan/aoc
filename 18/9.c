/* what a cop out */
#include <stdlib.h>
#include <stdio.h>
#define P(x,y,z) if(x){y}else{z}
#define R return
typedef unsigned long int J;typedef int I;typedef struct L0{struct L0*l;struct L0*r;J v;}*L;
L p(L x){printf("l: %p r: %p v: %li\n",x->l,x->r,x->v);R x;}
L mk(J y){L x=malloc(sizeof(struct L0));x->v=y;R x;}
L ad(L x,J y){L z=mk(y);z->l=x;z->r=x->r;x->r=z;z->r->l=z;R z;}
L rm(L x){L l=x->l;L r=x->r;r->l=l;l->r=r;free(x);R r;}
L mv(L x,I n){while(n!=0){P(n<0,{x=x->l;n++;},{x=x->r;n--;})}R x;}
L pr(L x){L y=x;do{p(y);y=y->r;}while(x!=y);R x;}
#define PLAYERS 10
#define LIMIT   25
J scores[PLAYERS]={0};
L a(L x,J y){x=mv(x,-7);scores[y%PLAYERS]+=y+x->v;R rm(x);}L b(L x,J y){R ad(mv(x,1),y);}
I main(){J i;J j;L x=mk(0);x->l=x;x->r=x;
for(i=1;i<LIMIT;i++)P((i!=0)&&(0==i%23),{x=a(x,i);},{x=b(x,i);});
for(i=0;i<PLAYERS;i++){printf("%li ",scores[i]);}printf("\n");
for(i=0,j=0;i<PLAYERS;i++)j=scores[i]>j?scores[i]:j;printf("%li\n",j);R 0;}
