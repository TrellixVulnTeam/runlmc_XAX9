#!/bin/bash

rm -f /tmp/err

eps="1e-1"

if [ -z "$1" ]; then
    kern="mix"
else
    kern="$1"
fi

echo 'N=4000 R=1 D=10 Q=10 SMALL RANK -> SLFM is best'
PYTHONPATH=. python3 benchmarks/bench.py 400 10 1 10 $eps $kern 1234 inversion > /tmp/out 2>>/tmp/err
head -n1 /tmp/out
tail -n5 /tmp/out

echo 'N=4000 R=10 D=10 Q=1 SMALL SUM -> SUM is best' # move to high-rank
PYTHONPATH=. python3 benchmarks/bench.py 400 10 10 1 $eps $kern 1234 inversion > /tmp/out 2>>/tmp/err
head -n1 /tmp/out
tail -n5 /tmp/out

echo 'N=4000 R=10 D=2 Q=1 SMALL DIM -> BT is best' # move to high-rank
PYTHONPATH=. python3 benchmarks/bench.py 2000 2 1 10 $eps $kern 1234 inversion > /tmp/out 2>>/tmp/err
head -n1 /tmp/out
tail -n5 /tmp/out

echo 'N=4000 R=4 D=4 Q=4 GRADIENTS'
PYTHONPATH=. python3 benchmarks/bench.py 1000 4 1 4 $eps $kern 1234 gradients > /tmp/out 2>>/tmp/err
head -n1 /tmp/out
grep -A 4 "matrix materialization" /tmp/out
tail -n6 /tmp/out

if [ -s /tmp/err ]; then
    echo
    echo 'ERRORS OCCURRED, printing file /tmp/err'
    cat /tmp/err
fi