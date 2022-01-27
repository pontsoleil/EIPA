#!/usr/bin/env python3
#coding: utf-8
#
# generate JP-PINT semantic html fron CSV file
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

# from jp_pint_base import APP_BASE
from jp_pint_base import MESSAGE # invoice debitnote summarized
from jp_pint_base import semantic_read_CSV_file 
from jp_pint_base import basic_rule,shared_rule,aligned_rule 

from jp_pint_constants import profiles
message_title_en = profiles[MESSAGE]['title_en']
message_title_ja = profiles[MESSAGE]['title_ja']
profile_id = profiles[MESSAGE]['ProfileID']
customization_id = profiles[MESSAGE]['CustomizationID']
from jp_pint_constants import OP_BASE
from jp_pint_constants import APP_BASE
# from jp_pint_constants import SEMANTIC_BASE
# # from jp_pint_constants import SYNTAX_BASE
# # from jp_pint_constants import RULES_BASE
from jp_pint_constants import RULES_UBL_JAPAN_BASE
from jp_pint_constants import RULES_UBL_PINT_BASE
from jp_pint_constants import RULES_EN_PEPPOL
from jp_pint_constants import RULES_EN_CEN

from jp_pint_constants import SPEC_TITLE_en
from jp_pint_constants import SPEC_TITLE_ja

from jp_pint_constants import SEMANTICS_MESSAGE_TITLE_en
from jp_pint_constants import SEMANTICS_MESSAGE_TITLE_ja

from jp_pint_constants import HOME_en
from jp_pint_constants import HOME_ja
from jp_pint_constants import NOT_SUPPORTED_en
from jp_pint_constants import NOT_SUPPORTED_ja

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
            <dt class="col-3"><strong>ID</strong></dt>
            <dd class="col-9">
              An identifier for the information element (BT - Business Term) and group of information elements (BG - business terms group). The identifiers are not necessarily consecutive or in sequence.</p>
            </dd>
            <dt class="col-3"><strong>Level</strong></dt>
            <dd class="col-9">
              Indicates on which level in the model the information element occurs:<br />
              ー &bullet;: The first level of the model;<br />
              ー &bullet;&bullet;: The second level of the model. The information element (or the group of information elements) is part of a group of information elements which id defined at the first level of the model;<br />
              ー &bullet;&bullet;&bullet;: The third level of the model. The information element (or the group of information elements) is part of a group of information elements which id defined at the second level of the model;<br />
              ー &bullet;&bullet;&bullet;&bullet;: The fourth level of the model, The information element (or the group of information elements) is part of a group of information elements which id defined at the third level of the model;</p>
            </dd>
						<dt class="col-3"><strong>Business Term</strong></dt>
            <dd class="col-9">
              The name of the information element used in the core invoice model or the name of a coherent group of related information elements, provided to give logical meaning.</p>
            </dd>
						<dt class="col-3"><strong>Semantic data type</strong></dt>
						<dd class="col-9"><a href="https://test-docs.peppol.eu/japan/master/billing-1.0/bis/#_semantic_data_types">Peppol BIS Japan Billing</a>
						</dd>
            <dt class="col-3"><strong>Cardinality</strong></dt>
            <dd class="col-9">
              Also known as multiplicity is used to indicate if an information element (or group of information elements) is mandatory or conditional, and if it is repeatable. The cardinality shall always be analysed in the context of where the information element is used. Example: the payee Name is mandatory in the core invoice model, but only when a payee is stated and is relevant.<br />
              The following cardinalities exist:<br />
              ー 1..1: Mandatory, minimum 1 occurence and maximum 1 occurrence of the information element (or group of the information elements) shall be present in any compliant instance document;<br />
              ー 1..n: Mandatory and repeatable, minimum 1 occurrence and unbounded upper maximum occurrences of the information element (or group of information elements) shall be present in any compliant instance document;<br />
              ー 0..1: Conditional,minimum 0 occurence and maximum 1 occurrence of the information element (or group of the information elements) may be present in any compliant instance document; it's use depends on business rules stated as well as the regulatory, commercial and contractual conditions that applies to the business transaction;<br />
              ー 0..n: Conditional,minimum 0 occurence and unboounded upper maximum occurrence of the information element (or group of the information elements) may be present in any compliant instance document; it's use depends on business rules stated as well as the regulatory, commercial and contractual conditions that applies to the business transaction;</p>
            </dd>

            <dt class="col-3"><strong>Description</strong></dt>
            <dd class="col-9">
              A description of the semantic meaning of the information element.
            </dd>
          </dl>
