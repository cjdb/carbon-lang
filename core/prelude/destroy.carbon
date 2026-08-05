// Part of the Carbon Language project, under the Apache License v2.0 with LLVM
// Exceptions. See /LICENSE for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception

package Core library "prelude/destroy";

import library "prelude/operators/bitwise";

// A toolchain-implemented interface used to destroy an object's subobjects.
//
// Types automatically implement `SubobjectDestroy` unless they:
// -   are abstract and not partial; or
// -   have a subobject that cannot be destroyed; or
// -   have explicitly opted out from being destructible.
interface SubobjectDestroy {
  // TODO: annotate `Op` with `private`.
  // TODO: annotate `Op` with `final`.
  // TODO: implement as `"type.destroy.subobjects"`.
  fn Op(unused ref self) {}
}

interface Destroy {
  require impls SubobjectDestroy;

  // TODO: change `Self` to `partial Self`.
  fn Op(ref self: Self);
}

// TODO: make `final`.
// TODO: change `T` to `partial T` and document why.
impl forall [T: SubobjectDestroy] T as Destroy {
  // TODO: change to `alias Op = T.Op;` when `T as Destroy` becomes `partial T as Destroy`.
  fn Op(unused ref self) {}
}
