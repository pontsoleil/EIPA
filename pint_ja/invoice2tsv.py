#!/usr/bin/env python3
# -*- coding: shift_jis -*-
import xml.etree.ElementTree as ET
from collections import defaultdict
import csv
import re
import json
import sys 

from dic2etree import *

dictXpath = defaultdict(type(""))
dictID = defaultdict(type(""))

# ns = {
#   '': 'urn:oasis:names:specification:ubl:schema:xsd:Invoice-2',
#   'xsi': 'http://www.w3.org/2001/XMLSchema-instance',
#   'cac': 'urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2',
#   'cbc': 'urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2',
#   'qdt': 'urn:oasis:names:specification:ubl:schema:xsd:QualifiedDataTypes-2',
#   'udt': 'urn:oasis:names:specification:ubl:schema:xsd:UnqualifiedDataTypes-2',
#   'ccts': 'urn:un:unece:uncefact:documentation:2'
# }
def main():
  base_dir = '/Users/pontsoleil/Documents/GitHub/EIPA/pint_ja/data/'
  fileName = base_dir+'out/example6.xml'
  tree = ET.parse(fileName)
  root = tree.getroot()
  dic = etree_to_dict(root)

  dicJson = json.dumps(dic)
  dicJson = re.sub('{' + ns[''] + '}', '', dicJson)
  dicJson = re.sub('{' + ns['cac'] + '}', 'cac:', dicJson)
  dicJson = re.sub('{' + ns['cbc'] + '}', 'cbc:', dicJson)
  dic2 = json.loads(dicJson)
  # pprint(dic2)

  with open(base_dir+'common/pint_ubl.tsv', encoding='utf-8', newline='') as f0:
    reader0 = csv.reader(f0, delimiter='\t')
    header = next(reader0)
    for record in reader0:
      id = record[2]
      if id:
        xpath = record[6]
        dictXpath[id] = xpath
        dictID[xpath] = id

  tsv = []
  tsv = dict_to_tsv(tsv, dic2, 'Invoice', '')
  print(tsv)

  with open(base_dir+'out/pint_example.csv', 'w') as f:
      writer = csv.writer(f)
      for record in tsv:
        writer.writerow([record['case'], record['id'], record['path'], record['val']])

  # tree2 = dict_to_etree(dic)
  # print(ET.tostring(tree2))

  # IssueDate = root.find('./cbc:IssueDate', ns)
  # print(IssueDate.tag, IssueDate.attrib, IssueDate.text)

  # InvoiceLine = root.findall('./cac:InvoiceLine', ns)
  # pprint(InvoiceLine)

if __name__ == "__main__":
    # execute only if run as a script
    main()