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

