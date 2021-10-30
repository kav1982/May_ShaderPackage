Shader "Bioum/Scene/May_PlanShadow"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _ShadowColor("ShadowColor", Color) = (0,0,0,1)
        _ShadowFalloff("ShadowFalloff", Range(0, 1)) = 0
    	_ObjHight("ObjectHeight",Float) =1
        _ShadowY("Shadow-YPos", Range(0, 3)) = 0.15
	    
	    
        
        [Header(LightDir)]		
		_Horizontal("Horizontal-Angle", range(0,360)) = 45
		_Vertical("Vertical-Angle", range(-90, 90)) = 45
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            // make fog work
            #pragma multi_compile_fog

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                UNITY_FOG_COORDS(1)
                float4 vertex : SV_POSITION;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                UNITY_TRANSFER_FOG(o,o.vertex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                // sample the texture
                fixed4 col = tex2D(_MainTex, i.uv);
                // apply fog
                UNITY_APPLY_FOG(i.fogCoord, col);
                return col;
            }
            ENDCG
        }
        
        Pass
            {
                Name "Shadow"

                Stencil
			    {
				Ref 0			
				Comp Equal			
				WriteMask 255		
				ReadMask 255
				//Pass IncrSat
				Pass Invert
				Fail Keep
				ZFail Keep
			    }

                Blend SrcAlpha OneMinusSrcAlpha
                ZWrite Off
                Offset -1, 0

                CGPROGRAM
                #pragma vertex vert
                #pragma fragment frag
                #pragma multi_compile_instancing
                #pragma multi_compile ROOTON_BLENDOFF ROOTON_BLENDON_CROSSFADEROOTON ROOTON_BLENDON_CROSSFADEROOTOFF ROOTOFF_BLENDOFF ROOTOFF_BLENDON_CROSSFADEROOTON ROOTOFF_BLENDON_CROSSFADEROOTOFF

                #include "UnityCG.cginc"
                //#include "Assets/GPUSkinning/Resources/GPUSkinningInclude.cginc"

                struct appdata
                {
                    float4 vertex : POSITION;                    
                    float4 uv2 : TEXCOORD1;
                    float4 uv3 : TEXCOORD2;
                    UNITY_VERTEX_INPUT_INSTANCE_ID
                };

                struct v2f
                {
                    float4 pos : SV_POSITION;
                    fixed4 color : COLOR;
                	UNITY_VERTEX_INPUT_INSTANCE_ID
                };
                
                float _ShadowY;                
                float4 _ShadowColor;
                fixed _ShadowFalloff;		        
                half _Horizontal, _Vertical, _ObjHight;;

            half3 SphereCoordToCartesianCoord(half horizontal, half vertical)
            {
	            half2 radians = half2(horizontal, vertical) * 0.0174532924; //角度转弧度
	            half2 sinResult, cosResult;
	            sincos(radians, sinResult, cosResult);

	            half x = sinResult.y * cosResult.x;
	            half z = sinResult.y * sinResult.x;
	            half y = cosResult.y;

	            return half3(x, y, z);
            }  

            v2f vert(appdata v)
            {
                UNITY_SETUP_INSTANCE_ID(v);
                v2f o;
                //float4 position = skin2(v.vertex, v.uv2, v.uv3);
                float4 position = v.vertex;
		        float3 shadowPos;
                float3 worldPos = mul(unity_ObjectToWorld, position).xyz;
                
                //float3 lightDir = normalize(_WorldSpaceLightPos0.xyz);
                float3 lightDir = SphereCoordToCartesianCoord(_Horizontal, 90 - _Vertical);
                //lightDir.w = _ShadowY;
                //阴影的世界空间坐标（低于地面的部分不做改变）
                shadowPos.y = min(worldPos.y, _ShadowY);
                shadowPos.xz = worldPos.xz - lightDir.xz * max(0, worldPos.y - _ShadowY) / lightDir.y;
                
				float3 modelHeight =float3(unity_ObjectToWorld[0].w,_ObjHight,unity_ObjectToWorld[2].w);
				
				float3 shadowH;
				shadowH.xz =modelHeight.xz -lightDir.xz *max(0,modelHeight.y - _ShadowY)/lightDir.y;
				shadowH.y =shadowPos.y;
                
                //得到中心点世界坐标，然后与地面上的阴影点计算距离衰减
                //unity_ObjectToWorld矩阵前三行的最后一个分量存储的是子对象在父空间下的坐标位置
                float3 center = float3(unity_ObjectToWorld[0].w, _ShadowY, unity_ObjectToWorld[2].w);

                o.pos = UnityWorldToClipPos(shadowPos);
                //float3 posToPlane_2 = (shadowPos - center);

                
                fixed falloff = 1 - saturate(distance(shadowPos, center)/distance(shadowH, center)*  _ShadowFalloff);
                //fixed falloff = (pow((1.0 - clamp(((sqrt(dot(posToPlane_2, posToPlane_2)) * _ShadowFalloff) - _LightDir.x), 0.0, 1.0)), _LightDir.y) * _LightDir.z);

                o.color = _ShadowColor;
                o.color.a *= falloff;

                return o;
            }

            fixed4 frag(v2f i) : SV_Target
            {
                return i.color;
            }
            ENDCG
        }
        
    }
}
