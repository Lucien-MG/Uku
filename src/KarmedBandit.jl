function gauss(x, sig, mu)
    return (1/(sig*sqrt(2*3.14))) * exp(-(((x - mu)**2) / (2 * sig**2)))
end

struct KarmedBandit
    q_values
    KarmedBandit() = new([Normal(2, 1) for i in 1:10])
end

function step!(karmedbandit:: KarmedBandit, action:: Int)
    return rand(karmedbandit.q_values[action], 1)
end
