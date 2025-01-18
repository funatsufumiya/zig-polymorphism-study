const std = @import("std");
const b = @import("lib6.zig");

pub fn main() !void {
    var cat = b.Cat{ .name_str = "Tama" };
    var dog = b.Dog{ .name_str = "Pochi" };
    
    var cat_animal = cat.asAnimal();
    var dog_animal = dog.asAnimal();

    std.debug.print("cat voice: {s}\n", .{b.animalVoice(&cat_animal)});
    std.debug.print("dog voice: {s}\n", .{b.animalVoice(&dog_animal)});
    std.debug.print("cat name: {s}\n", .{b.animalName(&cat_animal)});
    std.debug.print("dog name: {s}\n", .{b.animalName(&dog_animal)});
}
