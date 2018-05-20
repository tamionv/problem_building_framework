#include <fstream>
using namespace std;

int main(){
    ifstream f("aplusb.in");
    ofstream g("aplusb.out");
    long long x, y;
    f >> x >> y;
    g << x+y << endl;
    return 0; }
