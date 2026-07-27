// Part of the Carbon Language project, under the Apache License v2.0 with LLVM
// Exceptions. See /LICENSE for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception

package Core library "prelude/destroy";

// interface Destroy;
// fn SelfDestruct[T: Destroy](ref x: T);

// A toolchain-implemented interface used to destroy an object's subobjects.
//
// Types automatically implement `SubobjectDestroy` unless they:
// -   are abstract and not partial; or
// -   have a subobject that cannot be destroyed; or
// -   have explicitly opted out from being destructible.
private interface SubobjectDestroy {
  // friend fn SelfDestruct(ref x: Self);

  // TODO: make private
  fn Op(ref self);
}

final impl forall [T: type] T as SubobjectDestroy {
  fn Op(ref self) = "destroy.subobjects";
}

interface Destroy {}
final impl forall [T: type] T as Destroy {}

// Destroys a complete object, including all subobjects, and ends their
// lifetimes.
//
// The toolchain automatically calls `SelfDestruct` on all destructible objects
// at the end of the scope they were defined in. Users may manually call
// `SelfDestruct`. Users should only manually call `SelfDestruct` when explicit
// lifetime management is necessary.
//
// TODO: make unsafe
fn SelfDestruct[T: type](unused x: T) {
}

// TODO: enable once generic specializations are available
// unsafe fn SelfDestruct[T: TrivialDestroy](ref x: T) = "no_op";

// Represents types that have _dynamic destruction_.
//
// A type has dynamic destruction if it:
//
// -   is final and implements `Destroy`, or
// -   is not imported from C++ and has a virtual pointer, or
// -   is imported from C++ and has a virtual destructor.
//
// Dynamic destruction dispatches destruction to the object that is being pointed
// to. Dynamic destruction is the Carbon analogue for C++ virtual destructors.
//
// Types that have dynamic destruction automatically implement this interface.
// Users must not manually implement `DynamicDestroy`.
// interface DynamicDestroy {
  // Calls the appropriate destructor, based on the object's type.
  //
  // `DynamicDestroy.Op`'s behaviour:
  //
  // -   For final types: `DynamicDestroy.Op` calls `Destroy.Op` directly.
  // -   For types with a virtual pointer: `DynamicDestroy.Op` makes a virtual call
  //     to the `SubobjectDestroy` entry in the type's vtable.
  // final fn Op(ref self) = "destroy.dynamic";
// }
