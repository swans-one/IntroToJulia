
# coding: utf-8

# A Julia Example: Finding Pi
# ===========================
# 
# This notebook develops a complete simulation to solve an interesting, if somewhat artificial problem. The problem can be stated as "Imagine we don't know the value of the constant, $\pi$. Can we write a simple piece of code, based on some mathematic rules, to estimate a value for this constant?"
# 
# The mathematical rules we will be using are derived from the the ratio of the area of a cirlce, with a radius $r$ to the area of a square with a sides of length $2r$ (See the description of the `finding_pi` function below). Image a square circumscribing a circle like so.
# 
# ![Cirlce in Square](http://i.imgur.com/YVRUtV7.png?2)
# 
# Since we can exactly determine the value of $\pi$ if we know the ratio of these areas, we should be able to estimate the value of pi by estimating the ratio of these areas. In this example, we are going to generate a large number of points randomly distributed within a square like the one above, and determine what proportion of points are inside the circle. This should work as an estimate of the ratio of area of the circle to area of the square, and allow us to estimate $\pi$.
# 
# The code we write to do this will be divided into three modules. The first develops the library of functions needed to support this simulation. The second tests these functions, and the third writes the code to run a trial of this simulation, and to run a batch of trials to test the properties of this simulation.
# 
# Finaly, we'll plot the results.

# FindingPi Module
# ----------------
# 
# The following text describes the pieces of code in this module, with explanations of the Julia concepts they illustrate. Consider glancing through the code before reading this (much longer) description.
# 
# This is where most of our "library" code will go. We will write these functions and types as we need them, and will make sure they are testable. Actual simulation logic will live in another module.
# 
# In Julia, [Modules](http://docs.julialang.org/en/latest/manual/modules/) are the primary method of creating namespaces. In this module, we do not import any external names, but we do use the `export` keyword to export some. The types and methods that we export will be made public so that we can use them in other modules we write, through the `using` keyword.
# 
# 
# ### The `Point` Type
# 
# Stores a point in cartesian space. We will create instances of this type when we are generating the points for our simulation. This user defined type is a [Composite Type](http://docs.julialang.org/en/latest/manual/types/#composite-types).
# 
# ### The `is_inside` Methods
# 
# This function takes a point, and a radius of a circle, and returns a boolean, whether the  point is inside the circle or not.
# 
# The pythagorean formula states that $a^2 + b^2 = c^2$. We'll use this to create a test of whether a point is inside our circle. If we let the x-coordinate of our point be our $a$ and the y-coordinate of our point be $b$, it makes sense that the point is inside the circle, if $x^2 + y^2 <= r^2$
# 
# We define three versions of this function. When multiple versions of a function with the same name are defined for different types of arguments, they're known as [Methods](http://docs.julialang.org/en/latest/manual/methods/). When a function is called, the number and types of arguments passed in are used dispatch to the correct method. Since all the arguments are used to determine which of the available methods should be used, this process is known as [Multiple Dispatch](http://en.wikipedia.org/wiki/Multiple_dispatch), as opposed to the single dispatch that most OO languages use.
# 
# It is also worth noting that the final two functions could be replaced with a single definition: `is_inside(point, radius=1)`, using default arguments. These forms are semantically identical (See: [functions with optional arguments](http://julia.readthedocs.org/en/latest/manual/functions/#optional-arguments)).
# 
# ### The `find_pi` function
# 
# This function takes the number of points inside and outside the circle, and returns an estimate of pi. 
# 
# The area of a circle with radius $r$, called $area_c$, can be given $area_c = \pi r^2$ and the area of a square circumbscribing the circle, called $area_s$ can be given $area_s = (2r)^2$. If we take the proportion of points inside the circle to outside the circle, to be the same as the proportion, $\frac{area_c}{area_s}$, then 
# 
# $\frac{inside}{outside} = \frac{\pi r^2}{(2r)^2} = \frac{\pi}{4}$
# 
# and then our estimate of pi can be expressed as
# 
# $\pi = 4 \frac{inside}{outside}$
# 
# Which is what this function returns
# 
# ### The `random_point` function
# 
# This function generates a random x-coordinate and random y-coordinate, each between -1 and 1. These are used to construct a `Point` object, which is returned.
# 
# ### The `generate_points` function
# 
# Returns `n` points created with the `random_point` function.

