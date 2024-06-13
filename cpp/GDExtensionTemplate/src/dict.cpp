#include "dict.h"
#include "Util/util.hpp"
#include <godot_cpp/classes/node.hpp>
#include <godot_cpp/core/class_db.hpp>
#include <godot_cpp/variant/utility_functions.hpp>

using namespace godot;

void AugmenDict::_bind_methods() {

    BIND_ENUM_CONSTANT(None)
    BIND_ENUM_CONSTANT(Alternating)
    BIND_ENUM_CONSTANT(LeftOnly)
    BIND_ENUM_CONSTANT(RightOnly);

    godot::ClassDB::bind_method(godot::D_METHOD("AugTestPrint","toPrint"), &AugmenDict::testFunc);
    
    godot::ClassDB::bind_method(godot::D_METHOD("isValidChar","toCheck"),&AugmenDict::isValidChar);

}
AugmenDict::AugmenDict() { }
AugmenDict::~AugmenDict() { }

void AugmenDict::testFunc(godot::String toPrint) {
    godot::UtilityFunctions::print(toPrint);
}

bool AugmenDict::isValidChar(godot::String toCheck) {
    return invalidChars.count(toCheck[0]);
}

