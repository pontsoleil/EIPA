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
import collections
from collections import OrderedDict
import re
import json
import sys 
import os
import argparse

import jp_pint_constants
from jp_pint_constants import APP_BASE

APP_BASE = jp_pint_constants.APP_BASE
SEMANTIC_BASE = jp_pint_constants.SEMANTIC_BASE
SYNTAX_BASE = jp_pint_constants.SYNTAX_BASE
RULES_BASE = jp_pint_constants.RULES_BASE
RULES_UBL_JAPAN_BASE = jp_pint_constants.RULES_UBL_JAPAN_BASE
RULES_UBL_PINT_BASE = jp_pint_constants.RULES_UBL_PINT_BASE
RULES_EN_PEPPOL = jp_pint_constants.RULES_EN_PEPPOL
RULES_EN_CEN = jp_pint_constants.RULES_EN_CEN

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
            <dt class="col-3"><strong>Cardinality</strong></dt>
            <dd class="col-9">
              Also known as multiplicity is used to indicate if an information element (or group of information elements) is mandatory or conditional, and if it is repeatable. The cardinality shall always be analysed in the context of where the information element is used. Example: the payee Name is mandatory in the core invoice model, but only when a payee is stated and is relevant.<br />
              The following cardinalities exist:<br />
              ー 1..1: Mandatory, minimum 1 occurence and maximum 1 occurrence of the information element (or group of the information elements) shall be present in any compliant instance document;<br />
              ー 1..n: Mandatory and repeatable, minimum 1 occurrence and unbounded upper maximum occurrences of the information element (or group of information elements) shall be present in any compliant instance document;<br />
              ー 0..1: Conditional,minimum 0 occurence and maximum 1 occurrence of the information element (or group of the information elements) may be present in any compliant instance document; it's use depends on business rules stated as well as the regulatory, commercial and contractual conditions that applies to the business transaction;<br />
              ー 0..n: Conditional,minimum 0 occurence and unboounded upper maximum occurrence of the information element (or group of the information elements) may be present in any compliant instance document; it's use depends on business rules stated as well as the regulatory, commercial and contractual conditions that applies to the business transaction;</p>
            </dd>
            <dt class="col-3"><strong>Business Term</strong></dt>
            <dd class="col-9">
              The name of the information element used in the core invoice model or the name of a coherent group of related information elements, provided to give logical meaning.</p>
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
              コア請求書モデルで使用される情報要素の名前、または、関連する情報要素のまとめたグループの名前。論理的な意味を与えるために提供される。
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
						<col span="1" style="width: {3};">
						<col span="1" style="width: 9%;">
						<col span="1" style="width: {4};">
						<col span="1" style="width: 6%;">
						<col span="1" style="width: 60%;">
					</colgroup>
					<thead>
						<th>-</th>
						<th>ID</th>
						<th>{0}</th>
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
          <dl class="row">
            <dt class="col-3"><strong>Data type</strong></dt>
            <dd class="col-9">
							<a href="https://docs.peppol.eu/poacc/billing/3.0/bis/#_semantic_datatypes">Semantic datatypes</a><br />
							Semantic data types are used to bridge the gap between the semantic concepts expressed by the information elements defined in the semantic model from EN 16931 and the technical implementation. The semantic data types define the allowed value domain for the content, and any additional information components (attributes) needed in order to ensure its precise interpretation.
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
            <dt class="col-3"><strong>XML Attribute</strong></dt>
            <dd class="col-9">
							Specific requirements on XML attribute for this data element.
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
            <dt class="col-3"><strong>データ型</strong></dt>
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
            <dt class="col-3"><strong>XML属性</strong></dt>
            <dd class="col-9">
							この要素に関連するXML属性の使用条件
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
item_navbar = jp_pint_constants.item_navbar
item_header = jp_pint_constants.item_header
# 'DT','Section','Extension','Path','Attr','Rules','Explanation'
item_data = '''
				<dt class="col-3">{0}</dt><dd class="col-9">{1}</dd>
				<dt class="col-3">{2}</dt><dd class="col-9">{3}</dd>
				<dt class="col-3">{4}</dt><dd class="col-9">{5}</dd>
				<dt class="col-3">{6}</dt><dd class="col-9">{7}</dd>
				<dt class="col-3">{8}</dt><dd class="col-9">{9}</dd>
				<dt class="col-3">{10}</dt><dd class="col-9">{11}</dd>
				<dt class="col-3">{12}</dt><dd class="col-9">{13}</dd>
				<dt class="col-3">{14}</dt><dd class="col-9">{15}</dd>
'''
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
		<dt class="col-3">{0}</dt>
		<dd class="col-9">
			<div class="table-responsive semantics">
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

