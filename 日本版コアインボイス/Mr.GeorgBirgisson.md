Dear Mr. Nobuyuki Sambuichi
 
Thank you for this very interesting information and thank you also for the discussions in the web meeting . I would like to take some time later to properly analyse these requirements and compare  in detail to what can be done in Peppol but will now try to give a quick response. Please bear with me, I am giving my response based on my understanding of the requirements which may of course be incorrect so feel free to correct me.
 
Regarding the NTA required information. This is quite similar to the requirements that are made in Europe. Requirement 1 and 2 seems to allow identifying parties by either name or id number. The id number approach is common in EDI but in Peppol the name is used as the common denominator to reduce the need for prior exchange of master data for the identifiers. Peppol XML nevertheless supports the use of identifiers in the same way as is used in EDI. 3 and 4 seem to be the same. I am not sure I understand the difference between 5 and 6 but the concept of reporting the taxable amounts for different tax rates and the applied tax is supported but the calculation rules may be different but that can be handled in a similar way as with Singapore or by using the Peppol International Invoice.
 
Regarding the necessity to satisfy data elements in an invoice document. Again I am not sure I understand this correctly but it seems to be allowing the exchange of limited transaction data e.g. in high volume transactions and then sum up that data in some type of a final invoice. The Peppol invoice is designed to be able to stand by itself and not require pre-exchange of master data. Consequently each invoice is a full and legally complete invoice. This approach is well suited for SME transactions but may be less optimal for large integrated buyers and suppliers, but as you state, those have in most cases already been implemented as EDI solutions. 
 
Regarding J1
Since the trade during the month is handled by delivery notes, which are not invoices, then there seems to actually only be one invoice at the end of the month. This is in my view a very practical way of handling monthly trade and easily supported in Peppol. Peppol has a Despatch Advice document which is currently being used in a similar case as the delivery notes.
 
As to the requirements
R-J1-1 Peppol invoice should be able to fulfil this.
R-J1-2 The Peppol invoice in Europe does not support the multiple reference to delivery notes. This is constrained by the EN 16931 in Europe but outside of Europe this can be relaxed. The International invoice model has relaxed this requirement.
 
Regarding J2
This is what in Europe is called self-billing. It is not directly supported in the Peppol BIS Billing 3.0 but it is provided for. It is not directly supported because the use of self billing is dependent on prior agreement between the buyer and the seller so as part of that agreement they can agree on using a variant of the standard invoice. That is in fact what Australia and New Zealand have done. They have created Self billing invoice and credit note so that all use the same variant and this could be used as a reference model for Japan.
 
R-J2-1 Peppol invoice should be able to fulfil this.
R-J2-2 Same as for J1 .
R-J2-3 Self billing invoice can be supported as an extension.
 
Questions.
●	When calculating tax. Do you calculate the tax amount on the line level and then sum up to the document level or sum up the taxable amount to document level and apply the tax on the total for each rate? When rounding, where do you commonly do the rounding.
●	Is a return invoice not similar to a credit note and/or a negative invoice? 
 
Looking at the flowcharts and relating the message to Peppol BIS specifications
Purchase order = Peppol BIS Order only
Delivery note = Peppol BIS Despatch advice
Month end closing invoice = Peppol BIS Billing
Self billing invoice = Can be implemented as varant on BIS Billing similar to what AUNZ have done.
 
Looking at the invoice examples, they do not seem complex. Is that the general case in Japan that invoices are simple in layout with little redundant information? Finally please excuse my curiosity. My knowledge of Japanese is almost none, only konnichi wa and sayonara, but some of the characters in the Japanese invoice examples seem similar to some examples i have seen from China, like for total amounts. Is this the case?
 
I hope there is some help in my responses and please excuse how unorganized they are in this quick evaluation of these requirements.
 
Kveðja,
Georg
----------------------------------
Midran ehf., Georg Birgisson
Tel: (354) 544 4800, Mobile: (354) 898 0850, georg@midran.is
----------------------------------
Google翻訳
この非常に興味深い情報に感謝し、Web会議での議論にも感謝します。しばらくしてから、これらの要件を適切に分析し、Peppolで実行できることと詳細に比較したいと思いますが、ここで簡単に回答できるようにします。ご容赦ください。もちろん間違っているかもしれない要件を理解した上で対応させていただきますので、お気軽に訂正してください。
 
国税庁が必要とする情報について。これは、ヨーロッパで行われている要件と非常によく似ています。要件1および2では、名前またはID番号のいずれかで当事者を識別できるようです。 ID番号アプローチはEDIで一般的ですが、Peppolでは名前が使用されます。それでもPeppol XMLは、EDIで使用されるのと同じ方法で識別子の使用をサポートします。 3と4は同じようです。よくわかりません。識別子のマスターデータを事前に交換する必要性を減らすための共通の分母として。 5と6の違いですが、異なる税率と適用税の課税額を報告するという概念はサポートされていますが、計算ルールは異なる場合がありますが、シンガポールと同様に、またはPeppol InternationalInvoiceを使用して処理できます。
 
