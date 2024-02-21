struct KarmedBanditNonStationary
    nb_arms
    initial_variance

    variance
    q_values

    KarmedBanditNonStationary(nb_arms, initial_variance, variance) = new(nb_arms, initial_variance, variance, randn(nb_arms) .* initial_variance)
end

function step(karmedbandit:: KarmedBanditNonStationary, action:: Int)
    reward = karmedbandit.q_values[action] + randn(Float64, 1)[1]
    karmedbandit.q_values .+= randn(karmedbandit.nb_arms) * karmedbandit.variance
    return reward
end

function reset_env(karmedbandit:: KarmedBanditNonStationary)
    karmedbandit.q_values .= randn(karmedbandit.nb_arms) .* karmedbandit.initial_variance
end
