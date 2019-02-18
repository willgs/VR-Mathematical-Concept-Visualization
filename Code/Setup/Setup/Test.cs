using UnityEngine;
using System.Collections.Generic;
using System.IO;
using System.Text;
using UnityEditor;
using System;

public class Test : MonoBehaviour
{
    Vector3 YminV = new Vector3(0, float.PositiveInfinity, 0);
    Vector3 XmaxV = new Vector3(float.NegativeInfinity, 0, 0);
    Vector3 ZmaxV = new Vector3(0, 0, float.NegativeInfinity);

    void Start()
    {
        var rend = this.GetComponent<Renderer>();
        Material mat = (Material)AssetDatabase.LoadAssetAtPath("Assets/Setup/ColourByHeight.mat", typeof(Material));

        //Read in some scale data from json: example
        var scaleData = LoadCSV();

        var mesh = this.GetComponent<MeshFilter>().mesh;
        mesh.vertices = scaleVerts(scaleData, mesh);
        transform.localScale = transform.localScale / 15;
        this.GetComponentInParent<Transform>().position = new Vector3(0, 0, 0);

        Material[] mats = { mat };
        rend.materials = mats;
        position();
     

    }

    public scales LoadCSV()
    {
        string name = this.transform.parent.name + ".csv";

        using (var reader = new StreamReader("Assets/Setup/" + name))
        {

            var line = reader.ReadLine();
            var scaleString = line.Split(',');
            List<float> scaleFloat = new List<float>();
            foreach (var d in scaleString)
            {
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

    public Vector3[] scaleVerts(scales scaleData, Mesh mesh)
    {
        float x = scaleData.xHigh - scaleData.xLow;
        float y = scaleData.yHigh - scaleData.yLow;
        float z = scaleData.zHigh - scaleData.zLow;

        float x2 = 1; //Hard code
        float y2 = (x2 * x) / y;
        float z2 = (x2 * x) / z;

        var verts = mesh.vertices;

        for (int i = 0; i < verts.Length; i++)
        {
            var v = verts[i];
            verts[i] = new Vector3((v.x * x2), (v.y * y2), (v.z * z2));
        }
        return verts;
    }

    public void position()
    {
        var table = GameObject.Find("bench_top");

        var tverts = table.GetComponent<MeshFilter>().mesh.vertices;
        Vector3 TYmaxV = new Vector3(0, float.PositiveInfinity, 0);
        Vector3 TXmaxV = new Vector3(float.NegativeInfinity, 0, 0);
        Vector3 TZmaxV = new Vector3(0, 0, float.NegativeInfinity);

        var mesh = GetComponent<MeshFilter>().mesh;
        var verts = mesh.vertices;

        for (int i = 0; i < verts.Length; i++)
        {
            var v = verts[i];
            Vector3 vert = transform.TransformPoint(verts[i]);
            if (vert.x > XmaxV.x)
            {
                XmaxV = vert;
            }
            if (vert.y < YminV.y)
            {
                YminV = vert;
            }
            if (vert.z > ZmaxV.z)
            {
                ZmaxV = vert;
            }
        }

        for (int i = 0; i < tverts.Length; i++)
        {
            var v = tverts[i];
            Vector3 vert = transform.TransformPoint(tverts[i]);
            if (vert.x > TXmaxV.x)
            {
                TXmaxV = vert;
            }
            if (vert.y > TYmaxV.y)
            {
                TYmaxV = vert;
            }
            if (vert.z > TZmaxV.z)
            {
                TZmaxV = vert;
            }
        }
        Debug.Log("Table x max = " + TXmaxV.x + " Figure x pos = " + transform.position.x);
        float diffx = TXmaxV.x - XmaxV.x;
        var point = transform.InverseTransformPoint(transform.position.x - diffx, transform.position.y, transform.position.z);
        transform.position = point;
        Debug.Log("Table x max = " + TXmaxV.x + " Figure  x pos = " +(transform.position.x-diffx));

        return;
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