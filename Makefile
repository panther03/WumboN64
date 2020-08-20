###
# This Makefile can be used to make a parser for the Wumbo language
# (parser.class) and to make a program (P6.class) that tests code generator.
#
# make clean removes all generated files.
#
###

JC = javac
CP = ./deps:.

P6.class: P6.java parser.class Yylex.class ASTnode.class
	$(JC) -g -cp $(CP) P6.java

parser.class: parser.java ASTnode.class Yylex.class ErrMsg.class
	$(JC) -g -cp $(CP) parser.java

parser.java: Wumbo.cup
	java -cp $(CP) java_cup.Main < Wumbo.cup

Yylex.class: Wumbo.jlex.java sym.class ErrMsg.class
	$(JC) -g -cp $(CP) Wumbo.jlex.java

ASTnode.class: ast.java Type.java Sym.class
	$(JC) -g -cp $(CP) ast.java Type.java

Wumbo.jlex.java: Wumbo.jlex sym.class
	java -cp $(CP) JLex.Main Wumbo.jlex

sym.class: sym.java
	$(JC) -g -cp $(CP) sym.java

sym.java: Wumbo.cup
	java java_cup.Main < Wumbo.cup

ErrMsg.class: ErrMsg.java
	$(JC) -g -cp $(CP) ErrMsg.java

Sym.class: Sym.java Type.class ast.java
	$(JC) -g -cp $(CP) Sym.java ast.java

SymTable.class: SymTable.java Sym.class DuplicateSymException.class EmptySymTableException.class
	$(JC) -g -cp $(CP) SymTable.java

Type.class: Type.java ast.java Sym.java
	$(JC) -g -cp $(CP) Type.java ast.java Sym.java

DuplicateSymException.class: DuplicateSymException.java
	$(JC) -g -cp $(CP) DuplicateSymException.java

EmptySymTableException.class: EmptySymTableException.java
	$(JC) -g -cp $(CP) EmptySymTableException.java

###
# cmpl
#
cmpl:
ifeq ($(WUMBO_USE_JAR),YES)
	java -jar WumboN64.jar test.wumbo temp.asm
	cat INC/ROM_SKEL.asm temp.asm | cat - INC/ROM_SKEL_POST.asm > out.asm
	rm temp.asm
else
	java -cp $(CP) P6 test.wumbo temp.asm
	cat INC/ROM_SKEL.asm temp.asm | cat - INC/ROM_SKEL_POST.asm > out.asm
	rm temp.asm
endif

###
# jar
#
jar: P6.class
	jar cvfm WumboN64.jar manifest.txt *.class
	$(MAKE) -C deps -f Makefile jar

### 
# rom
# 
rom: cmpl

ifeq ($(WUMBO_TOOLS),SYSTEM)
	bass out.asm
	chksum64 out.N64
else
	tools/bass out.asm
	tools/chksum64 out.N64
endif
	
###
# play
#
play:

ifeq ($(WUMBO_DEBUG),YES)
	mame n64 -window -cart out.N64 -switchres -nofilter -debug
else
	mame n64 -window -cart out.N64 -switchres -nofilter
endif

###
# clean
###
clean:
	rm -f *~ *.class parser.java Wumbo.jlex.java sym.java

cleanrom:
	rm -f out.asm
	rm -f out.N64