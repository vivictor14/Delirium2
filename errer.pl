:- module( errer, [
	errer/4
] ).

:- use_module( seDirigerVers ).

% Se diriger vers un endroit inexploré
errer(X, Y, Laby, Action) :- premiereOccurence(Laby, -1, X1, Y1), seDirigerVers([X, Y], [X1, Y1], Laby, _, Action).
errer(X, Y, Laby, Action) :- coordLastElement(Laby, X1, Y1), seDirigerVers([X, Y], [X1, Y1], Laby, _, Action).

% Trouver la première occurence d'un élément dans le labyrinthe
premiereOccurence([[Element|_]|_], Element, X, Y, X, Y).
premiereOccurence([[]|R], Element, _, Y0, X, Y) :- Y1 is Y0 + 1, X1 is 0, premiereOccurence(R, Element, X1, Y1, X, Y).
premiereOccurence([[_|R1]|R2], Element, X0, Y0, X, Y) :- X1 is X0 + 1, premiereOccurence([R1|R2], Element, X1, Y0, X, Y).
premiereOccurence(Laby, Element, X, Y) :- premiereOccurence(Laby, Element, 0, 0, X, Y).

% Coordonnées du dernier élément
coordLastElement(Laby, X, Y) :- coordLastElement(Laby, 0, 0, X, Y).
coordLastElement([[_]], X, Y, X, Y).
coordLastElement([[]|R2], _, Y0, X, Y) :- Y1 is Y0 + 1, coordLastElement(R2, 0, Y1, X, Y).
coordLastElement([[_|R1]|R2], X0, Y0, X, Y) :- X1 is X0 + 1, coordLastElement([R1|R2], X1, Y0, X, Y).
