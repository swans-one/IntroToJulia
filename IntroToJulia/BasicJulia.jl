# ### Built In Types
# - [Integers and Floating Point Numbers](http://docs.julialang.org/en/latest/manual/integers-and-floating-point-numbers/)
# - [Strings and Characters](http://docs.julialang.org/en/latest/manual/strings/)
# - [Arrays](http://docs.julialang.org/en/latest/manual/arrays/)
# - [Dictionaries](http://docs.julialang.org/en/latest/stdlib/collections/#associative-collections)

1 + 2.0
typeof(3.3)

println("Hello World")
println("1 + 2 is: $(1 + 2)")

'a'
'\u2603'
int('☃')

['a' 'b' 'c']

['a' 'b' 'c';
'd' 'e' 'f';]

[1, 2, 3]

Dict(:erik => "python",
     :justin => "ruby",
     :colin => "scala",
)

# ### Variables
# - [Variables](http://docs.julialang.org/en/latest/manual/variables/)
# - [Variables and Scope](http://docs.julialang.org/en/latest/manual/variables-and-scoping/)
# - [Type Assertions](http://julia.readthedocs.org/en/latest/manual/types/#type-declarations)

a = 7
erik = :erik
erik::Symbol
erik::Array


# ### Control Flow
# - [Control Flow](http://docs.julialang.org/en/latest/manual/control-flow/)
# - [List Comprehensions](http://docs.julialang.org/en/latest/manual/arrays/#comprehensions)

a = 3
if a > 4
    println("a is too big")
else
    println("a is $a")
end

x = 1 == 2 ? "yeah!" : "nope..."

for x = 1:3:10
    println(x)
end

o_count = 0
for x = "one two three"
    if x == 'o'
        o_count += 1
    end
end
o_count

[x^2 for x = 1:5]

["$x $y" for x = 1:3, y='a':'c']

# ### Functions
# - [Functions](http://docs.julialang.org/en/latest/manual/functions/)

function minimum(l)
    min = l[1]
    for x = l[2:end]
        min = min < x ? min : x
    end
    min
end
minimum([2, -3, 6, -4, 3])

f(x) = 2x
f(3)

((x, y) -> x + y)(2, 3)

map(c -> c + 2, "Hello")

filter(x -> x % 3 == 0, 1:10)
