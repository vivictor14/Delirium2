/*
  Définition de l'IA du mineur
  Le prédicat move/12 est consulté à chaque itération du jeu.
*/

:- module( decision, [
	init/1,
	move/12
] ).
:- use_module(seDirigerVers).
:- use_module(errer).

% Initialise les tableaux de l'algorythme A*
init(_) :- nb_setval(labyrinthe, [[-1]]), seDirigerVers:init_astar(_).


/*
  move( +L,+LP, +X,+Y,+Pos, +Size, +CanGotoExit, +Energy,+GEnergy, +VPx,+VPy, -ActionId )
*/

test(Action) :- init(_), move([5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 0, 0, 0, 0, 22, 6, 0, 0, 0, 0, 5, 5, 6, 6, 6, 6, 0, 6, 0, 6, 0, 6, 5, 5, 0, 0, 0, 6, 0, 6, 0, 0, 0, 0, 5, 5, 6, 1, 6, 6, 0, 0, 0, 6, 0, 6, 5, 5, 0, 0, 0, 6, 6, 0, 6, 6, 0, 0, 5, 5, 0, 0, 0, 0, 0, 0, 6, 0, 0, 21, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5], _, 5, 1, 17, 12, 5, _, _, _, _, Action).
test2(Laby) :- updateLaby([[-1]], [5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 0, 0, 0, 0, 22, 6, 0, 0, 0, 0, 5, 5, 6, 6, 6, 6, 0, 6, 0, 6, 0, 6, 5, 5, 0, 0, 0, 6, 0, 6, 0, 0, 0, 0, 5, 5, 6, 1, 6, 6, 0, 0, 0, 6, 0, 6, 5, 5, 0, 0, 0, 6, 6, 0, 6, 6, 0, 0, 5, 5, 0, 0, 0, 0, 0, 0, 6, 0, 0, 21, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5], 5, 1, 17, 12), nb_getval(labyrinthe, Laby).
% Mettre à jour le labyrinthe avant de choisir le mouvement
move(L, _, X, Y, Pos, Size, CGE, _, _, _, _, Action) :- nb_getval(labyrinthe, Laby), updateLaby(Laby, L, X, Y, Pos, Size), nb_getval(labyrinthe, Laby1), move(X, Y, CGE, Laby1, Action).

% S'arrêter sur la sortie
move(X, Y, 0, Laby, 0) :- elemAtCoord(X, Y, 21).

% Se diriger vers la sortie
move(X, Y, 0, Laby, Action) :- premiereOccurence(Laby, 21, X1, Y1), seDirigerVers:seDirigerVers([X, Y], [X1, Y1], Laby, _, Action).

% Se diriger vers un diamant
move(X, Y, CGE, Laby, Action) :- not(CGE = 0), meilleureOption(X, Y, Laby, 2, Action).

% Errer
move(X, Y, _, Laby, Action) :- errer(X, Y, Laby, Action).

% Mise à jour du labyrinthe
updateLaby(OldLaby, L, X, Y, Pos, Size) :- coordLastElement(OldLaby, X1, Y1), posLastElement(L, Pos1), posToCoord(X, Y, Pos, Size, Pos1, X2, Y2), updateLaby(L, X, Y, X1, Y1, X2, Y2, Pos, Size, OldLaby, Laby, 0, 0), nb_setval(labyrinthe, Laby).

updateLaby(L, X, Y, X1, Y1, X2, Y2, Pos, Size, OldLaby, [[E]], Xe, Ye) :- Xe >= X1, Ye >= Y1, Xe = X2, Ye = Y2, elemAtPos(L, Pos1, E).
updateLaby(L, X, Y, X1, Y1, X2, Y2, Pos, Size, OldLaby, [[E]], Xe, Ye) :- Xe = X1, Ye = Y1, Xe >= X2, Ye >= Y2, elemAtCoord(OldLaby, X2, Y2, E).
updateLaby(L, X, Y, X1, Y1, X2, Y2, Pos, Size, OldLaby, [[-1]], Xe, Ye) :- Xe >= X1, Ye >= Y1, Xe >= X2, Ye >= Y2.
updateLaby(L, X, Y, X1, Y1, X2, Y2, Pos, Size, OldLaby, [[E]|R2], Xe, Ye) :- Xe >= X1, Xe = X2, Ye =< Y2, posToCoord(X, Y, Pos, Size, 0, _, Y3), Ye >= Y3, Pos2 is (Pos + (Xe - X) + Size * (Ye - Y)), elemAtPos(L, Pos2, E), Ye1 is Ye + 1, updateLaby(L, X, Y, X1, Y1, X2, Y2, Pos, Size, OldLaby, R2, 0, Ye1).
updateLaby(L, X, Y, X1, Y1, X2, Y2, Pos, Size, OldLaby, [[E]|R2], Xe, Ye) :- Xe = X1, Ye =< Y1, Xe >= X2, elemAtCoord(OldLaby, Xe, Ye, E), Ye1 is Ye + 1, updateLaby(L, X, Y, X1, Y1, X2, Y2, Pos, Size, OldLaby, R2, 0, Ye1).
updateLaby(L, X, Y, X1, Y1, X2, Y2, Pos, Size, OldLaby, [[-1]|R2], Xe, Ye) :- Xe >= X1, Xe >= X2, Ye1 is Ye + 1, updateLaby(L, X, Y, X1, Y1, X2, Y2, Pos, Size, OldLaby, R2, 0, Ye1).
updateLaby(L, X, Y, X1, Y1, X2, Y2, Pos, Size, OldLaby, [[E|R1]|R2], Xe, Ye) :- posToCoord(X, Y, Pos, Size, 0, X1, Y1), Xe >= X1, Ye >= Y1, Xe =< X2, Ye =< Y2, Pos2 is (Pos + (Xe - X) + Size * (Ye - Y)), elemAtPos(L, Pos2, E), Xe1 is Xe + 1, updateLaby(L, X, Y, X1, Y1, X2, Y2, Pos, Size, OldLaby, [R1|R2], Xe1, Ye).
updateLaby(L, X, Y, X1, Y1, X2, Y2, Pos, Size, OldLaby, [[E|R1]|R2], Xe, Ye) :- Xe =< X1, Ye =< Y1, elemAtCoord(OldLaby, Xe, Ye, E), Xe1 is Xe + 1, updateLaby(L, X, Y, X1, Y1, X2, Y2, Pos, Size, OldLaby, [R1|R2], Xe1, Ye).
updateLaby(L, X, Y, X1, Y1, X2, Y2, Pos, Size, OldLaby, [[-1|R1]|R2], Xe, Ye) :- Xe1 is Xe + 1, updateLaby(L, X, Y, X1, Y1, X2, Y2, Pos, Size, OldLaby, [R1|R2], Xe1, Ye).

