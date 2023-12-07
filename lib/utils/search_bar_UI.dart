import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// ignore: must_be_immutable
class SearchBarUI extends StatefulWidget {
  Function filterSearchResults;
  String hintText;

  SearchBarUI(
      {super.key, required this.filterSearchResults, required this.hintText});

  @override
  State<SearchBarUI> createState() => _SearchBarUIViewState();
}

TextEditingController _searchController = TextEditingController();

// function to filter
class _SearchBarUIViewState extends State<SearchBarUI> {
  // UI Search bar
  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _searchController,
      onChanged: (value) {
        widget.filterSearchResults(value);
      },
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.search),
        suffixIcon: _searchController.text.isNotEmpty
            ? IconButton(
                onPressed: () {
                  _searchController.clear();
                  widget.filterSearchResults('');
                },
                icon: const Icon(Icons.clear),
              )
            : null,
        hintText: widget.hintText,
      ),
    );
  }
}
