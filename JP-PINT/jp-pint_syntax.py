#!/usr/bin/env python3
#coding: utf-8
#
# generate JP-PINT Syntax binding html fron CSV file
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

from ubl2_1_cct import CCT
from ubl2_1_udt import UDT
from ubl2_1_cbc import CBC
from ubl2_1_cac import CAC
from ubl2_1_Invoice_2 import InvoiceType
complexType = CAC['complexType']

from jp_pint_base import MESSAGE # invoice debitnote summarized
from jp_pint_base import syntax_read_CSV_file
from jp_pint_base import basic_rule,shared_rule,aligned_rule 

from jp_pint_constants import profiles
message_title_en = profiles[MESSAGE]['title_en']
message_title_ja = profiles[MESSAGE]['title_ja']
profile_id = profiles[MESSAGE]['ProfileID']
customization_id = profiles[MESSAGE]['CustomizationID']

from jp_pint_constants import OP_BASE
from jp_pint_constants import APP_BASE
# from jp_pint_constants import SYNTAX_BASE
# from jp_pint_constants import RULES_UBL_JAPAN_BASE
# from jp_pint_constants import RULES_UBL_PINT_BASE
# from jp_pint_constants import RULES_EN_PEPPOL
# from jp_pint_constants import RULES_EN_CEN
from jp_pint_constants import SPEC_TITLE_en
from jp_pint_constants import SPEC_TITLE_ja
from jp_pint_constants import NOT_SUPPORTED_en
from jp_pint_constants import NOT_SUPPORTED_ja
from jp_pint_constants import SYNTAX_MESSAGE_TITLE_en
from jp_pint_constants import SYNTAX_MESSAGE_TITLE_ja
from jp_pint_constants import HOME_en
from jp_pint_constants import HOME_ja
from jp_pint_constants import variables
from jp_pint_constants import html_head
from jp_pint_constants import javascript_html
from jp_pint_constants import navbar_html
from jp_pint_constants import dropdown_menu_en
from jp_pint_constants import dropdown_menu_ja

dropdown_menu_en = dropdown_menu_en.format(APP_BASE)
dropdown_menu_ja = dropdown_menu_ja.format(APP_BASE)

legend_en = '''
	<dl class="row">
		<dt class="col-3">XML</dt>
		<dd class="col-9">UBL 2.1 XML element name</dd>
		<dt class="col-3">Datatype</dt>
		<dd class="col-9">UBL 2.1 XML type</dd>
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
		<dt class="col-3">UBL データ型</dt>
		<dd class="col-9">UBL 2.1 XMLタイプ</dd>
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
						<col span="1" style="width: 3%;">
						<col span="1" style="width: {3}%;">
						<col span="1" style="width: {4}%;">
						<col span="1" style="width: 50%;">
					</colgroup>
					<thead class="bg-light text-dark">
						<th>&nbsp;</th>
						<th>{0}</th>
						<th>{1}</th>
						<th>{2}</th>
					</thead>
					<tbody>
'''
from jp_pint_constants import table_trailer
from jp_pint_constants import trailer
# ITEM
from jp_pint_constants import item_head
item_legend = '''
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
			<tr><td>Attributes</td><td>IdentifierType<br />CodeType<br />TextType</td></tr>
		</tbody>
	</table>
'''

