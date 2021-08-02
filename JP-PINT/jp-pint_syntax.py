#!/usr/bin/env python3
#coding: utf-8
#
# generate JP-PINT syntax html fron CSV file
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
PINT_RULE_MESSAGE_TITLE_en = jp_pint_constants.PINT_RULE_MESSAGE_TITLE_en
PINT_RULE_MESSAGE_TITLE_ja = jp_pint_constants.PINT_RULE_MESSAGE_TITLE_ja
JP_RULE_MESSAGE_TITLE_en = jp_pint_constants.JP_RULE_MESSAGE_TITLE_en
JP_RULE_MESSAGE_TITLE_ja = jp_pint_constants.JP_RULE_MESSAGE_TITLE_ja
HOME_en = jp_pint_constants.HOME_en
HOME_ja = jp_pint_constants.HOME_ja

html_head = jp_pint_constants.html_head
javascript_html = jp_pint_constants.javascript_html
navbar_html = jp_pint_constants.navbar_html
dropdown_menu_en = jp_pint_constants.dropdown_menu_en.format(APP_BASE)
dropdown_menu_ja = jp_pint_constants.dropdown_menu_ja.format(APP_BASE)
legend_en = '''
'''
legend_ja = '''
'''
infoCAR_en = '''
	<dl class="row">
		<dt class="col-3">CAR-1</dt>
		<dd class="col-9">Semantic: optional(0..x) → Syntax: mandatory(1..x)<br />
			[Issue] If the value is not present, the UBL schema validation reports an error. <br />
			[Resolution] Agree on "default value if missing"  (e.g. 0, 1-1-1970, AAA)'
		</dd>
		<dt class="col-3">CAR-2</dt>
		<dd class="col-9">Semantic: mandatory(1..x) → Syntax: optional(0..x)<br />
			[Issue] None. <br />
			[Resolution] Add a rule in the schematron that the element shall be present.
		</dd>
		<dt class="col-3">CAR-3</dt>
		<dd class="col-9">Semantic: single(x..1) → Syntax: multiple(x..n)<br />
			[Issue] None. <br />
			[Resolution] Add a rule in the schematron that the element shall not be repeated.
		</dd>
		<dt class="col-3">CAR-4</dt>
		<dd class="col-9">Semantic: multiple(x..n) → Syntax: single(x..1)<br />
			[Issue] Repeating elements cannot be handled. <br />
			[Resolution]<br />
			&nbsp;&nbsp;1) If possible, repeat a higher level in the structure. <br />
			&nbsp;&nbsp;2) In the case of text elements, concatenate the repeating elements.
		</dd>
		<dt class="col-3">CAR-5</dt>
		<dd class="col-9">Semantic: element missing → Syntax: element mandatory<br />
			[Issue] Yes.<br />
			[Resolution] Agree on "default value if missing" (e.g. 0, 1-1-1970, AAA)
		</dd>
	</dl>
'''
infoCAR_ja = '''
	<dl class="row">
		<dt class="col-3">CAR-1</dt>
		<dd class="col-9">Semantic: optional(0..x) → Syntax: mandatory(1..x)<br />
			[問題] 要素がないと、UBLのスキーマ検証でエラーとなる。<br />
			[対策] 欠損した時のデフォルト値を決めておく。(例 0, 1-1-1970, AAA)
		</dd>
		<dt class="col-3">CAR-2</dt>
		<dd class="col-9">Semantic: mandatory(1..x) → Syntax: optional(0..x)<br />
			[問題] 問題なし。<br />
			[対策] データがなければならないことをスキーマトロンでルール定義する。
		</dd>
		<dt class="col-3">CAR-3</dt>
		<dd class="col-9">Semantic: single(x..1) → Syntax: multiple(x..n)<br />
			[問題] 問題なし。<br />
			[対策] データを繰り返さないようにスキーマトロンでルール定義する。
		</dd>
		<dt class="col-3">CAR-4</dt>
		<dd class="col-9">Semantic: multiple(x..n) → Syntax: single(x..1)<br />
			[問題] 繰返された要素は、受け付けられない。<br />
			[対策]<br />
			&nbsp;&nbsp;1) 可能なときには、上位の要素で繰り返す。<br />
			&nbsp;&nbsp;2) テキストデータのときには、文章を連結する。
		</dd>
		<dt class="col-3">CAR-5</dt>
		<dd class="col-9">element missing → Syntax: element mandatory<br />
			[問題] 問題。<br />
			[対策] 欠損した時のデフォルト値を決めておく。(例 0, 1-1-1970, AAA)
		</dd>
	</dl>
'''
infoCAR_Modal = '''
	<div id="infoCAR_Modal" class="modal modal-lg" tabindex="-1" role="dialog">
		<div class="modal-dialog" role="document">
			<div class="modal-content">
				<div class="modal-header">{0}</h5>
					<button type="button" class="close" data-dismiss="modal" aria-label="Close">
						<span aria-hidden="true">&times;</span>
					</button>
				</div>
				<div class="modal-body">
					{1}
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
				</div>
			</div>
		</div>
	</div>
'''
CAR_Button = '''
	<span>
		{0}
		<button type="button" class="info btn btn-outline-info my-2 my-sm-0 mr-sm-2 border-0" data-toggle="modal" data-target="#infoCAR_Modal">
			<i class="fa fa-info" aria-hidden="true"></i>
		</button>
	</span>
'''
table_html = '''
				<table class="syntax table table-sm table-hover" style="table-layout: fixed; width: 100%;">
					<colgroup>
						<col span="1" style="width: {4};">
						<col span="1" style="width: {5};">
						<col span="1" style="width: 18%;">
						<col span="1" style="width: 6%;">
						<col span="1" style="width: 40%;">
					</colgroup>
					<thead>
						<th>&nbsp;</th>
						<th>{0}</th>
						<th>{1}</th>
						<th>{2}</th>
						<th>{3}</th>
					</thead>
					<tbody>
'''
table_trailer = jp_pint_constants.table_trailer
trailer = jp_pint_constants.trailer
# ITEM
item_head = jp_pint_constants.item_head
item_legend_en = '''
	<h5>CEN/TS 16931-3-2</h5>
		<p>Electronic invoicing - Part 3-2:Syntax binding for ISO/IEC 19845(UBL 2.1) invoice and credit note</p>
	<h6>4.2 Data types</h6>
		<p class="text-center">Table 1 -- UBL data types</p>
		<table class="syntax table table-sm table-hover" style="table-layout: fixed; width: 100%;">
			<colgroup>
				<col span="1" style="width: 50%;">
				<col span="1" style="width: 50%;">
			</colgroup>
			<thead class="thead-light">
				<th>Smantic data typee</th>
				<th>UBL unqualified data type</th>
			</thead>
			<tbody class="table-striped">
				<tr><td>Smantic data typee</td><td>UBL unqualified data type</td></tr>
				<tr><td>Amount</td><td>AmountType</td></tr>
				<tr><td>Code</td><td>CodeType<br />IdentifierType<br />TextType</td></tr>
				<tr><td>Date</td><td>DateType</td></tr>
				<tr><td>Identifier</td><td>IdentifierType<br />CodeType</td></tr>
				<tr><td>Percent</td><td>PercentType<br />NumericType</td></tr>
				<tr><td>Quantity</td><td>QuantityType</td></tr>
				<tr><td>Text</td><td>TextType<br />NameType<br />IdentifierType</td></tr>
				<tr><td>Unit Price Amount</td><td>AmountType</td></tr>
				<tr><td>BinaryObject</td><td>BinaryObjectType</td></tr>
				<tr><td>Document Reference Type</td><td>IdentifierType</td></tr>
				<tr><td>Attributes</td><td>Identifier<br />Code<br />Text</td></tr>
			</tbody>
		</table>
'''
item_legend_ja = '''
	<h5>CEN/TS 16931-3-2</h5>
		<p>Electronic invoicing - Part 3-2:Syntax binding for ISO/IEC 19845(UBL 2.1) invoice and credit note</p>
	<h6>4.2 Data types</h6>
	<p class="text-center">Table 1 -- UBL data types</p>
	<table class="syntax table table-sm table-hover" style="table-layout: fixed; width: 100%;">
		<colgroup>
			<col span="1" style="width: 50%;">
			<col span="1" style="width: 50%;">
		</colgroup>
		<thead class="thead-light">
			<th>Smantic data typee</th>
			<th>UBL unqualified data type</th>
		</thead>
		<tbody class="table-striped">
			<tr><td>Smantic data typee</td><td>UBL unqualified data type</td></tr>
			<tr><td>Amount</td><td>AmountType</td></tr>
			<tr><td>Code</td><td>CodeType<br />IdentifierType<br />TextType</td></tr>
			<tr><td>Date</td><td>DateType</td></tr>
			<tr><td>Identifier</td><td>IdentifierType<br />CodeType</td></tr>
			<tr><td>Percent</td><td>PercentType<br />NumericType</td></tr>
			<tr><td>Quantity</td><td>QuantityType</td></tr>
			<tr><td>Text</td><td>TextType<br />NameType<br />IdentifierType</td></tr>
			<tr><td>Unit Price Amount</td><td>AmountType</td></tr>
			<tr><td>BinaryObject</td><td>BinaryObjectType</td></tr>
			<tr><td>Document Reference Type</td><td>IdentifierType</td></tr>
			<tr><td>Attributes</td><td>Identifier<br />Code<br />Text</td></tr>
		</tbody>
	</table>
'''
item_navbar = jp_pint_constants.item_navbar
item_header = jp_pint_constants.item_header
item_data = '''
				<dt class="col-3">{0}</dt><dd class="col-9">{1}</dd>
				<dt class="col-3">{2}</dt><dd class="col-9">{3}</dd>
				<dt class="col-3">{4}</dt><dd class="col-9">{5}</dd>
				<dt class="col-3">{6}</dt><dd class="col-9">{7}</dd>
				<dt class="col-3">{8}</dt><dd class="col-9">{9}</dd>
				<dt class="col-3">{10}</dt><dd class="col-9">{11}</dd>
				<dt class="col-3">{12}</dt><dd class="col-9">{13}</dd>
				<dt class="col-3">{14}</dt><dd class="col-9">{15}</dd>
				<dt class="col-3">{16}</dt><dd class="col-9">{17}</dd>
				<dt class="col-3">{18}</dt><dd class="col-9">{19}</dd>
				<dt class="col-3">{20}</dt><dd class="col-9">{21}</dd>
'''
child_elements_dt = '''
		<dt class="col-3">{0}</dt>
		<dd class="col-9">
			<div class="table-responsive">
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

def setupTr(data,lang):
	html = ''
	path = data['Path']
	m = re.match(r'.*\/([^\/]+)$',path)
	element = m.groups()[0]
	if 'Invoice' == element or re.match(r'^cac:[^\/]*$',element):
		html += '<tr class="group"'+ \
							' data-seq="'+data['SemSort']+'"'+ \
							' data-en_id="'+data['EN_ID']+'"'+ \
							' data-pint_id="'+data['PINT_ID']+'"'+ \
							' data-level="'+data['Level']+'"'+ \
							' data-card="'+data['Card'].strip()+'"'+ \
							' data-path="'+data['Path']+'">'
		html += '<td class="expand-control" align="center"></td>'
	elif re.match(r'^cbc:[^\/s]*$',element) or re.match(r'^@[a-zA-Z]+',element):
		html += '<tr'+ \
							' data-seq="'+data['SemSort']+'"'+ \
							' data-en_id="'+data['EN_ID']+'"'+ \
							' data-pint_id="'+data['PINT_ID']+'"'+ \
							' data-level="'+data['Level']+'"'+ \
							' data-card="'+data['Card'].strip()+'"'+ \
							' data-path="'+data['Path']+'">'
		html += '<td>&nbsp;</td>'
	else:
		return ''
	if 0 == len(path[9:]):
		item_dir = SYNTAX_BASE+lang+'/'
	else:
		item_dir = SYNTAX_BASE+path[9:].replace(':','-')+'/'+lang+'/'
	html += '<td class="info-link"><a href="'+item_dir+'">'+element+'</a></td>'
	html += '<td><span>'+data['Datatype'].strip()+'</span></td>\n'
	html += '<td><span>'+data['Card'].strip()+'</span></td>\n'
	html += '<td><p>'
	if 'ja' == lang:
		html += '<strong>'+data['BT_ja']+'</strong><br />'
	else:
		html += '<strong>'+data['BT']+'</strong><br />'
	if 'ja' == lang:
		if data['Desc_ja']:
			desc = '<em>'+('<br />'.join(data['Desc_ja'].split('\\n')))+'</em>'
		else:
			desc = ''
	else:
		if data['Desc']:
			desc = '<em>'+('<br />'.join(data['Desc'].split('\\n')))+'</em>'
		else:
			desc = ''
	html += desc
	html += '</p>'
	if data['Example']:
		example = '<p>Example value: <code>'+data['Example']+'</code></p>'
	else:
		example = ''
	html += example+'</td></tr>'
	return html

def writeTr_en(f,data):
	tabs = '\t\t\t\t\t\t'
	path = data['Path']
	m = re.match(r'.*\/([^\/]+)$',path)
	element = m.groups()[0]
	if 'Invoice' == element or re.match(r'^cac:[^\/]*$',element):
		f.write(tabs+'<tr class="group"'+ \
										' data-seq="'+data['SemSort']+'"'+ \
										' data-en_id="'+data['EN_ID']+'"'+ \
										' data-pint_id="'+data['PINT_ID']+'"'+ \
										' data-level="'+data['Level']+'"'+ \
										' data-card="'+data['Card'].strip()+'"'+ \
										' data-path="'+data['Path']+'">\n')
		f.write(tabs+'\t<td class="expand-control" align="center"><i class="expand fa fa-plus-circle"></i>'+ 
									'<i class="fold fa fa-minus-circle" style="display:none"></i></td>\n')
	elif re.match(r'^cbc:[^\/s]*$',element) or re.match(r'^@[a-zA-Z]+',element):
		f.write(tabs+'<tr'+ \
										' data-seq="'+data['SemSort']+'"'+ \
										' data-en_id="'+data['EN_ID']+'"'+ \
										' data-pint_id="'+data['PINT_ID']+'"'+ \
										' data-level="'+data['Level']+'"'+ \
										' data-card="'+data['Card'].strip()+'"'+ \
										' data-path="'+data['Path']+'">\n')
		f.write(tabs+'\t<td>&nbsp;</td>\n')
	else:
		return
	try:
		level = '&bullet;&nbsp;'*int(path[1:].count('/'))
	except TypeError as e:
		level = ''
	if 0 == len(path[9:]):
		item_dir = SYNTAX_BASE+'en/'
	else:
		item_dir = SYNTAX_BASE+path[9:].replace(':','-')+'/en/'
	f.write(tabs+'\t<td class="info-link">'+level+'<a href="'+item_dir+'">'+element+'</a></td>\n')
	f.write(tabs+'\t<td><span>'+data['Datatype'].strip()+'</span></td>\n')
	f.write(tabs+'\t<td><span>'+data['Card'].strip()+'</span></td>\n')
	f.write(tabs+'\t<td>\n'+tabs+'\t\t<p>\n')
	f.write(tabs+'\t\t\t<strong>'+data['BT']+'</strong><br />\n')
	if data['Desc']:
		desc = tabs+'\t\t\t<em>'+('<br />'.join(data['Desc'].split('\\n')))+'</em>\n'
	else:
		desc = ''
	f.write(desc)
	f.write(tabs+'\t\t</p>\n')
	if data['Example']:
		example = tabs+'\t\t<p>Example value: <code>'+data['Example']+'</code></p>\n'
	else:
		example = ''
	f.write(example+'\n'+tabs+'\t</td>\n')
	f.write(tabs+'</tr>\n')

def writeTr_ja(f,data):
	tabs = '\t\t\t\t\t\t'
	path = data['Path']
	m = re.match(r'.*\/([^\/]+)$',path)
	element = m.groups()[0]
	if 'Invoice' == element or re.match(r'^cac:[^\/]*$',element):
		f.write(tabs+'<tr class="group"'+ \
									' data-seq="'+data['SemSort']+'"'+ \
									' data-en_id="'+data['EN_ID']+'"'+ \
									' data-pint_id="'+data['PINT_ID']+'"'+ \
									' data-level="'+data['Level']+'"'+ \
									' data-card="'+data['Card'].strip()+'"'+ \
									' data-path="'+data['Path']+'">\n')
		f.write(tabs+'\t<td class="expand-control" align="center"><i class="expand fa fa-plus-circle"></i>'+ 
									'<i class="fold fa fa-minus-circle" style="display:none"></i></td>\n')
	elif re.match(r'^cbc:[^\/s]*$',element) or re.match(r'^@[a-zA-Z]+',element):
		f.write(tabs+'<tr'+ \
									' data-seq="'+data['SemSort']+'"'+ \
									' data-en_id="'+data['EN_ID']+'"'+ \
									' data-pint_id="'+data['PINT_ID']+'"'+ \
									' data-level="'+data['Level']+'"'+ \
									' data-card="'+data['Card'].strip()+'"'+ \
									' data-path="'+data['Path']+'">\n')
		f.write(tabs+'\t<td>&nbsp;</td>\n')
	else:
		return
	try:
		level = '&bullet;&nbsp;'*int(path[1:].count('/'))
	except TypeError as e:
		level = ''
	if 0 == len(path[9:]):
		item_dir = SYNTAX_BASE+'ja/'
	else:
		item_dir = SYNTAX_BASE+path[9:].replace(':','-')+'/ja/'
	f.write(tabs+'\t<td class="info-link">'+level+'<a href="'+item_dir+'">'+element+'</a></td>\n')
	f.write(tabs+'\t<td><span>'+data['Datatype'].strip()+'</span></td>\n')
	f.write(tabs+'\t<td><span>'+data['Card'].strip()+'</span></td>\n')
	f.write(tabs+'\t<td>\n'+tabs+'\t\t<p>\n')
	f.write(tabs+'\t\t\t<strong>'+data['BT_ja']+'</strong><br />\n')
	if data['Desc_ja']:
		desc = tabs+'\t\t<p><em>'+('<br />'.join(data['Desc_ja'].split('\\n')))+'</em></p>\n'
	else:
		desc = ''
	f.write(desc)
	if data['Example']:
		example = tabs+'\t\t例: <code>'+data['Example']+'</code>'
	else:
		example = ''
	f.write(example+'\n'+tabs+'\t</td>\n')
	f.write(tabs+'</tr>\n')

def writeBreadcrumb(f,path,lang):
	paths = path[9:].replace(':','-').split('/')
	if 'ja' == lang:
		home_str = HOME_ja
	else:
		home_str = HOME_en
	tabs = '\t\t\t'
	f.write(tabs+'<ol class="breadcrumb pt-1 pb-1">')
	f.write(tabs+'\t<li class="breadcrumb-item"><a href="'+APP_BASE+lang+'/">'+home_str+'</a></li>')
	item_dir = APP_BASE+'syntax/ubl-invoice/'
	f.write(tabs+'\t<li class="breadcrumb-item"><a href="'+item_dir+'tree/'+lang+'/">ubl:Invoice</a></li>')
	for el in paths:
		item_dir += el+'/'
		el = el.replace('-',':')
		if (el and not re.match(r'^.*'+el+'$',path)):
			f.write(tabs+'\t<li class="breadcrumb-item"><a href="'+item_dir+lang+'">'+el+'</a></li>')
		else:
			f.write(tabs+'\t<li class="breadcrumb-item active">'+el+'</li>')
	f.write(tabs+'</ol>')

def blank2nbsp(str):
	if str:
		return str
	return '&nbsp;'

def getNamespace(element):
	if re.match(r'^cac:.*$',element):
		NS = '<code>cac</code> urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2'
	elif re.match(r'^cbc:.*$',element):
		NS = '<code>cbc</code> urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2'
	elif re.match(r'^CreditNote$',element):
		NS = 'urn:oasis:names:specification:ubl:schema:xsd:CreditNote-2'
	elif re.match(r'^Invoice$',element):
		NS = 'urn:oasis:names:specification:ubl:schema:xsd:Invoice-2'
	else:
		NS = ''
	return NS

def checkRules(data, lang):
	id = data['PINT_ID']
	if not id:
		return ''
	Rules = data['Rules']
	if Rules:
		Rules = Rules.split(',')
	Rs = ''
	diff0 = []
	for r in Rules:
		if r in rule_dict:
			if r in schematron_dict:
				if 'ja' == lang:
					message = rule_dict[r]['Message_ja']
				else:
					message = rule_dict[r]['Message']
				schematron = schematron_dict[r]
				context = schematron['context']
				flag = schematron['flag']
				test = schematron['test']
				if re.match(r'^jp-',r):
					R = '<a href="'+RULES_UBL_JAPAN_BASE+r+'/'+lang+'/">'+r+'</a>'
				else:
					R = '<a href="'+RULES_UBL_PINT_BASE+r+'/'+lang+'/">'+r+'</a>'
				Rs += '<h5>'+R+' ('+flag+')</h5>'+message+'<br />'
				Rs += '<dl class="row">'
				if 'ja' == lang:
					Rs += '<dt class="col-3">対象(context)</dt><dd class="col-9">'+context+'</dd>'+ \
								'<dt class="col-3">検証(test)</dt><dd class="col-9">'+test+'</dd>'
				else:
					Rs += '<dt class="col-3">cotext</dt><dd class="col-9">'+context+'</dd>'+ \
								'<dt class="col-3">test</dt><dd class="col-9">'+test+'</dd>'
				Rs += '</dl>'
			else:
				if 'ja' == lang:
					message = rule_dict[r]['Message_ja']
				else:
					message = rule_dict[r]['Message']
				Rs += '<h5>'+r+'</h5>'+message+'<br />'
				if 'ja' == lang:
					Rs += 'スキーマトロン未定義<br />'
				else:
					Rs += 'is not defined in the schematron file.<br />'
		else:
			diff0.append(r)
	rules_ = rules[id]
	if rules_:
		rules_ = list(rules_)
	diff1 = list(set(rules_) - set(Rules))
	diff2 = list(set(Rules) - set(rules_) - set(diff0))
	if len(diff0) > 0:
		Rs += '<span class="text-danger"><b>'
		if 'ja' == lang:
			Rs += 'スキーマトロンで未定義'
		else:
			Rs += 'is not defined in the schematron file.'
		Rs += '</b></span><br />'
		for r in diff0:
			if re.match(r'^jp-',r):
				R = '<a href="'+RULES_UBL_JAPAN_BASE+r+'/'+lang+'/">'+r+'</a>'
			else:
				R = '<a href="'+RULES_UBL_PINT_BASE+r+'/'+lang+'/">'+r+'</a>'
			Rs += R+' '
		Rs += '<br />'
	if len(diff1) > 0:
		Rs += '<span class="text-danger"><b>'
		if 'ja' == lang:
			Rs += 'PINTモデルで未定義'
		else:
			Rs += 'is not defined in the PINT semantic model.'
		Rs += '</b></span><br />'
		for r in diff1:
			if re.match(r'^jp-',r):
				R = '<a href="'+RULES_UBL_JAPAN_BASE+r+'/'+lang+'/">'+r+'</a>'
			else:
				R = '<a href="'+RULES_UBL_PINT_BASE+r+'/'+lang+'/">'+r+'</a>'
			Rs += R+' '
		Rs += '<br />'
	if len(diff2) > 0:
		Rs += '<span class="text-danger"><b>'
		if 'ja' == lang:
			Rs += data['PINT_ID']+'は、PINTルールで未言及'
		else:
			Rs += data['PINT_ID']+' is not mentioned in the rule.'
		Rs += '</b></span><br />'
		for r in diff2:
			if re.match(r'^jp-',r):
				R = '<a href="'+RULES_UBL_JAPAN_BASE+r+'/'+lang+'/">'+r+'</a>'
			else:
				R = '<a href="'+RULES_UBL_PINT_BASE+r+'/'+lang+'/">'+r+'</a>'
			Rs += R+' '
		Rs += '<br />'
	if '<br />' == Rs[-6:]:
		Rs = Rs[:-6]
	return Rs

if __name__ == '__main__':
	# Create the parser
	parser = argparse.ArgumentParser(prog='genInvoice',
																	usage='%(prog)s [options] infile pint_rulefile jp_rulefile schematronfile',
																	description='CSVファイルからJP-PINTのHTMLファイルを作成')
	# Add the arguments
	parser.add_argument('inFile',metavar='infile',type=str,help='入力TSVファイル')
	parser.add_argument('pint_ruleFile',metavar='pint_rulefile',type=str,help='PINTルールCSVファイル')
	parser.add_argument('jp_ruleFile',metavar='jp_rulefile',type=str,help='JPルールCSVファイル')
	parser.add_argument('schematronFile',metavar='schematronfile',type=str,help='スキーマトロンCSVファイル')
	parser.add_argument('-v','--verbose',action='store_true')
	args = parser.parse_args()
	in_file = file_path(args.inFile)
	pint_rule_file = file_path(args.pint_ruleFile)
	jp_rule_file = file_path(args.jp_ruleFile)
	schematron_file = file_path(args.schematronFile)
	dir = os.path.dirname(in_file)
	syntax_en_html = 'billing-japan/syntax/ubl-invoice/tree/en/index.html'
	syntax_ja_html = 'billing-japan/syntax/ubl-invoice/tree/ja/index.html'
	verbose = args.verbose
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
		for row in reader:
			context = row['context']
			id = row['id']
			flag = row['flag']
			test = row['test']
			text = row['text']
			BG = row['BG']
			BT = row['BT']
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
	rule_dict = {}
	rule_keys = ('ID','Flag','Message','Message_ja')
	with open(pint_rule_file,'r',encoding='utf-8') as f:
		reader = csv.DictReader(f,rule_keys)
		header = next(reader)
		for row in reader:
			RuleID = row['ID']
			Flag = row['Flag']
			Message = row['Message']
			Message_ja = row['Message_ja']
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
			rule_dict[RuleID] = data

	with open(jp_rule_file,'r',encoding='utf-8') as f:
		reader = csv.DictReader(f,rule_keys)
		header = next(reader)
		for row in reader:
			RuleID = row['ID']
			Flag = row['Flag']
			Message = row['Message']
			Message_ja = row['Message_ja']
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
			rule_dict[RuleID] = data

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
			"Occ":"1..n",
			"Align":""
		}]+[x for x in csv_list if ''!=x['SynSort'] and ''!=x['Path']]
	pint_list = sorted(pint_list,key=lambda x: x['SynSort'])

	rules = {}
	idxLevel = ['']*6
	for data in pint_list:
		level = data['Level']
		if level:
			pint_id = data['PINT_ID']
			rules[pint_id] = set()
			for k,v in rule_dict.items():
				pint_ids = v['PINT_IDs']
				if pint_ids:
					pint_ids = pint_ids.split(' ')
					if pint_id in pint_ids:
						rules[pint_id].add(k)

	children = {}
	with open(syntax_en_html,'w',encoding='utf-8') as f:
		lang = 'en'
		f.write(html_head.format(lang, APP_BASE))
		f.write(javascript_html)
		# 0.SPEC_TITLE_en 1.'selected' 2.'' 3.HOME_en 4.SYNTAX_MESSAGE_TITLE_en 5.lang 6.APP_BASE 
		# 7.'Legend' 8.legend_en 9.'Shows a ...' 10.dropdown_menu_en 11.tooltipTextForSearch
		html = navbar_html.format(SPEC_TITLE_en,'selected','',HOME_en,SYNTAX_MESSAGE_TITLE_en,lang, \
															APP_BASE,'Legend',legend_en,'Shows a modal window of legend information.', \
															dropdown_menu_en,'ID or word in Term/Description')
		f.write(html)
		f.write(table_html.format('XML','Datatype','Card','Business Term / Description','3%','33%'))
		for data in pint_list:
			path = data['Path']
			m = re.match(r'.*\/([^\/]+)$',path)
			element = m.groups()[0]
			data['element'] = element
			Level = str(path[1:].count('/'))
			data['Level'] = Level
			if 'Invoice' == element or re.match(r'^c[ab]c:.*$',element): # NOT write @attribute
				writeTr_en(f,data)
			else:
				if re.match(r'^.*@[a-zA-Z]+$',element):
					if not path in children:
						children[path] = set()
					children[path].add(json.dumps(data))
		f.write(trailer)

	for data in pint_list:
		if not data or not data['Path']:
			continue
		lang = 'en'
		path = data['Path']
		m = re.match(r'.*\/([^\/]+)$',path)
		element = m.groups()[0]
		if 'Invoice' == element or re.match(r'^c[ab]c:.*$',element):
			if 'Invoice' == element:
				item_dir0 = 'billing-japan/syntax/ubl-invoice/'+lang
			else:
				item_dir0 = 'billing-japan/syntax/ubl-invoice/'+path[9:].replace(':','-')+'/'+lang

			os.makedirs(item_dir0,exist_ok=True)

			with open(item_dir0+'/index.html','w',encoding='utf-8') as f:
				paths = path[9:].replace(':','-').split('/')
				f.write(item_head.format(lang,APP_BASE))
				f.write(javascript_html)
				f.write('</head><body>')

				CARtitle = 'Alignment of cardinalities'
				f.write(infoCAR_Modal.format(CARtitle,infoCAR_en))

				# 0.SPEC_TITLE_en 1.'selected' 2.'' 3.lang 4.APP_BASE 5.'Legend' 6.info_item_modal_en 7.dropdown_menu_en　8.tooltipText
				f.write(item_navbar.format(SPEC_TITLE_en,'selected','',lang,APP_BASE,'Legend',item_legend_en,dropdown_menu_en,'Show Legend'))

				writeBreadcrumb(f,path,lang)

				Datatype = data['Datatype']
				Desc = '<br />'.join(data['Desc'].split('\\n'))
				f.write(item_header.format(element,Desc))

				Card = data['Card']+'&nbsp;'
				NS = getNamespace(element)
				Example = data['Example']
				if Example:
					Example = '<code>'+blank2nbsp(Example)+'</code>'
				else:
					Example = ''
				Rules = blank2nbsp(checkRules(data,lang))
				BT = blank2nbsp(data['BT'])
				id = data['PINT_ID']
				ID = '<a href="'+APP_BASE+'semantic/invoice/'+id+'/'+lang+'/">'+id+'</a>'
				Explanation = '<br />'.join(data['Exp'].split('\\n'))
				if len(Explanation) > 0:
					Explanation_title = 'Additional explanation'
				else:
					Explanation_title = '&nbsp;'
					Explanation = '&nbsp;'
				Align = data['Align'][:5]
				if 'CAR-1' == Align:
					Align = Align+' Semantic: optional(0..x) → Syntax: mandatory(1..x)<br />[Issue] If the value is not present, the UBL schema validation reports an error. <br />[Resolution] Agree on "default value if missing"  (e.g. 0, 1-1-1970, AAA)'
				elif 'CAR-2' == Align:
					Align = Align+' Semantic: mandatory(1..x) → Syntax: optional(0..x)<br />[Issue] None. <br />[Resolution] Add a rule in the schematron that the element shall be present.'
				elif 'CAR-3' == Align:
					Align = Align+' Semantic: single(x..1) → Syntax: multiple(x..n)<br />[Issue] None. <br />[Resolution] Add a rule in the schematron that the element shall not be repeated.'
				elif 'CAR-4' == Align:
					Align = Align+' Semantic: multiple(x..n) → Syntax: single(x..1)<br />[Issue] Repeating elements cannot be handled. <br />[Resolution] 1) If possible, repeat a higher level in the structure. 2) In the case of text elements, concatenate the repeating elements.'
				elif 'CAR-5' == Align:
					Align = Align+' Semantic: element missing  → Syntax: element mandatory<br />[Issue] Yes.<br />[Resolution] Agree on "default value if missing" (e.g. 0, 1-1-1970, AAA)'
				f.write(item_data.format('XPath',data['Path'],'Data type',Datatype,'Cardinality',Card,'Namespace',NS,'Example',Example,\
																	'Transaction Business Rules',Rules, \
																	'Business Term',BT,'Business Term ID',ID,'Additional Explanation',Explanation, \
																	'UBL cardinality',data['Occ'],CAR_Button.format(CARtitle),Align))
				html = ''
				if re.match(r'^cac:.*$',element):
					for _data in pint_list:
						_path = _data['Path']
						_m = re.match(r'.*\/([^\/]+)$',_path)
						_element = _m.groups()[0]
						if path+'/'+_element == _path:
							html += setupTr(_data,'en')
				else:
					for _data in pint_list:
						_path = _data['Path']
						_m = re.match(r'.*\/([^\/]+)$',_path)
						_element = _m.groups()[0]
						if path+'/'+_element == _path and _path in children:
							for child in children[_path]:
								_data = json.loads(child)
								html += setupTr(_data,'en')
				if html:
					f.write(child_elements_dt.format('Child elements'))
					f.write(table_html.format('XML','Datatype','Card','Business Term / Description','0%','36%'))
					f.write(html)
					f.write(table_trailer)

				f.write(item_trailer)

	with open(syntax_ja_html,'w',encoding='utf-8') as f:
		lang = 'ja'
		f.write(html_head.format(lang,APP_BASE))
		f.write(javascript_html)

		# 0.SPEC_TITLE_ja 1.'' 2.'selected' 3.HOME_ja 4.SYNTAX_MESSAGE_TITLE_ja 5.lang 6.APP_BASE 
		# 7.'凡例' 8.legend_ja 9.'凡例を説明するウィンドウを表示' 10.dropdown_menu_ja 11.tooltipTextForSearch
		html = navbar_html.format(SPEC_TITLE_ja,'','selected',HOME_ja,SYNTAX_MESSAGE_TITLE_ja,lang, \
															APP_BASE,'凡例',legend_ja,'凡例を説明するウィンドウを表示', \
															dropdown_menu_ja,'IDまたは用語/説明文が含む単語')
		f.write(html)
		f.write(table_html.format('XML','データ型','繰返','ビジネス用語 / XPath / 説明','3%','33%'))
		for data in pint_list:
			path = data['Path']
			m = re.match(r'.*\/([^\/]+)$',path)
			element = m.groups()[0]
			if 'Invoice' == element or re.match(r'^c[ab]c:.*$',element): # NOT write @attribute
				writeTr_ja(f,data)

		f.write(table_trailer)							
		f.write(trailer)

	for data in pint_list:
		if not data or not data['Path']:
			continue
		lang = 'ja'
		path = data['Path']
		m = re.match(r'.*\/([^\/]+)$',path)
		element = m.groups()[0]
		if 'Invoice' == element or re.match(r'^c[ab]c:.*$',element):
			if 'Invoice' == element:
				item_dir0 = 'billing-japan/syntax/ubl-invoice/'+lang
			else:
				item_dir0 = 'billing-japan/syntax/ubl-invoice/'+path[9:].replace(':','-')+'/'+lang

			os.makedirs(item_dir0,exist_ok=True)

			with open(item_dir0+'/index.html','w',encoding='utf-8') as f:
				paths = path[9:].replace(':','-').split('/')
				f.write(item_head.format(lang,APP_BASE))
				f.write(javascript_html)
				f.write('</head><body>')

				CARtitle = '繰返しの違いの調整'
				f.write(infoCAR_Modal.format(CARtitle,infoCAR_ja))

				# 0.SPEC_TITLE_en 1.'' 2.'selected' 3.lang 4.APP_BASE 5.'凡例' 6.info_item_modal_ja 7.dropdown_menu_ja 8.tooltipText
				f.write(item_navbar.format(SPEC_TITLE_ja,'','selected',lang,APP_BASE,'凡例',item_legend_ja,dropdown_menu_ja,'凡例を表示'))

				writeBreadcrumb(f,path,lang)

				Desc = '<br />'.join(data['Desc_ja'].split('\\n'))
				f.write(item_header.format(element,Desc))
				Card = data['Card']+'&nbsp;'
				NS = getNamespace(element)
				Datatype = data['Datatype']
				Example = data['Example']
				if Example:
					Example = '<code>'+blank2nbsp(Example)+'</code>'
				else:
					Example = ''
				Rules = blank2nbsp(checkRules(data,lang))
				BT = blank2nbsp(data['BT_ja'])
				id = data['PINT_ID']
				ID = '<a href="'+APP_BASE+'semantic/invoice/'+id+'/'+lang+'/">'+id+'</a>'
				Explanation = '<br />'.join(data['Exp_ja'].split('\\n'))
				if len(Explanation) > 0:
					Explanation_title = '追加説明'
				else:
					Explanation_title = '&nbsp;'
					Explanation = '&nbsp;'
				Align = data['Align'][:5]
				if 'CAR-1' == Align:
					Align = Align+' Semantic: optional(0..x) → Syntax: mandatory(1..x)<br />[問題] 要素がないと、UBLのスキーマ検証でエラーとなる。<br />[対策] 欠損した時のデフォルト値を決めておく。(例 0, 1-1-1970, AAA)'
				elif 'CAR-2' == Align:
					Align = Align+' Semantic: mandatory(1..x) → Syntax: optional(0..x)<br />[問題] 問題なし。<br />[対策] データがなければならないことをスキーマトロンでルール定義する。'
				elif 'CAR-3' == Align:
					Align = Align+' Semantic: single(x..1) → Syntax: multiple(x..n)<br />[問題] 問題なし。<br />[対策] データを繰り返さないようにスキーマトロンでルール定義する。'
				elif 'CAR-4' == Align:
					Align = Align+' Semantic: multiple(x..n) → Syntax: single(x..1)<br />[問題] 繰返された要素は、受け付けられない。<br />[対策] 1) 可能なときには、上位の要素で繰り返す。2) テキストデータのときには、文章を連結する。'
				elif 'CAR-5' == Align:
					Align = Align+' element missing  → Syntax: element mandatory<br />[問題] 問題。<br />[対策] 欠損した時のデフォルト値を決めておく。(例 0, 1-1-1970, AAA)'
				f.write(item_data.format('XPath',data['Path'],'データ型',Datatype,'繰返し',Card,'ネームスペース',NS,'例',Example,\
																	'ビジネスルール',Rules,'ビジネス用語',BT,'ビジネス用語ID',ID,Explanation_title,Explanation, \
																	'UBL要素の繰返し',data['Occ'],CAR_Button.format(CARtitle),Align))
				html = ''
				if re.match(r'^cac:.*$',element):
					for _data in pint_list:
						_path = _data['Path']
						_m = re.match(r'.*\/([^\/]+)$',_path)
						_element = _m.groups()[0]
						if path+'/'+_element == _path:
							html += setupTr(_data,'ja')
				else:
					for _data in pint_list:
						_path = _data['Path']
						_m = re.match(r'.*\/([^\/]+)$',_path)
						_element = _m.groups()[0]
						if path+'/'+_element == _path and _path in children:
							for child in children[_path]:
								_data = json.loads(child)
							html += setupTr(_data,'ja')
				if html:
					f.write(child_elements_dt.format('下位要素'))
					f.write(table_html.format('XML','データ型','繰返','ビジネス用語 / 説明','0%','36%'))
					f.write(html)
					f.write(table_trailer)

				f.write(infoCAR_Modal.format(CARtitle,infoCAR_ja))
				f.write(item_trailer)

	if verbose:
		print(f'** END ** {syntax_en_html} {syntax_ja_html}')