// Part of the Carbon Language project, under the Apache License v2.0 with LLVM
// Exceptions. See /LICENSE for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
// INCLUDE-FILE: toolchain/testing/testdata/min_prelude/destroy.carbon
//
// AUTOUPDATE
// TIP: To test this file alone, run:
// TIP:   bazel test //toolchain/testing:file_test --test_arg=--file_tests=toolchain/check/testdata/interop/cpp/impls/destruction/dynamic/classes.carbon
// TIP: To dump output, run:
// TIP:   bazel run //toolchain/testing:file_test -- --dump_output --file_tests=toolchain/check/testdata/interop/cpp/impls/destruction/dynamic/classes.carbon

// A type has _dynamic destruction_ if it:
//
// -   is final and implements `Core.Destroy`, or
// -   is not imported from C++ and has a virtual pointer, or
// -   is imported from C++ and has a virtual destructor.

// --- types.h

struct NonFinalTriviallyDestructible {};

struct VirtualDestructor {
  virtual ~VirtualDestructor();
};

struct DeletedDestructor {
  ~DeletedDestructor() = delete;
};

template <typename T>
struct NonFinalClassTemplate {
  T t;
};

// --- todo_dynamic_carbon_holds_trivial_destructor.carbon
library "[[@TEST_NAME]]";

import Cpp library "types.h";

class CarbonHoldsTriviallyDestructible {
  var t: Cpp.NonFinalTriviallyDestructible;
}

fn Make() -> CarbonHoldsTriviallyDestructible;

fn Test() {
  //@dump-sem-ir-begin
  CarbonHoldsTriviallyDestructible as Core.SubobjectDestroy;
  CarbonHoldsTriviallyDestructible as Core.Destroy;
  CarbonHoldsTriviallyDestructible as Core.DynamicDestroy;

  var unused x: CarbonHoldsTriviallyDestructible = Make();
  //@dump-sem-ir-end
}

// --- todo_dynamic_cpp_final_trivial_destructor.carbon
library "[[@TEST_NAME]]";

import Cpp inline '''c++
struct FinalTriviallyDestructible final {};
''';

fn Make() -> Cpp.FinalTriviallyDestructible;

fn Test() {
  //@dump-sem-ir-begin
  Cpp.FinalTriviallyDestructible as Core.SubobjectDestroy;
  Cpp.FinalTriviallyDestructible as Core.Destroy;
  Cpp.FinalTriviallyDestructible as Core.DynamicDestroy;

  var unused x: Cpp.FinalTriviallyDestructible = Make();
  //@dump-sem-ir-end
}

// --- todo_dynamic_cpp_final_non_trivial_destructor.carbon
library "[[@TEST_NAME]]";

import Cpp inline '''c++
struct FinalNonTriviallyDestructible final {
  ~FinalNonTriviallyDestructible();
};
''';

fn Make() -> Cpp.FinalNonTriviallyDestructible;

fn Test() {
  //@dump-sem-ir-begin
  Cpp.FinalNonTriviallyDestructible as Core.SubobjectDestroy;
  Cpp.FinalNonTriviallyDestructible as Core.Destroy;
  Cpp.FinalNonTriviallyDestructible as Core.DynamicDestroy;

  var unused x: Cpp.FinalNonTriviallyDestructible = Make();
  //@dump-sem-ir-end
}

// --- todo_dynamic_cpp_final_virtual_function.carbon
library "[[@TEST_NAME]]";

import Cpp inline '''c++
struct FinalVirtualFunction final {
  virtual void F();
};
''';

fn Make() -> Cpp.FinalVirtualFunction;

fn Test() {
  //@dump-sem-ir-begin
  Cpp.FinalVirtualFunction as Core.SubobjectDestroy;
  Cpp.FinalVirtualFunction as Core.Destroy;
  Cpp.FinalVirtualFunction as Core.DynamicDestroy;

  var unused x: Cpp.FinalVirtualFunction = Make();
  //@dump-sem-ir-end
}

// --- todo_dynamic_cpp_final_class_template_of_trivial_destruction.carbon
library "[[@TEST_NAME]]";

import Cpp inline '''c++
template <typename T>
struct FinalClassTemplate final {
  T t;
};
''';

class FinalClass {}
alias FinalClassTemplate = Cpp.FinalClassTemplate(FinalClass);
fn Make() -> FinalClassTemplate;

fn Test() {
  //@dump-sem-ir-begin
  FinalClassTemplate as Core.SubobjectDestroy;
  FinalClassTemplate as Core.Destroy;
  FinalClassTemplate as Core.DynamicDestroy;

  var unused x: FinalClassTemplate = Make();
  //@dump-sem-ir-end
}

// --- todo_dynamic_cpp_virtual_destructor.carbon
library "[[@TEST_NAME]]";

import Cpp library "types.h";

fn Make() -> Cpp.VirtualDestructor;

fn Test() {
  //@dump-sem-ir-begin
  Cpp.VirtualDestructor as Core.SubobjectDestroy;
  Cpp.VirtualDestructor as Core.Destroy;
  Cpp.VirtualDestructor as Core.DynamicDestroy;

  var unused x: Cpp.VirtualDestructor = Make();
  //@dump-sem-ir-end
}

// --- todo_dynamic_cpp_defaulted_virtual_destructor.carbon
library "[[@TEST_NAME]]";

import Cpp inline '''c++
struct DefaultedVirtualDestructor {
  virtual ~DefaultedVirtualDestructor() = default;
};
''';

fn Make() -> Cpp.DefaultedVirtualDestructor;

fn Test() {
  //@dump-sem-ir-begin
  Cpp.DefaultedVirtualDestructor as Core.SubobjectDestroy;
  Cpp.DefaultedVirtualDestructor as Core.Destroy;
  Cpp.DefaultedVirtualDestructor as Core.DynamicDestroy;

  var unused x: Cpp.DefaultedVirtualDestructor = Make();
  //@dump-sem-ir-end
}

// --- todo_dynamic_cpp_derived_from_virtual_destructor.carbon
library "[[@TEST_NAME]]";

import Cpp library "types.h";
inline Cpp '''c++
// The destructor is implicitly virtual, because the base's is virtual.
struct DerivedFromVirtualDestructor : VirtualDestructor {};
''';

fn Make() -> Cpp.DerivedFromVirtualDestructor;

fn Test() {
  //@dump-sem-ir-begin
  Cpp.DerivedFromVirtualDestructor as Core.SubobjectDestroy;
  Cpp.DerivedFromVirtualDestructor as Core.Destroy;
  Cpp.DerivedFromVirtualDestructor as Core.DynamicDestroy;

  var unused x: Cpp.DerivedFromVirtualDestructor = Make();
  //@dump-sem-ir-end
}

// --- fail_nondynamic_cpp_trivial_destructor.carbon
library "[[@TEST_NAME]]";

import Cpp library "types.h";

fn Test() {
  // CHECK:STDERR:        ╭─┤ fail_nondynamic_cpp_trivial_destructor.carbon:[[@LINE+8]]:3
  // CHECK:STDERR: ->     │   Cpp.NonFinalTriviallyDestructible as Core.DynamicDestroy;
  // CHECK:STDERR:        ·   ┳━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  // CHECK:STDERR:        ·   ┗━━┫ error: cannot convert type `NonFinalTriviallyDestructible` into type
  // CHECK:STDERR:        ·      ┃        implementing `Core.DynamicDestroy`
  // CHECK:STDERR:        ·      ┃        [ConversionFailureTypeToFacet]
  // CHECK:STDERR:        ╰────
  // CHECK:STDERR:
  Cpp.NonFinalTriviallyDestructible as Core.DynamicDestroy;
}

// --- fail_nondynamic_cpp_non_trivial_destructor.carbon
library "[[@TEST_NAME]]";

import Cpp inline '''c++
struct NonTriviallyDestructible {
  ~NonTriviallyDestructible();
};
''';

fn Test() {
  // CHECK:STDERR:        ╭─┤ fail_nondynamic_cpp_non_trivial_destructor.carbon:[[@LINE+8]]:3
  // CHECK:STDERR: ->     │   Cpp.NonTriviallyDestructible as Core.DynamicDestroy;
  // CHECK:STDERR:        ·   ┳━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  // CHECK:STDERR:        ·   ┗━━┫ error: cannot convert type `NonTriviallyDestructible` into type
  // CHECK:STDERR:        ·      ┃        implementing `Core.DynamicDestroy`
  // CHECK:STDERR:        ·      ┃        [ConversionFailureTypeToFacet]
  // CHECK:STDERR:        ╰────
  // CHECK:STDERR:
  Cpp.NonTriviallyDestructible as Core.DynamicDestroy;
}

// --- fail_nondynamic_cpp_virtual_function.carbon
library "[[@TEST_NAME]]";

import Cpp inline '''c++
// Has a virtual pointer, but the destructor isn't virtual.
struct VirtualFunction {
  virtual void F();
};
''';

// Has a virtual pointer, but that only gives dynamic destruction to types that
// aren't imported from C++.
fn Test() {
  // CHECK:STDERR:        ╭─┤ fail_nondynamic_cpp_virtual_function.carbon:[[@LINE+8]]:3
  // CHECK:STDERR: ->     │   Cpp.VirtualFunction as Core.DynamicDestroy;
  // CHECK:STDERR:        ·   ┳━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  // CHECK:STDERR:        ·   ┗━━┫ error: cannot convert type `VirtualFunction` into type implementing
  // CHECK:STDERR:        ·      ┃        `Core.DynamicDestroy`
  // CHECK:STDERR:        ·      ┃        [ConversionFailureTypeToFacet]
  // CHECK:STDERR:        ╰────
  // CHECK:STDERR:
  Cpp.VirtualFunction as Core.DynamicDestroy;
}

// --- fail_nondynamic_cpp_class_template_of_trivial_destruction.carbon
library "[[@TEST_NAME]]";

import Cpp library "types.h";

class FinalClass {}
alias NonFinalClassTemplate = Cpp.NonFinalClassTemplate(FinalClass);

fn Test() {
  // CHECK:STDERR:        ╭─┤ fail_nondynamic_cpp_class_template_of_trivial_destruction.carbon:[[@LINE+8]]:3
  // CHECK:STDERR: ->     │   NonFinalClassTemplate as Core.DynamicDestroy;
  // CHECK:STDERR:        ·   ┳━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  // CHECK:STDERR:        ·   ┗━━┫ error: cannot convert type `NonFinalClassTemplate` into type implementing
  // CHECK:STDERR:        ·      ┃        `Core.DynamicDestroy`
  // CHECK:STDERR:        ·      ┃        [ConversionFailureTypeToFacet]
  // CHECK:STDERR:        ╰────
  // CHECK:STDERR:
  NonFinalClassTemplate as Core.DynamicDestroy;
}

// --- fail_nondynamic_carbon_holds_deleted_destructor.carbon
library "[[@TEST_NAME]]";

import Cpp library "types.h";

class CarbonHoldsDeletedDestructor {
  var d: Cpp.DeletedDestructor;
}

fn Test() {
  // CHECK:STDERR:        ╭─┤ fail_nondynamic_carbon_holds_deleted_destructor.carbon:[[@LINE+21]]:32
  // CHECK:STDERR: ->     │   CarbonHoldsDeletedDestructor as Core.DynamicDestroy;
  // CHECK:STDERR:        ·                                ┳
  // CHECK:STDERR:        ·                                ┗━━┫ error: attempt to use a deleted function
  // CHECK:STDERR:        ·                                   ┃        [CppInteropParseError]
  // CHECK:STDERR:        ┆
  // CHECK:STDERR:        ├─┤ ./types.h
  // CHECK:STDERR:        │   ~DeletedDestructor() = delete;
  // CHECK:STDERR:        ·   ┬
  // CHECK:STDERR:        ·   ╰──┤ '~DeletedDestructor' has been explicitly marked deleted here
  // CHECK:STDERR:        ·      │ [CppInteropParseNote]
  // CHECK:STDERR:        ╰────
  // CHECK:STDERR:
  // CHECK:STDERR:        ╭─┤ fail_nondynamic_carbon_holds_deleted_destructor.carbon:[[@LINE+8]]:3
  // CHECK:STDERR: ->     │   CarbonHoldsDeletedDestructor as Core.DynamicDestroy;
  // CHECK:STDERR:        ·   ┳━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  // CHECK:STDERR:        ·   ┗━━┫ error: cannot convert type `CarbonHoldsDeletedDestructor` into type
  // CHECK:STDERR:        ·      ┃        implementing `Core.DynamicDestroy`
  // CHECK:STDERR:        ·      ┃        [ConversionFailureTypeToFacet]
  // CHECK:STDERR:        ╰────
  // CHECK:STDERR:
  CarbonHoldsDeletedDestructor as Core.DynamicDestroy;
}

// --- fail_nondynamic_virtual_function_with_deleted_destructor_field.carbon
library "[[@TEST_NAME]]";

import Cpp library "types.h";

// Has a virtual pointer, but can't be destroyed because of its field.
base class VirtualFunctionWithDeletedDestructorField {
  virtual fn F(self);
  var d: Cpp.DeletedDestructor;
}

fn Test() {
  // CHECK:STDERR:        ╭─┤ fail_nondynamic_virtual_function_with_deleted_destructor_field.carbon:[[@LINE+22]]:45
  // CHECK:STDERR: ->     │   VirtualFunctionWithDeletedDestructorField as Core.DynamicDestroy;
  // CHECK:STDERR:        ·                                             ┳
  // CHECK:STDERR:        ·                                             ┗━━┫ error: attempt to use a deleted
  // CHECK:STDERR:        ·                                                ┃        function
  // CHECK:STDERR:        ·                                                ┃        [CppInteropParseError]
  // CHECK:STDERR:        ┆
  // CHECK:STDERR:        ├─┤ ./types.h
  // CHECK:STDERR:        │   ~DeletedDestructor() = delete;
  // CHECK:STDERR:        ·   ┬
  // CHECK:STDERR:        ·   ╰──┤ '~DeletedDestructor' has been explicitly marked deleted here
  // CHECK:STDERR:        ·      │ [CppInteropParseNote]
  // CHECK:STDERR:        ╰────
  // CHECK:STDERR:
  // CHECK:STDERR:        ╭─┤ fail_nondynamic_virtual_function_with_deleted_destructor_field.carbon:[[@LINE+8]]:3
  // CHECK:STDERR: ->     │   VirtualFunctionWithDeletedDestructorField as Core.DynamicDestroy;
  // CHECK:STDERR:        ·   ┳━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  // CHECK:STDERR:        ·   ┗━━┫ error: cannot convert type `VirtualFunctionWithDeletedDestructorField`
  // CHECK:STDERR:        ·      ┃        into type implementing `Core.DynamicDestroy`
  // CHECK:STDERR:        ·      ┃        [ConversionFailureTypeToFacet]
  // CHECK:STDERR:        ╰────
  // CHECK:STDERR:
  VirtualFunctionWithDeletedDestructorField as Core.DynamicDestroy;
}

// --- fail_nondynamic_cpp_final_deleted_destructor.carbon
library "[[@TEST_NAME]]";

import Cpp inline '''c++
struct FinalDeletedDestructor final {
  ~FinalDeletedDestructor() = delete;
};
''';