def blank2fa_minus(str):
	if str:
		return str
	return '<i class="fa fa-minus" aria-hidden="true"></i>'

def setupTr(data,lang):
	id = data['PINT_ID']
	ID = id.upper()
	html = ''
	if re.match(r'^ibg-[0-9]*$',id):
		html += '<tr class="group"'+ \
						' data-seq="'+data['SemSort']+'"'+ \
						' data-en_id="'+data['EN_ID']+'"'+ \
						' data-pint_id="'+data['PINT_ID']+'"'+ \
						' data-level="'+data['Level']+'"'+ \
						' data-card="'+data['Card']+'"'+ \
						' data-path="'+data['Path']+'">'
		html += '<td class="expand-control" align="center"></td>'
	elif re.match(r'^ibt-[0-9a-z\-]*$',id):
		html += '<tr'+ \
						' data-seq="'+data['SemSort']+'"'+ \
						' data-en_id="'+data['EN_ID']+'"'+ \
						' data-pint_id="'+data['PINT_ID']+'"'+ \
						' data-level="'+data['Level']+'"'+ \
						' data-card="'+data['Card']+'"'+ \
						' data-path="'+data['Path']+'">'
		html += '<td>&nbsp;</td>'
	else:
		return html
	html += '<td>'+id+'</td>'
	level = ''
	if re.match(r'^ib[tg]-[0-9]*$',id):
		item_dir = APP_BASE+'semantic/invoice/'+id+'/'+lang+'/'
		if 'ja' == lang:
			html += '<td class="info-link">'+level+'<a href="'+item_dir+'">'+data['BT_ja']+'</a></td>'
		else:
			html += '<td class="info-link">'+level+'<a href="'+item_dir+'">'+data['BT']+'</a></td>'
	else:
		if 'ja' == lang:
			html += '<td><span>'+level+data['BT_ja']+'</span></td>'
		else:
			html += '<td><span>'+level+data['BT']+'</span></td>'
	html += '<td><span>'+data['Card']+'</span></td>'
	desc = ''
	if 'ja' == lang:
		if data['Desc_ja']:
			desc = '<p>'+('<br />'.join(data['Desc_ja'].split('\\n')))+'</p>'
	else:
		if data['Desc']:
			desc = '<p>'+('<br />'.join(data['Desc'].split('\\n')))+'</p>'
	html += '<td>'+desc
	if data['Example']:
		example = '例: <code>'+data['Example']+'</code>'
	else:
		example = ''
	html += example+'</td></html>'
	return html

