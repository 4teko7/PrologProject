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



% @@@@@   @@@@@   @@@@@   @@@@@   @@@@@  filterExplicitTracks(+TrackList, -FilteredTracks) 5 points   @@@@@   @@@@@   @@@@@   @@@@@    @@@@@   @@@@@   @@@@@

% COMPLETED
filterExplicitTracks(TrackList, FilteredTracks):-
    findExplicitTracksWithTrackIdsList(TrackList,FilteredTracks).


% @@@@@   @@@@@   @@@@@   @@@@@   @@@@@  getTrackGenre(+TrackId, -Genres) 5 points   @@@@@   @@@@@   @@@@@   @@@@@    @@@@@   @@@@@   @@@@@

% COMPLETED
getTrackGenre(TrackId, Genres) :-
    track(TrackId,_,ArtistNames,_,_),
    findArtistGenresWithArtistNames(ArtistNames,Genres).

% @@@@@   @@@@@   @@@@@   @@@@@   @@@@@  discoverPlaylist(+LikedGenres, +DislikedGenres, +Features, +FileName, -Playlist) 30 points   @@@@@   @@@@@   @@@@@   @@@@@    @@@@@   @@@@@   @@@@@

% COMPLETED
discoverPlaylist(LikedGenres, DislikedGenres, Features, FileName, Playlist):-
    findall(AllArtistNames,(artist(AllArtistNames,AllGenres,_),\+ isEmpty(AllGenres)),AllArtistNames),
    findall(AllGenres,(artist(_,AllGenres,_),\+ isEmpty(AllGenres)),AllGenres),
    collectArtistNamesFromWantedGenreList(AllGenres,AllArtistNames,LikedGenres,DislikedGenres,WantedArtistNames),
    findAllTrackIdsWithArtistNames(WantedArtistNames,AllTrackIds,ArtistNamesList),
    findAllFeaturesWithTrackIdListNotNested(AllTrackIds,AllTrackFeatures), % Features Filtered in this function
    findDistanceOfAllFeaturesFromSpecificFeature(Features,AllTrackFeatures,AllTrackIds,ArtistNamesList,Score),
    sortAscending(Score,SortedScore),
    getFirstNElementsOfList3(30,SortedScore,Distance,SimilarIds,SimilarNames,ArtistNames),
    Playlist = SimilarIds,
    writeToSpecificFile(FileName,SimilarIds),
    writeToSpecificFile(FileName,SimilarNames),
    writeToSpecificFile(FileName,ArtistNames),
    writeToSpecificFile(FileName,Distance),!.







% @ @ CORRECT @ @
findDistanceOfAllTracksFromSpecificTrack(SpecificTrackId,[],[],[]).
findDistanceOfAllTracksFromSpecificTrack(SpecificTrackId,[H1|T1],[H2|T2],Score):-
    findDistanceOfAllTracksFromSpecificTrack(SpecificTrackId,T1,T2,Score2),
    trackDistance(SpecificTrackId,H1,Distance),
    Score = [[Distance,H1,H2]|Score2].

% @ @ CORRECT @ @
findDistanceOfAllAlbumsFromSpecificAlbum(SpecificAlbumId,[],[],[]).
findDistanceOfAllAlbumsFromSpecificAlbum(SpecificAlbumId,[H1|T1],[H2|T2],Score):-
    findDistanceOfAllAlbumsFromSpecificAlbum(SpecificAlbumId,T1,T2,Score2),
    albumDistance(SpecificAlbumId,H1,Distance),
    Score = [[Distance,H1,H2]|Score2].

% @ @ CORRECT @ @
findDistanceOfAllArtistsFromSpecificArtist(SpecificArtistName,[],[]).
findDistanceOfAllArtistsFromSpecificArtist(SpecificArtistName,[H1|T1],Score):-
    findDistanceOfAllArtistsFromSpecificArtist(SpecificArtistName,T1,Score2),
    artistDistance(SpecificArtistName,H1,Distance),
    Score = [[Distance,H1]|Score2].



