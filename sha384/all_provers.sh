for prover in cvc4 ; do
    ./set_prover.sh ${prover} < sha384.saw > _tmp_sha384-${prover}.saw
    gtimeout 1500 ${SAW} -j core-1.51-b08.jar -j rt.jar _tmp_sha384-${prover}.saw 2>&1 | tee sha384-${prover}.log
    rm -f _tmp_sha384-${prover}.saw
done