'''
legend_ja = '''
          <dl class="row">
            <dt class="col-3"><strong>ID</strong></dt>
            <dd class="col-9">
							情報要素（BT - ビジネス用語）および情報要素のグループ（BG - ビジネス用語グループ）の識別子。識別子は必ずしも連続した番号がふられるとは限らない。
            </dd>
            <dt class="col-3"><strong>レベル(Level)</strong></dt>
            <dd class="col-9">
							モデルのどのレベルで情報要素が出現するかを示す。
              ー &bullet;: モデルの最初のレベル;<br />
              ー &bullet;&bullet;: モデルの第2レベル。情報要素（または情報要素のグループ）は、モデルの最初のレベルで定義された情報要素のグループの一部;<br />
              ー &bullet;&bullet;&bullet;: モデルの第3レベル。情報要素（または情報要素のグループ）は、モデルの第2レベルで定義された情報要素のグループの一部;<br />
              ー &bullet;&bullet;&bullet;&bullet;: モデルの第4レベル、情報要素（または情報要素のグループ）は、モデルの第3レベルで定義された情報要素のグループの一部;</p>
            </dd>
            <dt class="col-3"><strong>カーディナリティ(Cardinality) / 繰返し</strong></dt>
            <dd class="col-9">
              多重度とも呼ばれ、情報要素（または情報要素のグループ）の出現が必須か条件付きか、繰り返し可能かどうかを示すために使用される。カーディナリティは、情報要素が使用される場所のコンテキストで常に分析される。例：コア請求書モデルでは受取人名は必須だが、それは、受取人が記載されており、関連性がある場合に限る。<br />
							カーディナリティには、次がある：
              ー 1..1: 必須、最小1回および最大1回の出現。情報要素（または情報要素のグループ）は、準拠するインスタンスドキュメントに存在しなければならない;<br />
              ー 1..n: 必須、最小1回で上限は無制限の出現。情報要素（または情報要素のグループ）は、準拠するインスタンスドキュメントに存在しなければならない;<br />
              ー 0..1: 条件付き、最小0回および最大1回の出現。情報要素（または情報要素のグループ）は、準拠するインスタンスドキュメントに存在する可能性がある。使用するかどうかは、記載されているビジネスルール、およびビジネストランザクションに適用される規制、商業、および契約条件によって異なる;<br />
              ー 0..n: 条件付き、最小0の発生で上限は無制限の出現。情報要素（または情報要素のグループ）は、準拠するインスタンスドキュメントに存在する可能性がある。使用するかどうかは、記載されているビジネスルール、およびビジネストランザクションに適用される規制、商業、および契約条件によって異なる;</p>
            </dd>
            <dt class="col-3"><strong>ビジネス用語</strong></dt>
            <dd class="col-9">
              コアインボイス モデルで使用される情報要素の名前、または、関連する情報要素のまとめたグループの名前。論理的な意味を与えるために提供される。
            </dd>
            <dt class="col-3"><strong>説明</strong></dt>
            <dd class="col-9">
              情報要素の意味の説明。
            </dd>
          </dl>
