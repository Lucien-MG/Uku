module Uku

using DelimitedFiles

# Envs
include("environments/karmedbandit/KArmedBandit.jl")
include("environments/karmedbandit/KarmedBanditNonStationary.jl")

include("environments/toytext/Gridworld.jl")
include("environments/toytext/CliffWalking.jl")
include("environments/toytext/Blackjack.jl")
include("environments/toytext/WindyGridworld.jl")

# Agents
include("reinforcement-learning/tabular/EGreedy.jl")
include("reinforcement-learning/tabular/EGreedyMean.jl")
include("reinforcement-learning/tabular/GradientBandit.jl")
include("reinforcement-learning/tabular/UCB.jl")
include("reinforcement-learning/tabular/UCBMean.jl")

include("reinforcement-learning/temporal-difference/Sarsa.jl")
include("reinforcement-learning/temporal-difference/Qlearning.jl")

include("reinforcement-learning/human/HumanAgent.jl")

function play_env(env, agent)
    index_reward, index_step = 0, 1

    state, finished = reset(env), false
    previous_state = copy(state)

    while !finished
        action = policy(agent, state)

        state, reward, finished = step(env, action)

        learn(agent, previous_state, state, action, reward)

        previous_state .= state

        index_reward += reward
        index_step += 1
    end

    return index_reward, index_step
end

function run_episodes(name, env, agent, nb_runs)
    reward_by_episode = zeros(nb_runs)
    nb_steps_by_episode = zeros(nb_runs)

    for i in 1:nb_runs
        episode_reward, steps_played = play_env(env, agent)

        reward_by_episode[i] = episode_reward
        nb_steps_by_episode[i] = steps_played
    end

    return name, reward_by_episode, nb_steps_by_episode
end

function save_experiences(results_exps)
    open("data/rewards.csv", "w") do io
        write(io, join([results_exps[i][1] for i=1:length(results_exps)], "\t") * "\n")
    end

    open("data/rewards.csv", "a") do io
        writedlm(io, hcat([results_exps[i][2] for i=1:length(results_exps)]...))
    end

    open("data/steps_by_episode.csv", "w") do io
        write(io, join([results_exps[i][1] for i=1:length(results_exps)], "\t") * "\n")
    end

    open("data/steps_by_episode.csv", "a") do io
        writedlm(io, hcat([results_exps[i][3] for i=1:length(results_exps)]...))
    end
end

function run_experiments(nb_runs, experiences)
    results_exps = []

    Threads.@threads for exp in experiences
        # Experience title
        println(Threads.threadid(), ": ", exp["name"], " - running")
    
        # Run experiences
        @time results = run_episodes(exp["name"], exp["env"], exp["agent"], nb_runs)

        # Store experiences's results
        push!(results_exps, results)
    end

    return results_exps
end

# function generate_parameters_study(name, env, agent, parameters)
#     experiences = []

#     for i in 1:length(parameters)
#         exp = (name * string(parameters[i]), KarmedBandit(10), agent(parameters[i], 0.1, 10, 4))
#         # push!(experiences, exp)
#     end

#     return experiences
# end

nb_runs = 300

# experiences = [
#         ("epsilon-0.0", KArmedBandit(nb_actions), EGreedyMean(0, nb_actions)),
#         ("epsilon-0.0-optimistic", KArmedBandit(nb_actions), EGreedy(0, 0.1, nb_actions, 5)),
#         ("epsilon-0.1-mean", KArmedBandit(nb_actions), EGreedyMean(0.1, nb_actions)),
#         ("epsilon-0.1-alpha", KArmedBandit(nb_actions), EGreedy(0.1, 0.15, nb_actions)),
#         ("epsilon-0.01-mean", KArmedBandit(nb_actions), EGreedyMean(0.01, nb_actions)),
#         ("epsilon-0.01-alpha", KArmedBandit(nb_actions), EGreedy(0.01, 0.15, nb_actions)),
#         ("ucb-c_2-alpha_0.1", KArmedBandit(nb_actions), UCB(2, 0.1, nb_actions)),
#         ("ucb-mean-c_2", KArmedBandit(nb_actions), UCBMean(2, nb_actions)),
#         ("gradientbandit-0.1", KArmedBandit(nb_actions), GradientBandit(0.01, nb_actions)),
# ]

# experiences = [
#         ("epsilon-0.0", KarmedBanditNonStationary(nb_actions), EGreedyMean(0, nb_actions)),
#         ("epsilon-0.0-optimistic", KarmedBanditNonStationary(nb_actions), EGreedy(0, 0.1, nb_actions, 5)),
#         ("epsilon-0.1-mean", KarmedBanditNonStationary(nb_actions), EGreedyMean(0.1, nb_actions)),
#         ("epsilon-0.1-alpha", KarmedBanditNonStationary(nb_actions), EGreedy(0.1, 0.15, nb_actions)),
#         ("epsilon-0.01-mean", KarmedBanditNonStationary(nb_actions), EGreedyMean(0.01, nb_actions)),
#         ("epsilon-0.01-alpha", KarmedBanditNonStationary(nb_actions), EGreedy(0.01, 0.15, nb_actions)),
#         ("ucb-c_2-alpha_0.1", KarmedBanditNonStationary(nb_actions), UCB(2, 0.1, nb_actions)),
#         ("ucb-mean-c_2", KarmedBanditNonStationary(nb_actions), UCBMean(2, nb_actions)),
#         ("gradientbandit-0.1", KarmedBanditNonStationary(10), GradientBandit(0.01, 10)),
# ]

experiences = [
    # Dict("name" => "Qlearning-Grid", "env" => WindyGridworld(), "agent" => Qlearning(0.1, 0.5, 0.9, 4)),
    # Dict("name" => "Qlearning-Cliff", "env" => CliffWalking(), "agent" => Qlearning(0.1, 0.5, 0.9, 4)),
    # Dict("name" => "Qlearning-Blackjack", "env" => Blackjack(), "agent" => Qlearning(0.1, 0.5, 0.9, 4)),
    Dict("name" => "Human", "env" => Blackjack(), "agent" => HumanAgent()),
]

# experiences = generate_parameters_study("epsilon-", KarmedBandit(10), EGreedy, 0:0.1:0.5)

results_exps = run_experiments(nb_runs, experiences)

save_experiences(results_exps)

end # module Uku
