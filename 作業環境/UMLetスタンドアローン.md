# 1. UMLet zipファイルをダウンロード(Mac OSの場合)

windowsでは、未確認です。

次のSOFTPEDIAを開き、UMLetの[DOWNLOAD NOW]ボタンをクリックします。<br>
https://www.softpedia.com/get/Programming/Other-Programming-Files/UMLet.shtml#download<br>
![SOFTPEDIAからダウンロード](図/umlet1.png)<br>
次の画面が開くので、広告の下の[External mirror 1]ボタンをクリックするとzipファイルのダウンロードが始まります。<br>
![zipファイルのダウンロード](図/umlet2.png)<br>
ダウンロードしたzipファイル umlet-standalone-14.3.0.zip を解凍します。<br>

# 2. ダウンロードファイルを解凍します

<code>
$ tree<br>
.<br>
├── LICENCE.txt<br>
├── Umlet.exe<br>
├── custom_elements<br>
│   ├── AutoResize1.java<br>
│   ├── AutoResize2.java<br>
│   ├── Default.java<br>
│   ├── RectangleRound.java<br>
│   └── WordWrap.java<br>
├── img<br>
│   └── umlet_logo.png<br>
├── lib<br>
│   ├── autocomplete-2.5.8.jar<br>
│   ├── batik-awt-util-1.8.jar<br>
│   ├── batik-dom-1.8.jar<br>
│   ├── batik-ext-1.8.jar<br>
│   ├── batik-svggen-1.8.jar<br>
│   ├── batik-util-1.8.jar<br>
│   ├── batik-xml-1.8.jar<br>
│   ├── bcel-5.2.jar<br>
│   ├── commons-io-2.4.jar<br>
│   ├── ecj-4.4.2.jar<br>
│   ├── itextpdf-5.4.1.jar<br>
│   ├── javaparser-core-2.3.0.jar<br>
│   ├── javax.mail-1.5.6.jar<br>
│   ├── jlibeps-0.1.jar<br>
│   ├── log4j-1.2.17.jar<br>
│   ├── rsyntaxtextarea-2.5.8.jar<br>
│   ├── slf4j-api-1.7.7.jar<br>
│   ├── slf4j-log4j12-1.7.13.jar<br>
│   ├── umlet-elements-14.3.0.jar<br>
│   └── umlet-swing-14.3.0.jar<br>
├── palettes<br>
│   ├── Custom\ Drawings.uxf<br>
│   ├── Deprecated\ UML\ Sequence\ -\ All\ in\ one.uxf<br>
│   ├── Generic\ Colors.uxf<br>
│   ├── Generic\ Layers.uxf<br>
│   ├── Generic\ Text\ and\ Alignment.uxf<br>
│   ├── Plots.uxf<br>
│   ├── UML\ Activity\ -\ All\ in\ one.uxf<br>
│   ├── UML\ Activity.uxf<br>
│   ├── UML\ Class.uxf<br>
│   ├── UML\ Common\ Elements.uxf<br>
│   ├── UML\ Composite\ Structure.uxf<br>
│   ├── UML\ Package.uxf<br>
│   ├── UML\ Sequence\ -\ All\ in\ one.uxf<br>
│   ├── UML\ Sequence.uxf<br>
│   ├── UML\ State\ Machine.uxf<br>
│   ├── UML\ Structure\ and\ Deployment.uxf<br>
│   ├── UML\ Timing\ Diagram.uxf<br>
│   └── UML\ Use\ Case.uxf<br>
├── umlet.desktop<br>
├── umlet.jar<br>
└── umlet.sh<br>
</code>
<br>
4 directories, 49 files<br>

# 3. umlet.jarに実行権限を与えて実行します

<code>
$ chmod +x umlet.jar
</code>
<br>
javaプログラムを起動するとUMLetの画面が開きます。<br>
<code>
$ java -jar ./umlet.jar
</code>

# 4. UMLetから画像ファイルをエキスポートする

バージョン14では、utfファイルを開いて画面にUML図が表示されている状態で[FILE/Export as.../SVG...]を実行するとSVGファイルをエキスポートできます。<br>
![画像ファイルをエキスポート](図/umlet3.png)<br>

以上です。<br>
