#include <iostream>
#include <vector>
#include <fstream>
#include <string>

using namespace std;


struct input 
{
	int grammes;
	int stiles;
	vector<char> next;
};

input diavasma (string path)
{
	input i;
	ifstream input(path);
	input >> i.grammes >> i.stiles;
	char temp;
	while (input >> temp) i.next.push_back(temp);
	return i;
};

void diavasmaTEST ()
{
	input in = diavasma("input");
	cout << "input size is " << in.next.size() << endl;
	for (unsigned int i=0; i<in.next.size(); i++)
	{
		cout<<in.next[i]<<" ";
		if ((i+1) % in.stiles == 0) cout<<endl;
	} 
};

vector<int> findNext (input in)                      //L->-1 R->+1 U->-stiles D->+stiles
{                                                    //ekso-> eite an vgw out of range eite an allaksw grammi me R i L (diladi na allaksei to div)
	vector<int> ret;
	for (unsigned int i=0; i<in.next.size(); i++)
	{
		char temp = in.next[i];
		if (temp == 'L') ret.push_back(i - 1);
		else if (temp == 'R') ret.push_back(i + 1);
		else if (temp == 'U') ret.push_back(i - in.stiles);
		else if (temp == 'D') ret.push_back(i + in.stiles);

		if (ret[i] < 0) ret[i] = -1;
		else if (ret[i] >= (in.grammes * in.stiles)) ret[i] = -1;
		else if (((temp == 'R') or (temp == 'L')) and (((int)ret[i] / in.stiles) != (int)i / in.stiles)) ret[i] = -1;
	}
	return ret;
};

void findNextTEST ()
{
	input a;
	vector<char> v{'U', 'L', 'D', 'L', 'U', 'D', 'L', 'R', 'L'};
	a.next = v;
	a.grammes = 3;
	a.stiles = 3;
	vector<int> test = findNext(a);
	for (unsigned int i=0; i<test.size(); i++)
	{
		cout<<test[i]<<" ";
		if ((i+1) % a.stiles == 0) cout<<endl;
	} 
};

bool pathchecker (int place, bool* canfinish, bool* canNOTfinish, bool* visited, vector<int>* currentpath, vector<int>* epomenos)
{    //poliplokotita stiles*grammes giati den pernaei apo visited ksana akoma kai an tin ksanakalesw
	//cout<<"in place "<<place<<endl;
	visited[place] = true;
	currentpath->push_back(place);
	if (canfinish[(*epomenos)[place]])
	{
		//cout<<"epomenos teleionei"<<endl;
		return true;
	}
	if (canNOTfinish[(*epomenos)[place]]) 
	{
		//cout<<"epomenos den teleionei"<<endl;
		return false;
	}
	if (visited[(*epomenos)[place]])     //auto simainei oti vrika kyklo giati episkeftikame idi ton epomeno sto **current** monopati
	{                                //giati allios tha kserame eite oti borei na teleiosei eite oxi (meta apo kathe anadromi enimeronontai oi pinakes)
		//cout<<"kiklos"<<endl;
		return false;
	}                                  //genika proxorame mono an den kseroume ti kanei o epomenos kai den exoume kiklo
	return true and pathchecker((*epomenos)[place], canfinish, canNOTfinish, visited, currentpath, epomenos);     
};

int goodstarts (vector<int> next)
{
	int ret = 0;
	bool* visited = new bool[next.size()];
	bool* canfinish = new bool[next.size()];
	bool* canNOTfinish = new bool[next.size()];
	vector<int>* currentpath = new vector<int>;
	vector <int>* epomenos = &next;
	for (unsigned int i=0; i<next.size(); i++)    //arxikopoiiseis
	{
		canNOTfinish[i] = false;
		if (next[i] == -1) 
		{
			canfinish[i] = true;
			visited[i] = true;
		}
		else
		{
			canfinish[i] = false;
			visited[i] = false;
		}
	}
	for (unsigned int i=0; i<next.size(); i++)
	{
		if (visited[i]) continue;
		bool res = pathchecker(i, canfinish, canNOTfinish, visited, currentpath, epomenos);
		if (res)
		{
			for (unsigned int i = currentpath->size(); i>0; i--)
			{
				//cout<<"o "<<i<<" teleionei"<<endl;
				canfinish[(*currentpath)[i-1]]=true;                    //enimerosi canfinish
				currentpath->pop_back();                              //adeiasma currentpath
			}
		}
		else
		{			
			for (unsigned int i = currentpath->size(); i>0; i--)
			{
				//cout<<"o "<<i<<" den teleionei"<<endl;
				canNOTfinish[(*currentpath)[i-1]]=true;                    //enimerosi canNOTfinish
				currentpath->pop_back();                              //adeiasma currentpath
			}
		}
	}
	for (unsigned int i=0; i<next.size(); i++)
	{
		if (canNOTfinish[i]) ret++;
	}
	return ret;
};

int main (int argc, char** argv)
{
	input in = diavasma(argv[1]);
	vector<int> next = findNext(in);
	int canfinish = goodstarts(next);
	cout << canfinish << endl; 
	return 0;
}