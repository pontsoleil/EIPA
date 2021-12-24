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
  'SemSort','PINT_ID','Level','BT','Desc','Card','DT','Section','SynSort','XPath','Path','selectors','Codelist'
)
csv_item = OrderedDict([
  ('SemSort','0000'),
  ('PINT_ID','ibg-00'),
  ('Level','0'),
  ('BT','Invoice'),
  ('Desc','Commercial invoice'),
  ('Card','1..n'),
  ('DT','Group'),
  ('Section',''),
  ('Extension',''),
  ('SynSort','0000'),
  ('XPath','/ubl:Invoice'),
  ('Path','/ubl:Invoice'),
  ('selectors',''),
  ('element','Invoice'),
  ('Definition','A document used to request payment.'),
  ('Datatype','InvoiceType'),
  ('Occ','1..n'),
  ('Codelist','')
])
csv_list = [csv_item]

def syntax_read_CSV_file(in_file):
  with open(in_file,'r',encoding='utf-8') as f:
    reader = csv.DictReader(f,keys)
    header = next(reader)
    # header = next(reader)
    for row in reader:
      path = row['XPath']
      if path:
        if 'TaxTotal[' in path:
          if 'cbc:TaxAmount/@currencyID=/Invoice/cbc:DocumentCurrencyCode/text()' in path:
            path = path.replace('cbc:TaxAmount/@currencyID=/Invoice/cbc:DocumentCurrencyCode/text()','DocumentCurrencyCode')
          elif 'cbc:TaxAmount/@currencyID=/Invoice/cbc:TaxCurrencyCode/text()' in path:
            path = path.replace('cbc:TaxAmount/@currencyID=/Invoice/cbc:TaxCurrencyCode/text()','TaxCurrencyCode')
          row['Path'] = path
        else:
          row['Path'] = path
        element = path2element(path)
        row['element'] = element
        element = re.sub(r'\[.*\]','',element)
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
        else:
          row['Datatype'] = ''
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
      csv_list.append(row)
  return csv_list

def semantic_read_CSV_file(in_file):
  with open(in_file,'r',encoding='utf-8') as f:
    reader = csv.DictReader(f,keys)
    header = next(reader)
    # header = next(reader)
    for row in reader:
      path = row['XPath']
      if path:
        if 'TaxTotal[' in path:
          if 'cbc:TaxAmount/@currencyID=/Invoice/cbc:DocumentCurrencyCode/text()' in path:
            path = path.replace('cbc:TaxAmount/@currencyID=/Invoice/cbc:DocumentCurrencyCode/text()','DocumentCurrencyCode')
          elif 'cbc:TaxAmount/@currencyID=/Invoice/cbc:TaxCurrencyCode/text()' in path:
            path = path.replace('cbc:TaxAmount/@currencyID=/Invoice/cbc:TaxCurrencyCode/text()','TaxCurrencyCode')
          row['Path'] = path
        else:
          row['Path'] = path
        element = path2element(path)
        row['element'] = element
        element = re.sub(r'\[.*\]','',element)
        # row['Path'] = path
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

def basic_rule(rule_file): # 'data/Rules_Basic.json'
  dir = os.path.dirname(__file__)
  basic_path = os.path.join(dir,rule_file)
  f = open(basic_path)
  Rules_Basic = json.load(f)
  Basic_dict = {}
  for rule in Rules_Basic:
    if 'Identifier' in rule:
      Basic_dict[rule['Identifier']] = rule
  Basic_test = {}
  Basic_binding = {}
  for rule in Rules_Basic:
    id = [rule['Identifier']]
    context = rule['Context']
    context = re.sub(r'\[[^\]]+\]','',context)
    if 'ubl:Invoice' ==  context[:11]:
      context = f'/{context}'
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
    Basic_test[test] = id
    # print(f'{test} {Basic_test[test]}')
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
      Basic_binding[binding] = id
  return {'dict':Basic_dict,'test':Basic_test,'binding':Basic_binding}

def shared_rule(rule_file): # 'data/Rules_Shared.json'
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

def aligned_rule(rule_file): #'data/Rules_Aligned.json'
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