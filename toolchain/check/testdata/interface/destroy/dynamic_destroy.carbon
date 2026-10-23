// Part of the Carbon Language project, under the Apache License v2.0 with LLVM
// Exceptions. See /LICENSE for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
// INCLUDE-FILE: toolchain/testing/testdata/min_prelude/full.carbon
//
// AUTOUPDATE
// TIP: To test this file alone, run:
// TIP:   bazel test //toolchain/testing:file_test --test_arg=--file_tests=toolchain/check/testdata/interface/destroy/dynamic_destroy.carbon
// TIP: To dump output, run:
// TIP:   bazel run //toolchain/testing:file_test -- --dump_output --file_tests=toolchain/check/testdata/interface/destroy/dynamic_destroy.carbon


// A type has _dynamic destruction_ if it:
// 
// -   is final and implements `Core.Destroy`, or
// -   is not imported from C++ and has a virtual pointer, or
// -   is imported from C++ and has a virtual destructor.

// --- check_dynamic_destroy.carbon

fn CheckHasDestruction[T: Core.Destroy](_: T) {}
fn CheckHasDynamicDestruction[T: Core.DynamicDestroy](_: T) {}

// --- types.h

using Long = long;
using FunctionPointer = void (*)();

struct TrivialDestructor {};

struct FinalTrivialDestructor final {};

struct NonTrivialDestructor {
  ~NonTrivialDestructor();
};

struct FinalNonTrivialDestructor final {
  ~FinalNonTrivialDestructor();
};

struct VirtualDestructor {
  virtual ~VirtualDestructor();
};

struct DefaultedVirtualDestructor {
  virtual ~DefaultedVirtualDestructor() = default;
};

// The destructor is implicitly virtual, because the base's is virtual.
struct DerivedFromVirtualDestructor : VirtualDestructor {};

// Has a virtual pointer, but the destructor isn't virtual.
struct VirtualFunction {
  virtual void F();
};

struct FinalVirtualFunction final {
  virtual void F();
};

struct DeletedDestructor {
  ~DeletedDestructor() = delete;
};

struct FinalDeletedDestructor final {
  ~FinalDeletedDestructor() = delete;
};

struct DeletedVirtualDestructor {
  virtual ~DeletedVirtualDestructor() = delete;
};

template <typename T>
struct Holder {
  T t;
};

template <typename T>
struct FinalHolder final {
  T t;
};

// --- types.carbon

library "[[@TEST_NAME]]";

import Cpp library "types.h";

// Types used by the splits below.

class C {
  fn Get(self) -> i32;
}

class EmptyClass {}

class TrivialFields {
  var a: i32;
  var b: bool;
}

// Has non-trivial destruction because of its own `DestroyImpl.Op`.
class NonTrivial {
  impl as Core.DestroyImpl {
    fn Op(unused self) {}
  }
}

base class TrivialBase {}

// Has non-trivial destruction because of its own `DestroyImpl.Op`.
base class NonTrivialBase {
  impl as Core.DestroyImpl {
    fn Op(unused self) {}
  }
}

class DerivedFromTrivialBase {
  extend base: TrivialBase;
}

base class BaseDerivedFromTrivialBase {
  extend base: TrivialBase;
}

base class VirtualFunction {
  virtual fn F(self);
}

class DerivedFromVirtualFunction {
  extend base: VirtualFunction;
}

// Has a virtual pointer because its base class does.
base class BaseDerivedFromVirtualFunction {
  extend base: VirtualFunction;
}

// Has a virtual pointer, but can't be destroyed because of its field.
base class VirtualFunctionWithDeletedDestructorField {
  virtual fn F(self);
  var d: Cpp.DeletedDestructor;
}

class AdaptInt {
  adapt i32;
}

// A generic class with a member of type `T`. Tests that dynamic destruction of
// a generic class doesn't depend on its type argument.
class DestroyableBox(T: Core.Destroy) {
  var t: T;
}

class CarbonHoldsTrivialDestructor {
  var t: Cpp.TrivialDestructor;
}

class CarbonHoldsDeletedDestructor {
  var d: Cpp.DeletedDestructor;
}

// --- dynamic_destroy.carbon

library "[[@TEST_NAME]]";

