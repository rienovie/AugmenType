#pragma once

#include <godot_cpp/classes/node.hpp>
#include <godot_cpp/classes/wrapped.hpp>
#include <godot_cpp/core/binder_common.hpp>
#include <godot_cpp/templates/list.hpp>
#include <godot_cpp/variant/array.hpp>
#include <godot_cpp/variant/rid.hpp>
#include <godot_cpp/variant/vector2i.hpp>
#include <unordered_set>

namespace godot {

    class AugmenDict : public godot::Node {
        GDCLASS(AugmenDict, Node)

    public:
        AugmenDict();
        ~AugmenDict();

        enum charRestriction {
            None,
            Alternating,
            LeftOnly,
            RightOnly
        };

        struct dictParams {
            godot::Vector2i range;
            charRestriction restriction;
            bool bOnlyDoubles;
        };

        godot::String sNew = "", sLastWord = "";

        void testFunc(godot::String toPrint);
        bool isValidChar(godot::String toCheck);
        godot::String getRandomWord();
        godot::Vector2i getCurrentDictRange();
        charRestriction getCurrentDictRestrict();
        bool getCurrentDictDoubles();
        int getWordCountFromString(godot::String line);
        void buildGameDict(charRestriction restrict,godot::Vector2i range, bool onlyDoubles = false);

    private:
        std::unordered_set<char> leftChars = {
            'q', 'w', 'e', 'r', 't',
            'a', 's', 'd', 'f', 'g',
            'z', 'x', 'c', 'v', 'b'
        };

        std::unordered_set<char> rightChars = {
            'y', 'u', 'i', 'o', 'p',
            'h', 'j', 'k', 'l',
            'n', 'm'
        };

        std::unordered_set<char> invalidChars = {
            '!', '@', '#', '$', '%', '^', '&', '*', '(', ')', '-', '_',
            '=', '+','[', ']', '{', '}', '\\', '|', ';', ':', '\'', '\"',
            ',', '.', '/', '<','>', '?', '~', '`', '0', '1', '2', '3',
            '4', '5', '6', '7', '8', '9'
        };

        godot::List<godot::String>
            mainDict,
            altDict,
            doubleDict,
            leftHandDict,
            rightHandDict,
            dict3,
            dict4,
            dict5,
            dict6,
            dict7,
            dict8,
            dictLarge;

        dictParams currentDictParams;
        std::vector<godot::String> gameDict;

        void populateDicts();
    protected:
        static void _bind_methods();
    };

}

VARIANT_ENUM_CAST(AugmenDict::charRestriction);
