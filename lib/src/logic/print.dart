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

class Print implements Reduce {
  StringBuffer _buf;

  Print() {
    _buf = StringBuffer();
  }

  String call(Program program) {
    _buf.clear();
    program(this);
    return _buf.toString();
  }

  void reduceId(Id program) {
    //
  }

  void reduceApp(App program) {
    _buf.write("a");
  }

  void reduceBind(Bind program) {
    _buf.write("b");
  }

  void reduceCopy(Copy program) {
    _buf.write("c");
  }

  void reduceDrop(Drop program) {
    _buf.write("d");
  }

  void reduceQuote(Quote program) {
    _buf.write("[");
    program.body(this);
    _buf.write("]");
  }

  void reduceSequence(Sequence program) {
    program.fst(this);
    _buf.write(" ");
    program.snd(this);
  }

  void reduceTag(Tag program) {
    _buf.write("#${program.value}");
  }

  void reduceReference(Reference program) {
    _buf.write("\$${program.value}");
  }

  void reduceBinary(Binary program) {
    _buf.write("%${program.value}");
  }

  void reduceVariable(Variable program) {
    _buf.write(program.value);
  }

  void reduceText(Text program) {
    _buf.write('"${program.value}"');
  }

  void reduceNumber(Number program) {
    _buf.write("${program.value}");
  }
}
