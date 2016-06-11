:- module( errer, [
	errer/4
] ).

:- use_module(seDirigerVers).
:- use_module(fonctions).

% Se diriger vers un endroit inexploré ou au moins atteignable
/*
  errer( +X, +Y, +Laby, -Action )
*/
errer(X, Y, Laby, Action) :- meilleureOption(Laby, X, Y, -1, Action).
errer(X, Y, Laby, Action) :- endroitAtteignable(X, Y, Laby, Action).
errer(X, Y, Laby, Action) :- X1 is X + 1, possibleMove([X1, Y], Laby, 1), Action is 1.
errer(X, Y, Laby, Action) :- X1 is X + 1, elemAtCoord(Laby, X1, Y, 1), Action is 5.
errer(X, Y, Laby, Action) :- Y1 is Y - 1, possibleMove([X, Y1], Laby, 2), Action is 2.
errer(X, Y, Laby, Action) :- Y1 is Y - 1, elemAtCoord(Laby, X, Y1, 1), Action is 6.
errer(X, Y, Laby, Action) :- X1 is X - 1, possibleMove([X1, Y], Laby, 3), Action is 3.
errer(X, Y, Laby, Action) :- X1 is X - 1, elemAtCoord(Laby, X1, Y, 1), Action is 7.
errer(X, Y, Laby, Action) :- Y1 is Y + 1, possibleMove([X, Y1], Laby, 4), Action is 4.
errer(X, Y, Laby, Action) :- Y1 is Y + 1, elemAtCoord(Laby, X, Y1, 1), Action is 8.

% Trouver un endroit atteignable en partant du coin inférieur droit du labyrinthe
/*
  endroitAtteignable( +X, +Y, +Laby, -Action )
*/
endroitAtteignable(X, Y, Laby, Action) :- X0 is X + 2, Y0 is Y + 2, coordLastElement(Laby, XL, YL), endroitAtteignable(X, Y, Laby, X0, Y0, 20, XL, YL, Action), !.
/*
  endroitAtteignable( +X, +Y, +Laby, +X0, +Y0, +DistMax, +XL, +YL, -Action )
*/
endroitAtteignable(X, Y, Laby, X0, Y0, _, _, _, Action) :- elemAtCoord(Laby, X0, Y0, E), destinationPossible(E), seDirigerVers([X, Y], [X0, Y0], Laby, Action).
endroitAtteignable(X, Y, Laby, X0, Y0, DistMax, XL, YL, Action) :- X1 is X0 + 1, X1 < (X + DistMax), X1 < XL, !, endroitAtteignable(X, Y, Laby, X1, Y0, DistMax, XL, YL, Action).
endroitAtteignable(X, Y, Laby, X0, Y0, DistMax, XL, YL, Action) :- Y1 is Y0 + 1, Y1 < (Y + DistMax), Y1 < YL, X1 is X + 2, endroitAtteignable(X, Y, Laby, X1, Y1, DistMax, XL, YL, Action).

% Cases sur lesquelles le mineur peut se rendre
/*
  destinationPossible( +E )
*/
destinationPossible(E) :- E < 3.