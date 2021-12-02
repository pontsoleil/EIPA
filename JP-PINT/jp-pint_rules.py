#!/usr/bin/env python3
#coding: utf-8
#
# generate JP-PINT rules html fron CSV file
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
import collections
from collections import OrderedDict
import re
import json
import sys 
import os
import argparse

import jp_pint_base
# from jp_pint_base import APP_BASE
from jp_pint_base import MESSAGE # invoice debitnote summarized

import jp_pint_constants
from jp_pint_constants import profiles
from jp_pint_constants import OP_BASE
from jp_pint_constants import APP_BASE
# from jp_pint_constants import SEMANTIC_BASE
# from jp_pint_constants import SYNTAX_BASE
from jp_pint_constants import RULES_BASE
# from jp_pint_constants import RULES_UBL_JAPAN_BASE
# from jp_pint_constants import RULES_UBL_PINT_BASE
from jp_pint_constants import SPEC_TITLE_en
from jp_pint_constants import SPEC_TITLE_ja
# from jp_pint_constants import SEMANTICS_MESSAGE_TITLE_en
# from jp_pint_constants import SEMANTICS_MESSAGE_TITLE_ja
# from jp_pint_constants import SYNTAX_MESSAGE_TITLE_en
# from jp_pint_constants import SYNTAX_MESSAGE_TITLE_ja
from jp_pint_constants import PINT_RULE_MESSAGE_TITLE_en
from jp_pint_constants import PINT_RULE_MESSAGE_TITLE_ja
from jp_pint_constants import JP_RULE_MESSAGE_TITLE_en
from jp_pint_constants import JP_RULE_MESSAGE_TITLE_ja
from jp_pint_constants import HOME_en
from jp_pint_constants import HOME_ja
from jp_pint_constants import NOT_SUPPORTED_en
from jp_pint_constants import NOT_SUPPORTED_ja

from jp_pint_constants import html_head
from jp_pint_constants import javascript_html
from jp_pint_constants import navbar_html
from jp_pint_constants import dropdown_menu_en
dropdown_menu_en = dropdown_menu_en.format(APP_BASE)
from jp_pint_constants import dropdown_menu_ja
dropdown_menu_ja = dropdown_menu_ja.format(APP_BASE)
legend_en ='''
<h3>TBD</h3>
'''
legend_ja = '''
<h3>未定</h3>
'''
table_html = '''
				<table class="{0} rules table table-sm table-hover" style="table-layout: fixed; width: 100%;">
					<colgroup>
						<col span="1" style="width: 90%;">
						<col span="1" style="width: 10%;">
					</colgroup>
					<thead>
						<th>{1}</th>
						<th>{2}</th>
					</thead>
					<tbody>
'''
from jp_pint_constants import table_trailer
from jp_pint_constants import trailer
# ITEM
from jp_pint_constants import item_head
info_item_modal_en = '''
<h3>ISO/IEC 19757-3:2016(E)</h3>
<h5>Information technology -- Document Schema definition languages (DSDL) -- <br />part 3: Rule-based validation -- Schemetron</h5>
<h5>rule element</h5>
A list of assertions tested within the conttext specified by the required <strong>context</strong> attribute. The <strong>context</strong> attribute specifies the rule context expression.<br />
<br />
<h5>assert element</h5>
An assertion made about the context nodes. The data contents is a natural-language assertion. The required <strong>test</strong> attribute is an assertion test evaluated in the current context. If the test evaluates positive, the report succeeds.
The natural-language assertion shall be a positive statement of a constraint.<br />
The <strong>flag</strong> attribute allows more detailed outcomes.
'''
info_item_modal_ja = info_item_modal_en

from jp_pint_constants import item_navbar
# 0.lang 1.HOME_en 2.'Transction Business Rules' 3.'ubl-pint' 4.PINT_RULE_MESSAGE_TITLE_en 5.id
item_breadcrumb = '''
			<ol class="breadcrumb pt-1 pb-1">
				<li class="breadcrumb-item"><a href="'''+OP_BASE+'''">{1}</a></li>
				<li class="breadcrumb-item"><a href="'''+APP_BASE+'''rules/{0}">{2}</a></li>
				<li class="breadcrumb-item"><a href="'''+APP_BASE+'''rules/{3}/{0}/">{4}</a></li>
				<li class="breadcrumb-item active">{5}</li>
		</ol>
'''
from jp_pint_constants import item_header
item_data = '''
				<dt class="col-3">{0}</dt><dd class="col-9">{1}</dd>
				<dt class="col-3">{2}</dt><dd class="col-9">{3}</dd>
				<dt class="col-3">{4}</dt><dd class="col-9">{5}</dd>
				<dt class="col-3">{6}</dt><dd class="col-9">{7}</dd>
'''
item_table_head = '''
					<table class="table table-borderless table-sm table-hover">
						<colgroup>
							<col span="1" style="width: 20%;">
							<col span="1" style="width: 80%;">
						</colgroup>
						<tbody>
'''
item_table_row = '''
						<tr><td><a href="{3}semantic/invoice/{1}/{0}/">{1}</a></td>
						<td>{2}</td></tr>
'''
item_table_trailer = '''
						</tbody>
					</table>
''' 
from jp_pint_constants import item_trailer


