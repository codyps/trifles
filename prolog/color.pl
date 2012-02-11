%%%% coloring a graph

%%% a graph is a list of nodes
%%% a node is made with the functor node with arguments:
%%%  - name, a symbol (e.g. a or x)
%%%  - color, an integer
%%%  - neighbors, a list of node names (Note:  just the names, not the node(...)
%%%    structures)
%%% such that no two nodes in a graph have the same name and if a is a
%%% neighbor of b, b is a neighbor of a

%%% node_structure(+Name, +Graph, -Structure)  Graph is assumed to be a
%%% graph and Name is assumed to be the name of one of its nodes.  Structure
%%% is the node structure in Graph with name Name.
node_structure(Name, [node(Name, Color, Nbrs) | _],node(Name, Color, Nbrs)).
node_structure(Name, [_ | T], Structure):- node_structure(Name,T, Structure).

%%% all_names(+Graph, -Names) Graph is a list of nodes structures, Names is
%%% a list of just the names from the nodes in Graph

%%% FILLED in all_names here
all_names([],[]).
all_names([node(Name,_,_) | Rest], [Name | OtherNames] ):-
	all_names(Rest, OtherNames).

%%% all_unique(+List) List is assumed to be a list of symbols.
%%% all_unique is true if and only if there are no duplicate symbols in List.
%%% E.g., all_unique([a, b, c]) is true but all_unique([a, b, a]) is false.

%%% FILLED in all_unique here
all_unique([]).
all_unique([A | Rest]):-
	\+ member(A, Rest),
	all_unique(Rest).

%%% node_backlinks_valid(+Name, +Nbrs, +Graph) Name is assumed to be a node name,
%%% Nbrs is assumed to be a list of some of its neighbor names, and
%%% Graph is assumed to be a graph.   True if and only if every
%%% node in Nbrs has Name as a neighbor in Graph.  E.g. if
%%% G is [node(c, 0, [ ]), node(b, 0, [a, c]), node(a, 0, [b])]
%%% node_backlinks_valid(a, [b], G) is true but 
%%% node_backlinks_valid(b, [a, c]), G) is false because b is not in c's
%%% neighbor list in G

%%% FILLED in node_backlinks_valid here
node_backlinks_valid(_, _, []).
node_backlinks_valid(N, Nbrs, [node(SomeNode,_,SomeNodeNbrs)|Rest]):-
	member(SomeNode, Nbrs),
	!,
	member(N, SomeNodeNbrs),
	% could call with takeout(SomeNode, Nbrs, NewN)
	node_backlinks_valid(N, Nbrs, Rest).
node_backlinks_valid(N, Nbrs, [_|Rest]):-
	node_backlinks_valid(N, Nbrs, Rest).


% alternate, avoiding '!':
node_backlinks_valid2(_, _, []).
node_backlinks_valid2(N, Nbrs, [node(SomeNode,_,SomeNodeNbrs)|Rest]):-
	member(SomeNode, Nbrs),
	member(N, SomeNodeNbrs),
	% could call with takeout(SomeNode, Nbrs, NewN)
	node_backlinks_valid2(N, Nbrs, Rest).
node_backlinks_valid2(N, Nbrs, [node(SomeNode,_,_)|Rest]):-
	\+ member(SomeNode, Nbrs),
	node_backlinks_valid2(N, Nbrs, Rest).

%%% all_backlinks_valid(+Nodes, +Graph) Nodes is assumed to be a list of node
%%% structures, Graph a graph.  It is true if and only if all the nodes in Nodes
%%% are backlink valid in Graph.

%%% FILLED in all_backlinks_valid here
all_backlinks_valid([], _).
all_backlinks_valid([node(N, _, Nbrs) | Rest], G):-
	node_backlinks_valid(N, Nbrs, G),
	all_backlinks_valid(Rest, G).

%%% graph_valid(+G) G is assumed to be a graph.  It is true iff all the node
%%% names in G are unique and all the backlinks in G are valid
graph_valid(G):-
	all_names(G, Names), all_unique(Names), all_backlinks_valid(G, G).

%max_color(k) means k is the number of colors allowed

max_color(3).
% For the last example, adjust to 4 so it matches the given output.
%max_color(4).

%%% color(-N) N is an integer in the range from 1 thru max color

%%% FILLED in color here (TODO: avoid 'between', possibly?).
color(N):- max_color(M), between(1, M, N).

%%% colors_of(+Names, +Graph, -Colors) Names is a list of node names, Graph is a
%%% list of node structures, Colors is the list of colors that Nodes have in
%%% Graph

%%% FILLED in colors_of here
%%% NOTE: the example returns the color list in the reverse order.
%%%%      both are technically correct, though.
colors_of(_,[],[]).
colors_of(Names, [node(N, C, _) | Rest], [C | C_rest]) :-
	member(N, Names),
	colors_of(Names, Rest, C_rest).
colors_of(Names, [node(N, _, _) | Rest], Cs) :-
	\+ member(N, Names),
	colors_of(Names, Rest, Cs).

%%% valid_colors(+Nodes, +Graph) Nodes is a list of node structures,
%%% Graph is a graph.  Nodes is a tail (cdr of cdr ... of cdr) of Graph.
%%% True iff each nodes in Nodes has a
%%% different color than its neighbors in Graph.
valid_colors([ ], _).
valid_colors([node(_,Color,Nbrs) | Nodes], All_nodes):-
	colors_of(Nbrs, All_nodes, Colors),
	\+(member(Color, Colors)),
	valid_colors(Nodes, All_nodes).

%%% valid_colors(+G) G is assumed to be a graph, True iff G is legally
%%% colored, ie if no arc links two nodes of the same color
valid_colors(All_nodes):-valid_colors(All_nodes, All_nodes).

%%% colored_nodes(Nodes) is a list of node structures with some color
%%% filled in for each structure
colored_nodes([ ]).
colored_nodes([node(_, Color, _) | Nodes]):-
	color(Color),
	colored_nodes(Nodes).

%%% solve_coloring(+Nodes) Nodes is a graph, ie a coloring problem,
%%% Chooses a valid color for each node in Nodes

%%% FILLED in solve_coloring here
solve_coloring(Nodes):-
	colored_nodes(Nodes),
	valid_colors(Nodes).
