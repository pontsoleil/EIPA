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
# import collections
from collections import OrderedDict
import re
import json
import sys 
import os
import argparse

import jp_pint_base
from jp_pint_base import MESSAGE # invoice debitnote summarized

import jp_pint_constants
from jp_pint_constants import profiles
message_title_en = profiles[MESSAGE]['title_en']
message_title_ja = profiles[MESSAGE]['title_ja']
profile_id = profiles[MESSAGE]['ProfileID']
customization_id = profiles[MESSAGE]['CustomizationID']
from jp_pint_constants import OP_BASE
from jp_pint_constants import APP_BASE
# from jp_pint_constants import SEMANTIC_BASE
from jp_pint_constants import SYNTAX_BASE
# from jp_pint_constants import RULES_BASE
from jp_pint_constants import RULES_UBL_JAPAN_BASE
from jp_pint_constants import RULES_UBL_PINT_BASE
from jp_pint_constants import RULES_EN_PEPPOL
from jp_pint_constants import RULES_EN_CEN

from jp_pint_constants import SPEC_TITLE_en
from jp_pint_constants import SPEC_TITLE_ja
from jp_pint_constants import NOT_SUPPORTED_en
from jp_pint_constants import NOT_SUPPORTED_ja

# from jp_pint_constants import SEMANTICS_MESSAGE_TITLE_en
# from jp_pint_constants import SEMANTICS_MESSAGE_TITLE_ja
# from jp_pint_constants import SEMANTICS_LEGEND_TITLE_en
# from jp_pint_constants import SEMANTICS_LEGEND_TITLE_ja
from jp_pint_constants import SYNTAX_MESSAGE_TITLE_en
from jp_pint_constants import SYNTAX_MESSAGE_TITLE_ja
from jp_pint_constants import SYNTAX_LEGEND_TITLE_en
from jp_pint_constants import SYNTAX_LEGEND_TITLE_ja
# from jp_pint_constants import PINT_RULE_MESSAGE_TITLE_en
# from jp_pint_constants import PINT_RULE_MESSAGE_TITLE_ja
# from jp_pint_constants import JP_RULE_MESSAGE_TITLE_en
# from jp_pint_constants import JP_RULE_MESSAGE_TITLE_ja

from jp_pint_constants import HOME_en
from jp_pint_constants import HOME_ja

from jp_pint_constants import variables

from jp_pint_constants import html_head
from jp_pint_constants import javascript_html
from jp_pint_constants import navbar_html
from jp_pint_constants import dropdown_menu_en
dropdown_menu_en = dropdown_menu_en.format(APP_BASE)
from jp_pint_constants import dropdown_menu_ja
dropdown_menu_ja = dropdown_menu_ja.format(APP_BASE)
legend_en = '''
	<dl class="row">
		<dt class="col-3">XML</dt>
		<dd class="col-9">UBL 2.1 XML element name</dd>
		<dt class="col-3">Datatype</dt>
		<dd class="col-9">UBL 2.1 XML type name</dd>
		<dt class="col-3">Cardinality</dt>
		<dd class="col-9">Cardinality of corresponding semantic model Business Term or Business term Group</dd>
		<dt class="col-3">Business Term / Description</dt>
		<dd class="col-9">Business Term and Description defined in Semantic data model</dd>
	</dl>
'''
legend_ja = '''
	<dl class="row">
		<dt class="col-3">XML</dt>
		<dd class="col-9">UBL 2.1 XML要素名</dd>
		<dt class="col-3">データ型</dt>
		<dd class="col-9">UBL 2.1 XMLタイプ名</dd>
		<dt class="col-3">繰返</dt>
		<dd class="col-9">モデル定義における繰返し</dd>
		<dt class="col-3">ビジネス用語 / 説明</dt>
		<dd class="col-9">モデル定義で指定されたビジネス用語及び説明</dd>
	</dl>
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
CAR_Modal_title = '''
					<p class="mb-0">
						<span style="font-size:xx-large">{0}</span><br>
						CEN/TS 16931-3-1 Electronic invoicing - <br>
						Part 3-1: Methodology for syntax bindings of the core elements of an electronic invoice<br>
						4.4 Cardinality assesment
					</p>
