using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class MatChange : MonoBehaviour
{
    
    public Material mat;
    public GameObject go;
    public Button bt;
    void Start()
    {
        
        bt.onClick.AddListener(ChangeShaderTwo);
    }
    public void ChangeShader()
    {
        go.GetComponent<MeshRenderer>().material = mat;
    }
    public void ChangeShaderTwo()
    {
        //Material[0]使用物体上的着色器Element0，Material[1]使用Standard
        Material[] materials = GetComponent<MeshRenderer>().materials;
        materials[1] = new Material(Shader.Find("Standard"));
        materials[1].color = new Color(1, 1, 1, 0);
        GetComponent<Renderer>().materials = materials;
    }
}