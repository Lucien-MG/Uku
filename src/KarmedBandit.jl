using Distributions, Random

struct KarmedBandit
    q_values
    KarmedBandit() = new([Normal(rand(1:21) - 11, 1) for i in 1:10])
end

function step!(karmedbandit:: KarmedBandit, action:: Int)
    return rand(karmedbandit.q_values[action], 1)[end]
end
