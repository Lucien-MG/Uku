struct KarmedBanditNonStationary
    q_values
    KarmedBanditNonStationary() = new(randn(10) .* 1.5)
end

function step(karmedbandit:: KarmedBanditNonStationary, action:: Int)
    random_values = randn(2)

    reward = karmedbandit.q_values[action] + random_values[1]
    karmedbandit.q_values[action] += random_values[2] * 0.1

    return reward
end
