% Herederos: 1 hija, 2 hermanos, 2 primos
madre(beatriz, hija1).
hermano(hermano1, hija1).
hermano(hermano2, hija1).
primo(primo1, primo1).
primo(primo2, primo2).

% Definición de consanguinidad
levelConsanguinity(X, Y, 1) :- madre(X, Y).
levelConsanguinity(X, Y, 1) :- madre(Y, X).
levelConsanguinity(X, Y, 2) :- hermano(X, Y).
levelConsanguinity(X, Y, 2) :- hermano(Y, X).
levelConsanguinity(X, Y, 3) :- primo(X, Y).
levelConsanguinity(X, Y, 3) :- primo(Y, X).

% Distribución de la herencia
distributeInheritance(Total, Distribution) :-
    findall(P, levelConsanguinity(_, P, 1), Level1),
    findall(P, levelConsanguinity(_, P, 2), Level2),
    findall(P, levelConsanguinity(_, P, 3), Level3),

    length(Level1, N1),
    length(Level2, N2),
    length(Level3, N3),

    TotalPercentage is (N1 * 30) + (N2 * 20) + (N3 * 10),
    TotalDistribution is TotalPercentage / 100,

    (TotalDistribution =< 1 ->
        P1 is Total * 0.3 / N1,
        P2 is Total * 0.2 / N2,
        P3 is Total * 0.1 / N3
    ;
        P1 is Total * 0.3 / TotalDistribution,
        P2 is Total * 0.2 / TotalDistribution,
        P3 is Total * 0.1 / TotalDistribution
    ),

    append(Level1, Level2, Temp),
    append(Temp, Level3, Heirs),

    findall(distribution(Person, Amount), (
        member(Person, Heirs),
        (member(Person, Level1) -> Amount = P1;
         member(Person, Level2) -> Amount = P2;
         member(Person, Level3) -> Amount = P3)
    ), Distribution).

% Caso de prueba
test_case3(Distribution) :-
    distributeInheritance(150000, Distribution).