'''
table_html = '''
				<table class="semantics table table-sm table-hover" style="table-layout: fixed; width: 100%;">
					<colgroup>
						<col span="1" style="width: 3%;">
						<col span="1" style="width: {4}%;">
						<col span="1" style="width: {5}%;">
						<col span="1" style="width: {6}%;">
						<col span="1" style="width: 50%;">
					</colgroup>
					<thead class="bg-light text-dark">
						<th>-</th>
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
info_item_modal_en = '''
          <dl class="row">
            <dt class="col-3"><strong>Semantic datatype</strong></dt>
            <dd class="col-9">
							<a href="https://docs.peppol.eu/poacc/billing/3.0/bis/#_semantic_datatypes">Semantic datatypes</a><br />
							Semantic datatypes are used to bridge the gap between the semantic concepts expressed by the information elements defined in the semantic model from EN 16931 and the technical implementation. The semantic data types define the allowed value domain for the content, and any additional information components (attributes) needed in order to ensure its precise interpretation.
            </dd>
            <dt class="col-3"><strong>Section</strong></dt>
            <dd class="col-9">
							4a. Peppol International Invoice (PINT) Presented by Georg Birgisson<br />
							Source: OpenPeppol Cross-Community Plenary session 20.10.2020
							<dl calss="row">
								<dt class="col-3"><strong>•Shared</strong></dt>
								<dd class="col-9">
									Common for all domains. Minimum rules<br />
									Sufficient for basic automations
								</dd>
								<dt class="col-3"><strong>•Aligned</strong></dt>
								<dd class="col-9">
									Understood in general terms by all domains<br />
									No rules<br />
									Not optimized for automation<br />
									Can be specialized for domain specific automation and compliance<br />
								</dd>
								<dt class="col-3"><strong>•Distinct</strong></dt>
								<dd class="col-9">
									Only understood in the relevant domain
								</dd>
							</dl>
						</dd>
            <dt class="col-3"><strong>Extension</strong></dt>
            <dd class="col-9">
							Extension to the EN 16931
            </dd>
            <dt class="col-3"><strong>XPath</strong></dt>
            <dd class="col-9">
							XPath location of this data element
            </dd>
            <dt class="col-3"><strong>Specific requirements</strong></dt>
            <dd class="col-9">
							Specific requirements for this data element.
            </dd>
						<dt class="col-3"><strong>Rules</strong></dt>
            <dd class="col-9">
							Business rules for this data element.
            </dd>
						<dt class="col-3"><strong>Rules for BIS 3.0 Billing (informative)</strong></dt>
            <dd class="col-9">
							Business rules for this data element defined in BIS 3.0 Billing.
            </dd>
          </dl>
'''
info_item_modal_ja = '''
          <dl class="row">
            <dt class="col-3"><strong>セマンティックデータ型</strong></dt>
            <dd class="col-9">
							<a href="https://docs.peppol.eu/poacc/billing/3.0/bis/#_semantic_datatypes">Semantic datatypes</a><br />
								セマンティックデータ型は、EN16931のセマンティックモデルで定義された情報要素によって表現されるセマンティック概念と技術的な実装との間のギャップを埋めるために使用される。 セマンティックデータ型は、内容とする値の許容値の範囲と、その正確な解釈を保証するために必要な追加の情報構成要素（属性）を定義する。
						</dd>
            <dt class="col-3"><strong>Section</strong></dt>
            <dd class="col-9">
							4a. Peppol International Invoice (PINT) Presented by Georg Birgisson<br />
							Source: OpenPeppol Cross-Community Plenary session 20.10.2020
							<dl calss="row">
								<dt class="col-3"><strong>•Shared</strong></dt>
								<dd class="col-9">
									全ての管轄地域に共通。最低限のルール<br />
									基本レベルの自動化には十分
								</dd>
								<dt class="col-3"><strong>•Aligned</strong></dt>
								<dd class="col-9">
									すべての管轄地域で一般的に理解されている<br />
									特定のルールはない<br />
									自動化用に最適化されていない<br />
									管轄地域固有に特化して自動化とコンプライアンスを可能にする<br />
								</dd>
								<dt class="col-3"><strong>•Distinct</strong></dt>
								<dd class="col-9">
									関連する管轄地域でのみ理解される
								</dd>
							</dl>
						</dd>
            <dt class="col-3"><strong>欧州規格の拡張</strong></dt>
            <dd class="col-9">
							欧州規格EN 16931に対する拡張の内容
            </dd>
            <dt class="col-3"><strong>XPath</strong></dt>
            <dd class="col-9">
							この要素のXPath
            </dd>
            <dt class="col-3"><strong>特定の使用条件</strong></dt>
            <dd class="col-9">
							この要素に関連した特定の使用条件
            </dd>
						<dt class="col-3"><strong>ビジネスルール</strong></dt>
            <dd class="col-9">
							この要素に関連するビジネスルール
            </dd>
						<dt class="col-3"><strong>（参考）IS 3.0 Billing ビジネスルール</strong></dt>
            <dd class="col-9">
							BIS 3.0 Billingで定義された　この要素に関連するビジネスルール
            </dd>
          </dl>
'''
from jp_pint_constants import item_navbar
from jp_pint_constants import item_info_modal
rule_table_head = '''
					<table class="table table-borderless table-sm table-hover">
						<colgroup>
							<col span="1" style="width: 20%;">
							<col span="1" style="width: 80%;">
						</colgroup>
						<tbody>
'''
rule_table_row = '''
						<tr><td><a href="{5}rules/{0}/{1}/{2}/">{3}</a></td>
						<td>{4}</td></tr>
'''
rule_table_trailer = '''
						</tbody>
					</table>
''' 
childelements_dt = '''
		<dt class="col-md-2">{0}</dt>
		<dd class="col-md-10 mb-3">
			<div class="table-responsive semantics">
'''
from jp_pint_constants import item_trailer
from jp_pint_constants import warning_en
from jp_pint_constants import warning_ja
from jp_pint_constants import searchLegend_en
from jp_pint_constants import searchLegend_ja

