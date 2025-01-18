const std = @import("std");
const testing = std.testing;

const Animal = struct {
    voiceFn: *const fn (self: *anyopaque) []const u8,

    pub fn voice(self: *Animal) []const u8 {
        return self.voiceFn(self);
    }
};

const Cat = struct {
    pub fn meow(_: *Cat) []const u8 {
        return "meow";
    }

    pub fn asAnimal(_: *Cat) Animal {
        return .{
            .voiceFn = struct {
                fn voice(ptr: *anyopaque) []const u8 {
                    const self_ptr = @as(*Cat, @ptrCast(@alignCast(ptr)));
                    return self_ptr.meow();
                }
            }.voice,
        };
    }
};

const Dog = struct {
    pub fn bow(_: *Dog) []const u8 {
        return "bow wow";
    }

    pub fn asAnimal(_: *Dog) Animal {
        return .{
            .voiceFn = struct {
                fn voice(ptr: *anyopaque) []const u8 {
                    const self_ptr = @as(*Dog, @ptrCast(@alignCast(ptr)));
                    return self_ptr.bow();
                }
            }.voice,
        };
    }
};

pub fn animalVoice(animal: *Animal) []const u8 {
    return animal.voice();
}

test "animal voice with interface" {
    var cat = Cat{};
    var dog = Dog{};
    
    var cat_animal = cat.asAnimal();
    var dog_animal = dog.asAnimal();

    try testing.expectEqualSlices(u8, "meow", animalVoice(&cat_animal));
    try testing.expectEqualSlices(u8, "bow wow", animalVoice(&dog_animal));
}
