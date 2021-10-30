// Shader created with Shader Forge v1.38 
// Shader Forge (c) Freya Holmer - http://www.acegikmo.com/shaderforge/
// Note: Manually altering this data may prevent you from opening it in Shader Forge
/*SF_DATA;ver:1.38;sub:START;pass:START;ps:flbk:,iptp:0,cusa:False,bamd:0,cgin:,lico:1,lgpr:1,limd:0,spmd:1,trmd:0,grmd:0,uamb:True,mssp:True,bkdf:False,hqlp:False,rprd:False,enco:False,rmgx:True,imps:True,rpth:0,vtps:0,hqsc:True,nrmq:1,nrsp:0,vomd:0,spxs:False,tesm:0,olmd:1,culm:2,bsrc:0,bdst:1,dpts:2,wrdp:True,dith:0,atcv:True,rfrpo:True,rfrpn:Refraction,coma:15,ufog:True,aust:True,igpj:False,qofs:0,qpre:2,rntp:3,fgom:False,fgoc:False,fgod:False,fgor:False,fgmd:0,fgcr:0.5,fgcg:0.5,fgcb:0.5,fgca:1,fgde:0.01,fgrn:0,fgrf:300,stcl:False,atwp:False,stva:128,stmr:255,stmw:255,stcp:6,stps:0,stfa:0,stfz:0,ofsf:0,ofsu:0,f2p0:False,fnsp:False,fnfb:False,fsmp:False;n:type:ShaderForge.SFN_Final,id:9361,x:33589,y:32393,varname:node_9361,prsc:2|custl-8434-OUT,clip-2024-OUT;n:type:ShaderForge.SFN_Tex2d,id:2814,x:32853,y:32752,varname:ATex2D,prsc:2,ntxv:0,isnm:False|UVIN-3252-UVOUT,TEX-2924-TEX;n:type:ShaderForge.SFN_Panner,id:3252,x:32371,y:32750,varname:UVPanner,prsc:2,spu:0,spv:-1|UVIN-9040-UVOUT;n:type:ShaderForge.SFN_TexCoord,id:9040,x:32142,y:32750,varname:node_9040,prsc:2,uv:0,uaff:False;n:type:ShaderForge.SFN_Color,id:5181,x:32853,y:32551,ptovrint:False,ptlb:TEX_Color,ptin:_TEX_Color,varname:_TEX_Color,prsc:2,glob:False,taghide:False,taghdr:True,tagprd:False,tagnsco:False,tagnrm:False,c1:0.5,c2:0.5,c3:0.5,c4:1;n:type:ShaderForge.SFN_Multiply,id:1244,x:33126,y:32632,varname:node_1244,prsc:2|A-5181-RGB,B-2814-RGB;n:type:ShaderForge.SFN_Tex2d,id:1110,x:32852,y:33045,varname:UVTex,prsc:2,ntxv:0,isnm:False|UVIN-3252-UVOUT,TEX-2924-TEX;n:type:ShaderForge.SFN_Vector1,id:6764,x:32852,y:32931,varname:Value,prsc:2,v1:0.5;n:type:ShaderForge.SFN_Step,id:3409,x:33197,y:32933,varname:node_3409,prsc:2|A-6764-OUT,B-1599-OUT;n:type:ShaderForge.SFN_Multiply,id:1599,x:32792,y:33280,varname:DisMul,prsc:2|A-1110-R,B-3480-OUT;n:type:ShaderForge.SFN_Subtract,id:1081,x:33197,y:33272,varname:node_1081,prsc:2|A-6764-OUT,B-853-OUT;n:type:ShaderForge.SFN_Vector1,id:853,x:33197,y:33453,varname:node_853,prsc:2,v1:0.1;n:type:ShaderForge.SFN_Subtract,id:1139,x:33457,y:33080,varname:node_1139,prsc:2|A-2024-OUT,B-3409-OUT;n:type:ShaderForge.SFN_Step,id:2024,x:33197,y:33082,varname:StepNod,prsc:2|A-1081-OUT,B-1599-OUT;n:type:ShaderForge.SFN_Color,id:7848,x:33457,y:33244,ptovrint:False,ptlb:Miaobian_Color,ptin:_Miaobian_Color,varname:_Miaobian_Color,prsc:2,glob:False,taghide:False,taghdr:True,tagprd:False,tagnsco:False,tagnrm:False,c1:0.5,c2:0.5,c3:0.5,c4:1;n:type:ShaderForge.SFN_Multiply,id:8323,x:33686,y:33080,varname:node_8323,prsc:2|A-1139-OUT,B-7848-RGB;n:type:ShaderForge.SFN_Add,id:8434,x:33352,y:32632,varname:node_8434,prsc:2|A-1244-OUT,B-8323-OUT;n:type:ShaderForge.SFN_Vector2,id:4663,x:32413,y:33462,varname:node_4663,prsc:2,v1:0.5,v2:0.1;n:type:ShaderForge.SFN_Distance,id:8058,x:32379,y:33301,varname:node_8058,prsc:2|A-9040-UVOUT,B-4663-OUT;n:type:ShaderForge.SFN_OneMinus,id:3480,x:32582,y:33301,varname:node_3480,prsc:2|IN-8058-OUT;n:type:ShaderForge.SFN_Tex2dAsset,id:2924,x:32379,y:33082,ptovrint:False,ptlb:Textures,ptin:_Textures,varname:_Textures,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,ntxv:0,isnm:False;proporder:5181-7848-2924;pass:END;sub:END;*/

