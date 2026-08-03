// Part of the Carbon Language project, under the Apache License v2.0 with LLVM
// Exceptions. See /LICENSE for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception

// --- min_prelude/parts/destroy.carbon

package Core library "prelude/parts/destroy";

interface BitAndWith(Other: type) {
  fn Op(self, other: Other) -> Self;
}

impl type as BitAndWith(type) {
  fn Op(self, other: Self) -> Self = "type.and";
}

// A toolchain-implemented interface used to destroy an object's subobjects.
//
// Types automatically implement `SubobjectDestroy` unless they:
// -   are abstract and not partial; or
// -   have a subobject that cannot be destroyed; or
// -   have explicitly opted out from being destructible.
interface SubobjectDestroy {
  // friend fn SelfDestruct(ref x: Self);

  // TODO: make private
  fn Op(ref self);
}

// Describes how an object is destroyed for any implementing type.
//
// The toolchain implements `Destroy` by default for all types that implement
// `SubobjectDestroy`. Types that require custom clean-up must manually
// implement this interface.
interface Destroy {
  require impls SubobjectDestroy;
  // friend fn SelfDestruct(ref x: Self);

  // The operation responsible for handling object destruction. Types with a
  // default implementation for `Destroy` use a built-in operation that does no
  // work.
  //
  // TODO: make private
  fn Op(ref self: Self) = "no_op";
}

impl forall [T: type] T as Destroy {
  fn Op(ref self: Self) = "no_op";
}

// See `SelfDestruct` alias below.
interface SelfDestructible {
  // TODO: make unsafe
  fn Op(ref self);
}

final match_first {
  impl forall [T: SubobjectDestroy & Destroy] T as SelfDestructible {
    fn Op(ref self) {
      self.(Destroy.Op)();
      self.(SubobjectDestroy.Op)();
    }
  }
}

// Destroys a complete object, including all subobjects, and ends their
// lifetimes.
//
// The toolchain automatically calls `SelfDestruct` on all destructible objects
// at the end of the scope they were defined in. Users may manually call
// `SelfDestruct`. Users should only manually call `SelfDestruct` when explicit
// lifetime management is necessary.
alias SelfDestruct = SelfDestructible.Op;
