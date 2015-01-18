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

end


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

# Analysis with Gadfly and DataFrames
# -----------------------------------

FindingPiSim.trial(1000000)

Pkg.add("Gadfly")
Pkg.add("DataFrames")

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

# A simple plot:
plot(df, x="n", y="pi_est", color="error", Geom.point)

# A more complex plot, with a theme for point size,
# and a layer to mark the true value of pi with a line:
#
# t = Theme(
#     default_point_size=Compose.Measure(0.7),
#     highlight_width=Compose.Measure(0.1)
# )
#
# plot(
#     layer(x->3.1415, range[1], range[end]),
#     layer(df, x="n", y="pi_est", color="error", Geom.point, t)
# )
