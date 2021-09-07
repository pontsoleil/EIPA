CCT = {
  "AmountType":{
    "UniqueID":"UNDT000001",
    "CategoryCode":"CCT",
    "DictionaryEntryName":"Amount. Type",
    "VersionID":"1.0",
    "Definition":"A number of monetary units specified in a currency where the unit of the currency is explicit or implied.",
    "RepresentationTermName":"Amount",
    "PrimitiveType":"decimal",
    "base":"xsd:decimal",
    "attribute":{
      "currencyID":{
        "type":"xsd:normalizedString",
        "use":"optional",
        "UniqueID":"UNDT000001-SC2",
        "CategoryCode":"SC",
        "DictionaryEntryName":"Amount Currency. Identifier",
        "Definition":"The currency of the amount.",
        "ObjectClass":"Amount Currency",
        "PropertyTermName":"Identification",
        "RepresentationTermName":"Identifier",
        "PrimitiveType":"string",
        "UsageRule":"Reference UNECE Rec 9, using 3-letter alphabetic codes."
      },
      "currencyCodeListVersionID":{
        "type":"xsd:normalizedString",
        "use":"optional",
        "UniqueID":"UNDT000001-SC3",
        "CategoryCode":"SC",
        "DictionaryEntryName":"Amount Currency. Code List Version. Identifier",
        "Definition":"The VersionID of the UN/ECE Rec9 code list.",
        "ObjectClass":"Amount Currency",
        "PropertyTermName":"Code List Version",
        "RepresentationTermName":"Identifier",
        "PrimitiveType":"string"
      }
    }
  },
  "BinaryObjectType":{
    "UniqueID":"UNDT000002",
    "CategoryCode":"CCT",
    "DictionaryEntryName":"Binary Object. Type",
    "VersionID":"1.0",
    "Definition":"A set of finite-length sequences of binary octets.",
    "RepresentationTermName":"Binary Object",
    "PrimitiveType":"binary",
    "base":"xsd:base64Binary",
    "attribute":{
      "format":{
        "type":"xsd:string",
        "use":"optional",
        "UniqueID":"UNDT000002-SC2",
        "CategoryCode":"SC",
        "DictionaryEntryName":"Binary Object. Format. Text",
        "Definition":"The format of the binary content.",
        "ObjectClass":"Binary Object",
        "PropertyTermName":"Format",
        "RepresentationTermName":"Text",
        "PrimitiveType":"string"
      },
      "mimeCode":{
        "type":"xsd:normalizedString",
        "use":"optional",
        "UniqueID":"UNDT000002-SC3",
        "CategoryCode":"SC",
        "DictionaryEntryName":"Binary Object. Mime. Code",
        "Definition":"The mime type of the binary object.",
        "ObjectClass":"Binary Object",
        "PropertyTermName":"Mime",
        "RepresentationTermName":"Code",
        "PrimitiveType":"string"
      },
      "encodingCode":{
        "type":"xsd:normalizedString",
        "use":"optional",
        "UniqueID":"UNDT000002-SC4",
        "CategoryCode":"SC",
        "DictionaryEntryName":"Binary Object. Encoding. Code",
        "Definition":"Specifies the decoding algorithm of the binary object.",
        "ObjectClass":"Binary Object",
        "PropertyTermName":"Encoding",
        "RepresentationTermName":"Code",
        "PrimitiveType":"string"
      },
      "characterSetCode":{
        "type":"xsd:normalizedString",
        "use":"optional",
        "UniqueID":"UNDT000002-SC5",
        "CategoryCode":"SC",
        "DictionaryEntryName":"Binary Object. Character Set. Code",
        "Definition":"The character set of the binary object if the mime type is text.",
        "ObjectClass":"Binary Object",
        "PropertyTermName":"Character Set",
        "RepresentationTermName":"Code",
        "PrimitiveType":"string"
      },
      "uri":{
        "type":"xsd:anyURI",
        "use":"optional",
        "UniqueID":"UNDT000002-SC6",
        "CategoryCode":"SC",
        "DictionaryEntryName":"Binary Object. Uniform Resource. Identifier",
        "Definition":"The Uniform Resource Identifier that identifies where the binary object is located.",
        "ObjectClass":"Binary Object",
        "PropertyTermName":"Uniform Resource Identifier",
        "RepresentationTermName":"Identifier",
        "PrimitiveType":"string"
      },
      "filename":{
        "type":"xsd:string",
        "use":"optional",
        "UniqueID":"UNDT000002-SC7",
        "CategoryCode":"SC",
        "DictionaryEntryName":"Binary Object. Filename.Text",
        "Definition":"The filename of the binary object.",
        "ObjectClass":"Binary Object",
        "PropertyTermName":"Filename",
        "RepresentationTermName":"Text",
        "PrimitiveType":"string"
      }
    }
  },
  "CodeType":{
    "UniqueID":"UNDT000007",
    "CategoryCode":"CCT",
    "DictionaryEntryName":"Code. Type",
    "VersionID":"1.0",
    "Definition":"A character string (letters, figures, or symbols) that for brevity and/or languange independence may be used to represent or replace a definitive value or text of an attribute together with relevant supplementary information.",
    "RepresentationTermName":"Code",
    "PrimitiveType":"string",
    "UsageRule":"Should not be used if the character string identifies an instance of an object class or an object in the real world, in which case the Identifier. Type should be used.",
    "base":"xsd:normalizedString",
    "attribute":{
      "listID":{
        "type":"xsd:normalizedString",
        "use":"optional",
        "UniqueID":"UNDT000007-SC2",
        "CategoryCode":"SC",
        "DictionaryEntryName":"Code List. Identifier",
        "Definition":"The identification of a list of codes.",
        "ObjectClass":"Code List",
        "PropertyTermName":"Identification",
        "RepresentationTermName":"Identifier",
        "PrimitiveType":"string"
      },
      "listAgencyID":{
        "type":"xsd:normalizedString",
        "use":"optional",
        "UniqueID":"UNDT000007-SC3",
        "CategoryCode":"SC",
        "DictionaryEntryName":"Code List. Agency. Identifier",
        "Definition":"An agency that maintains one or more lists of codes.",
        "ObjectClass":"Code List",
        "PropertyTermName":"Agency",
        "RepresentationTermName":"Identifier",
        "PrimitiveType":"string",
        "UsageRule":"Defaults to the UN/EDIFACT data element 3055 code list."
      },
      "listAgencyName":{
        "type":"xsd:string",
        "use":"optional",
        "UniqueID":"UNDT000007-SC4",
        "CategoryCode":"SC",
        "DictionaryEntryName":"Code List. Agency Name. Text",
        "Definition":"The name of the agency that maintains the list of codes.",
        "ObjectClass":"Code List",
        "PropertyTermName":"Agency Name",
        "RepresentationTermName":"Text",
        "PrimitiveType":"string"
      },
      "listName":{
        "type":"xsd:string",
        "use":"optional",
        "UniqueID":"UNDT000007-SC5",
        "CategoryCode":"SC",
        "DictionaryEntryName":"Code List. Name. Text",
        "Definition":"The name of a list of codes.",
        "ObjectClass":"Code List",
        "PropertyTermName":"Name",
        "RepresentationTermName":"Text",
        "PrimitiveType":"string"
      },
      "listVersionID":{
        "type":"xsd:normalizedString",
        "use":"optional",
        "UniqueID":"UNDT000007-SC6",
        "CategoryCode":"SC",
        "DictionaryEntryName":"Code List. Version. Identifier",
        "Definition":"The version of the list of codes.",
        "ObjectClass":"Code List",
        "PropertyTermName":"Version",
        "RepresentationTermName":"Identifier",
        "PrimitiveType":"string"
      },
      "name":{
        "type":"xsd:string",
        "use":"optional",
        "UniqueID":"UNDT000007-SC7",
        "CategoryCode":"SC",
        "DictionaryEntryName":"Code. Name. Text",
        "Definition":"The textual equivalent of the code content component.",
        "ObjectClass":"Code",
        "PropertyTermName":"Name",
        "RepresentationTermName":"Text",
        "PrimitiveType":"string"
      },
      "languageID":{
        "type":"xsd:language",
        "use":"optional",
        "UniqueID":"UNDT000007-SC8",
        "CategoryCode":"SC",
        "DictionaryEntryName":"Language. Identifier",
        "Definition":"The identifier of the language used in the code name.",
        "ObjectClass":"Language",
        "PropertyTermName":"Identification",
        "RepresentationTermName":"Identifier",
        "PrimitiveType":"string"
      },
      "listURI":{
        "type":"xsd:anyURI",
        "use":"optional",
        "UniqueID":"UNDT000007-SC9",
        "CategoryCode":"SC",
        "DictionaryEntryName":"Code List. Uniform Resource. Identifier",
        "Definition":"The Uniform Resource Identifier that identifies where the code list is located.",
        "ObjectClass":"Code List",
        "PropertyTermName":"Uniform Resource Identifier",
        "RepresentationTermName":"Identifier",
        "PrimitiveType":"string"
      },
      "listSchemeURI":{
        "type":"xsd:anyURI",
        "use":"optional",
        "UniqueID":"UNDT000007-SC10",
        "CategoryCode":"SC",
        "DictionaryEntryName":"Code List Scheme. Uniform Resource. Identifier",
        "Definition":"The Uniform Resource Identifier that identifies where the code list scheme is located.",
        "ObjectClass":"Code List Scheme",
        "PropertyTermName":"Uniform Resource Identifier",
        "RepresentationTermName":"Identifier",
        "PrimitiveType":"string",
      }
    }
  },
  "DateTimeType":{
    "UniqueID":"UNDT000008",
    "CategoryCode":"CCT",
    "DictionaryEntryName":"Date Time. Type",
    "VersionID":"1.0",
    "Definition":"A particular point in the progression of time together with the relevant supplementary information.",
    "RepresentationTermName":"Date Time",
    "PrimitiveType":"string",
    "UsageRule":"Can be used for a date and/or time.",
    "base":"xsd:string",
    "attribute":{
      "format":{
        "type":"xsd:string",
        "use":"optional",
        "UniqueID":"UNDT000008-SC1",
        "CategoryCode":"SC",
        "DictionaryEntryName":"Date Time. Format. Text",
        "Definition":"The format of the date time content",
        "ObjectClass":"Date Time",
        "PropertyTermName":"Format",
        "RepresentationTermName":"Text",
        "PrimitiveType":"string"
      }
    }
  },
  "IdentifierType":{
    "UniqueID":"UNDT000011",
    "CategoryCode":"CCT",
    "DictionaryEntryName":"Identifier. Type",
    "VersionID":"1.0",
    "Definition":"A character string to identify and distinguish uniquely, one instance of an object in an identification scheme from all other objects in the same scheme together with relevant supplementary information.",
    "RepresentationTermName":"Identifier",
    "PrimitiveType":"string",
    "base":"xsd:normalizedString",
    "attribute":{
      "schemeID":{
        "type":"xsd:normalizedString",
        "use":"optional",
        "UniqueID":"UNDT000011-SC2",
        "CategoryCode":"SC",
        "DictionaryEntryName":"Identification Scheme. Identifier",
        "Definition":"The identification of the identification scheme.",
        "ObjectClass":"Identification Scheme",
        "PropertyTermName":"Identification",
        "RepresentationTermName":"Identifier",
        "PrimitiveType":"string"
      },
      "schemeName":{
        "type":"xsd:string",
        "use":"optional",
        "UniqueID":"UNDT000011-SC3",
        "CategoryCode":"SC",
        "DictionaryEntryName":"Identification Scheme. Name. Text",
        "Definition":"The name of the identification scheme.",
        "ObjectClass":"Identification Scheme",
        "PropertyTermName":"Name",
        "RepresentationTermName":"Text",
        "PrimitiveType":"string"
      },
      "schemeAgencyID":{
        "type":"xsd:normalizedString",
        "use":"optional",
        "UniqueID":"UNDT000011-SC4",
        "CategoryCode":"SC",
        "DictionaryEntryName":"Identification Scheme Agency. Identifier",
        "Definition":"The identification of the agency that maintains the identification scheme.",
        "ObjectClass":"Identification Scheme Agency",
        "PropertyTermName":"Identification",
        "RepresentationTermName":"Identifier",
        "PrimitiveType":"string",
        "UsageRule":"Defaults to the UN/EDIFACT data element 3055 code list."
      },
      "schemeAgencyName":{
        "type":"xsd:string",
        "use":"optional",
        "UniqueID":"UNDT000011-SC5",
        "CategoryCode":"SC",
        "DictionaryEntryName":"Identification Scheme Agency. Name. Text",
        "Definition":"The name of the agency that maintains the identification scheme.",
        "ObjectClass":"Identification Scheme Agency",
        "PropertyTermName":"Agency Name",
        "RepresentationTermName":"Text",
        "PrimitiveType":"string"
      },
      "schemeVersionID":{
        "type":"xsd:normalizedString",
        "use":"optional",
        "UniqueID":"UNDT000011-SC6",
        "CategoryCode":"SC",
        "DictionaryEntryName":"Identification Scheme. Version. Identifier",
        "Definition":"The version of the identification scheme.",
        "ObjectClass":"Identification Scheme",
        "PropertyTermName":"Version",
        "RepresentationTermName":"Identifier",
        "PrimitiveType":"string"
      },
      "schemeDataURI":{
        "type":"xsd:anyURI",
        "use":"optional",
        "UniqueID":"UNDT000011-SC7",
        "CategoryCode":"SC",
        "DictionaryEntryName":"Identification Scheme Data. Uniform Resource. Identifier",
        "Definition":"The Uniform Resource Identifier that identifies where the identification scheme data is located.",
        "ObjectClass":"Identification Scheme Data",
        "PropertyTermName":"Uniform Resource Identifier",
        "RepresentationTermName":"Identifier",
        "PrimitiveType":"string"
      },
      "schemeURI":{
        "type":"xsd:anyURI",
        "use":"optional",
        "UniqueID":"UNDT000011-SC8",
        "CategoryCode":"SC",
        "DictionaryEntryName":"Identification Scheme. Uniform Resource. Identifier",
        "Definition":"The Uniform Resource Identifier that identifies where the identification scheme is located.",
        "ObjectClass":"Identification Scheme",
        "PropertyTermName":"Uniform Resource Identifier",
        "RepresentationTermName":"Identifier",
        "PrimitiveType":"string"
      }
    }
  },
  "IndicatorType":{
    "UniqueID":"UNDT000012",
    "CategoryCode":"CCT",
    "DictionaryEntryName":"Indicator. Type",
    "VersionID":"1.0",
    "Definition":"A list of two mutually exclusive Boolean values that express the only possible states of a Property.",
    "RepresentationTermName":"Indicator",
    "PrimitiveType":"string",
    "base":"xsd:string",
    "attribute":{
      "format":{
        "type":"xsd:string",
        "use":"optional",
        "UniqueID":"UNDT000012-SC2",
        "CategoryCode":"SC",
        "DictionaryEntryName":"Indicator. Format. Text",
        "Definition":"Whether the indicator is numeric, textual or binary.",
        "ObjectClass":"Indicator",
        "PropertyTermName":"Format",
        "RepresentationTermName":"Text",
        "PrimitiveType":"string"
      }
    }
  },
  "MeasureType":{
    "UniqueID":"UNDT000013",
    "CategoryCode":"CCT",
    "DictionaryEntryName":"Measure. Type",
    "VersionID":"1.0",
    "Definition":"A numeric value determined by measuring an object along with the specified unit of measure.",
    "RepresentationTermName":"Measure",
    "PrimitiveType":"decimal",
    "base":"xsd:decimal",
    "attribute":{
      "unitCode":{
        "type":"xsd:normalizedString",
        "use":"optional",
        "UniqueID":"UNDT000013-SC2",
        "CategoryCode":"SC",
        "DictionaryEntryName":"Measure Unit. Code",
        "Definition":"The type of unit of measure.",
        "ObjectClass":"Measure Unit",
        "PropertyTermName":"Code",
        "RepresentationTermName":"Code",
        "PrimitiveType":"string",
        "UsageRule":"Reference UNECE Rec. 20 and X12 355"
      },
      "unitCodeListVersionID":{
        "type":"xsd:normalizedString",
        "use":"optional",
        "UniqueID":"UNDT000013-SC3",
        "CategoryCode":"SC",
        "DictionaryEntryName":"Measure Unit. Code List Version. Identifier",
        "Definition":"The version of the measure unit code list.",
        "ObjectClass":"Measure Unit",
        "PropertyTermName":"Code List Version",
        "RepresentationTermName":"Identifier",
        "PrimitiveType":"string"
      }
    }
  },
  "NumericType":{
    "UniqueID":"UNDT000014",
    "CategoryCode":"CCT",
    "DictionaryEntryName":"Numeric. Type",
    "VersionID":"1.0",
    "Definition":"Numeric information that is assigned or is determined by calculation, counting, or sequencing. It does not require a unit of quantity or unit of measure.",
    "RepresentationTermName":"Numeric",
    "PrimitiveType":"string",
    "base":"xsd:decimal",
    "attribute":{
      "format":{
        "type":"xsd:string",
        "use":"optional",
        "UniqueID":"UNDT000014-SC2",
        "CategoryCode":"SC",
        "DictionaryEntryName":"Numeric. Format. Text",
        "Definition":"Whether the number is an integer, decimal, real number or percentage.",
        "ObjectClass":"Numeric",
        "PropertyTermName":"Format",
        "RepresentationTermName":"Text",
        "PrimitiveType":"string"
      }
    }
  },
  "QuantityType":{
    "UniqueID":"UNDT000018",
    "CategoryCode":"CCT",
    "DictionaryEntryName":"Quantity. Type",
    "VersionID":"1.0",
    "Definition":"A counted number of non-monetary units possibly including fractions.",
    "RepresentationTermName":"Quantity",
    "PrimitiveType":"decimal",
    "base":"xsd:decimal",
    "attribute":{
      "unitCode":{
        "type":"xsd:normalizedString",
        "use":"optional",
        "UniqueID":"UNDT000018-SC2",
        "CategoryCode":"SC",
        "DictionaryEntryName":"Quantity. Unit. Code",
        "Definition":"The unit of the quantity",
        "ObjectClass":"Quantity",
        "PropertyTermName":"Unit Code",
        "RepresentationTermName":"Code",
        "PrimitiveType":"string"
      },
      "unitCodeListID":{
        "type":"xsd:normalizedString",
        "use":"optional",
        "UniqueID":"UNDT000018-SC3",
        "CategoryCode":"SC",
        "DictionaryEntryName":"Quantity Unit. Code List. Identifier",
        "Definition":"The quantity unit code list.",
        "ObjectClass":"Quantity Unit",
        "PropertyTermName":"Code List",
        "RepresentationTermName":"Identifier",
        "PrimitiveType":"string"
      },
      "unitCodeListAgencyID":{
        "type":"xsd:normalizedString",
        "use":"optional",
        "UniqueID":"UNDT000018-SC4",
        "CategoryCode":"SC",
        "DictionaryEntryName":"Quantity Unit. Code List Agency. Identifier",
        "Definition":"The identification of the agency that maintains the quantity unit code list",
        "ObjectClass":"Quantity Unit",
        "PropertyTermName":"Code List Agency",
        "RepresentationTermName":"Identifier",
        "PrimitiveType":"string",
        "UsageRule":"Defaults to the UN/EDIFACT data element 3055 code list."
      },
      "unitCodeListAgencyName":{
        "type":"xsd:string",
        "use":"optional",
        "UniqueID":"UNDT000018-SC5",
        "CategoryCode":"SC",
        "DictionaryEntryName":"Quantity Unit. Code List Agency Name. Text",
        "Definition":"The name of the agency which maintains the quantity unit code list.",
        "ObjectClass":"Quantity Unit",
        "PropertyTermName":"Code List Agency Name",
        "RepresentationTermName":"Text",
        "PrimitiveType":"string"
      }
    }
  },
  "TextType":{
    "UniqueID":"UNDT000019",
    "CategoryCode":"CCT",
    "DictionaryEntryName":"Text. Type",
    "VersionID":"1.0",
    "Definition":"A character string (i.e. a finite set of characters) generally in the form of words of a language.",
    "RepresentationTermName":"Text",
    "PrimitiveType":"string",
    "base":"xsd:string",
    "attribute":{
      "languageID":{
        "type":"xsd:language",
        "use":"optional",
        "UniqueID":"UNDT000019-SC2",
        "CategoryCode":"SC",
        "DictionaryEntryName":"Language. Identifier",
        "Definition":"The identifier of the language used in the content component.",
        "ObjectClass":"Language",
        "PropertyTermName":"Identification",
        "RepresentationTermName":"Identifier",
        "PrimitiveType":"string"
      },
      "languageLocaleID":{
        "type":"xsd:normalizedString",
        "use":"optional",
        "UniqueID":"UNDT000019-SC3",
        "CategoryCode":"SC",
        "DictionaryEntryName":" Language. Locale. Identifier",
        "Definition":"The identification of the locale of the language.",
        "ObjectClass":"Language",
        "PropertyTermName":"Locale",
        "RepresentationTermName":"Identifier",
        "PrimitiveType":"string"
      }
    }
  }
}