% @ @ CORRECT @ @
% Returns First N elements (3 Elements inside each list) from NESTED LIST : [ [] [] ]
getFirstNElementsOfList3(0,_,[],[],[],[]):- !.
getFirstNElementsOfList3(_,[],[],[],[],[]).
getFirstNElementsOfList3(N,[H|T],Distance,SimilarIds,SimilarNames,ArtistNames):-
    N1 is N - 1,
    getFirstNElementsOfList3(N1,T,Distance2,SimilarIds2,SimilarNames2,ArtistNames2),
    [D|[L|[R|[A]]]] = H, %[1 , 2 , 3]
    append([D],Distance2,Distance),
    append([L],SimilarIds2,SimilarIds),
    append([R],SimilarNames2,SimilarNames),
    append([A],ArtistNames2,ArtistNames).
    % writeToFile("Distance : " + Distance + "SimilarIds : " + SimilarIds + " SimilarNames : " + SimilarNames + " ArtistNames : " + ArtistNames).



% @ @ CORRECT @ @
% Returns First N elements (3 Elements inside each list) from NESTED LIST : [ [] [] ]
getFirstNElementsOfList(0,_,_,[]):- !.
getFirstNElementsOfList(_,[],[],[]).
getFirstNElementsOfList(N,[H|T],SimilarIds,SimilarNames):-
    N1 is N - 1,
    getFirstNElementsOfList(N1,T,SimilarIds2,SimilarNames2),
    [_|[L|[R]]] = H, %[1 , 2 , 3]
    append([L],SimilarIds2,SimilarIds),
    append([R],SimilarNames2,SimilarNames).
    

% @ @ CORRECT @ @
% Returns First N elements(2 Elements inside each list) from NESTED LIST : [ [] [] ]
getFirstNElementsOfList2(0,_,[]):- !.
getFirstNElementsOfList2(_,[],[]).
getFirstNElementsOfList2(N,[H|T],SimilarNames):-
    N1 is N - 1,
    getFirstNElementsOfList2(N1,T,SimilarNames2),
    [_|L] = H, %[1 , 2]
    append(L,SimilarNames2,SimilarNames).

% @ @ CORRECT @ @
% Sort List 
sortAscending(List, Sorted):-
    sort(0,  @=<, List,  Sorted).

% ########  Distance Between Two Features ######################

% @ @ CORRECT @ @
distanceBetweenTwoFeature(Track1Feature,Track2Feature,Score):-
    differenceSquareThenSumOfElementsOfList(Track1Feature,Track2Feature,SummedDifScore),
    Score is SummedDifScore ** 0.5.


% @ @ CORRECT @ @
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


% @ @ CORRECT @ @
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
    TrackIds = [TempTrackIds|TrackIds2].



% @ @ CORRECT @ @
% Takes Lists like this : [[1,1,1],[2,2,2],[3,3,3]] and returns nested list : [ [1,2,3] , [1,2,3] ]
findAllTrackFeaturesWithTrackIds([],[]).
findAllTrackFeaturesWithTrackIds([H|T],Features):-
    findAllTrackFeaturesWithTrackIds(T,Features2),
    findFeatureListWithTrackIdsList(H,Temp2),
    nestedListToSingleListAndAddElements(Temp2,Temp3),
    Features = [Temp3|Features2].




% @ @ CORRECT @ @
% Finds Feature List from Track Id List
findFeatureListWithTrackIdsList([],[]).
findFeatureListWithTrackIdsList([H|T],AlbumFeatures):-
    findFeatureListWithTrackIdsList(T,AlbumFeatures2),
    track(H,_,_,_,TempTrackFeature),
    filter_features(TempTrackFeature,FilteredTempTrackFeature),
    AlbumFeatures = [FilteredTempTrackFeature|AlbumFeatures2].



