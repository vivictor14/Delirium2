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
updateLaby(OldLaby, L, X, Y, Pos, Size, VPx, VPy) :- updateLaby(L, X, Y, Pos, Size, VPx, VPy, OldLaby, Laby, 0, 0), nb_setval(labyrinthe, Laby).

updateLaby(L, X, Y, Pos, Size, _, _, OldLaby, [[E]], Xe, Ye) :- coordLastElement(OldLaby, X1, Y1), Xe >= X1, Ye >= Y1, posLastElement(L, Pos1), posToCoord(X, Y, Pos, Size, Pos1, X2, Y2), Xe = X2, Ye = Y2, elemAtPos(L, Pos1, E).
updateLaby(L, X, Y, Pos, Size, _, _, OldLaby, [[E]], Xe, Ye) :- posLastElement(L, Pos1), posToCoord(X, Y, Pos, Size, Pos1, X1, Y1), Xe >= X1, Ye >= Y1, coordLastElement(OldLaby, X2, Y2), Xe = X2, Ye = Y2, elemAtCoord(OldLaby, X2, Y2, E).
updateLaby(L, X, Y, Pos, Size, _, _, OldLaby, [[-1]], Xe, Ye) :- coordLastElement(OldLaby, X1, Y1), Xe >= X1, Ye >= Y1, posLastElement(L, Pos1), posToCoord(X, Y, Pos, Size, Pos1, X2, Y2), Xe >= X2, Ye >= Y2.
updateLaby(L, X, Y, Pos, Size, VPx, VPy, OldLaby, [[E]|R2], Xe, Ye) :- coordLastElement(OldLaby, X1, _), Xe >= X1, posLastElement(L, Pos1), posToCoord(X, Y, Pos, Size, Pos1, X2, Y2), Xe = X2, Ye =< Y2, posToCoord(X, Y, Pos, Size, 0, _, Y3), Ye >= Y3, Pos2 is (Pos + (Xe - X) + Size * (Ye - Y)), elemAtPos(L, Pos2, E), Ye1 is Ye + 1, updateLaby(L, X, Y, Pos, Size, VPx, VPy, OldLaby, R2, 0, Ye1).
updateLaby(L, X, Y, Pos, Size, VPx, VPy, OldLaby, [[E]|R2], Xe, Ye) :- posLastElement(L, Pos1), posToCoord(X, Y, Pos, Size, Pos1, X1, _), Xe >= X1, coordLastElement(OldLaby, X2, Y2), Xe = X2, Ye =< Y2, elemAtCoord(OldLaby, Xe, Ye, E), Ye1 is Ye + 1, updateLaby(L, X, Y, Pos, Size, VPx, VPy, OldLaby, R2, 0, Ye1).
updateLaby(L, X, Y, Pos, Size, VPx, VPy, OldLaby, [[-1]|R2], Xe, Ye) :- coordLastElement(OldLaby, X1, _), Xe >= X1, posLastElement(L, Pos1), posToCoord(X, Y, Pos, Size, Pos1, X2, _), Xe >= X2, Ye1 is Ye + 1, updateLaby(L, X, Y, Pos, Size, VPx, VPy, OldLaby, R2, 0, Ye1).
updateLaby(L, X, Y, Pos, Size, VPx, VPy, OldLaby, [[E|R1]|R2], Xe, Ye) :- posToCoord(X, Y, Pos, Size, 0, X1, Y1), Xe >= X1, Ye >= Y1, posLastElement(L, Pos1), posToCoord(X, Y, Pos, Size, Pos1, X2, Y2), Xe =< X2, Ye =< Y2, Pos2 is (Pos + (Xe - X) + Size * (Ye - Y)), elemAtPos(L, Pos2, E), Xe1 is Xe + 1, updateLaby(L, X, Y, Pos, Size, VPx, VPy, OldLaby, [R1|R2], Xe1, Ye).
updateLaby(L, X, Y, Pos, Size, VPx, VPy, OldLaby, [[E|R1]|R2], Xe, Ye) :- coordLastElement(OldLaby, X1, Y1), Xe =< X1, Ye =< Y1, elemAtCoord(OldLaby, Xe, Ye, E), Xe1 is Xe + 1, updateLaby(L, X, Y, Pos, Size, VPx, VPy, OldLaby, [R1|R2], Xe1, Ye).
updateLaby(L, X, Y, Pos, Size, VPx, VPy, OldLaby, [[-1|R1]|R2], Xe, Ye) :- Xe1 is Xe + 1, updateLaby(L, X, Y, Pos, Size, VPx, VPy, OldLaby, [R1|R2], Xe1, Ye).

% Transformer position dans la liste en coordonnées dans le labyrinthe
posToCoord(X, Y, Pos, Size, Pos1, X1, Y1) :- X1 is (X + (Pos1 mod Size) - (Pos mod Size)), Y1 is (Y + (Pos1 // Size) - (Pos // Size)).

% Element à la position donnée
elemAtPos([E|_], 0, E).
elemAtPos([_|R], Pos, E) :- Pos1 is Pos - 1, elemAtPos(R, Pos1, E).

% Element aux coordonnées données
elemAtCoord([[E|_]|_], 0, 0, E).
elemAtCoord([[_|R1]|R2], X, 0, E) :- X1 is X - 1, elemAtCoord([R1|R2], X1, 0, E). 
elemAtCoord([_|R2], X, Y, E) :- Y1 is Y - 1, elemAtCoord(R2, X, Y1, E).

% Position du dernier élément
posLastElement(L, Pos) :- posLastElement(L, 0, Pos).
posLastElement([_], Pos, Pos).
posLastElement([_|R], Pos0, Pos) :- Pos1 is Pos0 + 1, posLastElement(R, Pos1, Pos).

% Coordonnées du dernier élément
coordLastElement(Laby, X, Y) :- coordLastElement(Laby, 0, 0, X, Y).
coordLastElement([[_]], X, Y, X, Y).
coordLastElement([[]|R2], _, Y0, X, Y) :- Y1 is Y0 + 1, coordLastElement(R2, 0, Y1, X, Y).
coordLastElement([[_|R1]|R2], X0, Y0, X, Y) :- X1 is X0 + 1, coordLastElement([R1|R2], X1, Y0, X, Y). 
