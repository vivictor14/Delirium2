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

% Initialiser les différentes variables globales du programme
/*
  init( _ )
*/
init(_) :- nb_setval(labyrinthe, [[-1]]), nb_setval(sortie, []), nb_setval(positions, [[-1, -1], [-2, -2], [-3, -3], [-4, -4], [-5, -5], [-6, -6]]), nb_setval(blacklist, []), init_astar(_), init_GlobaleMonster(_).

% Mettre à jour le labyrinthe en fonction des objets perçus, du labyrinthe précédent, des positions dangereuses et des positions blacklistées avant de choisir le mouvement
/*
  move( +L,+LP, +X,+Y,+Pos, +Size, +CanGotoExit, +Energy,+GEnergy, +VPx,+VPy, -ActionId )
*/
move(L, _, X, Y, Pos, Size, CGE, _, _, _, _, Action) :- eviterPieges(L, X, Y, Pos, Size, L1), nb_getval(labyrinthe, Laby), avoidLoop(_), updateLaby(Laby, L1, X, Y, Pos, Size), nb_getval(labyrinthe, Laby1), move(X, Y, CGE, Laby1, Action), updateMovements([X, Y]).
/*
  move( +X, +Y, +CanGotoExit, +Labyrinthe, -Action )
*/
% S'arrêter sur la sortie
move(X, Y, 1, _, Action) :- nb_getval(sortie, Coord), [X, Y] = Coord, Action is 0, write("J'attend que le prochain niveau se charge"), nl.
% Se diriger vers la sortie
move(X, Y, 1, Laby, Action) :- premiereOccurence(Laby, 21, X1, Y1), nb_setval(sortie, [X1, Y1]), seDirigerVers([X, Y], [X1, Y1], Laby, Action), write('Je me dirige vers la sortie'), nl.
% Se diriger vers un diamant
move(X, Y, 0, Laby, Action) :- meilleureOption(Laby, X, Y, 2, Action), write('Je me dirige vers un diamant'), nl.
% Errer
move(X, Y, _, Laby, Action) :- errer(X, Y, Laby, Action), write("J'erre"), nl.

