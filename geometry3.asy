/* 
geometry3 unofficial module for Asymptote vector graphics language


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

import three;

/* CONSTANTS */
real EPS = 1e-7;

/* LINE STRUCTURE */

// line3 structure
struct line3 {
    triple A, B;
  	bool extendA, extendB;
    path3 path;

    void init(triple A, bool extendA=true, triple B, bool extendB=true) {
        this.A = A;
        this.B = B;
      	path = (A--B);
      	real kA = extendA ? 10^9: 1, kB = extendB ? 10^9: 1;
      	triple vA = (kA-1)/2*(B-A), vB = (kB-1)/2*(B-A);
      	path = (A-vA) -- (B+vB);
    }
  
  	path3 getPath() {
    	return path;
    }
}

// Initialization for line3
line3 line3(triple A, bool extendA=true, triple B, bool extendB=true) {
      if (A == B) abort("unexpected line: AB is a dot");
      line3 l;
      l.init(A, extendA, B, extendB);
      return l;
}

/* SEGMENT STRUCTURE */

// segment3 structure
struct segment3 {
	triple A,B;
  
  	void init(triple A, triple B) {
    	this.A = A;
      	this.B = B;
    }
  
  	path3 getPath() {
    	return A--B;
    } 	
}

// Initialization for segment3
segment3 segment3(triple A, triple B) {
      if (A == B) abort("unexpected segment: AB is a dot");
  	  segment3 l;
      l.init(A, B);
      return l;
} 

/* CIRCLE STRUCTURE */

// circle3 structure
struct circle3 {
  	triple C;
  	real r;
  	triple normal;
    path3 path;

    void init(triple C, real r, triple normal) {
        this.path = circle(C, r, normal);
      	this.r = r;
      	this.C = C;
      	this.normal = normal;
    }
  
  	path3 getPath() {
    	return path;
    }
}

// Initialization for circle3
circle3 circle3(triple C=O, real r=1, triple normal=X) {
      circle3 c;
  	  if (r <= 0) abort("unexpected radius value (r > 0)");
  	  if (normal == O) abort("unexpected normal vector");
      c.init(C, r, normal);
      return c;
}

/* PLANE STRUCTURE */

// plane structure
struct plane {
	triple normal;
  	real A,B,C,D;
  
  	void init(triple A, triple B, triple C) {
      	normal = unit(cross(B-A,C-A));
      	this.A = normal.x;
      	this.B = normal.y;
      	this.C = normal.z;
      	this.D = -(normal.x*A.x + normal.y*A.y + normal.z*A.z); 	 
    }
  
  	void init(triple A, triple normal) {
    	normal = unit(normal);
      	this.A = normal.x;
      	this.B = normal.y;
      	this.C = normal.z;
      	this.D = -(normal.x*A.x + normal.y*A.y + normal.z*A.z); 	 
    }
  
  	bool operator ==(plane p) {
    	if (abs(abs(p.normal.x) - abs(this.normal.x)) < EPS && 
            abs(abs(p.normal.y) - abs(this.normal.y)) < EPS &&
            abs(abs(p.normal.z) - abs(this.normal.z)) < EPS)
        	return true;
        else	return false;
    }
  
  		
}

// Initialization for plane
plane plane(triple A, triple B, triple C) {
      if (A == B || B == C || A == C) abort("AB is a dot");
  	  plane p;
  	  p.init(A,B,C);
  	  return p;
}

// Initialization for plane (point and normal vector)
plane plane(triple A, triple normal) {
  	  plane p;
  	  p.init(A,normal);
  	  return p;
}

/* BASIC LINE FUNCTIONS */

// Returns midpoint of AB
triple midpoint(triple A, triple B) {
	return (A+B)/2;
}

// Returns point on AB in specified ratio t
triple ratioPoint(triple A, triple B, real t = 1.0) {
    return (1-t)*A + t*B;
}

// Returns length of segment AB
real distance(triple A, triple B) {
    return abs(A-B);
}

// Returns distance from P to the p plane
real distance(triple P, plane p) {
	return (abs(p.A * P.x + p.B * P.y + p.C * P.z + p.D))/(sqrt(p.A^2 + p.B^2 + p.C^2));
}

/* PROJECTIONS */

// Returns point H from height AH
triple projection(triple A, triple B, triple P) {
	return A + dot(P - A, B - A) / dot(B - A, B - A) * (B - A);
}

// Grows a perpendicular line in specified plain ABC from dot in ratio of AB.
segment3 perpendicular(triple A, triple B, triple C, real len = 1, real ratio=1/2) {
    triple AB = B-A;
    triple D = A + ratio*AB;
    triple normalVector = cross(A-B, C-B);
    triple perpendicularVector = cross(AB, normalVector);
	triple E_ = D + len*unit(perpendicularVector);
    return segment3(D,E_);
}

// Returns key points of perpendicular (see perpendicicular function)
triple[] perpendicular2(triple A, triple B, triple C, real len = 1, real ratio=1/2) {
    triple AB = B-A;
    triple D = A + ratio*AB;
    triple normalVector = cross(A-B, C-B);
    triple perpendicularVector = cross(AB, normalVector);
	triple E_ = D + len*unit(perpendicularVector);
    triple[] L = {D, E_};
    return L;
}

// Projects a point P to plane p
triple projection(plane p, triple P) {
  	real rho = distance(P, p);
  	triple P1 = P+p.normal*rho, P2 = P-p.normal*rho;
	real r1 = distance(P1, p), r2 = distance(P2, p);
    return (r1 > r2 ? P-p.normal*rho : P+p.normal*rho);
}

/* INTERSECTIONS */

// Returns line intersection point
triple intersectionpoint(line3 a, line3 b) {
	return intersectionpoint(a.getPath(), b.getPath());
}