def file_path(pathname):
	if '/' == pathname[0:1]:
		return pathname
	else:
		dir = os.path.dirname(__file__)
		new_path = os.path.join(dir,pathname)
		return new_path

def blank2fa_minus(str):
	if str:
		return str
	return '<i class="fa fa-minus" aria-hidden="true"></i>'

def setupTr(data,lang):
	id = data['PINT_ID']
	ID = id.upper()
	html = ''
	if re.match(r'(IBG|ibg)-[0-9]*$',id):
		html += '<tr class="group"'+ \
						' data-seq="'+data['SemSort']+'"'+ \
						' data-pint_id="'+data['PINT_ID']+'"'+ \
						' data-level="'+data['Level']+'"'+ \
						' data-card="'+data['Card']+'"'+ \
						' data-path="'+data['XPath']+'">'
		html += '<td class="expand-control" align="center"></td>'
	elif re.match(r'(IBT|ibt)-[0-9]+(-[0-9]+)?$',id):
		html += '<tr'+ \
						' data-seq="'+data['SemSort']+'"'+ \
						' data-pint_id="'+data['PINT_ID']+'"'+ \
						' data-level="'+data['Level']+'"'+ \
						' data-card="'+data['Card']+'"'+ \
						' data-path="'+data['XPath']+'">'
		html += '<td>&nbsp;</td>'
	else:
		return html
	html += '<td>'+id+'</td>'
	level = ''
	if re.match(r'^ib[tg]-[0-9]+(-[0-9]+)?$',id):
		# item_dir = semantic_root+id+'/'+lang+'/'
		item_dir = APP_BASE+'semantic/'+MESSAGE+'/'+id+'/'+lang+'/'
		# if 'ja' == lang:
		# 	html += '<td class="info-link">'+level+'<a href="'+item_dir+'">'+data['BT_ja']+'</a></td>'
		# else:
		html += '<td class="info-link">'+level+'<a href="'+item_dir+'">'+data['BT']+'<br>'+data['BT_ja']+'</a></td>'
	else:
		# if 'ja' == lang:
		# 	html += '<td><span>'+level+data['BT_ja']+'</span></td>'
		# else:
		html += '<td><span>'+level+data['BT']+'<br>'+data['BT_ja']+'</span></td>'
	html += '<td><span>'+data['Card']+'</span></td>'
	# html += '<td><span>'+data['DT']+'</span></td>'
	desc = ''
	if 'ja' == lang:
		if 'Desc_ja' in data:
			desc = '<p>'+('<br />'.join(data['Desc_ja'].split('\\n')))+'</p>'
	else:
		if 'Desc' in data:
			desc = '<p>'+('<br />'.join(data['Desc'].split('\\n')))+'</p>'
	html += '<td>'+desc+'</td>'
	# if data['Example']:
	# 	example = '例: <code>'+data['Example']+'</code>'
	# else:
	# 	example = ''
	# html += example+'</td>'
	return html

