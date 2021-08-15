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
import html
import sys 
import os
import argparse
from datetime import datetime, timedelta, timezone
import hashlib

import jp_pint_xBRL_constants
from jp_pint_xBRL_constants import SCHEMA_HEAD
from jp_pint_xBRL_constants import DEFINITION_HEAD
from jp_pint_xBRL_constants import PRESENTATION_HEAD
from jp_pint_xBRL_constants import LABEL_HEAD
from jp_pint_xBRL_constants import REFERENCE_HEAD

JST = timezone(timedelta(hours=+9), 'JST')

namespace = {}
namespace['Invoice'] = 'urn:oasis:names:specification:ubl:schema:xsd:Invoice-2'
namespace['cac'] = 'urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2'
namespace['cbc'] = 'urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2'

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

# https://stackoverflow.com/questions/8347048/how-to-convert-string-to-title-case-in-python
def camelCase(st):
	st = st.replace("'","")
	output = ''.join(x for x in st.title() if x.isalnum())
	return output[0].lower() + output[1:]

if __name__ == '__main__':
	# Create the parser
	parser = argparse.ArgumentParser(prog='jp-pint_semantics.py',
																	usage='%(prog)s [options] infile',
																	description='CSVファイルからJP-PINTのxBRLタクソノミを作成')
	# Add the arguments
	parser.add_argument('inFile',metavar='infile',type=str,help='入力CSVファイル')
	parser.add_argument('-v','--verbose',action='store_true')

	args = parser.parse_args()
	in_file = file_path(args.inFile)

	dir = os.path.dirname(in_file)

	xbrl_schema = 'xBRL/taxonomy/pint-2021-12-31.xsd'
	definition_linkbase = 'xBRL/taxonomy/pint-2021-12-31-definition.xml'
	presentation_linkbase = 'xBRL/taxonomy/pint-2021-12-31-presentation.xml'
	label_linkbase = 'xBRL/taxonomy/pint-2021-12-31-label.xml'
	reference_linkbase = 'xBRL/taxonomy/pint-2021-12-31-reference.xml'

	verbose = args.verbose
	# Check if infile exists
	if not os.path.isfile(in_file):
		print('入力ファイルがありません')
		sys.exit()
	if verbose: print('** START ** ',__file__)

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
			BT = html.escape(row['BT'])
			row['BT'] = BT.strip()
			BT_ja = row['BT_ja']
			if BT_ja:
				row['BT_ja'] = html.escape(BT_ja)
			Desc = row['Desc']
			if Desc:
				row['Desc'] = html.escape(Desc)
			Desc_ja = row['Desc_ja']
			if Desc_ja:
				row['Desc_ja'] = html.escape(Desc_ja)
			Exp = row['Exp']
			if Exp:
				row['Exp'] = html.escape(Exp)
			Exp_ja = row['Exp_ja']
			if Exp_ja:
				row['Exp_ja'] = html.escape(Exp_ja)
			Example = row['Example']
			if Example:
				row['Example'] = html.escape(Example)
			csv_list.append(row)

	pint_list = [x for x in csv_list if ''!=x['SemSort'] and ''!=x['PINT_ID']]
	pint_list = sorted(pint_list,key=lambda x: x['SemSort'])

	with open(xbrl_schema,'w',encoding='utf-8',buffering=1,errors='xmlcharrefreplace',newline='') as f:
		xml = SCHEMA_HEAD.format(datetime.now(JST).isoformat(timespec='minutes'))
		f.write(xml)
		f.write('<!-- item type -->\n')
		template = '	<complexType name="{0}ItemType"><simpleContent><restriction base="{1}"/></simpleContent></complexType>\n'
		types = {}
		for data in pint_list:
			if not data or not data['PINT_ID']: continue
			id = data['PINT_ID']
			if re.match(r'^ib[tg]-[0-9]*$',id):
				BT = data['BT']
				if re.match(r'^ibt-[0-9]*$',id): BT = camelCase(BT)
				else: BT = BT.replace(' ','_')
				DT = data['DT']
				if DT in datatypeDict: DT = datatypeDict[DT]
				elif DT: pass
				datatype = DT
				if 'Text' == datatype: itemtype= 'xbrli:stringItemType'
				elif 'Code' == datatype: itemtype = 'xbrli:tokenItemType'
				elif 'Identifier' == datatype: itemtype = 'xbrli:stringItemType'
				elif 'DocumentReference' == datatype: itemtype = 'xbrli:stringItemType'
				elif 'Date' == datatype: itemtype = 'xbrli:dateTimeItemType'
				elif 'Amount' == datatype: itemtype = 'xbrli:monetaryItemType'
				elif 'Quantity' == datatype: itemtype = 'xbrli:decimalItemType'
				elif 'Percentage' == datatype: itemtype = 'xbrli:pureItemType'
				else: itemtype = 'xbrli:stringItemType'
				xml = template.format(BT, itemtype)
				types[BT] = xml
		for BT,xml in types.items(): f.write(xml)

		f.write('  \n<!-- element -->\n')
		elements = {}
		template = '	<element name="{0}" id="pint-{0}" type="pint:{1}ItemType" substitutionGroup="xbrli:item" nillable="true" xbrli:periodType="instant"/>\n'
		for data in pint_list:
			if not data or not data['PINT_ID']: continue
			id = data['PINT_ID']
			if re.match(r'^ib[tg]-[0-9]*$',id):
				BT = data['BT']
				if re.match(r'^ibt-[0-9]*$',id): BT = camelCase(BT)
				else: BT = BT.replace(' ','_')
				xml = template.format(id,BT)
				elements[BT] = xml
		for BT,xml in elements.items(): f.write(xml)
		f.write('</schema>')

	with open(definition_linkbase,'w',encoding='utf-8',buffering=1,errors='xmlcharrefreplace',newline='') as f:
		xml = DEFINITION_HEAD.format(datetime.now(JST).isoformat(timespec='minutes'))
		f.write(xml)
		seq = 1000
		for data in pint_list:
			if not data or not data['PINT_ID']: continue
			id = data['PINT_ID']
			if re.match(r'^ib[tg]-[0-9]*$',id):
				BT = data['BT']
				if re.match(r'^ibt-[0-9]*$',id): BT = camelCase(BT)
				else: BT = BT.replace(' ','_')
				# current = datetime.utcnow().isoformat(timespec='microseconds').encode('utf-8')
				# cksum = hashlib.md5(current).hexdigest()
				if 'ibg-00' != id:
					xml = '		<!-- {0}:{1} -->\n'.format(id,BT)
					# 
					# locator
					# 
					xml += '    <link:loc xlink:type="locator" xlink:href="pint-2021-12-31.xsd#pint-{0}" xlink:label="pint-{0}"/>\n'.format(id)
					# 
					# definitionArc
					# 
					xml += '    <link:definitionArc xlink:type="arc" xlink:arcrole="http://xbrl.org/int/dim/arcrole/domain-member" xlink:from="pint-ibg-00" xlink:to="pint-{0}" order="{1}"/>\n'.format(id, seq)
					f.write(xml)
					seq += 10
		f.write('	</link:definitionLink>\n</link:linkbase>')

	with open(presentation_linkbase,'w',encoding='utf-8',buffering=1,errors='xmlcharrefreplace',newline='') as f:
		xml = PRESENTATION_HEAD.format(datetime.now(JST).isoformat(timespec='minutes'))
		f.write(xml)
		idxLevel = {}
		parent = None
		n = 0
		writtenLocator = set()
		for data in pint_list:
			if not data or not data['PINT_ID']: continue
			id = data['PINT_ID']
			if re.match(r'^ib[tg]-[0-9]*$',id):
				level = int(data['Level'])
				num = id
				if level > 0:
					parent_num = idxLevel[level - 1]
					parent = re.findall('_([^_]*)$',parent_num)
					if parent: parent = parent[0]
					else: parent = parent_num
					num = parent_num + '_' + id
				idxLevel[level] = num
				if parent:
					# 
					# locator
					#
					if parent in writtenLocator: pass
					else:
						xml = '    <loc xlink:type="locator" xlink:href="pint-2021-12-31.xsd#pint-{0}" xlink:label="pint-{0}" xlink:title="presentation parent: {0}"/>\n'.format(parent)
						f.write(xml)
						writtenLocator.add(parent)
					if id in writtenLocator: pass
					else:
						xml = '    <loc xlink:type="locator" xlink:href="pint-2021-12-31.xsd#pint-{0}" xlink:label="pint-{0}" xlink:title="presentation child: {0}"/>\n'.format(id)
						f.write(xml)
						writtenLocator.add(id)
					# 
					# presentationArc
					# 
					xml = '    <presentationArc xlink:type="arc" xlink:arcrole="http://www.xbrl.org/2003/arcrole/parent-child" xlink:from="pint-{0}" xlink:to="pint-{1}" xlink:title="presentation: {0} to {1}" use="optional" order="{2}"/>\n'.format(parent, id, n)
					f.write(xml)
				n = n + 1
		xml = '  </presentationLink>\n</linkbase>'
		f.write(xml)

	with open(label_linkbase,'w',encoding='utf-8',buffering=1,errors='xmlcharrefreplace',newline='') as f:
		xml = LABEL_HEAD.format(datetime.now(JST).isoformat(timespec='minutes'))
		f.write(xml)
		for data in pint_list:
			if not data or not data['PINT_ID']: continue
			id = data['PINT_ID']
			if re.match(r'^ib[tg]-[0-9]*$',id):
				BT = data['BT']
				if re.match(r'^ibt-[0-9]*$',id): BT = camelCase(BT)
				else: BT = BT.replace(' ','_')
				# current = datetime.utcnow().isoformat(timespec='microseconds')
				cksum = '' # hashlib.md5(current.encode('utf-8')).hexdigest()
				label =    data['BT']
				label_ja = data['BT_ja']
				desc =     data['Desc']
				desc_ja =  data['Desc_ja']
				exp =      data['Exp']
				exp_ja =   data['Exp_ja']
				xml = '		<!-- {0}:{1} -->\n'.format(id,BT)
				# 
				# locator
				# 
				xml += '    <link:loc xlink:type="locator" xlink:href="pint-2021-12-31.xsd#pint-{0}" xlink:label="{0}{1}"/>\n'.format(id, cksum)
				# 
				# label
				# 
				xml += '    <link:label xlink:type="resource" xlink:role="http://www.xbrl.org/2003/role/label" xml:lang="en" xlink:label="label-{0}{1}" id="label-{0}{1}">{2}</link:label>\n'.format(id, cksum, label)
				xml += '    <link:label xlink:type="resource" xlink:role="http://www.xbrl.org/2003/role/label" xml:lang="ja" xlink:label="label-{0}{1}" id="label-{0}{1}">{2}</link:label>\n'.format(id, cksum, label_ja)
				if desc:    xml += '    <link:label xlink:type="resource" xlink:role="http://www.xbrl.org/2003/role/documentation" xml:lang="en" xlink:label="label-{0}{1}" id="label-{0}{1}">{2}</link:label>\n'.format(id, cksum, desc)
				if desc_ja: xml += '    <link:label xlink:type="resource" xlink:role="http://www.xbrl.org/2003/role/documentation" xml:lang="ja" xlink:label="label-{0}{1}" id="label-{0}{1}">{2}</link:label>\n'.format(id, cksum, desc_ja)
				if exp:     xml += '    <link:label xlink:type="resource" xlink:role="http://www.xbrl.org/2003/role/commentaryGuidance" xml:lang="en" xlink:label="label-{0}{1}" id="label-{0}{1}">{2}</link:label>\n'.format(id, cksum, exp)
				if exp_ja:  xml += '    <link:label xlink:type="resource" xlink:role="http://www.xbrl.org/2003/role/commentaryGuidance" xml:lang="ja" xlink:label="label-{0}{1}" id="label-{0}{1}">{2}</link:label>\n'.format(id, cksum, exp_ja)
				# 
				# labelArc
				# 
				xml += '    <link:labelArc xlink:type="arc" xlink:arcrole="http://www.xbrl.org/2003/arcrole/concept-label" xlink:from="{0}{1}" xlink:to="label-{0}{1}"/>\n'.format(id, cksum)
				f.write(xml)
		f.write('	</link:labelLink>\n</link:linkbase>')

	with open(reference_linkbase,'w',encoding='utf-8',buffering=1,errors='xmlcharrefreplace',newline='') as f:
		xml = REFERENCE_HEAD.format(datetime.now(JST).isoformat(timespec='minutes'))
		f.write(xml)
		for data in pint_list:
			if not data or not data['PINT_ID']: continue
			id = data['PINT_ID']
			if re.match(r'^ib[tg]-[0-9]*$',id):
				BT = data['BT']
				if re.match(r'^ibt-[0-9]*$',id): BT = camelCase(BT)
				else: BT = BT.replace(' ','_')
				# current = datetime.utcnow().isoformat(timespec='microseconds')
				# cksum = hashlib.md5(current.encode('utf-8')).hexdigest()
				xml = '		<!-- {0}:{1} -->\n'.format(id,BT)
				# 
				# locator
				# 
				xml += '    <link:loc xlink:type="locator" xlink:href="pint-2021-12-31.xsd#pint-{0}" xlink:label="{0}"/>\n'.format(id)
				# 
				# definitionRef : Namespace XPath Attribute
				# 
				xml += '    <link:reference xlink:type="resource" xlink:role="http://www.xbrl.org/2003/role/definitionRef" xlink:label="ref-{0}" id="def-{0}">'.format(id)
				xpath = data['Path']
				path = data['Path']
				m = re.match(r'.*\/([^\/]+)$',path)
				if m:
					element = m.groups()[0]
					if 'Invoice' == element:   ns = namespace['Invoice']
					elif 'cac' == element[:3]: ns = namespace['cac']
					elif 'cbc' == element[:3]: ns = namespace['cbc']
				if ns: xml += '<pint:Namespace>{0}</pint:Namespace>'.format(ns)
				if xpath: xml += '<pint:XPath>{0}</pint:XPath>'.format(xpath)
				attribute = data['Attr']
				if attribute: xml += '<pint:Attribute>{0}</pint:Attribute>'.format(attribute)
				xml += '</link:reference>\n'
				# 
				# presentationRef : SemanticDatatype Cardinality Datatype Occurrence
				# 
				xml += '    <link:reference xlink:type="resource" xlink:role="http://www.xbrl.org/2003/role/presentationRef" xlink:label="ref-{0}" id="pre-{0}">'.format(id)
				semantic_datatype = data['DT']
				if semantic_datatype: xml += '<pint:SemanticDatatype>{0}</pint:SemanticDatatype>'.format(semantic_datatype)
				cardinality = data['Card']
				if cardinality: xml += '<pint:Cardinality>{0}</pint:Cardinality>'.format(cardinality)
				datatype = data['Datatype']
				if datatype:    xml += '<pint:Datatype>{0}</pint:Datatype>'.format(datatype)
				occurrence = data['Occ']
				if occurrence:  xml += '<pint:Occurrence>{0}</pint:Occurrence>'.format(occurrence)
				xml += '</link:reference>\n'
				# 
				# exampleRef
				# 
				example = data['Example']
				if example:
					xml += '    <link:reference xlink:type="resource" xlink:role="http://www.xbrl.org/2003/role/exampleRef" xlink:label="ref-{0}{1}" id="ex-{0}{1}"><pint:Example>{2}</pint:Example></link:reference>\n'.format(id, cksum, example)
				# 
				# referenceArc
				# 
				xml += '    <link:referenceArc xlink:type="arc" xlink:arcrole="http://www.xbrl.org/2003/arcrole/concept-reference" xlink:from="{0}{1}" xlink:to="ref-{0}{1}"/>\n'.format(id, cksum)
				f.write(xml)
		f.write('	</link:referenceLink>\n</link:linkbase>')

	if verbose:
		print(f'** END ** {xbrl_schema} {definition_linkbase} {presentation_linkbase} {label_linkbase} {reference_linkbase}')