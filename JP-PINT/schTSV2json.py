#!/usr/bin/env python3
#coding: utf-8
#
# generate JP-PINT rules json fron CSV file
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
                                  usage='%(prog)s [options] infile -o outfile',
                                  description='CSVファイルからPINT対応表用のJSONファイルを作成')
  # Add the arguments
  parser.add_argument('inFile', metavar='infile', type=str, help='入力TSVファイル')
  parser.add_argument('-o', '--out')
  parser.add_argument('-v', '--verbose', action='store_true')
  args = parser.parse_args()
  in_file = file_path(args.inFile)
  pre, ext = os.path.splitext(in_file)
  if args.out:
    out_file = args.out.lstrip()
    out_file = file_path(out_file)
  else:
    dir = os.path.dirname(in_file)
    out_file = dir+'/rules/pint_rules.json'
  verbose = args.verbose
  # Check if infile exists
  if not os.path.isfile(in_file):
    print('入力ファイルがありません')
    sys.exit()
  if verbose:
    print('** START ** ', __file__)

  rules_list = []
  keys = ('ID','Flag','Message','Message_ja')
  # Read CSV file
  with open(in_file,'r',encoding='utf-8') as f:
    reader = csv.DictReader(f,keys)
    header = next(reader)
    num = 0
    for row in reader:
      data = { # context id flag test #text BG BT
        'num':num,
        'context':row['context'],
        'id':row['id'],
        'flag':row['flag'],
        'test':row['test'],
        'text':row['text'],
        'Desc':'['+row['Flag']+'] '+row['Message'],
        'Desc_ja':row['Message_ja']
      }
      Message = row['Message']
      rules1 = re.findall(r'(B[TG]-[0-9]+)',Message)
      rules2 = re.findall(r'(ib[tg]-[0-9]+)',Message)
      rules = rules1+rules2
      data['BusinessTerm'] = ','.join(rules)
      rules_list.append(data)
      num += 1

  with open(out_file,'w',encoding='utf-8') as f:
    json.dump(rules_list, f)

  if verbose:
    print(f'** END ** {out_file}')