Shader "Custom/ToonShader"
{
    Properties
    {
        _BaseColor ("Base Color", Color) = (1, 1, 1, 1)
        _RampTex ("Ramp Texture", 2D) = "white" {}
        _MainTex("MainTextue",2D) = "white" {}
        
    }
    SubShader
    {
        Tags
        {
            "RenderPipeline" = "UniversalRenderPipeline" "RenderType" = "Opaque"
        }
        Pass
        {
            HLSLPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"

            // Vertex input structure
            struct Attributes
            {
                float4 positionOS : POSITION;
                float3 normalOS : NORMAL;
                float2 uv :TEXCOORD0;
            };

            
            // Variables passed from vertex to fragment shader
            struct Varyings
            {
                float4 positionHCS : SV_POSITION; // Homogeneous clip-space position
                float3 normalWS : TEXCOORD0;
                //Use a spearate set of TexCoord to place uvs 
                float2 uv :TEXCOORD1;

            };

        
            // World space normal
            // Declare the base texture and sampler
            TEXTURE2D(_MainTex);
            TEXTURE2D(_RampTex);
            SAMPLER(sampler_RampTex);
            SAMPLER(sampler_MainTex);

            CBUFFER_START(UnityPerMaterial)
                float4 _BaseColor;
            CBUFFER_END

            // Vertex Shader
            Varyings vert(Attributes IN)
            {
                Varyings OUT;
                // Transform object space position to homogeneous clip space
                OUT.positionHCS = TransformObjectToHClip(IN.positionOS.xyz);
                // Transform the object space normal to world space
                OUT.normalWS = normalize(TransformObjectToWorldNormal(IN.normalOS));
                //Add Uv sampling for textures 
                OUT.uv = IN.uv;
                return OUT;
            }

      
            // Fragment Shader
            half4 frag(Varyings IN) : SV_Target
            {
                // Fetch main light direction and color
                Light mainLight = GetMainLight();
                half3 lightDirWS = normalize(mainLight.direction);
                half3 lightColor = mainLight.color;
                // Calculate Lambertian diffuse lighting (NdotL)
                half NdotL = saturate(dot(IN.normalWS, lightDirWS));
                // Sample the ramp texture using NdotL to get the correct shade
                half rampValue = SAMPLE_TEXTURE2D(_RampTex, sampler_RampTex, float2(NdotL, 0)).r;
                // Multiply the base color by the ramp value and light color
                half mainTexColor = SAMPLE_TEXTURE2D(_MainTex,sampler_MainTex,IN.uv);
                half3 finalColor = _BaseColor.rgb * lightColor * rampValue * mainTexColor;
                // Return the final color with alpha
                return half4(finalColor, _BaseColor.a);
            }
            ENDHLSL
        }
    }
}