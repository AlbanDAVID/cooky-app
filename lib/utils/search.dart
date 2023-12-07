import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// ignore: must_be_immutable
class SearchListView extends StatefulWidget {
  late List filteredList;
  late List listToFilter;
  SearchListView(
      {super.key, required this.filteredList, required this.listToFilter});

  @override
  State<SearchListView> createState() => _SearchListViewState();
}

class _SearchListViewState extends State<SearchListView> {
  // function to search
  void filterSearchResults(String query, filteredList, listToFilter) {
    // get a list searchFiltred of the filtred search
    setState(() {
      filteredList = listToFilter.where((item) {
        final itemLowerCase = item.toLowerCase(); // to lower case each items
        final input = query
            .toLowerCase(); // to lower case the input (what are typed by the user)
        return itemLowerCase
            .contains(input); // check the match between intem and input
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SearchBar(
      onChanged: (value) {
        filterSearchResults(value, widget.filteredList, widget.listToFilter);
      },
      leading: const Icon(Icons.search),
      constraints: const BoxConstraints(
          minWidth: 200.0, maxWidth: 350.0, minHeight: 30.0),
      elevation: MaterialStateProperty.all(0),
      backgroundColor:
          MaterialStateProperty.all(const Color.fromRGBO(240, 232, 252, 1)),
      shape: MaterialStateProperty.all(const ContinuousRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(20)),
      )),
      hintText: AppLocalizations.of(context)!.searchTag,
      hintStyle: MaterialStateProperty.all(const TextStyle(color: Colors.grey)),
    );
  }
}
