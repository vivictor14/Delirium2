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
:- use_module(eviterPieges).
:- use_module(fonctions).

% Initialise les tableaux de l'algorythme A*
init(_) :- nb_setval(labyrinthe, [[-1]]), init_astar(_), init_GlobaleMonster(_).


/*
  move( +L,+LP, +X,+Y,+Pos, +Size, +CanGotoExit, +Energy,+GEnergy, +VPx,+VPy, -ActionId )
*/

% Mettre à jour le labyrinthe avant de choisir le mouvement
move(L, _, X, Y, Pos, Size, CGE, _, _, _, _, Action) :- eviterPieges(L, Size, L1), nb_getval(labyrinthe, Laby), updateLaby(Laby, L1, X, Y, Pos, Size), nb_getval(labyrinthe, Laby1), move(X, Y, CGE, Laby1, Action).

% S'arrêter sur la sortie
move(X, Y, 1, Laby, 0) :- elemAtCoord(Laby, X, Y, 21).

% Se diriger vers la sortie
move(X, Y, 1, Laby, Action) :- premiereOccurence(Laby, 21, X1, Y1), seDirigerVers([X, Y], [X1, Y1], Laby, _, Action), write('Je me dirige vers la sortie'), nl.

% Se diriger vers un diamant
move(X, Y, 0, Laby, Action) :- meilleureOption(X, Y, Laby, 2, Action), write('Je me dirige vers un diamant'), nl.

% Errer
move(X, Y, _, Laby, Action) :- errer(X, Y, Laby, Action), write('J erre'), nl.

% Mise à jour du labyrinthe
updateLaby(OldLaby, L, X, Y, Pos, Size) :- coordLastElement(OldLaby, X1, Y1), posLastElement(L, Pos1), updateLaby(L, X, Y, X1, Y1, Pos, Pos1, Size, OldLaby, Laby, 0, 0), nb_setval(labyrinthe, Laby).

updateLaby(L, X, Y, X1, Y1, Pos, Pos1, Size, _, [[E]], Xe, Ye) :- Xe >= X1, Ye >= Y1, posToCoord(X, Y, Pos, Size, Pos1, X2, Y2), Xe = X2, Ye = Y2, elemAtPos(L, Pos1, E).
updateLaby(_, X, Y, X1, Y1, Pos, Pos1, Size, OldLaby, [[E]], Xe, Ye) :- Xe = X1, Ye = Y1, posToCoord(X, Y, Pos, Size, Pos1, X2, Y2), Xe >= X2, Ye >= Y2, elemAtCoord(OldLaby, X1, Y1, E).
updateLaby(_, X, Y, X1, Y1, Pos, Pos1, Size, _, [[-1]], Xe, Ye) :- Xe >= X1, Ye >= Y1, posToCoord(X, Y, Pos, Size, Pos1, X2, Y2), Xe >= X2, Ye >= Y2.
updateLaby(L, X, Y, X1, Y1, Pos, Pos1, Size, OldLaby, [[E]|R2], Xe, Ye) :- Xe >= X1, posToCoord(X, Y, Pos, Size, Pos1, X2, Y2), Xe = X2, Ye =< Y2, posToCoord(X, Y, Pos, Size, 0, _, Y3), Ye >= Y3, Pos2 is (Pos + (Xe - X) + Size * (Ye - Y)), elemAtPos(L, Pos2, E), Ye1 is Ye + 1, updateLaby(L, X, Y, X1, Y1, Pos, Pos1, Size, OldLaby, R2, 0, Ye1).
updateLaby(L, X, Y, X1, Y1, Pos, Pos1, Size, OldLaby, [[E]|R2], Xe, Ye) :- Xe = X1, Ye =< Y1, posToCoord(X, Y, Pos, Size, Pos1, X2, _), Xe >= X2, elemAtCoord(OldLaby, Xe, Ye, E), Ye1 is Ye + 1, updateLaby(L, X, Y, X1, Y1, Pos, Pos1, Size, OldLaby, R2, 0, Ye1).
updateLaby(L, X, Y, X1, Y1, Pos, Pos1, Size, OldLaby, [[-1]|R2], Xe, Ye) :- Xe >= X1, posToCoord(X, Y, Pos, Size, Pos1, X2, _), Xe >= X2, Ye1 is Ye + 1, updateLaby(L, X, Y, X1, Y1, Pos, Pos1, Size, OldLaby, R2, 0, Ye1).
updateLaby(L, X, Y, X1, Y1, Pos, Pos1, Size, OldLaby, [[E|R1]|R2], Xe, Ye) :- posToCoord(X, Y, Pos, Size, Pos1, X2, Y2), Xe =< X2, Ye =< Y2, posToCoord(X, Y, Pos, Size, 0, X3, Y3), Xe >= X3, Ye >= Y3, Pos2 is (Pos + (Xe - X) + Size * (Ye - Y)), elemAtPos(L, Pos2, E), Xe1 is Xe + 1, updateLaby(L, X, Y, X1, Y1, Pos, Pos1, Size, OldLaby, [R1|R2], Xe1, Ye).
updateLaby(L, X, Y, X1, Y1, Pos, Pos1, Size, OldLaby, [[E|R1]|R2], Xe, Ye) :- Xe =< X1, Ye =< Y1, elemAtCoord(OldLaby, Xe, Ye, E), Xe1 is Xe + 1, updateLaby(L, X, Y, X1, Y1, Pos, Pos1, Size, OldLaby, [R1|R2], Xe1, Ye).
updateLaby(L, X, Y, X1, Y1, Pos, Pos1, Size, OldLaby, [[-1|R1]|R2], Xe, Ye) :- Xe1 is Xe + 1, updateLaby(L, X, Y, X1, Y1, Pos, Pos1, Size, OldLaby, [R1|R2], Xe1, Ye).