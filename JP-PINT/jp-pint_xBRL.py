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

import jp_pint_xbrl_constants
from jp_pint_xbrl_constants import SCHEMA_HEAD
from jp_pint_xbrl_constants import PRESENTATION_HEAD

JST = timezone(timedelta(hours=+9), 'JST')

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
	definition_linkbase = 'xBRL/data/pint-2021-12-31-definition.xml'
	presentation_linkbase = 'xBRL/data/pint-2021-12-31-presentation.xml'
	label_linkbase = 'xBRL/data/pint-2021-12-31-label.xml'
	reference_linkbase = 'xBRL/data/pint-2021-12-31-reference.xml'

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
		xml = '''<?xml version="1.0" encoding="UTF-8"?>
<!-- 
			Copyright (c) 2021 Nobuyuki SAMBUICHI
			Sambuichi Professional Engineers Office
			https://www.sambuichi.jp

			CC BY 4.0
			https://creativecommons.org/licenses/by/4.0/
			
			{0}
-->
<schema targetNamespace="http://peppol.eu/2021-12-31" 
	elementFormDefault="qualified" 
	attributeFormDefault="unqualified" 
	xmlns="http://www.w3.org/2001/XMLSchema" 
	xmlns:xlink="http://www.w3.org/1999/xlink" 
	xmlns:xbrli="http://www.xbrl.org/2003/instance" 
	xmlns:link="http://www.xbrl.org/2003/linkbase" 
	xmlns:xbrldt="http://xbrl.org/2005/xbrldt" 
	xmlns:pint="http://peppol.eu/2021-12-31">
	<annotation>
		<appinfo>
			<link:linkbaseRef xlink:href="pint-2021-12-31-presentation.xml" xlink:role="http://www.xbrl.org/2003/role/presentationLinkbaseRef" xlink:arcrole="http://www.w3.org/1999/xlink/properties/linkbase" xlink:type="simple"/>
			<link:linkbaseRef xlink:href="pint-2021-12-31-definition.xml" xlink:role="http://www.xbrl.org/2003/role/definitionLinkbaseRef" xlink:arcrole="http://www.w3.org/1999/xlink/properties/linkbase" xlink:type="simple"/>
			<link:linkbaseRef xlink:href="pint-2021-12-31-reference.xml" xlink:role="http://www.xbrl.org/2003/role/referenceLinkbaseRef" xlink:arcrole="http://www.w3.org/1999/xlink/properties/linkbase" xlink:type="simple"/>
			<link:linkbaseRef xlink:href="pint-2021-12-31-label.xml" xlink:role="http://www.xbrl.org/2003/role/labelLinkbaseRef" xlink:arcrole="http://www.w3.org/1999/xlink/properties/linkbase" xlink:type="simple"/>
			<link:roleType id="pint_structure" roleURI="http://peppol.eu/2021-12-31/role/pint_structure">
				<link:definition>PINT Structure</link:definition>
				<link:usedOn>link:presentationLink</link:usedOn>
				<link:usedOn>link:definitionLink</link:usedOn>
			</link:roleType>
			<link:arcroleType arcroleURI="http://peppol.eu/2021-12-31/role/XPath" cyclesAllowed="any" id="xpth">
				<link:definition>
					Arc from an XPath to a fact.
				</link:definition>
				<link:usedOn>link:referenceLink</link:usedOn>
			</link:arcroleType>
		</appinfo>
	</annotation>
	<import namespace="http://www.xbrl.org/2003/instance" schemaLocation="http://www.xbrl.org/2003/xbrl-instance-2003-12-31.xsd"/>
	<import namespace="http://www.xbrl.org/2003/linkbase" schemaLocation="http://www.xbrl.org/2003/xbrl-linkbase-2003-12-31.xsd"/>
	<import namespace="http://xbrl.org/2005/xbrldt" schemaLocation="http://www.xbrl.org/2005/xbrldt-2005.xsd"/>
<!-- Hypercube -->
	<element name="Hypercube" id="Hypercube" type="xbrli:stringItemType" substitutionGroup="xbrldt:hypercubeItem" abstract="true" xbrli:periodType="instant"/>
<!-- Dimension -->
	<!-- _1 -->
	<element name="_1" id="_1">
		<simpleType>
			<restriction base="string"/>
		</simpleType>
	</element>
	<element name="d1" id="d1" substitutionGroup="xbrldt:dimensionItem" abstract="true" type="xbrli:stringItemType" xbrli:periodType="instant" xbrldt:typedDomainRef="#_1"/>
	<!-- _2 -->
	<element name="_2" id="_2">
		<simpleType>
			<restriction base="string"/>
		</simpleType>
	</element>
	<element name="d2" id="d2" substitutionGroup="xbrldt:dimensionItem" abstract="true" type="xbrli:stringItemType" xbrli:periodType="instant" xbrldt:typedDomainRef="#_2"/>
	<!-- _3 -->
	<element name="_3" id="_3">
		<simpleType>
			<restriction base="string"/>
		</simpleType>
	</element>
	<element name="d3" id="d3" substitutionGroup="xbrldt:dimensionItem" abstract="true" type="xbrli:stringItemType" xbrli:periodType="instant" xbrldt:typedDomainRef="#_3"/>
	<!-- _4 -->
	<element name="_4" id="_4">
		<simpleType>
			<restriction base="string"/>
		</simpleType>
	</element>
	<element name="d4" id="d4" substitutionGroup="xbrldt:dimensionItem" abstract="true" type="xbrli:stringItemType" xbrli:periodType="instant" xbrldt:typedDomainRef="#_4"/>
	<!-- _5 -->
	<element name="_5" id="_5">
		<simpleType>
			<restriction base="string"/>
		</simpleType>
	</element>
	<element name="d5" id="d5" substitutionGroup="xbrldt:dimensionItem" abstract="true" type="xbrli:stringItemType" xbrli:periodType="instant" xbrldt:typedDomainRef="#_5"/>
<!-- reference -->
	<element name="XPath" type="string" substitutionGroup="link:part"/>
	<element name="Example" type="string" substitutionGroup="link:part"/>
'''
		xml = xml.format(datetime.now(JST).isoformat(timespec='minutes'))
		f.write(xml)
		f.write('<!-- item type -->\n')
		template = '	<complexType name="{0}ItemType"><simpleContent><restriction base="{1}"/></simpleContent></complexType>\n'
		types = {}
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
				xml = template.format(BT, itemtype)
				types[BT] = xml
		for BT,xml in types.items():	
			f.write(xml)

		f.write('  \n<!-- element -->\n')
		elements = {}
		template = '	<element name="{0}" id="pint-{0}" type="pint:{1}ItemType" substitutionGroup="xbrli:item" nillable="true" xbrli:periodType="instant"/>\n'
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
				xml = template.format(id,BT)
				elements[BT] = xml
		for BT,xml in elements.items():
			f.write(xml)
		f.write('</schema>')

	with open(definition_linkbase,'w',encoding='utf-8',buffering=1,errors='xmlcharrefreplace',newline='') as f:
		xml = '''<?xml version="1.0" encoding="UTF-8"?>
<!-- 
			Copyright (c) 2021 Nobuyuki SAMBUICHI
			Sambuichi Professional Engineers Office
			https://www.sambuichi.jp

			CC BY 4.0
			https://creativecommons.org/licenses/by/4.0/
			
			{0}
-->
<link:linkbase
  xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
  xmlns:link="http://www.xbrl.org/2003/linkbase"
  xmlns:xbrldt="http://xbrl.org/2005/xbrldt"
  xmlns:xlink="http://www.w3.org/1999/xlink"
  xsi:schemaLocation="http://www.xbrl.org/2003/linkbase http://www.xbrl.org/2003/xbrl-linkbase-2003-12-31.xsd">
  <link:roleRef roleURI="http://xbrl.org/role/pint_structure" xlink:type="simple" xlink:href="pint-2021-12-31.xsd#pint_structure"/>
  <link:arcroleRef arcroleURI="http://xbrl.org/int/dim/arcrole/all" xlink:type="simple" xlink:href="http://xbrl.org/2005/xbrldt-2005.xsd#all"/>
  <link:arcroleRef arcroleURI="http://xbrl.org/int/dim/arcrole/hypercube-dimension" xlink:type="simple" xlink:href="http://xbrl.org/2005/xbrldt-2005.xsd#hypercube-dimension"/>
  <link:arcroleRef arcroleURI="http://xbrl.org/int/dim/arcrole/dimension-domain" xlink:type="simple" xlink:href="http://xbrl.org/2005/xbrldt-2005.xsd#dimension-domain"/>
  <link:arcroleRef arcroleURI="http://xbrl.org/int/dim/arcrole/domain-member" xlink:type="simple" xlink:href="http://xbrl.org/2005/xbrldt-2005.xsd#domain-member"/>
  <link:definitionLink xlink:type="extended" xlink:role="http://peppol.eu/2021-12-31/role/pint_structure">
  <!-- Hypercube -->
    <link:loc xlink:type="locator" xlink:href="pint-2021-12-31.xsd#Hypercube" xlink:label="Hypercube" xlink:title="Hypercube"/>

  <!-- Typed Dimension -->
    <link:loc xlink:type="locator" xlink:href="pint-2021-12-31.xsd#d1" xlink:label="dim1" xlink:title="Axis d1"/>
    <link:definitionArc xlink:type="arc" xlink:arcrole="http://xbrl.org/int/dim/arcrole/hypercube-dimension" xlink:from="Hypercube" xlink:to="dim1" xlink:title="definition Hypercube to typed Dimension d1" use="optional" order="1.0"/>
    <link:loc xlink:type="locator" xlink:href="pint-2021-12-31.xsd#d2" xlink:label="dim2" xlink:title="Axis d2"/>
    <link:definitionArc xlink:type="arc" xlink:arcrole="http://xbrl.org/int/dim/arcrole/hypercube-dimension" xlink:from="Hypercube" xlink:to="dim2" xlink:title="definition Hypercube to Typed Dimension d2" use="optional" order="2.0"/>
    <link:loc xlink:type="locator" xlink:href="pint-2021-12-31.xsd#d3" xlink:label="dim3" xlink:title="Axis d3"/>
    <link:definitionArc xlink:type="arc" xlink:arcrole="http://xbrl.org/int/dim/arcrole/hypercube-dimension" xlink:from="Hypercube" xlink:to="dim3" xlink:title="definition Hypercube to Typed Dimension d3" use="optional" order="3.0"/>
    <link:loc xlink:type="locator" xlink:href="pint-2021-12-31.xsd#d4" xlink:label="dim4" xlink:title="Axis d4"/>
    <link:definitionArc xlink:type="arc" xlink:arcrole="http://xbrl.org/int/dim/arcrole/hypercube-dimension" xlink:from="Hypercube" xlink:to="dim4" xlink:title="definition Hypercube to Typed Dimension d4" use="optional" order="4.0"/>
    <link:loc xlink:type="locator" xlink:href="pint-2021-12-31.xsd#d5" xlink:label="dim5" xlink:title="Axis d5"/>
    <link:definitionArc xlink:type="arc" xlink:arcrole="http://xbrl.org/int/dim/arcrole/hypercube-dimension" xlink:from="Hypercube" xlink:to="dim5" xlink:title="definition Hypercube to Typed Dimension d5" use="optional" order="5.0"/>

  <!-- Primary Item ( ibg-00:Invoice ) to Hypercube -->
    <link:loc xlink:type="locator" xlink:href="pint-2021-12-31.xsd#pint-ibg-00" xlink:label="pint-ibg-00"/>
    <link:definitionArc xlink:type="arc" xlink:arcrole="http://xbrl.org/int/dim/arcrole/all" xlink:from="pint-ibg-00" xlink:to="Hypercube" order="100.0" xbrldt:contextElement="scenario" />
		
	<!-- Primary Item ( ibg-00:Invoice ) to each item -->
'''
		xml = xml.format(datetime.now(JST).isoformat(timespec='minutes'))
		f.write(xml)
		seq = 1000
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
				# current = datetime.utcnow().isoformat(timespec='microseconds').encode('utf-8')
				# cksum = hashlib.md5(current).hexdigest()
				if 'ibg-00' != id:
					xml = '		<!-- {0}:{1} -->\n'.format(id,BT)
					f.write(xml)
					# locator
					xml = '    <link:loc xlink:type="locator" xlink:href="pint-2021-12-31.xsd#pint-{0}" xlink:label="pint-{0}"/>\n'.format(id)
					f.write(xml)
					# definitionArc
					xml = '    <link:definitionArc xlink:type="arc" xlink:arcrole="http://xbrl.org/int/dim/arcrole/domain-member" xlink:from="pint-ibg-00" xlink:to="pint-{0}" order="{1}"/>\n'.format(id, seq)
					f.write(xml)
					seq += 10
		f.write('	</link:definitionLink>\n</link:linkbase>')

	with open(label_linkbase,'w',encoding='utf-8',buffering=1,errors='xmlcharrefreplace',newline='') as f:
		xml = '''<?xml version="1.0" encoding="UTF-8"?>
<!-- 
			Copyright (c) 2021 Nobuyuki SAMBUICHI
			Sambuichi Professional Engineers Office
			https://www.sambuichi.jp

			CC BY 4.0
			https://creativecommons.org/licenses/by/4.0/
			
			{0}
-->
	<link:linkbase xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xmlns:link="http://www.xbrl.org/2003/linkbase"
		xmlns:xlink="http://www.w3.org/1999/xlink"
		xmlns:pint="http://peppol.eu/2021-12-31"
    xsi:schemaLocation="http://www.xbrl.org/2003/linkbase http://www.xbrl.org/2003/xbrl-linkbase-2003-12-31.xsd">\n
  <link:labelLink xlink:type="extended" xlink:role="http://www.xbrl.org/2003/role/link">
'''
		xml = xml.format(datetime.now(JST).isoformat(timespec='minutes'))
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
				# current = datetime.utcnow().isoformat(timespec='microseconds')
				cksum = '' # hashlib.md5(current.encode('utf-8')).hexdigest()
				label = data['BT']
				label_ja = data['BT_ja']
				desc = data['Desc']
				desc_ja = data['Desc_ja']
				exp = data['Exp']
				exp_ja = data['Exp_ja']
				xml = '		<!-- {0}:{1} -->\n'.format(id,BT)
				f.write(xml)
				# locator
				xml = '    <link:loc xlink:type="locator" xlink:href="pint-2021-12-31.xsd#pint-{0}" xlink:label="{0}{1}"/>\n'.format(id, cksum)
				f.write(xml)
				# label
				xml = '    <link:label xlink:type="resource" xlink:role="http://www.xbrl.org/2003/role/label" xml:lang="en" xlink:label="label-{0}{1}" id="label-{0}{1}">{2}</link:label>\n'.format(id, cksum, label)
				f.write(xml)
				xml = '    <link:label xlink:type="resource" xlink:role="http://www.xbrl.org/2003/role/label" xml:lang="ja" xlink:label="label-{0}{1}" id="label-{0}{1}">{2}</link:label>\n'.format(id, cksum, label_ja)
				f.write(xml)
				if desc:
					xml = '    <link:label xlink:type="resource" xlink:role="http://www.xbrl.org/2003/role/documentation" xml:lang="en" xlink:label="label-{0}{1}" id="label-{0}{1}">{2}</link:label>\n'.format(id, cksum, desc)
					f.write(xml)
				if desc_ja:
					xml = '    <link:label xlink:type="resource" xlink:role="http://www.xbrl.org/2003/role/documentation" xml:lang="ja" xlink:label="label-{0}{1}" id="label-{0}{1}">{2}</link:label>\n'.format(id, cksum, desc_ja)
					f.write(xml)
				if exp:
					xml = '    <link:label xlink:type="resource" xlink:role="http://www.xbrl.org/2003/role/commentaryGuidance" xml:lang="en" xlink:label="label-{0}{1}" id="label-{0}{1}">{2}</link:label>\n'.format(id, cksum, exp)
					f.write(xml)
				if exp_ja:
					xml = '    <link:label xlink:type="resource" xlink:role="http://www.xbrl.org/2003/role/commentaryGuidance" xml:lang="ja" xlink:label="label-{0}{1}" id="label-{0}{1}">{2}</link:label>\n'.format(id, cksum, exp_ja)
					f.write(xml)
				# arc
				xml = '    <link:labelArc xlink:type="arc" xlink:arcrole="http://www.xbrl.org/2003/arcrole/concept-label" xlink:from="{0}{1}" xlink:to="label-{0}{1}"/>\n'.format(id, cksum)
				f.write(xml)
		f.write('	</link:labelLink>\n</link:linkbase>')

	with open(reference_linkbase,'w',encoding='utf-8',buffering=1,errors='xmlcharrefreplace',newline='') as f:
		xml = '''<?xml version="1.0" encoding="UTF-8"?>
<!-- 
			Copyright (c) 2021 Nobuyuki SAMBUICHI
			Sambuichi Professional Engineers Office
			https://www.sambuichi.jp

			CC BY 4.0
			https://creativecommons.org/licenses/by/4.0/
			
			{0}
-->
<link:linkbase xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xmlns:link="http://www.xbrl.org/2003/linkbase"
		xmlns:xlink="http://www.w3.org/1999/xlink"
		xmlns:pint="http://peppol.eu/2021-12-31"
    xsi:schemaLocation="http://www.xbrl.org/2003/linkbase http://www.xbrl.org/2003/xbrl-linkbase-2003-12-31.xsd">\n
  <link:referenceLink xlink:type="extended" xlink:role="http://www.xbrl.org/2003/role/link">
'''
		xml = xml.format(datetime.now(JST).isoformat(timespec='minutes'))
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
				# current = datetime.utcnow().isoformat(timespec='microseconds')
				cksum = '' # hashlib.md5(current.encode('utf-8')).hexdigest()
				xpath = data['Path']
				example = data['Example']
				xml = '		<!-- {0}:{1} -->\n'.format(id,BT)
				f.write(xml)
				# locator
				xml = '    <link:loc xlink:type="locator" xlink:href="pint-2021-12-31.xsd#pint-{0}" xlink:label="{0}{1}"/>\n'.format(id, cksum)
				f.write(xml)
				# xpath
				xml = '    <link:reference xlink:type="resource" xlink:role="http://www.xbrl.org/2003/role/definitionRef" xlink:label="ref-{0}{1}" id="xpath-{0}{1}"><pint:XPath>{2}</pint:XPath></link:reference>\n'.format(id, cksum, xpath)
				f.write(xml)
				# example
				if example:
					xml = '    <link:reference xlink:type="resource" xlink:role="http://www.xbrl.org/2003/role/exampleRef" xlink:label="ref-{0}{1}" id="example-{0}{1}"><pint:Example>{2}</pint:Example></link:reference>\n'.format(id, cksum, example)
					f.write(xml)
				# arc
				xml = '    <link:referenceArc xlink:type="arc" xlink:arcrole="http://www.xbrl.org/2003/arcrole/concept-reference" xlink:from="{0}{1}" xlink:to="ref-{0}{1}"/>\n'.format(id, cksum)
				f.write(xml)
		f.write('	</link:referenceLink>\n</link:linkbase>')

	with open(presentation_linkbase,'w',encoding='utf-8',buffering=1,errors='xmlcharrefreplace',newline='') as f:
		xml = '''<?xml version="1.0" encoding="UTF-8"?>
<!-- 
			Copyright (c) 2021 Nobuyuki SAMBUICHI
			Sambuichi Professional Engineers Office
			https://www.sambuichi.jp

			CC BY 4.0
			https://creativecommons.org/licenses/by/4.0/
			
			{0}
-->
<linkbase
  xmlns="http://www.xbrl.org/2003/linkbase"
  xmlns:xlink="http://www.w3.org/1999/xlink"
  xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
  xsi:schemaLocation="http://www.xbrl.org/2003/linkbase http://www.xbrl.org/2003/xbrl-linkbase-2003-12-31.xsd">
  <presentationLink xlink:type="extended" xlink:role="http://peppol.eu/2021-12-31/role/pint_structure">
'''
		xml = xml.format(datetime.now(JST).isoformat(timespec='minutes'))
		f.write(xml)
		idxLevel = {}
		parent = None
		n = 0
		writtenLocator = set()
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
					if parent in writtenLocator:
						pass
					else:
						xml = '    <loc xlink:type="locator" xlink:href="pint-2021-12-31.xsd#pint-{0}" xlink:label="pint-{0}" xlink:title="presentation parent: {0}"/>\n'.format(parent)
						f.write(xml)
						writtenLocator.add(parent)
					if id in writtenLocator:
						pass
					else:					
						xml = '    <loc xlink:type="locator" xlink:href="pint-2021-12-31.xsd#pint-{0}" xlink:label="pint-{0}" xlink:title="presentation child: {0}"/>\n'.format(id)
						f.write(xml)
						writtenLocator.add(id)
					xml = '    <presentationArc xlink:type="arc" xlink:arcrole="http://www.xbrl.org/2003/arcrole/parent-child" xlink:from="pint-{0}" xlink:to="pint-{1}" xlink:title="presentation: {0} to {1}" use="optional" order="{2}"/>\n'.format(parent, id, n)
					f.write(xml)
				n = n + 1
		xml = '  </presentationLink>\n</linkbase>'
		f.write(xml)

	if verbose:
		print(f'** END ** {xbrl_schema} {label_linkbase} {presentation_linkbase}')