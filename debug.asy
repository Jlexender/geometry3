import three;

/*
Asymptote VG language module (geometry3 package for 3D images).
Copyright (c) 2024

This program is free software; you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation; either version 2 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program; if not, see <http://www.gnu.org/licenses/>.

Author: Alexander Kaliev 2024/01/04
*/

real EPS = sqrt(realEpsilon); // \approx 1.49e-08

bool operator ==(real x, real y) {
	return abs(x-y) < EPS;
}

bool operator !=(real x, real y) {
	return !(x == y);
}

bool operator ==(triple T1, triple T2) {
	return (abs(T1.x - T2.x) < EPS) &&
      	   (abs(T1.y - T2.y) < EPS) &&
      	   (abs(T1.z - T2.z) < EPS);
}

bool operator !=(triple T1, triple T2) {
	return !(T1 == T2);
}

string string(bool b) {
	return (b ? "true":"false");
}

string string(triple t) {
	return string(t.x)+' '+string(t.y)+' '+string(t.z);
}

transform3 scale3(real k, triple P) {
	real r = length(O--P);
  	return shift(P*(r-k))*scale3(k);
}


real distance(triple P1, triple P2) {
	return length(P1-P2);
}


struct plane {
	restricted real a,b,c,d;
  	restricted triple n;
  
  	void init(triple P, triple n) {
        if (n.x < 0) n *= -1;
      	n = unit(n);
    	a = n.x;
      	b = n.y;
      	c = n.z;
      	d = -(P.x*a + P.y*b + P.z*c);
      	this.n = n;
    }
  
  	void init(triple A, triple B, triple C) {
    	triple n = cross(B-A, C-A);
      	if (n.x < 0) n *= -1;
      	init(A, n);
    }
  
  	real calculate(triple P) {
    	return P.x*a + P.y*b + P.z*c + d;
    }
}

bool operator ==(plane p1, plane p2) {
	return p1.a == p2.a && p1.b == p2.b && p1.c == p2.c && p1.d == p2.d;
}

bool operator !=(plane p1, plane p2) {
	return !(p1 == p2);
}

plane plane(triple P, triple n) {
	plane p; p.init(P, n);
  	return p;
}

plane plane(triple A, triple B, triple C) {
	plane p; p.init(A,B,C);
  	return p;
}

bool inplane(plane p, triple P) {
	return abs(p.calculate(P)) < EPS;
}

real distance(triple P, plane p) {
	return abs(p.a*P.x + p.b*P.y + p.c*P.z + p.d)/sqrt(p.a^2 + p.b^2 + p.c^2);
}

triple projection(plane p, triple P) {
  	triple P1=P-p.n*distance(P,p), P2=P+p.n*distance(P,p); 
	return (distance(P1, p) > distance(P2, p) ? P2:P1);
}


struct line3 {
	restricted triple v, P;
  	restricted path3 base;
  	restricted bool extendA, extendB;
  
  	void init(triple P, bool extendA=true, triple v, bool extendB=true, bool vec=false) {
      	if (vec) {
            base = P--(P+v);
        	this.v = unit(v);
      		this.P = P;
        }
      	else {
          	base = P--v;
        	triple B = v, A = P;
          	this.v = unit(B-A);
          	this.P = A;
        }
      	this.extendA = extendA;
      	this.extendB = extendB;
    }
  
  	void redirect() {
    	v *= -1;
    }
  
  	void normalize() {
    	if (v.x < 0) redirect();
    }
  	
  	path3 getBase() {
    	return base;
    }
  
  	path3 getLine() {
      	triple B=beginpoint(base), E=endpoint(base), M=midpoint(base);
      	if (extendA && extendB) return scale3(1/EPS, M)*base;
      	if (extendA) return scale3(10, E)*base;
      	if (extendB) return scale3(1/EPS, B)*base;
      	return base;
    }
}

line3 line3(triple P, bool extendA=true, triple v, bool extendB=true, bool vec=false) {
	line3 l; l.init(P, extendA, v, extendB, vec);
  	return l;
}

line3 copy(line3 l) { 
  return line3(l.P, l.extendA, l.v, l.extendB, true);
}

bool inplane(plane p, line3 l) {
	return inplane(p, l.P) && inplane(p, l.P+l.v);
}

bool parallel(line3 l1, line3 l2) {
  	line3 L1 = copy(l1), L2 = copy(l2);
  	if (L1.v.x < 0) L1.redirect();
    if (L2.v.x < 0) L2.redirect();
	return L1.v == L2.v;
}