from jp_pint_constants import warning_ja
from jp_pint_constants import warning_en
from jp_pint_constants import searchLegend_ja
from jp_pint_constants import searchLegend_en

datatypeDict = {
	'ID': 'Identifier',
	'Unit': 'Unit Price Amount',
	'REF (Optional)': 'Document Reference',
	'Binary': 'Binary objects'
}

# 6.4 Business rules in EN 16931-1
Rules = '''
			<h6>Business rules in EN 16931-1</h6>
			<dl class="row">
				<dt class="col-3">Integrity constraints</dt><dd class="col-9">BR-1 ~ BR-65</dd>
				<dt class="col-3">Conditions</dt><dd class="col-9">BR-CO-3 ~ BR-CO-26</dd>
				<dt class="col-3">VAT standard and reduced rate</dt><dd class="col-9">BR-S-1 ~ BR-S-10</dd>
				<dt class="col-3">VAT zero rate</dt><dd class="col-9">BR-Z-1 ~ BR-Z-10</dd>
				<dt class="col-3">Exempted from VAT</dt><dd class="col-9">BR-E-1 ~ BR-E-10</dd>
				<dt class="col-3">VAT reverse charge</dt><dd class="col-9">BR-AE-1 ~ BR-AE-10</dd>
				<dt class="col-3">VAT intra-community supply</dt><dd class="col-9">BR-IC-1 ~ BR-IC-12</dd>
				<dt class="col-3">VAT exports</dt><dd class="col-9">BR-G-1 ~ BR-G-10</dd>
				<dt class="col-3">Not subject to VAT</dt><dd class="col-9">BR-O-1 ~ BR-O-14</dd>
				<dt class="col-3">Canary islands tax</dt><dd class="col-9">BR-IG-1 ~ BR-IG-10</dd>
				<dt class="col-3">Ceuta and Melilla tax</dt><dd class="col-9">BR-IP-1 ~ BR-IP-10</dd>
			</dl>
'''

def file_path(pathname):
	if '/' == pathname[0:1]:
		return pathname
	else:
		dir = os.path.dirname(__file__)
		new_path = os.path.join(dir,pathname)
		return new_path

def writeTr_en(f,type,data): # Identifier,Flag,Message,Message_ja
	tabs = '\t\t\t\t\t\t'
	id = data['RuleID']
	flag = data['Flag']
	message = data['Message']
	f.write(tabs+'<tr data-id="'+id+'">\n')
	item_dir = RULES_BASE+type+'/'+id+'/en/'
	f.write(tabs+'\t<td class="info-link"><a href="'+item_dir+'">'+id+'</a><br />'+message+'</td>\n')
	f.write(tabs+'\t<td>'+flag+'</td>\n')
	f.write(tabs+'</tr>\n')

def writeTr_ja(f,type,data): # Identifier,Flag,Message,Message_ja
	tabs = '\t\t\t\t\t\t'
	id = data['RuleID']
	flag = data['Flag']
	message = data['Message_ja']
	f.write(tabs+'<tr data-id="'+id+'">\n')
	item_dir = RULES_BASE+type+'/'+id+'/ja/'
	f.write(tabs+'\t<td class="info-link"><a href="'+item_dir+'">'+id+'</a><br />'+message+'</td>\n')
	f.write(tabs+'\t<td>'+flag+'</td>\n')
	f.write(tabs+'</tr>\n')

def blank2nbsp(str):
	if str:
		return str
	return '<i class="fa fa-minus" aria-hidden="true"></i>'

