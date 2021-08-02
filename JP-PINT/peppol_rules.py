#!/usr/bin/env python3
#coding: utf-8
#
# generate PEPPOL rules html fron CSV file
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
import re
import json
import sys 
import os
import argparse

import jp_pint_constants

APP_BASE = jp_pint_constants.APP_BASE
SEMANTIC_BASE = jp_pint_constants.SEMANTIC_BASE
SYNTAX_BASE = jp_pint_constants.SYNTAX_BASE
RULES_BASE = jp_pint_constants.RULES_BASE
RULES_UBL_JAPAN_BASE = jp_pint_constants.RULES_UBL_JAPAN_BASE
RULES_UBL_PINT_BASE = jp_pint_constants.RULES_UBL_PINT_BASE
SPEC_TITLE_en = jp_pint_constants.SPEC_TITLE_en
SPEC_TITLE_ja = jp_pint_constants.SPEC_TITLE_ja
SEMANTICS_MESSAGE_TITLE_en = jp_pint_constants.SEMANTICS_MESSAGE_TITLE_en
SEMANTICS_MESSAGE_TITLE_ja = jp_pint_constants.SEMANTICS_MESSAGE_TITLE_ja
SYNTAX_MESSAGE_TITLE_en = jp_pint_constants.SYNTAX_MESSAGE_TITLE_en
SYNTAX_MESSAGE_TITLE_ja = jp_pint_constants.SYNTAX_MESSAGE_TITLE_ja
peppol_rule_MESSAGE_TITLE_en = jp_pint_constants.peppol_rule_MESSAGE_TITLE_en
peppol_rule_MESSAGE_TITLE_ja = jp_pint_constants.peppol_rule_MESSAGE_TITLE_ja
cen_rule_MESSAGE_TITLE_en = jp_pint_constants.cen_rule_MESSAGE_TITLE_en
cen_rule_MESSAGE_TITLE_ja = jp_pint_constants.cen_rule_MESSAGE_TITLE_ja
HOME_en = jp_pint_constants.HOME_en
HOME_ja = jp_pint_constants.HOME_ja

html_head = jp_pint_constants.html_head
javascript_html = jp_pint_constants.javascript_html
navbar_html = jp_pint_constants.navbar_html
dropdown_menu_en = jp_pint_constants.dropdown_menu_en.format(APP_BASE)
dropdown_menu_ja = jp_pint_constants.dropdown_menu_ja.format(APP_BASE)
legend_en ='''
'''
legend_ja ='''
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
table_trailer = jp_pint_constants.table_trailer
trailer = jp_pint_constants.trailer
# ITEM
item_head = jp_pint_constants.item_head
info_item_modal_en = '''
'''
info_item_modal_ja = '''
'''
item_navbar = jp_pint_constants.item_navbar
# 0.lang 1.HOME_en 2.'Transction Business Rules' 3.'en-peppol' 4.peppol_rule_MESSAGE_TITLE_en 5.id 6.APP_BASE
item_breadcrumb = '''
			<ol class="breadcrumb pt-1 pb-1">
        <li class="breadcrumb-item"><a href="{6}{0}/">{1}</a></li>
        <li class="breadcrumb-item"><a href="{6}rules/{0}">{2}</a></li>
        <li class="breadcrumb-item"><a href="{6}rules/{3}/{0}/">{4}</a></li>
        <li class="breadcrumb-item active">{5}</li>
    </ol>
'''
item_header = jp_pint_constants.item_header
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
# 0.lang 1.id 2.term 3.APP_BASE 4.pint_id
item_table_row = '''
						<tr>
							<td><a href="{3}semantic/invoice/{4}/{0}/">{1}</a></td>
							<td>{2}</td>
						</tr>
'''
item_table_trailer = '''
						</tbody>
					</table>
