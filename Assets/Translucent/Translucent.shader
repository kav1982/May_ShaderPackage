// Upgrade NOTE: upgraded instancing buffer 'Props' to new syntax.

Shader "Move/Translucent" 
{
	Properties 
    {
		_Color ("Color", Color) = (1,1,1,1)
		_MainTex ("Albedo (RGB)", 2D) = "white" {}
		_Glossiness ("Smoothness", Range(0,1)) = 0.5
		_Metallic ("Metallic", Range(0,1)) = 0.0
        _Distortion ("Distortion",Range(0,1)) = 0.0
        _Power ("Power",Range(0,5)) = 1
        _Scale ("Scale",Range(0,1)) = 1
        _ThicknessTex("Thickness Tex",2D) = "white"{}
        _Attenuation ("Attenuation",Range(0,1)) = 1
        _Ambient ("Ambient",Color) = (1,1,1,1)

	}
	SubShader 
    {
		Tags { "RenderType"="Opaque" }
		LOD 200
		
		CGPROGRAM
		// Physically based Standard lighting model, and enable shadows on all light types
		#pragma surface surf StandardTranslucent fullforwardshadows

		// Use shader model 3.0 target, to get nicer looking lighting
		#pragma target 3.0

		sampler2D _MainTex;

		struct Input 
        {
			float2 uv_MainTex;
		};

		half _Glossiness;
		half _Metallic;
		fixed4 _Color;

        half _Distortion,_Power,_Scale;

        sampler2D _ThicknessTex;
        float thickness;

        float _Attenuation;
        float4 _Ambient;

		// Add instancing support for this shader. You need to check 'Enable Instancing' on materials that use the shader.
		// See https://docs.unity3d.com/Manual/GPUInstancing.html for more information about instancing.
		// #pragma instancing_options assumeuniformscaling
		UNITY_INSTANCING_BUFFER_START(Props)
			// put more per-instance properties here
		UNITY_INSTANCING_BUFFER_END(Props)

        #include "UnityPBSLighting.cginc"
        inline fixed4 LightingStandardTranslucent(SurfaceOutputStandard s,fixed3 viewDir,UnityGI gi)
        {
            fixed4 light = LightingStandard(s,viewDir,gi);

            float3 I_Back = 0.0f.xxx;
            float3 L = gi.light.dir;
            float3 V = viewDir;
            float3 N = s.Normal;

            float3 H_LN = normalize(L + N * _Distortion);
            float VdotH_LN = saturate(dot(V,-H_LN));

            I_Back = pow(VdotH_LN,_Power) * _Scale;

            I_Back = _Attenuation * (I_Back + _Ambient) * thickness;

            light.rgb += gi.light.color * I_Back;

            return light;
        }

        void LightingStandardTranslucent_GI(SurfaceOutputStandard s,UnityGIInput data,inout UnityGI gi)
        {
            LightingStandard_GI(s,data,gi);
        }

		void surf (Input IN, inout SurfaceOutputStandard o) {
			// Albedo comes from a texture tinted by color
			fixed4 c = tex2D (_MainTex, IN.uv_MainTex) * _Color;
			o.Albedo = c.rgb;
			// Metallic and smoothness come from slider variables
			o.Metallic = _Metallic;
			o.Smoothness = _Glossiness;
			o.Alpha = c.a;
            thickness = tex2D(_ThicknessTex,IN.uv_MainTex).r;
		}
		ENDCG
	}
	FallBack "Diffuse"
}

