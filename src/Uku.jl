module Uku

using DelimitedFiles

include("environments/KarmedBandit.jl")
include("environments/KarmedBanditNonStationary.jl")

include("reinforcement-learning/EGreedy.jl")
include("reinforcement-learning/EGreedyMean.jl")
include("reinforcement-learning/GradientBandit.jl")
include("reinforcement-learning/UCB.jl")

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

function run_testbed_experiments(nb_runs, nb_steps, experiences)
    running_exps = []

    Threads.@threads for i in 1:length(experiences)
        thread = testbed_karmed(experiences[i][1], experiences[i][2], experiences[i][3], nb_runs, nb_steps)
        push!(running_exps, thread)
    end

    results_exps = [fetch(running_exps[i]) for i=1:length(running_exps)]

    save_experiences(results_exps)
end

function generate_parameters_study(name, env, agent, parameters)
    experiences = []

    for i in 1:length(parameters)
        exp = (name * string(parameters[i]), KarmedBandit(10), agent(parameters[i], 0.1, 10, 4))
        push!(experiences, exp)
    end

    return experiences
end

nb_actions = 10
nb_runs = 2000
nb_steps = 10000

experiences = [
        #("gradientbandit-0.1", KarmedBanditNonStationary(10), GradientBandit(0.01, 10)),
        ("epsilon-0.0", KarmedBanditNonStationary(nb_actions), EGreedyMean(0.0, nb_actions)),
        ("epsilon-0.1-mean", KarmedBanditNonStationary(nb_actions), EGreedyMean(0.1, nb_actions)),
        ("epsilon-0.1-alpha", KarmedBanditNonStationary(nb_actions), EGreedy(0.1, 0.15, nb_actions)),
        #("ucb", KarmedBandit(10), UCB(2, 0.1, 10)),
]

# experiences = generate_parameters_study("epsilon-", KarmedBandit(10), EGreedy, 0:0.1:0.5)

run_testbed_experiments(nb_runs, nb_steps, experiences)
#testbed_karmed(KarmedBanditNonStationary(10, 2, 0.1), EGreedy(0.1, 0.1, 10), 100, 1000)
#testbed_karmed(KarmedBanditNonStationary(10, 2, 0.1), EGreedy(0.1, 0.1, 10), 100, 1000)

end # module Uku
