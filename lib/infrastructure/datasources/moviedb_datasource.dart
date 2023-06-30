



import 'package:dio/dio.dart';
import 'package:nightfilm/config/constants/environment.dart';
import 'package:nightfilm/domain/datasources/movies_datasource.dart';
import 'package:nightfilm/domain/entities/movie.dart';
import 'package:nightfilm/infrastructure/mappers/movie_mapper.dart';
import 'package:nightfilm/infrastructure/models/moviedb/moviedb_response.dart';

//!CLIENTE DE PETICIONES HTTP PARA THEMOVIEDB

class MoviedbDatasource extends MoviesDatasource{
  final dio =Dio(BaseOptions(
    baseUrl: 'https://api.themoviedb.org/3',
    queryParameters: {
      'api_key': Environment.movieDbKey,
      'language':'es'
    }
  ));


  @override
  Future<List<Movie>> getNowPlaying({int page = 1}) async {

      final response = await dio.get('/movie/now_playing');
      final movieDBResponse= MovieDbResponse.fromJson(response.data);

      final List<Movie> movies=movieDBResponse.results
      //Si no pasa esta condición no cargamos la película.
      .where((moviedb) => moviedb.posterPath != 'no-poster')
      .map(
        (moviedb) => MovieMapper.movieDBToEntity(moviedb)
        ).toList();

    
    return movies;
  }



}