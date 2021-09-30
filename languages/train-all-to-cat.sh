#!/bin/bash

declare -a arr=("ita-cat" "fra-cat" "spa-cat" "por-cat" "eng-cat" "deu-cat" "nld-cat")
#declare -a arr=("fra-cat")

for dirname in "${arr[@]}"; do
    echo Processing $dirname
    pushd $dirname
    # Don at pre-process-all.sh
    #./preprocess.sh
    ./voc.sh
    ./train.sh
    ./export.sh
    popd
done