def writeTr_en(f,data):
	lang = 'en'
	tabs = '\t\t\t\t\t\t'
	id = data['PINT_ID']
	ID = id.upper()
	if re.match(r'^ibg-[0-9]*$',id):
		f.write(tabs+'<tr class="group"'+ \
										' data-seq="'+data['SemSort']+'"'+ \
										' data-en_id="'+data['EN_ID']+'"'+ \
										' data-pint_id="'+data['PINT_ID']+'"'+ \
										' data-level="'+data['Level']+'"'+ \
										' data-card="'+data['Card']+'"'+ \
										' data-path="'+data['Path']+'">\n')
		f.write(tabs+'\t<td class="expand-control" align="center"><i class="expand fa fa-plus-circle"></i>'+ 
										'<i class="fold fa fa-minus-circle" style="display:none"></i></td>\n')
	elif re.match(r'^ibt-[0-9a-z]*$',id):
		f.write(tabs+'<tr'+ \
										' data-seq="'+data['SemSort']+'"'+ \
										' data-en_id="'+data['EN_ID']+'"'+ \
										' data-pint_id="'+data['PINT_ID']+'"'+ \
										' data-level="'+data['Level']+'"'+ \
										' data-card="'+data['Card']+'"'+ \
										' data-path="'+data['Path']+'">\n')
		f.write(tabs+'\t<td>&nbsp;</td>\n')
	else:
		return
	f.write(tabs+'\t<td>'+id+'</td>\n')
	try:
		level = '&bullet;&nbsp;'*int(data['Level'])
	except TypeError as e:
		level = ''
	item_dir = APP_BASE+'semantic/invoice/'+id+'/'+lang+'/'
	f.write(tabs+'\t<td class="info-link">'+level+'<a href="'+item_dir+'">'+data['BT']+'</a></td>\n')
	f.write(tabs+'\t<td><span>'+data['Card']+'</span></td>\n')
	if data['Desc']:
		desc = tabs+'\t\t<p><em>'+('<br />'.join(data['Desc'].split('\\n')))+'</em></p>\n'
	else:
		desc = ''
	f.write(tabs+'\t<td>\n'+desc)
	if data['Example']:
		example = tabs+'\t\t<p>Example value: <code>'+data['Example']+'</code></p>\n'
	else:
		example = ''
	f.write(example+'\n'+tabs+'\t</td>\n')
	f.write(tabs+'</tr>\n')

def writeTr_ja(f,data):
	lang = 'ja'
	tabs = '\t\t\t\t\t\t'
	id = data['PINT_ID']
	ID = id.upper()
	if re.match(r'^ibg-[0-9]*$',id):
		f.write(tabs+'<tr class="group"'+ \
										' data-seq="'+data['SemSort']+'"'+ \
										' data-en_id="'+data['EN_ID']+'"'+ \
										' data-pint_id="'+data['PINT_ID']+'"'+ \
										' data-level="'+data['Level']+'"'+ \
										' data-card="'+data['Card']+'"'+ \
										' data-path="'+data['Path']+'">\n')
		f.write(tabs+'\t<td class="expand-control" align="center"><i class="expand fa fa-plus-circle"></i>'+ 
										'<i class="fold fa fa-minus-circle" style="display:none"></i></td>\n')
	elif re.match(r'^ibt-[0-9a-z]*$',id):
		f.write(tabs+'<tr'+ \
										' data-seq="'+data['SemSort']+'"'+ \
										' data-en_id="'+data['EN_ID']+'"'+ \
										' data-pint_id="'+data['PINT_ID']+'"'+ \
										' data-level="'+data['Level']+'"'+ \
										' data-card="'+data['Card']+'"'+ \
										' data-path="'+data['Path']+'">\n')
		f.write(tabs+'\t<td>&nbsp;</td>')
	else:
		return
	f.write(tabs+'\t<td>'+id+'</td>\n')
	try:
		level = '&bullet;&nbsp;'*int(data['Level'])
	except TypeError as e:
		level = ''
	item_dir0 = 'billing-japan/semantic/invoice/'+id+'/'+lang

	os.makedirs(item_dir0,exist_ok=True)

	item_dir = APP_BASE+'semantic/invoice/'+id+'/'+lang+'/'
	f.write(tabs+'\t<td class="info-link">'+level+'<a href="'+item_dir+'">'+data['BT_ja']+'</a></td>\n')
	f.write(tabs+'\t<td><span>'+data['Card']+'</span></td>\n')
	if data['Desc_ja']:
		desc = tabs+'\t\t<p><em>'+('<br />'.join(data['Desc_ja'].split('\\n')))+'</em></p>\n'
	else:
		desc = ''
	f.write(tabs+'\t<td>\n'+desc)
	if data['Example']:
		example = tabs+'\t\t例: <code>'+data['Example']+'</code>'
	else:
		example = ''
	f.write(example+'\n'+tabs+'\t</td>\n')
	f.write(tabs+'</tr>\n')

