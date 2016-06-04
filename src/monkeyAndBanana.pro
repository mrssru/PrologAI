domains
i=integer
s=symbol
IList = i*
database
cell(s, i, s) 					% ячейки клетки
list_storage(Ilist, s)				% 2 списка для box и stick
this_is_the_end(i)				% флаг выполнено ли одно из 3 условий (я+я, п+п, я+п)
predicates
nondeterm start					% цель
nondeterm set_position(i, IList, i, IList) 	% определение начальных положений 			(банан, ящики, обезьяна, палки)
nondeterm check_position(i, IList, i, IList) 	% проверка допустимости позиций обезьяны и банана 	(банан, ящики, обезьяна, палки)
nondeterm monkey_model(i, IList, i, IList) 	% поведение обезьяны 					(банан, ящики, обезьяна, палки)
nondeterm try_get_banana 			% попытка получить банан
nondeterm repeat(s) 				% предложение выполнить задачу еще раз 			(да/нет)
nondeterm ans(s) 				% факт ответа на предложение выполнить задачу еще раз 	(да)
nondeterm reset					% создаем заново базу фактов
nondeterm append(IList,i,IList)			% добавление элемента в список 				(лист, значение, получившийся лист)
nondeterm add_box_list(IList)			% добавление ящика в клетку 				(ящики)
nondeterm add_stick_list(IList)			% добавление палки в клетку 				(палки)
nondeterm add_one_more_box(Ilist)		% предложение добавить еще ящик в клетку 		(ящики)
nondeterm add_one_more_stick(Ilist)		% предложение добавить еще палку в клетку 		(палки)
nondeterm cell_count_check_box(i)		% проверка количества ящиков в ячейке клетки 		(ячейка)
nondeterm cell_count_check_stick(i)		% проверка количества палок в ячейке клетки 		(ячейка)
nondeterm howMany(Ilist,i,i)			% определение количество вхождений элемента в список 	(лист, элемент, количество)
nondeterm getLenList(Ilist,i)			% определение количества элементов в списке 		(лист, количество)
nondeterm end_check(Ilist,Ilist,i)		% проверка одного из 3 состояний(я+я, п+п, я+п) если да this_is_the_end = 1 (ящики, палки, банан)
nondeterm action				% в зависимости от значения this_is_the_end выводится текст действия для (я+я, п+п, я+п)
nondeterm monkey_move(i,i)			% перемещение обезьяны 					(обезьяна, предмет)
nondeterm find_item(Ilist,Ilist,i,s,i)		% поиск второго элемента для выполнения условия я+я, п+п, п+я (ящики, палки, клетка, тип(box,stick), банан)
nondeterm search(Ilist, s, s, i,i)		% поиск подходящего элемента для выполнения одного из условий (я+я, п+п, я+п) (список, тип1(box,stick), тип2(first,second), ячейка, банан)
nondeterm replace(i,i,Ilist,Ilist)		% замена первого вхождения элемента в список (элемент который надо найти, элемент который заменит старый, начальный список, конечный список)
nondeterm move_to_item(i,i,s)			% перемещение обезьяны с ящиком или палкой под банан 	(ячейка, банан, тип(box,stick))
nondeterm destructor				% перед повторным использованием очещаем полностью остатки баз данных и заполняем сначала
clauses
% перед повторным использованием через repeat, удаляем полностью базы чтобы не вылазили ошибки из за остатков баз предидущего использования
destructor if retractall(cell(stick,_,_)), retractall(cell(box,_,_)), retractall(cell(banana,_,_)), retractall(cell(monkey,_,_)),
retractall(cell(stick,_,_)), retractall(list_storage(_, box)), retractall(list_storage(_, stick)), retractall(this_is_the_end(0)).
% перемещение ящика и обезьяны под банан и редактирование листа ящиков
move_to_item(Value,Banana,Type) if Type=box, write(" Обезьяна передвигает ящик из позиции ", Value," в позицию ",Banana,"."), nl,
list_storage(Box, box), replace(Value,Banana,Box,BoxNew), assert(list_storage(BoxNew, box)), retract(list_storage(_, box)).
% перемещение палки и обезьяны под банан и редактирование листа ящиков
move_to_item(Value,Banana,Type) if Type=stick, write(" Обезьяна берет палку из позиции ", Value," в позицию ",Banana,"."), nl,
list_storage(Stick, stick), replace(Value,Banana,Stick,StickNew), assert(list_storage(StickNew, stick)), retract(list_storage(_, stick)).
% по логике этот случай не должен наступить вообще но мало ли как, чтобы не было ошибки
move_to_item(_,_,_) if write(" o_O быть не может но тип потерялся "), nl.
% поиск и замена элемента списка (элемент который надо найти, элемент который заменит старый, начальный список, конечный список)
replace(_,_,[],[]).
replace(Find,New,[Find|T1],[New|T1]) if !.
replace(Find,New,[Y|T1],[Y|T2]) if Find<>Y,replace(Find,New,T1,T2).
% поиск подходящих элементов в клетке чтобы добратся до банана
search([],_,_,_,_) if fail.
search([H|_], Type1, Type2, Value, Banana) if not(H=Banana), cell(Type1,H,Type2), Value=H, !.
search([_|T], Type1, Type2, Value, Banana) if search(T,Type1,Type2,Value,Banana).
% поиск второго элемента для выполнения одного из трех условий (лист ящиков, лист палок, номер ячейки, тип 1-box, 2-stick)
% поиск среди ящиков
find_item(Box,_,Value,Type,Banana) if search(Box, box, second, Value, Banana), Type = box.
% поиск среди палок
find_item(_,Stick,Value,Type,Banana) if search(Stick, stick, second, Value, Banana), Type = stick.
% перемещение обезьяны
% одно из условий выполнено и обезьяна находится под бананом
monkey_move(Monkey,Banana) if not(this_is_the_end(0)), Monkey=Banana.
% одно из условий выполнено и обезьяна находится не под бананом
monkey_move(Monkey,Banana) if not(this_is_the_end(0)), Monkey<>Banana, write(" Обезьяна переходит из позиции ", Monkey," в позицию ", Banana," к банану."), nl.
monkey_move(Monkey,StickOrBox) if this_is_the_end(0), write(" Обезьяна переходит из позиции ", Monkey," в позицию ", StickOrBox,"."), nl.
monkey_move(_,_) if write(" monkey move пусто "), nl.
% this_is_the_end = 1
action if this_is_the_end(1), write(" Обезьяна залезает на первый ящик "), nl, write(" Обезьяна залезает на второй ящик "), nl,
try_get_banana.
% this_is_the_end = 2
action if this_is_the_end(2), write(" Обезьяна берет одну палку"), nl,
write(" Обезьяна берет другую палку"), nl, write(" Обезьяна соединяет их вместе"), nl, try_get_banana.
% this_is_the_end = 3
action if this_is_the_end(3), write(" Обезьяна залезает на ящик"), nl, write(" Обезьяна берет палку"), nl, try_get_banana.
% check на два ящика под бананом this_is_the_end = 1
end_check(Box,_,Banana) if howMany(Box,-1,Result), Result < 1, howMany(Box,Banana,ResultBanana), ResultBanana >= 2,
write(" Под бананом стоят два ящика"), nl, retract(this_is_the_end(_)), assert(this_is_the_end(1)).
% check на две палки под бананом this_is_the_end = 2
end_check(_,Stick,Banana) if howMany(Stick,-1,Result), Result < 1, howMany(Stick,Banana,ResultBanana), ResultBanana >= 2,
write(" Под бананом лежат две палки"), nl, retract(this_is_the_end(_)), assert(this_is_the_end(2)).
% check на ящик и палку под бананом this_is_the_end = 3
end_check(Box,Stick,Banana) if howMany(Box,-1,Result), Result < 1, howMany(Box,Banana,ResultBanana), ResultBanana >= 1,
howMany(Stick,-1,Resulttwo), Resulttwo < 1, howMany(Stick,Banana,ResultBananaSt), ResultBananaSt >= 1,
write(" Есть ящик и палка под бананом "), nl, retract(this_is_the_end(_)), assert(this_is_the_end(3)).
% если не одно из 3 не подошло пусть 0 остается
end_check(_,_,_).
% получить количество элементов листа (лист, количество)
getLenList([],0).
getLenList([_|L],N)if getLenList(L,N1), N=N1+1.
% проверка ввода ящиков не больше 2 в одну клетку
cell_count_check_box(Box) if list_storage(BoxList, box), howMany(BoxList,Box,Count), Count < 1, retract(cell(stick, Box, first)).
cell_count_check_box(Box) if list_storage(BoxList, box), howMany(BoxList,Box,Count), Count < 2, retract(cell(stick, Box, second)).
cell_count_check_box(_) if fail.
% проверка ввода палок не больше 2 в одну клетку + отслеживание уже поставленных ящиков
cell_count_check_stick(Stick) if list_storage(StickList, stick), howMany(StickList,Stick,Count), Count < 1, cell(stick, Stick, first), retract(cell(box, Stick, first)).
cell_count_check_stick(Stick) if list_storage(StickList, stick), howMany(StickList,Stick,Count), Count < 2, cell(stick, Stick, second), retract(cell(box, Stick, second)).
cell_count_check_stick(_) if fail.
% (лист, элемент, количество) Возвращает количество вхождений элемента в листе.
howMany([],_,0).
howMany([A|B],A,X) if !,howMany(B,A,Y), X = Y+1.
howMany([_|B],C,X) if howMany(B,C,X).
% добавление элемента в список (начальный лист, значение, получившийся лист)
append([],X,[X]).
append([H|Xs],X,[H|Ys]) if append(Xs,X,Ys).
% предложение добавить еще один ящик в клетку
add_one_more_box(Ilist) if list_storage(IListNew, box), howMany(IListNew,-1,Count), Count <1, write(" Добавить еще ящик в клетку да/нет?"), nl, write(" "), readln(Answer), nl,
ans(Answer), add_box_list(IList).
add_one_more_box(_).
% предложение добавить еще одну палку в клетку
add_one_more_stick(Ilist) if list_storage(IListNew, stick), howMany(IListNew,-1,Count), Count <1, write(" Добавить еще палку в клетку да/нет?"), nl, write(" "), readln(Answer), nl,
ans(Answer), add_stick_list(IList).
add_one_more_stick(_).
% добавление ящика в клетку
add_box_list(IList) if write(" Введите местоположение ящика (1-10) или -1 если ящиков не должно быть: "),
readint(Box), cell(box,Box,_),cell_count_check_box(Box), append(IList,Box,IListNew), assert(list_storage(IListNew, box)), retract(list_storage(_, box)),
add_one_more_box(IListNew).
add_box_list(IListNew) if list_storage(IListNew,box), write(" Введено не правильное значение для ящика или мест нет в выбранной клетке"), nl, add_one_more_box(IListNew).
% добавление палки в клетку
add_stick_list(IList) if write(" Введите местоположение палки (1-10) или -1 если палок не должно быть: "),
readint(Stick), cell(stick,Stick,_), cell_count_check_stick(Stick), append(IList,Stick,IListNew), assert(list_storage(IListNew, stick)),
retract(list_storage(_, stick)), add_one_more_stick(IListNew).
add_stick_list(IListNew) if list_storage(IListNew,stick), write(" Введено не правильное значение для палки или мест нет в выбранной клетке"), nl, add_one_more_stick(IListNew).
% ///////////////////////////////////////
% Факты
% ///////////////////////////////////////
ans(да).
% ///////////////////////////////////////
% База данных разрешенных состояний
% ///////////////////////////////////////
reset if
% лист ящиков
assert(list_storage([], box)),
% лист палок
assert(list_storage([], stick)),
% условие для завершения (1 для я+я, 2 для п+п, 3 для п+я)
assert(this_is_the_end(0)),
% Разрешенные состояния для палки
assert(cell(stick,-1,first)),
assert(cell(stick,1,first)), assert(cell(stick,2,first)), assert(cell(stick,3,first)),
assert(cell(stick,4,first)), assert(cell(stick,5,first)), assert(cell(stick,6,first)),
assert(cell(stick,7,first)), assert(cell(stick,8,first)), assert(cell(stick,9,first)), assert(cell(stick,10,first)),
assert(cell(stick,-1,second)),
assert(cell(stick,1,second)), assert(cell(stick,2,second)), assert(cell(stick,3,second)),
assert(cell(stick,4,second)), assert(cell(stick,5,second)), assert(cell(stick,6,second)),
assert(cell(stick,7,second)), assert(cell(stick,8,second)), assert(cell(stick,9,second)), assert(cell(stick,10,second)),
% Разрешенные состояния для банана
assert(cell(banana,1,one)), assert(cell(banana,2,one)), assert(cell(banana,3,one)), assert(cell(banana,4,one)), assert(cell(banana,5,one)),
assert(cell(banana,6,one)), assert(cell(banana,7,one)), assert(cell(banana,8,one)), assert(cell(banana,9,one)), assert(cell(banana,10,one)),
% Разрешенные состояния для ящика
assert(cell(box,-1,first)),
assert(cell(box,1,first)), assert(cell(box,2,first)), assert(cell(box,3,first)), assert(cell(box,4,first)), assert(cell(box,5,first)),
assert(cell(box,6,first)), assert(cell(box,7,first)), assert(cell(box,8,first)), assert(cell(box,9,first)), assert(cell(box,10,first)),
assert(cell(box,-1,second)),
assert(cell(box,1,second)), assert(cell(box,2,second)), assert(cell(box,3,second)), assert(cell(box,4,second)), assert(cell(box,5,second)),
assert(cell(box,6,second)), assert(cell(box,7,second)), assert(cell(box,8,second)), assert(cell(box,9,second)), assert(cell(box,10,second)),
% Разрешенные состояния для обезьяны
assert(cell(monkey,1,one)), assert(cell(monkey,2,one)), assert(cell(monkey,3,one)), assert(cell(monkey,4,one)), assert(cell(monkey,5,one)),
assert(cell(monkey,6,one)), assert(cell(monkey,7,one)), assert(cell(monkey,8,one)), assert(cell(monkey,9,one)), assert(cell(monkey,10,one)).
% цель
start if destructor, reset, set_position(Banana,Box,Monkey,Stick), nl,
check_position(Banana,Box,Monkey,Stick),
write(" Еще раз да/нет?"), nl, write(" "), readln(Answer), nl, repeat(Answer).
start if write(" Один или несколько параметров введены не правильно"), nl,
write(" Еще раз да/нет?"), nl, write(" "), readln(Answer), nl, repeat(Answer).
repeat(Answer)	if ans(Answer), start.
repeat(_).
% запроса начального расположения объектов
set_position(Banana,Box,Monkey,Stick) if nl, nl,
write(" Введите местоположение банана (1-10) : "),
readint(Banana),
write(" Введите местоположение обезьяны (1-10): "),
readint(Monkey),
add_box_list(_), list_storage(Box, box),
add_stick_list(_), list_storage(Stick, stick).
% проверка
check_position(Banana,Box,Monkey,Stick) if cell(banana,Banana,_),
cell(monkey,Monkey,_), monkey_model(Banana,Box,Monkey,Stick).
% ///////////////////////////////////////
% управление поведением обезьяны
% ///////////////////////////////////////
% обработка не допустимых значений
% ///////////////////////////////////////
% оба параметра пришли -1 в клетке нету ящиков и палок
monkey_model(_,Box,_,Stick) if howMany(Box,-1,Result), Result >= 1, howMany(Stick,-1,Result), Result >= 1,
write(" Ящиков нету в клетке -1"), nl, write(" Палок нету в клетке -1"), nl, write(" В клетке нету палок и ящиков достать не получится "), nl.
% оба списка пусты в клетке нету ящиков и палок
monkey_model(_,Box,_,Stick) if getLenList(Box, Count), Count <1, getLenList(Stick, Counttwo), Counttwo <1,
write(" Ящиков нету в клетке []"), nl, write(" Палок нету в клетке []"), nl, write(" В клетке нету палок и ящиков достать не получится "), nl.
% box -1 stick []
monkey_model(_,Box,_,Stick) if howMany(Box,-1,Result), Result >= 1, getLenList(Stick, Count), Count <1,
write(" Ящиков нету в клетке -1"), nl, write(" Палок нету в клетке []"), nl, write(" В клетке нету палок и ящиков достать не получится "), nl.
% box [] stick -1
monkey_model(_,Box,_,Stick) if howMany(Stick,-1,Result), Result >= 1, getLenList(Box, Count), Count <1,
write(" Палок нету в клетке -1"), nl, write(" Ящиков нету в клетке []"), nl, write(" В клетке нету палок и ящиков достать не получится "), nl.
% ситуация когда не хватает элементов для выполнения например 1 коробка и 0 палок
monkey_model(_,Box,_,Stick) if howMany(Box,-1,Result), Result < 1, getLenList(Box, Count), Count <=1,
getLenList(Stick, Counttwo), Counttwo <=1, howMany(Stick,-1,Resulttwo), Resulttwo >= 1,
write(" Один ящик в клетке"), nl, write(" Палок нету в клетке"), nl, write(" Не достаточно предметов для получения банана "), nl.
% ситуация когда не хватает элементов для выполнения например 0 коробок и 1 палка
monkey_model(_,Box,_,Stick) if howMany(Stick,-1,Result), Result < 1, getLenList(Stick, Count), Count <=1,
getLenList(Box, Counttwo), Counttwo <=1, howMany(Box,-1,Resulttwo), Resulttwo >= 1,
write(" Одна палка в клетке"), nl, write(" Ящиков нету в клетке"), nl, write(" Не достаточно предметов для получения банана "), nl.
% box [] stick 1 элемент
monkey_model(_,Box,_,Stick) if getLenList(Box, Counttwo), Counttwo <1, getLenList(Stick, Count), Count <=1,
write(" ящиков [] палок 1 не получится достать банан"), nl.
% box 1 элемент stick []
monkey_model(_,Box,_,Stick) if getLenList(Stick, Counttwo), Counttwo <1, getLenList(Box, Count), Count <=1,
write(" ящиков 1 палок [] не получится достать банан"), nl.
% ///////////////////////////////////////
% обработка возможных правильных значений
% ///////////////////////////////////////
% начальная проверка на случай совпадения введенных начальных данных одному из трех условий
monkey_model(Banana,Box,Monkey,Stick) if end_check(Box,Stick,Banana), not(this_is_the_end(0)), monkey_move(Monkey,Banana), action.
% варианты когда не выполняется ни одно из трех условий сразу после ввода начальных данных
% под бананом уже стоит ящик ищем еще ящик или палку до кучи
monkey_model(Banana,Box,Monkey,Stick) if end_check(Box,Stick,Banana), this_is_the_end(0), howMany(Box,-1,Result), Result < 1,
howMany(Box,Banana,ResultBanana), ResultBanana >= 1, write(" Есть ящик стоит уже под бананом"), nl, find_item(Box,Stick,Value,Type,Banana),
monkey_move(Monkey,Value), move_to_item(Value,Banana,Type), list_storage(StickNew, stick), list_storage(BoxNew, box),
end_check(BoxNew,StickNew,Banana), not(this_is_the_end(0)), action.
% под бананом уже лежит палка ищем ему ящик или палку до кучи
monkey_model(Banana,Box,Monkey,Stick) if end_check(Box,Stick,Banana), this_is_the_end(0), howMany(Stick,-1,Result), Result < 1,
howMany(Stick,Banana,ResultBanana), ResultBanana >= 1, write(" Есть палка лежит уже под бананом"), nl, find_item(Box,Stick,Value,Type,Banana),
monkey_move(Monkey,Value), move_to_item(Value,Banana,Type), list_storage(StickNew, stick), list_storage(BoxNew, box),
end_check(BoxNew,StickNew,Banana), not(this_is_the_end(0)), action.
% под бананом пусто надо найти 2 ящика, 2 палки или палку и ящик
monkey_model(Banana,Box,Monkey,Stick) if end_check(Box,Stick,Banana), this_is_the_end(0),
write(" под бананом пусто надо найти 2 ящика, 2 палки или палку и ящик"), nl, find_item(Box,Stick,Value,Type,Banana),
monkey_move(Monkey,Value), move_to_item(Value,Banana,Type), list_storage(StickNew, stick), list_storage(BoxNew, box),
find_item(BoxNew,StickNew,ValueNew,TypeNew,Banana), monkey_move(Banana,ValueNew), move_to_item(ValueNew,Banana,TypeNew),
list_storage(StickTheEnd, stick), list_storage(BoxTheEnd, box), end_check(BoxTheEnd,StickTheEnd,Banana), not(this_is_the_end(0)), action.
% обезьяна пытается добратся до бананов
try_get_banana if write(" Обезьяна пытается достать банан "), nl,
random(Y), (Y*10)<5, write(" Не удачная попытка. Пробует еще раз..."), nl, try_get_banana.
% рандом получаем числа от (0,1) умножаем на 10 получаем от 1 до 9 если меньше 5 не получилось пробует еще раз.
try_get_banana if write(" Обезьяна достает банан."), nl,
write(" Обезьяна добралась до банана !"), nl, nl,
write(" ЗАДАНИЕ ВЫПОЛНЕНО !!!"), nl, nl.
goal
start.