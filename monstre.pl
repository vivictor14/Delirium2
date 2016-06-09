init_GlobaleMonster(_):-
  nb_setval(posMonstre,[]).
  
avoirNewCarte(Map,PosMonstre,NewMap):-
  lancerVerif(PosMonstre,ListeD),
  modifCarte(Map,ListeD,NewMap).
  
lancerVerif(PosMonstre,ListeD):-
  nb_getval(posMonstre,ListePosMonstre),
  verifMonstre(PosMonstre,ListeD,ListePosMonstre).
  
  
verifMonstre([],[],PosMonstre):-
  flushPosMonstre(PosMonstre,NewPosMonstre),
  nb_setval(posMonstre,NewPosMonstre).
verifMonstre([Monstre|AutresMonstre],ListeD,PosMonstre):-
  addPosition(PosMontre,Monstre,NewPosMonstre,Direction),
  append([Direction],NewListeD,ListeD),
  !
  verifMonstre(AutresMonstre,NewListeD).
verifMonstre([_|AutresMonstre],ListeD,PosMonstre):-
  verifMonstre(AutresMonstre,ListeD,PosMonstre).

/*
  modifCarte(+Map,+ListeD,-NewMap)
*/
  modifCarte(_,[],_).


/*
  flushPosMonstre(+PosMonstre,-NewPosMonstre)
*/

flushPosMonstre([],[]).
flushPosMonstre([Monstre|AutresMonstre],PosMonstre):-
    Monstre = [Pos1,Pos2],
    Pos1 = [X1,Y1],
    Pos2 = [X2,Y2],
    append([Pos2],NewPosMonstre,PosMonstre),
    !,
    flushPosMonstre(AutresMonstre,NewPosMonstre).
  flushPosMonstre([_|AutresMonstre],PosMonstre):-
    flushPosMonstre(AutresMonstre,PosMonstre).
  
/*
  addPosition(+PosMontre,+ListPosMonstre,-NewListPosMonstre,-Direction)
*/

% droite = 1 , haut = 2, gauche = 3, bas = 4
addPosition([],[],[],[]).
addPosition([],[X,Y],NewPos,[]):-
  append([[X,Y],[X,Y]],[],NewPos)
addPosition([PosAvant|Reste],[X,Y],NewPos,D):-
  PosAvant = [XMonstre,YMonstre],
  X1 is X+1,
  XMonstre = X1,
  D = [1,[X,Y]],
  !,
  append([PosAvant,[X,Y]],Pos,NewPos),
  addPosition(Reste,[],Pos,D).
  
addPosition([PosAvant|Reste],[X,Y],NewPos,D):-
  PosAvant = [XMonstre,YMonstre],
  X1 is X-1,
  XMonstre = X1,
  D = [3,[X,Y]],
  !,
  append([PosAvant,[X,Y]],Pos,NewPos),
  addPosition(Reste,[],Pos,D).
  
addPosition([PosAvant|Reste],[X,Y],NewPos,D):-
  PosAvant = [XMonstre,YMonstre],
  Y1 is Y+1,
  YMonstre = Y1,
  D = [4,[X,Y]],
  !,
  append([PosAvant,[X,Y]],Pos,NewPos),
  addPosition(Reste,[],Pos,D).

addPosition([PosAvant|Reste],[X,Y],NewPos,D):-
  PosAvant = [XMonstre,YMonstre],
  Y1 is Y-1,
  YMonstre = Y1,
  D = [2,[X,Y]],
  !,
  append([PosAvant,[X,Y]],Pos,NewPos),
  addPosition(Reste,[],Pos,D).  
  
addPosition([_|Reste],Pos,NewPos,D):-
  addPosition(Reste,Pos,NewPos,D).

  
% Prochaine position possible pour monstre
possibleMoveMonster(L, Pos) :- elementAtPosIs(L, Pos, X), X = 0.

% f(d)
% Vers la gauche
moveMonster(L, Pos, Size, D, L1) :- D = 2, Pos1 is Pos - 1, possibleMoveMonster(L, Pos1).
% Vers le bas
moveMonster(L, Pos, Size, D, L1) :- D = 3, Pos1 is Pos + Size, possibleMoveMonster(L, Pos1).
% Vers la droite
moveMonster(L, Pos, Size, D, L1) :- D = 4, Pos1 is Pos + 1, possibleMoveMonster(L, Pos1).
% Vers le haut
moveMonster(L, Pos, Size, D, L1) :- D = 1, Pos1 is Pos - Size, possibleMoveMonster(L, Pos1).

% d
% Vers le haut
moveMonster(L, Pos, Size, D, L1) :- D = 2, Pos1 is Pos - Size, possibleMoveMonster(L, Pos1).
% Vers la gauche
moveMonster(L, Pos, Size, D, L1) :- D = 3, Pos1 is Pos - 1, possibleMoveMonster(L, Pos1).
% Vers le bas
moveMonster(L, Pos, Size, D, L1) :- D = 4, Pos1 is Pos + Size, possibleMoveMonster(L, Pos1).
% Vers la droite
moveMonster(L, Pos, Size, D, L1) :- D = 1, Pos1 is Pos + 1, possibleMoveMonster(L, Pos1).

% f(f(d))
% Vers le bas
moveMonster(L, Pos, Size, D, L1) :- D = 2, Pos1 is Pos + Size, possibleMoveMonster(L, Pos1).
% Vers la droite
moveMonster(L, Pos, Size, D, L1) :- D = 3, Pos1 is Pos + 1, possibleMoveMonster(L, Pos1).
% Vers le haut
moveMonster(L, Pos, Size, D, L1) :- D = 4, Pos1 is Pos - Size, possibleMoveMonster(L, Pos1).
% Vers la gauche
moveMonster(L, Pos, Size, D, L1) :- D = 1, Pos1 is Pos - 1, possibleMoveMonster(L, Pos1).

% f(f(f(d)))
% Vers la droite
moveMonster(L, Pos, Size, D, L1) :- D = 2, Pos1 is Pos + 1, possibleMoveMonster(L, Pos1).
% Vers le haut
moveMonster(L, Pos, Size, D, L1) :- D = 3, Pos1 is Pos - Size, possibleMoveMonster(L, Pos1).
% Vers la gauche
moveMonster(L, Pos, Size, D, L1) :- D = 4, Pos1 is Pos - 1, possibleMoveMonster(L, Pos1).
% Vers le bas
moveMonster(L, Pos, Size, D, L1) :- D = 1, Pos1 is Pos + Size, possibleMoveMonster(L, Pos1).