bool crossing(line3 l1, line3 l2) {
  	if (parallel(l1,l2)) return false;
	triple[] L = {l1.P,l1.P+l1.v,l2.P,l2.P+l2.v};
  	bool c1=inplane(plane(L[0], L[1], L[2]), L[3]),
  		 c2=inplane(plane(L[1], L[2], L[3]), L[0]),
  		 c3=inplane(plane(L[2], L[3], L[0]), L[1]),
  		 c4=inplane(plane(L[3], L[0], L[1]), L[2]);
  	return !(c1 || c2 || c3 || c4);
}

plane plane(line3 l1, line3 l2) {
  	if (parallel(l1,l2) || crossing(l1,l2)) abort("no such plane");
	triple[] L = {l1.P,l1.P+l1.v,l2.P,l2.P+l2.v};
  	bool c1=inplane(plane(L[0], L[1], L[2]), L[3]),
  		 c2=inplane(plane(L[1], L[2], L[3]), L[0]),
  		 c3=inplane(plane(L[2], L[3], L[0]), L[1]),
  		 c4=inplane(plane(L[3], L[0], L[1]), L[2]);
    if (c1) return plane(L[0], L[1], L[2]);
  	else if (c2) return plane(L[1], L[2], L[3]);
  	else if (c3) return plane(L[2], L[3], L[0]);
  	else return plane(L[3], L[0], L[1]);
}

triple intersectionpoint(line3 l1, line3 l2, real fuzz=-1) {
	if (parallel(l1,l2) || crossing(l1,l2)) abort("lines do not intersect");
  	plane p = plane(l1,l2);
  	triple i = intersectionpoint(l1.getLine(), l2.getLine(), fuzz);
  	return projection(p, i);
}

triple intersectionpoint(line3 l, plane p, real fuzz=-1) {
	triple P1 = projection(p, l.P), P2 = projection(p, l.P+l.v);
  	line3 l_p = line3(P1, P2);
  	return intersectionpoint(l_p, l, fuzz);
}

line3 projection(plane p, line3 l) {
	line3 l_p = line3(projection(p, l.P), projection(p, l.P+l.v));
  	return l_p;
}

line3 raiseperpendicular(plane p, triple P) {
	if (!inplane(p, P)) return line3(P, projection(p,P));
  	return line3(P, p.n, true);
}

struct triangle3 {
	restricted triple A,B,C;
  	restricted real a,b,c,alpha,beta,gamma,area,perimeter;
  
  	void calculate(triple A, triple B, triple C) {
    	a = length(B-C);
      	b = length(A-C);
      	c = length(A-B);
      	alpha = acos((b^2 + c^2 - a^2)/(2*b*c));
      	beta = acos((a^2 + c^2 - b^2)/(2*a*c));
        gamma = acos((a^2 + b^2 - c^2)/(2*a*b));
      	area = 0.5*a*b*sin(gamma);
      	perimeter = a+b+c;
    }
  
  	void init(triple A, triple B, triple C) {
    	this.A = A;
      	this.B = B;
      	this.C = C;
      	calculate(A,B,C);
    }
  
  	real a() { return a; }
  	real b() { return b; }
  	real c() { return c; }
  	real alpha() { return alpha; }
  	real beta() { return beta; }
  	real gamma() { return gamma; }
  	real area() { return area; }
  	real perimeter() { return perimeter; }
  
  	path3 getPath() {
    	return A--B--C--cycle;
    }

}

triangle3 triangle3(triple A, triple B, triple C) {
	triangle3 t;
  	t.init(A,B,C);
  	return t;
}

plane plane(triangle3 t) {
	plane p; p.init(t.A,t.B,t.C);
  	return p;
}

void draw(picture pic=currentpicture, Label L="", triangle3 g, align align=NoAlign, material p=currentpen, margin3 margin=NoMargin3, light light=nolight, string name="", render render=defaultrender) {
  draw(pic,L,g.getPath(),align,p,margin,light,name,render);
}


struct circle3 {
	restricted triple C,n;
  	restricted real r;
  
	void init(triple C, real r, triple n=Z) {
      	if (n.x < 0) n *= -1;
    	this.C = C;
      	this.r = r;
      	this.n = unit(n);
    }
  
  	plane getPlane() {
    	return plane(C, n);
    }
  
  	path3 getPath() {
    	return circle(C, r, n);
    }
}

circle3 circle3(triple C, real r, triple n=Z) {
	circle3 c;
  	c.init(C,r,n);
  	return c;
}

bool inplane(plane p, circle3 c) {
  	plane p2 = c.getPlane();
	return p == c.getPlane();
}

