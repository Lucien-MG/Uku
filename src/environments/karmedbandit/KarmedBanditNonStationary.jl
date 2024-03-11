struct KarmedBanditNonStationary
    nb_arms::Int64
    initial_variance::Float64

    variance::Float64
    expected_rewards::Vector{Float64}

    KarmedBanditNonStationary(nb_arms, initial_variance=1, variance=0.1) = new(nb_arms, initial_variance, variance, randn(Float64, nb_arms) .* initial_variance)
end

function step(karmedbandit:: KarmedBanditNonStationary, action::Int64)
    reward = karmedbandit.expected_rewards[action] + randn(Float64, 1)[1]
    karmedbandit.expected_rewards .+= randn(Float64, karmedbandit.nb_arms) * karmedbandit.variance
    return reward
end

function reset_env(karmedbandit:: KarmedBanditNonStationary)
    karmedbandit.expected_rewards .= randn(Float64, karmedbandit.nb_arms) .* karmedbandit.initial_variance
end
