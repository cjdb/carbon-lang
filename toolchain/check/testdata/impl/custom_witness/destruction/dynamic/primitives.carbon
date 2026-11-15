// Part of the Carbon Language project, under the Apache License v2.0 with LLVM
// Exceptions. See /LICENSE for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
// INCLUDE-FILE: toolchain/testing/testdata/min_prelude/primitives.carbon
//
// AUTOUPDATE
// TIP: To test this file alone, run:
// TIP:   bazel test //toolchain/testing:file_test --test_arg=--file_tests=toolchain/check/testdata/impl/custom_witness/destruction/dynamic/primitives.carbon
// TIP: To dump output, run:
// TIP:   bazel run //toolchain/testing:file_test -- --dump_output --file_tests=toolchain/check/testdata/impl/custom_witness/destruction/dynamic/primitives.carbon

// A type has _dynamic destruction_ if it:
//
// -   is final and implements `Core.Destroy`, or
// -   is not imported from C++ and has a virtual pointer, or
// -   is imported from C++ and has a virtual destructor.

// --- todo_dynamic_bool.carbon
library "[[@TEST_NAME]]";

fn Test() {
  //@dump-sem-ir-begin
  bool as Core.SubobjectDestroy;
  bool as Core.Destroy;
  bool as Core.DynamicDestroy;

  var unused x: bool = true;
  //@dump-sem-ir-end
}

// --- todo_dynamic_bound_method.carbon
library "[[@TEST_NAME]]";

class C {
  fn Get(self) -> i32;
}

fn Make(c: C) -> typeof(c.Get);

fn Test(c: C) {
  //@dump-sem-ir-begin
  typeof(c.Get) as Core.SubobjectDestroy;
  typeof(c.Get) as Core.Destroy;
  typeof(c.Get) as Core.DynamicDestroy;

  var unused x: typeof(c.Get) = Make(c);
  //@dump-sem-ir-end
}

// --- todo_dynamic_char_literal.carbon
library "[[@TEST_NAME]]";

fn Test() {
  //@dump-sem-ir-begin
  Core.CharLiteral as Core.SubobjectDestroy;
  Core.CharLiteral as Core.Destroy;
  Core.CharLiteral as Core.DynamicDestroy;

  var unused x: Core.CharLiteral = 'c';
  //@dump-sem-ir-end
}

// --- todo_dynamic_f64.carbon
library "[[@TEST_NAME]]";

fn Test() {
  //@dump-sem-ir-begin
  f64 as Core.SubobjectDestroy;
  f64 as Core.Destroy;
  f64 as Core.DynamicDestroy;

  var unused x: f64 = 0.0;
  //@dump-sem-ir-end
}

// --- todo_dynamic_float_literal.carbon
library "[[@TEST_NAME]]";

fn Test() {
  //@dump-sem-ir-begin
  Core.FloatLiteral as Core.SubobjectDestroy;
  Core.FloatLiteral as Core.Destroy;
  Core.FloatLiteral as Core.DynamicDestroy;

  var unused x: Core.FloatLiteral = 0.0;
  //@dump-sem-ir-end
}

// --- todo_dynamic_form.carbon
library "[[@TEST_NAME]]";

alias Form = typeof(form(var i32));
fn Make() -> Form;

fn Test() {
  //@dump-sem-ir-begin
  Form as Core.SubobjectDestroy;
  Form as Core.Destroy;
  Form as Core.DynamicDestroy;

  var unused x: Form = Make();
  //@dump-sem-ir-end
}

// --- todo_dynamic_function.carbon
library "[[@TEST_NAME]]";

fn G() {}

alias Fn = typeof(G);
fn Make() -> Fn;

fn Test() {
  //@dump-sem-ir-begin
  Fn as Core.SubobjectDestroy;
  Fn as Core.Destroy;
  Fn as Core.DynamicDestroy;

  var unused x: Fn = Make();
  //@dump-sem-ir-end
}

// --- todo_dynamic_function_with_self.carbon
library "[[@TEST_NAME]]";

alias FnWithSelf = typeof((i32 as Core.Copy).Op);
fn Make() -> FnWithSelf;

fn Test() {
  //@dump-sem-ir-begin
  FnWithSelf as Core.SubobjectDestroy;
  FnWithSelf as Core.Destroy;
  FnWithSelf as Core.DynamicDestroy;

  var unused x: FnWithSelf = Make();
  //@dump-sem-ir-end
}

// --- todo_dynamic_int_literal.carbon
library "[[@TEST_NAME]]";

fn Test() {
  //@dump-sem-ir-begin
  Core.IntLiteral as Core.SubobjectDestroy;
  Core.IntLiteral as Core.Destroy;
  Core.IntLiteral as Core.DynamicDestroy;

  var unused x: Core.IntLiteral = 0;
  //@dump-sem-ir-end
}

// --- todo_dynamic_i32.carbon
library "[[@TEST_NAME]]";

fn Test() {
  //@dump-sem-ir-begin
  i32 as Core.SubobjectDestroy;
  i32 as Core.Destroy;
  i32 as Core.DynamicDestroy;

  var unused x: i32 = 0;
  //@dump-sem-ir-end
}

