using System;
using System.Collections.Generic;
using System.IO;
using UnityEditor;
using UnityEngine;

public class Test : MonoBehaviour
{
    void Start()
    {
      
        Material mat = (Material)AssetDatabase.LoadAssetAtPath("Assets/Setup/ColourByHeight.mat", typeof(Material));

        var scaleData = LoadCSV();

        scaleVerts(scaleData);
        var rend = GetComponent<Renderer>();
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

    public void scaleVerts(scales scaleData)
    {
        var mesh = GetComponent<MeshFilter>().mesh;
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
        Vector3 YminV = new Vector3(0, float.PositiveInfinity, 0);
        Vector3 YmaxV = new Vector3(0, float.NegativeInfinity, 0);
        Vector3 XminV = new Vector3(float.PositiveInfinity, 0, 0);
        Vector3 XmaxV = new Vector3(float.NegativeInfinity, 0, 0);
        Vector3 ZminV = new Vector3(0, 0, float.PositiveInfinity);
        Vector3 ZmaxV = new Vector3(0, 0, float.NegativeInfinity);

        for (int i = 0; i < verts.Length; i++)
        {
            var v = verts[i];
            Vector3 vert = transform.TransformPoint(verts[i]);
            if (vert.x > XmaxV.x)
            {
                XmaxV = vert;
            } else if(vert.x < XminV.x)
            {
                XminV = vert;
            }
            if (vert.y > YminV.y)
            {
                YmaxV = vert;
            } else if (vert.y < YminV.y)
            {
                YminV = vert;
            }
            if (vert.z > ZmaxV.z)
            {
                ZmaxV = vert;
            } else if (vert.z < ZminV.z)
            {
                ZminV = vert;
            }
        }
        var XCenter = (XmaxV.x - XminV.x)/2;
        var YCenter = (YmaxV.y - YmaxV.y)/2;
        var ZCenter = (ZmaxV.z - ZmaxV.z)/2;
        this.GetComponent<Renderer>().bounds.SetMinMax(new Vector3(XmaxV.x, YmaxV.y, ZmaxV.z), new Vector3(XminV.x, YminV.y, ZminV.z));
        
        //= new Vector3(XCenter, YCenter, ZCenter);
        Debug.Log(XmaxV +" \n" + XminV + " \n" + YmaxV + " \n" + YminV + " \n" + ZmaxV + " \n" + ZminV);
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

        } while (cubeBounds.x < figBounds.x || cubeBounds.y < figBounds.y || cubeBounds.z < figBounds.z);
       //do
        //{
        //    transform.position = new Vector3(transform.position.x, transform.position.y - 0.01f, transform.position.z);
        //} while (!GetComponent<Renderer>().bounds.Intersects(GameObject.Find("bench_top").GetComponent<Renderer>().bounds));
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