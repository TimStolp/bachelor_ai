% PSS Huiswerk # #
% 2-10-2017
% Tim Stolp, 11848782, tim2stolp@gmail.com


% Opd. 1.

% Neem een random member uit de lijst, verwijder de member uit de lijst, doe dit 4x voor 4 verschillende kleuren.

random_code([A1, A2, A3, A4]):-
  random_member(A1, [rood, oranje, geel, blauw, groen, bruin]),
  select(A1, [rood, oranje, geel, blauw, groen, bruin], L2),
  random_member(A2, L2),
  select(A2, L2, L3),
  random_member(A3, L3),
  select(A3, L3, L4),
  random_member(A4, L4).

% Opd. 2.

% findall() geeft hier een lijst van alle antwoorden die je krijgt als je all_codes2() gaat backtracken, daarna checkt length() de lengte van die lijst.
% Dan schrijft prolog met write() (en writeln() om het overzichtelijker te maken) de lengte van de lijst en geeft natuurlijk als antwoord van all_codes() gewoon de lijst van alle mogelijkheden.
% De procenten weghalen als je wilt dat prolog het aantal elementen in de lijst opschrijft, dit is weggelaten omdat dit stuk gebruikt wordt in verdere opgaven.

all_codes(C):-
  findall(A, all_codes2(A), C).
% length(C, B),
% write('Number of codes is '),
% writeln(B),
% writeln('').

% Dit stukje code geeft als je bij het antwoord met ; gaat backtracken alle verschillende mogelijke codes, dit zijn 6*5*4*3 (360) mogelijkheden.
all_codes2([A1, A2, A3, A4]):-
  select(A1, [rood, oranje, geel, blauw, groen, bruin], _),
  select(A2, [rood, oranje, geel, blauw, groen, bruin], _),
  select(A3, [rood, oranje, geel, blauw, groen, bruin], _),
  select(A4, [rood, oranje, geel, blauw, groen, bruin], _),
  \+ A2 = A1,
  \+ A3 = A1,
  \+ A3 = A2,
  \+ A4 = A1,
  \+ A4 = A2,
  \+ A4 = A3.

% Opd. 3.

% Haal lijst met alle codes, check of de test code in de lijst met alle codes zit, doe dan evaluate_trial2 met de geheime code en de test.
% Evaluate_trial2 checkt of de heads van de 2 codes gelijk zijn, zet dan een "x" neer, of checkt of de head van de test lijst in de gehele geheime code zit, zet dan een "o" neer.
% Als dat beide niet zo is zet niks neer, doe dit met recursie door te tail van de 2 codes te gebruiken.

evaluate_trial(A, B, D):-
  all_codes(X),
  member(B, X),
  evaluate_trial2(A, A, B, C),
  sort(0, @>=, C, D).

evaluate_trial2(_, [], [], []).
evaluate_trial2(X, [A|B], [C|D], [x|E]):-
  A = C,
  evaluate_trial2(X, B, D, E).
evaluate_trial2(X, [_|B], [C|D], [o|E]):-
  member(C, X),
  evaluate_trial2(X, B, D, E).
evaluate_trial2(X, [_|B], [_|D], E):-
  evaluate_trial2(X, B, D, E).

% Opd. 4/5.

% hier staan opdrachten 4 en 5 door elkaar heen.
% Het werkt, maar niet =< 6 pogingen omdat ik niet wist wel algoritme ik precies moest coderen.
% update maakt een lijst met codes die dezelfde uitkomst van evaluate trial zouden hebben als de 1e test poging, daarna doe je hetzelfde met als nieuwe test de head van de gemaakte lijst.

trials(R, _, _, List2):-
  random_code(R),
  all_codes(Codes),
  update(1, R, Codes, List2).

update(_, R, Codes, R):-
  [R] = Codes.
update(N, R, [H|T], Answer):-
  random_member(H2, [H|T]),
  write("Poging "),
  write(N),
  write( = ),
  write(H2),
  evaluate_trial(R, H2, S),
  writeln(S),
  check(R, [H|T], S, X),
  N2 is N + 1,
  update(N2, R, X, Answer).

% Check checkt of de head van de ingevoerde lijst de gegeven uitkomst van evaluate_trial krijgt, als dat zo is onthoud de head, anders gooi je hem weg.

check(_, [], _, []).
check(R, [H|T], S, [H|X]):-
  evaluate_trial(R, H, S),
  check(R, T, S, X).
check(R, [_|T], S, X):-
  check(R, T, S, X).
