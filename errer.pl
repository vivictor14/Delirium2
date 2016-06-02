:- use_module( seDirigerVers ).

:- module( errer, [
	errer/8
] ).

% Se diriger vers le point inexploré le plus proche
% A droite
errer(L, X, Y, Pos, Size, VPx, VPy, 1) :- nb_getval(labyrinthe, Laby), premiereOccurenceDroite(Laby, X, Y, -1, X1, Y1), seDirigerVers(L, X, Y, Pos, Size, X1, Y1, 1).
% En haut
errer(L, X, Y, Pos, Size, VPx, VPy, 2) :- nb_getval(labyrinthe, Laby), premiereOccurenceHaut(Laby, X, Y, -1, X1, Y1), seDirigerVers(L, X, Y, Pos, Size, X1, Y1, 2).
% A gauche
errer(L, X, Y, Pos, Size, VPx, VPy, 3) :- nb_getval(labyrinthe, Laby), premiereOccurenceGauche(Laby, X, Y, -1, X1, Y1), seDirigerVers(L, X, Y, Pos, Size, X1, Y1, 3).
% En bas
errer(L, X, Y, Pos, Size, VPx, VPy, 4) :- nb_getval(labyrinthe, Laby), premiereOccurenceBas(Laby, X, Y, -1, X1, Y1), seDirigerVers(L, X, Y, Pos, Size, X1, Y1, 4).

% Trouver la première occurence d'un élément à droite du mineur
premiereOccurenceDroite([L|Laby], X, 0, Element, X1, Y1) :- member(-1, L).
premiereOccurenceDroite([L|Laby], X, Y, Element, X1, Y1) :- premiereOccurence(Laby, X, Y, Element, X1, Y1).
