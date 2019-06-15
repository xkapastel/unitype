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
  Program _kId;
  Program _kApp;
  Program _kBind;
  Program _kCopy;
  Program _kDrop;

  Database() {
    _data = Map();
    _read = Read(this);
    _evaluate = Evaluate(this);
    _print = Print();
    _kId = Id();
    _kApp = App();
    _kBind = Bind();
    _kCopy = Copy();
    _kDrop = Drop();
  }

  Program get id => _kId;
  Program get app => _kApp;
  Program get bind => _kBind;
  Program get copy => _kCopy;
  Program get drop => _kDrop;

  Program quote(Program body) {
    return Quote(body);
  }

  Program sequence(Program fst, Program snd) {
    if (snd is Id) {
      return fst;
    }
    if (fst is Id) {
      return snd;
    }
    if (fst is Sequence) {
      var inner = sequence(fst.snd, snd);
      return sequence(fst.fst, inner);
    }
    return Sequence(fst, snd);
  }

  Program sequenceR(Program fst, Program snd) {
    return sequence(snd, fst);
  }

  Program tag(String value) {
    return Tag(value);
  }

  Program reference(String value) {
    return Reference(value);
  }

  Program variable(String value) {
    return Variable(value);
  }

  Program binary(String value) {
    return Binary(value);
  }

  Program text(String value) {
    return Text(value);
  }

  Program number(int value) {
    return Number(value);
  }

  Program read(String src) {
    return _read(src);
  }

  String print(Program program) {
    return _print(program);
  }

  Program evaluate(Program src) {
    return _evaluate(src);
  }

  Program operator [](String key) {
    return _data[key];
  }

  void operator []=(String key, Program value) {
    _data[key] = value;
  }

  void remove(String key) {
    _data.remove(key);
  }
}
