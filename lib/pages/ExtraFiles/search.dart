import 'package:flutter/material.dart';

import '../SongPages/SongPlay.dart';

// search page

class CustomSearchDelegate extends SearchDelegate {
  var searchTermsList;
  var dict;
  CustomSearchDelegate({this.searchTermsList, this.dict});

  // first overwrite to
  // clear the search text
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          query = '';
        },
        icon: Icon(Icons.clear),
      ),
    ];
  }

  // second overwrite to pop out of search menu
  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        close(context, null);
      },
      icon: Icon(Icons.arrow_back),
    );
  }

  // third overwrite to show query result
  @override
  Widget buildResults(BuildContext context) {

    var seen = Set<String>();
    List<dynamic> searchTerms = searchTermsList.where((country) => seen.add(country)).toList();

    List<String> matchQuery = [];
    for (var song in searchTerms) {
      if (song.toLowerCase().contains(query.toLowerCase())) {
        matchQuery.add(song);
      }
    }

    if(matchQuery.length == 0){
      return Center(
        child: Image.network(
            'https://tse1.mm.bing.net/th?id=OIP.w8YMeMXz_tZ3LUh06MB5UQHaHa&pid=Api&P=0',
          height: 300,
          width: 300,
        ),
      );
    }

    return ListView.builder(
      itemCount: matchQuery.length,
      itemBuilder: (context, index) {
        var result = matchQuery[index];
        return GestureDetector(
          child: ListTile(
            leading: Container(
              height: 80,
              width: 80,
              decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.circular(10),
                image: DecorationImage(
                    image: NetworkImage('${dict[result]['image']}'),
                    fit: BoxFit.cover
                ),
              ),
            ),
            title: Text(result),
            subtitle: Text('${dict[result]['singer']}'),
          ),
          onTap: (){
            Navigator.push(context, new MaterialPageRoute(
                builder: (context) => new SongPlayPage(
                  id: '${dict[result]['id']}',
                  name: '${dict[result]}',
                  singer: '${dict[result]['singer']}',
                  image: '${dict[result]['image']}',
                  isFav: dict[result]['isFav'],
                ))
            );
          },
        );
      },
    );
  }

  // last overwrite to show the
  // querying process at the runtime
  @override
  Widget buildSuggestions(BuildContext context) {

    var seen = Set<String>();
    List<dynamic> searchTerms = searchTermsList.where((country) => seen.add(country)).toList();

    List<String> matchQuery = [];
    for (var song in searchTerms) {
      if (song.toLowerCase().contains(query.toLowerCase())) {
        matchQuery.add(song);
      }
    }

    if(matchQuery.length == 0){
      return Center(
        child: Image.network(
          'https://tse1.mm.bing.net/th?id=OIP.w8YMeMXz_tZ3LUh06MB5UQHaHa&pid=Api&P=0',
          height: 300,
          width: 300,
        ),
      );
    }

    return ListView.builder(
      itemCount: matchQuery.length,
      itemBuilder: (context, index) {
        var result = matchQuery[index];
        return GestureDetector(
          child: ListTile(
            leading: Container(
              height: 80,
              width: 80,
              decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.circular(10),
                image: DecorationImage(
                    image: NetworkImage('${dict[result]['image']}'),
                    fit: BoxFit.cover
                ),
              ),
            ),
            title: Text(result),
            subtitle: Text('${dict[result]['singer']}'),
          ),
          onTap: (){
            print('----------------${dict}');
            Navigator.push(context, new MaterialPageRoute(
                builder: (context) => new SongPlayPage(
                  id: dict[result]['id'],
                  name: '${result}',
                  singer: '${dict[result]['singer']}',
                  image: '${dict[result]['image']}',
                  isFav: dict[result]['isFav'],
                ))
            );
          },
        );
      },
    );
  }
}