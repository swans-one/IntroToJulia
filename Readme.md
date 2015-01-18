Intro To Julia
==============

This repository contains code presented at the Pittsburgh Code and
Supply meetup
[Introduction to the Julia Programming Language](http://www.meetup.com/Pittsburgh-Code-Supply/events/216027832/)
on January 12th, 2015. The presentation was given as an interactive
tutorial, where everyone was encouraged to follow along in IJulia
notebooks. In two sections we first covered the basic syntax and
semantics of the Julia language and second worked through an example
problem.

Included in the `IntroToJulia` directory of this repository are two
versions of two files. BasicJulia.ipynb, BasicJulia.jl,
FindingPi.ipynb, FindingPi.jl. These files are described below.

BasicJulia
----------

BasicJulia.ipynb is the IJulia notebook we created during the
presentation, with some additional links to
documentation. BasicJulia.jl contains just the source code with none
of the notebook metadata.

We covered the basic syntax of the following, with a few simple
examples for each:

- Basic Types
- Variables
- Flow Control
- Functions

The contents of this notebook can also be viewed (but not interacted
with) without any need to download or install Julia, by going to its
[nbviewer page, here](http://nbviewer.ipython.org/github/Wilduck/IntroToJulia/blob/v1.0/IntroToJulia/BasicJulia.ipynb).

FindingPi
---------

After introducing the basic syntax of Julia, we worked through a
guided example of doing a numeric simulation in Julia. The example was
to estimate the value of Pi, using a method derived from the ratio of
a circle's area to the area of it's circumscribed square. We wrote
this code in modules, testing our functions as we went. We also
plotted the accuracy of our recommendations using the Gadfly plotting
library.

The FindingPi.ipynb is an IJulia notebook very similar to the one we
created during the presentation. It includes a fair amount of
explanatory text, covering both the problem of estimating pi, and the
organization of the code. The FindingPi.jl file contains just the
source code with little explanatory comments and none of the notebook
metadata.

Working through this example, we introduced the following Julia concepts:

- User Defined Types
- Multiple Dispatch
- Modules and Imports
- Testing
- External Packages
- Graphing
- Performance of nested loops.

The contents of this notebook can also be viewed (but not interacted
with) without any need to download or install Julia, by going to its
[nbviewer page, here](http://nbviewer.ipython.org/github/Wilduck/IntroToJulia/blob/v1.0/IntroToJulia/FindingPi.ipynb).

Copyright
=========

Copyright © 2015 Erik Swanson <theerikswanson@gmail.com>
This work is free. You can redistribute it and/or modify it under the
terms of the Do What The Fuck You Want To Public License, Version 2,
as published by Sam Hocevar. See the COPYING file for more details.