fn Test() {
  // CHECK:STDERR:        ╭─┤ fail_nondynamic_cpp_final_deleted_destructor.carbon:[[@LINE+20]]:30
  // CHECK:STDERR:        │   ~FinalDeletedDestructor() = delete;
  // CHECK:STDERR:        ·   ┬
  // CHECK:STDERR:        ·   ╰──┤ '~FinalDeletedDestructor' has been explicitly marked deleted here
  // CHECK:STDERR:        ·      │ [CppInteropParseNote]
  // CHECK:STDERR:        ┆
  // CHECK:STDERR: ->     │   Cpp.FinalDeletedDestructor as Core.DynamicDestroy;
  // CHECK:STDERR:        ·                              ┳
  // CHECK:STDERR:        ·                              ┗━━┫ error: attempt to use a deleted function
  // CHECK:STDERR:        ·                                 ┃        [CppInteropParseError]
  // CHECK:STDERR:        ╰────
  // CHECK:STDERR:
  // CHECK:STDERR:        ╭─┤ fail_nondynamic_cpp_final_deleted_destructor.carbon:[[@LINE+8]]:3
  // CHECK:STDERR: ->     │   Cpp.FinalDeletedDestructor as Core.DynamicDestroy;
  // CHECK:STDERR:        ·   ┳━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  // CHECK:STDERR:        ·   ┗━━┫ error: cannot convert type `FinalDeletedDestructor` into type
  // CHECK:STDERR:        ·      ┃        implementing `Core.DynamicDestroy`
  // CHECK:STDERR:        ·      ┃        [ConversionFailureTypeToFacet]
  // CHECK:STDERR:        ╰────
  // CHECK:STDERR:
  Cpp.FinalDeletedDestructor as Core.DynamicDestroy;
}

// --- fail_nondynamic_cpp_deleted_virtual_destructor.carbon
library "[[@TEST_NAME]]";

import Cpp inline '''c++
struct DeletedVirtualDestructor {
  virtual ~DeletedVirtualDestructor() = delete;
};
''';

fn Test() {
  // CHECK:STDERR:        ╭─┤ fail_nondynamic_cpp_deleted_virtual_destructor.carbon:[[@LINE+21]]:32
  // CHECK:STDERR:        │   virtual ~DeletedVirtualDestructor() = delete;
  // CHECK:STDERR:        ·           ┬
  // CHECK:STDERR:        ·           ╰──┤ '~DeletedVirtualDestructor' has been explicitly marked deleted
  // CHECK:STDERR:        ·              │ here
  // CHECK:STDERR:        ·              │ [CppInteropParseNote]
  // CHECK:STDERR:        ┆
  // CHECK:STDERR: ->     │   Cpp.DeletedVirtualDestructor as Core.DynamicDestroy;
  // CHECK:STDERR:        ·                                ┳
  // CHECK:STDERR:        ·                                ┗━━┫ error: attempt to use a deleted function
  // CHECK:STDERR:        ·                                   ┃        [CppInteropParseError]
  // CHECK:STDERR:        ╰────
  // CHECK:STDERR:
  // CHECK:STDERR:        ╭─┤ fail_nondynamic_cpp_deleted_virtual_destructor.carbon:[[@LINE+8]]:3
  // CHECK:STDERR: ->     │   Cpp.DeletedVirtualDestructor as Core.DynamicDestroy;
  // CHECK:STDERR:        ·   ┳━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  // CHECK:STDERR:        ·   ┗━━┫ error: cannot convert type `DeletedVirtualDestructor` into type
  // CHECK:STDERR:        ·      ┃        implementing `Core.DynamicDestroy`
  // CHECK:STDERR:        ·      ┃        [ConversionFailureTypeToFacet]
  // CHECK:STDERR:        ╰────
  // CHECK:STDERR:
  Cpp.DeletedVirtualDestructor as Core.DynamicDestroy;
}

