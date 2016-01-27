for prover in abc yices z3 picosat cvc4 ; do
    ./set_prover.sh ${prover} < ecdsa-prover.saw > _tmp_ecdsa-${prover}.saw
    gtimeout 1500 ${SAW} -j rt.jar -j ecdsa.jar _tmp_ecdsa-${prover}.saw 2>&1 | tee ecdsa-${prover}.log
    rm -f _tmp_ecdsa-${prover}.saw
done