def writeTr(f,data,lang):
	# lang = 'en'
	id = data['PINT_ID']
	if re.match(r'(IBG|ibg)-[0-9]+(-[0-9]+)?$',id):
		f.write('<tr class="group" data-seq="{0}" data-pint_id="{1}" data-level="{2}" data-card="{3}" data-path="{4}">'.format(
			data['SemSort'],data['PINT_ID'],data['Level'],data['Card'],data['XPath']
		))
		f.write('<td class="expand-control" align="center">'+
							'<i class="expand fa fa-plus-circle"></i>'+ 
							'<i class="fold fa fa-minus-circle" style="display:none"></i></td>\n')
	elif re.match(r'(IBT|ibt)-[0-9]+(-[0-9]+)?$',id):
		f.write('<tr data-seq="{0}" data-pint_id="{1}" data-level="{2}" data-card="{3}" data-path="{4}">'.format(
			data['SemSort'],data['PINT_ID'],data['Level'],data['Card'],data['XPath']
		))
		f.write('<td>&nbsp;</td>\n')
	else:
		return
	f.write('<td>'+id+'</td>\n')
	try:
		level = '&bullet;&nbsp;'*int(data['Level'])
	except TypeError as e:
		level = ''
	if 'ibg-00' == id:
		item_dir = '#'
	else:
		item_dir = APP_BASE+'semantic/'+MESSAGE+'/'+id+'/'+lang+'/'
	f.write('<td class="info-link">'+level+'<a href="'+item_dir+'">'+data['BT']+'<br>'+data['BT_ja']+'</a></td>\n')
	f.write('<td><span>'+data['Card']+'</span></td>\n')
	if data['Desc']:
		desc = '\t\t<p><em>'+('<br />'.join(data['Desc'].split('\\n')))+'</em></p>\n'
	else:
		desc = ''
	f.write('<td>\n'+desc)
	f.write('</td>\n')
	f.write('</tr>\n')

# def writeTr_ja(f,data):
# 	lang = 'ja'
# 	tabs = '\t\t\t\t\t\t'
# 	id = data['PINT_ID']
# 	ID = id.upper()
# 	if re.match(r'(IBG|ibg)-[0-9]+(-[0-9]+)?$',id):
# 		f.write('<tr class="group"'+ \
# 										' data-seq="'+data['SemSort']+'"'+ \
# 										' data-en_id="'+data['EN_ID']+'"'+ \
# 										' data-pint_id="'+data['PINT_ID']+'"'+ \
# 										' data-level="'+data['Level']+'"'+ \
# 										' data-card="'+data['Card']+'"'+ \
# 										' data-path="'+data['XPath']+'">\n')
# 		f.write('<td class="expand-control" align="center"><i class="expand fa fa-plus-circle"></i>'+ 
# 										'<i class="fold fa fa-minus-circle" style="display:none"></i></td>\n')
# 	elif re.match(r'(IBT|ibt)-[0-9]+(-[0-9]+)?$',id):
# 		f.write('<tr'+ \
# 										' data-seq="'+data['SemSort']+'"'+ \
# 										' data-en_id="'+data['EN_ID']+'"'+ \
# 										' data-pint_id="'+data['PINT_ID']+'"'+ \
# 										' data-level="'+data['Level']+'"'+ \
# 										' data-card="'+data['Card']+'"'+ \
# 										' data-path="'+data['XPath']+'">\n')
# 		f.write('<td>&nbsp;</td>')
# 	else:
# 		return
# 	f.write('<td>'+id+'</td>\n')
# 	try:
# 		level = '&bullet;&nbsp;'*int(data['Level'])
# 	except TypeError as e:
# 		level = ''
# 	item_dir0 = semantic_root+id+'/'+lang

# 	os.makedirs(item_dir0,exist_ok=True)

