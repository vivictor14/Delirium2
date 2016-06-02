:- module( seDirigerVers, [
	seDirigerVers/5
] ).




% Type de l'élément à la position indiquée
elementAtPosIs([X|_], 0, X).
elementAtPosIs([X|R], Pos, Element) :- Pos1 is Pos - 1, elementAtPosIs(R, Pos1, Element).

% Prochaine position possible
possibleMove(L, Pos) :- elementAtPosIs(L, Pos, X), X < 3.
possibleMove(L, Pos) :- elementAtPosIs(L, Pos, X), X = 20.



% Se rapproche de la position voulue
seRapproche(Pos, Pos1, Pos2) :- X is abs(Pos2 - Pos), Y is abs(Pos2 - Pos1), X > Y.