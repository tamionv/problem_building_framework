#include <fstream>
using namespace std;

int main(){
    ifstream f("aplusb.in");
    ofstream g("aplusb.out");
    long long x, y;
    f >> x >> y;
    if((x+y)%10 == 0) g << -1 << endl;
    else g << x+y << endl;
    return 0; }
