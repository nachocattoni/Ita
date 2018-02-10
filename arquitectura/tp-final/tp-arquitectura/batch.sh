#~/bin/bash
gcc *.c -o pilot-compiler
for i in `seq 1 $1`;
do
  ./pilot-compiler < "tests/test$i.txt" > "output/test_arm$i.s"
  echo "Se ha procesado el caso de prueba número: $i";
done