ここでも、請求書ドキュメントのデータ要素を満たす必要があります。繰り返しになりますが、これを正しく理解しているかどうかはわかりませんが、たとえば大量のトランザクションで限られたトランザクションデータを交換し、そのデータをある種の最終的な請求書にまとめることができるようです。 Peppolの請求書は、それ自体で立つことができ、マスターデータの事前交換を必要としないように設計されています。各請求書は、完全で法的に完全な請求書です。このアプローチはSMEトランザクションに適していますが、大規模な統合にはあまり最適ではない場合があります。バイヤーとサプライヤーですが、あなたが言うように、それらはほとんどの場合、EDIソリューションとしてすでに実装されています。
 
J1について
その月の取引は請求書ではない納品書で処理されるため、実際には月末の請求書は1つしかないようです。これは私の見解では、毎月の取引を処理する非常に実用的な方法であり、Peppolで簡単にサポートされています。 Peppolには、納品書と同様のケースで現在使用されている発送アドバイス文書があります。
 
要件について
R-J1-1Peppol請求書はこれを満たすことができるはずです。
R-J1-2ヨーロッパのPeppol請求書は、納品書への複数の参照をサポートしていません。これはヨーロッパではEN16931によって制約されていますが、ヨーロッパ以外ではこれを緩和できます。国際請求書モデルにより、この要件が緩和されました。
 
J2について
これは、ヨーロッパでは自己請求と呼ばれるものです。 Peppol BIS Billing 3.0では直接サポートされていませんが、提供されています。自己請求の使用は購入者と販売者の間の事前の合意に依存しているため、直接サポートされていません。その合意の一部として、標準の請求書の変形を使用することに同意できます。それは実際、オーストラリアとニュージーランドが行ったことです。彼らは、すべてが同じバリアントを使用するように自己請求請求書とクレジットノートを作成しました。これは日本の参照モデルとして使用できます。
 
R-J2-1Peppolの請求書はこれを満たすことができるはずです。
R-J2-2J1と同じです。
R-J2-3自己請求請求書は拡張機能としてサポートできます。
 
質問。
税金を計算するとき。ラインレベルで税額を計算してからドキュメントレベルで合計しますか、それとも課税対象額をドキュメントレベルで合計して、各レートの合計に税を適用しますか？丸めるとき、一般的にどこで丸めますか。
返品請求書は、クレジットノートやマイナスの請求書と似ていませんか？
 
フローチャートを見て、メッセージをPeppolBIS仕様に関連付けます
注文書= PeppolBIS注文のみ
納品書= PeppolBIS発送アドバイス
月末決算請求書= PeppolBIS請求
自己請求請求書= AUNZが行ったのと同様に、BIS請求のバリアントとして実装できます。
 
請求書の例を見ると、複雑ではないようです。それは、請求書のレイアウトが単純で、冗長な情報がほとんどないという日本の一般的なケースですか？最後に私の好奇心を許してください。私の日本語の知識はほとんどなく、こんにちはとさよならだけですが、日本の請求書の例の一部の文字は、合計金額など、中国で見たいくつかの例と似ているようです。これは本当ですか？
 
私の回答に何らかの助けがあることを願っています。これらの要件のこの迅速な評価において、彼らがいかに組織化されていないかをお許しください。

From: SAMBUICHI <nobuyuki@sambuichi.jp> 
Sent: sunnudagur, 15. nóvember 2020 21:18
To: georg@midran.is
Subject: Japanese business process requirements for PINT
Dear Mr. Georg Birgisson,
 
It was nice to talk with you at the Web meeting.
Please find attached UML activity diagrams for Japanese business process.
 
Most of the scenario is that a customer is a large company and supplier is a small and mid-sized enterprise (SME) and there is a contract between trading parties. Some leading industries are already processing ordering and shipping transactions using standard or proprietary EDI services in Japan. A large company sends purchase orders via their EDI services and receives delivery notes as EDI messages.
 
The Japanese National Tax Agency (NTA) requires following data elements for Tax deduction.
① Name or name of the creator of the purchase statement(customer)
② Name or registration number of the other party of taxable purchase(supplier)
③ Date of taxable purchase
④ Contents of assets or services related to taxable purchases
⑤ Amount of consideration paid for taxable purchases and applicable tax rate totaled for each tax rate
⑥ Consumption tax amount, etc. classified by tax rate
It is not necessary to satisfy the data elements to be stated with only one invoice document. The data elements can be supplied by the whole of the multiple documents and electromagnetic records. In such cases, the data elements to be supplied with multiple documents and electromagnetic records, the relationship between these documents shall be clear and the transaction contents shall be accurately recognized. This type of document is called an eligible invoice.
 
The following two scenarios form nearly 90% of SME transactions in Japan.
 
( J1 ) Month-end closing invoice
 
Based on the contract, the customer places an order as many times as needed and the supplier sends goods along with delivery notes. The number and/or total amount of goods is not decided prior to that month. After several business transactions of placing order and shipping goods, there comes the end of the month to send the month-end closing invoice. While calculating the total billing amount within this month, the supplier makes discounts from the total amount and also calculates tax amount based on the tax rate for each item.
 