def checkRule(rule):
	rule_id = rule['id']
	context = rule['context']
	test = rule['test']
	BG = rule['BG']
	BT = rule['BT']
	Rs = ''
	_cac = '(\/cac:[a-zA-Z]+)?'
	_cnd = '(\[[^\]]+\])?'
	check = '[:a-z]*(InvoiceLine|Invoice|cac:[a-zA-Z]+)'+_cnd+_cac+_cnd+_cac+_cnd+_cac+_cnd+_cac+_cnd
	mC = re.findall(check,context)
	_mC = [x[0]+_cnd+x[2]+_cnd+x[4]+_cnd+x[6]+_cnd+x[8]+_cnd for x in mC if ''!=x[8]] + \
				[x[0]+_cnd+x[2]+_cnd+x[4]+_cnd+x[6]+_cnd for x in mC if ''!=x[6] and ''==x[8]] + \
				[x[0]+_cnd+x[2]+_cnd+x[4]+_cnd for x in mC if ''!=x[4] and ''==x[6] and ''==x[8]] + \
				[x[0]+_cnd+x[2]+_cnd for x in mC if ''!=x[2] and ''==x[4] and ''==x[6] and ''==x[8]] + \
				[x[0]+_cnd for x in mC if ''!=x[0] and ''==x[2] and ''==x[4] and ''==x[6] and ''==x[8]]
	_mC = sorted(list(set(_mC)))
	mT = re.findall(r'(cac:[a-zA-Z]+\/)*(xs:[a-zA-Z]+\()*(cbc:[a-zA-Z\[\]\@\$\=]+)',test)
	_mT = [x[0]+x[2] for x in mT]
	_mT = sorted(list(set(_mT)))
	rgxs = set()
	if _mC:
		for ctx in _mC:
			for tst in _mT:
				if ctx:
					rgx = '^.*'+ctx.replace(' ','')+re.escape('/'+tst.replace(' ',''))+'$'
					rgxs.add(rgx)
				else:
					rgx = '^.*'+re.escape(tst.replace(' ',''))+'$'
					rgxs.add(rgx)
	else:
		for tst in _mT:
			rgx = '^.*'+re.escape(tst.replace(' ',''))+'$'
			rgxs.add(rgx)
	rgxs = list(rgxs)
	if rgxs:
		Pset = set()
		for path in rgxs:
			Ps = [x['PINT_ID'] for x in pint_list if re.match(path,x['Path'])]
			for id in Ps:
				Pset.add(id)
		if Pset:
			Ps = sorted(list(Pset))
			BTs = ' '.join(Ps)
			XPaths = set()
			for id in Ps:
				XPath = [id+'_'+x['Path'] for x in pint_list if id == x['PINT_ID']]
				XPaths.add(XPath[0])
			XPaths = '<br />'.join(XPaths)
			bt = sorted(BT.split(' '))
			bt = ' '.join(bt)
			if not BTs in bt:
				rule_data = '''
				<dl class="row">
					<dt class="col-3">Regular Expression</dt><dd class="col-9">{0}</dd>
					<dt class="col-3">Business term IDs</dt><dd class="col-9">{1}</dd>
					<dt class="col-3">business term XPath</dt><dd class="col-9">{2}</dd>
				</dl>
'''
				Rs += rule_data.format('<br />'.join(rgxs),BTs,XPaths)
	return Rs

def lookupBG(data, lang):
	table ='<i class="fa fa-minus" aria-hidden="true"></i>'
	terms = data['BG']
	if len(terms) > 0:
		table = item_table_head
		terms = terms.split(' ')
		_terms = set()
		for id in terms:
			_terms.add(id)
		terms = list(_terms)
		for id in terms:
			if 'ja' == lang:
				term = [x['BT_ja'] for x in pint_list if id == x['PINT_ID']]
			else:
				term = [x['BT'] for x in pint_list if id == x['PINT_ID']]
			if len(term) > 0:
				term = term[0]
				table += item_table_row.format(lang,id,term,APP_BASE)
			else:
				bt = 'ibt'+id[3:]
				if 'ja' == lang:
					term = [x['BT_ja'] for x in pint_list if bt == x['PINT_ID']]
				else:
					term = [x['BT'] for x in pint_list if bt == x['PINT_ID']]
				if len(term) > 0:
					term = term[0]
					table += item_table_row.format(lang,id,term,APP_BASE)
				else:
					table += item_table_row.format(lang,id,'Not found',APP_BASE)
		table += item_table_trailer
	return table
		
def lookupBT(data,lang):
	table = '<i class="fa fa-minus" aria-hidden="true"></i>'
	terms = data['BT']
	if len(terms) > 0:
		table = item_table_head
		terms = terms.split(' ')
		_terms = set()
		for id in terms:
			_terms.add(id)
		terms = list(_terms)
		for id in terms:
			if re.match(r'^ibt-[0-9]{2}$',id):
				id = 'ibt-0'+id[-2:]
			if 'ja' == lang:
				term = [x['BT_ja'] for x in pint_list if id == x['PINT_ID']]
			else:
				term = [x['BT'] for x in pint_list if id == x['PINT_ID']]
			if len(term) > 0:
				term = term[0]
				table += item_table_row.format(lang,id,term,APP_BASE)
			else:
				table += item_table_row.format(lang,id,'Not found',APP_BASE)
		table += item_table_trailer
	return table

