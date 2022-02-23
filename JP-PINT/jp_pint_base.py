#!/usr/bin/env python3
#coding: utf-8
#
# generate JP-PINT html fron CSV file base library
#
# This software was designed by SAMBUICHI,Nobuyuki (Sambuichi Professional Engineers Office)
# and it was written by SAMBUICHI,Nobuyuki (Sambuichi Professional Engineers Office).
#
# ==== MIT License ====
#
# Copyright (c) 2021 SAMBUICHI Nobuyuki (Sambuichi Professional Engineers Office)
#
# Permission is hereby granted,free of charge,to any person obtaining a copy
# of this software and associated documentation files (the "Software"),to deal
# in the Software without restriction,including without limitation the rights
# to use,copy,modify,merge,publish,distribute,sublicense,and/or sell
# copies of the Software,and to permit persons to whom the Software is
# furnished to do so,subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS",WITHOUT WARRANTY OF ANY KIND,EXPRESS OR
# IMPLIED,INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM,DAMAGES OR OTHER
# LIABILITY,WHETHER IN AN ACTION OF CONTRACT,TORT OR OTHERWISE,ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.
import csv
from collections import OrderedDict
import re
import json
import sys
import os
import argparse

# OP_BASE = 'https://www.wuwei.space/jp_pint/billing-japan/en/'
OP_BASE = '' # for local test
# APP_BASE = '/jp_pint/billing-japan/'
APP_BASE = '/billing-japan/'
MESSAGE = 'invoice' #summarised debitnote

from ubl2_1_cct import CCT
from ubl2_1_udt import UDT
from ubl2_1_cbc import CBC
from ubl2_1_cac import CAC
from ubl2_1_Invoice_2 import InvoiceType
complexType = CAC['complexType']

def path2element(path):
  m = re.search(r'\[([^\s]+\s*=\s*[^\s]+)\]',path)
  if m:
    qualifier = m.group(0)
    replacer = qualifier.replace('/','_')[1:-1]
    replacer = replacer.replace(':','-')
    qualifier = qualifier[1:-1]
    path = path.replace(qualifier,replacer)
  m2 = re.match(r'.*\/([^\/]+)$',path)
  if m2:
    element = m2.groups()[0]
  else:
    element = path
  return element

# Read CSV file
keys = (
# 'SemSort','PINT_ID','Level','BT','Desc','BT_ja','Card','DT','Section','SynSort','XPath','selectors','Codelist','CAR'
  'SemSort','PINT_ID','Level','BT','BT_ja','Desc','Desc_ja','Explanation','Explanation_ja','Example','Card','DT','Section','Extension','SynSort','XPath','selectors','Codelist','ModCard','UBLCard','CAR'
)
csv_item = OrderedDict([
  ('SemSort','0000'),
  ('PINT_ID','ibg-00'),
  ('Level','0'),
  ('BT','Invoice'),
  ('BT_ja','請求書'),
  ('Desc','Commercial invoice'),
  ('Desc_ja',''),
  ('Explanation',''),
  ('Explanation_ja',''),
  ('Example',''),
  ('Card','1..n'),
  ('DT','Group'),
  ('Section',''),
  ('Extension',''),
  ('SynSort','0000'),
  ('XPath','/Invoice'),
  ('dirPath','/Invoice'),
  ('Path','/Invoice'),
  ('selectors',''),
  ('element','Invoice'),
  ('Definition','A document used to request payment.'),
  ('Datatype','InvoiceType'),
  ('Occ','1..n'),
  ('Codelist',''),
  ('ModCard','1..n'),
  ('UBLCard','1..n'),
  ('CAR','')
])
csv_list = [csv_item]