''' 
item_trailer = jp_pint_constants.item_trailer

datatypeDict = {
	'ID': 'Identifier',
	'Unit': 'Unit Price Amount',
	'REF (Optional)': 'Document Reference',
	'Binary': 'Binary objects'
}

def file_path(pathname):
	if '/' == pathname[0:1]:
		return pathname
	else:
		dir = os.path.dirname(__file__)
		new_path = os.path.join(dir,pathname)
		return new_path

def writeTr_en(f,type,data):
	html = '''
							<tr data-id="{0}">
								<td class="info-link"><a href="{1}">{0}</a><br />{2}</td>
								<td>{3}</td>
							</tr>
	'''
	# tabs = '\t\t\t\t\t\t'
	id = data['id']
	flag = data['flag']
	text = data['text']
	# f.write(tabs+'<tr data-id="'+id+'">\n')
	item_dir = RULES_BASE+type+id+'/en/'
	html = html.format(id,item_dir,text,flag)
	f.write(html)
	# f.write(tabs+'\t<td class="info-link"><a href="'+item_dir+'">'+id+'</a><br />'+text+'</td>\n')
	# f.write(tabs+'\t<td>'+flag+'</td>\n')
	# f.write(tabs+'</tr>\n')

def writeTr_ja(f,type,data):
	html = '''
							<tr data-id="{0}">
								<td class="info-link"><a href="{1}">{0}</a><br />{2}</td>
								<td>{3}</td>
							</tr>
	'''
	# tabs = '\t\t\t\t\t\t'
	id = data['id']
	flag = data['flag']
	text = data['text']
	# f.write(tabs+'<tr data-id="'+id+'">\n')
	item_dir = RULES_BASE+type+id+'/ja/'
	html = html.format(id,item_dir,text,flag)
	f.write(html)
	# f.write(tabs+'\t<td class="info-link"><a href="'+item_dir+'">'+id+'</a><br />'+text+'</td>\n')
	# f.write(tabs+'\t<td>'+flag+'</td>\n')
	# f.write(tabs+'</tr>\n')

def blank2nbsp(str):
	if str:
		return str
	return '&nbsp;'

# def checkRules(data, lang):
# 	id = data['PINT_ID']
# 	if not id:
# 		return ''
# 	Rules = data['Rules']
# 	if Rules:
# 		Rules = Rules.split(',')
# 	Rs = ''
# 	diff0 = []
# 	for r in Rules:
# 		if r in rule_dict:
# 			if r in rule_dict:
# 				if 'ja' == lang:
# 					message = rule_dict[r]['Message_ja']
# 				else:
# 					message = rule_dict[r]['Message']
# 				schematron = rule_dict[r]
# 				context = schematron['context']
# 				flag = schematron['flag']
# 				test = schematron['test']
# 				Rs += '<h5>'+r+' ('+flag+')</h5>'+message+'<br />'
# 				Rs += '<dl class="row">'
# 				if 'ja' == lang:
# 					Rs += '<dt class="col-3">対象(context)</dt><dd class="col-9">'+context+'</dd>'+ \
# 								'<dt class="col-3">検証(test)</dt><dd class="col-9">'+test+'</dd>'
# 				else:
# 					Rs += '<dt class="col-3">cotext</dt><dd class="col-9">'+context+'</dd>'+ \
# 								'<dt class="col-3">test</dt><dd class="col-9">'+test+'</dd>'
# 				Rs += '</dl>'
# 			else:
# 				if 'ja' == lang:
# 					Rs += '** 未定義 **<br />'
# 				else:
# 					Rs += '** Not defined **<br />'
# 		else:
# 			diff0.append(r)
# 	rules_ = rules[id]
# 	if rules_:
# 		rules_ = list(rules_)
# 	diff1 = list(set(rules_) - set(Rules))
# 	diff2 = list(set(Rules) - set(rules_) - set(diff0))
# 	if len(diff0) > 0:
# 		Rs += '<span class="text-danger"><strong>'
# 		if 'ja' == lang:
# 			Rs += 'スキーマトロンで未定義'
# 		else:
# 			Rs += 'Not defined in the schematron file.'
# 		Rs += '</strong></span><br />'
# 		for r in diff0:
# 			Rs += r+' '
# 		Rs += '<br />'
# 	if len(diff1) > 0:
# 		Rs += '<span class="text-danger"><strong>'
# 		if 'ja' == lang:
# 			Rs += 'PINTモデルで未定義'
# 		else:
# 			Rs += 'Not defined in the semantic model.'
# 		Rs += '</strong></span><br />'
# 		for r in diff1:
# 			Rs += r+' '
# 		Rs += '<br />'
# 	if len(diff2) > 0:
# 		Rs += '<span class="text-danger"><strong>'
# 		if 'ja' == lang:
# 			Rs += data['PINT_ID']+'は、PINTルールで未言及'
# 		else:
# 			Rs += data['PINT_ID']+' is not mentioned in the rule.'
# 		Rs += '</strong></span><br />'
# 		for r in diff2:
# 			Rs += r+' '
# 		Rs += '<br />'
# 	if Rs[-6:]=='<bt />':
# 		Rs = Rs[:-6]
# 	return Rs

def lookupBG(data, lang):
	table ='&nbsp;'
	BGs = data['BG']
	if len(BGs) > 0:
		table = item_table_head
		BGs = BGs.split(' ')
		for id in BGs:
			if 'BG' == id[:2]:
				pint_id = 'i'+id[:3].lower()+'{:02d}'.format(int(id[3:]))
			elif 'BT' == id[:2]:
				pint_id = 'i'+id[:3].lower()+'{:03d}'.format(int(id[3:]))
			else:
				continue
			if 'ja' == lang:
				term = [x['BT_ja'] for x in pint_list if pint_id == x['PINT_ID']]
			else:
				term = [x['BT'] for x in pint_list if pint_id == x['PINT_ID']]
			if len(term) > 0:
				term = term[0]
				table += item_table_row.format(lang,id,term,APP_BASE,pint_id)
			else:
				table += item_table_row.format(lang,id,'Not found',APP_BASE,pint_id)
		table += item_table_trailer
	return table
		
def lookupBT(data,lang):
	table = '&nbsp;'
	BTs = data['BT']
	if len(BTs) > 0:
		table = item_table_head
		BTs = BTs.split(' ')
		for id in BTs:
			if 'BG' == id[:2]:
				pint_id = 'i'+id[:3].lower()+'{:02d}'.format(int(id[3:]))
			elif 'BT' == id[:2]:
				pint_id = 'i'+id[:3].lower()+'{:03d}'.format(int(id[3:]))
			else:
				continue
			if 'ja' == lang:
				term = [x['BT_ja'] for x in pint_list if pint_id == x['PINT_ID']]
			else:
				term = [x['BT'] for x in pint_list if pint_id == x['PINT_ID']]
			if len(term) > 0:
				term = term[0]
				table += item_table_row.format(lang,id,term,APP_BASE,pint_id)
			else:
				table += item_table_row.format(lang,id,'Not found',APP_BASE,pint_id)
		table += item_table_trailer
	return table

def lookupBGT(id,lang):
	rule = cen_rule_dict[id]
	if len(rule) > 0:
		pint_ids = rule['PINT_IDs']
	else:
		rule = peppol_rule_dict[id]
		if len(rule) > 0:
			pint_ids = rule['PINT_IDs']
	pint_ids = pint_ids.split(' ')
	BGs = ' '.join([x for x in pint_ids if re.match(r'^BG-.*$',x)])
	BGroup = termTable(BGs,lang)
	BTs = ' '.join([x for x in pint_ids if re.match(r'^BT-.*$',x)])
	BTerm = termTable(BTs,lang)
	return {'BGroup':BGroup,'BTerm':BTerm}

def termTable(terms,lang):
	table = '&nbsp;'
	if len(terms) > 0:
		table = item_table_head
		terms = terms.split(' ')
		for id in terms:
			if 'BG' == id[2:]:
				pint_id = 'i'+id[:3].lower()+'{:02d}'.format(int(id[3:]))
			elif 'BT' == id[2:]:
				pint_id = 'i'+id[:3].lower()+'{:03d}'.format(int(id[3:]))
			else:
				continue
			if 'ja' == lang:
				term = [x['BT_ja'] for x in pint_list if pint_id == x['PINT_ID']]
			else:
				term = [x['BT'] for x in pint_list if pint_id == x['PINT_ID']]
			if len(term) > 0:
				term = term[0]
				table += item_table_row.format(lang,id,term,APP_BASE,pint_id)
			else:
				table += item_table_row.format(lang,id,'Not found',APP_BASE,pint_id)
		table += item_table_trailer
	return table

if __name__ == '__main__':
	# Create the parser
	parser = argparse.ArgumentParser(prog='genInvoice',
																	usage='%(prog)s [options] infile ppeppol_rulefile cen_rulefile',
																	description='CSVファイルからPEPPOLのHTMLファイル(ルール)を作成')
	# Add the arguments
	parser.add_argument('inFile',metavar='infile',type=str,help='入力TSVファイル')
	parser.add_argument('peppol_ruleFile',metavar='peppol_rulefile',type=str,help='PEPPOLルールCSVファイル')
	parser.add_argument('cen_ruleFile',metavar='cen_rulefile',type=str,help='CENルールCSVファイル')
	parser.add_argument('-v','--verbose',action='store_true')
	args = parser.parse_args()

	in_file = file_path(args.inFile)
	peppol_rule_file = file_path(args.peppol_ruleFile)
	cen_rule_file = file_path(args.cen_ruleFile)

	peppol_rule_en_html = 'billing-japan/rules/en-peppol/en/index.html'
	peppol_rule_ja_html = 'billing-japan/rules/en-peppol/ja/index.html'
	cen_rule_en_html = 'billing-japan/rules/en-cen/en/index.html'
	cen_rule_ja_html = 'billing-japan/rules/en-cen/ja/index.html'

	verbose = args.verbose
	# Check if infile exists
	if not os.path.isfile(in_file):
		print('入力ファイルがありません')
		sys.exit()
	if verbose:
		print('** START ** ',__file__)

	# Read Rule CSV file
	rule_keys = ('context','id','flag','test','text')
	peppol_rule_dict = {}
	with open(peppol_rule_file,'r',encoding='utf-8') as f:
		reader = csv.DictReader(f,rule_keys)
		header = next(reader)
		for row in reader:
			id = row['id']
			flag = row['flag']
			text = row['text']
			context = row['context']
			test = row['test']
			data = { # 'context','id','flag','test','text'
				'id':id,
				'flag':flag,
				'text':text,
				'context':context,
				'test':test
			}
			rulesBG = re.findall(r'(BG-[0-9]+)',text)
			data['BG'] = ' '.join(rulesBG)
			rulesBT = re.findall(r'(BT-[0-9]+)',text)
			data['BT'] = ' '.join(rulesBT)
			rules = rulesBG + rulesBT
			data['PINT_IDs'] = ' '.join(rules)
			peppol_rule_dict[id] = data

	cen_rule_dict = {}
	with open(cen_rule_file,'r',encoding='utf-8') as f:
		reader = csv.DictReader(f,rule_keys)
		header = next(reader)
		for row in reader:
			id = row['id']
			flag = row['flag']
			text = row['text']
			context = row['context']
			test = row['test']
			data = { # 'context','id','flag','test','text'
				'id':id,
				'flag':flag,
				'text':text,
				'context':context,
				'test':test
			}
			rulesBG = re.findall(r'(BG-[0-9]+)',text)
			data['BG'] = ' '.join(rulesBG)
			rulesBT = re.findall(r'(BT-[0-9]+)',text)
			data['BT'] = ' '.join(rulesBT)
			rules = rulesBG + rulesBT
			data['PINT_IDs'] = ' '.join(rules)
			cen_rule_dict[id] = data

	# Read CSV file
	csv_list = []
	keys = (
		'SemSort','EN_ID','PINT_ID','Level','BT','BT_ja','Desc','Desc_ja','Exp','Exp_ja','Example',
		'Card','DT','Section','Extension','SynSort','Path','Attr','Rules','Datatype','Occ','Align'
	)
	with open(in_file,'r',encoding='utf-8') as f:
		reader = csv.DictReader(f,keys)
		header = next(reader)
		header = next(reader)
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
			"Datatype":"",
			"Occ":"",
			"Align":""
		}]+[x for x in csv_list if ''!=x['SynSort'] and ''!=x['Path']]
	pint_list = sorted(pint_list,key=lambda x: x['SynSort'])

	rules = {}
	rule_dict = {}
	for data in pint_list:
		level = data['Level']
		if level:
			pint_id = data['PINT_ID']
			rules[pint_id] = set()
			for k,v in peppol_rule_dict.items():
				rule_dict[k] = v
				pint_ids = v['PINT_IDs']
				if pint_ids:
					pint_ids = pint_ids.split(' ')
					if pint_id in pint_ids:
						rules[pint_id].add(k)
			for k,v in cen_rule_dict.items():
				rule_dict[k] = v
				pint_ids = v['PINT_IDs']
				if pint_ids:
					pint_ids = pint_ids.split(' ')
					if pint_id in pint_ids:
						rules[pint_id].add(k)

	with open(peppol_rule_en_html,'w',encoding='utf-8') as f:
		lang = 'en'
		f.write(html_head.format(lang,APP_BASE))
		f.write(javascript_html)
		# 0.SPEC_TITLE_en 1.'selected' 2.'' 3.HOME_en 4.MESSAGE_TITLE_en 5.lang 6.APP_BASE 
		# 7.'Legend' 8.legend_en 9.'Shows a ...' 10.dropdown_menu_en 11.tooltipTextForSearch
		html = navbar_html.format(SPEC_TITLE_en,'selected','',HOME_en,peppol_rule_MESSAGE_TITLE_en,lang, \
															APP_BASE,'Legend',legend_en,'Shows a modal window of legend information.', \
															dropdown_menu_en,'ID or word in Term/Description')
		f.write(html)
		f.write(table_html.format('PINT','Identifier / Error message','Flag'))
		for id,data in peppol_rule_dict.items():
			writeTr_en(f,'en-peppol/',data)
		f.write(trailer)

	with open(peppol_rule_ja_html,'w',encoding='utf-8') as f:
		lang = 'ja'
		f.write(html_head.format(lang,APP_BASE))
		f.write(javascript_html)
		# 0.SPEC_TITLE_en 1.'selected' 2.'' 3.HOME_en 4.MESSAGE_TITLE_en 5.lang 6.APP_BASE 
		# 7.'凡例' 8.legend_ja 9.'凡例を説明するウィンドウを表示' 10.dropdown_menu_ja 11.tooltipTextForSearch
		html = navbar_html.format(SPEC_TITLE_ja,'','selected',HOME_ja,peppol_rule_MESSAGE_TITLE_ja,lang, \
															APP_BASE,'凡例',legend_ja,'凡例を説明するウィンドウを表示', \
															dropdown_menu_ja,'IDまたは用語/説明文が含む単語')
		f.write(html)
		f.write(table_html.format('PINT','ID / エラ-メッセージ','重要度'))
		for id,data in peppol_rule_dict.items():
			writeTr_ja(f,'en-peppol/',data)
		f.write(trailer)

	with open(cen_rule_en_html,'w',encoding='utf-8') as f:
		lang = 'en'
		f.write(html_head.format(lang,APP_BASE))
		f.write(javascript_html)
		# 0.SPEC_TITLE_en 1.'selected' 2.'' 3.HOME_en 4.MESSAGE_TITLE_en 5.lang 6.APP_BASE 
		# 7.'Legend' 8.legend_en 9.'Shows a ...' 10.dropdown_menu_en 11.tooltipTextForSearch
		html = navbar_html.format(SPEC_TITLE_en,'selected','',HOME_en,cen_rule_MESSAGE_TITLE_en,lang, \
															APP_BASE,'Legend',legend_en,'Shows a modal window of legend information.', \
															dropdown_menu_en,'ID or word in Term/Description')
		f.write(html)
		f.write(table_html.format('JP','Identifier / Error message','Flag'))
		for id,data in cen_rule_dict.items():
			writeTr_en(f,'en-cen/',data)
		f.write(trailer)

	with open(cen_rule_ja_html,'w',encoding='utf-8') as f:
		lang = 'ja'
		f.write(html_head.format(lang,APP_BASE))
		f.write(javascript_html)
		# 0.SPEC_TITLE_en 1.'selected' 2.'' 3.HOME_en 4.MESSAGE_TITLE_en 5.lang 6.APP_BASE 
		# 7.'凡例' 8.legend_ja 9.'凡例を説明するウィンドウを表示' 10.dropdown_menu_ja 11.tooltipTextForSearch
		html = navbar_html.format(SPEC_TITLE_ja,'','selected',HOME_ja,cen_rule_MESSAGE_TITLE_ja,lang, \
															APP_BASE,'凡例',legend_ja,'凡例を説明するウィンドウを表示', \
															dropdown_menu_ja,'IDまたは用語/説明文が含む単語')
		f.write(html)
		f.write(table_html.format('JP','ID / エラ-メッセージ','重要度'))
		for id,data in cen_rule_dict.items():
			writeTr_ja(f,'en-cen/',data)
		f.write(trailer)

	for id,v in peppol_rule_dict.items():
		if not id:
			continue
		lang = 'en'
		item_dir0 = 'billing-japan/rules/en-peppol/'+id+'/'+lang
		os.makedirs(item_dir0,exist_ok=True)
		with open(item_dir0+'/index.html','w',encoding='utf-8') as f:
			f.write(item_head.format(lang,APP_BASE))
			f.write(javascript_html)
			f.write('</head><body>')
			# 0.SPEC_TITLE_en 1.'selected' 2.'' 3.lang 4.APP_BASE 5.'Legend' 6.info_item_modal_en 7.dropdown_menu_en　8.tooltipText
			f.write(item_navbar.format(SPEC_TITLE_en,'selected','',lang,APP_BASE,'Legend',info_item_modal_en,dropdown_menu_en,'Show Legend'))
			# 0.lang 1.HOME_en 2.'Transction Business Rules' 3.'en-peppol' 4.peppol_rule_MESSAGE_TITLE_en 5.id 6.APP_BASE
			f.write(item_breadcrumb.format(lang,HOME_en,'Transction Business Rules','en-peppol',peppol_rule_MESSAGE_TITLE_en, \
																			id,APP_BASE))
			if id in rule_dict:
				data = rule_dict[id]
				title = id+' ('+data['flag']+')'
				f.write(item_header.format(title,v['text']))
				BGroup = termTable(data['BG'],lang)
				BTerm = termTable(data['BT'],lang)
				html = item_data.format('context',data['context'],'test',data['test'], \
																'Associated Business term Group',BGroup,'Associated Business Term',BTerm)
				f.write(html)
			else:
				f.write(item_header.format(id,v['text']))
				GBT = lookupBGT(id,lang)
				BGroup = GBT['BGroup']
				BTerm = GBT['BTerm']
				html = item_data.format('context','** The rule is not defined in the schematron file. **','test','&nbsp;',
																'Associated Business term Group',BGroup,'Associated Business Term',BTerm)
				f.write(html)
			f.write(item_trailer)

		lang = 'ja'
		item_dir0 = 'billing-japan/rules/en-peppol/'+id+'/'+lang
		os.makedirs(item_dir0,exist_ok=True)
		with open(item_dir0+'/index.html','w',encoding='utf-8') as f:
			f.write(item_head.format(lang,APP_BASE))
			f.write(javascript_html)
			# 0.SPEC_TITLE_en 1.'selected' 2.'' 3.lang 4.APP_BASE 5.'凡例' 6.info_item_modal_ja 7.dropdown_menu_ja 8.tooltipText
			f.write(item_navbar.format(SPEC_TITLE_ja,'','selected',lang,APP_BASE,'凡例',info_item_modal_ja,dropdown_menu_ja,'凡例を表示'))
			# 0.lang 1.HOME_en 2.'Transction Business Rules' 3.'en-peppol' 4.peppol_rule_MESSAGE_TITLE_en 5.id 6.APP_BASE
			f.write(item_breadcrumb.format(lang,HOME_ja,'ビジネスルール','en-peppol',peppol_rule_MESSAGE_TITLE_ja, \
																			id,APP_BASE))
			if id in rule_dict:
				data = rule_dict[id]
				title = id+' ('+data['flag']+')'
				f.write(item_header.format(title,v['text']))
				BGroup = lookupBG(data,'ja')
				BTerm = lookupBT(data,'ja')
				html = item_data.format('対象(context)',data['context'],'検証(test)',data['test'], \
																'関連するビジネス用語グループ',BGroup,'関連するビジネス用語',BTerm)
				f.write(html)
			else:
				GBT = lookupBGT(id,lang)
				BGroup = GBT['BGroup']
				BTerm = GBT['BTerm']
				f.write(item_header.format(id,v['text']))
				html = item_data.format('対象(context)','** ビジネスルールは、スキーマトロンで未定義 **','検証(test)','&nbsp;', \
																'関連するビジネス用語グループ',BGroup,'関連するビジネス用語',BTerm)
				f.write(html)
			f.write(item_trailer)

	for id,v in cen_rule_dict.items():
		if not id:
			continue
		lang = 'en'
		item_dir0 = 'billing-japan/rules/en-cen/'+id+'/'+lang
		os.makedirs(item_dir0,exist_ok=True)
		with open(item_dir0+'/index.html','w',encoding='utf-8') as f:
			f.write(item_head.format(lang,APP_BASE))
			f.write(javascript_html)
			# 0.SPEC_TITLE_en 1.'selected' 2.'' 3.lang 4.APP_BASE 5.'Legend' 6.info_item_modal_en 7.dropdown_menu_en　8.tooltipText
			f.write(item_navbar.format(SPEC_TITLE_en,'selected','',lang,APP_BASE,'Legend',info_item_modal_en,dropdown_menu_en,'Show Legend'))
			# 0.lang 1.HOME_en 2.'Transction Business Rules' 3.'en-peppol' 4.peppol_rule_MESSAGE_TITLE_en 5.id 6.APP_BASE
			f.write(item_breadcrumb.format(lang,HOME_en,'Transction Business Rules','en-cen',cen_rule_MESSAGE_TITLE_en, \
																			id,APP_BASE))
			if id in rule_dict:
				data = rule_dict[id]
				title = id+' ('+data['flag']+')'
				f.write(item_header.format(title,v['text']))
				BGroup = lookupBG(data,lang)
				BTerm = lookupBT(data,lang)
				html = item_data.format('context',data['context'],'test',data['test'], \
																'Associated Business term Group',BGroup,'Associated Business Term',BTerm)
				f.write(html)
			else:
				GBT = lookupBGT(id,lang)
				BGroup = GBT['BGroup']
				BTerm = GBT['BTerm']
				f.write(item_header.format(id,v['text']))
				html = item_data.format('context','** The rule is not defined in the schematron file. **','test','&nbsp;', 
																'Associated Business term Group',BGroup,'Associated Business Term',BTerm)
				f.write(html)
			f.write(item_trailer)

		lang = 'ja'
		item_dir0 = 'billing-japan/rules/en-cen/'+id+'/'+lang
		os.makedirs(item_dir0,exist_ok=True)
		with open(item_dir0+'/index.html','w',encoding='utf-8') as f:
			f.write(item_head.format(lang,APP_BASE))
			f.write(javascript_html)
			# 0.SPEC_TITLE_en 1.'selected' 2.'' 3.lang 4.APP_BASE 5.'凡例' 6.info_item_modal_ja 7.dropdown_menu_ja 8.tooltipText
			f.write(item_navbar.format(SPEC_TITLE_ja,'','selected',lang,APP_BASE,'凡例',info_item_modal_ja,dropdown_menu_ja,'凡例を表示'))
			# 0.lang 1.HOME_en 2.'Transction Business Rules' 3.'en-peppol' 4.peppol_rule_MESSAGE_TITLE_en 5.id 6.APP_BASE
			f.write(item_breadcrumb.format(lang,HOME_ja,'ビジネスルール','en-cen',cen_rule_MESSAGE_TITLE_ja, \
																			id,APP_BASE))
			if id in rule_dict:
				data = rule_dict[id]
				title = id+' ('+data['flag']+')'
				f.write(item_header.format(title,v['text']))
				BGroup = lookupBG(data,lang)
				BTerm = lookupBT(data,lang)
				html = item_data.format('対象(context)',data['context'],'検証(test)',data['test'], \
																'関連するビジネス用語グループ',BGroup,'関連するビジネス用語',BTerm)
				f.write(html)
			else:
				GBT = lookupBGT(id,lang)
				BGroup = GBT['BGroup']
				BTerm = GBT['BTerm']
				f.write(item_header.format(id,v['text']))
				html = item_data.format('対象(context)','** ビジネスルールは、スキーマトロンで未定義 **','検証(test)','&nbsp;', \
																'関連するビジネス用語グループ',BGroup,'関連するビジネス用語',BTerm)
				f.write(html)
			f.write(item_trailer)

	if verbose:
		print(f'** END ** {peppol_rule_en_html} {peppol_rule_ja_html} {cen_rule_en_html} {cen_rule_ja_html}')