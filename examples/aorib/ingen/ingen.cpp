#include <iostream>
#include <fstream>
using namespace std;

int main(){
    ifstream f("aorib.cf");
    ofstream g("aorib.in");
    bool fixed;
    int x, y;
    f >> fixed >> x >> y;

    if(fixed) g << x << ' ' << y << endl;
    else{
        srand(time(nullptr));
        g << rand() << ' ' << rand() << endl; }
    return 0; }
