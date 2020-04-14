% Bilal Tekin
% 2017400264
% compiling: yes
% complete: yes

% artist(ArtistName, Genres, AlbumIds).
% album(AlbumId, AlbumName, ArtistNames, TrackIds).
% track(TrackId, TrackName, ArtistNames, AlbumName, [Explicit, Danceability, Energy,
%                                                     Key, Loudness, Mode, Speechiness,
%                                                     Acousticness, Instrumentalness, Liveness,
%                                                     Valence, Tempo, DurationMs, TimeSignature]).








features([explicit-0, danceability-1, energy-1,
          key-0, loudness-0, mode-1, speechiness-1,
       	  acousticness-1, instrumentalness-1,
          liveness-1, valence-1, tempo-0, duration_ms-0,
          time_signature-0]).

filter_features(Features, Filtered) :- features(X), filter_features_rec(Features, X, Filtered).
filter_features_rec([], [], []).
filter_features_rec([FeatHead|FeatTail], [Head|Tail], FilteredFeatures) :-
    filter_features_rec(FeatTail, Tail, FilteredTail),
    _-Use = Head,
    (
        (Use is 1, FilteredFeatures = [FeatHead|FilteredTail]);
        (Use is 0,
            FilteredFeatures = FilteredTail
        )
    ).




% artist(ArtistName, Genres, AlbumIds).
% album(AlbumId, AlbumName, ArtistNames, TrackIds).
% track(TrackId, TrackName, ArtistNames, AlbumName, [Explicit, Danceability, Energy,
%                                                     Key, Loudness, Mode, Speechiness,
%                                                     Acousticness, Instrumentalness, Liveness,
%                                                     Valence, Tempo, DurationMs, TimeSignature]).


% @@@@@   @@@@@   @@@@@   @@@@@   @@@@@  getArtistTracks(+ArtistName, -TrackIds, -TrackNames) 5 points   @@@@@   @@@@@   @@@@@   @@@@@    @@@@@   @@@@@   @@@@@

% COMPLETED
getArtistTracks(ArtistName, TrackIds, TrackNames) :-
    artist(ArtistName,_,AlbumIds),
    findTrackIdsWithAlbumIds(AlbumIds,NestedTrackIds),
    nestedListToSingleList(NestedTrackIds,TrackIds),
    findTrackNamesWithTrackIds(TrackIds,TrackNames).



% @@@@@   @@@@@   @@@@@   @@@@@   @@@@@  albumFeatures(+AlbumId, -AlbumFeatures) 5 points   @@@@@   @@@@@   @@@@@   @@@@@    @@@@@   @@@@@   @@@@@

% COMPLETED
albumFeatures(AlbumId, AlbumFeatures) :-
    album(AlbumId,_,_,AlbumTrackIds),
    findFeatureListWithTrackIdsList(AlbumTrackIds,TempAlbumFeatures),
    listLength(TempAlbumFeatures,Length),
    nestedListToSingleListAndAddElements(TempAlbumFeatures,AverageFeatures),
    averageOfListLengthGiven(AverageFeatures,Length,AlbumFeatures),!.

% @@@@@   @@@@@   @@@@@   @@@@@   @@@@@  artistFeatures(+ArtistName, -ArtistFeatures) 5 points   @@@@@   @@@@@   @@@@@   @@@@@    @@@@@   @@@@@   @@@@@

% COMPLETED
artistFeatures(ArtistName, ArtistFeatures) :-
    getArtistTracks(ArtistName,TrackIds,_),
    findFeatureListWithTrackIdsList(TrackIds,TempTrackFeatures),
    listLength(TempTrackFeatures,Length),
    nestedListToSingleListAndAddElements(TempTrackFeatures,AverageFeatures),
    averageOfListLengthGiven(AverageFeatures,Length,ArtistFeatures),!.


% @@@@@   @@@@@   @@@@@   @@@@@   @@@@@  trackDistance(+TrackId1, +TrackId2, -Score) 5 points   @@@@@   @@@@@   @@@@@   @@@@@    @@@@@   @@@@@   @@@@@