# In[66]:

module FindingPi

export Point, is_inside, find_pi, random_point, generate_points

type Point
    x::Real
    y::Real
end

# r^2 = x^2 + y^2
is_inside(x, y, radius) = x^2 + y^2 <= radius^2
is_inside(point, radius) = is_inside(point.x, point.y, radius)
is_inside(point) = is_inside(point, 1)


# area_circle = pi*r^2
# area_square = (2r)^2
#  => c / s = pi / 4 
find_pi(inside, total) = 4 * inside / total

function random_point()
    x = (rand() * 2) - 1
    y = (rand() * 2) - 1
    Point(x, y)
end

generate_points(n) = [random_point() for i=1:n]

end


# The TestingPi Module
# --------------------
# 
# Here we right some basic tests to make sure that our functions are working as expected. We will only be testing our library code, not our actual simulation code.
# 
# In order to test code contained in another module, we first have to be sure those functions are available in the current namespace. There are two keywords that can be used to bring external functions into the current namespace, `import` and `using` which have a [number of differences](http://docs.julialang.org/en/latest/manual/modules/#summary-of-module-usage). Here, we use `using FindingPi` because it will bring into scope all the names that were `export`'d in the `FindingPi` module. 
# 
# We also include `using Base.Test`, which brings in the unit testing functionality that is included with Julia. Specifically, we'll use the `@test` macro from [`Base.Test`](http://julia.readthedocs.org/en/latest/stdlib/test/#test-framework) to test our code and provide feedback if something fails. This [macro](http://docs.julialang.org/en/latest/manual/metaprogramming/?highlight=macro#macros), denoted with the `@` sign, is essentially a glorified assert statement. It will pass without output if it's single argument evaluates to `true` otherwise it will fail with a full traceback.

# In[68]:

module TestingPi

using FindingPi
using Base.Test

# is_inside
@test is_inside(0, 0, 1)
@test !is_inside(1, 1, 1)
@test is_inside(1/sqrt(2), 1/sqrt(2), 1)
@test is_inside(Point(0,0))

# find_pi
@test find_pi(100, 100) == 4

# generate_points
@test typeof(random_point()) == Point
@test length(generate_points(4)) == 4

# @test false

end


# FindingPiSim Module
# -------------------
# 
# This module contains two functions. The first runs an individual trial, creating an estimation of pi. The second collects a series of these trials together, and returns an array of the results.
# 
# ### The `trial` function
# 
# In this function, we used the components we developed in the `FindingPi` module to estimate pi. As described in the introduction, this involves generating a set of randomly distributed points, assessing how many of them lie within the circle, and using that proportion to estimate $\pi$.
# 
# This function takes a single argument, `n`, which controls how many points are generated. This comes with an assumption that as more points are generated, the estimate of pi should become more accurate. This assumption makes intuitive sense, but we can test the assumption by observing the results of the `trial` function at a variety of values of `n`.
# 
# ### The `batch` function
# 
# The `batch` function runs a number of trials, collecting the results for observation. Here, we are moving beyond simply estimating pi, and starting to look at the properties of our estimation techniques.
# 
# The `batch` function takes a range (or other iterable) and a number of iterations. For each value in the iterable, it will run the `trial` function `iterations` times. Taking both a range, and number of iterations allows us to observe the behavior of our estimate at specified values of `n`, as well as show a broad picture of the estimates at those levels of `n` by controlling the number of iterations.
# 
# The output is an array with dimensions $length(range) \cdot iterations \times 2$, where the first column is the number of points, `n`, used to estimate $\pi$, and the second column is the estimate of $\pi$ for that trial. This array will allow us to easily plot the results of many trials of our estimate of $\pi$.
# 
# ### A note on performance
# 
# For people who are used to working with languages such as R, Matlab, or Python/Numpy/Scipy, it might be counterintuitive to write nested for loops, as seen in the `batch` function below. In those languages, to get decent performance, all expensive computation needs to either be vectorized, or off-loaded to a more performant language.
# 
# [Benchmarks](http://julialang.org/benchmarks/) show that Julia is very fast. While artificial benchmarks are a poor judge of the quality of a language, and many of the contenders in those benchmarks could be improved through optimization, the real benefit of Julia being fast, is that you can write simple, readable code and expect it to be performant.
# 
# This performance comes from an LLVM-based just-in-time (JIT) compiler. For the most part, the programmer can simply write code and expect it to be optimized automatically at run time. If the programmer needs more performance, the guide for writing [Fast Numeric Computation in Julia](http://julialang.org/blog/2013/09/fast-numeric/) is short, straigtforward, and easy to internalize.

