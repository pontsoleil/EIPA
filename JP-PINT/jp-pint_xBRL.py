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
from datetime import datetime
import hashlib

import jp_pint_xbrl_constants
from jp_pint_xbrl_constants import SCHEMA_HEAD
from jp_pint_xbrl_constants import PRESENTATION_HEAD

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

	xbrl_schema = 'xBRL/data/pint-2021-12-31.xsd'
	label_linkbase = 'xBRL/data/pint-2021-12-31-label.xml'
	presentation_linkbase = 'xBRL/data/pint-2021-12-31-presentation.xml'

	verbose = args.verbose
	# Check if infile exists
	if not os.path.isfile(in_file):
		print('入力ファイルがありません')
		sys.exit()
	if verbose:
		print('** START ** ',__file__)

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
			BT = row['BT']
			row['BT'] = BT.strip()
			csv_list.append(row)

	pint_list = [x for x in csv_list if ''!=x['SemSort'] and ''!=x['PINT_ID']]
	pint_list = sorted(pint_list,key=lambda x: x['SemSort'])

	with open(xbrl_schema,'w',encoding='utf-8',buffering=1,errors='xmlcharrefreplace',newline='') as f:
		xml = '''
<?xml version="1.0" encoding="UTF-8"?>
<!-- (c) XBRL Japan -->
<schema targetNamespace="http://peppol.eu/2021-12-31" 
	elementFormDefault="qualified" 
	attributeFormDefault="unqualified" 
	xmlns="http://www.w3.org/2001/XMLSchema" 
	xmlns:xlink="http://www.w3.org/1999/xlink" 
	xmlns:xbrli="http://www.xbrl.org/2003/instance" 
	xmlns:link="http://www.xbrl.org/2003/linkbase" 
	xmlns:xbrldt="http://xbrl.org/2005/xbrldt" 
	xmlns:pint="http://peppol.eu/2021-12-31">
	<import namespace="http://www.xbrl.org/2003/instance" schemaLocation="http://www.xbrl.org/2003/xbrl-instance-2003-12-31.xsd"/>
	<import namespace="http://xbrl.org/2005/xbrldt" schemaLocation="http://www.xbrl.org/2005/xbrldt-2005.xsd"/>
	<annotation>
		<appinfo>
			<link:linkbaseRef xlink:arcrole="http://www.w3.org/1999/xlink/properties/linkbase" xlink:href="pint-2021-12-31-presentation.xml" xlink:role="http://www.xbrl.org/2003/role/presentationLinkbaseRef" xlink:type="simple"/>
			<link:linkbaseRef xlink:arcrole="http://www.w3.org/1999/xlink/properties/linkbase" xlink:href="pint-2021-12-31-definition.xml" xlink:role="http://www.xbrl.org/2003/role/definitionLinkbaseRef" xlink:type="simple"/>
      <link:linkbaseRef xlink:arcrole="http://www.w3.org/1999/xlink/properties/linkbase" xlink:href="pint-2021-12-31-label.xml" xlink:role="http://www.xbrl.org/2003/role/labelLinkbaseRef" xlink:type="simple"/>
			<link:roleType id="pint_structure" roleURI="http://xbrl.org/role/pint_structure">
				<link:definition>PINT Structure</link:definition>
				<link:usedOn>link:presentationLink</link:usedOn>
				<link:usedOn>link:definitionLink</link:usedOn>
			</link:roleType>
		</appinfo>
	</annotation>
	<!-- Hypercube -->
	<element name="Hypercube" id="Hypercube" type="xbrli:stringItemType" substitutionGroup="xbrldt:hypercubeItem" abstract="true" xbrli:periodType="instant"/>
	<!-- Domain -->
	<!-- L1 -->
  <element name="L1Number" id="pint_L1Number">
    <simpleType>
      <restriction base="string"/>
    </simpleType>
  </element>
  <element name="dL1Number" id="pint_dL1Number" type="xbrli:stringItemType" substitutionGroup="xbrldt:dimensionItem" abstract="true" xbrli:periodType="instant" xbrldt:typedDomainRef="#pint_L1Number"/>
	<!-- L2 -->
	<element name="L2Number" id="pint_L2Number">
		<simpleType>
			<restriction base="string"/>
		</simpleType>
	</element>
	<element name="dL2Number" id="pint_dL2Number" type="xbrli:stringItemType" substitutionGroup="xbrldt:dimensionItem" abstract="true" xbrli:periodType="instant" xbrldt:typedDomainRef="#pint_L2Number"/>
	<!-- L3 -->
	<element name="L3Number" id="pint_L3Number">
		<simpleType>
			<restriction base="string"/>
		</simpleType>
	</element>
	<element name="dL3Number" id="pint_dL3Number" type="xbrli:stringItemType" substitutionGroup="xbrldt:dimensionItem" abstract="true" xbrli:periodType="instant" xbrldt:typedDomainRef="#pint_L3Number"/>
	<!-- L4 -->
	<element name="L4Number" id="pint_L4Number">
		<simpleType>
			<restriction base="string"/>
		</simpleType>
	</element>
	<element name="dL4Number" id="pint_dL4Number" type="xbrli:stringItemType" substitutionGroup="xbrldt:dimensionItem" abstract="true" xbrli:periodType="instant" xbrldt:typedDomainRef="#pint_L4Number"/>
'''
		f.write(xml)
		f.write('\n<!-- item type -->\n')
		for data in pint_list:
			if not data or not data['PINT_ID']:
				continue
			id = data['PINT_ID']
			if re.match(r'^ib[tg]-[0-9]*$',id):
				BT = data['BT']
				if re.match(r'^ibt-[0-9]*$',id):
					BT = camelCase(BT)
				else:
					BT = BT.replace(' ','_')
				DT = data['DT']
				if DT in datatypeDict:
					DT = datatypeDict[DT]
				elif DT:
					pass
				datatype = DT
				if 'Text' == datatype:
					itemtype= 'xbrli:stringItemType'
				elif 'Code' == datatype:
					itemtype = 'xbrli:tokenItemType'
				elif 'Identifier' == datatype:
					itemtype = 'xbrli:stringItemType'
				elif 'DocumentReference' == datatype:
					itemtype = 'xbrli:stringItemType'
				elif 'Date' == datatype:
					itemtype = 'xbrli:dateTimeItemType'
				elif 'Amount' == datatype:
					itemtype = 'xbrli:monetaryItemType'
				elif 'Quantity' == datatype:
					itemtype = 'xbrli:decimalItemType'
				elif 'Percentage' == datatype:
					itemtype = 'xbrli:pureItemType'
				else:
					itemtype = 'xbrli:stringItemType'
				xml = '	<complexType name="{0}ItemType"><simpleContent><restriction base="{1}"/></simpleContent></complexType>\n'
				f.write(xml.format(BT, itemtype))

		f.write('  \n<!-- element -->\n')
		for data in pint_list:
			if not data or not data['PINT_ID']:
				continue
			id = data['PINT_ID']
			if re.match(r'^ib[tg]-[0-9]*$',id):
				BT = data['BT']
				if re.match(r'^ibt-[0-9]*$',id):
					BT = camelCase(BT)
				else:
					BT = BT.replace(' ','_')
				xml = '	<element name="{0}" id="pint-{0}" type="pint:{1}ItemType" substitutionGroup="xbrli:item" nillable="true" xbrli:periodType="instant"/>\n'
				f.write(xml.format(id,BT))
		f.write('</schema>')

	with open(label_linkbase,'w',encoding='utf-8',buffering=1,errors='xmlcharrefreplace',newline='') as f:
		xml = '''
<?xml version="1.0" encoding="UTF-8"?>\n
<link:linkbase xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xmlns:link="http://www.xbrl.org/2003/linkbase" xmlns:xlink="http://www.w3.org/1999/xlink"
    xsi:schemaLocation="http://www.xbrl.org/2003/linkbase http://www.xbrl.org/2003/xbrl-linkbase-2003-12-31.xsd">
  <link:labelLink xlink:type="extended" xlink:role="http://www.xbrl.org/2003/role/link">\n
'''
		f.write(xml)
		for data in pint_list:
			if not data or not data['PINT_ID']:
				continue
			id = data['PINT_ID']
			if re.match(r'^ib[tg]-[0-9]*$',id):
				BT = data['BT']
				if re.match(r'^ibt-[0-9]*$',id):
					BT = camelCase(BT)
				else:
					BT = BT.replace(' ','_')
				current = datetime.utcnow().isoformat(timespec='microseconds')
				cksum = hashlib.md5(current.encode('utf-8')).hexdigest()
				label = data['BT']
				xml = '		<!-- {0}:{1} -->\n'.format(id,BT)
				f.write(xml)
				xml = '    <link:loc xlink:type="locator" xlink:href="pint-2021-12-31.xsd#pint-{0}" xlink:label="{0}{1}"/>\n'.format(id, cksum)
				f.write(xml)
				xml = '    <link:label xlink:type="resource" xlink:label="label_{0}{1}" xlink:role="http://www.xbrl.org/2003/role/label" xml:lang="en" id="label_{0}{1}">{2}</link:label>\n'.format(id, cksum, label)
				f.write(xml)
				xml = '    <link:labelArc xlink:type="arc" xlink:arcrole="http://www.xbrl.org/2003/arcrole/concept-label" xlink:from="{0}{1}" xlink:to="label_{0}{1}"/>\n'.format(id, cksum)
				f.write(xml)
		f.write('	</link:labelLink>\n</link:linkbase>')

	with open(presentation_linkbase,'w',encoding='utf-8',buffering=1,errors='xmlcharrefreplace',newline='') as f:
		xml = '''
<?xml version="1.0" encoding="UTF-8"?>
<!-- (c) XBRL Japan -->
<linkbase
  xmlns="http://www.xbrl.org/2003/linkbase"
  xmlns:xlink="http://www.w3.org/1999/xlink"
  xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
  xsi:schemaLocation="http://www.xbrl.org/2003/linkbase http://www.xbrl.org/2003/xbrl-linkbase-2003-12-31.xsd">
  <presentationLink xlink:type="extended" xlink:role="http://www.xbrl.org/2003/role/link">
'''
		f.write(xml)
		idxLevel = {}
		parent = None
		n = 0
		for data in pint_list:
			if not data or not data['PINT_ID']:
				continue
			id = data['PINT_ID']
			if re.match(r'^ib[tg]-[0-9]*$',id):
				level = int(data['Level'])
				num = id
				if level > 0:
					parent_num = idxLevel[level - 1]
					parent = re.findall('_([^_]*)$',parent_num)
					if parent:
						parent = parent[0]
					else:
						parent = parent_num
					num = parent_num + '_' + id
				idxLevel[level] = num
				if parent:
					xml = '    <loc xlink:type="locator" xlink:href="pint-2021-12-31.xsd#pint_{0}" xlink:label="pint_{0}" xlink:title="presentation parent: {0}"/>\n'.format(parent)
					f.write(xml)
					xml = '    <loc xlink:type="locator" xlink:href="pint-2021-12-31.xsd#pint_{0}" xlink:label="pint_{0}" xlink:title="presentation child: {0}"/>\n'.format(id)
					f.write(xml)
					xml = '    <presentationArc xlink:type="arc" xlink:arcrole="http://www.xbrl.org/2003/arcrole/parent-child" xlink:from="pint_{0}" xlink:to="pint_{1}" xlink:title="presentation: {0} to {1}" use="optional" order="{2}"/>\n'.format(parent, id, n)
					f.write(xml)
				n = n + 1
		xml = '  </presentationLink>\n</linkbase>'
		f.write(xml)

	if verbose:
		print(f'** END ** {xbrl_schema} {label_linkbase} {presentation_linkbase}')