% COMPLETED
trackDistance(TrackId1, TrackId2, Score):-
    findTrackFeatureWithTrackId(TrackId1,Track1Feature),
    findTrackFeatureWithTrackId(TrackId2,Track2Feature),
    distanceBetweenTwoFeature(Track1Feature,Track2Feature,Score),!.

% @@@@@   @@@@@   @@@@@   @@@@@   @@@@@  albumDistance(+AlbumId1, +AlbumId2, -Score) 5 points   @@@@@   @@@@@   @@@@@   @@@@@    @@@@@   @@@@@   @@@@@

% COMPLETED
albumDistance(AlbumId1, AlbumId2, Score) :-
    albumFeatures(AlbumId1,Album1Feature),
    albumFeatures(AlbumId2,Album2Feature),
    distanceBetweenTwoFeature(Album1Feature,Album2Feature,Score),!.
    


% @@@@@   @@@@@   @@@@@   @@@@@   @@@@@  artistDistance(+ArtistName1, +ArtistName2, -Score) 5 points   @@@@@   @@@@@   @@@@@   @@@@@    @@@@@   @@@@@   @@@@@

% COMPLETED
artistDistance(ArtistName1, ArtistName2, Score) :-
    artistFeatures(ArtistName1, Artist1Features),
    artistFeatures(ArtistName2, Artist2Features),
    distanceBetweenTwoFeature(Artist1Features,Artist2Features,Score),!.



% @@@@@   @@@@@   @@@@@   @@@@@   @@@@@  findMostSimilarTracks(+TrackId, -SimilarIds, -SimilarNames) 10 points   @@@@@   @@@@@   @@@@@   @@@@@    @@@@@   @@@@@   @@@@@

% COMPLETED
findMostSimilarTracks(TrackId, SimilarIds, SimilarNames):-
    findall(TempTrackNames,( track(_,TempTrackNames,_,_,_) ),TempTrackNames),
    findall(TempTrackIds,( track(TempTrackIds,_,_,_,_) ),TempTrackIds),
    findDistanceOfAllTracksFromSpecificTrack(TrackId,TempTrackIds,TempTrackNames,Score),
    sortAscending(Score,SortedScore),
    removeFirstElementOfList(SortedScore,LastSortedScore),
    getFirstNElementsOfList(30,LastSortedScore,SimilarIds,SimilarNames),!.


% @@@@@   @@@@@   @@@@@   @@@@@   @@@@@  findMostSimilarAlbums(+AlbumId, -SimilarIds, -SimilarNames) 10 points   @@@@@   @@@@@   @@@@@   @@@@@    @@@@@   @@@@@   @@@@@

% COMPLETED
findMostSimilarAlbums(AlbumId, SimilarIds, SimilarNames):-
    findall(AlbumIds,( album(AlbumIds,_,_,_) ),AlbumIds),
    findall(AlbumNames,( album(_,AlbumNames,_,_) ),AlbumNames),
    findDistanceOfAllAlbumsFromSpecificAlbum(AlbumId,AlbumIds,AlbumNames,Score),
    sortAscending(Score,SortedScore),
    removeFirstElementOfList(SortedScore,LastSortedScore),
    getFirstNElementsOfList(30,LastSortedScore,SimilarIds,SimilarNames),!.

% @@@@@   @@@@@   @@@@@   @@@@@   @@@@@  findMostSimilarArtists(+ArtistName, -SimilarArtists) 10 points   @@@@@   @@@@@   @@@@@   @@@@@    @@@@@   @@@@@   @@@@@

% COMPLETED
findMostSimilarArtists(ArtistName, SimilarArtists):-
    findall(ArtistNames,( artist(ArtistNames,_,_) ),ArtistNames),
    findDistanceOfAllArtistsFromSpecificArtist(ArtistName,ArtistNames,Score),
    sortAscending(Score,SortedScore),
    removeFirstElementOfList(SortedScore,LastSortedScore),
    getFirstNElementsOfList2(30,LastSortedScore,SimilarArtists),!.



