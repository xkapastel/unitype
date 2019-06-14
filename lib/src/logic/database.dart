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

import "program.dart";
import "read.dart";
import "evaluate.dart";
import "print.dart";

/// A database normalizes programs, and manages definitions.
class Database {
  Map<String, Program> _data;
  Read _read;
  Evaluate _evaluate;
  Print _print;

  Database() {
    _data = Map();
    _read = Read();
    _evaluate = Evaluate();
    _print = Print();
  }

  String call(String src) {
    return _print(_evaluate(_read(src)));
  }

  String operator [](String key) {
    var program = _data[key];
    return _print(program);
  }

  void operator []=(String key, String value) {
    var program = _read(value);
    _data[key] = program;
  }

  void remove(String key) {
    _data.remove(key);
  }
}
