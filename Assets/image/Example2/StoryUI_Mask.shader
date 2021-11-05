Shader "Bioum/Effect/Story_MaskSet"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _SampleTex ("Mask Texture " , 2D) = "black" {}
        
    }
    SubShader
    {
       Tags{
            "Queue" = "Transparent"
            "IgnoreProjector" = "True"
            "RenderType" = "Transparent"
        }

        Cull Off ZWrite Off ZTest Always
        // 混合模式 最终颜色 = 源颜色 * 源a  + (1 - a) * 目标颜色
        Blend SrcAlpha OneMinusSrcAlpha


        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
            };

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                return o;
            }

            sampler2D _MainTex;

            // 由脚本传入的像素信息
            sampler2D _SampleTex;
            
            fixed4 frag (v2f i) : SV_Target
            {
                fixed4 col = tex2D(_MainTex, i.uv);
                fixed4 maskCol = tex2D(_SampleTex, i.uv);
                // 取相反值
                col.a = col.a* (1 - maskCol.r);
              
        
                return col;
            }
            ENDCG
        }
    }
}
