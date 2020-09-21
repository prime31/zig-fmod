const c = @import("c.zig");
const System = @import("system.zig").System;
const Channel = @import("system.zig").Channel;
const ChannelGroup = @import("system.zig").ChannelGroup;

pub const Sound = struct {
    system: System,
    sound: ?*c.FMOD_SOUND,

    pub fn init(system: System, name: [*c]const u8) !Sound {
        var sound: ?*c.FMOD_SOUND = undefined;
        if (c.FMOD_System_CreateSound(system.fmod, name, c.FMOD_DEFAULT, null, &sound) != .FMOD_OK) {
            return error.fmod_error;
        }

        return Sound{
            .system = system,
            .sound = sound,
        };
    }

    pub fn deinit(self: Sound) void {
        _ = c.FMOD_Sound_Release(self.sound);
    }

    pub fn length(self: Sound) c_uint {
        var len: c_uint = undefined;
        _ = c.FMOD_Sound_GetLength(self.sound, &len, 0x00000001);
        return len;
    }

    pub fn setMode(self: Sound, mode: c.FMOD_MODE) void {
        _ = c.FMOD_Sound_SetMode(self.sound, mode);
    }

    pub fn setLoopCount(self: Sound, loopcount: c_int) void {
        self.setMode(c.FMOD_LOOP_NORMAL);
        _ = c.FMOD_Sound_SetLoopCount(self.sound, loopcount);
    }

    pub fn play(self: Sound) void {
        var channel_group = self.system.getMasterChannelGroup();
        var channel = Channel{};
        _ = c.FMOD_System_PlaySound(self.system.fmod, self.sound, channel_group.channel_group, 0, &channel.channel);
    }

    pub fn playInChannelGroup(self: Sound, channel_group: ChannelGroup) void {
        var channel = Channel{};
        _ = c.FMOD_System_PlaySound(self.system.fmod, self.sound, channel_group.channel_group, 0, &channel.channel);
    }
};
