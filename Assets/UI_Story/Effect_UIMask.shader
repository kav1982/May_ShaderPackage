Shader "Bioum/Effect/UIMaskSet"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _SampleTex ("MaskTexture" , 2D) = "black" {}
        
        [Toggle(ANIMATION_SHEET)] _AnimationSheet ("序列帧", int) = 0
        _AniSheetSpeed("序列帧速度", float) = 1
        _AniSheetTile("序列帧规格", vector) = (3,3,0,0)
        
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
            #pragma multi_compile __ ANIMATION_SHEET
            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float4 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float2 aniuv : TEXCOORD1;
                float4 vertex : SV_POSITION;
            };

            sampler2D _MainTex;            
            sampler2D _SampleTex;
            float4 _MainTex_ST, _SampleTex_ST;

             #if ANIMATION_SHEET
                float _AniSheetSpeed;
                float4 _AniSheetTile;
            #endif

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv.xy;
                o.aniuv = v.uv.zw;
                float anitime = fmod(_Time.y, 100);
                #if ANIMATION_SHEET                   
					float2 d = 1 / _AniSheetTile.xy;
                    float time = anitime * _AniSheetSpeed;
                    float2 xy = floor(float2(time, time * d.x));
                    float2 ani = frac(xy * d.xy);
                    o.aniuv = o.uv * d.xy + float2(ani.x, -ani.y);                     
                #else
					o.aniuv = o.uv * _SampleTex_ST.xy + _SampleTex_ST.zw;					                   
                #endif
                return o;
            }

            
            
            fixed4 frag (v2f i) : SV_Target
            {
                fixed4 col = tex2D(_MainTex, i.uv);
                fixed4 maskCol = tex2D(_SampleTex, i.aniuv);
               
                // 取相反值
                col.a = col.a* (1 - maskCol.r);
              
        
                return col;
            }
            ENDCG
        }
    }
}
