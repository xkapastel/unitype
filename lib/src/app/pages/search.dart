// This file is a part of Unitype.
// Copyright (C) 2019 Matthew Blount

// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU Affero General Public License as
// published by the Free Software Foundation, either version 3 of the
// License, or (at your option) any later version.

// This program is distributed in the hope that it will be useful, but
// WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
// Affero General Public License for more details.

// You should have received a copy of the GNU Affero General Public
// License along with this program.  If not, see
// <https://www.gnu.org/licenses/.

import "package:flutter_web/material.dart";

class Search extends StatefulWidget {
  const Search();

  @override
  State<StatefulWidget> createState() {
    return _State();
  }
}

class _State extends State<Search> {
  String _query;
  TextEditingController _queryController;

  @override
  void initState() {
    super.initState();
    _queryController = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    _queryController.dispose();
  }

  void _onQueryChanged(String value) {
    setState(() {
      _query = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _queryController,
          onChanged: _onQueryChanged,
          style: TextStyle(
            color: Colors.white,
            fontSize: 24.0,
          ),
          cursorColor: Colors.white,
          autofocus: true,
        ),
      ),
      body: Center(
        child: Text("Query: ${_query}"),
      ),
    );
  }
}
