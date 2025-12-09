# Day 9 - Movie Theatre

The input is a set of vertices. Draw the largest rectangle between any pair.

The vertices were specified as a list.

```
7,1
11,1
11,7
9,7
9,5
2,5
2,3
7,3
```

Visually, this is:

```
..............
.......#...#..
..............
..#....#......
..............
..#......#....
..............
.........#.#..
..............
```

## Part 1

This couldn't have been easier, particularly following day 8, as the input parser and combination generator are the same. Calculate the area of all the rectangles, then sort the list to find the largest.

## Part 2

The extension was that the rectangle must be within the polygon defined by the input list of vertices. The input coordinates are in the range 0-100,000 on both x and y; therefore, we must do this mathematically, as the set will be too large.

To test if a polygon is contained within another polygon, then all vertices of A must be inside B, and none of the edges of A must cross the edges of B.

I used the ray casting algorithm to determine if a point was in a polygon. Due to the way the coordinate grid works, the code is somewhat messy, as all the boundaries are contained within the shape. Then test all pairs of edges to see if they crossed using the cross product to see if the endpoints lie on opposite sides of the infinite line defined by the other segment.