import library "check_dynamic_destroy";
import library "types";
import Cpp library "types.h";

// Final types that implement `Core.Destroy`.

fn TestBool(x: bool) {
  CheckHasDynamicDestruction(x);
}

fn TestBoundMethod(c: C) {
  CheckHasDynamicDestruction(c.Get);
}

fn TestCharLiteral() {
  CheckHasDynamicDestruction('a');
}

fn TestF64(x: f64) {
  CheckHasDynamicDestruction(x);
}

fn TestFloatLiteral() {
  CheckHasDynamicDestruction(1.0);
}

fn TestForm() {
  CheckHasDynamicDestruction(form(var i32));
}

fn G() {}

fn TestFunction() {
  CheckHasDynamicDestruction(G);
}

fn TestFunctionWithSelf() {
  CheckHasDynamicDestruction((i32 as Core.Copy).Op);
}

fn TestIntLiteral() {
  CheckHasDynamicDestruction(1);
}

fn TestI32(x: i32) {
  CheckHasDynamicDestruction(x);
}

fn TestPointer(x: i32*) {
  CheckHasDynamicDestruction(x);
}

fn TestPointerToTrivialBase(x: TrivialBase*) {
  CheckHasDynamicDestruction(x);
}

fn TestEmptyStruct() {
  CheckHasDynamicDestruction({});
}

fn TestStruct(x: {.a: i32, .b: bool}) {
  CheckHasDynamicDestruction(x);
}

fn TestStructWithTrivialBase(x: {.b: TrivialBase}) {
  CheckHasDynamicDestruction(x);
}

fn TestEmptyTuple(x: ()) {
  CheckHasDynamicDestruction(x);
}

fn TestTuple(x: (i32, bool)) {
  CheckHasDynamicDestruction(x);
}

fn TestTupleWithTrivialBase(x: (TrivialBase,)) {
  CheckHasDynamicDestruction(x);
}

fn TestArray(x: array(i32, 3)) {
  CheckHasDynamicDestruction(x);
}

fn TestArrayOfTrivialBase(x: array(TrivialBase, 2)) {
  CheckHasDynamicDestruction(x);
}

fn TestConst(x: const i32) {
  CheckHasDynamicDestruction(x);
}

fn TestEmptyClass(x: EmptyClass) {
  CheckHasDynamicDestruction(x);
}

fn TestTrivialFields(x: TrivialFields) {
  CheckHasDynamicDestruction(x);
}

fn TestNonTrivial(x: NonTrivial) {
  CheckHasDynamicDestruction(x);
}

fn TestDerivedFromTrivialBase(x: DerivedFromTrivialBase) {
  CheckHasDynamicDestruction(x);
}

fn TestAdaptInt(x: AdaptInt) {
  CheckHasDynamicDestruction(x);
}

fn TestGenericClassOfI32(x: DestroyableBox(i32)) {
  CheckHasDynamicDestruction(x);
}

fn TestGenericClassOfTrivialBase(x: DestroyableBox(TrivialBase)) {
  CheckHasDynamicDestruction(x);
}

fn TestCarbonHoldsTrivialDestructor(x: CarbonHoldsTrivialDestructor) {
  CheckHasDynamicDestruction(x);
}

fn TestLong(x: Cpp.Long) {
  CheckHasDynamicDestruction(x);
}

fn TestFunctionPointer(x: Cpp.FunctionPointer) {
  CheckHasDynamicDestruction(x);
}

fn TestFinalTrivialDestructor(x: Cpp.FinalTrivialDestructor) {
  CheckHasDynamicDestruction(x);
}

fn TestFinalNonTrivialDestructor(x: Cpp.FinalNonTrivialDestructor) {
  CheckHasDynamicDestruction(x);
}

fn TestFinalVirtualFunction(x: Cpp.FinalVirtualFunction) {
  CheckHasDynamicDestruction(x);
}

fn TestFinalHolderOfI32(x: Cpp.FinalHolder(i32)) {
  CheckHasDynamicDestruction(x);
}

// Types that aren't imported from C++ and have a virtual pointer.

fn TestVirtualFunction(x: VirtualFunction) {
  CheckHasDynamicDestruction(x);
}

