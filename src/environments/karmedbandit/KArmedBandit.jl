struct KArmedBandit
    nb_arms::Int64
    variance::Float64

    expected_rewards::Vector{Float64}

    function KArmedBandit(nb_arms, variance=1)
        return new(nb_arms, variance, randn(nb_arms) * variance)
    end
end

function step(karmedbandit::KArmedBandit, action::Int)
    reward = karmedbandit.expected_rewards[action] + randn(1)[end]
    return reward, reward, false
end

function reset(karmedbandit::KArmedBandit)::Float64
    karmedbandit.expected_rewards .= randn(Float64, karmedbandit.nb_arms) .* karmedbandit.variance
    return 0.0
end
