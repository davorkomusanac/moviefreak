import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../application/movies/movie_search/movie_search_cubit.dart';
import '../../../application/movies/popular_movies/popular_movies_cubit.dart';
import '../../utilities/utilities.dart';
import 'widgets/movie_search_results_list_view.dart';
import 'widgets/popular_movies_grid_view.dart';

class DiscoverPage extends StatefulWidget {
  const DiscoverPage({Key? key}) : super(key: key);

  @override
  State<DiscoverPage> createState() => _DiscoverPageState();
}

class _DiscoverPageState extends State<DiscoverPage> with TickerProviderStateMixin {
  late final TextEditingController _searchController;
  final _debouncer = Debouncer(milliseconds: 500);

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    context.read<PopularMoviesCubit>().popularMoviesCalled();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: TextField(
                  controller: _searchController,
                  decoration: const InputDecoration(
                    hintText: 'Type to search a movie..',
                    suffixIcon: Icon(
                      Icons.search,
                      size: 20,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.blue,
                        width: 1.5,
                      ),
                      borderRadius: BorderRadius.all(
                        Radius.circular(15.0),
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.grey,
                        width: 1.5,
                      ),
                      borderRadius: BorderRadius.all(
                        Radius.circular(15.0),
                      ),
                    ),
                  ),
                  onChanged: (value) {
                    _debouncer.run(() {
                      context.read<MovieSearchCubit>().searchTitleChanged(
                            title: _searchController.text.trim(),
                          );
                    });
                  },
                ),
              ),
              Expanded(
                child: BlocBuilder<MovieSearchCubit, MovieSearchState>(
                  builder: (context, state) =>
                      state.searchTitle.isEmpty ? const PopularMoviesGridView() : const MovieSearchResultsListView(),
                ),
              ),
            ],
          ),
        ),
      );
}
