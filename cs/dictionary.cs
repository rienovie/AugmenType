using Godot;
using Godot.Collections;
using System;
using System.Collections;
using System.Collections.Generic;
using System.ComponentModel.Design.Serialization;
using System.IO;
using System.Linq;
using System.Reflection.Metadata;


public partial class dictionary : Node
{
    public enum ECharRestriction
    {
        None, Alternating, LeftOnly, RightOnly
    }

    private readonly Random rand = new();

    public HashSet<string> mainDict = new();
    public HashSet<string> alternatingDict = new();
    public HashSet<string> doubleDict = new();
    public HashSet<string> leftHandDict = new();
    public HashSet<string> rightHandDict = new();
    public HashSet<string> threeDict = new();
    public HashSet<string> fourDict = new();
    public HashSet<string> fiveDict = new();
    public HashSet<string> sixDict = new();
    public HashSet<string> sevenDict = new();
    public HashSet<string> eightDict = new();
    public HashSet<string> largeDict = new();

    public HashSet<string> gameDict = new();
    
    public HashSet<char> leftChars = new()
    {
        'q', 'w', 'e', 'r', 't',
        'a', 's', 'd', 'f', 'g',
        'z', 'x', 'c', 'v', 'b'
    };

    public HashSet<char> rightChars = new()
    {
        'y', 'u', 'i', 'o', 'p',
        'h', 'j', 'k', 'l',
        'n', 'm'
    };

    public HashSet<char> invalidChars = new()
    {
        '!', '@', '#', '$', '%', '^', '&', '*', '(', ')', '-', '_', '=', '+',
        '[', ']', '{', '}', '\\', '|', ';', ':', '\'', '\"', ',', '.', '/', '<',
        '>', '?', '~', '`', '0', '1', '2', '3', '4', '5', '6', '7', '8', '9'
    };

    public bool isValidChar(string newText) {
        return invalidChars.Contains(newText[0]);
    }

    public struct DictParameters {
        public Vector2I range;
        public int restrict;
        public bool onlyDoubles;
    }

    public DictParameters currentDictParams = new();
    
    public override void _Ready()
    {
        base._Ready();
        PopulateDicts();
    }

    private void PopulateDicts()
    {
        bool bDouble, bLeftHand, bRightHand, bAlternating;
        foreach(string line in File.ReadAllLines("./resources/dict.txt"))
        {
            mainDict.Add(line);
            switch (line.Length)
            {
                case 3:
                    threeDict.Add(line);
                    break;
                case 4:
                    fourDict.Add(line);
                    break;
                case 5:
                    fiveDict.Add(line);
                    break;
                case 6:
                    sixDict.Add(line);
                    break;
                case 7:
                    sevenDict.Add(line);
                    break;
                case 8:
                    eightDict.Add(line);
                    break;
                case >= 9:
                    largeDict.Add(line);
                    break;
                default:
                    GD.PushError("Char count",line.Length," for word: ",line," is not accounted for!");
                    break;
            }

            bDouble = false;
            bLeftHand = true;
            bRightHand = true;
            bAlternating = true;

            //for each char in line
            for(int i = 0; i < line.Length; i++)
            {
                //TODO improve this by skipping if already set
                if(i != 0)
                {
                    //checks if not alternating chars
                    if(!((leftChars.Contains(line[i]) && rightChars.Contains(line[i-1]))
                    || (rightChars.Contains(line[i]) && leftChars.Contains(line[i-1]))))
                    {
                        bAlternating = false;
                    }

                    if(line[i] == line[i-1])
                    {
                        bDouble = true;
                    }

                }
                //checks if not Single Hand
                if(leftChars.Contains(line[i]))
                {
                    bRightHand = false;
                }
                
                if(rightChars.Contains(line[i]))
                {
                    bLeftHand = false;
                }
            }

            if(bDouble) doubleDict.Add(line);
            if(bAlternating) alternatingDict.Add(line);
            if(bRightHand) rightHandDict.Add(line);
            if(bLeftHand) leftHandDict.Add(line);

        }
    }

    public string[] GetMainDictionary()
    {
        return mainDict.ToArray();
    }

    public Vector2I GetCurrentDictRange() {
        return currentDictParams.range;
    }

    public int GetCurrentDictRestrict() {
        return currentDictParams.restrict;
    }

    public bool GetCurrentDictDoubles() {
        return currentDictParams.onlyDoubles;
    }

    public void BuildGameDict(Vector2I range, int restrict, bool onlyDoubles)
    {
        gameDict.Clear();
        currentDictParams.range = range;
        currentDictParams.restrict = restrict;
        currentDictParams.onlyDoubles = onlyDoubles;

        HashSet<HashSet<string>> workingSets = new();
        HashSet<string> buildSet = new();
        
        //populate workingSets
        for(int i = range.X; i < range.Y + 1; i++)
        {
            switch (i)
            {
                case 3:
                    workingSets.Add(threeDict);
                    break;
                case 4:
                    workingSets.Add(fourDict);
                    break;
                case 5:
                    workingSets.Add(fiveDict);
                    break;
                case 6:
                    workingSets.Add(sixDict);
                    break;
                case 7:
                    workingSets.Add(sevenDict);
                    break;
                case 8:
                    workingSets.Add(eightDict);
                    break;
                case >= 9:
                    workingSets.Add(largeDict);
                    break;
                default:
                    GD.PushError("Range Error when building Game Dict! ",i," is not defined!");
                    break;
            }
        }

        foreach(HashSet<string> curSet in workingSets)
        {
            buildSet.Clear();
            
            switch ((ECharRestriction)restrict)
            {  
                case ECharRestriction.None:
                    if(onlyDoubles)
                    {
                        buildSet.UnionWith(curSet);
                        buildSet.IntersectWith(doubleDict);
                        gameDict.UnionWith(buildSet);
                    }
                    else
                    {
                        gameDict.UnionWith(curSet);
                    }
                    break;
                case ECharRestriction.Alternating:
                    buildSet.UnionWith(curSet);
                    buildSet.IntersectWith(alternatingDict);
                    gameDict.UnionWith(buildSet);
                    break;
                case ECharRestriction.LeftOnly:
                    if(onlyDoubles)
                    {
                        buildSet.UnionWith(curSet);
                        buildSet.IntersectWith(leftHandDict);
                        buildSet.IntersectWith(doubleDict);
                        gameDict.UnionWith(buildSet);
                    }
                    else
                    {
                        buildSet.UnionWith(curSet);
                        buildSet.IntersectWith(leftHandDict);
                        gameDict.UnionWith(buildSet);
                    }
                    break;
                case ECharRestriction.RightOnly:
                    if(onlyDoubles)
                    {
                        buildSet.UnionWith(curSet);
                        buildSet.IntersectWith(rightHandDict);
                        buildSet.IntersectWith(doubleDict);
                        gameDict.UnionWith(buildSet);
                    }
                    else
                    {
                        buildSet.UnionWith(curSet);
                        buildSet.IntersectWith(rightHandDict);
                        gameDict.UnionWith(buildSet);
                    }
                    break;
                default:
                    GD.PushError("Char restriction not defined in Build Game Dict! Value: ",restrict);
                    break;
            }
        }
        GD.Print("Dicts Populated!");
    }

    public string RandomWord()
    {
        if(gameDict.Count == 0) {return "";}
        return gameDict.ElementAt(rand.Next(gameDict.Count));
    }

    public int GetWordCountFromString(string line)
    {
        int output = 0;
        string[] splitLine = line.Split(' ');
        foreach(string word in splitLine)
        {
            if(mainDict.Contains(word)) { output++; }
        }
        return output;
    }

}
