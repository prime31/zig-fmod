const std = @import("std");
const Builder = @import("std").build.Builder;

pub fn build(b: *Builder) void {
    const mode = b.standardReleaseOptions();
    const exe = b.addExecutable("run", "examples/main.zig");
    exe.setOutputDir("zig-cache/bin");

    const fmod = std.build.Pkg{
        .name = "fmod",
        .path = "src/fmod.zig",
    };
    exe.addPackage(fmod);
    linkArtifact(exe);

    exe.setBuildMode(mode);
    exe.install();

    const run_cmd = exe.run();
    const exe_step = b.step("run", "run main.zig");
    exe_step.dependOn(&run_cmd.step);

    //export DYLD_FALLBACK_LIBRARY_PATH or DYLD_LIBRARY_PATH
    // install_name_tool -change @rpath/libfmod.dylib @executable_path/libfmod.dylib run./r
}

pub fn linkArtifact(exe: *std.build.LibExeObjStep) void {
    exe.addIncludeDir("src/core/inc");
    exe.addLibPath("src/core/lib");
    exe.linkSystemLibraryName("fmod");
}
