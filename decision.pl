/*


  Définition de l'IA du mineur

  Le prédicat move/12 est consulté à chaque itération du jeu.


*/

:- use_module( seDirigerVers ).
:- use_module( errer ).

:- module( decision, [
	init/1,
	move/12
] ).


init(_).


/*
  move( +L,+LP, +X,+Y,+Pos, +Size, +CanGotoExit, +Energy,+GEnergy, +VPx,+VPy, -ActionId )
*/

% Mouvement aléatoire avec prédicat move/12
% move( _,_, _,_,_, _, _, _,_, _,_, Action ) :- Action is random( 5 ), write(Action),nl.
% move( Action ) :- Action is 1+random( 4 ), write(Action),nl.

% Se diriger vers la sortie
move(L, _, X, Y, Pos, Size, 0, _, _, VPx, VPy, Action) :- member(20, L), positionLaPlusProche(20, Pos1), seDirigerVers(L, Pos, Size, Pos1, Action).

% Se diriger vers un diamant
move(L, _, X, Y, Pos, Size, 1, _, _, VPx, VPy, Action) :- member(2, L), positionLaPlusProche(2, Pos1), seDirigerVers(L, Pos, Size, Pos1, Action).

% Errer
move(L, _, X, Y, Pos, Size, _, _, _, VPx, VPy, Action) :- errer(L, X, Y, Pos, Size, VPx, VPy, Action).

% Position de la première occurence de l'élément
position(Element, [X|_], Pos, Index) :- Element = X, Pos = Index, !.
position(Element, [X|R], Pos, Index) :- Pos1 is Pos + 1, position(Element, R, Pos1, Index).
position(Element, L, Index) :- position(Element, L, 0, Index).

% Positions de toutes les occurences de l'élément
allPosition(_, [], _, []).
allPosition(Element, [X|R1], Pos, [Pos|Y]) :- Element = X, !, Pos1 is Pos + 1, allPosition(Element,R1,Pos1,Y).
allPosition(Element, [_|R], Pos, Index) :- Pos1 is Pos + 1, allPosition(Element, R, Pos1, Index).
allPosition(Element, L, Index) :- allPosition(Element, L, 0, Index).