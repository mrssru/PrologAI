domains
i=integer
s=symbol
IList = i*
database
code_frog_position(i,i)				% храним позицию лягушки для 1 и 3 четверти
code_mosquito_position(i,i)			% храним позицию комара для 1 и 3 четверти
code_ma_check(i,i)				% храним все возможные варианты хода комара отраженный вариант
swamp(s,s,i,i)					% болото (комар, лягушка, X, Y)
move_order(s,i)					% хранится очередь хода
choose(i)					% хранится выбор игрока за кого играет 1- комар 2 -лягушка
quarter(i)					% хранится информация в какой четверти находится комар (1-2-3-4) против часовой стрелки начало X>0 Y>0
frog_position(i,i)				% хранит координаты лягушки (X,Y)
mosquito_position(i,i)				% хранит координаты комара (X,Y)
mosquito_position_next(i,i)			% хранит следующее положение комара
mosquito_check_X(i)				% проверка на возможность перемещения комара по Х (-1 начальное значение, 0 нет , 1 да)
mosquito_check_Y(i)				% проверка на возможность перемещения комара по Y (-1 начальное значение, 0 нет , 1 да)
frog_check_XY(i)				% проверка на возможность перемещения лягушки X фиксированное Y[1,8] или наоборот
frog_position_next(i,i)				% хранит следующее положение лягушки
win(i)						% хранит флаг победы (-1 начальное значение 0 нет 1 да)
ma_check(i,i)					% все возможные позиции комара
frog_vs_mosquito(i)				% одно из 4 возмжных варианта расположения лягушки от комара
max(i,i,i)					% наибольшая площадь или наименьшая
is_it_code(i,s)					% флаг заменяли порядок следования например X[6,7,8] на X[3,2,1] чтобы не писать доп логику
predicates
nondeterm start					% цель
nondeterm reset					% создаем заново базу фактов
nondeterm destructor				% перед повторным использованием очещаем полностью остатки баз данных и заполняем сначала
nondeterm set_set_position(i,i,i,i) 		% определение начальных положений (комар X, комарY, лягушка X, лягушка Y, игрок выбор)
nondeterm ans(s) 				% факт ответа на предложение выполнить задачу еще раз 	(да)
nondeterm repeat(s) 				% предложение выполнить задачу еще раз 			(да/нет)
nondeterm check_position(i,i,i,i) 		% проверка допустимости позиций комара и лягушки 	(К_X, K_Y, Л_Х, Л_У)
nondeterm set_position				% диалог укажите координаты передвежения
nondeterm start_set_position(i,i,i,i)		% установка в базу начальных положений для комара и лягушки
nondeterm print(i,i)				% вывод игрового поля
nondeterm quarter_definition(i, i)		% определение в какой четверти находится комар(четверть квадрат 4х4 нумерация начинается правый верхний угол и идет против часовой стрелки)
nondeterm frog_move(i,i,i,i)			% перемещение лягушки из позиции (X,Y) в позицию (X1,Y1) (X,Y,X1,Y1)
nondeterm mosquito_move(i,i,i,i)		% перемещение комара из позиции (X,Y) в позицию (X1,Y1) (X,Y,X1,Y1)
nondeterm print_element(i,i)			% возвращает значение ячейки игрового поля (frog,mosquito,empty)
nondeterm first_move				% определяем кто же первый ходит(очередность ходов)
nondeterm mosquito_move_check_X(i)		% проверка введенной Х координаты для комара
nondeterm mosquito_move_check_Y(i) 		% проверка введенной Y координаты для комара
nondeterm frog_move_check(i,i)			% проверка введенных X Y координат для лягушки
nondeterm frog_bot				% ИИ для лягушки
nondeterm mosquito_bot				% ИИ для комара
nondeterm win_check				% проверка выполнено ли хотя бы одно условие для победы
nondeterm mosquito_possible_move		% перечесление всех возможных направлений ходов комара
nondeterm mosquito_available_move		% допустимые ходы из доступных для камора
nondeterm mosqyito_try_move			% на основе расположения лягушки против комара и доступных позиций из текущего места комара отсекаются не допустимые и выбирается лучший из оставшихся
nondeterm code(i)				% заменяем порядок следования например X[6,7,8] на X[3,2,1] чтобы не писать доп логику 1-X,2-Y
nondeterm reflect(i,i)				% (номер, ось) откажает номер на противоположный по оси ось
clauses
% отражаем
reflect(Before,After) if Before=8, After=1.
reflect(Before,After) if Before=7, After=2.
reflect(Before,After) if Before=6, After=3.
reflect(Before,After) if Before=5, After=4.
reflect(Before,After) if Before=4, After=5.
reflect(Before,After) if Before=3, After=6.
reflect(Before,After) if Before=2, After=7.
reflect(Before,After) if Before=1, After=8.
% кодируем для 3 четверти
code(Axis) if Axis=1, code_frog_position(-1,-1), frog_position(FX,FY), reflect(FX,After), retract(code_frog_position(-1,-1)), assert(code_frog_position(After,FY)), fail.
code(Axis) if Axis=1, code_mosquito_position(-1,-1), mosquito_position(MX,MY), reflect(MX,After), retract(code_mosquito_position(-1,-1)), assert(code_mosquito_position(After,MY)), fail.
code(Axis) if Axis=1, code_ma_check(-1,-1), ma_check(X,Y), reflect(X,After), retract(code_ma_check(-1,-1)), assert(code_ma_check(After,Y)), fail.
code(Axis) if Axis=1, ma_check(X,Y), reflect(X,After), assert(code_ma_check(After,Y)), fail.
code(Axis) if Axis=1, !.
% кодируем для 1 четверти
code(Axis) if Axis=2, code_frog_position(-1,-1), frog_position(FX,FY), reflect(FY,After), retract(code_frog_position(-1,-1)), assert(code_frog_position(FX,After)), fail.
code(Axis) if Axis=2, code_mosquito_position(-1,-1), mosquito_position(MX,MY), reflect(MY,After), retract(code_mosquito_position(-1,-1)), assert(code_mosquito_position(MX,After)), fail.
code(Axis) if Axis=2, code_ma_check(-1,-1), ma_check(X,Y), reflect(Y,After), retract(code_ma_check(-1,-1)), assert(code_ma_check(X,After)), fail.
code(Axis) if Axis=2, ma_check(X,Y), reflect(Y,After), assert(code_ma_check(X,After)), fail.
code(Axis) if Axis=2, !.
% на расположения лягушки против комара вариант 1
mosqyito_try_move if frog_vs_mosquito(VS), VS=1, mosquito_position(X,Y), X=1, Y=1, retract(max(_,_,_)), assert(max(1,2,2)), !.
mosqyito_try_move if frog_vs_mosquito(VS), VS=1, ma_check(X,Y), frog_position(FX,FY), FXX=FX-1, FYY=FY-1, X=FXX, Y=FYY, retract(ma_check(X,Y)), fail.
mosqyito_try_move if frog_vs_mosquito(VS), VS=1, ma_check(X,Y), X=0, retract(ma_check(X,Y)), fail.
mosqyito_try_move if frog_vs_mosquito(VS), VS=1, ma_check(X,Y), Y=0, retract(ma_check(X,Y)), fail.
mosqyito_try_move if frog_vs_mosquito(VS), VS=1, ma_check(X,Y), frog_position(FX,_), X=FX, retract(ma_check(X,Y)), fail.
mosqyito_try_move if frog_vs_mosquito(VS), VS=1, ma_check(X,Y), frog_position(_,FY), Y=FY, retract(ma_check(X,Y)), fail.
mosqyito_try_move if frog_vs_mosquito(VS), VS=1, ma_check(X,Y), S=X*Y, max(_,_,Max), S>Max, retract(max(_,_,Max)), assert(max(X,Y,S)), retract(ma_check(X,Y)), fail.
mosqyito_try_move if frog_vs_mosquito(VS), VS=1, ma_check(X,Y), retract(ma_check(X,Y)), fail.
mosqyito_try_move if frog_vs_mosquito(VS), VS=1, !.
% на расположения лягушки против комара вариант 2
mosqyito_try_move if frog_vs_mosquito(VS), VS=2, is_it_code(-1,_), code(1), retract(is_it_code(-1,_)), assert(is_it_code(1,axis_x)), fail.
mosqyito_try_move if frog_vs_mosquito(VS), VS=2, mosquito_position(X,Y), X=8, Y=1, retract(max(_,_,_)), assert(max(8,2,14)), !.
mosqyito_try_move if frog_vs_mosquito(VS), VS=2, code_ma_check(X,Y), code_frog_position(FX,FY), FXX=FX-1, FYY=FY-1, X=FXX, Y=FYY, retract(code_ma_check(X,Y)), fail.
mosqyito_try_move if frog_vs_mosquito(VS), VS=2, code_ma_check(X,Y), X=0, retract(code_ma_check(X,Y)), fail.
mosqyito_try_move if frog_vs_mosquito(VS), VS=2, code_ma_check(X,Y), Y=0, retract(code_ma_check(X,Y)), fail.
mosqyito_try_move if frog_vs_mosquito(VS), VS=2, code_ma_check(X,Y), code_frog_position(FX,_), X=FX, retract(code_ma_check(X,Y)), fail.
mosqyito_try_move if frog_vs_mosquito(VS), VS=2, code_ma_check(X,Y), code_frog_position(_,FY), Y=FY, retract(code_ma_check(X,Y)), fail.
mosqyito_try_move if frog_vs_mosquito(VS), VS=2, code_ma_check(X,Y), S=X*Y, max(_,_,Max), S>Max, retract(max(_,_,Max)), assert(max(X,Y,S)), retract(code_ma_check(X,Y)), fail.
mosqyito_try_move if frog_vs_mosquito(VS), VS=2, code_ma_check(X,Y), retract(code_ma_check(X,Y)), fail.
mosqyito_try_move if frog_vs_mosquito(VS), VS=2, max(X,Y,Max), reflect(X,After), retract(max(X,Y,Max)), assert(max(After,Y,Max)),
		     retract(code_mosquito_position(_,_)), assert(code_mosquito_position(-1,-1)), retract(code_frog_position(_,_)), assert(code_frog_position(-1,-1)),
		     assert(code_ma_check(-1,-1)), retract(is_it_code(_,_)), assert(is_it_code(-1,axis)), !.
