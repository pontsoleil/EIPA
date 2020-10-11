<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0">

<!-- handle the root XML element -->
<xsl:template match="/">
<html>
<head>
  <title>Pets that are available for adoption</title>
</head>
<body>
  <xsl:apply-templates/>
</body>
</html>
</xsl:template>

<xsl:template match="pets">
<xsl:apply-templates/>
</xsl:template>

<xsl:template match="petType">
<h2><xsl:value-of select="@name"/></h2>
<table id="{@name}">
   <tr>
     <th colname="id">ID</th>
     <th colname="name">Name</th>
     <th colname="vaccinated">Vaccine status</th>
     <th colname="health">Health status</th>
   </tr>
   <tbody>
     <!-- add a row for each pet in this category -->
     <xsl:for-each select="pet">
       <tr>
         <td colname="id"><xsl:value-of select="@id"/></td>
         <td colname="name"><xsl:value-of select="@name"/></td>
         <td colname="vaccinated"><xsl:value-of select="@vaccineStatus"/></td>
         <td colname="health"><xsl:value-of select="@healthStatus"/></td>
       </tr>
     </xsl:for-each>
   </tbody>
 </table>
</xsl:template>

<!-- ignore the content of other tags because we processed them elsewhere -->
<xsl:template match="*">
<!-- do nothing -->
</xsl:template>

</xsl:stylesheet>
