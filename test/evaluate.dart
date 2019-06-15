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

import "package:test/test.dart";
import "package:unitype/logic.dart" as logic;

void main() {
  var db = logic.Database();
  var src = {
    "[foo] [bar] a": "bar [foo]",
    "[foo] [bar] b": "[[foo] bar]",
    "[foo] [bar] c": "[foo] [bar] [bar]",
    "[foo] [bar] d": "[foo]",
  };
  for (var entry in src.entries) {
    var program = db.read(entry.key);
    var expected = entry.value;
    var residual = db.evaluate(program);
    var actual = db.print(residual);
    test("${program} = ${expected}", () {
      expect(actual, equals(expected));
    });
  }
}
