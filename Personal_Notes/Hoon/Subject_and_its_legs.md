# The subject and its Legs

Hoon is a Subject oriented programming language. For now we can say three things about the subject:
* 1) every Hoon expression is evaluated relative to some subject;
* 2) roughly, the subject defines the environment in which a Hoon expression is evaluated;
* 3) the subject is a noun.

The `:` operator does two things.
* First, it evaluates the expression on the right-hand side;
* Second, it evaluates the expression on the left-hand side, using the product of the right-hand side as its subject.

For example
```
> [[(add 22 33) (mul 2 6)] 23]
[[55 12] 23]

> +1:[[(add 22 33) (mul 2 6)] 23]
[[55 12] 23]

> +2:[[(add 22 33) (mul 2 6)] 23]
[55 12]

> +3:[[(add 22 33) (mul 2 6)] 23]
23

> +4:[[(add 22 33) (mul 2 6)] 23]
55

```

* Sometimes a programmer simply wants to produce a value from the subject. In other cases more is desired such as  carrying out substantive computations on data in the subject. There are two kinds of limbs to accommodate these two cases:
* Arms: Arms are limbs of the subject that are used for carrying out substantive computations.
* Legs: Legs are limbs that store data. Any limb that isn't an arm is a leg.


# Address-based Limb Expressions

A limb expression is an expression of Hoon that resolves to a limb of the subject. An address-based limb expression evaluates to a limb of the subject based on its noun address. _WtF is this shit?_

## Various Limb Expressions Available in Hoon

* We'll explain the limb expressions that return a leg according to subject address.

### `+` Operator
*  For any unsigned integer `n`, `+n` returns the limb of the subject at address `n`. If there is no such limb, the result is a crash.

### `.` Expression
* Using `.` as an expression returns the entire subject. It's equivalent to `+1`.

### `lark` expressions (`+`,`-`, `+>`, `+<`, `->`, `-<`, etc.)
* Using `-` by itself returns the head of the subject, and using `+` by itself returns the tail. Note: `-` and `+` only work if the subject is a cell, naturally. An atom doesn't have a head or a tail.
* What if you want the tail of the tail of the subject? we combine `+` with `>` and the analogous point also holds for `-` and `<`
**Basically**
- `-<` returns the head of the head
- `->` returns the tail of the head
- `+<` returns the head of the tail
- `+>` returns the tail of the head

Further more, by alternating the `+/-` symbols with `</>` symbols, you can grab an even more specific limb of the subject:

```
> +:[[4 5] [6 [14 15]]]
[6 14 15]

> +>:[[4 5] [6 [14 15]]]
[14 15]

> +>-:[[4 5] [6 [14 15]]]
14
```
_Fantastic Example_
* You can think of this sort of lark series -- e.g., `+>-<` -- as indicating a binary tree path to a limb of the subject, starting from the root node of the tree. In the case of `+>-<` this path is: tail, tail, head, head.

```
      *Root*
      /    \
    Head   *Tail*
        /    \
      Head   *Tail*
          /    \
      *Head*   Tail
        /    \
    *Head*   Tail

```

### `&` and `|` operators
* `&n` returns the `n`th item of a list that has at least `n + 1` items. `|n` returns everything after `&n`.

# Other Limb Expressions

## Faces
* Hoon doesn't have variables like other programming languages do; it has 'faces'. Faces are like variables in certain respects, but not in others. Faces play various roles in Hoon, but most frequently faces are used simply as labels for legs.

A face is a limb expression that consists of a series of alphanumeric characters.

_Need to learn this deeper, Has allot of info that must be considered_
