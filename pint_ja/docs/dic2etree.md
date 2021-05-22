# dic2etree

## etree_to_dict 及び dict_to_etree

参考 [Stackoverflow Converting xml to dictionary using elementtree](https://stackoverflow.com/questions/7684333/converting-xml-to-dictionary-using-elementtree)

pythonのdictionaryとElementTreeの相互変換  
属性定義されたXML要素は、dictでは、{'#text':要素値, ’＠属性名':属性値}として定義している。  

## get_path_value 及び set_path_value

参考　[Stackoverflow Get parents keys from nested dictionary](https://stackoverflow.com/questions/15210148/get-parents-keys-from-nested-dictionary) の回答の中で定義されているbreadcrumb(json_dict_or_list, value)関数を参考に作成した。