% @ @ CORRECT @ @
% Find Explicit Tracks With Track Ids = [1,2,3,4]
findExplicitTracksWithTrackIdsList([],[]).
findExplicitTracksWithTrackIdsList([H|T],ExplicitTracks):-
    findExplicitTracksWithTrackIdsList(T,ExplicitTracks2),
    track(H,_,_,_,TempExplicitTracks),
    [IsExplicit|_] = TempExplicitTracks,
    
    
    (
        (IsExplicit =:= 0, ExplicitTracks = [H|ExplicitTracks2]) ;
        (IsExplicit =:= 1, ExplicitTracks = ExplicitTracks2)
    ).
    


% @ @ CORRECT @ @
% Finds ArtistGenres List = (Not Nested List) from ArtistNames List = (Not Nested)
findArtistGenresWithArtistNames([],[]).
findArtistGenresWithArtistNames([H|T],ArtistGenres):-
    findArtistGenresWithArtistNames(T,ArtistGenres2),
    artist(H,TempArtistGenres,_),
    append(TempArtistGenres,ArtistGenres2,ArtistGenres).

% @ @ CORRECT @ @
splitNestedStringsListWithACharacter([],Character,[]).
splitNestedStringsListWithACharacter([H|T],Character,SplittedNestedGenresList):-
    splitNestedStringsListWithACharacter(T,Character,SplittedNestedGenresList2),
    splitStringList(H,Character,TempSplittedNestedGenresList),
    SplittedNestedGenresList = [TempSplittedNestedGenresList | SplittedNestedGenresList2].




% @ @ CORRECT @ @
% Obtain All Artist Names Whose genre List contains liked genres but not disliked genres
collectArtistNamesFromWantedGenreList([],[],LikedGenres,DislikedGenres,[]).
collectArtistNamesFromWantedGenreList([H1|T1],[H2|T2],LikedGenres,DislikedGenres,WantedArtistNames):-
    collectArtistNamesFromWantedGenreList(T1,T2,LikedGenres,DislikedGenres,WantedArtistNames2),
    lookStringListForContainingDislikedOrLikedGenres(H1,DislikedGenres,IsFound1),
    lookStringListForContainingDislikedOrLikedGenres(H1,LikedGenres,IsFound2),
    (
        (isEmpty(IsFound1), (\+ isEmpty(IsFound2)) , WantedArtistNames = [H2 | WantedArtistNames2]);    
        (WantedArtistNames = WantedArtistNames2)    
    ).


% @ @ CORRECT @ @
% Makes Genre List A Single String and Sends To the Other Predicate to Check
% Whether there is a substring of disliked or liked string in the genre string.
lookStringListForContainingDislikedOrLikedGenres([],LikedGenres,[]).
lookStringListForContainingDislikedOrLikedGenres([H|T],LikedGenres,IsFound):-
    lookStringListForContainingDislikedOrLikedGenres(T,LikedGenres,IsFound2),
    lookStringForContainingDislikedOrLikedGenreList(H,LikedGenres,Temp),
    
    (
        ( (\+ isEmpty(Temp)) , IsFound = [Temp|IsFound2]);
        (IsFound = IsFound2)    
        
    ).
    % writeToFile("IsFound : " + IsFound).
    


% @ @ CORRECT @ @
% Checks Whether there is a substring of the disliked or liked string in the genre string
lookStringForContainingDislikedOrLikedGenreList(StringGenre,[],[]).
lookStringForContainingDislikedOrLikedGenreList(StringGenre,[H|T],Temp):-
    lookStringForContainingDislikedOrLikedGenreList(StringGenre,T,Temp2),
    (
    (isSubstring(StringGenre,H), Temp = [H|Temp2]);
    (Temp = Temp2)
    ).




findAllTrackIdsWithArtistNames([],[],[]).
findAllTrackIdsWithArtistNames([H|T],TrackIds,ArtistNamesList):-
    findAllTrackIdsWithArtistNames(T,TrackIds2,ArtistNamesList2),
    getArtistTracks(H,TempTrackIds,_),
    listLength(TempTrackIds,N),
    addNTimesToList(N,H,ArtistNamesListTemp),
    append(ArtistNamesListTemp,ArtistNamesList2,ArtistNamesList),
    % TrackIds = [TempTrackIds|TrackIds2]
    append(TempTrackIds,TrackIds2,TrackIds).



