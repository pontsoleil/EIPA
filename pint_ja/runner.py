import xml.etree.ElementTree as ET
from collections import defaultdict
import csv
import re
import json
import sys 

from dic2etree import *

ns = {
  '': 'urn:oasis:names:specification:ubl:schema:xsd:Invoice-2',
  'xsi': 'http://www.w3.org/2001/XMLSchema-instance',
  'cac': 'urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2',
  'cbc': 'urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2',
  'qdt': 'urn:oasis:names:specification:ubl:schema:xsd:QualifiedDataTypes-2',
  'udt': 'urn:oasis:names:specification:ubl:schema:xsd:UnqualifiedDataTypes-2',
  'ccts': 'urn:un:unece:uncefact:documentation:2'
}

dictXpath = defaultdict(type(""))

def runner():
  print("START "+__file__)

  if len(sys.argv) > 1:
    argv1 = sys.argv[1]
  else:
    argv1 = 'pint_ex6'
  if len(sys.argv) > 2:
    argv2 = sys.argv[2]
  else:
    argv2 = '/Users/pontsoleil/Documents/GitHub/EIPA/pint_ja/data/'
  if len(sys.argv) > 3:
    argv3 = sys.argv[3]
  else:
    argv3 = 'txt'
  filename = argv1
  base_dir = argv2
  extension = argv3
  xpath_file = base_dir+'in/xpath.tsv'
  # in_file    = base_dir+'pint_example6.txt'
  # out_file   = base_dir+'pint_example6.xml'
  in_file    = base_dir+"in/"+filename+"."+extension
  out_file   = base_dir+"out/"+filename+".xml"

  # print(base_dir)
  print("xpath_file "+xpath_file)
  # print(in_file)
  # print(out_file)
  # print(__path__)

  dictXpath = defaultdict(type(""))

  with open(xpath_file, encoding='utf-8', newline='') as f0:
    reader0 = csv.reader(f0, delimiter='\t')
    header = next(reader0)
    for record in reader0:
      id = record[1]
      if id:
        level = record[2]
        BT = record[3]
        card = record[4]
        datatype = record[5]
        xpath = record[7]
        dictXpath[id] = {'level':level, 'BT':BT, 'card':card, 'datatype':datatype,'xpath':xpath}

  dic = defaultdict(type(""))
  dic['Invoice'] = {}

  with open(in_file, encoding='utf-8', newline='') as f:
    reader = csv.reader(f, delimiter='\t')
    header = next(reader)
    for record in reader:
      base0 = dictXpath[record[0]] and dictXpath[record[0]]['xpath']
      base1 = dictXpath[record[2]] and dictXpath[record[2]]['xpath']
      base2 = dictXpath[record[4]] and dictXpath[record[4]]['xpath']
      seq0 = record[1]
      seq1 = record[3]
      seq2 = record[5]

      root = '/Invoice'
      if '' == base0:
        base = root
      else:
        base = base0
      baseList0 = base.split('/')
      baseList0.remove('')
      base_path = baseList0
      if seq0 and '' != seq0:
        try:
          base_path += [int(seq0)]
        except ValueError:
          pass
      if len(base1) > 0:
        baseList1 = re.sub(base, '', base1).split('/')
        baseList1.remove('')
        base = base1
        base_path += baseList1
        if seq1 and '' != seq1:
          try:
            base_path += [int(seq1)]
          except ValueError:
            pass
        if len(base2) > 0:
          baseList2 = re.sub(base, '', base2).split('/')
          baseList2.remove('')
          base = base2
          base_path += baseList1
          if seq2 and '' != seq2:
            try:
              base_path += [int(seq2)]
            except ValueError:
              pass
      n = 0
      for cell in record:  # traverce field in a record
        if n > 5 and cell:
          id = header[n]
          if id:
            dictxpath = dictXpath[id]
            if dictxpath:
              path = dictxpath['xpath']
              if path:
                pathList = re.sub(base, '', path).split('/')
                pathList.remove('')
                xpath = base_path + pathList
                datatype = dictxpath['datatype']
                set_path_value(dic, xpath, cell, datatype)
        n += 1

    dicJson = json.dumps(dic)
    dicJson = re.sub('"Invoice"', '"{' + ns[''] + '}Invoice"', dicJson)
    dicJson = re.sub('xsi:', '{' + ns['xsi'] + '}', dicJson)
    dicJson = re.sub('cac:', '{' + ns['cac'] + '}', dicJson)
    dicJson = re.sub('cbc:', '{' + ns['cbc'] + '}', dicJson)
    dicJson = re.sub('qdt:', '{' + ns['qdt'] + '}', dicJson)
    dicJson = re.sub('udt:', '{' + ns['udt'] + '}', dicJson)
    dicJson = re.sub('ccts:', '{' + ns['ccts'] + '}', dicJson)
    dic2 = json.loads(dicJson)

    tree = dict_to_etree(dic2)
    with open(out_file, 'wb') as f:
      t = ET.ElementTree(tree)
      t.write(f, encoding='UTF-8')

if __name__ == "__main__":
    # execute only if run as a script
    runner()