struct KarmedBandit
    q_values

    KarmedBandit() = new((rand(Float64, 10) .* 3.) .- 1.5)
end

function step(karmedbandit:: KarmedBandit, action:: Int)
    return karmedbandit.q_values[action] + (rand(Float64, 1)[end] * 1.5) - 1
end
