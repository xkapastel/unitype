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

/// A Unitype program. Executing a Unitype program is called "normalization",
/// and the result is another, hopefully simpler program.
abstract class Program {
  bool get isObject => false;
  void call(Reduce client);
}

abstract class Reduce {
  void reduceId(Id code);
  void reduceApp(App code);
  void reduceBind(Bind code);
  void reduceCopy(Copy code);
  void reduceDrop(Drop code);
  void reduceQuote(Quote code);
  void reduceSequence(Sequence code);
  void reduceTag(Tag code);
  void reduceText(Text code);
  void reduceNumber(Number code);
  void reduceBinary(Binary code);
  void reduceVariable(Variable code);
  void reduceReference(Reference code);
}

class Id extends Program {
  void call(Reduce client) {
    client.reduceId(this);
  }
}

class App extends Program {
  void call(Reduce client) {
    client.reduceApp(this);
  }
}

class Bind extends Program {
  void call(Reduce client) {
    client.reduceBind(this);
  }
}

class Copy extends Program {
  void call(Reduce client) {
    client.reduceCopy(this);
  }
}

class Drop extends Program {
  void call(Reduce client) {
    client.reduceDrop(this);
  }
}

class Quote extends Program {
  final Program body;
  Quote(Program this.body);

  @override
  bool get isObject => true;

  void call(Reduce client) {
    client.reduceQuote(this);
  }
}

class Sequence extends Program {
  final Program fst;
  final Program snd;
  Sequence(Program this.fst, Program this.snd);

  void call(Reduce client) {
    client.reduceSequence(this);
  }
}

class Tag extends Program {
  final String value;
  Tag(String this.value);

  void call(Reduce client) {
    client.reduceTag(this);
  }
}

class Text extends Program {
  final String value;
  Text(String this.value);

  @override
  bool get isObject => true;

  void call(Reduce client) {
    client.reduceText(this);
  }
}

class Number extends Program {
  final int value;
  Number(int this.value);

  @override
  bool get isObject => true;

  void call(Reduce client) {
    client.reduceNumber(this);
  }
}

class Binary extends Program {
  final String value;
  Binary(String this.value);

  @override
  bool get isObject => true;

  void call(Reduce client) {
    client.reduceBinary(this);
  }
}

class Variable extends Program {
  final String value;
  Variable(String this.value);

  void call(Reduce client) {
    client.reduceVariable(this);
  }
}

class Reference extends Program {
  final String value;
  Reference(String this.value);

  void call(Reduce client) {
    client.reduceReference(this);
  }
}
