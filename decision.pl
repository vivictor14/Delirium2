/*
  Définition de l'IA du mineur
  Le prédicat move/12 est consulté à chaque itération du jeu.
*/
/*
%:- use_module( seDirigerVers ).
%:- use_module( errer ).

:- module( decision, [
	init/1,
	move/12
] ).


init(_).*/


/*
  move( +L,+LP, +X,+Y,+Pos, +Size, +CanGotoExit, +Energy,+GEnergy, +VPx,+VPy, -ActionId )
*/

% Mouvement aléatoire avec prédicat move/12
% move( _,_, _,_,_, _, _, _,_, _,_, Action ) :- Action is random( 5 ), write(Action),nl.
% move( Action ) :- Action is 1+random( 4 ), write(Action),nl.


% Mettre à jour le labyrinthe avant de choisir le mouvement
move(L, _, X, Y, Pos, Size, CGE, _, _, VPx, VPy, Action) :- nb_getval(labyrinthe, Laby), updateLaby(Laby, L, X, Y, Pos, Size, VPx, VPy), nb_getval(labyrinthe, Laby1), move(L, X, Y, Pos ,Size, CGE, Laby1, Action).

% Se diriger vers la sortie
move(L, X, Y, Pos, Size, 0, Laby, Action) :- member(20, L), premiereOccurence(Laby, 20, X1, Y1), seDirigerVers(L, X, Y, Pos, Size, X1, Y1, Action).

% Se diriger vers un diamant
move(L, X, Y, Pos, Size, CGE, _, Action) :- not(CGE = 0), member(2, L), meilleureOption(L, Size, Pos, 2, Pos1), posToCoord(X, Y, Pos, Size, Pos1, X1, Y1), seDirigerVers(L, X, Y, Pos, Size, X1, Y1, Action).

% Errer
move(L, X, Y, Pos, Size, _, Laby, Action) :- errer(L, X, Y, Pos, Size, Laby, Action).

% Meilleure option possible
meilleureOption(L, Size, Pos, Element, Pos1) :- allPosition(Element, L, Positions), seDirigerVers:couts(L, Pos, Size, Positions, Rangs), meilleureOp(Positions, Rangs, Pos1).

meilleureOp([X|Positions], [Y|Rangs], Pos1) :- meilleureOp(Positions, Rangs, X, Y, Pos1).
meilleureOp([], [], Pos, _, Pos).
meilleureOp([X|P], [Y|R], _, Min, Pos) :- Y < Min, !, meilleureOp(P, R, X, Y, Pos).
meilleureOp([_|P], [_|R], Pos0, Min, Pos) :- meilleureOp(P, R, Pos0, Min, Pos).

% Positions de toutes les occurences de l'élément
allPosition(_, [], _, []).
allPosition(Element, [X|R1], Pos, [Pos|Y]) :- Element = X, !, Pos1 is Pos + 1, allPosition(Element,R1,Pos1,Y).
allPosition(Element, [_|R], Pos, Index) :- Pos1 is Pos + 1, allPosition(Element, R, Pos1, Index).
allPosition(Element, L, Index) :- allPosition(Element, L, 0, Index).

% Mise à jour du labyrinthe
updateLaby([], L, X, Y, Pos, Size, VPx, VPy) :- initLaby(L, X, Y, Pos, Size, VPx, VPy, Laby), nb_setval(labyrinthe, Laby).

% Initialisation du labyrinthe
initLaby(L, X, Y, Pos, Size, VPx, VPy, [[E|_]|_], Xe, Ye) :- posToCoord(X, Y, Pos, Size, ((VPx * 2 + 1) * (VPy * 2 + 1) - 1), X1, Y1), Xe = X1, Ye = Y1, Pos1 is (Pos + (Xe - X) + Size * (Ye - Y)), elemAtPos(L, Pos1, E), write(1 + Ye).
initLaby(L, X, Y, Pos, Size, VPx, VPy, [_|R2], Xe, Ye) :- Pos1 is ((VPx * 2 + 1) * (VPy * 2 + 1) - 1), posToCoord(X, Y, Pos, Size, Pos1, X2, _), Xe > X2, Ye1 is Ye + 1, write(2 + Ye), initLaby(L, X, Y, Pos, Size, VPx, VPy, R2, 0, Ye1).
initLaby(L, X, Y, Pos, Size, VPx, VPy, [[E|R1]|R2], Xe, Ye) :- posToCoord(X, Y, Pos, Size, 0, _, Y1), Ye < Y1, Pos1 is ((VPx * 2 + 1) * (VPy * 2 + 1) - 1), posToCoord(X, Y, Pos, Size, Pos1, X2, _), Xe =< X2,  E is -1, Xe1 is Xe + 1, write(3 + Ye), initLaby(L, X, Y, Pos, Size, VPx, VPy, [R1|R2], Xe1, Ye).
initLaby(L, X, Y, Pos, Size, VPx, VPy, [[E|R1]|R2], Xe, Ye) :- posToCoord(X, Y, Pos, Size, 0, X1, _), Xe < X1, E is -1, Xe1 is Xe + 1, write(4 + Ye), initLaby(L, X, Y, Pos, Size, VPx, VPy, [R1|R2], Xe1, Ye).
initLaby(L, X, Y, Pos, Size, VPx, VPy, [[E|R1]|R2], Xe, Ye) :- Pos1 is (Pos + (Xe - X) + Size * (Ye - Y)), elemAtPos(L, Pos1, E), Xe1 is Xe + 1, write(5 + Ye), initLaby(L, X, Y, Pos, Size, VPx, VPy, [R1|R2], Xe1, Ye).


% Transformer position dans la liste en coordonnées dans le labyrinthe
posToCoord(X, Y, Pos, Size, Pos1, X1, Y1) :- X1 is (X + (Pos1 mod Size) - (Pos mod Size)), Y1 is (Y + (Pos1 // Size) - (Pos // Size)).

% Element à la position donnée
elemAtPos([E|_], 0, E).
elemAtPos([_|R], Pos, E) :- Pos1 is Pos - 1, elemAtPos(R, Pos1, E).

%initLaby([ 1, 0, 1, 1, 2, 23, 1, 21, 2, 3, 2, 2, 0, 0, 0 ], 2, 1, 7, 5, 2, 1, Laby, 0, 0).
