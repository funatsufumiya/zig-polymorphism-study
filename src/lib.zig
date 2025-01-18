const std = @import("std");
const testing = std.testing;

const Cat = struct {
    pub fn meow(_: *Cat) []const u8 {
        return "meow";
    }

    pub fn voice(self: *Cat) []const u8 {
        return self.meow();
    }
};

const Dog = struct {
    pub fn bow(_: *Dog) []const u8 {
        return "bow wow";
    }

    pub fn voice(self: *Dog) []const u8 {
        return self.bow();
    }
};

pub fn animalVoice(animal: anytype) void {
    animal.voice();
}

test "animal voice" {
    var cat = Cat{};
    var dog = Dog{};

    try testing.expectEqualSlices(u8, "meow", cat.voice());
    try testing.expectEqualSlices(u8, "bow wow", dog.voice());
}