// Part of the Carbon Language project, under the Apache License v2.0 with LLVM
// Exceptions. See /LICENSE for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
// INCLUDE-FILE: toolchain/testing/testdata/min_prelude/primitives.carbon
//
// AUTOUPDATE
// TIP: To test this file alone, run:
// TIP:   bazel test //toolchain/testing:file_test --test_arg=--file_tests=toolchain/lower/testdata/var/destroy_control_flow.carbon
// TIP: To dump output, run:
// TIP:   bazel run //toolchain/testing:file_test -- --dump_output --file_tests=toolchain/lower/testdata/var/destroy_control_flow.carbon

// --- destructible.carbon

library "[[@TEST_NAME]]";

class Destructible {
  impl as Core.DestroyImpl {
    fn Op(self);
  }
};

fn Use(ref d: Destructible);

// --- if_then.carbon

library "[[@TEST_NAME]]";
import library "destructible";

fn IfThen(cond: bool) {
  var a: Destructible = {};
  Use(ref a);
  if (cond) {
    var b: Destructible = {};
    Use(ref b);
  }
  Use(ref a);
}

// --- if_else.carbon

library "[[@TEST_NAME]]";
import library "destructible";

fn IfElse(cond: bool) {
  var a: Destructible = {};
  Use(ref a);
  if (cond) {
    var b: Destructible = {};
    Use(ref b);
  } else {
    var c: Destructible = {};
    Use(ref c);
  }
  Use(ref a);
}

// --- if_return.carbon

library "[[@TEST_NAME]]";
import library "destructible";

fn IfReturn(cond: bool) {
  var a: Destructible = {};
  Use(ref a);
  if (cond) {
    var b: Destructible = {};
    Use(ref b);
    return;
  }
}

// --- while_break.carbon

library "[[@TEST_NAME]]";
import library "destructible";

fn WhileBreak(cond: bool) {
  var a: Destructible = {};
  Use(ref a);
  while (cond) {
    Use(ref a);
    var b: Destructible = {};
    Use(ref b);
    if (cond) {
      var c: Destructible = {};
      Use(ref c);
      break;
    }
  }
  Use(ref a);
}

// --- while_continue.carbon

library "[[@TEST_NAME]]";
import library "destructible";

fn WhileContinue(cond: bool) {
  var a: Destructible = {};
  Use(ref a);
  while (cond) {
    Use(ref a);
    var b: Destructible = {};
    Use(ref b);
    if (cond) {
      var c: Destructible = {};
      Use(ref c);
      continue;
    }
  }
  Use(ref a);
}

