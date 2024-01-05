// settings.render = 0;
import three;

// Returns a triangle path by 3 points
path3 triangle(triple A, triple B, triple C) {
    return A--B--C--cycle;
}

// Returns a centroid of given triangle ABC
triple centroid(triple A, triple B, triple C) {
    return (A+B+C)/3;
}

// Returns a path of height from P to AB in triangle ABC
path3 height(triple P, triple A, triple B) {
    return P -- (A + dot(P - A, B - A) / dot(B - A, B - A) * (B - A));
}

// Returns point on AB in specified ratio t
triple ratioPoint(triple A, triple B, real t = 1.0) {
    return (1-t)*A + t*B;
}

// Returns length of segment AB
real distance(triple A, triple B) {
    return abs(A-B);
}

// Returns a bisector path
path3 bisector(triple P, triple A, triple B) {
	return P -- (ratioPoint(A,B,distance(P,A)/(distance(P,A)+distance(P,B))));
}

// Returns incenter of given triangle ABC
triple incenter(triple A, triple B, triple C) {
	return intersectionpoint(bisector(A,B,C), bisector(B,A,C));
}

// Returns midpoint of AB
triple midpoint(triple A, triple B) {
	return (A+B)/2;
}

// Grows a perpendicular line in specified plain ABC from dot in ratio of AB.
path3 perpendicular(triple A, triple B, triple C, real len = 1, real ratio=1/2) {
    triple AB = B-A;
    triple D = A + ratio*AB;
    triple normalVector = cross(A-B, C-B);
    triple perpendicularVector = cross(AB, normalVector);
	triple E_ = D + len*unit(perpendicularVector);
    return D--E_;
}

// Returns keypoints of perpendicular (see perpendicicular function)
triple[] perpendicularPoints(triple A, triple B, triple C, real len = 1, real ratio=1/2) {
    triple AB = B-A;
    triple D = A + ratio*AB;
    triple normalVector = cross(A-B, C-B);
    triple perpendicularVector = cross(AB, normalVector);
	triple E_ = D + len*unit(perpendicularVector);
    triple[] L = {D, E_};
    return L;
}

// Returns point H from height AH
triple projection(triple P, triple A, triple B) {
	return A + dot(P - A, B - A) / dot(B - A, B - A) * (B - A);
}

// Returns incircle path3
path3 incircle(triple A, triple B, triple C) {
	triple O_ = incenter(A,B,C);
	return circle(O_, length(O_ - projection(O_, B, C)), cross(O_-B,B-C));
}

// Draws right angle path
void markrightangle(triple A, triple O, triple B, real s = 1, pen p = currentpen, pen fillpen = nullpen, light light = currentlight) {
	triple R1 = s*unit(A-O)/25, R2 = s*unit(B-O)/25;
  	path3 rightAnglePath = (O + R1) -- (O + R1 + R2) -- (O + R2);
    path3 fillPath = (O + R1) -- (O + R1 + R2) -- (O + R2) -- O -- cycle;
    draw(rightAnglePath, p);
    draw(surface(fillPath), fillpen, light);
}

// Simple line structure for better code structuring
struct line3 {
    triple A, B;
    path3 thisLine;

    void init(triple A, triple B) {
        this.A = A;
        this.B = B;
      	thisLine = (A--B);
      	real k = 10^9;
      	triple v = (k-1)/2*(B-A);
      	thisLine = (A-v) -- (B+v);
    }
  
  	restricted path3 getPath() {
    	return thisLine;
    }
}

// Initializer
line3 line3(triple A, triple B) {
      line3 l;
      l.init(A,B);
      return l;
}

// Returns line intersection point
triple intersectionpoint(line3 a, line3 b) {
	return intersectionpoint(a.getPath(), b.getPath());
}

transform3 scale3(triple P, real k) {
	real r = length(O--P);
  	return shift(P*(r-k))*scale3(k);
}

// Returns a circumcenter of triangle ABC
triple circumcenter(triple A, triple B, triple C) {
	triple[] p1 = perpendicularPoints(A,B,C);
  	triple[] p2 = perpendicularPoints(C,B,A);
  	line3 l1 = line3(p1[0], p1[1]), l2 = line3(p2[0], p2[1]);
  
    return intersectionpoint(l1, l2);
}

// Returns a path of circle for ABC triangle.
path3 circumcircle(triple A, triple B, triple C) {
    triple O_ = circumcenter(A,B,C);
	return circle(O_, distance(A, O_), cross(A-B,B-C));
}

size(10cm);

triple C = (0,0,0);
triple B = (1,0,0);
triple A = (0.5,sqrt(3)/2,0);
triple P = (0.5,sqrt(3)/6,sqrt(2./3));
triple N = midpoint(B--A);
triple K = midpoint(C--A);
triple M = ratioPoint(P, C, 1/3);
triple S = ratioPoint(M, N, 4/7);


dot(N, 2bp+black);
dot(K, 2bp+black);
dot(P, 2bp+black);
dot(A, 2bp+black);
dot(B, 2bp+black);
dot(C, 2bp+black);
dot(M, 2bp+black);
dot(S, 2bp+black);
draw(B--C,longdashed);
draw(B--A--C--P--B--cycle);
draw(P--A);
draw(M--N, dashed);

label("$A$",A,E);
label("$B$",B,SW);
label("$C$",C,E);
label("$P$",P,NW);
label("$N$",N,SW);
label("$K$",K,SE);
label("$M$",M,NE);
label("$S$",S,NW);

draw(height(M,K,C));
draw(circumcircle(M,K,C));
draw(incircle(A,B,C), dotted);

draw(scale3(A, 1/2)*(N--K));
markrightangle(M, projection(M, A, C), C, fillpen=magenta+opacity(0.2), nolight);
dot(circumcenter(M,K,C), pink);

line3 l1 = line3(S,N), l2 = line3(A,M);

dot(intersectionpoint(l1, l2), orange);
// Change the perspective
currentprojection = perspective(8,27.3,15);
