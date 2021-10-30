
Shader "Bioum/Effect/burn"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _BurnTex ("Texture", 2D) = "white" {}
        _NoiseMap("Noise" , 2D) = "black"{}
        _NoiseMap2("Noise2" , 2D) = "black"{}
        
        [Header(Burn)]	
        _Blend("Blend" , Range(-1,3)) = 0	
        _Angle("Angle" , range (-3.14,3.14)) =0
        
        _Range("Range" , Range(0.01, 1)) = 0
        //_BurnRange("BurnRange" , Range(-0.5, 0.5)) = 0
        _RangeOffset("Range Offset" , Range(-1,1)) = 0
        _ClipOffset("Clip Offset" , Range(0,1)) = 0.5
        [hdr]_RangeColor("RangeColor" , Color) = (1,0,0,1)
        [hdr]_SparkColor("SparkColor" , Color) = (1,0,0,1)
        _FloatVector("Flow Vector" , vector) = (0,0,0,0)
        
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100
        Blend SrcAlpha OneMinusSrcAlpha
        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex   : POSITION;
                float2 uv       : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv       : TEXCOORD0;
                float4 uv2      : TEXCOORD1;
                float4 vertex   : SV_POSITION;
            };

            sampler2D   _MainTex;
            float4      _MainTex_ST;
            sampler2D   _BurnTex;
            
            sampler2D   _NoiseMap;
            sampler2D   _NoiseMap2;
            float4      _NoiseMap_ST ;

            float       _Blend;
            float       _Range;
            //float       _BurnRange;
            float       _ClipOffset;
            float4      _RangeColor;
            float4      _SparkColor;
            float4      _FloatVector;
            float       _RangeOffset;
            half        _Angle;
           

            v2f vert (appdata v)
            {
                v2f o;
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);

                //通过采样两次噪音图进行叠加来让噪音更随机一些，让其中一次稍微放大一些防止完全重叠的情况
                o.uv2 = TRANSFORM_TEX(v.uv, _NoiseMap).xyxy * float4(1,1,1.3,1.3) + _FloatVector * _Time.x;

                //顶点里采样贴图需要使用tex2Dlod
                float noise = tex2Dlod(_NoiseMap , float4(o.uv2.zw , 0,0))  ;
                
                _Blend = _Blend * 2 - 1;
                float blendValue = 1-smoothstep(_Blend,_Blend + _Range,  o.uv.x +_Range) ;
                //对燃烧区域的顶点做一点偏移，模拟飘动的效果
                o.vertex = UnityObjectToClipPos(v.vertex + float4(0,0,noise * blendValue * 0.3,0));

                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                half2x2 Rot = half2x2(cos(_Angle),-sin(_Angle) ,sin(_Angle),cos(_Angle));
                half2 Rotuv = i.uv.xy - float2(0.5, 0.5);
	            Rotuv = mul(Rot,Rotuv);
                
                
                float noise = tex2D(_NoiseMap , i.uv2.xy) * (1-tex2D(_NoiseMap , i.uv2.zw)) ;
                float noise2 =1- ( tex2D(_NoiseMap2 , i.uv2.xy) * (tex2D(_NoiseMap2, i.uv2.zw)) );

                //基于uv的x方向计算混合的权重，边缘使用噪音进行扰动
                //_Blend = _Blend * 2 - 0.5;
                float blendValue = smoothstep(_Blend -_Range,_Blend + _Range,  Rotuv.x + noise2 * _Range) ;                
                
                //原始的颜色
                fixed4 col = tex2D(_MainTex, i.uv.xy);
                //燃烧后的颜色
                fixed4 colBrun = tex2D(_BurnTex, Rotuv.xy);
                //燃烧后的小火星，这个算法没什么意义，一个trick，自己根据需要慢慢调吧 
                fixed3 spark = (smoothstep(0.4 ,0, noise2)) * step (blendValue ,0.1) ;
                //燃烧边缘的计算                
                float3 burnRange = blendValue * saturate( 1 - abs(blendValue - _RangeOffset)/_Range);
                colBrun.rgb += spark * _SparkColor + burnRange * _RangeColor ;
                //return colBrun.rgba;

                //溶解
                //clip( i.uv.x + noise2  - ((_Blend - _BurnRange) * 3 - 1)) ;
                clip( Rotuv.x + noise2 - (_Blend - _Range * saturate( 1 - abs(blendValue - _ClipOffset)))) ;
                
                //混合
                col.rgb = lerp(colBrun, col ,  blendValue);
                //col.rgb = blendValue;
                return col;
            }
            ENDCG
        }
    }
}
