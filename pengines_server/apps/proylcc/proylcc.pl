:- module(proylcc,
	[  
		put/8
	]).

:-use_module(library(lists)).



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% replace(?X, +XIndex, +Y, +Xs, -XsY)
%
% XsY is the result of replacing the occurrence of X in position XIndex of Xs by Y.

replace(X, 0, Y, [X|Xs], [Y|Xs]).

replace(X, XIndex, Y, [Xi|Xs], [Xi|XsY]):-
    XIndex > 0,
    XIndexS is XIndex - 1,
    replace(X, XIndexS, Y, Xs, XsY).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% put(+Content, +Pos, +RowsClues, +ColsClues, +Grid, -NewGrid, -RowSat, -ColSat).
%

put(Content, [RowN, ColN], RowsClues, ColsClues, Grid, NewGrid, RowSat, ColSat):-
	% NewGrid is the result of replacing the row Row in position RowN of Grid by a new row NewRow (not yet instantiated).
	replace(Row, RowN, NewRow, Grid, NewGrid),

	% NewRow is the result of replacing the cell Cell in position ColN of Row by _,
	% if Cell matches Content (Cell is instantiated in the call to replace/5).	
	% Otherwise (;)
	% NewRow is the result of replacing the cell in position ColN of Row by Content (no matter its content: _Cell).

	(replace(Cell, ColN, _, Row, NewRow),
	Cell == Content;
	replace(_Cell, ColN, Content, Row, NewRow)),
	elementoEn(RowN, NewGrid, Fila),
	columnaEn(ColN, NewGrid, Columna),
	elementoEn(RowN, RowsClues, PistaFila),
	elementoEn(ColN, ColsClues, PistaColumna),
	calcularPista(PistaFila, Fila, RowSat),
	calcularPista(PistaColumna, Columna, ColSat).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% elementoEn(+N, +Lista, -Return).
%
% Retorna el N-esimo elemento de una lista.
elementoEn(N, [_X|Xs], Return):-
    N > 0,
    Next is (N - 1),
    elementoEn(Next, Xs, Return).
elementoEn(0, [X|_Xs], X).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% columnaEn(+N, +Matriz, -Return).
%
% crea una lista a partir de los elementos de la N-esima columna de una
% matriz.
columnaEn(_N, [], []).
columnaEn(N, [X|Xs], Return):-
    elementoEn(N, X, Columna),
    columnaEn(N, Xs, Resultado),
    Return = [Columna|Resultado].

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% checkLista(+N, +Lista, -Resto).
%
% predicado cascara para checkListaAux, omite primeras apariciones de
% variables no instanciadas y aparciones de #, para luego llamar a
% checkListaAux.
% Resto es la sublista que queda luego de las primeras apariciones
% consecutivas de las X.
%
%
%
% checkListaAux(+N, +Lista, -Resto).
% verifica si existen exactamente N apariciones consecutivas de # en la
% lista. Solo se verifica las primeras apariciones de # antes de que un
% _ los separe, osea checkLista(3, ["#","#",_,"#","#","#"]). da falso.
checkListaAux(0, [], []).
checkListaAux(0, [X], [_]):- var(X); X \== "#".
checkListaAux(0, [X|Xs], [X|Xs]):- var(X); X \== "#".
checkListaAux(N, [X|Xs], Resto):- N > 0, X == "#", Next is N - 1, checkListaAux(Next, Xs, Resto).
checkLista(N, [X|Xs], Resto):- ((var(X); X \== "#"), checkLista(N, Xs, Resto)); (nonvar(X), checkListaAux(N, [X|Xs], Resto)).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% checkPista(+Pistas, +Lista, -Return).
%
checkPista([], Lista):- checkResto(Lista).
checkPista([P|Ps], Lista):-
    (checkLista(P, Lista, Resto),
      checkPista(Ps, Resto)).

calcularPista(Pista, Lista, Resultado):- checkPista(Pista, Lista) -> Resultado is 1; Resultado is 0.


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% checkResto(+Lista).
%
% verdadero si la lista solo contiene apariciones de _ ó X.
checkResto([]).
checkResto([X|Xs]):- (var(X); X \== "#"), checkResto(Xs).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%   validarListaClues(+Lista).
validarListaClues([]).
validarListaClues([1|Xs]):- validarListaClues(Xs).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%	hace lo mismo que el put pero sin calcular ni devolver la grilla nueva
%
%   checkCumplimientoPistas(+RowN, +ColN, +Grilla, +RowsClues, +ColsClues, -RowSat, -ColSat).

checkCumplimientoPistas(RowN, ColN, Grilla, RowsClues, ColsClues, RowSat, ColSat):-
	elementoEn(RowN, Grilla, Fila),
	columnaEn(ColN, Grilla, Columna),
	elementoEn(RowN, RowsClues, PistaFila),
	elementoEn(ColN, ColsClues, PistaColumna),
	calcularPista(PistaFila, Fila, RowSat),
	calcularPista(PistaColumna, Columna, ColSat).