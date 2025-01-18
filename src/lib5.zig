const std = @import("std");
const testing = std.testing;

const Animal = struct {
    vtable: *const VTable,
    instance: *anyopaque,

    const VTable = struct {
        voiceFn: *const fn (*anyopaque) []const u8,
        nameFn: *const fn (*anyopaque) []const u8,
    };

    pub fn voice(self: *const Animal) []const u8 {
        return self.vtable.voiceFn(self.instance);
    }

    pub fn name(self: *const Animal) []const u8 {
        return self.vtable.nameFn(self.instance);
    }

    pub fn init(comptime T: type, instance: *T) Animal {
        const vtable = comptime VTable{
            .voiceFn = struct {
                fn func(ptr: *anyopaque) []const u8 {
                    const self = @as(*T, @ptrCast(@alignCast(ptr)));
                    return self.voice();
                }
            }.func,
            .nameFn = struct {
                fn func(ptr: *anyopaque) []const u8 {
                    const self = @as(*T, @ptrCast(@alignCast(ptr)));
                    return self.name();
                }
            }.func,
        };
        return .{
            .vtable = &vtable,
            .instance = instance,
        };
    }
};

const Cat = struct {
    name_str: []const u8,

    pub fn voice(_: *const Cat) []const u8 {
        return "meow";
    }

    pub fn name(self: *const Cat) []const u8 {
        return self.name_str;
    }

    pub fn asAnimal(self: *Cat) Animal {
        return Animal.init(Cat, self);
    }
};

const Dog = struct {
    name_str: []const u8,

    pub fn voice(_: *const Dog) []const u8 {
        return "bow wow";
    }

    pub fn name(self: *const Dog) []const u8 {
        return self.name_str;
    }

    pub fn asAnimal(self: *Dog) Animal {
        return Animal.init(Dog, self);
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