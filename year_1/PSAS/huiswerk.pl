% PSS Huiswerk # 4
% 9-10-2017
% Tim Stolp, 11848782, tim2stolp@gmail.com



% Dit zorgt ervoor dat prolog de hele lijst uitprint.

?- set_prolog_flag(answer_write_options, [max_depth(0)]).

% Opd. 1.

% Dit is de te oplossen sudoku. Weergegeven als een lijst met 9 lijsten.

beginToestand([[1, x, x, x, x, 2, 7, 6, x],
               [2, x, x, x, x, 1, x, x, 8],
               [x, 3, 6, x, x, 7, x, x, 4],
               [x, x, x, x, 6, x, 8, 7, 2],
               [6, x, 7, x, 2, 9, x, x, x],
               [x, x, x, x, x, x, x, x, x],
               [x, 8, x, x, 7, x, 3, x, x],
               [x, 1, 3, x, x, x, 5, x, x],
               [x, x, x, x, 1, x, x, 9, 7]]).

% Opd. 2.

% rij rekent eerst de bijbehorende Y uit bij een elementnummer (1-81) en stop dan de Y in rij2, rij2 vindt de bijbehorende rij.

rij(A, B, C):-
  y(A, D),
  rij2(D, B, C).
rij2(A, B, C):-
  nth1(A, B, C).

%kolom rekent eerst de X uit van het elementnummer en kolom2 rekent dan de bijbehorendelijst uit.

kolom(A, B, C):-
  x(A, D),
  kolom2(D, B, C).

kolom2(_, [], []).
kolom2(A, [H|T], [B|C]):-
  nth1(A, H, B),
  kolom2(A, T, C).

% kwadrant rekent eerst de X en Y uit, daarna de K, K is het nummer van het bijbehorende kwadrant van het elementnummer, met het kwadrantnummer rekent kwadrant2 eerst de X en Y uit, daarna de min Y, max Y, min X en max X van het kwadrant uit.
% Daarna zoekt numbers de bijbehorende rijen, van YMin tot YMax, en dan pakt numbers2 uit de rijen de elementen, van XMin tot XMax, en dan maakt numbers daarvan een lijst van 9 elementen.

kwadrant(A, B, C):-
  x(A, X),
  y(A, Y),
  k(X, Y, D),
  kwadrant2(D, B, C).

kwadrant2(A, B, Answer):-
  Y is A // 3,
  X is A mod 3,
  YMin is Y * 3 + 1,
  YMax is (Y + 1) * 3,
  XMin is X * 3 + 1,
  XMax is (X + 1) * 3,
  numbers(YMin, YMax, XMin, XMax, B, Answer).

numbers(Y1, Y2, _, _, _, []):-
  Y1 > Y2.
numbers(Y1, Y2, X1, X2, B, Answer2):-
  rij2(Y1, B, C),
  numbers2(X1, X2, C, H),
  Y3 is Y1 + 1,
  numbers(Y3, Y2, X1, X2, B, Answer),
  flatten([H|Answer], Answer2).

numbers2(X1, X2, _, []):-
  X1 > X2.
numbers2(X1, X2, C, [H|Answer]):-
  nth1(X1, C, H),
  X3 is X1 + 1,
  numbers2(X3, X2, C, Answer).

% Dit is alle wiskunde waarmee prolog vanuit een elementnummer de bijbehorende X, Y en kwadrantnummer uitrekent.

x(A, B):-
  A2 is A mod 9,
  A2 = 0,
  B is 9.
x(A, B):-
  B is A mod 9.

y(A, B):-
  X is A mod 9,
  X = 0,
  B is A // 9.
y(A, B):-
  B is A // 9 + 1.

k(X, Y, C3):-
  X2 is X - 1,
  Y2 is Y - 1,
  C1 is X2 // 3 + 1,
  Y3 is Y2 // 3 + 1,
  C2 is (Y3 - 1) * 3,
  C3 is C1 + C2 - 1.

% Opd. 3.