# 	item_dir = APP_BASE+'semantic/'+MESSAGE+'/'+id+'/'+lang+'/'
# 	f.write('<td class="info-link">'+level+'<a href="'+item_dir+'">'+data['BT_ja']+'</a></td>\n')
# 	f.write('<td><span>'+data['Card']+'</span></td>\n')
# 	if data['Desc_ja']:
# 		desc = '\t\t<p><em>'+('<br />'.join(data['Desc_ja'].split('\\n')))+'</em></p>\n'
# 	else:
# 		desc = ''
# 	f.write('<td>\n'+desc)
# 	f.write('</td>\n')
# 	f.write('</tr>\n')

def writeBreadcrumb(f,num,lang):
	nums = num.split(' ')
	# home_dir = APP_BASE
	tabs = '\t\t\t'
	f.write('<ol class="breadcrumb pt-1 pb-1">')
	if 'ja' == lang:
		home_str = HOME_ja
		name = SEMANTICS_MESSAGE_TITLE_ja
	else:
		home_str = HOME_en
		name = SEMANTICS_MESSAGE_TITLE_en	
	f.write('<li class="breadcrumb-item"><a href="'+OP_BASE+'">'+home_str+'</a></li>')
	f.write('<li class="breadcrumb-item"><a href="'+APP_BASE+'semantic/'+MESSAGE+'/tree/'+lang+'/">'+name+'</a></li>')
	for id in nums:
		item_dir = APP_BASE+'semantic/'+MESSAGE+'/'+id+'/'+lang+'/'
		if 'ja' == lang:
			name = [x['BT_ja'] for x in pint_list if id==x['PINT_ID']][0]
		else:
			name = [x['BT'] for x in pint_list if id==x['PINT_ID']][0]
		if not id in nums[-1:]:
			f.write('<li class="breadcrumb-item"><a href="'+item_dir+'/">'+name+'</a></li>')
		else:
			f.write('<li class="breadcrumb-item active">'+name+'</li>')
	f.write('</ol>')

