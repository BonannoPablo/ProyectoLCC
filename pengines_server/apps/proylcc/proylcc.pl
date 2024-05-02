:- module(proylcc,
	[
		put/8
	]).

:-use_module(library(lists)).


%---------------------/ Predicados Principales \-----------------------%


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

	% NewRow is the result of replacing the cell Cell in position ColN of Row by _,["#","#",_,"#","#","#"]
	% if Cell matches Content (Cell is instantiated in the call to replace/5).
	% Otherwise (;)
	% NewRow is the result of replacing the cell in position ColN of Row by Content (no matter its content: _Cell).

	(replace(Cell, ColN, _, Row, NewRow),
	Cell == Content;
	replace(_Cell, ColN, Content, Row, NewRow)),

        % --------------- / Calculo de pistas \ ----------------%
        checkCumplimientoPistas(RowN, ColN, NewGrid, RowsClues, ColsClues, RowSat, ColSat).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% checkCumplimientoPistas(+RowN, +ColN, +Tablero, +RowsClues,+ColsClues,-RowSat, -ColSat).
% Dadas una pista fila, una pista columna, una fila y una columna
% especificada, verifica la satisfaccion de dichas pistas con el tablero
% pasado por parametro en la fila y columna mencionadas. RowSat tiene
% valor 1 si se cumple la pista fila, en caso contrario vale 0.
% ColSat tiene valor 1 si se cumple la pista columna, en caso contrario
% vale 0.
checkCumplimientoPistas(RowN, ColN, Tablero, RowsClues, ColsClues, RowSat, ColSat):-
        % Primero se obtienen las listas de elementos de la fila y columna del
        % tablero.
	elementoEn(RowN, Tablero, Fila),
	columnaEn(ColN, Tablero, Columna),
        % Luego, se obtienen las pistas de la fila y columna.
	elementoEn(RowN, RowsClues, PistaFila),
	elementoEn(ColN, ColsClues, PistaColumna),
        % Por ultimo, se calcula la satisfaccion de las pistas en la fila y en la columna.
	calcularPista(PistaFila, Fila, RowSat),
	calcularPista(PistaColumna, Columna, ColSat).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% calcularPista(+Pista, +Lista, -Resultado).
% Dada la pista y la lista pasadas por parametro, se calcula el
% cumplimiento de la pista.
% Resultado vale 1 si se cumple la pista, 0 en caso contrario.
calcularPista(Pista, Lista, Resultado):- calcularSubPistas(Pista, Lista) -> Resultado is 1; Resultado is 0.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% calcularSubPista(+[P|Ps], +Lista).
% Se llama subpista al valor individual de una pista, por ejemplo: dada
% la pista [1,2,3], se dice que, tanto 1 como 2 como 3 son subpistas.
% Este predicado se encarga de ir llamando a contarAteriscos con las
% subpistas, luego al resto devuelto por contarAteriscos se lo verifica
% con la siguiente subpista.
% Devuelve verdadero si se cumplen todas las subpistas o si no se
% tienen subpistas y la lista no contiene ateriscos, devuelve falso 
% en caso contrario.
calcularSubPistas([], Lista):- listaSinAteriscos(Lista).
calcularSubPistas([P|Ps], Lista):- contarAteriscos(P, Lista, Resto), calcularSubPistas(Ps, Resto).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% contarAteriscos(+N, +Lista, -Resto).
% Predicado cascara para contarAteriscosAux, omite primeras apariciones
% de variables no instanciadas y aparciones de "X", para luego llamar a
% contarAteriscosAux. Resto es la sublista que queda luego de las
% primeras apariciones consecutivas de los "#", osea si
% Lista = [ _ ,"#","#", _ ,"#","#","#"] y N = 2,
% Resto = [ _ ,"#","#","#"].
contarAteriscos(0, [], []). % Solucion para la pista cero.
contarAteriscos(N, [X|Xs], Resto):-
    (
     (var(X); X == "X"),            % si X es una variable no instanciada o "X", entonces se sigue
     contarAteriscos(N, Xs, Resto)  % con el siguiente elemento.
    )
    ;
    (X == "#",                             % si X es un #, se sigue con el siguiente paso,
     contarAteriscosAux(N, [X|Xs], Resto)).% el cual es verificar los N ateriscos.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% contarAteriscosAux(+N, +Lista, -Resto).
% Verifica si existen exactamente N apariciones consecutivas de # en la
% lista. Solo se verifica las primeras apariciones de # antes de que
% aparezca una variable no instanciada o un "X", osea
% checkLista(3, ["#","#",_,"#","#","#"]). da falso.
contarAteriscosAux(0, [], []).
contarAteriscosAux(0, [X], [X]):- (var(X); X == "X").       % Solo verdadero si X se trata de una variable
contarAteriscosAux(0, [X|Xs], [X|Xs]):- (var(X); X == "X"). % no instanciada o "X".
contarAteriscosAux(N, [X|Xs], Resto):- N > 0, X == "#", Next is N - 1, contarAteriscosAux(Next, Xs, Resto).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% validarListaClues(+Lista).
% Recibe una lista de pistas y devuelve verdadero si 
% todas las pistas estan cumplidas, devuelve falso
% caso contrario.
validarListaClues([]).
validarListaClues([1|Xs]):- validarListaClues(Xs).


%------------------------/ Predicados Utiles \------------------------%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% elementoEn(+N, +Lista, -Return).
% Retorna el N-esimo elemento de una lista.
elementoEn(0, [X|_Xs], X).
elementoEn(N, [_X|Xs], Return):-
    N > 0,
    Next is (N - 1),
    elementoEn(Next, Xs, Return).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% columnaEn(+N, +Matriz, -Return).
% Crea una lista a partir de los elementos de la N-esima columna de una
% matriz.
columnaEn(_N, [], []).
columnaEn(N, [X|Xs], Return):-
    elementoEn(N, X, Columna),
    columnaEn(N, Xs, Resultado),
    Return = [Columna|Resultado].

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% listaSinAteriscos(+Lista).
% Verdadero si la lista no contiene "#", falso en caso contrario
listaSinAteriscos([]).
listaSinAteriscos([X|Xs]):- (var(X); X \== "#"), listaSinAteriscos(Xs).
