#include <fstream>
using namespace std;

int main(){
    ifstream points("aorib.points");
    ifstream f("aorib.in");
    ofstream g("aorib.ok");

    long long p, x, y;
    f >> x >> y;
    points >> p;
    g << p << endl;
    g << x*y << endl;
    return 0; }