// CHECK:STDOUT: ; ---
// CHECK:STDOUT: ; ModuleID = 'destructible.carbon'
// CHECK:STDOUT: source_filename = "destructible.carbon"
// CHECK:STDOUT:
// CHECK:STDOUT: declare void @"_COp.Destructible.Main:DestroyImpl.Core"(ptr)
// CHECK:STDOUT:
// CHECK:STDOUT: ; Function Attrs: alwaysinline nounwind
// CHECK:STDOUT: define weak_odr void @"_COp:thunk:DestroyImpl.1421ed8cb8ddfaad.Core:Destructible.Main:DestroyImpl.Core"(ptr %self) #0 !dbg !39 {
// CHECK:STDOUT: entry:
// CHECK:STDOUT:   call void @"_COp.Destructible.Main:DestroyImpl.Core"(ptr %self), !dbg !42
// CHECK:STDOUT:   ret void, !dbg !42
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: declare void @_CUse.Main(ptr)
// CHECK:STDOUT:
// CHECK:STDOUT: attributes #0 = { alwaysinline nounwind }
// CHECK:STDOUT:
// CHECK:STDOUT: !llvm.dbg.cu = !{!35}
// CHECK:STDOUT: !llvm.module.flags = !{!2, !3}
// CHECK:STDOUT:
// CHECK:STDOUT: !2 = !{i32 7, !"Dwarf Version", i32 5}
// CHECK:STDOUT: !3 = !{i32 2, !"Debug Info Version", i32 3}
// CHECK:STDOUT: !34 = !DIFile(filename: "destructible.carbon", directory: "")
// CHECK:STDOUT: !35 = distinct !DICompileUnit(language: DW_LANG_C_plus_plus, file: !34, producer: "carbon", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug)
// CHECK:STDOUT: !36 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
// CHECK:STDOUT: !37 = !{null, !36}
// CHECK:STDOUT: !38 = !DISubroutineType(types: !37)
// CHECK:STDOUT: !39 = distinct !DISubprogram(name: "Op", linkageName: "_COp:thunk:DestroyImpl.1421ed8cb8ddfaad.Core:Destructible.Main:DestroyImpl.Core", scope: null, file: !34, line: 6, type: !38, spFlags: DISPFlagDefinition, unit: !35, retainedNodes: !43)
// CHECK:STDOUT: !40 = !DILocalVariable(arg: 1, scope: !39, type: !36)
// CHECK:STDOUT: !42 = !DILocation(line: 6, column: 5, scope: !39)
// CHECK:STDOUT: !43 = !{!40}
// CHECK:STDOUT:
// CHECK:STDOUT: ; ---
// CHECK:STDOUT: ; ModuleID = 'if_then.carbon'
// CHECK:STDOUT: source_filename = "if_then.carbon"
// CHECK:STDOUT:
// CHECK:STDOUT: @Destructible.val.loc6_3 = internal constant {} zeroinitializer
// CHECK:STDOUT:
// CHECK:STDOUT: ; Function Attrs: nounwind
// CHECK:STDOUT: define void @_CIfThen.Main(i1 %cond) #0 !dbg !46 {
// CHECK:STDOUT: entry:
// CHECK:STDOUT:   %a.var = alloca {}, align 1, !dbg !49
// CHECK:STDOUT:   %b.var = alloca {}, align 1, !dbg !56
// CHECK:STDOUT:   call void @llvm.lifetime.start.p0(ptr %a.var), !dbg !49
// CHECK:STDOUT:   call void @llvm.memcpy.p0.p0.i64(ptr align 1 %a.var, ptr align 1 @Destructible.val.loc6_3, i64 0, i1 false), !dbg !49
// CHECK:STDOUT:   call void @_CUse.Main(ptr %a.var), !dbg !53
// CHECK:STDOUT:   br i1 %cond, label %if.then, label %if.else, !dbg !55
// CHECK:STDOUT:
// CHECK:STDOUT: if.then:                                          ; preds = %entry
// CHECK:STDOUT:   call void @llvm.lifetime.start.p0(ptr %b.var), !dbg !56
// CHECK:STDOUT:   call void @llvm.memcpy.p0.p0.i64(ptr align 1 %b.var, ptr align 1 @Destructible.val.loc6_3, i64 0, i1 false), !dbg !56
// CHECK:STDOUT:   call void @_CUse.Main(ptr %b.var), !dbg !60
// CHECK:STDOUT:   br label %if.else, !dbg !61
// CHECK:STDOUT:
// CHECK:STDOUT: if.else:                                          ; preds = %if.then, %entry
// CHECK:STDOUT:   call void @_CUse.Main(ptr %a.var), !dbg !64
// CHECK:STDOUT:   ret void, !dbg !65
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: declare void @_CUse.Main(ptr)
// CHECK:STDOUT:
// CHECK:STDOUT: declare void @"_COp:thunk:DestroyImpl.4a8993846ac47976.Core:Destructible.Main:DestroyImpl.Core"(ptr)
// CHECK:STDOUT:
// CHECK:STDOUT: ; Function Attrs: nocallback nofree nosync nounwind willreturn memory(argmem: readwrite)
// CHECK:STDOUT: declare void @llvm.lifetime.start.p0(ptr captures(none)) #1
// CHECK:STDOUT:
// CHECK:STDOUT: ; Function Attrs: nocallback nofree nosync nounwind willreturn memory(argmem: readwrite)
// CHECK:STDOUT: declare void @llvm.memcpy.p0.p0.i64(ptr noalias writeonly captures(none), ptr noalias readonly captures(none), i64, i1 immarg) #1
// CHECK:STDOUT:
// CHECK:STDOUT: ; uselistorder directives
// CHECK:STDOUT: uselistorder ptr @_CUse.Main, { 2, 1, 0 }
// CHECK:STDOUT: uselistorder ptr @llvm.lifetime.start.p0, { 1, 0 }
// CHECK:STDOUT: uselistorder ptr @llvm.memcpy.p0.p0.i64, { 1, 0 }
// CHECK:STDOUT:
// CHECK:STDOUT: attributes #0 = { nounwind }
// CHECK:STDOUT: attributes #1 = { nocallback nofree nosync nounwind willreturn memory(argmem: readwrite) }
// CHECK:STDOUT:
// CHECK:STDOUT: !llvm.dbg.cu = !{!45}
// CHECK:STDOUT: !llvm.module.flags = !{!2, !3}
// CHECK:STDOUT:
// CHECK:STDOUT: !2 = !{i32 7, !"Dwarf Version", i32 5}
// CHECK:STDOUT: !3 = !{i32 2, !"Debug Info Version", i32 3}
// CHECK:STDOUT: !36 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
// CHECK:STDOUT: !37 = !{null, !36}
// CHECK:STDOUT: !38 = !DISubroutineType(types: !37)
// CHECK:STDOUT: !44 = !DIFile(filename: "if_then.carbon", directory: "")
// CHECK:STDOUT: !45 = distinct !DICompileUnit(language: DW_LANG_C_plus_plus, file: !44, producer: "carbon", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug)
// CHECK:STDOUT: !46 = distinct !DISubprogram(name: "IfThen", linkageName: "_CIfThen.Main", scope: null, file: !44, line: 5, type: !38, spFlags: DISPFlagDefinition, unit: !45, retainedNodes: !66)
// CHECK:STDOUT: !47 = !DILocalVariable(arg: 1, scope: !46, type: !36)
// CHECK:STDOUT: !49 = !DILocation(line: 6, column: 3, scope: !46)
// CHECK:STDOUT: !53 = !DILocation(line: 7, column: 3, scope: !46)
// CHECK:STDOUT: !55 = !DILocation(line: 8, column: 6, scope: !46)
// CHECK:STDOUT: !56 = !DILocation(line: 9, column: 5, scope: !46)
// CHECK:STDOUT: !60 = !DILocation(line: 10, column: 5, scope: !46)
// CHECK:STDOUT: !61 = !DILocation(line: 8, column: 3, scope: !46)
// CHECK:STDOUT: !64 = !DILocation(line: 12, column: 3, scope: !46)
// CHECK:STDOUT: !65 = !DILocation(line: 5, column: 1, scope: !46)
// CHECK:STDOUT: !66 = !{!47}
// CHECK:STDOUT:
// CHECK:STDOUT: ; ---
// CHECK:STDOUT: ; ModuleID = 'if_else.carbon'
// CHECK:STDOUT: source_filename = "if_else.carbon"
// CHECK:STDOUT:
// CHECK:STDOUT: @Destructible.val.loc6_3 = internal constant {} zeroinitializer
// CHECK:STDOUT:
// CHECK:STDOUT: ; Function Attrs: nounwind
// CHECK:STDOUT: define void @_CIfElse.Main(i1 %cond) #0 !dbg !69 {
// CHECK:STDOUT: entry:
// CHECK:STDOUT:   %a.var = alloca {}, align 1, !dbg !72
// CHECK:STDOUT:   %b.var = alloca {}, align 1, !dbg !79
// CHECK:STDOUT:   %c.var = alloca {}, align 1, !dbg !85
// CHECK:STDOUT:   call void @llvm.lifetime.start.p0(ptr %a.var), !dbg !72
// CHECK:STDOUT:   call void @llvm.memcpy.p0.p0.i64(ptr align 1 %a.var, ptr align 1 @Destructible.val.loc6_3, i64 0, i1 false), !dbg !72
// CHECK:STDOUT:   call void @_CUse.Main(ptr %a.var), !dbg !76
// CHECK:STDOUT:   br i1 %cond, label %if.then, label %if.else, !dbg !78
// CHECK:STDOUT:
// CHECK:STDOUT: if.then:                                          ; preds = %entry
// CHECK:STDOUT:   call void @llvm.lifetime.start.p0(ptr %b.var), !dbg !79
// CHECK:STDOUT:   call void @llvm.memcpy.p0.p0.i64(ptr align 1 %b.var, ptr align 1 @Destructible.val.loc6_3, i64 0, i1 false), !dbg !79
// CHECK:STDOUT:   call void @_CUse.Main(ptr %b.var), !dbg !83
// CHECK:STDOUT:   br label %if.done, !dbg !84
// CHECK:STDOUT:
// CHECK:STDOUT: if.else:                                          ; preds = %entry
// CHECK:STDOUT:   call void @llvm.lifetime.start.p0(ptr %c.var), !dbg !85
// CHECK:STDOUT:   call void @llvm.memcpy.p0.p0.i64(ptr align 1 %c.var, ptr align 1 @Destructible.val.loc6_3, i64 0, i1 false), !dbg !85
// CHECK:STDOUT:   call void @_CUse.Main(ptr %c.var), !dbg !89
// CHECK:STDOUT:   br label %if.done, !dbg !84
// CHECK:STDOUT:
// CHECK:STDOUT: if.done:                                          ; preds = %if.else, %if.then
// CHECK:STDOUT:   call void @_CUse.Main(ptr %a.var), !dbg !92
// CHECK:STDOUT:   ret void, !dbg !93
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: declare void @_CUse.Main(ptr)
// CHECK:STDOUT:
// CHECK:STDOUT: declare void @"_COp:thunk:DestroyImpl.4a8993846ac47976.Core:Destructible.Main:DestroyImpl.Core"(ptr)
// CHECK:STDOUT:
// CHECK:STDOUT: ; Function Attrs: nocallback nofree nosync nounwind willreturn memory(argmem: readwrite)
// CHECK:STDOUT: declare void @llvm.lifetime.start.p0(ptr captures(none)) #1
// CHECK:STDOUT:
// CHECK:STDOUT: ; Function Attrs: nocallback nofree nosync nounwind willreturn memory(argmem: readwrite)
// CHECK:STDOUT: declare void @llvm.memcpy.p0.p0.i64(ptr noalias writeonly captures(none), ptr noalias readonly captures(none), i64, i1 immarg) #1
// CHECK:STDOUT:
// CHECK:STDOUT: ; uselistorder directives
// CHECK:STDOUT: uselistorder ptr @_CUse.Main, { 3, 2, 1, 0 }
// CHECK:STDOUT: uselistorder ptr @llvm.lifetime.start.p0, { 2, 1, 0 }
// CHECK:STDOUT: uselistorder ptr @llvm.memcpy.p0.p0.i64, { 2, 1, 0 }
// CHECK:STDOUT:
// CHECK:STDOUT: attributes #0 = { nounwind }
// CHECK:STDOUT: attributes #1 = { nocallback nofree nosync nounwind willreturn memory(argmem: readwrite) }
// CHECK:STDOUT:
// CHECK:STDOUT: !llvm.dbg.cu = !{!68}
// CHECK:STDOUT: !llvm.module.flags = !{!2, !3}
// CHECK:STDOUT:
// CHECK:STDOUT: !2 = !{i32 7, !"Dwarf Version", i32 5}
// CHECK:STDOUT: !3 = !{i32 2, !"Debug Info Version", i32 3}
// CHECK:STDOUT: !36 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
// CHECK:STDOUT: !37 = !{null, !36}
// CHECK:STDOUT: !38 = !DISubroutineType(types: !37)
// CHECK:STDOUT: !67 = !DIFile(filename: "if_else.carbon", directory: "")
// CHECK:STDOUT: !68 = distinct !DICompileUnit(language: DW_LANG_C_plus_plus, file: !67, producer: "carbon", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug)
// CHECK:STDOUT: !69 = distinct !DISubprogram(name: "IfElse", linkageName: "_CIfElse.Main", scope: null, file: !67, line: 5, type: !38, spFlags: DISPFlagDefinition, unit: !68, retainedNodes: !94)
// CHECK:STDOUT: !70 = !DILocalVariable(arg: 1, scope: !69, type: !36)
// CHECK:STDOUT: !72 = !DILocation(line: 6, column: 3, scope: !69)
// CHECK:STDOUT: !76 = !DILocation(line: 7, column: 3, scope: !69)
// CHECK:STDOUT: !78 = !DILocation(line: 8, column: 6, scope: !69)
// CHECK:STDOUT: !79 = !DILocation(line: 9, column: 5, scope: !69)
// CHECK:STDOUT: !83 = !DILocation(line: 10, column: 5, scope: !69)
// CHECK:STDOUT: !84 = !DILocation(line: 8, column: 3, scope: !69)
// CHECK:STDOUT: !85 = !DILocation(line: 12, column: 5, scope: !69)
// CHECK:STDOUT: !89 = !DILocation(line: 13, column: 5, scope: !69)
// CHECK:STDOUT: !92 = !DILocation(line: 15, column: 3, scope: !69)
// CHECK:STDOUT: !93 = !DILocation(line: 5, column: 1, scope: !69)
// CHECK:STDOUT: !94 = !{!70}
// CHECK:STDOUT:
// CHECK:STDOUT: ; ---
// CHECK:STDOUT: ; ModuleID = 'if_return.carbon'
// CHECK:STDOUT: source_filename = "if_return.carbon"
// CHECK:STDOUT:
// CHECK:STDOUT: @Destructible.val.loc6_3 = internal constant {} zeroinitializer
// CHECK:STDOUT:
// CHECK:STDOUT: ; Function Attrs: nounwind
// CHECK:STDOUT: define void @_CIfReturn.Main(i1 %cond) #0 !dbg !97 {
// CHECK:STDOUT: entry:
// CHECK:STDOUT:   %a.var = alloca {}, align 1, !dbg !100
// CHECK:STDOUT:   %b.var = alloca {}, align 1, !dbg !107
// CHECK:STDOUT:   call void @llvm.lifetime.start.p0(ptr %a.var), !dbg !100
// CHECK:STDOUT:   call void @llvm.memcpy.p0.p0.i64(ptr align 1 %a.var, ptr align 1 @Destructible.val.loc6_3, i64 0, i1 false), !dbg !100
// CHECK:STDOUT:   call void @_CUse.Main(ptr %a.var), !dbg !104
// CHECK:STDOUT:   br i1 %cond, label %if.then, label %if.else, !dbg !106
// CHECK:STDOUT:
// CHECK:STDOUT: if.then:                                          ; preds = %entry
// CHECK:STDOUT:   call void @llvm.lifetime.start.p0(ptr %b.var), !dbg !107
// CHECK:STDOUT:   call void @llvm.memcpy.p0.p0.i64(ptr align 1 %b.var, ptr align 1 @Destructible.val.loc6_3, i64 0, i1 false), !dbg !107
// CHECK:STDOUT:   call void @_CUse.Main(ptr %b.var), !dbg !111
// CHECK:STDOUT:   ret void, !dbg !112
// CHECK:STDOUT:
// CHECK:STDOUT: if.else:                                          ; preds = %entry
// CHECK:STDOUT:   ret void, !dbg !113
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: declare void @_CUse.Main(ptr)
// CHECK:STDOUT:
// CHECK:STDOUT: declare void @"_COp:thunk:DestroyImpl.4a8993846ac47976.Core:Destructible.Main:DestroyImpl.Core"(ptr)
// CHECK:STDOUT:
// CHECK:STDOUT: ; Function Attrs: nocallback nofree nosync nounwind willreturn memory(argmem: readwrite)
// CHECK:STDOUT: declare void @llvm.lifetime.start.p0(ptr captures(none)) #1
// CHECK:STDOUT:
// CHECK:STDOUT: ; Function Attrs: nocallback nofree nosync nounwind willreturn memory(argmem: readwrite)
// CHECK:STDOUT: declare void @llvm.memcpy.p0.p0.i64(ptr noalias writeonly captures(none), ptr noalias readonly captures(none), i64, i1 immarg) #1
// CHECK:STDOUT:
// CHECK:STDOUT: ; uselistorder directives
// CHECK:STDOUT: uselistorder ptr @_CUse.Main, { 1, 0 }
// CHECK:STDOUT: uselistorder ptr @llvm.lifetime.start.p0, { 1, 0 }
// CHECK:STDOUT: uselistorder ptr @llvm.memcpy.p0.p0.i64, { 1, 0 }
// CHECK:STDOUT:
// CHECK:STDOUT: attributes #0 = { nounwind }
// CHECK:STDOUT: attributes #1 = { nocallback nofree nosync nounwind willreturn memory(argmem: readwrite) }
// CHECK:STDOUT:
// CHECK:STDOUT: !llvm.dbg.cu = !{!96}
// CHECK:STDOUT: !llvm.module.flags = !{!2, !3}
// CHECK:STDOUT:
// CHECK:STDOUT: !2 = !{i32 7, !"Dwarf Version", i32 5}
// CHECK:STDOUT: !3 = !{i32 2, !"Debug Info Version", i32 3}
// CHECK:STDOUT: !36 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
// CHECK:STDOUT: !37 = !{null, !36}
// CHECK:STDOUT: !38 = !DISubroutineType(types: !37)
// CHECK:STDOUT: !95 = !DIFile(filename: "if_return.carbon", directory: "")
// CHECK:STDOUT: !96 = distinct !DICompileUnit(language: DW_LANG_C_plus_plus, file: !95, producer: "carbon", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug)
// CHECK:STDOUT: !97 = distinct !DISubprogram(name: "IfReturn", linkageName: "_CIfReturn.Main", scope: null, file: !95, line: 5, type: !38, spFlags: DISPFlagDefinition, unit: !96, retainedNodes: !114)
// CHECK:STDOUT: !98 = !DILocalVariable(arg: 1, scope: !97, type: !36)
// CHECK:STDOUT: !100 = !DILocation(line: 6, column: 3, scope: !97)
// CHECK:STDOUT: !104 = !DILocation(line: 7, column: 3, scope: !97)
// CHECK:STDOUT: !106 = !DILocation(line: 8, column: 6, scope: !97)
// CHECK:STDOUT: !107 = !DILocation(line: 9, column: 5, scope: !97)
// CHECK:STDOUT: !111 = !DILocation(line: 10, column: 5, scope: !97)
// CHECK:STDOUT: !112 = !DILocation(line: 11, column: 5, scope: !97)
// CHECK:STDOUT: !113 = !DILocation(line: 5, column: 1, scope: !97)
// CHECK:STDOUT: !114 = !{!98}
// CHECK:STDOUT:
// CHECK:STDOUT: ; ---
// CHECK:STDOUT: ; ModuleID = 'while_break.carbon'
// CHECK:STDOUT: source_filename = "while_break.carbon"
// CHECK:STDOUT:
// CHECK:STDOUT: @Destructible.val.loc6_3 = internal constant {} zeroinitializer
// CHECK:STDOUT:
// CHECK:STDOUT: ; Function Attrs: nounwind
// CHECK:STDOUT: define void @_CWhileBreak.Main(i1 %cond) #0 !dbg !117 {
// CHECK:STDOUT: entry:
// CHECK:STDOUT:   %a.var = alloca {}, align 1, !dbg !120
// CHECK:STDOUT:   %b.var = alloca {}, align 1, !dbg !130
// CHECK:STDOUT:   %c.var = alloca {}, align 1, !dbg !137
// CHECK:STDOUT:   call void @llvm.lifetime.start.p0(ptr %a.var), !dbg !120
// CHECK:STDOUT:   call void @llvm.memcpy.p0.p0.i64(ptr align 1 %a.var, ptr align 1 @Destructible.val.loc6_3, i64 0, i1 false), !dbg !120
// CHECK:STDOUT:   call void @_CUse.Main(ptr %a.var), !dbg !124
// CHECK:STDOUT:   br label %while.cond, !dbg !125
// CHECK:STDOUT:
// CHECK:STDOUT: while.cond:                                       ; preds = %if.else, %entry
// CHECK:STDOUT:   br i1 %cond, label %while.body, label %while.done, !dbg !125
// CHECK:STDOUT:
// CHECK:STDOUT: while.body:                                       ; preds = %while.cond
// CHECK:STDOUT:   call void @_CUse.Main(ptr %a.var), !dbg !129
// CHECK:STDOUT:   call void @llvm.lifetime.start.p0(ptr %b.var), !dbg !130
// CHECK:STDOUT:   call void @llvm.memcpy.p0.p0.i64(ptr align 1 %b.var, ptr align 1 @Destructible.val.loc6_3, i64 0, i1 false), !dbg !130
// CHECK:STDOUT:   call void @_CUse.Main(ptr %b.var), !dbg !134
// CHECK:STDOUT:   br i1 %cond, label %if.then, label %if.else, !dbg !136
// CHECK:STDOUT:
// CHECK:STDOUT: if.then:                                          ; preds = %while.body
// CHECK:STDOUT:   call void @llvm.lifetime.start.p0(ptr %c.var), !dbg !137
// CHECK:STDOUT:   call void @llvm.memcpy.p0.p0.i64(ptr align 1 %c.var, ptr align 1 @Destructible.val.loc6_3, i64 0, i1 false), !dbg !137
// CHECK:STDOUT:   call void @_CUse.Main(ptr %c.var), !dbg !141
// CHECK:STDOUT:   br label %while.done, !dbg !142
// CHECK:STDOUT:
// CHECK:STDOUT: if.else:                                          ; preds = %while.body
// CHECK:STDOUT:   br label %while.cond, !dbg !143
// CHECK:STDOUT:
// CHECK:STDOUT: while.done:                                       ; preds = %if.then, %while.cond
// CHECK:STDOUT:   call void @_CUse.Main(ptr %a.var), !dbg !146
// CHECK:STDOUT:   ret void, !dbg !147
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: declare void @_CUse.Main(ptr)
// CHECK:STDOUT:
// CHECK:STDOUT: declare void @"_COp:thunk:DestroyImpl.4a8993846ac47976.Core:Destructible.Main:DestroyImpl.Core"(ptr)
// CHECK:STDOUT:
// CHECK:STDOUT: ; Function Attrs: nocallback nofree nosync nounwind willreturn memory(argmem: readwrite)
// CHECK:STDOUT: declare void @llvm.lifetime.start.p0(ptr captures(none)) #1
// CHECK:STDOUT:
// CHECK:STDOUT: ; Function Attrs: nocallback nofree nosync nounwind willreturn memory(argmem: readwrite)
// CHECK:STDOUT: declare void @llvm.memcpy.p0.p0.i64(ptr noalias writeonly captures(none), ptr noalias readonly captures(none), i64, i1 immarg) #1
// CHECK:STDOUT:
// CHECK:STDOUT: ; uselistorder directives
// CHECK:STDOUT: uselistorder ptr @_CUse.Main, { 4, 3, 2, 1, 0 }
// CHECK:STDOUT: uselistorder ptr @llvm.lifetime.start.p0, { 2, 1, 0 }
// CHECK:STDOUT: uselistorder ptr @llvm.memcpy.p0.p0.i64, { 2, 1, 0 }
// CHECK:STDOUT:
// CHECK:STDOUT: attributes #0 = { nounwind }
// CHECK:STDOUT: attributes #1 = { nocallback nofree nosync nounwind willreturn memory(argmem: readwrite) }
// CHECK:STDOUT:
// CHECK:STDOUT: !llvm.dbg.cu = !{!116}
// CHECK:STDOUT: !llvm.module.flags = !{!2, !3}
// CHECK:STDOUT:
// CHECK:STDOUT: !2 = !{i32 7, !"Dwarf Version", i32 5}
// CHECK:STDOUT: !3 = !{i32 2, !"Debug Info Version", i32 3}
// CHECK:STDOUT: !36 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
// CHECK:STDOUT: !37 = !{null, !36}
// CHECK:STDOUT: !38 = !DISubroutineType(types: !37)
// CHECK:STDOUT: !115 = !DIFile(filename: "while_break.carbon", directory: "")
// CHECK:STDOUT: !116 = distinct !DICompileUnit(language: DW_LANG_C_plus_plus, file: !115, producer: "carbon", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug)
// CHECK:STDOUT: !117 = distinct !DISubprogram(name: "WhileBreak", linkageName: "_CWhileBreak.Main", scope: null, file: !115, line: 5, type: !38, spFlags: DISPFlagDefinition, unit: !116, retainedNodes: !148)
// CHECK:STDOUT: !118 = !DILocalVariable(arg: 1, scope: !117, type: !36)
// CHECK:STDOUT: !120 = !DILocation(line: 6, column: 3, scope: !117)
// CHECK:STDOUT: !124 = !DILocation(line: 7, column: 3, scope: !117)
// CHECK:STDOUT: !125 = !DILocation(line: 8, column: 9, scope: !117)
// CHECK:STDOUT: !129 = !DILocation(line: 9, column: 5, scope: !117)
// CHECK:STDOUT: !130 = !DILocation(line: 10, column: 5, scope: !117)
// CHECK:STDOUT: !134 = !DILocation(line: 11, column: 5, scope: !117)
// CHECK:STDOUT: !136 = !DILocation(line: 12, column: 8, scope: !117)
// CHECK:STDOUT: !137 = !DILocation(line: 13, column: 7, scope: !117)
// CHECK:STDOUT: !141 = !DILocation(line: 14, column: 7, scope: !117)
// CHECK:STDOUT: !142 = !DILocation(line: 15, column: 7, scope: !117)
// CHECK:STDOUT: !143 = !DILocation(line: 8, column: 3, scope: !117)
// CHECK:STDOUT: !146 = !DILocation(line: 18, column: 3, scope: !117)
// CHECK:STDOUT: !147 = !DILocation(line: 5, column: 1, scope: !117)
// CHECK:STDOUT: !148 = !{!118}
// CHECK:STDOUT:
// CHECK:STDOUT: ; ---
// CHECK:STDOUT: ; ModuleID = 'while_continue.carbon'
// CHECK:STDOUT: source_filename = "while_continue.carbon"
// CHECK:STDOUT:
// CHECK:STDOUT: @Destructible.val.loc6_3 = internal constant {} zeroinitializer
// CHECK:STDOUT:
// CHECK:STDOUT: ; Function Attrs: nounwind
// CHECK:STDOUT: define void @_CWhileContinue.Main(i1 %cond) #0 !dbg !151 {
// CHECK:STDOUT: entry:
// CHECK:STDOUT:   %a.var = alloca {}, align 1, !dbg !154
// CHECK:STDOUT:   %b.var = alloca {}, align 1, !dbg !164
// CHECK:STDOUT:   %c.var = alloca {}, align 1, !dbg !171
// CHECK:STDOUT:   call void @llvm.lifetime.start.p0(ptr %a.var), !dbg !154
// CHECK:STDOUT:   call void @llvm.memcpy.p0.p0.i64(ptr align 1 %a.var, ptr align 1 @Destructible.val.loc6_3, i64 0, i1 false), !dbg !154
// CHECK:STDOUT:   call void @_CUse.Main(ptr %a.var), !dbg !158
// CHECK:STDOUT:   br label %while.cond, !dbg !159
// CHECK:STDOUT:
// CHECK:STDOUT: while.cond:                                       ; preds = %if.else, %if.then, %entry
// CHECK:STDOUT:   br i1 %cond, label %while.body, label %while.done, !dbg !159
// CHECK:STDOUT:
// CHECK:STDOUT: while.body:                                       ; preds = %while.cond
// CHECK:STDOUT:   call void @_CUse.Main(ptr %a.var), !dbg !163
// CHECK:STDOUT:   call void @llvm.lifetime.start.p0(ptr %b.var), !dbg !164
// CHECK:STDOUT:   call void @llvm.memcpy.p0.p0.i64(ptr align 1 %b.var, ptr align 1 @Destructible.val.loc6_3, i64 0, i1 false), !dbg !164
// CHECK:STDOUT:   call void @_CUse.Main(ptr %b.var), !dbg !168
// CHECK:STDOUT:   br i1 %cond, label %if.then, label %if.else, !dbg !170
// CHECK:STDOUT:
// CHECK:STDOUT: if.then:                                          ; preds = %while.body
// CHECK:STDOUT:   call void @llvm.lifetime.start.p0(ptr %c.var), !dbg !171
// CHECK:STDOUT:   call void @llvm.memcpy.p0.p0.i64(ptr align 1 %c.var, ptr align 1 @Destructible.val.loc6_3, i64 0, i1 false), !dbg !171
// CHECK:STDOUT:   call void @_CUse.Main(ptr %c.var), !dbg !175
// CHECK:STDOUT:   br label %while.cond, !dbg !176
// CHECK:STDOUT:
// CHECK:STDOUT: if.else:                                          ; preds = %while.body
// CHECK:STDOUT:   br label %while.cond, !dbg !177
// CHECK:STDOUT:
// CHECK:STDOUT: while.done:                                       ; preds = %while.cond
// CHECK:STDOUT:   call void @_CUse.Main(ptr %a.var), !dbg !180
// CHECK:STDOUT:   ret void, !dbg !181
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: declare void @_CUse.Main(ptr)
// CHECK:STDOUT:
// CHECK:STDOUT: declare void @"_COp:thunk:DestroyImpl.4a8993846ac47976.Core:Destructible.Main:DestroyImpl.Core"(ptr)
// CHECK:STDOUT:
// CHECK:STDOUT: ; Function Attrs: nocallback nofree nosync nounwind willreturn memory(argmem: readwrite)
// CHECK:STDOUT: declare void @llvm.lifetime.start.p0(ptr captures(none)) #1
// CHECK:STDOUT:
// CHECK:STDOUT: ; Function Attrs: nocallback nofree nosync nounwind willreturn memory(argmem: readwrite)
// CHECK:STDOUT: declare void @llvm.memcpy.p0.p0.i64(ptr noalias writeonly captures(none), ptr noalias readonly captures(none), i64, i1 immarg) #1
// CHECK:STDOUT:
// CHECK:STDOUT: ; uselistorder directives
// CHECK:STDOUT: uselistorder ptr @_CUse.Main, { 4, 3, 2, 1, 0 }
// CHECK:STDOUT: uselistorder ptr @llvm.lifetime.start.p0, { 2, 1, 0 }
// CHECK:STDOUT: uselistorder ptr @llvm.memcpy.p0.p0.i64, { 2, 1, 0 }
// CHECK:STDOUT:
// CHECK:STDOUT: attributes #0 = { nounwind }
// CHECK:STDOUT: attributes #1 = { nocallback nofree nosync nounwind willreturn memory(argmem: readwrite) }
// CHECK:STDOUT:
// CHECK:STDOUT: !llvm.dbg.cu = !{!150}
// CHECK:STDOUT: !llvm.module.flags = !{!2, !3}
// CHECK:STDOUT:
// CHECK:STDOUT: !2 = !{i32 7, !"Dwarf Version", i32 5}
// CHECK:STDOUT: !3 = !{i32 2, !"Debug Info Version", i32 3}
// CHECK:STDOUT: !36 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
// CHECK:STDOUT: !37 = !{null, !36}
// CHECK:STDOUT: !38 = !DISubroutineType(types: !37)
// CHECK:STDOUT: !149 = !DIFile(filename: "while_continue.carbon", directory: "")
// CHECK:STDOUT: !150 = distinct !DICompileUnit(language: DW_LANG_C_plus_plus, file: !149, producer: "carbon", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug)
// CHECK:STDOUT: !151 = distinct !DISubprogram(name: "WhileContinue", linkageName: "_CWhileContinue.Main", scope: null, file: !149, line: 5, type: !38, spFlags: DISPFlagDefinition, unit: !150, retainedNodes: !182)
// CHECK:STDOUT: !152 = !DILocalVariable(arg: 1, scope: !151, type: !36)
// CHECK:STDOUT: !154 = !DILocation(line: 6, column: 3, scope: !151)
// CHECK:STDOUT: !158 = !DILocation(line: 7, column: 3, scope: !151)
// CHECK:STDOUT: !159 = !DILocation(line: 8, column: 9, scope: !151)
// CHECK:STDOUT: !163 = !DILocation(line: 9, column: 5, scope: !151)
// CHECK:STDOUT: !164 = !DILocation(line: 10, column: 5, scope: !151)
// CHECK:STDOUT: !168 = !DILocation(line: 11, column: 5, scope: !151)
// CHECK:STDOUT: !170 = !DILocation(line: 12, column: 8, scope: !151)
// CHECK:STDOUT: !171 = !DILocation(line: 13, column: 7, scope: !151)
// CHECK:STDOUT: !175 = !DILocation(line: 14, column: 7, scope: !151)
// CHECK:STDOUT: !176 = !DILocation(line: 15, column: 7, scope: !151)
// CHECK:STDOUT: !177 = !DILocation(line: 8, column: 3, scope: !151)
// CHECK:STDOUT: !180 = !DILocation(line: 18, column: 3, scope: !151)
// CHECK:STDOUT: !181 = !DILocation(line: 5, column: 1, scope: !151)
// CHECK:STDOUT: !182 = !{!152}
// CHECK:STDOUT:
