// Part of the Carbon Language project, under the Apache License v2.0 with LLVM
// Exceptions. See /LICENSE for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
// INCLUDE-FILE: toolchain/testing/testdata/min_prelude/destroy.carbon
//
// AUTOUPDATE
// TIP: To test this file alone, run:
// TIP:   bazel test //toolchain/testing:file_test --test_arg=--file_tests=toolchain/check/testdata/interop/cpp/impls/destruction/dynamic/adapters.carbon
// TIP: To dump output, run:
// TIP:   bazel run //toolchain/testing:file_test -- --dump_output --file_tests=toolchain/check/testdata/interop/cpp/impls/destruction/dynamic/adapters.carbon

// A type has _dynamic destruction_ if it:
//
// -   is final and implements `Core.Destroy`, or
// -   is not imported from C++ and has a virtual pointer, or
// -   is imported from C++ and has a virtual destructor.

// --- types.h

using FunctionPointer = void (*)();

struct TrivialDestructor {};

struct VirtualDestructor {
  virtual ~VirtualDestructor();
};

// --- todo_dynamic_cpp_function_pointer.carbon
library "[[@TEST_NAME]]";

import Cpp library "types.h";

fn Make() -> Cpp.FunctionPointer;

fn Test() {
  //@dump-sem-ir-begin
  Cpp.FunctionPointer as Core.SubobjectDestroy;
  Cpp.FunctionPointer as Core.Destroy;
  Cpp.FunctionPointer as Core.DynamicDestroy;

  var unused x: Cpp.FunctionPointer = Make();
  //@dump-sem-ir-end
}

// --- todo_dynamic_cpp_const_virtual_destructor.carbon
library "[[@TEST_NAME]]";

import Cpp library "types.h";

alias Const = const Cpp.VirtualDestructor;
fn Make() -> Const;

fn Test() {
  //@dump-sem-ir-begin
  // TODO: fix crash
  // Const as Core.SubobjectDestroy;
  // Const as Core.Destroy;
  // Const as Core.DynamicDestroy;

  // var unused x: Const = Make();
  //@dump-sem-ir-end
}

// --- fail_nondynamic_cpp_const_trivial_destructor.carbon
library "[[@TEST_NAME]]";

import Cpp library "types.h";

alias Const = const Cpp.TrivialDestructor;

fn Test() {
  // CHECK:STDERR:        ╭─┤ fail_nondynamic_cpp_const_trivial_destructor.carbon:[[@LINE+8]]:3
  // CHECK:STDERR: ->     │   Const as Core.DynamicDestroy;
  // CHECK:STDERR:        ·   ┳━━━━━━━━━━━━━━━━━━━━━━━━━━━
  // CHECK:STDERR:        ·   ┗━━┫ error: cannot convert type `Const` into type implementing
  // CHECK:STDERR:        ·      ┃        `Core.DynamicDestroy`
  // CHECK:STDERR:        ·      ┃        [ConversionFailureTypeToFacet]
  // CHECK:STDERR:        ╰────
  // CHECK:STDERR:
  Const as Core.DynamicDestroy;
}

// CHECK:STDOUT: --- todo_dynamic_cpp_function_pointer.carbon = $todo_dynamic_cpp_function_pointer
// CHECK:STDOUT:
// CHECK:STDOUT: constants {
// CHECK:STDOUT:   type: type = facet_type <type> [concrete]
// CHECK:STDOUT:   %.659: type = cpp_fn_ptr_type clang_function_pointer_type58000000 [concrete]
// CHECK:STDOUT:   %pattern_type.4b7: type = pattern_type %.659 [concrete]
// CHECK:STDOUT:   %Make.type: type = fn_type @Make [concrete]
// CHECK:STDOUT:   %empty_tuple.type: type = tuple_type () [concrete]
// CHECK:STDOUT:   %Make: %Make.type = struct_value () [concrete]
// CHECK:STDOUT:   %SubobjectDestroy.type: type = facet_type <@SubobjectDestroy> [concrete]
// CHECK:STDOUT:   %SubobjectDestroy.WithSelf.Op.type.687: type = fn_type @SubobjectDestroy.WithSelf.Op.loc9 [concrete]
// CHECK:STDOUT:   %SubobjectDestroy.WithSelf.Op.30f: %SubobjectDestroy.WithSelf.Op.type.687 = struct_value () [concrete]
// CHECK:STDOUT:   %custom_witness.b80: <witness> = custom_witness (%SubobjectDestroy.WithSelf.Op.30f), @SubobjectDestroy [concrete]
// CHECK:STDOUT:   %SubobjectDestroy.facet.886: %SubobjectDestroy.type = facet_value %.659, (%custom_witness.b80) [concrete]
// CHECK:STDOUT:   %Destroy.type: type = facet_type <@Destroy> [concrete]
// CHECK:STDOUT:   %DestroyImpl.type: type = facet_type <@DestroyImpl> [concrete]
// CHECK:STDOUT:   %T.09f: %SubobjectDestroy.type = symbolic_binding T, 0 [symbolic]
// CHECK:STDOUT:   %T.as_type.as.DestroyImpl.impl.Op.type.dea: type = fn_type @T.as_type.as.DestroyImpl.impl.Op, @T.as_type.as.DestroyImpl.impl(%T.09f) [symbolic]
// CHECK:STDOUT:   %T.as_type.as.DestroyImpl.impl.Op.6e5: %T.as_type.as.DestroyImpl.impl.Op.type.dea = struct_value () [symbolic]
// CHECK:STDOUT:   %DestroyImpl.impl_witness.381: <witness> = impl_witness imports.%DestroyImpl.impl_witness_table, @T.as_type.as.DestroyImpl.impl(%SubobjectDestroy.facet.886) [concrete]
// CHECK:STDOUT:   %Destroy.facet: %Destroy.type = facet_value %.659, (%custom_witness.b80, %DestroyImpl.impl_witness.381) [concrete]
// CHECK:STDOUT:   %DynamicDestroy.type: type = facet_type <@DynamicDestroy> [concrete]
// CHECK:STDOUT:   %custom_witness.0b5: <witness> = custom_witness (), @DynamicDestroyImpl [concrete]
// CHECK:STDOUT:   %DynamicDestroy.facet: %DynamicDestroy.type = facet_value %.659, (%custom_witness.b80, %DestroyImpl.impl_witness.381, %custom_witness.0b5) [concrete]
// CHECK:STDOUT:   %x.patt: %pattern_type.4b7 = ref_binding_pattern x [concrete]
// CHECK:STDOUT:   %x.var_patt: %pattern_type.4b7 = var_pattern %x.patt [concrete]
// CHECK:STDOUT:   %SelfDestruct.type: type = fn_type @SelfDestruct [concrete]
// CHECK:STDOUT:   %SelfDestruct: %SelfDestruct.type = struct_value () [concrete]
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: imports {
// CHECK:STDOUT:   %Core: <namespace> = namespace file.%Core.import, [concrete] {
// CHECK:STDOUT:     .SubobjectDestroy = %Core.SubobjectDestroy
// CHECK:STDOUT:     .Destroy = %Core.Destroy
// CHECK:STDOUT:     .DynamicDestroy = %Core.DynamicDestroy
// CHECK:STDOUT:     .DestroyImpl = %Core.DestroyImpl
// CHECK:STDOUT:     .SelfDestruct = %Core.SelfDestruct
// CHECK:STDOUT:     import Core//prelude
// CHECK:STDOUT:     import Core//prelude/...
// CHECK:STDOUT:   }
// CHECK:STDOUT:   %Cpp: <namespace> = namespace file.%Cpp.import_cpp, [concrete] {
// CHECK:STDOUT:     .FunctionPointer = constants.%.659
// CHECK:STDOUT:     import Cpp//...
// CHECK:STDOUT:   }
// CHECK:STDOUT:   %Core.SubobjectDestroy: type = import_ref Core//prelude/parts/destroy, SubobjectDestroy, loaded [concrete = constants.%SubobjectDestroy.type]
// CHECK:STDOUT:   %Core.Destroy: type = import_ref Core//prelude/parts/destroy, Destroy, loaded [concrete = constants.%Destroy.type]
// CHECK:STDOUT:   %Core.import_ref.74d: @T.as_type.as.DestroyImpl.impl.%T.as_type.as.DestroyImpl.impl.Op.type (%T.as_type.as.DestroyImpl.impl.Op.type.dea) = import_ref Core//prelude/parts/destroy, loc{{\d+_\d+}}, loaded [symbolic = @T.as_type.as.DestroyImpl.impl.%T.as_type.as.DestroyImpl.impl.Op (constants.%T.as_type.as.DestroyImpl.impl.Op.6e5)]
// CHECK:STDOUT:   %DestroyImpl.impl_witness_table = impl_witness_table (%Core.import_ref.74d), @T.as_type.as.DestroyImpl.impl [concrete]
// CHECK:STDOUT:   %Core.DynamicDestroy: type = import_ref Core//prelude/parts/destroy, DynamicDestroy, loaded [concrete = constants.%DynamicDestroy.type]
// CHECK:STDOUT:   %Core.DestroyImpl: type = import_ref Core//prelude/parts/destroy, DestroyImpl, loaded [concrete = constants.%DestroyImpl.type]
// CHECK:STDOUT:   %Core.SelfDestruct: %SelfDestruct.type = import_ref Core//prelude/parts/destroy, SelfDestruct, loaded [concrete = constants.%SelfDestruct]
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: fn @Test() {
// CHECK:STDOUT: !entry:
// CHECK:STDOUT:   %Cpp.ref.loc9: <namespace> = name_ref Cpp, imports.%Cpp [concrete = imports.%Cpp]
// CHECK:STDOUT:   %FunctionPointer.ref.loc9: type = name_ref FunctionPointer, constants.%.659 [concrete = constants.%.659]
// CHECK:STDOUT:   %Core.ref.loc9: <namespace> = name_ref Core, imports.%Core [concrete = imports.%Core]
// CHECK:STDOUT:   %SubobjectDestroy.ref: type = name_ref SubobjectDestroy, imports.%Core.SubobjectDestroy [concrete = constants.%SubobjectDestroy.type]
// CHECK:STDOUT:   %SubobjectDestroy.facet: %SubobjectDestroy.type = facet_value %FunctionPointer.ref.loc9, (constants.%custom_witness.b80) [concrete = constants.%SubobjectDestroy.facet.886]
// CHECK:STDOUT:   %.loc9: %SubobjectDestroy.type = converted %FunctionPointer.ref.loc9, %SubobjectDestroy.facet [concrete = constants.%SubobjectDestroy.facet.886]
// CHECK:STDOUT:   %Cpp.ref.loc10: <namespace> = name_ref Cpp, imports.%Cpp [concrete = imports.%Cpp]
// CHECK:STDOUT:   %FunctionPointer.ref.loc10: type = name_ref FunctionPointer, constants.%.659 [concrete = constants.%.659]
// CHECK:STDOUT:   %Core.ref.loc10: <namespace> = name_ref Core, imports.%Core [concrete = imports.%Core]
// CHECK:STDOUT:   %Destroy.ref: type = name_ref Destroy, imports.%Core.Destroy [concrete = constants.%Destroy.type]
// CHECK:STDOUT:   %Destroy.facet.loc10: %Destroy.type = facet_value %FunctionPointer.ref.loc10, (constants.%custom_witness.b80, constants.%DestroyImpl.impl_witness.381) [concrete = constants.%Destroy.facet]
// CHECK:STDOUT:   %.loc10: %Destroy.type = converted %FunctionPointer.ref.loc10, %Destroy.facet.loc10 [concrete = constants.%Destroy.facet]
// CHECK:STDOUT:   %Cpp.ref.loc11: <namespace> = name_ref Cpp, imports.%Cpp [concrete = imports.%Cpp]
// CHECK:STDOUT:   %FunctionPointer.ref.loc11: type = name_ref FunctionPointer, constants.%.659 [concrete = constants.%.659]
// CHECK:STDOUT:   %Core.ref.loc11: <namespace> = name_ref Core, imports.%Core [concrete = imports.%Core]
// CHECK:STDOUT:   %DynamicDestroy.ref: type = name_ref DynamicDestroy, imports.%Core.DynamicDestroy [concrete = constants.%DynamicDestroy.type]
// CHECK:STDOUT:   %DynamicDestroy.facet: %DynamicDestroy.type = facet_value %FunctionPointer.ref.loc11, (constants.%custom_witness.b80, constants.%DestroyImpl.impl_witness.381, constants.%custom_witness.0b5) [concrete = constants.%DynamicDestroy.facet]
// CHECK:STDOUT:   %.loc11: %DynamicDestroy.type = converted %FunctionPointer.ref.loc11, %DynamicDestroy.facet [concrete = constants.%DynamicDestroy.facet]
// CHECK:STDOUT:   %x.var: ref %.659 = var_storage %x.var_patt
// CHECK:STDOUT:   %Make.ref: %Make.type = name_ref Make, file.%Make.decl [concrete = constants.%Make]
// CHECK:STDOUT:   %Make.call: init %.659 = call %Make.ref()
// CHECK:STDOUT:   assign %x.var, %Make.call
// CHECK:STDOUT:   %.loc13_20: type = splice_block %FunctionPointer.ref.loc13 [concrete = constants.%.659] {
// CHECK:STDOUT:     %Cpp.ref.loc13: <namespace> = name_ref Cpp, imports.%Cpp [concrete = imports.%Cpp]
// CHECK:STDOUT:     %FunctionPointer.ref.loc13: type = name_ref FunctionPointer, constants.%.659 [concrete = constants.%.659]
// CHECK:STDOUT:   }
// CHECK:STDOUT:   %x: ref %.659 = wrapper_binding x, %x.var
// CHECK:STDOUT:   name_binding_decl {
// CHECK:STDOUT:     %x.patt: %pattern_type.4b7 = ref_binding_pattern x [concrete = constants.%x.patt]
// CHECK:STDOUT:     %x.var_patt: %pattern_type.4b7 = var_pattern %x.patt [concrete = constants.%x.var_patt]
// CHECK:STDOUT:   }
// CHECK:STDOUT:   %Destroy.facet.loc13_3.1: %Destroy.type = facet_value constants.%.659, (constants.%custom_witness.b80, constants.%DestroyImpl.impl_witness.381) [concrete = constants.%Destroy.facet]
// CHECK:STDOUT:   %.loc13_3.1: %Destroy.type = converted constants.%.659, %Destroy.facet.loc13_3.1 [concrete = constants.%Destroy.facet]
// CHECK:STDOUT:   %Destroy.facet.loc13_3.2: %Destroy.type = facet_value constants.%.659, (constants.%custom_witness.b80, constants.%DestroyImpl.impl_witness.381) [concrete = constants.%Destroy.facet]
// CHECK:STDOUT:   %.loc13_3.2: %Destroy.type = converted constants.%.659, %Destroy.facet.loc13_3.2 [concrete = constants.%Destroy.facet]
// CHECK:STDOUT:   <elided>
// CHECK:STDOUT:   %SelfDestruct.call: init %empty_tuple.type = call %SelfDestruct.specific_fn(%x.var)
// CHECK:STDOUT:   <elided>
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: fn @SubobjectDestroy.WithSelf.Op.loc9(%self.param: ref %.659) = "no_op";
// CHECK:STDOUT:
// CHECK:STDOUT: --- todo_dynamic_cpp_const_virtual_destructor.carbon = $todo_dynamic_cpp_const_virtual_destructor
// CHECK:STDOUT:
// CHECK:STDOUT: fn @Test() {
// CHECK:STDOUT: !entry:
// CHECK:STDOUT:   <elided>
// CHECK:STDOUT: }
// CHECK:STDOUT:
