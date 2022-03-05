#include <iostream>
#include <fstream>
#include <string>
#include <vector>

using namespace std;

struct myinput
{
	int nosokomeia;
	vector<int> icu;
};

struct couple
{
	long int sum;
	int index;
};


bool greaterCouple (couple a, couple b)
{
	if (a.sum > b.sum) return true;
	if (a.sum < b.sum) return false;
	return a.index > b.index;
};

void printCouple (couple c)
{
	cout<<"("<<c.sum<<", "<<c.index<<") ";
}

void printCoupleVector(vector<couple> a)
{
    for (unsigned int i = 0; i < a.size(); i++) 
      {
  		printCouple(a[i]);
  		cout<<"  ";
  	}
    cout<<endl<<endl;
}

myinput diavasma (string path)
{
	myinput ret;
	ifstream eisodos(path);
	int M;
	eisodos >> M >> ret.nosokomeia;
	int temp;
	while (eisodos >> temp) ret.icu.push_back(temp);
	eisodos.close();
	return ret;
};

vector<int> opposite (vector<int> v, int mo)
{
	vector<int> op;
	for (unsigned int i=0; i<v.size(); i++) op.push_back(v[i]*(-1)-mo);
	return op;
};

vector<long int> preffixSums (vector<int> v)
{
	vector<long int> psums;
	for (unsigned int i=0; i<v.size(); i++) 
	{
		if (i == 0) psums.push_back(v[i]);
		else psums.push_back(psums[i-1] + v[i]);
	}
	return psums;
};

vector<couple> psumsWithIndex (vector<long int> psums)
{
	vector<couple> ret;
	couple temp;
	for (unsigned int i=0; i<psums.size(); i++)
	{
		temp.sum = psums[i];
		temp.index = i;
		ret.push_back(temp);
	} 
	return ret;
}



/* Auti i sinartisi sortarei ta zeugaria preffixsum-index prwta me vasi to sum kai meta to index
apo to mikrotero sto megalytero.
Ton arxiko kwdika tis mergesort ton pirame apo https://www.geeksforgeeks.org/merge-sort/
an kai ton exoume allaksei arketa gia auto pou theloume na kanoume*/
void merge(vector<couple>* arr, int l, int m, int r)
{
    int n1 = m - l + 1;
    int n2 = r - m;
 
    // Create temp arrays
    vector<couple>* L= new vector<couple>;
    vector<couple>* R= new vector<couple>;
 
    // Copy data to temp arrays L[] and R[]
    for (int i = 0; i < n1; i++) L->push_back((*arr)[l + i]);
    for (int j = 0; j < n2; j++) R->push_back((*arr)[m + 1 + j]);

 
    // Merge the temp arrays back into arr[l..r]
 
    // Initial index of first subarray
    int i = 0;
 
    // Initial index of second subarray
    int j = 0;
 
    // Initial index of merged subarray
    int k = l;
 
    while (i < n1 && j < n2) {

        if (greaterCouple((*R)[j], (*L)[i])) 
        {
            (*arr)[k] = (*L)[i];
            i++;
        }
        else 
        {
            (*arr)[k] = (*R)[j];
            j++;
        }
        k++;
    }
 
    // Copy the remaining elements of
    // L[], if there are any
    while (i < n1) {
        (*arr)[k] = (*L)[i];
        i++;
        k++;
    }
 
    // Copy the remaining elements of
    // R[], if there are any
    while (j < n2) {
        (*arr)[k] = (*R)[j];
        j++;
        k++;
    }
    delete L;
    delete R;
}
 

void mergeSort(vector<couple>* arr,int l,int r){
    if(l>=r){
        return;
    }
    int m =l+ (r-l)/2;
    mergeSort(arr,l,m);
    mergeSort(arr,m+1,r);
    merge(arr,l,m,r);
}



/*Auti i sinartisi epistrefei vector pou gia kathe subarray tou sortarismenou 
pinaka sums-index, me arxi i kai telos to telos tou pinaka, deixnei to megisto index
diladi vector[i] = megalyteros index ston subarray [i..end] tou sortarismenou sums-index*/
vector<int> largestSubbarayIndex (vector<couple> sorted)
{
	vector<int> ret;
	int max=0;
	int temp[sorted.size()];
	for (unsigned int i=sorted.size(); i>0; i--)
	{
		if (i == sorted.size()) 
		{
			max = sorted[i-1].index;
			temp[i-1] = max;
		}
		else 
		{
			if (sorted[i-1].index > max) max = sorted[i-1].index;
			temp[i-1] = max;
		}
	}
	for (unsigned int i=0; i<sorted.size(); i++) ret.push_back(temp[i]);
	return ret;
}




/*Kanei return tin thesi autou pou psaxnw i allios tin thesi tou amesos megalyterou. 
An auto pou psaxnw einai megalytero apo to megisto toy pinaka epistrefei -1.
SOS: tha tin kaloume gia to sum pou theloume - 0.5 wste an epanalamvanetai na mas vgalei tin prwti tou emfanisi.
Ton arxiko kwdika tis binarySearch ton pirame apo https://www.geeksforgeeks.org/binary-search/ 
an kai ton exoume allaksei arketa gia auto pou theloume na kanoume*/
int binarySearch(vector<couple>* arr, int l, int r, long double x, int max) 
{   
      if (x > max) return -1;                                      
      if (r > l) {
          int mid = l + (r - l) / 2;
  
          if ((*arr)[mid].sum == x)
              return mid;
        
        
          if ((*arr)[mid].sum > x)
              return binarySearch(arr, l, mid - 1, x, max);
  
        
          return binarySearch(arr, mid + 1, r, x, max);
       }
      else if(r==l) //ara kai mid=r=l
      {
          	if ((*arr)[r].sum >= x) return r;
          	else return r+1; 
      }
      else if(r!=0 && l!=0)
      {
      	return l;
      }   
      return 0;   //an diladi x mikrotero apo to min tou pinaka
} 

int main (int argc, char** argv)
{
	myinput input = diavasma(argv[1]);

	vector<int> op = opposite(input.icu, input.nosokomeia);

	vector<long int> psums = preffixSums(op);

	vector<couple> sums_index = psumsWithIndex(psums);

      vector<couple>* ptr = &sums_index;
      int size = (*ptr).size();
      mergeSort(ptr, 0, size - 1);

      vector<int> localindex = largestSubbarayIndex(sums_index);

      int maxlength = 0;
      long double minimumNeededSum;
      int indexfound, maximumsuitableindex;
      int temp;

      //vriskw max subarray me arxi kathe stoixeio
      //kai epistrefw to megalytero

      for (unsigned int i=0; i<sums_index.size(); i++) 
      {
      	temp = (int) i;
      	if (i == 0) minimumNeededSum = 0 - 0.5;
      	else minimumNeededSum = 0 + psums[i-1] - 0.5;
      	indexfound = binarySearch(ptr, 0, size-1, minimumNeededSum, (*ptr)[size-1].sum);
      	if (indexfound == -1) continue;  //ara den yparxei subarray me arxi to i
      	maximumsuitableindex = localindex[indexfound];
      	if (maximumsuitableindex - temp + 1 > maxlength) maxlength = maximumsuitableindex - temp + 1;
      }
      cout<<maxlength<<endl;
}