def lookupBGT(id,lang):
	if not id in jp_rule_dict:
		return {'BGroup':'','BTerm':''}
	rule = jp_rule_dict[id]
	if len(rule) > 0:
		pint_ids = rule['PINT_IDs']
	else:
		rule = pint_rule_dict[id]
		if len(rule) > 0:
			pint_ids = rule['PINT_IDs']
	pint_ids = pint_ids.split(' ')
	terms = [x for x in pint_ids if re.match(r'^ibg-.*$',x)]
	_terms = set()
	for id in terms:
		_terms.add(id)
	terms = ' '.join(sorted(list(_terms)))
	BGroup = termTable(terms,lang)
	terms = [x for x in pint_ids if re.match(r'^ibt-.*$',x)]
	_terms = set()
	for id in terms:
		_terms.add(id)
	terms = ' '.join(sorted(list(_terms)))
	BTerm = termTable(terms,lang)
	return {'BGroup':BGroup,'BTerm':BTerm}

def termTable(terms,lang):
	table = '<i class="fa fa-minus" aria-hidden="true"></i>'
	if len(terms) > 0:
		table = item_table_head
		terms = terms.split(' ')
		for id in terms:
			if re.match(r'^ibt-[0-9]{2}$',id):
				id = 'ibt-0'+id[-2:]
			if 'ja' == lang:
				term = [x['BT_ja'] for x in pint_list if id == x['PINT_ID']]
			else:
				term = [x['BT'] for x in pint_list if id == x['PINT_ID']]
			if len(term) > 0:
				term = term[0]
				table += item_table_row.format(lang,id,term,APP_BASE)
			else:
				table += item_table_row.format(lang,id,'Not found',APP_BASE)
		table += item_table_trailer
	return table