// Returns intersection point between line and plane
triple intersectionpoint(line3 a, plane b) {
  	return O;
}

// Returns line intersection point
triple intersectionpoint(line3 a, segment3 b) {
	return intersectionpoint(a.getPath(), b.getPath());
}

// Returns line intersection point
triple intersectionpoint(circle3 a, circle3 b) {
	return intersectionpoint(a.getPath(), b.getPath());
}

// Returns line intersection point
triple intersectionpoint(circle3 a, line3 b) {
	return intersectionpoint(a.getPath(), b.getPath());
}

// Returns line intersection point
triple intersectionpoint(circle3 a, segment3 b) {
	return intersectionpoint(a.getPath(), b.getPath());
}

// Returns line intersection point
triple intersectionpoint(segment3 a, segment3 b) {
	return intersectionpoint(a.getPath(), b.getPath());
}

/* TRANSFORMATIONS */

transform3 scale3(real k, triple P) {
	real r = length(O--P);
  	return shift(P*(r-k))*scale3(k);
}

/* TRIANGLE GEOMETRY */ 

// Returns a triangle path by 3 points
path3 triangle(triple A, triple B, triple C) {
    return A--B--C--cycle;
}

// Returns a bisector path
segment3 bisector(triple P, triple A, triple B) {
	return segment3(P, ratioPoint(A,B,distance(P,A)/(distance(P,A)+distance(P,B))));
}

// Returns a centroid of given triangle ABC
triple centroid(triple A, triple B, triple C) {
    return (A+B+C)/3;
}

// Returns incenter of given triangle ABC
triple incenter(triple A, triple B, triple C) {
	return intersectionpoint(bisector(A,B,C), bisector(B,A,C));
}

// Returns incircle path3
circle3 incircle(triple A, triple B, triple C) {
	triple O_ = incenter(A,B,C);
	return circle3(O_, length(O_ - projection(O_, B, C)), cross(O_-B,B-C));
}

// Returns a circumcenter of triangle ABC
triple circumcenter(triple A, triple B, triple C) {
	triple[] p1 = perpendicular2(A,B,C);
  	triple[] p2 = perpendicular2(C,B,A);
  	line3 l1 = line3(p1[0], p1[1]), l2 = line3(p2[0], p2[1]);
    return intersectionpoint(l1, l2);
}

// Returns a path of circle for ABC triangle.
circle3 circumcircle(triple A, triple B, triple C) {
    triple O_ = circumcenter(A,B,C);
	return circle3(O_, distance(A, O_), cross(A-B,B-C));
}

// Returns a path of height from P to AB in triangle ABC
segment3 height(triple P, triple A, triple B) {
    return segment3(P, (A + dot(P - A, B - A) / dot(B - A, B - A) * (B - A)));
}

/* CIRCLE */

// tangent function returns segment of length 1 that is tangent line to the circle that intersects point P.
segment3 tangent(circle3 c, triple P) {
  	triple[] L = intersectionpoints(c.path, P);
  	triple B = scale3(1/c.r, P)*rotate(90, P, P+c.normal)*(c.C);
    triple C = scale3(1/c.r, P)*rotate(-90, P, P+c.normal)*(c.C);
  	return segment3(B,C);
}

// Epsilon problem
/* triple[] tangents(circle3 c, triple A, real fuzz = EPS) {
  	if (dot(c.normal, A-c.C) > EPS) abort("Point and circle aren't in-plane");    
	circle3 c_ = circle3(projection(plane(c.C, c.normal), midpoint(A,c.C)), distance(A,c.C)/2, c.normal); 
  
  	real[][] t=intersections(c.getPath(),c_.getPath(),fuzz);
  	return sequence(new triple(int i) {return point(c.getPath(),t[i][0]);},t.length);
} */ 

// tangents function. Returns tangent line from point that away from circle
triple[] tangents(circle3 c, triple A) {
	if (dot(c.normal, A-c.C) > EPS) abort("Point and circle aren't in-plane");
  	path3 c_ = shift((A-c.C)/2)*scale3(distance(A, c.C)/(2*c.r), c.C)*c.getPath();
  	triple[] i = {intersectionpoint(c.getPath(), c_, fuzz=EPS)};
  	i.push(reflect(A, c.C, A+c.normal)*i[0]);
  	return i;
}

/* DRAWING */

// Draws right angle path
void markrightangle(triple A, triple O, triple B, real s = 1, pen p = currentpen, pen fillpen = nullpen, light light = currentlight) {
	triple R1 = s*unit(A-O)/25, R2 = s*unit(B-O)/25;
  	path3 rightAnglePath = (O + R1) -- (O + R1 + R2) -- (O + R2);
    path3 fillPath = (O + R1) -- (O + R1 + R2) -- (O + R2) -- O -- cycle;
    draw(rightAnglePath, p);
    draw(surface(fillPath), fillpen, light);
}

void draw(picture pic=currentpicture, Label L="", circle3 g, align align=NoAlign, material p=currentpen, margin3 margin=NoMargin3, light light=nolight, string name="", render render=defaultrender) {
  draw(pic,L,g.getPath(),align,p,margin,light,name,render);
}

void draw(picture pic=currentpicture, Label L="", line3 g, align align=NoAlign, material p=currentpen, margin3 margin=NoMargin3, light light=nolight, string name="", render render=defaultrender) {
  draw(pic,L,g.getPath(),align,p,margin,light,name,render);
}

void draw(picture pic=currentpicture, Label L="", segment3 g, align align=NoAlign, material p=currentpen, margin3 margin=NoMargin3, light light=nolight, string name="", render render=defaultrender) {
  draw(pic,L,g.getPath(),align,p,margin,light,name,render);
}