% на расположения лягушки против комара вариант 4
mosqyito_try_move if frog_vs_mosquito(VS), VS=4, is_it_code(-1,_), code(2), retract(is_it_code(-1,_)), assert(is_it_code(1,axis_y)), fail.
mosqyito_try_move if frog_vs_mosquito(VS), VS=4, mosquito_position(X,Y), X=1, Y=8, retract(max(_,_,_)), assert(max(1,7,14)), !.
mosqyito_try_move if frog_vs_mosquito(VS), VS=4, code_ma_check(X,Y), code_frog_position(FX,FY), FXX=FX-1, FYY=FY-1, X=FXX, Y=FYY, retract(code_ma_check(X,Y)), fail.
mosqyito_try_move if frog_vs_mosquito(VS), VS=4, code_ma_check(X,Y), X=0, retract(code_ma_check(X,Y)), fail.
mosqyito_try_move if frog_vs_mosquito(VS), VS=4, code_ma_check(X,Y), Y=0, retract(code_ma_check(X,Y)), fail.
mosqyito_try_move if frog_vs_mosquito(VS), VS=4, code_ma_check(X,Y), code_frog_position(FX,_), X=FX, retract(code_ma_check(X,Y)), fail.
mosqyito_try_move if frog_vs_mosquito(VS), VS=4, code_ma_check(X,Y), code_frog_position(_,FY), Y=FY, retract(code_ma_check(X,Y)), fail.
mosqyito_try_move if frog_vs_mosquito(VS), VS=4, code_ma_check(X,Y), S=X*Y, max(_,_,Max), S>Max, retract(max(_,_,Max)), assert(max(X,Y,S)), retract(code_ma_check(X,Y)), fail.
mosqyito_try_move if frog_vs_mosquito(VS), VS=4, code_ma_check(X,Y), retract(code_ma_check(X,Y)), fail.
mosqyito_try_move if frog_vs_mosquito(VS), VS=4, max(X,Y,Max), reflect(Y,After), retract(max(X,Y,Max)), assert(max(X,After,Max)),
		     retract(code_mosquito_position(_,_)), assert(code_mosquito_position(-1,-1)), retract(code_frog_position(_,_)), assert(code_frog_position(-1,-1)),
		     assert(code_ma_check(-1,-1)), retract(is_it_code(_,_)), assert(is_it_code(-1,axis)), !.
