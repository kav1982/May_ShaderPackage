using System.Collections;
using System.Collections.Generic;
using UnityEditor;
using UnityEngine;

public class MatTest : MonoBehaviour
{ 
    Renderer rend;
    public Material material;
    public bool m_AutoPlay = false;
    [SerializeField] public float AniSpeed;
    [SerializeField] public int row;
    [SerializeField] public int col;
    [SerializeField] public int _ticked;
    private float _time;
    
    private void Init()
    {
        _ticked = 0;
        _time = 0;
        m_AutoPlay = false;
        material.SetTextureScale("_SampleTex",new Vector2(1/row, 1/col));
    }
    
    private void SetContainerSprite(int index)
    {
        int colIndex = index / col;
        int rowIndex = index % col;
        material.SetTextureOffset("_SampleTex", new Vector2(1/col * rowIndex, 1/row * colIndex));
    }
    
    
    
    // Start is called before the first frame update
    void Start()
    {
        rend = GetComponent<Renderer> ();
        //rend.enabled = true;
        rend.sharedMaterial = material;
        rend.material.SetFloat("_AniSheetSpeed", AniSpeed);
        rend.material.SetVector("_AniSheetTile", new Vector4(row,col,0,0));
    }

    // Update is called once per frame
    void Update()
    {
        if (m_AutoPlay)
        {
            rend.enabled = true;
            rend.material.EnableKeyword("ANIMATION_SHEET");
        }

        else
        {
            rend.enabled = false;
            rend.material.DisableKeyword("ANIMATION_SHEET");
            
        }
    }
}
