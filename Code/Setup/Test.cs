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

        float Xscale = x2 / x;
        float Yscale = y2 / y;
        float Zscale = z2 / z;

        transform.localScale = new Vector3((x * Xscale)/10, (y * Yscale)/10, (z * Zscale)/10);
        transform.position = new Vector3(-0.542f, 1.68f, -2.075f);

        Material[] mats = { mat };
        rend.materials = mats;



    }
}