-module(exercice1).
-import(lists, [max/1, sublist/2]).
-include("livre.hrl").
-export([ex1/0]).	

ex1()->
	L1 = #livre{isbn="9783425040639",titre="Letranger", auteur1="Albert Camus", auteur2="", edition="Edition Christian",prix_achat=10.0, prix_vente=20.0, nombre_exemplaires_initial = 25, nombre_exemplaires_actuel=10 },
	L2 = #livre{isbn="8883425040639",titre="La vie d'esclave au college", auteur1="Felix Noiseux", auteur2="Raphael Lapointe", edition="Beliveau Editeur",prix_achat=5.0, prix_vente=15.0, nombre_exemplaires_initial = 50, nombre_exemplaires_actuel=30 },
	L3 = #livre{isbn="1243432459039",titre="Developpement Agile", auteur1="Stephane Denis", auteur2="", edition="La courte echelle",prix_achat=20.0, prix_vente=35.0, nombre_exemplaires_initial = 10, nombre_exemplaires_actuel=1 },
	L4 = #livre{isbn="0941731348877",titre="Apprendre Java", auteur1="Giovana Ensei", auteur2="", edition="Flammarion Quebec",prix_achat=2.0, prix_vente=5.0, nombre_exemplaires_initial = 20, nombre_exemplaires_actuel=17 },
	L5 = #livre{isbn="4894794128472",titre="Lenigme de l'Atlantide", auteur1="Edouard Brassey", auteur2="", edition="Front Froid",prix_achat=1.0, prix_vente=2.0, nombre_exemplaires_initial = 1, nombre_exemplaires_actuel=1 },
	LstLivres = [L1, L2, L3, L4, L5],
    LstLivresPlusCher = lists:sort(fun (A, B) -> A#livre.prix_vente >= B#livre.prix_vente end, LstLivres),
    LstLivresMoinsCher = lists:sort(fun (A, B) -> A#livre.prix_vente =< B#livre.prix_vente end, LstLivres),
	LstLivresPlusVendus = lists:sort(fun (A, B) -> (A#livre.nombre_exemplaires_initial - A#livre.nombre_exemplaires_actuel) >= (B#livre.nombre_exemplaires_initial - B#livre.nombre_exemplaires_actuel) end, LstLivres),
	LstLivresMoinsVendus = lists:sort(fun (A, B) -> (A#livre.nombre_exemplaires_initial - A#livre.nombre_exemplaires_actuel) =< (B#livre.nombre_exemplaires_initial - B#livre.nombre_exemplaires_actuel) end, LstLivres),
	LstLivresPlusVendusFinal = sublist(LstLivresPlusVendus, length(LstLivresPlusVendus)div 2), 
	LstLivresMoinsVendusFinal = sublist(LstLivresMoinsVendus, (length(LstLivresPlusVendus) + 1) div 2),
	io:format("~n~n ==========TITRES DES LIVRES LES PLUS CHERS========== ~n~n"),
	lists:foreach(fun(Y) -> erlang:display("Titre: " ++ Y#livre.titre ++ ", Prix: " ++ float_to_list(Y#livre.prix_vente, [{decimals, 2}]) ++ "$")end, LstLivresPlusCher),
	timer:sleep(1000),
	io:format("~n~n ==========LIVRES LES MOINS CHERS==========  ~n~n"),
	lists:foreach(fun(Y) -> erlang:display("Titre: " ++ Y#livre.titre ++ ", Prix: " ++ float_to_list(Y#livre.prix_vente, [{decimals, 2}]) ++ "$")end, LstLivresMoinsCher),
	timer:sleep(1000),
	io:format("~n~n ==========LIVRES LES PLUS VENDUS=========== ~n~n"),
	lists:foreach(fun(Y) -> erlang:display("Titre: " ++ Y#livre.titre ++ ", Quantite vendu: " ++ integer_to_list(Y#livre.nombre_exemplaires_initial - Y#livre.nombre_exemplaires_actuel))end, LstLivresPlusVendus),
	timer:sleep(1000),
	io:format("~n~n ==========LIVRES LES MOINS VENDUS=========== ~n~n"),
	lists:foreach(fun(Y) -> erlang:display("Titre: " ++ Y#livre.titre ++ ", Quantite vendu: " ++ integer_to_list(Y#livre.nombre_exemplaires_initial - Y#livre.nombre_exemplaires_actuel))end, LstLivresMoinsVendus),
	timer:sleep(1000),
	io:format("~n~n =====================AUGMENTATION DE 10% DU PRIX DE VENTES DES 2 PREMIERS LIVRES LES PLUS POPULAIRES===================== ~n~n"),
	lists:foreach(fun(Y) -> erlang:display("Titre: " ++ Y#livre.titre ++ ", Quantite vendu: " ++ 
											integer_to_list(Y#livre.nombre_exemplaires_initial - Y#livre.nombre_exemplaires_actuel) ++ 
											", PrixVente Initial : " ++ float_to_list(Y#livre.prix_vente, [{decimals, 2}]) ++ ", PrixVente Augmente: " ++ 
											float_to_list(Y#livre.prix_vente * 1.10, [{decimals, 2}]))end, LstLivresPlusVendusFinal),
	timer:sleep(1000),
	io:format("~n~n =====================DIMINUTION DE 10% DU PRIX DE VENTES DES 3 PREMIERS LIVRES LES MOINS POPULAIRES===================== ~n~n"),
	lists:foreach(fun(Y) -> erlang:display("Titre: " ++ Y#livre.titre ++ ", Quantite vendu: " ++ 
											integer_to_list(Y#livre.nombre_exemplaires_initial - Y#livre.nombre_exemplaires_actuel) ++ 
											", PrixVente Initial : " ++ float_to_list(Y#livre.prix_vente, [{decimals, 2}]) ++ ", PrixVente Diminue: " ++ 
											float_to_list(Y#livre.prix_vente *0.9, [{decimals, 2}]))end, LstLivresMoinsVendusFinal),
	timer:sleep(1000),
	io:format("~n~n =====================Afficher les ISBN et les titres des livres d’un auteur saisi au clavier===================== ~n~n"),
	{ok, [NOM_AUTEUR]} = io:fread("donner l'auteur ", "~s"),
	LstAuteurs = lists:any(fun(X) -> X#livre.auteur1 == NOM_AUTEUR end, LstLivres),
	io:format("Ateur: ~p~n", [LstAuteurs]).

