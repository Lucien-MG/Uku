struct Environment
end

function step(env:: Environment)
    random_var = (rand(Float32, 1)[end] * 2) - 1
    return karmedbandit.q_values[action] + random_var
end
