struct KarmedBandit
    nb_arms::Int64
    initial_variance::Float64

    expected_rewards::Vector{Float64}

    KarmedBandit(nb_arms, initial_variance=1) = new(nb_arms, initial_variance, randn(nb_arms) * initial_variance)
end

function step(karmedbandit:: KarmedBandit, action:: Int)
    reward = karmedbandit.expected_rewards[action] + randn(1)[1]
    return reward, reward
end

function reset_env(karmedbandit:: KarmedBandit)
    karmedbandit.expected_rewards .= randn(Float64, karmedbandit.nb_arms) .* karmedbandit.initial_variance
    return 0.0
end
