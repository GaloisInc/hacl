for prover in abc cvc4 yices z3 picosat ; do
    ./set_prover.sh ${prover} < aes-prover.saw > _tmp_aes-${prover}.saw
    gtimeout 1500 ${SAW} _tmp_aes-${prover}.saw 2>&1 | tee aes-${prover}.log
    rm -f _tmp_aes-${prover}.saw
done
