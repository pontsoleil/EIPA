[ConnectingEurope/eInvoicing-EN16931](https://github.com/ConnectingEurope/eInvoicing-EN16931)の次のページから
[EN16931 Validation artefacts v.1.3.2](https://github.com/ConnectingEurope/eInvoicing-EN16931/releases/tag/validation-1.3.2)
[Source code (zip)](https://github.com/ConnectingEurope/eInvoicing-EN16931/archive/validation-1.3.2.zip)をダウンロードして、｀update-xslt-and-validate.cmd`のmvnコマンドを実行した。
```
Last login: Sun Sep 13 04:47:03 2020 from .....

       __|  __|_  )
       _|  (     /   Amazon Linux AMI
      ___|\___|___|

https://aws.amazon.com/amazon-linux-ami/2018.03-release-notes/
[ec2-user@ip-xx-x-x-xxx ~]$ mvn -version
Apache Maven 3.5.2 (138edd61fd100ec658bfa2d307c43b76940a5d7d; 2017-10-18T16:58:13+09:00)
Maven home: /usr/share/apache-maven
Java version: 1.8.0_252, vendor: Oracle Corporation
Java home: /usr/lib/jvm/java-1.8.0-openjdk-1.8.0.252.b09-2.51.amzn1.x86_64/jre
Default locale: ja_JP, platform encoding: UTF-8
OS name: "linux", version: "4.14.171-105.231.amzn1.x86_64", arch: "amd64", family: "unix"
```
```
[ec2-user@ip-xx-x-x-xxx ~]$ cd tmp
[ec2-user@ip-xx-x-x-xxx tmp]$ wget https://github.com/ConnectingEurope/eInvoicing-EN16931/archive/validation-1.3.2.zip
--2020-09-14 07:15:08--  https://github.com/ConnectingEurope/eInvoicing-EN16931/archive/validation-1.3.2.zip
github.com (github.com) をDNSに問いあわせています... 13.114.40.48
github.com (github.com)|13.114.40.48|:443 に接続しています... 接続しました。
HTTP による接続要求を送信しました、応答を待っています... 302 Found
場所: https://codeload.github.com/ConnectingEurope/eInvoicing-EN16931/zip/validation-1.3.2 [続く]
--2020-09-14 07:15:08--  https://codeload.github.com/ConnectingEurope/eInvoicing-EN16931/zip/validation-1.3.2
codeload.github.com (codeload.github.com) をDNSに問いあわせています... 52.193.111.178
codeload.github.com (codeload.github.com)|52.193.111.178|:443 に接続しています... 接続しました。
HTTP による接続要求を送信しました、応答を待っています... 200 OK
長さ: 特定できません [application/zip]
`validation-1.3.2.zip' に保存中

validation-1.3.2.zip                [ <=>                                                  ]   1.15M  --.-KB/s    in 0.1s    

2020-09-14 07:15:08 (7.81 MB/s) - `validation-1.3.2.zip' へ保存終了 [1206511]

[ec2-user@ip-xx-x-x-xxx tmp]$ unzip validation-1.3.2.zip
Archive:  validation-1.3.2.zip
b6762416a714fa78633af72966f130bddbeee568
   creating: eInvoicing-EN16931-validation-1.3.2/
  inflating: eInvoicing-EN16931-validation-1.3.2/.gitattributes  
  inflating: eInvoicing-EN16931-validation-1.3.2/.gitignore  
...
[ec2-user@ip-xx-x-x-xxx tmp]$
```
```
[ec2-user@ip-xx-x-x-xxx tmp]$ cd eInvoicing-EN16931-validation-1.3.2
[ec2-user@ip-xx-x-x-xxx eInvoicing-EN16931-validation-1.3.2]$ mvn -f pom-preprocess.xml generate-resources
[INFO] Scanning for projects...
Downloading from central: https://repo.maven.apache.org/maven2/com/helger/parent-pom/1.10.8/parent-pom-1.10.8.pom
Downloaded from central: https://repo.maven.apache.org/maven2/com/helger/parent-pom/1.10.8/parent-pom-1.10.8.pom (44 kB at 25 kB/s)
[INFO] 
[INFO] ------------------------------------------------------------------------
[INFO] Building centc434-validation-rules 1.0.0
[INFO] ------------------------------------------------------------------------
Downloading from central: https://repo.maven.apache.org/maven2/com/helger/maven/ph-buildinfo-maven-plugin/3.0.0/ph-buildinfo-maven-plugin-3.0.0.pom
Downloaded from central: https://repo.maven.apache.org/maven2/com/helger/maven/ph-buildinfo-maven-plugin/3.0.0/ph-buildinfo-maven-plugin-3.0.0.pom (4.9 kB at 11 kB/s)
...

[INFO] 
[INFO] --- ph-buildinfo-maven-plugin:3.0.0:generate-buildinfo (default) @ centc434-validation-rules ---
Downloading from central: https://repo.maven.apache.org/maven2/org/apache/maven/maven-plugin-api/3.0/maven-plugin-api-3.0.pom
Downloaded from central: https://repo.maven.apache.org/maven2/org/apache/maven/maven-plugin-api/3.0/maven-plugin-api-3.0.pom (2.3 kB at 6.0 kB/s)
...

[INFO] Successfully created temp directory buildinfo-maven-plugin
[INFO] 
[INFO] --- ph-schematron-maven-plugin:5.2.0:preprocess (cii) @ centc434-validation-rules ---
Downloading from central: https://repo.maven.apache.org/maven2/org/apache/maven/maven-plugin-api/3.5.3/maven-plugin-api-3.5.3.pom
Downloaded from central: https://repo.maven.apache.org/maven2/org/apache/maven/maven-plugin-api/3.5.3/maven-plugin-api-3.5.3.pom (2.9 kB at 9.7 kB/s)
...

[INFO] Successfully wrote preprocessed Schematron file 'cii/schematron/preprocessed/EN16931-CII-validation-preprocessed.sch'
[INFO] 
[INFO] --- ph-schematron-maven-plugin:5.2.0:preprocess (edifact) @ centc434-validation-rules ---
[INFO] Successfully wrote preprocessed Schematron file 'edifact/schematron/preprocessed/EN16931-EDIFACT-validation-preprocessed.sch'
[INFO] 
[INFO] --- ph-schematron-maven-plugin:5.2.0:preprocess (ubl) @ centc434-validation-rules ---
[INFO] Successfully wrote preprocessed Schematron file 'ubl/schematron/preprocessed/EN16931-UBL-validation-preprocessed.sch'
[INFO] ------------------------------------------------------------------------
[INFO] BUILD SUCCESS
[INFO] ------------------------------------------------------------------------
[INFO] Total time: 01:03 min
[INFO] Finished at: 2020-09-14T07:20:15+09:00
[INFO] Final Memory: 15M/36M
[INFO] ------------------------------------------------------------------------
[ec2-user@ip-xx-x-x-xxx eInvoicing-EN16931-validation-1.3.2]$

[ec2-user@ip-xx-x-x-xxx eInvoicing-EN16931-validation-1.3.2]$ mvn -f pom-xslt.xml process-resources
[INFO] Scanning for projects...
[INFO] 
[INFO] ------------------------------------------------------------------------
[INFO] Building centc434-validation-rules 1.0.0
[INFO] ------------------------------------------------------------------------
Downloading from central: https://repo.maven.apache.org/maven2/org/apache/maven/plugins/maven-resources-plugin/3.1.0/maven-resources-plugin-3.1.0.pom
Downloaded from central: https://repo.maven.apache.org/maven2/org/apache/maven/plugins/maven-resources-plugin/3.1.0/maven-resources-plugin-3.1.0.pom (7.2 kB at 6.1 kB/s)
...

[INFO] 
[INFO] --- ph-buildinfo-maven-plugin:3.0.0:generate-buildinfo (default) @ centc434-validation-rules ---
[INFO] Successfully created temp directory buildinfo-maven-plugin
[INFO] 
[INFO] --- ph-schematron-maven-plugin:5.2.0:convert (cii) @ centc434-validation-rules ---
[INFO] Converting Schematron file 'cii/schematron/EN16931-CII-validation.sch' to XSLT file 'cii/xslt/EN16931-CII-validation.xslt'
[INFO] 
[INFO] --- ph-schematron-maven-plugin:5.2.0:convert (edifact) @ centc434-validation-rules ---
[INFO] Converting Schematron file 'edifact/schematron/EN16931-EDIFACT-validation.sch' to XSLT file 'edifact/xslt/EN16931-EDIFACT-validation.xslt'
[INFO] 
[INFO] --- ph-schematron-maven-plugin:5.2.0:convert (ubl) @ centc434-validation-rules ---
[INFO] Converting Schematron file 'ubl/schematron/EN16931-UBL-validation.sch' to XSLT file 'ubl/xslt/EN16931-UBL-validation.xslt'
[INFO] 
[INFO] --- maven-resources-plugin:3.1.0:resources (default-resources) @ centc434-validation-rules ---
Downloading from central: https://repo.maven.apache.org/maven2/org/codehaus/plexus/plexus-component-annotations/1.7.1/plexus-component-annotations-1.7.1.pom
Downloaded from central: https://repo.maven.apache.org/maven2/org/codehaus/plexus/plexus-component-annotations/1.7.1/plexus-component-annotations-1.7.1.pom (770 B at 1.3 kB/s)
...

[INFO] Using 'UTF-8' encoding to copy filtered resources.
[INFO] skip non existing resourceDirectory src/main/resources
[INFO] Copying 1 resource to META-INF
[INFO] ------------------------------------------------------------------------
[INFO] BUILD SUCCESS
[INFO] ------------------------------------------------------------------------
[INFO] Total time: 23:26 min
[INFO] Finished at: 2020-09-14T07:44:29+09:00
[INFO] Final Memory: 21M/146M
[INFO] ------------------------------------------------------------------------
[ec2-user@ip-xx-x-x-xxx eInvoicing-EN16931-validation-1.3.2]$ 
```
```
[ec2-user@ip-xx-x-x-xxx eInvoicing-EN16931-validation-1.3.2]$ mvn -f pom-license.xml license:format
[INFO] Scanning for projects...
Downloading from central: https://repo.maven.apache.org/maven2/org/apache/maven/plugins/maven-compiler-plugin/3.8.0/maven-compiler-plugin-3.8.0.pom
Downloaded from central: https://repo.maven.apache.org/maven2/org/apache/maven/plugins/maven-compiler-plugin/3.8.0/maven-compiler-plugin-3.8.0.pom (12 kB at 10 kB/s)
...

[INFO] 
[INFO] ------------------------------------------------------------------------
[INFO] Building centc434-validation-rules 1.3.0
[INFO] ------------------------------------------------------------------------
[INFO] 
[INFO] --- license-maven-plugin:3.0:format (default-cli) @ centc434-validation-rules ---
Downloading from central: https://repo.maven.apache.org/maven2/org/apache/maven/maven-plugin-api/3.1.0/maven-plugin-api-3.1.0.pom
Downloaded from central: https://repo.maven.apache.org/maven2/org/apache/maven/maven-plugin-api/3.1.0/maven-plugin-api-3.1.0.pom (3.0 kB at 12 kB/s)
...

[INFO] Updating license headers...
[INFO] Updating license header in: ubl/schematron/preprocessed/EN16931-UBL-validation-preprocessed.sch
[INFO] Updating license header in: ubl/xslt/EN16931-UBL-validation.xslt
[INFO] Updating license header in: cii/schematron/preprocessed/EN16931-CII-validation-preprocessed.sch
[INFO] Updating license header in: cii/xslt/EN16931-CII-validation.xslt
[INFO] Updating license header in: edifact/schematron/preprocessed/EN16931-EDIFACT-validation-preprocessed.sch
[INFO] Updating license header in: edifact/xslt/EN16931-EDIFACT-validation.xslt
[INFO] ------------------------------------------------------------------------
[INFO] BUILD SUCCESS
[INFO] ------------------------------------------------------------------------
[INFO] Total time: 22.528 s
[INFO] Finished at: 2020-09-14T07:46:33+09:00
[INFO] Final Memory: 12M/32M
[INFO] ------------------------------------------------------------------------
[ec2-user@ip-xx-x-x-xxx eInvoicing-EN16931-validation-1.3.2]$

[ec2-user@ip-xx-x-x-xxx eInvoicing-EN16931-validation-1.3.2]$ mvn -f pom-validate.xml validate
[INFO] Scanning for projects...
[INFO] 
[INFO] ------------------------------------------------------------------------
[INFO] Building centc434-validation-rules 1.0.0
[INFO] ------------------------------------------------------------------------
[INFO] 
[INFO] --- ph-schematron-maven-plugin:5.2.0:validate (cii) @ centc434-validation-rules ---
[INFO] Compiling XSLT instance [file=cii/xslt/EN16931-CII-validation.xslt]
[INFO] Successfully parsed Schematron file 'cii/xslt/EN16931-CII-validation.xslt'
[INFO] Validating XML file 'cii/examples/CII_example1.xml' against Schematron rules from 'cii/xslt/EN16931-CII-validation.xslt' expecting success
[INFO] Creating JAXB context for package org.oclc.purl.dsdl.svrl using ClassLoader ClassRealm[plugin>com.helger.maven:ph-schematron-maven-plugin:5.2.0, parent: sun.misc.Launcher$AppClassLoader@7852e922]
[INFO] Validating XML file 'cii/examples/CII_business_example_02.xml' against Schematron rules from 'cii/xslt/EN16931-CII-validation.xslt' expecting success
[INFO] Validating XML file 'cii/examples/CII_example6.xml' against Schematron rules from 'cii/xslt/EN16931-CII-validation.xslt' expecting success
[INFO] Validating XML file 'cii/examples/CII_example4.xml' against Schematron rules from 'cii/xslt/EN16931-CII-validation.xslt' expecting success
[INFO] Validating XML file 'cii/examples/CII_example3.xml' against Schematron rules from 'cii/xslt/EN16931-CII-validation.xslt' expecting success
[INFO] Validating XML file 'cii/examples/CII_example2.xml' against Schematron rules from 'cii/xslt/EN16931-CII-validation.xslt' expecting success
[INFO] Validating XML file 'cii/examples/CII_business_example_01.xml' against Schematron rules from 'cii/xslt/EN16931-CII-validation.xslt' expecting success
[INFO] Validating XML file 'cii/examples/CII_example7.xml' against Schematron rules from 'cii/xslt/EN16931-CII-validation.xslt' expecting success
[INFO] Validating XML file 'cii/examples/CII_example5.xml' against Schematron rules from 'cii/xslt/EN16931-CII-validation.xslt' expecting success
[INFO] Validating XML file 'cii/examples/CII_example9.xml' against Schematron rules from 'cii/xslt/EN16931-CII-validation.xslt' expecting success
[INFO] Validating XML file 'cii/examples/CII_example8.xml' against Schematron rules from 'cii/xslt/EN16931-CII-validation.xslt' expecting success
[INFO] 
[INFO] --- ph-schematron-maven-plugin:5.2.0:validate (edifact) @ centc434-validation-rules ---
[INFO] Compiling XSLT instance [file=edifact/xslt/EN16931-EDIFACT-validation.xslt]
[INFO] Successfully parsed Schematron file 'edifact/xslt/EN16931-EDIFACT-validation.xslt'
[INFO] Validating XML file 'edifact/examples/EDIFACT_EXAMPLE4.xml' against Schematron rules from 'edifact/xslt/EN16931-EDIFACT-validation.xslt' expecting success
[INFO] Validating XML file 'edifact/examples/EDIFACT_EXAMPLE8.xml' against Schematron rules from 'edifact/xslt/EN16931-EDIFACT-validation.xslt' expecting success
[INFO] Validating XML file 'edifact/examples/EDIFACT_EXAMPLE9.xml' against Schematron rules from 'edifact/xslt/EN16931-EDIFACT-validation.xslt' expecting success
[INFO] Validating XML file 'edifact/examples/EDIFACT_EXAMPLE2.xml' against Schematron rules from 'edifact/xslt/EN16931-EDIFACT-validation.xslt' expecting success
[INFO] Validating XML file 'edifact/examples/EDIFACT_EXAMPLE3.xml' against Schematron rules from 'edifact/xslt/EN16931-EDIFACT-validation.xslt' expecting success
[INFO] Validating XML file 'edifact/examples/EDIFACT_EXAMPLE7.xml' against Schematron rules from 'edifact/xslt/EN16931-EDIFACT-validation.xslt' expecting success
[INFO] Validating XML file 'edifact/examples/EDIFACT_EXAMPLE1.xml' against Schematron rules from 'edifact/xslt/EN16931-EDIFACT-validation.xslt' expecting success
[INFO] Validating XML file 'edifact/examples/EDIFACT_EXAMPLE5.xml' against Schematron rules from 'edifact/xslt/EN16931-EDIFACT-validation.xslt' expecting success
[INFO] Validating XML file 'edifact/examples/EDIFACT_EXAMPLE6.xml' against Schematron rules from 'edifact/xslt/EN16931-EDIFACT-validation.xslt' expecting success
[INFO] 
[INFO] --- ph-schematron-maven-plugin:5.2.0:validate (ubl) @ centc434-validation-rules ---
[INFO] Compiling XSLT instance [file=ubl/xslt/EN16931-UBL-validation.xslt]
[INFO] Successfully parsed Schematron file 'ubl/xslt/EN16931-UBL-validation.xslt'
[INFO] Validating XML file 'ubl/examples/ubl-tc434-creditnote1.xml' against Schematron rules from 'ubl/xslt/EN16931-UBL-validation.xslt' expecting success
[INFO] Validating XML file 'ubl/examples/ubl-tc434-example2.xml' against Schematron rules from 'ubl/xslt/EN16931-UBL-validation.xslt' expecting success
[INFO] Validating XML file 'ubl/examples/ubl-tc434-example3.xml' against Schematron rules from 'ubl/xslt/EN16931-UBL-validation.xslt' expecting success
[INFO] Validating XML file 'ubl/examples/ubl-tc434-example1.xml' against Schematron rules from 'ubl/xslt/EN16931-UBL-validation.xslt' expecting success
[INFO] Validating XML file 'ubl/examples/ubl-tc434-example7.xml' against Schematron rules from 'ubl/xslt/EN16931-UBL-validation.xslt' expecting success
[INFO] Validating XML file 'ubl/examples/ubl-tc434-example5.xml' against Schematron rules from 'ubl/xslt/EN16931-UBL-validation.xslt' expecting success
[INFO] Validating XML file 'ubl/examples/ubl-tc434-example6.xml' against Schematron rules from 'ubl/xslt/EN16931-UBL-validation.xslt' expecting success
[INFO] Validating XML file 'ubl/examples/ubl-tc434-example4.xml' against Schematron rules from 'ubl/xslt/EN16931-UBL-validation.xslt' expecting success
[INFO] Validating XML file 'ubl/examples/ubl-tc434-example9.xml' against Schematron rules from 'ubl/xslt/EN16931-UBL-validation.xslt' expecting success
[INFO] Validating XML file 'ubl/examples/ubl-tc434-example8.xml' against Schematron rules from 'ubl/xslt/EN16931-UBL-validation.xslt' expecting success
[INFO] ------------------------------------------------------------------------
[INFO] BUILD SUCCESS
[INFO] ------------------------------------------------------------------------
[INFO] Total time: 11.456 s
[INFO] Finished at: 2020-09-14T07:47:03+09:00
[INFO] Final Memory: 70M/167M
[INFO] ------------------------------------------------------------------------
[ec2-user@ip-xx-x-x-xxx eInvoicing-EN16931-validation-1.3.2]$ 
```