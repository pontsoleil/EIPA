# en16931.html
## data
| Excel | text file |
| --- | --- |
| EN2CII.xlsx | en2cii.txt, cii2en.txt |
| EN2UBL.xlsx | en_ivc2ubl.txt, en_cnt2ubl.txt, ubl2en_ivc.txt, ubl2en_cnt.txt |

## `awk & makrj.sh`
|  |  |  |
| --- | --- | --- |
| `en2x.sh` | en2ubl_ivc.txt -> en2ubl_ivc.json<br>en2ubl_cnt.txt -> en2ubl_cnt.json | EN_Parent EN_ID EN_Level EN_Card EN_BT EN_Desc EN_DT Path Type Card Match Rules |
| `en2cii.sh` | en2cii.txt -> en2cii.json | EN_Parent EN_ID EN_Level EN_Card EN_BT EN_Desc EN_DT CII_Path CII_Type CII_Card CII_Match CII_Rules |
| `x2en.sh` | ubl2en_ivc.txt -> ubl2en_ivc.json<br>ubl2en_cnt.txt -> ubl2en_cnt.json | Path Card EN_ID EN_Level EN_Card EN_BT EN_Desc EN_DT |
| `cii2en.sh` | cii2en.txt -> cii2en.json | CII_Path CII_Card EN_ID EN_Level EN_Card EN_BT EN_Desc EN_DT |

## en16931.js  
* EN2CII
```
  en2cii_table = $( '#en2cii' ).DataTable({
    'ajax': 'data/en2cii.json'
  })
```  
* EN_IVC2UBL
```
  en_ivc2ubl_table = $( '#en_ivc2ubl' ).DataTable({ 
    'ajax': 'data/en_ivc2ubl.json'
  })
```  
* EN_IVC2UBL
```
  en_cnt2ubl_table = $( '#en_cnt2ubl' ).DataTable({
    'ajax': 'data/en_cnt2ubl.json'
  })
```  
* CII2EN
```
  ajaxRequest( 'data/cii2en.json' )
  .then(function(res) {
    json = JSON.parse(res);
    return tableInit2('#cii2en', json);
  })
  var cii2en_table = $('#cii2en').DataTable()
```
* UBL2EN_IVC
```
  ajaxRequest( 'data/ubl2en_ivc.json' )
  .then(function(res) {
    json = JSON.parse(res);
    return tableInit2('#ubl2en_ivc', json); })
  var ubl2en_ivc_table = $('#ubl2en_ivc').DataTable()
```  
* UBL2EN_CNT
```
  ajaxRequest( 'data/ubl2en_cnt.json' )
  .then(function(res) {
    json = JSON.parse(res);
    return tableInit2('#ubl2en_cnt', json);
  })
  var ubl2en_cnt_table = $('#ubl2en_cnt').DataTable()
```
# syntax.html
## data
| Excel | text file |
| --- | --- |
| EN2CII.xlsx | en2cii.txt, cii2en.txt |
| EN2UBL.xlsx | ubl2en_ivc.txt |
| 190315中小企業共通EDIメッセ－ジv2 .0_draft_r1 0（請求情報）.xlsx | sme.txt |

## `awk & makrj.sh`
|  |  |  |
| --- | --- | --- |
| `cii2en.sh` | cii2en.txt -> cii2en.json | CII_Path CII_Card EN_ID EN_Level EN_Card EN_BT EN_Desc EN_DT |
| `en2cii.sh` | en2cii.txt -> en2cii.json | EN_Parent EN_ID EN_Level EN_Card EN_BT EN_Desc EN_DT CII_Path CII_Type CII_Card CII_Match CII_Rules |
| `sme.sh` | sme.txt -> sme.json | num	seq	hdr	uniqueID	kind	DictionaryEntryName	name	description	 Card	comment1	comment2	comment3	update	private	SME	Invoice	item_name	note |
| `x2en.sh` | ubl2en_cnt.txt -> ubl2en_cnt.json | Path Card EN_ID EN_Level EN_Card EN_BT EN_Desc EN_DT |
| `text edit` | Peppol/invoice.json | Card Level Name Description |

## syntax.js
* EN
```
  ajaxRequest( 'data/en2cii.json' )
  .then(function(res) {
    json = JSON.parse(res);
    return tableInitEN(json); })
  var en_table = $( '#en' ).DataTable()
```
* CII
```
  ajaxRequest( 'data/cii2en.json' )
  .then(function(res) {
    json = JSON.parse(res);
    return tableInitX('#cii', json); })
  var cii_table = $( '#cii' ).DataTable()
```
* SME
```
  ajaxRequest( 'data/sme.json' )
  .then(function(res) {
    json = JSON.parse(res);
    return tableInitSME(json);
  })
  var sme_table = $( '#sme' ).DataTable()
```
* UBL
```
  ajaxRequest( 'data/ubl2en_ivc.json' )
  .then(function(res) {
    json = JSON.parse(res);
    return tableInitX('#ubl', json); })
  var ubl_table = $( '#ubl' ).DataTable()
```
* PEPPOL
```
  ajaxRequest( 'data/Peppol/invoice.json' )
  .then(function(res) {
    json = JSON.parse(res);
    return tableInitPEPPOL(json);
  })
  var peppol_table = $( '#peppol' ).DataTable()
```
# rules.html
## data
| Excel | text file |
| --- | --- |
| EN_16931-1.xlsx | EN_16931-1_table2.txt<hr>EN_16931-1_functionality.txt, EN_16931-1_VAT.txt<hr> EN_16931-1_conditions.txt, EN_16931-1_integrity.txt<hr>EN_16931-1_VATcategory.txt |

## `awk & makrj.sh`
|  |  |  |
| --- | --- | --- |
| `table2.sh` | EN_16831-1_table2.txt -> EN_16831-1_table2.json | ID Level Card BusinessTerm Desc UsageNote ReqID SemanticDataType |
| `rules.sh` | EN_16831-1_functionality.txt & EN_16831-1_VAT.txt -> EN_16831-1_rules.json<hr>EN_16831-1_conditions.txt & EN_16831-1_integrity.txt -> EN_16831-1_rules2.json | ID Desc<hr>ID Desc Target BusinessTerm |

## rules.js
* EN
```
  ajaxRequest(' data/rules/EN_16931-1_table2.json' )
  .then(function(res) {
    json = JSON.parse(res);
    return tableInitEN(json);
  })
  var en_table = $( '#en' ).DataTable()
```
* rule
```
  ajaxRequest('data/rules/EN_16931-1_rules.json' )
  .then(function(res) {
    RULES = JSON.parse(res);
    tableInitRule();
  })
  ajaxRequest('data/rules/EN_16931-1_rules2.json' )
  .then(function(res) {
    RULES2 = JSON.parse(res);
    tableInitRule();
  })
  var rule_table = $( '#rule' ).DataTable()
```

# cii2x.html
## data
eInvoicing-EN16931-validation-1.3.2/(cii|ubl)/examples

## `parsrx.sh & awk & makrj.sh`
|  |  |
| --- | --- |
| `cii2json.sh` | cii/CII_"$1".xml -> cii/cii_"$1".json |

## cii2x.js
```
var en = cii2en(json);
var xbrlgl = en2xbrlgl(en);
ajaxRequest('data/save.cgi', data, 'POST', timeout)
```