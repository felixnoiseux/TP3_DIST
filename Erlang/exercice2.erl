-module(exercice2).
-include("expr.hrl").
-compile(export_all).

% Lit le fichier, le ferme et retourne les lignes du fichier sous-forme de liste afin 
% qu'elles puissent être manipulées par d'autres fonctions.
lireFichier(Fichier) ->
    {ok, ToutesLignes} = file:open(Fichier, [read]),
    Liste = lireLigne(ToutesLignes),
    file:close(ToutesLignes),
    % La première ligne ne sert à rien. Il faut donc l'enlever.
    lists:nthtail(1, Liste).

% Appel récursif qui retourne toutes les lignes pour qu'elles puissent être utilisées dans la fonction lireFichier.
lireLigne(ToutesLignes) ->
    case file:read_line(ToutesLignes) of
        {ok, Ligne} ->
                % On effectue un droplast sur la ligne pour enlever le changement de ligne à la fin.
                [lists:droplast(Ligne)] ++ lireLigne(ToutesLignes);
    eof -> []
end.

% Convertit les lignes lues dans la fonction lireFichier en enregistrements destinés à être manipulés dans la fonction main.
lignesVersExpressions([]) ->
    [];
lignesVersExpressions(Liste) ->
    Ligne = lists:nth(1, Liste),
    CommenceParGuillemet = string:str(Ligne, "\""),
    DernierCaractere = lists:last(Ligne),
    [Expr, Sign] = string:tokens(Ligne, ";"),
    if (CommenceParGuillemet == 0) or (DernierCaractere == 34) ->
        Record = #expr{expr = Expr, signification = Sign},
        [Record] ++ lignesVersExpressions(lists:nthtail(1, Liste));
    true ->
        SignComplet = Sign ++ " " ++ lists:nth(2, Liste),
        Record = #expr{expr = Expr, signification = SignComplet},
        [Record] ++ lignesVersExpressions(lists:nthtail(2, Liste))
    end.

trouverExpression([], Recherche) ->
    throw("Aucun match.");
trouverExpression(Liste, Recherche) ->
    Entree = lists:nth(1, Liste),
    Match = Entree#expr.expr == Recherche,
    if Match ->
        Entree;
    true ->
        trouverExpression(lists:nthtail(1, Liste), Recherche)
    end.

% Point d'entrée. Toute les autres fonctions sont appelées ici. Directement ou indirectement.
main() ->
    Liste = lireFichier("expression.csv"),
    Expressions = lignesVersExpressions(Liste),
    Expr = lists:droplast(io:get_line("Entrez une expression: ")),
    Match = trouverExpression(Expressions, Expr),
    io:fwrite(Match#expr.signification ++ "\n").
