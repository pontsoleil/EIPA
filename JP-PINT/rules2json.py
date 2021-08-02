#!/usr/bin/env python3
#coding: utf-8
#
# generate JP-PINT rules json fron CSV and TSV file
# 
# designed by SAMBUICHI, Nobuyuki (Sambuichi Professional Engineers Office)
# written by SAMBUICHI, Nobuyuki (Sambuichi Professional Engineers Office)
#
# MIT License
# 
# Copyright (c) 2021 SAMBUICHI Nobuyuki (Sambuichi Professional Engineers Office)
# 
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
# 
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
# 
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.
import csv
import re
import json
import sys 
import os
import argparse

def file_path(pathname):
  if '/' == pathname[0:1]:
    return pathname
  else:
    dir = os.path.dirname(__file__)
    new_path = os.path.join(dir, pathname)
    return new_path

if __name__ == '__main__':
  # Create the parser
  parser = argparse.ArgumentParser(prog='genInvoice',
                                  usage='%(prog)s [options] infile -t translatedfile -o outfile -v',
                                  description='CSVファイルからPINT対応表用のJSONファイルを作成')
  # Add the arguments
  parser.add_argument('inFile', metavar='infile', type=str, help='入力TSVファイル')
  parser.add_argument('-t', '--translated')
  parser.add_argument('-o', '--out')
  parser.add_argument('-v', '--verbose', action='store_true')
  args = parser.parse_args()
  in_file = file_path(args.inFile)
  pre, ext = os.path.splitext(in_file)
  if args.translated:
    translated_file = args.translated.lstrip()
    translated_file = file_path(translated_file)
  else:
    translated_file = pre+'.tsv'
  if args.out:
    out_file = args.out.lstrip()
    out_file = file_path(out_file)
  else:
    dir = os.path.dirname(in_file)
    out_file = pre+'.json'
  verbose = args.verbose
  # Check if infile exists
  if not os.path.isfile(in_file):
    print('入力ファイルがありません')
    sys.exit()
  if verbose:
    print('** START ** ', __file__)

  rulesDict = {}
  # Read CSV file
  keys = ('ID','Flag','Desc','Desc_ja')
  with open(in_file,'r',encoding='utf-8',newline='') as csvf:
    reader = csv.DictReader(csvf,keys)
    header = next(reader)
    # num = 0
    for row in reader:
      ID = row['ID']
      if (ID):
        Desc = row['Desc']
        data = {
          'ID':ID,
          'Flag':row['Flag'],
          'Desc':row['Desc'],
          'Desc_ja':row['Desc_ja']
        }
        rulesEN = re.findall(r'(B[TG]-[0-9]+)',Desc)
        rulesPint = re.findall(r'(ib[tg]-[0-9]+)',Desc)
        rules = rulesEN + rulesPint
        data['BusinessTerm'] = ' '.join(rules)
        rulesDict[ID] = data
        # num += 1

  # Read translated TSV file
  keys = ('context','id','flag','test','text','BG','BT')
  with open(translated_file,'r',encoding='utf-8',newline='') as tevf:
    reader = csv.DictReader(tevf,keys,delimiter='\t')
    header = next(reader)
    for row in reader:
      id = row['id']
      if (id):
        if (not id in rulesDict):
          rulesDict[id] = {}
        data = rulesDict[id]
        context = row['context']
        data['context'] = context
        flag = row['flag']
        data['flag'] = flag
        test = row['test']
        data['test'] = test
        text = row['text']
        found = re.search('\[(BR|ibr)-[\-0-9a-zA-Z]+\]',text)
        if (found):
          text = text[(1+found.span()[1]):]
          rule_id = found.group()
          data['rule_id'] = rule_id
        data['text'] = text
        BG = row['BG']
        BT = row['BT']
        rulesEN = re.findall(r'(B[TG]-[0-9]+)',text)
        rulesPint = re.findall(r'(ib[tg]-[0-9]+)',text)
        rules = rulesEN + rulesPint
        data['rules'] = rules
        rulesDict[id] = data

  rulesList = []
  for k, v in rulesDict.items():
    rulesList.append(v)

  with open(out_file,'w',encoding='utf-8') as f:
    json.dump(rulesList, f)

  if verbose:
    print(f'** END ** {out_file}')