fn TestDerivedFromVirtualFunction(x: DerivedFromVirtualFunction) {
  CheckHasDynamicDestruction(x);
}

fn TestBaseDerivedFromVirtualFunction(x: BaseDerivedFromVirtualFunction) {
  CheckHasDynamicDestruction(x);
}

// Types imported from C++ that have a virtual destructor.

fn TestVirtualDestructor(x: Cpp.VirtualDestructor) {
  CheckHasDynamicDestruction(x);
}

fn TestDefaultedVirtualDestructor(x: Cpp.DefaultedVirtualDestructor) {
  CheckHasDynamicDestruction(x);
}

fn TestDerivedFromVirtualDestructor(x: Cpp.DerivedFromVirtualDestructor) {
  CheckHasDynamicDestruction(x);
}

fn TestConstVirtualDestructor(x: const Cpp.VirtualDestructor) {
  CheckHasDynamicDestruction(x);
}

// Facets whose facet type requires dynamic destruction.

fn TestDynamicDestroyFacet[T: Core.DynamicDestroy](x: T) {
  CheckHasDynamicDestruction(x);
}

// --- fail_dynamic_destroy.carbon

library "[[@TEST_NAME]]";

import library "check_dynamic_destroy";
import library "types";
import Cpp library "types.h";

// Types that aren't imported from C++, aren't final, and don't have a virtual
// pointer.

fn TestTrivialBase(x: TrivialBase) {
  CheckHasDestruction(x);

  CheckHasDynamicDestruction(x);
}

fn TestNonTrivialBase(x: NonTrivialBase) {
  CheckHasDestruction(x);

  CheckHasDynamicDestruction(x);
}

fn TestBaseDerivedFromTrivialBase(x: BaseDerivedFromTrivialBase) {
  CheckHasDestruction(x);

  CheckHasDynamicDestruction(x);
}

fn TestConstTrivialBase(x: const TrivialBase) {
  CheckHasDestruction(x);

  CheckHasDynamicDestruction(x);
}

// Types imported from C++ that aren't final and don't have a virtual
// destructor.

fn TestTrivialDestructor(x: Cpp.TrivialDestructor) {
  CheckHasDestruction(x);

  CheckHasDynamicDestruction(x);
}

fn TestNonTrivialDestructor(x: Cpp.NonTrivialDestructor) {
  CheckHasDestruction(x);

  CheckHasDynamicDestruction(x);
}

// Has a virtual pointer, but that only gives dynamic destruction to types that
// aren't imported from C++.
fn TestVirtualFunction(x: Cpp.VirtualFunction) {
  CheckHasDestruction(x);

  CheckHasDynamicDestruction(x);
}

fn TestHolderOfI32(x: Cpp.Holder(i32)) {
  CheckHasDestruction(x);

  CheckHasDynamicDestruction(x);
}

fn TestConstTrivialDestructor(x: const Cpp.TrivialDestructor) {
  CheckHasDestruction(x);

  CheckHasDynamicDestruction(x);
}

// Types that are final, or have a virtual pointer or virtual destructor, but
// don't implement `Core.Destroy`.

fn TestCarbonHoldsDeletedDestructor(x: CarbonHoldsDeletedDestructor) {
  CheckHasDestruction(x);

  CheckHasDynamicDestruction(x);
}

fn TestVirtualFunctionWithDeletedDestructorField(
    x: VirtualFunctionWithDeletedDestructorField) {
  CheckHasDestruction(x);

  CheckHasDynamicDestruction(x);
}

fn TestFinalDeletedDestructor(x: Cpp.FinalDeletedDestructor) {
  CheckHasDestruction(x);

  CheckHasDynamicDestruction(x);
}

fn TestDeletedVirtualDestructor(x: Cpp.DeletedVirtualDestructor) {
  CheckHasDestruction(x);

  CheckHasDynamicDestruction(x);
}

// Facets whose facet type doesn't require dynamic destruction.

fn TestDestroyFacet[T: Core.Destroy](x: T) {
  CheckHasDestruction(x);

  CheckHasDynamicDestruction(x);
}

fn TestTrivialDestroyFacet[T: Core.TrivialDestroy](x: T) {
  CheckHasDestruction(x);

  CheckHasDynamicDestruction(x);
}
