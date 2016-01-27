sed -e "s/let proof_wrap t =.*/let proof_wrap t = do { print_goal_size; $1; };/"
