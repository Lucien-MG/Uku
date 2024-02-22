module Uku

using DelimitedFiles

include("environments/KarmedBandit.jl")
include("environments/KarmedBanditNonStationary.jl")

include("reinforcement-learning/EGreedy.jl")
include("reinforcement-learning/EGreedyUCB.jl")

function play_env(env, agent, nb_steps, mean_rewards::Array{Float64}, optimal_moves::Array{Float64})
    reset_agent(agent)
    reset_env(env)

    for i=1:nb_steps
        action = policy(agent)
        reward = step(env, action)

        learn(agent, action, reward)

        mean_rewards[i] += reward
        optimal_moves[i] += (action == argmax(env.expected_rewards))::Bool
    end
end

function testbed_karmed(name, env, agent, nb_runs, nb_steps)
    mean_rewards = zeros(nb_steps)
    optimal_moves = zeros(nb_steps)

    for i=1:nb_runs
        play_env(env, agent, nb_steps, mean_rewards, optimal_moves)
    end

    mean_rewards .= mean_rewards ./ nb_runs
    optimal_moves .= (optimal_moves .* 100) ./ nb_runs

    return name, mean_rewards, optimal_moves
end

function save_experiences(results_exps)
    open("data/rewards.csv", "w") do io
        write(io, join([results_exps[i][1] for i=1:length(results_exps)], "\t") * "\n")
    end

    open("data/rewards.csv", "a") do io
        writedlm(io, hcat([results_exps[i][2] for i=1:length(results_exps)]...))
    end

    open("data/optimal_actions.csv", "w") do io
        write(io, join([results_exps[i][1] for i=1:length(results_exps)], "\t") * "\n")
    end

    open("data/optimal_actions.csv", "a") do io
        writedlm(io, hcat([results_exps[i][3] for i=1:length(results_exps)]...))
    end
end

function run_testbed_experiments()
    nb_runs = 2000
    nb_steps = 10000

    running_exps = []

    # experiences = [
    #     ("epsilon-0.1", KarmedBanditNonStationary(10, 2, 0.1), EGreedy(0.1, 0.1, 10)),
    #     ("epsilon-0.01", KarmedBanditNonStationary(10, 2, 0.1), EGreedy(0.01, 0.1, 10)),
    #     ("epsilon-0.0", KarmedBanditNonStationary(10, 2, 0.1), EGreedy(0.0, 0.1, 10)),
    #     ("epsilon-0.1-optimistic", KarmedBanditNonStationary(10, 2, 0.1), EGreedy(0.1, 0.1, 10, 5)),
    #     ("epsilon-0.01-optimistic", KarmedBanditNonStationary(10, 2, 0.1), EGreedy(0.1, 0.1, 10, 5))
    # ]

    # experiences = [
    #     ("epsilon-0.1", KarmedBandit(10, 1.5), EGreedy(0.1, 0.1, 10)),
    #     ("epsilon-0.01", KarmedBandit(10, 1.5), EGreedy(0.01, 0.1, 10)),
    #     ("epsilon-0.0", KarmedBandit(10, 1.5), EGreedy(0.0, 0.1, 10)),
    #     ("epsilon-0.1-optimistic", KarmedBandit(10, 1.5), EGreedy(0.1, 0.1, 10, 5)),
    #     ("epsilon-0.01-optimistic", KarmedBandit(10, 1.5), EGreedy(0.1, 0.1, 10, 5))
    # ]

    experiences = [
        ("epsilon-0.1", KarmedBanditNonStationary(10), EGreedy(0.1, 0.1, 10)),
        ("epsilon-0.0-opt", KarmedBanditNonStationary(10), EGreedy(0.0, 0.1, 10, 5)),
        ("epsilon-0.1-opt", KarmedBanditNonStationary(10), EGreedy(0.1, 0.1, 10, 5)),
        ("epsilon-ucb", KarmedBanditNonStationary(10), EGreedyUCB(2, 0.1, 10, 0)),
    ]

    Threads.@threads for i in 1:length(experiences)
        thread = testbed_karmed(experiences[i][1], experiences[i][2], experiences[i][3], nb_runs, nb_steps)
        push!(running_exps, thread)
    end

    results_exps = [fetch(running_exps[i]) for i=1:length(running_exps)]

    save_experiences(results_exps)
end

run_testbed_experiments()
#testbed_karmed(KarmedBanditNonStationary(10, 2, 0.1), EGreedy(0.1, 0.1, 10), 100, 1000)
#testbed_karmed(KarmedBanditNonStationary(10, 2, 0.1), EGreedy(0.1, 0.1, 10), 100, 1000)

end # module Uku
