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
	cp sintax.yacc sintax.y
	bison -d sintax.y
	flex lexerWithMain.l
	@echo "#include \"sintax.tab.h\"" > link.c
	@echo "#include \"lex.yy.c\"" >> link.c
	@echo "#include \"sintax.tab.c\"" >> link.c
	gcc -E link.c -o compiler.c -lfl
	gcc -o pddl_sintax compiler.c
	rm lex.yy.c sintax.tab.* link.c

debug:
	cp sintax.yacc sintax.y
	bison -d sintax.y
	flex lexerWithMain.l
	@echo "#include \"sintax.tab.h\"" > link.c
	@echo "#include \"lex.yy.c\"" >> link.c
	@echo "#include \"sintax.tab.c\"" >> link.c
	gcc -E link.c -o compiler.c -DYYDEBUG -lfl
	gcc -o pddl_sintax compiler.c
	rm lex.yy.c sintax.tab.* link.c

test1:
	./pddl_sintax PDDL-DOM/dom1.pddl PDDL-PROB/prob1.pddl
	echo -e "\n \n Deveria ter sido: Accepted"

test2:
	./pddl_sintax PDDL-DOM/dom2.pddl PDDL-PROB/prob2.pddl
	echo -e "\n \n Deveria ter sido: Rejected: /tmp/in/problem-fga.pddl at line 35"

test3:
	./pddl_sintax PDDL-DOM/dom3.pddl PDDL-PROB/prob3.pddl
	echo -e "\n \n Deveria ter sido: Rejected: /tmp/in/domain.pddl at line 1"

test4:
	./pddl_sintax PDDL-DOM/dom4.pddl PDDL-PROB/prob4.pddl
	echo -e "\n \n Deveria ter sido: Accepted"

test5:
	./pddl_sintax PDDL-DOM/dom5.pddl PDDL-PROB/prob5.pddl
	echo -e "\n \n Deveria ter sido: Rejected: /tmp/in/problem.pddl at line 34"

test6:
	./pddl_sintax PDDL-DOM/dom6.pddl PDDL-PROB/prob6.pddl
	echo -e "\n \n Deveria ter sido: Rejected: /tmp/in/domain-snake.pddl at line 26"

test7:
	./pddl_sintax PDDL-DOM/dom7.pddl PDDL-PROB/prob7.pddl
	echo -e "\n \n Deveria ter sido: Accepted"

test8:
	./pddl_sintax PDDL-DOM/dom8.pddl PDDL-PROB/prob8.pddl
	echo -e "\n \n Deveria ter sido: Accepted"

test9:
	./pddl_sintax PDDL-DOM/dom9.pddl PDDL-PROB/prob9.pddl
	echo -e "\n \n Deveria ter sido: Rejected: /tmp/in/domain.pddl at line 9"

test10:	
	./pddl_sintax PDDL-DOM/dom10.pddl PDDL-PROB/prob10.pddl
	echo -e "\n \n Deveria ter sido: Rejected: /tmp/in/domain.pddl at line 2"

test11:
	./pddl_sintax PDDL-DOM/dom11.pddl PDDL-PROB/prob11.pddl
	echo -e "\n \n Deveria ter sido: Accepted"

test12:
	./pddl_sintax PDDL-DOM/dom12.pddl PDDL-PROB/prob12.pddl
	echo -e "\n \n Deveria ter sido: Accepted"

testall:
	clear
	make test1
	echo -e "\n \n"
	make test2
	echo -e "\n \n"
	make test3
	echo -e "\n \n"
	make test4
	echo -e "\n \n"
	make test5
	echo -e "\n \n"
	make test6
	echo -e "\n \n"
	make test7
	echo -e "\n \n"
	make test8
	echo -e "\n \n"
	make test9
	echo -e "\n \n"
	make test10
	echo -e "\n \n"
	make test11
	echo -e "\n \n"
	make test12
	echo -e "\n \n"

clean:
	clear
	rm compiler.c pddl_sintax sintax.y
	clear