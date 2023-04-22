function train_sampled = CreateSamples(train,section_len)
    start = 1;
    finish = section_len;
    train_sampled = [];
    while true
        train_sampled = [train_sampled, train(start:finish)];
        start = start + section_len;
        finish = finish + section_len;
        if finish > length(train)
            break
        end
    end
end