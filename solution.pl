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


:- [ tracks,
     artists,
     albums
   ].





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


% getArtistTracks(+ArtistName, -TrackIds, -TrackNames) 5 points
getArtistTracks(ArtistName, TrackIds, TrackNames) :-
    artist(ArtistName,_,AlbumIds),
    getAlbumTrackIds(AlbumIds,TrackIds,TrackNames),
    getTrackTrackName(TrackIds,TrackNames).


getAlbumTrackIds([],[],_).
getAlbumTrackIds([H|T],TrackIds,TrackNames) :-
    getAlbumTrackIds(T,TrackIds2,TrackNames),
    album(H,_,_,M),
    append(M,TrackIds2,TrackIds).




% Append Two Lists [1,2,3] + [5,6] = [1,2,3,5,6]
append([],L2,L2).
append([H|T],L2,[H|L3]) :- append(T,L2,L3).



% Gets TrackName From TrackIds = [1,2,3,4]
getTrackTrackName([],[]).
getTrackTrackName([H|T],TrackNames) :-
    getTrackTrackName(T,TrackNames2),
    catch(track(H,M,_,_,_), X, (write('error from p'), nl)),
    TrackNames = [M|TrackNames2].



    
% loop([],[]).
% loop([H|T],TrackNames) :-
%     loop(T,TrackNames2),
%     track(_,M,_,_,_),
%     TrackNames = [M|TrackNames2].
        











% getAlbumTracks(AlbumName,TrackIds,TrackNames) :-
%     album(AlbumName,_,_,TrackIds2),
%     TrackIds = [TrackIds|TrackIds2].





% getArtistTracks(+ArtistName, -TrackIds, -TrackNames) 5 points
% getArtistTracks(ArtistName, TrackIds, TrackNames) :-
%     track(TrackIds,TrackNames,ArtistName,_,_).
















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