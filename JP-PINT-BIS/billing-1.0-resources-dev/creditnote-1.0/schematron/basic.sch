<?xml version="1.0" encoding="UTF-8"?><schema xmlns="http://purl.oclc.org/dsdl/schematron" queryBinding="xslt2" schemaVersion="iso">
  <title>Basic rules</title>
  <ns prefix="ubl" uri="urn:oasis:names:specification:ubl:schema:xsd:Invoice-2"/>
  <ns prefix="cac" uri="urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2"/>
  <ns prefix="cbc" uri="urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2"/>
  <ns prefix="xmldsig" uri="http://www.w3.org/2000/09/xmldsig#"/>
  <ns prefix="xs" uri="http://www.w3.org/2001/XMLSchema"/>
  <pattern id="basic">
  <let name="clICD" value="tokenize('0002 0003 0004 0005 0006 0007 0008 0009 0010 0011 0012 0013 0014 0015 0016 0017 0018 0019 0020 0021 0022 0023 0024 0025 0026 0027 0028 0029 0030 0031 0032 0033 0034 0035 0036 0037 0038 0039 0040 0041 0042 0043 0044 0045 0046 0047 0048 0049 0050 0051 0052 0053 0054 0055 0056 0057 0058 0059 0060 0061 0062 0063 0064 0065 0066 0067 0068 0069 0070 0071 0072 0073 0074 0075 0076 0077 0078 0079 0080 0081 0082 0083 0084 0085 0086 0087 0088 0089 0090 0091 0093 0094 0095 0096 0097 0098 0099 0100 0101 0102 0104 0105 0106 0107 0108 0109 0110 0111 0112 0113 0114 0115 0116 0117 0118 0119 0120 0121 0122 0123 0124 0125 0126 0127 0128 0129 0130 0131 0132 0133 0134 0135 0136 0137 0138 0139 0140 0141 0142 0143 0144 0145 0146 0147 0148 0149 0150 0151 0152 0153 0154 0155 0156 0157 0158 0159 0160 0161 0162 0163 0164 0165 0166 0167 0168 0169 0170 0171 0172 0173 0174 0175 0176 0177 0178 0179 0180 0183 0184 0185 0186 0187 0188 0189 0190 0191 0192 0193 0194 0195 0196 0197 0198 0199 0200 0201 0202 0203 0204 0205 0206 0207 0208 0209 0210 0211 0212 0213', '\s')"/>
  <let name="clISO3166" value="tokenize('AD AE AF AG AI AL AM AO AQ AR AS AT AU AW AX AZ BA BB BD BE BF BG BH BI BJ BL BM BN BO BQ BR BS BT BV BW BY BZ CA CC CD CF CG CH CI CK CL CM CN CO CR CU CV CW CX CY CZ DE DJ DK DM DO DZ EC EE EG EH ER ES ET FI FJ FK FM FO FR GA GB GD GE GF GG GH GI GL GM GN GP GQ GR GS GT GU GW GY HK HM HN HR HT HU ID IE IL IM IN IO IQ IR IS IT JE JM JO JP KE KG KH KI KM KN KP KR KW KY KZ LA LB LC LI LK LR LS LT LU LV LY MA MC MD ME MF MG MH MK ML MM MN MO MP MQ MR MS MT MU MV MW MX MY MZ NA NC NE NF NG NI NL NO NP NR NU NZ OM PA PE PF PG PH PK PL PM PN PR PS PT PW PY QA RE RO RS RU RW SA SB SC SD SE SG SH SI SJ SK SL SM SN SO SR SS ST SV SX SY SZ TC TD TF TG TH TJ TK TL TM TN TO TR TT TV TW TZ UA UG UM US UY UZ VA VC VE VG VI VN VU WF WS YE YT ZA ZM ZW 1A XI', '\s')"/>
  <let name="clISO4217" value="tokenize('AED AFN ALL AMD ANG AOA ARS AUD AWG AZN BAM BBD BDT BGN BHD BIF BMD BND BOB BOV BRL BSD BTN BWP BYN BZD CAD CDF CHE CHF CHW CLF CLP CNY COP COU CRC CUC CUP CVE CZK DJF DKK DOP DZD EGP ERN ETB EUR FJD FKP GBP GEL GHS GIP GMD GNF GTQ GYD HKD HNL HRK HTG HUF IDR ILS INR IQD IRR ISK JMD JOD JPY KES KGS KHR KMF KPW KRW KWD KYD KZT LAK LBP LKR LRD LSL LYD MAD MDL MGA MKD MMK MNT MOP MRU MUR MVR MWK MXN MXV MYR MZN NAD NGN NIO NOK NPR NZD OMR PAB PEN PGK PHP PKR PLN PYG QAR RON RSD RUB RWF SAR SBD SCR SDG SEK SGD SHP SLL SOS SRD SSP STN SVC SYP SZL THB TJS TMT TND TOP TRY TTD TWD TZS UAH UGX USD USN UYI UYU UZS VEF VND VUV WST XAF XAG XAU XBA XBB XBC XBD XCD XDR XOF XPD XPF XPT XSU XTS XUA YER ZAR ZMW ZWL', '\s')"/>
  <let name="clMimeCode" value="tokenize('application/pdf application/vnd.oasis.opendocument.spreadsheet application/vnd.openxmlformats-officedocument.spreadsheetml.sheet image/jpeg image/png text/csv', '\s')"/>
  <let name="clSEPA" value="tokenize('SEPA', '\s')"/>
  <let name="clUNCL1001" value="tokenize('1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41 42 43 44 45 46 47 48 49 50 51 52 53 54 55 56 57 58 59 60 61 62 63 64 65 66 67 68 69 70 71 72 73 74 75 76 77 78 79 80 81 82 83 84 85 86 87 88 89 90 91 92 93 94 95 96 97 98 99 100 101 102 103 104 105 106 107 108 109 110 111 112 113 114 115 116 117 118 119 120 121 122 123 124 125 126 127 128 129 130 131 132 133 134 135 136 137 138 139 140 141 142 143 144 145 146 147 148 149 150 151 152 153 154 155 156 157 158 159 160 161 162 163 164 165 166 167 168 169 170 171 172 173 174 175 176 177 178 179 180 181 182 183 184 185 186 187 188 189 190 191 192 193 194 195 196 197 198 199 200 201 202 203 204 205 206 207 208 209 210 211 212 213 214 215 216 217 218 219 220 221 222 223 224 225 226 227 228 229 230 231 232 233 234 235 236 237 238 239 240 241 242 243 244 245 246 247 248 249 250 251 252 253 254 255 256 257 258 259 260 261 262 263 264 265 266 267 268 269 270 271 272 273 274 275 276 277 278 279 280 281 282 283 284 285 286 287 288 289 290 291 292 293 294 295 296 297 298 299 300 301 302 303 304 305 306 307 308 309 310 311 312 313 314 315 316 317 318 319 320 321 322 323 324 325 326 327 328 329 330 331 332 333 334 335 336 337 338 339 340 341 342 343 344 345 346 347 348 349 350 351 352 353 354 355 356 357 358 359 360 361 362 363 364 365 366 367 368 369 370 371 372 373 374 375 376 377 378 379 380 381 382 383 384 385 386 387 388 389 390 391 392 393 394 395 396 397 398 399 400 401 402 403 404 405 406 407 408 409 410 411 412 413 414 415 416 417 418 419 420 421 422 423 1999 424 425 426 427 428 429 430 431 432 433 434 435 436 437 438 439 440 441 442 443 444 445 446 447 448 449 450 451 452 453 454 455 456 457 458 459 460 461 462 463 464 465 466 467 468 469 470 481 482 483 484 485 486 487 488 489 490 491 493 494 495 496 497 498 499 520 521 522 523 524 525 526 527 528 529 530 531 532 533 534 535 536 537 538 539 550 551 552 553 554 575 576 577 578 579 580 581 582 583 584 585 586 587 588 589 610 621 622 623 624 625 626 627 628 629 630 631 632 633 634 635 636 637 638 639 640 641 642 643 644 645 646 647 648 649 650 651 652 653 654 655 656 657 658 659 700 701 702 703 704 705 706 707 708 709 710 711 712 713 714 715 716 717 718 719 720 721 722 723 724 725 726 727 728 729 730 731 732 733 734 735 736 737 738 739 740 741 742 743 744 745 746 747 748 749 750 751 760 761 763 764 765 766 770 775 780 781 782 783 784 785 786 787 788 789 790 791 792 793 794 795 796 797 798 799 810 811 812 820 821 822 823 824 825 830 833 840 841 850 851 852 853 855 856 860 861 862 863 864 865 870 890 895 896 901 910 911 913 914 915 916 917 925 926 927 929 930 931 932 933 934 935 936 937 938 940 941 950 951 952 953 954 955 960 961 962 963 964 965 966 970 971 972 974 975 976 977 978 979 990 991 995 996 998', '\s')"/>
  <let name="clUNCL1001-inv" value="tokenize('80 82 84 380 383 386 393 395 575 623 780', '\s')"/>
  <let name="clUNCL1153" value="tokenize('AAA AAB AAC AAD AAE AAF AAG AAH AAI AAJ AAK AAL AAM AAN AAO AAP AAQ AAR AAS AAT AAU AAV AAW AAX AAY AAZ ABA ABB ABC ABD ABE ABF ABG ABH ABI ABJ ABK ABL ABM ABN ABO ABP ABQ ABR ABS ABT ABU ABV ABW ABX ABY ABZ AC ACA ACB ACC ACD ACE ACF ACG ACH ACI ACJ ACK ACL ACN ACO ACP ACQ ACR ACT ACU ACV ACW ACX ACY ACZ ADA ADB ADC ADD ADE ADF ADG ADI ADJ ADK ADL ADM ADN ADO ADP ADQ ADT ADU ADV ADW ADX ADY ADZ AE AEA AEB AEC AED AEE AEF AEG AEH AEI AEJ AEK AEL AEM AEN AEO AEP AEQ AER AES AET AEU AEV AEW AEX AEY AEZ AF AFA AFB AFC AFD AFE AFF AFG AFH AFI AFJ AFK AFL AFM AFN AFO AFP AFQ AFR AFS AFT AFU AFV AFW AFX AFY AFZ AGA AGB AGC AGD AGE AGF AGG AGH AGI AGJ AGK AGL AGM AGN AGO AGP AGQ AGR AGS AGT AGU AGV AGW AGX AGY AGZ AHA AHB AHC AHD AHE AHF AHG AHH AHI AHJ AHK AHL AHM AHN AHO AHP AHQ AHR AHS AHT AHU AHV AHX AHY AHZ AIA AIB AIC AID AIE AIF AIG AIH AII AIJ AIK AIL AIM AIN AIO AIP AIQ AIR AIS AIT AIU AIV AIW AIX AIY AIZ AJA AJB AJC AJD AJE AJF AJG AJH AJI AJJ AJK AJL AJM AJN AJO AJP AJQ AJR AJS AJT AJU AJV AJW AJX AJY AJZ AKA AKB AKC AKD AKE AKF AKG AKH AKI AKJ AKK AKL AKM AKN AKO AKP AKQ AKR AKS AKT AKU AKV AKW AKX AKY AKZ ALA ALB ALC ALD ALE ALF ALG ALH ALI ALJ ALK ALL ALM ALN ALO ALP ALQ ALR ALS ALT ALU ALV ALW ALX ALY ALZ AMA AMB AMC AMD AME AMF AMG AMH AMI AMJ AMK AML AMM AMN AMO AMP AMQ AMR AMS AMT AMU AMV AMW AMX AMY AMZ ANA ANB ANC AND ANE ANF ANG ANH ANI ANJ ANK ANL ANM ANN ANO ANP ANQ ANR ANS ANT ANU ANV ANW ANX ANY AOA AOD AOE AOF AOG AOH AOI AOJ AOK AOL AOM AON AOO AOP AOQ AOR AOS AOT AOU AOV AOW AOX AOY AOZ AP APA APB APC APD APE APF APG APH API APJ APK APL APM APN APO APP APQ APR APS APT APU APV APW APX APY APZ AQA AQB AQC AQD AQE AQF AQG AQH AQI AQJ AQK AQL AQM AQN AQO AQP AQQ AQR AQS AQT AQU AQV AQW AQX AQY AQZ ARA ARB ARC ARD ARE ARF ARG ARH ARI ARJ ARK ARL ARM ARN ARO ARP ARQ ARR ARS ART ARU ARV ARW ARX ARY ARZ ASA ASB ASC ASD ASE ASF ASG ASH ASI ASJ ASK ASL ASM ASN ASO ASP ASQ ASR ASS AST ASU ASV ASW ASX ASY ASZ ATA ATB ATC ATD ATE ATF ATG ATH ATI ATJ ATK ATL ATM ATN ATO ATP ATQ ATR ATS ATT ATU ATV ATW ATX ATY ATZ AU AUA AUB AUC AUD AUE AUF AUG AUH AUI AUJ AUK AUL AUM AUN AUO AUP AUQ AUR AUS AUT AUU AUV AUW AUX AUY AUZ AV AVA AVB AVC AVD AVE AVF AVG AVH AVI AVJ AVK AVL AVM AVN AVO AVP AVQ AVR AVS AVT AVU AVV AVW AVX AVY AVZ AWA AWB AWC AWD AWE AWF AWG AWH AWI AWJ AWK AWL AWM AWN AWO AWP AWQ AWR AWS AWT AWU AWV AWW AWX AWY AWZ AXA AXB AXC AXD AXE AXF AXG AXH AXI AXJ AXK AXL AXM AXN AXO AXP AXQ AXR AXS BA BC BD BE BH BM BN BO BR BT BTP BW CAS CAT CAU CAV CAW CAX CAY CAZ CBA CBB CD CEC CED CFE CFF CFO CG CH CK CKN CM CMR CN CNO COF CP CR CRN CS CST CT CU CV CW CZ DA DAN DB DI DL DM DQ DR EA EB ED EE EEP EI EN EQ ER ERN ET EX FC FF FI FLW FN FO FS FT FV FX GA GC GD GDN GN HS HWB IA IB ICA ICE ICO II IL INB INN INO IP IS IT IV JB JE LA LAN LAR LB LC LI LO LRC LS MA MB MF MG MH MR MRN MS MSS MWB NA NF OH OI true OP OR PB PC PD PE PF PI PK PL POR PP PQ PR PS PW PY RA RC RCN RE REN RF RR RT SA SB SD SE SEA SF SH SI SM SN SP SQ SRN SS STA SW SZ TB TCR TE TF TI TIN TL TN TP UAR UC UCN UN UO URI VA VC VGR VM VN VON VOR VP VR VS VT VV WE WM WN WR WS WY XA XC XP ZZZ', '\s')"/>
  <let name="clUNCL2005" value="tokenize('3 35 432', '\s')"/>
  <let name="clUNCL4461" value="tokenize('1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41 42 43 44 45 46 47 48 49 50 51 52 53 54 55 56 57 58 59 60 61 62 63 64 65 66 67 68 70 74 75 76 77 78 91 92 93 94 95 96 97 ZZZ Z01 Z02', '\s')"/>
  <let name="clUNCL5189" value="tokenize('41 42 60 62 63 64 65 66 67 68 70 71 88 95 100 102 103 104 105', '\s')"/>
  <let name="clUNCL5305" value="tokenize('AA E G O S', '\s')"/>
  <let name="clUNCL7143" value="tokenize('AA AB AC AD AE AF AG AH AI AJ AK AL AM AN AO AP AQ AR AS AT AU AV AW AX AY AZ BA BB BC BD BE BF BG BH BI BJ BK BL BM BN BO BP BQ BR BS BT BU BV BW BX BY BZ CC CG CL CR CV DR DW EC EF EN FS GB GN GS HS IB IN IS IT IZ MA MF MN MP NB true PD PL PO PV QS RC RN RU RY SA SG SK SN SRS SRT SRU SRV SRW SRX SRY SRZ SS SSA SSB SSC SSD SSE SSF SSG SSH SSI SSJ SSK SSL SSM SSN SSO SSP SSQ SSR SSS SST SSU SSV SSW SSX SSY SSZ ST STA STB STC STD STE STF STG STH STI STJ STK STL STM STN STO STP STQ STR STS STT STU STV STW STX STY STZ SUA SUB SUC SUD SUE SUF SUG SUH SUI SUJ SUK SUL SUM TG TSN TSO TSP TSP TSQ TSR TSS TST TSU UA UP VN VP VS VX ZZZ', '\s')"/>
  <let name="clUNCL7161" value="tokenize('AA AAA AAC AAD AAE AAF AAH AAI AAS AAT AAV AAY AAZ ABA ABB ABC ABD ABF ABK ABL ABN ABR ABS ABT ABU ACF ACG ACH ACI ACJ ACK ACL ACM ACS ADC ADE ADJ ADK ADL ADM ADN ADO ADP ADQ ADR ADT ADW ADY ADZ AEA AEB AEC AED AEF AEH AEI AEJ AEK AEL AEM AEN AEO AEP AES AET AEU AEV AEW AEX AEY AEZ AJ AU CA CAB CAD CAE CAF CAI CAJ CAK CAL CAM CAN CAO CAP CAQ CAR CAS CAT CAU CAV CAW CAX CAY CAZ CD CG CS CT DAB DAC DAD DAF DAG DAH DAI DAJ DAK DAL DAM DAN DAO DAP DAQ DL EG EP ER FAA FAB FAC FC FH FI GAA HAA HD HH IAA IAB ID IF IR IS KO L1 LA LAA LAB LF MAE MI ML NAA OA PA PAA PC PL RAB RAC RAD RAF RE RF RH RV SA SAA SAD SAE SAI SG SH SM SU TAB TAC TT TV V1 V2 WH XAA YY ZZZ', '\s')"/>
  <let name="clUNECERec20" value="tokenize('10 11 13 14 15 20 21 22 23 24 25 27 28 33 34 35 37 38 40 41 56 57 58 59 60 61 74 77 80 81 85 87 89 91 1I 2A 2B 2C 2G 2H 2I 2J 2K 2L 2M 2N 2P 2Q 2R 2U 2X 2Y 2Z 3B 3C 4C 4G 4H 4K 4L 4M 4N 4O 4P 4Q 4R 4T 4U 4W 4X 5A 5B 5E 5J A10 A11 A12 A13 A14 A15 A16 A17 A18 A19 A2 A20 A21 A22 A23 A24 A26 A27 A28 A29 A3 A30 A31 A32 A33 A34 A35 A36 A37 A38 A39 A4 A40 A41 A42 A43 A44 A45 A47 A48 A49 A5 A53 A54 A55 A56 A59 A6 A68 A69 A7 A70 A71 A73 A74 A75 A76 A8 A84 A85 A86 A87 A88 A89 A9 A90 A91 A93 A94 A95 A96 A97 A98 A99 AA AB ACR ACT AD AE AH AI AK AL AMH AMP ANN APZ AQ AS ASM ASU ATM AWG AY AZ B1 B10 B11 B12 B13 B14 B15 B16 B17 B18 B19 B20 B21 B22 B23 B24 B25 B26 B27 B28 B29 B3 B30 B31 B32 B33 B34 B35 B4 B41 B42 B43 B44 B45 B46 B47 B48 B49 B50 B52 B53 B54 B55 B56 B57 B58 B59 B60 B61 B62 B63 B64 B66 B67 B68 B69 B7 B70 B71 B72 B73 B74 B75 B76 B77 B78 B79 B8 B80 B81 B82 B83 B84 B85 B86 B87 B88 B89 B90 B91 B92 B93 B94 B95 B96 B97 B98 B99 BAR BB BFT BHP BIL BLD BLL BP BPM BQL BTU BUA BUI C0 C10 C11 C12 C13 C14 C15 C16 C17 C18 C19 C20 C21 C22 C23 C24 C25 C26 C27 C28 C29 C3 C30 C31 C32 C33 C34 C35 C36 C37 C38 C39 C40 C41 C42 C43 C44 C45 C46 C47 C48 C49 C50 C51 C52 C53 C54 C55 C56 C57 C58 C59 C60 C61 C62 C63 C64 C65 C66 C67 C68 C69 C7 C70 C71 C72 C73 C74 C75 C76 C78 C79 C8 C80 C81 C82 C83 C84 C85 C86 C87 C88 C89 C9 C90 C91 C92 C93 C94 C95 C96 C97 C99 CCT CDL CEL CEN CG CGM CKG CLF CLT CMK CMQ CMT CNP CNT COU CTG CTM CTN CUR CWA CWI D03 D04 D1 D10 D11 D12 D13 D15 D16 D17 D18 D19 D2 D20 D21 D22 D23 D24 D25 D26 D27 D29 D30 D31 D32 D33 D34 D36 D41 D42 D43 D44 D45 D46 D47 D48 D49 D5 D50 D51 D52 D53 D54 D55 D56 D57 D58 D59 D6 D60 D61 D62 D63 D65 D68 D69 D73 D74 D77 D78 D80 D81 D82 D83 D85 D86 D87 D88 D89 D91 D93 D94 D95 DAA DAD DAY DB DBM DBW DD DEC DG DJ DLT DMA DMK DMO DMQ DMT DN DPC DPR DPT DRA DRI DRL DT DTN DWT DZN DZP E01 E07 E08 E09 E10 E12 E14 E15 E16 E17 E18 E19 E20 E21 E22 E23 E25 E27 E28 E30 E31 E32 E33 E34 E35 E36 E37 E38 E39 E4 E40 E41 E42 E43 E44 E45 E46 E47 E48 E49 E50 E51 E52 E53 E54 E55 E56 E57 E58 E59 E60 E61 E62 E63 E64 E65 E66 E67 E68 E69 E70 E71 E72 E73 E74 E75 E76 E77 E78 E79 E80 E81 E82 E83 E84 E85 E86 E87 E88 E89 E90 E91 E92 E93 E94 E95 E96 E97 E98 E99 EA EB EQ F01 F02 F03 F04 F05 F06 F07 F08 F10 F11 F12 F13 F14 F15 F16 F17 F18 F19 F20 F21 F22 F23 F24 F25 F26 F27 F28 F29 F30 F31 F32 F33 F34 F35 F36 F37 F38 F39 F40 F41 F42 F43 F44 F45 F46 F47 F48 F49 F50 F51 F52 F53 F54 F55 F56 F57 F58 F59 F60 F61 F62 F63 F64 F65 F66 F67 F68 F69 F70 F71 F72 F73 F74 F75 F76 F77 F78 F79 F80 F81 F82 F83 F84 F85 F86 F87 F88 F89 F90 F91 F92 F93 F94 F95 F96 F97 F98 F99 FAH FAR FBM FC FF FH FIT FL FNU FOT FP FR FS FTK FTQ G01 G04 G05 G06 G08 G09 G10 G11 G12 G13 G14 G15 G16 G17 G18 G19 G2 G20 G21 G23 G24 G25 G26 G27 G28 G29 G3 G30 G31 G32 G33 G34 G35 G36 G37 G38 G39 G40 G41 G42 G43 G44 G45 G46 G47 G48 G49 G50 G51 G52 G53 G54 G55 G56 G57 G58 G59 G60 G61 G62 G63 G64 G65 G66 G67 G68 G69 G70 G71 G72 G73 G74 G75 G76 G77 G78 G79 G80 G81 G82 G83 G84 G85 G86 G87 G88 G89 G90 G91 G92 G93 G94 G95 G96 G97 G98 G99 GB GBQ GDW GE GF GFI GGR GIA GIC GII GIP GJ GL GLD GLI GLL GM GO GP GQ GRM GRN GRO GV GWH H03 H04 H05 H06 H07 H08 H09 H10 H11 H12 H13 H14 H15 H16 H18 H19 H20 H21 H22 H23 H24 H25 H26 H27 H28 H29 H30 H31 H32 H33 H34 H35 H36 H37 H38 H39 H40 H41 H42 H43 H44 H45 H46 H47 H48 H49 H50 H51 H52 H53 H54 H55 H56 H57 H58 H59 H60 H61 H62 H63 H64 H65 H66 H67 H68 H69 H70 H71 H72 H73 H74 H75 H76 H77 H79 H80 H81 H82 H83 H84 H85 H87 H88 H89 H90 H91 H92 H93 H94 H95 H96 H98 H99 HA HAD HBA HBX HC HDW HEA HGM HH HIU HKM HLT HM HMO HMQ HMT HPA HTZ HUR HWE IA IE INH INK INQ ISD IU IV J10 J12 J13 J14 J15 J16 J17 J18 J19 J2 J20 J21 J22 J23 J24 J25 J26 J27 J28 J29 J30 J31 J32 J33 J34 J35 J36 J38 J39 J40 J41 J42 J43 J44 J45 J46 J47 J48 J49 J50 J51 J52 J53 J54 J55 J56 J57 J58 J59 J60 J61 J62 J63 J64 J65 J66 J67 J68 J69 J70 J71 J72 J73 J74 J75 J76 J78 J79 J81 J82 J83 J84 J85 J87 J90 J91 J92 J93 J95 J96 J97 J98 J99 JE JK JM JNT JOU JPS JWL K1 K10 K11 K12 K13 K14 K15 K16 K17 K18 K19 K2 K20 K21 K22 K23 K26 K27 K28 K3 K30 K31 K32 K33 K34 K35 K36 K37 K38 K39 K40 K41 K42 K43 K45 K46 K47 K48 K49 K50 K51 K52 K53 K54 K55 K58 K59 K6 K60 K61 K62 K63 K64 K65 K66 K67 K68 K69 K70 K71 K73 K74 K75 K76 K77 K78 K79 K80 K81 K82 K83 K84 K85 K86 K87 K88 K89 K90 K91 K92 K93 K94 K95 K96 K97 K98 K99 KA KAT KB KBA KCC KDW KEL KGM KGS KHY KHZ KI KIC KIP KJ KJO KL KLK KLX KMA KMH KMK KMQ KMT KNI KNM KNS KNT KO KPA KPH KPO KPP KR KSD KSH KT KTN KUR KVA KVR KVT KW KWH KWO KWT KWY KX L10 L11 L12 L13 L14 L15 L16 L17 L18 L19 L2 L20 L21 L23 L24 L25 L26 L27 L28 L29 L30 L31 L32 L33 L34 L35 L36 L37 L38 L39 L40 L41 L42 L43 L44 L45 L46 L47 L48 L49 L50 L51 L52 L53 L54 L55 L56 L57 L58 L59 L60 L63 L64 L65 L66 L67 L68 L69 L70 L71 L72 L73 L74 L75 L76 L77 L78 L79 L80 L81 L82 L83 L84 L85 L86 L87 L88 L89 L90 L91 L92 L93 L94 L95 L96 L98 L99 LA LAC LBR LBT LD LEF LF LH LK LM LN LO LP LPA LR LS LTN LTR LUB LUM LUX LY M1 M10 M11 M12 M13 M14 M15 M16 M17 M18 M19 M20 M21 M22 M23 M24 M25 M26 M27 M29 M30 M31 M32 M33 M34 M35 M36 M37 M38 M39 M4 M40 M41 M42 M43 M44 M45 M46 M47 M48 M49 M5 M50 M51 M52 M53 M55 M56 M57 M58 M59 M60 M61 M62 M63 M64 M65 M66 M67 M68 M69 M7 M70 M71 M72 M73 M74 M75 M76 M77 M78 M79 M80 M81 M82 M83 M84 M85 M86 M87 M88 M89 M9 M90 M91 M92 M93 M94 M95 M96 M97 M98 M99 MAH MAL MAM MAR MAW MBE MBF MBR MC MCU MD MGM MHZ MIK MIL MIN MIO MIU MKD MKM MKW MLD MLT MMK MMQ MMT MND MNJ MON MPA MQD MQH MQM MQS MQW MRD MRM MRW MSK MTK MTQ MTR MTS MTZ MVA MWH N1 N10 N11 N12 N13 N14 N15 N16 N17 N18 N19 N20 N21 N22 N23 N24 N25 N26 N27 N28 N29 N3 N30 N31 N32 N33 N34 N35 N36 N37 N38 N39 N40 N41 N42 N43 N44 N45 N46 N47 N48 N49 N50 N51 N52 N53 N54 N55 N56 N57 N58 N59 N60 N61 N62 N63 N64 N65 N66 N67 N68 N69 N70 N71 N72 N73 N74 N75 N76 N77 N78 N79 N80 N81 N82 N83 N84 N85 N86 N87 N88 N89 N90 N91 N92 N93 N94 N95 N96 N97 N98 N99 NA NAR NCL NEW NF NIL NIU NL NM3 NMI NMP NPT NT NTU NU NX OA ODE OHM true ONZ OPM OT OZA OZI P1 P10 P11 P12 P13 P14 P15 P16 P17 P18 P19 P2 P20 P21 P22 P23 P24 P25 P26 P27 P28 P29 P30 P31 P32 P33 P34 P35 P36 P37 P38 P39 P40 P41 P42 P43 P44 P45 P46 P47 P48 P49 P5 P50 P51 P52 P53 P54 P55 P56 P57 P58 P59 P60 P61 P62 P63 P64 P65 P66 P67 P68 P69 P70 P71 P72 P73 P74 P75 P76 P77 P78 P79 P80 P81 P82 P83 P84 P85 P86 P87 P88 P89 P90 P91 P92 P93 P94 P95 P96 P97 P98 P99 PAL PD PFL PGL PI PLA PO PQ PR PS PTD PTI PTL PTN Q10 Q11 Q12 Q13 Q14 Q15 Q16 Q17 Q18 Q19 Q20 Q21 Q22 Q23 Q24 Q25 Q26 Q27 Q28 Q29 Q30 Q31 Q32 Q33 Q34 Q35 Q36 Q37 Q38 Q39 Q40 Q3 QA QAN QB QR QTD QTI QTL QTR R1 R9 RH RM ROM RP RPM RPS RT S3 S4 SAN SCO SCR SEC SET SG SIE SM3 SMI SQ SQR SR STC STI STK STL STN STW SW SX SYR T0 T3 TAH TAN TI TIC TIP TKM TMS TNE TP TPI TPR TQD TRL TST TTS U1 U2 UB UC VA VLT VP W2 WA WB WCD WE WEB WEE WG WHR WM WSD WTT X1 YDK YDQ YRD Z11 Z9 ZP ZZ X1A X1B X1D X1F X1G X1W X2C X3A X3H X43 X44 X4A X4B X4C X4D X4F X4G X4H X5H X5L X5M X6H X6P X7A X7B X8A X8B X8C XAA XAB XAC XAD XAE XAF XAG XAH XAI XAJ XAL XAM XAP XAT XAV XB4 XBA XBB XBC XBD XBE XBF XBG XBH XBI XBJ XBK XBL XBM XBN XBO XBP XBQ XBR XBS XBT XBU XBV XBW XBX XBY XBZ XCA XCB XCC XCD XCE XCF XCG XCH XCI XCJ XCK XCL XCM XCN XCO XCP XCQ XCR XCS XCT XCU XCV XCW XCX XCY XCZ XDA XDB XDC XDG XDH XDI XDJ XDK XDL XDM XDN XDP XDR XDS XDT XDU XDV XDW XDX XDY XEC XED XEE XEF XEG XEH XEI XEN XFB XFC XFD XFE XFI XFL XFO XFP XFR XFT XFW XFX XGB XGI XGL XGR XGU XGY XGZ XHA XHB XHC XHG XHN XHR XIA XIB XIC XID XIE XIF XIG XIH XIK XIL XIN XIZ XJB XJC XJG XJR XJT XJY XKG XKI XLE XLG XLT XLU XLV XLZ XMA XMB XMC XME XMR XMS XMT XMW XMX XNA XNE XNF XNG XNS XNT XNU XNV XO1 XO2 XO3 XO4 XO5 XO6 XO7 XO8 XO9 XOA XOB XOC XOD XOE XOF XOG XOH XOI XOK XOJ XOL XOM XON XOP XOQ XOR XOS XOV XOW XOT XOU XOX XOY XOZ XP1 XP2 XP3 XP4 XPA XPB XPC XPD XPE XPF XPG XPH XPI XPJ XPK XPL XPN XPO XPP XPR XPT XPU XPV XPX XPY XPZ XQA XQB XQC XQD XQF XQG XQH XQJ XQK XQL XQM XQN XQP XQQ XQR XQS XRD XRG XRJ XRK XRL XRO XRT XRZ XSA XSB XSC XSD XSE XSH XSI XSK XSL XSM XSO XSP XSS XST XSU XSV XSW XSX XSY XSZ XT1 XTB XTC XTD XTE XTG XTI XTK XTL XTN XTO XTR XTS XTT XTU XTV XTW XTY XTZ XUC XUN XVA XVG XVI XVK XVL XVO XVP XVQ XVN XVR XVS XVY XWA XWB XWC XWD XWF XWG XWH XWJ XWK XWL XWM XWN XWP XWQ XWR XWS XWT XWU XWV XWW XWX XWY XWZ XXA XXB XXC XXD XXF XXG XXH XXJ XXK XYA XYB XYC XYD XYF XYG XYH XYJ XYK XYL XYM XYN XYP XYQ XYR XYS XYT XYV XYW XYX XYY XYZ XZA XZB XZC XZD XZF XZG XZH XZJ XZK XZL XZM XZN XZP XZQ XZR XZS XZT XZU XZV XZW XZX XZY', '\s')"/>
  <let name="cleas" value="tokenize('0002 0007 0009 0037 0060 0088 0096 0097 0106 0130 0135 0142 0151 0183 0184 0190 0191 0192 0193 0195 0196 0198 0199 0200 0201 0202 0204 0208 0209 0210 0211 0212 0213 9901 9906 9907 9910 9913 9914 9915 9918 9919 9920 9922 9923 9924 9925 9926 9927 9928 9929 9930 9931 9932 9933 9934 9935 9936 9937 9938 9939 9940 9941 9942 9943 9944 9945 9946 9947 9948 9949 9950 9951 9952 9953 9955 9957', '\s')"/>
  <rule context="ubl:Invoice">
    <assert flag="fatal" id="BASIC-00001" test="cbc:CustomizationID[1] and not(cbc:CustomizationID[2])">A single instance of cbc:CustomizationID is mandatory.</assert>
    <assert flag="fatal" id="BASIC-00002" test="cbc:ProfileID[1] and not(cbc:ProfileID[2])">A single instance of cbc:ProfileID is mandatory.</assert>
    <assert flag="fatal" id="BASIC-00003" test="cbc:ID[1] and not(cbc:ID[2])">A single instance of cbc:ID is mandatory.</assert>
    <assert flag="fatal" id="BASIC-00004" test="cbc:IssueDate[1] and not(cbc:IssueDate[2])">A single instance of cbc:IssueDate is mandatory.</assert>
    <assert flag="fatal" id="BASIC-00005" test="not(cbc:IssueTime[2])">No more than a single instance of cbc:IssueTime are allowed.</assert>
    <assert flag="fatal" id="BASIC-00006" test="not(cbc:DueDate[2])">No more than a single instance of cbc:DueDate are allowed.</assert>
    <assert flag="fatal" id="BASIC-00007" test="cbc:InvoiceTypeCode[1] and not(cbc:InvoiceTypeCode[2])">A single instance of cbc:InvoiceTypeCode is mandatory.</assert>
    <assert flag="fatal" id="BASIC-00008" test="not(cbc:Note[2])">No more than a single instance of cbc:Note are allowed.</assert>
    <assert flag="fatal" id="BASIC-00009" test="not(cbc:Note[2])">No more than a single instance of cbc:Note are allowed.</assert>
    <assert flag="fatal" id="BASIC-00010" test="not(cbc:TaxPointDate[2])">No more than a single instance of cbc:TaxPointDate are allowed.</assert>
    <assert flag="fatal" id="BASIC-00011" test="cbc:DocumentCurrencyCode[1] and not(cbc:DocumentCurrencyCode[2])">A single instance of cbc:DocumentCurrencyCode is mandatory.</assert>
    <assert flag="fatal" id="BASIC-00012" test="not(cbc:TaxCurrencyCode[2])">No more than a single instance of cbc:TaxCurrencyCode are allowed.</assert>
    <assert flag="fatal" id="BASIC-00013" test="not(cbc:AccountingCost[2])">No more than a single instance of cbc:AccountingCost are allowed.</assert>
    <assert flag="fatal" id="BASIC-00014" test="not(cbc:BuyerReference[2])">No more than a single instance of cbc:BuyerReference are allowed.</assert>
    <assert flag="fatal" id="BASIC-00015" test="not(cac:InvoicePeriod[2])">No more than a single instance of cac:InvoicePeriod are allowed.</assert>
    <assert flag="fatal" id="BASIC-00016" test="not(cac:OrderReference[2])">No more than a single instance of cac:OrderReference are allowed.</assert>
    <assert flag="fatal" id="BASIC-00017" test="not(cac:ReceiptDocumentReference[2])">No more than a single instance of cac:ReceiptDocumentReference are allowed.</assert>
    <assert flag="fatal" id="BASIC-00018" test="not(cac:OriginatorDocumentReference[2])">No more than a single instance of cac:OriginatorDocumentReference are allowed.</assert>
    <assert flag="fatal" id="BASIC-00019" test="not(cac:ContractDocumentReference[2])">No more than a single instance of cac:ContractDocumentReference are allowed.</assert>
    <assert flag="fatal" id="BASIC-00020" test="not(cac:ProjectReference[2])">No more than a single instance of cac:ProjectReference are allowed.</assert>
    <assert flag="fatal" id="BASIC-00021" test="cac:AccountingSupplierParty[1] and not(cac:AccountingSupplierParty[2])">A single instance of cac:AccountingSupplierParty is mandatory.</assert>
    <assert flag="fatal" id="BASIC-00022" test="cac:AccountingCustomerParty[1] and not(cac:AccountingCustomerParty[2])">A single instance of cac:AccountingCustomerParty is mandatory.</assert>
    <assert flag="fatal" id="BASIC-00023" test="not(cac:PayeeParty[2])">No more than a single instance of cac:PayeeParty are allowed.</assert>
    <assert flag="fatal" id="BASIC-00024" test="cac:TaxRepresentativeParty[1] and not(cac:TaxRepresentativeParty[2])">A single instance of cac:TaxRepresentativeParty is mandatory.</assert>
    <assert flag="fatal" id="BASIC-00025" test="not(cac:Delivery[2])">No more than a single instance of cac:Delivery are allowed.</assert>
    <assert flag="fatal" id="BASIC-00026" test="cac:TaxTotal[1] and not(cac:TaxTotal[2])">A single instance of cac:TaxTotal is mandatory.</assert>
    <assert flag="fatal" id="BASIC-00027" test="cac:LegalMonetaryTotal[1] and not(cac:LegalMonetaryTotal[2])">A single instance of cac:LegalMonetaryTotal is mandatory.</assert>
    <assert flag="fatal" id="BASIC-00028" test="cac:InvoiceLine[1]">Minimum one instance of cac:InvoiceLine is mandatory.</assert>
  </rule>
  <rule context="ubl:Invoice/cbc:CustomizationID"/>
  <rule context="ubl:Invoice/cbc:ProfileID"/>
  <rule context="ubl:Invoice/cbc:ID"/>
  <rule context="ubl:Invoice/cbc:IssueDate"/>
  <rule context="ubl:Invoice/cbc:IssueTime"/>
  <rule context="ubl:Invoice/cbc:DueDate"/>
  <rule context="ubl:Invoice/cbc:InvoiceTypeCode">
    <assert flag="fatal" id="BASIC-00029" test="(some $code in $clUNCL1001-inv satisfies $code = normalize-space())">This element must have value from codelist UNCL1001-inv.</assert>
  </rule>
  <rule context="ubl:Invoice/cbc:Note"/>
  <rule context="ubl:Invoice/cbc:Note"/>
  <rule context="ubl:Invoice/cbc:TaxPointDate"/>
  <rule context="ubl:Invoice/cbc:DocumentCurrencyCode">
    <assert flag="fatal" id="BASIC-00030" test="(some $code in $clISO4217 satisfies $code = normalize-space())">This element must have value from codelist ISO4217.</assert>
  </rule>
  <rule context="ubl:Invoice/cbc:TaxCurrencyCode">
    <assert flag="fatal" id="BASIC-00031" test="(some $code in $clISO4217 satisfies $code = normalize-space())">This element must have value from codelist ISO4217.</assert>
  </rule>
  <rule context="ubl:Invoice/cbc:AccountingCost"/>
  <rule context="ubl:Invoice/cbc:BuyerReference"/>
  <rule context="ubl:Invoice/cac:InvoicePeriod">
    <assert flag="fatal" id="BASIC-00032" test="not(cbc:StartDate[2])">No more than a single instance of cbc:StartDate are allowed.</assert>
    <assert flag="fatal" id="BASIC-00033" test="not(cbc:EndDate[2])">No more than a single instance of cbc:EndDate are allowed.</assert>
    <assert flag="fatal" id="BASIC-00034" test="not(cbc:DescriptionCode[2])">No more than a single instance of cbc:DescriptionCode are allowed.</assert>
  </rule>
  <rule context="ubl:Invoice/cac:InvoicePeriod/cbc:StartDate"/>
  <rule context="ubl:Invoice/cac:InvoicePeriod/cbc:EndDate"/>
  <rule context="ubl:Invoice/cac:InvoicePeriod/cbc:DescriptionCode">
    <assert flag="fatal" id="BASIC-00035" test="(some $code in $clUNCL2005 satisfies $code = normalize-space())">This element must have value from codelist UNCL2005.</assert>
  </rule>
  <rule context="ubl:Invoice/cac:OrderReference">
    <assert flag="fatal" id="BASIC-00036" test="cbc:ID[1] and not(cbc:ID[2])">A single instance of cbc:ID is mandatory.</assert>
    <assert flag="fatal" id="BASIC-00037" test="not(cbc:SalesOrderID[2])">No more than a single instance of cbc:SalesOrderID are allowed.</assert>
  </rule>
  <rule context="ubl:Invoice/cac:OrderReference/cbc:ID"/>
  <rule context="ubl:Invoice/cac:OrderReference/cbc:SalesOrderID"/>
  <rule context="ubl:Invoice/cac:BillingReference">
    <assert flag="fatal" id="BASIC-00038" test="cac:InvoiceDocumentReference[1] and not(cac:InvoiceDocumentReference[2])">A single instance of cac:InvoiceDocumentReference is mandatory.</assert>
  </rule>
  <rule context="ubl:Invoice/cac:BillingReference/cac:InvoiceDocumentReference">
    <assert flag="fatal" id="BASIC-00039" test="cbc:ID[1] and not(cbc:ID[2])">A single instance of cbc:ID is mandatory.</assert>
    <assert flag="fatal" id="BASIC-00040" test="not(cbc:IssueDate[2])">No more than a single instance of cbc:IssueDate are allowed.</assert>
  </rule>
  <rule context="ubl:Invoice/cac:BillingReference/cac:InvoiceDocumentReference/cbc:ID"/>
  <rule context="ubl:Invoice/cac:BillingReference/cac:InvoiceDocumentReference/cbc:IssueDate"/>
  <rule context="ubl:Invoice/cac:DespatchDocumentReference">
    <assert flag="fatal" id="BASIC-00041" test="cbc:ID[1] and not(cbc:ID[2])">A single instance of cbc:ID is mandatory.</assert>
  </rule>
  <rule context="ubl:Invoice/cac:DespatchDocumentReference/cbc:ID"/>
  <rule context="ubl:Invoice/cac:ReceiptDocumentReference">
    <assert flag="fatal" id="BASIC-00042" test="cbc:ID[1] and not(cbc:ID[2])">A single instance of cbc:ID is mandatory.</assert>
  </rule>
  <rule context="ubl:Invoice/cac:ReceiptDocumentReference/cbc:ID"/>
  <rule context="ubl:Invoice/cac:OriginatorDocumentReference">
    <assert flag="fatal" id="BASIC-00043" test="cbc:ID[1] and not(cbc:ID[2])">A single instance of cbc:ID is mandatory.</assert>
  </rule>
  <rule context="ubl:Invoice/cac:OriginatorDocumentReference/cbc:ID"/>
  <rule context="ubl:Invoice/cac:ContractDocumentReference">
    <assert flag="fatal" id="BASIC-00044" test="cbc:ID[1] and not(cbc:ID[2])">A single instance of cbc:ID is mandatory.</assert>
  </rule>
  <rule context="ubl:Invoice/cac:ContractDocumentReference/cbc:ID"/>
  <rule context="ubl:Invoice/cac:AdditionalDocumentReference">
    <assert flag="fatal" id="BASIC-00045" test="cbc:ID[1] and not(cbc:ID[2])">A single instance of cbc:ID is mandatory.</assert>
    <assert flag="fatal" id="BASIC-00046" test="not(cbc:DocumentTypeCode[2])">No more than a single instance of cbc:DocumentTypeCode are allowed.</assert>
  </rule>
  <rule context="ubl:Invoice/cac:AdditionalDocumentReference/cbc:ID">
    <assert flag="fatal" id="BASIC-00047" test="not(@schemeID) or (some $code in $clUNCL1153 satisfies $code = normalize-space(@schemeID))">This attribute must have value from codelist UNCL1153.</assert>
  </rule>
  <rule context="ubl:Invoice/cac:AdditionalDocumentReference/cbc:DocumentTypeCode"/>
  <rule context="ubl:Invoice/cac:AdditionalDocumentReference">
    <assert flag="fatal" id="BASIC-00048" test="cbc:ID[1] and not(cbc:ID[2])">A single instance of cbc:ID is mandatory.</assert>
    <assert flag="fatal" id="BASIC-00049" test="not(cbc:DocumentDescription[2])">No more than a single instance of cbc:DocumentDescription are allowed.</assert>
    <assert flag="fatal" id="BASIC-00050" test="not(cac:Attachment[2])">No more than a single instance of cac:Attachment are allowed.</assert>
  </rule>
  <rule context="ubl:Invoice/cac:AdditionalDocumentReference/cbc:ID"/>
  <rule context="ubl:Invoice/cac:AdditionalDocumentReference/cbc:DocumentDescription"/>
  <rule context="ubl:Invoice/cac:AdditionalDocumentReference/cac:Attachment">
    <assert flag="fatal" id="BASIC-00051" test="not(cbc:EmbeddedDocumentBinaryObject[2])">No more than a single instance of cbc:EmbeddedDocumentBinaryObject are allowed.</assert>
    <assert flag="fatal" id="BASIC-00052" test="not(cac:ExternalReference[2])">No more than a single instance of cac:ExternalReference are allowed.</assert>
  </rule>
  <rule context="ubl:Invoice/cac:AdditionalDocumentReference/cac:Attachment/cbc:EmbeddedDocumentBinaryObject">
    <assert flag="fatal" id="BASIC-00053" test="not(@mimeCode) or (some $code in $clMimeCode satisfies $code = normalize-space(@mimeCode))">This attribute must have value from codelist MimeCode.</assert>
  </rule>
  <rule context="ubl:Invoice/cac:AdditionalDocumentReference/cac:Attachment/cac:ExternalReference">
    <assert flag="fatal" id="BASIC-00054" test="cbc:URI[1] and not(cbc:URI[2])">A single instance of cbc:URI is mandatory.</assert>
  </rule>
  <rule context="ubl:Invoice/cac:AdditionalDocumentReference/cac:Attachment/cac:ExternalReference/cbc:URI"/>
  <rule context="ubl:Invoice/cac:ProjectReference">
    <assert flag="fatal" id="BASIC-00055" test="cbc:ID[1] and not(cbc:ID[2])">A single instance of cbc:ID is mandatory.</assert>
  </rule>
  <rule context="ubl:Invoice/cac:ProjectReference/cbc:ID"/>
  <rule context="ubl:Invoice/cac:AccountingSupplierParty">
    <assert flag="fatal" id="BASIC-00056" test="cac:Party[1] and not(cac:Party[2])">A single instance of cac:Party is mandatory.</assert>
  </rule>
  <rule context="ubl:Invoice/cac:AccountingSupplierParty/cac:Party">
    <assert flag="fatal" id="BASIC-00057" test="cbc:EndpointID[1] and not(cbc:EndpointID[2])">A single instance of cbc:EndpointID is mandatory.</assert>
    <assert flag="fatal" id="BASIC-00058" test="not(cac:PartyIdentification[2])">No more than a single instance of cac:PartyIdentification are allowed.</assert>
    <assert flag="fatal" id="BASIC-00059" test="not(cac:PartyName[2])">No more than a single instance of cac:PartyName are allowed.</assert>
    <assert flag="fatal" id="BASIC-00060" test="cac:PostalAddress[1] and not(cac:PostalAddress[2])">A single instance of cac:PostalAddress is mandatory.</assert>
    <assert flag="fatal" id="BASIC-00061" test="not(cac:PartyTaxScheme[2])">No more than a single instance of cac:PartyTaxScheme are allowed.</assert>
    <assert flag="fatal" id="BASIC-00062" test="not(cac:PartyTaxScheme[2])">No more than a single instance of cac:PartyTaxScheme are allowed.</assert>
    <assert flag="fatal" id="BASIC-00063" test="cac:PartyLegalEntity[1] and not(cac:PartyLegalEntity[2])">A single instance of cac:PartyLegalEntity is mandatory.</assert>
    <assert flag="fatal" id="BASIC-00064" test="not(cac:Contact[2])">No more than a single instance of cac:Contact are allowed.</assert>
  </rule>
  <rule context="ubl:Invoice/cac:AccountingSupplierParty/cac:Party/cbc:EndpointID">
    <assert flag="fatal" id="BASIC-00065" test="@schemeID">Attribute schemeID is mandatory.</assert>
    <assert flag="fatal" id="BASIC-00066" test="not(@schemeID) or (some $code in $cleas satisfies $code = normalize-space(@schemeID))">This attribute must have value from codelist eas.</assert>
  </rule>
  <rule context="ubl:Invoice/cac:AccountingSupplierParty/cac:Party/cac:PartyIdentification">
    <assert flag="fatal" id="BASIC-00067" test="cbc:ID[1] and not(cbc:ID[2])">A single instance of cbc:ID is mandatory.</assert>
  </rule>
  <rule context="ubl:Invoice/cac:AccountingSupplierParty/cac:Party/cac:PartyIdentification/cbc:ID">
    <assert flag="fatal" id="BASIC-00068" test="not(@schemeID) or (some $code in $clICD satisfies $code = normalize-space(@schemeID))">This attribute must have value from codelist ICD.</assert>
  </rule>
  <rule context="ubl:Invoice/cac:AccountingSupplierParty/cac:Party/cac:PartyIdentification">
    <assert flag="fatal" id="BASIC-00069" test="cbc:ID[1] and not(cbc:ID[2])">A single instance of cbc:ID is mandatory.</assert>
  </rule>
  <rule context="ubl:Invoice/cac:AccountingSupplierParty/cac:Party/cac:PartyIdentification/cbc:ID">
    <assert flag="fatal" id="BASIC-00070" test="not(@schemeID) or (some $code in $clSEPA satisfies $code = normalize-space(@schemeID))">This attribute must have value from codelist SEPA.</assert>
  </rule>
  <rule context="ubl:Invoice/cac:AccountingSupplierParty/cac:Party/cac:PartyName">
    <assert flag="fatal" id="BASIC-00071" test="cbc:Name[1] and not(cbc:Name[2])">A single instance of cbc:Name is mandatory.</assert>
  </rule>
  <rule context="ubl:Invoice/cac:AccountingSupplierParty/cac:Party/cac:PartyName/cbc:Name"/>
  <rule context="ubl:Invoice/cac:AccountingSupplierParty/cac:Party/cac:PostalAddress">
    <assert flag="fatal" id="BASIC-00072" test="not(cbc:StreetName[2])">No more than a single instance of cbc:StreetName are allowed.</assert>
    <assert flag="fatal" id="BASIC-00073" test="not(cbc:AdditionalStreetName[2])">No more than a single instance of cbc:AdditionalStreetName are allowed.</assert>
    <assert flag="fatal" id="BASIC-00074" test="not(cbc:CityName[2])">No more than a single instance of cbc:CityName are allowed.</assert>
    <assert flag="fatal" id="BASIC-00075" test="not(cbc:PostalZone[2])">No more than a single instance of cbc:PostalZone are allowed.</assert>
    <assert flag="fatal" id="BASIC-00076" test="not(cbc:CountrySubentity[2])">No more than a single instance of cbc:CountrySubentity are allowed.</assert>
    <assert flag="fatal" id="BASIC-00077" test="not(cac:AddressLine[2])">No more than a single instance of cac:AddressLine are allowed.</assert>
    <assert flag="fatal" id="BASIC-00078" test="cac:Country[1] and not(cac:Country[2])">A single instance of cac:Country is mandatory.</assert>
  </rule>
  <rule context="ubl:Invoice/cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cbc:StreetName"/>
  <rule context="ubl:Invoice/cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cbc:AdditionalStreetName"/>
  <rule context="ubl:Invoice/cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cbc:CityName"/>
  <rule context="ubl:Invoice/cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cbc:PostalZone"/>
  <rule context="ubl:Invoice/cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cbc:CountrySubentity"/>
  <rule context="ubl:Invoice/cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:AddressLine">
    <assert flag="fatal" id="BASIC-00079" test="cbc:Line[1] and not(cbc:Line[2])">A single instance of cbc:Line is mandatory.</assert>
  </rule>
  <rule context="ubl:Invoice/cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:AddressLine/cbc:Line"/>
  <rule context="ubl:Invoice/cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country">
    <assert flag="fatal" id="BASIC-00080" test="cbc:IdentificationCode[1] and not(cbc:IdentificationCode[2])">A single instance of cbc:IdentificationCode is mandatory.</assert>
  </rule>
  <rule context="ubl:Invoice/cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode">
    <assert flag="fatal" id="BASIC-00081" test="(some $code in $clISO3166 satisfies $code = normalize-space())">This element must have value from codelist ISO3166.</assert>
  </rule>
  <rule context="ubl:Invoice/cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme">
    <assert flag="fatal" id="BASIC-00082" test="cbc:CompanyID[1] and not(cbc:CompanyID[2])">A single instance of cbc:CompanyID is mandatory.</assert>
    <assert flag="fatal" id="BASIC-00083" test="cac:TaxScheme[1] and not(cac:TaxScheme[2])">A single instance of cac:TaxScheme is mandatory.</assert>
  </rule>
  <rule context="ubl:Invoice/cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme/cbc:CompanyID"/>
  <rule context="ubl:Invoice/cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme/cac:TaxScheme">
    <assert flag="fatal" id="BASIC-00084" test="cbc:ID[1] and not(cbc:ID[2])">A single instance of cbc:ID is mandatory.</assert>
  </rule>
  <rule context="ubl:Invoice/cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme/cac:TaxScheme/cbc:ID"/>
  <rule context="ubl:Invoice/cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme">
    <assert flag="fatal" id="BASIC-00085" test="cbc:CompanyID[1] and not(cbc:CompanyID[2])">A single instance of cbc:CompanyID is mandatory.</assert>
    <assert flag="fatal" id="BASIC-00086" test="cac:TaxScheme[1] and not(cac:TaxScheme[2])">A single instance of cac:TaxScheme is mandatory.</assert>
  </rule>
  <rule context="ubl:Invoice/cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme/cbc:CompanyID"/>
  <rule context="ubl:Invoice/cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme/cac:TaxScheme">
    <assert flag="fatal" id="BASIC-00087" test="cbc:ID[1] and not(cbc:ID[2])">A single instance of cbc:ID is mandatory.</assert>
  </rule>
  <rule context="ubl:Invoice/cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme/cac:TaxScheme/cbc:ID"/>
  <rule context="ubl:Invoice/cac:AccountingSupplierParty/cac:Party/cac:PartyLegalEntity">
    <assert flag="fatal" id="BASIC-00088" test="cbc:RegistrationName[1] and not(cbc:RegistrationName[2])">A single instance of cbc:RegistrationName is mandatory.</assert>
    <assert flag="fatal" id="BASIC-00089" test="not(cbc:CompanyID[2])">No more than a single instance of cbc:CompanyID are allowed.</assert>
    <assert flag="fatal" id="BASIC-00090" test="not(cbc:CompanyLegalForm[2])">No more than a single instance of cbc:CompanyLegalForm are allowed.</assert>
  </rule>
  <rule context="ubl:Invoice/cac:AccountingSupplierParty/cac:Party/cac:PartyLegalEntity/cbc:RegistrationName"/>
  <rule context="ubl:Invoice/cac:AccountingSupplierParty/cac:Party/cac:PartyLegalEntity/cbc:CompanyID">
    <assert flag="fatal" id="BASIC-00091" test="not(@schemeID) or (some $code in $clICD satisfies $code = normalize-space(@schemeID))">This attribute must have value from codelist ICD.</assert>
  </rule>
  <rule context="ubl:Invoice/cac:AccountingSupplierParty/cac:Party/cac:PartyLegalEntity/cbc:CompanyLegalForm"/>
  <rule context="ubl:Invoice/cac:AccountingSupplierParty/cac:Party/cac:Contact">
    <assert flag="fatal" id="BASIC-00092" test="not(cbc:Name[2])">No more than a single instance of cbc:Name are allowed.</assert>
    <assert flag="fatal" id="BASIC-00093" test="not(cbc:Telephone[2])">No more than a single instance of cbc:Telephone are allowed.</assert>
    <assert flag="fatal" id="BASIC-00094" test="not(cbc:ElectronicMail[2])">No more than a single instance of cbc:ElectronicMail are allowed.</assert>
  </rule>
  <rule context="ubl:Invoice/cac:AccountingSupplierParty/cac:Party/cac:Contact/cbc:Name"/>
  <rule context="ubl:Invoice/cac:AccountingSupplierParty/cac:Party/cac:Contact/cbc:Telephone"/>
  <rule context="ubl:Invoice/cac:AccountingSupplierParty/cac:Party/cac:Contact/cbc:ElectronicMail"/>
  <rule context="ubl:Invoice/cac:AccountingCustomerParty">
    <assert flag="fatal" id="BASIC-00095" test="cac:Party[1] and not(cac:Party[2])">A single instance of cac:Party is mandatory.</assert>
  </rule>
  <rule context="ubl:Invoice/cac:AccountingCustomerParty/cac:Party">
    <assert flag="fatal" id="BASIC-00096" test="cbc:EndpointID[1] and not(cbc:EndpointID[2])">A single instance of cbc:EndpointID is mandatory.</assert>
    <assert flag="fatal" id="BASIC-00097" test="not(cac:PartyName[2])">No more than a single instance of cac:PartyName are allowed.</assert>
    <assert flag="fatal" id="BASIC-00098" test="cac:PostalAddress[1] and not(cac:PostalAddress[2])">A single instance of cac:PostalAddress is mandatory.</assert>
    <assert flag="fatal" id="BASIC-00099" test="not(cac:PartyTaxScheme[2])">No more than a single instance of cac:PartyTaxScheme are allowed.</assert>
    <assert flag="fatal" id="BASIC-00100" test="cac:PartyLegalEntity[1] and not(cac:PartyLegalEntity[2])">A single instance of cac:PartyLegalEntity is mandatory.</assert>
  </rule>
  <rule context="ubl:Invoice/cac:AccountingCustomerParty/cac:Party/cbc:EndpointID">
    <assert flag="fatal" id="BASIC-00101" test="@schemeID">Attribute schemeID is mandatory.</assert>
    <assert flag="fatal" id="BASIC-00102" test="not(@schemeID) or (some $code in $cleas satisfies $code = normalize-space(@schemeID))">This attribute must have value from codelist eas.</assert>
  </rule>
  <rule context="ubl:Invoice/cac:AccountingCustomerParty/cac:Party/cac:PartyIdentification">
    <assert flag="fatal" id="BASIC-00103" test="cbc:ID[1] and not(cbc:ID[2])">A single instance of cbc:ID is mandatory.</assert>
  </rule>
  <rule context="ubl:Invoice/cac:AccountingCustomerParty/cac:Party/cac:PartyIdentification/cbc:ID">
    <assert flag="fatal" id="BASIC-00104" test="not(@schemeID) or (some $code in $clICD satisfies $code = normalize-space(@schemeID))">This attribute must have value from codelist ICD.</assert>
  </rule>
  <rule context="ubl:Invoice/cac:AccountingCustomerParty/cac:Party/cac:PartyName">
    <assert flag="fatal" id="BASIC-00105" test="cbc:Name[1] and not(cbc:Name[2])">A single instance of cbc:Name is mandatory.</assert>
  </rule>
  <rule context="ubl:Invoice/cac:AccountingCustomerParty/cac:Party/cac:PartyName/cbc:Name"/>
  <rule context="ubl:Invoice/cac:AccountingCustomerParty/cac:Party/cac:PostalAddress">
    <assert flag="fatal" id="BASIC-00106" test="not(cbc:StreetName[2])">No more than a single instance of cbc:StreetName are allowed.</assert>
    <assert flag="fatal" id="BASIC-00107" test="not(cbc:AdditionalStreetName[2])">No more than a single instance of cbc:AdditionalStreetName are allowed.</assert>
    <assert flag="fatal" id="BASIC-00108" test="not(cbc:CityName[2])">No more than a single instance of cbc:CityName are allowed.</assert>
    <assert flag="fatal" id="BASIC-00109" test="not(cbc:PostalZone[2])">No more than a single instance of cbc:PostalZone are allowed.</assert>
    <assert flag="fatal" id="BASIC-00110" test="not(cbc:CountrySubentity[2])">No more than a single instance of cbc:CountrySubentity are allowed.</assert>
    <assert flag="fatal" id="BASIC-00111" test="not(cac:AddressLine[2])">No more than a single instance of cac:AddressLine are allowed.</assert>
    <assert flag="fatal" id="BASIC-00112" test="cac:Country[1] and not(cac:Country[2])">A single instance of cac:Country is mandatory.</assert>
  </rule>
  <rule context="ubl:Invoice/cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cbc:StreetName"/>
  <rule context="ubl:Invoice/cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cbc:AdditionalStreetName"/>
  <rule context="ubl:Invoice/cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cbc:CityName"/>
  <rule context="ubl:Invoice/cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cbc:PostalZone"/>
  <rule context="ubl:Invoice/cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cbc:CountrySubentity"/>
  <rule context="ubl:Invoice/cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cac:AddressLine">
    <assert flag="fatal" id="BASIC-00113" test="cbc:Line[1] and not(cbc:Line[2])">A single instance of cbc:Line is mandatory.</assert>
  </rule>
  <rule context="ubl:Invoice/cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cac:AddressLine/cbc:Line"/>
  <rule context="ubl:Invoice/cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cac:Country">
    <assert flag="fatal" id="BASIC-00114" test="cbc:IdentificationCode[1] and not(cbc:IdentificationCode[2])">A single instance of cbc:IdentificationCode is mandatory.</assert>
  </rule>
  <rule context="ubl:Invoice/cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode">
    <assert flag="fatal" id="BASIC-00115" test="(some $code in $clISO3166 satisfies $code = normalize-space())">This element must have value from codelist ISO3166.</assert>
  </rule>
  <rule context="ubl:Invoice/cac:AccountingCustomerParty/cac:Party/cac:PartyTaxScheme">
    <assert flag="fatal" id="BASIC-00116" test="cbc:CompanyID[1] and not(cbc:CompanyID[2])">A single instance of cbc:CompanyID is mandatory.</assert>
    <assert flag="fatal" id="BASIC-00117" test="cac:TaxScheme[1] and not(cac:TaxScheme[2])">A single instance of cac:TaxScheme is mandatory.</assert>
  </rule>
  <rule context="ubl:Invoice/cac:AccountingCustomerParty/cac:Party/cac:PartyTaxScheme/cbc:CompanyID"/>
  <rule context="ubl:Invoice/cac:AccountingCustomerParty/cac:Party/cac:PartyTaxScheme/cac:TaxScheme">
    <assert flag="fatal" id="BASIC-00118" test="cbc:ID[1] and not(cbc:ID[2])">A single instance of cbc:ID is mandatory.</assert>
  </rule>
  <rule context="ubl:Invoice/cac:AccountingCustomerParty/cac:Party/cac:PartyTaxScheme/cac:TaxScheme/cbc:ID"/>
  <rule context="ubl:Invoice/cac:AccountingCustomerParty/cac:Party/cac:PartyLegalEntity">
    <assert flag="fatal" id="BASIC-00119" test="cbc:RegistrationName[1] and not(cbc:RegistrationName[2])">A single instance of cbc:RegistrationName is mandatory.</assert>
    <assert flag="fatal" id="BASIC-00120" test="not(cbc:CompanyID[2])">No more than a single instance of cbc:CompanyID are allowed.</assert>
    <assert flag="fatal" id="BASIC-00121" test="not(cac:Contact[2])">No more than a single instance of cac:Contact are allowed.</assert>
  </rule>
  <rule context="ubl:Invoice/cac:AccountingCustomerParty/cac:Party/cac:PartyLegalEntity/cbc:RegistrationName"/>
  <rule context="ubl:Invoice/cac:AccountingCustomerParty/cac:Party/cac:PartyLegalEntity/cbc:CompanyID">
    <assert flag="fatal" id="BASIC-00122" test="not(@schemeID) or (some $code in $clICD satisfies $code = normalize-space(@schemeID))">This attribute must have value from codelist ICD.</assert>
  </rule>
  <rule context="ubl:Invoice/cac:AccountingCustomerParty/cac:Party/cac:PartyLegalEntity/cac:Contact">
    <assert flag="fatal" id="BASIC-00123" test="not(cbc:Name[2])">No more than a single instance of cbc:Name are allowed.</assert>
    <assert flag="fatal" id="BASIC-00124" test="not(cbc:Telephone[2])">No more than a single instance of cbc:Telephone are allowed.</assert>
    <assert flag="fatal" id="BASIC-00125" test="not(cbc:ElectronicMail[2])">No more than a single instance of cbc:ElectronicMail are allowed.</assert>
  </rule>
  <rule context="ubl:Invoice/cac:AccountingCustomerParty/cac:Party/cac:PartyLegalEntity/cac:Contact/cbc:Name"/>
  <rule context="ubl:Invoice/cac:AccountingCustomerParty/cac:Party/cac:PartyLegalEntity/cac:Contact/cbc:Telephone"/>
  <rule context="ubl:Invoice/cac:AccountingCustomerParty/cac:Party/cac:PartyLegalEntity/cac:Contact/cbc:ElectronicMail"/>
  <rule context="ubl:Invoice/cac:PayeeParty">
    <assert flag="fatal" id="BASIC-00126" test="not(cac:PartyIdentification[2])">No more than a single instance of cac:PartyIdentification are allowed.</assert>
    <assert flag="fatal" id="BASIC-00127" test="not(cac:PartyIdentification[2])">No more than a single instance of cac:PartyIdentification are allowed.</assert>
    <assert flag="fatal" id="BASIC-00128" test="cac:PartyName[1] and not(cac:PartyName[2])">A single instance of cac:PartyName is mandatory.</assert>
    <assert flag="fatal" id="BASIC-00129" test="not(cac:PartyLegalEntity[2])">No more than a single instance of cac:PartyLegalEntity are allowed.</assert>
  </rule>
  <rule context="ubl:Invoice/cac:PayeeParty/cac:PartyIdentification">
    <assert flag="fatal" id="BASIC-00130" test="cbc:ID[1] and not(cbc:ID[2])">A single instance of cbc:ID is mandatory.</assert>
  </rule>
  <rule context="ubl:Invoice/cac:PayeeParty/cac:PartyIdentification/cbc:ID">
    <assert flag="fatal" id="BASIC-00131" test="not(@schemeID) or (some $code in $clICD satisfies $code = normalize-space(@schemeID))">This attribute must have value from codelist ICD.</assert>
  </rule>
  <rule context="ubl:Invoice/cac:PayeeParty/cac:PartyIdentification">
    <assert flag="fatal" id="BASIC-00132" test="cbc:ID[1] and not(cbc:ID[2])">A single instance of cbc:ID is mandatory.</assert>
  </rule>
  <rule context="ubl:Invoice/cac:PayeeParty/cac:PartyIdentification/cbc:ID">
    <assert flag="fatal" id="BASIC-00133" test="not(@schemeID) or (some $code in $clICD satisfies $code = normalize-space(@schemeID)) or (some $code in $clSEPA satisfies $code = normalize-space(@schemeID))">This attribute must have value from codelist ICD, SEPA.</assert>
  </rule>
  <rule context="ubl:Invoice/cac:PayeeParty/cac:PartyName">
    <assert flag="fatal" id="BASIC-00134" test="cbc:Name[1] and not(cbc:Name[2])">A single instance of cbc:Name is mandatory.</assert>
  </rule>
  <rule context="ubl:Invoice/cac:PayeeParty/cac:PartyName/cbc:Name"/>
  <rule context="ubl:Invoice/cac:PayeeParty/cac:PartyLegalEntity">
    <assert flag="fatal" id="BASIC-00135" test="cbc:CompanyID[1] and not(cbc:CompanyID[2])">A single instance of cbc:CompanyID is mandatory.</assert>
  </rule>
  <rule context="ubl:Invoice/cac:PayeeParty/cac:PartyLegalEntity/cbc:CompanyID">
    <assert flag="fatal" id="BASIC-00136" test="not(@schemeID) or (some $code in $clICD satisfies $code = normalize-space(@schemeID))">This attribute must have value from codelist ICD.</assert>
  </rule>
  <rule context="ubl:Invoice/cac:TaxRepresentativeParty">
    <assert flag="fatal" id="BASIC-00137" test="cac:PartyName[1] and not(cac:PartyName[2])">A single instance of cac:PartyName is mandatory.</assert>
    <assert flag="fatal" id="BASIC-00138" test="cac:PostalAddress[1] and not(cac:PostalAddress[2])">A single instance of cac:PostalAddress is mandatory.</assert>
    <assert flag="fatal" id="BASIC-00139" test="cac:PartyTaxScheme[1] and not(cac:PartyTaxScheme[2])">A single instance of cac:PartyTaxScheme is mandatory.</assert>
  </rule>
  <rule context="ubl:Invoice/cac:TaxRepresentativeParty/cac:PartyName">
    <assert flag="fatal" id="BASIC-00140" test="cbc:Name[1] and not(cbc:Name[2])">A single instance of cbc:Name is mandatory.</assert>
  </rule>
  <rule context="ubl:Invoice/cac:TaxRepresentativeParty/cac:PartyName/cbc:Name"/>
  <rule context="ubl:Invoice/cac:TaxRepresentativeParty/cac:PostalAddress">
    <assert flag="fatal" id="BASIC-00141" test="not(cbc:StreetName[2])">No more than a single instance of cbc:StreetName are allowed.</assert>
    <assert flag="fatal" id="BASIC-00142" test="not(cbc:AdditionalStreetName[2])">No more than a single instance of cbc:AdditionalStreetName are allowed.</assert>
    <assert flag="fatal" id="BASIC-00143" test="not(cbc:CityName[2])">No more than a single instance of cbc:CityName are allowed.</assert>
    <assert flag="fatal" id="BASIC-00144" test="not(cbc:PostalZone[2])">No more than a single instance of cbc:PostalZone are allowed.</assert>
    <assert flag="fatal" id="BASIC-00145" test="not(cbc:CountrySubentity[2])">No more than a single instance of cbc:CountrySubentity are allowed.</assert>
    <assert flag="fatal" id="BASIC-00146" test="not(cac:AddressLine[2])">No more than a single instance of cac:AddressLine are allowed.</assert>
    <assert flag="fatal" id="BASIC-00147" test="cac:Country[1] and not(cac:Country[2])">A single instance of cac:Country is mandatory.</assert>
  </rule>
  <rule context="ubl:Invoice/cac:TaxRepresentativeParty/cac:PostalAddress/cbc:StreetName"/>
  <rule context="ubl:Invoice/cac:TaxRepresentativeParty/cac:PostalAddress/cbc:AdditionalStreetName"/>
  <rule context="ubl:Invoice/cac:TaxRepresentativeParty/cac:PostalAddress/cbc:CityName"/>
  <rule context="ubl:Invoice/cac:TaxRepresentativeParty/cac:PostalAddress/cbc:PostalZone"/>
  <rule context="ubl:Invoice/cac:TaxRepresentativeParty/cac:PostalAddress/cbc:CountrySubentity"/>
  <rule context="ubl:Invoice/cac:TaxRepresentativeParty/cac:PostalAddress/cac:AddressLine">
    <assert flag="fatal" id="BASIC-00148" test="cbc:Line[1] and not(cbc:Line[2])">A single instance of cbc:Line is mandatory.</assert>
  </rule>
  <rule context="ubl:Invoice/cac:TaxRepresentativeParty/cac:PostalAddress/cac:AddressLine/cbc:Line"/>
  <rule context="ubl:Invoice/cac:TaxRepresentativeParty/cac:PostalAddress/cac:Country">
    <assert flag="fatal" id="BASIC-00149" test="cbc:IdentificationCode[1] and not(cbc:IdentificationCode[2])">A single instance of cbc:IdentificationCode is mandatory.</assert>
  </rule>
  <rule context="ubl:Invoice/cac:TaxRepresentativeParty/cac:PostalAddress/cac:Country/cbc:IdentificationCode">
    <assert flag="fatal" id="BASIC-00150" test="(some $code in $clISO3166 satisfies $code = normalize-space())">This element must have value from codelist ISO3166.</assert>
  </rule>
  <rule context="ubl:Invoice/cac:TaxRepresentativeParty/cac:PartyTaxScheme">
    <assert flag="fatal" id="BASIC-00151" test="cbc:CompanyID[1] and not(cbc:CompanyID[2])">A single instance of cbc:CompanyID is mandatory.</assert>
    <assert flag="fatal" id="BASIC-00152" test="cac:TaxScheme[1] and not(cac:TaxScheme[2])">A single instance of cac:TaxScheme is mandatory.</assert>
  </rule>
  <rule context="ubl:Invoice/cac:TaxRepresentativeParty/cac:PartyTaxScheme/cbc:CompanyID"/>
  <rule context="ubl:Invoice/cac:TaxRepresentativeParty/cac:PartyTaxScheme/cac:TaxScheme">
    <assert flag="fatal" id="BASIC-00153" test="cbc:ID[1] and not(cbc:ID[2])">A single instance of cbc:ID is mandatory.</assert>
  </rule>
  <rule context="ubl:Invoice/cac:TaxRepresentativeParty/cac:PartyTaxScheme/cac:TaxScheme/cbc:ID"/>
  <rule context="ubl:Invoice/cac:Delivery">
    <assert flag="fatal" id="BASIC-00154" test="not(cbc:ActualDeliveryDate[2])">No more than a single instance of cbc:ActualDeliveryDate are allowed.</assert>
    <assert flag="fatal" id="BASIC-00155" test="not(cac:DeliveryLocation[2])">No more than a single instance of cac:DeliveryLocation are allowed.</assert>
    <assert flag="fatal" id="BASIC-00156" test="not(cac:DeliveryParty[2])">No more than a single instance of cac:DeliveryParty are allowed.</assert>
  </rule>
  <rule context="ubl:Invoice/cac:Delivery/cbc:ActualDeliveryDate"/>
  <rule context="ubl:Invoice/cac:Delivery/cac:DeliveryLocation">
    <assert flag="fatal" id="BASIC-00157" test="not(cbc:ID[2])">No more than a single instance of cbc:ID are allowed.</assert>
    <assert flag="fatal" id="BASIC-00158" test="not(cac:Address[2])">No more than a single instance of cac:Address are allowed.</assert>
  </rule>
  <rule context="ubl:Invoice/cac:Delivery/cac:DeliveryLocation/cbc:ID">
    <assert flag="fatal" id="BASIC-00159" test="not(@schemeID) or (some $code in $clICD satisfies $code = normalize-space(@schemeID))">This attribute must have value from codelist ICD.</assert>
  </rule>
  <rule context="ubl:Invoice/cac:Delivery/cac:DeliveryLocation/cac:Address">
    <assert flag="fatal" id="BASIC-00160" test="not(cbc:StreetName[2])">No more than a single instance of cbc:StreetName are allowed.</assert>
    <assert flag="fatal" id="BASIC-00161" test="not(cbc:AdditionalStreetName[2])">No more than a single instance of cbc:AdditionalStreetName are allowed.</assert>
    <assert flag="fatal" id="BASIC-00162" test="not(cbc:CityName[2])">No more than a single instance of cbc:CityName are allowed.</assert>
    <assert flag="fatal" id="BASIC-00163" test="not(cbc:PostalZone[2])">No more than a single instance of cbc:PostalZone are allowed.</assert>
    <assert flag="fatal" id="BASIC-00164" test="not(cbc:CountrySubentity[2])">No more than a single instance of cbc:CountrySubentity are allowed.</assert>
    <assert flag="fatal" id="BASIC-00165" test="not(cac:AddressLine[2])">No more than a single instance of cac:AddressLine are allowed.</assert>
    <assert flag="fatal" id="BASIC-00166" test="cac:Country[1] and not(cac:Country[2])">A single instance of cac:Country is mandatory.</assert>
  </rule>
  <rule context="ubl:Invoice/cac:Delivery/cac:DeliveryLocation/cac:Address/cbc:StreetName"/>
  <rule context="ubl:Invoice/cac:Delivery/cac:DeliveryLocation/cac:Address/cbc:AdditionalStreetName"/>
  <rule context="ubl:Invoice/cac:Delivery/cac:DeliveryLocation/cac:Address/cbc:CityName"/>
  <rule context="ubl:Invoice/cac:Delivery/cac:DeliveryLocation/cac:Address/cbc:PostalZone"/>
  <rule context="ubl:Invoice/cac:Delivery/cac:DeliveryLocation/cac:Address/cbc:CountrySubentity"/>
  <rule context="ubl:Invoice/cac:Delivery/cac:DeliveryLocation/cac:Address/cac:AddressLine">
    <assert flag="fatal" id="BASIC-00167" test="cbc:Line[1] and not(cbc:Line[2])">A single instance of cbc:Line is mandatory.</assert>
  </rule>
  <rule context="ubl:Invoice/cac:Delivery/cac:DeliveryLocation/cac:Address/cac:AddressLine/cbc:Line"/>
  <rule context="ubl:Invoice/cac:Delivery/cac:DeliveryLocation/cac:Address/cac:Country">
    <assert flag="fatal" id="BASIC-00168" test="cbc:IdentificationCode[1] and not(cbc:IdentificationCode[2])">A single instance of cbc:IdentificationCode is mandatory.</assert>
  </rule>
  <rule context="ubl:Invoice/cac:Delivery/cac:DeliveryLocation/cac:Address/cac:Country/cbc:IdentificationCode">
    <assert flag="fatal" id="BASIC-00169" test="(some $code in $clISO3166 satisfies $code = normalize-space())">This element must have value from codelist ISO3166.</assert>
  </rule>
  <rule context="ubl:Invoice/cac:Delivery/cac:DeliveryParty">
    <assert flag="fatal" id="BASIC-00170" test="cac:PartyName[1] and not(cac:PartyName[2])">A single instance of cac:PartyName is mandatory.</assert>
  </rule>
  <rule context="ubl:Invoice/cac:Delivery/cac:DeliveryParty/cac:PartyName">
    <assert flag="fatal" id="BASIC-00171" test="cbc:Name[1] and not(cbc:Name[2])">A single instance of cbc:Name is mandatory.</assert>
  </rule>
  <rule context="ubl:Invoice/cac:Delivery/cac:DeliveryParty/cac:PartyName/cbc:Name"/>
  <rule context="ubl:Invoice/cac:PaymentMeans">
    <assert flag="fatal" id="BASIC-00172" test="not(cbc:ID[2])">No more than a single instance of cbc:ID are allowed.</assert>
    <assert flag="fatal" id="BASIC-00173" test="cbc:PaymentMeansCode[1] and not(cbc:PaymentMeansCode[2])">A single instance of cbc:PaymentMeansCode is mandatory.</assert>
    <assert flag="fatal" id="BASIC-00174" test="not(cbc:PaymentID[2])">No more than a single instance of cbc:PaymentID are allowed.</assert>
    <assert flag="fatal" id="BASIC-00175" test="not(cac:CardAccount[2])">No more than a single instance of cac:CardAccount are allowed.</assert>
    <assert flag="fatal" id="BASIC-00176" test="not(cac:PayeeFinancialAccount[2])">No more than a single instance of cac:PayeeFinancialAccount are allowed.</assert>
    <assert flag="fatal" id="BASIC-00177" test="cac:PaymentMandate[1] and not(cac:PaymentMandate[2])">A single instance of cac:PaymentMandate is mandatory.</assert>
  </rule>
  <rule context="ubl:Invoice/cac:PaymentMeans/cbc:ID"/>
  <rule context="ubl:Invoice/cac:PaymentMeans/cbc:PaymentMeansCode">
    <assert flag="fatal" id="BASIC-00178" test="(some $code in $clUNCL4461 satisfies $code = normalize-space())">This element must have value from codelist UNCL4461.</assert>
  </rule>
  <rule context="ubl:Invoice/cac:PaymentMeans/cbc:PaymentID"/>
  <rule context="ubl:Invoice/cac:PaymentMeans/cac:CardAccount">
    <assert flag="fatal" id="BASIC-00179" test="cbc:PrimaryAccountNumberID[1] and not(cbc:PrimaryAccountNumberID[2])">A single instance of cbc:PrimaryAccountNumberID is mandatory.</assert>
    <assert flag="fatal" id="BASIC-00180" test="cbc:NetworkID[1] and not(cbc:NetworkID[2])">A single instance of cbc:NetworkID is mandatory.</assert>
    <assert flag="fatal" id="BASIC-00181" test="not(cbc:HolderName[2])">No more than a single instance of cbc:HolderName are allowed.</assert>
  </rule>
  <rule context="ubl:Invoice/cac:PaymentMeans/cac:CardAccount/cbc:PrimaryAccountNumberID"/>
  <rule context="ubl:Invoice/cac:PaymentMeans/cac:CardAccount/cbc:NetworkID"/>
  <rule context="ubl:Invoice/cac:PaymentMeans/cac:CardAccount/cbc:HolderName"/>
  <rule context="ubl:Invoice/cac:PaymentMeans/cac:PayeeFinancialAccount">
    <assert flag="fatal" id="BASIC-00182" test="cbc:ID[1] and not(cbc:ID[2])">A single instance of cbc:ID is mandatory.</assert>
    <assert flag="fatal" id="BASIC-00183" test="not(cbc:Name[2])">No more than a single instance of cbc:Name are allowed.</assert>
    <assert flag="fatal" id="BASIC-00184" test="not(cac:FinancialInstitutionBranch[2])">No more than a single instance of cac:FinancialInstitutionBranch are allowed.</assert>
  </rule>
  <rule context="ubl:Invoice/cac:PaymentMeans/cac:PayeeFinancialAccount/cbc:ID"/>
  <rule context="ubl:Invoice/cac:PaymentMeans/cac:PayeeFinancialAccount/cbc:Name"/>
  <rule context="ubl:Invoice/cac:PaymentMeans/cac:PayeeFinancialAccount/cac:FinancialInstitutionBranch">
    <assert flag="fatal" id="BASIC-00185" test="cbc:ID[1] and not(cbc:ID[2])">A single instance of cbc:ID is mandatory.</assert>
    <assert flag="fatal" id="BASIC-00186" test="cac:PostalAddress[1] and not(cac:PostalAddress[2])">A single instance of cac:PostalAddress is mandatory.</assert>
  </rule>
  <rule context="ubl:Invoice/cac:PaymentMeans/cac:PayeeFinancialAccount/cac:FinancialInstitutionBranch/cbc:ID"/>
  <rule context="ubl:Invoice/cac:PaymentMeans/cac:PayeeFinancialAccount/cac:FinancialInstitutionBranch/cac:PostalAddress">
    <assert flag="fatal" id="BASIC-00187" test="not(cbc:StreetName[2])">No more than a single instance of cbc:StreetName are allowed.</assert>
    <assert flag="fatal" id="BASIC-00188" test="not(cbc:AdditionalStreetName[2])">No more than a single instance of cbc:AdditionalStreetName are allowed.</assert>
    <assert flag="fatal" id="BASIC-00189" test="not(cbc:CityName[2])">No more than a single instance of cbc:CityName are allowed.</assert>
    <assert flag="fatal" id="BASIC-00190" test="not(cbc:PostalZone[2])">No more than a single instance of cbc:PostalZone are allowed.</assert>
    <assert flag="fatal" id="BASIC-00191" test="not(cbc:CountrySubentity[2])">No more than a single instance of cbc:CountrySubentity are allowed.</assert>
    <assert flag="fatal" id="BASIC-00192" test="not(cac:AddressLine[2])">No more than a single instance of cac:AddressLine are allowed.</assert>
    <assert flag="fatal" id="BASIC-00193" test="cac:Country[1] and not(cac:Country[2])">A single instance of cac:Country is mandatory.</assert>
  </rule>
  <rule context="ubl:Invoice/cac:PaymentMeans/cac:PayeeFinancialAccount/cac:FinancialInstitutionBranch/cac:PostalAddress/cbc:StreetName"/>
  <rule context="ubl:Invoice/cac:PaymentMeans/cac:PayeeFinancialAccount/cac:FinancialInstitutionBranch/cac:PostalAddress/cbc:AdditionalStreetName"/>
  <rule context="ubl:Invoice/cac:PaymentMeans/cac:PayeeFinancialAccount/cac:FinancialInstitutionBranch/cac:PostalAddress/cbc:CityName"/>
  <rule context="ubl:Invoice/cac:PaymentMeans/cac:PayeeFinancialAccount/cac:FinancialInstitutionBranch/cac:PostalAddress/cbc:PostalZone"/>
  <rule context="ubl:Invoice/cac:PaymentMeans/cac:PayeeFinancialAccount/cac:FinancialInstitutionBranch/cac:PostalAddress/cbc:CountrySubentity"/>
  <rule context="ubl:Invoice/cac:PaymentMeans/cac:PayeeFinancialAccount/cac:FinancialInstitutionBranch/cac:PostalAddress/cac:AddressLine">
    <assert flag="fatal" id="BASIC-00194" test="cbc:Line[1] and not(cbc:Line[2])">A single instance of cbc:Line is mandatory.</assert>
  </rule>
  <rule context="ubl:Invoice/cac:PaymentMeans/cac:PayeeFinancialAccount/cac:FinancialInstitutionBranch/cac:PostalAddress/cac:AddressLine/cbc:Line"/>
  <rule context="ubl:Invoice/cac:PaymentMeans/cac:PayeeFinancialAccount/cac:FinancialInstitutionBranch/cac:PostalAddress/cac:Country">
    <assert flag="fatal" id="BASIC-00195" test="cbc:IdentificationCode[1] and not(cbc:IdentificationCode[2])">A single instance of cbc:IdentificationCode is mandatory.</assert>
  </rule>
  <rule context="ubl:Invoice/cac:PaymentMeans/cac:PayeeFinancialAccount/cac:FinancialInstitutionBranch/cac:PostalAddress/cac:Country/cbc:IdentificationCode">
    <assert flag="fatal" id="BASIC-00196" test="(some $code in $clISO3166 satisfies $code = normalize-space())">This element must have value from codelist ISO3166.</assert>
  </rule>
  <rule context="ubl:Invoice/cac:PaymentMeans/cac:PaymentMandate">
    <assert flag="fatal" id="BASIC-00197" test="not(cbc:ID[2])">No more than a single instance of cbc:ID are allowed.</assert>
    <assert flag="fatal" id="BASIC-00198" test="not(cac:PayerFinancialAccount[2])">No more than a single instance of cac:PayerFinancialAccount are allowed.</assert>
  </rule>
  <rule context="ubl:Invoice/cac:PaymentMeans/cac:PaymentMandate/cbc:ID"/>
  <rule context="ubl:Invoice/cac:PaymentMeans/cac:PaymentMandate/cac:PayerFinancialAccount">
    <assert flag="fatal" id="BASIC-00199" test="cbc:ID[1] and not(cbc:ID[2])">A single instance of cbc:ID is mandatory.</assert>
  </rule>
  <rule context="ubl:Invoice/cac:PaymentMeans/cac:PaymentMandate/cac:PayerFinancialAccount/cbc:ID"/>
  <rule context="ubl:Invoice/cac:PaymentTerms">
    <assert flag="fatal" id="BASIC-00200" test="not(cbc:PaymentMeansID[2])">No more than a single instance of cbc:PaymentMeansID are allowed.</assert>
    <assert flag="fatal" id="BASIC-00201" test="not(cbc:Note[2])">No more than a single instance of cbc:Note are allowed.</assert>
    <assert flag="fatal" id="BASIC-00202" test="not(cbc:Amount[2])">No more than a single instance of cbc:Amount are allowed.</assert>
    <assert flag="fatal" id="BASIC-00203" test="not(cbc:InstallmentDueDate[2])">No more than a single instance of cbc:InstallmentDueDate are allowed.</assert>
  </rule>
  <rule context="ubl:Invoice/cac:PaymentTerms/cbc:PaymentMeansID"/>
  <rule context="ubl:Invoice/cac:PaymentTerms/cbc:Note"/>
  <rule context="ubl:Invoice/cac:PaymentTerms/cbc:Amount"/>
  <rule context="ubl:Invoice/cac:PaymentTerms/cbc:InstallmentDueDate"/>
  <rule context="ubl:Invoice/cac:PrepaidPayment">
    <assert flag="fatal" id="BASIC-00204" test="not(cbc:ID[2])">No more than a single instance of cbc:ID are allowed.</assert>
    <assert flag="fatal" id="BASIC-00205" test="not(cbc:PaidAmount[2])">No more than a single instance of cbc:PaidAmount are allowed.</assert>
    <assert flag="fatal" id="BASIC-00206" test="not(cbc:ReceivedDate[2])">No more than a single instance of cbc:ReceivedDate are allowed.</assert>
    <assert flag="fatal" id="BASIC-00207" test="not(cbc:InstructionID[2])">No more than a single instance of cbc:InstructionID are allowed.</assert>
  </rule>
  <rule context="ubl:Invoice/cac:PrepaidPayment/cbc:ID"/>
  <rule context="ubl:Invoice/cac:PrepaidPayment/cbc:PaidAmount"/>
  <rule context="ubl:Invoice/cac:PrepaidPayment/cbc:ReceivedDate"/>
  <rule context="ubl:Invoice/cac:PrepaidPayment/cbc:InstructionID"/>
  <rule context="ubl:Invoice/cac:AllowanceCharge">
    <assert flag="fatal" id="BASIC-00208" test="cbc:ChargeIndicator[1] and not(cbc:ChargeIndicator[2])">A single instance of cbc:ChargeIndicator is mandatory.</assert>
    <assert flag="fatal" id="BASIC-00209" test="not(cbc:AllowanceChargeReasonCode[2])">No more than a single instance of cbc:AllowanceChargeReasonCode are allowed.</assert>
    <assert flag="fatal" id="BASIC-00210" test="not(cbc:AllowanceChargeReason[2])">No more than a single instance of cbc:AllowanceChargeReason are allowed.</assert>
    <assert flag="fatal" id="BASIC-00211" test="not(cbc:MultiplierFactorNumeric[2])">No more than a single instance of cbc:MultiplierFactorNumeric are allowed.</assert>
    <assert flag="fatal" id="BASIC-00212" test="cbc:Amount[1] and not(cbc:Amount[2])">A single instance of cbc:Amount is mandatory.</assert>
    <assert flag="fatal" id="BASIC-00213" test="not(cbc:BaseAmount[2])">No more than a single instance of cbc:BaseAmount are allowed.</assert>
    <assert flag="fatal" id="BASIC-00214" test="cac:TaxCategory[1] and not(cac:TaxCategory[2])">A single instance of cac:TaxCategory is mandatory.</assert>
  </rule>
  <rule context="ubl:Invoice/cac:AllowanceCharge/cbc:ChargeIndicator"/>
  <rule context="ubl:Invoice/cac:AllowanceCharge/cbc:AllowanceChargeReasonCode">
    <assert flag="fatal" id="BASIC-00215" test="(some $code in $clUNCL5189 satisfies $code = normalize-space()) or (some $code in $clUNCL7161 satisfies $code = normalize-space())">This element must have value from codelist UNCL5189, UNCL7161.</assert>
  </rule>
  <rule context="ubl:Invoice/cac:AllowanceCharge/cbc:AllowanceChargeReason"/>
  <rule context="ubl:Invoice/cac:AllowanceCharge/cbc:MultiplierFactorNumeric"/>
  <rule context="ubl:Invoice/cac:AllowanceCharge/cbc:Amount">
    <assert flag="fatal" id="BASIC-00216" test="not(@currencyID) or (some $code in $clISO4217 satisfies $code = normalize-space(@currencyID))">This attribute must have value from codelist ISO4217.</assert>
  </rule>
  <rule context="ubl:Invoice/cac:AllowanceCharge/cbc:BaseAmount">
    <assert flag="fatal" id="BASIC-00217" test="not(@currencyID) or (some $code in $clISO4217 satisfies $code = normalize-space(@currencyID))">This attribute must have value from codelist ISO4217.</assert>
  </rule>
  <rule context="ubl:Invoice/cac:AllowanceCharge/cac:TaxCategory">
    <assert flag="fatal" id="BASIC-00218" test="cbc:ID[1] and not(cbc:ID[2])">A single instance of cbc:ID is mandatory.</assert>
    <assert flag="fatal" id="BASIC-00219" test="not(cbc:Percent[2])">No more than a single instance of cbc:Percent are allowed.</assert>
    <assert flag="fatal" id="BASIC-00220" test="cac:TaxScheme[1] and not(cac:TaxScheme[2])">A single instance of cac:TaxScheme is mandatory.</assert>
  </rule>
  <rule context="ubl:Invoice/cac:AllowanceCharge/cac:TaxCategory/cbc:ID">
    <assert flag="fatal" id="BASIC-00221" test="(some $code in $clUNCL5305 satisfies $code = normalize-space())">This element must have value from codelist UNCL5305.</assert>
  </rule>
  <rule context="ubl:Invoice/cac:AllowanceCharge/cac:TaxCategory/cbc:Percent"/>
  <rule context="ubl:Invoice/cac:AllowanceCharge/cac:TaxCategory/cac:TaxScheme">
    <assert flag="fatal" id="BASIC-00222" test="cbc:ID[1] and not(cbc:ID[2])">A single instance of cbc:ID is mandatory.</assert>
  </rule>
  <rule context="ubl:Invoice/cac:AllowanceCharge/cac:TaxCategory/cac:TaxScheme/cbc:ID"/>
  <rule context="ubl:Invoice/cac:TaxTotal">
    <assert flag="fatal" id="BASIC-00223" test="cbc:TaxAmount[1] and not(cbc:TaxAmount[2])">A single instance of cbc:TaxAmount is mandatory.</assert>
  </rule>
  <rule context="ubl:Invoice/cac:TaxTotal/cbc:TaxAmount">
    <assert flag="fatal" id="BASIC-00224" test="not(@currencyID) or (some $code in $clISO4217 satisfies $code = normalize-space(@currencyID))">This attribute must have value from codelist ISO4217.</assert>
  </rule>
  <rule context="ubl:Invoice/cac:TaxTotal/cac:TaxSubtotal">
    <assert flag="fatal" id="BASIC-00225" test="cbc:TaxableAmount[1] and not(cbc:TaxableAmount[2])">A single instance of cbc:TaxableAmount is mandatory.</assert>
    <assert flag="fatal" id="BASIC-00226" test="cbc:TaxAmount[1] and not(cbc:TaxAmount[2])">A single instance of cbc:TaxAmount is mandatory.</assert>
    <assert flag="fatal" id="BASIC-00227" test="cac:TaxCategory[1] and not(cac:TaxCategory[2])">A single instance of cac:TaxCategory is mandatory.</assert>
  </rule>
  <rule context="ubl:Invoice/cac:TaxTotal/cac:TaxSubtotal/cbc:TaxableAmount">
    <assert flag="fatal" id="BASIC-00228" test="not(@currencyID) or (some $code in $clISO4217 satisfies $code = normalize-space(@currencyID))">This attribute must have value from codelist ISO4217.</assert>
  </rule>
  <rule context="ubl:Invoice/cac:TaxTotal/cac:TaxSubtotal/cbc:TaxAmount">
    <assert flag="fatal" id="BASIC-00229" test="not(@currencyID) or (some $code in $clISO4217 satisfies $code = normalize-space(@currencyID))">This attribute must have value from codelist ISO4217.</assert>
  </rule>
  <rule context="ubl:Invoice/cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory">
    <assert flag="fatal" id="BASIC-00230" test="cbc:ID[1] and not(cbc:ID[2])">A single instance of cbc:ID is mandatory.</assert>
    <assert flag="fatal" id="BASIC-00231" test="not(cbc:Percent[2])">No more than a single instance of cbc:Percent are allowed.</assert>
    <assert flag="fatal" id="BASIC-00232" test="not(cbc:TaxExemptionReasonCode[2])">No more than a single instance of cbc:TaxExemptionReasonCode are allowed.</assert>
    <assert flag="fatal" id="BASIC-00233" test="not(cbc:TaxExemptionReason[2])">No more than a single instance of cbc:TaxExemptionReason are allowed.</assert>
    <assert flag="fatal" id="BASIC-00234" test="cac:TaxScheme[1] and not(cac:TaxScheme[2])">A single instance of cac:TaxScheme is mandatory.</assert>
  </rule>
  <rule context="ubl:Invoice/cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory/cbc:ID">
    <assert flag="fatal" id="BASIC-00235" test="(some $code in $clUNCL5305 satisfies $code = normalize-space())">This element must have value from codelist UNCL5305.</assert>
  </rule>
  <rule context="ubl:Invoice/cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory/cbc:Percent"/>
  <rule context="ubl:Invoice/cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory/cbc:TaxExemptionReasonCode"/>
  <rule context="ubl:Invoice/cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory/cbc:TaxExemptionReason"/>
  <rule context="ubl:Invoice/cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory/cac:TaxScheme">
    <assert flag="fatal" id="BASIC-00236" test="cbc:ID[1] and not(cbc:ID[2])">A single instance of cbc:ID is mandatory.</assert>
  </rule>
  <rule context="ubl:Invoice/cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory/cac:TaxScheme/cbc:ID"/>
  <rule context="ubl:Invoice/cac:LegalMonetaryTotal">
    <assert flag="fatal" id="BASIC-00237" test="cbc:LineExtensionAmount[1] and not(cbc:LineExtensionAmount[2])">A single instance of cbc:LineExtensionAmount is mandatory.</assert>
    <assert flag="fatal" id="BASIC-00238" test="cbc:TaxExclusiveAmount[1] and not(cbc:TaxExclusiveAmount[2])">A single instance of cbc:TaxExclusiveAmount is mandatory.</assert>
    <assert flag="fatal" id="BASIC-00239" test="cbc:TaxInclusiveAmount[1] and not(cbc:TaxInclusiveAmount[2])">A single instance of cbc:TaxInclusiveAmount is mandatory.</assert>
    <assert flag="fatal" id="BASIC-00240" test="not(cbc:AllowanceTotalAmount[2])">No more than a single instance of cbc:AllowanceTotalAmount are allowed.</assert>
    <assert flag="fatal" id="BASIC-00241" test="not(cbc:ChargeTotalAmount[2])">No more than a single instance of cbc:ChargeTotalAmount are allowed.</assert>
    <assert flag="fatal" id="BASIC-00242" test="not(cbc:PrepaidAmount[2])">No more than a single instance of cbc:PrepaidAmount are allowed.</assert>
    <assert flag="fatal" id="BASIC-00243" test="not(cbc:PayableRoundingAmount[2])">No more than a single instance of cbc:PayableRoundingAmount are allowed.</assert>
    <assert flag="fatal" id="BASIC-00244" test="cbc:PayableAmount[1] and not(cbc:PayableAmount[2])">A single instance of cbc:PayableAmount is mandatory.</assert>
  </rule>
  <rule context="ubl:Invoice/cac:LegalMonetaryTotal/cbc:LineExtensionAmount">
    <assert flag="fatal" id="BASIC-00245" test="not(@currencyID) or (some $code in $clISO4217 satisfies $code = normalize-space(@currencyID))">This attribute must have value from codelist ISO4217.</assert>
  </rule>
  <rule context="ubl:Invoice/cac:LegalMonetaryTotal/cbc:TaxExclusiveAmount">
    <assert flag="fatal" id="BASIC-00246" test="not(@currencyID) or (some $code in $clISO4217 satisfies $code = normalize-space(@currencyID))">This attribute must have value from codelist ISO4217.</assert>
  </rule>
  <rule context="ubl:Invoice/cac:LegalMonetaryTotal/cbc:TaxInclusiveAmount">
    <assert flag="fatal" id="BASIC-00247" test="not(@currencyID) or (some $code in $clISO4217 satisfies $code = normalize-space(@currencyID))">This attribute must have value from codelist ISO4217.</assert>
  </rule>
  <rule context="ubl:Invoice/cac:LegalMonetaryTotal/cbc:AllowanceTotalAmount">
    <assert flag="fatal" id="BASIC-00248" test="not(@currencyID) or (some $code in $clISO4217 satisfies $code = normalize-space(@currencyID))">This attribute must have value from codelist ISO4217.</assert>
  </rule>
  <rule context="ubl:Invoice/cac:LegalMonetaryTotal/cbc:ChargeTotalAmount">
    <assert flag="fatal" id="BASIC-00249" test="not(@currencyID) or (some $code in $clISO4217 satisfies $code = normalize-space(@currencyID))">This attribute must have value from codelist ISO4217.</assert>
  </rule>
  <rule context="ubl:Invoice/cac:LegalMonetaryTotal/cbc:PrepaidAmount">
    <assert flag="fatal" id="BASIC-00250" test="not(@currencyID) or (some $code in $clISO4217 satisfies $code = normalize-space(@currencyID))">This attribute must have value from codelist ISO4217.</assert>
  </rule>
  <rule context="ubl:Invoice/cac:LegalMonetaryTotal/cbc:PayableRoundingAmount">
    <assert flag="fatal" id="BASIC-00251" test="not(@currencyID) or (some $code in $clISO4217 satisfies $code = normalize-space(@currencyID))">This attribute must have value from codelist ISO4217.</assert>
  </rule>
  <rule context="ubl:Invoice/cac:LegalMonetaryTotal/cbc:PayableAmount">
    <assert flag="fatal" id="BASIC-00252" test="not(@currencyID) or (some $code in $clISO4217 satisfies $code = normalize-space(@currencyID))">This attribute must have value from codelist ISO4217.</assert>
  </rule>
  <rule context="ubl:Invoice/cac:InvoiceLine">
    <assert flag="fatal" id="BASIC-00253" test="cbc:ID[1] and not(cbc:ID[2])">A single instance of cbc:ID is mandatory.</assert>
    <assert flag="fatal" id="BASIC-00254" test="not(cbc:Note[2])">No more than a single instance of cbc:Note are allowed.</assert>
    <assert flag="fatal" id="BASIC-00255" test="cbc:InvoicedQuantity[1] and not(cbc:InvoicedQuantity[2])">A single instance of cbc:InvoicedQuantity is mandatory.</assert>
    <assert flag="fatal" id="BASIC-00256" test="cbc:LineExtensionAmount[1] and not(cbc:LineExtensionAmount[2])">A single instance of cbc:LineExtensionAmount is mandatory.</assert>
    <assert flag="fatal" id="BASIC-00257" test="not(cbc:AccountingCost[2])">No more than a single instance of cbc:AccountingCost are allowed.</assert>
    <assert flag="fatal" id="BASIC-00258" test="not(cac:InvoicePeriod[2])">No more than a single instance of cac:InvoicePeriod are allowed.</assert>
    <assert flag="fatal" id="BASIC-00259" test="not(cac:OrderLineReference[2])">No more than a single instance of cac:OrderLineReference are allowed.</assert>
    <assert flag="fatal" id="BASIC-00260" test="not(cac:DocumentReference[2])">No more than a single instance of cac:DocumentReference are allowed.</assert>
    <assert flag="fatal" id="BASIC-00261" test="not(cac:DocumentReference[2])">No more than a single instance of cac:DocumentReference are allowed.</assert>
    <assert flag="fatal" id="BASIC-00262" test="cac:Item[1] and not(cac:Item[2])">A single instance of cac:Item is mandatory.</assert>
    <assert flag="fatal" id="BASIC-00263" test="cac:Price[1] and not(cac:Price[2])">A single instance of cac:Price is mandatory.</assert>
  </rule>
  <rule context="ubl:Invoice/cac:InvoiceLine/cbc:ID"/>
  <rule context="ubl:Invoice/cac:InvoiceLine/cbc:Note"/>
  <rule context="ubl:Invoice/cac:InvoiceLine/cbc:InvoicedQuantity">
    <assert flag="fatal" id="BASIC-00264" test="not(@unitCode) or (some $code in $clUNECERec20 satisfies $code = normalize-space(@unitCode))">This attribute must have value from codelist UNECERec20.</assert>
  </rule>
  <rule context="ubl:Invoice/cac:InvoiceLine/cbc:LineExtensionAmount">
    <assert flag="fatal" id="BASIC-00265" test="not(@currencyID) or (some $code in $clISO4217 satisfies $code = normalize-space(@currencyID))">This attribute must have value from codelist ISO4217.</assert>
  </rule>
  <rule context="ubl:Invoice/cac:InvoiceLine/cbc:AccountingCost"/>
  <rule context="ubl:Invoice/cac:InvoiceLine/cac:InvoicePeriod">
    <assert flag="fatal" id="BASIC-00266" test="not(cbc:StartDate[2])">No more than a single instance of cbc:StartDate are allowed.</assert>
    <assert flag="fatal" id="BASIC-00267" test="not(cbc:EndDate[2])">No more than a single instance of cbc:EndDate are allowed.</assert>
  </rule>
  <rule context="ubl:Invoice/cac:InvoiceLine/cac:InvoicePeriod/cbc:StartDate"/>
  <rule context="ubl:Invoice/cac:InvoiceLine/cac:InvoicePeriod/cbc:EndDate"/>
  <rule context="ubl:Invoice/cac:InvoiceLine/cac:OrderLineReference">
    <assert flag="fatal" id="BASIC-00268" test="cbc:LineID[1] and not(cbc:LineID[2])">A single instance of cbc:LineID is mandatory.</assert>
  </rule>
  <rule context="ubl:Invoice/cac:InvoiceLine/cac:OrderLineReference/cbc:LineID"/>
  <rule context="ubl:Invoice/cac:InvoiceLine/cac:DocumentReference">
    <assert flag="fatal" id="BASIC-00269" test="cbc:ID[1] and not(cbc:ID[2])">A single instance of cbc:ID is mandatory.</assert>
    <assert flag="fatal" id="BASIC-00270" test="cbc:DocumentTypeCode[1] and not(cbc:DocumentTypeCode[2])">A single instance of cbc:DocumentTypeCode is mandatory.</assert>
  </rule>
  <rule context="ubl:Invoice/cac:InvoiceLine/cac:DocumentReference/cbc:ID"/>
  <rule context="ubl:Invoice/cac:InvoiceLine/cac:DocumentReference/cbc:DocumentTypeCode">
    <assert flag="fatal" id="BASIC-00271" test="(some $code in $clUNCL1001 satisfies $code = normalize-space())">This element must have value from codelist UNCL1001.</assert>
  </rule>
  <rule context="ubl:Invoice/cac:InvoiceLine/cac:DocumentReference">
    <assert flag="fatal" id="BASIC-00272" test="cbc:ID[1] and not(cbc:ID[2])">A single instance of cbc:ID is mandatory.</assert>
    <assert flag="fatal" id="BASIC-00273" test="cbc:DocumentTypeCode[1] and not(cbc:DocumentTypeCode[2])">A single instance of cbc:DocumentTypeCode is mandatory.</assert>
  </rule>
  <rule context="ubl:Invoice/cac:InvoiceLine/cac:DocumentReference/cbc:ID">
    <assert flag="fatal" id="BASIC-00274" test="not(@schemeID) or (some $code in $clUNCL1153 satisfies $code = normalize-space(@schemeID))">This attribute must have value from codelist UNCL1153.</assert>
  </rule>
  <rule context="ubl:Invoice/cac:InvoiceLine/cac:DocumentReference/cbc:DocumentTypeCode"/>
  <rule context="ubl:Invoice/cac:InvoiceLine/cac:AllowanceCharge">
    <assert flag="fatal" id="BASIC-00275" test="cbc:ChargeIndicator[1] and not(cbc:ChargeIndicator[2])">A single instance of cbc:ChargeIndicator is mandatory.</assert>
    <assert flag="fatal" id="BASIC-00276" test="not(cbc:AllowanceChargeReasonCode[2])">No more than a single instance of cbc:AllowanceChargeReasonCode are allowed.</assert>
    <assert flag="fatal" id="BASIC-00277" test="not(cbc:AllowanceChargeReason[2])">No more than a single instance of cbc:AllowanceChargeReason are allowed.</assert>
    <assert flag="fatal" id="BASIC-00278" test="cbc:Amount[1] and not(cbc:Amount[2])">A single instance of cbc:Amount is mandatory.</assert>
    <assert flag="fatal" id="BASIC-00279" test="not(cbc:BaseAmount[2])">No more than a single instance of cbc:BaseAmount are allowed.</assert>
  </rule>
  <rule context="ubl:Invoice/cac:InvoiceLine/cac:AllowanceCharge/cbc:ChargeIndicator"/>
  <rule context="ubl:Invoice/cac:InvoiceLine/cac:AllowanceCharge/cbc:AllowanceChargeReasonCode">
    <assert flag="fatal" id="BASIC-00280" test="(some $code in $clUNCL5189 satisfies $code = normalize-space()) or (some $code in $clUNCL7161 satisfies $code = normalize-space())">This element must have value from codelist UNCL5189, UNCL7161.</assert>
  </rule>
  <rule context="ubl:Invoice/cac:InvoiceLine/cac:AllowanceCharge/cbc:AllowanceChargeReason"/>
  <rule context="ubl:Invoice/cac:InvoiceLine/cac:AllowanceCharge/cbc:MultiplierFactorNumeric"/>
  <rule context="ubl:Invoice/cac:InvoiceLine/cac:AllowanceCharge/cbc:Amount">
    <assert flag="fatal" id="BASIC-00281" test="not(@currencyID) or (some $code in $clISO4217 satisfies $code = normalize-space(@currencyID))">This attribute must have value from codelist ISO4217.</assert>
  </rule>
  <rule context="ubl:Invoice/cac:InvoiceLine/cac:AllowanceCharge/cbc:BaseAmount">
    <assert flag="fatal" id="BASIC-00282" test="not(@currencyID) or (some $code in $clISO4217 satisfies $code = normalize-space(@currencyID))">This attribute must have value from codelist ISO4217.</assert>
  </rule>
  <rule context="ubl:Invoice/cac:InvoiceLine/cac:Item">
    <assert flag="fatal" id="BASIC-00283" test="not(cbc:Description[2])">No more than a single instance of cbc:Description are allowed.</assert>
    <assert flag="fatal" id="BASIC-00284" test="cbc:Name[1] and not(cbc:Name[2])">A single instance of cbc:Name is mandatory.</assert>
    <assert flag="fatal" id="BASIC-00285" test="not(cac:BuyersItemIdentification[2])">No more than a single instance of cac:BuyersItemIdentification are allowed.</assert>
    <assert flag="fatal" id="BASIC-00286" test="not(cac:SellersItemIdentification[2])">No more than a single instance of cac:SellersItemIdentification are allowed.</assert>
    <assert flag="fatal" id="BASIC-00287" test="not(cac:StandardItemIdentification[2])">No more than a single instance of cac:StandardItemIdentification are allowed.</assert>
    <assert flag="fatal" id="BASIC-00288" test="not(cac:OriginCountry[2])">No more than a single instance of cac:OriginCountry are allowed.</assert>
    <assert flag="fatal" id="BASIC-00289" test="cac:ClassifiedTaxCategory[1] and not(cac:ClassifiedTaxCategory[2])">A single instance of cac:ClassifiedTaxCategory is mandatory.</assert>
  </rule>
  <rule context="ubl:Invoice/cac:InvoiceLine/cac:Item/cbc:Description"/>
  <rule context="ubl:Invoice/cac:InvoiceLine/cac:Item/cbc:Name"/>
  <rule context="ubl:Invoice/cac:InvoiceLine/cac:Item/cac:BuyersItemIdentification">
    <assert flag="fatal" id="BASIC-00290" test="cbc:ID[1] and not(cbc:ID[2])">A single instance of cbc:ID is mandatory.</assert>
  </rule>
  <rule context="ubl:Invoice/cac:InvoiceLine/cac:Item/cac:BuyersItemIdentification/cbc:ID"/>
  <rule context="ubl:Invoice/cac:InvoiceLine/cac:Item/cac:SellersItemIdentification">
    <assert flag="fatal" id="BASIC-00291" test="cbc:ID[1] and not(cbc:ID[2])">A single instance of cbc:ID is mandatory.</assert>
  </rule>
  <rule context="ubl:Invoice/cac:InvoiceLine/cac:Item/cac:SellersItemIdentification/cbc:ID"/>
  <rule context="ubl:Invoice/cac:InvoiceLine/cac:Item/cac:StandardItemIdentification">
    <assert flag="fatal" id="BASIC-00292" test="cbc:ID[1] and not(cbc:ID[2])">A single instance of cbc:ID is mandatory.</assert>
  </rule>
  <rule context="ubl:Invoice/cac:InvoiceLine/cac:Item/cac:StandardItemIdentification/cbc:ID">
    <assert flag="fatal" id="BASIC-00293" test="not(@schemeID) or (some $code in $clICD satisfies $code = normalize-space(@schemeID))">This attribute must have value from codelist ICD.</assert>
  </rule>
  <rule context="ubl:Invoice/cac:InvoiceLine/cac:Item/cac:OriginCountry">
    <assert flag="fatal" id="BASIC-00294" test="cbc:IdentificationCode[1] and not(cbc:IdentificationCode[2])">A single instance of cbc:IdentificationCode is mandatory.</assert>
  </rule>
  <rule context="ubl:Invoice/cac:InvoiceLine/cac:Item/cac:OriginCountry/cbc:IdentificationCode">
    <assert flag="fatal" id="BASIC-00295" test="(some $code in $clISO3166 satisfies $code = normalize-space())">This element must have value from codelist ISO3166.</assert>
  </rule>
  <rule context="ubl:Invoice/cac:InvoiceLine/cac:Item/cac:CommodityClassification">
    <assert flag="fatal" id="BASIC-00296" test="cbc:ItemClassificationCode[1] and not(cbc:ItemClassificationCode[2])">A single instance of cbc:ItemClassificationCode is mandatory.</assert>
  </rule>
  <rule context="ubl:Invoice/cac:InvoiceLine/cac:Item/cac:CommodityClassification/cbc:ItemClassificationCode">
    <assert flag="fatal" id="BASIC-00297" test="not(@listID) or (some $code in $clUNCL7143 satisfies $code = normalize-space(@listID))">This attribute must have value from codelist UNCL7143.</assert>
  </rule>
  <rule context="ubl:Invoice/cac:InvoiceLine/cac:Item/cac:ClassifiedTaxCategory">
    <assert flag="fatal" id="BASIC-00298" test="cbc:ID[1] and not(cbc:ID[2])">A single instance of cbc:ID is mandatory.</assert>
    <assert flag="fatal" id="BASIC-00299" test="not(cbc:Percent[2])">No more than a single instance of cbc:Percent are allowed.</assert>
    <assert flag="fatal" id="BASIC-00300" test="not(cbc:PerUnitAmount[2])">No more than a single instance of cbc:PerUnitAmount are allowed.</assert>
    <assert flag="fatal" id="BASIC-00301" test="not(cbc:TaxExemptionReasonCode[2])">No more than a single instance of cbc:TaxExemptionReasonCode are allowed.</assert>
    <assert flag="fatal" id="BASIC-00302" test="not(cbc:TaxExemptionReason[2])">No more than a single instance of cbc:TaxExemptionReason are allowed.</assert>
    <assert flag="fatal" id="BASIC-00303" test="cac:TaxScheme[1] and not(cac:TaxScheme[2])">A single instance of cac:TaxScheme is mandatory.</assert>
  </rule>
  <rule context="ubl:Invoice/cac:InvoiceLine/cac:Item/cac:ClassifiedTaxCategory/cbc:ID">
    <assert flag="fatal" id="BASIC-00304" test="(some $code in $clUNCL5305 satisfies $code = normalize-space())">This element must have value from codelist UNCL5305.</assert>
  </rule>
  <rule context="ubl:Invoice/cac:InvoiceLine/cac:Item/cac:ClassifiedTaxCategory/cbc:Percent"/>
  <rule context="ubl:Invoice/cac:InvoiceLine/cac:Item/cac:ClassifiedTaxCategory/cbc:PerUnitAmount"/>
  <rule context="ubl:Invoice/cac:InvoiceLine/cac:Item/cac:ClassifiedTaxCategory/cbc:TaxExemptionReasonCode"/>
  <rule context="ubl:Invoice/cac:InvoiceLine/cac:Item/cac:ClassifiedTaxCategory/cbc:TaxExemptionReason"/>
  <rule context="ubl:Invoice/cac:InvoiceLine/cac:Item/cac:ClassifiedTaxCategory/cac:TaxScheme">
    <assert flag="fatal" id="BASIC-00305" test="cbc:ID[1] and not(cbc:ID[2])">A single instance of cbc:ID is mandatory.</assert>
  </rule>
  <rule context="ubl:Invoice/cac:InvoiceLine/cac:Item/cac:ClassifiedTaxCategory/cac:TaxScheme/cbc:ID"/>
  <rule context="ubl:Invoice/cac:InvoiceLine/cac:Item/cac:AdditionalItemProperty">
    <assert flag="fatal" id="BASIC-00306" test="cbc:Name[1] and not(cbc:Name[2])">A single instance of cbc:Name is mandatory.</assert>
    <assert flag="fatal" id="BASIC-00307" test="cbc:Value[1] and not(cbc:Value[2])">A single instance of cbc:Value is mandatory.</assert>
  </rule>
  <rule context="ubl:Invoice/cac:InvoiceLine/cac:Item/cac:AdditionalItemProperty/cbc:Name"/>
  <rule context="ubl:Invoice/cac:InvoiceLine/cac:Item/cac:AdditionalItemProperty/cbc:Value"/>
  <rule context="ubl:Invoice/cac:InvoiceLine/cac:Price">
    <assert flag="fatal" id="BASIC-00308" test="cbc:PriceAmount[1] and not(cbc:PriceAmount[2])">A single instance of cbc:PriceAmount is mandatory.</assert>
    <assert flag="fatal" id="BASIC-00309" test="not(cbc:BaseQuantity[2])">No more than a single instance of cbc:BaseQuantity are allowed.</assert>
    <assert flag="fatal" id="BASIC-00310" test="not(cac:AllowanceCharge[2])">No more than a single instance of cac:AllowanceCharge are allowed.</assert>
  </rule>
  <rule context="ubl:Invoice/cac:InvoiceLine/cac:Price/cbc:PriceAmount">
    <assert flag="fatal" id="BASIC-00311" test="@currencyID">Attribute currencyID is mandatory.</assert>
    <assert flag="fatal" id="BASIC-00312" test="not(@currencyID) or (some $code in $clISO4217 satisfies $code = normalize-space(@currencyID))">This attribute must have value from codelist ISO4217.</assert>
  </rule>
  <rule context="ubl:Invoice/cac:InvoiceLine/cac:Price/cbc:BaseQuantity">
    <assert flag="fatal" id="BASIC-00313" test="not(@unitCode) or (some $code in $clUNECERec20 satisfies $code = normalize-space(@unitCode))">This attribute must have value from codelist UNECERec20.</assert>
  </rule>
  <rule context="ubl:Invoice/cac:InvoiceLine/cac:Price/cac:AllowanceCharge">
    <assert flag="fatal" id="BASIC-00314" test="cbc:ChargeIndicator[1] and not(cbc:ChargeIndicator[2])">A single instance of cbc:ChargeIndicator is mandatory.</assert>
    <assert flag="fatal" id="BASIC-00315" test="cbc:Amount[1] and not(cbc:Amount[2])">A single instance of cbc:Amount is mandatory.</assert>
    <assert flag="fatal" id="BASIC-00316" test="not(cbc:BaseAmount[2])">No more than a single instance of cbc:BaseAmount are allowed.</assert>
  </rule>
  <rule context="ubl:Invoice/cac:InvoiceLine/cac:Price/cac:AllowanceCharge/cbc:ChargeIndicator">
    <assert flag="fatal" id="BASIC-00317" test="normalize-space() = 'false'">This element must have value 'false'.</assert>
  </rule>
  <rule context="ubl:Invoice/cac:InvoiceLine/cac:Price/cac:AllowanceCharge/cbc:Amount">
    <assert flag="fatal" id="BASIC-00318" test="@currencyID">Attribute currencyID is mandatory.</assert>
    <assert flag="fatal" id="BASIC-00319" test="not(@currencyID) or (some $code in $clISO4217 satisfies $code = normalize-space(@currencyID))">This attribute must have value from codelist ISO4217.</assert>
  </rule>
  <rule context="ubl:Invoice/cac:InvoiceLine/cac:Price/cac:AllowanceCharge/cbc:BaseAmount">
    <assert flag="fatal" id="BASIC-00320" test="@currencyID">Attribute currencyID is mandatory.</assert>
    <assert flag="fatal" id="BASIC-00321" test="not(@currencyID) or (some $code in $clISO4217 satisfies $code = normalize-space(@currencyID))">This attribute must have value from codelist ISO4217.</assert>
  </rule>
  <rule context="ubl:Invoice//xmldsig:*"/>
  <rule context="ubl:Invoice//*"/>
</pattern>
</schema>