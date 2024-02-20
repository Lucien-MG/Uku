struct KarmedBandit
    q_values
    KarmedBandit() = new(randn(10) .* 1.5)
end

function step(karmedbandit:: KarmedBandit, action:: Int)
    return karmedbandit.q_values[action] + randn(1)[1]
end
