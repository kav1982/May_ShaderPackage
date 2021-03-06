// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

/*
@喵喵Mya
2017-5-12 23:50:49
仿照暗黑3天使之翼效果的shader，重点在模型和uv，请务必让美术认真看明白范例里的模型

*/

Shader"Mya/Fx/mya_wing_uv"
{
	Properties
	{
		_Color ("Main Color", Color) = (1,1,1,1)
		_Tex1 ("Texture1 (RGB)", 2D) = "white" {}
		_Tex2 ("Texture2 (RGB)", 2D) = "white" {}
		_AlphaMask ("AlphaMask(RGB)", 2D) = "white" {}
		_FlowVector("Flow Vector" , Vector) = (0,0,0,0)
	}
	SubShader
	{
		Tags {"Queue"="Transparent" "RenderType" = "Transparent"}

		Pass
		{
			Tags {"LightMode"="ForwardBase" }

			ZWrite Off

			Cull Off
			Blend OneMinusDstColor  One


			CGPROGRAM

			#pragma vertex vert
			#pragma fragment frag
			#pragma multi_compile_fog
			
			#include "UnityCG.cginc"

            

			sampler2D _Tex1 ,_Tex2;
			half4 _Tex1_ST ,_Tex2_ST;

			sampler2D _AlphaMask;
			half4 _AlphaMask_ST;

			fixed4 _Color;
			half4 _FlowVector;

		
			struct a2v
			{
				float4 vertex : POSITION;
				float4 texcoord : TEXCOORD0;
			};
			
			struct v2f
			{
				float4 pos : SV_POSITION;
				float4 uv : TEXCOORD0;
				float2 uv_mask : TEXCOORD1;
			};
						 
			
			v2f vert(a2v v)
			{
				v2f o;
				o.pos = UnityObjectToClipPos(v.vertex);
			
				o.uv.xy = TRANSFORM_TEX(v.texcoord, _Tex1) + _FlowVector.xy * _Time.y;
				o.uv.zw = TRANSFORM_TEX(v.texcoord, _Tex2) + _FlowVector.zw * _Time.y;
				o.uv_mask = TRANSFORM_TEX(v.texcoord, _AlphaMask);
				return o;
			
			}
			
			fixed4 frag(v2f i) : SV_Target
			{

				fixed4 col = tex2D(_Tex1, i.uv.xy) * _Color ;
				fixed tex2a = tex2D(_Tex2, i.uv.zw).a;
				fixed alphaMask = tex2D(_AlphaMask, i.uv_mask).a;

				col.a = (col.a + tex2a) * alphaMask;
				col.rgb *=  col.rgb *col.a *2;//暴雪技术分享的一个特效算法，看起来效果的确不错

				
				//return alphaMask;
				return col;
			
			}
			ENDCG
		}
	}
}