% findDistanceOfAllTracksFromSpecificTrack(SpecificTrackFeature,[],[],[],[]).
% findDistanceOfAllTracksFromSpecificTrack(SpecificTrackFeature,[H1|T1],[H2|T2],[H3|T3],Score):-
%     findDistanceOfAllTracksFromSpecificTrack(SpecificTrackFeature,T1,T2,T3,Score2),
%     distanceBetweenTwoFeature(SpecificTrackFeature,H1,TempScore3),
%     Score = [[TempScore3,H3,H2]|Score2].



findDistanceOfAllTracksFromSpecificTrack(SpecificTrackId,[],[],[]).
findDistanceOfAllTracksFromSpecificTrack(SpecificTrackId,[H1|T1],[H2|T2],Score):-
    findDistanceOfAllTracksFromSpecificTrack(SpecificTrackId,T1,T2,Score2),
    trackDistance(SpecificTrackId,H1,Distance),
    Score = [[Distance,H1,H2]|Score2].


findDistanceOfAllAlbumsFromSpecificAlbum(SpecificAlbumId,[],[],[]).
findDistanceOfAllAlbumsFromSpecificAlbum(SpecificAlbumId,[H1|T1],[H2|T2],Score):-
    findDistanceOfAllAlbumsFromSpecificAlbum(SpecificAlbumId,T1,T2,Score2),
    albumDistance(SpecificAlbumId,H1,Distance),
    Score = [[Distance,H1,H2]|Score2].


findDistanceOfAllArtistsFromSpecificArtist(SpecificArtistName,[],[]).
findDistanceOfAllArtistsFromSpecificArtist(SpecificArtistName,[H1|T1],Score):-
    findDistanceOfAllArtistsFromSpecificArtist(SpecificArtistName,T1,Score2),
    artistDistance(SpecificArtistName,H1,Distance),
    Score = [[Distance,H1]|Score2].


% Returns First N elements (3 Elements inside each list) from NESTED LIST : [ [] [] ]
getFirstNElementsOfList(0,_,_,_):- !.
getFirstNElementsOfList(_,[],[],[]).
getFirstNElementsOfList(N,[H|T],SimilarIds,SimilarNames):-
    N1 is N - 1,
    getFirstNElementsOfList(N1,T,SimilarIds2,SimilarNames2),
    [_|[L|[R]]] = H, %[1 , 2 , 3]
    append([L],SimilarIds2,SimilarIds),
    append([R],SimilarNames2,SimilarNames).
    

% Returns First N elements(2 Elements inside each list) from NESTED LIST : [ [] [] ]
getFirstNElementsOfList2(0,_,_):- !.
getFirstNElementsOfList2(_,[],[]).
getFirstNElementsOfList2(N,[H|T],SimilarNames):-
    N1 is N - 1,
    getFirstNElementsOfList2(N1,T,SimilarNames2),
    [_|L] = H, %[1 , 2]
    append(L,SimilarNames2,SimilarNames).



sortAscending(List, Sorted):-
    sort(0,  @=<, List,  Sorted).

% ########  Distance Between Two Features ######################
distanceBetweenTwoFeature(Track1Feature,Track2Feature,Score):-
    differenceSquareThenSumOfElementsOfList(Track1Feature,Track2Feature,SummedDifScore),
    Score is SummedDifScore ** 0.5.


differenceSquareThenSumOfElementsOfList([],[],0).
differenceSquareThenSumOfElementsOfList([H1|T1],[H2|T2],Score):-
    differenceSquareThenSumOfElementsOfList(T1,T2,Score2),
    M is ((H1 - H2) ** 2),
    Score is M+Score2.

% ##############################################################

% @ @ CORRECT @ @
findTrackFeatureWithTrackId(TrackId,TrackFeature) :-
    track(TrackId,_,_,_,TempTrackFeature),
    filter_features(TempTrackFeature,TrackFeature).


