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
    findAllThesePair(ArtistName,TrackIds,TrackNames).

% Human and What he likes
findAllThesePair(ArtistName,TrackIds,TrackNames) :- 
    findall(TrackIds, ( track(TrackIds,_,[ArtistName|_],_,_) ), TrackIds),
    findall(TrackNames, ( track(_,TrackNames,[ArtistName|_],_,_) ), TrackNames).




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