% на расположения лягушки против комара вариант 3
mosqyito_try_move if frog_vs_mosquito(VS), VS=3, max(_,_,-1), retract(max(_,_,-1)), assert(max(-1,-1,111)), fail.
mosqyito_try_move if frog_vs_mosquito(VS), VS=3, mosquito_position(X,Y), X=8, Y=8, retract(max(_,_,_)), assert(max(8,7,56)), !.
mosqyito_try_move if frog_vs_mosquito(VS), VS=3, ma_check(X,Y), frog_position(FX,FY), FXX=FX+1, FYY=FY+1, X=FXX, Y=FYY, retract(ma_check(X,Y)), fail.
mosqyito_try_move if frog_vs_mosquito(VS), VS=3, ma_check(X,Y), X=9, retract(ma_check(X,Y)), fail.
mosqyito_try_move if frog_vs_mosquito(VS), VS=3, ma_check(X,Y), Y=9, retract(ma_check(X,Y)), fail.
mosqyito_try_move if frog_vs_mosquito(VS), VS=3, ma_check(X,Y), frog_position(FX,_), X=FX, retract(ma_check(X,Y)), fail.
mosqyito_try_move if frog_vs_mosquito(VS), VS=3, ma_check(X,Y), frog_position(_,FY), Y=FY, retract(ma_check(X,Y)), fail.
mosqyito_try_move if frog_vs_mosquito(VS), VS=3, ma_check(X,Y), S=X*Y, max(_,_,Min), S<Min, retract(max(_,_,Min)), assert(max(X,Y,S)), retract(ma_check(X,Y)), fail.
mosqyito_try_move if frog_vs_mosquito(VS), VS=3, ma_check(X,Y), retract(ma_check(X,Y)), fail.
mosqyito_try_move if frog_vs_mosquito(VS), VS=3, !.
% допустимые ходы из доступных для камора
mosquito_available_move if mosquito_position(MX,MY), frog_position(FX,FY), FX>MX, FY>MY, retract(frog_vs_mosquito(_)), assert(frog_vs_mosquito(1)).
mosquito_available_move if mosquito_position(MX,MY), frog_position(FX,FY), MX>FX, FY>MY, retract(frog_vs_mosquito(_)), assert(frog_vs_mosquito(2)).
mosquito_available_move if mosquito_position(MX,MY), frog_position(FX,FY), MX>FX, MY>FY, retract(frog_vs_mosquito(_)), assert(frog_vs_mosquito(3)).
mosquito_available_move if mosquito_position(MX,MY), frog_position(FX,FY), FX>MX, MY>FY, retract(frog_vs_mosquito(_)), assert(frog_vs_mosquito(4)).
mosquito_available_move if write("<<<").
% перечесление всех возможных направлений ходов комара
mosquito_possible_move if mosquito_position(MX,MY), MXN=MX-1, assert(ma_check(MXN,MY)),
			  MXNN=MX+1, assert(ma_check(MXNN,MY)), MYNN=MY+1, assert(ma_check(MX,MYNN)),
			  MYNO=MY-1, assert(ma_check(MX,MYNO)), MXNU=MX-1, MYNU=MY-1, assert(ma_check(MXNU,MYNU)),
			  MXNR=MX+1, MYNR=MY+1, assert(ma_check(MXNR,MYNR)), MXNT=MX+1, MYNT=MY-1, assert(ma_check(MXNT,MYNT)),
			  MXNC=MX-1, MYNC=MY+1, assert(ma_check(MXNC,MYNC)).