% % Human and What he likes
% findAllTracksIdsAndTrackNamesWithArtistName(ArtistName,TrackIds,TrackNames) :- 
%     findall(TrackIds, ( track(TrackIds,_,[ArtistName|_],_,_) ), TrackIds),
%     findall(TrackNames, ( track(_,TrackNames,[ArtistName|_],_,_) ), TrackNames).




% % Checked @@
% findAllTracksFeaturesWithArtistName(ArtistName,ArtistFeatures) :- 
%     findall(ArtistFeatures, ( track(_,_,Y,_,ArtistFeatures),member(ArtistName,Y) ), ArtistFeatures).



% findAllTracksIdsWithArtistName(ArtistName,TrackIds) :- 
%     findall(TrackIds, ( track(TrackIds,_,[ArtistName],_,_)), TrackIds).


% Filter Nested Feature List = [ [], [] ]
filterNestedFeatureList([],[]).
filterNestedFeatureList([H|T], ResultFeatureNestedList):-
    filterNestedFeatureList(T,ResultFeatureNestedList2),
    filter_features(H,FilteredFeature),
    ResultFeatureNestedList = [FilteredFeature|ResultFeatureNestedList2].



% Checked @@
findAllTrackFeaturesWithAlbumName(AlbumName,AlbumFeatures):-
    findall(AlbumFeatures, ( track(_,_,_,AlbumName,AlbumFeatures) ), AlbumFeatures).


% @ @ CORRECT @ @
% Finds TrackIds List = (Nested List) from AlbumIds List = (Not Nested)
findTrackIdsWithAlbumIds([],[]).
findTrackIdsWithAlbumIds([H|T],TrackIds):-
    findTrackIdsWithAlbumIds(T,TrackIds2),
    album(H,_,_,TempTrackIds),
    ( isVariableFree(TrackIds2), TrackIds = TempTrackIds;
    (\+ isVariableFree(TrackIds2)), TrackIds = [TempTrackIds|TrackIds2]).




% Takes Lists like this : [[1,1,1],[2,2,2],[3,3,3]]
findAllTrackFeaturesWithTrackIds([],[]).
findAllTrackFeaturesWithTrackIds([H|T],Features):-
    findAllTrackFeaturesWithTrackIds(T,Features2),
    findFeatureListWithTrackIdsList(H,Temp2),
    nestedListToSingleListAndAddElements(Temp2,Temp3),
    % writeToFile("Temp3 : " + Temp3),
    ( isVariableFree(Features2), Features = [Temp3];
    (\+ isVariableFree(Features2)), Features = [Temp3|Features2]).




% @ @ CORRECT @ @
% Finds Feature List from Track Id List
findFeatureListWithTrackIdsList([],[]).
findFeatureListWithTrackIdsList([H|T],AlbumFeatures):-
    findFeatureListWithTrackIdsList(T,AlbumFeatures2),
    track(H,_,_,_,TempTrackFeature),
    filter_features(TempTrackFeature,FilteredTempTrackFeature),
    ( isVariableFree(AlbumFeatures2), AlbumFeatures = [FilteredTempTrackFeature];
    (\+ isVariableFree(AlbumFeatures2)), AlbumFeatures = [FilteredTempTrackFeature|AlbumFeatures2]).



% % Finds Feature List from Artist Names List 
% findAllTrackFeaturesWithArtistNames([],[]).
% findAllTrackFeaturesWithArtistNames([H|T],ArtistFeatures):-
%     findAllTrackFeaturesWithArtistNames(T,ArtistFeatures2),
%     writeToFile("H : " + H),
%     artistFeatures(H,TempTrackFeature),
%     writeToFile("TempTrackFeature : " + TempTrackFeature),
%     % nestedListToSingleListAndAddElements(TempTrackFeature,TempTrackFeature2),
%     % writeToFile("TempTrackFeature2 : " + TempTrackFeature2),
%     % filter_features(TempTrackFeature2,TempTrackFeature3),
%     % writeToFile("TempTrackFeature3 : " + TempTrackFeature3),
%     ( isVariableFree(ArtistFeatures2), ArtistFeatures = [TempTrackFeature];
%     (\+ isVariableFree(ArtistFeatures2)), ArtistFeatures = [TempTrackFeature|ArtistFeatures2]),
%     writeToFile("AlbumFeatures : " + ArtistFeatures).



