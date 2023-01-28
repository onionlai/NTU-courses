#include"ypglpk.hpp"
#include<iostream>
int main(){
  // maximize x+2y-2.5z subject to 3x+2y+z<=9.9, -x+z<=8.24, 1.5y-z<=4.3, and x-1.3y-z<=5.3
  ypglpk::set_output(true); int n=3,m=4;
  std::vector<std::vector<double>> A(m,std::vector<double>(n));
  std::vector<double> b(m),c(n);
  c[0]=1; c[1]=2; c[2]=-2.5;
  A[0][0]=3; A[0][1]=2; A[0][2]=1; b[0]=9.9;
  A[1][0]=-1; A[1][2]=1; b[1]=8.24;
  A[2][1]=1.5; A[2][2]=-1; b[2]=4.3;
  A[3][0]=1; A[3][1]=-1.3; A[3][2]=-1; b[3]=5.3;
  std::pair<double,std::vector<double>> res=ypglpk::linear_programming(A,b,c);
  std::cout<<"\033[1;36mLP: max="<<res.first<<" with x="<<res.second[0]<<" y="<<res.second[1]<<" z="<<res.second[2]<<"\033[0m\n";
  std::vector<bool> isint(n);
  isint[0]=0; isint[1]=1; isint[2]=1; // y,z should be integers
  res=ypglpk::mixed_integer_linear_programming(A,b,c,isint);
  std::cout<<"\033[1;36mMILP: max="<<res.first<<" with x="<<res.second[0]<<" y="<<res.second[1]<<" z="<<res.second[2]<<"\033[0m\n";
}
