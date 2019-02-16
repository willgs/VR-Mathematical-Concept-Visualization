using UnityEngine;
using System.Collections;
using System.Text;
using UnityEditor;

public class Test : MonoBehaviour
{

    void Start()
    {
        var rend = this.GetComponent<Renderer>();
        Material mat = (Material)AssetDatabase.LoadAssetAtPath("Assets/Setup/ColourByHeight.mat", typeof(Material));

        //Read in some scale data from json: example
        float x = 3;
        float y = 1;
        float z = 3;

        float x2 = 1; //Hard code
        float y2 = (x2 * x) / y;
        float z2 = (x2 * x) / z;
        
        var mesh = this.GetComponent<MeshFilter>().mesh;
        var verts = mesh.vertices;
        for (int i = 0; i < verts.Length; i++) 
        {
            var v = verts[i];
            verts[i] = new Vector3((v.x * x2), (v.y * y2), (v.z * z2));
        }
        mesh.vertices = verts;
        transform.localScale = transform.localScale/15;
        this.GetComponentInParent<Transform>().position = new Vector3(0,0,0);
        transform.position = new Vector3(0.49f, 0.72f, 0.509f);

        Material[] mats = { mat };
        rend.materials = mats;



    }
}