Shader "Shader Forge/BY747_Fire_rongjie" {
    Properties {
        [HDR]_TEX_Color ("TEX_Color", Color) = (0.5,0.5,0.5,1)
        [HDR]_Miaobian_Color ("Miaobian_Color", Color) = (0.5,0.5,0.5,1)
        _Textures ("Textures", 2D) = "white" {}
        [HideInInspector]_Cutoff ("Alpha cutoff", Range(0,1)) = 0.5
    }
    SubShader {
        Tags {
            "Queue"="AlphaTest"
            "RenderType"="TransparentCutout"
        }
        Pass {
            Name "FORWARD"
            Tags {
                "LightMode"="ForwardBase"
            }
            Cull Off
            
            
            AlphaToMask On
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #define UNITY_PASS_FORWARDBASE
            #include "UnityCG.cginc"
            #pragma multi_compile_fwdbase_fullshadows
            #pragma multi_compile_fog
            #pragma only_renderers d3d9 d3d11 glcore gles 
            #pragma target 3.0
            uniform float4 _TEX_Color;
            uniform float4 _Miaobian_Color;
            uniform sampler2D _Textures; uniform float4 _Textures_ST;
            struct VertexInput {
                float4 vertex : POSITION;
                float2 texcoord0 : TEXCOORD0;
            };
            struct VertexOutput {
                float4 pos : SV_POSITION;
                float2 uv0 : TEXCOORD0;
                UNITY_FOG_COORDS(1)
            };
            VertexOutput vert (VertexInput v) {
                VertexOutput o = (VertexOutput)0;
                o.uv0 = v.texcoord0;
                o.pos = UnityObjectToClipPos( v.vertex );
                UNITY_TRANSFER_FOG(o,o.pos);
                return o;
            }
            float4 frag(VertexOutput i, float facing : VFACE) : COLOR {
                float isFrontFace = ( facing >= 0 ? 1 : 0 );
                float faceSign = ( facing >= 0 ? 1 : -1 );
                float Value = 0.5;
                float4 node_7275 = _Time;
                float2 UVPanner = (i.uv0+node_7275.g*float2(0,-1));
                float4 UVTex = tex2D(_Textures,TRANSFORM_TEX(UVPanner, _Textures));
                float DisMul = (UVTex.r*(1.0 - distance(i.uv0,float2(0.5,0.1))));
                float StepNod = step((Value-0.1),DisMul);
                clip(StepNod - 0.5);
////// Lighting:
                float4 ATex2D = tex2D(_Textures,TRANSFORM_TEX(UVPanner, _Textures));
                float3 finalColor = ((_TEX_Color.rgb*ATex2D.rgb)+((StepNod-step(Value,DisMul))*_Miaobian_Color.rgb));
                fixed4 finalRGBA = fixed4(finalColor,(StepNod) * 2.0 - 1.0);
                UNITY_APPLY_FOG(i.fogCoord, finalRGBA);
                return finalRGBA;
            }
            ENDCG
        }
        Pass {
            Name "ShadowCaster"
            Tags {
                "LightMode"="ShadowCaster"
            }
            Offset 1, 1
            Cull Off
            
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #define UNITY_PASS_SHADOWCASTER
            #include "UnityCG.cginc"
            #include "Lighting.cginc"
            #pragma fragmentoption ARB_precision_hint_fastest
            #pragma multi_compile_shadowcaster
            #pragma multi_compile_fog
            #pragma only_renderers d3d9 d3d11 glcore gles 
            #pragma target 3.0
            uniform sampler2D _Textures; uniform float4 _Textures_ST;
            struct VertexInput {
                float4 vertex : POSITION;
                float2 texcoord0 : TEXCOORD0;
            };
            struct VertexOutput {
                V2F_SHADOW_CASTER;
                float2 uv0 : TEXCOORD1;
            };
            VertexOutput vert (VertexInput v) {
                VertexOutput o = (VertexOutput)0;
                o.uv0 = v.texcoord0;
                o.pos = UnityObjectToClipPos( v.vertex );
                TRANSFER_SHADOW_CASTER(o)
                return o;
            }
            float4 frag(VertexOutput i, float facing : VFACE) : COLOR {
                float isFrontFace = ( facing >= 0 ? 1 : 0 );
                float faceSign = ( facing >= 0 ? 1 : -1 );
                float Value = 0.5;
                float4 node_1922 = _Time;
                float2 UVPanner = (i.uv0+node_1922.g*float2(0,-1));
                float4 UVTex = tex2D(_Textures,TRANSFORM_TEX(UVPanner, _Textures));
                float DisMul = (UVTex.r*(1.0 - distance(i.uv0,float2(0.5,0.1))));
                float StepNod = step((Value-0.1),DisMul);
                clip(StepNod - 0.5);
                SHADOW_CASTER_FRAGMENT(i)
            }
            ENDCG
        }
    }
    FallBack "Diffuse"
    CustomEditor "ShaderForgeMaterialInspector"
}
