
# Change Log
All notable changes to this project will be documented in this file.
 
The format is based on [Keep a Changelog](http://keepachangelog.com/)
and this project adheres to [Semantic Versioning](http://semver.org/).
 
## [alpha 1.1] - 2024-01-04
  
### Added

- projection function
- incircle function
 
## [alpha 1.2] - 2024-01-04
  
### Fixed

- ratioPoint(triple, triple, triple) now returns triple

## [alpha 1.3] - 2024-01-04
  
### Added

- markrightangle() function

## [alpha 1.4] - 2024-01-05
  
### Added

- line3 structure (constructs by 2 triples). Implemented for finding line intersections.
    * NOTE: drawing a line is a bad idea, so no procedure provided
- intersectionpoint function between line3
- scale3 function now overloads for triple: scale3(triple P, real k=1.0)

### Removed

- lineIntersection function (line3 is the alternative way to find intersections)
- centerScaledSegment function (scale3 function is the alternative)

### Changed

- renamed segmentLength() to distance()
- better implementation for distance()
- changed circumcenter() logic
- reduced angle size in markrightangle()

## [alpha 2.0] - 2024-01-05
  
### Added

- circle3 structure (drawing works using **toPath()** method)
- segment3 structure (drawing works using **toPath()** method)
- tangents() function
    * Returns tangent line from point that away from circle
- tangent() function
    * returns segment of length 1 that is tangent line to the circle that intersects point P

## [alpha 2.1] - 2024-01-06
  
### Added

- plane structure (comparable)
    * constructor by 3 points
    * constructor by 1 point & normal vector
- draw() functions for every struct except plane
- intersectionpoint() functions
- projection(plane, triple) function
- distance(triple, plane) function

### Changed

- restructurized code, all structures have toPath() method if needed.
- changed return values according to added structures

### Fixed

- tangents function

## [beta 1.0] - 2024-01-07

The entire logic of module has been changed completely.

### Added

#### Structures:

- plane (comparable)
- line3
- triangle3
- circle3

#### Functions and methods (only geometry included):
NOTE: Functions with dot in their name in this list mean that module has the method of mentioned struct. For example, **real plane.calculate(triple P)** means that struct _plane_ has _calculate(triple P)_ method that returns _real_ value.
- transform3 scale3(real k, triple P) 
- real distance(triple P1, triple P2)
- real plane.calculate(triple P)
- bool operator ==(plane p1, plane p2)
- plane plane(triple P, triple n)
- plane plane(triple A, triple B, triple C)
- bool inplane(plane p, triple P)
- real distance(triple P, plane p)
- triple projection(plane p, triple P)
- void line3.redirect()
- path3 line3.getBase()
- path3 line3.getLine()
- line3 line3.copy()
- line3 line3(triple v, triple P, bool vec=false)
- bool inplane(plane p, line3 l)
- bool parallel(line3 l1, line3 l2)
- bool crossing(line3 l1, line3 l2)
- triple intersectionpoint(line3 l1, line3 l2, real fuzz=-1)
- triple intersectionpoint(line3 l, plane p, real fuzz=-1)
- line3 projection(plane p, line3 l)
- line3 raiseperpendicular(plane p, triple P)
- real triangle3.a()
- real triangle3.b()
- real triangle3.c()
- real triangle3.alpha()
- real triangle3.beta()
- real triangle3.gamma()
- real triangle3.area()
- real triangle3.perimeter()
- path3 triangle3.getPath()
- triangle3 triangle3(triple A, triple B, triple C)
- plane plane(triangle3 t)
- void draw(triangle t) (and all other parameters)
- plane circle3.getPlane()
- path3 circle3.getPath()
- circle3 circle3(triple C, real r, triple n=Z)
- bool inplane(plane p, circle3 c) 
- bool oncircle(circle3 c, triple P)
- triple centroid(triangle3 t)
- path3 median(triangle3 t, triple P)
- triple heightpoint(triangle3 t, triple P)
- path3 height(triangle3 t, triple P)
- triple orthocenter(triangle3 t)
- triple bisectorpoint(triangle3 t, triple P)
- path3 bisector(triangle3 t, triple P)
- triple incenter(triangle3 t)
- circle3 incircle(triangle3 t)
- triple circumcenter(triangle3 t)
- circle3 circumcircle(triangle3 t)
- line3 tangent(circle3 c, triple P)
- triple[] tangents(circle3 c, triple P)

### Changes

- tangent function doesn't have epsilon problem now
- reduced amount of calculation errors 

## [beta 1.1] - 2024-01-07

### Added

- void markrightangle(triple A, triple B, triple C, real size = 1, pen p = currentpen, pen fillpen = nullpen, light light = currentlight)
- void markangle(triple A, triple B, triple C, int n = 1, real radius = 1, real space = 1, pen p = currentpen, pen fillpen = nullpen, light light = currentlight)

In this procedures, __radius__ and __space__ are coefficients of scaling.

## [beta 1.2] - 2024-01-07

### Added

- plane plane(line3 l1, line3 l2)

### Fixed

- intersectionpoint(line3 l1, line3 l2) function (less calculation errors now)

## [beta 1.3] - 2024-01-08

### Changed

__line3__ initialization now includes __extendA, extendB__ booleans, so line3 can create semi-lines.

- line3 line3(triple P, bool extendA=true, triple v, bool extendB=true, bool vec=false)

### Fixed

- bool parallel(line3 l1, line3 l2) now doesn't affect on l1.v, l2.v
- void markrightangle( ... ): fixed marker size

### Added

- bool operator !=(plane p1, plane p2)

Structure __segment3__ and functions for it:

- path3 segment3.getPath()
- segment3 segment3(triple A, triple B)
- segment3 copy(segment3 s)
- line3 line3(segment3 s, bool extendA=true, bool extendB=true)
- bool inplane(plane p, segment3 s)
- bool parallel(segment3 l1, segment3 l2)
- triple intersectionpoint(segment3 s1, segment3 s2, real fuzz=-1)

