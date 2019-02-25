using System;
using System.Collections.Generic;
using System.IO;
using UnityEditor;
using UnityEngine;

public class View_Adjust : MonoBehaviour
{
    public float yscale;
    void Start()
    {
        var scaleData = LoadCSV();  
        scaleVerts(scaleData);
        position();
        lower();
        color();
    }

    public scales LoadCSV()
    {
        string name = this.transform.parent.name + ".csv";

        using (var reader = new StreamReader("Assets/Setup/" + name))
        {
            reader.ReadLine();
            var line = reader.ReadLine();
            var scaleString = line.Split(',');
            Array.Resize(ref scaleString,scaleString.Length -1);
            List<float> scaleFloat = new List<float>();
            foreach (var d in scaleString)
            {
                Convert.ToDouble(d);
                scaleFloat.Add((float)Convert.ToDouble(d));
            }
            return new scales
            {
                xHigh = scaleFloat[0],
                xLow = scaleFloat[1],
                yHigh = scaleFloat[2],
                yLow = scaleFloat[3],
                zHigh = scaleFloat[4],
                zLow = scaleFloat[5]
            };
        }
    }

    public void scaleVerts(scales scaleData)
    {
        var mesh = GetComponent<MeshFilter>().mesh;
        float x = scaleData.xHigh - scaleData.xLow;
        float y = scaleData.yHigh - scaleData.yLow;
        float z = scaleData.zHigh - scaleData.zLow;

        float x2 = 1; //Hard code
        float y2 = (x2 * x) / y;
        float z2 = (x2 * x) / z;
        yscale = y2 * y;
        Debug.Log("y " + y + " y2 " + y2 + " = " + y * y2);
        var verts = mesh.vertices;

        for (int i = 0; i < verts.Length; i++)
        {
            var v = verts[i];
            verts[i] = new Vector3((v.x * x2), (v.y * y2), (v.z * z2));
        }

        mesh.vertices = verts;
    }

    public void position()
    {
        var cube = GameObject.Find("Cube");
        transform.position = cube.transform.position;
        var figBounds = GetComponent<Renderer>().bounds.extents;
        var cubeBounds = cube.GetComponent<Renderer>().bounds.extents;
     
        do
        {
            transform.position = cube.transform.position;
            var center = GetComponent<Renderer>().bounds.center;
            var diffx = transform.position.x - center.x;
            var diffy = transform.position.y - center.y;
            var diffz = transform.position.z - center.z;

            transform.position = new Vector3(transform.position.x + diffx, transform.position.y + diffy, transform.position.z + diffz);
            transform.localScale = transform.localScale / 1.01f;
            figBounds = GetComponent<Renderer>().bounds.extents;

        } while (cubeBounds.x < figBounds.x || cubeBounds.z < figBounds.z); //Ignore the y value, scaling causes bounds.y issues, deal with it in lower()

        return;
    }

    public void lower()
    {
        Vector3 YminV = new Vector3(0, float.PositiveInfinity, 0);
        var mesh = GetComponent<MeshFilter>().mesh;
        var verts = mesh.vertices;
        for (int i = 0; i < verts.Length; i++)
        {
            var v = verts[i];
            Vector3 vert = transform.TransformPoint(verts[i]);
            if (vert.y < YminV.y)
            {
                YminV = vert;
            }

        }
        var sphere = GameObject.Find("Sphere");
        var diff = YminV.y - sphere.transform.position.y;
        transform.position = new Vector3(transform.position.x, transform.position.y - diff, transform.position.z);
    }

    public void color()
    {
        Vector3 YminV = new Vector3(0, float.PositiveInfinity, 0);
        Vector3 YmaxV = new Vector3(0, float.NegativeInfinity, 0);
        var mesh = GetComponent<MeshFilter>().mesh;
        var verts = mesh.vertices;
        for (int i = 0; i < verts.Length; i++)
        {
            var v = verts[i];
            Vector3 vert = transform.TransformPoint(verts[i]);
            if (vert.y < YminV.y)
            {
                YminV = vert;
            } else if(vert.y > YmaxV.y)
            {
                YmaxV = vert;
            }

        }
        var diff = YmaxV.y - YminV.y;
        Debug.Log(YmaxV.y + " and " + YminV.y + " equal " +diff );

        var matHeights = new float[4];
        matHeights[0] = yscale / 3.278f;
        matHeights[1] = matHeights[0] / 1.187f;
        matHeights[2] = matHeights[1] / -2.286f;
        matHeights[3] = matHeights[2] / 0.225f;

        var rend = GetComponent<Renderer>();
        Material mat = (Material)AssetDatabase.LoadAssetAtPath("Assets/Setup/ColourByHeight.mat", typeof(Material));
        mat.SetFloat("_First", matHeights[0]);
        mat.SetFloat("_Second", matHeights[1]);
        mat.SetFloat("_Third", matHeights[2]);
        mat.SetFloat("_Fourth", matHeights[3]);
        Material[] mats = { mat };
        rend.materials = mats;
    }
}

public class scales
{
    public float xHigh;
    public float xLow;
    public float yHigh;
    public float yLow;
    public float zHigh;
    public float zLow;
}