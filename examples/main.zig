const std = @import("std");
const c = @import("fmod");

pub fn main() !void {
    var fmod = c.System.init();
    defer fmod.deinit();

    var channel_group = fmod.getMasterChannelGroup();

    var sound = try fmod.createSound("examples/assets/skid.wav");
    defer sound.deinit();

    std.debug.print("len: {}\n", .{sound.length()});
    sound.setLoopCount(4);
    sound.playInChannelGroup(channel_group);

    var dsp = fmod.createDspByType(.FMOD_DSP_TYPE_FLANGE);
    channel_group.addDsp(0, dsp);

    std.time.sleep(2000 * std.time.ns_per_ms);
    channel_group.removeDsp(dsp);
    sound.play();

    std.time.sleep(5000 * std.time.ns_per_ms);
}