bool oncircle(circle3 c, triple P) {
	return inplane(c.getPlane(), P) && distance(c.C, P) == c.r;
}

circle3 unitcircle = circle3(O, 1);

triple centroid(triangle3 t) {
	return (t.A + t.B + t.C)/3;
}

path3 median(triangle3 t, triple P) {
	if (P == t.A) {
    	return P -- midpoint(t.B--t.C);
    }
  	if (P == t.B) {
    	return P -- midpoint(t.A--t.C);
    }
  	if (P == t.C) {
    	return P -- midpoint(t.B--t.A);
    }
  	abort("P is not a triangle vertex");
  	return O;
}

triple heightpoint(triangle3 t, triple P) {
  	plane p, p_t = plane(t);
	if (P == t.A) {
    	p = plane(t.B, t.C, midpoint(t.B--t.C)+p_t.n);
      	return projection(p, t.A);
    }
  	if (P == t.B) {
    	p = plane(t.A, t.C, midpoint(t.A--t.C)+p_t.n);
      	return projection(p, t.B);
    }
  	if (P == t.C) {
    	p = plane(t.A, t.B, midpoint(t.A--t.B)+p_t.n);
      	return projection(p, t.C);
    }
  	abort("P is not a triangle vertex");
  	return O;
}

path3 height(triangle3 t, triple P) {
	return P--heightpoint(t, P);
}

triple orthocenter(triangle3 t) {
	triple H1 = heightpoint(t, t.A), H2 = heightpoint(t, t.B);
  	line3 l1 = line3(t.A, H1), l2 = line3(t.B, H2);
  	plane p = plane(t);
  	return projection(p, intersectionpoint(l1, l2));
}

triple bisectorpoint(triangle3 t, triple P) {
	if (P == t.A) {
    	return relpoint(t.B--t.C, t.c/(t.b+t.c));
    }
  	if (P == t.B) {
    	return relpoint(t.A--t.C, t.c/(t.a+t.c));
    }
  	if (P == t.C) {
    	return relpoint(t.A--t.B, t.b/(t.a+t.b));
    }
  	abort("P is not a triangle vertex");
  	return O;
}

path3 bisector(triangle3 t, triple P) {
	return P--bisectorpoint(t, P);
}

triple incenter(triangle3 t) {
  	plane p = plane(t);
	line3 b1 = line3(t.A, bisectorpoint(t, t.A)),
      	  b2 = line3(t.B, bisectorpoint(t, t.B));
  	return projection(p, intersectionpoint(b1, b2));
}

circle3 incircle(triangle3 t) {
	triple I = incenter(t), n = plane(t).n;
  	triangle3 t_I = triangle3(I, t.B, t.C);
  	real r = length(I-heightpoint(t_I, I));
  	return circle3(I,r,n);
}

triple circumcenter(triangle3 t) {
  	triple n = plane(t).n;
	triple A1 = midpoint(t.B--t.C), 
  		   B1 = midpoint(t.C--t.A);
  	triple nA = plane(t.B, t.C, A1+n).n,
  		   nB = plane(t.A, t.C, B1+n).n;
  	line3 l1 = line3(A1, A1+nA),
  		  l2 = line3(B1, B1+nB);
  	return intersectionpoint(l1, l2);
}

circle3 circumcircle(triangle3 t) {
	triple O = circumcenter(t);
  	real r = length(t.A-O);
  	return circle3(O, r, plane(t).n);
}

line3 tangent(circle3 c, triple P) {
	triple n = c.n;
  	triple O1 = rotate(90, P, P+n)*c.C;
  	triple O2 = scale3(-1, P)*O1;
  	return line3(O1, O2);
}


// epsilon problem
/* triple[] tangents(circle3 c, triple P) {
  	plane p = c.getPlane();
  	if (!inplane(p, P)) abort("P is not in circle3 plane");
  	triple O1 = midpoint(P--c.C);
  	circle3 c1 = circle3(O1, length(P-c.C)/2, c.n);
  	draw(c1.getPath(), blue+dashed);
  	triple[] t = intersectionpoints(c1.getPath(), c.getPath(), fuzz=EPS);
  	dot(t[1]);
  	return t;
} */

