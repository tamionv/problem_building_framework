#include <fstream>
using namespace std;

int main(){
    ifstream f("aorib.in");
    ofstream g("aorib.out");
    long long x, y;
    f >> x >> y;
    g << x*y << endl;
    return 0; }
