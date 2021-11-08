using System.Collections;
using System.Collections.Generic;
using UnityEditor;
using UnityEngine;

public class MatTest : MonoBehaviour
{ 
    Renderer rend;
    private Material material;
    private float _time;
    public bool m_AutoPlay = false;
    public bool isLoop = true;
    [SerializeField] public float AniSpeed;
    [SerializeField] public int row;
    [SerializeField] public int col;
    [SerializeField] public int _ticked;

    
    
    private void SetContainerSprite(int index)
    {
        int colIndex = index / col;
        int rowIndex = index % col;
        //Debug.Log(string.Format("{0},{1},{2}", index, 1.0f/row * colIndex, 1.0f/col * rowIndex));
        material.SetTextureOffset("_SampleTex", new Vector2(1.0f/col * rowIndex,1.0f/row * colIndex));
    }


    void Start()
    {
        rend = GetComponent<Renderer> ();
        material = rend.material;
        //rend.sharedMaterial = material;
        material.SetFloat("_AniSheetSpeed", AniSpeed);
        material.SetVector("_AniSheetTile", new Vector4(row,col,0,0));
        material.SetTextureScale("_SampleTex", new Vector2(1.0f / row, 1.0f / col));
        material.SetTextureOffset("_SampleTex", new Vector2(0, 0));

    }
    
    void Update()
    {
        if (m_AutoPlay)
        {
            _time += Time.deltaTime;
            if (_time > AniSpeed)
            {
                
                if (_ticked == row * col)
                {
                    if (isLoop)
                    {
                        _ticked = 0;
                    }
                    else
                    {
                        _ticked = row * col - 1;
                    }
                }
                _time = 0;
                SetContainerSprite(_ticked);
                _ticked++;
            }
        }
    }
    

}