'''
infoCAR_Modal = '''
	<div id="infoCAR_Modal" class="modal" tabindex="-1" role="dialog">
		<div class="modal-dialog modal-lg" role="document">
			<div class="modal-content">
				<div class="modal-header">{0}
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
from jp_pint_constants import table_trailer
from jp_pint_constants import trailer
# ITEM
from jp_pint_constants import item_head
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
from jp_pint_constants import item_navbar
from jp_pint_constants import item_header
item_data_detail = '''
				<dt class="col-2">{0}</dt><dd class="col-10">{1}</dd>
				<dt class="col-2">{2}</dt><dd class="col-10">{3}</dd>
				<dt class="col-2">{4}</dt><dd class="col-10">{5}</dd>
				<dt class="col-2">{6}</dt><dd class="col-10">{7}</dd>
				<dt class="col-2">{8}</dt><dd class="col-10">{9}</dd>
				<dt class="col-2">{10}</dt><dd class="col-10">{11}</dd>
				<dt class="col-2">{12}</dt><dd class="col-10">{13}</dd>
				<dt class="col-2">{14}</dt><dd class="col-10">{15}</dd>
				<dt class="col-2">{16}</dt><dd class="col-10">{17}</dd>
				<dt class="col-2">{18}</dt><dd class="col-10">{19}</dd>
'''
item_data = '''
				<dt class="col-2">{0}</dt><dd class="col-10">{1}</dd>
				<dt class="col-2">{2}</dt><dd class="col-10">{3}</dd>
				<dt class="col-2">{4}</dt><dd class="col-10">{5}</dd>
				<dt class="col-2">{6}</dt><dd class="col-10">{7}</dd>
				<dt class="col-2">{8}</dt><dd class="col-10">{9}</dd>
				<dt class="col-2">{10}</dt><dd class="col-10">{11}</dd>
				<dt class="col-2">{12}</dt><dd class="col-10">{13}</dd>
				<dt class="col-2">{14}</dt><dd class="col-10">{15}</dd>
'''
rule_data_detail = '''
				<dt class="col-2">{0}</dt><dd class="col-10">{1}</dd>
				<dt class="col-2">{2}</dt><dd class="col-10">{3}</dd>
'''
rule_data = '''
				<dt class="col-2">{0}</dt><dd class="col-10">{1}</dd>
'''
child_elements_dt = '''
		<dt class="col-2">{0}</dt>
		<dd class="col-10">
			<div class="table-responsive">
'''
from jp_pint_constants import item_trailer

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
	if not 'element' in data:
		return ''
	element = data['element']
	name = element.replace('-',':')
	name = name.replace('_','/')
	name = name.replace('[','[ ')
	name = name.replace(']',' ]')
	if data['Card']: card = data['Card'].strip()
	elif data['Occ']: card = data['Occ'].strip()
	else: card = ''
	if 'Invoice' == element or re.match(r'^cac:.*$',element):
		if data['Card']: card = data['Card'].strip()
		elif data['Occ']: card = data['Occ'].strip()
		else: card = ''
		html += '<tr class="group"'+ \
							' data-seq="'+data['SynSort']+'"'+ \
							' data-en_id="'+data['EN_ID']+'"'+ \
							' data-pint_id="'+data['PINT_ID']+'"'+ \
							' data-level="'+data['Level']+'"'+ \
							' data-card="'+card+'"'+ \
							' data-path="'+data['Path']+'">'
		html += '<td class="expand-control" align="center"></td>'
	elif re.match(r'^cbc:.*$',element) or re.match(r'^@.+',element):
		html += '<tr'+ \
							' data-seq="'+data['SynSort']+'"'+ \
							' data-en_id="'+data['EN_ID']+'"'+ \
							' data-pint_id="'+data['PINT_ID']+'"'+ \
							' data-level="'+data['Level']+'"'+ \
							' data-card="'+card+'"'+ \
							' data-path="'+data['Path']+'">'
		html += '<td>&nbsp;</td>'
	else:
		return ''
	if data['Card']: card = data['Card'].strip()
	elif data['Occ']: card = data['Occ'].strip()
	else: card = ''
	if re.match(r'^@[a-zA-Z]+',element):
		html += '<td><span>'+element+'</span></td>'
		html += '<td><span>'+data['Datatype'].strip()+'</span></td>\n'
		html += '<td><span>'+card+'</span></td>\n'
	else:
		if 0 == len(path[9:]):
			item_dir = SYNTAX_BASE+lang+'/'
		else:
			item_dir = SYNTAX_BASE+path[9:].replace(':','-')+'/'+lang+'/'
		html += '<td class="info-link"><a href="'+item_dir+'">'+name+'</a></td>'
		html += '<td><span>'+data['Datatype'].strip()+'</span></td>\n'
		html += '<td><span>'+card+'</span></td>\n'
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
	if 'element' in data:
		element = data['element']
	else:
		return
	name = element.replace('-',':')
	name = name.replace('_','/')
	name = name.replace('[','[ ')
	name = name.replace(']',' ]')
	if 'Invoice' == element or re.match(r'^cac:.*$',element):
		f.write(tabs+'<tr class="group"'+ \
									' data-seq="'+data['SynSort']+'"'+ \
									' data-en_id="'+data['EN_ID']+'"'+ \
									' data-pint_id="'+data['PINT_ID']+'"'+ \
									' data-level="'+data['Level']+'"'+ \
									' data-card="'+data['Card'].strip()+'"'+ \
									' data-occ="'+data['Occ'].strip()+'"'+ \
									' data-xpath="'+data['XPath']+'"'+ \
									' data-path="'+data['Path']+'">\n')
		f.write(tabs+'\t<td class="expand-control" align="center"><i class="expand fa fa-plus-circle"></i>'+ 
									'<i class="fold fa fa-minus-circle" style="display:none"></i></td>\n')
	elif re.match(r'^cbc:.*$',element) or re.match(r'^@.+',element):
		f.write(tabs+'<tr'+ \
									' data-seq="'+data['SynSort']+'"'+ \
									' data-en_id="'+data['EN_ID']+'"'+ \
									' data-pint_id="'+data['PINT_ID']+'"'+ \
									' data-level="'+data['Level']+'"'+ \
									' data-card="'+data['Card'].strip()+'"'+ \
									' data-occ="'+data['Occ'].strip()+'"'+ \
									' data-xpath="'+data['XPath']+'"'+ \
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
	if data['Card']: card = data['Card'].strip()
	elif data['Occ']: card = data['Occ'].strip()
	else: card = ''
	f.write(tabs+'\t<td class="info-link">'+level+'<a href="'+item_dir+'">'+name+'</a></td>\n')
	f.write(tabs+'\t<td><span>'+data['Datatype'].strip()+'</span></td>\n')
	f.write(tabs+'\t<td><span>'+card+'</span></td>\n')
	f.write(tabs+'\t<td>\n'+tabs+'\t\t<p>\n')
	f.write(tabs+'\t\t\t<strong>'+data['BT']+'</strong><br />\n')
	if data['Desc']:
		desc = tabs+'\t\t\t<em>'+('<br />'.join(data['Desc'].split('\\n')))+'</em>\n'
	else:
		desc = ''
	f.write(desc)
	f.write(tabs+'\t\t</p>\n')
	if 'ibt-023' == data['PINT_ID']:
		example = tabs+'\t\t<p>Default value: <code>'+profile_id+'</code></p>\n'
	elif 'ibt-024' == data['PINT_ID']:
		example = tabs+'\t\t<p>Default value: <code>'+customization_id+'</code></p>\n'
	elif data['Example']:
		example = tabs+'\t\t<p>Example value: <code>'+data['Example']+'</code></p>\n'
	else:
		example = ''
	f.write(example+'\n'+tabs+'\t</td>\n')
	f.write(tabs+'</tr>\n')

def writeTr_ja(f,data):
	tabs = '\t\t\t\t\t\t'
	path = data['Path']
	if 'element' in data:
		element = data['element']
	else:
		return
	name = element.replace('-',':')
	name = name.replace('_','/')
	name = name.replace('[','[ ')
	name = name.replace(']',' ]')
	if 'Invoice' == element or re.match(r'^cac:.*$',element):
		f.write(tabs+'<tr class="group"'+ 
									' data-seq="'+data['SynSort']+'"'+ 
									' data-en_id="'+data['EN_ID']+'"'+ 
									' data-pint_id="'+data['PINT_ID']+'"'+ 
									' data-level="'+data['Level']+'"'+ 
									' data-card="'+data['Card'].strip()+'"'+ 
									' data-occ="'+data['Occ'].strip()+'"'+ 
									' data-xpath="'+data['XPath']+'"'+ 
									' data-path="'+data['Path']+'">\n')
		f.write(tabs+'\t<td class="expand-control" align="center"><i class="expand fa fa-plus-circle"></i>'+ 
									'<i class="fold fa fa-minus-circle" style="display:none"></i></td>\n')
	elif re.match(r'^cbc:.*$',element) or re.match(r'^@.+',element):
		f.write(tabs+'<tr'+ 
									' data-seq="'+data['SynSort']+'"'+ 
									' data-en_id="'+data['EN_ID']+'"'+ 
									' data-pint_id="'+data['PINT_ID']+'"'+ 
									' data-level="'+data['Level']+'"'+ 
									' data-card="'+data['Card'].strip()+'"'+ 
									' data-occ="'+data['Occ'].strip()+'"'+ 
									' data-xpath="'+data['XPath']+'"'+ 
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
	if data['Card']: card = data['Card'].strip()
	elif data['Occ']: card = data['Occ'].strip()
	else: card = ''
	f.write(tabs+'\t<td class="info-link">'+level+'<a href="'+item_dir+'">'+name+'</a></td>\n')
	f.write(tabs+'\t<td><span>'+data['Datatype'].strip()+'</span></td>\n')
	f.write(tabs+'\t<td><span>'+card+'</span></td>\n')
	f.write(tabs+'\t<td>\n'+tabs+'\t\t<p>\n')
	f.write(tabs+'\t\t\t<strong>'+data['BT_ja']+'</strong><br />\n')
	if data['Desc_ja']:
		desc = tabs+'\t\t<p><em>'+('<br />'.join(data['Desc_ja'].split('\\n')))+'</em></p>\n'
	else:
		desc = ''
	f.write(desc)
	if 'ibt-023' == data['PINT_ID']:
		example = tabs+'\t\t<p>既定値: <code>'+profile_id+'</code></p>\n'
	elif 'ibt-024' == data['PINT_ID']:
		example = tabs+'\t\t<p>既定値: <code>'+customization_id+'</code></p>\n'
	elif data['Example']:
		example = tabs+'\t\t例: <code>'+data['Example']+'</code>'
	else:
		example = ''
	f.write(example+'\n'+tabs+'\t</td>\n')
	f.write(tabs+'</tr>\n')

def writeBreadcrumb(f,path,lang):
	paths = path[9:].replace(':','-').split('/')
	if 'ja' == lang:
		home_str = HOME_ja
		name = SYNTAX_MESSAGE_TITLE_ja
	else:
		home_str = HOME_en
		name = SYNTAX_MESSAGE_TITLE_en
	tabs = '\t\t\t'
	f.write(tabs+'<ol class="breadcrumb pt-1 pb-1">')
	f.write(tabs+'\t<li class="breadcrumb-item"><a href="https://test-docs.peppol.eu/poacc/billing-japan/">'+home_str+'</a></li>')
	item_dir = APP_BASE+'syntax/ubl-invoice/'
	f.write(tabs+'\t<li class="breadcrumb-item"><a href="'+item_dir+'tree/'+lang+'/">'+name+'</a></li>')
	if '/Invoice' == path:
		f.write(tabs+'\t<li class="breadcrumb-item active">Invoice</li>')
	else:
		f.write(tabs+'\t<li class="breadcrumb-item"><a href="'+item_dir+lang+'/">Invoice</a></li>')
		for el in paths:
			item_dir += el+'/'
			name = el.replace('-',':')
			name = name.replace('_','/')
			if name and not path.endswith(name):
				f.write(tabs+'\t<li class="breadcrumb-item"><a href="'+item_dir+lang+'">'+name+'</a></li>')
			else:
				f.write(tabs+'\t<li class="breadcrumb-item active">'+name+'</li>')
	f.write(tabs+'</ol>')

def blank2fa_minus(str):
	if str:
		return str
	return '<i class="fa fa-minus" aria-hidden="true"></i>'

def getNamespace(element):
	if re.match(r'^cac:.*$',element):
		NS = '<code>cac</code> urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2'
	elif re.match(r'^cbc:.*$',element):
		NS = '<code>cbc</code> urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2'
	elif re.match(r'^CreditNote$',element):
		NS = '<code>CreditNote</code> urn:oasis:names:specification:ubl:schema:xsd:CreditNote-2'
	elif re.match(r'^Invoice$',element):
		NS = '<code>Invoice</code> urn:oasis:names:specification:ubl:schema:xsd:Invoice-2'
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
			if 'ja' == lang:
				message = rule_dict[r]['Message_ja']
			else:
				message = rule_dict[r]['Message']
			if r in schematron_dict:
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
					Rs += '<dt class="col-3">対象(context)</dt><dd class="col-9"><code>'+context+'</code></dd>'+ \
								'<dt class="col-3">検証(test)</dt><dd class="col-9"><code>'+test+'</code></dd>'
				else:
					Rs += '<dt class="col-3">cotext</dt><dd class="col-9"><code>'+context+'</code></dd>'+ \
								'<dt class="col-3">test</dt><dd class="col-9"><code>'+test+'</code></dd>'
				Rs += '</dl>'
			else:
				Rs += '<h5>'+r+'</h5>'+message+'<br />'
				Rs += '<span class="text-danger"><b>'
				if 'ja' == lang:
					Rs += 'スキーマトロンで未定義'
				else:
					Rs += 'is not defined in the schematron file.'
				Rs += '</b></span><br />'
		else:
			diff0.append(r)
	rules_ = rules[id] # From pint_list data['Rules']
	if rules_:
		rules_ = list(rules_)
	diff1 = list(set(rules_) - set(Rules))
	diff2 = list(set(Rules) - set(rules_) - set(diff0))
	if len(diff0) > 0:
		Rs += '<span class="text-danger"><b>'
		if 'ja' == lang:
			Rs += 'ルール表で未定義'
		else:
			Rs += 'is not defined in the rule table.'
		Rs += '</b></span><br />'
		for r in diff0:
			if re.match(r'^jp-',r):
				R = '<a href="'+RULES_UBL_JAPAN_BASE+r+'/'+lang+'/">'+r+'</a>'
			else:
				R = '<a href="'+RULES_UBL_PINT_BASE+r+'/'+lang+'/">'+r+'</a>'
			Rs += R+' '
		Rs += '<br />'
	if detail:
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

def checkBIS_Rules(data, lang):
	id = data['PINT_ID']
	if not id:
		return ''
	if 'ibt' == id[:3]:
		ID = 'BT-'+str(int(id[4:7]))
	elif 'ibg' == id[:3]:
		ID ='BG-'+str(int(id[4:6]))
	Rs = ''
	if ID in BISrules:
		Rules = BISrules[ID]
		for r in Rules:
			if r in BISrule_dict:
				rule = BISrule_dict[r]
				message = rule['text']
				context = rule['context']
				flag = rule['flag']
				test = rule['test']
				if re.match(r'^(BR|UBL)-',r):
					R = '<a href="'+RULES_EN_CEN+r+'/'+lang+'/">'+r+'</a>'
				else:
					R = '<a href="'+RULES_EN_PEPPOL+r+'/'+lang+'/">'+r+'</a>'
				Rs += '<h5>'+R+' ('+flag+')</h5>'+message+'<br />'
				Rs += '<dl class="row">'
				if 'ja' == lang:
					Rs += '<dt class="col-3">対象(context)</dt><dd class="col-9"><code>'+context+'</code></dd>'+ \
								'<dt class="col-3">検証(test)</dt><dd class="col-9"><code>'+test+'</code></dd>'
				else:
					Rs += '<dt class="col-3">cotext</dt><dd class="col-9"><code>'+context+'</code></dd>'+ \
								'<dt class="col-3">test</dt><dd class="col-9"><code>'+test+'</code></dd>'
				Rs += '</dl>'
	return Rs

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

if __name__ == '__main__':
	# Create the parser
	parser = argparse.ArgumentParser(prog='jp-pint_syntax',
																	usage='%(prog)s [options] infile pint_rulefile jp_rulefile schematronfile ppeppol_rulefile cen_rulefile',
																	description='CSVファイルからJP-PINTのHTMLファイルを作成')
	# Add the arguments
	parser.add_argument('inFile',metavar='infile',type=str,help='入力TSVファイル')
	parser.add_argument('pint_ruleFile',metavar='pint_rulefile',type=str,help='PINTルールCSVファイル')
	parser.add_argument('jp_ruleFile',metavar='jp_rulefile',type=str,help='JPルールCSVファイル')
	parser.add_argument('schematronFile',metavar='schematronfile',type=str,help='スキーマトロンCSVファイル')
	parser.add_argument('peppol_ruleFile',metavar='peppol_rulefile',type=str,help='PEPPOLルールCSVファイル')
	parser.add_argument('cen_ruleFile',metavar='cen_rulefile',type=str,help='CENルールCSVファイル')

	parser.add_argument('-v','--verbose',action='store_true')
	parser.add_argument('-d','--detail',action='store_true')

	args = parser.parse_args()
	in_file = file_path(args.inFile)
	pint_rule_file = file_path(args.pint_ruleFile)
	jp_rule_file = file_path(args.jp_ruleFile)
	schematron_file = file_path(args.schematronFile)
	peppol_rule_file = file_path(args.peppol_ruleFile)
	cen_rule_file = file_path(args.cen_ruleFile)

	dir = os.path.dirname(in_file)

	syntax_en_html = 'billing-japan/syntax/ubl-'+MESSAGE+'/tree/en/index.html'
	syntax_ja_html = 'billing-japan/syntax/ubl-'+MESSAGE+'/tree/ja/index.html'
	
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
		for row in reader:
			context = row['context'].replace(' ','')
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
				'BT':BT
			}
			schematron_dict[id] = data

	# Read PINT Rule CSV file
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

	if detail:
		# Read BIS Rule CSV file
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
		('Align',''),
		('element','Invoice'),
		('XPath','/Invoice')
	])
	csv_list = [csv_item]
	with open(in_file,'r',encoding='utf-8') as f:
		reader = csv.DictReader(f,keys)
		header = next(reader)
		header = next(reader)
		for row in reader:
			path = row['Path']
			path = path.replace(' ','')
			row['XPath'] = path
			for k,v in variables.items():
				check = re.escape(k)
				if check in re.escape(path):
					path = path.replace(k,v)
					break
			row['Path'] = path
			if path:
				row['element'] = path2element(path)
				row['Level'] = str(path[1:].count('/'))
			csv_list.append(row)

	pint_list = [x for x in csv_list if ''!=x['SynSort'] and ''!=x['Path']]
	pint_list = sorted(pint_list,key=lambda x: x['SynSort'])

	# PINT rules 
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

	BISrules = {}
	BISrule_dict = {}
	if detail:
		# BIS rules
		for k,v in peppol_rule_dict.items():
			BISrule_dict[k] = v
			pint_ids = v['PINT_IDs']
			if pint_ids:
				pint_ids = pint_ids.split(' ')
				for pint_id in pint_ids:
					if not pint_id in BISrules:
						BISrules[pint_id] = set()
					BISrules[pint_id].add(k)
		for k,v in cen_rule_dict.items():
			BISrule_dict[k] = v
			pint_ids = v['PINT_IDs']
			if pint_ids:
				pint_ids = pint_ids.split(' ')
				for pint_id in pint_ids:
					if not pint_id in BISrules:
						BISrules[pint_id] = set()
					BISrules[pint_id].add(k)

	# update schematron_dict
	for k,v in schematron_dict.items():
		context = v['context']
		mC = re.findall(r'^.*(Invoice|cac:[a-zA-Z]+.*\/)(xs:[a-zA-Z]+\()?(cac:[a-zA-Z]+(\[[^\]]+\])?)?',context)
		_mC = [x[0]+x[2] for x in mC]
		test = v['test']
		mT = re.findall(r'(cac:[a-zA-Z]+\/)*(xs:[a-zA-Z]+\()*(cbc:[a-zA-Z\[\]\@\$\=]+)',test)
		_mT = [x[0]+x[2] for x in mT]
		BTs = set()
		if _mC:
			for ctx in _mC:
				for tst in _mT:
					if ctx:
						BTs.add('^.*'+re.escape(ctx.replace(' ',''))+'.*'+re.escape(tst.replace(' ',''))+'$')
					else:
						BTs.add('^.*'+re.escape(tst.replace(' ',''))+'$')
		else:
			for tst in _mT:
				BTs.add('^.*'+re.escape(tst.replace(' ',''))+'$')
		BTs = list(BTs)
		if BTs:
			Pset = set()
			for path in BTs:
				Ps = [x['PINT_ID'] for x in pint_list if re.match(path,x['Path'])]
				for id in Ps:
					Pset.add(id)
			if Pset:
				Ps = sorted(list(Pset))
				BTs = ' '.join(Ps)
				if detail:
					if verbose and BTs != v['BT']:
						print('{0} context:{1}\ntest:{2}\nRegEx:{3}\nFound:{4}\nRecorded:{5}\n\n'.format(k,v['context'],v['test'],path,BTs,v['BT']))
				v['BTs'] = BTs
				schematron_dict[k] = v

	children = {}
	with open(syntax_en_html,'w',encoding='utf-8',buffering=1,errors='xmlcharrefreplace',newline='') as f:
		lang = 'en'
		f.write(html_head.format(lang, APP_BASE))
		f.write(javascript_html)
		warning_en = '<p class="lead">NOTE: All element names are inhereted from Peppol International Invoicing (PINT) and naming use the term invoice, the same items are used in standard commercial invoice, summarised invoice and delivery note (debit note). The difference is Business process type (Profile ID) and Specification identifier (Customization ID). The tag names are correct according to the UBL 2.1 Invoice schema.</p>'
# 0.SPEC_TITLE_en 1.'selected' 2.'' 3.HOME_en 4.SYNTAX_MESSAGE_TITLE_en 5.'Legend' 
# 6.legend_en 7.'Shows a ...' 8.dropdown_menu 9.tooltipTextForSearch, 10.size 11.warning 12.APP_BASE 13.jang
# 14.NOT_SUPPORTED  15.gobacktext
		html = navbar_html.format(SPEC_TITLE_en,'selected','',HOME_en,SYNTAX_MESSAGE_TITLE_en,
															'Legend',legend_en,'Shows a modal window of legend information.',
															dropdown_menu_en,'ID or word in Term/Description','modal-lg',warning_en,OP_BASE,'',
															NOT_SUPPORTED_en,'Return to previous page.')
		f.write(html)
		f.write(table_html.format('XML','Datatype','Card','Business Term / Description','3%','33%'))
		for data in pint_list:
			path = data['Path']
			if 'element' in data:
				element = data['element']
			else:
				continue
			if 'Invoice' == element or re.match(r'^c[ab]c:.*$',element): # NOT write @attribute				
				writeTr_en(f,data)
			else:
				if re.match(r'^.*@[a-zA-Z]+$',element):
					if not path in children:
						children[path] = set()
					children[path].add(json.dumps(data))
		f.write(trailer.format('Go to top'))

	for data in pint_list:
		if not data or not data['Path']:
			continue
		lang = 'en'
		path = data['Path']
		if not 'element' in data:
			continue
		element = data['element']
		if 'Invoice' == element or re.match(r'^c[ab]c:.*$',element):
			if 'Invoice' == element:
				item_dir0 = 'billing-japan/syntax/ubl-'+MESSAGE+'/'+lang
			else:
				item_dir0 = 'billing-japan/syntax/ubl-'+MESSAGE+'/'+path[9:].replace(':','-')+'/'+lang

			os.makedirs(item_dir0,exist_ok=True)

			with open(item_dir0+'/index.html','w',encoding='utf-8',buffering=1,errors='xmlcharrefreplace',newline='') as f:
				paths = path[9:].replace(':','-').split('/')
				f.write(item_head.format(lang,APP_BASE))
				f.write(javascript_html)
				f.write('</head><body>')
				CARtitle = 'Alignment of cardinalities'
				f.write(infoCAR_Modal.format(CAR_Modal_title.format(CARtitle),infoCAR_en))
				# 0.SPEC_TITLE_en 1.'selected' 2.'' 3.lang 4.APP_BASE 5.'Legend' 6.info_item_modal_en 7.dropdown_menu_en　8.tooltipText 9.gobacktext
				f.write(item_navbar.format(SPEC_TITLE_en,'selected','',OP_BASE,'', \
																	'Legend',item_legend_en,dropdown_menu_en,'Show Legend','modal-lg','Go Back'))

				writeBreadcrumb(f,path,lang)

				name = element.replace('-',':')
				name = name.replace('_','/')
				Desc = '<br />'.join(data['Desc'].split('\\n'))

				f.write(item_header.format(name,Desc))

				NS = getNamespace(element)
				Datatype = data['Datatype']
				Card = data['Card']+'&nbsp;'
				if detail:
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
						Align = Align+' Semantic: element missing → Syntax: element mandatory<br />[Issue] Yes.<br />[Resolution] Agree on "default value if missing" (e.g. 0, 1-1-1970, AAA)'
					elif not Align:
						Align = '<i class="fa fa-minus" aria-hidden="true"></i>'
				Example = data['Example']
				if Example:
					Example = '<code>'+blank2fa_minus(Example)+'</code>'
				else:
					Example = '<i class="fa fa-minus" aria-hidden="true"></i>'
				BT = blank2fa_minus(data['BT'])
				id = data['PINT_ID']
				ID = '<a href="'+APP_BASE+'semantic/invoice/'+id+'/'+lang+'/"><h5>'+id+'</h5></a>'
				Explanation = '<br />'.join(data['Exp'].split('\\n'))
				if not Explanation:
					Explanation = '<i class="fa fa-minus" aria-hidden="true"></i>'
				if detail:
					html = item_data_detail.format('Namespace',NS,'XPath',data['XPath'],'Data type',Datatype, \
																'Cardinality',Card, \
																'UBL cardinality',data['Occ'],CAR_Button.format(CARtitle),Align, \
																'Business Term ID',ID,'Business Term',BT,'Additional Explanation',Explanation,'Example',Example)
				else:
					html = item_data.format('Namespace',NS,'XPath',data['XPath'],'Data type',Datatype, \
																'Cardinality',Card, \
																'Business Term ID',ID,'Business Term',BT,'Additional Explanation',Explanation,'Example',Example)
				f.write(html)
				Rules = blank2fa_minus(checkRules(data,lang))
				if detail:
					BIS_Rules = blank2fa_minus(checkBIS_Rules(data,lang))
					html = rule_data_detail.format('Transaction Business Rules',Rules,'BIS 3.0 Billing Rules (informative)',BIS_Rules)
				else:
					html = rule_data.format('Transaction Business Rules',Rules)
				f.write(html)
				html = ''
				if 'Invoice' == element or re.match(r'^cac:.*$',element):
					for _data in pint_list:
						_path = _data['Path']
						if not 'element' in _data:
							continue
						_element = _data['element']
						if path+'/'+_element == _path:
							html += setupTr(_data,'en')
				else:
					for _data in pint_list:
						_path = _data['Path']
						if not 'element' in _data:
							continue
						_element = _data['element']
						if path+'/'+_element == _path and _path in children:
							for child in children[_path]:
								_data = json.loads(child)
								html += setupTr(_data,'en')
				if html:
					f.write(child_elements_dt.format('Child element(s) / attribute(s)'))
					f.write(table_html.format('XML','Datatype','Card','Business Term / Description','0%','36%'))
					f.write(html)
					f.write(table_trailer)

				f.write(item_trailer.format('Go to top'))

	with open(syntax_ja_html,'w',encoding='utf-8',buffering=1,errors='xmlcharrefreplace',newline='') as f:
		lang = 'ja'
		f.write(html_head.format(lang,APP_BASE))
		f.write(javascript_html)
		warning_ja = '<p class="lead">注：すべての項目名は、Peppol International Invoicing (PINT)からのものです。共通して同じ名称が、都度請求書、合算請求書、納品書で使われています。違いは、ビジネスプロセスタイプ (Profile ID)と仕様ID (Customization ID)です。XML要素名、属性名は、UBL 2.1 Invoice に基づいています。</p>'
# 0.SPEC_TITLE_en 1.'selected' 2.'' 3.HOME_en 4.SYNTAX_MESSAGE_TITLE_en 5.'Legend' 
# 6.legend_en 7.'Shows a ...' 8.dropdown_menu 9.tooltipTextForSearch, 10.size 11.warning 12.APP_BASE 13.jang
# 14.NOT_SUPPORTED  15.gobacktext
		html = navbar_html.format(SPEC_TITLE_ja,'','selected',HOME_ja,SYNTAX_MESSAGE_TITLE_ja,
															'凡例',legend_ja,'凡例を説明するウィンドウを表示',
															dropdown_menu_ja,'IDまたは用語/説明文が含む単語','modal-lg',warning_ja,OP_BASE,'',
															NOT_SUPPORTED_ja,'前のページに戻る')
		f.write(html)
		f.write(table_html.format('XML','データ型','繰返','ビジネス用語 / 説明','3%','33%'))
		for data in pint_list:
			path = data['Path']
			if not 'element' in data:
				continue
			element = data['element']
			if 'Invoice' == element or re.match(r'^c[ab]c:.*$',element): # NOT write @attribute
				writeTr_ja(f,data)

		f.write(table_trailer)							
		f.write(trailer.format('先頭に前のページに'))

	for data in pint_list:
		if not data or not data['Path']:
			continue
		lang = 'ja'
		path = data['Path']
		if not 'element' in data:
			continue
		element = data['element']
		if 'Invoice' == element or re.match(r'^c[ab]c:.*$',element):
			if 'Invoice' == element:
				item_dir0 = 'billing-japan/syntax/ubl-'+MESSAGE+'/'+lang
			else:
				item_dir0 = 'billing-japan/syntax/ubl-'+MESSAGE+'/'+path[9:].replace(':','-')+'/'+lang

			os.makedirs(item_dir0,exist_ok=True)

			with open(item_dir0+'/index.html','w',encoding='utf-8',buffering=1,errors='xmlcharrefreplace',newline='') as f:
				paths = path[9:].replace(':','-').split('/')
				f.write(item_head.format(lang,APP_BASE))
				f.write(javascript_html)
				f.write('</head><body>')
				CARtitle = '繰返しの違いの調整'
				f.write(infoCAR_Modal.format(CAR_Modal_title.format(CARtitle),infoCAR_ja))
				# 0.SPEC_TITLE_en 1.'' 2.'selected' 3.lang 4.APP_BASE 5.'凡例' 6.info_item_modal_ja 7.dropdown_menu_ja 8.tooltipText 9.gobacktext
				f.write(item_navbar.format(SPEC_TITLE_ja,'','selected',OP_BASE,'',
																	'凡例',item_legend_ja,dropdown_menu_ja,'凡例を表示','modal-lg','前のページに戻る'))

				writeBreadcrumb(f,path,lang)

				Desc = '<br />'.join(data['Desc_ja'].split('\\n'))
				f.write(item_header.format(element,Desc))

				NS = getNamespace(element)
				Datatype = data['Datatype']
				Card = data['Card']+'&nbsp;'
				if detail:
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
						Align = Align+' element missing → Syntax: element mandatory<br />[問題] 問題。<br />[対策] 欠損した時のデフォルト値を決めておく。(例 0, 1-1-1970, AAA)'
					elif not Align:
						Align = '<i class="fa fa-minus" aria-hidden="true"></i>'
				BT = blank2fa_minus(data['BT_ja'])
				id = data['PINT_ID']
				ID = '<a href="'+APP_BASE+'semantic/invoice/'+id+'/'+lang+'/"><h5>'+id+'</h5></a>'
				Explanation = '<br />'.join(data['Exp_ja'].split('\\n'))
				if not Explanation:
					Explanation = '<i class="fa fa-minus" aria-hidden="true"></i>'
				Example = data['Example']
				if Example:
					Example = '<code>'+blank2fa_minus(Example)+'</code>'
				else:
					Example = '<i class="fa fa-minus" aria-hidden="true"></i>'
				if detail:
					html = item_data.format('ネームスペース',NS,'XPath',data['XPath'],'データ型',Datatype, \
																'繰返し',Card, \
																'UBL要素の繰返し',data['Occ'],CAR_Button.format(CARtitle),Align, \
																'ビジネス用語ID',ID,'ビジネス用語',BT,'追加説明',Explanation,'例',Example)
				else:
					html = item_data.format('ネームスペース',NS,'XPath',data['XPath'],'データ型',Datatype, \
																'繰返し',Card, \
																'ビジネス用語ID',ID,'ビジネス用語',BT,'追加説明',Explanation,'例',Example)
				f.write(html)
				Rules = blank2fa_minus(checkRules(data,lang))
				if detail:
					BIS_Rules = blank2fa_minus(checkBIS_Rules(data,lang))
					html = rule_data.format('ビジネスルール',Rules,'（参考）BIS 3.0 Billing ルール',BIS_Rules)
				else:
					html = rule_data.format('ビジネスルール',Rules)
				f.write(html)
				html = ''
				if 'Invoice' == element or re.match(r'^cac:.*$',element):
					for _data in pint_list:
						_path = _data['Path']
						_m = re.match(r'.*\/([^\/]+)$',_path)
						_element = _m.groups()[0]
						if path+'/'+_element == _path:
							html += setupTr(_data,'ja')
				else:
					for _data in pint_list:
						_path = _data['Path']
						if not 'element' in _data:
							continue
						_element = _data['element']
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
				f.write(item_trailer.format('先頭に戻る'))

	if verbose:
		print(f'** END ** {syntax_en_html} {syntax_ja_html}')