from jp_pint_constants import item_navbar
rule_data = '''
				<dt class="col-md-2">{0}</dt><dd class="col-md-10 mb-3">{1}</dd>
'''
child_elements_dt = '''
		<dt class="col-md-2">{0}</dt>
		<dd class="col-md-10 mb-3">
			<div class="table-responsive">
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

def file_path(pathname):
	if '/' == pathname[0:1]:
		return pathname
	else:
		dir = os.path.dirname(__file__)
		new_path = os.path.join(dir,pathname)
		return new_path

def setupTr(data,lang):
	if 'ja'== lang:
		return
	html = ''
	if not 'XPath' in data or not 'element' in data:
		return ''
	path = data['XPath']
	if 'Path' in data:
		pathDisp = data['Path']
	else: pathDisp = None
	element = data['element']
	name = element.replace('-',':')
	name = name.replace('_','/')
	name = name.replace('[','[ ')
	name = name.replace(']',' ]')
	if 'Card' in data:
		card = data['Card']
	else:
		card = ''
	if 'Occ' in data:
		occ = data['Occ']
	else: 
		occ = ''
	if 'Invoice' == element or re.match(r'^cac:.*$',element):
		html += '<tr class="group"'+ \
							' data-seq="'+data['SynSort']+'"'+ \
							' data-pint_id="'+data['PINT_ID']+'"'+ \
							' data-level="'+data['Level']+'"'+ \
							' data-card="'+card+'"'+ \
							' data-occ="'+occ+'"'+ \
							' data-path="'+data['Path']+'">'
		html += '<td class="expand-control" align="center"></td>'
	elif re.match(r'^cbc:.*$',element) or re.match(r'^@.+',element):
		html += '<tr'+ \
							' data-seq="'+data['SynSort']+'"'+ \
							' data-pint_id="'+data['PINT_ID']+'"'+ \
							' data-level="'+data['Level']+'"'+ \
							' data-path="'+data['Path']+'">'
		html += '<td>&nbsp;</td>'
	else:
		return ''
	
	if re.match(r'^@[a-zA-Z]+',element):
		html += '<td><span>'+occ+'</span></td>\n'
		html += '<td><span>'+element+'</span></td>\n'
		# html += '<td><span>'+datatype+'</span></td>\n'
	else:
		if 0 == len(path[9:]):
			item_dir = APP_BASE+'syntax/ubl-'+MESSAGE+'/'+lang+'/'
		else:
			if pathDisp: 
				item_dir = APP_BASE+'syntax/ubl-'+MESSAGE+'/'+pathDisp[9:].replace(':','-')+'/'+lang+'/'
			else:
				item_dir = APP_BASE+'syntax/ubl-'+MESSAGE+'/'+path[9:].replace(':','-')+'/'+lang+'/'
		html += '<td><span>'+occ+'</span></td>\n'
		html += '<td class="info-link"><a href="'+item_dir+'">'+name+'</a></td>'
	html += '<td><p>'
	if 'ja' == lang:
		pass
	else:
		if 'BT' in data and len(data['BT']) > 0:
			html += '<strong>'+data['BT']+'</strong><br />'
		if 'Definition' in data and len(data['Definition']) >  0:
			definition = '<em>'+('<br />'.join(data['Definition'].split('\\n')))+'</em>'
		else:
			definition = ''
	html += definition
	html += '</p></td></tr>'
	return html

def writeTr(f,data,lang):
	if 'ja'==lang:
		return
	tabs = '\t\t\t\t\t\t'
	if not 'XPath' in data:
		return
	path = data['XPath']
	if 'Path' in data:
		pathDisp = data['Path']
	else: pathDisp = None
	if 'element' in data:
		element = data['element']
	else:
		return
	name = element.replace('-',':')
	name = name.replace('_','/')
	name = name.replace('[','[ ')
	name = name.replace(']',' ]')
	# if 'Datatype' in data:
	# 	datatype = data['Datatype']
	# else:
	# 	datatype = ''
	if 'Card' in data:
		card = data['Card']
	else:
		card = ''
	if 'Occ' in data:
		occ = data['Occ']
	else:
		occ = ''
	if 'Invoice' == element or re.match(r'^cac:.*$',element):
		f.write(tabs+'<tr class="group"'+ \
									' data-seq="'+data['SynSort']+'"'+ \
									' data-pint_id="'+data['PINT_ID']+'"'+ \
									' data-level="'+data['Level']+'"'+ \
									' data-card="'+card+'"'+ \
									' data-xpath="'+data['XPath']+'"'+ \
									' data-path="'+data['Path']+'">\n')
		f.write(tabs+'\t<td class="expand-control" align="center"><i class="expand fa fa-plus-circle"></i>'+ 
									'<i class="fold fa fa-minus-circle" style="display:none"></i></td>\n')
	elif re.match(r'^cbc:.*$',element) or re.match(r'^@.+',element):
		f.write(tabs+'<tr'+ \
									' data-seq="'+data['SynSort']+'"'+ \
									' data-pint_id="'+data['PINT_ID']+'"'+ \
									' data-level="'+data['Level']+'"'+ \
									' data-card="'+card+'"'+ \
									' data-xpath="'+data['XPath']+'"'+ \
									' data-path="'+data['Path']+'">\n')
		f.write(tabs+'\t<td>&nbsp;</td>\n')
	else:
		return ''
	try:
		if pathDisp:
			level = '&bullet;&nbsp;'*int(pathDisp[1:].count('/'))
		else:
			level = '&bullet;&nbsp;'*int(path[1:].count('/'))
	except TypeError as e:
		level = ''
	if 0 == len(path[9:]):
		item_dir = APP_BASE+'syntax/ubl-'+MESSAGE+'/'+lang+'/'
	else:
		if pathDisp:
			item_dir = APP_BASE+'syntax/ubl-'+MESSAGE+'/'+pathDisp[9:].replace(':','-')+'/'+lang+'/'
		else:
			item_dir = APP_BASE+'syntax/ubl-'+MESSAGE+'/'+path[9:].replace(':','-')+'/'+lang+'/'
	f.write(tabs+'\t<td class="info-link">'+level+'<a href="'+item_dir+'">'+name+'</a></td>\n')
	# f.write(tabs+'\t<td><span>'+datatype+'</span></td>\n')
	f.write(tabs+'\t<td><span>'+occ+'</span></td>\n')
	f.write(tabs+'\t<td>\n'+tabs+'\t\t<p>\n')
	if 'ja' == lang:
		pass
		# if 'BT_ja' in data and len(data['BT_ja']) > 0:
		# 	f.write(tabs+'\t\t\t<strong>'+data['BT_ja']+'</strong><br />\n')
		# if 'Desc_ja' in data and len(data['Desc_ja']) > 0:
		# 	desc = tabs+'\t\t\t<em>'+('<br />'.join(data['Desc_ja'].split('\\n')))+'</em>\n'
		# else:
		# 	if datatype in complexType:
		# 		definition = complexType[datatype]['Definition']
		# 		desc = '(UBL2.1タイプ定義: '+definition+')'
		# 	else: desc = ''
	else:
		if 'BT' in data and len(data['BT']) > 0:
			f.write(tabs+'\t\t\t<strong>'+data['BT']+'</strong><br />\n')
		if 'Definition' in data and len(data['Definition']) > 0:
			definition = tabs+'\t\t\t<em>'+('<br />'.join(data['Definition'].split('\\n')))+'</em>\n'
		else:
			definition = ''
			# if datatype in complexType:
			# 	definition = complexType[datatype]['Definition']
			# 	desc = '(UBL 2.1 type definition: '+definition+')'
			# else: 
			# 	desc = ''
	f.write(definition+'</p>\n')
	example = ''		
	f.write(example+'</td>\n')
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
	f.write(tabs+'\t<li class="breadcrumb-item"><a href="'+OP_BASE+'">'+home_str+'</a></li>')
	item_dir = APP_BASE+'syntax/ubl-'+MESSAGE+'/'
	f.write(tabs+'\t<li class="breadcrumb-item"><a href="'+item_dir+'tree/'+lang+'/">'+name+'</a></li>')
	if '/Invoice' == path:
		f.write(tabs+'\t<li class="breadcrumb-item active">Invoice</li>')
	else:
		f.write(tabs+'\t<li class="breadcrumb-item"><a href="'+item_dir+lang+'/">Invoice</a></li>')
		# item_dir = APP_BASE+'syntax/ubl-'+MESSAGE+'/'
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
	if str: return str
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

if __name__ == '__main__':
	# Create the parser
	parser = argparse.ArgumentParser(prog='jp-pint_syntax',
																	usage='%(prog)s [options] infile',
																	description='CSVファイルからJP-PINTのHTMLファイルを作成')
	# Add the arguments
	parser.add_argument('inFile',metavar='infile',type=str,help='入力CSVファイル')
	parser.add_argument('-v','--verbose',action='store_true')

	args = parser.parse_args()
	in_file = file_path(args.inFile)

	dir = os.path.dirname(in_file)

	syntax_root = 'billing-japan/syntax/ubl-'+MESSAGE+'/'
	syntax_en_html = syntax_root+'tree/en/index.html'
	# syntax_ja_html = syntax_root+'tree/ja/index.html'
	
	verbose = args.verbose
	# Check if infile exists
	if not os.path.isfile(in_file):
		print('入力ファイルがありません')
		sys.exit()
	if verbose:
		print(f'** START ** {__file__}')
		print(f' -- APP_BASE={APP_BASE}')

	item_legend += '''
		<br />
		<hr>
		<h5>UBL 2.1</h5>
		<h6>UBL-UnqualifiedDataTypes-2.1</h6>
		<p class="namespace text-center">Table 2 -- urn:oasis:names:specification:ubl:schema:xsd:UnqualifiedDataTypes-2</p>
		<table class="syntax table table-sm table-hover" style="table-layout: fixed; width: 100%;">
			<colgroup>
				<col span="1" style="width: 15%;">
				<col span="1" style="width: 15%;">
				<col span="1" style="width: 18%;">
				<col span="1" style="width: 12%;">
				<col span="1" style="width: 8%;">
				<col span="1" style="width: 32%;">
			</colgroup>
			<thead class="thead-light">
				<th>UniqueID</th>
				<th>name</th>
				<th>base / type</th>
				<th>PrimitiveType</th>
				<th>use</th>
				<th>Definition</th>
			</thead>
			<tbody class="table-striped">
	'''
	for k,v in UDT.items():
		item_legend += '<tr><td>'+v['UniqueID']+'</td><td><strong>'+k+'</strong></td><td>'+v['base']+'</td><td>'+ \
									'&nbsp;</td><td>&nbsp;</td><td>'+v['Definition']+'</td></tr>'
		if 'attribute' in v:
			for ak,av in v['attribute'].items():
				if 'UsageRule' in av:
					item_legend += '<tr><td>'+av['UniqueID']+'</td><td>@'+ak+'</td><td>'+av['type']+'</td><td>'+ \
											av['PrimitiveType']+'</td><td>'+av['use']+'</td><td>'+ \
											av['Definition']+'<br />'+av['UsageRule']+'</td></tr>'
				else:
					item_legend += '<tr><td>'+av['UniqueID']+'</td><td>@'+ak+'</td><td>'+av['type']+'</td><td>'+ \
											av['PrimitiveType']+'</td><td>'+av['use']+'</td><td>'+av['Definition']+'</td></tr>'
	item_legend += '</tbody></table>'

	item_legend += '''
		<br />
		<h6>CCTS_CCT_SchemaModule-2.1.xsd</h6>
		<p class="text-center">Table 3 -- ccts-cct urn:un:unece:uncefact:data:specification:CoreComponentTypeSchemaModule:2</p>
		<table class="syntax table table-sm table-hover" style="table-layout: fixed; width: 100%;">
			<colgroup>
				<col span="1" style="width: 15%;">
				<col span="1" style="width: 20%;">
				<col span="1" style="width: 15%;">
				<col span="1" style="width: 10%;">
				<col span="1" style="width: 8%;">
				<col span="1" style="width: 32%;">
			</colgroup>
			<thead class="thead-light">
				<th>UniqueID</th>
				<th>name</th>
				<th>base / type</th>
				<th>PrimitiveType</th>
				<th>use</th>
				<th>Definition</th>
			</thead>
			<tbody class="table-striped">
	'''
	for k,v in CCT.items():
		item_legend += '<tr><td>'+v['UniqueID']+'</td><td><strong>'+k+'</strong></td><td>'+v['base']+'</td><td>'+ \
									v['PrimitiveType']+'</td><td>&nbsp;</td><td>'+v['Definition']+'</td></tr>'
		for ak,av in v['attribute'].items():
			if 'UsageRule' in av:
				item_legend += '<tr><td>'+av['UniqueID']+'</td><td>@'+ak+'</td><td>'+av['type']+'</td><td>'+ \
										av['PrimitiveType']+'</td><td>'+av['use']+'</td><td>'+ \
										av['Definition']+'<br />'+av['UsageRule']+'</td></tr>'
			else:
				item_legend += '<tr><td>'+av['UniqueID']+'</td><td>@'+ak+'</td><td>'+av['type']+'</td><td>'+ \
										av['PrimitiveType']+'</td><td>'+av['use']+'</td><td>'+av['Definition']+'</td></tr>'
	item_legend += '</tbody></table>'

	# read csv file
	csv_list = syntax_read_CSV_file(in_file)
	pint_list = [x for x in csv_list if ''!=x['SynSort'] and ''!=x['Path']]
	pint_list = sorted(pint_list,key=lambda x: x['SynSort'])
	
	if verbose:
		print(' -- write index table')

	children = {}
	with open(syntax_en_html,'w',encoding='utf-8',buffering=1,errors='xmlcharrefreplace',newline='') as f:
		lang = 'en'
		f.write(html_head.format(lang,APP_BASE))
		html = navbar_html.format(SPEC_TITLE_en,'selected','',HOME_en,SYNTAX_MESSAGE_TITLE_en,
															'Legend',legend_en,'Shows a modal window of legend information.',
															dropdown_menu_en,searchLegend_en,'modal-lg',warning_en,OP_BASE,'',
															NOT_SUPPORTED_en,'Return to previous page.','Search')
		f.write(html)

		f.write(table_html.format('XML Element','Card','Business Term / Description','40','7'))
		for data in pint_list:
			if not 'XPath' in data or not 'element' in data:
				continue
			path = data['XPath']
			element = data['element']
			if 'Invoice' == element or re.match(r'^c[ab]c:.*$',element): # NOT write @attribute				

				writeTr(f,data,lang)

			else:
				if re.match(r'^.*@[^\/]+$',element):
					if not path in children:
						children[path] = set()
					children[path].add(json.dumps(data))

		f.write(trailer.format('Go to top'))
		f.write(javascript_html)
		f.write('</body></html>')

	if verbose:
		print(f' -- write each element')

	xpath_map = {}
	for data in pint_list:
		xpath = data['XPath']
		xpath = re.sub(r'\[[^\]]+\]','',xpath)
		if not xpath:
			continue
		id = data['PINT_ID']
		if id:
			if not xpath in xpath_map:
				xpath_map[f'/ubl:{xpath[1:]}'] = [id]
			else:
				xpath_map[f'/ubl:{xpath[1:]}'] += [id]

	result = basic_rule('data/Rules_Basic.json')
	Basic_Dict = result['dict']
	Basic_test = result['test']
	Basic_binding = result['binding']
	Shared_rule = shared_rule('data/Rules_Shared.json')
	Aligned_rule = aligned_rule('data/Rules_Aligned.json')

	for data in pint_list:
		if not 'XPath' in data: # or not 'element' in data:
			continue
		lang = 'en'
		path = data['XPath']
		if 'Path' in data:
			pathDisp = data['Path']
		else: pathDisp = None
		element = data['element']
		if 'Invoice' == element or re.match(r'^c[ab]c:.*$',element):
			if 'Invoice' == element:
				item_dir0 = syntax_root+lang
			else:
				if pathDisp: 
					item_dir0 = syntax_root+pathDisp[9:].replace(':','-')+'/'+lang+'/'
				else:
					item_dir0 = syntax_root+path[9:].replace(':','-')+'/'+lang+'/'

			os.makedirs(item_dir0,exist_ok=True)

			with open(item_dir0+'/index.html','w',encoding='utf-8',buffering=1,errors='xmlcharrefreplace',newline='') as f:
				paths = path[9:].replace(':','-').split('/')
				f.write(item_head.format(lang,APP_BASE))
				f.write('</head><body>')
				# CARtitle = 'Alignment of cardinalities'
				f.write('<header class="sticky-top bg-white px-0 py-2">')
				# f.write(infoCAR_Modal.format(CAR_Modal_title.format(CARtitle),infoCAR_en))
				# 0.SPEC_TITLE_en 1.'selected' 2.'' 3.lang 4.APP_BASE 5.'Legend' 6.info_item_modal_en 7.dropdown_menu_en　8.tooltipText 9.modal-size 10.gobacktext 11.warning
				f.write(item_navbar.format(SPEC_TITLE_en,'selected','',OP_BASE,'','Legend',item_legend,dropdown_menu_en,
																	'Show Legend','modal-xl','Go Back',warning_en))
				if pathDisp:
					writeBreadcrumb(f,pathDisp,lang)
				else:
					writeBreadcrumb(f,path,lang)
				f.write('</header>\n')

				name = element.replace('-',':')
				name = name.replace('_','/')

				definition = data['Definition']
				if definition:
					Definition = '<br />'.join(definition.split('\\n'))
					Definition += ' (UBL 2.1)'
				else: Definition = ''
				if 'Datatype' in data:
					datatype = data['Datatype']
				else: datatype = ''
				NS = getNamespace(element)
				if 'selectors' in data:
					selectors = data['selectors']
				else: selectors = ''
				Selectors = blank2fa_minus(selectors)
				if 'Datatype' in data:
					datatype = data['Datatype']
				else: datatype = ''
				Datatype = blank2fa_minus(datatype)
				if 'Card' in data:
					card = data['Card']
				else: card = ''
				Card = blank2fa_minus(card)
				if 'Occ' in data:
					occ = data['Occ']
				else: occ = ''
				Occ = blank2fa_minus(occ)
				if 'Desc' in data:
					desc = data['Desc']
				else: desc = ''
				Desc = blank2fa_minus(desc)
				id = data['PINT_ID']
				if id:
					BT = '<a href="'+APP_BASE+'semantic/'+MESSAGE+'/'+id+'/'+lang+'/"><h5>'+data['BT']+'</h5></a>'
				else:
					BT = blank2fa_minus(id)
				DT = data['DT']
				if not DT and DT in datatypeDict:
					DT = datatypeDict[DT]
				elif DT:
					pass
				else:
					DT = '<i class="fa fa-minus" aria-hidden="true"></i>'
				xpath = data['XPath']

				f.write('<div class="container">')

				html = ''
				html += f'<div class="page-header"><h1>{name}</h1></div>'
				# html += f'<div class="page-header"><h2>{BT}</h2></div>'
				html += f'<p class="lead">{Definition}</p>'
				html += '<h4>About</h4>'
				html += '<dl class="row">'
				html += f'<dt class="col-md-2">Datatype</dt><dd class="col-md-10 mb-3">{Datatype}</dd>'
				html += f'<dt class="col-md-2">Cardinality</dt><dd class="col-md-10 mb-3">{Occ}</dd>'
				html += f'<dt class="col-md-2">XPath</dt><dd class="col-md-10 mb-3">{xpath}</dd>'
				html += f'<dt class="col-md-2">Selectors</dt><dd class="col-md-10 mb-3">{Selectors}</dd>'
				html += f'<dt class="col-md-2">Namespace</dt><dd class="col-md-10 mb-3">{NS}</dd>'
				html += '</dl>'
				f.write(html)
				
				html = '<hr>'
				html += '<h4>Semantic</h4>'
				html += '<dl class="row">'
				html += f'<dt class="col-md-2">Business Term</dt><dd class="col-md-10 mb-3">{BT}</dd>'
				html += f'<dt class="col-md-2">ID</dt><dd class="col-md-10 mb-3">{id}</dd>'
				html += f'<dt class="col-md-2">Semantic datatype</dt><dd class="col-md-10 mb-3">{DT}</dd>'
				html += f'<dt class="col-md-2">Cardinality</dt><dd class="col-md-10 mb-3">{Card}</dd>'
				html += f'<dt class="col-md-2">Description</dt><dd class="col-md-10 mb-3">{Desc}</dd>'
				html += '</dl>'
				f.write(html)

				if '/ubl:Invoice' == xpath:
					continue
				if '/Invoice' == xpath[:8]:
					path = '/ubl:'+xpath[1:]
				# elif '/ubl:Invoice' == xpath[:12]:
				else:
					path = xpath
				Basic = []
				if path in Basic_test: Basic += Basic_test[path]
				if path in Basic_binding: Basic += Basic_binding[path]
				Basic = [x for x in set(Basic)]
				if len(Basic) > 0 or id in Shared_rule or id in Aligned_rule:
					f.write('<hr>')
					path = re.sub(r'\[[^\]]+\]','',xpath)
					if len(Basic) > 0:
						html = '<h4>Basic Rule(s)</h4>'
						html += '<dl class="row">'
						for rule in Basic:
							html += f'<dt class="col-md-2">{rule} ( {Basic_Dict[rule]["Flag"]} )</dt><dd class="col-md-10 mb-3">{Basic_Dict[rule]["Message"]}</dd>'
							html += f'<dt class="col-md-2 text-right">Context</dt><dd class="col-md-10 mb-3"><code>{Basic_Dict[rule]["Context"]}</code></dd>'
							html += f'<dt class="col-md-2 text-right">Text</dt><dd class="col-md-10 mb-3"><code>{Basic_Dict[rule]["Test"]}</code></dd>'
						html += '</dl>'
						f.write(html)
					if id in Shared_rule:
						html = '<h4>Shared Rule(s)</h4>'
						html += '<dl class="row">'
						for rule in Shared_rule[id]:
							if 'Flag' in rule and 'Message' in rule:
								message = rule["Message"]
								rule_id = re.findall(r'\[(.*)\]',message)
								if len(rule_id) > 0:
									rule_id = rule_id[0]
								html += f'<dt class="col-md-2">{rule_id} ( {rule["Flag"]} )</dt><dd class="col-md-10 mb-3">{message}</dd>'
								html += f'<dt class="col-md-2 text-right">Context</dt><dd class="col-md-10 mb-3"><code>{rule["Context"]}</code></dd>'
								html += f'<dt class="col-md-2 text-right">Test</dt><dd class="col-md-10 mb-3"><code>{rule["Test"]}</code></dd>'
						html += '</dl>'
						f.write(html)
					if id in Aligned_rule:
						html = '<h4>Shared Rule(s)</h4>'
						html += '<dl class="row">'
						for rule in Aligned_rule[id]:
							if 'Flag' in rule and 'Message' in rule:
								message = rule["Message"]
								rule_id = re.findall(r'\[(.*)\]',message)
								if len(rule_id) > 0:
									rule_id = rule_id[0]
								html += f'<dt class="col-md-2">{rule_id} ( {rule["Flag"]} )</dt><dd class="col-md-10 mb-3">{message}</dd>'
								html += f'<dt class="col-md-2 text-right">Context</dt><dd class="col-md-10 mb-3"><code>{rule["Context"]}</code></dd>'
								html += f'<dt class="col-md-2 text-right">Test</dt><dd class="col-md-10 mb-3"><code>{rule["Test"]}</code></dd>'
						html += '</dl>'
						f.write(html)

				html = ''
				if 'Invoice' == element or re.match(r'^cac:.*$',element):
					for _data in pint_list:
						if not 'XPath' in _data or not 'element' in _data:
							continue
						_path = _data['XPath']
						_element = _data['element']
						if path+'/'+_element == _path:
							html += setupTr(_data,lang)
				else:
					for _data in pint_list:
						if not 'XPath' in _data or not 'element' in _data:
							continue
						_path = _data['XPath']
						_element = _data['element']
						if path+'/'+_element == _path and _path in children:
							for child in children[_path]:
								_data = json.loads(child)
								html += setupTr(_data,lang)
				if html:
					f.write('<hr>')
					f.write('<h4>Child element(s) / attribute(s)</h4>')
					f.write(table_html.format('Card','XML Element','Business Term / Description','7','40'))
					f.write(html)
					f.write(table_trailer)

				f.write(item_trailer.format('Go to top'))
				f.write('<div class="bg-white m-3">')
				f.write('<p>This site is provided by <a href="https://www.sambuichi.jp/?page_id=670&lang=en">Sambuichi Profssional Engineers Office</a> for verification.</p>')
				f.write('<p><a rel="license" href="http://creativecommons.org/licenses/by-sa/4.0/"><img alt="Creative Commons License" style="border-width:0" src="https://i.creativecommons.org/l/by-sa/4.0/88x31.png" /></a> CC BY-SA 4.0 This work is licensed under a <a rel="license" href="http://creativecommons.org/licenses/by-sa/4.0/">Creative Commons Attribution-ShareAlike 4.0 International License</a>.</p>')
				f.write('</div>')
				f.write('</div>')
				f.write(javascript_html)
				f.write('</body></html>')

	if verbose:
		print(f'** END ** {syntax_en_html}')# {syntax_ja_html}')