% проверка выполнено ли хотя бы одно условие для победы
win_check if mosquito_position(MX,MY), frog_position(FX,FY), MX<>-1, MY<>-1, FX<>-1, FY<>-1, MX=FX, MY=FY, write("Лягушка и комар в одной клетке "), nl, retract(win(_)), assert(win(1)).
win_check if mosquito_position(MX,MY), frog_position(FX,FY), MX<>-1, MY<>-1, FX<>-1, FY<>-1, MX=FX, write("Лягушка может поймать по X"), nl, retract(win(_)), assert(win(1)).
win_check if mosquito_position(MX,MY), frog_position(FX,FY), MX<>-1, MY<>-1, FX<>-1, FY<>-1, MY=FY, write("Лягушка может поймать по Y"), nl, retract(win(_)), assert(win(1)).
win_check if mosquito_position(MX,MY), frog_position(FX,FY), MX<>-1, MY<>-1, FX<>-1, FY<>-1, MX=FX-1, MY=FY-1, write("Диагональ для 2 четверти "), nl, retract(win(_)), assert(win(1)).
win_check if mosquito_position(MX,MY), frog_position(FX,FY), MX<>-1, MY<>-1, FX<>-1, FY<>-1, MX=FX+1, MY=FY+1, write("Диагональ для 4 четверти "), nl, retract(win(_)), assert(win(1)).
win_check if mosquito_position(MX,MY), frog_position(FX,FY), MX<>-1, MY<>-1, FX<>-1, FY<>-1, MX=FX-1, MY=FY+1, write("Диагональ для 1 четверти "), nl, retract(win(_)), assert(win(1)).
win_check if mosquito_position(MX,MY), frog_position(FX,FY), MX<>-1, MY<>-1, FX<>-1, FY<>-1, MX=FX+1, MY=FY-1, write("Диагональ для 3 четверти "), nl, retract(win(_)), assert(win(1)).
win_check.
% ИИ для лягушки
frog_bot if quarter(Quarter), Quarter = 2, mosquito_position(MX,MY), frog_position(FX,FY), FY=MY+1, FXN=MX+1, frog_move(FX,FY,FXN,FY), retract(frog_position(FX,FY)), assert(frog_position(FXN,FY)),
retract(swamp(_,frog,FX,FY)), assert(swamp(empty,empty,FX,FY)), retract(swamp(_,_,FXN,FY)), assert(swamp(empty,frog,FXN,FY)), print(1,1). %отрезаем по X
frog_bot if quarter(Quarter), Quarter = 2, mosquito_position(_,MY), frog_position(FX,FY), FY<>MY+1, FYN=MY+1, frog_move(FX,FY,FX,FYN), retract(frog_position(FX,FY)), assert(frog_position(FX,FYN)),
retract(swamp(_,frog,FX,FY)), assert(swamp(empty,empty,FX,FY)), retract(swamp(_,_,FX,FYN)), assert(swamp(empty,frog,FX,FYN)), print(1,1).	%отрезаем по Y
frog_bot if quarter(Quarter), Quarter = 3, mosquito_position(MX,MY), frog_position(FX,FY), FY=MY+1, FXN=MX-1, frog_move(FX,FY,FXN,FY), retract(frog_position(FX,FY)), assert(frog_position(FXN,FY)),
retract(swamp(_,frog,FX,FY)), assert(swamp(empty,empty,FX,FY)), retract(swamp(_,_,FXN,FY)), assert(swamp(empty,frog,FXN,FY)), print(1,1).	%X
frog_bot if quarter(Quarter), Quarter = 3, mosquito_position(_,MY), frog_position(FX,FY), FY<>MY+1, FYN=MY+1, frog_move(FX,FY,FX,FYN), retract(frog_position(FX,FY)), assert(frog_position(FX,FYN)),
retract(swamp(_,frog,FX,FY)), assert(swamp(empty,empty,FX,FY)), retract(swamp(_,_,FX,FYN)), assert(swamp(empty,frog,FX,FYN)), print(1,1). %Y
frog_bot if quarter(Quarter), Quarter = 1, mosquito_position(MX,MY), frog_position(FX,FY), FY=MY-1, FXN=MX+1, frog_move(FX,FY,FXN,FY), retract(frog_position(FX,FY)), assert(frog_position(FXN,FY)),
retract(swamp(_,frog,FX,FY)), assert(swamp(empty,empty,FX,FY)), retract(swamp(_,_,FXN,FY)), assert(swamp(empty,frog,FXN,FY)), print(1,1).	%X
frog_bot if quarter(Quarter), Quarter = 1, mosquito_position(_,MY), frog_position(FX,FY), FY<>MY-1, FYN=MY-1, frog_move(FX,FY,FX,FYN), retract(frog_position(FX,FY)), assert(frog_position(FX,FYN)),
retract(swamp(_,frog,FX,FY)), assert(swamp(empty,empty,FX,FY)), retract(swamp(_,_,FX,FYN)), assert(swamp(empty,frog,FX,FYN)), print(1,1).	%Y
frog_bot if quarter(Quarter), Quarter = 4, mosquito_position(MX,MY), frog_position(FX,FY), FY=MY-1, FXN=MX-1, frog_move(FX,FY,FXN,FY), retract(frog_position(FX,FY)), assert(frog_position(FXN,FY)),
retract(swamp(_,frog,FX,FY)), assert(swamp(empty,empty,FX,FY)), retract(swamp(_,_,FXN,FY)), assert(swamp(empty,frog,FXN,FY)), print(1,1).	%X
frog_bot if quarter(Quarter), Quarter = 4, mosquito_position(_,MY), frog_position(FX,FY), FY<>MY-1, FYN=MY-1, frog_move(FX,FY,FX,FYN), retract(frog_position(FX,FY)), assert(frog_position(FX,FYN)),
retract(swamp(_,frog,FX,FY)), assert(swamp(empty,empty,FX,FY)), retract(swamp(_,_,FX,FYN)), assert(swamp(empty,frog,FX,FYN)), print(1,1).	%Y
% ИИ для комара
mosquito_bot if retractall(ma_check(_,_)), mosquito_possible_move, mosquito_available_move, retract(max(_,_,_)), assert(max(-1,-1,-1)), mosquito_position(MX,MY), mosqyito_try_move, max(X,Y,_),
mosquito_move(MX,MY,X,Y), retract(swamp(mosquito,empty,MX,MY)), assert(swamp(empty,empty,MX,MY)), retract(swamp(empty,empty,X,Y)), assert(swamp(mosquito,empty,X,Y)), retract(mosquito_position(_,_)), assert(mosquito_position(X,Y)), print(1,1).
% проверка введенных X Y координат для лягушки
frog_move_check(X,Y) if frog_position(X1,_), X=X1, Y<=8, Y>=1, retract(frog_check_XY(_)), assert(frog_check_XY(1)), retract(frog_position_next(_,_)), assert(frog_position_next(X,Y)).
frog_move_check(X,Y) if frog_position(_,Y1), Y=Y1, X<=8, X>=1,  retract(frog_check_XY(_)), assert(frog_check_XY(1)), retract(frog_position_next(_,_)), assert(frog_position_next(X,Y)).
frog_move_check(_,_) if write("Беда frog "), nl, retract(frog_check_XY(-1)), retract(frog_position_next(_,_)), assert(frog_position_next(-1,-1)), set_position.
% проверка введенной Х координаты для комара
mosquito_move_check_X(X) if mosquito_position(X1,_), X>=X1, X-X1<=1, retract(mosquito_check_X(_)), assert(mosquito_check_X(1)), retract(mosquito_position_next(_,_)), assert(mosquito_position_next(X,-1)).
mosquito_move_check_X(X) if mosquito_position(X1,_), X1>=X, X1-X<=1, retract(mosquito_check_X(_)), assert(mosquito_check_X(1)), retract(mosquito_position_next(_,_)), assert(mosquito_position_next(X,-1)).
mosquito_move_check_X(_) if write("Беда X"), nl, retract(mosquito_check_X(-1)), retract(mosquito_check_Y(-1)),
retract(mosquito_position_next(_,_)), assert(mosquito_position_next(-1,-1)), set_position.
% проверка введенной Y координаты для комара
mosquito_move_check_Y(Y) if mosquito_position(_,Y1), Y>=Y1, Y-Y1<=1, retract(mosquito_check_Y(_)), assert(mosquito_check_Y(1)), retract(mosquito_position_next(X,_)), assert(mosquito_position_next(X,Y)).
mosquito_move_check_Y(Y) if mosquito_position(_,Y1), Y1>=Y, Y1-Y<=1, retract(mosquito_check_Y(_)), assert(mosquito_check_Y(1)), retract(mosquito_position_next(X,_)), assert(mosquito_position_next(X,Y)).
mosquito_move_check_Y(_) if write("Беда Y"), nl,  retract(mosquito_check_X(-1)), retract(mosquito_check_Y(-1)),
retract(mosquito_position_next(_,_)), assert(mosquito_position_next(-1,-1)), set_position.
% играем за комара
first_move if win_check, win(Value), Value=1, mosquito_position(MX,MY), frog_position(FX,FY), frog_move(FX,FY,MX,MY), retract(swamp(mosquito,_,MX,MY)), retract(swamp(_,frog,FX,FY)),
assert(swamp(empty,empty,FX,FY)), assert(swamp(empty,frog,MX,MY)), print(1,1), write(" Лягушка съедает комара "), nl, write(" Лягушка победила "), nl, !.
first_move if win_check, choose(Choose), Choose = 1, write(" Вы играете за Комар ожидаем хода лягушки "), nl, frog_bot,
set_position, mosquito_position_next(X,Y), mosquito_position(X1,Y1), mosquito_move(X1,Y1,X,Y), retract(mosquito_position(X1,Y1)), assert(mosquito_position(X,Y)), print(1,1), first_move.
% играем за лягушку
first_move if choose(Choose), Choose = 2, write(" Вы играете за Лягушка ходите вы "), nl, set_position, frog_position_next(X,Y), frog_position(X1,Y1), frog_move(X1,Y1,X,Y),
retract(frog_position(X1,Y1)), assert(frog_position(X,Y)), mosquito_bot, first_move.
first_move if write("ПРовалилось "), nl.
%заполняем каждую клетку игрововго поля mosquito, frog, empty
print_element(X,Y) if swamp(mosquito,_,X,Y), write(" M"), !.
print_element(X,Y) if swamp(_,frog,X,Y), write(" F "), !.
print_element(X,Y) if swamp(empty, empty, X,Y), write(" * "), !.
print_element(_,_) if !.
%перемещение лягушки
frog_move(StartX,StartY, EndX, EndY) if win(Win), Win=1, write("лягушка прыгает из (",StartX,",",StartY,") в позицию (",EndX,",",EndY,")"),  nl.
frog_move(StartX,StartY, EndX, EndY) if write("лягушка переместилась из (",StartX,",",StartY,") в позицию (",EndX,",",EndY,")"),  nl.
%перемещение комара
mosquito_move(StartX,StartY, EndX, EndY) if write("комар переместился из (",StartX,",",StartY,") в позицию (",EndX,",",EndY,")"), nl.
%определение в какой четверти находится комар
quarter_definition(Mosquito_X, Mosquito_Y) if Mosquito_X>=5, Mosquito_Y<=4, retract(quarter(_)), assert(quarter(1)).
quarter_definition(Mosquito_X, Mosquito_Y) if Mosquito_X<=4, Mosquito_Y<=4, retract(quarter(_)), assert(quarter(2)).
quarter_definition(Mosquito_X, Mosquito_Y) if Mosquito_X<=4, Mosquito_Y>=5, retract(quarter(_)), assert(quarter(3)).
quarter_definition(Mosquito_X, Mosquito_Y) if Mosquito_X>=5, Mosquito_Y>=5, retract(quarter(_)), assert(quarter(4)).
quarter_definition(_,_) if write("По логики не должно быть но мало ли как..."), nl.
%печать игрового поля(сетка) и заполнение каждой клетки
print(9,9) if !.
print(X,Y) if Y<9, print_element(X,Y), Y1=Y+1, print(X,Y1).
print(X,Y) if Y=9, nl, X1=X+1, Y1=1, print(X1,Y1).
%определение стартовых положений для комара и лягушки
start_set_position(Mosquito_X,Mosquito_Y,Frog_X,Frog_Y) if
retract(frog_position(-1,-1)), assert(frog_position(Frog_X, Frog_Y)), retract(mosquito_position(-1,-1)),
assert(mosquito_position(Mosquito_X,Mosquito_Y)), retract(swamp(_,_,Mosquito_X,Mosquito_Y)),
retract(swamp(_,_,Frog_X,Frog_Y)), assert(swamp(mosquito,empty,Mosquito_X,Mosquito_Y)), assert(swamp(empty,frog,Frog_X,Frog_Y)),
print(1,1).
start_set_position(X,Y,X,Y).
start_set_position(_,_,_,_) if write("Ошибка "), nl.
%задать позиции комара или лягушки в зависимости от того за кого играем
%играем за комара
set_position if win(Check), Check<>1, choose(Choose), Choose = 1, write("Ходит комар "), nl, write(" Введите Х=(1-8) "), nl, readint(X),
write(" Введите Y=(1-8) "), nl, readint(Y), swamp(_,_,X,Y), mosquito_move_check_X(X), mosquito_check_X(Status_X), Status_X=1, mosquito_move_check_Y(Y), mosquito_check_Y(Status_Y),
Status_Y=1, mosquito_position(X1,Y1), retract(swamp(_,_,X1,Y1)), assert(swamp(empty,empty,X1,Y1)), retract(swamp(_,_,X,Y)), assert(swamp(mosquito,empty,X,Y)).
%играем за лягушку
set_position if win(Check), Check<>1, choose(Choose), Choose = 2, write("Ходит лягушка "), nl, write(" Введите Х=(1-8) "), nl, readint(X),
write(" Введите Y=(1-8) "), nl, readint(Y), swamp(_,_,X,Y),
mosquito_position(MX,MY), X<>MX,  Y<>MY, frog_move_check(X,Y), frog_check_XY(Status), Status=1, frog_position(X1,Y1),
retract(swamp(_,frog,X1,Y1)), assert(swamp(empty,empty,X1,Y1)), retract(swamp(_,_,X,Y)), assert(swamp(empty,frog,X,Y)).
set_position if win(Check), Check<>1, set_position.
% проверка
check_position(Mosquito_X,Mosquito_Y,Frog_X,Frog_Y) if choose(Choose), Choose = 1, swamp(_,_,Mosquito_X,Mosquito_Y),
swamp(_,_,Frog_X,Frog_Y), start_set_position(Mosquito_X,Mosquito_Y,Frog_X,Frog_Y), quarter_definition(Mosquito_X, Mosquito_Y).
check_position(Mosquito_X,Mosquito_Y,Frog_X,Frog_Y) if choose(Choose), Choose = 2, swamp(_,_,Mosquito_X,Mosquito_Y),
swamp(_,_,Frog_X,Frog_Y), start_set_position(Mosquito_X,Mosquito_Y,Frog_X,Frog_Y), quarter_definition(Mosquito_X, Mosquito_Y).
check_position(_,_,_,_) if write (" Один или несколько параметров введены не верно"), nl, fail.
% запрос начального расположения объектов
set_set_position(Mosquito_X, Mosquito_Y, Frog_X, Frog_Y) if nl, nl,
write(" Введите местоположение комара X=(1-8) : "),
readint(Mosquito_X),
write(" Введите местоположение комара Y=(1-8) : "),
readint(Mosquito_Y),
write(" Введите местоположение лягушки X=(1-8): "),
readint(Frog_X),
write(" Введите местоположение лягушки Y=(1-8): "),
readint(Frog_Y),
write(" За кого играем? Ваш выбор: "), nl,
write(" 1 - комар "), nl,
write(" 2 - лягушка "), nl,
readint(Choose), retract(choose(-1)), assert(choose(Choose)).
% перед повторным использованием через repeat, удаляем полностью базы чтобы не вылазили ошибки из за остатков баз предидущего использования
destructor if retractall(swamp(_,_,_,_)), retractall(move_order(_,_)), retractall(choose(_)), retractall(code_frog_position(_,_)),
retractall(code_mosquito_position(_,_)), retractall(code_ma_check(_,_)), retractall(quarter(_)), retractall(frog_position(_,_)),
retractall(mosquito_position(_,_)), retractall(mosquito_position_next(_,_)), retractall(mosquito_check_X(_)), retractall(mosquito_check_Y(_)),
retractall(frog_check_XY(_)), retractall(frog_position_next(_,_)), retractall(win(_)), retractall(ma_check(_,_)), retractall(frog_vs_mosquito(_)),
retractall(max(_,_,_)), retractall(is_it_code(_,_)).
% база данных болота и всех остальных БД
ans(да).
reset if assert(frog_position_next(-1,-1)), assert(win(-1)), assert(frog_vs_mosquito(-1)), assert(max(-1,-1,-1)), assert(is_it_code(-1,axis)),
	 assert(code_frog_position(-1,-1)), assert(code_mosquito_position(-1,-1)), assert(code_ma_check(-1,-1)),
	 assert(mosquito_position_next(-1,-1)), assert(mosquito_check_X(-1)), assert(mosquito_check_Y(-1)), assert(frog_check_XY(-1)),
	 assert(choose(-1)), assert(quarter(-1)), assert(frog_position(-1,-1)),
	 assert(mosquito_position(-1,-1)),  %выбор за кого играем -1 начало 1 комар 2 лягушка
	 assert(move_order(frog,1)), assert(move_order(mosquito,0)),  %самое начало лягушка первая ходит
	 % row = 1
	 assert(swamp(empty,empty,1,1)), assert(swamp(empty,empty,1,2)), assert(swamp(empty,empty,1,3)), assert(swamp(empty,empty,1,4)),
 	 assert(swamp(empty,empty,1,5)), assert(swamp(empty,empty,1,6)), assert(swamp(empty,empty,1,7)), assert(swamp(empty,empty,1,8)),
 	 % row = 2
	 assert(swamp(empty,empty,2,1)), assert(swamp(empty,empty,2,2)), assert(swamp(empty,empty,2,3)), assert(swamp(empty,empty,2,4)),
	 assert(swamp(empty,empty,2,5)), assert(swamp(empty,empty,2,6)), assert(swamp(empty,empty,2,7)), assert(swamp(empty,empty,2,8)),
	 % row = 3
	 assert(swamp(empty,empty,3,1)), assert(swamp(empty,empty,3,2)), assert(swamp(empty,empty,3,3)), assert(swamp(empty,empty,3,4)),
	 assert(swamp(empty,empty,3,5)), assert(swamp(empty,empty,3,6)), assert(swamp(empty,empty,3,7)), assert(swamp(empty,empty,3,8)),
	 % row = 4
	 assert(swamp(empty,empty,4,1)), assert(swamp(empty,empty,4,2)), assert(swamp(empty,empty,4,3)), assert(swamp(empty,empty,4,4)),
	 assert(swamp(empty,empty,4,5)), assert(swamp(empty,empty,4,6)), assert(swamp(empty,empty,4,7)), assert(swamp(empty,empty,4,8)),
	 % row = 5
	 assert(swamp(empty,empty,5,1)), assert(swamp(empty,empty,5,2)), assert(swamp(empty,empty,5,3)), assert(swamp(empty,empty,5,4)),
	 assert(swamp(empty,empty,5,5)), assert(swamp(empty,empty,5,6)), assert(swamp(empty,empty,5,7)), assert(swamp(empty,empty,5,8)),
	 % row = 6
	 assert(swamp(empty,empty,6,1)), assert(swamp(empty,empty,6,2)), assert(swamp(empty,empty,6,3)), assert(swamp(empty,empty,6,4)),
	 assert(swamp(empty,empty,6,5)), assert(swamp(empty,empty,6,6)), assert(swamp(empty,empty,6,7)), assert(swamp(empty,empty,6,8)),
	 % row = 7
	 assert(swamp(empty,empty,7,1)), assert(swamp(empty,empty,7,2)), assert(swamp(empty,empty,7,3)), assert(swamp(empty,empty,7,4)),
	 assert(swamp(empty,empty,7,5)), assert(swamp(empty,empty,7,6)), assert(swamp(empty,empty,7,7)), assert(swamp(empty,empty,7,8)),
	 % row = 8
	 assert(swamp(empty,empty,8,1)), assert(swamp(empty,empty,8,2)), assert(swamp(empty,empty,8,3)), assert(swamp(empty,empty,8,4)),
	 assert(swamp(empty,empty,8,5)), assert(swamp(empty,empty,8,6)), assert(swamp(empty,empty,8,7)), assert(swamp(empty,empty,8,8)).
% цель
start if destructor, reset, set_set_position(Mosquito_X,Mosquito_Y,Frog_X,Frog_Y), nl,
	 check_position(Mosquito_X,Mosquito_Y,Frog_X,Frog_Y), first_move,
	 write(" Еще раз да/нет?"), nl, write(" "), readln(Answer), nl, repeat(Answer).
start if write(" Один или несколько параметров введены не правильно"), nl,
	 write(" Еще раз да/нет?"), nl, write(" "), readln(Answer), nl, repeat(Answer).
repeat(Answer) if ans(Answer), start.
repeat(_).
goal
start.