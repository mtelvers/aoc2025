# Day 3 - Lobby

Sum the largest number you can make using N digits from the given sequences. The order of the digits cannot be changed.

```
987654321111111
811111111111119
234234234234278
818181911112111
```

## Part 1

As it was initially presented, you are only required to consider two digits. As `9_` will always be bigger than `8_`, this becomes a case of finding the largest digit available, which still leaves one digit. If there is more than one digit left, then pick the largest one. For example, given `818181911112111`, the largest first digit is `9`, followed by the largest digit in `11112111`, which is 2.

I pattern-matched the list of numbers to extract two digits in a recursive loop:

```ocaml
let rec loop max_left max_right = function
  | l :: r :: tl ->
    if l > max_left then loop l r (r :: tl)
    else if r > max_right then loop max_left r (r :: tl)
    else loop max_left max_right (r :: tl)
  | _ -> (max_left, max_right)
in
let l, r = loop 0 0 bank in
let num = l * 10 + r
```

## Part 2

Annoyingly, this changed the problem significantly, as it increased the number length from 2 to 12. My list approach now seemed unworkable, and I switched to using arrays.

Taking `818181911112111` as an example, I extracted `8181`, leaving 11 digits available and found the maximum value, which is the first `8`. Then I extracted a new subarray, `1818`, starting after the first digit matched and leaving 10 digits available. The maximum here is the `8` at index 1. Repeating this process, finding the maximum in `181`, then of `19`, and finally, all the remaining numbers must be taken to achieve the correct length.

```
818181911112111

8181 -> i=0 [i]=8
1818 -> i=1 [i]=8
181 -> i=1 [i]=8
19 -> i=1 [i]=9
1 -> i=0 [i]=1
1 -> i=0 [i]=1
1 -> i=0 [i]=1
1 -> i=0 [i]=1
2 -> i=0 [i]=2
1 -> i=0 [i]=1
1 -> i=0 [i]=1
1 -> i=0 [i]=1
```

This worked out nicely, and I parameterised the function to accept the length of the number required so that I could use this code for part 1 as well.

