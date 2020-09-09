# EIPA
[電子インボイス推進協議会（英語名称：E-Invoice Promotion Association）](https://www.csaj.jp/activity/project/eipa.html)

## 目的
「電子インボイス推進協議会」において「日本の電子インボイス」の要件を整理することを目的とします。

## 作業
作業としては、欧州での電子インボイスの議論の内容を把握し、日本におけるユースケースをUMLで定義することを想定しています。 
そこで、協力いただける方としては、
* 欧州での議論の結果を取りまとめた欧州標準化委員会作業部会合意書[CWA 16460](EN規格/CWA_16460_翻訳.md)の内容確認を一緒に行っていただいたける方。
* 提供されているソフトウエアやサービスの電子インボイスと関係しそうな業務パターンをUMLで定義していただける方。（UMLの書き方は指導します）
を考えております。  

なお、[業務パターン](UML)については、事業者の中でどの職務の方がどんな書類や根拠に基づいてどういった処理で画面を入力し、モノやサービスの提供は何に基づいて行われ、請求書と入金の関係は誰がどうやって仕事をしているか、などがイメージできる方が望ましいと思います。  
また、日本での電子インボイスにおける ・適格請求書の交付/保管義務の適用シーン ・交付免除の適用シーンなど 法的要件（新消税法、電帳法など）と照らし合わせてプロセスの網羅性を見ていく必要もあると思います。

## 実施方法
定期的なWebミーティングとこの[GitHub環境](https://github.com/pontsoleil/EIPA)および[Googleドライブ](https://drive.google.com/drive/folders/15VG367MpVpIYHrzK43Ac89Lw3xcvB_nN)での文書のブラッシュアップを予定しています。

### その他
第2回の提言のご紹介では、次については、具体的にお話ししませんでした。  
* 標準フォーマットとデータ流通に係る**技術検討**
* 標準仕様の維持改訂等に係る**運用検討**  

欧州におけるEN規格(注1)](EN規格)[制定の歴史]を振り返ると、今世紀初頭からの電子政府の取り組みの中で電子インボイスの規格を制定するにあたり、実施上の課題について議論が重ねられ、2012年に合意書[CWA 16460](EN規格/CWA_16460_翻訳.md)が発行されました。  
電子インボイスを実現する上で、先行する欧州の活動を参考にして、課題を明らかにして整理するため翻訳しました。  

合意書では、電子インボイスの技術検討や運用検討を反映して、電子インボイスは次の3項目を満たすこととされています。   
-　発行元の**真正性**: 　発行元は、ほんとに今回の取引相手か？  
-　含まれる内容の**完全性**:　その内容は、実際の取引に対応した内容であり、改竄されていないか？  
-　**可読性**:　インボイスの視認性は？  

この**真正性**や**完全性**を実現するための実装方式の分類（クラス）と実装上の課題、あわせて考慮すべき、マスターデータやストレージ(注2)と監査能力などの課題も記載されており、**PEPPOL**や**ZUGFeRD**がどのクラスに位置づけられるかも記載されています。  
電子インボイスについてのCEN作業部会の合意書の要点抜粋は、[CWA 16460　抜粋](EU規格/CWA_16460_抜粋.md)  を確認してください。  
合意書には、**技術検討**や**運用検討**を反映した課題の具体例が記載されています。  
これらの課題を整理し、日本の法令や業務に合わせた全体像の合意を得ることが重要と考えます。

9月7日、8日にXBRL FinlandのElina Koskentalo氏とのZoom会議で、第2回でご紹介した北欧スマート政府プロジェクトや電子インボイスの実際の使用状況についてお聞きしました。  
[発表資料](XBRL%20JAPAN%E3%81%8B%E3%82%89%E3%81%AE%E6%8F%90%E8%A8%80/7.9.2020%20XBRL%20Finland%2C%20Elina%20Koskentalo)  
「電子インボイスは、[Real Time Economyプロジェクト](https://www.youtube.com/watch?v=eMDJAwHg5qM&feature=youtu.be)(2006~)の延長であり、今世紀初頭からの歴史がある。  
請求書を紙で郵送すると一件2.00EURかかるけど電子インボイスだと0.60EUR。  
電子インボイスに関連した会計不正のニュースは聞かないし、電子インボイスはいつも使っている会計ソフトの一機能に過ぎないので、みんなは特に意識せず、安心して使っている。」ということでした。  
日本でもそうでありたいと思います。  
紙の帳簿の山と電子インボイスを突き合わせて、という状態になると大変な作業です。  

XBRL Japan 顧問 [三分一信之](https://www.sambuichi.jp)

注1： EN規格は、CEN(欧州標準化委員会)やCENELEC(欧州電気標準化委員会)、ETSI(欧州通信規格協会)が発行する、欧州の統一規格です。加盟各国は、EN規格を自国の国家規格として採用することが義務付けられています。  
注2: 米国の「クラウド法」など民間企業が保有する電子通信データへの国境を超えたアクセスについての諸外国の法についても検討が必要。(参考：国立国会図書館 立法情報 外国の立法 No.278-1（2019.1） 国立国会図書館 調査及び立法考査局[【アメリカ】海外のデータの合法的使用を明確化する法律－クラウド法－](https://dl.ndl.go.jp/view/download/digidepo_11220541_po_02780102.pdf?contentNo=1) )  
