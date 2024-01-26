if(!settings.multipleView) settings.batchView=false;
settings.tex="pdflatex";
defaultfilename="main-1";
if(settings.render < 0) settings.render=4;
settings.outformat="";
settings.inlineimage=true;
settings.embed=true;
settings.toolbar=false;
viewportmargin=(2,2);

settings.render = 0;
import three;
import geometry3;
size(15cm);
triple A=(6,0,0),B=(6,6,0),C=(0,6,0),S=(4,4,6);
draw(A--B^^B--C);
draw(A--C, longdashed);
draw(S--A);
draw(S--B);
draw(S--C);
label("$A$", A, 2W);
label("$B$", B, 2SE);
label("$C$", C, 2E);
label("$S$", S, N);
triple P = relpoint(S--C, 2/3);
dot(P);
label("$P$", P, 2E);
triangle3 t = triangle3(S,A,B);
triple A1 = heightpoint(t, A), B1 = heightpoint(t, B);
markrightangle(A,A1,B,size=3);
markrightangle(S,B1,B,size=3);
draw(height(t, A)); dot(A1);
draw(height(t, B)); dot(B1);
triple H = orthocenter(t);
label("$H$", H, S); dot(H);
circle3 c = circumcircle(t);
draw(c.getPath(), grey);
draw(H--P, dashed);
triple M = midpoint(A--B);
triple H_ = scale3(-1, M)*H;
dot(H_, black+7bp);
label("$H'$", H_, 2SW);
triangle3 t2 = triangle3(H_, C, S);

triple H__ = projection(plane(A,B,C), H_);
label("$H''$", H__, 2W);
dot(H__, black+7bp);

triple I = intersectionpoint(C--H__, A--B);
draw(H__--I, black+2bp);
draw(I--C, black+2bp+dashed);
draw(H_ -- H__);
dot(I, black+5bp);
label("$I$", I, 2N);
markrightangle(H_, H__, C, size=5);
surface s1 = surface(S--I--C--cycle);
draw(S--I, black+2bp);
draw(S--C, black+2bp);
draw(s1, red+opacity(0.2));

triple S_ = rotate(20, I, C)*S;
dot("$S'$", S_, black+5bp);

triple T = heightpoint(triangle3(I,S,C), S);
draw(arc(T, S, S_), dashed, Arrow3(HookHead2, 15));

