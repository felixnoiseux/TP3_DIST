-module(exercice1).
-import(lists, [max/1]).
-include("livre.hrl").
-export([ex1/0]).	

ex1()->
	L1 = #livre{isbn="9783425040639",titre="Letranger", auteur1="Albert Camus", auteur2="", edition="Edition Christian",prix_achat=10, prix_vente=20, nombre_exemplaires_initial = 25, nombre_exemplaires_actuel=10 },
	L2 = #livre{isbn="8883425040639",titre="La vie d'esclave au college", auteur1="Felix Noiseux", auteur2="Raphael Lapointe", edition="Beliveau Editeur",prix_achat=5, prix_vente=15, nombre_exemplaires_initial = 50, nombre_exemplaires_actuel=30 },
	L3 = #livre{isbn="1243432459039",titre="Developpement Agile", auteur1="Stephane Denis", auteur2="", edition="La courte echelle",prix_achat=20, prix_vente=35, nombre_exemplaires_initial = 10, nombre_exemplaires_actuel=1 },
	L4 = #livre{isbn="0941731348877",titre="Apprendre Java", auteur1="Giovana Ensei", auteur2="", edition="Flammarion Quebec",prix_achat=2, prix_vente=5, nombre_exemplaires_initial = 20, nombre_exemplaires_actuel=17 },
	L5 = #livre{isbn="4894794128472",titre="Lenigme de l'Atlantide", auteur1="Edouard Brassey", auteur2="", edition="Front Froid",prix_achat=1, prix_vente=2, nombre_exemplaires_initial = 1, nombre_exemplaires_actuel=1 },
	LstLivres = [L1, L2, L3, L4, L5],
    LstLivresPlusCher = lists:sort(fun (A, B) -> A#livre.prix_vente >= B#livre.prix_vente end, LstLivres),
    LstLivresMoinsCher = lists:sort(fun (A, B) -> A#livre.prix_vente =< B#livre.prix_vente end, LstLivres),
	LstLivresPlusVendus = lists:sort(fun (A, B) -> (A#livre.nombre_exemplaires_initial - A#livre.nombre_exemplaires_actuel) >= (B#livre.nombre_exemplaires_initial - B#livre.nombre_exemplaires_actuel) end, LstLivres),
	LstLivresMoinsVendus = lists:sort(fun (A, B) -> (A#livre.nombre_exemplaires_initial - A#livre.nombre_exemplaires_actuel) =< (B#livre.nombre_exemplaires_initial - B#livre.nombre_exemplaires_actuel) end, LstLivres),
	io:format("~n~n ==========LIVRES LES PLUS CHERS========== ~n~n"),
	io:format("Livres les plus chers : ~p~n", [LstLivresPlusCher]),
	io:format("~n~n ==========LIVRES LES MOINS CHERS==========  ~n~n"),
	io:format("Livres les moins chers : ~p~n", [LstLivresMoinsCher]),
	io:format("~n~n ==========LIVRES LES PLUS VENDUS=========== ~n~n"),
	io:format("Livres les plus vendus : ~p~n", [LstLivresPlusVendus]),
	io:format("~n~n ==========LIVRES LES MOINS VENDUS=========== ~n~n"),
	io:format("Livres les plus vendus : ~p~n", [LstLivresMoinsVendus]),
	io:format("~n~n =====================AUGMENTATION DE 10% DU PRIX DE VENTES DES 3 PREMIERS LIVRES LES PLUS POPULAIRES===================== ~n~n"),
	io:format("~n~n =====================DIMINUTION DE 10% DU PRIX DE VENTES DES 2 PREMIERS LIVRES LES MOINS POPULAIRES===================== ~n~n"),
	io:format("Livres les plus vendus : ~p~n", [LstLivresPlusVendus]),
	io:format("~n~n =====================Afficher les ISBN et les titres des livres d’un auteur saisi au clavier===================== ~n~n"),
	{ok, [NOM_AUTEUR]} = io:fread("donner l'auteur ", "~s"),
	LstAuteurs = lists:any(fun(X) -> X#livre.auteur1 == NOM_AUTEUR end, LstLivres),
	io:format("Ateur: ~p~n", [LstAuteurs]).
