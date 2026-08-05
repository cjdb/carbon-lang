// Part of the Carbon Language project, under the Apache License v2.0 with LLVM
// Exceptions. See /LICENSE for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
// INCLUDE-FILE: toolchain/testing/testdata/min_prelude/parts/as.carbon

// --- min_prelude/parts/bit_and_with.carbon

package Core library "prelude/parts/bit_and_with";

interface BitAndWith(Other: type) {
  fn Op(self, other: Other) -> Self;
}

impl type as BitAndWith(type) {
  fn Op(self, other: Self) -> Self = "type.and";
}