def writeBreadcrumb(f,num,lang):
	nums = num.split(' ')
	home_dir = APP_BASE
	tabs = '\t\t\t'
	f.write(tabs+'<ol class="breadcrumb pt-1 pb-1">')
	if 'ja' == lang:
		home_str = HOME_ja
		name = SEMANTICS_MESSAGE_TITLE_ja
	else:
		home_str = HOME_en
		name = SEMANTICS_MESSAGE_TITLE_en	
	f.write(tabs+'\t<li class="breadcrumb-item"><a href="'+home_dir+lang+'/">'+home_str+'</a></li>')
	f.write(tabs+'\t<li class="breadcrumb-item"><a href="'+SEMANTIC_BASE+'tree/'+lang+'/">'+name+'</a></li>')
	for id in nums:
		item_dir = SEMANTIC_BASE+id+'/'
		if 'ja' == lang:
			name = [x['BT_ja'] for x in pint_list if id==x['PINT_ID']][0]
		else:
			name = [x['BT'] for x in pint_list if id==x['PINT_ID']][0]
		if not id in nums[-1:]:
			f.write(tabs+'\t<li class="breadcrumb-item"><a href="'+item_dir+lang+'/">'+name+'</a></li>')
		else:
			f.write(tabs+'\t<li class="breadcrumb-item active">'+name+'</li>')
	f.write(tabs+'</ol>')