if __name__ == '__main__':
	# Create the parser
	parser = argparse.ArgumentParser(prog='jp-pint_semantics.py',
																	usage='%(prog)s [options] infile',
																	description='CSVファイルからJP-PINTのHTMLファイルを作成')
	# Add the arguments
	parser.add_argument('inFile',metavar='infile',type=str,help='入力CSVファイル')
	parser.add_argument('-v','--verbose',action='store_true')

	args = parser.parse_args()
	in_file = file_path(args.inFile)

	dir = os.path.dirname(in_file)

	semantic_root = 'billing-japan/semantic/'+MESSAGE+'/'
	semantic_en_html = semantic_root+'tree/en/index.html'
	# semantic_ja_html = semantic_root+'tree/ja/index.html'

	verbose = args.verbose
	# Check if infile exists
	if not os.path.isfile(in_file):
		print('入力ファイルがありません')
		sys.exit()
	if verbose:
		print('** START ** ',__file__)

	# Read CSV file
	csv_list = semantic_read_CSV_file(in_file)
	pint_list = [x for x in csv_list if ''!=x['SemSort'] and ''!=x['PINT_ID']]
	pint_list = sorted(pint_list,key=lambda x: x['SemSort'])

	# PINT rules
	result = basic_rule('data/Rules_Basic.json')
	Basic_Dict = result['dict']
	Basic_test = result['test']
	Basic_binding = result['binding']
	Shared_rule = shared_rule('data/Rules_Shared.json')
	Aligned_rule = aligned_rule('data/Rules_Aligned.json')

	rules = {}
	idxLevel = ['']*8
	for data in pint_list:
		level = data['Level']
		if level:
			try:
				level = int(level)
			except TypeError as e:
				continue
			pint_id = data['PINT_ID']
			num = pint_id
			if level > 0:
				num = idxLevel[level - 1]+' '+num
			idxLevel[level] = num
			data['num'] = num

	if verbose:
		print(' -- write index table --')

	children = {}
	with open(semantic_en_html,'w',encoding='utf-8',buffering=1,errors='xmlcharrefreplace',newline='') as f:
		lang = 'en'
		f.write(html_head.format(lang,APP_BASE))

		html = navbar_html.format(SPEC_TITLE_en,'selected','',HOME_en,SEMANTICS_MESSAGE_TITLE_en,
															'Legend',legend_en,'Shows a modal window of legend information.',
															dropdown_menu_en,searchLegend_en,'modal-lg',warning_en,OP_BASE,'',
															NOT_SUPPORTED_en,'Return to previous page.','Search')
		f.write(html)

		f.write(table_html.format('ID','Business Term','Card','Description','10','30','7'))
		for data in pint_list:
			id = data['PINT_ID']
			if re.match(r'^ib[tg]-[0-9]+(-[0-9]+)?$',id):

				writeTr(f,data,lang)

			if re.match(r'^ib[tg]-[0-9]+-[0-9]+$',id):
				m = re.search(r'^ib[tg]-[0-9]*.+',id)
				if m:
					child_id = m.group()
					_id = child_id[:7]
					if not _id in children:
						children[_id] = set()
					children[_id].add(json.dumps(data))
		f.write(trailer.format('Go to top'))

		f.write('</div>')
		f.write(javascript_html)
		f.write('</body></html>')

	if verbose:
		print(' -- write each business term --')

	for data in pint_list:
		if not data or not data['PINT_ID']:
			continue
		lang = 'en'
		id = data['PINT_ID']
		if re.match(r'^ib[tg]-[0-9]+(-[0-9]+)?$',id):
			item_dir0 = semantic_root+id+'/'+lang

			os.makedirs(item_dir0,exist_ok=True)

			with open(item_dir0+'/index.html','w',encoding='utf-8',buffering=1,errors='xmlcharrefreplace',newline='') as f:
				f.write(item_head.format(lang,APP_BASE))
				f.write('</head><body>')
				ID = id.upper()
				# name = id+'&nbsp;'+data['BT']
				BT = data['BT']
				BT_ja = data['BT_ja']
				Desc = '<br />'.join(data['Desc'].split('\\n'))
				f.write('<header class="sticky-top bg-white px-0 py-2">')
				# 0.SPEC_TITLE_en 1.APP_BASE 2.lang 3.dropdown_menu 4.tooltipText 5.warning
				f.write(item_navbar.format(SPEC_TITLE_en,OP_BASE,'',dropdown_menu_en,'Show Legend',warning_en))
				f.write('<div class="item-semantics">\n')
				writeBreadcrumb(f,data['num'],lang)
				f.write('</header>')

				DT = data['DT']
				Section = blank2fa_minus(data['Section'])
				Card = blank2fa_minus(data['Card'])
				if 'Path' in data:
					Path = data['Path']
					xpath = data['XPath']
					if len(Path) > 0 and re.match(r'^\/Invoice',Path):
						_path = Path[9:].replace(':','-')
						if '' == _path:
							Path = '<a href="'+APP_BASE+'syntax/ubl-'+MESSAGE+'/'+lang+'/"><h5>'+xpath+'</h5></a>'
						else:
						# elif not '@' in _path:
							Path = '<a href="'+APP_BASE+'syntax/ubl-'+MESSAGE+'/'+_path+'/'+lang+'/"><h5>'+xpath+'</h5></a>'
						# else:
						# 	m = re.match(r'^.*(\/@.*)$',xpath)
						# 	if m:
						# 		attr = m.groups()[0]
						# 		_path = _path[:-(len(attr))]
						# 		Path = '<a href="'+APP_BASE+'syntax/ubl-'+MESSAGE+'/'+_path+'/'+lang+'/"><h5>'+xpath+'</h5></a>'
						# 	else: Path = '<h5>'+xpath+'</h5>'
					else:
						Path = '<i class="fa fa-minus" aria-hidden="true"></i>'
				else:
					Path = '<i class="fa fa-minus" aria-hidden="true"></i>'
				if 'selectors' in data:
					selectors = data['selectors']
				else: selectors = ''
				Selectors = blank2fa_minus(selectors)
				if 'Datatype' in data:
					datatype = data['Datatype']
				else: datatype = ''
				UBLdatatype = blank2fa_minus(datatype)
				if 'Occ' in data:
					occ = data['Occ']
				else: occ = ''
				Occ = blank2fa_minus(occ)
				if 'Definition' in data:
					definition = data['Definition']
				else:
					definition = ''
				Definition = blank2fa_minus(definition)
				# Rules = blank2fa_minus(checkRules(data,lang))
				# Explanation = '<br />'.join(data['Exp'].split('\\n'))
				# if len(Explanation) > 0:
				# 	pass
				# else:
				# 	Explanation = '<i class="fa fa-minus" aria-hidden="true"></i>'
				# html = item_data.format('Semantic datatype',DT,'Cardinality',Card,'Section',Section,
				# 												'Syntax binding XPath',Path,'Selectors',Selectors,
				# 												'UBL datatype',UBLdatatype,'UBL cardinality',Occ,
				# 												'UBL definition',Definition
				# 												)
				# f.write(item_header.format(name,Desc))

				html = '<div class="container">'
				html += item_info_modal.format('Legend',info_item_modal_en,'modal-lg')
				html += f'<div class="page-header"><h1>{BT}</h1></div>'
				html += f'<div class="page-header"><h3>{BT_ja}</h3></div>'
				html += f'<p class="lead">{Desc}</p>'
				f.write(html)

				html = '<hr>'
				html += '<h4>About</h4>'
				html += '<dl class="row">'
				html += f'<dt class="col-md-2">ID</dt><dd class="col-md-10 mb-3">{id}</dd>'
				html += f'<dt class="col-md-2">Semantic datatype</dt><dd class="col-md-10 mb-3">{DT}</dd>'
				html += f'<dt class="col-md-2">Cardinality</dt><dd class="col-md-10 mb-3">{Card}</dd>'
				html += f'<dt class="col-md-2">Section</dt><dd class="col-md-10 mb-3">{Section}</dd>'
				html += '</dl>'
				f.write(html)
				html = '<hr>'
				html += '<h4>Syntax binding</h4>'
				html += '<dl class="row">'
				html += f'<dt class="col-md-2">XPath</dt><dd class="col-md-10 mb-3">{Path}</dd>'
				html += f'<dt class="col-md-2">Selectors</dt><dd class="col-md-10 mb-3">{Selectors}</dd>'
				html += f'<dt class="col-md-2">Datatype(UBL)</dt><dd class="col-md-10 mb-3">{UBLdatatype}</dd>'
				html += f'<dt class="col-md-2">Cardinality(UBL)</dt><dd class="col-md-10 mb-3">{Occ}</dd>'
				html += f'<dt class="col-md-2">Definition(UBL)</dt><dd class="col-md-10 mb-3">{Definition}</dd>'
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
							html += f'<dt class="col-md-2">{rule}({Basic_Dict[rule]["Flag"]})</dt><dd class="col-md-10 mb-3">{Basic_Dict[rule]["Message"]}</dd>'
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
								html += f'<dt class="col-md-2">{rule_id}({rule["Flag"]})</dt><dd class="col-md-10 mb-3">{message}</dd>'
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
								html += f'<dt class="col-md-2">{rule_id}({rule["Flag"]})</dt><dd class="col-md-10 mb-3">{message}</dd>'
						html += '</dl>'
						f.write(html)

				if re.match(r'^(IBG|ibg)-[0-9]+$',ID):
					html = ''
					for child in [x for x in pint_list]:
						if re.match(r'^'+data['num']+' ib[gt]-[\-0-9]+$',child['num']):
							html += setupTr(child,lang)
					if html:
						# f.write(childelements_dt.format('Child elements'))
						f.write('<hr>')
						f.write('<h4>Child element(s)</h4>')
						f.write(table_html.format('ID','Business Term','Card','Description','10','30','7'))
						f.write(html)
						f.write(table_trailer)
				else:
					if id in children:
						# f.write(childelements_dt.format('Child elements'))
						f.write('<hr>')
						f.write('<h4>Child element(s)</h4>')
						f.write(table_html.format('ID','Business Term','Card','Description','10','30','7'))
						html = ''
						for child in children[id]:
							data = json.loads(child)
							html += setupTr(data,lang)
						f.write(html)
						f.write(table_trailer)
				f.write(item_trailer.format('Go to top'))

				f.write(javascript_html)
				f.write('</body></html>')

	if verbose:
		print(f'** END ** {semantic_en_html}')
		# print(f'** END ** {semantic_en_html} {semantic_ja_html}')