def syntax_read_CSV_file(in_file):
  with open(in_file,'r',encoding='utf-8') as f:
    reader = csv.DictReader(f,keys)
    next(reader)
    for row in reader:
      xPath = row['XPath']
      id = row['PINT_ID']
      if not xPath or id in ['ibt-251','ibt-252']: # /Invoice/ext:UBLExtensions/op-cac:AlternativeCurrencyMonetaryTotals
        continue
      if 'TaxTotal[' in xPath:
        if 'cbc:TaxAmount/@currencyID=/Invoice/cbc:DocumentCurrencyCode/text()' in xPath:
          dirPath = xPath.replace('cbc:TaxAmount/@currencyID=/Invoice/cbc:DocumentCurrencyCode/text()','DocumentCurrencyCode')
        elif 'cbc:TaxAmount/@currencyID=/Invoice/cbc:TaxCurrencyCode/text()' in xPath:
          dirPath = xPath.replace('cbc:TaxAmount/@currencyID=/Invoice/cbc:TaxCurrencyCode/text()','TaxCurrencyCode')
      # elif "[cbc:DocumentTypeCode='130']" in xPath:
      #   dirPath = xPath.replace("[cbc:DocumentTypeCode='130']","[DocumentTypeCode='130']")
      # elif "[cbc:DocumentTypeCode!='130']" in xPath:
      #   dirPath = xPath.replace("[cbc:DocumentTypeCode!='130']","[DocumentTypeCode!='130']")
      # elif "[not(cbc:DocumentTypeCode='130')]" in xPath:
      #   dirPath = xPath.replace("[not(cbc:DocumentTypeCode='130')]","[not(DocumentTypeCode='130')]")
      # elif '[cbc:ChargeIndicator=false()]' in xPath:
      #   dirPath = xPath.replace('[cbc:ChargeIndicator=false()]','[ChargeIndicator=false]')
      # elif '[cbc:ChargeIndicator=true()]' in xPath:
      #   dirPath = xPath.replace('[cbc:ChargeIndicator=false()]','[ChargeIndicator=true]')
      else:
        dirPath = xPath
      row['dirPath'] = dirPath
      element = path2element(dirPath)
      if re.match(r'\[.*\]',element):
        element = re.sub(r'\[.*\]','',element)
      row['element'] = element
      path = re.sub(r'\[[^\]]+\]','',dirPath)
      row['Path'] = path
      level = str(path[1:].count('/'))
      row['Level'] = level
      if element in InvoiceType['element']:
        elementType = InvoiceType['element'][element]
        if 'cac' == element[:3] and 'DictionaryEntryName' in elementType:
          if element[4:] in CAC['element'] and 'type' in CAC['element'][element[4:]]:
            datatype = CAC['element'][element[4:]]['type']
          else:
            datatype = elementType['DictionaryEntryName'][9:]
          datatype = datatype.replace('udt:','')
          datatype = datatype.replace('. ','')
          datatype = datatype.replace(' ','')
          row['Datatype'] = datatype
          row['Occ'] = str(elementType['Cardinality'])
          row['Definition'] = elementType['Definition']
        elif 'cbc' == element[:3] and element[4:] in CBC['element']:
          dtype = CBC['element'][element[4:]]['type']
          if dtype in CBC['complexType']:
            if 'base' in CBC['complexType'][dtype]:
              datatype = CBC['complexType'][dtype]['base']
              datatype = datatype.replace('udt:','')
              datatype = datatype.replace('. ','')
              row['Datatype'] = datatype
              row['Occ'] = str(elementType['Cardinality'])
              row['Definition'] = elementType['Definition']
      elif 'cac' == element[:3] and element[4:] in CAC['element']:
        dtype = CAC['element'][element[4:]]['type']
        if dtype in CAC['complexType']:
          row['Datatype'] = dtype
          datatype = CAC['complexType'][dtype]
          row['Definition'] = datatype['Definition']
      if int(row['Level']) > 1:
          pathList = path[9:].split('/')
          parent = pathList[-2]
          parent = re.sub(r'\[.*\]','',parent)
          if 'cac'==parent[:3]:
            if parent[4:] in CAC['element'] and 'type' in CAC['element'][parent[4:]]:
              elementType = CAC['element'][parent[4:]]['type']
              if elementType in CAC['complexType']:
                elmts = CAC['complexType'][elementType]['element']
                if element in elmts:
                  el = elmts[element]
                  if 'DataType' in el:
                    datatype = el['DataType'].replace('. ','')
                    datatype = datatype.replace('udt:','')
                    datatype = datatype.replace('. ','')
                    datatype = datatype.replace(' ','')
                    row['Datatype'] = datatype
                  if 'Cardinality' in el:
                    row['Occ'] = str(el['Cardinality'])
                  if 'Definition' in el:
                    row['Definition'] = el['Definition']
      # if not 'Definition' in row:
      #   row['Definition'] = ''
      # if not 'Datatype' in row:
      #   row['Datatype'] = ''
      # if 'Example' in row and row['Example']:
      #   pass
      # else:
      #   pass
      # if not 'Codelist' in row:
      #   row['Codelist'] = ''
      csv_list.append(row)
  return csv_list

