#include <iostream>
#include <fstream>
#include <chrono>
using namespace std;

int main(){
    ifstream f("aplusb.cf");
    ofstream g("aplusb.in");
    bool fixed;
    int x, y;
    f >> fixed >> x >> y;

    if(fixed){
        g << x << ' ' << y << endl;
    }
    else{
        unsigned seed1 = std::chrono::system_clock::now().time_since_epoch().count();
        srand(seed1);
        g << rand() << ' ' << rand() << endl; }
    return 0; }