% Dit goal kijkt naar de 1e lijst in een bepaalde toestant van een sudoku, neemt de 1e lijst en sorteert die van klein naar groot, als die gesorteerde lijst gelijk is aan een lijst van 1 tot 9 is de lijst dus helemaal gevuld met alle nummers van 1 tot 9.
% Dit checkt hij met alle 9 lijsten, als dat allemaal true is dan is de sudoku gevuld. (De regels worden tijdens het invoeren gecheckt dus dat hoeft op het einde niet, dit is meer een stop voor het programma).

goal([]).
goal([H|T]):-
  sort(H, H2),
  H2 = [1, 2, 3, 4, 5, 6, 7, 8, 9],
  goal(T).

% Dit stuk vervangt get eerste gegeven element in een lijst met een ander element.

replace(_, _, [], []).
replace(A, B, [A|T], [B|T]).
replace(A, B, [H|T], [H|D]):-
  replace(A, B, T, D).


% het predicate check checkt of alle elementen in de sudoku niet de regels overtreden van hun bijbehorende rij, kolom en kwadrant.
% Het doet dit van elementnummer 1 tot 81.

check(_, X):-
  X = 81.
check(A, X):-
  check2(X, A),
  X2 is X + 1,
  check(A, X2).

% Check2 maakt eerst de rij, kolom en kwadrant van het gegeven elementnummer, haalt dan de alle "x" uit die lijsten en dan checkt check3 of alle overgebleven elementen er niet meerdere keren in voor komen.

check2(X, A):-
  rij(X, A, Rij),
  kolom(X, A, Kolom),
  kwadrant(X, A, Kwadrant),
  removeX(Rij, Rij2),
  removeX(Kolom, Kolom2),
  removeX(Kwadrant, Kwadrant2), !,
  check3(Rij2),
  check3(Kolom2),
  check3(Kwadrant2).

% Dit checkt of een lijst geen duplicates bevat.

check3([]).
check3([H|T]):-
  \+ member(H, T),
  check3(T).

% Dit verijdert alle "x" uit een lijst.

removeX([], []).
removeX([x|T], B):-
  removeX(T, B).
removeX([H|T], [H|B]):-
  removeX(T, B).

% Opd. 4.

% Dit maakt van de sudoku's 9 lijsten 1 lijst, zoekt dan het elementnummer van de 1e "x" en zoekt de daarbijbehorende rij, dan kiest hij een getal van 1 tot 9, beginnend bij de laagste en vervangt dan in de bijbehorender rij de x met het gekozen getal.
% dan vervangt hij de orginele rij met de nieuw gemaakte rij en dan heb je een nieuwe toestand van de sudoku.

move(A, B):-
  flatten(A, A2),
  nth1(N, A2, x),
  rij(N, A, Rij),
  replace(x, X, Rij, Rij2),
  replace(Rij, Rij2, A, B), !,
  between(1, 9, X).

% Dit kijkt of de toestand voldoet aan de goal, anders gaat hij move doen, krijgt dan een nieuwe toestand, dan checkt hij of die toestand niet de regels van een sudoku overtreedt, daarna of hij niet al eens die toestand is tegengekomen (als dat zo is zoek een andere toestand).
% Dit doet hij met recursie todat de toestand voldoet aan de goal.

solve(_, A, A):-
  goal(A).
solve(Visited, A, C):-
  move(A, B),
  check(B, 1),
  \+ member(B, Visited),
  solve([B|Visited], B, C).

% Dit print de toestand op een mooie manier uit.

fancy([]).
fancy([H|T]):-
  write("|"),
  write(H),
  writeln("|"),
  fancy(T).

% Opd. 5.

% Dit begint de code, roept eerst de begintoestand aan en gaat dan de sudoku oplossen, als hij klaar is schrijft hij de sudoku mooi op en geeft de tijd die nodig was om de sudoku op te lossen. LET OP: (DIT DUURT OP MIJN LAPTOP 21.3 SECONDEN, HET IS GEEN SNEL PROGRAMMA, LAAT HET LADEN A.U.B.).

start():-
  beginToestand(A),
  time(solve(A, A, B)),
  writeln("---------------------"),
  fancy(B),
  write("---------------------").
