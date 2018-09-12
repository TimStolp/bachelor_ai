% PSS Huiswerk # 5
% 16-10-2017
% Tim Stolp, 11848782, tim2stolp@gmail.com


% Opd. 1.
% Haalt alle codes weg, neemt daarna een getal tussen de 10000 en 99999 en stopt dat als feit in de code en schrijft dan de code op.

draw():-
  retractall(code(_)),
  random_between(10000, 99999, A),
  asserta(code(A)),
  writeln("********************"),
  write("De code: "),
  writeln(A),
  write("********************").

% Opd. 2.
% splits het getal in apparte elementen en maakt er een lijst van. Vergelijkt de gegeven code met de geheime code d.m.v evaluate_trialx en geeft daarna de hoeveelheid Xen door de lengte te nemen van de lijst met Xen.

scorex(N, X):-
  string_chars(N, Poging),
  code(A),
  string_chars(A, Code),
  evaluate_trialx(Code, Poging, Score, _, _),
  length(Score, X).

% splits het getal in apparte elementen en maakt er een lijst van. Vergelijkt de gegeven code met de geheime code d.m.v evaluate_trialo en geeft daarna de hoeveelheid Otjes door de lengte te nemen van de lijst met Otjes.

scoreo(N, O):-
  string_chars(N, Poging),
  code(A),
  string_chars(A, Code),
  evaluate_trialx(Code, Poging, _, Code2, Poging2),
  evaluate_trialo(Code2, Poging2, Score),
  length(Score, O).

% Neemt een lijst van getallen en gaat telkens de head vergelijken met de head van de geheime lijst, als ze overeenkomen dan schrijft hij een x op in het antwoord, anders schrijft hij niks op, met recursie tot de lijsten leeg zijn.

evaluate_trialx([], [], [], [], []).
evaluate_trialx([A|B], [C|D], [x|E], F, G):-
    A = C,
  evaluate_trialx(B, D, E, F, G).
evaluate_trialx([A|B], [C|D], E, [A|F], [C|G]):-
  evaluate_trialx(B, D, E, F, G).

% Neemt een lijst van getallen en gaat telkens kijken of de head een member is van de geheime lijst, als dat zo is dan schrijft hij een O op in het antwoord, anders niks, met recursie tot de gegeven lijst van getallen leeg is.

evaluate_trialo(_, [], []).
evaluate_trialo(A, [B|C], [o|D]):-
  member(B, A),S
  select(B, A, X),
  evaluate_trialo(X, C, D).
evaluate_trialo(A, [_|C], D):-
  evaluate_trialo(A, C, D).

% Opd. 3.
% Vergelijkt "Poging" met de geheime code en krijgt daar een score uit, vergelijkt daarna "MogelijkeCode" met de geheime code en krijst daar een score uit. Vergelijkt daarna de 2 gevonden scores en slaagt als die hetzelfde zijn.

equalScore(MogelijkeCode, Poging):-
  scorex(Poging, X),
  scoreo(Poging, O),
  string_chars(Poging, PogingList),
  string_chars(MogelijkeCode, MogelijkeCode2),
  evaluate_trialx(MogelijkeCode2, PogingList, X2, MogelijkeCode3, PogingList2),
  evaluate_trialo(MogelijkeCode3, PogingList2, O2),
  length(X2, X3),
  length(O2, O3), !,
  X = X3,
  O = O3.

% Doet equalScores met alle pogingen met recursie tot de lijst met pogingen leeg is.

equalScores(_, []).
equalScores(MogelijkeCode, [H|T]):-
  equalScore(MogelijkeCode, H),
  equalScores(MogelijkeCode, T).

% Opd. 4.
% De goal is dat als een poging een score heeft van 5 Xen dan is de poging hetzelfde als de geheime code.

goal(Poging):-
  scorex(Poging, 5).

% Opd. 5.
% De move zoekt een volgend nummmer door determineNextNumber aan te roepen.

move(Visited, Number, NextNumber):-
  determineNextNumber(Visited, Number, NextNumber).

% determineNextNumber krijgt een lijst van vorige pogingen en een andere poging, doet de poging dan + 1 en doet dan met de nieuwe poging equalScores met de lijst van vorige pogingen. Als dit slaagt dan is de nieuwe poging het volgende nummer dat in de lijst met onthoudden pogingen gaat.
% Als equalScores niet slaagt dan doet hij de nieuwe poging + 1 en doet dan determineNextNumber opnieuw met recursie.

determineNextNumber(Lijst, Counter, NextNumber):-
  Counter2 is Counter + 1,
  equalScores(Counter2, Lijst),
  NextNumber = Counter2.
determineNextNumber(Lijst, Counter, NextNumber):-
  Counter2 is Counter + 1,
  determineNextNumber(Lijst, Counter2, NextNumber).

% Opd. 6.
% Dit is het stuk dat depthfirst_cyclefree een oplossing vind, hij onthoud de gevonden antwoorden.

solve_depthfirst_cyclefree(Node, Path) :-
  depthfirst_cyclefree([Node], Node, RevPath),
  reverse(RevPath, Path).

% Als de goal slaagt dan is het antwoord de lijst van alle gevonden antwoorden.

depthfirst_cyclefree(Visited, Node, Visited) :-
  goal(Node).

% Als de goal niet slaagt dan doet hij move, en gaat dus 1 stapje verder en doet opnieuw depthfirst_cyclefree todat de goal behaald is.

depthfirst_cyclefree(Visited, Node, Path) :-
  move(Visited, Node, NextNode),
  depthfirst_cyclefree([NextNode|Visited], NextNode, Path).

% Go roept solve_depthfirst_cyclefree met de beginpoging 10000 en krijgt dan als antwoord een lijst met alle gevonden pogingen en schrijft het mooi uit.

go():-
  solve_depthfirst_cyclefree(10000, X),
  writeln("************"),
  writeIt(X),
  writeln("************").

% Schrijft met recursie alle elementen van de uiteindelijke lijst mooi op.

writeIt([]).
writeIt([H|T]):-
  scorex(H, X),
  scoreo(H, O),
  write(H),
  write(" -- "),
  write(X),
  write("/"),
  writeln(O),
  writeIt(T).
