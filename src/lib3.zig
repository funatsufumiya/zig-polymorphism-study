const std = @import("std");
const testing = std.testing;

const Animal = struct {
    ptr: *anyopaque,
    voiceFn: *const fn (ptr: *anyopaque) []const u8,
    nameFn: *const fn (ptr: *anyopaque) []const u8,

    pub fn voice(self: *const Animal) []const u8 {
        return self.voiceFn(self.ptr);
    }

    pub fn name(self: *const Animal) []const u8 {
        return self.nameFn(self.ptr);
    }
};

const Cat = struct {
    name_str: []const u8,

    pub fn meow(_: *const Cat) []const u8 {
        return "meow";
    }

    pub fn name(self: *const Cat) []const u8 {
        return self.name_str;
    }

    pub fn asAnimal(self: *Cat) Animal {
        return .{
            .ptr = self,
            .voiceFn = struct {
                fn voice(ptr: *anyopaque) []const u8 {
                    const self_ptr = @as(*const Cat, @ptrCast(@alignCast(ptr)));
                    return self_ptr.meow();
                }
            }.voice,
            .nameFn = struct {
                fn name(ptr: *anyopaque) []const u8 {
                    const self_ptr = @as(*const Cat, @ptrCast(@alignCast(ptr)));
                    return self_ptr.name();
                }
            }.name,
        };
    }
};

const Dog = struct {
    name_str: []const u8,

    pub fn bow(_: *const Dog) []const u8 {
        return "bow wow";
    }

    pub fn name(self: *const Dog) []const u8 {
        return self.name_str;
    }

    pub fn asAnimal(self: *Dog) Animal {
        return .{
            .ptr = self,
            .voiceFn = struct {
                fn voice(ptr: *anyopaque) []const u8 {
                    const self_ptr = @as(*const Dog, @ptrCast(@alignCast(ptr)));
                    return self_ptr.bow();
                }
            }.voice,
            .nameFn = struct {
                fn name(ptr: *anyopaque) []const u8 {
                    const self_ptr = @as(*const Dog, @ptrCast(@alignCast(ptr)));
                    return self_ptr.name();
                }
            }.name,
        };
    }
};

pub fn animalVoice(animal: *const Animal) []const u8 {
    return animal.voice();
}

pub fn animalName(animal: *const Animal) []const u8 {
    return animal.name();
}

test "animal voice and name with interface" {
    var cat = Cat{ .name_str = "Tama" };
    var dog = Dog{ .name_str = "Pochi" };
    
    var cat_animal = cat.asAnimal();
    var dog_animal = dog.asAnimal();

    try testing.expectEqualSlices(u8, "meow", animalVoice(&cat_animal));
    try testing.expectEqualSlices(u8, "bow wow", animalVoice(&dog_animal));
    try testing.expectEqualSlices(u8, "Tama", animalName(&cat_animal));
    try testing.expectEqualSlices(u8, "Pochi", animalName(&dog_animal));
}