# In[67]:

module FindingPiSim

using FindingPi

function trial(n)
    points = generate_points(n)
    points_inside = map(is_inside, points)
    inside_count = sum(points_inside)
    pi_estimate = find_pi(inside_count, n)
end

function batch(range, iterations)
    results = Array(Real, (length(range) * iterations, 2))
    i = 1
    for n = range
        for j = 1:iterations
            results[i, :] = [n, trial(n)]
            i += 1
        end
    end
    results
end

end


# Analysis and Plotting with DataFrames and Gadfly
# ------------------------------------------------
# 
# At this point we can look at the results of our estimations. In the following cells we'll use two [external packages](http://julia.readthedocs.org/en/latest/manual/packages/), [Gadfly](http://gadflyjl.org/index.html) a grammar-of-graphics based plotting library, and [DataFrames](http://dataframesjl.readthedocs.org/en/latest/), a package providing an interface similar to R's dataframes. Before we can use these external packages, we have to fetch and install them. Installing a package is a simple as calling `Pkg.add()`, passing in the name of the package. Note that packages can be found by searching for them at http://pkg.julialang.org/.
# 
# To plot the results of the `batch` trials we'll be creating a data frame, using the [DataFrame constructor](http://dataframesjl.readthedocs.org/en/latest/getting_started.html#the-dataframe-type). This will be passed in to the [plot](http://gadflyjl.org/#plot-invocations) function from gadfly, with a [Geom.point](http://gadflyjl.org/geom_point.html) geometry.
# 
# Along the way, we'll also print out some timing statistics, showing how quickly we're dealing with the large number of randomly distrubuted points we're using to estimate $\pi$.
# 
# This is the end of our analysis for this workbook, but this should give a solid grounding in how to use Julia, and let you jump off to lot of different and interesting topics.

# In[38]:

FindingPiSim.trial(1000000)


# In[27]:

Pkg.add("Gadfly")
Pkg.add("DataFrames")


# In[95]:

using Gadfly
using DataFrames

range = 100:10:1000
iterations = 5

total_points = sum(range) * iterations
println("$total_points points")
t1 = time()

res = FindingPiSim.batch(range, iterations)

t2 = time()
println("total time: $(t2 - t1)")
println("time per point: $((t2 - t1) / total_points)")

df = DataFrame(n=res[:, 1], pi_est=res[:, 2])
df[:error] = pi - df[:pi_est]

t = Theme(
    default_point_size=Compose.Measure(0.7),
    highlight_width=Compose.Measure(0.1)
)

# plot(df, x="n", y="pi_est", color="error", Geom.point)
plot(
    layer(x->3.1415, range[1], range[end]),
    layer(df, x="n", y="pi_est", color="error", Geom.point, t)
)