def checkRules(data, lang):
	id = data['PINT_ID']
	if not id:
		return ''
	Rules = data['Rules']
	if Rules:
		Rules = Rules.split(',')
	Rs = ''
	# diff0 = []
	for r in Rules:
		if r in rule_dict:
			if r in schematron_dict:
				if 'ja' == lang:
					message = rule_dict[r]['Message_ja']
				else:
					message = rule_dict[r]['Message']
				schematron = schematron_dict[r]
				# context = schematron['context']
				flag = schematron['flag']
				# test = schematron['test']
				if re.match(r'^jp-',r):
					R = '<a href="'+RULES_UBL_JAPAN_BASE+r+'/'+lang+'/">'+r+'</a>'
				else:
					R = '<a href="'+RULES_UBL_PINT_BASE+r+'/'+lang+'/">'+r+'</a>'
				Rs += '<h5>'+R+' ('+flag+')</h5>'+message+'<br />'
				# Rs += '<dl class="row">'
				# if 'ja' == lang:
				# 	Rs += '<dt class="col-3">対象(context)</dt><dd class="col-9"><code>'+context+'</code></dd>'+ \
				# 				'<dt class="col-3">検証(test)</dt><dd class="col-9"><code>'+test+'</code></dd>'
				# else:
				# 	Rs += '<dt class="col-3">cotext</dt><dd class="col-9"><code>'+context+'</code></dd>'+ \
				# 				'<dt class="col-3">test</dt><dd class="col-9"><code>'+test+'</code></dd>'
				# Rs += '</dl>'
			else:
				if 'ja' == lang:
					message = rule_dict[r]['Message_ja']
				else:
					message = rule_dict[r]['Message']
				Rs += '<h5>'+r+'</h5>'+message+'<br />'
				# Rs += '<span class="text-danger"><b>'
				# if 'ja' == lang:
				# 	Rs += 'スキーマトロンで未定義'
				# else:
				# 	Rs += 'This rule is not defined in the schematron file.'
				# Rs += '</b></span><br />'
		# else:
		# 	diff0.append(r)
	# rules_ = rules[id]
	# if rules_:
	# 	rules_ = list(rules_)
	# diff1 = list(set(rules_) - set(Rules))
	# diff2 = list(set(Rules) - set(rules_) - set(diff0))
	# if len(diff0) > 0:
	# 	Rs += '<span class="text-danger"><b>'
	# 	if 'ja' == lang:
	# 		Rs += 'スキーマトロンで未定義'
	# 	else:
	# 		Rs += 'This rule is not defined in the schematron file.'
	# 	Rs += '</b></span><br />'
	# 	for r in diff0:
	# 		if re.match(r'^jp-',r):
	# 			R = '<a href="'+RULES_UBL_JAPAN_BASE+r+'/'+lang+'/">'+r+'</a>'
	# 		else:
	# 			R = '<a href="'+RULES_UBL_PINT_BASE+r+'/'+lang+'/">'+r+'</a>'
	# 		Rs += R+' '
	# 	Rs += '<br />'
	# if len(diff1) > 0:
	# 	Rs += '<span class="text-danger"><b>'
	# 	if 'ja' == lang:
	# 		Rs += 'PINTモデルで未定義'
	# 	else:
	# 		Rs += 'This rule is not defined in the PINT model.'
	# 	Rs += '</b></span><br />'
	# 	for r in diff1:
	# 		if re.match(r'^jp-',r):
	# 			R = '<a href="'+RULES_UBL_JAPAN_BASE+r+'/'+lang+'/">'+r+'</a>'
	# 		else:
	# 			R = '<a href="'+RULES_UBL_PINT_BASE+r+'/'+lang+'/">'+r+'</a>'
	# 		Rs += R+' '
	# 	Rs += '<br />'
	# if len(diff2) > 0:
	# 	Rs += '<span class="text-danger"><b>'
	# 	if 'ja' == lang:
	# 		Rs += data['PINT_ID']+'は、PINTルールで未言及'
	# 	else:
	# 		Rs += data['PINT_ID']+' is not mentioned in the rule.'
	# 	Rs += '</b></span><br />'
	# 	for r in diff2:
	# 		if re.match(r'^jp-',r):
	# 			R = '<a href="'+RULES_UBL_JAPAN_BASE+r+'/'+lang+'/">'+r+'</a>'
	# 		else:
	# 			R = '<a href="'+RULES_UBL_PINT_BASE+r+'/'+lang+'/">'+r+'</a>'
	# 		Rs += R+' '
	# 	Rs += '<br />'
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
				# context = rule['context']
				flag = rule['flag']
				# test = rule['test']
				if re.match(r'^(BR|UBL)-',r):
					R = '<a href="'+RULES_EN_CEN+r+'/'+lang+'/">'+r+'</a>'
				else:
					R = '<a href="'+RULES_EN_PEPPOL+r+'/'+lang+'/">'+r+'</a>'
				Rs += '<h5>'+R+' ('+flag+')</h5>'+message+'<br />'
				# Rs += '<dl class="row">'
				# if 'ja' == lang:
				# 	Rs += '<dt class="col-3">対象(context)</dt><dd class="col-9"><code>'+context+'</code></dd>'+ \
				# 				'<dt class="col-3">検証(test)</dt><dd class="col-9"><code>'+test+'</code></dd>'
				# else:
				# 	Rs += '<dt class="col-3">cotext</dt><dd class="col-9"><code>'+context+'</code></dd>'+ \
				# 				'<dt class="col-3">test</dt><dd class="col-9"><code>'+test+'</code></dd>'
				# Rs += '</dl>'
	return Rs

