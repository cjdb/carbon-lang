// Part of the Carbon Language project, under the Apache License v2.0 with LLVM
// Exceptions. See /LICENSE for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
// INCLUDE-FILE: toolchain/testing/testdata/min_prelude/parts/bit_and_with.carbon

// --- min_prelude/parts/destroy.carbon

package Core library "prelude/parts/destroy";

export import library "prelude/parts/bit_and_with";

interface SubobjectDestroy {
  // TODO: annotate `Op` with `private`.
  // TODO: annotate `Op` with `final`.
  // TODO: implement as `"type.destroy.subobjects"`.
  fn Op(ref self);
}

interface Destroy {
  // TODO: uncomment when `require impls` adds a witness table entry.
  // require impls SubobjectDestroy;

  // TODO: change `Self` to `partial Self`.
  fn Op(ref self: Self);

  // TODO: remove when `require impls` adds a witness table entry.
  fn CallSubobjectDestroyOp(ref self);
}

// TODO: make `final`.
// TODO: change `T` to `partial T` and document why.
impl forall [T: SubobjectDestroy] T as Destroy {
  // TODO: change to `alias Op = T.Op;` when `T as Destroy` becomes `partial T as Destroy`.
  fn Op(unused ref self) {}

  // TODO: remove when `require impls` adds a witness table entry.
  fn CallSubobjectDestroyOp(ref self) {
    self.(SubobjectDestroy.Op)();
  }
}

// TODO: make private
interface SelfDestructible {
  // TODO: uncomment when `require impls` adds a witness table entry.
  // require impls Destroy;

  // TODO: annotate with `private`.
  // TODO: annotate with `unsafe`.
  fn Op(ref self: Self);
}

impl forall [T: Destroy] T as SelfDestructible {
  fn Op(ref self) {
    self.(Destroy.Op)();

    // TODO: replace with `self.(SubobjectDestroy.Op)()` when `require impls` adds a witness table entry.
    self.(Destroy.CallSubobjectDestroyOp)();
  }
}

alias SelfDestruct = SelfDestructible.Op;