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
path3 ratioPoint(triple A, triple B, real t = 1.0) {
    return (1-t)*A + t*B;
}

// Returns length of segment AB
real segmentLength(triple A, triple B) {
    return sqrt((A.x-B.x)^2 + (A.y-B.y)^2 + (A.z-B.z)^2);
}

// Returns a bisector path
path3 bisector(triple P, triple A, triple B) {
	return P -- (ratioPoint(A,B,segmentLength(P,A)/(segmentLength(P,A)+segmentLength(P,B))));
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

// Retuns a segment that is scaled by its center by factor k.
path3 centerScaledSegment(triple A, triple B, real k=1.0) {
  	triple v = (k-1)/2*(B-A);
  	return (A-v) -- (B+v);
}
  
// Returns an intersection point of 2 lines A1A2 and B1B2
// NOTE: use only if segments are in one plain, else -- unexpected behaviour.
triple lineIntersection(triple A1, triple A2, triple B1, triple B2, real k=1000) {
	 	
  return intersectionpoint(centerScaledSegment(A1,A2,k), centerScaledSegment(B1,B2,k));
}

// Returns a circumcenter of triangle ABC
triple circumcenter(triple A, triple B, triple C) {
	triple[] p1 = perpendicularPoints(A,B,C);
  	triple[] p2 = perpendicularPoints(C,B,A);
  
    return lineIntersection(p1[0], p1[1], p2[0], p2[1]);
}

// Returns a path of circle for ABC triangle.
path3 circumcircle(triple A, triple B, triple C) {
    triple O_ = circumcenter(A,B,C);
	return circle(O_, segmentLength(A, O_), cross(A-B,B-C));
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
