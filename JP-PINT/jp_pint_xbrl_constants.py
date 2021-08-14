SCHEMA_HEAD = '''<?xml version="1.0" encoding="UTF-8"?>
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
	<element name="Namespace" type="string" substitutionGroup="link:part"/>
	<element name="XPath" type="string" substitutionGroup="link:part"/>
	<element name="Attribute" type="string" substitutionGroup="link:part"/>
	<element name="SemanticDatatype" type="string" substitutionGroup="link:part"/>
	<element name="Cardinality" type="string" substitutionGroup="link:part"/>
	<element name="Datatype" type="string" substitutionGroup="link:part"/>
	<element name="Occurrence" type="string" substitutionGroup="link:part"/>
	<element name="Example" type="string" substitutionGroup="link:part"/>
'''
DEFINITION_HEAD = '''<?xml version="1.0" encoding="UTF-8"?>
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
PRESENTATION_HEAD = '''<?xml version="1.0" encoding="UTF-8"?>
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
LABEL_HEAD = '''<?xml version="1.0" encoding="UTF-8"?>
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
REFERENCE_HEAD = '''<?xml version="1.0" encoding="UTF-8"?>
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