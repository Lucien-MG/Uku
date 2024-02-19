module Uku

using DelimitedFiles

include("environments/KarmedBandit.jl")
include("reinforcement-learning/EGreedy.jl")

function play_karmed(karmedbandit, egreedy, nb_steps)
    all_rewards = []
    optimal_moves = []

    for i=1:nb_steps
        action = policy(egreedy)

        reward = step(karmedbandit, action)

        learn(egreedy, action, reward)

        append!(all_rewards, reward)
        append!(optimal_moves, action == argmax(karmedbandit.q_values))
    end
    
    return all_rewards, optimal_moves
end

function testbed_karmed(nb_runs, nb_steps, epsilon, alpha, nb_actions)
    karmedbandit = KarmedBandit()
    egreedy = Egreedy(epsilon, alpha, nb_actions)

    rewards, optimal_moves = play_karmed(karmedbandit, egreedy, nb_steps)

    for i=1:nb_runs
        karmedbandit = KarmedBandit()
        egreedy = Egreedy(epsilon, alpha, nb_actions)

        env_rewards, env_optimal_moves = play_karmed(karmedbandit, egreedy, nb_steps)
        rewards .+= env_rewards
        optimal_moves .+= env_optimal_moves
    end

    # Mean
    rewards .= rewards ./ nb_runs
    optimal_moves .= (optimal_moves .* 100) ./ nb_runs

    return rewards, optimal_moves
end

nb_runs = 2000
nb_steps = 5000

rewards_1, optimal_moves_1 = testbed_karmed(nb_runs, nb_steps, 0.1, 0.1, 10)
rewards_2, optimal_moves_2 = testbed_karmed(nb_runs, nb_steps, 0.01, 0.1, 10)
rewards_3, optimal_moves_3 = testbed_karmed(nb_runs, nb_steps, 0.0, 0.1, 10)

open("data/epsilon.csv", "w") do io
    write(io, "epsilon-0.1\tepsilon-0.01\tepsilon-0.0\n")
end

open("data/epsilon.csv", "a") do io
    writedlm(io, hcat(rewards_1, rewards_2, rewards_3))
end

open("data/optimal.csv", "w") do io
    write(io, "epsilon-0.1\tepsilon-0.01\tepsilon-0.0\n")
end

open("data/optimal.csv", "a") do io
    writedlm(io, hcat(optimal_moves_1, optimal_moves_2, optimal_moves_3))
end

end # module Uku