if __name__ == '__main__':
	# Create the parser
	parser = argparse.ArgumentParser(prog='jp-pint_rules.py',
																	usage='%(prog)s [options] infile pint_rulefile jp_rulefile schematronfile',
																	description='CSVファイルからJP-PINTのHTMLファイルを作成')
	# Add the arguments
	parser.add_argument('inFile',metavar='infile',type=str,help='入力TSVファイル')
	parser.add_argument('pint_ruleFile',metavar='pint_rulefile',type=str,help='PINTルールCSVファイル')
	parser.add_argument('jp_ruleFile',metavar='jp_rulefile',type=str,help='JPルールCSVファイル')
	parser.add_argument('schematronFile',metavar='schematronfile',type=str,help='スキーマトロンCSVファイル')

	parser.add_argument('-v','--verbose',action='store_true')
	parser.add_argument('-d','--detail',action='store_true')
	
	args = parser.parse_args()

	in_file = file_path(args.inFile)
	pint_rule_file = file_path(args.pint_ruleFile)
	jp_rule_file = file_path(args.jp_ruleFile)
	schematron_file = file_path(args.schematronFile)

	pint_rule_en_html = 'billing-japan/rules/ubl-pint/en/index.html'
	pint_rule_ja_html = 'billing-japan/rules/ubl-pint/ja/index.html'
	jp_rule_en_html = 'billing-japan/rules/ubl-japan/en/index.html'
	jp_rule_ja_html = 'billing-japan/rules/ubl-japan/ja/index.html'

	verbose = args.verbose
	detail = args.detail
	# Check if infile exists
	if not os.path.isfile(in_file):
		print('入力ファイルがありません')
		sys.exit()
	if verbose:
		print('** START ** ',__file__)

	# Read Schematron CSV file
	schematron_dict = {}
	schematron_keys = ('context','id','flag','test','text','BG','BT')
	with open(schematron_file,'r',encoding='utf-8') as f:
		reader = csv.DictReader(f,schematron_keys)
		header = next(reader)
		for row in reader:
			context = row['context']
			id = row['id'].strip()
			flag = row['flag'].strip()
			test = row['test'].strip()
			text = row['text'].strip()
			BG = row['BG'].strip()
			BT = row['BT'].strip()
			data = { # Identifier,Flag,Message,Message_ja
				'context':context,
				'id':id,
				'flag':flag,
				'test':test,
				'text':text,
				'BG':BG,
				'BT':BT,
			}
			schematron_dict[id] = data

	# Read Rule CSV file
	rule_keys = ('ID','Flag','Message','Message_ja')
	pint_rule_dict = {}
	with open(pint_rule_file,'r',encoding='utf-8') as f:
		reader = csv.DictReader(f,rule_keys)
		header = next(reader)
		for row in reader:
			RuleID = row['ID'].strip()
			Flag = row['Flag'].strip()
			Message = row['Message'].strip()
			Message_ja = row['Message_ja'].strip()
			data = { # Identifier,Flag,Message,Message_ja
				'RuleID':RuleID,
				'Flag':Flag,
				'Message':Message,
				'Message_ja':Message_ja
			}
			rules1 = re.findall(r'(B[TG]-[0-9]+)',Message)
			rules2 = re.findall(r'(ib[tg]-[0-9]+)',Message)
			rules = rules1+rules2
			data['PINT_IDs'] = ' '.join(rules)
			pint_rule_dict[RuleID] = data

	jp_rule_dict = {}
	with open(jp_rule_file,'r',encoding='utf-8') as f:
		reader = csv.DictReader(f,rule_keys)
		header = next(reader)
		for row in reader:
			RuleID = row['ID'].strip()
			Flag = row['Flag'].strip()
			Message = row['Message'].strip()
			Message_ja = row['Message_ja'].strip()
			data = { # Identifier,Flag,Message,Message_ja
				'RuleID':RuleID,
				'Flag':Flag,
				'Message':Message,
				'Message_ja':Message_ja
			}
			rules1 = re.findall(r'(B[TG]-[0-9]+)',Message)
			rules2 = re.findall(r'(ib[tg]-[0-9]+)',Message)
			rules = rules1+rules2
			data['PINT_IDs'] = ' '.join(rules)
			jp_rule_dict[RuleID] = data

	# Read CSV file
	keys = (
		'SemSort','EN_ID','PINT_ID','Level','BT','BT_ja','Desc','Desc_ja','Exp','Exp_ja','Example',
		'Card','DT','Section','Extension','SynSort','Path','Attr','Rules','Datatype','Occ','Align'
	)
	csv_item = OrderedDict([
		('SemSort','0000'),
		('EN_ID','BG-0'),
		('PINT_ID','ibg-00'),
		('Level','0'),
		('BT','Invoice'),
		('BT_ja','インボイス'),
		('Desc',''),
		('Desc_ja',''),
		('Exp',''),
		('Exp_ja',''),
		('Example',''),
		('Card','1..n'),
		('DT',''),
		('Section',''),
		('Extension',''),
		('SynSort','0000'),
		('Path','/Invoice'),
		('Attr',''),
		('Rules',''),
		('Datatype','InvoiceType'),
		('Occ','1..n'),
		('Align','')
	])
	csv_list = [csv_item]
	with open(in_file,'r',encoding='utf-8') as f:
		reader = csv.DictReader(f,keys)
		header = next(reader)
		# header = next(reader)
		for row in reader:
			csv_list.append(row)

	pint_list = [{
			"SemSort": "0000",
			"EN_ID": "BG-0",
			"PINT_ID": "ibg-00",
			"Level": "0",
			"BT": "Invoice",
			"BT_ja": "インボイス",
			"Desc": "",
			"Desc_ja": "",
			"Exp": "",
			"Exp_ja": "",
			"Example": "",
			"Card": "1..1 ",
			"DT": "",
			"Section": "Shared",
			"Extension": "",
			"SynSort": "0000",
			"Path": "/Invoice",
			"Attr": "",
			"Rules": "",
			"Datatype":""
		}]+[x for x in csv_list if ''!=x['SynSort'] and ''!=x['Path']]
	pint_list = sorted(pint_list,key=lambda x: x['SynSort'])

	rules = {}
	rule_dict = {}
	for data in pint_list:
		level = data['Level']
		if level:
			pint_id = data['PINT_ID']
			rules[pint_id] = set()
			for k,v in pint_rule_dict.items():
				rule_dict[k] = v
				pint_ids = v['PINT_IDs']
				if pint_ids:
					pint_ids = pint_ids.split(' ')
					if pint_id in pint_ids:
						rules[pint_id].add(k)
			for k,v in jp_rule_dict.items():
				rule_dict[k] = v
				pint_ids = v['PINT_IDs']
				if pint_ids:
					pint_ids = pint_ids.split(' ')
					if pint_id in pint_ids:
						rules[pint_id].add(k)

	with open(pint_rule_en_html,'w',encoding='utf-8',buffering=1,errors='xmlcharrefreplace',newline='') as f:
		lang = 'en'
		f.write(html_head.format(lang,APP_BASE))
		# f.write(javascript_html)
		title = PINT_RULE_MESSAGE_TITLE_en
		warning = '<p class="lead">NOTE The information provided here is currently under consideration and is subject to change.</p>'
		# 0.SPEC_TITLE_en 1.'selected' 2.'' 3.HOME_en 4.SYNTAX_MESSAGE_TITLE_en 5.'Legend' 
		# 6.legend_en 7.'Shows a ...' 8.dropdown_menu 9.tooltipTextForSearch, 10.size 11.warning 12.APP_BASE 13.jang
		# 14.NOT_SUPPORTED  15.gobacktext 16.SearchText
		html = navbar_html.format(SPEC_TITLE_en,'selected','',HOME_en,title,'Legend',legend_en,
															'Shows a modal window of legend information.',
															dropdown_menu_en,searchLegend_en,'modal-sm',warning,OP_BASE,'',
															NOT_SUPPORTED_en,'Go back to the previous page,','Search')
		f.write(html)
		f.write(table_html.format('PINT','Identifier / Message','flag'))
		for id,data in pint_rule_dict.items():
			writeTr_en(f,'ubl-pint',data)
		f.write(trailer.format('Go to top'))
		f.write(javascript_html)
		f.write('</body></html>')

	with open(pint_rule_ja_html,'w',encoding='utf-8',buffering=1,errors='xmlcharrefreplace',newline='') as f:
		lang = 'ja'
		f.write(html_head.format(lang,APP_BASE))
		# f.write(javascript_html)
		title = PINT_RULE_MESSAGE_TITLE_ja
		warning = '<p class="lead">注：ここに記載されている情報は現在検討中であり、変更される可能性があります。</p>'
		# 0.SPEC_TITLE_en 1.'selected' 2.'' 3.HOME_en 4.SYNTAX_MESSAGE_TITLE_en 5.'Legend' 
		# 6.legend_en 7.'Shows a ...' 8.dropdown_menu 9.tooltipTextForSearch, 10.size 11.warning 12.APP_BASE 13.jang
		# 14.NOT_SUPPORTED  15.gobacktext 16.SearchText
		html = navbar_html.format(SPEC_TITLE_ja,'','selected',HOME_ja,title,'凡例',legend_ja,'凡例を説明するウィンドウを表示',
															dropdown_menu_ja,searchLegend_ja,'modal-sm',warning,OP_BASE,'',
															NOT_SUPPORTED_ja,'前のページに戻る','検索')
		f.write(html)
		f.write(table_html.format('PINT','ID / メッセージ','flag'))
		for id,data in pint_rule_dict.items():
			writeTr_ja(f,'ubl-pint',data)
		f.write(trailer.format('先頭に戻る'))
		f.write(javascript_html)
		f.write('</body></html>')

	with open(jp_rule_en_html,'w',encoding='utf-8',buffering=1,errors='xmlcharrefreplace',newline='') as f:
		lang = 'en'
		f.write(html_head.format(lang,APP_BASE))
		# f.write(javascript_html)
		title = JP_RULE_MESSAGE_TITLE_en
		warning = '<p class="lead">NOTE The information provided here is currently under consideration and is subject to change.</p>'
		# 0.SPEC_TITLE_en 1.'selected' 2.'' 3.HOME_en 4.SYNTAX_MESSAGE_TITLE_en 5.'Legend' 
		# 6.legend_en 7.'Shows a ...' 8.dropdown_menu 9.tooltipTextForSearch, 10.size 11.warning 12.APP_BASE 13.jang
		# 14.NOT_SUPPORTED  15.gobacktext
		html = navbar_html.format(SPEC_TITLE_en,'selected','',HOME_en,title,'Legend',legend_en,
															'Shows a modal window of legend information.',
															dropdown_menu_en,searchLegend_en,'modal-sm',warning,OP_BASE,'',
															NOT_SUPPORTED_en,'Go back to the previous page,','Search')
		f.write(html)
		f.write(table_html.format('JP','Identifier / Message','flag'))
		for id,data in jp_rule_dict.items():
			writeTr_en(f,'ubl-japan',data)
		f.write(trailer.format('Go to top'))
		f.write(javascript_html)
		f.write('</body></html>')

	with open(jp_rule_ja_html,'w',encoding='utf-8',buffering=1,errors='xmlcharrefreplace',newline='') as f:
		lang = 'ja'
		f.write(html_head.format(lang,APP_BASE))
		# f.write(javascript_html)
		title = JP_RULE_MESSAGE_TITLE_ja
		warning = '<p class="lead">注：ここに記載されている情報は現在検討中であり、変更される可能性があります。</p>'
		# 0.SPEC_TITLE_en 1.'selected' 2.'' 3.HOME_en 4.SYNTAX_MESSAGE_TITLE_en 5.'Legend' 
		# 6.legend_en 7.'Shows a ...' 8.dropdown_menu 9.tooltipTextForSearch, 10.size 11.warning 12.APP_BASE 13.jang
		# 14.NOT_SUPPORTED  15.gobacktext
		html = navbar_html.format(SPEC_TITLE_ja,'','selected',HOME_ja,title,'凡例',legend_ja,'凡例を説明するウィンドウを表示',
															dropdown_menu_ja,searchLegend_ja,'modal-sm',warning,OP_BASE,'',
															NOT_SUPPORTED_ja,'前のページに戻る','検索')
		f.write(html)
		f.write(table_html.format('JP','ID / メッセージ','flag'))
		for id,data in jp_rule_dict.items():
			writeTr_ja(f,'ubl-japan',data)
		f.write(trailer.format('先頭に戻る'))
		f.write(javascript_html)
		f.write('</body></html>')

	for id,v in pint_rule_dict.items():
		if not id:
			continue
		lang = 'en'
		item_dir0 = 'billing-japan/rules/ubl-pint/'+id+'/'+lang

		os.makedirs(item_dir0,exist_ok=True)

		with open(item_dir0+'/index.html','w',encoding='utf-8',buffering=1,errors='xmlcharrefreplace',newline='') as f:
			f.write(item_head.format(lang,APP_BASE))
			# f.write(javascript_html)
			f.write('</head><body>')
			# 0.SPEC_TITLE_en 1.'selected' 2.'' 3.APP_BASE 4.lang 5.'Legend' 6.info_item_modal_en 7.dropdown_menu 8.tooltipText 9.size 10.gobcckText 11.warning
			f.write(item_navbar.format(SPEC_TITLE_en,'selected','',OP_BASE,'',
																'Legend',info_item_modal_en,dropdown_menu_en,'Show Legend','modal-lg',
																'Go back to the previous page,',warning_en))
			# 0.lang 1.HOME_en 2.'Transction Business Rules' 3.'ubl-pint' 4.PINT_RULE_MESSAGE_TITLE_en 5.id
			f.write(item_breadcrumb.format(lang,HOME_en,'Transction Business Rules','ubl-pint',PINT_RULE_MESSAGE_TITLE_en,id))
			if id in schematron_dict:
				data = schematron_dict[id]
				BGroup = termTable(data['BG'],lang)
				BTerm = termTable(data['BT'],lang)
				title = id+' ('+data['flag']+')'
				f.write(item_header.format(title,v['Message']))
				html = item_data.format('context','<code>'+data['context']+'</code>','test','<code>'+data['test']+'</code>', \
																'Associated Business term Group',BGroup,'Associated Business Term',BTerm)
				f.write(html)
			else:
				f.write(item_header.format(id,v['Message']))
				GBT = lookupBGT(id,lang)
				BGroup = GBT['BGroup']
				BTerm = GBT['BTerm']
				html = item_data.format('context','** The rule is not defined in the schematron file. **','test','<i class="fa fa-minus" aria-hidden="true"></i>',
																'Associated Business term Group',BGroup,'Associated Business Term',BTerm)
				f.write(html)
			f.write(item_trailer.format('Go to top'))
			f.write(javascript_html)
			f.write('</body></html>')

		lang = 'ja'
		item_dir0 = 'billing-japan/rules/ubl-pint/'+id+'/'+lang
		os.makedirs(item_dir0,exist_ok=True)
		with open(item_dir0+'/index.html','w',encoding='utf-8',buffering=1,errors='xmlcharrefreplace',newline='') as f:
			f.write(item_head.format(lang,APP_BASE))
			# f.write(javascript_html)
			# 0.SPEC_TITLE_en 1.'selected' 2.'' 3.lang 4.APP_BASE 5.'凡例' 6.info_item_modal_ja 7.dropdown_menu_ja 8.tooltipText 9.gobacktext
			f.write(item_navbar.format(SPEC_TITLE_ja,'','selected',OP_BASE,'',
																'凡例',info_item_modal_ja,dropdown_menu_ja,'凡例を表示','modal-lg','前のページに戻る',warning_ja))
			# 0.lang 1.HOME_en 2.'Transction Business Rules' 3.'ubl-pint' 4.PINT_RULE_MESSAGE_TITLE_en 5.id
			f.write(item_breadcrumb.format(lang,HOME_ja,'ビジネスルール','ubl-pint',PINT_RULE_MESSAGE_TITLE_ja,id))
			if id in schematron_dict:
				data = schematron_dict[id]
				BGroup = lookupBG(data,'ja')
				BTerm = lookupBT(data,'ja')
				title = id+' ('+data['flag']+')'
				f.write(item_header.format(title,v['Message_ja']))
				html = item_data.format('対象(context)','<code>'+data['context']+'</code>','検証(test)','<code>'+data['test']+'</code>', \
																'関連するビジネス用語グループ',BGroup,'関連するビジネス用語',BTerm)
				f.write(html)
			else:
				GBT = lookupBGT(id,'ja')
				BGroup = GBT['BGroup']
				BTerm = GBT['BTerm']
				f.write(item_header.format(id,v['Message_ja']))
				html = item_data.format('対象(context)','** スキーマトロンのビジネスルールは検討中 **','検証(test)','<i class="fa fa-minus" aria-hidden="true"></i>', \
																'関連するビジネス用語グループ',BGroup,'関連するビジネス用語',BTerm)
				f.write(html)
			f.write(item_trailer.format('先頭に戻る'))
			f.write(javascript_html)
			f.write('</body></html>')

	for id,v in jp_rule_dict.items():
		if not id:
			continue
		lang = 'en'
		item_dir0 = 'billing-japan/rules/ubl-japan/'+id+'/'+lang
		os.makedirs(item_dir0,exist_ok=True)
		with open(item_dir0+'/index.html','w',encoding='utf-8',buffering=1,errors='xmlcharrefreplace',newline='') as f:
			f.write(item_head.format(lang,APP_BASE))
			# f.write(javascript_html)
			# 0.SPEC_TITLE_en 1.'selected' 2.'' 3.lang 4.APP_BASE 5.'Legend' 6.info_item_modal_en 7.dropdown_menu_en　8.tooltipText 9.gobacktext
			f.write(item_navbar.format(SPEC_TITLE_en,'selected','',OP_BASE,'',
																'Legend',info_item_modal_en,dropdown_menu_en,'Show Legend','modal-lg',
																'Go back to the previous page,',warning_en))
			# 0.lang 1.HOME_en 2.'Transction Business Rules' 3.'ubl-pint' 4.PINT_RULE_MESSAGE_TITLE_en 5.id
			f.write(item_breadcrumb.format(lang,HOME_en,'Transction Business Rules','ubl-japan',JP_RULE_MESSAGE_TITLE_en,id))
			if id in schematron_dict:
				data = schematron_dict[id]
				BGroup = lookupBG(data,lang)
				BTerm = lookupBT(data,lang)
				title = id+' ('+data['flag']+')'
				f.write(item_header.format(title,v['Message']))
				html = item_data.format('context','<code>'+data['context']+'</code>','test','<code>'+data['test']+'</code>', \
																# 'Flag',data['flag'], \
																'Associated Business term Group',BGroup,'Associated Business Term',BTerm)
				f.write(html)
			else:
				GBT = lookupBGT(id,lang)
				BGroup = GBT['BGroup']
				BTerm = GBT['BTerm']
				f.write(item_header.format(id,v['Message']))
				html = item_data.format('context','** The rule is not defined in the schematron file. **','test','<i class="fa fa-minus" aria-hidden="true"></i>', 
																'Associated Business term Group',BGroup,'Associated Business Term',BTerm)
				f.write(html)
			f.write(item_trailer.format('Go to top'))
			f.write(javascript_html)
			f.write('</body></html>')

		lang = 'ja'
		item_dir0 = 'billing-japan/rules/ubl-japan/'+id+'/'+lang
		os.makedirs(item_dir0,exist_ok=True)
		with open(item_dir0+'/index.html','w',encoding='utf-8',buffering=1,errors='xmlcharrefreplace',newline='') as f:
			f.write(item_head.format(lang,APP_BASE))
			# f.write(javascript_html)
			# 0.SPEC_TITLE_en 1.'selected' 2.'' 3.lang 4.APP_BASE 5.'凡例' 6.info_item_modal_ja 7.dropdown_menu_ja 8.tooltipText 9.gobacktext 10.warning
			f.write(item_navbar.format(SPEC_TITLE_ja,'','selected',OP_BASE,'',
																'凡例',info_item_modal_ja,dropdown_menu_ja,'凡例を表示','modal-lg','前のページに戻る',warning_ja))
			# 0.lang 1.HOME_en 2.'Transction Business Rules' 3.'ubl-pint' 4.PINT_RULE_MESSAGE_TITLE_en 5.id
			f.write(item_breadcrumb.format(lang,HOME_ja,'ビジネスルール','ubl-japan',JP_RULE_MESSAGE_TITLE_ja,id))
			if id in schematron_dict:
				data = schematron_dict[id]
				BGroup = lookupBG(data,lang)
				BTerm = lookupBT(data,lang)
				title = id+' ('+data['flag']+')'
				f.write(item_header.format(title,v['Message_ja']))
				html = item_data.format('対象(context)','<code>'+data['context']+'</code>','検証(test)','<code>'+data['test']+'</code>', \
																'関連するビジネス用語グループ',BGroup,'関連するビジネス用語',BTerm)
				f.write(html)
			else:
				GBT = lookupBGT(id,lang)
				BGroup = GBT['BGroup']
				BTerm = GBT['BTerm']
				f.write(item_header.format(id,v['Message_ja']))
				html = item_data.format('対象(context)','** スキーマトロンのビジネスルールは検討中 **','検証(test)','<i class="fa fa-minus" aria-hidden="true"></i>', \
																'関連するビジネス用語グループ',BGroup,'関連するビジネス用語',BTerm)
				f.write(html)
			f.write(item_trailer.format('先頭に戻る'))
			f.write(javascript_html)
			f.write('</body></html>')

	if verbose:
		print(f'** END ** {pint_rule_en_html} {pint_rule_ja_html} {jp_rule_en_html} {jp_rule_ja_html}')