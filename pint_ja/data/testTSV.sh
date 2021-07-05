./invoice2tsv data/in/discount.xml -o data/out/discount.tsv -e Shift_JIS -v
./invoice2tsv data/in/allowance1.xml -o data/out/allowance1.tsv -e Shift_JIS -v
./invoice2tsv data/in/allowance2.xml -o data/out/allowance2.tsv -e Shift_JIS -v

./invoice2tsv data/in/ubl-tc434-example1.xml -o data/out/ubl-tc434-example1.tsv -e Shift_JIS -v
./invoice2tsv data/in/ubl-tc434-example2.xml -o data/out/ubl-tc434-example2.tsv -e Shift_JIS -v
./invoice2tsv data/in/ubl-tc434-example3.xml -o data/out/ubl-tc434-example3.tsv -e Shift_JIS -v
./invoice2tsv data/in/ubl-tc434-example4.xml -o data/out/ubl-tc434-example4.tsv -e Shift_JIS -v
./invoice2tsv data/in/ubl-tc434-example5.xml -o data/out/ubl-tc434-example5.tsv -e Shift_JIS -v
./invoice2tsv data/in/ubl-tc434-example6.xml -o data/out/ubl-tc434-example6.tsv -e Shift_JIS -v
./invoice2tsv data/in/ubl-tc434-example7.xml -o data/out/ubl-tc434-example7.tsv -e Shift_JIS -v
./invoice2tsv data/in/ubl-tc434-example8.xml -o data/out/ubl-tc434-example8.tsv -e Shift_JIS -v
./invoice2tsv data/in/ubl-tc434-example9.xml -o data/out/ubl-tc434-example9.tsv -e Shift_JIS -v

./genInvoice data/out/discount.tsv -o data/out/discount.xml -e Shift_JIS -t -v
./genInvoice data/out/allowance1.tsv -o data/out/allowance1.xml -e Shift_JIS -t -v
./genInvoice data/out/allowance2.tsv -o data/out/allowance2.xml -e Shift_JIS -t -v

./genInvoice data/out/ubl-tc434-example1.tsv -o data/out/ubl-tc434-example1.xml -e Shift_JIS -t -v
./genInvoice data/out/ubl-tc434-example2.tsv -o data/out/ubl-tc434-example2.xml -e Shift_JIS -t -v
./genInvoice data/out/ubl-tc434-example3.tsv -o data/out/ubl-tc434-example3.xml -e Shift_JIS -t -v
./genInvoice data/out/ubl-tc434-example4.tsv -o data/out/ubl-tc434-example4.xml -e Shift_JIS -t -v
./genInvoice data/out/ubl-tc434-example5.tsv -o data/out/ubl-tc434-example5.xml -e Shift_JIS -t -v
./genInvoice data/out/ubl-tc434-example6.tsv -o data/out/ubl-tc434-example6.xml -e Shift_JIS -t -v
./genInvoice data/out/ubl-tc434-example7.tsv -o data/out/ubl-tc434-example7.xml -e Shift_JIS -t -v
./genInvoice data/out/ubl-tc434-example8.tsv -o data/out/ubl-tc434-example8.xml -e Shift_JIS -t -v
./genInvoice data/out/ubl-tc434-example9.tsv -o data/out/ubl-tc434-example9.xml -e Shift_JIS -t -v


./invoice2tsv data/in/ubl-tc434-example2.xml -o data/out/ubl-tc434-example2.tsv -e Shift_JIS -v
./genInvoice data/out/ubl-tc434-example2.tsv -o data/out/ubl-tc434-example2.xml -e Shift_JIS -t -v
