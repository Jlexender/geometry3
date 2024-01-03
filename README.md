# Description

Geometry3 repository is an implementation of basic functions that specify on segments on triangles (especially from geometry.asy), but ported to 3D and triple-like variables. Some functions can be implemented really poorly.

# List of available functions

* path3 triangle(triple A, triple B, triple C)
    - Returns a triangle path by 3 points

* triple centroid(triple A, triple B, triple C)
    - Returns a centroid of given triangle ABC

* path3 height(triple P, triple A, triple B)
    - Returns a path of height from P to AB in triangle ABC

* triple orthocenter(triple A, triple B, triple C)
    - Returns an orthocenter point in triangle ABC

* path3 ratioPoint(triple A, triple B, real t = 1.0)
    - Returns point on AB in specified ratio t

* real segmentLength(triple A, triple B)
    - Returns length of segment AB

* path3 bisector(triple P, triple A, triple B)
    - Returns a bisector path of triangle PAB

* triple incenter(triple A, triple B, triple C)
    - Returns incenter of given triangle ABC

* triple midpoint(triple A, triple B)
    - Returns midpoint of AB

* path3 perpendicular(triple A, triple B, triple C, real len = 1, real ratio=1/2)
    - Grows a perpendicular line in specified plain ABC from dot in ratio of AB

* triple[] perpendicularPoints(triple A, triple B, triple C, real len = 1, real ratio=1/2)
    - Returns keypoints of perpendicular (see perpendicicular function)

* path3 centerScaledSegment(triple A, triple B, real k=1.0)
    - Retuns a segment that is scaled by its center by factor k

* triple lineIntersection(triple A1, triple A2, triple B1, triple B2, real k=1000)
    - Returns an intersection point of 2 lines A1A2 and B1B2
    - NOTE: use only if segments are in one plain, else - unexpected behaviour

* triple circumcenter(triple A, triple B, triple C)
    - Returns a circumcenter of triangle ABC

* path3 circumcircle(triple A, triple B, triple C)
    - Returns a path of circle for ABC triangle

* path3 incircle(triple A, triple B, triple C)
    - Returns incircle path3

* triple projection(triple P, triple A, triple B)
    - Returns point H from height AH

