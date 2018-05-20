#include <iostream>
#include <fstream>
#include <cassert>
using namespace std;

int main(){
    ifstream fout("aplusb.out");
    ifstream fok("aplusb.ok");

    int points = 0;
    fok >> points;

    string s1, s2;
    while(fok >> s1){
        if(!bool(fout >> s2) || s1 != s2){
            cerr << "WA" << endl;
            cout << 0 << endl;
            return 0; } }

    cerr << "OK" << endl;
    cout << points << endl;
    return 0; }
