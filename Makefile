ECHO=
LOCAL=/home/lou/Public
SCHEMA1=$(LOCAL)/WG1/distantreading.github.io/Schema/eltec-1.rng
CORPUS=$(LOCAL)/ELTeC-eng
CORPUS1=$(LOCAL)/ELTeC-eng/level1
SCHEMA0=$(LOCAL)/WG1/distantreading.github.io/Schema/eltec-0.rng
CORPUS0=$(LOCAL)/ELTeC-eng/level0
CORPUSHDR=corpHeaderStart.txt
REPORTER=$(LOCAL)/Scripts/reporter.xsl
CURRENT=`pwd`

validate:
	cd $(CORPUS1); for f in *.xml ; do \
		echo $$f; \
		jing  $(SCHEMA1) \
		$$f ; done; cd $(CURRENT);
	cd $(CORPUS0); for f in *.xml ; do \
		echo $$f; \
		jing  $(SCHEMA0) \
		$$f ; done; cd $(CURRENT);

driver:
	echo rebuild driver file
	cp $(CORPUSHDR) $(CORPUS)/driver.tei;\
		for f in $(CORPUS)/*/*.xml ; do \
		echo "<xi:include href='$$f'/>" >> $(CORPUS)/driver.tei; \
	done; echo "</teiCorpus>" >> $(CORPUS)/driver.tei

schema: 
	echo rebuild schemas from ODD
	cd /home/lou/Public/WG1/
	teitoodd --localsource=/home/lou/Public/TEI/P5/p5subset.xml eltec.xml eltec-compiled.xml
	teitorelaxng  --localsource=/home/lou/Public/TEI/P5/p5subset.xml eltec-0.xml distantreading.github.io/Schema/eltec-0.rng
	teitorelaxng  --localsource=/home/lou/Public/TEI/P5/p5subset.xml eltec-1.xml distantreading.github.io/Schema/eltec-1.rng
	teitohtml --odd --localsource=/home/lou/Public/TEI/P5/p5subset.xml eltec-0.xml distantreading.github.io/eltec-0.html
	teitohtml --odd --localsource=/home/lou/Public/TEI/P5/p5subset.xml eltec-1.xml distantreading.github.io/eltec-1.html
	cd $(CURRENT)
report:
	echo report on corpus balance
	saxon -xi $(CORPUS)/driver.tei $(REPORTER) >balance_report.html
