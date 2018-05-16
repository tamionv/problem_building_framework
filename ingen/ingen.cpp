#include <iostream>
#include <fstream>
using namespace std;

int main(){
    ifstream f("aplusb.cf");
    if(!f){
        srand(time(nullptr));
        cout << rand() << ' ' << rand() << endl; }
    else {
        int x;
        f >> x;
        cout <<  x << ' ' << x << endl; }
    return 0; }
