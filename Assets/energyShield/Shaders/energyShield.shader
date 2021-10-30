// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'
// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Mya/energyShield"
{
    Properties 
	{
        _Color ("Color", Color) = (1,1,1,1)
		_MainTex("Main Tex", 2D) = "white" {}
		_MaskTex("Mask Tex", 2D) = "white" {}
		_EdgeColor ("Edge Color", Color) = (1,1,1,1)
		_EdgeRange("Edge Range" , Range(0,8)) = 1
    }
    SubShader 
	{
        Tags 
		{
            "IgnoreProjector"="True"
            "Queue"="Transparent"
            "RenderType"="Transparent"
        }
        Pass {
            Name "ForwardBase"
            Tags {
                "LightMode"="ForwardBase"
            }

            //Blend SrcAlpha OneMinusSrcAlpha
			//Blend OneMinusDstColor  One
			Blend One One
            ZWrite Off
			Cull Off
            
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #define UNITY_PASS_FORWARDBASE
            #pragma multi_compile_fwdbase

            #pragma target 3.0
			
			#include "UnityCG.cginc"

            float4 _Color , _EdgeColor;
			sampler2D _MainTex , _MaskTex;
			float4 _MainTex_ST;
			sampler2D_float _CameraDepthTexture;

			float _EdgeRange;

            struct a2v {
                float4 vertex : POSITION;
				float3 normal : NORMAL;
				float2 texcoord0 :TEXCOORD0;
            };
            struct v2f {
                float4 pos : SV_POSITION;
				half4 screenPos:TEXCOORD0;
				half3 worldNormal:TEXCOORD1;
				half3 worldViewDir:TEXCOORD2;
				float2 uv :TEXCOORD3;
            };
            v2f vert (a2v v) {
                v2f o = (v2f)0;
				o.worldNormal = UnityObjectToWorldNormal(v.normal);  
				float3 worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;  
				o.worldViewDir = normalize(UnityWorldSpaceViewDir(worldPos));

				o.uv = TRANSFORM_TEX(v.texcoord0 , _MainTex) + float2(0 , _Time.y*0.2);

                o.pos = UnityObjectToClipPos(v.vertex);
				o.screenPos = ComputeScreenPos(o.pos);
				COMPUTE_EYEDEPTH(o.screenPos.z);
                return o;
            }
            fixed4 frag(v2f i) : SV_Target {

				//这这一段随便写的，根据自己情况改一下吧
				fixed mask = tex2D(_MaskTex , i.uv + float2(0 , _Time.y)).a;
				fixed wave = 1-tex2D(_MainTex , i.uv).a ;
				fixed4 col = lerp (_Color , _EdgeColor , wave * mask);

				//通过对比深度计算与其他物体相交的边缘
				half depth = LinearEyeDepth(SAMPLE_DEPTH_TEXTURE_PROJ(_CameraDepthTexture, UNITY_PROJ_COORD(i.screenPos)));  
				depth = 1-saturate((depth-i.screenPos.z)*_EdgeRange*4);   

				//通过法线和观察方向计算边缘光
				half rim = pow(1 - abs(dot(normalize(i.worldNormal),normalize(i.worldViewDir))) , _EdgeRange);

				col = lerp(col, _EdgeColor  ,depth + rim) ;


                return col; 
            }
            ENDCG
        }
    }
    FallBack "Diffuse"
}
