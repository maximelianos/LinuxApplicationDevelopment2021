# Mess up delete infile after transfer

rm -f myfile2.tmp
cp myfile1.back.tmp myfile1.tmp
testname=$(basename "$0") # get filename
testname="${testname#*-}" # split by -
testname="${testname%.*}" # split by .

strace -y -e trace=\!mmap,mprotect,munmap -e fault=unlink -o strace-${testname}.log ./move myfile1.tmp myfile2.tmp
ret=$?
if [ "$ret" -ne "6" ]; then
    echo "Expected return code 6, got $ret"
    exit 1
fi
if [ ! -f "myfile1.tmp" ]; then
    echo "infile does not exist"
    exit 1
fi
if [ ! -f "myfile2.tmp" ]; then
    echo "outfile does not exist"
    exit 1
fi
diff myfile1.back.tmp myfile2.tmp
if [ "$?" -ne "0" ]; then
    echo "Files differ after moving"
    exit 1
fi