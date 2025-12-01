# Day 1

A dial points to 50. Follow the sequence of turns to see how many times it lands on zero. The only gotcha here was that the real input had values > 100.

```
L68
L30
R48
L5
R60
L55
L1
L99
R14
L82
```

Part 2 was fiddly as the corner cases needed careful consideration. Landing on zero should be counted, so start with the answer from part 1. Add the number of clicks to turn through divided by 100 (the quotient) to count the number of full rotations. Then add the cases where the turning left by the number of clicks modulo 100 would be less than zero, and the same for turning right when it would be greater than 100.

Note that starting at 0 and turning left 5 does not count as passing zero. So if your zero passing test is `position < value`, then this is only true when `position > 0`.
