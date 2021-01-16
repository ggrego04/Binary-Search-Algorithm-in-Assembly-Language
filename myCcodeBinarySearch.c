#include <stdio.h>
#include <stdlib.h>
int BinarySearch(int value, int first,int last,int data[]){

    int mid=(first+last)/2;
  
    if(value == data[mid]){
       return(mid);
    }else if (first>last){
       return -1;
    }else{
       if (value<data[mid])
          return BinarySearch(value,first,mid-1,data);
       else if (value>data[mid])
          return BinarySearch(value,mid+1,last,data);

    	}
}
 
int main(){
  int data[1000000];
  FILE *fp=NULL;
  fp = fopen("numbers_1mil.txt", "r");
  int i=0; int value=1; int position;
  while(1){
    if(feof(fp))
    	break;
    fscanf(fp,"%d",&data[i]);
    i++;
  }

  printf("Give me the number you want to find: ");
  scanf("%d",&value);
  position=BinarySearch(value,0,1000000,data);
  (position == -1)? printf("The number is not found in the table!\n"): printf("The number is found in place %d of the table!\n",position );
  return 0;

}

