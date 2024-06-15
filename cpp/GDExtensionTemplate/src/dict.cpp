#include "dict.h"
#include "Util/util.hpp"
#include <cstdlib>
#include <godot_cpp/classes/node.hpp>
#include <godot_cpp/core/class_db.hpp>
#include <godot_cpp/variant/packed_string_array.hpp>
#include <godot_cpp/variant/utility_functions.hpp>
#include <godot_cpp/variant/vector2i.hpp>

using namespace godot;

void AugmenDict::_bind_methods() {

    BIND_ENUM_CONSTANT(None)
    BIND_ENUM_CONSTANT(Alternating)
    BIND_ENUM_CONSTANT(LeftOnly)
    BIND_ENUM_CONSTANT(RightOnly);

    godot::ClassDB::bind_method(godot::D_METHOD("AugTestPrint","toPrint"), &AugmenDict::testFunc);
    
    godot::ClassDB::bind_method(godot::D_METHOD("isValidChar","toCheck"),&AugmenDict::isValidChar);

    godot::ClassDB::bind_method(godot::D_METHOD("getRandomWord"), &AugmenDict::getRandomWord);

    godot::ClassDB::bind_method(godot::D_METHOD("getCurrentDictRange"), &AugmenDict::getCurrentDictRange);

    godot::ClassDB::bind_method(godot::D_METHOD("getCurrentDictDoubles"), &AugmenDict::getCurrentDictDoubles);

    godot::ClassDB::bind_method(godot::D_METHOD("getCurrentDictRestrict"), &AugmenDict::getCurrentDictRestrict);

    godot::ClassDB::bind_method(godot::D_METHOD("getWordCountFromString","line"), &AugmenDict::getWordCountFromString);

    godot::ClassDB::bind_method(godot::D_METHOD("buildGameDict","restrict","range","onlyDoubles"), &AugmenDict::buildGameDict);

}

AugmenDict::AugmenDict() {
    populateDicts();
}
AugmenDict::~AugmenDict() { }

void AugmenDict::testFunc(godot::String toPrint) {
    godot::UtilityFunctions::print(toPrint);
}

bool AugmenDict::isValidChar(godot::String toCheck) {
    return invalidChars.count(toCheck[0]);
}

godot::String AugmenDict::getRandomWord() {
    if(gameDict.size() == 0) { return ""; }
    return gameDict.at(rand() % gameDict.size() - 1);
}

godot::Vector2i AugmenDict::getCurrentDictRange() {
    return currentDictParams.range;
}

AugmenDict::charRestriction AugmenDict::getCurrentDictRestrict() {
    return currentDictParams.restriction;
}

bool AugmenDict::getCurrentDictDoubles() {
    return currentDictParams.bOnlyDoubles;
}

int AugmenDict::getWordCountFromString(godot::String line) {
    int output = 0;
    godot::PackedStringArray words = line.split(" ");
    for(auto word : words) {
        godot::UtilityFunctions::print(word);
        if(mainDict.find(word)) { output++; }
    }
    return output;
}

void AugmenDict::populateDicts() {
    bool
        bDouble,
        bLeftHand,
        bRightHand,
        bAlternating;
    godot::String gLine;
    std::string sLine;
    MACRO_ReadFileByLine("./resources/dict.txt", sLine, {
        gLine = sLine.c_str();
        mainDict.push_back(gLine);
        switch (gLine.length()) {
            case 3:
                dict3.push_back(gLine);
                break;
            case 4:
                dict4.push_back(gLine);
                break;
            case 5:
                dict5.push_back(gLine);
                break;
            case 6:
                dict6.push_back(gLine);
                break;
            case 7:
                dict7.push_back(gLine);
                break;
            case 8:
                dict8.push_back(gLine);
                break;
            default:
                if(gLine.length() >= 9) dictLarge.push_back(gLine);
                else godot::UtilityFunctions::print("Dict populate error char count:",gLine.length()," is not accounted for!");
                break;
        }

        bDouble = false;
        bLeftHand = true;
        bRightHand = true;
        bAlternating = true;
        
        for(int i = 0; i < gLine.length(); i++) {
            if(i != 0) {
                if(!((util::contains(leftChars, sLine[i]) && util::contains(rightChars, sLine[i-1])) || (util::contains(rightChars, sLine[i]) && util::contains(leftChars, sLine[i-1])))) {
                         bAlternating = false;
                }

                if(gLine[i] == gLine[i-1]) bDouble = true;
            }

            if(util::contains(leftChars, sLine[i])) bRightHand = false;
            if(util::contains(rightChars, sLine[i])) bLeftHand = false;
        }

        if(bDouble) doubleDict.push_back(gLine);
        if(bAlternating) altDict.push_back(gLine);
        if(bRightHand) rightHandDict.push_back(gLine);
        if(bLeftHand) leftHandDict.push_back(gLine);

    });
}

void AugmenDict::buildGameDict(AugmenDict::charRestriction restrict, godot::Vector2i range, bool onlyDoubles) {
    gameDict.clear();
    currentDictParams.range = range;
    currentDictParams.bOnlyDoubles = onlyDoubles;
    currentDictParams.restriction = restrict;
    
    godot::List<godot::String>* curDict;

    for (int i = range.x; i < range.y +1; i++) {
        switch(i) {
            case 3:
                curDict = &dict3;
                break;
            case 4:
                curDict = &dict4;
                break;
            case 5:
                curDict = &dict5;
                break;
            case 6:
                curDict = &dict6;
                break;
            case 7:
                curDict = &dict7;
                break;
            case 8:
                curDict = &dict8;
                break;
            case 9:
                curDict = &dictLarge;
                break;
            default:
                godot::UtilityFunctions::push_error("range invalid value of: ",i);
                continue;
        }

        for (auto word : *curDict) {
            switch(restrict) {
                case None:
                    gameDict.push_back(word);
                    break;
                case Alternating:
                    if(altDict.find(word)) gameDict.push_back(word);
                    break;
                case LeftOnly:
                    if(onlyDoubles) {
                        if(doubleDict.find(word) && leftHandDict.find(word)) {
                            gameDict.push_back(word);
                        }
                    }
                    else if(leftHandDict.find(word)) gameDict.push_back(word);
                    break;
                case RightOnly:
                    if(onlyDoubles) {
                        if(doubleDict.find(word) && rightHandDict.find(word)) {
                            gameDict.push_back(word);
                        }
                    }
                    else if(rightHandDict.find(word)) gameDict.push_back(word);
                    break;
                default:
                    godot::UtilityFunctions::push_error("Restrict error!");
                    break;

            }
        }
    }

    godot::UtilityFunctions::print("Cpp Dicts Populated!");
}