triple[] tangents(circle3 c, triple P) {
    plane p = c.getPlane();
    if (!inplane(p, P)) abort("P is not in circle3 plane");
  
  	triple[] L;
  	real d = distance(c.C, P);
  	circle3 c1 = circle3((c.C+P)/2, d/2, c.n);
  	path3 c1_p = c1.getPath();
  
  	real l=0, r=180;
  	triple t;
  	for (int i = 0; i < 100; ++i) {
    	real mid = (l+r)/2;
      	t = arcpoint(c1_p, mid);
      	if (distance(t, c.C) < c.r) l = mid;
      	else r = mid;
    }
	t = arcpoint(c1_p, r);
  	L.push(t);
  	
  	real l=-180, r=0;
  	for (int i = 0; i < 100; ++i) {
    	real mid = (l+r)/2;
      	t = arcpoint(c1_p, mid);
      	if (distance(t, c.C) < c.r) r = mid;
      	else l = mid;
    }
	t = arcpoint(c1_p, l);
  	if (t != L[0]) L.push(t);
  
	return L;
} 


struct segment3 {
	restricted triple A,B,v;
  	restricted path3 base;
  
  	void init(triple A, triple B) {
        base = A--B;
      	this.A = A; 
      	this.B = B;
        this.v = unit(B-A);
    }
  
  	void redirect() {
    	v *= -1;
    }
  	
  	path3 getPath() {
    	return base;
    }
  
}

segment3 segment3(triple A, triple B) {
	segment3 s; s.init(A,B);
  	return s;
}

segment3 copy(segment3 s) { 
  return segment3(s.A, s.B);
}

line3 line3(segment3 s, bool extendA=true, bool extendB=true) {
	return line3(s.A, extendA, s.B, extendB);
}

bool inplane(plane p, segment3 s) {
  	return inplane(p, line3(s));
}

bool parallel(segment3 l1, segment3 l2) {
  	return parallel(line3(l1), line3(l2));
}

triple intersectionpoint(segment3 s1, segment3 s2, real fuzz=-1) {
  	line3 l1 = line3(s1), l2 = line3(s2);
	if (parallel(l1,l2) || crossing(l1,l2)) abort("segments do not intersect");
  	plane p = plane(l1,l2);
  	triple i = intersectionpoint(s1.getPath(), s2.getPath(), fuzz);
  	return projection(p, i);
}


void markrightangle(triple A, triple B, triple C, real size = 1, pen p = currentpen, pen fillpen = nullpen, light light = currentlight) {
	triple R1 = size*unit(A-B)/6, R2 = size*unit(C-B)/6;
  	path3 rightAnglePath = (B + R1) -- (B + R1 + R2) -- (B + R2);
    path3 fillPath = (B + R1) -- (B + R1 + R2) -- (B + R2) -- B -- cycle;
    draw(rightAnglePath, p);
    draw(surface(fillPath), fillpen, light);
}

void markangle(triple A, triple B, triple C, int n = 1, real radius = 1, real space = 1, pen p = currentpen, pen fillpen = nullpen, light light = currentlight) {
	for (int i = 0; i < n; ++i) {
      	path3 mark = scale3(radius*0.75/length(B-C),B)*arc(B,C,A);
      	mark = scale3(1+0.75*space*i,B)*mark;
    	draw(mark);
      	if (i == n-1) {
        	surface fillPath = surface(B--mark--cycle);
          	draw(fillPath, fillpen, light);
        }
    }
}

struct sphere3 {
	restricted triple O;
  	restricted real r;
  	restricted projection p;
  	
  	void init(triple O, real r, projection p) {
      	this.O = O;
      	this.r = r;
    	this.p = p;
    }
  
  	path3[] getPath() {
      	triple n1 = p.camera-p.target;      
    	circle3 c1 = circle3(O, r, n1);     	
      	line3 l = line3(O, O+p.up); 
      	line3 l_c = projection(c1.getPlane(), l);
      	plane pl = plane(O, O+unit(n1)*r, O+unit(l_c.v)*r);
		real delta = n1.x < 0 ? 15 : -15;
      	triple P_rot = rotate(delta, O, O+pl.n)*(O+unit(l_c.v)*r);      
      	circle3 c2 = circle3(O, r, P_rot-O);
      	return c1.getPath()^^c2.getPath();
    }
}

sphere3 sphere3(triple O=(0,0,0), real r=1, projection p=currentprojection) {
	sphere3 s;
  	s.init(O, r, p);
  	return s;
}


// DEBUG BEGINS HERE

size(6cm);
dot(X);
dot(Y);
dot(Z);
draw(X--O--Y^^O--Z);
label("$X$", X, W);
label("$Y$", Y, E);
label("$Z$", Z, N);

currentprojection = orthographic(1,2,3);

// currentprojection = orthographic(-3,-4,5); // is upper than expected

projection cp = currentprojection;

triple n = (cp.camera - cp.target);

sphere3 s = sphere3((1,1,1),3);
draw(s.getPath(), red);

