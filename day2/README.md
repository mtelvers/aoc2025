# Day 2 - Gift Shop

Find repeating patterns in some number ranges.

```
11-22,95-115,998-1012,1188511880-1188511890,222220-222224,
1698522-1698528,446443-446449,38593856-38593862,565653-565659,
824824821-824824827,2121212118-2121212124
```

## Part 1

I decided right away to use integer comparison rather than converting numbers to strings and then comparing them. The number of digits in an integer when written in base 10 is the `1 + int(log10 x)`. For part 1, the challenge was to look for exact splits `11` or `123123`; therefore, the length must be even. We can use the divisor `10^(length/2)`, and test with `x / divisor = x mod divisor` and sum all the numbers where this is true.

## Part 2

The problem is extended to allow any equal chunking. Thus, `824824824` is now valid as it has three chunks of 3 digits. Given the maximum length of a 64-bit integer is 20 digits, we only need the factors of the numbers 1 to 20, which could be entered as a static list. I decided to calculate these in code using a simple division test up to the square root of the number. I should memoise these results to avoid repeated recalculation. Once I had a list of factors, I folded over the list, testing each with a recursive function to verify that each chunk was equal.

```ocaml
let base = pow 10 factor in
let modulo = x mod base in

let rec loop v =
  if v = 0 then true
  else if v mod base = modulo then loop (v / base)
  else false
in

loop (x / base)
```

The only gotcha I found was that numbers less than 10 came out as true, so I constrained the lower bound of the range to 10.
