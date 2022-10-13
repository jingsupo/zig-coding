const std = @import("std");

pub fn build(b: *std.build.Builder) void {
    // Standard release options allow the person running `zig build` to select
    // between Debug, ReleaseSafe, ReleaseFast, and ReleaseSmall.
    const mode = b.standardReleaseOptions();
    const target = b.standardTargetOptions(.{});

    const exe = b.addExecutable("main", "src/main.zig");
    exe.setBuildMode(.ReleaseSafe);
    exe.setTarget(target);
    // c lib path
    // exe.addIncludePath(".");
    exe.install();

    const main = b.addStaticLibrary("main", "src/main.zig");
    main.setBuildMode(.ReleaseSafe);
    // c lib path
    // main.addIncludePath(".");
    main.install();

    const storage = b.addStaticLibrary("storage", "src/storage.zig");
    storage.setBuildMode(mode);
    // c lib path
    // storage.addIncludePath(".");
    storage.install();

    const main_tests = b.addTest("src/main.zig");
    // c lib path
    main_tests.addIncludePath(".");

    const storage_tests = b.addTest("src/storage.zig");
    // c lib path
    storage_tests.addIncludePath(".");
    // link libc
    storage_tests.linkLibC();

    const run_cmd = exe.run();
    const run_step = b.step("run", "Run the app");
    run_step.dependOn(&run_cmd.step);
    const test_step = b.step("test", "Run library tests");
    test_step.dependOn(&main_tests.step);
    test_step.dependOn(&storage_tests.step);
}
