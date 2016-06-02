% Prochaine position possible pour monstre
possibleMoveMonster(L, Pos) :- elementAtPosIs(L, Pos, X), X = 0.

% 1 = Haut, 2 = Gauche, 3 = Bas, 4 = Droite
% f(d)
% Vers la gauche
moveMonster(L, Pos, Size, d, L1) :- d = 1, Pos1 is Pos - 1, possibleMoveMonster(L, Pos1).
% Vers le bas
moveMonster(L, Pos, Size, d, L1) :- d = 2, Pos1 is Pos + Size, possibleMoveMonster(L, Pos1).
% Vers la droite
moveMonster(L, Pos, Size, d, L1) :- d = 3, Pos1 is Pos + 1, possibleMoveMonster(L, Pos1).
% Vers le haut
moveMonster(L, Pos, Size, d, L1) :- d = 4, Pos1 is Pos - Size, possibleMoveMonster(L, Pos1).

% d
% Vers le haut
moveMonster(L, Pos, Size, d, L1) :- d = 1, Pos1 is Pos - Size, possibleMoveMonster(L, Pos1).
% Vers la gauche
moveMonster(L, Pos, Size, d, L1) :- d = 2, Pos1 is Pos - 1, possibleMoveMonster(L, Pos1).
% Vers le bas
moveMonster(L, Pos, Size, d, L1) :- d = 3, Pos1 is Pos + Size, possibleMoveMonster(L, Pos1).
% Vers la droite
moveMonster(L, Pos, Size, d, L1) :- d = 4, Pos1 is Pos + 1, possibleMoveMonster(L, Pos1).

% f(f(d))
% Vers le bas
moveMonster(L, Pos, Size, d, L1) :- d = 1, Pos1 is Pos + Size, possibleMoveMonster(L, Pos1).
% Vers la droite
moveMonster(L, Pos, Size, d, L1) :- d = 2, Pos1 is Pos + 1, possibleMoveMonster(L, Pos1).
% Vers le haut
moveMonster(L, Pos, Size, d, L1) :- d = 3, Pos1 is Pos - Size, possibleMoveMonster(L, Pos1).
% Vers la gauche
moveMonster(L, Pos, Size, d, L1) :- d = 4, Pos1 is Pos - 1, possibleMoveMonster(L, Pos1).

% f(f(f(d)))
% Vers la droite
moveMonster(L, Pos, Size, d, L1) :- d = 1, Pos1 is Pos + 1, possibleMoveMonster(L, Pos1).
% Vers le haut
moveMonster(L, Pos, Size, d, L1) :- d = 2, Pos1 is Pos - Size, possibleMoveMonster(L, Pos1).
% Vers la gauche
moveMonster(L, Pos, Size, d, L1) :- d = 3, Pos1 is Pos - 1, possibleMoveMonster(L, Pos1).
% Vers le bas
moveMonster(L, Pos, Size, d, L1) :- d = 4, Pos1 is Pos + Size, possibleMoveMonster(L, Pos1).