def semantic_read_CSV_file(in_file):
  with open(in_file,'r',encoding='utf-8') as f:
    reader = csv.DictReader(f,keys)
    next(reader)
    for row in reader:
      if not row['SemSort']:
        continue
      xPath = row['XPath']
      if not xPath:
        xPath = '#'
      if 'TaxTotal[' in xPath:
        if 'cbc:TaxAmount/@currencyID=/Invoice/cbc:DocumentCurrencyCode/text()' in xPath:
          dirPath = xPath.replace('cbc:TaxAmount/@currencyID=/Invoice/cbc:DocumentCurrencyCode/text()','DocumentCurrencyCode')
        elif 'cbc:TaxAmount/@currencyID=/Invoice/cbc:TaxCurrencyCode/text()' in xPath:
          dirPath = xPath.replace('cbc:TaxAmount/@currencyID=/Invoice/cbc:TaxCurrencyCode/text()','TaxCurrencyCode')
      # elif "[cbc:DocumentTypeCode='130']" in xPath:
      #   dirPath = xPath.replace("[cbc:DocumentTypeCode='130']","[DocumentTypeCode='130']")
      # elif "[not(cbc:DocumentTypeCode='130')]" in xPath:
      #   dirPath = xPath.replace("[not(cbc:DocumentTypeCode='130')]","[not(DocumentTypeCode='130')]")
      # elif '[cbc:ChargeIndicator=false()]' in xPath:
      #   dirPath = xPath.replace('[cbc:ChargeIndicator=false()]','[ChargeIndicator=false]')
      # elif '[cbc:ChargeIndicator=true()]' in xPath:
      #   dirPath = xPath.replace('[cbc:ChargeIndicator=false()]','[ChargeIndicator=true]')
      else:
        dirPath = xPath
      row['dirPath'] = dirPath
      element = path2element(dirPath)
      if re.match(r'\[.*\]',element):
        element = re.sub(r'\[.*\]','',element)
      row['element'] = element
      path = re.sub(r'\[[^\]]+\]','',dirPath)
      row['Path'] = path
      level = str(path[1:].count('/'))
      if element in InvoiceType['element']:
        elementType = InvoiceType['element'][element]
        if 'cac' == element[:3] and 'DictionaryEntryName' in elementType:
          if element[4:] in CAC['element'] and 'type' in CAC['element'][element[4:]]:
            datatype = CAC['element'][element[4:]]['type']
          else:
            datatype = elementType['DictionaryEntryName'][9:]
          datatype = datatype.replace('udt:','')
          datatype = datatype.replace('. ','')
          datatype = datatype.replace(' ','')
          row['Datatype'] = datatype
          row['Occ'] = str(elementType['Cardinality'])
          row['Definition'] = elementType['Definition']
        elif 'cbc' == element[:3] and element[4:] in CBC['element']:
          dtype = CBC['element'][element[4:]]['type']
          if dtype in CBC['complexType']:
            if 'base' in CBC['complexType'][dtype]:
              datatype = CBC['complexType'][dtype]['base']
              datatype = datatype.replace('udt:','')
              datatype = datatype.replace('. ','')
              row['Datatype'] = datatype
              row['Occ'] = str(elementType['Cardinality'])
              row['Definition'] = elementType['Definition']
      elif 'cac' == element[:3] and element[4:] in CAC['element']:
        dtype = CAC['element'][element[4:]]['type']
        if dtype in CAC['complexType']:
          row['Datatype'] = dtype
          datatype = CAC['complexType'][dtype]
          row['Definition'] = datatype['Definition']
      else:
        row['Datatype'] = ''
      if int(level) > 1:
        pathList = path[9:].split('/')
        parent = pathList[-2]
        parent = re.sub(r'\[.*\]','',parent)
        if 'cac'==parent[:3]:
          if parent[4:] in CAC['element'] and 'type' in CAC['element'][parent[4:]]:
            elementType = CAC['element'][parent[4:]]['type']
            if elementType in CAC['complexType']:
              elmts = CAC['complexType'][elementType]['element']
              if element in elmts:
                el = elmts[element]
                if 'DataType' in el:
                  datatype = el['DataType'].replace('. ','')
                  datatype = datatype.replace('udt:','')
                  datatype = datatype.replace('. ','')
                  datatype = datatype.replace(' ','')
                  row['Datatype'] = datatype
                if 'Cardinality' in el:
                  row['Occ'] = str(el['Cardinality'])
                if 'Definition' in el:
                  row['Definition'] = el['Definition']
      csv_list.append(row)
  return csv_list

