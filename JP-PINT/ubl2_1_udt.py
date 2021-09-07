UDT = {
  "AmountType":{
    "UniqueID":"UBLUDT000001",
    "Definition":"A number of monetary units specified using a given unit of currency.",
    "base":"ccts-cct:AmountType",
    "attribute":{
      "currencyID":{
        "type":"xsd:normalizedString",
        "use":"required",
        "UniqueID":"UNDT000001-SC2",
        "Definition":"The currency of the amount.",
        "PrimitiveType":"string",
        "UsageRule":"Reference UNECE Rec 9, using 3-letter alphabetic codes."
      }
    }
  },
  "BinaryObjectType":{
    "UniqueID":"UBLUDT000002",
    "Definition":"A set of finite-length sequences of binary octets.",
    "base":"ccts-cct:BinaryObjectType",
    "attribute":{
      "mimeCode":{
        "type":"xsd:normalizedString",
        "use":"required",
        "UniqueID":"UNDT000002-SC3",
        "Definition":"The mime type of the binary object.",
        "PrimitiveType":"string"
      }
    }
  },
  # "GraphicType":{
  #   "UniqueID":"UBLUDT000003",
  #   "Definition":"A diagram, graph, mathematical curve, or similar representation.",
  #   "PrimitiveType":"binary",
  #   "base":"ccts-cct:BinaryObjectType",
  #   "attribute":{
  #     "mimeCode":{
  #       "type":"xsd:normalizedString",
  #       "use":"required",
  #       "UniqueID":"UNDT000003-SC3",
  #       "Definition":"The mime type of the graphic object.",
  #       "PrimitiveType":"normalizedString"
  #     }
  #   }
  # },
  # "PictureType":{
  #   "UniqueID":"UBLUDT000004",
  #   "Definition":"A diagram, graph, mathematical curve, or similar representation.",
  #   "PrimitiveType":"binary",
  #   "base":"ccts-cct:BinaryObjectType",
  #   "attribute":{
  #     "mimeCode":{
  #       "type":"xsd:normalizedString",
  #       "use":"required",
  #       "UniqueID":"UNDT000004-SC3",
  #       "Definition":"The mime type of the picture object.",
  #       "PrimitiveType":"normalizedString"
  #     }
  #   }
  # },
  # "SoundType":{
  #   "UniqueID":"UBLUDT000005",
  #   "Definition":"An audio representation.",
  #   "PrimitiveType":"binary",
  #   "base":"ccts-cct:BinaryObjectType",
  #   "attribute":{
  #     "mimeCode":{
  #       "type":"xsd:normalizedString",
  #       "use":"required",
  #       "UniqueID":"UNDT000005-SC3",
  #       "Definition":"The mime type of the sound object.",
  #       "PrimitiveType":"normalizedString"
  #     }
  #   }
  # },  
  # "VideoType":{
  #   "UniqueID":"UBLUDT000006",
  #   "Definition":"A video representation.",
  #   "PrimitiveType":"binary",
  #   "base":"ccts-cct:BinaryObjectType",
  #   "attribute":{
  #     "mimeCode":{
  #       "type":"xsd:normalizedString",
  #       "use":"required",
  #       "UniqueID":"UNDT000006-SC3",
  #       "Definition":"The mime type of the video object.",
  #       "PrimitiveType":"normalizedString"
  #     }
  #   }
  # },
  "CodeType":{
    "UniqueID":"UBLUDT000007",
    "Definition":"A character string (letters, figures, or symbols) that for brevity and/or language independence may be used to represent or replace a definitive value or text of an attribute, together with relevant supplementary information.",
    "PrimitiveType":"string",
    "UsageRule":"Other supplementary components in the CCT are captured as part of the token and name for the schema module containing the code list and thus, are not declared as attributes. ",
    "base":"ccts-cct:CodeType",
  },
  "DateTimeType":{
    "UniqueID":"UBLUDT000008",
    "Definition":"A particular point in the progression of time, together with relevant supplementary information.",
    "PrimitiveType":"string",
    "UsageRule":"Can be used for a date and/or time.",
    "base":"xsd:dateTime"
  },
  "DateType":{
    "UniqueID":"UBLUDT000009",
    "Definition":"One calendar day according the Gregorian calendar.",
    "PrimitiveType":"string",
    "base":"xsd:date"
  },
  "TimeType":{
    "UniqueID":"UBLUDT0000010",
    "Definition":"An instance of time that occurs every day.",
    "PrimitiveType":"string",
    "base":"xsd:time"
  },
  "IdentifierType":{
    "UniqueID":"UBLUDT0000011",
    "Definition":"A character string to identify and uniquely distinguish one instance of an object in an identification scheme from all other objects in the same scheme, together with relevant supplementary information.",
    "PrimitiveType":"string",
    "UsageRule":"Other supplementary components in the CCT are captured as part of the token and name for the schema module containing the identifier list and thus, are not declared as attributes. ",
    "base":"ccts-cct:IdentifierType",
  },
  "IndicatorType":{
    "UniqueID":"UBLUDT0000012",
    "Definition":"A list of two mutually exclusive Boolean values that express the only possible states of a property.",
    "PrimitiveType":"string",
    "base":"xsd:boolean"
  }, 
  # "MeasureType":{
  #   "UniqueID":"UBLUDT0000013",
  #   "Definition":"A numeric value determined by measuring an object using a specified unit of measure.",
  #   "PrimitiveType":"decimal",
  #   "base":"ccts-cct:MeasureType",
  #   "attribute":{
  #     "unitCode":{
  #       "type":"xsd:normalizedString",
  #       "use":"required",
  #       "UniqueID":"UNDT000013-SC2",
  #       "Definition":"The type of unit of measure.",
  #       "PrimitiveType":"normalizedString",
  #       "UsageRule":"Reference UNECE Rec. 20 and X12 355"
  #     }
  #   }
  # },
  "NumericType":{
    "UniqueID":"UBLUDT0000014",
    "Definition":"Numeric information that is assigned or is determined by calculation, counting, or sequencing. It does not require a unit of quantity or unit of measure.",
    "PrimitiveType":"string",
    "base":"ccts-cct:NumericType"
  },
  # "ValueType":{
  #   "UniqueID":"UBLUDT0000015",
  #   "Definition":"Numeric information that is assigned or is determined by calculation, counting, or sequencing. It does not require a unit of quantity or unit of measure.",
  #   "PrimitiveType":"string",
  #   "base":"ccts-cct:NumericType"
  # },
  "PercentType":{
    "UniqueID":"UBLUDT0000016",
    "Definition":"Numeric information that is assigned or is determined by calculation, counting, or sequencing and is expressed as a percentage. It does not require a unit of quantity or unit of measure.",
    "PrimitiveType":"string",
    "base":"ccts-cct:NumericType"
  },
  # "RateType":{
  #   "UniqueID":"UBLUDT0000017",
  #   "Definition":"A numeric expression of a rate that is assigned or is determined by calculation, counting, or sequencing. It does not require a unit of quantity or unit of measure.",
  #   "PrimitiveType":"string",
  #   "base":"ccts-cct:NumericType"
  # },
  "QuantityType":{
    "UniqueID":"UBLUDT0000018",
    "Definition":"A counted number of non-monetary units, possibly including a fractional part.",
    "PrimitiveType":"decimal",
    "base":"ccts-cct:QuantityType"
  },
  "TextType":{
    "UniqueID":"UBLUDT0000019",
    "Definition":"A character string (i.e. a finite set of characters), generally in the form of words of a language.",
    "PrimitiveType":"string",
    "base":"ccts-cct:TextType"
  },
  "NameType":{
    "UniqueID":"UBLUDT0000020",
    "Definition":"A character string that constitutes the distinctive designation of a person, place, thing or concept.",
    "PrimitiveType":"string",
    "base":"ccts-cct:TextType"
  }
}