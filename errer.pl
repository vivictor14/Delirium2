:- use_module( seDirigerVers ).

:- module( errer, [
	errer/8
] ).

% Se diriger vers un endroit inexploré
errer(L, X, Y, Pos, Size, VPx, VPy, Action) :- nb_getval(labyrinthe, Laby), premiereOccurence(Laby, -1, X1, Y1), seDirigerVers(L, X, Y, Pos, Size, X1, Y1, Action).

% Trouver la première occurence d'un élément dans le labyrinthe
premiereOccurence([[Element|_]|_], Element, X, Y, X, Y).
premiereOccurence([[]|R], Element, X0, Y0, X, Y) :- Y1 is Y0 + 1, premiereOccurence(R, Element, X0, Y1, X, Y).
premiereOccurence([[_|R1]|R2], X0, Y0, X, Y) :- X1 is X0 + 1, premiereOccurence([[R1]|R2], X1, Y0, X, Y).
premiereOccurence(Laby, Element, X, Y) :- premiereOccurence(Laby, 1, 1, X, Y).
