using Richardson, Test

@testset "basic tests" begin
    X = Float64[]
    val, err = extrapolate(1.0, rtol=1e-10, contract=0.1) do x
        push!(X, x)
        sin(x)/x
    end
    @test val ≈ 1 rtol=1e-10
    @test err < 1e-10
    @test all(x -> x > 0, X)
    @test length(X) == 6

    empty!(X)
    val, err = extrapolate(-1.0, rtol=1e-10, contract=0.1) do x
        push!(X, x)
        sin(x)/x
    end
    @test val ≈ 1 rtol=1e-10
    @test err < 1e-10
    @test all(x -> x < 0, X)
    @test length(X) == 6

    empty!(X)
    val, err = extrapolate(1.0, x0=Inf) do x
        push!(X, x)
        (x^2 + 3x - 2) / (x^2 + 5)
    end
    @test val ≈ 1 rtol=1e-12
    @test err < 1e-10
    @test length(X) == 7

    # make sure this terminates rather than looping on NaN values
    val, err = extrapolate(x -> log(x)/sqrt(x-1), 0.2, x0=1.0)
    @test abs(val) < 1e-6 && abs(err) < 1e-6
end