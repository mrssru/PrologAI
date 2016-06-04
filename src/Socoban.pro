domains
i=integer
s=symbol
iList=i*
database
cell(i,i,s,i) 					% ячейки уровня x, y, box || player, конечная точка для ящика Пример(1,1,Box,-1)
predicates
nondeterm start					% цель
nondeterm init					% инициализация
nondeterm print(i,i)				% вывод игрового поля
nondeterm print_element(i,i)			% возвращает значение ячейки игрового поля (box,player,empty)
nondeterm find_box_for_move			% поиск ящика для движения
nondeterm move_to(i,i)				% проверка возможности передвинуться в одном из направлений up, down, right, left
nondeterm move(i,i)				% граф движения
nondeterm move_from_to(i,i)			% поиск пути from to
nondeterm search_dpth(i,i).			% интерфейс для поиска
nondeterm next_move(iList,iList).		% делаем следующий ход
nondeterm dpth(iList,i,iList).			% сам поиск
nondeterm show_path(iList).			% показать путь
nondeterm member(i,iList)			% проверка проходили ли мы уже по клетке
clauses
% граф движения
move(1,2).
move(1,3).
move(2,4).
move(3,4).
move(3,5).
move(4,6).
move(5,6).
move(5,9).
move(6,10).
move(6,7).
move(7,8).
move(7,11).
move(8,12).
move(12,11).
move(11,10).
move(10,9).
move(10,14).
move(9,13).
move(14,13).
% поиск пути from to
move_from_to(A,B) if move(A,B); move(B,A).
% делаем следующий ход
next_move([H|T],[New,H|T]) if move(H,New),not(member(New,[H|T])).
% сам поиск
dpth([H|T],H,[H|T]).
dpth(TempWay,Finish,Way) if next_move(TempWay,NewWay),dpth(NewWay,Finish,Way).
% проверка проходили ли мы уже по клетке
member(H,[H|_]).
member(H,[_|T]) if member(H,T).
% интерфейс для поиска
search_dpth(Start,Finish) if dpth([Start],Finish,Way),show_path(Way).
% показать путь
show_path([_]) if !.
show_path([A,B|Tail]) if show_path([B|Tail]),nl,write(B," -> ",A).
% движение к ящику
move_to(X,Y) if X1=X+1, cell(X1,Y,empty,_), !. % move right
move_to(X,Y) if X1=X-1, cell(X1,Y,empty,_), !. % move left
move_to(X,Y) if Y1=Y+1, cell(X,Y1,empty,_), !. % move down
move_to(X,Y) if Y1=Y-1, cell(X,Y1,empty,_), !. % move up
% поиск ящика для движения
find_box_for_move if !.
% цель
start if init, print(1,1).
% инициализация
init if
assert(cell(1,1,empty,-1)), assert(cell(2,1,empty,1)),	 							% row 1
assert(cell(1,2,empty,-1)), assert(cell(2,2,empty,-1)),								% row 2
assert(cell(1,3,box,1)), assert(cell(2,3,player,-1)), assert(cell(3,3,empty,-1)), assert(cell(4,3,empty,-1)), 	% row 3
assert(cell(1,4,empty,-1)), assert(cell(2,4,empty,-1)), assert(cell(3,4,box,-1)), assert(cell(4,4,empty,-1)), 	% row 4
assert(cell(1,5,empty,-1)), assert(cell(2,5,empty,-1)). 							% row 5
% печать поля
print(_,6) if !.
print(X,Y) if Y<6, cell(X,Y,_,_), print_element(X,Y), X1=X+1, print(X1,Y).
print(_,Y) if Y<6, nl, Y1=Y+1, X1=1, print(X1,Y1).
% заполнение каждой клетки поля
print_element(X,Y) if cell(X,Y,box,-1), write(" b"), !.
print_element(X,Y) if cell(X,Y,box,1), write(" B"), !.
print_element(X,Y) if cell(X,Y,player,_), write(" P "), !.
print_element(X,Y) if cell(X,Y,empty,-1), write(" # "), !.
print_element(X,Y) if cell(X,Y,empty,1), write(" * "), !.
print_element(_,_) if !.
goal
start.