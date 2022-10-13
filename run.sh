N=$1
TPB=$2

if [[ $# -eq 0 ]] ; then
    echo 'missing args'
    exit 0
fi

cd src/

g++ nocuda.cpp -o nocuda
time ./nocuda $N
nvcc cuda.cu -o cuda
time ./cuda $N $TPB

cd -