% Meilleure option possible
meilleureOption(X, Y, Laby, Elem, Action) :- meilleureOption(X, Y, Laby, Laby, 0, 0, Elem, 42, 0, Action).

meilleureOption(X, Y, Laby, [[Elem]], X0, Y0, Elem, Min, _, Action) :- seDirigerVers([X, Y], [X0, Y0], Laby, Cout, Action), Cout =< Min.
meilleureOption(_, _, _, [[_]], _, _, _, _, Action, Action) :- not(Action = 0).
meilleureOption(X, Y, Laby, [[]|R2], X0, Y0, Elem, Min, Action0, Action) :- Y1 is Y0 + 1, meilleureOption(X, Y, Laby, R2, X0, Y1, Elem, Min, Action0, Action).
meilleureOption(X, Y, Laby, [[Elem|R1]|R2], X0, Y0, Elem, Min, _, Action) :- seDirigerVers([X, Y], [X0, Y0], Laby, Cout, Action1), Cout =< Min, X1 is X0 + 1, meilleureOption(X, Y, Laby, [R1|R2], X1, Y0, Elem, Cout, Action1, Action).
meilleureOption(X, Y, Laby, [[_|R1]|R2], X0, Y0, Elem, Min, Action0, Action) :- X1 is X0 + 1, meilleureOption(X, Y, Laby, [R1|R2], X1, Y0, Elem, Min, Action0, Action).

% Transformer position dans la liste en coordonnées dans le labyrinthe
posToCoord(X, Y, Pos, Size, Pos1, X1, Y1) :- X1 is (X + (Pos1 mod Size) - (Pos mod Size)), Y1 is (Y + (Pos1 // Size) - (Pos // Size)).

% Element à la position donnée
elemAtPos([E|_], 0, E).
elemAtPos([_|R], Pos, E) :- Pos1 is Pos - 1, elemAtPos(R, Pos1, E).

% Element aux coordonnées données
elemAtCoord([[E|_]|_], 0, 0, E).
elemAtCoord([[_|R1]|R2], X, 0, E) :- X > 0, X1 is X - 1, elemAtCoord([R1|R2], X1, 0, E). 
elemAtCoord([_|R2], X, Y, E) :- Y > 0, Y1 is Y - 1, elemAtCoord(R2, X, Y1, E).

% Position du dernier élément
posLastElement(L, Pos) :- posLastElement(L, 0, Pos).
posLastElement([_], Pos, Pos).
posLastElement([_|R], Pos0, Pos) :- Pos1 is Pos0 + 1, posLastElement(R, Pos1, Pos).

% Coordonnées du dernier élément
coordLastElement(Laby, X, Y) :- coordLastElement(Laby, 0, 0, X, Y).
coordLastElement([[_]], X, Y, X, Y).
coordLastElement([[]|R2], _, Y0, X, Y) :- Y1 is Y0 + 1, coordLastElement(R2, 0, Y1, X, Y).
coordLastElement([[_|R1]|R2], X0, Y0, X, Y) :- X1 is X0 + 1, coordLastElement([R1|R2], X1, Y0, X, Y).

% Trouver la première occurence d'un élément dans le labyrinthe
premiereOccurence([[Element|_]|_], Element, X, Y, X, Y).
premiereOccurence([[]|R], Element, _, Y0, X, Y) :- Y1 is Y0 + 1, X1 is 0, premiereOccurence(R, Element, X1, Y1, X, Y).
premiereOccurence([[_|R1]|R2], Element, X0, Y0, X, Y) :- X1 is X0 + 1, premiereOccurence([R1|R2], Element, X1, Y0, X, Y).
premiereOccurence(Laby, Element, X, Y) :- premiereOccurence(Laby, Element, 0, 0, X, Y).