if __name__ == '__main__':
	# Create the parser
	parser = argparse.ArgumentParser(prog='jp-pint_semantics.py',
																	usage='%(prog)s [options] infile pint_rulefile jp_rulefile schematronfile ppeppol_rulefile cen_rulefile',
																	description='CSVファイルからJP-PINTのHTMLファイルを作成')
	# Add the arguments
	parser.add_argument('inFile',metavar='infile',type=str,help='入力CSVファイル')
	parser.add_argument('pint_ruleFile',metavar='pint_rulefile',type=str,help='PINTルールCSVファイル')
	parser.add_argument('jp_ruleFile',metavar='jp_rulefile',type=str,help='JPルールCSVファイル')
	parser.add_argument('schematronFile',metavar='schematronfile',type=str,help='スキーマトロンCSVファイル')
	parser.add_argument('peppol_ruleFile',metavar='peppol_rulefile',type=str,help='PEPPOLルールCSVファイル')
	parser.add_argument('cen_ruleFile',metavar='cen_rulefile',type=str,help='CENルールCSVファイル')

	parser.add_argument('-v','--verbose',action='store_true')

	args = parser.parse_args()
	in_file = file_path(args.inFile)
	pint_rule_file = file_path(args.pint_ruleFile)
	jp_rule_file = file_path(args.jp_ruleFile)
	schematron_file = file_path(args.schematronFile)
	peppol_rule_file = file_path(args.peppol_ruleFile)
	cen_rule_file = file_path(args.cen_ruleFile)

	dir = os.path.dirname(in_file)

	semantic_en_html = 'billing-japan/semantic/invoice/tree/en/index.html'
	semantic_ja_html = 'billing-japan/semantic/invoice/tree/ja/index.html'

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

	rule_dict = {}
	rule_keys = ('ID','Flag','Message','Message_ja')
	# Read PINT Rule CSV file
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
	csv_list = []
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
		header = next(reader)
		for row in reader:
			csv_list.append(row)

	pint_list = [x for x in csv_list if ''!=x['SemSort'] and ''!=x['PINT_ID']]
	pint_list = sorted(pint_list,key=lambda x: x['SemSort'])

	# PINT rules
	rules = {}
	idxLevel = ['']*6
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
			rules[pint_id] = set()
			for k,v in rule_dict.items():
				pint_ids = v['PINT_IDs']
				if pint_ids:
					pint_ids = pint_ids.split(' ')
					if pint_id in pint_ids:
						rules[pint_id].add(k)

	# BIS rules
	BISrules = {}
	BISrule_dict = {}
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

	children = {}
	with open(semantic_en_html,'w',encoding='utf-8',buffering=1,errors='xmlcharrefreplace',newline='') as f:
		lang = 'en'
		f.write(html_head.format(lang,APP_BASE))
		f.write(javascript_html)
		# 0.SPEC_TITLE_en 1.'selected' 2.'' 3.HOME_en 4.SYNTAX_MESSAGE_TITLE_en 5.lang 6.APP_BASE 
		# 7.'Legend' 8.legend_en 9.'Shows a ...' 10.dropdown_menu_en 11.tooltipTextForSearch
		f.write(navbar_html.format(SPEC_TITLE_en,'selected','',HOME_en,SEMANTICS_MESSAGE_TITLE_en,lang, \
																APP_BASE,'Legend',legend_en,'Shows a modal window of legend information.', \
																dropdown_menu_en,'ID or word in Term/Description','modal-lg'))
		f.write(table_html.format('Business Term','Card','Description','3%','22%'))
		for data in pint_list:
			id = data['PINT_ID']
			if re.match(r'^ib[tg]-[0-9]*$',id):
				writeTr_en(f,data)
			else:
				m = re.search(r'^ib[tg]-[0-9]*.+',id)
				if m:
					child_id = m.group()
					_id = child_id[:7]
					if not _id in children:
						children[_id] = set()
					children[_id].add(json.dumps(data))
		f.write(trailer.format('Go to top'))

	for data in pint_list:
		if not data or not data['PINT_ID']:
			continue
		lang = 'en'
		id = data['PINT_ID']
		if re.match(r'^ib[tg]-[0-9]*$',id):
			item_dir0 = 'billing-japan/semantic/invoice/'+id+'/'+lang

			os.makedirs(item_dir0,exist_ok=True)

			with open(item_dir0+'/index.html','w',encoding='utf-8',buffering=1,errors='xmlcharrefreplace',newline='') as f:
				f.write(item_head.format(lang,APP_BASE))
				f.write(javascript_html)
				f.write('</head><body>')
				ID = id.upper()
				name = id+'&nbsp;'+data['BT']
				Desc = '<br />'.join(data['Desc'].split('\\n'))
				# 0.SPEC_TITLE_en 1.'selected' 2.'' 3.lang 4.APP_BASE 5.'Legend' 6.info_item_modal_en 7.dropdown_menu_en 8.tooltipText
				f.write(item_navbar.format(SPEC_TITLE_en,'selected','',lang,APP_BASE, \
																	'Legend',info_item_modal_en,dropdown_menu_en,'Show Legend','modal-lg'))

				writeBreadcrumb(f,data['num'],lang)

				f.write(item_header.format(name,Desc))
				DT = data['DT']
				if DT in datatypeDict:
					DT = datatypeDict[DT]
				elif DT:
					pass
				else:
					DT = '<i class="fa fa-minus" aria-hidden="true"></i>'
				Section = blank2fa_minus(data['Section'])
				Extension = blank2fa_minus(data['Extension'])
				Path = data['Path']
				if len(Path) > 0 and re.match(r'^\/Invoice',Path):
					_path = Path[9:].replace(':','-')
					if '' == _path:
						Path = '<a href="'+APP_BASE+'syntax/ubl-invoice/'+lang+'/">'+Path+'</a>'
					else:
						Path = '<a href="'+APP_BASE+'syntax/ubl-invoice/'+_path+'/'+lang+'/">'+Path+'</a>'
				else:
					Path = '<i class="fa fa-minus" aria-hidden="true"></i>'
				Attr = blank2fa_minus(data['Attr'])

				Rules = blank2fa_minus(checkRules(data,lang))
				BIS_Rules = blank2fa_minus(checkBIS_Rules(data,lang))

				Explanation = '<br />'.join(data['Exp'].split('\\n'))
				if len(Explanation) > 0:
					pass
				else:
					Explanation = '<i class="fa fa-minus" aria-hidden="true"></i>'
				f.write(item_data.format('Data type',DT,'Section',Section,'Extension',Extension,'XPath',Path,\
																	'XML Attribute',Attr, \
																	'Transaction Business Rules',Rules,'Rules for BIS 3.0 Billing (informative)',BIS_Rules, \
																	'Additional explanation',Explanation))
				if re.match(r'^IBG-[0-9]+$',ID):
					html = ''
					for child in [x for x in pint_list]:
						if re.match(r'^'+data['num']+' ib[gt]-[\-0-9]+$',child['num']):
							html += setupTr(child,lang)
					if html:
						f.write(childelements_dt.format('Child elements'))
						f.write(table_html.format('Business Term','Card','Description','0%','25%'))
						f.write(html)
						f.write(table_trailer)
				else:
					if id in children:
						f.write(childelements_dt.format('Child elements'))
						f.write(table_html.format('Business Term','Card','Description','0%','25%'))
						html = ''
						for child in children[id]:
							data = json.loads(child)
							html += setupTr(data,lang)
						f.write(html)
						f.write(table_trailer)

				f.write(item_trailer.format('Go to top'))

	with open(semantic_ja_html,'w',encoding='utf-8',buffering=1,errors='xmlcharrefreplace',newline='') as f:
		lang = 'ja'
		f.write(html_head.format(lang,APP_BASE))
		f.write(javascript_html)
		# 0.SPEC_TITLE_en 1.'selected' 2.'' 3.HOME_en 4.SYNTAX_MESSAGE_TITLE_en 5.lang 6.APP_BASE 
		# 7.'Legend' 8.legend_en 9.'Shows a ...' 10.dropdown_menu_ja 11.tooltipTextForSearch
		f.write(navbar_html.format(SPEC_TITLE_ja,'','selected',HOME_ja,SEMANTICS_MESSAGE_TITLE_ja,lang, \
																APP_BASE,'凡例',legend_ja,'凡例を説明するウィンドウを表示', \
																dropdown_menu_ja,'IDまたは用語/説明文が含む単語','modal-lg'))
		f.write(table_html.format('ビジネス用語','繰返','説明','3%','22%'))
		for data in pint_list:
			id = data['PINT_ID']
			if re.match(r'^ib[tg]-[0-9]*$',id):
				writeTr_ja(f,data)
		f.write(trailer.format('先頭に戻る'))

	for data in pint_list:
		if not data or not data['PINT_ID']:
			continue
		lang = 'ja'
		id = data['PINT_ID']
		if re.match(r'^ib[tg]-[0-9]*$',id):
			item_dir0 = 'billing-japan/semantic/invoice/'+id+'/'+lang

			os.makedirs(item_dir0,exist_ok=True)

			with open(item_dir0+'/index.html','w',encoding='utf-8',buffering=1,errors='xmlcharrefreplace',newline='') as f:
				f.write(item_head.format(lang,APP_BASE))
				f.write(javascript_html)
				ID = id.upper()
				name = id+'&nbsp;'+data['BT_ja']
				Desc = '<br />'.join(data['Desc_ja'].split('\\n'))
				# 0.SPEC_TITLE_en 1.'selected' 2.'' 3.lang 4.APP_BASE 5.'Legend' 6.info_item_modal_en 7.dropdown_menu_ja 8.tooltipText
				f.write(item_navbar.format(SPEC_TITLE_ja,'','selected',lang,APP_BASE, \
																	'凡例',info_item_modal_ja,dropdown_menu_ja,'凡例を表示','modal-lg'))

				writeBreadcrumb(f,data['num'],lang)

				f.write(item_header.format(name,Desc))
				DT = data['DT']
				if DT in datatypeDict:
					DT = datatypeDict[DT]
				elif DT:
					pass
				else:
					DT = '<i class="fa fa-minus" aria-hidden="true"></i>'
				Section = blank2fa_minus(data['Section'])
				Extension = blank2fa_minus(data['Extension'])
				Path = data['Path']
				if len(Path) > 0 and re.match(r'^\/Invoice',Path):
					_path = Path[9:].replace(':','-')
					if '' == _path:
						Path = '<a href="'+APP_BASE+'syntax/ubl-invoice/'+lang+'/">'+Path+'</a>'
					else:
						Path = '<a href="'+APP_BASE+'syntax/ubl-invoice/'+_path+'/'+lang+'/">'+Path+'</a>'
				else:
					Path = '<i class="fa fa-minus" aria-hidden="true"></i>'
				Attr = blank2fa_minus(data['Attr'])

				Rules = blank2fa_minus(checkRules(data,lang))
				BIS_Rules = blank2fa_minus(checkBIS_Rules(data,lang))

				Explanation = '<br />'.join(data['Exp_ja'].split('\\n'))
				if len(Explanation) > 0:
					pass
				else:
					Explanation = '<i class="fa fa-minus" aria-hidden="true"></i>'
				html = item_data.format('データ型',DT,'使用条件(Section)',Section,'欧州規格の拡張',Extension,'XPath',Path,\
																'XML属性',Attr, \
																'ビジネスルール',Rules,'（参考）BIS 3.0 Billing ルール',BIS_Rules, \
																'追加説明',Explanation)
				f.write(html)
				if re.match(r'^IBG-[0-9]+$',ID):
					html = ''
					for child in [x for x in pint_list]:
						if re.match(r'^'+data['num']+' ib[gt]-[\-0-9]+$',child['num']):
							html += setupTr(child,lang)
					if html:
						f.write(childelements_dt.format('下位要素'))
						f.write(table_html.format('ビジネス用語','繰返','説明','0%','25%'))
						f.write(html)
						f.write(table_trailer)
				else:
					if id in children and len(children[id]) > 0:
						f.write(childelements_dt.format('下位要素'))
						f.write(table_html.format('ビジネス用語','繰返','説明','0%','25%'))
						html = ''
						for child in children[id]:
							data = json.loads(child)
							html += setupTr(data,lang)
						f.write(html)
						f.write(table_trailer)

				f.write(item_trailer.format('先頭に戻る'))

	if verbose:
		print(f'** END ** {semantic_en_html} {semantic_ja_html}')