# Lists

* A list can be thought of as an ordered arrangement of zero or more elements terminated by a `~` _aka (null)_.

* A list can be either *null* or *non-null*.
-> When the list contains only `~` and no items, it's the null list.
-> Non-null lists called lests, are cells in which the head is the first list item, and the tail is the rest of the list. The tail is itself a list, and if such a list is also non-null, the head of this sub-list is the second item in the greater list, and so on.

For example:
```
[1 2 3 4 ~]
with the cell-delineating brackets left in:  
[1 [2 [3 [4 ~]]]]
```

* It's easy to see where the heads (atom `1`) are and where the nesting tails (`[2 [3 [4 ~]]]`) are. Recall that whenever cell brackets are omitted so that visually there appears to be more than two child nouns, it is implicitly understood that the right-most nouns constitute a cell.
* FYI - `~[1 2]` is semantically identical to `[1 2 ~]`

* The use of *casts* helps tell the hoon compiler exactly what data structure we mean. **Get in the habit of casting your data structures, as it will not only help anyone reading your code, but it will help you in hunting down bugs in your code.**
For example: `(list @t)` is the cast here:
```
Input > `(list @t)`['Urbit' 'will' 'rescue' 'the' 'internet' ~]

Output > |Urbit will rescue the internet|>
```

## List Structure
* The head of a list has the face `i` and the tail has the face `t` -> `[i t]`.
* To use the `i` and `t` faces of a list, you must first prove that the list is non-null by using the conditional family of runes, `?`

- For example :
```
> =>(b=`(list @)`[1 2 3 4 5 ~] ?~(b ~ i.b))
1

> =>(b=`(list @)`[1 2 3 4 5 ~] ?~(b ~ t.b))
~[2 3 4 5]

```
**NOTE**
It's important to kow that performing tests like `?~ mylist` will actually transform `mylist` into a non-null list. Because non-null lists (_aka lest_) is a different type than list, performing such tests can come back to bite you later in non-obvious ways when you try to use some standard library functions meant for lists.

You can construct lists of any type. `(list @)` indicates a list of atoms, `(list ^)` indicates a list of cells, `(list [@ ?])` indicates a list of cells whose head is an atom and whose tail is a flag, etc.

## Tapes and Cords

Hoon has two kinds of strings:
* Cords - Atoms with aura `@t` printed between `' '` marks
* Tapes - Atoms with aura `@tD` printed between `" "` marks
```
> `tape`"this is a tape"
"this is a tape"

> `cord`'this is a cord'
'this is a cord'
```

## List Functions in the Hoon Standard library

Lists are a commonly used data structure. Accordingly, there are several functions in the ![Hoon standard Library](https://urbit.org/docs/reference/library/)
intended to make lists easier to use.

* `flop` functions takes a list and returns it in reverse order _it Flops its around_
* `sort` function uses the 'quicksort' Algo depending on the argument.
```
> (sort ~[37 62 49 921 123] <ARG>)
```
_Arguments;
 - lth; Less than
 - gth; Greater than_
* `weld` function takes two lists of the same type and concatenates them.
* `snag` function takes an atom `n` and a list, and returns the `n`th item of the list.
For Example :
```
> (snag 0 `(list @)`~[11 22 33 44])
11

> (snag 3 `(list @)`~[11 22 33 44])
44
```
* `oust` function takes a pair of atoms `[a=@ b=@]` and a list, and returns the list with `b` items removed, starting at item `a`.
For Example :
```
> (oust [1 2] `(list @)`~[11 22 33 44])
~[11 44]

> (oust [2 2] "Hello!")
```
* `lent` function takes a list and returns the number of items in it.
* `roll` function takes a list and a gate, and accumulates a value of the list items using the gate. For example, If you would want to add or multiply items in a list of atoms, you would use `roll`.
```
> (roll `(list @)`~[11 22 33 44 55] add)
165

> (roll `(list @)`~[11 22 33 44 55] mul)
19.326.120
```
* `turn` function takes a list and a gate, and returns a list of the products of applying each item of the input list to the gate. Ie, add `1` to each item in a list of atoms:
```
> (turn `(list @)`~[11 22 33 44] |=(a=@ +(a)))

~[12 23 34 45]
```
