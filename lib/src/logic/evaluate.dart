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

class Evaluate implements Reduce {
  List<Program> _data;
  List<Program> _code;
  List<Program> _sink;
  List<Program> _hold;
  Program _head;
  Database _db;
  int _time;

  Evaluate(Database this._db);

  Program call(Program src) {
    _code = [src];
    _data = [];
    _sink = [];
    _hold = [];
    _time = 65535;
    while (!_complete) {
      _head = _fetch();
      try {
        _head(this);
      } on _ArityError catch (err) {
        _thunk();
      } on _TagError catch (err) {
        _thunk();
      }
      _flush();
    }
    return _state;
  }

  bool get _complete {
    return _code.isEmpty || _time == 0;
  }

  Program get _state {
    var state = _code.fold(_db.id, _db.sequenceR);
    state = _data.reversed.fold(state, _db.sequenceR);
    state = _sink.reversed.fold(state, _db.sequenceR);
    return state;
  }

  void _require(int arity) {
    if (_data.length < arity) {
      throw _ArityError(arity, _data.length);
    }
  }

  void _push(Program program) {
    _data.add(program);
  }

  Program _pop() {
    return _data.removeLast();
  }

  Quote _popQuote() {
    if (_peek is! Quote) {
      throw _TagError("quote", _db.print(_peek));
    }
    return _pop() as Quote;
  }

  Program get _peek {
    return _data.last;
  }

  void _run(Program program) {
    _hold.add(program);
  }

  Program _fetch() {
    return _code.removeLast();
  }

  void _flush() {
    if (!_hold.isEmpty) {
      _code.addAll(_hold.reversed);
      _hold.clear();
    }
  }

  void _thunk() {
    _sink.addAll(_data);
    _sink.add(_head);
    _data.clear();
  }

  void _tick() {
    _time--;
  }

  void reduceId(Id program) {
    //
  }

  void reduceApp(App program) {
    _require(2);
    var block = _popQuote();
    var value = _pop();
    _run(block.body);
    _run(value);
    _tick();
  }

  void reduceBind(Bind program) {
    _require(2);
    var block = _popQuote();
    var value = _pop();
    var body = _db.sequence(value, block.body);
    var result = _db.quote(body);
    _push(result);
    _tick();
  }

  void reduceCopy(Copy program) {
    _require(1);
    _push(_peek);
    _tick();
  }

  void reduceDrop(Drop program) {
    _require(1);
    _pop();
    _tick();
  }

  void reduceQuote(Quote program) {
    _push(program);
  }

  void reduceSequence(Sequence program) {
    _run(program.fst);
    _run(program.snd);
  }

  void reduceTag(Tag program) {
    _thunk();
  }

  void reduceReference(Reference program) {
    _thunk();
  }

  void reduceBinary(Binary program) {
    _thunk();
  }

  void reduceVariable(Variable program) {
    var binding = _db[program.value];
    if (binding == null) {
      _thunk();
    } else {
      _run(binding);
    }
  }

  void reduceText(Text program) {
    _push(program);
  }

  void reduceNumber(Number program) {
    _push(program);
  }
}

class _ArityError {
  final int expected;
  final int actual;
  _ArityError(int this.expected, int this.actual);

  @override
  String toString() {
    return "ArityError: expected ${expected} values but got ${actual}";
  }
}

class _TagError {
  final String expected;
  final String actual;
  _TagError(String this.expected, String this.actual);

  @override
  String toString() {
    return "TagError: expected a value of type `${expected}` but got `${actual}`";
  }
}
