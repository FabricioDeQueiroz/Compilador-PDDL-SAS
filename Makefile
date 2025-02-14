# all:
# 	bison -t -d sintax.y
# 	flex lexerWithMain.l
# 	@echo "#include \"sintax.tab.h\"" > link.c
# 	@echo "#include \"lex.yy.c\"" >> link.c
# 	@echo "#include \"sintax.tab.c\"" >> link.c
# 	g++ -E link.c -o compiler.c -DYYDEBUG -lfl
# 	g++ -o pddl_sintax compiler.c
# 	rm lex.yy.c sintax.tab.* sintax.output link.c

all:
	bison -t -d -v -Wcounterexamples sintax.y
	flex lexerWithMain.l
	@echo "#include \"sintax.tab.h\"" > link.c
	@echo "#include \"lex.yy.c\"" >> link.c
	@echo "#include \"sintax.tab.c\"" >> link.c
	g++ -E link.c -o compiler.c -lfl
	g++ -o pddl_sintax compiler.c
	rm lex.yy.c sintax.tab.* sintax.output link.c

cpp:
	bison -t -d -v sintax.ypp
	flex lexerWithMain.l
	@echo "#include \"sintax.tab.hpp\"" > link.c
	@echo "#include \"lex.yy.c\"" >> link.c
	@echo "#include \"sintax.tab.cpp\"" >> link.c
	g++ -E link.c -o compiler.c
	g++ -o pddl_sintax compiler.c
	rm lex.yy.c sintax.tab.* sintax.output link.c

test1:
	./pddl_sintax PDDL-Exemplo/dom.pddl PDDL-Exemplo/prob.pddl

test2:
	./pddl_sintax PDDL-Exemplo/dom2.pddl PDDL-Exemplo/prob2.pddl

test3:
	./pddl_sintax PDDL-Exemplo/dom3.pddl PDDL-Exemplo/prob3.pddl

testpy:
	./pddl_sintax PDDL-Exemplo/teste.py

sintest1:
	./pddl_sintax PDDL-Exemplo/dom4.pddl PDDL-Exemplo/prob4.pddl

sintest2:
	./pddl_sintax PDDL-Exemplo/dom5.pddl PDDL-Exemplo/prob5.pddl

# clean:	
# 	rm lex.yy.c sintax.tab.* sintax.output link.c compiler.c pddl_sintax link.c
# 	clear

clean:
	rm compiler.c pddl_sintax
	clear