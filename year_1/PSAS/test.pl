% Huiswerk 5

draw():-
  retractall(code(_)),
  random_between(10000, 99999, A),
  asserta(code(A)),
  writeln("********************"),
  write("De code: "),
  writeln(A),
  write("********************").



scorex(N, X):-
  string_chars(N, Poging),
  code(A),
  string_chars(A, Code),
  evaluate_trialx(Code, Poging, Score, _, _),
  length(Score, X).




evaluate_trialx([], [], [], [], []).
evaluate_trialx([A|B], [C|D], [x|E], F, G):-
    A = C,
  evaluate_trialx(B, D, E, F, G).
evaluate_trialx([A|B], [C|D], E, [A|F], [C|G]):-
  evaluate_trialx(B, D, E, F, G).

  evaluate_trail_o([_], [], []).
  evaluate_trail_o(A, [H|T], [o|X]) :-
    member(H, A),
    select(H, A, N),
    evaluate_trail_o(N, T, X).
  evaluate_trail_o(A, [_|T], X) :-
    evaluate_trail_o(A, T, X).

  scoreo(Poging, Oscore) :-
    code(A),
    string_chars(A, Code),
    string_chars(Poging, ListPoging),
    evaluate_trailx(Code, ListPoging, _, RestCode, RestPoging),
    evaluate_trail_o(RestCode, RestPoging, Antwoord),
    length(Antwoord, Oscore).


equalScore(MogelijkePogingen, Poging):-
  scoreo(Poging, O),
  scorex(Poging, X),
  scoreo(MogelijkePogingen, O),
  scorex(MogelijkePogingen, X).

equalScores(_), []).
equalScores(MogelijkePogingen [H|T]):-
  equalScore(MogelijkePogingen, H),
  equalScores(MogelijkePogingen, T).

goal(Poging):-
  scorex(Poging, 5).
