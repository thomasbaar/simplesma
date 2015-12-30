# simplesma -- Simple State Machine Analyzer

## Overview

The *Simple State Machine Analyzer* (*SSMA* for short) is an [Xtext](www.eclipse.org/xtext)-based
toolset for analyzing simple state machines. SSMA has been implemented in
form of multiple DSLs. From the user's point of view, the DSL *ssma.sminv*
is the most important one since it allows to create and to interact with 
simple state machines. However, also the DSL *ssma.fml* can be used stand-alone;
it realizes a simple expression language (arithmetic expression and 
quantifier-free formulas)

Besides the source code for the DSLs, this repository contains some 
other Eclipse-projects
(e.g. *princessintegration*), which provide services for the SSMA toolset.

## Features of SSMA

The DSL *ssma.sminv* allows the user to describe simple state machines
in textual form. This 
language supports **named states, state variables, events**, and **transitions**. 
Each **transition connects two states** and has **optionally** an annotated **event**, 
a **guard** (which is a boolean expression) and an **update** on state variables. 

Each state machine has always exactly one start-state, which has to be named as well. 
Currently, only simples states are supported; there is no support neither for nested states 
nor for other non-simple states (e.g. history states, final states). Also, entry-/exit-actions
on states have not been supported yet.

A **unique feature** of SSMA is the **formulation and verification of invariants on states**. 
For example, one can constrain
the value of (some) state variables by a boolean expression, e.g. ´myvar > 5 - 2´.
The expression language is implemented by *ssma.fml* and can be used for formulating  
invariants on states as well as guards on transitions. Note that all expressions are 
currently either of type ´Integer´ or ´Boolean´ and no other types are  supported.
State variables are always of type ´Integer´.


The SSMA toolset can **check several properties** of a state machine that goes **beyond pure syntactic
checks**. For example, the toolset checks automatically whether all transitions have
guards and updates that are strong enough to establish the invariant(s) of their post-state. Another check is on
the liveness of a transition, i.e. whether its guard does not contradict the invariant of 
its pre-state. For these **semantic checks**, SSMA uses **internally the theorem prover [Princess](http://www.philipp.ruemmer.org/princess.shtml)**.

For a thorough description of SSMA's features please have a look on a pre-print of the 
conference paper *Thomas Baar: Verification Support for a State-Transition-DSL
Defined with Xtext*, published at the PSI'15 conference, held in 
Kazan, Russian Federation, August 25-27, 2015. The conference proceedings
have been published by Springer. 
#Te pre-print can be found in *ssma/doc/publications*.

Further documentations such as screenshots and an installation guide can be
found in project *ssma*.


## Version Information

In order to build SSMA and to use it, it is expected you have Eclipse
together with Xtext 2.8 installed on your machine.


## Credits

- **YAKINDU** SSMA has been greatly inspired by [Yakindu](www.statecharts.org). Compared to Yakindu,
SSMA does not support a graphical syntax (yet) and has the simpler expression language (e.g.
all expressions are of type ´Integer´ or ´Boolean´). On the other hand, Yakindu does not allow
to annotate invariants on a state and  provides pure syntactic checks only.

- **PRINCESS** SSMA uses internally this theorem prover [Princess](http://www.philipp.ruemmer.org/princess.shtml) 
developed by Philipp RÃ¼mmer for semantic
checks on the state machine. Princess supports first-order predicate logic
with Integer arithmetic (i.e. interpreted function and relation symbols).

- **Book _Implementing Domain-Specific Languages with Xtext and Xtend_ by _Lorenzo Bettini_**
This fantastic book teaches the definition of DSLs with Xtext with numerous insightful 
examples. The language *ssma.fml* is more or less taken literally from this book (in the book, this
language is called *Expression*).


## Feedback

In case your have comments, wishes, bugs, please write them too *thomas.baar AT htw-berlin.de* with 
a subject starting with **SSMA**.