% Mettre à jour le labyrinthe
/*
  updateLaby( +OldLaby, +L, +X, +Y, +Pos, +Size )
*/
updateLaby(OldLaby, L, X, Y, Pos, Size) :- coordLastElement(OldLaby, X1, Y1), posLastElement(L, Pos1), updateLaby(L, X, Y, X1, Y1, Pos, Pos1, Size, OldLaby, Laby, 0, 0), nb_setval(labyrinthe, Laby).
/*
  updateLaby( +L, +X, +Y, +X1, +Y1, +Pos, +Pos1, +Size, +OldLaby, -NewLaby, +Xe, +Ye )
*/
updateLaby(_, _, _, _, _, _, _, _, _, [[4]], Xe, Ye) :- nb_getval(blacklist, List), member([Xe, Ye], List).
updateLaby(L, X, Y, X1, Y1, Pos, Pos1, Size, _, [[E]], Xe, Ye) :- Xe >= X1, Ye >= Y1, posToCoord(X, Y, Pos, Size, Pos1, X2, Y2), Xe = X2, Ye = Y2, elemAtPos(L, Pos1, E).
updateLaby(_, X, Y, X1, Y1, Pos, Pos1, Size, OldLaby, [[E]], Xe, Ye) :- Xe = X1, Ye = Y1, posToCoord(X, Y, Pos, Size, Pos1, X2, Y2), Xe >= X2, Ye >= Y2, elemAtCoord(OldLaby, X1, Y1, E).
updateLaby(_, X, Y, X1, Y1, Pos, Pos1, Size, _, [[-1]], Xe, Ye) :- Xe >= X1, Ye >= Y1, posToCoord(X, Y, Pos, Size, Pos1, X2, Y2), Xe >= X2, Ye >= Y2.
updateLaby(L, X, Y, X1, Y1, Pos, Pos1, Size, OldLaby, [[4]|R2], Xe, Ye) :- nb_getval(blacklist, List), member([Xe, Ye], List), Ye1 is Ye + 1, updateLaby(L, X, Y, X1, Y1, Pos, Pos1, Size, OldLaby, R2, 0, Ye1).
updateLaby(L, X, Y, X1, Y1, Pos, Pos1, Size, OldLaby, [[E]|R2], Xe, Ye) :- Xe >= X1, posToCoord(X, Y, Pos, Size, Pos1, X2, Y2), Xe = X2, Ye =< Y2, posToCoord(X, Y, Pos, Size, 0, _, Y3), Ye >= Y3, Pos2 is (Pos + (Xe - X) + Size * (Ye - Y)), elemAtPos(L, Pos2, E), Ye1 is Ye + 1, updateLaby(L, X, Y, X1, Y1, Pos, Pos1, Size, OldLaby, R2, 0, Ye1).
updateLaby(L, X, Y, X1, Y1, Pos, Pos1, Size, OldLaby, [[E]|R2], Xe, Ye) :- Xe = X1, Ye =< Y1, posToCoord(X, Y, Pos, Size, Pos1, X2, _), Xe >= X2, elemAtCoord(OldLaby, Xe, Ye, E), Ye1 is Ye + 1, updateLaby(L, X, Y, X1, Y1, Pos, Pos1, Size, OldLaby, R2, 0, Ye1).
updateLaby(L, X, Y, X1, Y1, Pos, Pos1, Size, OldLaby, [[-1]|R2], Xe, Ye) :- Xe >= X1, posToCoord(X, Y, Pos, Size, Pos1, X2, _), Xe >= X2, Ye1 is Ye + 1, updateLaby(L, X, Y, X1, Y1, Pos, Pos1, Size, OldLaby, R2, 0, Ye1).
updateLaby(L, X, Y, X1, Y1, Pos, Pos1, Size, OldLaby, [[4|R1]|R2], Xe, Ye) :- nb_getval(blacklist, List), member([Xe, Ye], List), Xe1 is Xe + 1, updateLaby(L, X, Y, X1, Y1, Pos, Pos1, Size, OldLaby, [R1|R2], Xe1, Ye).
updateLaby(L, X, Y, X1, Y1, Pos, Pos1, Size, OldLaby, [[E|R1]|R2], Xe, Ye) :- posToCoord(X, Y, Pos, Size, Pos1, X2, Y2), Xe =< X2, Ye =< Y2, posToCoord(X, Y, Pos, Size, 0, X3, Y3), Xe >= X3, Ye >= Y3, Pos2 is (Pos + (Xe - X) + Size * (Ye - Y)), elemAtPos(L, Pos2, E), Xe1 is Xe + 1, updateLaby(L, X, Y, X1, Y1, Pos, Pos1, Size, OldLaby, [R1|R2], Xe1, Ye).
updateLaby(L, X, Y, X1, Y1, Pos, Pos1, Size, OldLaby, [[E|R1]|R2], Xe, Ye) :- Xe =< X1, Ye =< Y1, elemAtCoord(OldLaby, Xe, Ye, E), Xe1 is Xe + 1, updateLaby(L, X, Y, X1, Y1, Pos, Pos1, Size, OldLaby, [R1|R2], Xe1, Ye).
updateLaby(L, X, Y, X1, Y1, Pos, Pos1, Size, OldLaby, [[-1|R1]|R2], Xe, Ye) :- Xe1 is Xe + 1, updateLaby(L, X, Y, X1, Y1, Pos, Pos1, Size, OldLaby, [R1|R2], Xe1, Ye).

% Blacklister les positions causant une boucle infinie
/*
  avoidLoop( _ )
*/
avoidLoop(_) :- nb_getval(positions, [E1, E2, E1, E2, E1, E2]), nb_getval(blacklist, List), append(List, [E1, E2], List1), nb_setval(blacklist, List1).
avoidLoop(_).

% Mettre à jour la liste des 6 dernières actions effectuées par le mineur
/*
  updateMovements( +Coord )
*/
updateMovements(Coord) :- nb_getval(positions, [E1, E2, E3, E4, E5, _]), nb_setval(positions, [Coord, E1, E2, E3, E4, E5]).
