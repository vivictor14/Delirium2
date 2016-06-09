init_GlobaleMonster(_):-
  nb_setval(posMonstre,[]).
  
avoirNewCarte(Map,Size,PosMonstres,NewMap):-
  lancerRecupDirection(PosMonstres,Size,ListeD),
  nouvellePosition(Map,Size,ListeD,ListeP),
  modifCarte(Map,ListeP,NewMap).
  
lancerRecupDirection(PosMonstres,Size,ListeDirectionPrecedent):-
  nb_getval(posMonstre,ListePosMonstre),
  verifMonstre(PosMonstres,Size,ListeDirectionPrecedent,ListePosMonstre).
  
  
nouvellePosition(_,_,[],[]):-
nouvellePosition(Map,Size,[D,Pos|Reste],Liste):-
	moveMonster(Map, Pos, Size, D, Pos1),
	append([Pos,Pos1],NewListe,Liste),
	!,
	nouvellePosition(Map,Size,Reste,NewListe).
nouvellePosition(Map,Size,[_|Reste],Liste):-
	nouvellePosition(Map,Size,Reste,Liste).
  
  
verifMonstre([],_,[],PosMonstre):-
  flushPosMonstre(PosMonstre,NewPosMonstre),
  nb_setval(posMonstre,NewPosMonstre).
verifMonstre([Monstre|AutresMonstre],Size,ListeD,ListPosMonstre):-
  addPosition(ListPosMonstre,Monstre,Size,NewPosMonstre,Direction),
  append([Direction],NewListeD,ListeD),
  !
  verifMonstre(AutresMonstre,NewListeD,ListPosMonstre).
verifMonstre([_|AutresMonstre],Size,ListeD,ListPosMonstre):-
  verifMonstre(AutresMonstre,ListeD,ListPosMonstre).

replace([_|T], 0, X, [X|T]).
replace([H|T], I, X, [H|R]):- 
	I > -1, NI is I-1, replace(T, NI, X, R), !.
  
/*
  modifCarte(+Map,+ListeD,-NewMap)
*/
modifCarte(N,[],N).
modifCarte(Map,[XAvant,XApres|Reste],NewMap)
	replace(Map,XAvant,0,MapRecursive2),
	replace(MapRecursive,XApres,24,MapSuivante),
	!,
	modifCarte(MapSuivante,Reste,NewMap).


/*
  flushPosMonstre(+PosMonstre,-NewPosMonstre)
*/

flushPosMonstre([],[]).
flushPosMonstre([Monstre|AutresMonstre],PosMonstre):-
    Monstre = [Pos1,Pos2],
    Pos1 = [X1],
    Pos2 = [X2],
    append([Pos2],NewPosMonstre,PosMonstre),
    !,
    flushPosMonstre(AutresMonstre,NewPosMonstre).
  flushPosMonstre([_|AutresMonstre],PosMonstre):-
    flushPosMonstre(AutresMonstre,PosMonstre).
  
/*
  addPosition(+PosMontre,+ListPosMonstre,+Size,-NewListPosMonstre,-Direction)
*/

% droite = 1 , haut = 2, gauche = 3, bas = 4
addPosition([],[],_,[],[]).
addPosition([],[X],Size,NewPos,[]):-
  append([[X],[X]],[],NewPos)
addPosition([PosAvant|Reste],[X],Size,NewPos,D):-
  PosAvant = [XMonstre],
  X1 is X+1,
  XMonstre = X1,
  D = [1,X],
  !,
  append([PosAvant,[X]],Pos,NewPos),
  addPosition(Reste,[],Pos,D).
  
addPosition([PosAvant|Reste],[X],Size,NewPos,D):-
  PosAvant = [XMonstre],
  X1 is X-1,
  XMonstre = X1,
  D = [3,X],
  !,
  append([PosAvant,[X]],Pos,NewPos),
  addPosition(Reste,[],Pos,D).
  
addPosition([PosAvant|Reste],[X],Size,NewPos,D):-
  PosAvant = [XMonstre],
  X1 is X+Size,
  XMonstre = X1,
  D = [4,X],
  !,
  append([PosAvant,[X]],Pos,NewPos),
  addPosition(Reste,[],Pos,D).

addPosition([PosAvant|Reste],[X],Size,NewPos,D):-
  PosAvant = [XMonstre],
  X1 is X-Size,
  XMonstre = X1,
  D = [2,X],
  !,
  append([PosAvant,[X]],Pos,NewPos),
  addPosition(Reste,[],Pos,D).
  
addPosition([_|Reste],Pos,Size,NewPos,D):-
  addPosition(Reste,Pos,Size,NewPos,D).

% Type de l'élément à la position indiquée
elementAtPosIs([X|_], 0, X).
elementAtPosIs([X|R], Pos, Element) :- Pos1 is Pos - 1, elementAtPosIs(R, Pos1, Element).

% Prochaine position possible pour monstre
possibleMoveMonster(L, Pos) :- elementAtPosIs(L, Pos, X), X = 0.

% f(d)
% Vers la gauche
moveMonster(L, Pos, Size, D, Pos1) :- D = 2, Pos1 is Pos - 1, possibleMoveMonster(L, Pos1).
% Vers le bas
moveMonster(L, Pos, Size, D, Pos1) :- D = 3, Pos1 is Pos + Size, possibleMoveMonster(L, Pos1).
% Vers la droite
moveMonster(L, Pos, Size, D, Pos1) :- D = 4, Pos1 is Pos + 1, possibleMoveMonster(L, Pos1).
% Vers le haut
moveMonster(L, Pos, Size, D, Pos1) :- D = 1, Pos1 is Pos - Size, possibleMoveMonster(L, Pos1).

% d
% Vers le haut
moveMonster(L, Pos, Size, D, Pos1) :- D = 2, Pos1 is Pos - Size, possibleMoveMonster(L, Pos1).
% Vers la gauche
moveMonster(L, Pos, Size, D, Pos1) :- D = 3, Pos1 is Pos - 1, possibleMoveMonster(L, Pos1).
% Vers le bas
moveMonster(L, Pos, Size, D, Pos1) :- D = 4, Pos1 is Pos + Size, possibleMoveMonster(L, Pos1).
% Vers la droite
moveMonster(L, Pos, Size, D, Pos1) :- D = 1, Pos1 is Pos + 1, possibleMoveMonster(L, Pos1).

% f(f(d))
% Vers le bas
moveMonster(L, Pos, Size, D, Pos1) :- D = 2, Pos1 is Pos + Size, possibleMoveMonster(L, Pos1).
% Vers la droite
moveMonster(L, Pos, Size, D, Pos1) :- D = 3, Pos1 is Pos + 1, possibleMoveMonster(L, Pos1).
% Vers le haut
moveMonster(L, Pos, Size, D, Pos1) :- D = 4, Pos1 is Pos - Size, possibleMoveMonster(L, Pos1).
% Vers la gauche
moveMonster(L, Pos, Size, D, Pos1) :- D = 1, Pos1 is Pos - 1, possibleMoveMonster(L, Pos1).

% f(f(f(d)))
% Vers la droite
moveMonster(L, Pos, Size, D, Pos1) :- D = 2, Pos1 is Pos + 1, possibleMoveMonster(L, Pos1).
% Vers le haut
moveMonster(L, Pos, Size, D, Pos1) :- D = 3, Pos1 is Pos - Size, possibleMoveMonster(L, Pos1).
% Vers la gauche
moveMonster(L, Pos, Size, D, Pos1) :- D = 4, Pos1 is Pos - 1, possibleMoveMonster(L, Pos1).
% Vers le bas
moveMonster(L, Pos, Size, D, Pos1) :- D = 1, Pos1 is Pos + Size, possibleMoveMonster(L, Pos1).
