function parse_git_dirty 
    git diff --quiet HEAD ^&-
    if test $status = 1
        echo (set_color $fish_git_dirty_color)"Δ"(set_color normal)
    end
end
