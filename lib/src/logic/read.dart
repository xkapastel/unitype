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
import "database.dart";

class Read {
  Database _db;

  Read(Database this._db);

  Program call(String source) {
    List<Program> build = [];
    List<List<Program>> stack = [];
    int index = 0;

    void skipWhile(Function predicate) {
      while (index < source.length) {
        var rune = source[index];
        if (!predicate(rune)) {
          break;
        }
        index++;
      }
    }

    bool skipUntil(Function predicate) {
      while (index < source.length) {
        var rune = source[index];
        if (predicate(rune)) {
          return true;
        }
        index++;
      }
      return false;
    }

    while (index < source.length) {
      var rune = source[index];
      if (_isLeftBracket(rune)) {
        stack.add(build);
        build = [];
        index++;
      } else if (_isRightBracket(rune)) {
        if (stack.isEmpty) {
          throw ReadError(source, index, "unbalanced brackets");
        }
        var body = build.reversed.fold(_db.id, _db.sequenceR);
        var program = _db.quote(body);
        build = stack.removeLast();
        build.add(program);
        index++;
      } else if (_isSpace(rune)) {
        skipWhile(_isSpace);
      } else if (_isQuote(rune)) {
        index++;
        var start = index;
        var match = skipUntil(_isQuote);
        if (!match) {
          throw ReadError(source, index, "unbalanced quotes");
        }
        var value = source.substring(start, index);
        var program = _db.text(value);
        build.add(program);
        index++;
      } else if (_isHash(rune)) {
        index++;
        var start = index;
        skipUntil(_isSpace);
        var value = source.substring(start, index);
        var program = _db.tag(value);
        build.add(program);
      } else if (_isDollar(rune)) {
        index++;
        var start = index;
        skipUntil(_isSpace);
        var value = source.substring(start, index);
        var program = _db.reference(value);
        build.add(program);
      } else if (_isPercent(rune)) {
        index++;
        var start = index;
        skipUntil(_isSpace);
        var value = source.substring(start, index);
        var program = _db.binary(value);
        build.add(program);
      } else if (_isAlpha(rune)) {
        var start = index;
        skipUntil(_isSeparator);
        var value = source.substring(start, index);
        var program = null;
        switch (value) {
          case "a":
            program = _db.app;
            break;
          case "b":
            program = _db.bind;
            break;
          case "c":
            program = _db.copy;
            break;
          case "d":
            program = _db.drop;
            break;
          default:
            program = _db.variable(value);
            break;
        }
        build.add(program);
      } else if (_isNumeric(rune)) {
        throw ReadError(source, index, "unimplemented");
      } else {
        throw ReadError(source, index, "unknown rune");
      }
    }
    return build.reversed.fold(_db.id, _db.sequenceR);
  }

  bool _isLeftBracket(String rune) {
    return rune == "[";
  }

  bool _isRightBracket(String rune) {
    return rune == "]";
  }

  bool _isSpace(String rune) {
    return " \t\r\n".contains(rune);
  }

  bool _isQuote(String rune) {
    return rune == "\"";
  }

  bool _isHash(String rune) {
    return rune == "#";
  }

  bool _isDollar(String rune) {
    return rune == "\$";
  }

  bool _isPercent(String rune) {
    return rune == "%";
  }

  bool _isAlpha(String rune) {
    return "abcdefghijklmnopqrstuvwxyz".contains(rune);
  }

  bool _isNumeric(String rune) {
    return "0123456789".contains(rune);
  }

  bool _isSeparator(String rune) {
    return _isSpace(rune) || _isLeftBracket(rune) || _isRightBracket(rune);
  }
}

class ReadError {
  final String source;
  final int index;
  final String message;
  ReadError(String this.source, int this.index, String this.message);

  @override
  String toString() {
    return "ReadError: ${message}\nAt position ${index}:\n${source}";
  }
}