findDistanceOfAllFeaturesFromSpecificFeature(SpecificFeatures,[],[],[],[]).
findDistanceOfAllFeaturesFromSpecificFeature(SpecificFeatures,[H1|T1],[H2|T2],[H3|T3],Score):-
    findDistanceOfAllFeaturesFromSpecificFeature(SpecificFeatures,T1,T2,T3,Score2),
    distanceBetweenTwoFeature(SpecificFeatures,H1,Distance),
    track(H2,TrackName,_,_,_),
    Score = [[Distance,H2,TrackName,[H3]]|Score2].


findAllFeaturesWithTrackIdListNotNested([],[]).
findAllFeaturesWithTrackIdListNotNested([H|T],AllTrackFeatures):-
    findAllFeaturesWithTrackIdListNotNested(T,AllTrackFeatures2),
    track(H,_,_,_,TempAllTrackFeatures2),
    filter_features(TempAllTrackFeatures2,FilteredTempAllTrackFeatures2),
    AllTrackFeatures = [FilteredTempAllTrackFeatures2|AllTrackFeatures2].



% addNTimesToList(0,_):- !.
addNTimesToList(0,ArtistName,[]).
addNTimesToList(N,ArtistName,List):-
    N1 is N - 1,
    addNTimesToList(N1,ArtistName,List2),
    List = [ArtistName|List2].



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


% @ @ CORRECT @ @
% Add Two List.
addTwoList([],[],[]).
addTwoList(H,[],ResultList):- ResultList = H.
addTwoList([H1|T1],[H2|T2],ResultList):-
    addTwoList(T1,T2,ResultList2),
    M is H1 + H2,
    ResultList = [M|ResultList2].


% @ @ CORRECT @ @
% Gives Length Of Any List.
listLength([], 0 ).
listLength([_|OurList], X) :- 
    listLength(OurList,N) , X is N+1 .


% @ @ CORRECT @ @
writeToFile(X):-
    open('writtenThing.txt', append, Stream), write(Stream,X), write(Stream,'\n'),close(Stream).


writeToSpecificFile(FileName,Parameter):-
    open(FileName, append, Stream), write(Stream,Parameter), write(Stream,'\n'),close(Stream).


% @ @ CORRECT @ @
% Append Two Lists [1,2,3] + [5,6] = [1,2,3,5,6]
append([],L2,L2).
append([H|T],L2,[H|L3]) :- append(T,L2,L3).



% @ @ CORRECT @ @
%  Removes last element of list.
removeLastElementOfList([],[]).
removeLastElementOfList([X|Xs], Ys) :-                 
    removeLastElementOfList2(Xs, Ys, X).           

% @ @ CORRECT @ @
removeLastElementOfList2([], [], _).
removeLastElementOfList2([X1|Xs], [X0|Ys], X0) :-  
    removeLastElementOfList2(Xs, Ys, X1). 

% @ @ CORRECT @ @
% Remove First Element Of List
removeFirstElementOfList(List1,ResultList):-
    [_|ResultList] = List1.

% @ @ CORRECT @ @
%  Is Variable Free Or Not
isVariableFree(Var):-
    \+(\+(Var=0)),
    \+(\+(Var=1)).


% Split String With a Given Character and returns a list : ["a","b","c"]
splitString(String,Char,List):-
    split_string(String,Char,Char,TempList),
    List = [String | TempList].

% Split String With a Given Character and returns a list : ["a","b","c"]
splitStringList([],Char,[]).
splitStringList([H|T],Char,SplittedStringList):-
    splitStringList(T,Char,SplittedStringList2),
    splitString(H,Char,TempSplittedStringList2),
    append(TempSplittedStringList2,SplittedStringList2,SplittedStringList).


isSubstring(String,Substring) :-
    sub_string(String,_,_,_,Substring),!.



% Check If List Empty
isEmpty(List):- not(member(_,List)).

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