% @ @ CORRECT @ @
% Average Of A List With Length Given.
averageOfListLengthGiven([],_,[]).
averageOfListLengthGiven([H|T],Length,AlbumFeatures):-
    averageOfListLengthGiven(T,Length,AlbumFeatures2),
    M is H / Length,
    AlbumFeatures = [M|AlbumFeatures2].






% @ @ CORRECT @ @
%  Find TrackNames = [] (Single List) WITH Track Ids = [] (Single List)
findTrackNamesWithTrackIds([],[]).
findTrackNamesWithTrackIds([H|T],TrackNames):-
    findTrackNamesWithTrackIds(T,TrackNames2),
    track(H,Temp2,_,_,_),
    TrackNames = [Temp2|TrackNames2].


% @ @ CORRECT @ @
%  Nested List [ [] , [] ] to Single List.
nestedListToSingleList([],[]).
nestedListToSingleList([H|T],SingleList):-
    nestedListToSingleList(T,SingleList2),
    append(H,SingleList2,SingleList).


%  @ @ CORRECT @ @
% Add All Lists' Elements Inside One Nested Main List.
% For example, 1. element of 1. list and 1. element of 2. list will be added.
% Result will be Only One List.
nestedListToSingleListAndAddElements([],[]).
nestedListToSingleListAndAddElements([H|T],AverageFeatures):-
    nestedListToSingleListAndAddElements(T,AverageFeatures2),
    addTwoList(H,AverageFeatures2,AverageFeatures).



% Add Two List.
addTwoList([],[],[]).
addTwoList(H,[],ResultList):- ResultList = H.
addTwoList([H1|T1],[H2|T2],ResultList):-
    addTwoList(T1,T2,ResultList2),
    M is H1 + H2,
    ResultList = [M|ResultList2].


% Gives Length Of Any List.
listLength([], 0 ).
listLength([_|OurList], X) :- 
    listLength(OurList,N) , X is N+1 .


writeToFile(X):-
    open('writtenThing.txt', append, Stream), write(Stream,X), write(Stream,'\n'),close(Stream).


% Append Two Lists [1,2,3] + [5,6] = [1,2,3,5,6]
append([],L2,L2).
append([H|T],L2,[H|L3]) :- append(T,L2,L3).




%  Removes last element of list.
removeLastElementOfList([],[]).
removeLastElementOfList([X|Xs], Ys) :-                 
    removeLastElementOfList2(Xs, Ys, X).           

removeLastElementOfList2([], [], _).
removeLastElementOfList2([X1|Xs], [X0|Ys], X0) :-  
    removeLastElementOfList2(Xs, Ys, X1). 


% Remove First Element Of List
removeFirstElementOfList(List1,ResultList):-
    [_|ResultList] = List1.


%  Is Variable Free Or Not
isVariableFree(Var):-
    \+(\+(Var=0)),
    \+(\+(Var=1)).




% albumFeatures(+AlbumId, -AlbumFeatures) 5 points
% artistFeatures(+ArtistName, -ArtistFeatures) 5 points

% trackDistance(+TrackId1, +TrackId2, -Score) 5 points
% albumDistance(+AlbumId1, +AlbumId2, -Score) 5 points
% artistDistance(+ArtistName1, +ArtistName2, -Score) 5 points

% findMostSimilarTracks(+TrackId, -SimilarIds, -SimilarNames) 10 points
% findMostSimilarAlbums(+AlbumId, -SimilarIds, -SimilarNames) 10 points
% findMostSimilarArtists(+ArtistName, -SimilarArtists) 10 points

% filterExplicitTracks(+TrackList, -FilteredTracks) 5 points

% getTrackGenre(+TrackId, -Genres) 5 points

% discoverPlaylist(+LikedGenres, +DislikedGenres, +Features, +FileName, -Playlist) 30 points