Requirements
R-J1-1 Shall satisfy NTA requirements as an eligible invoice.
R-J1-2 Delivery notes in this month specifies shipped item, item quantity, tax ratio for this item, and delivery date. Month-end closing invoice references multiple delivery notes.
 
( J2 ) Aggregated purchase statement
 
J2 follows the same business transaction as in the previous scenario J1. In this scenario, the customer sends a closing self-invoice at the end of the month. This is an aggregated purchase statement. The receiving supplier sends a confirmation back to the customer, and after receiving this confirmation, the customer pays for these purchased items.
 
Requirements
R-J2-1 Shall satisfy NTA requirements as an eligible invoice.
R-J2-2 Aggregated purchase statement references multiple delivery notes.
R-J2-3 Self-invoice
 
NOTE: 
The tax amount can be rounded only once for each tax rate. Describing this requires another story.
There are also eligible return invoices and simplified eligible invoices.
I have attached the current paper invoice and related documents for tax deduction. There are many other use cases. I'm sorry, this is in Japanese.
 
Best regards,
 
SAMBUICHI, Nobuyuki
 
E-Invoice Promotion Association, Business Requirements Working Group 
Sambuichi Professional Engineers Office
https://www.sambuichi.jp/?lang=en
 
[J1Activity.png](https://github.com/pontsoleil/EIPA/blob/master/UML/%E6%A5%AD%E5%8B%99%E3%83%97%E3%83%AD%E3%82%BB%E3%82%B9/J1A%E4%B8%80%E6%8B%AC%E8%AB%8B%E6%B1%82/J1A%E3%82%A2%E3%82%AF%E3%83%86%E3%82%A3%E3%83%93%E3%83%86%E3%82%A3.png)
[J2Activity.png](https://github.com/pontsoleil/EIPA/blob/master/UML/%E6%A5%AD%E5%8B%99%E3%83%97%E3%83%AD%E3%82%BB%E3%82%B9/J2A%E4%BB%95%E5%85%A5%E6%98%8E%E7%B4%B0/J2A%E3%82%A2%E3%82%AF%E3%83%86%E3%82%A3%E3%83%93%E3%83%86%E3%82%A3.png)

Google翻訳
Web会議でお話できてよかったです。
日本のビジネスプロセスに関する添付のUMLアクティビティ図をご覧ください。
 
シナリオのほとんどは、顧客が大企業であり、サプライヤーが中小企業（SME）であり、取引当事者間に契約があるというものです。一部の大手業界は、日本で標準または独自のEDIサービスを使用して注文および出荷トランザクションをすでに処理しています。大企業は、EDIサービスを介して注文書を送信し、EDIメッセージとして納品書を受け取ります。
 
日本の国税庁（NTA）は、税額控除のために以下のデータ要素を要求しています。
①購入明細書の作成者（顧客）の名前または名前
②課税対象購入相手の氏名または登録番号（サプライヤー）
③課税対象の購入日
④課税対象の購入に関連する資産またはサービスの内容
⑤課税対象の購入に対して支払われた対価と各税率に合計された適用税率
⑥税率で分類した消費税額等
1つの請求書文書だけで記載されるデータ要素を満たす必要はありません。データ要素は、複数のドキュメントと電磁記録全体から提供できます。このような場合、複数の文書および電磁記録とともに提供されるデータ要素、これらの文書間の関係が明確であり、取引内容が正確に認識されている必要があります。このタイプのドキュメントは、適格請求書と呼ばれます。
 
次の2つのシナリオは、日本の中小企業取引のほぼ90％を占めています。
 
（J1）月末決算請求書
 
契約に基づいて、顧客は必要な回数だけ注文し、サプライヤは納品書と一緒に商品を送信します。商品の数および/または合計金額は、その月より前に決定されていません。注文と商品の発送といういくつかの商取引の後、月末に月末の決算請求書が送信されます。サプライヤは、今月の合計請求額を計算する際に、合計金額から割引を行い、各アイテムの税率に基づいて税額を計算します。
 
要件
R-J1-1適格請求書としてNTA要件を満たさなければなりません。
R-J1-2今月の納品書には、出荷品目、品目数量、この品目の税率、および納期が指定されています。月末の決算請求書は、複数の納品書を参照しています。
 
（J2）集約された購入ステートメント
 
J2は、前のシナリオJ1と同じビジネストランザクションに従います。このシナリオでは、顧客は月末に決算自己請求書を送信します。これは、集約された購入明細書です。受け取り側のサプライヤは確認を顧客に送り返し、この確認を受け取った後、顧客はこれらの購入したアイテムの代金を支払います。
 
要件
R-J2-1適格請求書としてNTA要件を満たさなければなりません。
R-J2-2集約された購入明細書は、複数の納品書を参照しています。
R-J2-3自己請求書
 
注意：
税額は、税率ごとに1回だけ丸めることができます。これを説明するには、別の話が必要です。
適格返還請求書と適格簡易請求書もあります。
税額控除のために、現在の紙の請求書と関連書類を添付しました。他にも多くのユースケースがあります。すみません、これは日本語です。
