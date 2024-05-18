using Godot;
using Godot.Collections;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;



public partial class dictionary : Node
{
    private readonly Random rand = new();

    public HashSet<string> mainDict = new();
    
    public override void _Ready()
    {
        base._Ready();
        foreach(string line in File.ReadAllLines("./resources/dict.txt"))
        {
            mainDict.Add(line);
        }
        
    }

    public string[] GetMainDictionary()
    {
        return mainDict.ToArray();
    }

    public string RandomWord() 
    {
        return mainDict.ElementAt(rand.Next(mainDict.Count));
    }

}