def basic_rule(rule_file): # data/Rules_Basic.json
  dir = os.path.dirname(__file__)
  basic_path = os.path.join(dir,rule_file)
  f = open(basic_path)
  Rules_Basic = json.load(f)
  Basic_dict = {}
  for rule in Rules_Basic:
    if 'Identifier' in rule:
      Basic_dict[rule['Identifier']] = rule
  Basic_message = {}
  Basic_test = {}
  Basic_binding = {}
  for rule in Rules_Basic:
    id = [rule['Identifier']]
    context = rule['Context']
    context = re.sub(r'\[[^\]]+\]','',context)
    if 'ubl:Invoice' ==  context[:11]:
      context = f'/{context}'
    # Message
    message = rule['Message']
    for element in re.findall(r"c[ab]c:[a-zA-Z]*", message):
      element = f'{context}/{element}'
      if element in Basic_message:
        Basic_message[element] += id
      else:
        Basic_message[element] = id
    # Test
    test = rule['Test']
    test = re.sub(r'\[[^\]]+\]','',test)
    test = re.sub(r'not\(([^\)]+)\)','\\1',test)
    test = re.sub(r'exists\(([^\)]+)\)','\\1',test)
    if not '(some $code in' in test and \
       not 'normalize-space()' in test and \
       not 'matches(' in test and \
       'false()' != test and \
       'true()' != test:
      l = set()
      test_list = test.split(' and ')
      test_list = set(test_list)
      test_list = [x for x in test_list]
      for x in test_list:
        if ' or ' in x:
          tmp = x.split(' or ')
          tmp = set(tmp)
          for x in tmp:
            l.add(x)
        else:
          l.add(x)
      list = [x for x in l]
      if len(list) > 0:
        test = list[0]
        test = f'{context}/{test}'
    else:
      test = context
    if test in Basic_test:
      Basic_test[test] += id
    if test in Basic_test:
      Basic_test[test] += id
    else:
      Basic_test[test] = id
    # Syntax binding
    if 'Syntax binding' in rule:
      binding = rule['Syntax binding']
      binding = binding.replace('\n','')
      binding = binding.replace(' ','')
      binding = re.sub(r'\[[^\]]+\]','',binding)
      if 'ubl:Invoice' ==  binding[:11]:
        binding = f'/{binding}'
      if binding in Basic_binding:
        Basic_binding[binding] += id
      else:
        Basic_binding[binding] = id
  return {'dict':Basic_dict,'message':Basic_message,'test':Basic_test,'binding':Basic_binding}

def shared_rule(rule_file): # data/Rules_Shared.json
  dir = os.path.dirname(__file__)
  shared_path = os.path.join(dir,rule_file)
  f = open(shared_path)
  Rules_Shared = json.load(f)
  Shared_rule = {}
  for rule in Rules_Shared:
    id = rule['Identifier']
    message = rule['Message']
    rulesBG = re.findall(r'(ibg-[0-9]+)',message)
    rulesBT = re.findall(r'(ibt-[0-9]+)',message)
    rules = rulesBG + rulesBT
    for id in rules:
      if id in Shared_rule:
        Shared_rule[id] += rule
      else:
        Shared_rule[id] = [rule]
  return Shared_rule

def aligned_rule(rule_file): # data/Rules_Aligned.json
  dir = os.path.dirname(__file__)
  aligned_path = os.path.join(dir,rule_file)
  f = open(aligned_path)
  Rules_Aligned = json.load(f)
  Aligned_rule = {}
  for rule in Rules_Aligned:
    id = [rule['Identifier']]
    message = rule['Message']
    rulesBG = re.findall(r'(ibg-[0-9]+)',message)
    rulesBT = re.findall(r'(ibt-[0-9]+)',message)
    rules = rulesBG + rulesBT
    for id in rules:
      if id in Aligned_rule:
        Aligned_rule[id] += rule
      else:
        Aligned_rule[id] = [rule]
  return Aligned_rule

def get_codelist(codelist_file): # data/Codelists.json
  dir = os.path.dirname(__file__)
  codelist_path = os.path.join(dir,codelist_file)
  f = open(codelist_path)
  Codelist = json.load(f)
  return Codelist