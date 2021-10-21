# テキストファイルから電子インボイスを作成 (Phyton)

## テキストファイルについて

### 階層構造のあるデータ

![Fig 1][1]

３つの表が関連する階層構造のあるデータ。Party(組織)は、住所(Address)と担当者(Contact)情報を下位に持つ階層構造。このデータを一つの表で表すことを目的とする。
Party(組織)、住所(Address)、担当者(Contact)は、それぞれ、Business term GroupとしてのID、BG-0, BG-1, BG-2が定義され、Business TermとしてBT-1 ~ BT-9が定義されている。

![Fig 2][2]

### 階層構造のあるデータを表で表現する
欄を２つの領域、Business term groupとしてのIDを指定する領域とBusiness TermとしてBT-1 ~ BT-9の値を指定する領域に分ける。

![Fig 3][3]

Business term groupとしてのIDを指定する領域では、IDと出現順の番号を指定する。Party(組織) BG-0が、３個なので、それぞれに番号、0 1 2を指定する。Party(組織)BG-0の下位の住所(Address)BG-1は、繰り返しがないので順序番号は、記入しない。担当者(Contact)BG-2は、繰り返しがあるので、番号を0 1 ...と定義する。その階層に所属するBusiness Termのセルにその階層での値を記入する。

![Fig 4][4]

この形式の表現では、同じ構造のBusiness term Groupを同じ欄に繰り返して記入するので、関係データベースのように複数の表を使用する必要がなく、担当者など同じ構造が繰り返される場合でも欄を増やして記入しなくて良い。

[1]:fig/1.png
[2]:fig/2.png
[3]:fig/3.png
[4]:fig/4.png

## プログラムの実行

$ ./genInvoice infile -o outfile -e encoding -t -v
- infile 入力ファイル(.tsv)   
- outfile 出力ファイル(.xml)  
- -e (--encoding) 入力ファイルのエンコーディングを指定する。省略時は、UTF-8  
- -t 行列の入れ替え。指定しないときには、入力ファイルは、先頭行が項目ID。指定時は、最初の欄に項目IDのファイルを行列入れ替えて処理する。  
- -v 処理状況を標準出力に出力する  

$ ./invoice2tsv infile -o outfile -e encoding -v
- infile 入力ファイル(.xml)   
- outfile 出力ファイル(.tsv)  
- -e (--encoding) 入力ファイルのエンコーディングを指定する。省略時は、UTF-8  
- -v 処理状況を標準出力に出力する  

## ディレクトリ階層

```
.
├── csv2invoice
├── data
│   ├── common
│   │   ├── uncl4451.txt
│   │   └── xpath.csv
│   ├── in
│   │   ├── ubl-tc434-example1.xml
│   │   ├── ubl-tc434-example2.xml
...
│   │   └── ubl-tc434-example9.xml
│   ├── out
│   │   ├── ubl-tc434-example1.csv
│   │   ├── ubl-tc434-example1.txt
│   │   ├── ubl-tc434-example1.xml
│   │   ├── ubl-tc434-example2.csv
│   │   ├── ubl-tc434-example2.txt
│   │   ├── ubl-tc434-example2.xml
...
│   │   ├── ubl-tc434-example9.csv
│   │   ├── ubl-tc434-example9.txt
│   │   └── ubl-tc434-example9.xml
├── dic2etree
│   ├── __init__.py
│   ├── __pycache__
│   │   ├── __init__.cpython-36.pyc
│   │   └── dic2etree.cpython-36.pyc
│   └── dic2etree.py
└── invoice2csv

```

## 参考
https://stackoverflow.com/questions/7684333/converting-xml-to-dictionary-using-elementtree
https://stackoverflow.com/questions/15210148/get-parents-keys-from-nested-dictionary

XML出力は、xml.etree.ElementTreeを使用しました。