// CHECK:STDOUT: --- todo_dynamic_carbon_holds_trivial_destructor.carbon = $todo_dynamic_carbon_holds_trivial_destructor
// CHECK:STDOUT:
// CHECK:STDOUT: constants {
// CHECK:STDOUT:   type: type = facet_type <type> [concrete]
// CHECK:STDOUT:   %CarbonHoldsTriviallyDestructible: type = class_type @CarbonHoldsTriviallyDestructible [concrete]
// CHECK:STDOUT:   %NonFinalTriviallyDestructible: type = class_type @NonFinalTriviallyDestructible [concrete]
// CHECK:STDOUT:   %empty_tuple.type: type = tuple_type () [concrete]
// CHECK:STDOUT:   %struct_type.t.bd2: type = struct_type {.t: %NonFinalTriviallyDestructible} [concrete]
// CHECK:STDOUT:   %pattern_type.9cf: type = pattern_type %CarbonHoldsTriviallyDestructible [concrete]
// CHECK:STDOUT:   %Make.type: type = fn_type @Make [concrete]
// CHECK:STDOUT:   %Make: %Make.type = struct_value () [concrete]
// CHECK:STDOUT:   %SubobjectDestroy.type: type = facet_type <@SubobjectDestroy> [concrete]
// CHECK:STDOUT:   %DestroyImpl.type: type = facet_type <@DestroyImpl> [concrete]
// CHECK:STDOUT:   %T.09f: %SubobjectDestroy.type = symbolic_binding T, 0 [symbolic]
// CHECK:STDOUT:   %T.as_type.as.DestroyImpl.impl.Op.type.dea: type = fn_type @T.as_type.as.DestroyImpl.impl.Op, @T.as_type.as.DestroyImpl.impl(%T.09f) [symbolic]
// CHECK:STDOUT:   %T.as_type.as.DestroyImpl.impl.Op.6e5: %T.as_type.as.DestroyImpl.impl.Op.type.dea = struct_value () [symbolic]
// CHECK:STDOUT:   %SubobjectDestroy.WithSelf.Op.type.6870fd.2: type = fn_type @SubobjectDestroy.WithSelf.Op.loc13_36.2 [concrete]
// CHECK:STDOUT:   %SubobjectDestroy.WithSelf.Op.30f1ee.2: %SubobjectDestroy.WithSelf.Op.type.6870fd.2 = struct_value () [concrete]
// CHECK:STDOUT:   %custom_witness.b80ef6.2: <witness> = custom_witness (%SubobjectDestroy.WithSelf.Op.30f1ee.2), @SubobjectDestroy [concrete]
// CHECK:STDOUT:   %SubobjectDestroy.facet.cc4: %SubobjectDestroy.type = facet_value %CarbonHoldsTriviallyDestructible, (%custom_witness.b80ef6.2) [concrete]
// CHECK:STDOUT:   %Destroy.type: type = facet_type <@Destroy> [concrete]
// CHECK:STDOUT:   %DestroyImpl.impl_witness.ca7: <witness> = impl_witness imports.%DestroyImpl.impl_witness_table, @T.as_type.as.DestroyImpl.impl(%SubobjectDestroy.facet.cc4) [concrete]
// CHECK:STDOUT:   %Destroy.facet: %Destroy.type = facet_value %CarbonHoldsTriviallyDestructible, (%custom_witness.b80ef6.2, %DestroyImpl.impl_witness.ca7) [concrete]
// CHECK:STDOUT:   %DynamicDestroy.type: type = facet_type <@DynamicDestroy> [concrete]
// CHECK:STDOUT:   %custom_witness.0b5: <witness> = custom_witness (), @DynamicDestroyImpl [concrete]
// CHECK:STDOUT:   %DynamicDestroy.facet: %DynamicDestroy.type = facet_value %CarbonHoldsTriviallyDestructible, (%custom_witness.b80ef6.2, %DestroyImpl.impl_witness.ca7, %custom_witness.0b5) [concrete]
// CHECK:STDOUT:   %x.patt: %pattern_type.9cf = ref_binding_pattern x [concrete]
// CHECK:STDOUT:   %x.var_patt: %pattern_type.9cf = var_pattern %x.patt [concrete]
// CHECK:STDOUT:   %SelfDestruct.type: type = fn_type @SelfDestruct [concrete]
// CHECK:STDOUT:   %SelfDestruct: %SelfDestruct.type = struct_value () [concrete]
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: imports {
// CHECK:STDOUT:   %Core: <namespace> = namespace file.%Core.import, [concrete] {
// CHECK:STDOUT:     .SubobjectDestroy = %Core.SubobjectDestroy
// CHECK:STDOUT:     .DestroyImpl = %Core.DestroyImpl
// CHECK:STDOUT:     .Destroy = %Core.Destroy
// CHECK:STDOUT:     .DynamicDestroy = %Core.DynamicDestroy
// CHECK:STDOUT:     .SelfDestruct = %Core.SelfDestruct
// CHECK:STDOUT:     import Core//prelude
// CHECK:STDOUT:     import Core//prelude/...
// CHECK:STDOUT:   }
// CHECK:STDOUT:   %Core.SubobjectDestroy: type = import_ref Core//prelude/parts/destroy, SubobjectDestroy, loaded [concrete = constants.%SubobjectDestroy.type]
// CHECK:STDOUT:   %Core.DestroyImpl: type = import_ref Core//prelude/parts/destroy, DestroyImpl, loaded [concrete = constants.%DestroyImpl.type]
// CHECK:STDOUT:   %Core.import_ref.74d: @T.as_type.as.DestroyImpl.impl.%T.as_type.as.DestroyImpl.impl.Op.type (%T.as_type.as.DestroyImpl.impl.Op.type.dea) = import_ref Core//prelude/parts/destroy, loc{{\d+_\d+}}, loaded [symbolic = @T.as_type.as.DestroyImpl.impl.%T.as_type.as.DestroyImpl.impl.Op (constants.%T.as_type.as.DestroyImpl.impl.Op.6e5)]
// CHECK:STDOUT:   %DestroyImpl.impl_witness_table = impl_witness_table (%Core.import_ref.74d), @T.as_type.as.DestroyImpl.impl [concrete]
// CHECK:STDOUT:   %Core.Destroy: type = import_ref Core//prelude/parts/destroy, Destroy, loaded [concrete = constants.%Destroy.type]
// CHECK:STDOUT:   %Core.DynamicDestroy: type = import_ref Core//prelude/parts/destroy, DynamicDestroy, loaded [concrete = constants.%DynamicDestroy.type]
// CHECK:STDOUT:   %Core.SelfDestruct: %SelfDestruct.type = import_ref Core//prelude/parts/destroy, SelfDestruct, loaded [concrete = constants.%SelfDestruct]
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: fn @Test() {
// CHECK:STDOUT: !entry:
// CHECK:STDOUT:   %CarbonHoldsTriviallyDestructible.ref.loc13: type = name_ref CarbonHoldsTriviallyDestructible, file.%CarbonHoldsTriviallyDestructible.decl [concrete = constants.%CarbonHoldsTriviallyDestructible]
// CHECK:STDOUT:   %Core.ref.loc13: <namespace> = name_ref Core, imports.%Core [concrete = imports.%Core]
// CHECK:STDOUT:   %SubobjectDestroy.ref: type = name_ref SubobjectDestroy, imports.%Core.SubobjectDestroy [concrete = constants.%SubobjectDestroy.type]
// CHECK:STDOUT:   %SubobjectDestroy.facet: %SubobjectDestroy.type = facet_value %CarbonHoldsTriviallyDestructible.ref.loc13, (constants.%custom_witness.b80ef6.2) [concrete = constants.%SubobjectDestroy.facet.cc4]
// CHECK:STDOUT:   %.loc13: %SubobjectDestroy.type = converted %CarbonHoldsTriviallyDestructible.ref.loc13, %SubobjectDestroy.facet [concrete = constants.%SubobjectDestroy.facet.cc4]
// CHECK:STDOUT:   %CarbonHoldsTriviallyDestructible.ref.loc14: type = name_ref CarbonHoldsTriviallyDestructible, file.%CarbonHoldsTriviallyDestructible.decl [concrete = constants.%CarbonHoldsTriviallyDestructible]
// CHECK:STDOUT:   %Core.ref.loc14: <namespace> = name_ref Core, imports.%Core [concrete = imports.%Core]
// CHECK:STDOUT:   %Destroy.ref: type = name_ref Destroy, imports.%Core.Destroy [concrete = constants.%Destroy.type]
// CHECK:STDOUT:   %Destroy.facet.loc14: %Destroy.type = facet_value %CarbonHoldsTriviallyDestructible.ref.loc14, (constants.%custom_witness.b80ef6.2, constants.%DestroyImpl.impl_witness.ca7) [concrete = constants.%Destroy.facet]
// CHECK:STDOUT:   %.loc14: %Destroy.type = converted %CarbonHoldsTriviallyDestructible.ref.loc14, %Destroy.facet.loc14 [concrete = constants.%Destroy.facet]
// CHECK:STDOUT:   %CarbonHoldsTriviallyDestructible.ref.loc15: type = name_ref CarbonHoldsTriviallyDestructible, file.%CarbonHoldsTriviallyDestructible.decl [concrete = constants.%CarbonHoldsTriviallyDestructible]
// CHECK:STDOUT:   %Core.ref.loc15: <namespace> = name_ref Core, imports.%Core [concrete = imports.%Core]
// CHECK:STDOUT:   %DynamicDestroy.ref: type = name_ref DynamicDestroy, imports.%Core.DynamicDestroy [concrete = constants.%DynamicDestroy.type]
// CHECK:STDOUT:   %DynamicDestroy.facet: %DynamicDestroy.type = facet_value %CarbonHoldsTriviallyDestructible.ref.loc15, (constants.%custom_witness.b80ef6.2, constants.%DestroyImpl.impl_witness.ca7, constants.%custom_witness.0b5) [concrete = constants.%DynamicDestroy.facet]
// CHECK:STDOUT:   %.loc15: %DynamicDestroy.type = converted %CarbonHoldsTriviallyDestructible.ref.loc15, %DynamicDestroy.facet [concrete = constants.%DynamicDestroy.facet]
// CHECK:STDOUT:   %x.var: ref %CarbonHoldsTriviallyDestructible = var_storage %x.var_patt
// CHECK:STDOUT:   %Make.ref: %Make.type = name_ref Make, file.%Make.decl [concrete = constants.%Make]
// CHECK:STDOUT:   %.loc17_3.1: ref %CarbonHoldsTriviallyDestructible = splice_block %x.var {}
// CHECK:STDOUT:   %Make.call: init %CarbonHoldsTriviallyDestructible to %.loc17_3.1 = call %Make.ref()
// CHECK:STDOUT:   assign %x.var, %Make.call
// CHECK:STDOUT:   %CarbonHoldsTriviallyDestructible.ref.loc17: type = name_ref CarbonHoldsTriviallyDestructible, file.%CarbonHoldsTriviallyDestructible.decl [concrete = constants.%CarbonHoldsTriviallyDestructible]
// CHECK:STDOUT:   %x: ref %CarbonHoldsTriviallyDestructible = wrapper_binding x, %x.var
// CHECK:STDOUT:   name_binding_decl {
// CHECK:STDOUT:     %x.patt: %pattern_type.9cf = ref_binding_pattern x [concrete = constants.%x.patt]
// CHECK:STDOUT:     %x.var_patt: %pattern_type.9cf = var_pattern %x.patt [concrete = constants.%x.var_patt]
// CHECK:STDOUT:   }
// CHECK:STDOUT:   %Destroy.facet.loc17_3.1: %Destroy.type = facet_value constants.%CarbonHoldsTriviallyDestructible, (constants.%custom_witness.b80ef6.2, constants.%DestroyImpl.impl_witness.ca7) [concrete = constants.%Destroy.facet]
// CHECK:STDOUT:   %.loc17_3.2: %Destroy.type = converted constants.%CarbonHoldsTriviallyDestructible, %Destroy.facet.loc17_3.1 [concrete = constants.%Destroy.facet]
// CHECK:STDOUT:   %Destroy.facet.loc17_3.2: %Destroy.type = facet_value constants.%CarbonHoldsTriviallyDestructible, (constants.%custom_witness.b80ef6.2, constants.%DestroyImpl.impl_witness.ca7) [concrete = constants.%Destroy.facet]
// CHECK:STDOUT:   %.loc17_3.3: %Destroy.type = converted constants.%CarbonHoldsTriviallyDestructible, %Destroy.facet.loc17_3.2 [concrete = constants.%Destroy.facet]
// CHECK:STDOUT:   <elided>
// CHECK:STDOUT:   %SelfDestruct.call: init %empty_tuple.type = call %SelfDestruct.specific_fn(%x.var)
// CHECK:STDOUT:   <elided>
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: fn @SubobjectDestroy.WithSelf.Op.loc13_36.1(%self.param: ref %struct_type.t.bd2) = "no_op";
// CHECK:STDOUT:
// CHECK:STDOUT: fn @SubobjectDestroy.WithSelf.Op.loc13_36.2(%self.param: ref %CarbonHoldsTriviallyDestructible) = "no_op";
// CHECK:STDOUT:
// CHECK:STDOUT: --- todo_dynamic_cpp_final_trivial_destructor.carbon = $todo_dynamic_cpp_final_trivial_destructor
// CHECK:STDOUT:
// CHECK:STDOUT: constants {
// CHECK:STDOUT:   type: type = facet_type <type> [concrete]
// CHECK:STDOUT:   %FinalTriviallyDestructible: type = class_type @FinalTriviallyDestructible [concrete]
// CHECK:STDOUT:   %pattern_type.9b8: type = pattern_type %FinalTriviallyDestructible [concrete]
// CHECK:STDOUT:   %Make.type: type = fn_type @Make [concrete]
// CHECK:STDOUT:   %empty_tuple.type: type = tuple_type () [concrete]
// CHECK:STDOUT:   %Make: %Make.type = struct_value () [concrete]
// CHECK:STDOUT:   %SubobjectDestroy.type: type = facet_type <@SubobjectDestroy> [concrete]
// CHECK:STDOUT:   %DestroyImpl.type: type = facet_type <@DestroyImpl> [concrete]
// CHECK:STDOUT:   %FinalTriviallyDestructible.cpp_destructor.type: type = fn_type @FinalTriviallyDestructible.cpp_destructor [concrete]
// CHECK:STDOUT:   %FinalTriviallyDestructible.cpp_destructor: %FinalTriviallyDestructible.cpp_destructor.type = struct_value () [concrete]
// CHECK:STDOUT:   %custom_witness.fe1: <witness> = custom_witness (%FinalTriviallyDestructible.cpp_destructor), @SubobjectDestroy [concrete]
// CHECK:STDOUT:   %SubobjectDestroy.facet.cda: %SubobjectDestroy.type = facet_value %FinalTriviallyDestructible, (%custom_witness.fe1) [concrete]
// CHECK:STDOUT:   %Destroy.type: type = facet_type <@Destroy> [concrete]
// CHECK:STDOUT:   %T.09f: %SubobjectDestroy.type = symbolic_binding T, 0 [symbolic]
// CHECK:STDOUT:   %T.as_type.as.DestroyImpl.impl.Op.type.dea: type = fn_type @T.as_type.as.DestroyImpl.impl.Op, @T.as_type.as.DestroyImpl.impl(%T.09f) [symbolic]
// CHECK:STDOUT:   %T.as_type.as.DestroyImpl.impl.Op.6e5: %T.as_type.as.DestroyImpl.impl.Op.type.dea = struct_value () [symbolic]
// CHECK:STDOUT:   %DestroyImpl.impl_witness.de2: <witness> = impl_witness imports.%DestroyImpl.impl_witness_table, @T.as_type.as.DestroyImpl.impl(%SubobjectDestroy.facet.cda) [concrete]
// CHECK:STDOUT:   %Destroy.facet: %Destroy.type = facet_value %FinalTriviallyDestructible, (%custom_witness.fe1, %DestroyImpl.impl_witness.de2) [concrete]
// CHECK:STDOUT:   %DynamicDestroy.type: type = facet_type <@DynamicDestroy> [concrete]
// CHECK:STDOUT:   %custom_witness.0b5: <witness> = custom_witness (), @DynamicDestroyImpl [concrete]
// CHECK:STDOUT:   %DynamicDestroy.facet: %DynamicDestroy.type = facet_value %FinalTriviallyDestructible, (%custom_witness.fe1, %DestroyImpl.impl_witness.de2, %custom_witness.0b5) [concrete]
// CHECK:STDOUT:   %x.patt: %pattern_type.9b8 = ref_binding_pattern x [concrete]
// CHECK:STDOUT:   %x.var_patt: %pattern_type.9b8 = var_pattern %x.patt [concrete]
// CHECK:STDOUT:   %SelfDestruct.type: type = fn_type @SelfDestruct [concrete]
// CHECK:STDOUT:   %SelfDestruct: %SelfDestruct.type = struct_value () [concrete]
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: imports {
// CHECK:STDOUT:   %Core: <namespace> = namespace file.%Core.import, [concrete] {
// CHECK:STDOUT:     .SubobjectDestroy = %Core.SubobjectDestroy
// CHECK:STDOUT:     .DestroyImpl = %Core.DestroyImpl
// CHECK:STDOUT:     .Destroy = %Core.Destroy
// CHECK:STDOUT:     .DynamicDestroy = %Core.DynamicDestroy
// CHECK:STDOUT:     .SelfDestruct = %Core.SelfDestruct
// CHECK:STDOUT:     import Core//prelude
// CHECK:STDOUT:     import Core//prelude/...
// CHECK:STDOUT:   }
// CHECK:STDOUT:   %Cpp: <namespace> = namespace file.%Cpp.import_cpp, [concrete] {
// CHECK:STDOUT:     .FinalTriviallyDestructible = %FinalTriviallyDestructible.decl
// CHECK:STDOUT:     import Cpp//...
// CHECK:STDOUT:   }
// CHECK:STDOUT:   %FinalTriviallyDestructible.decl: type = class_decl @FinalTriviallyDestructible [concrete = constants.%FinalTriviallyDestructible] {} {}
// CHECK:STDOUT:   %Core.SubobjectDestroy: type = import_ref Core//prelude/parts/destroy, SubobjectDestroy, loaded [concrete = constants.%SubobjectDestroy.type]
// CHECK:STDOUT:   %Core.DestroyImpl: type = import_ref Core//prelude/parts/destroy, DestroyImpl, loaded [concrete = constants.%DestroyImpl.type]
// CHECK:STDOUT:   %Core.Destroy: type = import_ref Core//prelude/parts/destroy, Destroy, loaded [concrete = constants.%Destroy.type]
// CHECK:STDOUT:   %Core.import_ref.74d: @T.as_type.as.DestroyImpl.impl.%T.as_type.as.DestroyImpl.impl.Op.type (%T.as_type.as.DestroyImpl.impl.Op.type.dea) = import_ref Core//prelude/parts/destroy, loc{{\d+_\d+}}, loaded [symbolic = @T.as_type.as.DestroyImpl.impl.%T.as_type.as.DestroyImpl.impl.Op (constants.%T.as_type.as.DestroyImpl.impl.Op.6e5)]
// CHECK:STDOUT:   %DestroyImpl.impl_witness_table = impl_witness_table (%Core.import_ref.74d), @T.as_type.as.DestroyImpl.impl [concrete]
// CHECK:STDOUT:   %Core.DynamicDestroy: type = import_ref Core//prelude/parts/destroy, DynamicDestroy, loaded [concrete = constants.%DynamicDestroy.type]
// CHECK:STDOUT:   %Core.SelfDestruct: %SelfDestruct.type = import_ref Core//prelude/parts/destroy, SelfDestruct, loaded [concrete = constants.%SelfDestruct]
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: fn @Test() {
// CHECK:STDOUT: !entry:
// CHECK:STDOUT:   %Cpp.ref.loc11: <namespace> = name_ref Cpp, imports.%Cpp [concrete = imports.%Cpp]
// CHECK:STDOUT:   %FinalTriviallyDestructible.ref.loc11: type = name_ref FinalTriviallyDestructible, imports.%FinalTriviallyDestructible.decl [concrete = constants.%FinalTriviallyDestructible]
// CHECK:STDOUT:   %Core.ref.loc11: <namespace> = name_ref Core, imports.%Core [concrete = imports.%Core]
// CHECK:STDOUT:   %SubobjectDestroy.ref: type = name_ref SubobjectDestroy, imports.%Core.SubobjectDestroy [concrete = constants.%SubobjectDestroy.type]
// CHECK:STDOUT:   %SubobjectDestroy.facet: %SubobjectDestroy.type = facet_value %FinalTriviallyDestructible.ref.loc11, (constants.%custom_witness.fe1) [concrete = constants.%SubobjectDestroy.facet.cda]
// CHECK:STDOUT:   %.loc11: %SubobjectDestroy.type = converted %FinalTriviallyDestructible.ref.loc11, %SubobjectDestroy.facet [concrete = constants.%SubobjectDestroy.facet.cda]
// CHECK:STDOUT:   %Cpp.ref.loc12: <namespace> = name_ref Cpp, imports.%Cpp [concrete = imports.%Cpp]
// CHECK:STDOUT:   %FinalTriviallyDestructible.ref.loc12: type = name_ref FinalTriviallyDestructible, imports.%FinalTriviallyDestructible.decl [concrete = constants.%FinalTriviallyDestructible]
// CHECK:STDOUT:   %Core.ref.loc12: <namespace> = name_ref Core, imports.%Core [concrete = imports.%Core]
// CHECK:STDOUT:   %Destroy.ref: type = name_ref Destroy, imports.%Core.Destroy [concrete = constants.%Destroy.type]
// CHECK:STDOUT:   %Destroy.facet.loc12: %Destroy.type = facet_value %FinalTriviallyDestructible.ref.loc12, (constants.%custom_witness.fe1, constants.%DestroyImpl.impl_witness.de2) [concrete = constants.%Destroy.facet]
// CHECK:STDOUT:   %.loc12: %Destroy.type = converted %FinalTriviallyDestructible.ref.loc12, %Destroy.facet.loc12 [concrete = constants.%Destroy.facet]
// CHECK:STDOUT:   %Cpp.ref.loc13: <namespace> = name_ref Cpp, imports.%Cpp [concrete = imports.%Cpp]
// CHECK:STDOUT:   %FinalTriviallyDestructible.ref.loc13: type = name_ref FinalTriviallyDestructible, imports.%FinalTriviallyDestructible.decl [concrete = constants.%FinalTriviallyDestructible]
// CHECK:STDOUT:   %Core.ref.loc13: <namespace> = name_ref Core, imports.%Core [concrete = imports.%Core]
// CHECK:STDOUT:   %DynamicDestroy.ref: type = name_ref DynamicDestroy, imports.%Core.DynamicDestroy [concrete = constants.%DynamicDestroy.type]
// CHECK:STDOUT:   %DynamicDestroy.facet: %DynamicDestroy.type = facet_value %FinalTriviallyDestructible.ref.loc13, (constants.%custom_witness.fe1, constants.%DestroyImpl.impl_witness.de2, constants.%custom_witness.0b5) [concrete = constants.%DynamicDestroy.facet]
// CHECK:STDOUT:   %.loc13: %DynamicDestroy.type = converted %FinalTriviallyDestructible.ref.loc13, %DynamicDestroy.facet [concrete = constants.%DynamicDestroy.facet]
// CHECK:STDOUT:   %x.var: ref %FinalTriviallyDestructible = var_storage %x.var_patt
// CHECK:STDOUT:   %Make.ref: %Make.type = name_ref Make, file.%Make.decl [concrete = constants.%Make]
// CHECK:STDOUT:   %.loc15_3.1: ref %FinalTriviallyDestructible = splice_block %x.var {}
// CHECK:STDOUT:   %Make.call: init %FinalTriviallyDestructible to %.loc15_3.1 = call %Make.ref()
// CHECK:STDOUT:   assign %x.var, %Make.call
// CHECK:STDOUT:   %.loc15_20: type = splice_block %FinalTriviallyDestructible.ref.loc15 [concrete = constants.%FinalTriviallyDestructible] {
// CHECK:STDOUT:     %Cpp.ref.loc15: <namespace> = name_ref Cpp, imports.%Cpp [concrete = imports.%Cpp]
// CHECK:STDOUT:     %FinalTriviallyDestructible.ref.loc15: type = name_ref FinalTriviallyDestructible, imports.%FinalTriviallyDestructible.decl [concrete = constants.%FinalTriviallyDestructible]
// CHECK:STDOUT:   }
// CHECK:STDOUT:   %x: ref %FinalTriviallyDestructible = wrapper_binding x, %x.var
// CHECK:STDOUT:   name_binding_decl {
// CHECK:STDOUT:     %x.patt: %pattern_type.9b8 = ref_binding_pattern x [concrete = constants.%x.patt]
// CHECK:STDOUT:     %x.var_patt: %pattern_type.9b8 = var_pattern %x.patt [concrete = constants.%x.var_patt]
// CHECK:STDOUT:   }
// CHECK:STDOUT:   %Destroy.facet.loc15_3.1: %Destroy.type = facet_value constants.%FinalTriviallyDestructible, (constants.%custom_witness.fe1, constants.%DestroyImpl.impl_witness.de2) [concrete = constants.%Destroy.facet]
// CHECK:STDOUT:   %.loc15_3.2: %Destroy.type = converted constants.%FinalTriviallyDestructible, %Destroy.facet.loc15_3.1 [concrete = constants.%Destroy.facet]
// CHECK:STDOUT:   %Destroy.facet.loc15_3.2: %Destroy.type = facet_value constants.%FinalTriviallyDestructible, (constants.%custom_witness.fe1, constants.%DestroyImpl.impl_witness.de2) [concrete = constants.%Destroy.facet]
// CHECK:STDOUT:   %.loc15_3.3: %Destroy.type = converted constants.%FinalTriviallyDestructible, %Destroy.facet.loc15_3.2 [concrete = constants.%Destroy.facet]
// CHECK:STDOUT:   <elided>
// CHECK:STDOUT:   %SelfDestruct.call: init %empty_tuple.type = call %SelfDestruct.specific_fn(%x.var)
// CHECK:STDOUT:   <elided>
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: --- todo_dynamic_cpp_final_non_trivial_destructor.carbon = $todo_dynamic_cpp_final_non_trivial_destructor
// CHECK:STDOUT:
// CHECK:STDOUT: constants {
// CHECK:STDOUT:   type: type = facet_type <type> [concrete]
// CHECK:STDOUT:   %FinalNonTriviallyDestructible: type = class_type @FinalNonTriviallyDestructible [concrete]
// CHECK:STDOUT:   %pattern_type.e4a: type = pattern_type %FinalNonTriviallyDestructible [concrete]
// CHECK:STDOUT:   %Make.type: type = fn_type @Make [concrete]
// CHECK:STDOUT:   %empty_tuple.type: type = tuple_type () [concrete]
// CHECK:STDOUT:   %Make: %Make.type = struct_value () [concrete]
// CHECK:STDOUT:   %SubobjectDestroy.type: type = facet_type <@SubobjectDestroy> [concrete]
// CHECK:STDOUT:   %DestroyImpl.type: type = facet_type <@DestroyImpl> [concrete]
// CHECK:STDOUT:   %FinalNonTriviallyDestructible.cpp_destructor.type: type = fn_type @FinalNonTriviallyDestructible.cpp_destructor [concrete]
// CHECK:STDOUT:   %FinalNonTriviallyDestructible.cpp_destructor: %FinalNonTriviallyDestructible.cpp_destructor.type = struct_value () [concrete]
// CHECK:STDOUT:   %custom_witness.fe1: <witness> = custom_witness (%FinalNonTriviallyDestructible.cpp_destructor), @SubobjectDestroy [concrete]
// CHECK:STDOUT:   %SubobjectDestroy.facet.fd8: %SubobjectDestroy.type = facet_value %FinalNonTriviallyDestructible, (%custom_witness.fe1) [concrete]
// CHECK:STDOUT:   %Destroy.type: type = facet_type <@Destroy> [concrete]
// CHECK:STDOUT:   %T.09f: %SubobjectDestroy.type = symbolic_binding T, 0 [symbolic]
// CHECK:STDOUT:   %T.as_type.as.DestroyImpl.impl.Op.type.dea: type = fn_type @T.as_type.as.DestroyImpl.impl.Op, @T.as_type.as.DestroyImpl.impl(%T.09f) [symbolic]
// CHECK:STDOUT:   %T.as_type.as.DestroyImpl.impl.Op.6e5: %T.as_type.as.DestroyImpl.impl.Op.type.dea = struct_value () [symbolic]
// CHECK:STDOUT:   %DestroyImpl.impl_witness.1b6: <witness> = impl_witness imports.%DestroyImpl.impl_witness_table, @T.as_type.as.DestroyImpl.impl(%SubobjectDestroy.facet.fd8) [concrete]
// CHECK:STDOUT:   %Destroy.facet: %Destroy.type = facet_value %FinalNonTriviallyDestructible, (%custom_witness.fe1, %DestroyImpl.impl_witness.1b6) [concrete]
// CHECK:STDOUT:   %DynamicDestroy.type: type = facet_type <@DynamicDestroy> [concrete]
// CHECK:STDOUT:   %custom_witness.0b5: <witness> = custom_witness (), @DynamicDestroyImpl [concrete]
// CHECK:STDOUT:   %DynamicDestroy.facet: %DynamicDestroy.type = facet_value %FinalNonTriviallyDestructible, (%custom_witness.fe1, %DestroyImpl.impl_witness.1b6, %custom_witness.0b5) [concrete]
// CHECK:STDOUT:   %x.patt: %pattern_type.e4a = ref_binding_pattern x [concrete]
// CHECK:STDOUT:   %x.var_patt: %pattern_type.e4a = var_pattern %x.patt [concrete]
// CHECK:STDOUT:   %SelfDestruct.type: type = fn_type @SelfDestruct [concrete]
// CHECK:STDOUT:   %SelfDestruct: %SelfDestruct.type = struct_value () [concrete]
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: imports {
// CHECK:STDOUT:   %Core: <namespace> = namespace file.%Core.import, [concrete] {
// CHECK:STDOUT:     .SubobjectDestroy = %Core.SubobjectDestroy
// CHECK:STDOUT:     .DestroyImpl = %Core.DestroyImpl
// CHECK:STDOUT:     .Destroy = %Core.Destroy
// CHECK:STDOUT:     .DynamicDestroy = %Core.DynamicDestroy
// CHECK:STDOUT:     .SelfDestruct = %Core.SelfDestruct
// CHECK:STDOUT:     import Core//prelude
// CHECK:STDOUT:     import Core//prelude/...
// CHECK:STDOUT:   }
// CHECK:STDOUT:   %Cpp: <namespace> = namespace file.%Cpp.import_cpp, [concrete] {
// CHECK:STDOUT:     .FinalNonTriviallyDestructible = %FinalNonTriviallyDestructible.decl
// CHECK:STDOUT:     import Cpp//...
// CHECK:STDOUT:   }
// CHECK:STDOUT:   %FinalNonTriviallyDestructible.decl: type = class_decl @FinalNonTriviallyDestructible [concrete = constants.%FinalNonTriviallyDestructible] {} {}
// CHECK:STDOUT:   %Core.SubobjectDestroy: type = import_ref Core//prelude/parts/destroy, SubobjectDestroy, loaded [concrete = constants.%SubobjectDestroy.type]
// CHECK:STDOUT:   %Core.DestroyImpl: type = import_ref Core//prelude/parts/destroy, DestroyImpl, loaded [concrete = constants.%DestroyImpl.type]
// CHECK:STDOUT:   %Core.Destroy: type = import_ref Core//prelude/parts/destroy, Destroy, loaded [concrete = constants.%Destroy.type]
// CHECK:STDOUT:   %Core.import_ref.74d: @T.as_type.as.DestroyImpl.impl.%T.as_type.as.DestroyImpl.impl.Op.type (%T.as_type.as.DestroyImpl.impl.Op.type.dea) = import_ref Core//prelude/parts/destroy, loc{{\d+_\d+}}, loaded [symbolic = @T.as_type.as.DestroyImpl.impl.%T.as_type.as.DestroyImpl.impl.Op (constants.%T.as_type.as.DestroyImpl.impl.Op.6e5)]
// CHECK:STDOUT:   %DestroyImpl.impl_witness_table = impl_witness_table (%Core.import_ref.74d), @T.as_type.as.DestroyImpl.impl [concrete]
// CHECK:STDOUT:   %Core.DynamicDestroy: type = import_ref Core//prelude/parts/destroy, DynamicDestroy, loaded [concrete = constants.%DynamicDestroy.type]
// CHECK:STDOUT:   %Core.SelfDestruct: %SelfDestruct.type = import_ref Core//prelude/parts/destroy, SelfDestruct, loaded [concrete = constants.%SelfDestruct]
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: fn @Test() {
// CHECK:STDOUT: !entry:
// CHECK:STDOUT:   %Cpp.ref.loc13: <namespace> = name_ref Cpp, imports.%Cpp [concrete = imports.%Cpp]
// CHECK:STDOUT:   %FinalNonTriviallyDestructible.ref.loc13: type = name_ref FinalNonTriviallyDestructible, imports.%FinalNonTriviallyDestructible.decl [concrete = constants.%FinalNonTriviallyDestructible]
// CHECK:STDOUT:   %Core.ref.loc13: <namespace> = name_ref Core, imports.%Core [concrete = imports.%Core]
// CHECK:STDOUT:   %SubobjectDestroy.ref: type = name_ref SubobjectDestroy, imports.%Core.SubobjectDestroy [concrete = constants.%SubobjectDestroy.type]
// CHECK:STDOUT:   %SubobjectDestroy.facet: %SubobjectDestroy.type = facet_value %FinalNonTriviallyDestructible.ref.loc13, (constants.%custom_witness.fe1) [concrete = constants.%SubobjectDestroy.facet.fd8]
// CHECK:STDOUT:   %.loc13: %SubobjectDestroy.type = converted %FinalNonTriviallyDestructible.ref.loc13, %SubobjectDestroy.facet [concrete = constants.%SubobjectDestroy.facet.fd8]
// CHECK:STDOUT:   %Cpp.ref.loc14: <namespace> = name_ref Cpp, imports.%Cpp [concrete = imports.%Cpp]
// CHECK:STDOUT:   %FinalNonTriviallyDestructible.ref.loc14: type = name_ref FinalNonTriviallyDestructible, imports.%FinalNonTriviallyDestructible.decl [concrete = constants.%FinalNonTriviallyDestructible]
// CHECK:STDOUT:   %Core.ref.loc14: <namespace> = name_ref Core, imports.%Core [concrete = imports.%Core]
// CHECK:STDOUT:   %Destroy.ref: type = name_ref Destroy, imports.%Core.Destroy [concrete = constants.%Destroy.type]
// CHECK:STDOUT:   %Destroy.facet.loc14: %Destroy.type = facet_value %FinalNonTriviallyDestructible.ref.loc14, (constants.%custom_witness.fe1, constants.%DestroyImpl.impl_witness.1b6) [concrete = constants.%Destroy.facet]
// CHECK:STDOUT:   %.loc14: %Destroy.type = converted %FinalNonTriviallyDestructible.ref.loc14, %Destroy.facet.loc14 [concrete = constants.%Destroy.facet]
// CHECK:STDOUT:   %Cpp.ref.loc15: <namespace> = name_ref Cpp, imports.%Cpp [concrete = imports.%Cpp]
// CHECK:STDOUT:   %FinalNonTriviallyDestructible.ref.loc15: type = name_ref FinalNonTriviallyDestructible, imports.%FinalNonTriviallyDestructible.decl [concrete = constants.%FinalNonTriviallyDestructible]
// CHECK:STDOUT:   %Core.ref.loc15: <namespace> = name_ref Core, imports.%Core [concrete = imports.%Core]
// CHECK:STDOUT:   %DynamicDestroy.ref: type = name_ref DynamicDestroy, imports.%Core.DynamicDestroy [concrete = constants.%DynamicDestroy.type]
// CHECK:STDOUT:   %DynamicDestroy.facet: %DynamicDestroy.type = facet_value %FinalNonTriviallyDestructible.ref.loc15, (constants.%custom_witness.fe1, constants.%DestroyImpl.impl_witness.1b6, constants.%custom_witness.0b5) [concrete = constants.%DynamicDestroy.facet]
// CHECK:STDOUT:   %.loc15: %DynamicDestroy.type = converted %FinalNonTriviallyDestructible.ref.loc15, %DynamicDestroy.facet [concrete = constants.%DynamicDestroy.facet]
// CHECK:STDOUT:   %x.var: ref %FinalNonTriviallyDestructible = var_storage %x.var_patt
// CHECK:STDOUT:   %Make.ref: %Make.type = name_ref Make, file.%Make.decl [concrete = constants.%Make]
// CHECK:STDOUT:   %.loc17_3.1: ref %FinalNonTriviallyDestructible = splice_block %x.var {}
// CHECK:STDOUT:   %Make.call: init %FinalNonTriviallyDestructible to %.loc17_3.1 = call %Make.ref()
// CHECK:STDOUT:   assign %x.var, %Make.call
// CHECK:STDOUT:   %.loc17_20: type = splice_block %FinalNonTriviallyDestructible.ref.loc17 [concrete = constants.%FinalNonTriviallyDestructible] {
// CHECK:STDOUT:     %Cpp.ref.loc17: <namespace> = name_ref Cpp, imports.%Cpp [concrete = imports.%Cpp]
// CHECK:STDOUT:     %FinalNonTriviallyDestructible.ref.loc17: type = name_ref FinalNonTriviallyDestructible, imports.%FinalNonTriviallyDestructible.decl [concrete = constants.%FinalNonTriviallyDestructible]
// CHECK:STDOUT:   }
// CHECK:STDOUT:   %x: ref %FinalNonTriviallyDestructible = wrapper_binding x, %x.var
// CHECK:STDOUT:   name_binding_decl {
// CHECK:STDOUT:     %x.patt: %pattern_type.e4a = ref_binding_pattern x [concrete = constants.%x.patt]
// CHECK:STDOUT:     %x.var_patt: %pattern_type.e4a = var_pattern %x.patt [concrete = constants.%x.var_patt]
// CHECK:STDOUT:   }
// CHECK:STDOUT:   %Destroy.facet.loc17_3.1: %Destroy.type = facet_value constants.%FinalNonTriviallyDestructible, (constants.%custom_witness.fe1, constants.%DestroyImpl.impl_witness.1b6) [concrete = constants.%Destroy.facet]
// CHECK:STDOUT:   %.loc17_3.2: %Destroy.type = converted constants.%FinalNonTriviallyDestructible, %Destroy.facet.loc17_3.1 [concrete = constants.%Destroy.facet]
// CHECK:STDOUT:   %Destroy.facet.loc17_3.2: %Destroy.type = facet_value constants.%FinalNonTriviallyDestructible, (constants.%custom_witness.fe1, constants.%DestroyImpl.impl_witness.1b6) [concrete = constants.%Destroy.facet]
// CHECK:STDOUT:   %.loc17_3.3: %Destroy.type = converted constants.%FinalNonTriviallyDestructible, %Destroy.facet.loc17_3.2 [concrete = constants.%Destroy.facet]
// CHECK:STDOUT:   <elided>
// CHECK:STDOUT:   %SelfDestruct.call: init %empty_tuple.type = call %SelfDestruct.specific_fn(%x.var)
// CHECK:STDOUT:   <elided>
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: --- todo_dynamic_cpp_final_virtual_function.carbon = $todo_dynamic_cpp_final_virtual_function
// CHECK:STDOUT:
// CHECK:STDOUT: constants {
// CHECK:STDOUT:   type: type = facet_type <type> [concrete]
// CHECK:STDOUT:   %FinalVirtualFunction: type = class_type @FinalVirtualFunction [concrete]
// CHECK:STDOUT:   %pattern_type.ced: type = pattern_type %FinalVirtualFunction [concrete]
// CHECK:STDOUT:   %Make.type: type = fn_type @Make [concrete]
// CHECK:STDOUT:   %empty_tuple.type: type = tuple_type () [concrete]
// CHECK:STDOUT:   %Make: %Make.type = struct_value () [concrete]
// CHECK:STDOUT:   %SubobjectDestroy.type: type = facet_type <@SubobjectDestroy> [concrete]
// CHECK:STDOUT:   %FinalVirtualFunction.F.type: type = fn_type @FinalVirtualFunction.F [concrete]
// CHECK:STDOUT:   %FinalVirtualFunction.F: %FinalVirtualFunction.F.type = struct_value () [concrete]
// CHECK:STDOUT:   %DestroyImpl.type: type = facet_type <@DestroyImpl> [concrete]
// CHECK:STDOUT:   %FinalVirtualFunction.cpp_destructor.type: type = fn_type @FinalVirtualFunction.cpp_destructor [concrete]
// CHECK:STDOUT:   %FinalVirtualFunction.cpp_destructor: %FinalVirtualFunction.cpp_destructor.type = struct_value () [concrete]
// CHECK:STDOUT:   %custom_witness.fe1: <witness> = custom_witness (%FinalVirtualFunction.cpp_destructor), @SubobjectDestroy [concrete]
// CHECK:STDOUT:   %SubobjectDestroy.facet.bf0: %SubobjectDestroy.type = facet_value %FinalVirtualFunction, (%custom_witness.fe1) [concrete]
// CHECK:STDOUT:   %Destroy.type: type = facet_type <@Destroy> [concrete]
// CHECK:STDOUT:   %T.09f: %SubobjectDestroy.type = symbolic_binding T, 0 [symbolic]
// CHECK:STDOUT:   %T.as_type.as.DestroyImpl.impl.Op.type.dea: type = fn_type @T.as_type.as.DestroyImpl.impl.Op, @T.as_type.as.DestroyImpl.impl(%T.09f) [symbolic]
// CHECK:STDOUT:   %T.as_type.as.DestroyImpl.impl.Op.6e5: %T.as_type.as.DestroyImpl.impl.Op.type.dea = struct_value () [symbolic]
// CHECK:STDOUT:   %DestroyImpl.impl_witness.474: <witness> = impl_witness imports.%DestroyImpl.impl_witness_table, @T.as_type.as.DestroyImpl.impl(%SubobjectDestroy.facet.bf0) [concrete]
// CHECK:STDOUT:   %Destroy.facet: %Destroy.type = facet_value %FinalVirtualFunction, (%custom_witness.fe1, %DestroyImpl.impl_witness.474) [concrete]
// CHECK:STDOUT:   %DynamicDestroy.type: type = facet_type <@DynamicDestroy> [concrete]
// CHECK:STDOUT:   %custom_witness.0b5: <witness> = custom_witness (), @DynamicDestroyImpl [concrete]
// CHECK:STDOUT:   %DynamicDestroy.facet: %DynamicDestroy.type = facet_value %FinalVirtualFunction, (%custom_witness.fe1, %DestroyImpl.impl_witness.474, %custom_witness.0b5) [concrete]
// CHECK:STDOUT:   %x.patt: %pattern_type.ced = ref_binding_pattern x [concrete]
// CHECK:STDOUT:   %x.var_patt: %pattern_type.ced = var_pattern %x.patt [concrete]
// CHECK:STDOUT:   %SelfDestruct.type: type = fn_type @SelfDestruct [concrete]
// CHECK:STDOUT:   %SelfDestruct: %SelfDestruct.type = struct_value () [concrete]
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: imports {
// CHECK:STDOUT:   %Core: <namespace> = namespace file.%Core.import, [concrete] {
// CHECK:STDOUT:     .SubobjectDestroy = %Core.SubobjectDestroy
// CHECK:STDOUT:     .DestroyImpl = %Core.DestroyImpl
// CHECK:STDOUT:     .Destroy = %Core.Destroy
// CHECK:STDOUT:     .DynamicDestroy = %Core.DynamicDestroy
// CHECK:STDOUT:     .SelfDestruct = %Core.SelfDestruct
// CHECK:STDOUT:     import Core//prelude
// CHECK:STDOUT:     import Core//prelude/...
// CHECK:STDOUT:   }
// CHECK:STDOUT:   %Cpp: <namespace> = namespace file.%Cpp.import_cpp, [concrete] {
// CHECK:STDOUT:     .FinalVirtualFunction = %FinalVirtualFunction.decl
// CHECK:STDOUT:     import Cpp//...
// CHECK:STDOUT:   }
// CHECK:STDOUT:   %FinalVirtualFunction.decl: type = class_decl @FinalVirtualFunction [concrete = constants.%FinalVirtualFunction] {} {}
// CHECK:STDOUT:   %Core.SubobjectDestroy: type = import_ref Core//prelude/parts/destroy, SubobjectDestroy, loaded [concrete = constants.%SubobjectDestroy.type]
// CHECK:STDOUT:   %FinalVirtualFunction.F.decl: %FinalVirtualFunction.F.type = fn_decl @FinalVirtualFunction.F [concrete = constants.%FinalVirtualFunction.F] {
// CHECK:STDOUT:     <elided>
// CHECK:STDOUT:   } {
// CHECK:STDOUT:     <elided>
// CHECK:STDOUT:   }
// CHECK:STDOUT:   %Core.DestroyImpl: type = import_ref Core//prelude/parts/destroy, DestroyImpl, loaded [concrete = constants.%DestroyImpl.type]
// CHECK:STDOUT:   %Core.Destroy: type = import_ref Core//prelude/parts/destroy, Destroy, loaded [concrete = constants.%Destroy.type]
// CHECK:STDOUT:   %Core.import_ref.74d: @T.as_type.as.DestroyImpl.impl.%T.as_type.as.DestroyImpl.impl.Op.type (%T.as_type.as.DestroyImpl.impl.Op.type.dea) = import_ref Core//prelude/parts/destroy, loc{{\d+_\d+}}, loaded [symbolic = @T.as_type.as.DestroyImpl.impl.%T.as_type.as.DestroyImpl.impl.Op (constants.%T.as_type.as.DestroyImpl.impl.Op.6e5)]
// CHECK:STDOUT:   %DestroyImpl.impl_witness_table = impl_witness_table (%Core.import_ref.74d), @T.as_type.as.DestroyImpl.impl [concrete]
// CHECK:STDOUT:   %Core.DynamicDestroy: type = import_ref Core//prelude/parts/destroy, DynamicDestroy, loaded [concrete = constants.%DynamicDestroy.type]
// CHECK:STDOUT:   %Core.SelfDestruct: %SelfDestruct.type = import_ref Core//prelude/parts/destroy, SelfDestruct, loaded [concrete = constants.%SelfDestruct]
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: vtable @FinalVirtualFunction.vtable {
// CHECK:STDOUT:   imports.%FinalVirtualFunction.F.decl
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: fn @Test() {
// CHECK:STDOUT: !entry:
// CHECK:STDOUT:   %Cpp.ref.loc13: <namespace> = name_ref Cpp, imports.%Cpp [concrete = imports.%Cpp]
// CHECK:STDOUT:   %FinalVirtualFunction.ref.loc13: type = name_ref FinalVirtualFunction, imports.%FinalVirtualFunction.decl [concrete = constants.%FinalVirtualFunction]
// CHECK:STDOUT:   %Core.ref.loc13: <namespace> = name_ref Core, imports.%Core [concrete = imports.%Core]
// CHECK:STDOUT:   %SubobjectDestroy.ref: type = name_ref SubobjectDestroy, imports.%Core.SubobjectDestroy [concrete = constants.%SubobjectDestroy.type]
// CHECK:STDOUT:   %SubobjectDestroy.facet: %SubobjectDestroy.type = facet_value %FinalVirtualFunction.ref.loc13, (constants.%custom_witness.fe1) [concrete = constants.%SubobjectDestroy.facet.bf0]
// CHECK:STDOUT:   %.loc13: %SubobjectDestroy.type = converted %FinalVirtualFunction.ref.loc13, %SubobjectDestroy.facet [concrete = constants.%SubobjectDestroy.facet.bf0]
// CHECK:STDOUT:   %Cpp.ref.loc14: <namespace> = name_ref Cpp, imports.%Cpp [concrete = imports.%Cpp]
// CHECK:STDOUT:   %FinalVirtualFunction.ref.loc14: type = name_ref FinalVirtualFunction, imports.%FinalVirtualFunction.decl [concrete = constants.%FinalVirtualFunction]
// CHECK:STDOUT:   %Core.ref.loc14: <namespace> = name_ref Core, imports.%Core [concrete = imports.%Core]
// CHECK:STDOUT:   %Destroy.ref: type = name_ref Destroy, imports.%Core.Destroy [concrete = constants.%Destroy.type]
// CHECK:STDOUT:   %Destroy.facet.loc14: %Destroy.type = facet_value %FinalVirtualFunction.ref.loc14, (constants.%custom_witness.fe1, constants.%DestroyImpl.impl_witness.474) [concrete = constants.%Destroy.facet]
// CHECK:STDOUT:   %.loc14: %Destroy.type = converted %FinalVirtualFunction.ref.loc14, %Destroy.facet.loc14 [concrete = constants.%Destroy.facet]
// CHECK:STDOUT:   %Cpp.ref.loc15: <namespace> = name_ref Cpp, imports.%Cpp [concrete = imports.%Cpp]
// CHECK:STDOUT:   %FinalVirtualFunction.ref.loc15: type = name_ref FinalVirtualFunction, imports.%FinalVirtualFunction.decl [concrete = constants.%FinalVirtualFunction]
// CHECK:STDOUT:   %Core.ref.loc15: <namespace> = name_ref Core, imports.%Core [concrete = imports.%Core]
// CHECK:STDOUT:   %DynamicDestroy.ref: type = name_ref DynamicDestroy, imports.%Core.DynamicDestroy [concrete = constants.%DynamicDestroy.type]
// CHECK:STDOUT:   %DynamicDestroy.facet: %DynamicDestroy.type = facet_value %FinalVirtualFunction.ref.loc15, (constants.%custom_witness.fe1, constants.%DestroyImpl.impl_witness.474, constants.%custom_witness.0b5) [concrete = constants.%DynamicDestroy.facet]
// CHECK:STDOUT:   %.loc15: %DynamicDestroy.type = converted %FinalVirtualFunction.ref.loc15, %DynamicDestroy.facet [concrete = constants.%DynamicDestroy.facet]
// CHECK:STDOUT:   %x.var: ref %FinalVirtualFunction = var_storage %x.var_patt
// CHECK:STDOUT:   %Make.ref: %Make.type = name_ref Make, file.%Make.decl [concrete = constants.%Make]
// CHECK:STDOUT:   %.loc17_3.1: ref %FinalVirtualFunction = splice_block %x.var {}
// CHECK:STDOUT:   %Make.call: init %FinalVirtualFunction to %.loc17_3.1 = call %Make.ref()
// CHECK:STDOUT:   assign %x.var, %Make.call
// CHECK:STDOUT:   %.loc17_20: type = splice_block %FinalVirtualFunction.ref.loc17 [concrete = constants.%FinalVirtualFunction] {
// CHECK:STDOUT:     %Cpp.ref.loc17: <namespace> = name_ref Cpp, imports.%Cpp [concrete = imports.%Cpp]
// CHECK:STDOUT:     %FinalVirtualFunction.ref.loc17: type = name_ref FinalVirtualFunction, imports.%FinalVirtualFunction.decl [concrete = constants.%FinalVirtualFunction]
// CHECK:STDOUT:   }
// CHECK:STDOUT:   %x: ref %FinalVirtualFunction = wrapper_binding x, %x.var
// CHECK:STDOUT:   name_binding_decl {
// CHECK:STDOUT:     %x.patt: %pattern_type.ced = ref_binding_pattern x [concrete = constants.%x.patt]
// CHECK:STDOUT:     %x.var_patt: %pattern_type.ced = var_pattern %x.patt [concrete = constants.%x.var_patt]
// CHECK:STDOUT:   }
// CHECK:STDOUT:   %Destroy.facet.loc17_3.1: %Destroy.type = facet_value constants.%FinalVirtualFunction, (constants.%custom_witness.fe1, constants.%DestroyImpl.impl_witness.474) [concrete = constants.%Destroy.facet]
// CHECK:STDOUT:   %.loc17_3.2: %Destroy.type = converted constants.%FinalVirtualFunction, %Destroy.facet.loc17_3.1 [concrete = constants.%Destroy.facet]
// CHECK:STDOUT:   %Destroy.facet.loc17_3.2: %Destroy.type = facet_value constants.%FinalVirtualFunction, (constants.%custom_witness.fe1, constants.%DestroyImpl.impl_witness.474) [concrete = constants.%Destroy.facet]
// CHECK:STDOUT:   %.loc17_3.3: %Destroy.type = converted constants.%FinalVirtualFunction, %Destroy.facet.loc17_3.2 [concrete = constants.%Destroy.facet]
// CHECK:STDOUT:   <elided>
// CHECK:STDOUT:   %SelfDestruct.call: init %empty_tuple.type = call %SelfDestruct.specific_fn(%x.var)
// CHECK:STDOUT:   <elided>
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: --- todo_dynamic_cpp_final_class_template_of_trivial_destruction.carbon = $todo_dynamic_cpp_final_class_template_of_trivial_destruction
// CHECK:STDOUT:
// CHECK:STDOUT: constants {
// CHECK:STDOUT:   type: type = facet_type <type> [concrete]
// CHECK:STDOUT:   %empty_tuple.type: type = tuple_type () [concrete]
// CHECK:STDOUT:   %FinalClassTemplate: type = class_type @FinalClassTemplate [concrete]
// CHECK:STDOUT:   %pattern_type.03a: type = pattern_type %FinalClassTemplate [concrete]
// CHECK:STDOUT:   %Make.type: type = fn_type @Make [concrete]
// CHECK:STDOUT:   %Make: %Make.type = struct_value () [concrete]
// CHECK:STDOUT:   %SubobjectDestroy.type: type = facet_type <@SubobjectDestroy> [concrete]
// CHECK:STDOUT:   %SelfDestruct.type: type = fn_type @SelfDestruct [concrete]
// CHECK:STDOUT:   %SelfDestruct: %SelfDestruct.type = struct_value () [concrete]
// CHECK:STDOUT:   %Destroy.type: type = facet_type <@Destroy> [concrete]
// CHECK:STDOUT:   %DestroyImpl.type: type = facet_type <@DestroyImpl> [concrete]
// CHECK:STDOUT:   %T.09f: %SubobjectDestroy.type = symbolic_binding T, 0 [symbolic]
// CHECK:STDOUT:   %T.as_type.as.DestroyImpl.impl.Op.type.dea: type = fn_type @T.as_type.as.DestroyImpl.impl.Op, @T.as_type.as.DestroyImpl.impl(%T.09f) [symbolic]
// CHECK:STDOUT:   %T.as_type.as.DestroyImpl.impl.Op.6e5: %T.as_type.as.DestroyImpl.impl.Op.type.dea = struct_value () [symbolic]
// CHECK:STDOUT:   %FinalClassTemplate.cpp_destructor.type: type = fn_type @FinalClassTemplate.cpp_destructor [concrete]
// CHECK:STDOUT:   %FinalClassTemplate.cpp_destructor: %FinalClassTemplate.cpp_destructor.type = struct_value () [concrete]
// CHECK:STDOUT:   %custom_witness.fe1: <witness> = custom_witness (%FinalClassTemplate.cpp_destructor), @SubobjectDestroy [concrete]
// CHECK:STDOUT:   %SubobjectDestroy.facet.3ed: %SubobjectDestroy.type = facet_value %FinalClassTemplate, (%custom_witness.fe1) [concrete]
// CHECK:STDOUT:   %DestroyImpl.impl_witness.ccc: <witness> = impl_witness imports.%DestroyImpl.impl_witness_table, @T.as_type.as.DestroyImpl.impl(%SubobjectDestroy.facet.3ed) [concrete]
// CHECK:STDOUT:   %Destroy.facet.ea4: %Destroy.type = facet_value %FinalClassTemplate, (%custom_witness.fe1, %DestroyImpl.impl_witness.ccc) [concrete]
// CHECK:STDOUT:   %DynamicDestroy.type: type = facet_type <@DynamicDestroy> [concrete]
// CHECK:STDOUT:   %custom_witness.0b5: <witness> = custom_witness (), @DynamicDestroyImpl [concrete]
// CHECK:STDOUT:   %DynamicDestroy.facet: %DynamicDestroy.type = facet_value %FinalClassTemplate, (%custom_witness.fe1, %DestroyImpl.impl_witness.ccc, %custom_witness.0b5) [concrete]
// CHECK:STDOUT:   %x.patt: %pattern_type.03a = ref_binding_pattern x [concrete]
// CHECK:STDOUT:   %x.var_patt: %pattern_type.03a = var_pattern %x.patt [concrete]
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: imports {
// CHECK:STDOUT:   %Core: <namespace> = namespace file.%Core.import, [concrete] {
// CHECK:STDOUT:     .SubobjectDestroy = %Core.SubobjectDestroy
// CHECK:STDOUT:     .SelfDestruct = %Core.SelfDestruct
// CHECK:STDOUT:     .DestroyImpl = %Core.DestroyImpl
// CHECK:STDOUT:     .Destroy = %Core.Destroy
// CHECK:STDOUT:     .DynamicDestroy = %Core.DynamicDestroy
// CHECK:STDOUT:     import Core//prelude
// CHECK:STDOUT:     import Core//prelude/...
// CHECK:STDOUT:   }
// CHECK:STDOUT:   %Core.SubobjectDestroy: type = import_ref Core//prelude/parts/destroy, SubobjectDestroy, loaded [concrete = constants.%SubobjectDestroy.type]
// CHECK:STDOUT:   %Core.SelfDestruct: %SelfDestruct.type = import_ref Core//prelude/parts/destroy, SelfDestruct, loaded [concrete = constants.%SelfDestruct]
// CHECK:STDOUT:   %Core.DestroyImpl: type = import_ref Core//prelude/parts/destroy, DestroyImpl, loaded [concrete = constants.%DestroyImpl.type]
// CHECK:STDOUT:   %Core.import_ref.74d: @T.as_type.as.DestroyImpl.impl.%T.as_type.as.DestroyImpl.impl.Op.type (%T.as_type.as.DestroyImpl.impl.Op.type.dea) = import_ref Core//prelude/parts/destroy, loc{{\d+_\d+}}, loaded [symbolic = @T.as_type.as.DestroyImpl.impl.%T.as_type.as.DestroyImpl.impl.Op (constants.%T.as_type.as.DestroyImpl.impl.Op.6e5)]
// CHECK:STDOUT:   %DestroyImpl.impl_witness_table = impl_witness_table (%Core.import_ref.74d), @T.as_type.as.DestroyImpl.impl [concrete]
// CHECK:STDOUT:   %Core.Destroy: type = import_ref Core//prelude/parts/destroy, Destroy, loaded [concrete = constants.%Destroy.type]
// CHECK:STDOUT:   %Core.DynamicDestroy: type = import_ref Core//prelude/parts/destroy, DynamicDestroy, loaded [concrete = constants.%DynamicDestroy.type]
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: fn @Test() {
// CHECK:STDOUT: !entry:
// CHECK:STDOUT:   %FinalClassTemplate.ref.loc16: type = name_ref FinalClassTemplate, file.%FinalClassTemplate [concrete = constants.%FinalClassTemplate]
// CHECK:STDOUT:   %Core.ref.loc16: <namespace> = name_ref Core, imports.%Core [concrete = imports.%Core]
// CHECK:STDOUT:   %SubobjectDestroy.ref: type = name_ref SubobjectDestroy, imports.%Core.SubobjectDestroy [concrete = constants.%SubobjectDestroy.type]
// CHECK:STDOUT:   %SubobjectDestroy.facet: %SubobjectDestroy.type = facet_value %FinalClassTemplate.ref.loc16, (constants.%custom_witness.fe1) [concrete = constants.%SubobjectDestroy.facet.3ed]
// CHECK:STDOUT:   %.loc16: %SubobjectDestroy.type = converted %FinalClassTemplate.ref.loc16, %SubobjectDestroy.facet [concrete = constants.%SubobjectDestroy.facet.3ed]
// CHECK:STDOUT:   %FinalClassTemplate.ref.loc17: type = name_ref FinalClassTemplate, file.%FinalClassTemplate [concrete = constants.%FinalClassTemplate]
// CHECK:STDOUT:   %Core.ref.loc17: <namespace> = name_ref Core, imports.%Core [concrete = imports.%Core]
// CHECK:STDOUT:   %Destroy.ref: type = name_ref Destroy, imports.%Core.Destroy [concrete = constants.%Destroy.type]
// CHECK:STDOUT:   %Destroy.facet.loc17: %Destroy.type = facet_value %FinalClassTemplate.ref.loc17, (constants.%custom_witness.fe1, constants.%DestroyImpl.impl_witness.ccc) [concrete = constants.%Destroy.facet.ea4]
// CHECK:STDOUT:   %.loc17: %Destroy.type = converted %FinalClassTemplate.ref.loc17, %Destroy.facet.loc17 [concrete = constants.%Destroy.facet.ea4]
// CHECK:STDOUT:   %FinalClassTemplate.ref.loc18: type = name_ref FinalClassTemplate, file.%FinalClassTemplate [concrete = constants.%FinalClassTemplate]
// CHECK:STDOUT:   %Core.ref.loc18: <namespace> = name_ref Core, imports.%Core [concrete = imports.%Core]
// CHECK:STDOUT:   %DynamicDestroy.ref: type = name_ref DynamicDestroy, imports.%Core.DynamicDestroy [concrete = constants.%DynamicDestroy.type]
// CHECK:STDOUT:   %DynamicDestroy.facet: %DynamicDestroy.type = facet_value %FinalClassTemplate.ref.loc18, (constants.%custom_witness.fe1, constants.%DestroyImpl.impl_witness.ccc, constants.%custom_witness.0b5) [concrete = constants.%DynamicDestroy.facet]
// CHECK:STDOUT:   %.loc18: %DynamicDestroy.type = converted %FinalClassTemplate.ref.loc18, %DynamicDestroy.facet [concrete = constants.%DynamicDestroy.facet]
// CHECK:STDOUT:   %x.var: ref %FinalClassTemplate = var_storage %x.var_patt
// CHECK:STDOUT:   %Make.ref: %Make.type = name_ref Make, file.%Make.decl [concrete = constants.%Make]
// CHECK:STDOUT:   %.loc20_3.1: ref %FinalClassTemplate = splice_block %x.var {}
// CHECK:STDOUT:   %Make.call: init %FinalClassTemplate to %.loc20_3.1 = call %Make.ref()
// CHECK:STDOUT:   assign %x.var, %Make.call
// CHECK:STDOUT:   %FinalClassTemplate.ref.loc20: type = name_ref FinalClassTemplate, file.%FinalClassTemplate [concrete = constants.%FinalClassTemplate]
// CHECK:STDOUT:   %x: ref %FinalClassTemplate = wrapper_binding x, %x.var
// CHECK:STDOUT:   name_binding_decl {
// CHECK:STDOUT:     %x.patt: %pattern_type.03a = ref_binding_pattern x [concrete = constants.%x.patt]
// CHECK:STDOUT:     %x.var_patt: %pattern_type.03a = var_pattern %x.patt [concrete = constants.%x.var_patt]
// CHECK:STDOUT:   }
// CHECK:STDOUT:   %Destroy.facet.loc20_3.1: %Destroy.type = facet_value constants.%FinalClassTemplate, (constants.%custom_witness.fe1, constants.%DestroyImpl.impl_witness.ccc) [concrete = constants.%Destroy.facet.ea4]
// CHECK:STDOUT:   %.loc20_3.2: %Destroy.type = converted constants.%FinalClassTemplate, %Destroy.facet.loc20_3.1 [concrete = constants.%Destroy.facet.ea4]
// CHECK:STDOUT:   %Destroy.facet.loc20_3.2: %Destroy.type = facet_value constants.%FinalClassTemplate, (constants.%custom_witness.fe1, constants.%DestroyImpl.impl_witness.ccc) [concrete = constants.%Destroy.facet.ea4]
// CHECK:STDOUT:   %.loc20_3.3: %Destroy.type = converted constants.%FinalClassTemplate, %Destroy.facet.loc20_3.2 [concrete = constants.%Destroy.facet.ea4]
// CHECK:STDOUT:   <elided>
// CHECK:STDOUT:   %SelfDestruct.call: init %empty_tuple.type = call %SelfDestruct.specific_fn(%x.var)
// CHECK:STDOUT:   <elided>
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: --- todo_dynamic_cpp_virtual_destructor.carbon = $todo_dynamic_cpp_virtual_destructor
// CHECK:STDOUT:
// CHECK:STDOUT: constants {
// CHECK:STDOUT:   type: type = facet_type <type> [concrete]
// CHECK:STDOUT:   %VirtualDestructor: type = class_type @VirtualDestructor [concrete]
// CHECK:STDOUT:   %pattern_type.650: type = pattern_type %VirtualDestructor [concrete]
// CHECK:STDOUT:   %Make.type: type = fn_type @Make [concrete]
// CHECK:STDOUT:   %empty_tuple.type: type = tuple_type () [concrete]
// CHECK:STDOUT:   %Make: %Make.type = struct_value () [concrete]
// CHECK:STDOUT:   %SubobjectDestroy.type: type = facet_type <@SubobjectDestroy> [concrete]
// CHECK:STDOUT:   %DestroyImpl.type: type = facet_type <@DestroyImpl> [concrete]
// CHECK:STDOUT:   %VirtualDestructor.cpp_destructor.type: type = fn_type @VirtualDestructor.cpp_destructor [concrete]
// CHECK:STDOUT:   %VirtualDestructor.cpp_destructor: %VirtualDestructor.cpp_destructor.type = struct_value () [concrete]
// CHECK:STDOUT:   %custom_witness.fe1: <witness> = custom_witness (%VirtualDestructor.cpp_destructor), @SubobjectDestroy [concrete]
// CHECK:STDOUT:   %SubobjectDestroy.facet.0a0: %SubobjectDestroy.type = facet_value %VirtualDestructor, (%custom_witness.fe1) [concrete]
// CHECK:STDOUT:   %Destroy.type: type = facet_type <@Destroy> [concrete]
// CHECK:STDOUT:   %T.09f: %SubobjectDestroy.type = symbolic_binding T, 0 [symbolic]
// CHECK:STDOUT:   %T.as_type.as.DestroyImpl.impl.Op.type.dea: type = fn_type @T.as_type.as.DestroyImpl.impl.Op, @T.as_type.as.DestroyImpl.impl(%T.09f) [symbolic]
// CHECK:STDOUT:   %T.as_type.as.DestroyImpl.impl.Op.6e5: %T.as_type.as.DestroyImpl.impl.Op.type.dea = struct_value () [symbolic]
// CHECK:STDOUT:   %DestroyImpl.impl_witness.05b: <witness> = impl_witness imports.%DestroyImpl.impl_witness_table, @T.as_type.as.DestroyImpl.impl(%SubobjectDestroy.facet.0a0) [concrete]
// CHECK:STDOUT:   %Destroy.facet: %Destroy.type = facet_value %VirtualDestructor, (%custom_witness.fe1, %DestroyImpl.impl_witness.05b) [concrete]
// CHECK:STDOUT:   %DynamicDestroy.type: type = facet_type <@DynamicDestroy> [concrete]
// CHECK:STDOUT:   %custom_witness.0b5: <witness> = custom_witness (), @DynamicDestroyImpl [concrete]
// CHECK:STDOUT:   %DynamicDestroy.facet: %DynamicDestroy.type = facet_value %VirtualDestructor, (%custom_witness.fe1, %DestroyImpl.impl_witness.05b, %custom_witness.0b5) [concrete]
// CHECK:STDOUT:   %x.patt: %pattern_type.650 = ref_binding_pattern x [concrete]
// CHECK:STDOUT:   %x.var_patt: %pattern_type.650 = var_pattern %x.patt [concrete]
// CHECK:STDOUT:   %SelfDestruct.type: type = fn_type @SelfDestruct [concrete]
// CHECK:STDOUT:   %SelfDestruct: %SelfDestruct.type = struct_value () [concrete]
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: imports {
// CHECK:STDOUT:   %Core: <namespace> = namespace file.%Core.import, [concrete] {
// CHECK:STDOUT:     .SubobjectDestroy = %Core.SubobjectDestroy
// CHECK:STDOUT:     .DestroyImpl = %Core.DestroyImpl
// CHECK:STDOUT:     .Destroy = %Core.Destroy
// CHECK:STDOUT:     .DynamicDestroy = %Core.DynamicDestroy
// CHECK:STDOUT:     .SelfDestruct = %Core.SelfDestruct
// CHECK:STDOUT:     import Core//prelude
// CHECK:STDOUT:     import Core//prelude/...
// CHECK:STDOUT:   }
// CHECK:STDOUT:   %Cpp: <namespace> = namespace file.%Cpp.import_cpp, [concrete] {
// CHECK:STDOUT:     .VirtualDestructor = %VirtualDestructor.decl
// CHECK:STDOUT:     import Cpp//...
// CHECK:STDOUT:   }
// CHECK:STDOUT:   %VirtualDestructor.decl: type = class_decl @VirtualDestructor [concrete = constants.%VirtualDestructor] {} {}
// CHECK:STDOUT:   %Core.SubobjectDestroy: type = import_ref Core//prelude/parts/destroy, SubobjectDestroy, loaded [concrete = constants.%SubobjectDestroy.type]
// CHECK:STDOUT:   %Core.DestroyImpl: type = import_ref Core//prelude/parts/destroy, DestroyImpl, loaded [concrete = constants.%DestroyImpl.type]
// CHECK:STDOUT:   %Core.Destroy: type = import_ref Core//prelude/parts/destroy, Destroy, loaded [concrete = constants.%Destroy.type]
// CHECK:STDOUT:   %Core.import_ref.74d: @T.as_type.as.DestroyImpl.impl.%T.as_type.as.DestroyImpl.impl.Op.type (%T.as_type.as.DestroyImpl.impl.Op.type.dea) = import_ref Core//prelude/parts/destroy, loc{{\d+_\d+}}, loaded [symbolic = @T.as_type.as.DestroyImpl.impl.%T.as_type.as.DestroyImpl.impl.Op (constants.%T.as_type.as.DestroyImpl.impl.Op.6e5)]
// CHECK:STDOUT:   %DestroyImpl.impl_witness_table = impl_witness_table (%Core.import_ref.74d), @T.as_type.as.DestroyImpl.impl [concrete]
// CHECK:STDOUT:   %Core.DynamicDestroy: type = import_ref Core//prelude/parts/destroy, DynamicDestroy, loaded [concrete = constants.%DynamicDestroy.type]
// CHECK:STDOUT:   %Core.SelfDestruct: %SelfDestruct.type = import_ref Core//prelude/parts/destroy, SelfDestruct, loaded [concrete = constants.%SelfDestruct]
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: vtable @VirtualDestructor.vtable {}
// CHECK:STDOUT:
// CHECK:STDOUT: fn @Test() {
// CHECK:STDOUT: !entry:
// CHECK:STDOUT:   %Cpp.ref.loc9: <namespace> = name_ref Cpp, imports.%Cpp [concrete = imports.%Cpp]
// CHECK:STDOUT:   %VirtualDestructor.ref.loc9: type = name_ref VirtualDestructor, imports.%VirtualDestructor.decl [concrete = constants.%VirtualDestructor]
// CHECK:STDOUT:   %Core.ref.loc9: <namespace> = name_ref Core, imports.%Core [concrete = imports.%Core]
// CHECK:STDOUT:   %SubobjectDestroy.ref: type = name_ref SubobjectDestroy, imports.%Core.SubobjectDestroy [concrete = constants.%SubobjectDestroy.type]
// CHECK:STDOUT:   %SubobjectDestroy.facet: %SubobjectDestroy.type = facet_value %VirtualDestructor.ref.loc9, (constants.%custom_witness.fe1) [concrete = constants.%SubobjectDestroy.facet.0a0]
// CHECK:STDOUT:   %.loc9: %SubobjectDestroy.type = converted %VirtualDestructor.ref.loc9, %SubobjectDestroy.facet [concrete = constants.%SubobjectDestroy.facet.0a0]
// CHECK:STDOUT:   %Cpp.ref.loc10: <namespace> = name_ref Cpp, imports.%Cpp [concrete = imports.%Cpp]
// CHECK:STDOUT:   %VirtualDestructor.ref.loc10: type = name_ref VirtualDestructor, imports.%VirtualDestructor.decl [concrete = constants.%VirtualDestructor]
// CHECK:STDOUT:   %Core.ref.loc10: <namespace> = name_ref Core, imports.%Core [concrete = imports.%Core]
// CHECK:STDOUT:   %Destroy.ref: type = name_ref Destroy, imports.%Core.Destroy [concrete = constants.%Destroy.type]
// CHECK:STDOUT:   %Destroy.facet.loc10: %Destroy.type = facet_value %VirtualDestructor.ref.loc10, (constants.%custom_witness.fe1, constants.%DestroyImpl.impl_witness.05b) [concrete = constants.%Destroy.facet]
// CHECK:STDOUT:   %.loc10: %Destroy.type = converted %VirtualDestructor.ref.loc10, %Destroy.facet.loc10 [concrete = constants.%Destroy.facet]
// CHECK:STDOUT:   %Cpp.ref.loc11: <namespace> = name_ref Cpp, imports.%Cpp [concrete = imports.%Cpp]
// CHECK:STDOUT:   %VirtualDestructor.ref.loc11: type = name_ref VirtualDestructor, imports.%VirtualDestructor.decl [concrete = constants.%VirtualDestructor]
// CHECK:STDOUT:   %Core.ref.loc11: <namespace> = name_ref Core, imports.%Core [concrete = imports.%Core]
// CHECK:STDOUT:   %DynamicDestroy.ref: type = name_ref DynamicDestroy, imports.%Core.DynamicDestroy [concrete = constants.%DynamicDestroy.type]
// CHECK:STDOUT:   %DynamicDestroy.facet: %DynamicDestroy.type = facet_value %VirtualDestructor.ref.loc11, (constants.%custom_witness.fe1, constants.%DestroyImpl.impl_witness.05b, constants.%custom_witness.0b5) [concrete = constants.%DynamicDestroy.facet]
// CHECK:STDOUT:   %.loc11: %DynamicDestroy.type = converted %VirtualDestructor.ref.loc11, %DynamicDestroy.facet [concrete = constants.%DynamicDestroy.facet]
// CHECK:STDOUT:   %x.var: ref %VirtualDestructor = var_storage %x.var_patt
// CHECK:STDOUT:   %Make.ref: %Make.type = name_ref Make, file.%Make.decl [concrete = constants.%Make]
// CHECK:STDOUT:   %.loc13_3.1: ref %VirtualDestructor = splice_block %x.var {}
// CHECK:STDOUT:   %Make.call: init %VirtualDestructor to %.loc13_3.1 = call %Make.ref()
// CHECK:STDOUT:   assign %x.var, %Make.call
// CHECK:STDOUT:   %.loc13_20: type = splice_block %VirtualDestructor.ref.loc13 [concrete = constants.%VirtualDestructor] {
// CHECK:STDOUT:     %Cpp.ref.loc13: <namespace> = name_ref Cpp, imports.%Cpp [concrete = imports.%Cpp]
// CHECK:STDOUT:     %VirtualDestructor.ref.loc13: type = name_ref VirtualDestructor, imports.%VirtualDestructor.decl [concrete = constants.%VirtualDestructor]
// CHECK:STDOUT:   }
// CHECK:STDOUT:   %x: ref %VirtualDestructor = wrapper_binding x, %x.var
// CHECK:STDOUT:   name_binding_decl {
// CHECK:STDOUT:     %x.patt: %pattern_type.650 = ref_binding_pattern x [concrete = constants.%x.patt]
// CHECK:STDOUT:     %x.var_patt: %pattern_type.650 = var_pattern %x.patt [concrete = constants.%x.var_patt]
// CHECK:STDOUT:   }
// CHECK:STDOUT:   %Destroy.facet.loc13_3.1: %Destroy.type = facet_value constants.%VirtualDestructor, (constants.%custom_witness.fe1, constants.%DestroyImpl.impl_witness.05b) [concrete = constants.%Destroy.facet]
// CHECK:STDOUT:   %.loc13_3.2: %Destroy.type = converted constants.%VirtualDestructor, %Destroy.facet.loc13_3.1 [concrete = constants.%Destroy.facet]
// CHECK:STDOUT:   %Destroy.facet.loc13_3.2: %Destroy.type = facet_value constants.%VirtualDestructor, (constants.%custom_witness.fe1, constants.%DestroyImpl.impl_witness.05b) [concrete = constants.%Destroy.facet]
// CHECK:STDOUT:   %.loc13_3.3: %Destroy.type = converted constants.%VirtualDestructor, %Destroy.facet.loc13_3.2 [concrete = constants.%Destroy.facet]
// CHECK:STDOUT:   <elided>
// CHECK:STDOUT:   %SelfDestruct.call: init %empty_tuple.type = call %SelfDestruct.specific_fn(%x.var)
// CHECK:STDOUT:   <elided>
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: --- todo_dynamic_cpp_defaulted_virtual_destructor.carbon = $todo_dynamic_cpp_defaulted_virtual_destructor
// CHECK:STDOUT:
// CHECK:STDOUT: constants {
// CHECK:STDOUT:   type: type = facet_type <type> [concrete]
// CHECK:STDOUT:   %DefaultedVirtualDestructor: type = class_type @DefaultedVirtualDestructor [concrete]
// CHECK:STDOUT:   %pattern_type.70b: type = pattern_type %DefaultedVirtualDestructor [concrete]
// CHECK:STDOUT:   %Make.type: type = fn_type @Make [concrete]
// CHECK:STDOUT:   %empty_tuple.type: type = tuple_type () [concrete]
// CHECK:STDOUT:   %Make: %Make.type = struct_value () [concrete]
// CHECK:STDOUT:   %SubobjectDestroy.type: type = facet_type <@SubobjectDestroy> [concrete]
// CHECK:STDOUT:   %DestroyImpl.type: type = facet_type <@DestroyImpl> [concrete]
// CHECK:STDOUT:   %DefaultedVirtualDestructor.cpp_destructor.type: type = fn_type @DefaultedVirtualDestructor.cpp_destructor [concrete]
// CHECK:STDOUT:   %DefaultedVirtualDestructor.cpp_destructor: %DefaultedVirtualDestructor.cpp_destructor.type = struct_value () [concrete]
// CHECK:STDOUT:   %custom_witness.fe1: <witness> = custom_witness (%DefaultedVirtualDestructor.cpp_destructor), @SubobjectDestroy [concrete]
// CHECK:STDOUT:   %SubobjectDestroy.facet.40e: %SubobjectDestroy.type = facet_value %DefaultedVirtualDestructor, (%custom_witness.fe1) [concrete]
// CHECK:STDOUT:   %Destroy.type: type = facet_type <@Destroy> [concrete]
// CHECK:STDOUT:   %T.09f: %SubobjectDestroy.type = symbolic_binding T, 0 [symbolic]
// CHECK:STDOUT:   %T.as_type.as.DestroyImpl.impl.Op.type.dea: type = fn_type @T.as_type.as.DestroyImpl.impl.Op, @T.as_type.as.DestroyImpl.impl(%T.09f) [symbolic]
// CHECK:STDOUT:   %T.as_type.as.DestroyImpl.impl.Op.6e5: %T.as_type.as.DestroyImpl.impl.Op.type.dea = struct_value () [symbolic]
// CHECK:STDOUT:   %DestroyImpl.impl_witness.102: <witness> = impl_witness imports.%DestroyImpl.impl_witness_table, @T.as_type.as.DestroyImpl.impl(%SubobjectDestroy.facet.40e) [concrete]
// CHECK:STDOUT:   %Destroy.facet: %Destroy.type = facet_value %DefaultedVirtualDestructor, (%custom_witness.fe1, %DestroyImpl.impl_witness.102) [concrete]
// CHECK:STDOUT:   %DynamicDestroy.type: type = facet_type <@DynamicDestroy> [concrete]
// CHECK:STDOUT:   %custom_witness.0b5: <witness> = custom_witness (), @DynamicDestroyImpl [concrete]
// CHECK:STDOUT:   %DynamicDestroy.facet: %DynamicDestroy.type = facet_value %DefaultedVirtualDestructor, (%custom_witness.fe1, %DestroyImpl.impl_witness.102, %custom_witness.0b5) [concrete]
// CHECK:STDOUT:   %x.patt: %pattern_type.70b = ref_binding_pattern x [concrete]
// CHECK:STDOUT:   %x.var_patt: %pattern_type.70b = var_pattern %x.patt [concrete]
// CHECK:STDOUT:   %SelfDestruct.type: type = fn_type @SelfDestruct [concrete]
// CHECK:STDOUT:   %SelfDestruct: %SelfDestruct.type = struct_value () [concrete]
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: imports {
// CHECK:STDOUT:   %Core: <namespace> = namespace file.%Core.import, [concrete] {
// CHECK:STDOUT:     .SubobjectDestroy = %Core.SubobjectDestroy
// CHECK:STDOUT:     .DestroyImpl = %Core.DestroyImpl
// CHECK:STDOUT:     .Destroy = %Core.Destroy
// CHECK:STDOUT:     .DynamicDestroy = %Core.DynamicDestroy
// CHECK:STDOUT:     .SelfDestruct = %Core.SelfDestruct
// CHECK:STDOUT:     import Core//prelude
// CHECK:STDOUT:     import Core//prelude/...
// CHECK:STDOUT:   }
// CHECK:STDOUT:   %Cpp: <namespace> = namespace file.%Cpp.import_cpp, [concrete] {
// CHECK:STDOUT:     .DefaultedVirtualDestructor = %DefaultedVirtualDestructor.decl
// CHECK:STDOUT:     import Cpp//...
// CHECK:STDOUT:   }
// CHECK:STDOUT:   %DefaultedVirtualDestructor.decl: type = class_decl @DefaultedVirtualDestructor [concrete = constants.%DefaultedVirtualDestructor] {} {}
// CHECK:STDOUT:   %Core.SubobjectDestroy: type = import_ref Core//prelude/parts/destroy, SubobjectDestroy, loaded [concrete = constants.%SubobjectDestroy.type]
// CHECK:STDOUT:   %Core.DestroyImpl: type = import_ref Core//prelude/parts/destroy, DestroyImpl, loaded [concrete = constants.%DestroyImpl.type]
// CHECK:STDOUT:   %Core.Destroy: type = import_ref Core//prelude/parts/destroy, Destroy, loaded [concrete = constants.%Destroy.type]
// CHECK:STDOUT:   %Core.import_ref.74d: @T.as_type.as.DestroyImpl.impl.%T.as_type.as.DestroyImpl.impl.Op.type (%T.as_type.as.DestroyImpl.impl.Op.type.dea) = import_ref Core//prelude/parts/destroy, loc{{\d+_\d+}}, loaded [symbolic = @T.as_type.as.DestroyImpl.impl.%T.as_type.as.DestroyImpl.impl.Op (constants.%T.as_type.as.DestroyImpl.impl.Op.6e5)]
// CHECK:STDOUT:   %DestroyImpl.impl_witness_table = impl_witness_table (%Core.import_ref.74d), @T.as_type.as.DestroyImpl.impl [concrete]
// CHECK:STDOUT:   %Core.DynamicDestroy: type = import_ref Core//prelude/parts/destroy, DynamicDestroy, loaded [concrete = constants.%DynamicDestroy.type]
// CHECK:STDOUT:   %Core.SelfDestruct: %SelfDestruct.type = import_ref Core//prelude/parts/destroy, SelfDestruct, loaded [concrete = constants.%SelfDestruct]
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: vtable @DefaultedVirtualDestructor.vtable {}
// CHECK:STDOUT:
// CHECK:STDOUT: fn @Test() {
// CHECK:STDOUT: !entry:
// CHECK:STDOUT:   %Cpp.ref.loc13: <namespace> = name_ref Cpp, imports.%Cpp [concrete = imports.%Cpp]
// CHECK:STDOUT:   %DefaultedVirtualDestructor.ref.loc13: type = name_ref DefaultedVirtualDestructor, imports.%DefaultedVirtualDestructor.decl [concrete = constants.%DefaultedVirtualDestructor]
// CHECK:STDOUT:   %Core.ref.loc13: <namespace> = name_ref Core, imports.%Core [concrete = imports.%Core]
// CHECK:STDOUT:   %SubobjectDestroy.ref: type = name_ref SubobjectDestroy, imports.%Core.SubobjectDestroy [concrete = constants.%SubobjectDestroy.type]
// CHECK:STDOUT:   %SubobjectDestroy.facet: %SubobjectDestroy.type = facet_value %DefaultedVirtualDestructor.ref.loc13, (constants.%custom_witness.fe1) [concrete = constants.%SubobjectDestroy.facet.40e]
// CHECK:STDOUT:   %.loc13: %SubobjectDestroy.type = converted %DefaultedVirtualDestructor.ref.loc13, %SubobjectDestroy.facet [concrete = constants.%SubobjectDestroy.facet.40e]
// CHECK:STDOUT:   %Cpp.ref.loc14: <namespace> = name_ref Cpp, imports.%Cpp [concrete = imports.%Cpp]
// CHECK:STDOUT:   %DefaultedVirtualDestructor.ref.loc14: type = name_ref DefaultedVirtualDestructor, imports.%DefaultedVirtualDestructor.decl [concrete = constants.%DefaultedVirtualDestructor]
// CHECK:STDOUT:   %Core.ref.loc14: <namespace> = name_ref Core, imports.%Core [concrete = imports.%Core]
// CHECK:STDOUT:   %Destroy.ref: type = name_ref Destroy, imports.%Core.Destroy [concrete = constants.%Destroy.type]
// CHECK:STDOUT:   %Destroy.facet.loc14: %Destroy.type = facet_value %DefaultedVirtualDestructor.ref.loc14, (constants.%custom_witness.fe1, constants.%DestroyImpl.impl_witness.102) [concrete = constants.%Destroy.facet]
// CHECK:STDOUT:   %.loc14: %Destroy.type = converted %DefaultedVirtualDestructor.ref.loc14, %Destroy.facet.loc14 [concrete = constants.%Destroy.facet]
// CHECK:STDOUT:   %Cpp.ref.loc15: <namespace> = name_ref Cpp, imports.%Cpp [concrete = imports.%Cpp]
// CHECK:STDOUT:   %DefaultedVirtualDestructor.ref.loc15: type = name_ref DefaultedVirtualDestructor, imports.%DefaultedVirtualDestructor.decl [concrete = constants.%DefaultedVirtualDestructor]
// CHECK:STDOUT:   %Core.ref.loc15: <namespace> = name_ref Core, imports.%Core [concrete = imports.%Core]
// CHECK:STDOUT:   %DynamicDestroy.ref: type = name_ref DynamicDestroy, imports.%Core.DynamicDestroy [concrete = constants.%DynamicDestroy.type]
// CHECK:STDOUT:   %DynamicDestroy.facet: %DynamicDestroy.type = facet_value %DefaultedVirtualDestructor.ref.loc15, (constants.%custom_witness.fe1, constants.%DestroyImpl.impl_witness.102, constants.%custom_witness.0b5) [concrete = constants.%DynamicDestroy.facet]
// CHECK:STDOUT:   %.loc15: %DynamicDestroy.type = converted %DefaultedVirtualDestructor.ref.loc15, %DynamicDestroy.facet [concrete = constants.%DynamicDestroy.facet]
// CHECK:STDOUT:   %x.var: ref %DefaultedVirtualDestructor = var_storage %x.var_patt
// CHECK:STDOUT:   %Make.ref: %Make.type = name_ref Make, file.%Make.decl [concrete = constants.%Make]
// CHECK:STDOUT:   %.loc17_3.1: ref %DefaultedVirtualDestructor = splice_block %x.var {}
// CHECK:STDOUT:   %Make.call: init %DefaultedVirtualDestructor to %.loc17_3.1 = call %Make.ref()
// CHECK:STDOUT:   assign %x.var, %Make.call
// CHECK:STDOUT:   %.loc17_20: type = splice_block %DefaultedVirtualDestructor.ref.loc17 [concrete = constants.%DefaultedVirtualDestructor] {
// CHECK:STDOUT:     %Cpp.ref.loc17: <namespace> = name_ref Cpp, imports.%Cpp [concrete = imports.%Cpp]
// CHECK:STDOUT:     %DefaultedVirtualDestructor.ref.loc17: type = name_ref DefaultedVirtualDestructor, imports.%DefaultedVirtualDestructor.decl [concrete = constants.%DefaultedVirtualDestructor]
// CHECK:STDOUT:   }
// CHECK:STDOUT:   %x: ref %DefaultedVirtualDestructor = wrapper_binding x, %x.var
// CHECK:STDOUT:   name_binding_decl {
// CHECK:STDOUT:     %x.patt: %pattern_type.70b = ref_binding_pattern x [concrete = constants.%x.patt]
// CHECK:STDOUT:     %x.var_patt: %pattern_type.70b = var_pattern %x.patt [concrete = constants.%x.var_patt]
// CHECK:STDOUT:   }
// CHECK:STDOUT:   %Destroy.facet.loc17_3.1: %Destroy.type = facet_value constants.%DefaultedVirtualDestructor, (constants.%custom_witness.fe1, constants.%DestroyImpl.impl_witness.102) [concrete = constants.%Destroy.facet]
// CHECK:STDOUT:   %.loc17_3.2: %Destroy.type = converted constants.%DefaultedVirtualDestructor, %Destroy.facet.loc17_3.1 [concrete = constants.%Destroy.facet]
// CHECK:STDOUT:   %Destroy.facet.loc17_3.2: %Destroy.type = facet_value constants.%DefaultedVirtualDestructor, (constants.%custom_witness.fe1, constants.%DestroyImpl.impl_witness.102) [concrete = constants.%Destroy.facet]
// CHECK:STDOUT:   %.loc17_3.3: %Destroy.type = converted constants.%DefaultedVirtualDestructor, %Destroy.facet.loc17_3.2 [concrete = constants.%Destroy.facet]
// CHECK:STDOUT:   <elided>
// CHECK:STDOUT:   %SelfDestruct.call: init %empty_tuple.type = call %SelfDestruct.specific_fn(%x.var)
// CHECK:STDOUT:   <elided>
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: --- todo_dynamic_cpp_derived_from_virtual_destructor.carbon = $todo_dynamic_cpp_derived_from_virtual_destructor
// CHECK:STDOUT:
// CHECK:STDOUT: constants {
// CHECK:STDOUT:   type: type = facet_type <type> [concrete]
// CHECK:STDOUT:   %DerivedFromVirtualDestructor: type = class_type @DerivedFromVirtualDestructor [concrete]
// CHECK:STDOUT:   %pattern_type.89a: type = pattern_type %DerivedFromVirtualDestructor [concrete]
// CHECK:STDOUT:   %Make.type: type = fn_type @Make [concrete]
// CHECK:STDOUT:   %empty_tuple.type: type = tuple_type () [concrete]
// CHECK:STDOUT:   %Make: %Make.type = struct_value () [concrete]
// CHECK:STDOUT:   %SubobjectDestroy.type: type = facet_type <@SubobjectDestroy> [concrete]
// CHECK:STDOUT:   %DestroyImpl.type: type = facet_type <@DestroyImpl> [concrete]
// CHECK:STDOUT:   %DerivedFromVirtualDestructor.cpp_destructor.type: type = fn_type @DerivedFromVirtualDestructor.cpp_destructor [concrete]
// CHECK:STDOUT:   %DerivedFromVirtualDestructor.cpp_destructor: %DerivedFromVirtualDestructor.cpp_destructor.type = struct_value () [concrete]
// CHECK:STDOUT:   %custom_witness.fe1: <witness> = custom_witness (%DerivedFromVirtualDestructor.cpp_destructor), @SubobjectDestroy [concrete]
// CHECK:STDOUT:   %SubobjectDestroy.facet.09e: %SubobjectDestroy.type = facet_value %DerivedFromVirtualDestructor, (%custom_witness.fe1) [concrete]
// CHECK:STDOUT:   %Destroy.type: type = facet_type <@Destroy> [concrete]
// CHECK:STDOUT:   %T.09f: %SubobjectDestroy.type = symbolic_binding T, 0 [symbolic]
// CHECK:STDOUT:   %T.as_type.as.DestroyImpl.impl.Op.type.dea: type = fn_type @T.as_type.as.DestroyImpl.impl.Op, @T.as_type.as.DestroyImpl.impl(%T.09f) [symbolic]
// CHECK:STDOUT:   %T.as_type.as.DestroyImpl.impl.Op.6e5: %T.as_type.as.DestroyImpl.impl.Op.type.dea = struct_value () [symbolic]
// CHECK:STDOUT:   %DestroyImpl.impl_witness.ed5: <witness> = impl_witness imports.%DestroyImpl.impl_witness_table, @T.as_type.as.DestroyImpl.impl(%SubobjectDestroy.facet.09e) [concrete]
// CHECK:STDOUT:   %Destroy.facet: %Destroy.type = facet_value %DerivedFromVirtualDestructor, (%custom_witness.fe1, %DestroyImpl.impl_witness.ed5) [concrete]
// CHECK:STDOUT:   %DynamicDestroy.type: type = facet_type <@DynamicDestroy> [concrete]
// CHECK:STDOUT:   %custom_witness.0b5: <witness> = custom_witness (), @DynamicDestroyImpl [concrete]
// CHECK:STDOUT:   %DynamicDestroy.facet: %DynamicDestroy.type = facet_value %DerivedFromVirtualDestructor, (%custom_witness.fe1, %DestroyImpl.impl_witness.ed5, %custom_witness.0b5) [concrete]
// CHECK:STDOUT:   %x.patt: %pattern_type.89a = ref_binding_pattern x [concrete]
// CHECK:STDOUT:   %x.var_patt: %pattern_type.89a = var_pattern %x.patt [concrete]
// CHECK:STDOUT:   %SelfDestruct.type: type = fn_type @SelfDestruct [concrete]
// CHECK:STDOUT:   %SelfDestruct: %SelfDestruct.type = struct_value () [concrete]
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: imports {
// CHECK:STDOUT:   %Core: <namespace> = namespace file.%Core.import, [concrete] {
// CHECK:STDOUT:     .SubobjectDestroy = %Core.SubobjectDestroy
// CHECK:STDOUT:     .DestroyImpl = %Core.DestroyImpl
// CHECK:STDOUT:     .Destroy = %Core.Destroy
// CHECK:STDOUT:     .DynamicDestroy = %Core.DynamicDestroy
// CHECK:STDOUT:     .SelfDestruct = %Core.SelfDestruct
// CHECK:STDOUT:     import Core//prelude
// CHECK:STDOUT:     import Core//prelude/...
// CHECK:STDOUT:   }
// CHECK:STDOUT:   %Cpp: <namespace> = namespace file.%Cpp.import_cpp, [concrete] {
// CHECK:STDOUT:     .DerivedFromVirtualDestructor = %DerivedFromVirtualDestructor.decl
// CHECK:STDOUT:     import Cpp//...
// CHECK:STDOUT:   }
// CHECK:STDOUT:   %DerivedFromVirtualDestructor.decl: type = class_decl @DerivedFromVirtualDestructor [concrete = constants.%DerivedFromVirtualDestructor] {} {}
// CHECK:STDOUT:   %Core.SubobjectDestroy: type = import_ref Core//prelude/parts/destroy, SubobjectDestroy, loaded [concrete = constants.%SubobjectDestroy.type]
// CHECK:STDOUT:   %Core.DestroyImpl: type = import_ref Core//prelude/parts/destroy, DestroyImpl, loaded [concrete = constants.%DestroyImpl.type]
// CHECK:STDOUT:   %Core.Destroy: type = import_ref Core//prelude/parts/destroy, Destroy, loaded [concrete = constants.%Destroy.type]
// CHECK:STDOUT:   %Core.import_ref.74d: @T.as_type.as.DestroyImpl.impl.%T.as_type.as.DestroyImpl.impl.Op.type (%T.as_type.as.DestroyImpl.impl.Op.type.dea) = import_ref Core//prelude/parts/destroy, loc{{\d+_\d+}}, loaded [symbolic = @T.as_type.as.DestroyImpl.impl.%T.as_type.as.DestroyImpl.impl.Op (constants.%T.as_type.as.DestroyImpl.impl.Op.6e5)]
// CHECK:STDOUT:   %DestroyImpl.impl_witness_table = impl_witness_table (%Core.import_ref.74d), @T.as_type.as.DestroyImpl.impl [concrete]
// CHECK:STDOUT:   %Core.DynamicDestroy: type = import_ref Core//prelude/parts/destroy, DynamicDestroy, loaded [concrete = constants.%DynamicDestroy.type]
// CHECK:STDOUT:   %Core.SelfDestruct: %SelfDestruct.type = import_ref Core//prelude/parts/destroy, SelfDestruct, loaded [concrete = constants.%SelfDestruct]
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: vtable @DerivedFromVirtualDestructor.vtable {}
// CHECK:STDOUT:
// CHECK:STDOUT: vtable @VirtualDestructor.vtable {}
// CHECK:STDOUT:
// CHECK:STDOUT: fn @Test() {
// CHECK:STDOUT: !entry:
// CHECK:STDOUT:   %Cpp.ref.loc13: <namespace> = name_ref Cpp, imports.%Cpp [concrete = imports.%Cpp]
// CHECK:STDOUT:   %DerivedFromVirtualDestructor.ref.loc13: type = name_ref DerivedFromVirtualDestructor, imports.%DerivedFromVirtualDestructor.decl [concrete = constants.%DerivedFromVirtualDestructor]
// CHECK:STDOUT:   %Core.ref.loc13: <namespace> = name_ref Core, imports.%Core [concrete = imports.%Core]
// CHECK:STDOUT:   %SubobjectDestroy.ref: type = name_ref SubobjectDestroy, imports.%Core.SubobjectDestroy [concrete = constants.%SubobjectDestroy.type]
// CHECK:STDOUT:   %SubobjectDestroy.facet: %SubobjectDestroy.type = facet_value %DerivedFromVirtualDestructor.ref.loc13, (constants.%custom_witness.fe1) [concrete = constants.%SubobjectDestroy.facet.09e]
// CHECK:STDOUT:   %.loc13: %SubobjectDestroy.type = converted %DerivedFromVirtualDestructor.ref.loc13, %SubobjectDestroy.facet [concrete = constants.%SubobjectDestroy.facet.09e]
// CHECK:STDOUT:   %Cpp.ref.loc14: <namespace> = name_ref Cpp, imports.%Cpp [concrete = imports.%Cpp]
// CHECK:STDOUT:   %DerivedFromVirtualDestructor.ref.loc14: type = name_ref DerivedFromVirtualDestructor, imports.%DerivedFromVirtualDestructor.decl [concrete = constants.%DerivedFromVirtualDestructor]
// CHECK:STDOUT:   %Core.ref.loc14: <namespace> = name_ref Core, imports.%Core [concrete = imports.%Core]
// CHECK:STDOUT:   %Destroy.ref: type = name_ref Destroy, imports.%Core.Destroy [concrete = constants.%Destroy.type]
// CHECK:STDOUT:   %Destroy.facet.loc14: %Destroy.type = facet_value %DerivedFromVirtualDestructor.ref.loc14, (constants.%custom_witness.fe1, constants.%DestroyImpl.impl_witness.ed5) [concrete = constants.%Destroy.facet]
// CHECK:STDOUT:   %.loc14: %Destroy.type = converted %DerivedFromVirtualDestructor.ref.loc14, %Destroy.facet.loc14 [concrete = constants.%Destroy.facet]
// CHECK:STDOUT:   %Cpp.ref.loc15: <namespace> = name_ref Cpp, imports.%Cpp [concrete = imports.%Cpp]
// CHECK:STDOUT:   %DerivedFromVirtualDestructor.ref.loc15: type = name_ref DerivedFromVirtualDestructor, imports.%DerivedFromVirtualDestructor.decl [concrete = constants.%DerivedFromVirtualDestructor]
// CHECK:STDOUT:   %Core.ref.loc15: <namespace> = name_ref Core, imports.%Core [concrete = imports.%Core]
// CHECK:STDOUT:   %DynamicDestroy.ref: type = name_ref DynamicDestroy, imports.%Core.DynamicDestroy [concrete = constants.%DynamicDestroy.type]
// CHECK:STDOUT:   %DynamicDestroy.facet: %DynamicDestroy.type = facet_value %DerivedFromVirtualDestructor.ref.loc15, (constants.%custom_witness.fe1, constants.%DestroyImpl.impl_witness.ed5, constants.%custom_witness.0b5) [concrete = constants.%DynamicDestroy.facet]
// CHECK:STDOUT:   %.loc15: %DynamicDestroy.type = converted %DerivedFromVirtualDestructor.ref.loc15, %DynamicDestroy.facet [concrete = constants.%DynamicDestroy.facet]
// CHECK:STDOUT:   %x.var: ref %DerivedFromVirtualDestructor = var_storage %x.var_patt
// CHECK:STDOUT:   %Make.ref: %Make.type = name_ref Make, file.%Make.decl [concrete = constants.%Make]
// CHECK:STDOUT:   %.loc17_3.1: ref %DerivedFromVirtualDestructor = splice_block %x.var {}
// CHECK:STDOUT:   %Make.call: init %DerivedFromVirtualDestructor to %.loc17_3.1 = call %Make.ref()
// CHECK:STDOUT:   assign %x.var, %Make.call
// CHECK:STDOUT:   %.loc17_20: type = splice_block %DerivedFromVirtualDestructor.ref.loc17 [concrete = constants.%DerivedFromVirtualDestructor] {
// CHECK:STDOUT:     %Cpp.ref.loc17: <namespace> = name_ref Cpp, imports.%Cpp [concrete = imports.%Cpp]
// CHECK:STDOUT:     %DerivedFromVirtualDestructor.ref.loc17: type = name_ref DerivedFromVirtualDestructor, imports.%DerivedFromVirtualDestructor.decl [concrete = constants.%DerivedFromVirtualDestructor]
// CHECK:STDOUT:   }
// CHECK:STDOUT:   %x: ref %DerivedFromVirtualDestructor = wrapper_binding x, %x.var
// CHECK:STDOUT:   name_binding_decl {
// CHECK:STDOUT:     %x.patt: %pattern_type.89a = ref_binding_pattern x [concrete = constants.%x.patt]
// CHECK:STDOUT:     %x.var_patt: %pattern_type.89a = var_pattern %x.patt [concrete = constants.%x.var_patt]
// CHECK:STDOUT:   }
// CHECK:STDOUT:   %Destroy.facet.loc17_3.1: %Destroy.type = facet_value constants.%DerivedFromVirtualDestructor, (constants.%custom_witness.fe1, constants.%DestroyImpl.impl_witness.ed5) [concrete = constants.%Destroy.facet]
// CHECK:STDOUT:   %.loc17_3.2: %Destroy.type = converted constants.%DerivedFromVirtualDestructor, %Destroy.facet.loc17_3.1 [concrete = constants.%Destroy.facet]
// CHECK:STDOUT:   %Destroy.facet.loc17_3.2: %Destroy.type = facet_value constants.%DerivedFromVirtualDestructor, (constants.%custom_witness.fe1, constants.%DestroyImpl.impl_witness.ed5) [concrete = constants.%Destroy.facet]
// CHECK:STDOUT:   %.loc17_3.3: %Destroy.type = converted constants.%DerivedFromVirtualDestructor, %Destroy.facet.loc17_3.2 [concrete = constants.%Destroy.facet]
// CHECK:STDOUT:   <elided>
// CHECK:STDOUT:   %SelfDestruct.call: init %empty_tuple.type = call %SelfDestruct.specific_fn(%x.var)
// CHECK:STDOUT:   <elided>
// CHECK:STDOUT: }
// CHECK:STDOUT:
