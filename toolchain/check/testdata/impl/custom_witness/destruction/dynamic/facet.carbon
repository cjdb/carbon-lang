// Part of the Carbon Language project, under the Apache License v2.0 with LLVM
// Exceptions. See /LICENSE for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
// INCLUDE-FILE: toolchain/testing/testdata/min_prelude/destroy.carbon
//
// AUTOUPDATE
// TIP: To test this file alone, run:
// TIP:   bazel test //toolchain/testing:file_test --test_arg=--file_tests=toolchain/check/testdata/impl/custom_witness/destruction/dynamic/facet.carbon
// TIP: To dump output, run:
// TIP:   bazel run //toolchain/testing:file_test -- --dump_output --file_tests=toolchain/check/testdata/impl/custom_witness/destruction/dynamic/facet.carbon

// A type has _dynamic destruction_ if it:
//
// -   is final and implements `Core.Destroy`, or
// -   is not imported from C++ and has a virtual pointer, or
// -   is imported from C++ and has a virtual destructor.

// --- todo_dynamic_facet.carbon
library "[[@TEST_NAME]]";

fn Test(generic T: Core.DynamicDestroy) {
  //@dump-sem-ir-begin
  T as Core.SubobjectDestroy;
  T as Core.Destroy;
  T as Core.DynamicDestroy;
  //@dump-sem-ir-end
}

// --- todo_fail_nondynamic_destroy_facet.carbon
library "[[@TEST_NAME]]";

fn Test(generic T: Core.Destroy) {
  T as Core.DynamicDestroy;
}

// CHECK:STDOUT: --- todo_dynamic_facet.carbon = $todo_dynamic_facet
// CHECK:STDOUT:
// CHECK:STDOUT: constants {
// CHECK:STDOUT:   type: type = facet_type <type> [concrete]
// CHECK:STDOUT:   %DynamicDestroy.type: type = facet_type <@DynamicDestroy> [concrete]
// CHECK:STDOUT:   %Destroy.type: type = facet_type <@Destroy> [concrete]
// CHECK:STDOUT:   %SubobjectDestroy.type: type = facet_type <@SubobjectDestroy> [concrete]
// CHECK:STDOUT:   %pattern_type.9a5: type = pattern_type %DynamicDestroy.type [concrete]
// CHECK:STDOUT:   %T.patt.3a0: %pattern_type.9a5 = symbolic_binding_pattern T, 0 [symbolic]
// CHECK:STDOUT:   %T.f45: %DynamicDestroy.type = symbolic_binding T, 0 [symbolic]
// CHECK:STDOUT:   %T.as_type.190: type = facet_access_type %T.f45 [symbolic]
// CHECK:STDOUT:   %SubobjectDestroy.lookup_impl_witness: <witness> = lookup_impl_witness %T.f45, @SubobjectDestroy [symbolic]
// CHECK:STDOUT:   %SubobjectDestroy.facet: %SubobjectDestroy.type = facet_value %T.as_type.190, (%SubobjectDestroy.lookup_impl_witness) [symbolic]
// CHECK:STDOUT:   %DestroyImpl.lookup_impl_witness: <witness> = lookup_impl_witness %T.f45, @DestroyImpl [symbolic]
// CHECK:STDOUT:   %Destroy.facet: %Destroy.type = facet_value %T.as_type.190, (%DestroyImpl.lookup_impl_witness, %SubobjectDestroy.lookup_impl_witness) [symbolic]
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: imports {
// CHECK:STDOUT:   %Core: <namespace> = namespace file.%Core.import, [concrete] {
// CHECK:STDOUT:     .DynamicDestroy = %Core.DynamicDestroy
// CHECK:STDOUT:     .SubobjectDestroy = %Core.SubobjectDestroy
// CHECK:STDOUT:     .Destroy = %Core.Destroy
// CHECK:STDOUT:     import Core//prelude
// CHECK:STDOUT:     import Core//prelude/...
// CHECK:STDOUT:   }
// CHECK:STDOUT:   %Core.DynamicDestroy: type = import_ref Core//prelude/parts/destroy, DynamicDestroy, loaded [concrete = constants.%DynamicDestroy.type]
// CHECK:STDOUT:   %Core.SubobjectDestroy: type = import_ref Core//prelude/parts/destroy, SubobjectDestroy, loaded [concrete = constants.%SubobjectDestroy.type]
// CHECK:STDOUT:   %Core.Destroy: type = import_ref Core//prelude/parts/destroy, Destroy, loaded [concrete = constants.%Destroy.type]
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: generic fn @Test(%T.loc3_18.2: %DynamicDestroy.type) {
// CHECK:STDOUT:   <elided>
// CHECK:STDOUT:
// CHECK:STDOUT: !definition:
// CHECK:STDOUT:   %T.as_type.loc5_5.2: type = facet_access_type %T.loc3_18.1 [symbolic = %T.as_type.loc5_5.2 (constants.%T.as_type.190)]
// CHECK:STDOUT:   %SubobjectDestroy.lookup_impl_witness: <witness> = lookup_impl_witness %T.loc3_18.1, @SubobjectDestroy [symbolic = %SubobjectDestroy.lookup_impl_witness (constants.%SubobjectDestroy.lookup_impl_witness)]
// CHECK:STDOUT:   %SubobjectDestroy.facet.loc5_5.2: %SubobjectDestroy.type = facet_value %T.as_type.loc5_5.2, (%SubobjectDestroy.lookup_impl_witness) [symbolic = %SubobjectDestroy.facet.loc5_5.2 (constants.%SubobjectDestroy.facet)]
// CHECK:STDOUT:   %DestroyImpl.lookup_impl_witness: <witness> = lookup_impl_witness %T.loc3_18.1, @DestroyImpl [symbolic = %DestroyImpl.lookup_impl_witness (constants.%DestroyImpl.lookup_impl_witness)]
// CHECK:STDOUT:   %Destroy.facet.loc6_5.2: %Destroy.type = facet_value %T.as_type.loc5_5.2, (%DestroyImpl.lookup_impl_witness, %SubobjectDestroy.lookup_impl_witness) [symbolic = %Destroy.facet.loc6_5.2 (constants.%Destroy.facet)]
// CHECK:STDOUT:
// CHECK:STDOUT:   fn() {
// CHECK:STDOUT:   !entry:
// CHECK:STDOUT:     %T.ref.loc5: %DynamicDestroy.type = name_ref T, %T.loc3_18.2 [symbolic = %T.loc3_18.1 (constants.%T.f45)]
// CHECK:STDOUT:     %Core.ref.loc5: <namespace> = name_ref Core, imports.%Core [concrete = imports.%Core]
// CHECK:STDOUT:     %SubobjectDestroy.ref: type = name_ref SubobjectDestroy, imports.%Core.SubobjectDestroy [concrete = constants.%SubobjectDestroy.type]
// CHECK:STDOUT:     %T.as_type.loc5_5.1: type = facet_access_type %T.ref.loc5 [symbolic = %T.as_type.loc5_5.2 (constants.%T.as_type.190)]
// CHECK:STDOUT:     %SubobjectDestroy.facet.loc5_5.1: %SubobjectDestroy.type = facet_value %T.as_type.loc5_5.1, (constants.%SubobjectDestroy.lookup_impl_witness) [symbolic = %SubobjectDestroy.facet.loc5_5.2 (constants.%SubobjectDestroy.facet)]
// CHECK:STDOUT:     %.loc5: %SubobjectDestroy.type = converted %T.ref.loc5, %SubobjectDestroy.facet.loc5_5.1 [symbolic = %SubobjectDestroy.facet.loc5_5.2 (constants.%SubobjectDestroy.facet)]
// CHECK:STDOUT:     %T.ref.loc6: %DynamicDestroy.type = name_ref T, %T.loc3_18.2 [symbolic = %T.loc3_18.1 (constants.%T.f45)]
// CHECK:STDOUT:     %Core.ref.loc6: <namespace> = name_ref Core, imports.%Core [concrete = imports.%Core]
// CHECK:STDOUT:     %Destroy.ref: type = name_ref Destroy, imports.%Core.Destroy [concrete = constants.%Destroy.type]
// CHECK:STDOUT:     %T.as_type.loc6: type = facet_access_type %T.ref.loc6 [symbolic = %T.as_type.loc5_5.2 (constants.%T.as_type.190)]
// CHECK:STDOUT:     %Destroy.facet.loc6_5.1: %Destroy.type = facet_value %T.as_type.loc6, (constants.%DestroyImpl.lookup_impl_witness, constants.%SubobjectDestroy.lookup_impl_witness) [symbolic = %Destroy.facet.loc6_5.2 (constants.%Destroy.facet)]
// CHECK:STDOUT:     %.loc6: %Destroy.type = converted %T.ref.loc6, %Destroy.facet.loc6_5.1 [symbolic = %Destroy.facet.loc6_5.2 (constants.%Destroy.facet)]
// CHECK:STDOUT:     %T.ref.loc7: %DynamicDestroy.type = name_ref T, %T.loc3_18.2 [symbolic = %T.loc3_18.1 (constants.%T.f45)]
// CHECK:STDOUT:     %Core.ref.loc7: <namespace> = name_ref Core, imports.%Core [concrete = imports.%Core]
// CHECK:STDOUT:     %DynamicDestroy.ref.loc7: type = name_ref DynamicDestroy, imports.%Core.DynamicDestroy [concrete = constants.%DynamicDestroy.type]
// CHECK:STDOUT:     <elided>
// CHECK:STDOUT:   }
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: specific @Test(constants.%T.f45) {
// CHECK:STDOUT:   %T.patt.loc3_18.2 => constants.%T.patt.3a0
// CHECK:STDOUT:   %T.loc3_18.1 => constants.%T.f45
// CHECK:STDOUT: }
// CHECK:STDOUT:
