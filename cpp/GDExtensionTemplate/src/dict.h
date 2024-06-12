#pragma once

#include <godot_cpp/classes/node.hpp>
#include <godot_cpp/classes/wrapped.hpp>
#include <unordered_set>

namespace godot {
    
    class AugmenDict : public godot::Node {
        GDCLASS(AugmenDict, Node)
    
    public:
        AugmenDict();
        ~AugmenDict();
        
        void testFunc(godot::String toPrint);

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

        std::unordered_set<std::string>
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
            dictLarge,
            dictGame;
    protected:
        static void _bind_methods();
    };
    
}
