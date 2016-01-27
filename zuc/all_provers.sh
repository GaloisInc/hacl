for prover in abc yices z3 picosat ; do
    ./set_prover.sh ${prover} < zuc-equiv.saw > _tmp_zuc-${prover}.saw
    ${SAW} _tmp_zuc-${prover}.saw 2>&1 | tee zuc-${prover}.log
    rm -f _tmp_zuc-${prover}.saw
done
