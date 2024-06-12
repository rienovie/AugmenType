#include "dict.h"
#include "Util/util.hpp"
#include <godot_cpp/classes/node.hpp>
#include <godot_cpp/core/class_db.hpp>
#include <godot_cpp/variant/utility_functions.hpp>

using namespace godot;

void AugmenDict::_bind_methods() {

    godot::ClassDB::bind_method(godot::D_METHOD("AugTestPrint","toPrint"), &godot::AugmenDict::testFunc);

}

void AugmenDict::testFunc(godot::String toPrint) {
    godot::UtilityFunctions::print(toPrint);
}

AugmenDict::AugmenDict() { }
AugmenDict::~AugmenDict() { }


