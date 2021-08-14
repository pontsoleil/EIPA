PRESENTATION_HEAD = '''
<?xml version="1.0" encoding="UTF-8"?>
<!-- (c) XBRL Japan -->
<linkbase
  xmlns="http://www.xbrl.org/2003/linkbase"
  xmlns:xlink="http://www.w3.org/1999/xlink"
  xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
  xsi:schemaLocation="http://www.xbrl.org/2003/linkbase http://www.xbrl.org/2003/xbrl-linkbase-2003-12-31.xsd">
  <presentationLink xlink:type="extended" xlink:role="http://www.xbrl.org/2003/role/link">
'''
SCHEMA_HEAD = '''
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
<!--			<link:linkbaseRef xlink:arcrole="http://www.w3.org/1999/xlink/properties/linkbase" xlink:href="pint-2021-12-31-definition.xml" xlink:role="http://www.xbrl.org/2003/role/definitionLinkbaseRef" xlink:type="simple"/>
-->
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