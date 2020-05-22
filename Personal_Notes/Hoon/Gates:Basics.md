
# Gate
![Reference_Link](https://urbit.org/docs/tutorials/hoon/gates/)

**Construct 1 -> Gate:[Battery Payload]**
**Construct 2 -> Gate:[$[Sample Context]]**

##Overview
-> A gate is a core with two distinctive properties:
    1 - The Battery of a gate contains exactly one `arm` which has the special name `$` (Aka. Buc), containing the instructions for the function in question
    2 - The payload of a gate consist of a cell of `[Sample Context]` where:
        - Sample = Stores the argument
        - Context = All other data to compute the `$` arm

Like all arms, `$` is computed with its parent core as the subject. When `$` is computed, the resulting value is the `product` (Aka, the product is the output of the Gate)

_So you can think of this like a physical `gate` which controls the flow of whatever people/data/chickens...
The battery is the operation, like plus, minus, multiple and all that
the payload (Just as it sounds - the `payload of an aircraft`) is the stuff that you load into it. in this case it has 2 different components, the Sample which is all the arguments and the context which is all the other data to support the arm in computing whatever_

##Anatomy of a Gate
-> A gate is a one-armed core with a sample: `[$ [Sample Context]]`

#The `$` arm _aka the operation_
-> The arm of the Gate encodes the instructions for the hoon function in question

#The Sample _aka the argument/holder_
-> The same of a gate is the address reserved for storing the argument to the hoon function. The sample is always at the head of the gate's tale (Tree position `+6`).
-> This is a placeholder value for the function argument. If you evaluate `$` arm without passing an argument, the placeholder value is used for the computation. This is sometimes called as a `blunt` value, being determined by the input type.

#The Context _the shit_
-> The context of a gate contains other data that maybe necessary for the `$` arm to evaluate correctly.
-> The context is always located at the tail, of the tail, of the gate (position +7 on the binary tree). There is no requirement that the context have any particular arrangement, though it often dose.

_As a side note: Basically a gate is a simple function used to modify an input using a specific function so the value of a functions output depends solely on the input value_

## Gates Define Functions of the Sample
-> The value of a function's output depends on the input value.
-> In Hoon, we can use `(gate arg)` syntax to make a cell function call. For example:
```
> (inc 234)
235
```
-> The name of the gate is `inc`, but how is the `$` arm of `inc` evaluated? _Go on mate...tell me.._
-> When a function is called, a copy of `inc` gate is create with the sample being replaced with the function argument. Then the `$` arm is computed against this modified version of the `inc` gate.

_so it copied then replaced meaning it becomes `(234)` then whatever the `$` is, it does it to the argument_

->The default or blunt value of the sample of `inc` is `0` (_since there is no argument_) on this example, so in the function call, a copy of `inc` gate is made but with a sample of `234`. When `$` is computed against this modified core, the product is 235.
->Neither the arm or the context is modified before the arm is evaluated. That means that the only part of the gate that changes before the arm evaluation is the sample. Hence, we may understand each gate as *defining a function whose argument is the sample.* If you call a gate with the same sample, you'll get the same value returned to you every time.

## Modifying the Context of a Gate
-> It is possible to modify the context of a gate when you make a function call; or, to be more precise, it's possible to call a mutant copy of the gate in which the context is modified. _Basically talks about how you can bind things to each other like `b` to the value `10` by talling hoon `=b 10`
