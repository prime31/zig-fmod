const c = @import("c.zig");
const Sound = @import("sound.zig").Sound;

pub const ChannelGroup = struct {
    channel_group: ?*c.FMOD_CHANNELGROUP = null,

    pub fn addDsp(self: ChannelGroup, index: c_int, dsp: Dsp) void {
        _ = c.FMOD_ChannelGroup_AddDSP(self.channel_group, index, dsp.dsp);
    }

    pub fn removeDsp(self: ChannelGroup, dsp: Dsp) void {
        _ = c.FMOD_ChannelGroup_RemoveDSP(self.channel_group, dsp.dsp);
    }
};

pub const Channel = struct {
    channel: ?*c.FMOD_CHANNEL = null
};

pub const SoundGroup = struct {
    group: ?*c.FMOD_SOUNDGROUP = null
};

pub const Dsp = struct {
    dsp: ?*c.FMOD_DSP = null
};

pub const System = struct {
    fmod: ?*c.FMOD_SYSTEM = undefined,

    pub fn init() System {
        var sys = System{};
        if (c.FMOD_System_Create(&sys.fmod) != .FMOD_OK) {
            @panic("uh oh. no audio");
        }

        if (c.FMOD_System_Init(sys.fmod, 32, c.FMOD_INIT_NORMAL, null) != .FMOD_OK) {
            @panic("uh oh. no init audio");
        }

        return sys;
    }

    pub fn deinit(self: System) void {
        _ = c.FMOD_System_Release(self.fmod);
    }

    pub fn createSound(self: System, file: [*c]const u8) !Sound {
        return Sound.init(self, file);
    }

    pub fn getChannel(self: System, channelid: c_int) Channel {
        var channel = Channel{};
        _ = c.FMOD_System_GetChannel(self.fmod, channelid, &channel.channel);
        return channel;
    }

    pub fn getMasterChannelGroup(self: System) ChannelGroup {
        var channel_group = ChannelGroup{};
        _ = c.FMOD_System_GetMasterChannelGroup(self.fmod, &channel_group.channel_group);
        return channel_group;
    }

    pub fn createChannelGroup(self: System) ChannelGroup {
        var channel_group = ChannelGroup{};
        _ = c.FMOD_System_CreateChannelGroup(self.fmod, "name", &channel_group.channel_group);
        return channel_group;
    }

    pub fn createSoundGroup(self: System) SoundGroup {
        var sound_group = SoundGroup{};
        _ = c.FMOD_System_CreateSoundGroup(self.fmod, "nane", &sound_group.group);
        return sound_group;
    }

    pub fn createDspByType(self: System, dsp_type: c.FMOD_DSP_TYPE) Dsp {
        var dsp = Dsp{};
        _ = c.FMOD_System_CreateDSPByType(self.fmod, dsp_type, &dsp.dsp);
        return dsp;
    }
};