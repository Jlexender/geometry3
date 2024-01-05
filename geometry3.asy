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

// line3 structure
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
  
  	path3 toPath() {
    	return thisLine;
    }
}

// Initialization for line3
line3 line3(triple A, triple B) {
      if (A == B) abort("unexpected line: AB is a dot");
      line3 l;
      l.init(A,B);
      return l;
}

// Returns line intersection point
triple intersectionpoint(line3 a, line3 b) {
	return intersectionpoint(a.toPath(), b.toPath());
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
  
  	path3 toPath() {
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


// segment3 structure
struct segment3 {
	triple A,B;
  
  	void init(triple A, triple B) {
    	this.A = A;
      	this.B = B;
    }
  
  	path3 toPath() {
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

// tangents function. Returns tangent line from point that away from circle
segment3[] tangents(circle3 c, triple A) {
  	if (dot(c.normal, A-c.C) != 0) abort("Point and circle aren't in-plane");
	circle3 c_ = circle3((A+c.C)/2, abs(A-c.C)/2, c.normal);
  	segment3[] L;
  	triple[] ii = intersectionpoints(c.toPath(), c_.toPath());
  	for (int i = 0; i < ii.length; ++i) {
    	L.push(segment3(A, ii[i]));
    }
  	return L;
}

// tangent function returns segment of length 1 that is tangent line to the circle that intersects point P.
segment3 tangent(circle3 c, triple P) {
  	triple[] L = intersectionpoints(c.toPath(), P);
	if (L.length == 0) abort("point is not on the circle path");
  	draw(c.C --(c.C +c.normal));
  	
  	draw(P -- P+c.normal, blue);
  	triple B = scale3(P, 1/c.r)*rotate(90, P, P+c.normal)*(c.C);
    triple C = scale3(P, 1/c.r)*rotate(-90, P, P+c.normal)*(c.C);
  	return segment3(B,C);
}

