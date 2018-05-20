#include <fstream>
using namespace std;

int main(){
    ifstream points("aplusb.points");
    ifstream f("aplusb.in");
    ofstream g("aplusb.ok");

    long long p, x, y;
    f >> x >> y;
    points >> p;
    g << p << endl;
    g << x+y << endl;
    return 0; }
