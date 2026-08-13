// Part of the Carbon Language project, under the Apache License v2.0 with LLVM
// Exceptions. See /LICENSE for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
// INCLUDE-FILE: toolchain/testing/testdata/min_prelude/parts/bit_and_with.carbon

// --- min_prelude/parts/destroy.carbon

package Core library "prelude/parts/destroy";

export import library "prelude/parts/bit_and_with";

interface Destroy {
  // TODO: uncomment when `require impls` adds a witness table entry.
  // require impls SubobjectDestroy;

  // TODO: change `Self` to `partial Self`.
  fn Op(ref self: Self);

  final fn SubobjectDestroy(unused ref self) = "no_op";

  final fn SelfDestruct(ref self) {
    self.Op();
    self.SubobjectDestroy();
  }
}