// CHECK:STDOUT: --- todo_dynamic_bool.carbon = $todo_dynamic_bool
// CHECK:STDOUT:
// CHECK:STDOUT: constants {
// CHECK:STDOUT:   type: type = facet_type <type> [concrete]
// CHECK:STDOUT:   %empty_tuple.type: type = tuple_type () [concrete]
// CHECK:STDOUT:   %SubobjectDestroy.type: type = facet_type <@SubobjectDestroy> [concrete]
// CHECK:STDOUT:   %pattern_type.831: type = pattern_type bool [concrete]
// CHECK:STDOUT:   %SubobjectDestroy.WithSelf.Op.type.687: type = fn_type @SubobjectDestroy.WithSelf.Op.loc5 [concrete]
// CHECK:STDOUT:   %SubobjectDestroy.WithSelf.Op.30f: %SubobjectDestroy.WithSelf.Op.type.687 = struct_value () [concrete]
// CHECK:STDOUT:   %custom_witness.b80: <witness> = custom_witness (%SubobjectDestroy.WithSelf.Op.30f), @SubobjectDestroy [concrete]
// CHECK:STDOUT:   %SubobjectDestroy.facet.a87: %SubobjectDestroy.type = facet_value bool, (%custom_witness.b80) [concrete]
// CHECK:STDOUT:   %Destroy.type: type = facet_type <@Destroy> [concrete]
// CHECK:STDOUT:   %DestroyImpl.type: type = facet_type <@DestroyImpl> [concrete]
// CHECK:STDOUT:   %T.09f: %SubobjectDestroy.type = symbolic_binding T, 0 [symbolic]
// CHECK:STDOUT:   %T.as_type.as.DestroyImpl.impl.Op.type.dea: type = fn_type @T.as_type.as.DestroyImpl.impl.Op, @T.as_type.as.DestroyImpl.impl(%T.09f) [symbolic]
// CHECK:STDOUT:   %T.as_type.as.DestroyImpl.impl.Op.6e5: %T.as_type.as.DestroyImpl.impl.Op.type.dea = struct_value () [symbolic]
// CHECK:STDOUT:   %DestroyImpl.impl_witness.778: <witness> = impl_witness imports.%DestroyImpl.impl_witness_table, @T.as_type.as.DestroyImpl.impl(%SubobjectDestroy.facet.a87) [concrete]
// CHECK:STDOUT:   %Destroy.facet: %Destroy.type = facet_value bool, (%custom_witness.b80, %DestroyImpl.impl_witness.778) [concrete]
// CHECK:STDOUT:   %DynamicDestroy.type: type = facet_type <@DynamicDestroy> [concrete]
// CHECK:STDOUT:   %custom_witness.0b5: <witness> = custom_witness (), @DynamicDestroyImpl [concrete]
// CHECK:STDOUT:   %DynamicDestroy.facet: %DynamicDestroy.type = facet_value bool, (%custom_witness.b80, %DestroyImpl.impl_witness.778, %custom_witness.0b5) [concrete]
// CHECK:STDOUT:   %x.patt: %pattern_type.831 = ref_binding_pattern x [concrete]
// CHECK:STDOUT:   %x.var_patt: %pattern_type.831 = var_pattern %x.patt [concrete]
// CHECK:STDOUT:   %true: bool = bool_literal true [concrete]
// CHECK:STDOUT:   %Copy.type: type = facet_type <@Copy> [concrete]
// CHECK:STDOUT:   %Copy.impl_witness.5e1: <witness> = impl_witness imports.%Copy.impl_witness_table.bda [concrete]
// CHECK:STDOUT:   %Copy.facet: %Copy.type = facet_value bool, (%Copy.impl_witness.5e1) [concrete]
// CHECK:STDOUT:   %Copy.WithSelf.Op.type.c98: type = fn_type @Copy.WithSelf.Op, @Copy.WithSelf(%Copy.facet) [concrete]
// CHECK:STDOUT:   %.68a: type = fn_type_with_self_type %Copy.WithSelf.Op.type.c98, %Copy.facet [concrete]
// CHECK:STDOUT:   %bool.as.Copy.impl.Op.type: type = fn_type @bool.as.Copy.impl.Op [concrete]
// CHECK:STDOUT:   %bool.as.Copy.impl.Op: %bool.as.Copy.impl.Op.type = struct_value () [concrete]
// CHECK:STDOUT:   %bool.as.Copy.impl.Op.bound: <bound method> = bound_method %true, %bool.as.Copy.impl.Op [concrete]
// CHECK:STDOUT:   %SelfDestruct.type: type = fn_type @SelfDestruct [concrete]
// CHECK:STDOUT:   %SelfDestruct: %SelfDestruct.type = struct_value () [concrete]
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: imports {
// CHECK:STDOUT:   %Core: <namespace> = namespace file.%Core.import, [concrete] {
// CHECK:STDOUT:     .Bool = %Core.Bool
// CHECK:STDOUT:     .SubobjectDestroy = %Core.SubobjectDestroy
// CHECK:STDOUT:     .Destroy = %Core.Destroy
// CHECK:STDOUT:     .DynamicDestroy = %Core.DynamicDestroy
// CHECK:STDOUT:     .DestroyImpl = %Core.DestroyImpl
// CHECK:STDOUT:     .Copy = %Core.Copy
// CHECK:STDOUT:     .SelfDestruct = %Core.SelfDestruct
// CHECK:STDOUT:     import Core//prelude
// CHECK:STDOUT:     import Core//prelude/...
// CHECK:STDOUT:   }
// CHECK:STDOUT:   %Core.Bool: type = import_ref Core//prelude/parts/bool, Bool, loaded [concrete = bool]
// CHECK:STDOUT:   %Core.SubobjectDestroy: type = import_ref Core//prelude/parts/destroy, SubobjectDestroy, loaded [concrete = constants.%SubobjectDestroy.type]
// CHECK:STDOUT:   %Core.Destroy: type = import_ref Core//prelude/parts/destroy, Destroy, loaded [concrete = constants.%Destroy.type]
// CHECK:STDOUT:   %Core.import_ref.74d: @T.as_type.as.DestroyImpl.impl.%T.as_type.as.DestroyImpl.impl.Op.type (%T.as_type.as.DestroyImpl.impl.Op.type.dea) = import_ref Core//prelude/parts/destroy, loc{{\d+_\d+}}, loaded [symbolic = @T.as_type.as.DestroyImpl.impl.%T.as_type.as.DestroyImpl.impl.Op (constants.%T.as_type.as.DestroyImpl.impl.Op.6e5)]
// CHECK:STDOUT:   %DestroyImpl.impl_witness_table = impl_witness_table (%Core.import_ref.74d), @T.as_type.as.DestroyImpl.impl [concrete]
// CHECK:STDOUT:   %Core.DynamicDestroy: type = import_ref Core//prelude/parts/destroy, DynamicDestroy, loaded [concrete = constants.%DynamicDestroy.type]
// CHECK:STDOUT:   %Core.DestroyImpl: type = import_ref Core//prelude/parts/destroy, DestroyImpl, loaded [concrete = constants.%DestroyImpl.type]
// CHECK:STDOUT:   %Core.Copy: type = import_ref Core//prelude/parts/copy, Copy, loaded [concrete = constants.%Copy.type]
// CHECK:STDOUT:   %Core.import_ref.9c3: %bool.as.Copy.impl.Op.type = import_ref Core//prelude/parts/copy, loc{{\d+_\d+}}, loaded [concrete = constants.%bool.as.Copy.impl.Op]
// CHECK:STDOUT:   %Copy.impl_witness_table.bda = impl_witness_table (%Core.import_ref.9c3), @bool.as.Copy.impl [concrete]
// CHECK:STDOUT:   %Core.SelfDestruct: %SelfDestruct.type = import_ref Core//prelude/parts/destroy, SelfDestruct, loaded [concrete = constants.%SelfDestruct]
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: fn @Test() {
// CHECK:STDOUT: !entry:
// CHECK:STDOUT:   %.loc5_3: type = type_literal bool [concrete = bool]
// CHECK:STDOUT:   %Core.ref.loc5: <namespace> = name_ref Core, imports.%Core [concrete = imports.%Core]
// CHECK:STDOUT:   %SubobjectDestroy.ref: type = name_ref SubobjectDestroy, imports.%Core.SubobjectDestroy [concrete = constants.%SubobjectDestroy.type]
// CHECK:STDOUT:   %SubobjectDestroy.facet: %SubobjectDestroy.type = facet_value %.loc5_3, (constants.%custom_witness.b80) [concrete = constants.%SubobjectDestroy.facet.a87]
// CHECK:STDOUT:   %.loc5_8: %SubobjectDestroy.type = converted %.loc5_3, %SubobjectDestroy.facet [concrete = constants.%SubobjectDestroy.facet.a87]
// CHECK:STDOUT:   %.loc6_3: type = type_literal bool [concrete = bool]
// CHECK:STDOUT:   %Core.ref.loc6: <namespace> = name_ref Core, imports.%Core [concrete = imports.%Core]
// CHECK:STDOUT:   %Destroy.ref: type = name_ref Destroy, imports.%Core.Destroy [concrete = constants.%Destroy.type]
// CHECK:STDOUT:   %Destroy.facet.loc6: %Destroy.type = facet_value %.loc6_3, (constants.%custom_witness.b80, constants.%DestroyImpl.impl_witness.778) [concrete = constants.%Destroy.facet]
// CHECK:STDOUT:   %.loc6_8: %Destroy.type = converted %.loc6_3, %Destroy.facet.loc6 [concrete = constants.%Destroy.facet]
// CHECK:STDOUT:   %.loc7_3: type = type_literal bool [concrete = bool]
// CHECK:STDOUT:   %Core.ref.loc7: <namespace> = name_ref Core, imports.%Core [concrete = imports.%Core]
// CHECK:STDOUT:   %DynamicDestroy.ref: type = name_ref DynamicDestroy, imports.%Core.DynamicDestroy [concrete = constants.%DynamicDestroy.type]
// CHECK:STDOUT:   %DynamicDestroy.facet: %DynamicDestroy.type = facet_value %.loc7_3, (constants.%custom_witness.b80, constants.%DestroyImpl.impl_witness.778, constants.%custom_witness.0b5) [concrete = constants.%DynamicDestroy.facet]
// CHECK:STDOUT:   %.loc7_8: %DynamicDestroy.type = converted %.loc7_3, %DynamicDestroy.facet [concrete = constants.%DynamicDestroy.facet]
// CHECK:STDOUT:   %x.var: ref bool = var_storage %x.var_patt
// CHECK:STDOUT:   %true: bool = bool_literal true [concrete = constants.%true]
// CHECK:STDOUT:   %impl.elem0: %.68a = impl_witness_access constants.%Copy.impl_witness.5e1, element0 [concrete = constants.%bool.as.Copy.impl.Op]
// CHECK:STDOUT:   %bound_method: <bound method> = bound_method %true, %impl.elem0 [concrete = constants.%bool.as.Copy.impl.Op.bound]
// CHECK:STDOUT:   %bool.as.Copy.impl.Op.call: init bool = call %bound_method(%true) [concrete = constants.%true]
// CHECK:STDOUT:   assign %x.var, %bool.as.Copy.impl.Op.call
// CHECK:STDOUT:   %.loc9_17: type = type_literal bool [concrete = bool]
// CHECK:STDOUT:   %x: ref bool = wrapper_binding x, %x.var
// CHECK:STDOUT:   name_binding_decl {
// CHECK:STDOUT:     %x.patt: %pattern_type.831 = ref_binding_pattern x [concrete = constants.%x.patt]
// CHECK:STDOUT:     %x.var_patt: %pattern_type.831 = var_pattern %x.patt [concrete = constants.%x.var_patt]
// CHECK:STDOUT:   }
// CHECK:STDOUT:   %Destroy.facet.loc9_3.1: %Destroy.type = facet_value bool, (constants.%custom_witness.b80, constants.%DestroyImpl.impl_witness.778) [concrete = constants.%Destroy.facet]
// CHECK:STDOUT:   %.loc9_3.1: %Destroy.type = converted bool, %Destroy.facet.loc9_3.1 [concrete = constants.%Destroy.facet]
// CHECK:STDOUT:   %Destroy.facet.loc9_3.2: %Destroy.type = facet_value bool, (constants.%custom_witness.b80, constants.%DestroyImpl.impl_witness.778) [concrete = constants.%Destroy.facet]
// CHECK:STDOUT:   %.loc9_3.2: %Destroy.type = converted bool, %Destroy.facet.loc9_3.2 [concrete = constants.%Destroy.facet]
// CHECK:STDOUT:   <elided>
// CHECK:STDOUT:   %SelfDestruct.call: init %empty_tuple.type = call %SelfDestruct.specific_fn(%x.var)
// CHECK:STDOUT:   <elided>
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: fn @SubobjectDestroy.WithSelf.Op.loc5(%self.param: ref bool) = "no_op";
// CHECK:STDOUT:
// CHECK:STDOUT: --- todo_dynamic_bound_method.carbon = $todo_dynamic_bound_method
// CHECK:STDOUT:
// CHECK:STDOUT: constants {
// CHECK:STDOUT:   type: type = facet_type <type> [concrete]
// CHECK:STDOUT:   %C: type = class_type @C [concrete]
// CHECK:STDOUT:   %Int.type: type = parameterized_class_name_type @Int [concrete]
// CHECK:STDOUT:   %empty_tuple.type: type = tuple_type () [concrete]
// CHECK:STDOUT:   %Int.generic: %Int.type = struct_value () [concrete]
// CHECK:STDOUT:   %C.Get.type: type = fn_type @C.Get [concrete]
// CHECK:STDOUT:   %C.Get: %C.Get.type = struct_value () [concrete]
// CHECK:STDOUT:   %pattern_type.061: type = pattern_type <bound method> [concrete]
// CHECK:STDOUT:   %Make.type: type = fn_type @Make [concrete]
// CHECK:STDOUT:   %Make: %Make.type = struct_value () [concrete]
// CHECK:STDOUT:   %SubobjectDestroy.type: type = facet_type <@SubobjectDestroy> [concrete]
// CHECK:STDOUT:   %SubobjectDestroy.WithSelf.Op.type.687: type = fn_type @SubobjectDestroy.WithSelf.Op.loc11 [concrete]
// CHECK:STDOUT:   %SubobjectDestroy.WithSelf.Op.30f: %SubobjectDestroy.WithSelf.Op.type.687 = struct_value () [concrete]
// CHECK:STDOUT:   %custom_witness.b80: <witness> = custom_witness (%SubobjectDestroy.WithSelf.Op.30f), @SubobjectDestroy [concrete]
// CHECK:STDOUT:   %SubobjectDestroy.facet.8ad: %SubobjectDestroy.type = facet_value <bound method>, (%custom_witness.b80) [concrete]
// CHECK:STDOUT:   %Destroy.type: type = facet_type <@Destroy> [concrete]
// CHECK:STDOUT:   %DestroyImpl.type: type = facet_type <@DestroyImpl> [concrete]
// CHECK:STDOUT:   %T.09f: %SubobjectDestroy.type = symbolic_binding T, 0 [symbolic]
// CHECK:STDOUT:   %T.as_type.as.DestroyImpl.impl.Op.type.dea: type = fn_type @T.as_type.as.DestroyImpl.impl.Op, @T.as_type.as.DestroyImpl.impl(%T.09f) [symbolic]
// CHECK:STDOUT:   %T.as_type.as.DestroyImpl.impl.Op.6e5: %T.as_type.as.DestroyImpl.impl.Op.type.dea = struct_value () [symbolic]
// CHECK:STDOUT:   %DestroyImpl.impl_witness.691: <witness> = impl_witness imports.%DestroyImpl.impl_witness_table, @T.as_type.as.DestroyImpl.impl(%SubobjectDestroy.facet.8ad) [concrete]
// CHECK:STDOUT:   %Destroy.facet: %Destroy.type = facet_value <bound method>, (%custom_witness.b80, %DestroyImpl.impl_witness.691) [concrete]
// CHECK:STDOUT:   %DynamicDestroy.type: type = facet_type <@DynamicDestroy> [concrete]
// CHECK:STDOUT:   %custom_witness.0b5: <witness> = custom_witness (), @DynamicDestroyImpl [concrete]
// CHECK:STDOUT:   %DynamicDestroy.facet: %DynamicDestroy.type = facet_value <bound method>, (%custom_witness.b80, %DestroyImpl.impl_witness.691, %custom_witness.0b5) [concrete]
// CHECK:STDOUT:   %x.patt: %pattern_type.061 = ref_binding_pattern x [concrete]
// CHECK:STDOUT:   %x.var_patt: %pattern_type.061 = var_pattern %x.patt [concrete]
// CHECK:STDOUT:   %SelfDestruct.type: type = fn_type @SelfDestruct [concrete]
// CHECK:STDOUT:   %SelfDestruct: %SelfDestruct.type = struct_value () [concrete]
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: imports {
// CHECK:STDOUT:   %Core: <namespace> = namespace file.%Core.import, [concrete] {
// CHECK:STDOUT:     .Int = %Core.Int
// CHECK:STDOUT:     .SubobjectDestroy = %Core.SubobjectDestroy
// CHECK:STDOUT:     .Destroy = %Core.Destroy
// CHECK:STDOUT:     .DynamicDestroy = %Core.DynamicDestroy
// CHECK:STDOUT:     .DestroyImpl = %Core.DestroyImpl
// CHECK:STDOUT:     .SelfDestruct = %Core.SelfDestruct
// CHECK:STDOUT:     import Core//prelude
// CHECK:STDOUT:     import Core//prelude/...
// CHECK:STDOUT:   }
// CHECK:STDOUT:   %Core.Int: %Int.type = import_ref Core//prelude/parts/int, Int, loaded [concrete = constants.%Int.generic]
// CHECK:STDOUT:   %Core.SubobjectDestroy: type = import_ref Core//prelude/parts/destroy, SubobjectDestroy, loaded [concrete = constants.%SubobjectDestroy.type]
// CHECK:STDOUT:   %Core.Destroy: type = import_ref Core//prelude/parts/destroy, Destroy, loaded [concrete = constants.%Destroy.type]
// CHECK:STDOUT:   %Core.import_ref.74d: @T.as_type.as.DestroyImpl.impl.%T.as_type.as.DestroyImpl.impl.Op.type (%T.as_type.as.DestroyImpl.impl.Op.type.dea) = import_ref Core//prelude/parts/destroy, loc{{\d+_\d+}}, loaded [symbolic = @T.as_type.as.DestroyImpl.impl.%T.as_type.as.DestroyImpl.impl.Op (constants.%T.as_type.as.DestroyImpl.impl.Op.6e5)]
// CHECK:STDOUT:   %DestroyImpl.impl_witness_table = impl_witness_table (%Core.import_ref.74d), @T.as_type.as.DestroyImpl.impl [concrete]
// CHECK:STDOUT:   %Core.DynamicDestroy: type = import_ref Core//prelude/parts/destroy, DynamicDestroy, loaded [concrete = constants.%DynamicDestroy.type]
// CHECK:STDOUT:   %Core.DestroyImpl: type = import_ref Core//prelude/parts/destroy, DestroyImpl, loaded [concrete = constants.%DestroyImpl.type]
// CHECK:STDOUT:   %Core.SelfDestruct: %SelfDestruct.type = import_ref Core//prelude/parts/destroy, SelfDestruct, loaded [concrete = constants.%SelfDestruct]
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: fn @Test(%c.param: %C) {
// CHECK:STDOUT: !entry:
// CHECK:STDOUT:   %.loc11_15: type = type_of %C.Get.bound.loc11 in [concrete = <bound method>] {
// CHECK:STDOUT:     %c.ref.loc11: %C = name_ref c, %c
// CHECK:STDOUT:     %Get.ref.loc11: %C.Get.type = name_ref Get, @C.%C.Get.decl [concrete = constants.%C.Get]
// CHECK:STDOUT:     %C.Get.bound.loc11: <bound method> = bound_method %c.ref.loc11, %Get.ref.loc11
// CHECK:STDOUT:   }
// CHECK:STDOUT:   %Core.ref.loc11: <namespace> = name_ref Core, imports.%Core [concrete = imports.%Core]
// CHECK:STDOUT:   %SubobjectDestroy.ref: type = name_ref SubobjectDestroy, imports.%Core.SubobjectDestroy [concrete = constants.%SubobjectDestroy.type]
// CHECK:STDOUT:   %SubobjectDestroy.facet: %SubobjectDestroy.type = facet_value %.loc11_15, (constants.%custom_witness.b80) [concrete = constants.%SubobjectDestroy.facet.8ad]
// CHECK:STDOUT:   %.loc11_17: %SubobjectDestroy.type = converted %.loc11_15, %SubobjectDestroy.facet [concrete = constants.%SubobjectDestroy.facet.8ad]
// CHECK:STDOUT:   %.loc12_15: type = type_of %C.Get.bound.loc12 in [concrete = <bound method>] {
// CHECK:STDOUT:     %c.ref.loc12: %C = name_ref c, %c
// CHECK:STDOUT:     %Get.ref.loc12: %C.Get.type = name_ref Get, @C.%C.Get.decl [concrete = constants.%C.Get]
// CHECK:STDOUT:     %C.Get.bound.loc12: <bound method> = bound_method %c.ref.loc12, %Get.ref.loc12
// CHECK:STDOUT:   }
// CHECK:STDOUT:   %Core.ref.loc12: <namespace> = name_ref Core, imports.%Core [concrete = imports.%Core]
// CHECK:STDOUT:   %Destroy.ref: type = name_ref Destroy, imports.%Core.Destroy [concrete = constants.%Destroy.type]
// CHECK:STDOUT:   %Destroy.facet.loc12: %Destroy.type = facet_value %.loc12_15, (constants.%custom_witness.b80, constants.%DestroyImpl.impl_witness.691) [concrete = constants.%Destroy.facet]
// CHECK:STDOUT:   %.loc12_17: %Destroy.type = converted %.loc12_15, %Destroy.facet.loc12 [concrete = constants.%Destroy.facet]
// CHECK:STDOUT:   %.loc13_15: type = type_of %C.Get.bound.loc13 in [concrete = <bound method>] {
// CHECK:STDOUT:     %c.ref.loc13: %C = name_ref c, %c
// CHECK:STDOUT:     %Get.ref.loc13: %C.Get.type = name_ref Get, @C.%C.Get.decl [concrete = constants.%C.Get]
// CHECK:STDOUT:     %C.Get.bound.loc13: <bound method> = bound_method %c.ref.loc13, %Get.ref.loc13
// CHECK:STDOUT:   }
// CHECK:STDOUT:   %Core.ref.loc13: <namespace> = name_ref Core, imports.%Core [concrete = imports.%Core]
// CHECK:STDOUT:   %DynamicDestroy.ref: type = name_ref DynamicDestroy, imports.%Core.DynamicDestroy [concrete = constants.%DynamicDestroy.type]
// CHECK:STDOUT:   %DynamicDestroy.facet: %DynamicDestroy.type = facet_value %.loc13_15, (constants.%custom_witness.b80, constants.%DestroyImpl.impl_witness.691, constants.%custom_witness.0b5) [concrete = constants.%DynamicDestroy.facet]
// CHECK:STDOUT:   %.loc13_17: %DynamicDestroy.type = converted %.loc13_15, %DynamicDestroy.facet [concrete = constants.%DynamicDestroy.facet]
// CHECK:STDOUT:   %x.var: ref <bound method> = var_storage %x.var_patt
// CHECK:STDOUT:   %Make.ref: %Make.type = name_ref Make, file.%Make.decl [concrete = constants.%Make]
// CHECK:STDOUT:   %c.ref.loc15_38: %C = name_ref c, %c
// CHECK:STDOUT:   %Make.call: init <bound method> = call %Make.ref(%c.ref.loc15_38)
// CHECK:STDOUT:   assign %x.var, %Make.call
// CHECK:STDOUT:   %.loc15_29: type = type_of %C.Get.bound.loc15 in [concrete = <bound method>] {
// CHECK:STDOUT:     %c.ref.loc15_24: %C = name_ref c, %c
// CHECK:STDOUT:     %Get.ref.loc15: %C.Get.type = name_ref Get, @C.%C.Get.decl [concrete = constants.%C.Get]
// CHECK:STDOUT:     %C.Get.bound.loc15: <bound method> = bound_method %c.ref.loc15_24, %Get.ref.loc15
// CHECK:STDOUT:   }
// CHECK:STDOUT:   %x: ref <bound method> = wrapper_binding x, %x.var
// CHECK:STDOUT:   name_binding_decl {
// CHECK:STDOUT:     %x.patt: %pattern_type.061 = ref_binding_pattern x [concrete = constants.%x.patt]
// CHECK:STDOUT:     %x.var_patt: %pattern_type.061 = var_pattern %x.patt [concrete = constants.%x.var_patt]
// CHECK:STDOUT:   }
// CHECK:STDOUT:   %Destroy.facet.loc15_3.1: %Destroy.type = facet_value <bound method>, (constants.%custom_witness.b80, constants.%DestroyImpl.impl_witness.691) [concrete = constants.%Destroy.facet]
// CHECK:STDOUT:   %.loc15_3.1: %Destroy.type = converted <bound method>, %Destroy.facet.loc15_3.1 [concrete = constants.%Destroy.facet]
// CHECK:STDOUT:   %Destroy.facet.loc15_3.2: %Destroy.type = facet_value <bound method>, (constants.%custom_witness.b80, constants.%DestroyImpl.impl_witness.691) [concrete = constants.%Destroy.facet]
// CHECK:STDOUT:   %.loc15_3.2: %Destroy.type = converted <bound method>, %Destroy.facet.loc15_3.2 [concrete = constants.%Destroy.facet]
// CHECK:STDOUT:   <elided>
// CHECK:STDOUT:   %SelfDestruct.call: init %empty_tuple.type = call %SelfDestruct.specific_fn(%x.var)
// CHECK:STDOUT:   <elided>
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: fn @SubobjectDestroy.WithSelf.Op.loc11(%self.param: ref <bound method>) = "no_op";
// CHECK:STDOUT:
// CHECK:STDOUT: --- todo_dynamic_char_literal.carbon = $todo_dynamic_char_literal
// CHECK:STDOUT:
// CHECK:STDOUT: constants {
// CHECK:STDOUT:   type: type = facet_type <type> [concrete]
// CHECK:STDOUT:   %empty_tuple.type: type = tuple_type () [concrete]
// CHECK:STDOUT:   %SubobjectDestroy.type: type = facet_type <@SubobjectDestroy> [concrete]
// CHECK:STDOUT:   %pattern_type.8c6: type = pattern_type Core.CharLiteral [concrete]
// CHECK:STDOUT:   %SubobjectDestroy.WithSelf.Op.type.687: type = fn_type @SubobjectDestroy.WithSelf.Op.loc5 [concrete]
// CHECK:STDOUT:   %SubobjectDestroy.WithSelf.Op.30f: %SubobjectDestroy.WithSelf.Op.type.687 = struct_value () [concrete]
// CHECK:STDOUT:   %custom_witness.b80: <witness> = custom_witness (%SubobjectDestroy.WithSelf.Op.30f), @SubobjectDestroy [concrete]
// CHECK:STDOUT:   %SubobjectDestroy.facet.576: %SubobjectDestroy.type = facet_value Core.CharLiteral, (%custom_witness.b80) [concrete]
// CHECK:STDOUT:   %Destroy.type: type = facet_type <@Destroy> [concrete]
// CHECK:STDOUT:   %DestroyImpl.type: type = facet_type <@DestroyImpl> [concrete]
// CHECK:STDOUT:   %T.09f: %SubobjectDestroy.type = symbolic_binding T, 0 [symbolic]
// CHECK:STDOUT:   %T.as_type.as.DestroyImpl.impl.Op.type.dea: type = fn_type @T.as_type.as.DestroyImpl.impl.Op, @T.as_type.as.DestroyImpl.impl(%T.09f) [symbolic]
// CHECK:STDOUT:   %T.as_type.as.DestroyImpl.impl.Op.6e5: %T.as_type.as.DestroyImpl.impl.Op.type.dea = struct_value () [symbolic]
// CHECK:STDOUT:   %DestroyImpl.impl_witness.96a: <witness> = impl_witness imports.%DestroyImpl.impl_witness_table, @T.as_type.as.DestroyImpl.impl(%SubobjectDestroy.facet.576) [concrete]
// CHECK:STDOUT:   %Destroy.facet: %Destroy.type = facet_value Core.CharLiteral, (%custom_witness.b80, %DestroyImpl.impl_witness.96a) [concrete]
// CHECK:STDOUT:   %DynamicDestroy.type: type = facet_type <@DynamicDestroy> [concrete]
// CHECK:STDOUT:   %custom_witness.0b5: <witness> = custom_witness (), @DynamicDestroyImpl [concrete]
// CHECK:STDOUT:   %DynamicDestroy.facet: %DynamicDestroy.type = facet_value Core.CharLiteral, (%custom_witness.b80, %DestroyImpl.impl_witness.96a, %custom_witness.0b5) [concrete]
// CHECK:STDOUT:   %x.patt: %pattern_type.8c6 = ref_binding_pattern x [concrete]
// CHECK:STDOUT:   %x.var_patt: %pattern_type.8c6 = var_pattern %x.patt [concrete]
// CHECK:STDOUT:   %.b9b: Core.CharLiteral = char_value U+0063 [concrete]
// CHECK:STDOUT:   %Copy.type: type = facet_type <@Copy> [concrete]
// CHECK:STDOUT:   %Copy.impl_witness.f54: <witness> = impl_witness imports.%Copy.impl_witness_table.021 [concrete]
// CHECK:STDOUT:   %Copy.facet: %Copy.type = facet_value Core.CharLiteral, (%Copy.impl_witness.f54) [concrete]
// CHECK:STDOUT:   %Copy.WithSelf.Op.type.2c5: type = fn_type @Copy.WithSelf.Op, @Copy.WithSelf(%Copy.facet) [concrete]
// CHECK:STDOUT:   %.1c4: type = fn_type_with_self_type %Copy.WithSelf.Op.type.2c5, %Copy.facet [concrete]
// CHECK:STDOUT:   %Core.CharLiteral.as.Copy.impl.Op.type: type = fn_type @Core.CharLiteral.as.Copy.impl.Op [concrete]
// CHECK:STDOUT:   %Core.CharLiteral.as.Copy.impl.Op: %Core.CharLiteral.as.Copy.impl.Op.type = struct_value () [concrete]
// CHECK:STDOUT:   %Core.CharLiteral.as.Copy.impl.Op.bound: <bound method> = bound_method %.b9b, %Core.CharLiteral.as.Copy.impl.Op [concrete]
// CHECK:STDOUT:   %SelfDestruct.type: type = fn_type @SelfDestruct [concrete]
// CHECK:STDOUT:   %SelfDestruct: %SelfDestruct.type = struct_value () [concrete]
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: imports {
// CHECK:STDOUT:   %Core: <namespace> = namespace file.%Core.import, [concrete] {
// CHECK:STDOUT:     .CharLiteral = %Core.CharLiteral
// CHECK:STDOUT:     .SubobjectDestroy = %Core.SubobjectDestroy
// CHECK:STDOUT:     .Destroy = %Core.Destroy
// CHECK:STDOUT:     .DynamicDestroy = %Core.DynamicDestroy
// CHECK:STDOUT:     .DestroyImpl = %Core.DestroyImpl
// CHECK:STDOUT:     .Copy = %Core.Copy
// CHECK:STDOUT:     .SelfDestruct = %Core.SelfDestruct
// CHECK:STDOUT:     import Core//prelude
// CHECK:STDOUT:     import Core//prelude/...
// CHECK:STDOUT:   }
// CHECK:STDOUT:   %Core.CharLiteral: type = import_ref Core//prelude/parts/char, CharLiteral, loaded [concrete = Core.CharLiteral]
// CHECK:STDOUT:   %Core.SubobjectDestroy: type = import_ref Core//prelude/parts/destroy, SubobjectDestroy, loaded [concrete = constants.%SubobjectDestroy.type]
// CHECK:STDOUT:   %Core.Destroy: type = import_ref Core//prelude/parts/destroy, Destroy, loaded [concrete = constants.%Destroy.type]
// CHECK:STDOUT:   %Core.import_ref.74d: @T.as_type.as.DestroyImpl.impl.%T.as_type.as.DestroyImpl.impl.Op.type (%T.as_type.as.DestroyImpl.impl.Op.type.dea) = import_ref Core//prelude/parts/destroy, loc{{\d+_\d+}}, loaded [symbolic = @T.as_type.as.DestroyImpl.impl.%T.as_type.as.DestroyImpl.impl.Op (constants.%T.as_type.as.DestroyImpl.impl.Op.6e5)]
// CHECK:STDOUT:   %DestroyImpl.impl_witness_table = impl_witness_table (%Core.import_ref.74d), @T.as_type.as.DestroyImpl.impl [concrete]
// CHECK:STDOUT:   %Core.DynamicDestroy: type = import_ref Core//prelude/parts/destroy, DynamicDestroy, loaded [concrete = constants.%DynamicDestroy.type]
// CHECK:STDOUT:   %Core.DestroyImpl: type = import_ref Core//prelude/parts/destroy, DestroyImpl, loaded [concrete = constants.%DestroyImpl.type]
// CHECK:STDOUT:   %Core.Copy: type = import_ref Core//prelude/parts/copy, Copy, loaded [concrete = constants.%Copy.type]
// CHECK:STDOUT:   %Core.import_ref.9c3: %Core.CharLiteral.as.Copy.impl.Op.type = import_ref Core//prelude/parts/copy, loc{{\d+_\d+}}, loaded [concrete = constants.%Core.CharLiteral.as.Copy.impl.Op]
// CHECK:STDOUT:   %Copy.impl_witness_table.021 = impl_witness_table (%Core.import_ref.9c3), @Core.CharLiteral.as.Copy.impl [concrete]
// CHECK:STDOUT:   %Core.SelfDestruct: %SelfDestruct.type = import_ref Core//prelude/parts/destroy, SelfDestruct, loaded [concrete = constants.%SelfDestruct]
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: fn @Test() {
// CHECK:STDOUT: !entry:
// CHECK:STDOUT:   %Core.ref.loc5_3: <namespace> = name_ref Core, imports.%Core [concrete = imports.%Core]
// CHECK:STDOUT:   %CharLiteral.ref.loc5: type = name_ref CharLiteral, imports.%Core.CharLiteral [concrete = Core.CharLiteral]
// CHECK:STDOUT:   %Core.ref.loc5_23: <namespace> = name_ref Core, imports.%Core [concrete = imports.%Core]
// CHECK:STDOUT:   %SubobjectDestroy.ref: type = name_ref SubobjectDestroy, imports.%Core.SubobjectDestroy [concrete = constants.%SubobjectDestroy.type]
// CHECK:STDOUT:   %SubobjectDestroy.facet: %SubobjectDestroy.type = facet_value %CharLiteral.ref.loc5, (constants.%custom_witness.b80) [concrete = constants.%SubobjectDestroy.facet.576]
// CHECK:STDOUT:   %.loc5: %SubobjectDestroy.type = converted %CharLiteral.ref.loc5, %SubobjectDestroy.facet [concrete = constants.%SubobjectDestroy.facet.576]
// CHECK:STDOUT:   %Core.ref.loc6_3: <namespace> = name_ref Core, imports.%Core [concrete = imports.%Core]
// CHECK:STDOUT:   %CharLiteral.ref.loc6: type = name_ref CharLiteral, imports.%Core.CharLiteral [concrete = Core.CharLiteral]
// CHECK:STDOUT:   %Core.ref.loc6_23: <namespace> = name_ref Core, imports.%Core [concrete = imports.%Core]
// CHECK:STDOUT:   %Destroy.ref: type = name_ref Destroy, imports.%Core.Destroy [concrete = constants.%Destroy.type]
// CHECK:STDOUT:   %Destroy.facet.loc6: %Destroy.type = facet_value %CharLiteral.ref.loc6, (constants.%custom_witness.b80, constants.%DestroyImpl.impl_witness.96a) [concrete = constants.%Destroy.facet]
// CHECK:STDOUT:   %.loc6: %Destroy.type = converted %CharLiteral.ref.loc6, %Destroy.facet.loc6 [concrete = constants.%Destroy.facet]
// CHECK:STDOUT:   %Core.ref.loc7_3: <namespace> = name_ref Core, imports.%Core [concrete = imports.%Core]
// CHECK:STDOUT:   %CharLiteral.ref.loc7: type = name_ref CharLiteral, imports.%Core.CharLiteral [concrete = Core.CharLiteral]
// CHECK:STDOUT:   %Core.ref.loc7_23: <namespace> = name_ref Core, imports.%Core [concrete = imports.%Core]
// CHECK:STDOUT:   %DynamicDestroy.ref: type = name_ref DynamicDestroy, imports.%Core.DynamicDestroy [concrete = constants.%DynamicDestroy.type]
// CHECK:STDOUT:   %DynamicDestroy.facet: %DynamicDestroy.type = facet_value %CharLiteral.ref.loc7, (constants.%custom_witness.b80, constants.%DestroyImpl.impl_witness.96a, constants.%custom_witness.0b5) [concrete = constants.%DynamicDestroy.facet]
// CHECK:STDOUT:   %.loc7: %DynamicDestroy.type = converted %CharLiteral.ref.loc7, %DynamicDestroy.facet [concrete = constants.%DynamicDestroy.facet]
// CHECK:STDOUT:   %x.var: ref Core.CharLiteral = var_storage %x.var_patt
// CHECK:STDOUT:   %.loc9_36: Core.CharLiteral = char_value U+0063 [concrete = constants.%.b9b]
// CHECK:STDOUT:   %impl.elem0: %.1c4 = impl_witness_access constants.%Copy.impl_witness.f54, element0 [concrete = constants.%Core.CharLiteral.as.Copy.impl.Op]
// CHECK:STDOUT:   %bound_method: <bound method> = bound_method %.loc9_36, %impl.elem0 [concrete = constants.%Core.CharLiteral.as.Copy.impl.Op.bound]
// CHECK:STDOUT:   %Core.CharLiteral.as.Copy.impl.Op.call: init Core.CharLiteral = call %bound_method(%.loc9_36) [concrete = constants.%.b9b]
// CHECK:STDOUT:   assign %x.var, %Core.CharLiteral.as.Copy.impl.Op.call
// CHECK:STDOUT:   %.loc9_21: type = splice_block %CharLiteral.ref.loc9 [concrete = Core.CharLiteral] {
// CHECK:STDOUT:     %Core.ref.loc9: <namespace> = name_ref Core, imports.%Core [concrete = imports.%Core]
// CHECK:STDOUT:     %CharLiteral.ref.loc9: type = name_ref CharLiteral, imports.%Core.CharLiteral [concrete = Core.CharLiteral]
// CHECK:STDOUT:   }
// CHECK:STDOUT:   %x: ref Core.CharLiteral = wrapper_binding x, %x.var
// CHECK:STDOUT:   name_binding_decl {
// CHECK:STDOUT:     %x.patt: %pattern_type.8c6 = ref_binding_pattern x [concrete = constants.%x.patt]
// CHECK:STDOUT:     %x.var_patt: %pattern_type.8c6 = var_pattern %x.patt [concrete = constants.%x.var_patt]
// CHECK:STDOUT:   }
// CHECK:STDOUT:   %Destroy.facet.loc9_3.1: %Destroy.type = facet_value Core.CharLiteral, (constants.%custom_witness.b80, constants.%DestroyImpl.impl_witness.96a) [concrete = constants.%Destroy.facet]
// CHECK:STDOUT:   %.loc9_3.1: %Destroy.type = converted Core.CharLiteral, %Destroy.facet.loc9_3.1 [concrete = constants.%Destroy.facet]
// CHECK:STDOUT:   %Destroy.facet.loc9_3.2: %Destroy.type = facet_value Core.CharLiteral, (constants.%custom_witness.b80, constants.%DestroyImpl.impl_witness.96a) [concrete = constants.%Destroy.facet]
// CHECK:STDOUT:   %.loc9_3.2: %Destroy.type = converted Core.CharLiteral, %Destroy.facet.loc9_3.2 [concrete = constants.%Destroy.facet]
// CHECK:STDOUT:   <elided>
// CHECK:STDOUT:   %SelfDestruct.call: init %empty_tuple.type = call %SelfDestruct.specific_fn(%x.var)
// CHECK:STDOUT:   <elided>
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: fn @SubobjectDestroy.WithSelf.Op.loc5(%self.param: ref Core.CharLiteral) = "no_op";
// CHECK:STDOUT:
// CHECK:STDOUT: --- todo_dynamic_f64.carbon = $todo_dynamic_f64
// CHECK:STDOUT:
// CHECK:STDOUT: constants {
// CHECK:STDOUT:   type: type = facet_type <type> [concrete]
// CHECK:STDOUT:   %empty_tuple.type: type = tuple_type () [concrete]
// CHECK:STDOUT:   %int_64: Core.IntLiteral = int_value 64 [concrete]
// CHECK:STDOUT:   %Float.type: type = parameterized_class_name_type @Float [concrete]
// CHECK:STDOUT:   %Float.generic: %Float.type = struct_value () [concrete]
// CHECK:STDOUT:   %f64.761: type = class_type @Float, @Float(%int_64) [concrete]
// CHECK:STDOUT:   %SubobjectDestroy.type: type = facet_type <@SubobjectDestroy> [concrete]
// CHECK:STDOUT:   %f64.794: type = float_type %int_64, f64 [concrete]
// CHECK:STDOUT:   %DestroyImpl.type: type = facet_type <@DestroyImpl> [concrete]
// CHECK:STDOUT:   %T.09f: %SubobjectDestroy.type = symbolic_binding T, 0 [symbolic]
// CHECK:STDOUT:   %T.as_type.as.DestroyImpl.impl.Op.type.dea: type = fn_type @T.as_type.as.DestroyImpl.impl.Op, @T.as_type.as.DestroyImpl.impl(%T.09f) [symbolic]
// CHECK:STDOUT:   %T.as_type.as.DestroyImpl.impl.Op.6e5: %T.as_type.as.DestroyImpl.impl.Op.type.dea = struct_value () [symbolic]
// CHECK:STDOUT:   %pattern_type.667: type = pattern_type %f64.761 [concrete]
// CHECK:STDOUT:   %SubobjectDestroy.WithSelf.Op.type.6870fd.2: type = fn_type @SubobjectDestroy.WithSelf.Op.loc5_7.2 [concrete]
// CHECK:STDOUT:   %SubobjectDestroy.WithSelf.Op.30f1ee.2: %SubobjectDestroy.WithSelf.Op.type.6870fd.2 = struct_value () [concrete]
// CHECK:STDOUT:   %custom_witness.b80ef6.2: <witness> = custom_witness (%SubobjectDestroy.WithSelf.Op.30f1ee.2), @SubobjectDestroy [concrete]
// CHECK:STDOUT:   %SubobjectDestroy.facet.47f: %SubobjectDestroy.type = facet_value %f64.761, (%custom_witness.b80ef6.2) [concrete]
// CHECK:STDOUT:   %Destroy.type: type = facet_type <@Destroy> [concrete]
// CHECK:STDOUT:   %DestroyImpl.impl_witness.a23: <witness> = impl_witness imports.%DestroyImpl.impl_witness_table, @T.as_type.as.DestroyImpl.impl(%SubobjectDestroy.facet.47f) [concrete]
// CHECK:STDOUT:   %Destroy.facet: %Destroy.type = facet_value %f64.761, (%custom_witness.b80ef6.2, %DestroyImpl.impl_witness.a23) [concrete]
// CHECK:STDOUT:   %DynamicDestroy.type: type = facet_type <@DynamicDestroy> [concrete]
// CHECK:STDOUT:   %custom_witness.0b5: <witness> = custom_witness (), @DynamicDestroyImpl [concrete]
// CHECK:STDOUT:   %DynamicDestroy.facet: %DynamicDestroy.type = facet_value %f64.761, (%custom_witness.b80ef6.2, %DestroyImpl.impl_witness.a23, %custom_witness.0b5) [concrete]
// CHECK:STDOUT:   %x.patt: %pattern_type.667 = ref_binding_pattern x [concrete]
// CHECK:STDOUT:   %x.var_patt: %pattern_type.667 = var_pattern %x.patt [concrete]
// CHECK:STDOUT:   %float.1f7: Core.FloatLiteral = float_literal_value 0e-1 [concrete]
// CHECK:STDOUT:   %ImplicitAs.type.0ff: type = generic_interface_type @ImplicitAs [concrete]
// CHECK:STDOUT:   %ImplicitAs.generic: %ImplicitAs.type.0ff = struct_value () [concrete]
// CHECK:STDOUT:   %ImplicitAs.type.068: type = facet_type <@ImplicitAs, @ImplicitAs(%f64.761)> [concrete]
// CHECK:STDOUT:   %To: Core.IntLiteral = symbolic_binding To, 0 [symbolic]
// CHECK:STDOUT:   %Core.FloatLiteral.as.ImplicitAs.impl.Convert.type.c1a: type = fn_type @Core.FloatLiteral.as.ImplicitAs.impl.Convert, @Core.FloatLiteral.as.ImplicitAs.impl(%To) [symbolic]
// CHECK:STDOUT:   %Core.FloatLiteral.as.ImplicitAs.impl.Convert.48f: %Core.FloatLiteral.as.ImplicitAs.impl.Convert.type.c1a = struct_value () [symbolic]
// CHECK:STDOUT:   %ImplicitAs.impl_witness.1d6: <witness> = impl_witness imports.%ImplicitAs.impl_witness_table, @Core.FloatLiteral.as.ImplicitAs.impl(%int_64) [concrete]
// CHECK:STDOUT:   %ImplicitAs.facet: %ImplicitAs.type.068 = facet_value Core.FloatLiteral, (%ImplicitAs.impl_witness.1d6) [concrete]
// CHECK:STDOUT:   %ImplicitAs.WithSelf.Convert.type.62d: type = fn_type @ImplicitAs.WithSelf.Convert, @ImplicitAs.WithSelf(%f64.761, %ImplicitAs.facet) [concrete]
// CHECK:STDOUT:   %.b5b: type = fn_type_with_self_type %ImplicitAs.WithSelf.Convert.type.62d, %ImplicitAs.facet [concrete]
// CHECK:STDOUT:   %Core.FloatLiteral.as.ImplicitAs.impl.Convert.type.b39: type = fn_type @Core.FloatLiteral.as.ImplicitAs.impl.Convert, @Core.FloatLiteral.as.ImplicitAs.impl(%int_64) [concrete]
// CHECK:STDOUT:   %Core.FloatLiteral.as.ImplicitAs.impl.Convert.9d0: %Core.FloatLiteral.as.ImplicitAs.impl.Convert.type.b39 = struct_value () [concrete]
// CHECK:STDOUT:   %Core.FloatLiteral.as.ImplicitAs.impl.Convert.bound: <bound method> = bound_method %float.1f7, %Core.FloatLiteral.as.ImplicitAs.impl.Convert.9d0 [concrete]
// CHECK:STDOUT:   %Core.FloatLiteral.as.ImplicitAs.impl.Convert.specific_fn: <specific function> = specific_function %Core.FloatLiteral.as.ImplicitAs.impl.Convert.9d0, @Core.FloatLiteral.as.ImplicitAs.impl.Convert(%int_64) [concrete]
// CHECK:STDOUT:   %bound_method: <bound method> = bound_method %float.1f7, %Core.FloatLiteral.as.ImplicitAs.impl.Convert.specific_fn [concrete]
// CHECK:STDOUT:   %float.73e: %f64.761 = float_value 0 [concrete]
// CHECK:STDOUT:   %SelfDestruct.type: type = fn_type @SelfDestruct [concrete]
// CHECK:STDOUT:   %SelfDestruct: %SelfDestruct.type = struct_value () [concrete]
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: imports {
// CHECK:STDOUT:   %Core: <namespace> = namespace file.%Core.import, [concrete] {
// CHECK:STDOUT:     .Float = %Core.Float
// CHECK:STDOUT:     .SubobjectDestroy = %Core.SubobjectDestroy
// CHECK:STDOUT:     .DestroyImpl = %Core.DestroyImpl
// CHECK:STDOUT:     .Destroy = %Core.Destroy
// CHECK:STDOUT:     .DynamicDestroy = %Core.DynamicDestroy
// CHECK:STDOUT:     .ImplicitAs = %Core.ImplicitAs
// CHECK:STDOUT:     .SelfDestruct = %Core.SelfDestruct
// CHECK:STDOUT:     import Core//prelude
// CHECK:STDOUT:     import Core//prelude/...
// CHECK:STDOUT:   }
// CHECK:STDOUT:   %Core.Float: %Float.type = import_ref Core//prelude/parts/float, Float, loaded [concrete = constants.%Float.generic]
// CHECK:STDOUT:   %Core.SubobjectDestroy: type = import_ref Core//prelude/parts/destroy, SubobjectDestroy, loaded [concrete = constants.%SubobjectDestroy.type]
// CHECK:STDOUT:   %Core.DestroyImpl: type = import_ref Core//prelude/parts/destroy, DestroyImpl, loaded [concrete = constants.%DestroyImpl.type]
// CHECK:STDOUT:   %Core.import_ref.74d: @T.as_type.as.DestroyImpl.impl.%T.as_type.as.DestroyImpl.impl.Op.type (%T.as_type.as.DestroyImpl.impl.Op.type.dea) = import_ref Core//prelude/parts/destroy, loc{{\d+_\d+}}, loaded [symbolic = @T.as_type.as.DestroyImpl.impl.%T.as_type.as.DestroyImpl.impl.Op (constants.%T.as_type.as.DestroyImpl.impl.Op.6e5)]
// CHECK:STDOUT:   %DestroyImpl.impl_witness_table = impl_witness_table (%Core.import_ref.74d), @T.as_type.as.DestroyImpl.impl [concrete]
// CHECK:STDOUT:   %Core.Destroy: type = import_ref Core//prelude/parts/destroy, Destroy, loaded [concrete = constants.%Destroy.type]
// CHECK:STDOUT:   %Core.DynamicDestroy: type = import_ref Core//prelude/parts/destroy, DynamicDestroy, loaded [concrete = constants.%DynamicDestroy.type]
// CHECK:STDOUT:   %Core.ImplicitAs: %ImplicitAs.type.0ff = import_ref Core//prelude/parts/as, ImplicitAs, loaded [concrete = constants.%ImplicitAs.generic]
// CHECK:STDOUT:   %Core.import_ref.0c7: @Core.FloatLiteral.as.ImplicitAs.impl.%Core.FloatLiteral.as.ImplicitAs.impl.Convert.type (%Core.FloatLiteral.as.ImplicitAs.impl.Convert.type.c1a) = import_ref Core//prelude/parts/float, loc{{\d+_\d+}}, loaded [symbolic = @Core.FloatLiteral.as.ImplicitAs.impl.%Core.FloatLiteral.as.ImplicitAs.impl.Convert (constants.%Core.FloatLiteral.as.ImplicitAs.impl.Convert.48f)]
// CHECK:STDOUT:   %ImplicitAs.impl_witness_table = impl_witness_table (%Core.import_ref.0c7), @Core.FloatLiteral.as.ImplicitAs.impl [concrete]
// CHECK:STDOUT:   %Core.SelfDestruct: %SelfDestruct.type = import_ref Core//prelude/parts/destroy, SelfDestruct, loaded [concrete = constants.%SelfDestruct]
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: fn @Test() {
// CHECK:STDOUT: !entry:
// CHECK:STDOUT:   %f64.loc5: type = type_literal constants.%f64.761 [concrete = constants.%f64.761]
// CHECK:STDOUT:   %Core.ref.loc5: <namespace> = name_ref Core, imports.%Core [concrete = imports.%Core]
// CHECK:STDOUT:   %SubobjectDestroy.ref: type = name_ref SubobjectDestroy, imports.%Core.SubobjectDestroy [concrete = constants.%SubobjectDestroy.type]
// CHECK:STDOUT:   %SubobjectDestroy.facet: %SubobjectDestroy.type = facet_value %f64.loc5, (constants.%custom_witness.b80ef6.2) [concrete = constants.%SubobjectDestroy.facet.47f]
// CHECK:STDOUT:   %.loc5: %SubobjectDestroy.type = converted %f64.loc5, %SubobjectDestroy.facet [concrete = constants.%SubobjectDestroy.facet.47f]
// CHECK:STDOUT:   %f64.loc6: type = type_literal constants.%f64.761 [concrete = constants.%f64.761]
// CHECK:STDOUT:   %Core.ref.loc6: <namespace> = name_ref Core, imports.%Core [concrete = imports.%Core]
// CHECK:STDOUT:   %Destroy.ref: type = name_ref Destroy, imports.%Core.Destroy [concrete = constants.%Destroy.type]
// CHECK:STDOUT:   %Destroy.facet.loc6: %Destroy.type = facet_value %f64.loc6, (constants.%custom_witness.b80ef6.2, constants.%DestroyImpl.impl_witness.a23) [concrete = constants.%Destroy.facet]
// CHECK:STDOUT:   %.loc6: %Destroy.type = converted %f64.loc6, %Destroy.facet.loc6 [concrete = constants.%Destroy.facet]
// CHECK:STDOUT:   %f64.loc7: type = type_literal constants.%f64.761 [concrete = constants.%f64.761]
// CHECK:STDOUT:   %Core.ref.loc7: <namespace> = name_ref Core, imports.%Core [concrete = imports.%Core]
// CHECK:STDOUT:   %DynamicDestroy.ref: type = name_ref DynamicDestroy, imports.%Core.DynamicDestroy [concrete = constants.%DynamicDestroy.type]
// CHECK:STDOUT:   %DynamicDestroy.facet: %DynamicDestroy.type = facet_value %f64.loc7, (constants.%custom_witness.b80ef6.2, constants.%DestroyImpl.impl_witness.a23, constants.%custom_witness.0b5) [concrete = constants.%DynamicDestroy.facet]
// CHECK:STDOUT:   %.loc7: %DynamicDestroy.type = converted %f64.loc7, %DynamicDestroy.facet [concrete = constants.%DynamicDestroy.facet]
// CHECK:STDOUT:   %x.var: ref %f64.761 = var_storage %x.var_patt
// CHECK:STDOUT:   %float: Core.FloatLiteral = float_literal_value 0e-1 [concrete = constants.%float.1f7]
// CHECK:STDOUT:   %impl.elem0: %.b5b = impl_witness_access constants.%ImplicitAs.impl_witness.1d6, element0 [concrete = constants.%Core.FloatLiteral.as.ImplicitAs.impl.Convert.9d0]
// CHECK:STDOUT:   %bound_method.loc9_3.1: <bound method> = bound_method %float, %impl.elem0 [concrete = constants.%Core.FloatLiteral.as.ImplicitAs.impl.Convert.bound]
// CHECK:STDOUT:   %specific_fn: <specific function> = specific_function %impl.elem0, @Core.FloatLiteral.as.ImplicitAs.impl.Convert(constants.%int_64) [concrete = constants.%Core.FloatLiteral.as.ImplicitAs.impl.Convert.specific_fn]
// CHECK:STDOUT:   %bound_method.loc9_3.2: <bound method> = bound_method %float, %specific_fn [concrete = constants.%bound_method]
// CHECK:STDOUT:   %Core.FloatLiteral.as.ImplicitAs.impl.Convert.call: init %f64.761 = call %bound_method.loc9_3.2(%float) [concrete = constants.%float.73e]
// CHECK:STDOUT:   %.loc9_3.1: init %f64.761 = converted %float, %Core.FloatLiteral.as.ImplicitAs.impl.Convert.call [concrete = constants.%float.73e]
// CHECK:STDOUT:   assign %x.var, %.loc9_3.1
// CHECK:STDOUT:   %f64.loc9: type = type_literal constants.%f64.761 [concrete = constants.%f64.761]
// CHECK:STDOUT:   %x: ref %f64.761 = wrapper_binding x, %x.var
// CHECK:STDOUT:   name_binding_decl {
// CHECK:STDOUT:     %x.patt: %pattern_type.667 = ref_binding_pattern x [concrete = constants.%x.patt]
// CHECK:STDOUT:     %x.var_patt: %pattern_type.667 = var_pattern %x.patt [concrete = constants.%x.var_patt]
// CHECK:STDOUT:   }
// CHECK:STDOUT:   %Destroy.facet.loc9_3.1: %Destroy.type = facet_value constants.%f64.761, (constants.%custom_witness.b80ef6.2, constants.%DestroyImpl.impl_witness.a23) [concrete = constants.%Destroy.facet]
// CHECK:STDOUT:   %.loc9_3.2: %Destroy.type = converted constants.%f64.761, %Destroy.facet.loc9_3.1 [concrete = constants.%Destroy.facet]
// CHECK:STDOUT:   %Destroy.facet.loc9_3.2: %Destroy.type = facet_value constants.%f64.761, (constants.%custom_witness.b80ef6.2, constants.%DestroyImpl.impl_witness.a23) [concrete = constants.%Destroy.facet]
// CHECK:STDOUT:   %.loc9_3.3: %Destroy.type = converted constants.%f64.761, %Destroy.facet.loc9_3.2 [concrete = constants.%Destroy.facet]
// CHECK:STDOUT:   <elided>
// CHECK:STDOUT:   %SelfDestruct.call: init %empty_tuple.type = call %SelfDestruct.specific_fn(%x.var)
// CHECK:STDOUT:   <elided>
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: fn @SubobjectDestroy.WithSelf.Op.loc5_7.1(%self.param: ref %f64.794) = "no_op";
// CHECK:STDOUT:
// CHECK:STDOUT: fn @SubobjectDestroy.WithSelf.Op.loc5_7.2(%self.param: ref %f64.761) = "no_op";
// CHECK:STDOUT:
// CHECK:STDOUT: --- todo_dynamic_float_literal.carbon = $todo_dynamic_float_literal
// CHECK:STDOUT:
// CHECK:STDOUT: constants {
// CHECK:STDOUT:   type: type = facet_type <type> [concrete]
// CHECK:STDOUT:   %empty_tuple.type: type = tuple_type () [concrete]
// CHECK:STDOUT:   %SubobjectDestroy.type: type = facet_type <@SubobjectDestroy> [concrete]
// CHECK:STDOUT:   %pattern_type.dab: type = pattern_type Core.FloatLiteral [concrete]
// CHECK:STDOUT:   %SubobjectDestroy.WithSelf.Op.type.687: type = fn_type @SubobjectDestroy.WithSelf.Op.loc5 [concrete]
// CHECK:STDOUT:   %SubobjectDestroy.WithSelf.Op.30f: %SubobjectDestroy.WithSelf.Op.type.687 = struct_value () [concrete]
// CHECK:STDOUT:   %custom_witness.b80: <witness> = custom_witness (%SubobjectDestroy.WithSelf.Op.30f), @SubobjectDestroy [concrete]
// CHECK:STDOUT:   %SubobjectDestroy.facet.d80: %SubobjectDestroy.type = facet_value Core.FloatLiteral, (%custom_witness.b80) [concrete]
// CHECK:STDOUT:   %Destroy.type: type = facet_type <@Destroy> [concrete]
// CHECK:STDOUT:   %DestroyImpl.type: type = facet_type <@DestroyImpl> [concrete]
// CHECK:STDOUT:   %T.09f: %SubobjectDestroy.type = symbolic_binding T, 0 [symbolic]
// CHECK:STDOUT:   %T.as_type.as.DestroyImpl.impl.Op.type.dea: type = fn_type @T.as_type.as.DestroyImpl.impl.Op, @T.as_type.as.DestroyImpl.impl(%T.09f) [symbolic]
// CHECK:STDOUT:   %T.as_type.as.DestroyImpl.impl.Op.6e5: %T.as_type.as.DestroyImpl.impl.Op.type.dea = struct_value () [symbolic]
// CHECK:STDOUT:   %DestroyImpl.impl_witness.62f: <witness> = impl_witness imports.%DestroyImpl.impl_witness_table, @T.as_type.as.DestroyImpl.impl(%SubobjectDestroy.facet.d80) [concrete]
// CHECK:STDOUT:   %Destroy.facet: %Destroy.type = facet_value Core.FloatLiteral, (%custom_witness.b80, %DestroyImpl.impl_witness.62f) [concrete]
// CHECK:STDOUT:   %DynamicDestroy.type: type = facet_type <@DynamicDestroy> [concrete]
// CHECK:STDOUT:   %custom_witness.0b5: <witness> = custom_witness (), @DynamicDestroyImpl [concrete]
// CHECK:STDOUT:   %DynamicDestroy.facet: %DynamicDestroy.type = facet_value Core.FloatLiteral, (%custom_witness.b80, %DestroyImpl.impl_witness.62f, %custom_witness.0b5) [concrete]
// CHECK:STDOUT:   %x.patt: %pattern_type.dab = ref_binding_pattern x [concrete]
// CHECK:STDOUT:   %x.var_patt: %pattern_type.dab = var_pattern %x.patt [concrete]
// CHECK:STDOUT:   %float: Core.FloatLiteral = float_literal_value 0e-1 [concrete]
// CHECK:STDOUT:   %Copy.type: type = facet_type <@Copy> [concrete]
// CHECK:STDOUT:   %Copy.impl_witness.a5c: <witness> = impl_witness imports.%Copy.impl_witness_table.fcf [concrete]
// CHECK:STDOUT:   %Copy.facet: %Copy.type = facet_value Core.FloatLiteral, (%Copy.impl_witness.a5c) [concrete]
// CHECK:STDOUT:   %Copy.WithSelf.Op.type.3d9: type = fn_type @Copy.WithSelf.Op, @Copy.WithSelf(%Copy.facet) [concrete]
// CHECK:STDOUT:   %.5ac: type = fn_type_with_self_type %Copy.WithSelf.Op.type.3d9, %Copy.facet [concrete]
// CHECK:STDOUT:   %Core.FloatLiteral.as.Copy.impl.Op.type: type = fn_type @Core.FloatLiteral.as.Copy.impl.Op [concrete]
// CHECK:STDOUT:   %Core.FloatLiteral.as.Copy.impl.Op: %Core.FloatLiteral.as.Copy.impl.Op.type = struct_value () [concrete]
// CHECK:STDOUT:   %Core.FloatLiteral.as.Copy.impl.Op.bound: <bound method> = bound_method %float, %Core.FloatLiteral.as.Copy.impl.Op [concrete]
// CHECK:STDOUT:   %SelfDestruct.type: type = fn_type @SelfDestruct [concrete]
// CHECK:STDOUT:   %SelfDestruct: %SelfDestruct.type = struct_value () [concrete]
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: imports {
// CHECK:STDOUT:   %Core: <namespace> = namespace file.%Core.import, [concrete] {
// CHECK:STDOUT:     .FloatLiteral = %Core.FloatLiteral
// CHECK:STDOUT:     .SubobjectDestroy = %Core.SubobjectDestroy
// CHECK:STDOUT:     .Destroy = %Core.Destroy
// CHECK:STDOUT:     .DynamicDestroy = %Core.DynamicDestroy
// CHECK:STDOUT:     .DestroyImpl = %Core.DestroyImpl
// CHECK:STDOUT:     .Copy = %Core.Copy
// CHECK:STDOUT:     .SelfDestruct = %Core.SelfDestruct
// CHECK:STDOUT:     import Core//prelude
// CHECK:STDOUT:     import Core//prelude/...
// CHECK:STDOUT:   }
// CHECK:STDOUT:   %Core.FloatLiteral: type = import_ref Core//prelude/parts/float_literal, FloatLiteral, loaded [concrete = Core.FloatLiteral]
// CHECK:STDOUT:   %Core.SubobjectDestroy: type = import_ref Core//prelude/parts/destroy, SubobjectDestroy, loaded [concrete = constants.%SubobjectDestroy.type]
// CHECK:STDOUT:   %Core.Destroy: type = import_ref Core//prelude/parts/destroy, Destroy, loaded [concrete = constants.%Destroy.type]
// CHECK:STDOUT:   %Core.import_ref.74d: @T.as_type.as.DestroyImpl.impl.%T.as_type.as.DestroyImpl.impl.Op.type (%T.as_type.as.DestroyImpl.impl.Op.type.dea) = import_ref Core//prelude/parts/destroy, loc{{\d+_\d+}}, loaded [symbolic = @T.as_type.as.DestroyImpl.impl.%T.as_type.as.DestroyImpl.impl.Op (constants.%T.as_type.as.DestroyImpl.impl.Op.6e5)]
// CHECK:STDOUT:   %DestroyImpl.impl_witness_table = impl_witness_table (%Core.import_ref.74d), @T.as_type.as.DestroyImpl.impl [concrete]
// CHECK:STDOUT:   %Core.DynamicDestroy: type = import_ref Core//prelude/parts/destroy, DynamicDestroy, loaded [concrete = constants.%DynamicDestroy.type]
// CHECK:STDOUT:   %Core.DestroyImpl: type = import_ref Core//prelude/parts/destroy, DestroyImpl, loaded [concrete = constants.%DestroyImpl.type]
// CHECK:STDOUT:   %Core.Copy: type = import_ref Core//prelude/parts/copy, Copy, loaded [concrete = constants.%Copy.type]
// CHECK:STDOUT:   %Core.import_ref.9c3: %Core.FloatLiteral.as.Copy.impl.Op.type = import_ref Core//prelude/parts/copy, loc{{\d+_\d+}}, loaded [concrete = constants.%Core.FloatLiteral.as.Copy.impl.Op]
// CHECK:STDOUT:   %Copy.impl_witness_table.fcf = impl_witness_table (%Core.import_ref.9c3), @Core.FloatLiteral.as.Copy.impl [concrete]
// CHECK:STDOUT:   %Core.SelfDestruct: %SelfDestruct.type = import_ref Core//prelude/parts/destroy, SelfDestruct, loaded [concrete = constants.%SelfDestruct]
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: fn @Test() {
// CHECK:STDOUT: !entry:
// CHECK:STDOUT:   %Core.ref.loc5_3: <namespace> = name_ref Core, imports.%Core [concrete = imports.%Core]
// CHECK:STDOUT:   %FloatLiteral.ref.loc5: type = name_ref FloatLiteral, imports.%Core.FloatLiteral [concrete = Core.FloatLiteral]
// CHECK:STDOUT:   %Core.ref.loc5_24: <namespace> = name_ref Core, imports.%Core [concrete = imports.%Core]
// CHECK:STDOUT:   %SubobjectDestroy.ref: type = name_ref SubobjectDestroy, imports.%Core.SubobjectDestroy [concrete = constants.%SubobjectDestroy.type]
// CHECK:STDOUT:   %SubobjectDestroy.facet: %SubobjectDestroy.type = facet_value %FloatLiteral.ref.loc5, (constants.%custom_witness.b80) [concrete = constants.%SubobjectDestroy.facet.d80]
// CHECK:STDOUT:   %.loc5: %SubobjectDestroy.type = converted %FloatLiteral.ref.loc5, %SubobjectDestroy.facet [concrete = constants.%SubobjectDestroy.facet.d80]
// CHECK:STDOUT:   %Core.ref.loc6_3: <namespace> = name_ref Core, imports.%Core [concrete = imports.%Core]
// CHECK:STDOUT:   %FloatLiteral.ref.loc6: type = name_ref FloatLiteral, imports.%Core.FloatLiteral [concrete = Core.FloatLiteral]
// CHECK:STDOUT:   %Core.ref.loc6_24: <namespace> = name_ref Core, imports.%Core [concrete = imports.%Core]
// CHECK:STDOUT:   %Destroy.ref: type = name_ref Destroy, imports.%Core.Destroy [concrete = constants.%Destroy.type]
// CHECK:STDOUT:   %Destroy.facet.loc6: %Destroy.type = facet_value %FloatLiteral.ref.loc6, (constants.%custom_witness.b80, constants.%DestroyImpl.impl_witness.62f) [concrete = constants.%Destroy.facet]
// CHECK:STDOUT:   %.loc6: %Destroy.type = converted %FloatLiteral.ref.loc6, %Destroy.facet.loc6 [concrete = constants.%Destroy.facet]
// CHECK:STDOUT:   %Core.ref.loc7_3: <namespace> = name_ref Core, imports.%Core [concrete = imports.%Core]
// CHECK:STDOUT:   %FloatLiteral.ref.loc7: type = name_ref FloatLiteral, imports.%Core.FloatLiteral [concrete = Core.FloatLiteral]
// CHECK:STDOUT:   %Core.ref.loc7_24: <namespace> = name_ref Core, imports.%Core [concrete = imports.%Core]
// CHECK:STDOUT:   %DynamicDestroy.ref: type = name_ref DynamicDestroy, imports.%Core.DynamicDestroy [concrete = constants.%DynamicDestroy.type]
// CHECK:STDOUT:   %DynamicDestroy.facet: %DynamicDestroy.type = facet_value %FloatLiteral.ref.loc7, (constants.%custom_witness.b80, constants.%DestroyImpl.impl_witness.62f, constants.%custom_witness.0b5) [concrete = constants.%DynamicDestroy.facet]
// CHECK:STDOUT:   %.loc7: %DynamicDestroy.type = converted %FloatLiteral.ref.loc7, %DynamicDestroy.facet [concrete = constants.%DynamicDestroy.facet]
// CHECK:STDOUT:   %x.var: ref Core.FloatLiteral = var_storage %x.var_patt
// CHECK:STDOUT:   %float: Core.FloatLiteral = float_literal_value 0e-1 [concrete = constants.%float]
// CHECK:STDOUT:   %impl.elem0: %.5ac = impl_witness_access constants.%Copy.impl_witness.a5c, element0 [concrete = constants.%Core.FloatLiteral.as.Copy.impl.Op]
// CHECK:STDOUT:   %bound_method: <bound method> = bound_method %float, %impl.elem0 [concrete = constants.%Core.FloatLiteral.as.Copy.impl.Op.bound]
// CHECK:STDOUT:   %Core.FloatLiteral.as.Copy.impl.Op.call: init Core.FloatLiteral = call %bound_method(%float) [concrete = constants.%float]
// CHECK:STDOUT:   assign %x.var, %Core.FloatLiteral.as.Copy.impl.Op.call
// CHECK:STDOUT:   %.loc9_21: type = splice_block %FloatLiteral.ref.loc9 [concrete = Core.FloatLiteral] {
// CHECK:STDOUT:     %Core.ref.loc9: <namespace> = name_ref Core, imports.%Core [concrete = imports.%Core]
// CHECK:STDOUT:     %FloatLiteral.ref.loc9: type = name_ref FloatLiteral, imports.%Core.FloatLiteral [concrete = Core.FloatLiteral]
// CHECK:STDOUT:   }
// CHECK:STDOUT:   %x: ref Core.FloatLiteral = wrapper_binding x, %x.var
// CHECK:STDOUT:   name_binding_decl {
// CHECK:STDOUT:     %x.patt: %pattern_type.dab = ref_binding_pattern x [concrete = constants.%x.patt]
// CHECK:STDOUT:     %x.var_patt: %pattern_type.dab = var_pattern %x.patt [concrete = constants.%x.var_patt]
// CHECK:STDOUT:   }
// CHECK:STDOUT:   %Destroy.facet.loc9_3.1: %Destroy.type = facet_value Core.FloatLiteral, (constants.%custom_witness.b80, constants.%DestroyImpl.impl_witness.62f) [concrete = constants.%Destroy.facet]
// CHECK:STDOUT:   %.loc9_3.1: %Destroy.type = converted Core.FloatLiteral, %Destroy.facet.loc9_3.1 [concrete = constants.%Destroy.facet]
// CHECK:STDOUT:   %Destroy.facet.loc9_3.2: %Destroy.type = facet_value Core.FloatLiteral, (constants.%custom_witness.b80, constants.%DestroyImpl.impl_witness.62f) [concrete = constants.%Destroy.facet]
// CHECK:STDOUT:   %.loc9_3.2: %Destroy.type = converted Core.FloatLiteral, %Destroy.facet.loc9_3.2 [concrete = constants.%Destroy.facet]
// CHECK:STDOUT:   <elided>
// CHECK:STDOUT:   %SelfDestruct.call: init %empty_tuple.type = call %SelfDestruct.specific_fn(%x.var)
// CHECK:STDOUT:   <elided>
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: fn @SubobjectDestroy.WithSelf.Op.loc5(%self.param: ref Core.FloatLiteral) = "no_op";
// CHECK:STDOUT:
// CHECK:STDOUT: --- todo_dynamic_form.carbon = $todo_dynamic_form
// CHECK:STDOUT:
// CHECK:STDOUT: constants {
// CHECK:STDOUT:   type: type = facet_type <type> [concrete]
// CHECK:STDOUT:   %Int.type: type = parameterized_class_name_type @Int [concrete]
// CHECK:STDOUT:   %empty_tuple.type: type = tuple_type () [concrete]
// CHECK:STDOUT:   %Int.generic: %Int.type = struct_value () [concrete]
// CHECK:STDOUT:   %pattern_type.13f: type = pattern_type Core.Form [concrete]
// CHECK:STDOUT:   %Make.type: type = fn_type @Make [concrete]
// CHECK:STDOUT:   %Make: %Make.type = struct_value () [concrete]
// CHECK:STDOUT:   %SubobjectDestroy.type: type = facet_type <@SubobjectDestroy> [concrete]
// CHECK:STDOUT:   %SubobjectDestroy.WithSelf.Op.type.687: type = fn_type @SubobjectDestroy.WithSelf.Op.loc8 [concrete]
// CHECK:STDOUT:   %SubobjectDestroy.WithSelf.Op.30f: %SubobjectDestroy.WithSelf.Op.type.687 = struct_value () [concrete]
// CHECK:STDOUT:   %custom_witness.b80: <witness> = custom_witness (%SubobjectDestroy.WithSelf.Op.30f), @SubobjectDestroy [concrete]
// CHECK:STDOUT:   %SubobjectDestroy.facet.4de: %SubobjectDestroy.type = facet_value Core.Form, (%custom_witness.b80) [concrete]
// CHECK:STDOUT:   %Destroy.type: type = facet_type <@Destroy> [concrete]
// CHECK:STDOUT:   %DestroyImpl.type: type = facet_type <@DestroyImpl> [concrete]
// CHECK:STDOUT:   %T.09f: %SubobjectDestroy.type = symbolic_binding T, 0 [symbolic]
// CHECK:STDOUT:   %T.as_type.as.DestroyImpl.impl.Op.type.dea: type = fn_type @T.as_type.as.DestroyImpl.impl.Op, @T.as_type.as.DestroyImpl.impl(%T.09f) [symbolic]
// CHECK:STDOUT:   %T.as_type.as.DestroyImpl.impl.Op.6e5: %T.as_type.as.DestroyImpl.impl.Op.type.dea = struct_value () [symbolic]
// CHECK:STDOUT:   %DestroyImpl.impl_witness.fb5: <witness> = impl_witness imports.%DestroyImpl.impl_witness_table, @T.as_type.as.DestroyImpl.impl(%SubobjectDestroy.facet.4de) [concrete]
// CHECK:STDOUT:   %Destroy.facet: %Destroy.type = facet_value Core.Form, (%custom_witness.b80, %DestroyImpl.impl_witness.fb5) [concrete]
// CHECK:STDOUT:   %DynamicDestroy.type: type = facet_type <@DynamicDestroy> [concrete]
// CHECK:STDOUT:   %custom_witness.0b5: <witness> = custom_witness (), @DynamicDestroyImpl [concrete]
// CHECK:STDOUT:   %DynamicDestroy.facet: %DynamicDestroy.type = facet_value Core.Form, (%custom_witness.b80, %DestroyImpl.impl_witness.fb5, %custom_witness.0b5) [concrete]
// CHECK:STDOUT:   %x.patt: %pattern_type.13f = ref_binding_pattern x [concrete]
// CHECK:STDOUT:   %x.var_patt: %pattern_type.13f = var_pattern %x.patt [concrete]
// CHECK:STDOUT:   %SelfDestruct.type: type = fn_type @SelfDestruct [concrete]
// CHECK:STDOUT:   %SelfDestruct: %SelfDestruct.type = struct_value () [concrete]
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: imports {
// CHECK:STDOUT:   %Core: <namespace> = namespace file.%Core.import, [concrete] {
// CHECK:STDOUT:     .Int = %Core.Int
// CHECK:STDOUT:     .SubobjectDestroy = %Core.SubobjectDestroy
// CHECK:STDOUT:     .Destroy = %Core.Destroy
// CHECK:STDOUT:     .DynamicDestroy = %Core.DynamicDestroy
// CHECK:STDOUT:     .DestroyImpl = %Core.DestroyImpl
// CHECK:STDOUT:     .SelfDestruct = %Core.SelfDestruct
// CHECK:STDOUT:     import Core//prelude
// CHECK:STDOUT:     import Core//prelude/...
// CHECK:STDOUT:   }
// CHECK:STDOUT:   %Core.Int: %Int.type = import_ref Core//prelude/parts/int, Int, loaded [concrete = constants.%Int.generic]
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
// CHECK:STDOUT:   %Form.ref.loc8: type = name_ref Form, file.%Form [concrete = Core.Form]
// CHECK:STDOUT:   %Core.ref.loc8: <namespace> = name_ref Core, imports.%Core [concrete = imports.%Core]
// CHECK:STDOUT:   %SubobjectDestroy.ref: type = name_ref SubobjectDestroy, imports.%Core.SubobjectDestroy [concrete = constants.%SubobjectDestroy.type]
// CHECK:STDOUT:   %SubobjectDestroy.facet: %SubobjectDestroy.type = facet_value %Form.ref.loc8, (constants.%custom_witness.b80) [concrete = constants.%SubobjectDestroy.facet.4de]
// CHECK:STDOUT:   %.loc8: %SubobjectDestroy.type = converted %Form.ref.loc8, %SubobjectDestroy.facet [concrete = constants.%SubobjectDestroy.facet.4de]
// CHECK:STDOUT:   %Form.ref.loc9: type = name_ref Form, file.%Form [concrete = Core.Form]
// CHECK:STDOUT:   %Core.ref.loc9: <namespace> = name_ref Core, imports.%Core [concrete = imports.%Core]
// CHECK:STDOUT:   %Destroy.ref: type = name_ref Destroy, imports.%Core.Destroy [concrete = constants.%Destroy.type]
// CHECK:STDOUT:   %Destroy.facet.loc9: %Destroy.type = facet_value %Form.ref.loc9, (constants.%custom_witness.b80, constants.%DestroyImpl.impl_witness.fb5) [concrete = constants.%Destroy.facet]
// CHECK:STDOUT:   %.loc9: %Destroy.type = converted %Form.ref.loc9, %Destroy.facet.loc9 [concrete = constants.%Destroy.facet]
// CHECK:STDOUT:   %Form.ref.loc10: type = name_ref Form, file.%Form [concrete = Core.Form]
// CHECK:STDOUT:   %Core.ref.loc10: <namespace> = name_ref Core, imports.%Core [concrete = imports.%Core]
// CHECK:STDOUT:   %DynamicDestroy.ref: type = name_ref DynamicDestroy, imports.%Core.DynamicDestroy [concrete = constants.%DynamicDestroy.type]
// CHECK:STDOUT:   %DynamicDestroy.facet: %DynamicDestroy.type = facet_value %Form.ref.loc10, (constants.%custom_witness.b80, constants.%DestroyImpl.impl_witness.fb5, constants.%custom_witness.0b5) [concrete = constants.%DynamicDestroy.facet]
// CHECK:STDOUT:   %.loc10: %DynamicDestroy.type = converted %Form.ref.loc10, %DynamicDestroy.facet [concrete = constants.%DynamicDestroy.facet]
// CHECK:STDOUT:   %x.var: ref Core.Form = var_storage %x.var_patt
// CHECK:STDOUT:   %Make.ref: %Make.type = name_ref Make, file.%Make.decl [concrete = constants.%Make]
// CHECK:STDOUT:   %Make.call: init Core.Form = call %Make.ref()
// CHECK:STDOUT:   assign %x.var, %Make.call
// CHECK:STDOUT:   %Form.ref.loc12: type = name_ref Form, file.%Form [concrete = Core.Form]
// CHECK:STDOUT:   %x: ref Core.Form = wrapper_binding x, %x.var
// CHECK:STDOUT:   name_binding_decl {
// CHECK:STDOUT:     %x.patt: %pattern_type.13f = ref_binding_pattern x [concrete = constants.%x.patt]
// CHECK:STDOUT:     %x.var_patt: %pattern_type.13f = var_pattern %x.patt [concrete = constants.%x.var_patt]
// CHECK:STDOUT:   }
// CHECK:STDOUT:   %Destroy.facet.loc12_3.1: %Destroy.type = facet_value Core.Form, (constants.%custom_witness.b80, constants.%DestroyImpl.impl_witness.fb5) [concrete = constants.%Destroy.facet]
// CHECK:STDOUT:   %.loc12_3.1: %Destroy.type = converted Core.Form, %Destroy.facet.loc12_3.1 [concrete = constants.%Destroy.facet]
// CHECK:STDOUT:   %Destroy.facet.loc12_3.2: %Destroy.type = facet_value Core.Form, (constants.%custom_witness.b80, constants.%DestroyImpl.impl_witness.fb5) [concrete = constants.%Destroy.facet]
// CHECK:STDOUT:   %.loc12_3.2: %Destroy.type = converted Core.Form, %Destroy.facet.loc12_3.2 [concrete = constants.%Destroy.facet]
// CHECK:STDOUT:   <elided>
// CHECK:STDOUT:   %SelfDestruct.call: init %empty_tuple.type = call %SelfDestruct.specific_fn(%x.var)
// CHECK:STDOUT:   <elided>
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: fn @SubobjectDestroy.WithSelf.Op.loc8(%self.param: ref Core.Form) = "no_op";
// CHECK:STDOUT:
// CHECK:STDOUT: --- todo_dynamic_function.carbon = $todo_dynamic_function
// CHECK:STDOUT:
// CHECK:STDOUT: constants {
// CHECK:STDOUT:   type: type = facet_type <type> [concrete]
// CHECK:STDOUT:   %G.type: type = fn_type @G [concrete]
// CHECK:STDOUT:   %empty_tuple.type: type = tuple_type () [concrete]
// CHECK:STDOUT:   %pattern_type.38a: type = pattern_type %G.type [concrete]
// CHECK:STDOUT:   %Make.type: type = fn_type @Make [concrete]
// CHECK:STDOUT:   %Make: %Make.type = struct_value () [concrete]
// CHECK:STDOUT:   %SubobjectDestroy.type: type = facet_type <@SubobjectDestroy> [concrete]
// CHECK:STDOUT:   %SubobjectDestroy.WithSelf.Op.type.687: type = fn_type @SubobjectDestroy.WithSelf.Op.loc10 [concrete]
// CHECK:STDOUT:   %SubobjectDestroy.WithSelf.Op.30f: %SubobjectDestroy.WithSelf.Op.type.687 = struct_value () [concrete]
// CHECK:STDOUT:   %custom_witness.b80: <witness> = custom_witness (%SubobjectDestroy.WithSelf.Op.30f), @SubobjectDestroy [concrete]
// CHECK:STDOUT:   %SubobjectDestroy.facet.d43: %SubobjectDestroy.type = facet_value %G.type, (%custom_witness.b80) [concrete]
// CHECK:STDOUT:   %Destroy.type: type = facet_type <@Destroy> [concrete]
// CHECK:STDOUT:   %DestroyImpl.type: type = facet_type <@DestroyImpl> [concrete]
// CHECK:STDOUT:   %T.09f: %SubobjectDestroy.type = symbolic_binding T, 0 [symbolic]
// CHECK:STDOUT:   %T.as_type.as.DestroyImpl.impl.Op.type.dea: type = fn_type @T.as_type.as.DestroyImpl.impl.Op, @T.as_type.as.DestroyImpl.impl(%T.09f) [symbolic]
// CHECK:STDOUT:   %T.as_type.as.DestroyImpl.impl.Op.6e5: %T.as_type.as.DestroyImpl.impl.Op.type.dea = struct_value () [symbolic]
// CHECK:STDOUT:   %DestroyImpl.impl_witness.846: <witness> = impl_witness imports.%DestroyImpl.impl_witness_table, @T.as_type.as.DestroyImpl.impl(%SubobjectDestroy.facet.d43) [concrete]
// CHECK:STDOUT:   %Destroy.facet: %Destroy.type = facet_value %G.type, (%custom_witness.b80, %DestroyImpl.impl_witness.846) [concrete]
// CHECK:STDOUT:   %DynamicDestroy.type: type = facet_type <@DynamicDestroy> [concrete]
// CHECK:STDOUT:   %custom_witness.0b5: <witness> = custom_witness (), @DynamicDestroyImpl [concrete]
// CHECK:STDOUT:   %DynamicDestroy.facet: %DynamicDestroy.type = facet_value %G.type, (%custom_witness.b80, %DestroyImpl.impl_witness.846, %custom_witness.0b5) [concrete]
// CHECK:STDOUT:   %x.patt: %pattern_type.38a = ref_binding_pattern x [concrete]
// CHECK:STDOUT:   %x.var_patt: %pattern_type.38a = var_pattern %x.patt [concrete]
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
// CHECK:STDOUT:   %Fn.ref.loc10: type = name_ref Fn, file.%Fn [concrete = constants.%G.type]
// CHECK:STDOUT:   %Core.ref.loc10: <namespace> = name_ref Core, imports.%Core [concrete = imports.%Core]
// CHECK:STDOUT:   %SubobjectDestroy.ref: type = name_ref SubobjectDestroy, imports.%Core.SubobjectDestroy [concrete = constants.%SubobjectDestroy.type]
// CHECK:STDOUT:   %SubobjectDestroy.facet: %SubobjectDestroy.type = facet_value %Fn.ref.loc10, (constants.%custom_witness.b80) [concrete = constants.%SubobjectDestroy.facet.d43]
// CHECK:STDOUT:   %.loc10: %SubobjectDestroy.type = converted %Fn.ref.loc10, %SubobjectDestroy.facet [concrete = constants.%SubobjectDestroy.facet.d43]
// CHECK:STDOUT:   %Fn.ref.loc11: type = name_ref Fn, file.%Fn [concrete = constants.%G.type]
// CHECK:STDOUT:   %Core.ref.loc11: <namespace> = name_ref Core, imports.%Core [concrete = imports.%Core]
// CHECK:STDOUT:   %Destroy.ref: type = name_ref Destroy, imports.%Core.Destroy [concrete = constants.%Destroy.type]
// CHECK:STDOUT:   %Destroy.facet.loc11: %Destroy.type = facet_value %Fn.ref.loc11, (constants.%custom_witness.b80, constants.%DestroyImpl.impl_witness.846) [concrete = constants.%Destroy.facet]
// CHECK:STDOUT:   %.loc11: %Destroy.type = converted %Fn.ref.loc11, %Destroy.facet.loc11 [concrete = constants.%Destroy.facet]
// CHECK:STDOUT:   %Fn.ref.loc12: type = name_ref Fn, file.%Fn [concrete = constants.%G.type]
// CHECK:STDOUT:   %Core.ref.loc12: <namespace> = name_ref Core, imports.%Core [concrete = imports.%Core]
// CHECK:STDOUT:   %DynamicDestroy.ref: type = name_ref DynamicDestroy, imports.%Core.DynamicDestroy [concrete = constants.%DynamicDestroy.type]
// CHECK:STDOUT:   %DynamicDestroy.facet: %DynamicDestroy.type = facet_value %Fn.ref.loc12, (constants.%custom_witness.b80, constants.%DestroyImpl.impl_witness.846, constants.%custom_witness.0b5) [concrete = constants.%DynamicDestroy.facet]
// CHECK:STDOUT:   %.loc12: %DynamicDestroy.type = converted %Fn.ref.loc12, %DynamicDestroy.facet [concrete = constants.%DynamicDestroy.facet]
// CHECK:STDOUT:   %x.var: ref %G.type = var_storage %x.var_patt
// CHECK:STDOUT:   %Make.ref: %Make.type = name_ref Make, file.%Make.decl [concrete = constants.%Make]
// CHECK:STDOUT:   %Make.call: init %G.type = call %Make.ref()
// CHECK:STDOUT:   assign %x.var, %Make.call
// CHECK:STDOUT:   %Fn.ref.loc14: type = name_ref Fn, file.%Fn [concrete = constants.%G.type]
// CHECK:STDOUT:   %x: ref %G.type = wrapper_binding x, %x.var
// CHECK:STDOUT:   name_binding_decl {
// CHECK:STDOUT:     %x.patt: %pattern_type.38a = ref_binding_pattern x [concrete = constants.%x.patt]
// CHECK:STDOUT:     %x.var_patt: %pattern_type.38a = var_pattern %x.patt [concrete = constants.%x.var_patt]
// CHECK:STDOUT:   }
// CHECK:STDOUT:   %Destroy.facet.loc14_3.1: %Destroy.type = facet_value constants.%G.type, (constants.%custom_witness.b80, constants.%DestroyImpl.impl_witness.846) [concrete = constants.%Destroy.facet]
// CHECK:STDOUT:   %.loc14_3.1: %Destroy.type = converted constants.%G.type, %Destroy.facet.loc14_3.1 [concrete = constants.%Destroy.facet]
// CHECK:STDOUT:   %Destroy.facet.loc14_3.2: %Destroy.type = facet_value constants.%G.type, (constants.%custom_witness.b80, constants.%DestroyImpl.impl_witness.846) [concrete = constants.%Destroy.facet]
// CHECK:STDOUT:   %.loc14_3.2: %Destroy.type = converted constants.%G.type, %Destroy.facet.loc14_3.2 [concrete = constants.%Destroy.facet]
// CHECK:STDOUT:   <elided>
// CHECK:STDOUT:   %SelfDestruct.call: init %empty_tuple.type = call %SelfDestruct.specific_fn(%x.var)
// CHECK:STDOUT:   <elided>
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: fn @SubobjectDestroy.WithSelf.Op.loc10(%self.param: ref %G.type) = "no_op";
// CHECK:STDOUT:
// CHECK:STDOUT: --- todo_dynamic_function_with_self.carbon = $todo_dynamic_function_with_self
// CHECK:STDOUT:
// CHECK:STDOUT: constants {
// CHECK:STDOUT:   type: type = facet_type <type> [concrete]
// CHECK:STDOUT:   %int_32: Core.IntLiteral = int_value 32 [concrete]
// CHECK:STDOUT:   %Int.type: type = parameterized_class_name_type @Int [concrete]
// CHECK:STDOUT:   %empty_tuple.type: type = tuple_type () [concrete]
// CHECK:STDOUT:   %Int.generic: %Int.type = struct_value () [concrete]
// CHECK:STDOUT:   %N: Core.IntLiteral = symbolic_binding N, 0 [symbolic]
// CHECK:STDOUT:   %i32: type = class_type @Int, @Int(%int_32) [concrete]
// CHECK:STDOUT:   %Copy.type: type = facet_type <@Copy> [concrete]
// CHECK:STDOUT:   %Int.as.Copy.impl.Op.type.a1d: type = fn_type @Int.as.Copy.impl.Op, @Int.as.Copy.impl(%N) [symbolic]
// CHECK:STDOUT:   %Int.as.Copy.impl.Op.3c1: %Int.as.Copy.impl.Op.type.a1d = struct_value () [symbolic]
// CHECK:STDOUT:   %Copy.impl_witness.8af: <witness> = impl_witness imports.%Copy.impl_witness_table.f44, @Int.as.Copy.impl(%int_32) [concrete]
// CHECK:STDOUT:   %Copy.facet: %Copy.type = facet_value %i32, (%Copy.impl_witness.8af) [concrete]
// CHECK:STDOUT:   %Copy.WithSelf.Op.type.f76: type = fn_type @Copy.WithSelf.Op, @Copy.WithSelf(%Copy.facet) [concrete]
// CHECK:STDOUT:   %.2b9: type = fn_type_with_self_type %Copy.WithSelf.Op.type.f76, %Copy.facet [concrete]
// CHECK:STDOUT:   %pattern_type.783: type = pattern_type %.2b9 [concrete]
// CHECK:STDOUT:   %Make.type: type = fn_type @Make [concrete]
// CHECK:STDOUT:   %Make: %Make.type = struct_value () [concrete]
// CHECK:STDOUT:   %SubobjectDestroy.type: type = facet_type <@SubobjectDestroy> [concrete]
// CHECK:STDOUT:   %SubobjectDestroy.WithSelf.Op.type.687: type = fn_type @SubobjectDestroy.WithSelf.Op.loc8 [concrete]
// CHECK:STDOUT:   %SubobjectDestroy.WithSelf.Op.30f: %SubobjectDestroy.WithSelf.Op.type.687 = struct_value () [concrete]
// CHECK:STDOUT:   %custom_witness.b80: <witness> = custom_witness (%SubobjectDestroy.WithSelf.Op.30f), @SubobjectDestroy [concrete]
// CHECK:STDOUT:   %SubobjectDestroy.facet.ab7: %SubobjectDestroy.type = facet_value %.2b9, (%custom_witness.b80) [concrete]
// CHECK:STDOUT:   %Destroy.type: type = facet_type <@Destroy> [concrete]
// CHECK:STDOUT:   %DestroyImpl.type: type = facet_type <@DestroyImpl> [concrete]
// CHECK:STDOUT:   %T.09f: %SubobjectDestroy.type = symbolic_binding T, 0 [symbolic]
// CHECK:STDOUT:   %T.as_type.as.DestroyImpl.impl.Op.type.dea: type = fn_type @T.as_type.as.DestroyImpl.impl.Op, @T.as_type.as.DestroyImpl.impl(%T.09f) [symbolic]
// CHECK:STDOUT:   %T.as_type.as.DestroyImpl.impl.Op.6e5: %T.as_type.as.DestroyImpl.impl.Op.type.dea = struct_value () [symbolic]
// CHECK:STDOUT:   %DestroyImpl.impl_witness.e48: <witness> = impl_witness imports.%DestroyImpl.impl_witness_table, @T.as_type.as.DestroyImpl.impl(%SubobjectDestroy.facet.ab7) [concrete]
// CHECK:STDOUT:   %Destroy.facet: %Destroy.type = facet_value %.2b9, (%custom_witness.b80, %DestroyImpl.impl_witness.e48) [concrete]
// CHECK:STDOUT:   %DynamicDestroy.type: type = facet_type <@DynamicDestroy> [concrete]
// CHECK:STDOUT:   %custom_witness.0b5: <witness> = custom_witness (), @DynamicDestroyImpl [concrete]
// CHECK:STDOUT:   %DynamicDestroy.facet: %DynamicDestroy.type = facet_value %.2b9, (%custom_witness.b80, %DestroyImpl.impl_witness.e48, %custom_witness.0b5) [concrete]
// CHECK:STDOUT:   %x.patt: %pattern_type.783 = ref_binding_pattern x [concrete]
// CHECK:STDOUT:   %x.var_patt: %pattern_type.783 = var_pattern %x.patt [concrete]
// CHECK:STDOUT:   %SelfDestruct.type: type = fn_type @SelfDestruct [concrete]
// CHECK:STDOUT:   %SelfDestruct: %SelfDestruct.type = struct_value () [concrete]
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: imports {
// CHECK:STDOUT:   %Core: <namespace> = namespace file.%Core.import, [concrete] {
// CHECK:STDOUT:     .Int = %Core.Int
// CHECK:STDOUT:     .Copy = %Core.Copy
// CHECK:STDOUT:     .SubobjectDestroy = %Core.SubobjectDestroy
// CHECK:STDOUT:     .Destroy = %Core.Destroy
// CHECK:STDOUT:     .DynamicDestroy = %Core.DynamicDestroy
// CHECK:STDOUT:     .DestroyImpl = %Core.DestroyImpl
// CHECK:STDOUT:     .SelfDestruct = %Core.SelfDestruct
// CHECK:STDOUT:     import Core//prelude
// CHECK:STDOUT:     import Core//prelude/...
// CHECK:STDOUT:   }
// CHECK:STDOUT:   %Core.Int: %Int.type = import_ref Core//prelude/parts/int, Int, loaded [concrete = constants.%Int.generic]
// CHECK:STDOUT:   %Core.Copy: type = import_ref Core//prelude/parts/copy, Copy, loaded [concrete = constants.%Copy.type]
// CHECK:STDOUT:   %Core.import_ref.72f: @Int.as.Copy.impl.%Int.as.Copy.impl.Op.type (%Int.as.Copy.impl.Op.type.a1d) = import_ref Core//prelude/parts/int, loc{{\d+_\d+}}, loaded [symbolic = @Int.as.Copy.impl.%Int.as.Copy.impl.Op (constants.%Int.as.Copy.impl.Op.3c1)]
// CHECK:STDOUT:   %Copy.impl_witness_table.f44 = impl_witness_table (%Core.import_ref.72f), @Int.as.Copy.impl [concrete]
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
// CHECK:STDOUT:   %FnWithSelf.ref.loc8: type = name_ref FnWithSelf, file.%FnWithSelf [concrete = constants.%.2b9]
// CHECK:STDOUT:   %Core.ref.loc8: <namespace> = name_ref Core, imports.%Core [concrete = imports.%Core]
// CHECK:STDOUT:   %SubobjectDestroy.ref: type = name_ref SubobjectDestroy, imports.%Core.SubobjectDestroy [concrete = constants.%SubobjectDestroy.type]
// CHECK:STDOUT:   %SubobjectDestroy.facet: %SubobjectDestroy.type = facet_value %FnWithSelf.ref.loc8, (constants.%custom_witness.b80) [concrete = constants.%SubobjectDestroy.facet.ab7]
// CHECK:STDOUT:   %.loc8: %SubobjectDestroy.type = converted %FnWithSelf.ref.loc8, %SubobjectDestroy.facet [concrete = constants.%SubobjectDestroy.facet.ab7]
// CHECK:STDOUT:   %FnWithSelf.ref.loc9: type = name_ref FnWithSelf, file.%FnWithSelf [concrete = constants.%.2b9]
// CHECK:STDOUT:   %Core.ref.loc9: <namespace> = name_ref Core, imports.%Core [concrete = imports.%Core]
// CHECK:STDOUT:   %Destroy.ref: type = name_ref Destroy, imports.%Core.Destroy [concrete = constants.%Destroy.type]
// CHECK:STDOUT:   %Destroy.facet.loc9: %Destroy.type = facet_value %FnWithSelf.ref.loc9, (constants.%custom_witness.b80, constants.%DestroyImpl.impl_witness.e48) [concrete = constants.%Destroy.facet]
// CHECK:STDOUT:   %.loc9: %Destroy.type = converted %FnWithSelf.ref.loc9, %Destroy.facet.loc9 [concrete = constants.%Destroy.facet]
// CHECK:STDOUT:   %FnWithSelf.ref.loc10: type = name_ref FnWithSelf, file.%FnWithSelf [concrete = constants.%.2b9]
// CHECK:STDOUT:   %Core.ref.loc10: <namespace> = name_ref Core, imports.%Core [concrete = imports.%Core]
// CHECK:STDOUT:   %DynamicDestroy.ref: type = name_ref DynamicDestroy, imports.%Core.DynamicDestroy [concrete = constants.%DynamicDestroy.type]
// CHECK:STDOUT:   %DynamicDestroy.facet: %DynamicDestroy.type = facet_value %FnWithSelf.ref.loc10, (constants.%custom_witness.b80, constants.%DestroyImpl.impl_witness.e48, constants.%custom_witness.0b5) [concrete = constants.%DynamicDestroy.facet]
// CHECK:STDOUT:   %.loc10: %DynamicDestroy.type = converted %FnWithSelf.ref.loc10, %DynamicDestroy.facet [concrete = constants.%DynamicDestroy.facet]
// CHECK:STDOUT:   %x.var: ref %.2b9 = var_storage %x.var_patt
// CHECK:STDOUT:   %Make.ref: %Make.type = name_ref Make, file.%Make.decl [concrete = constants.%Make]
// CHECK:STDOUT:   %Make.call: init %.2b9 = call %Make.ref()
// CHECK:STDOUT:   assign %x.var, %Make.call
// CHECK:STDOUT:   %FnWithSelf.ref.loc12: type = name_ref FnWithSelf, file.%FnWithSelf [concrete = constants.%.2b9]
// CHECK:STDOUT:   %x: ref %.2b9 = wrapper_binding x, %x.var
// CHECK:STDOUT:   name_binding_decl {
// CHECK:STDOUT:     %x.patt: %pattern_type.783 = ref_binding_pattern x [concrete = constants.%x.patt]
// CHECK:STDOUT:     %x.var_patt: %pattern_type.783 = var_pattern %x.patt [concrete = constants.%x.var_patt]
// CHECK:STDOUT:   }
// CHECK:STDOUT:   %Destroy.facet.loc12_3.1: %Destroy.type = facet_value constants.%.2b9, (constants.%custom_witness.b80, constants.%DestroyImpl.impl_witness.e48) [concrete = constants.%Destroy.facet]
// CHECK:STDOUT:   %.loc12_3.1: %Destroy.type = converted constants.%.2b9, %Destroy.facet.loc12_3.1 [concrete = constants.%Destroy.facet]
// CHECK:STDOUT:   %Destroy.facet.loc12_3.2: %Destroy.type = facet_value constants.%.2b9, (constants.%custom_witness.b80, constants.%DestroyImpl.impl_witness.e48) [concrete = constants.%Destroy.facet]
// CHECK:STDOUT:   %.loc12_3.2: %Destroy.type = converted constants.%.2b9, %Destroy.facet.loc12_3.2 [concrete = constants.%Destroy.facet]
// CHECK:STDOUT:   <elided>
// CHECK:STDOUT:   %SelfDestruct.call: init %empty_tuple.type = call %SelfDestruct.specific_fn(%x.var)
// CHECK:STDOUT:   <elided>
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: fn @SubobjectDestroy.WithSelf.Op.loc8(%self.param: ref %.2b9) = "no_op";
// CHECK:STDOUT:
// CHECK:STDOUT: --- todo_dynamic_int_literal.carbon = $todo_dynamic_int_literal
// CHECK:STDOUT:
// CHECK:STDOUT: constants {
// CHECK:STDOUT:   type: type = facet_type <type> [concrete]
// CHECK:STDOUT:   %empty_tuple.type: type = tuple_type () [concrete]
// CHECK:STDOUT:   %SubobjectDestroy.type: type = facet_type <@SubobjectDestroy> [concrete]
// CHECK:STDOUT:   %pattern_type.dc0: type = pattern_type Core.IntLiteral [concrete]
// CHECK:STDOUT:   %SubobjectDestroy.WithSelf.Op.type.687: type = fn_type @SubobjectDestroy.WithSelf.Op.loc5 [concrete]
// CHECK:STDOUT:   %SubobjectDestroy.WithSelf.Op.30f: %SubobjectDestroy.WithSelf.Op.type.687 = struct_value () [concrete]
// CHECK:STDOUT:   %custom_witness.b80: <witness> = custom_witness (%SubobjectDestroy.WithSelf.Op.30f), @SubobjectDestroy [concrete]
// CHECK:STDOUT:   %SubobjectDestroy.facet.659: %SubobjectDestroy.type = facet_value Core.IntLiteral, (%custom_witness.b80) [concrete]
// CHECK:STDOUT:   %Destroy.type: type = facet_type <@Destroy> [concrete]
// CHECK:STDOUT:   %DestroyImpl.type: type = facet_type <@DestroyImpl> [concrete]
// CHECK:STDOUT:   %T.09f: %SubobjectDestroy.type = symbolic_binding T, 0 [symbolic]
// CHECK:STDOUT:   %T.as_type.as.DestroyImpl.impl.Op.type.dea: type = fn_type @T.as_type.as.DestroyImpl.impl.Op, @T.as_type.as.DestroyImpl.impl(%T.09f) [symbolic]
// CHECK:STDOUT:   %T.as_type.as.DestroyImpl.impl.Op.6e5: %T.as_type.as.DestroyImpl.impl.Op.type.dea = struct_value () [symbolic]
// CHECK:STDOUT:   %DestroyImpl.impl_witness.9b4: <witness> = impl_witness imports.%DestroyImpl.impl_witness_table, @T.as_type.as.DestroyImpl.impl(%SubobjectDestroy.facet.659) [concrete]
// CHECK:STDOUT:   %Destroy.facet: %Destroy.type = facet_value Core.IntLiteral, (%custom_witness.b80, %DestroyImpl.impl_witness.9b4) [concrete]
// CHECK:STDOUT:   %DynamicDestroy.type: type = facet_type <@DynamicDestroy> [concrete]
// CHECK:STDOUT:   %custom_witness.0b5: <witness> = custom_witness (), @DynamicDestroyImpl [concrete]
// CHECK:STDOUT:   %DynamicDestroy.facet: %DynamicDestroy.type = facet_value Core.IntLiteral, (%custom_witness.b80, %DestroyImpl.impl_witness.9b4, %custom_witness.0b5) [concrete]
// CHECK:STDOUT:   %x.patt: %pattern_type.dc0 = ref_binding_pattern x [concrete]
// CHECK:STDOUT:   %x.var_patt: %pattern_type.dc0 = var_pattern %x.patt [concrete]
// CHECK:STDOUT:   %int_0: Core.IntLiteral = int_value 0 [concrete]
// CHECK:STDOUT:   %Copy.type: type = facet_type <@Copy> [concrete]
// CHECK:STDOUT:   %Copy.impl_witness.0b3: <witness> = impl_witness imports.%Copy.impl_witness_table.ee5 [concrete]
// CHECK:STDOUT:   %Copy.facet: %Copy.type = facet_value Core.IntLiteral, (%Copy.impl_witness.0b3) [concrete]
// CHECK:STDOUT:   %Copy.WithSelf.Op.type.d4d: type = fn_type @Copy.WithSelf.Op, @Copy.WithSelf(%Copy.facet) [concrete]
// CHECK:STDOUT:   %.1b2: type = fn_type_with_self_type %Copy.WithSelf.Op.type.d4d, %Copy.facet [concrete]
// CHECK:STDOUT:   %Core.IntLiteral.as.Copy.impl.Op.type: type = fn_type @Core.IntLiteral.as.Copy.impl.Op [concrete]
// CHECK:STDOUT:   %Core.IntLiteral.as.Copy.impl.Op: %Core.IntLiteral.as.Copy.impl.Op.type = struct_value () [concrete]
// CHECK:STDOUT:   %Core.IntLiteral.as.Copy.impl.Op.bound: <bound method> = bound_method %int_0, %Core.IntLiteral.as.Copy.impl.Op [concrete]
// CHECK:STDOUT:   %SelfDestruct.type: type = fn_type @SelfDestruct [concrete]
// CHECK:STDOUT:   %SelfDestruct: %SelfDestruct.type = struct_value () [concrete]
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: imports {
// CHECK:STDOUT:   %Core: <namespace> = namespace file.%Core.import, [concrete] {
// CHECK:STDOUT:     .IntLiteral = %Core.IntLiteral
// CHECK:STDOUT:     .SubobjectDestroy = %Core.SubobjectDestroy
// CHECK:STDOUT:     .Destroy = %Core.Destroy
// CHECK:STDOUT:     .DynamicDestroy = %Core.DynamicDestroy
// CHECK:STDOUT:     .DestroyImpl = %Core.DestroyImpl
// CHECK:STDOUT:     .Copy = %Core.Copy
// CHECK:STDOUT:     .SelfDestruct = %Core.SelfDestruct
// CHECK:STDOUT:     import Core//prelude
// CHECK:STDOUT:     import Core//prelude/...
// CHECK:STDOUT:   }
// CHECK:STDOUT:   %Core.IntLiteral: type = import_ref Core//prelude/parts/int_literal, IntLiteral, loaded [concrete = Core.IntLiteral]
// CHECK:STDOUT:   %Core.SubobjectDestroy: type = import_ref Core//prelude/parts/destroy, SubobjectDestroy, loaded [concrete = constants.%SubobjectDestroy.type]
// CHECK:STDOUT:   %Core.Destroy: type = import_ref Core//prelude/parts/destroy, Destroy, loaded [concrete = constants.%Destroy.type]
// CHECK:STDOUT:   %Core.import_ref.74d: @T.as_type.as.DestroyImpl.impl.%T.as_type.as.DestroyImpl.impl.Op.type (%T.as_type.as.DestroyImpl.impl.Op.type.dea) = import_ref Core//prelude/parts/destroy, loc{{\d+_\d+}}, loaded [symbolic = @T.as_type.as.DestroyImpl.impl.%T.as_type.as.DestroyImpl.impl.Op (constants.%T.as_type.as.DestroyImpl.impl.Op.6e5)]
// CHECK:STDOUT:   %DestroyImpl.impl_witness_table = impl_witness_table (%Core.import_ref.74d), @T.as_type.as.DestroyImpl.impl [concrete]
// CHECK:STDOUT:   %Core.DynamicDestroy: type = import_ref Core//prelude/parts/destroy, DynamicDestroy, loaded [concrete = constants.%DynamicDestroy.type]
// CHECK:STDOUT:   %Core.DestroyImpl: type = import_ref Core//prelude/parts/destroy, DestroyImpl, loaded [concrete = constants.%DestroyImpl.type]
// CHECK:STDOUT:   %Core.Copy: type = import_ref Core//prelude/parts/copy, Copy, loaded [concrete = constants.%Copy.type]
// CHECK:STDOUT:   %Core.import_ref.9c3: %Core.IntLiteral.as.Copy.impl.Op.type = import_ref Core//prelude/parts/copy, loc{{\d+_\d+}}, loaded [concrete = constants.%Core.IntLiteral.as.Copy.impl.Op]
// CHECK:STDOUT:   %Copy.impl_witness_table.ee5 = impl_witness_table (%Core.import_ref.9c3), @Core.IntLiteral.as.Copy.impl [concrete]
// CHECK:STDOUT:   %Core.SelfDestruct: %SelfDestruct.type = import_ref Core//prelude/parts/destroy, SelfDestruct, loaded [concrete = constants.%SelfDestruct]
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: fn @Test() {
// CHECK:STDOUT: !entry:
// CHECK:STDOUT:   %Core.ref.loc5_3: <namespace> = name_ref Core, imports.%Core [concrete = imports.%Core]
// CHECK:STDOUT:   %IntLiteral.ref.loc5: type = name_ref IntLiteral, imports.%Core.IntLiteral [concrete = Core.IntLiteral]
// CHECK:STDOUT:   %Core.ref.loc5_22: <namespace> = name_ref Core, imports.%Core [concrete = imports.%Core]
// CHECK:STDOUT:   %SubobjectDestroy.ref: type = name_ref SubobjectDestroy, imports.%Core.SubobjectDestroy [concrete = constants.%SubobjectDestroy.type]
// CHECK:STDOUT:   %SubobjectDestroy.facet: %SubobjectDestroy.type = facet_value %IntLiteral.ref.loc5, (constants.%custom_witness.b80) [concrete = constants.%SubobjectDestroy.facet.659]
// CHECK:STDOUT:   %.loc5: %SubobjectDestroy.type = converted %IntLiteral.ref.loc5, %SubobjectDestroy.facet [concrete = constants.%SubobjectDestroy.facet.659]
// CHECK:STDOUT:   %Core.ref.loc6_3: <namespace> = name_ref Core, imports.%Core [concrete = imports.%Core]
// CHECK:STDOUT:   %IntLiteral.ref.loc6: type = name_ref IntLiteral, imports.%Core.IntLiteral [concrete = Core.IntLiteral]
// CHECK:STDOUT:   %Core.ref.loc6_22: <namespace> = name_ref Core, imports.%Core [concrete = imports.%Core]
// CHECK:STDOUT:   %Destroy.ref: type = name_ref Destroy, imports.%Core.Destroy [concrete = constants.%Destroy.type]
// CHECK:STDOUT:   %Destroy.facet.loc6: %Destroy.type = facet_value %IntLiteral.ref.loc6, (constants.%custom_witness.b80, constants.%DestroyImpl.impl_witness.9b4) [concrete = constants.%Destroy.facet]
// CHECK:STDOUT:   %.loc6: %Destroy.type = converted %IntLiteral.ref.loc6, %Destroy.facet.loc6 [concrete = constants.%Destroy.facet]
// CHECK:STDOUT:   %Core.ref.loc7_3: <namespace> = name_ref Core, imports.%Core [concrete = imports.%Core]
// CHECK:STDOUT:   %IntLiteral.ref.loc7: type = name_ref IntLiteral, imports.%Core.IntLiteral [concrete = Core.IntLiteral]
// CHECK:STDOUT:   %Core.ref.loc7_22: <namespace> = name_ref Core, imports.%Core [concrete = imports.%Core]
// CHECK:STDOUT:   %DynamicDestroy.ref: type = name_ref DynamicDestroy, imports.%Core.DynamicDestroy [concrete = constants.%DynamicDestroy.type]
// CHECK:STDOUT:   %DynamicDestroy.facet: %DynamicDestroy.type = facet_value %IntLiteral.ref.loc7, (constants.%custom_witness.b80, constants.%DestroyImpl.impl_witness.9b4, constants.%custom_witness.0b5) [concrete = constants.%DynamicDestroy.facet]
// CHECK:STDOUT:   %.loc7: %DynamicDestroy.type = converted %IntLiteral.ref.loc7, %DynamicDestroy.facet [concrete = constants.%DynamicDestroy.facet]
// CHECK:STDOUT:   %x.var: ref Core.IntLiteral = var_storage %x.var_patt
// CHECK:STDOUT:   %int_0: Core.IntLiteral = int_value 0 [concrete = constants.%int_0]
// CHECK:STDOUT:   %impl.elem0: %.1b2 = impl_witness_access constants.%Copy.impl_witness.0b3, element0 [concrete = constants.%Core.IntLiteral.as.Copy.impl.Op]
// CHECK:STDOUT:   %bound_method: <bound method> = bound_method %int_0, %impl.elem0 [concrete = constants.%Core.IntLiteral.as.Copy.impl.Op.bound]
// CHECK:STDOUT:   %Core.IntLiteral.as.Copy.impl.Op.call: init Core.IntLiteral = call %bound_method(%int_0) [concrete = constants.%int_0]
// CHECK:STDOUT:   assign %x.var, %Core.IntLiteral.as.Copy.impl.Op.call
// CHECK:STDOUT:   %.loc9_21: type = splice_block %IntLiteral.ref.loc9 [concrete = Core.IntLiteral] {
// CHECK:STDOUT:     %Core.ref.loc9: <namespace> = name_ref Core, imports.%Core [concrete = imports.%Core]
// CHECK:STDOUT:     %IntLiteral.ref.loc9: type = name_ref IntLiteral, imports.%Core.IntLiteral [concrete = Core.IntLiteral]
// CHECK:STDOUT:   }
// CHECK:STDOUT:   %x: ref Core.IntLiteral = wrapper_binding x, %x.var
// CHECK:STDOUT:   name_binding_decl {
// CHECK:STDOUT:     %x.patt: %pattern_type.dc0 = ref_binding_pattern x [concrete = constants.%x.patt]
// CHECK:STDOUT:     %x.var_patt: %pattern_type.dc0 = var_pattern %x.patt [concrete = constants.%x.var_patt]
// CHECK:STDOUT:   }
// CHECK:STDOUT:   %Destroy.facet.loc9_3.1: %Destroy.type = facet_value Core.IntLiteral, (constants.%custom_witness.b80, constants.%DestroyImpl.impl_witness.9b4) [concrete = constants.%Destroy.facet]
// CHECK:STDOUT:   %.loc9_3.1: %Destroy.type = converted Core.IntLiteral, %Destroy.facet.loc9_3.1 [concrete = constants.%Destroy.facet]
// CHECK:STDOUT:   %Destroy.facet.loc9_3.2: %Destroy.type = facet_value Core.IntLiteral, (constants.%custom_witness.b80, constants.%DestroyImpl.impl_witness.9b4) [concrete = constants.%Destroy.facet]
// CHECK:STDOUT:   %.loc9_3.2: %Destroy.type = converted Core.IntLiteral, %Destroy.facet.loc9_3.2 [concrete = constants.%Destroy.facet]
// CHECK:STDOUT:   <elided>
// CHECK:STDOUT:   %SelfDestruct.call: init %empty_tuple.type = call %SelfDestruct.specific_fn(%x.var)
// CHECK:STDOUT:   <elided>
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: fn @SubobjectDestroy.WithSelf.Op.loc5(%self.param: ref Core.IntLiteral) = "no_op";
// CHECK:STDOUT:
// CHECK:STDOUT: --- todo_dynamic_i32.carbon = $todo_dynamic_i32
// CHECK:STDOUT:
// CHECK:STDOUT: constants {
// CHECK:STDOUT:   type: type = facet_type <type> [concrete]
// CHECK:STDOUT:   %empty_tuple.type: type = tuple_type () [concrete]
// CHECK:STDOUT:   %int_32: Core.IntLiteral = int_value 32 [concrete]
// CHECK:STDOUT:   %Int.type: type = parameterized_class_name_type @Int [concrete]
// CHECK:STDOUT:   %Int.generic: %Int.type = struct_value () [concrete]
// CHECK:STDOUT:   %i32: type = class_type @Int, @Int(%int_32) [concrete]
// CHECK:STDOUT:   %SubobjectDestroy.type: type = facet_type <@SubobjectDestroy> [concrete]
// CHECK:STDOUT:   %i32.builtin: type = int_type signed, %int_32 [concrete]
// CHECK:STDOUT:   %DestroyImpl.type: type = facet_type <@DestroyImpl> [concrete]
// CHECK:STDOUT:   %T.09f: %SubobjectDestroy.type = symbolic_binding T, 0 [symbolic]
// CHECK:STDOUT:   %T.as_type.as.DestroyImpl.impl.Op.type.dea: type = fn_type @T.as_type.as.DestroyImpl.impl.Op, @T.as_type.as.DestroyImpl.impl(%T.09f) [symbolic]
// CHECK:STDOUT:   %T.as_type.as.DestroyImpl.impl.Op.6e5: %T.as_type.as.DestroyImpl.impl.Op.type.dea = struct_value () [symbolic]
// CHECK:STDOUT:   %pattern_type.d94: type = pattern_type %i32 [concrete]
// CHECK:STDOUT:   %SubobjectDestroy.WithSelf.Op.type.6870fd.2: type = fn_type @SubobjectDestroy.WithSelf.Op.loc5_7.2 [concrete]
// CHECK:STDOUT:   %SubobjectDestroy.WithSelf.Op.30f1ee.2: %SubobjectDestroy.WithSelf.Op.type.6870fd.2 = struct_value () [concrete]
// CHECK:STDOUT:   %custom_witness.b80ef6.2: <witness> = custom_witness (%SubobjectDestroy.WithSelf.Op.30f1ee.2), @SubobjectDestroy [concrete]
// CHECK:STDOUT:   %SubobjectDestroy.facet.49a: %SubobjectDestroy.type = facet_value %i32, (%custom_witness.b80ef6.2) [concrete]
// CHECK:STDOUT:   %Destroy.type: type = facet_type <@Destroy> [concrete]
// CHECK:STDOUT:   %DestroyImpl.impl_witness.077: <witness> = impl_witness imports.%DestroyImpl.impl_witness_table, @T.as_type.as.DestroyImpl.impl(%SubobjectDestroy.facet.49a) [concrete]
// CHECK:STDOUT:   %Destroy.facet: %Destroy.type = facet_value %i32, (%custom_witness.b80ef6.2, %DestroyImpl.impl_witness.077) [concrete]
// CHECK:STDOUT:   %DynamicDestroy.type: type = facet_type <@DynamicDestroy> [concrete]
// CHECK:STDOUT:   %custom_witness.0b5: <witness> = custom_witness (), @DynamicDestroyImpl [concrete]
// CHECK:STDOUT:   %DynamicDestroy.facet: %DynamicDestroy.type = facet_value %i32, (%custom_witness.b80ef6.2, %DestroyImpl.impl_witness.077, %custom_witness.0b5) [concrete]
// CHECK:STDOUT:   %x.patt: %pattern_type.d94 = ref_binding_pattern x [concrete]
// CHECK:STDOUT:   %x.var_patt: %pattern_type.d94 = var_pattern %x.patt [concrete]
// CHECK:STDOUT:   %int_0.5c6: Core.IntLiteral = int_value 0 [concrete]
// CHECK:STDOUT:   %ImplicitAs.type.0ff: type = generic_interface_type @ImplicitAs [concrete]
// CHECK:STDOUT:   %ImplicitAs.generic: %ImplicitAs.type.0ff = struct_value () [concrete]
// CHECK:STDOUT:   %ImplicitAs.type.6b0: type = facet_type <@ImplicitAs, @ImplicitAs(%i32)> [concrete]
// CHECK:STDOUT:   %To: Core.IntLiteral = symbolic_binding To, 0 [symbolic]
// CHECK:STDOUT:   %Core.IntLiteral.as.ImplicitAs.impl.Convert.type.3c6: type = fn_type @Core.IntLiteral.as.ImplicitAs.impl.Convert, @Core.IntLiteral.as.ImplicitAs.impl(%To) [symbolic]
// CHECK:STDOUT:   %Core.IntLiteral.as.ImplicitAs.impl.Convert.6f2: %Core.IntLiteral.as.ImplicitAs.impl.Convert.type.3c6 = struct_value () [symbolic]
// CHECK:STDOUT:   %ImplicitAs.impl_witness.d73: <witness> = impl_witness imports.%ImplicitAs.impl_witness_table.f53, @Core.IntLiteral.as.ImplicitAs.impl(%int_32) [concrete]
// CHECK:STDOUT:   %ImplicitAs.facet: %ImplicitAs.type.6b0 = facet_value Core.IntLiteral, (%ImplicitAs.impl_witness.d73) [concrete]
// CHECK:STDOUT:   %ImplicitAs.WithSelf.Convert.type.58f: type = fn_type @ImplicitAs.WithSelf.Convert, @ImplicitAs.WithSelf(%i32, %ImplicitAs.facet) [concrete]
// CHECK:STDOUT:   %.33a: type = fn_type_with_self_type %ImplicitAs.WithSelf.Convert.type.58f, %ImplicitAs.facet [concrete]
// CHECK:STDOUT:   %Core.IntLiteral.as.ImplicitAs.impl.Convert.type.766: type = fn_type @Core.IntLiteral.as.ImplicitAs.impl.Convert, @Core.IntLiteral.as.ImplicitAs.impl(%int_32) [concrete]
// CHECK:STDOUT:   %Core.IntLiteral.as.ImplicitAs.impl.Convert.f60: %Core.IntLiteral.as.ImplicitAs.impl.Convert.type.766 = struct_value () [concrete]
// CHECK:STDOUT:   %Core.IntLiteral.as.ImplicitAs.impl.Convert.bound: <bound method> = bound_method %int_0.5c6, %Core.IntLiteral.as.ImplicitAs.impl.Convert.f60 [concrete]
// CHECK:STDOUT:   %Core.IntLiteral.as.ImplicitAs.impl.Convert.specific_fn: <specific function> = specific_function %Core.IntLiteral.as.ImplicitAs.impl.Convert.f60, @Core.IntLiteral.as.ImplicitAs.impl.Convert(%int_32) [concrete]
// CHECK:STDOUT:   %bound_method: <bound method> = bound_method %int_0.5c6, %Core.IntLiteral.as.ImplicitAs.impl.Convert.specific_fn [concrete]
// CHECK:STDOUT:   %int_0.753: %i32 = int_value 0 [concrete]
// CHECK:STDOUT:   %SelfDestruct.type: type = fn_type @SelfDestruct [concrete]
// CHECK:STDOUT:   %SelfDestruct: %SelfDestruct.type = struct_value () [concrete]
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: imports {
// CHECK:STDOUT:   %Core: <namespace> = namespace file.%Core.import, [concrete] {
// CHECK:STDOUT:     .Int = %Core.Int
// CHECK:STDOUT:     .SubobjectDestroy = %Core.SubobjectDestroy
// CHECK:STDOUT:     .DestroyImpl = %Core.DestroyImpl
// CHECK:STDOUT:     .Destroy = %Core.Destroy
// CHECK:STDOUT:     .DynamicDestroy = %Core.DynamicDestroy
// CHECK:STDOUT:     .ImplicitAs = %Core.ImplicitAs
// CHECK:STDOUT:     .SelfDestruct = %Core.SelfDestruct
// CHECK:STDOUT:     import Core//prelude
// CHECK:STDOUT:     import Core//prelude/...
// CHECK:STDOUT:   }
// CHECK:STDOUT:   %Core.Int: %Int.type = import_ref Core//prelude/parts/int, Int, loaded [concrete = constants.%Int.generic]
// CHECK:STDOUT:   %Core.SubobjectDestroy: type = import_ref Core//prelude/parts/destroy, SubobjectDestroy, loaded [concrete = constants.%SubobjectDestroy.type]
// CHECK:STDOUT:   %Core.DestroyImpl: type = import_ref Core//prelude/parts/destroy, DestroyImpl, loaded [concrete = constants.%DestroyImpl.type]
// CHECK:STDOUT:   %Core.import_ref.74d: @T.as_type.as.DestroyImpl.impl.%T.as_type.as.DestroyImpl.impl.Op.type (%T.as_type.as.DestroyImpl.impl.Op.type.dea) = import_ref Core//prelude/parts/destroy, loc{{\d+_\d+}}, loaded [symbolic = @T.as_type.as.DestroyImpl.impl.%T.as_type.as.DestroyImpl.impl.Op (constants.%T.as_type.as.DestroyImpl.impl.Op.6e5)]
// CHECK:STDOUT:   %DestroyImpl.impl_witness_table = impl_witness_table (%Core.import_ref.74d), @T.as_type.as.DestroyImpl.impl [concrete]
// CHECK:STDOUT:   %Core.Destroy: type = import_ref Core//prelude/parts/destroy, Destroy, loaded [concrete = constants.%Destroy.type]
// CHECK:STDOUT:   %Core.DynamicDestroy: type = import_ref Core//prelude/parts/destroy, DynamicDestroy, loaded [concrete = constants.%DynamicDestroy.type]
// CHECK:STDOUT:   %Core.ImplicitAs: %ImplicitAs.type.0ff = import_ref Core//prelude/parts/as, ImplicitAs, loaded [concrete = constants.%ImplicitAs.generic]
// CHECK:STDOUT:   %Core.import_ref.e47: @Core.IntLiteral.as.ImplicitAs.impl.%Core.IntLiteral.as.ImplicitAs.impl.Convert.type (%Core.IntLiteral.as.ImplicitAs.impl.Convert.type.3c6) = import_ref Core//prelude/parts/int, loc{{\d+_\d+}}, loaded [symbolic = @Core.IntLiteral.as.ImplicitAs.impl.%Core.IntLiteral.as.ImplicitAs.impl.Convert (constants.%Core.IntLiteral.as.ImplicitAs.impl.Convert.6f2)]
// CHECK:STDOUT:   %ImplicitAs.impl_witness_table.f53 = impl_witness_table (%Core.import_ref.e47), @Core.IntLiteral.as.ImplicitAs.impl [concrete]
// CHECK:STDOUT:   %Core.SelfDestruct: %SelfDestruct.type = import_ref Core//prelude/parts/destroy, SelfDestruct, loaded [concrete = constants.%SelfDestruct]
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: fn @Test() {
// CHECK:STDOUT: !entry:
// CHECK:STDOUT:   %i32.loc5: type = type_literal constants.%i32 [concrete = constants.%i32]
// CHECK:STDOUT:   %Core.ref.loc5: <namespace> = name_ref Core, imports.%Core [concrete = imports.%Core]
// CHECK:STDOUT:   %SubobjectDestroy.ref: type = name_ref SubobjectDestroy, imports.%Core.SubobjectDestroy [concrete = constants.%SubobjectDestroy.type]
// CHECK:STDOUT:   %SubobjectDestroy.facet: %SubobjectDestroy.type = facet_value %i32.loc5, (constants.%custom_witness.b80ef6.2) [concrete = constants.%SubobjectDestroy.facet.49a]
// CHECK:STDOUT:   %.loc5: %SubobjectDestroy.type = converted %i32.loc5, %SubobjectDestroy.facet [concrete = constants.%SubobjectDestroy.facet.49a]
// CHECK:STDOUT:   %i32.loc6: type = type_literal constants.%i32 [concrete = constants.%i32]
// CHECK:STDOUT:   %Core.ref.loc6: <namespace> = name_ref Core, imports.%Core [concrete = imports.%Core]
// CHECK:STDOUT:   %Destroy.ref: type = name_ref Destroy, imports.%Core.Destroy [concrete = constants.%Destroy.type]
// CHECK:STDOUT:   %Destroy.facet.loc6: %Destroy.type = facet_value %i32.loc6, (constants.%custom_witness.b80ef6.2, constants.%DestroyImpl.impl_witness.077) [concrete = constants.%Destroy.facet]
// CHECK:STDOUT:   %.loc6: %Destroy.type = converted %i32.loc6, %Destroy.facet.loc6 [concrete = constants.%Destroy.facet]
// CHECK:STDOUT:   %i32.loc7: type = type_literal constants.%i32 [concrete = constants.%i32]
// CHECK:STDOUT:   %Core.ref.loc7: <namespace> = name_ref Core, imports.%Core [concrete = imports.%Core]
// CHECK:STDOUT:   %DynamicDestroy.ref: type = name_ref DynamicDestroy, imports.%Core.DynamicDestroy [concrete = constants.%DynamicDestroy.type]
// CHECK:STDOUT:   %DynamicDestroy.facet: %DynamicDestroy.type = facet_value %i32.loc7, (constants.%custom_witness.b80ef6.2, constants.%DestroyImpl.impl_witness.077, constants.%custom_witness.0b5) [concrete = constants.%DynamicDestroy.facet]
// CHECK:STDOUT:   %.loc7: %DynamicDestroy.type = converted %i32.loc7, %DynamicDestroy.facet [concrete = constants.%DynamicDestroy.facet]
// CHECK:STDOUT:   %x.var: ref %i32 = var_storage %x.var_patt
// CHECK:STDOUT:   %int_0: Core.IntLiteral = int_value 0 [concrete = constants.%int_0.5c6]
// CHECK:STDOUT:   %impl.elem0: %.33a = impl_witness_access constants.%ImplicitAs.impl_witness.d73, element0 [concrete = constants.%Core.IntLiteral.as.ImplicitAs.impl.Convert.f60]
// CHECK:STDOUT:   %bound_method.loc9_3.1: <bound method> = bound_method %int_0, %impl.elem0 [concrete = constants.%Core.IntLiteral.as.ImplicitAs.impl.Convert.bound]
// CHECK:STDOUT:   %specific_fn: <specific function> = specific_function %impl.elem0, @Core.IntLiteral.as.ImplicitAs.impl.Convert(constants.%int_32) [concrete = constants.%Core.IntLiteral.as.ImplicitAs.impl.Convert.specific_fn]
// CHECK:STDOUT:   %bound_method.loc9_3.2: <bound method> = bound_method %int_0, %specific_fn [concrete = constants.%bound_method]
// CHECK:STDOUT:   %Core.IntLiteral.as.ImplicitAs.impl.Convert.call: init %i32 = call %bound_method.loc9_3.2(%int_0) [concrete = constants.%int_0.753]
// CHECK:STDOUT:   %.loc9_3.1: init %i32 = converted %int_0, %Core.IntLiteral.as.ImplicitAs.impl.Convert.call [concrete = constants.%int_0.753]
// CHECK:STDOUT:   assign %x.var, %.loc9_3.1
// CHECK:STDOUT:   %i32.loc9: type = type_literal constants.%i32 [concrete = constants.%i32]
// CHECK:STDOUT:   %x: ref %i32 = wrapper_binding x, %x.var
// CHECK:STDOUT:   name_binding_decl {
// CHECK:STDOUT:     %x.patt: %pattern_type.d94 = ref_binding_pattern x [concrete = constants.%x.patt]
// CHECK:STDOUT:     %x.var_patt: %pattern_type.d94 = var_pattern %x.patt [concrete = constants.%x.var_patt]
// CHECK:STDOUT:   }
// CHECK:STDOUT:   %Destroy.facet.loc9_3.1: %Destroy.type = facet_value constants.%i32, (constants.%custom_witness.b80ef6.2, constants.%DestroyImpl.impl_witness.077) [concrete = constants.%Destroy.facet]
// CHECK:STDOUT:   %.loc9_3.2: %Destroy.type = converted constants.%i32, %Destroy.facet.loc9_3.1 [concrete = constants.%Destroy.facet]
// CHECK:STDOUT:   %Destroy.facet.loc9_3.2: %Destroy.type = facet_value constants.%i32, (constants.%custom_witness.b80ef6.2, constants.%DestroyImpl.impl_witness.077) [concrete = constants.%Destroy.facet]
// CHECK:STDOUT:   %.loc9_3.3: %Destroy.type = converted constants.%i32, %Destroy.facet.loc9_3.2 [concrete = constants.%Destroy.facet]
// CHECK:STDOUT:   <elided>
// CHECK:STDOUT:   %SelfDestruct.call: init %empty_tuple.type = call %SelfDestruct.specific_fn(%x.var)
// CHECK:STDOUT:   <elided>
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: fn @SubobjectDestroy.WithSelf.Op.loc5_7.1(%self.param: ref %i32.builtin) = "no_op";
// CHECK:STDOUT:
// CHECK:STDOUT: fn @SubobjectDestroy.WithSelf.Op.loc5_7.2(%self.param: ref %i32) = "no_op";
// CHECK:STDOUT:
