# Tail-Call Optimisation

* Code below is a Factorial program which is very inefficient, It works! but when it starts to compute bigger numbers, it wastes resources:

```
|=  n=@ud             :1
?:  =(n 1)            :2
  1                   :3
(mul n $(n (dec n)))  :4
```
### Why?
Lets break this down

* `1` is our `gate` that takes one sample (argument) `n` that must nest inside `@ud` _aka unsigned-integer_ type
* `2` check if `n` is `1`. If so, the result is just `1`, since `1 * 1 = 1`. If `n` is not `1` , then branch to the final line of the code, which is `4`
* Line `4` is where the recursion logic lives. We multiply `n` by the recursion of `n` minus `1`. `$` initiates recursion by calling the gate that we are already in but replaces its sample.

* Visually heres how it works:
```
(factorial 5)
(mul 5 (factorial 4))
(mul 5 (mul 4 (factorial 3)))
(mul 5 (mul 4 (mul 3 (factorial 2))))
(mul 5 (mul 4 (mul 3 (mul 2 (factorial 1)))))
(mul 5 (mul 4 (mul 3 (mul 2 1))))
(mul 5 (mul 4 (mul 3 2)))
(mul 5 (mul 4 6))
(mul 5 24)
120
```
* It's easy to see how we are "floating" gate calls until we reach the final iteration of calls that only produces a value. The `mul n` component of the gate leaves something like `mul 5`, waiting for the final series of terms to be operated upon. Once the expression cannot be expanded out further, the operations work backwards, successively feeding values into the `mul` functions behind them.

* This is why it isn't a very efficient method because we are using allot of computing resources. The pyramid-shaped illustration approximates what's happening on the **call stack**, a memory structure that tracks the instructions of the program. Every time a parent gate calls another gate, the gate being called is "pushed" to the top of the stack in the form of a frame. This process continues until a value is produced instead of a function, completing the stack.

* Visual breakdown
```
                  Push order      Pop order
(fifth frame)         ^               |
(fourth frame)        |               |
(third frame)         |               |
(second frame)        |               |
(first frame)         |               V

```

* Once this stack of frames is completed, frames "pop" off the stack starting at the top. When a frame is popped, it executes the contained gate and passes produced data _the output_ to the frame below it. This process continues until the stack is empty, giving us the gate's output.

* When a program's final expression uses the stack in this way, it's considered to be not tail-recursive.  if you have to manipulate the result of a recursion as the last expression of your gate, as we did in our example, the function is not tail-recursive, and therefore not very efficient with memory. A problem arises when we try to recurse more times that we have space on the stack.

* If you have to manipulate the result of a recursion as the last expression of your gate, the function is not tail-recursive, and therefore *not very efficient with memory*. A problem arises when we try to recurse more times that we have space on the stack. This will result in our computation failing and producing a stack overflow.

# A Tail-Recursive Gate

```
|=  n=@ud                   :1
=/  t=@ud  1                :2
|-                          :3
?:  =(n 1)                  :4
    t                       :5
$(n (dec n), t (mul t n))   :6

```
* We are still building a gate that takes one argument `n`. this time, we are also putting a `face` on `@ud` and setting its initial value of `1`. Line `3` is used to crease a new gate with one arm `$` and immediately call it. This can be thought of as a recursion point. We then evaluate `n` to see if it is `1`. If it is, we return the value of `t` else,  we perform our recursion (Line `6`).

* All we are doing here is recursing our new gate and modifying the values of `n` and `t`. `t` is used as an accumulator variable that we use to keep a running total for the factorial computation. _aka the counter_

 For example :
```
(factorial 5)
(|- 5 1)
(|- 4 5)
(|- 3 20)
(|- 2 60)
(|- 1 120)
120
```
* We simply multiply `t` and `n` to produce the new value of `t`, and then decrement `n` before repeating. Since this `$` call is the final and solitary thing that is run in the default case and since we are doing all computation before the call, this version is properly tail-recursive. We don't need to do anything to the result of the recursion except recurse it again. That means that each iteration can be replaced instead of held in memory.

## A note on `$`
* `$` is, in its use with recursion, a reference to the gate that we are inside of. That's because a gate is just a core with a single arm named `$`. The subject is searched depth-first, head before tail, with faces skipped, and stopping on the first result. In other words, the first match found in the head will be returned. If you wished to refer to the outer `$` in this context, the idiomatic way would be to use `^$`. The `^` operator skips the first match of a name.
